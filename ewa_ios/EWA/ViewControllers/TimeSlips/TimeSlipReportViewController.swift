//
//  TimeSlipReportViewController.swift
//  EWA
//
//  Created by NFC Solutions on 06/11/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import ANLoader
import CropViewController

class TimeSlipReportViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate {
    
    @IBOutlet var totalHoursSize: NSLayoutConstraint!
    var object: JSON = JSON.null
    var picUploadData:JSON = JSON.null
    @IBOutlet var clientName: UILabel!
    @IBOutlet var employeeName: UILabel!
    @IBOutlet var reportedToLabel: UILabel!
    @IBOutlet var enteredData: UILabel!
    @IBOutlet var approvedByLabel: UILabel!
    @IBOutlet var approvedDate: UILabel!
    @IBOutlet var weekendLAbel: UILabel!
    @IBOutlet var totalHoursLabel: UILabel!
    
    @IBOutlet var totalHour: [UILabel]!
    @IBOutlet var dateLabel: [UILabel]!
    
    @IBOutlet var lunchTime: [UILabel]!
    
    @IBOutlet var endTime: [UITextField]!
    
    @IBOutlet var startTime: [UITextField]!
    
    @IBOutlet var heightConstrain: NSLayoutConstraint!
    
    @IBOutlet var weekReportView: UIView!
    
    @IBOutlet var totalHoursView: UIView!
    
    @IBOutlet var weekReportHeight: NSLayoutConstraint!
    
    var timeId = String()
    var ApiStatus = String()
    
    @IBOutlet var timeViews: [UIView]!
    
    @IBOutlet var totalHoursTextLabel: UILabel!
    
    @IBOutlet var dateHeaderLabel: UILabel!
    @IBOutlet var startHeaderLabel: UILabel!
    @IBOutlet var endHeaderLabel: UILabel!
    @IBOutlet var totalHeaderLabel: UILabel!
    @IBOutlet var lunchLabel: UILabel!
    
    @IBOutlet var timePendingView: UIView!
    @IBOutlet var timeSlipPendingTotalLabel: UILabel!
    
    @IBOutlet var timeSlipTotalLabel: PaddingLabel!
    
    
    
    var firstLabel = UILabel()
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
            ANLoader.hide()
        })
        if ConnectionCheck.isConnectedToNetwork()
        {
            //ANLoader.showLoading("", disableUI:false)
            ServerService.showActivityIndicatory(uiView:self.view)
            let params:[String:String] = ["TimeId":timeId,"ApiStatus":ApiStatus]
            ServerService.getTimeSlipReport(self, params: params, method: "POST", accessToken:Constants.Token, acces:true, callBack:getresponse(response:))
        }
        else
        {
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
        
        weekReportView.isHidden = true
        totalHoursView.isHidden = true
        
        for i in 0..<7
        {
            dateLabel[i].backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        }
        dateHeaderLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        startHeaderLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        endHeaderLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        totalHeaderLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        lunchLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        totalHoursLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        totalHoursTextLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        
        timePendingView.isHidden = true
        timeSlipPendingTotalLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        if ApiStatus == "A"
        //        {
        //            self.navigationItem.title = "Approved Time Sheet Report"
        //        }
        //        else
        //        {
        //            self.navigationItem.title = "Pending Time Sheet Report"
        //        }
        print(String(describing: TimeSlipReportViewController.self))
        
        if let navigationBar = self.navigationController?.navigationBar {
            let firstFrame = CGRect(x: 0, y: 0, width: navigationBar.frame.width, height: navigationBar.frame.height)
            firstLabel = UILabel(frame: firstFrame)
            firstLabel.textColor = .white
            firstLabel.font = UIFont.systemFont(ofSize:13, weight:.bold)
            firstLabel.textAlignment = .center
            if ApiStatus == "A"
            {
                firstLabel.text = "Approved Time Sheet Report"
            }
            else
            {
                firstLabel.text = "Pending Time Sheet Report"
            }
            navigationBar.addSubview(firstLabel)
            
        }
        
        
        
        //        if self.view.bounds.height <= 568
        //        {
        //            if ApiStatus == "A"
        //            {
        //                let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 9)]
        //                self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        //            }
        //            else
        //            {
        //                let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 10)]
        //                self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        //            }
        //        }
        //        else
        //        {
        //            let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 13)]
        //            self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        //        }
        
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        firstLabel.removeFromSuperview()
    }
    
    //aftergettingResponseFrom the server
    func getresponse(response:AnyObject)->()
    {
        ANLoader.hide()
        ServerService.hideProgressView()
        object = response as! JSON
        print(object)
        if object.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if object["Status"].stringValue == "Success"
        {
            self.totalHoursLabel.text =  String(format: "%.2f",object["TotalHour"].doubleValue)
            self.clientName.text = object["ClientName"].stringValue
            self.clientName.addBottomBorderWithColor(color:.lightGray, width:0.5)
            self.employeeName.text = object["EmployeeName"].stringValue
            self.employeeName.addBottomBorderWithColor(color:.lightGray, width:0.5)
            self.reportedToLabel.text = object["RepotedTo"].stringValue
            self.reportedToLabel.addBottomBorderWithColor(color:.lightGray, width:0.5)
            if object["EnteredDate"].stringValue.count>0
            {
                if object["EnteredDate"].stringValue.replace(target:"\\", withString:"").substring(to:10) == "01/01/0001"
                {
                    self.enteredData.text = ""
                }
                else
                {
                    self.enteredData.text = object["EnteredDate"].stringValue
                }
            }
            self.enteredData.addBottomBorderWithColor(color:.lightGray, width:0.5)
            if object["WeekEnding"].stringValue.substring(to:10) == "0001-01-01"
            {
                self.weekendLAbel.text = ""
            }
            else
            {
                self.weekendLAbel.text = self.getFormattedDate(string:object["WeekEnding"].stringValue.substring(to:10))
            }
            self.weekendLAbel.addBottomBorderWithColor(color:.lightGray, width:0.5)
            //self.approvedDate.addLeftBorderWithColor(color:.lightGray, width:0.5)
            if object["ApprovedDate"].stringValue.count>10
            {
                self.approvedByLabel.text = object["ApprovedBy"].stringValue
                self.approvedDate.text = object["ApprovedDate"].stringValue
            }
            else
            {
                self.approvedByLabel.text = ""
            }
            
            if ApiStatus == "A"
            {
                
            }
            else
            {
                if object["WeekTimeReport"].arrayValue.count>0
                {
                }
                else
                {
                    timePendingView.isHidden = false
                    timeSlipTotalLabel.text = String(format: "%.2f",object["TotalHour"].doubleValue)
                }
            }
            
            if object["WeekTimeReport"].arrayValue.count>0
            {
                weekReportView.isHidden = false
                totalHoursView.isHidden = false
                
                let weekCount = 7-object["WeekTimeReport"].arrayValue.count
                weekReportHeight.constant -= CGFloat(weekCount*50)
                heightConstrain.constant -= CGFloat(weekCount*50)
                
                for i in 0..<7
                {
                    if i<object["WeekTimeReport"].arrayValue.count {
                        timeViews[i].isHidden = false
                        dateLabel[i].text = object["WeekTimeReport"][i]["Date"].stringValue.substring(with:8..<10)+"  "+object["WeekTimeReport"][i]["Day"].stringValue.uppercased()
                        startTime[i].text = object["WeekTimeReport"][i]["StartTime"].stringValue
                        endTime[i].text = object["WeekTimeReport"][i]["EndTime"].stringValue
                        lunchTime[i].text = String(format: "%.2f",object["WeekTimeReport"][i]["Lunch"].doubleValue)
                        totalHour[i].text = String(format: "%.2f",object["WeekTimeReport"][i]["Hours"].doubleValue)
                    }
                    else
                    {
                        timeViews[i].isHidden = true
                    }
                }
            }
            else
            {
                weekReportView.isHidden = false
                totalHoursView.isHidden = false
                heightConstrain.constant -= 400
                weekReportHeight.constant = 30
                totalHoursTextLabel.isHidden = true
                totalHoursLabel.text = "No Records Found"
                totalHoursLabel.textColor = .black
                totalHoursSize.constant = 0
                totalHoursLabel.textAlignment = .center
                for v in 0..<7
                {
                    timeViews[v].isHidden = true
                }
            }
        }
        else
        {
            
        }
    }
    //function to get date
    func getFormattedDate(string: String) -> String{
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
    //imagePicker
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
    //aftergettingResponseFrom the server
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
