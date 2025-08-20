//
//  ViewTimeSlipsViewController.swift
//  EWA
//
//  Created by NFC Solutions on 01/11/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import ANLoader
import CropViewController
import FSCalendar


class ViewTimeSlipsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate {
    var object: JSON = JSON.null
    var picUploadData:JSON = JSON.null
    var selectedIndex = Int()
    var timeId = String()
    var Apistatus = String()
    var theme: SambagTheme = .light
    var activeTextField: UITextField?
    var formDate = String()
    var toDate = String()
    
    @IBOutlet var toDateTextField: UITextField!
    @IBOutlet var fromDateTextField: UITextField!
    @IBOutlet var segmentControl: BetterSegmentedControl!
    @IBOutlet var timeSlipsTableView: UITableView!
    
    @IBOutlet var infoView: UIView!
    var blurEffect = UIBlurEffect()
    var blurEffectView = UIVisualEffectView()
    var pendingTimeSlips = [TimeSlip]()
    var approvedTimeSlips = [TimeSlip]()
    @IBOutlet var infoButton: UIButton!
    
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    @IBOutlet weak var noTimeSlipsLabel: PaddingLabel!
    
    @IBOutlet weak var calenderView: UIView!
    @IBOutlet weak var calender: FSCalendar!
    @IBOutlet weak var calenderHeight: NSLayoutConstraint!
    @IBOutlet weak var calenderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewHeightConstrain: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        self.updateNavigationBarColor()
        //getting Today's Date
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = "MM/dd/yyyy"
        
        
        // showing dates in the textField,s default dates
        let weekEnd = Calendar.current.date(byAdding: .day, value: 1, to: date.endOfWeek(weekday: 1))
        print(weekEnd!)
        
        let result = formatter.string(from: weekEnd!)
        print(result)
        let thMonth = Calendar.current.date(byAdding: .month, value:-1, to: weekEnd!)
        let thirdMonth = formatter.string(from: thMonth!)
        
        fromDateTextField.text = thirdMonth
        toDateTextField.text = result
        formDate = thirdMonth
        toDate = result
        
        
        // getting the TimeSlips
        
        if ConnectionCheck.isConnectedToNetwork()
        {
            //ANLoader.showLoading("", disableUI:false)
            ServerService.showActivityIndicatory(uiView:self.view)
            let params = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String]
            ServerService.viewTimeSlip(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponse(response:))
            
        }
        else
        {
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
            ANLoader.hide()
        })
        
        segmentControl.indicatorViewBackgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        
        infoView.frame = CGRect(x:10,y:self.view.bounds.height/2-80, width: self.view.bounds.width-20, height:160)
        infoButton.isHidden = true
        selectedIndex = 0
        //calender Initialization
        self.calender.delegate = self
        self.calender.scope = .month
        // For UITest
        self.calender.accessibilityIdentifier = "calendar"
        self.calender.appearance.weekdayTextColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        self.calender.appearance.headerTitleColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        self.calender.appearance.selectionColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        self.calender.appearance.todayColor =  UIColor(hexString:"#c4c0cb")
        
        
        // hiding calenderView initially
        calenderHeight.constant = 250
        calenderViewHeight.constant = 0
        calenderView.isHidden = true
        viewHeightConstrain.constant = 170
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font:UIFont.systemFont(ofSize:17)]
        //        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        print(String(describing: ViewTimeSlipsViewController.self))
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
    }
    
    
    //aftergettingResponseFrom the server
    func getresponse(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        //ANLoader.hide()
        object = response as! JSON
        print(object)
        pendingTimeSlips.removeAll()
        approvedTimeSlips.removeAll()
        if object.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if object["Status"] == "Success"
        {
            if object["PendingTimeList"].arrayValue.count>0
            {
                for t in 0..<object["PendingTimeList"].arrayValue.count
                {
                    var date = String()
                    if object["PendingTimeList"][t]["WeekEnding"].stringValue.count>10
                    {
                        date = self.getFormattedDateCosmatic(string:object["PendingTimeList"][t]["WeekEnding"].stringValue.substring(to: 10))
                    }
                    else
                    {
                        date = ""
                    }
                    
                    let timeslip = TimeSlip.init(clientName: object["PendingTimeList"][t]["Company"].stringValue, date: "Week Ending "+" "+date, time: object["PendingTimeList"][t]["HoursDiff"].stringValue+"hr(s)", timeId: object["PendingTimeList"][t]["TimeId"].stringValue, apistatus: object["PendingTimeList"][t]["ApiStatus"].stringValue)
                    pendingTimeSlips.append(timeslip)
                }
                //timeSlipsTableView.backgroundColor = UIColor.init(hexString:"#E8ECEE")
            }
            if object["ApprovalTimeList"].arrayValue.count>0
            {
                
                for at in 0..<object["ApprovalTimeList"].arrayValue.count
                {
                    var date = String()
                    if object["ApprovalTimeList"][at]["WeekEnding"].stringValue.count>10
                    {
                        date = self.getFormattedDateCosmatic(string:object["ApprovalTimeList"][at]["WeekEnding"].stringValue.substring(to: 10))
                    }
                    else
                    {
                        date = ""
                    }
                    
                    let timeslip = TimeSlip.init(clientName: object["ApprovalTimeList"][at]["Company"].stringValue, date: "Week Ending "+" "+date,time: object["ApprovalTimeList"][at]["HoursDiff"].stringValue+"hr(s)", timeId: object["ApprovalTimeList"][at]["TimeId"].stringValue, apistatus: object["ApprovalTimeList"][at]["ApiStatus"].stringValue)
                    approvedTimeSlips.append(timeslip)
                }
                //timeSlipsTableView.backgroundColor = UIColor.init(hexString:"#E8ECEE")
            }
            
            if selectedIndex == 1
            {
                if approvedTimeSlips.count>0
                {
                    timeSlipsTableView.backgroundColor = UIColor.init(hexString:"#E8ECEE")
                }
                else
                {
                    timeSlipsTableView.backgroundColor = .clear
                }
            }
            else
            {
                if pendingTimeSlips.count>0
                {
                    timeSlipsTableView.backgroundColor = UIColor.init(hexString:"#E8ECEE")
                }
                else
                {
                    timeSlipsTableView.backgroundColor = .clear
                }
            }
        }
        else
        {
            timeSlipsTableView.backgroundColor = .clear
        }
        timeSlipsTableView.reloadData()
        
    }
    
    @IBAction func segmentAction(_ sender: Any)
    {
        
        self.timeSlipsTableView.isUserInteractionEnabled = false
        if  segmentControl.index==0
        {
            selectedIndex = 0
            if pendingTimeSlips.count>0
            {
                timeSlipsTableView.backgroundColor = UIColor.init(hexString:"#E8ECEE")
            }
            else
            {
                timeSlipsTableView.backgroundColor = .clear
            }
            DispatchQueue.main.async {
                self.timeSlipsTableView.reloadData()
                self.timeSlipsTableView.contentOffset = .zero
                self.timeSlipsTableView.isUserInteractionEnabled = true
            }
            
            
        }
        else if segmentControl.index == 1
        {
            selectedIndex = 1
            if approvedTimeSlips.count>0
            {
                timeSlipsTableView.backgroundColor = UIColor.init(hexString:"#E8ECEE")
            }
            else
            {
                timeSlipsTableView.backgroundColor = .clear
            }
            DispatchQueue.main.async {
                self.timeSlipsTableView.reloadData()
                self.timeSlipsTableView.contentOffset = .zero
                self.timeSlipsTableView.isUserInteractionEnabled = true
            }
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedIndex == 0
        {
            if section == 0
            {
                return pendingTimeSlips.count
            }
            else
            {
                return 0
            }
            
        }
        else
        {
            if section == 0
            {
                return 0
            }
            else
            {
                return approvedTimeSlips.count
            }
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vtCell") as! ViewTimeSlipsTableViewCell
        if selectedIndex == 0
        {
            cell.titleLabel.text = pendingTimeSlips[indexPath.row].clientName!
            cell.timeLabel.text = pendingTimeSlips[indexPath.row].time!
            cell.clientName.text = pendingTimeSlips[indexPath.row].date!
            let heightOfRow = Constants.calculateHeight(inString:pendingTimeSlips[indexPath.row].clientName!,width:self.view.bounds.size.width-20)
            cell.titleConstrain.constant = heightOfRow+10
        }
        else
        {
            
            cell.titleLabel.text = approvedTimeSlips[indexPath.row].clientName!
            cell.timeLabel.text = approvedTimeSlips[indexPath.row].time!
            cell.clientName.text = approvedTimeSlips[indexPath.row].date!
            let heightOfRow = Constants.calculateHeight(inString:approvedTimeSlips[indexPath.row].clientName!,width:self.view.bounds.size.width-20)
            cell.titleConstrain.constant = heightOfRow+10
        }
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if selectedIndex == 0
        {
            let heightOfRow = Constants.calculateHeight(inString:pendingTimeSlips[indexPath.row].clientName!,width:self.view.bounds.size.width-20)
            return (heightOfRow+80)
        }
        else
        {
            let heightOfRow = Constants.calculateHeight(inString:approvedTimeSlips[indexPath.row].clientName!
                                                        ,width:self.view.bounds.size.width-20)
            return (heightOfRow+80)
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if selectedIndex == 0
        {
            
            if section == 0
            {
                return 50
            }
            else
            {
                return 0.01
            }
        }
        else
        {
            if section == 1
            {
                return 50
            }
            else
            {
                return 0.01
            }
        }
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 50)
        footerView.backgroundColor = UIColor(hexString:"#337ab7")
        let totalHoursLabel = UILabel()
        totalHoursLabel.frame = CGRect(x:10, y: 5, width:self.view.bounds.size.width-20, height: 40)
        totalHoursLabel.textAlignment = .right
        totalHoursLabel.textColor = .white
        footerView.addSubview(totalHoursLabel)
        
        if selectedIndex == 0
        {
            if section == 0
            {if pendingTimeSlips.count>0
                {
                totalHoursLabel.text = "Total Pending Hours "+object["PendingHourTotal"].stringValue
                return footerView
            }
                else
                {
                    totalHoursLabel.text = "Total Pending Hours 0.00"
                    return footerView
                }
            }
            else
            {
                return nil
            }
        }
        else
        {
            if section == 1
            {
                if approvedTimeSlips.count>0
                {
                    totalHoursLabel.text = "Total Approved Hours "+object["ApprovedHourTotal"].stringValue
                    return footerView
                }
                else
                {
                    totalHoursLabel.text = "Total Approved Hours 0.00"
                    return footerView
                }
            }
            else
            {
                return nil
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedIndex == 0
        {
            timeId = pendingTimeSlips[indexPath.row].timeId!
            Apistatus = pendingTimeSlips[indexPath.row].apistatus!
        }
        else
        {
            timeId = approvedTimeSlips[indexPath.row].timeId!
            Apistatus = approvedTimeSlips[indexPath.row].apistatus!
        }
        self.performSegue(withIdentifier: "deatilSegue", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "deatilSegue"
        {
            let dvc = segue.destination as! TimeSlipReportViewController
            dvc.timeId = timeId
            dvc.ApiStatus = Apistatus
            
        }
    }
    
    @IBAction func goAction(_ sender: Any)
    {
        // hiding calender View
        calenderViewHeight.constant = 0
        calenderView.isHidden = true
        viewHeightConstrain.constant = 170
        if ConnectionCheck.isConnectedToNetwork()
        {
            //ANLoader.showLoading("", disableUI:false)
            ServerService.showActivityIndicatory(uiView:self.view)
            let params = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"FromDate":formDate, "ToDate":toDate]
            ServerService.viewTimeSlip(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponse(response:))
        }
        else
        {
            ANLoader.hide()
        }
        
    }
    
    
    //textField delegate methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        activeTextField = textField
        textField.resignFirstResponder()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from:textField.text!)
        self.calender.select(date)
        
        //showing calender View
        calenderViewHeight.constant = 250
        calenderView.isHidden = false
        viewHeightConstrain.constant = 420
        return false
    }
    
    
    //function to get date
    func getFormattedDate(string: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "MMM d, yyyy" // This formate is input formated .
        let formateDate = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "MM/dd/yyyy" // Output Formated
        return dateFormatter.string(from: formateDate)
    }
    
    //function to get date
    func getFormattedDateCosmatic(string: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd" // This formate is input formated .
        let formateDate = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "MM/dd/yyyy" // Output Formated
        return dateFormatter.string(from: formateDate)
    }
    
    @IBAction func handleNavgationBarButtonTap(_ sender: UIBarButtonItem, event: UIEvent)
    
    {
        Constants.showUp(event:event,viewController:self)
        
    }
    
    
    @IBAction func infoAction(_ sender: UIButton)
    {
        blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.contentView.addSubview(infoView)
        view.addSubview(blurEffectView)
    }
    
    @IBAction func okAction(_ sender: UIButton) {
        blurEffectView.removeFromSuperview()
    }
    
    //imagePicker methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = (info[UIImagePickerControllerOriginalImage] as? UIImage) else { return }
        
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.delegate = self
        
        // Uncomment this if you wish to provide extra instructions via a title label
        //cropController.title = "Crop Image"
        
        // -- Uncomment these if you want to test out restoring to a previous crop setting --
        //cropController.angle = 90 // The initial angle in which the image will be rotated
        //cropController.imageCropFrame = CGRect(x: 0, y: 0, width: 2848, height: 4288) //The initial frame that the crop controller will have visible.
        
        // -- Uncomment the following lines of code to test out the aspect ratio features --
        cropController.aspectRatioPreset = .presetSquare; //Set the initial aspect ratio as a square
        cropController.aspectRatioLockEnabled = true // The crop box is locked to the aspect ratio and can't be resized away from it
        cropController.resetAspectRatioEnabled = false // When tapping 'reset', the aspect ratio will NOT be reset back to default
        cropController.aspectRatioPickerButtonHidden = true
        
        // -- Uncomment this line of code to place the toolbar at the top of the view controller --
        //cropController.toolbarPosition = .top
        
        cropController.rotateButtonsHidden = true
        cropController.rotateClockwiseButtonHidden = true
        
        //cropController.doneButtonTitle = "Title"
        //cropController.cancelButtonTitle = "Title"
        
        self.image = image
        
        
        //If profile picture, push onto the same navigation stack
        if croppingStyle == .circular {
            picker.pushViewController(cropController, animated: true)
        }
        else { //otherwise dismiss, and then present from the main controller
            picker.dismiss(animated: true, completion: {
                if #available(iOS 13.0, *) {
                    cropController.modalPresentationStyle = .fullScreen;
                } else {
                    // Fallback on earlier versions
                }
                self.present(cropController, animated: true, completion: nil)
                //self.navigationController!.pushViewController(cropController, animated: true)
            })
        }
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        cropViewController.dismiss(animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            ANLoader.showLoading("", disableUI:true)
            let selectedImage:UIImage = image.resize(withWidth:200)!
            let base64String = selectedImage.toBase64()
            let params = ["CandId":UserDefaults.standard.object(forKey:"cID") as! String,"ImageFile":base64String!] as [String:Any]
            ServerService.AccountInsertProfilePicture(self, params: params, method: "POST", accessToken:Constants.Token,acces:true, callBack:self.getresponseForPic(response:))
        })
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    //aftergettingResponseFrom the server for picture upload
    func getresponseForPic(response:AnyObject)->()
    {
        ANLoader.hide()
        print(response)
        picUploadData = response as! JSON
        if picUploadData.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if picUploadData["MessageStatus"].intValue == 1
        {
            UserDefaults.standard.set(picUploadData["ImageFile"].stringValue, forKey: "ImageFile")
            NotificationCenter.default.post(name: Notification.Name("updateImage"), object: nil)
            ServerService.ShowAlertMessage(ErrorMessage:Constants.imageMessage, title:"", view:self)
            
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage:picUploadData["Message"].stringValue, title:"", view:self)
        }
    }
    
    
}
extension ViewTimeSlipsViewController: SambagDatePickerViewControllerDelegate {
    
    func sambagDatePickerDidSet(_ viewController: SambagDatePickerViewController, result: SambagDatePickerResult)
    {   print(result)
        if activeTextField?.tag == 1
        {
            fromDateTextField.text = self.getFormattedDate(string:String(describing: result))
            formDate = self.getFormattedDate(string:String(describing: result))
            
        }
        else
        {
            toDateTextField.text = self.getFormattedDate(string:String(describing: result))
            toDate = self.getFormattedDate(string:String(describing: result))
        }
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func sambagDatePickerDidCancel(_ viewController: SambagDatePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}





//FSCalender view delegate and dataSource methods in extension
extension ViewTimeSlipsViewController:FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance
{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = "MM/dd/yyyy"
        if self.activeTextField?.tag == 1
        {
            self.fromDateTextField.text = formatter.string(from:date)
            self.formDate = formatter.string(from: date)
        }
        else
        {
            self.toDateTextField.text = formatter.string(from: date)
            self.toDate = formatter.string(from:date)
        }
        calenderViewHeight.constant = 0
        calenderView.isHidden = true
        viewHeightConstrain.constant = 170
    }
    
    
}
