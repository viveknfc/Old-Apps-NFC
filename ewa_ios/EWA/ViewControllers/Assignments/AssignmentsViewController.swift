//
//  AssignmentsViewController.swift
//  EWA
//
//  Created by NFC Solutions on 09/10/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import FSCalendar
import SideMenuController
import ANLoader
import CropViewController


class AssignmentsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate{
    
    var object: JSON = JSON.null
    var picUploadData:JSON = JSON.null
    var cells = [JSON]()
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet var assignmenmtTableView: UITableView!
    var resultDate = String()
    var orderId = String()
    var datesWithMultipleEvents = Array<String>()
    var colors =  Array<[String:[UIColor]]>()
    var colorIndex = 0
    var startTime = String()
    var EndTime = String()
    var divison = String()
    var isAlertshown = Bool()
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    @IBOutlet var infoView: UIView!
    var blurEffect = UIBlurEffect()
    var blurEffectView = UIVisualEffectView()
    var assignmentsObjects = [Assignments]()
    
    @IBOutlet var rightBarButton: UIBarButtonItem!
    
    @IBOutlet weak var noMessageLabel: PaddingLabel!
    
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    let Legend_Tbl_Tag = 1001
    var infoViewColorsArray = NSMutableArray()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //Do any additional setup after loading the view.
        
        self.updateNavigationBarColor()
        
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        if #available(iOS 11.0, *) {
            assignmenmtTableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        //getting Today's Date
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = "MM/dd/yyyy"
        let result = formatter.string(from: date)
        resultDate = result
        print(result)
        
        //
        
        isAlertshown = false
        
        if ConnectionCheck.isConnectedToNetwork()
        {
            //server call
            //ANLoader.showLoading("", disableUI:true)
            ServerService.showActivityIndicatory(uiView:self.view)
            let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"StartDate":result]
            print(params)
            ServerService.getListOfAssignments(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: self.getresponse(response:))
            
        }
        else
        {
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            
        }
        
        //ServerService.showActivityIndicatory(uiView: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
            ANLoader.hide()
        })
        
        
        
        
        
        
        
        self.calendar.delegate = self
        self.calendar.select(Date())
        self.view.addGestureRecognizer(self.scopeGesture)
        self.assignmenmtTableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .month
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        self.calendar.appearance.weekdayTextColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        self.calendar.appearance.headerTitleColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        self.calendar.appearance.selectionColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        self.calendar.appearance.todayColor =  UIColor(hexString:"#c4c0cb")
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func showAlertForUser(){
        isAlertshown = true
        let confromAlert = UIAlertController(title: "Note", message:"", preferredStyle: UIAlertControllerStyle.alert)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        let attributedMessage: NSMutableAttributedString = NSMutableAttributedString(
            /*
             string:"Please reference the calendar below for assignments you’ve accepted this month. To view past assignments you have accepted, please adjust the calendar view to the correct month. If you would like to view your future assignments, adjust the calendar view or click below on one of the dates highlighted in blue. To view the complete description for any position, click on the pink-shaded section of the assignment listing.", // your string message here
             */
            string: object["AssignmentText"].stringValue,
            attributes: [
                NSAttributedStringKey.paragraphStyle: paragraphStyle,
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13.0)
            ]
        )
        confromAlert.setValue(attributedMessage, forKey: "attributedMessage")
        confromAlert.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
        })
        self.present(confromAlert, animated: true)
    }
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int
    {
        
        let eventDate = self.dateFormatter.string(from: date)
        if self.datesWithMultipleEvents.contains(eventDate)
        {
            
            return self.datesWithMultipleEvents.filter{$0 == eventDate}.count
        }
        return 0
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let key = self.dateFormatter.string(from: date)
        for index in 0..<colors.count
        {
            if colors[index].allKeys()[0] == key
            {
                colorIndex = index
            }
        }
        //        if self.datesWithMultipleEvents.contains(key)
        //        {
        print("color index is",colorIndex)
        return colors[colorIndex][key]
        //        }
        //        return nil
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        let key = self.dateFormatter.string(from: date)
        for index in 0..<colors.count
        {
            if colors[index].allKeys()[0] == key
            {
                colorIndex = index
            }
        }
        print("color index is",colorIndex)
        return colors[colorIndex][key]
    }
    
    
    
    //function to get date
    func getFormattedDate(string: String) -> String{
        
        if string.count>10
        {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.preferredLocale()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // This formate is input formated .
            let formateDate = dateFormatter.date(from: string)!
            dateFormatter.dateFormat = "MM/dd/yyyy" // Output Formated
            return dateFormatter.string(from: formateDate)
        }
        else
        {
            return ""
        }
    }
    
    
    
    deinit {
        print("\(#function)")
    }
    
    // MARK:- UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let shouldBegin = self.assignmenmtTableView.contentOffset.y <= -self.assignmenmtTableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                colorIndex = 0
                return velocity.y < 0
            case .week:
                colorIndex = 0
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        
        print("did select date \(self.dateFormatter.string(from: date))")
        cells.removeAll()
        assignmentsObjects.removeAll()
        let result = self.dateFormatter.string(from: date)
        resultDate = self.dateFormatter.string(from: date)
        //        let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"StartDate":result]
        //        ServerService.getListOfAssignments(self, params: params, method:"POST", accessToken:"", acces:false, callBack: getresponse(response:))
        for index in 0..<object["Assignments"].arrayValue.count
        {
            let date = getFormattedDate(string:object["Assignments"][index]["StartDate"].stringValue)
            print(date)
            if result == date
            {
                let assignment = Assignments.init(companyName:object["Assignments"][index]["Subject"].stringValue, address: object["Assignments"][index]["Note"].stringValue, time:"Hours:"+object["Assignments"][index]["StartTime"].stringValue+" to "+object["Assignments"][index]["EndTime"].stringValue, color:object["Assignments"][index]["Color"].stringValue,orderId:object["Assignments"][index]["OrderId"].stringValue,division:object["Assignments"][index]["Division"].stringValue)
                assignmentsObjects.append(assignment)
                cells.append(object["Assignments"][index])
            }
        }
        
        if cells.count>0
        {
            assignmenmtTableView.backgroundColor = .white
        }
        else
        {
            assignmenmtTableView.backgroundColor = .clear
        }
        assignmenmtTableView.reloadData()
        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        colorIndex = 0
        resultDate = self.dateFormatter.string(from: calendar.currentPage)
        self.calendar.select(calendar.currentPage)
        
        if ConnectionCheck.isConnectedToNetwork()
        {
            //server call
            ANLoader.showLoading("", disableUI:true)
            let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"StartDate":self.dateFormatter.string(from: calendar.currentPage)]
            ServerService.getListOfAssignments(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponse(response:))
            print("\(self.dateFormatter.string(from: calendar.currentPage))")
            
        }
        else
        {
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
            ANLoader.hide()
        })
        
    }
    
    //aftergettingResponseFrom the server
    func getresponse(response:AnyObject)->()
    {
        ANLoader.hide()
        ServerService.hideProgressView()
        object = response as! JSON
        print(object)
        cells.removeAll()
        colors.removeAll()
        colorIndex = 0
        assignmentsObjects.removeAll()
        self.datesWithMultipleEvents.removeAll()
        self.colors.removeAll()
        infoViewColorsArray.removeAllObjects()
        if object["ColourText"].arrayValue.count>0 {
            
            let colourTextArray = object["ColourText"].array
            
            for dict in colourTextArray! {
                infoViewColorsArray.add(["Text":dict["Text"].stringValue,"Color":dict["Color"].stringValue])
            }
            
        }
        noMessageLabel.text = "No Assignments Found"
        if object["Assignments"].arrayValue.count==0 // object.isEmpty
        {
            print("empty")
            assignmenmtTableView.backgroundColor = .clear
            //            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else
        {
            for color in 0..<object["Assignments"].arrayValue.count
            {
                var calenderDotColors = [UIColor]()
                var calenderDotColor = UIColor()
                let date = getFormattedDate(string:object["Assignments"][color]["StartDate"].stringValue)
                if color>0
                {
                    if date == getFormattedDate(string:object["Assignments"][color-1]["StartDate"].stringValue)
                    {
                        calenderDotColors = colors[colors.count-1][date]!
                        calenderDotColor = UIColor(hexString:object["Assignments"][color]["Color"].stringValue)
                        calenderDotColors.append(calenderDotColor)
                        colors[colors.count-1][date] = calenderDotColors
                    }
                    else
                    {
                        calenderDotColor = UIColor(hexString:object["Assignments"][color]["Color"].stringValue)
                        calenderDotColors.append(calenderDotColor)
                        
                        colors.append([date:calenderDotColors])
                    }
                }
                else
                {
                    var dotColors = [UIColor]()
                    let dotColor = UIColor(hexString:object["Assignments"][color]["Color"].stringValue)
                    dotColors.append(dotColor)
                    colors.append([date:dotColors])
                }
            }
            
            for index in 0..<object["Assignments"].arrayValue.count
            {
                
                let date = getFormattedDate(string: object["Assignments"][index]["StartDate"].stringValue)
                self.datesWithMultipleEvents.append(date)
                if resultDate == date
                {
                    
                    let assignment = Assignments.init(companyName:object["Assignments"][index]["Subject"].stringValue, address: object["Assignments"][index]["Note"].stringValue, time:"Hours:"+object["Assignments"][index]["StartTime"].stringValue+" to "+object["Assignments"][index]["EndTime"].stringValue, color:object["Assignments"][index]["Color"].stringValue,orderId:object["Assignments"][index]["OrderId"].stringValue,division:object["Assignments"][index]["Division"].stringValue)
                    assignmentsObjects.append(assignment)
                    cells.append(object["Assignments"][index])
                }
            }
            
            if cells.count>0
            {
                assignmenmtTableView.backgroundColor = .white
            }
            else
            {
                assignmenmtTableView.backgroundColor = .clear
            }
        }
        assignmenmtTableView.reloadData()
        self.calendar.reloadData()
        if !isAlertshown {
            showAlertForUser()
        }
        
    }
    
    
    
    @IBAction func ViewMessageAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "messageSegue", sender: nil)
    }
    
    
    @IBAction func infoButton(_ sender: UIButton)
    {
        
        var rectHeight = 0
        
        rectHeight = infoViewColorsArray.count*40
        var alrController = UIAlertController()
        
        alrController = UIAlertController(title: "", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertController.Style.alert)
        let originY = 10
        let width = 255
        let margin:CGFloat = 8.0
        let rect = CGRect(x: Int(margin), y: originY, width: width, height: rectHeight)
        
        let tableView = UITableView(frame: rect)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tag = Legend_Tbl_Tag
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorInset = .zero
        alrController.view.addSubview(tableView)
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alrController.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(rectHeight+60))
        alrController.view.addConstraint(height);
        
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: {(alert: UIAlertAction!) in print("OK")
            alrController.dismiss(animated: true, completion: nil)
        })
        
        alrController.addAction(cancelAction)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alrController.modalPresentationStyle = .popover
            
            if let popoverController = alrController.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
                popoverController.permittedArrowDirections = []
                self.present(alrController, animated: true, completion: nil)
                
            }
        }else{
            self.present(alrController, animated: true, completion: {})
        }
        
    }
    
    @IBAction func okAction(_ sender: UIButton)
    {
        blurEffectView.removeFromSuperview()
    }
    
    
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
                    cropController.modalPresentationStyle = UIModalPresentationStyle.fullScreen;
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
        if picUploadData["MessageStatus"].intValue == 1
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
    
    
    
    //TableView Datasource and Delegate Methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView.tag == Legend_Tbl_Tag {
            return infoViewColorsArray.count
        }
        else{
            return cells.count
        }
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if  tableView.tag == Legend_Tbl_Tag{
            let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell") ?? UITableViewCell(style: .default, reuseIdentifier: "timeCell")
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.numberOfLines = 0
            
            cell.imageView?.image = nil
            if infoViewColorsArray.count>0 {
                let colorDict = infoViewColorsArray[indexPath.row] as! NSDictionary
                let text = colorDict["Text"] as? String
                let bgColor = colorDict["Color"] as? String
                
                cell.backgroundColor = UIColor(hexString:bgColor!)
                cell.textLabel?.textColor = UIColor.black
                cell.textLabel?.textAlignment = .center
                
                
                cell.textLabel?.text = text?.replace(target: "<br/>", withString: "\n")
            }
            
            return cell
            
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "aCell") as! AssignmentsTableViewCell
            cell.selectionStyle = .none
            cell.cView.backgroundColor = UIColor(hexString:assignmentsObjects[indexPath.row].color!)
            //UIColor(hexString:cells[indexPath.row]["Color"].stringValue)
            cell.jobTitle.text = assignmentsObjects[indexPath.row].companyName     //cells[indexPath.row]["Subject"].stringValue
            
            //cell.officeName.text = cells[indexPath.row]["Subject"].stringValue
            let fullName    = assignmentsObjects[indexPath.row].address//cells[indexPath.row]["Note"].stringValue
            if fullName?.count==0
            {
                //cell.timeImageView.isHidden = true
                cell.locationImageView.isHidden = true
            }
            else
            {
                //cell.timeImageView.isHidden = false
                cell.locationImageView.isHidden = false
            }
            let addArr = fullName?.components(separatedBy:"\r\n")
            if addArr!.count>2
            {
                
                
                cell.addressLabel.text = addArr![addArr!.count-2].replace(target:":", withString:" ")
                
                let heightOfAddress  = Constants.calculateHeightWithFont(inString:addArr![addArr!.count-2],width:self.view.bounds.size.width-20,font:UIFont(name:"Avenir Heavy", size: 15.0)!)
                cell.addressHeight.constant = heightOfAddress+20
                //cell.timeLabel.text = addArr.last
            }
            else
            {
                cell.addressLabel.text = ""
                cell.addressHeight.constant = 0
            }
            //cell.timeLabel.text = assignmentsObjects[indexPath.row].time//"Hours:"+cells[indexPath.row]["StartTime"].stringValue+" to "+cells[indexPath.row]["EndTime"].stringValue
            let heightOfTitle = Constants.calculateHeightWithFont(inString:assignmentsObjects[indexPath.row].companyName!,width:self.view.bounds.size.width-20,font:cell.jobTitle.font)
            cell.titleHeight.constant = heightOfTitle
            
            cell.timeLabel.isHidden = true
            cell.timeImageView.isHidden = true
            
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == Legend_Tbl_Tag{
            //            let colorDict = infoViewColorsArray[indexPath.row] as! NSDictionary
            //            let bgColor = colorDict["Color"] as? String
            //            if bgColor?.count == 0{
            //                return 115
            //
            //            }
            //            return 40
            if infoViewColorsArray.count>0 {
                return 40
            }
            else{
                return 0
            }
        }
        else{
            
            let fullName    = assignmentsObjects[indexPath.row].address!
            let addArr = fullName.components(separatedBy:"\r\n")
            if addArr.count>2
            {
                let height = Constants.calculateHeightWithFont(inString:assignmentsObjects[indexPath.row].companyName!,width:self.view.bounds.size.width-20,font:UIFont(name:"Avenir Heavy", size: 15.0)!)
                
                let heightOfRow = Constants.calculateHeightWithFont(inString:addArr[addArr.count-2],width:self.view.bounds.size.width-20,font:UIFont(name:"Avenir Heavy", size: 15.0)!)
                
                //            let heightOfRow = Constants.calculateHeight(inString:assignmentsObjects[indexPath.row].time!+addArr[addArr.count-2],width:self.view.bounds.size.width-50)
                return (heightOfRow+height+60)
            }
            else
            {
                let height = Constants.calculateHeightWithFont(inString:assignmentsObjects[indexPath.row].companyName!,width:self.view.bounds.size.width-20,font:UIFont(name:"Avenir Heavy", size: 15.0)!)
                
                //            let heightOfRow = Constants.calculateHeight(inString:assignmentsObjects[indexPath.row].time!,width:self.view.bounds.size.width-20)
                return (height+50)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == assignmenmtTableView {
            orderId = assignmentsObjects[indexPath.row].orderId!
            startTime = cells[indexPath.row]["StartTime"].stringValue
            EndTime = cells[indexPath.row]["EndTime"].stringValue
            divison = assignmentsObjects[indexPath.row].division!
            self.performSegue(withIdentifier: "detailSegue", sender: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue"
        {
            let dvc = segue.destination as! AssigmentsDetailViewController
            dvc.orderId = orderId
            dvc.dateString = resultDate
            dvc.startTime = startTime
            dvc.EndTime = EndTime
            dvc.Division = divison
        }
    }
    @IBAction func handleNavgationBarButtonTap(_ sender: UIBarButtonItem, event: UIEvent)
    
    {
        Constants.showUp(event:event,viewController:self)
        
    }
    
    
    //catching the device orentation
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            infoView.frame = CGRect(x:10, y:self.view.bounds.height/2-125, width: self.view.bounds.width-20, height:250)
        case .landscapeLeft:
            text="LandscapeLeft"
            infoView.frame = CGRect(x:10, y:self.view.bounds.height/2-125, width: self.view.bounds.width-20, height:250)
        case .landscapeRight:
            text="LandscapeRight"
            infoView.frame = CGRect(x:10, y:self.view.bounds.height/2-125, width: self.view.bounds.width-20, height:250)
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
    }
}

