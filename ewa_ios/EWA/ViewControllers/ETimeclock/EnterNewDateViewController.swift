//
//  EnterNewDateViewController.swift
//  EWA
//
//  Created by NFC India on 26/12/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import FSCalendar
import SwiftyJSON
import CoreLocation
import IQKeyboardManagerSwift
import JVFloatLabeledTextField


class EnterNewDateViewController: BaseViewController {
    
    
    
    @IBOutlet weak var orderIdLabel: UILabel!
    
    let dateFormat = "MM/dd/yyyy"
    var historyData:JSON = JSON.null
    //Object References from storyBoard
    
    var ordersData:JSON = JSON.null
    var WarningType = String()
    @IBOutlet weak var loginStartTextField: UITextField!
    @IBOutlet weak var lunchOutTextField: UITextField!
    @IBOutlet weak var lunchReturnTextField: UITextField!
    @IBOutlet weak var logoutFinishTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet var cView: UIView!
    
    @IBOutlet weak var calnederView: FSCalendar!
    @IBOutlet weak var scrollTable: UITableView!
    var warningStatus = String()
    @IBOutlet weak var dateButton: UIButton!
    //variable declarations
    let datePicker = UIDatePicker()
    var activeTextField = UITextField()
    var textFields = [UITextField]()
    var enterDateObject:JSON = JSON.null
    var hisObject = HistoryObject.init(orderID:"", date:"", loginStart:"", lunchOut:"", lunchReturn:"", logoutFinish:"", canID:"", sent:"", comments:"",timeID:"", isEtcCheck: "", isNote: "", isEdit: "", ETCLogId: "",ColorCode:"",IsSubmitted:"",ErrorMessage:"",IsvalidToSubmit:"",ConflictMessage:"", IsMultipleLunch: "",lunchOut2: "",lunchReturn2: "")
    var timeid = String()
    var latt = String()
    var logn = String()
    var loginToSend = String(), lunchOutToSend = String(), lunchReturnToSend = String(), logoutToSend = String(), addressToSend = String(), lunchOutToSend2 = String(), lunchReturnToSend2 = String()
    var blurEffect = UIBlurEffect()
    var blurEffectView = UIVisualEffectView()
    
    @IBOutlet weak var lunchOutTextField2: JVFloatLabeledTextField!
    
    @IBOutlet weak var lunchReturnTextField2: JVFloatLabeledTextField!
    
    @IBOutlet weak var dataViewHeight: NSLayoutConstraint! // 560 -450
    @IBOutlet weak var logoutTop: NSLayoutConstraint! // 125 to 15
    @IBOutlet weak var dataView: UIView! // 603 to 484
    
    override func viewDidLoad() {
        EMALocationManager.shared.requestLocationAtOnce()
        super.viewDidLoad()
        submitButton.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        textFields = [loginStartTextField,lunchOutTextField,lunchReturnTextField,logoutFinishTextField]
        
        self.title = "Enter New Day"
        
        commentsView.layer.borderColor = UIColor.gray.cgColor
        commentsView.layer.borderWidth = 1.0
        commentsView.layer.cornerRadius = 5
        commentsTextView.placeholder = "Enter comments here..."
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = "MM/dd/yyyy"
        let result = formatter.string(from: date)
        dateButton.setTitle(result, for: .normal)
        commentsTextView.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(commentsDoneClicked (_:)))
        scrollTable.tableFooterView = UIView()
        calnederView.delegate = self
        configure_Calender()
        showCalener()
        getLocationDetails()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updatePopView(notification:)), name: Notification.Name("updatePopView"), object: nil)
        
        warningStatus = "false"
        WarningType = ""
        activateSingleLunchBreaks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        orderIdLabel.textColor = .black
        orderIdLabel.text = Constants.eTimeClockOrderID
        
        if  Constants.ETCIsMultipleLunch.count > 0 {
            
            if Constants.ETCIsMultipleLunch == "1" {
                lunchOutTextField.placeholder  = ordersData["LunchOut1"].stringValue
                lunchReturnTextField.placeholder  = ordersData["LunchIn1"].stringValue
                lunchOutTextField2.placeholder  = ordersData["LunchOut2"].stringValue
                lunchReturnTextField2.placeholder  = ordersData["LunchIn2"].stringValue
                self.activateMultpleLunchBreaks()
            }
            else {
                lunchOutTextField.placeholder  = ordersData["LunchOut"].stringValue
                lunchReturnTextField.placeholder  = ordersData["LunchIn"].stringValue
                self.activateSingleLunchBreaks()
            }
        }
    }
    @objc func updatePopView(notification: Notification){
        cView.removeFromSuperview()
    }
    func configure_Calender ()
    {
        //calneder view config's
        self.calnederView.delegate = self
        self.calnederView.select(Date())
        self.calnederView.scope = .month
        self.calnederView.accessibilityIdentifier = "calendar"
        self.calnederView.appearance.weekdayTextColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        self.calnederView.appearance.headerTitleColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        self.calnederView.appearance.selectionColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        self.calnederView.appearance.todayColor =  UIColor(hexString:"#c4c0cb")
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //craeting the layers for the textFields
        createBorder(textField:lunchOutTextField)
        createBorder(textField: lunchReturnTextField)
        createBorder(textField: loginStartTextField)
        createBorder(textField: logoutFinishTextField)
        createBorder(textField: lunchOutTextField2)
        createBorder(textField: lunchReturnTextField2)
        
        //adding the calender image to the textField
        setRightViewIcon(textField:loginStartTextField)
        setRightViewIcon(textField:lunchOutTextField)
        setRightViewIcon(textField:lunchReturnTextField)
        setRightViewIcon(textField:logoutFinishTextField)
        setRightViewIcon(textField:lunchOutTextField2)
        setRightViewIcon(textField:lunchReturnTextField2)
        
        //        configure_DatePicker(textField:loginStartTextField)
        //        configure_DatePicker(textField: logoutFinishTextField)
        //        configure_DatePicker(textField:lunchOutTextField)
        //        configure_DatePicker(textField:lunchReturnTextField)
        
        
    }
    
    func activateMultpleLunchBreaks() {
        dataViewHeight.constant = 560
        logoutTop.constant = 125
        dataView.frame.size.height = 603
        lunchOutTextField2.isHidden = false
        lunchReturnTextField2.isHidden = false
        scrollTable.reloadData()
    }
    func activateSingleLunchBreaks() {
        dataViewHeight.constant = 450
        logoutTop.constant = 15
        dataView.frame.size.height = 484
        lunchOutTextField2.isHidden = true
        lunchReturnTextField2.isHidden = true
        scrollTable.reloadData()
    }
    //catching the device orentation
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            cView.frame = CGRect.init(x:0, y:0, width: self.view.bounds.size.width, height:self.view.bounds.size.height)
        // self.calnederView.reloadData()
        case .landscapeLeft:
            text="LandscapeLeft"
            cView.frame = CGRect.init(x:0, y:0, width: self.view.bounds.size.width, height:self.view.bounds.size.height)
        case .landscapeRight:
            text="LandscapeRight"
            cView.frame = CGRect.init(x:0, y:0, width: self.view.bounds.size.width, height:self.view.bounds.size.height)
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //hiding the keyboard when tapped outside
        self.view.endEditing(false)
    }
    
    
    //method to add bottom layer to the textField
    func createBorder(textField:UITextField)
    {
        //creating the border at the bottom
        let border = CALayer()
        border.borderColor = UIColor.lightGray.cgColor
        border.borderWidth = 1
        border.frame = CGRect(x:0, y:39, width:textField.bounds.size.width, height:1)
        textField.layer.masksToBounds = true
        //adding the layers to the textfield
        textField.layer.addSublayer(border)
        
    }
    
    @objc func commentsDoneClicked(_ sender: Any){
        self.commentsTextView.endEditing(true)
    }
    
    //this method is used to create the rightside view to the textField
    func setRightViewIcon(textField:UITextField) {
        
        let btnView = UIButton(frame: CGRect(x: 0, y: 5, width:28, height:28))
        btnView.setImage(UIImage(named:"clock.png"), for: .normal)
        btnView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 3)
        btnView.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        btnView.tag = textField.tag
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        view.addSubview(btnView)
        textField.rightView = view
        textField.rightViewMode = .always
        
    }
    
    //called when button is clicked from textField
    @objc func buttonAction(sender: UIButton!) {
        activeTextField = textFields[sender.tag-1]
        activeTextField.tag = sender.tag
        configure_DatePicker(textField:activeTextField)
        activeTextField.becomeFirstResponder()
    }
    
    //MARK:- action called while submiting the order
    @IBAction func submitAction(_ sender: Any) {
        self.view.endEditing(true)
        if checkLocationPermission() {
            let llogin  = ordersData["Login"].stringValue
            let llogout  = ordersData["LogOut"].stringValue
            
                if logoutFinishTextField.text!.count>0&&loginStartTextField.text!.count>0
                {
                    
                    insert_Edit_Data()
                }
                else
                {
                    ServerService.ShowAlertMessage(ErrorMessage:"", title: "\(llogin) and \(llogout) are required", view:self)
                }
        }
        else {
            askPermission()
        }
    }
    
    //TODO:- Add time_id param
    
    func insert_Edit_Data()
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:self.view)
            if hisObject.TimeId.count>0{
                timeid = hisObject.TimeId
            }
            else
            {
                timeid = ""
            }
            let enteredDate = dateButton.currentTitle!
            if loginStartTextField.text!.count > 0 {
                loginToSend = "\(enteredDate) \(loginStartTextField.text!)"
            }
            if lunchOutTextField.text!.count > 0 {
                lunchOutToSend = "\(enteredDate) \(lunchOutTextField.text!)"
            }
            if lunchReturnTextField.text!.count > 0 {
                lunchReturnToSend = "\(enteredDate) \(lunchReturnTextField.text!)"
            }
            if lunchOutTextField2.text!.count > 0 {
                lunchOutToSend2 = "\(enteredDate) \(lunchOutTextField2.text!)"
            }
            if lunchReturnTextField2.text!.count > 0 {
                lunchReturnToSend2 = "\(enteredDate) \(lunchReturnTextField2.text!)"
            }
            if logoutFinishTextField.text!.count > 0 {
                logoutToSend = "\(enteredDate) \(logoutFinishTextField.text!)"
            }
            let params =
                ["CandidateId" : UserDefaults.standard.object(forKey: "cID") as! String,
                 "log_in"  : loginToSend,
                 "log_out" : logoutToSend,
                 "lunch_in" : lunchReturnToSend,
                 "lunch_out" : lunchOutToSend,
                 "Comments" : commentsTextView.text!,
                 "latitude": latt,
                 "longitude": logn,
                 "address": self.addressToSend,
                 "OrderID": Constants.eTimeClockOrderID,
                 "ETCcheck": Constants.ETCcheck,
                 "IsWarningConfirmed":self.warningStatus,
                 "CurrentDate":currentDateNTime(),
                 "lunch_out2":lunchOutToSend2,
                 "lunch_in2":lunchReturnToSend2,
                 "WarningType":WarningType, "DeviceId": "\(UIDevice.current.identifierForVendor!.uuidString.stripped)"]  as [String : Any]
            print(params)
            ServerService.enterNewDay(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.gethEditEnterData(response:))
            
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            
        }
        
    }
    
    // response from the server
    func gethEditEnterData(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        enterDateObject = response as! JSON
        print("****** enterDateObject data is ************\n",enterDateObject)
        
        if enterDateObject["MessageStatus"].intValue == 1 {
            self.warningStatus = "false"
            self.WarningType = ""
            let alert = UIAlertController.init(title: enterDateObject["Status"].stringValue, message: "", preferredStyle: .alert)
            
            let action1 = UIAlertAction.init(title: "Ok", style: .default) { (action) in
                
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(action1)
            self.present(alert, animated: true, completion: nil)
        }
        else{
            if enterDateObject["WarningMessage"].stringValue == "true"
            {
                let attributedString = NSAttributedString(string:enterDateObject["Status"].stringValue, attributes: [
                    NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), //your font here
                    NSAttributedStringKey.foregroundColor : UIColor.black
                ])
                let alert = UIAlertController(title: "", message: "",  preferredStyle: .alert)
                alert.setValue(attributedString, forKey: "attributedTitle")
                let ok = UIAlertAction(title: "YES",
                                       style: .default) { (action: UIAlertAction!) -> Void in
                    OperationQueue.main.addOperation({
                        self.warningStatus = "true"
                        self.WarningType = self.enterDateObject["WarningType"].stringValue
                        self.insert_Edit_Data()
                    })
                    
                    
                }
                let cancel = UIAlertAction(title: "NO",
                                           style: .destructive) { (action: UIAlertAction!) -> Void in
                    self.warningStatus = "false"
                    self.WarningType = ""
                }
                alert.addAction(cancel)
                alert.addAction(ok)
                present(alert,animated: true,completion: nil)
            }
            else {
                
                var messagee = String()
                if enterDateObject["Status"].stringValue.count > 0 {
                    messagee = enterDateObject["Status"].stringValue
                }
                else {
                    messagee = "Something is not right here try again later"
                }
                ServerService.ShowAlertMessage(ErrorMessage:"", title:messagee, view:self)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    func configure_DatePicker(textField:UITextField){
        //Formate Date
        datePicker.datePickerMode = .time
        datePicker.setDate(Date(), animated:true)
        datePicker.tintColor = UIColor.black
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        textField.inputAccessoryView = toolbar
        textField.inputView = datePicker
        
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = "hh:mm aa"//"MM/dd/yyyy hh:mm aa"
        activeTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    //MARK:- Getting User Location Co-ordinates
    func getLocationDetails(){
        EMALocationManager.shared.requestLocationAtOnce()
        if UserDefaults.standard.value(forKey: "CurrentLocation") != nil {
            let currentLocationCoordi = UserDefaults.standard.value(forKey: "CurrentLocation") as! [String: CLLocationDegrees]
            print("Latitude \(String(describing: currentLocationCoordi["latitude"]!))")
            print("Longitude \(String(describing: currentLocationCoordi["longitude"]!))")
            latt = String(describing: currentLocationCoordi["latitude"]!)
            logn = String(describing: currentLocationCoordi["longitude"]!)
            //        let lat: Double = Double("\(latt)")!
            //        //21.228124
            //        let lon: Double = Double("\(logn)")!
            //        self.reverseGeoCode(lat: lat, long: lon)
        }
        else {
            EMALocationManager.shared.requestLocationAtOnce()
            if let recentLocation = EMALocationManager.shared.currentLocation?.coordinate, EMALocationManager.shared.currentLocation?.horizontalAccuracy ?? -1 >= 0 {
                latt = String(describing: recentLocation.latitude)
                logn = String(describing: recentLocation.longitude)
            }
        }
        
    }
    
    func reverseGeoCode(lat: Double, long: Double)
    {
        
        DispatchQueue.global(qos:.userInitiated).async {
            
            let urlString = String(format:"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&key=AIzaSyD6xpmUz94TVR3hUjKYEuBSILJJJoP70HQ",lat,long)
            
            var request = URLRequest(url: URL(string:urlString)!)
            request.httpMethod = "POST"
            let postString: String = String(format:"")
            
            request.httpBody = postString.data(using: .utf8)
            
            URLSession.shared.dataTask(with:request) { (data, response, error) in
                if error != nil
                {
                    print("error is ",error!)
                }
                else
                {
                    let  json = JSON(data!)
                    //                    print("********Address********",json)
                    OperationQueue.main.addOperation
                    {
                        
                        if json["results"].null == nil{
                            let results = json["results"]
                            if results.count > 0{
                                self.addressToSend =  json["results"][0]["formatted_address"].stringValue
                                
                                print(self.addressToSend)
                            }
                        }
                    }
                }
            }.resume()
            
        }
    }
    
    
    /*
     let formatter = DateFormatter()
     formatter.dateFormat = "MM/dd/yyyy"
     calnederView.select(formatter.date(from: activeField.text!))
     showCalener()
     */
    //MARK:- Showing the calendee
    func showCalener() {
        
        
        cView.frame = CGRect.init(x:0, y:0, width: self.view.bounds.size.width, height:self.view.bounds.size.height)
        //        blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        //        blurEffectView = UIVisualEffectView(effect: blurEffect)
        //        blurEffectView.frame = view.bounds
        //        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //        blurEffectView.contentView.addSubview(cView)
        view.addSubview(cView)
        
    }
    
    @IBAction func dateButtonClicked(_ sender: UIButton) {
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = "MM/dd/yyyy"
        calnederView.select(formatter.date(from: dateButton.currentTitle!))
        showCalener()
    }
    
    //MARK:- function to get the orders history
    
    func getETCData()
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            
            if checkLocationPermission() {
                self.getLocationDetails()
                let params = ["CandidateId":UserDefaults.standard.object(forKey:"cID") as! String,
                              "entereddate":dateButton.currentTitle!,
                              "latitude":latt,
                              "longitude": logn,
                              "PositionID":"",
                              "ClientId":"",
                              "PositionCheck":""] as [String : Any]
                print(params)
                ServerService.showActivityIndicatory(uiView:self.view)
                ServerService.ETimeClockGetETCNewDay(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.getettcData(response:))
            }
            else {
                askPermission()
            }
        }
        // }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            
            
        }
        
    }
    
    func getettcData(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        print(response)
        ordersData = response as! JSON
        loginStartTextField.placeholder  = ordersData["Login"].stringValue
        
        logoutFinishTextField.placeholder  = ordersData["LogOut"].stringValue
        if ordersData["LstETimeClockCandOrders"].arrayValue.count == 0 {
            ServerService.ShowAlertMessage(ErrorMessage:"", title: ordersData["Message"].stringValue, view:self)
            Constants.eTimeClockOrderID = ""
            Constants.ETCcheck = ""
            Constants.ETCIsMultipleLunch = ""
        }
        else if ordersData["LstETimeClockCandOrders"].arrayValue.count == 1 {
            cView.removeFromSuperview()
            Constants.eTimeClockOrderID = ordersData["LstETimeClockCandOrders"][0]["Order_id"].stringValue
            Constants.ETCcheck = ordersData["LstETimeClockCandOrders"][0]["isETCcheck"].stringValue
            orderIdLabel.text = Constants.eTimeClockOrderID
            Constants.ETCIsMultipleLunch = ordersData["LstETimeClockCandOrders"][0]["IsMultipleLunch"].stringValue
            
            if Constants.ETCIsMultipleLunch == "1" {
                lunchOutTextField.placeholder  = ordersData["LunchOut1"].stringValue
                lunchReturnTextField.placeholder  = ordersData["LunchIn1"].stringValue
                lunchOutTextField2.placeholder  = ordersData["LunchOut2"].stringValue
                lunchReturnTextField2.placeholder  = ordersData["LunchIn2"].stringValue
                self.activateMultpleLunchBreaks()
            }
            else {
                lunchOutTextField.placeholder  = ordersData["LunchOut"].stringValue
                lunchReturnTextField.placeholder  = ordersData["LunchIn"].stringValue
                self.activateSingleLunchBreaks()
                
            }
        }
        else {
            
            self.moveToOrdersListScreen()
        }
        
    }
    
    func moveToOrdersListScreen() {
        let screen = self.storyboard?.instantiateViewController(withIdentifier: "OrdersViewController") as! OrdersViewController
        screen.assignmentListData = self.ordersData
        screen.isFrom = "NewDay"
        self.navigationController?.pushViewController(screen, animated: true)
    }
    func showPicker(ampm:Bool)
    {
        
        let min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
        let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
        let picker = DateTimePicker.show(selected:Date(), minimumDate: min, maximumDate: max)
        let step = ordersData["MinutesStepCount"].intValue
        if step == 30
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.thirty
        }
        else if step == 15
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.fifteen
        }
        else if step == 10
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.ten
        }
        else if step == 5
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.five
        }
        
        else if step == 6
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.six
        }
        else if step == 1
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.default
        }
        else{
            picker.timeInterval = DateTimePicker.MinuteInterval.default
        }
        
        picker.highlightColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = "Select"
        picker.doneBackgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        picker.locale = Locale.preferredLocale()
        //picker.isDefault = true
        picker.todayButtonTitle = ""
        picker.isAmPm = ampm
        if ampm{
            picker.is12HourFormat = false
            picker.dateFormat = "hh:mm"
        }
        else
        {
            picker.is12HourFormat = true
            picker.dateFormat = "hh:mm aa"
        }
        picker.isTimePickerOnly = true
        //picker.isDatePickerOnly = true
        picker.includeMonth = false // if true the month shows at top
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.locale = Locale.preferredLocale()
            if ampm{
                formatter.dateFormat = "hh:mm"
            }
            else
            {
                formatter.dateFormat = "hh:mm aa"
            }
            
            if (self.activeTextField == self.loginStartTextField)
            {
                self.loginStartTextField.text = formatter.string(from: date)
            }
            else if (self.activeTextField == self.lunchOutTextField)
            {
                self.lunchOutTextField.text = formatter.string(from: date)
                
            }
            else if (self.activeTextField == self.lunchReturnTextField)
            {
                self.lunchReturnTextField.text = formatter.string(from: date)
            }
            else if (self.activeTextField == self.lunchOutTextField2)
            {
                self.lunchOutTextField2.text = formatter.string(from: date)
                
            }
            else if (self.activeTextField == self.lunchReturnTextField2)
            {
                self.lunchReturnTextField2.text = formatter.string(from: date)
            }
            else if (self.activeTextField == self.logoutFinishTextField)
            {
                self.logoutFinishTextField.text = formatter.string(from: date)
            }
            
        }
        picker.delegate = self
        NotificationCenter.default.post(name: Notification.Name("Time"), object: nil)
    }
}

//END OF CLASS

extension EnterNewDateViewController:UITextFieldDelegate
{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        //        if activeTextField.text!.count > 0 {
        //            datePicker.setDate(self.geteTimeClockDateFromStringTime(stringdate: activeTextField.text!), animated:true)
        //        }
        
        self.view.endEditing(true)
        self.showPicker(ampm:false)
    }
}
extension EnterNewDateViewController:FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance
{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        //chnaging the dateFormat
        let date = date
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = "MM/dd/yyyy"
        let result = formatter.string(from: date)
        dateButton.setTitle(result, for: .normal)
        self.getETCData()
        
        
    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int
    {
        return 0
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        
        return nil
    }
    //    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
    //
    //        let formatter = DateFormatter()
    //        formatter.dateFormat = dateFormat
    //
    //        let todayDate = date
    //        let todayString = formatter.string(from: todayDate as Date)
    //        let todaysDay = self.getDayOfWeek(today: todayString)
    //
    //        if todaysDay == "Sunday" {
    //            return UIColor.red
    //        }else{
    //            return UIColor.clear
    //        }
    //
    //    }
    func minimumDate(for calendar: FSCalendar) -> Date
    {
        return Calendar.current.date(byAdding: .day, value: -60, to: Date())!
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
        //Date().addDays(365)
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        
        let todayDatee = date
        let todayString = convertDateToString(dDate: todayDatee)
        let SelDate = convertDateToString(dDate: date)
        let maxdaay = convertDateToString(dDate: Calendar.current.date(byAdding: .day, value: 0, to: Date())!)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.locale = Locale.preferredLocale()
        dateFormatter1.dateFormat = "MM-dd-yyyy"
        let todayDate = dateFormatter1.date(from: todayString)
        let calDate = dateFormatter1.date(from: SelDate)
        let maxfinal = dateFormatter1.date(from: maxdaay)
        let compare = describeComparison(date1: calDate ?? Date(), date2: todayDate ?? Date())
        let compare1 = describeComparison(date1: calDate ?? Date(), date2: maxfinal ?? Date())
        if compare ==  "date1 < date2" || compare1 == "date1 > date2"{
            return UIColor.lightGray
        }
        else{
            //            let d = dateFormatter.string(from: date)
            //            if arrDates.contains(d) {
            //                return UIColor.black
            //            } else {
            //                return UIColor.lightGray
            //            }
            return UIColor.black
        }
    }
    func describeComparison(date1: Date, date2: Date) -> String {
        
        //https://stackoverflow.com/questions/39018335/swift-3-comparing-date-objects
        
        var descriptionArray: [String] = []
        
        if date1 == date2 {
            descriptionArray.append("date1 == date2")
        }
        
        if date1 != date2 {
            
            if date1 < date2 {
                descriptionArray.append("date1 < date2")
            }
            
            if date1 > date2 {
                descriptionArray.append("date1 > date2")
            }
            
        }
        
        return descriptionArray.joined(separator: ",  ")
    }
    
    func convertDateToString(dDate: Date) -> String{
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String //2020-05-24 08:53:48 +0000
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let myString = formatter.string(from: dDate) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "MM-dd-yyyy"//""yyyy-MM-dd"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        
        return myStringafd
    }
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        //        let formatter = DateFormatter()
        //        formatter.dateFormat = dateFormat
        //        let todayDate = date
        //        let todayString = formatter.string(from: todayDate)
        //        let todaysDay = self.getDayOfWeek(today: todayString)
        //
        //        if todaysDay == "Sunday" {
        //            return true
        //        }else{
        //            return false
        //        }
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        
        let todayDatee = date
        let todayString = convertDateToString(dDate: todayDatee)
        let SelDate = convertDateToString(dDate: date)
        let maxdaay = convertDateToString(dDate: Calendar.current.date(byAdding: .day, value: 0, to: Date())!)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.locale = Locale.preferredLocale()
        dateFormatter1.dateFormat = "MM-dd-yyyy"
        let todayDate = dateFormatter1.date(from: todayString)
        let calDate = dateFormatter1.date(from: SelDate)
        let maxfinal = dateFormatter1.date(from: maxdaay)
        let compare = describeComparison(date1: calDate ?? Date(), date2: todayDate ?? Date())
        let compare1 = describeComparison(date1: calDate ?? Date(), date2: maxfinal ?? Date())
        if compare ==  "date1 < date2" || compare1 == "date1 > date2"{
            return false
        }
        else{
            //            let d = dateFormatter.string(from: date)
            //            if arrDates.contains(d) {
            //                return UIColor.black
            //            } else {
            //                return UIColor.lightGray
            //            }
            return true
        }
    }
    func getDayOfWeek(today:String)->String {
        
        let formatter  = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        let todayDate = formatter.date(from: today)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: todayDate)
        let weekDay = myComponents.weekday
        var day = ""
        switch weekDay {
        case 1?:
            day = "Sunday"
        case 2?:
            day = "Monday"
        case 3?:
            day = "Tuesday"
        case 4?:
            day = "Wednesday"
        case 5?:
            day = "Thursday"
        case 6?:
            day = "Friday"
        case 7?:
            day = "Saturday"
        default:
            day = ""
        }
        return day
    }
}
extension EnterNewDateViewController:DateTimePickerDelegate
{
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        print(picker.selectedDateString)
    }
}
