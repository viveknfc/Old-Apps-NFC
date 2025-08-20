//
//  EditEtimeClock.swift
//  EWA
//
//  Created by NFC User on 4/15/21.
//  Copyright © 2021 NFC. All rights reserved.
//

import UIKit
import FSCalendar
import SwiftyJSON
import CoreLocation
import IQKeyboardManagerSwift
import JVFloatLabeledTextField


class EditEtimeClock: BaseViewController {
    var historyData:JSON = JSON.null
    @IBOutlet weak var dateIcon: UIImageView!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var loginTop: NSLayoutConstraint!
    @IBOutlet weak var dateButton: UIButton!
    //Object References from storyBoard
    @IBOutlet weak var loginStartTextField: UITextField!
    @IBOutlet weak var lunchOutTextField: UITextField!
    @IBOutlet weak var lunchReturnTextField: UITextField!
    @IBOutlet weak var logoutFinishTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var commentsTextView: UITextView!
    var warningStatus = String()
    @IBOutlet weak var scrollTable: UITableView!
    
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
    var IsFromEditTimsheet = Int()
    @IBOutlet weak var lunchReturnTextField2: JVFloatLabeledTextField!
    @IBOutlet weak var lunchOutTextField2: JVFloatLabeledTextField!
    @IBOutlet weak var dataViewHeight: NSLayoutConstraint! // 560 to 450
    
    @IBOutlet weak var logoutTop: NSLayoutConstraint! // 125 to 15
    @IBOutlet weak var dataView: UIView! // 603 to 484
    var WarningType = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        EMALocationManager.shared.requestLocationAtOnce()
        submitButton.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        textFields = [loginStartTextField,lunchOutTextField,lunchReturnTextField,logoutFinishTextField]
        
        dateButton.isUserInteractionEnabled = false
        self.title = "Edit Day"
        
        if hisObject.IsMultipleLunch == "1" {
            self.activateMultpleLunchBreaks()
            lunchOutTextField.placeholder  = historyData["LunchOut1"].stringValue
            lunchReturnTextField.placeholder  = historyData["LunchIn1"].stringValue
            lunchOutTextField2.placeholder  = historyData["LunchOut2"].stringValue
            lunchReturnTextField2.placeholder  = historyData["LunchIn2"].stringValue
        }
        else {
            self.activateSingleLunchBreaks()
            lunchOutTextField.placeholder  = historyData["LunchOut"].stringValue
            lunchReturnTextField.placeholder  = historyData["LunchIn"].stringValue
        }
        
        loginStartTextField.placeholder  = historyData["Login"].stringValue
        
        logoutFinishTextField.placeholder  = historyData["LogOut"].stringValue
        
        loginStartTextField.text =  self.geteTimeClockFormattedTime(string:    hisObject.loginStart)
        logoutFinishTextField.text = self.geteTimeClockFormattedTime(string: hisObject.logoutFinish)
        lunchOutTextField.text = self.geteTimeClockFormattedTime(string: hisObject.lunchOut)
        lunchReturnTextField.text = self.geteTimeClockFormattedTime(string: hisObject.lunchReturn)
        lunchOutTextField2.text = self.geteTimeClockFormattedTime(string: hisObject.lunchOut2)
        lunchReturnTextField2.text = self.geteTimeClockFormattedTime(string: hisObject.lunchReturn2)
        commentsTextView.text = hisObject.comments
        
        commentsView.layer.borderColor = UIColor.gray.cgColor
        commentsView.layer.borderWidth = 1.0
        commentsView.layer.cornerRadius = 5
        commentsTextView.placeholder = "Enter comments here..."
        
        commentsTextView.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(commentsDoneClicked (_:)))
        scrollTable.tableFooterView = UIView()
        orderIdLabel.textColor = .black
        orderIdLabel.text = "\(hisObject.orderID)"
        let enteredDate = self.geteTimeClockFormattedOnlyDate(string:  hisObject.date)
        print(enteredDate)
        dateButton.setTitle(enteredDate, for: .normal)
        warningStatus = "false"
        WarningType = ""
        getLocationDetails()
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
    
    @IBAction func dateButtonClicked(_ sender: UIButton) {
        
        
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
            
            insert_Edit_Data()
            /*
             if commentsTextView.text!.replacingOccurrences(of: " ", with: "").count>0{
             insert_Edit_Data()
             }
             else{
             ServerService.ShowAlertMessage(ErrorMessage:"Please enter comments", title: "", view:self)
             } */
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
            
            
            let enteredDate = self.geteTimeClockFormattedOnlyDate(string:  hisObject.date)
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
            let etccheck = hisObject.IsETCcheck
            if etccheck == "0"{
                latt = ""
                logn = ""
            }
            //"lunch_in2", "lunch_out2"
            let params =
                ["CandidateId" : UserDefaults.standard.object(forKey: "cID") as! String,
                 "log_in"  : loginToSend,
                 "log_out" : logoutToSend,
                 "lunch_in" : lunchReturnToSend,
                 "lunch_out" : lunchOutToSend,
                 "Comments" : commentsTextView.text!,
                 "Time_id":hisObject.TimeId,
                 "latitude": latt,
                 "longitude": logn,
                 "isETCcheck": hisObject.IsETCcheck,
                 "order_id":hisObject.orderID,
                 "Address":self.addressToSend,
                 "IsFromLunchPopup":"0",
                 "NoLunchTaken":"0",
                 "CurrentDate":currentDateNTime(),
                 "IsFromEditTimsheet":IsFromEditTimsheet,
                 "IsWarningConfirmed":self.warningStatus,
                 "mode":"",
                 "lunch_out2":lunchOutToSend2,
                 "lunch_in2":lunchReturnToSend2,
                 "WarningType":WarningType, "DeviceId": "\(UIDevice.current.identifierForVendor!.uuidString.stripped)"]  as [String : Any]
            print("viv calling from here 283",params)
            ServerService.editDay(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.gethEditEnterData(response:))
            
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
        /*
         {
         "log_out" : "2019-03-10T19:30:10",
         "CandidateId" : 233450,
         "Status" : "There is currently no order for you with this login time.  Please check with your supervisor to make sure an order is in place for you.",
         "Comments" : "test",
         "lunch_in" : "2019-03-10T14:10:27",
         "log_in" : "2019-03-10T10:00:57",
         "MessageStatus" : 1,
         "lunch_out" : "2019-03-10T15:10:55",
         "Message" : "Success",
         "Time_id" : 0
         }
         */
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
                    NSAttributedStringKey.foregroundColor : UIColor.black //red
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
            
            //            if latt.count > 0 && logn.count > 0 {
            //                let lat: Double = Double("\(latt)")!
            //                //21.228124
            //                let lon: Double = Double("\(logn)")!
            //                self.reverseGeoCode(lat: lat, long: lon)
            //            }
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
        self.addressToSend = ""
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
    
    func showPicker(ampm:Bool)
    {
        
        let min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
        let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
        let picker = DateTimePicker.show(selected:Date(), minimumDate: min, maximumDate: max)
        let step = historyData["MinutesStepCount"].intValue
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

extension EditEtimeClock:UITextFieldDelegate
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
extension EditEtimeClock:DateTimePickerDelegate
{
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        print(picker.selectedDateString)
    }
}
