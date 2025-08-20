//
//  OrderDetailViewController.swift
//  EWA
//
//  Created by Mahesh Narla on 03/01/19.
//  Copyright © 2019 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation
import JVFloatLabeledTextField
import SideMenuController

class OrderDetailViewController: UIViewController {
    //object references from storyboard
    @IBOutlet weak var lunchPopupHeadingLabel: UILabel!
    @IBOutlet weak var buttonsTableView: UITableView!
    @IBOutlet weak var lunchOutButton2: ShadowButton!
    @IBOutlet weak var lunchReturnButton2: ShadowButton!
    @IBOutlet weak var break2Height: NSLayoutConstraint! // 160 // No meals 20 // multiple lunch breaks 300
    let datePicker = UIDatePicker()
    @IBOutlet var lunchDetailsPopView: UIView!
    var textFields = [UITextField]()
    @IBOutlet weak var popLunchOutTF: JVFloatLabeledTextField!
    var activeTextField = UITextField()
    @IBOutlet weak var popLunchSubmitButton: UIButton!
    @IBOutlet weak var popLunchCancelButton: UIButton!
    var NoLunchTaken = String()
    @IBOutlet weak var popLunchReturnTF: JVFloatLabeledTextField!
    @IBOutlet weak var loginButton: ShadowButton!
    @IBOutlet weak var lunchOut: ShadowButton!
    @IBOutlet weak var lunchReturn: ShadowButton!
    @IBOutlet weak var logOut: ShadowButton!
    @IBOutlet weak var positionsPopView: UIView!
    @IBOutlet weak var positionsTableView: UITableView!
    
    @IBOutlet weak var positionTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var innerPopView: UIView!
    //variable declarations
    var timeObject:JSON = JSON.null
    var ordersData:JSON = JSON.null
    var order_ID  = String()
    var type = Int()
    var ETCcheck = String()
    var addressToSend = String()
    @IBOutlet var loginStartPopView: UIView!
    @IBOutlet weak var conclusionTopView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var popViewDateLabel: UILabel!
    @IBOutlet weak var popViewLocationLabel: UILabel!
    @IBOutlet weak var popViewUserNameLabel: UILabel!
    var typeStr = String()
    var warningStatus = String()
    var latt = String()
    var logn = String()
    var loginTime = String();var lunchOutTime = String();var lunchInTime = String();var logoutTime = String();var lunchOutTime2 = String();var lunchInTime2 = String()
    var positionID = String(); var clientID = String(); var positionCheck = String();
    var enterDateObject:JSON = JSON.null
    @IBOutlet weak var popSubmitButtonLeft: NSLayoutConstraint!
    @IBOutlet weak var popCancelLabel: UILabel!
    @IBOutlet weak var popSubmitLabel: UILabel!
    
    @IBOutlet weak var lunchPopViewHeight: NSLayoutConstraint! // 420 to 280
    
    @IBOutlet weak var innerDisplayView: UIView! //288 to 150
    
    @IBOutlet weak var popLunchOutTF2: JVFloatLabeledTextField!
    
    @IBOutlet weak var ll1: UILabel!
    @IBOutlet weak var ll: UILabel!
    @IBOutlet weak var lImg1: UIImageView!
    @IBOutlet weak var lImg: UIImageView!
    @IBOutlet weak var popLunchReturnTF2: JVFloatLabeledTextField!
    var isMultiLunchOrder = Bool()
    var WarningType = String()
    
    var titleMessage = String()
    
    var tempTypeOfAction = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        positionID = ""
        clientID = ""
        positionCheck = "0"
        buttonsTableView.tableFooterView = UIView()
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectIndex(_:)), name: Notification.Name(rawValue: "didSelectIndex"), object: nil)
        //textFields = [popLunchOutTF,popLunchReturnTF]
        popLunchOutTF.delegate = self
        popLunchReturnTF.delegate = self
        popLunchOutTF2.delegate = self
        popLunchReturnTF2.delegate = self
        self.warningStatus = "false"
        self.WarningType = ""
    }
    
    func lunchPopUpWithMultipleLunchBreak() {
        lunchPopViewHeight.constant = 420
        innerDisplayView.frame.size.height = 288
        popLunchOutTF2.isHidden = false
        popLunchReturnTF2.isHidden = false
        lImg.isHidden = false
        lImg1.isHidden = false
        ll.isHidden = false
        ll1.isHidden = false
    }
    func lunchPopUpWithSingleLunchBreak() {
        lunchPopViewHeight.constant = 280
        innerDisplayView.frame.size.height = 150
        popLunchOutTF2.isHidden = true
        popLunchReturnTF2.isHidden = true
        lImg.isHidden = true
        lImg1.isHidden = true
        ll.isHidden = true
        ll1.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = UserDefaults.standard.object(forKey:"CandName") as? String
        positionsPopView.isHidden = true
        positionsTableView.delegate = self
        positionsTableView.dataSource = self
        positionsTableView.tableFooterView = UIView()
        innerPopView.layer.cornerRadius = 5
        Newconfigure_Button_Colors()
        errorLabel.text = ""
        
        print("view will appear called")
        getETCData()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func didSelectIndex(_ notification: Notification) {
        if ((notification.object) != nil){
            print("Selected Index : \(notification.object as! Int)")
            let indd = notification.object as! Int
            if indd == 0 {
                UserDefaults.standard.set("0", forKey: "eTimeClock")
                getETCData()
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let index = UserDefaults.standard.object(forKey: "eTimeClock") as?  String ?? "0"
        if index == "0" {
            print("view did appear called")
            getETCData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // configure_DatePicker(textField:popLunchOutTF)
        //configure_DatePicker(textField: popLunchReturnTF)
        let window = UIApplication.shared.keyWindow!
        
        lunchDetailsPopView.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
    }
    
    //MARK:- function to get the orders history
    
    func getETCData()
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            if checkLocationPermission() {
                self.getLocationDetails()
                let params = ["CandidateId":UserDefaults.standard.object(forKey:"cID") as! String,
                              "entereddate":getToday(), //"04/10/2021",//getToday(),
                              "latitude":latt,
                              "longitude": logn,
                              "PositionID":positionID,
                              "ClientId":clientID,
                              "PositionCheck":positionCheck] as [String : Any]
                print("GetETCDetails params are",params)
                self.showLoaderForThisScreen()
                ServerService.GetETCDetails(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.getettcData(response:))
            }
            else {
                askPermission()
            }
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
    }
    
    func getettcData(response:AnyObject)->()
    {
        self.hideLoaderForThisScreen()
        print("GetEtcdetails api response is ",response)
        ordersData = response as! JSON
        positionID = ""
        clientID = ""
        positionCheck = "0"
        
        loginButton.setTitle(ordersData["Login"].stringValue, for: .normal)
        lunchOut.setTitle(ordersData["LunchOut"].stringValue, for: .normal)
        lunchReturn.setTitle(ordersData["LunchIn"].stringValue, for: .normal)
        lunchOutButton2.setTitle(ordersData["LunchOut2"].stringValue, for: .normal)
        lunchReturnButton2.setTitle(ordersData["LunchIn2"].stringValue, for: .normal)
        logOut.setTitle(ordersData["LogOut"].stringValue, for: .normal)
        
        let llunchoout = ordersData["LunchOut"].stringValue
        let llunchreturn = ordersData["LunchIn"].stringValue
        
        lunchPopupHeadingLabel.text = "Please enter \(llunchoout.lowercased()) and \(llunchreturn.lowercased()) time"
        popLunchOutTF.placeholder  = llunchoout
        popLunchReturnTF.placeholder  = llunchreturn
        popCancelLabel.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        popSubmitLabel.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        
        if ordersData["ActiveOrder"].stringValue.count>1{
            order_ID = ordersData["ActiveOrder"].stringValue
            isMultiLunchOrder = ordersData["IsMultipleLunch"].boolValue
            buttonsTableView.isHidden = false
            errorLabel.text = ""
        }
        else {
            if ordersData["LstEtimeclockGetClients"].arrayValue.count>1{
                buttonsTableView.isHidden = false
                errorLabel.text = ""
                showPositionPopView()
            }
            
            else if ordersData["LstEtimeclockGetClients"].arrayValue.count == 0 && ordersData["LstETimeClockCandOrders"].arrayValue.count == 0{
                buttonsTableView.isHidden = true
                positionID = ""
                clientID = ""
                positionCheck = "0"
                positionsPopView.isHidden = true
                errorLabel.text = ordersData["Message"].stringValue
            }
            else if ordersData["LstETimeClockCandOrders"].arrayValue.count != 0 {
                isMultiLunchOrder = ordersData["LstETimeClockCandOrders"][0]["IsMultipleLunch"].boolValue
                buttonsTableView.isHidden = false
                errorLabel.text = ""
            }
        }
        
        if ordersData["ShowLunchButtons"].stringValue == "0" {
            lunchOut.isHidden = true
            lunchReturn.isHidden = true
            lunchOutButton2.isHidden = true
            lunchReturnButton2.isHidden = true
            break2Height.constant = 20
        }
        else {
            if isMultiLunchOrder {
                break2Height.constant = 300
                lunchOut.isHidden = false
                lunchReturn.isHidden = false
                lunchOutButton2.isHidden = false
                lunchReturnButton2.isHidden = false
                lunchOut.setTitle(ordersData["LunchOut1"].stringValue, for: .normal)
                lunchReturn.setTitle(ordersData["LunchIn1"].stringValue, for: .normal)
            }
            else {
                break2Height.constant = 160
                lunchOut.isHidden = false
                lunchReturn.isHidden = false
                lunchOutButton2.isHidden = true
                lunchReturnButton2.isHidden = true
                lunchOut.setTitle(ordersData["LunchOut"].stringValue, for: .normal)
                lunchReturn.setTitle(ordersData["LunchIn"].stringValue, for: .normal)
            }
        }
        
        if ordersData["IsLogin"].intValue == 1 {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.gray
        }
        
        if ordersData["IsLogOut"].intValue == 1 {
            logOut.isEnabled = false
            logOut.backgroundColor = UIColor.gray
        }
        
        if ordersData["IsLunchOut"].intValue == 1 {
            lunchOut.isEnabled = false
            lunchOut.backgroundColor = UIColor.gray
        }
        
        if ordersData["IslunchIn"].intValue == 1 {
            lunchReturn.isEnabled = false
            lunchReturn.backgroundColor = UIColor.gray
        }
    }
    
    func showPositionPopView(){
        positionsPopView.isHidden = false
        let value = 44*ordersData["LstEtimeclockGetClients"].arrayValue.count+110
        if value > 350{
            positionTableHeight.constant = 350
        }
        else {
            positionTableHeight.constant = CGFloat(value)
        }
        errorLabel.text = ""
        positionsTableView.reloadData()
    }
    
    func Newconfigure_Button_Colors(){
        let enabledColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        configure_Buttons(button:loginButton, textColor:enabledColor, backGroundColor: UIColor.white)
        configure_Buttons(button:lunchOut, textColor:enabledColor, backGroundColor: UIColor.white)
        configure_Buttons(button:lunchReturn, textColor:enabledColor, backGroundColor: UIColor.white)
        configure_Buttons(button:lunchOutButton2, textColor:enabledColor, backGroundColor: UIColor.white)
        configure_Buttons(button:lunchReturnButton2, textColor:enabledColor, backGroundColor: UIColor.white)
        configure_Buttons(button:logOut, textColor:enabledColor, backGroundColor: UIColor.white)
        buttonsTableView.isHidden = true
    }
    
    // method is use to add background color to buttons
    func configure_Buttons(button:UIButton,textColor:UIColor,backGroundColor:UIColor)
    {
        button.backgroundColor = backGroundColor
        button.setTitleColor(textColor, for:.normal)
    }
    
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            if self.view.bounds.height<=568
            {
                loginStartPopView.frame = CGRect(x:0, y:80, width: self.view.bounds.width, height:self.view.bounds.height-80)
            }
            else
            {
                loginStartPopView.frame = CGRect(x:0, y:80, width: self.view.bounds.width, height:self.view.bounds.height-80)
            }
            if isMultiLunchOrder {
                lunchPopViewHeight.constant = 420
            }
            else {
                lunchPopViewHeight.constant = 280
            }
            
        case .landscapeLeft:
            text="LandscapeLeft"
            if self.view.bounds.height<=568
            {
                loginStartPopView.frame = CGRect(x:0, y:80, width: self.view.bounds.width, height:self.view.bounds.height-80)
            }
            else
            {
                loginStartPopView.frame = CGRect(x:0, y:80, width: self.view.bounds.width, height:self.view.bounds.height-80)
            }
            lunchPopViewHeight.constant = 280
            
        case .landscapeRight:
            text="LandscapeRight"
            if self.view.bounds.height<=568
            {
                loginStartPopView.frame = CGRect(x:0, y:80, width: self.view.bounds.width, height:self.view.bounds.height-80)
            }
            else
            {
                loginStartPopView.frame = CGRect(x:0, y:80, width: self.view.bounds.width, height:self.view.bounds.height-80)
            }
            lunchPopViewHeight.constant = 280
            
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
    }
    //login/logout/lunchout/lunchin
    
    //MARK:- button actions
    @IBAction func loginAction(_ sender: Any) {
        
        loginTime = currentDateNTime()
        lunchOutTime = ""
        lunchInTime = ""
        lunchOutTime2 = ""
        lunchInTime2 = ""
        logoutTime = ""
        updateAssignment(typeOfAction:"login")
    }
    
    @IBAction func lunchOut(_ sender: Any) {
        loginTime = ""
        lunchOutTime = currentDateNTime()
        lunchInTime = ""
        lunchOutTime2 = ""
        lunchInTime2 = ""
        logoutTime = ""
        updateAssignment(typeOfAction:"lunchout")
    }
    
    @IBAction func lunchReturn(_ sender: Any) {
        loginTime = ""
        lunchOutTime = ""
        lunchInTime = currentDateNTime()
        lunchOutTime2 = ""
        lunchInTime2 = ""
        logoutTime = ""
        updateAssignment(typeOfAction:"lunchin")
    }
    
    @IBAction func lunchOut2Clicked(_ sender: ShadowButton) {
        loginTime = ""
        lunchOutTime = ""
        lunchInTime = ""
        lunchOutTime2 = currentDateNTime()
        lunchInTime2 = ""
        logoutTime = ""
        updateAssignment(typeOfAction:"lunchout2")
    }
    
    @IBAction func lunchReturn2Clicked(_ sender: ShadowButton) {
        loginTime = ""
        lunchOutTime = ""
        lunchInTime = ""
        lunchOutTime2 = ""
        lunchInTime2 = currentDateNTime()
        logoutTime = ""
        updateAssignment(typeOfAction:"lunchin2")
    }
    
    @IBAction func logoutFinish(_ sender: Any) {
        loginTime = ""
        lunchOutTime = ""
        lunchInTime = ""
        lunchOutTime2 = ""
        lunchInTime2 = ""
        logoutTime = currentDateNTime()
        updateAssignment(typeOfAction:"logout")
    }
    
    func showLunchPopView(){
        
        getLocationDetails()
        let window = UIApplication.shared.keyWindow!
        
        lunchDetailsPopView.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
        UIApplication.getTopMostViewController()!.view.addSubview(lunchDetailsPopView)
        UIApplication.getTopMostViewController()!.view.bringSubview(toFront:lunchDetailsPopView)
    }
    //method to add bottom layer to the textField
    func createBorder(textField:UITextField)
    {
        //constants which stores values which will be assigned to respective fields
        let width = CGFloat(1)
        let color = UIColor.darkGray.cgColor
        
        //creating layer for the border of the view
        let border = CALayer()
        border.frame = CGRect(x:0, y:textField.frame.height-1, width:textField.frame.width, height:width)
        border.borderColor = color
        border.borderWidth = width
        textField.layer.masksToBounds = true
        textField.layer.addSublayer(border)
    }
    
    //this method is used to create the rightside view to the textField
    func setRightViewIcon(textField:UITextField) {
        
        let btnView = UIButton(frame: CGRect(x: 0, y: 5, width:28, height:28))
        btnView.setImage(UIImage(named:"clock.png"), for: .normal)
        btnView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 3)
        btnView.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        btnView.tag = textField.tag
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        view.addSubview(btnView)
        textField.rightView = view
        textField.rightViewMode = .always
        
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
    //called when button is clicked from textField
    @objc func buttonAction(sender: UIButton!) {
        activeTextField = textFields[sender.tag-1]
        activeTextField.tag = sender.tag
        // configure_DatePicker(textField:activeTextField)
        activeTextField.becomeFirstResponder()
    }
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = "hh:mm aa"//"MM/dd/yyyy hh:mm aa"
        activeTextField.text = formatter.string(from: datePicker.date)
        lunchDetailsPopView.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        lunchDetailsPopView.endEditing(true)
    }
    
    func updateAssignment(typeOfAction:String){
        if checkLocationPermission() {
            if ordersData["ActiveOrder"].stringValue.count>1{
                order_ID = ordersData["ActiveOrder"].stringValue
                ETCcheck = ordersData["ETCcheck"].stringValue
                submitValuesToAPI(typeOfAction:typeOfAction)
            }
            else {
                
                if ordersData["LstEtimeclockGetClients"].arrayValue.count > 1{
                    showPositionPopView()
                    
                }
                else {
                    positionsPopView.isHidden = true
                    
                    if ordersData["LstETimeClockCandOrders"].arrayValue.count==0{
                        ServerService.ShowAlertMessage(ErrorMessage:"", title: ordersData["Message"].stringValue, view:self)
                    }
                    else {
                        
                        if typeOfAction == "login"{
                            
                            if ordersData["LstETimeClockCandOrders"].arrayValue.count==1{
                                order_ID = ordersData["LstETimeClockCandOrders"][0]["Order_id"].stringValue
                                ETCcheck = ordersData["LstETimeClockCandOrders"][0]["isETCcheck"].stringValue
                                submitValuesToAPI(typeOfAction:typeOfAction)
                            }
                            else if ordersData["LstETimeClockCandOrders"].arrayValue.count>1{
                                self.moveToOrdersListScreen(typeOfAction: typeOfAction)
                            }
                        }
                        else {
                            order_ID = ordersData["LstETimeClockCandOrders"][0]["Order_id"].stringValue
                            ETCcheck = ordersData["LstETimeClockCandOrders"][0]["isETCcheck"].stringValue
                            submitValuesToAPI(typeOfAction:typeOfAction)
                        }
                    }
                }
            }
        }
        else {
            askPermission()
        }
        
    }
    
    func moveToOrdersListScreen(typeOfAction: String) {
        let screen = self.storyboard?.instantiateViewController(withIdentifier: "OrdersViewController") as! OrdersViewController
        screen.assignmentListData = self.ordersData
        screen.loginTime = self.loginTime
        screen.lunchOutTime = self.lunchOutTime
        screen.lunchInTime = self.lunchInTime
        screen.lunchOutTime2 = self.lunchOutTime2
        screen.lunchInTime2 = self.lunchInTime2
        screen.logoutTime = self.logoutTime
        screen.typeOfAction = typeOfAction
        screen.addressToSend = self.addressToSend
        self.navigationController?.pushViewController(screen, animated: true)
    }
    
    //MARK:- AddPopView
    func addPopView(){
        conclusionTopView.isHidden = true
        okButton.isHidden = true
        popViewUserNameLabel.text = "Welcome, \(String(describing: UserDefaults.standard.object(forKey:"CandName") as! String))"
        popViewDateLabel.text = currentDateNTime()
        getLocationDetails()
        loginStartPopView.frame = CGRect(x:0, y:0, width: self.view.bounds.width, height:self.view.bounds.height)
        self.view.addSubview(loginStartPopView)
    }
    
    var modeToCheck = String()
    
    //MARK:- Update Assignment
    func submitValuesToAPI(typeOfAction:String)
    {
        
        tempTypeOfAction = typeOfAction
        
        
        if ETCcheck == "0"{
            latt = ""
            logn = ""
        }
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:self.view)
                let params = [
                    "CandidateId" : UserDefaults.standard.object(forKey:"cID") as! String,
                    "OrderId" : order_ID,
                    "latitude":latt,
                    "longitude":logn,
                    "entereddate":getToday(),
                    "Mode" : typeOfAction,
                    "Log_in": loginTime,
                    "Lunch_out":lunchOutTime,
                    "Lunch_in":lunchInTime,
                    "Log_out":logoutTime,
                    "ETCcheck" : ETCcheck,
                    "Address": self.addressToSend,
                    "Lunch_out2":lunchOutTime2,
                    "Lunch_in2":lunchInTime2,
                    "Retry":"0", "DeviceId": "\(UIDevice.current.identifierForVendor!.uuidString.stripped)"] as [String : Any]
            
                print(params)
                modeToCheck = typeOfAction
                ServerService.updateAssignment(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.getTimeUpdatedData(response:))
            
            
           
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            
        }
        
        
    }
    
    // response from the server
    func getTimeUpdatedData(response:AnyObject)->()
    {
//        ServerService.hideProgressView() // viv hided for new feature of retry
        timeObject = response as! JSON
        print("****** timeObject data from order detail vc ************\n",timeObject)
        
        if timeObject["Status"].intValue == 1 {
            
            if timeObject["showLunchPopup"].stringValue == "1" {
                
                ServerService.hideProgressView() // viv added newly for retry
                
                popLunchOutTF.text = ""
                popLunchReturnTF.text = ""
                popLunchOutTF2.text = ""
                popLunchReturnTF2.text = ""
                if timeObject["IsMultipleLunch"].stringValue == "1" {
                    self.lunchPopUpWithMultipleLunchBreak()
                    popLunchOutTF.placeholder =  ordersData["LunchOut1"].stringValue
                    popLunchReturnTF.placeholder =  ordersData["LunchIn1"].stringValue
                    popLunchOutTF2.placeholder =  ordersData["LunchOut2"].stringValue
                    popLunchReturnTF2.placeholder =  ordersData["LunchIn2"].stringValue
                }
                else {
                    self.lunchPopUpWithSingleLunchBreak()
                    popLunchOutTF.placeholder =  ordersData["LunchOut"].stringValue
                    popLunchReturnTF.placeholder =  ordersData["LunchIn"].stringValue
                }
                
                if modeToCheck == "lunchin" || modeToCheck == "lunchin2"{
                    lunchPopupHeadingLabel.text = timeObject["Message"].stringValue
                    popSubmitLabel.text = "Update meal break"
                    popSubmitButtonLeft.constant = 0
                    popLunchOutTF.text = self.geteTimeClockFormattedTime(string:  timeObject["Lunch_out"].stringValue)
                    popLunchReturnTF.text = self.geteTimeClockFormattedTime(string:  timeObject["Lunch_in"].stringValue)
                    popLunchOutTF2.text = self.geteTimeClockFormattedTime(string:  timeObject["Lunch_out2"].stringValue)
                    popLunchReturnTF2.text = self.geteTimeClockFormattedTime(string:  timeObject["Lunch_in2"].stringValue)
                    logoutTime = ""
                }
                else {
                    
                    lunchPopupHeadingLabel.text = timeObject["Message"].stringValue
                    
                    popSubmitLabel.text = "Clock Out and save"
                    if timeObject["showNoLunchButton"].stringValue == "1" {
                        popSubmitButtonLeft.constant = 161
                    }
                    else {
                        popSubmitButtonLeft.constant = 0
                    }
                    popLunchOutTF.text = self.geteTimeClockFormattedTime(string:  timeObject["Lunch_out"].stringValue)
                    popLunchReturnTF.text = self.geteTimeClockFormattedTime(string:  timeObject["Lunch_in"].stringValue)
                    popLunchOutTF2.text = self.geteTimeClockFormattedTime(string:  timeObject["Lunch_out2"].stringValue)
                    popLunchReturnTF2.text = self.geteTimeClockFormattedTime(string:  timeObject["Lunch_in2"].stringValue)
                }
                showLunchPopView()
            }
            else {
                
                if self.timeObject["SuccessStatus"].intValue == 1 {
                    
                    ServerService.hideProgressView()
                    let title = timeObject["Message"].stringValue
                    let targetViewControllerIdentifier = "dash"
                    let titleColor = ServerService.alertGreen
                    let titleBg = ServerService.alertGreenBg
                    let buttonBg = ServerService.alertGreen
                    
                    let buttonTitleColor = UIColor.white
                    
                    self.showCustomAlertWithOkButton(title: title, titleColor: titleColor, titleBackgroundColor: titleBg, buttonBackgroundColor: buttonBg, buttonTitleColor: buttonTitleColor, targetViewControllerIdentifier: nil) {
                        let screen = self.storyboard?.instantiateViewController(withIdentifier: "dash") as! DashboardViewController
                        let navi = BaseNaviViewController(rootViewController:screen)
                        navi.navigationBar.tintColor = .white
                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                        self.sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"dash")
                    }
                    
                }
                
                else if self.timeObject["SuccessStatus"].intValue == 0 && self.timeObject["Retry"].intValue == 1 {
                    
                    print("the type of action is ", tempTypeOfAction)
                    
                    let delayInSeconds = self.timeObject["Sleep"].intValue
                    let delayInNanoSeconds = UInt64(delayInSeconds * 1_000_000_000)

                    DispatchQueue.main.asyncAfter(deadline: .now() + .nanoseconds(Int(delayInNanoSeconds))) { [self] in
                        // Retry API Call Started
                        
                        print("Entered the second API call after 5 sec delay")
                        
                        if ConnectionCheck.isConnectedToNetwork()
                        {

                                let params = [
                                    "CandidateId" : UserDefaults.standard.object(forKey:"cID") as! String,
                                    "OrderId" : self.order_ID,
                                    "latitude":self.latt,
                                    "longitude":self.logn,
                                    "entereddate":self.getToday(),
                                    "Mode" : self.tempTypeOfAction,
                                    "Log_in": self.loginTime,
                                    "Lunch_out":self.lunchOutTime,
                                    "Lunch_in":self.lunchInTime,
                                    "Log_out":self.logoutTime,
                                    "ETCcheck" : self.ETCcheck,
                                    "Address": self.addressToSend,
                                    "Lunch_out2":self.lunchOutTime2,
                                    "Lunch_in2":self.lunchInTime2,
                                    "Retry":"1", "DeviceId": "\(UIDevice.current.identifierForVendor!.uuidString.stripped)"] as [String : Any]
                                print("Parameters from the retry api call is /n",params)
                                self.modeToCheck = self.tempTypeOfAction
                                ServerService.updateAssignment(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.getTimeUpdatedData(response:))
                            
                            
                            
                        }
                        else
                        {
                            ServerService.hideProgressView()
                            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                            
                        }
                        
                        // End
                    }
    
                }
                
                else if self.timeObject["SuccessStatus"].intValue == 0 && self.timeObject["Retry"].intValue == 0 {
                    
                    print("Entered retry = 0 and exit the api with a refresh in same page")
                    
                    ServerService.hideProgressView()
                    
                    let title = timeObject["Message"].stringValue
                    let titleColor = ServerService.alertRed
                    let titleBg = ServerService.alertRedBg
                    let buttonBg = ServerService.alertRed
                    let buttonTitleColor = UIColor.white

                    
                    self.showCustomAlertWithOkButton(title: title, titleColor: titleColor, titleBackgroundColor: titleBg, buttonBackgroundColor: buttonBg, buttonTitleColor: buttonTitleColor, targetViewControllerIdentifier: nil) {
                        self.getETCData()
                    }
                    
//                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: title, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
//                    self.getETCData()
                }

            }
        }
        else {
            ServerService.hideProgressView() // viv added newly for retry
            
            //for blank text we need to do as below
            
            //viv newly added
            
            var title = String()
            
            if timeObject["Message"].stringValue.count == 0 {
                title = "Due to some network issues we were unable to get data, please try again after some time"
            } else {
                title = timeObject["Message"].stringValue
            }
            
            //end
            
            
            let titleColor = ServerService.alertRed
            let titleBg = ServerService.alertRedBg
            let buttonBg = ServerService.alertRed
            let buttonTitleColor = UIColor.white

            self.showCustomAlertWithOkButton(title: title, titleColor: titleColor, titleBackgroundColor: titleBg, buttonBackgroundColor: buttonBg, buttonTitleColor: buttonTitleColor, targetViewControllerIdentifier: nil)
            
//            ServerService.ShowAlertMessage(ErrorMessage:"", title: timeObject["Message"].stringValue, view:self)
        }
    }
    
    //MARK:- PopViewActions
    
    @IBAction func confirmButtonClicked(_ sender: UIButton) {
        updateAssignment(typeOfAction:typeStr)
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        loginStartPopView.removeFromSuperview()
    }
    
    @IBAction func okButtonClicked(_ sender: Any) {
        loginStartPopView.removeFromSuperview()
    }
    
    @IBAction func popViewCancelClicked(_ sender: ShadowButton) {
        positionsPopView.isHidden = true
    }
    
    //MARK:- Getting User Location Co-ordinates
    func getLocationDetails(){
        
        EMALocationManager.shared.requestLocationAtOnce()
        
        if let recentLocation = EMALocationManager.shared.currentLocation?.coordinate, EMALocationManager.shared.currentLocation?.horizontalAccuracy ?? -1 >= 0 {
            latt = String(describing: recentLocation.latitude)
            logn = String(describing: recentLocation.longitude)
        }
        
        else {
            print("enter the else with delay of 5 sec")
            let delayInSeconds = 5
            let delayInNanoSeconds = UInt64(delayInSeconds * 1_000_000_000)
            DispatchQueue.main.asyncAfter(deadline: .now() + .nanoseconds(Int(delayInNanoSeconds))) { [self] in
                EMALocationManager.shared.requestLocationAtOnce()
                let recentLocation = EMALocationManager.shared.currentLocation?.coordinate
                
                
                
                latt = String(describing: recentLocation?.latitude)
                logn = String(describing: recentLocation?.longitude)
                print("After 5 sec you will get this")
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
                                
                                print("address from the reverse geo code is",self.addressToSend)
                            }
                        }
                    }
                }
            }.resume()
            
        }
    }
    //MARK:- Getting Current Address
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
                                        if (error != nil)
                                        {
                                            print("reverse geodcode fail: \(error!.localizedDescription)")
                                        }
                                        let pm = placemarks! as [CLPlacemark]
                                        
                                        if pm.count > 0 {
                                            let pm = placemarks![0]
                                            //print(pm.country!)
                                            //  print(pm.locality!)
                                            //print(pm.subLocality!)
                                            // print(pm.thoroughfare!)
                                            //print(pm.postalCode!)
                                            // print(pm.subThoroughfare!)
                                            print (pm)
                                            var addressString : String = ""
                                            if pm.subLocality != nil {
                                                addressString = addressString + pm.subLocality! + ", "
                                            }
                                            if pm.thoroughfare != nil {
                                                addressString = addressString + pm.thoroughfare! + ", "
                                            }
                                            if pm.locality != nil {
                                                addressString = addressString + pm.locality! + ", "
                                            }
                                            if pm.country != nil {
                                                addressString = addressString + pm.country! + ", "
                                            }
                                            if pm.postalCode != nil {
                                                addressString = addressString + pm.postalCode! + " "
                                            }
                                            
                                            
                                            print(addressString)
                                            self.popViewLocationLabel.text = addressString
                                            if let lines = pm.addressDictionary?["FormattedAddressLines"] as? [String] {
                                                let placeString = lines.joined(separator: ", ")
                                                // Do your thing
                                                self.addressToSend = placeString
                                                print(self.addressToSend)
                                            }
                                            
                                        }
                                    })
        
    }
    
    func getToday()-> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = "MM/dd/yyyy"
        let result = formatter.string(from: date)
        return result
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title=""
    }
    
    //MARK:- ActivityLoader
    func showLoaderForThisScreen(){
        let vc = UIStoryboard.init(name:"Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"eTimeClock History") as! ETimeClockMainViewController
        vc.showLoader()
    }
    func hideLoaderForThisScreen(){
        let vc = UIStoryboard.init(name:"Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"eTimeClock History") as! ETimeClockMainViewController
        vc.hideLoader()
    }
    //MARK:- Lunch PopView Actions
    @IBAction func popLunchSubmitButtonCLicked(_ sender: UIButton) {
        //        if popLunchOutTF.text!.count == 0 {
        //            ServerService.ShowAlertMessage(ErrorMessage: "", title: "Please enter \(popLunchOutTF.placeholder!)", view:self)
        //        }
        //        else if popLunchReturnTF.text!.count == 0 {
        //            ServerService.ShowAlertMessage(ErrorMessage:"", title: "Please enter \(popLunchReturnTF.placeholder!)", view:self)
        //        }
        //        else {
        NoLunchTaken = "0"
        insert_Edit_Data()
        // }
    }
    //MARK:- No LunchTaken Action
    @IBAction func popLunchCancelButtonClicked(_ sender: UIButton) {
        NoLunchTaken = "1"
        insert_Edit_Data()
    }
    
    //TODO:- Add time_id param
    
    func insert_Edit_Data()
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:self.view)
            
            if ETCcheck == "0"{
                latt = ""
                logn = ""
            }
            if  modeToCheck == "lunchin" || modeToCheck == "lunchin2"{
                logoutTime = ""
            }
            else {
                logoutTime = currentDateNTime()
            }
            
            lunchOutTime = ""
            lunchInTime = ""
            lunchOutTime2 = ""
            lunchInTime2 = ""
            
            if popLunchOutTF.text!.count > 0 {
                lunchOutTime = "\(getToday()) \(popLunchOutTF.text!)"
            }
            if popLunchReturnTF.text!.count > 0 {
                lunchInTime = "\(getToday()) \(popLunchReturnTF.text!)"
            }
            if popLunchOutTF2.text!.count > 0 {
                lunchOutTime2 = "\(getToday()) \(popLunchOutTF2.text!)"
            }
            if popLunchReturnTF2.text!.count > 0 {
                lunchInTime2 = "\(getToday()) \(popLunchReturnTF2.text!)"
            }
            
            if NoLunchTaken == "1" {
                lunchOutTime = ""
                lunchInTime = ""
                lunchOutTime2 = ""
                lunchInTime2 = ""
            }
            
            
            
            let params =
                ["CandidateId" : UserDefaults.standard.object(forKey: "cID") as! String,
                 "log_in"  : "",
                 "log_out" : logoutTime,
                 "lunch_in" :  lunchInTime,
                 "lunch_out" : lunchOutTime,
                 "Comments" : "",
                 "Time_id":"",
                 "latitude": latt,
                 "longitude": logn,
                 "isETCcheck": ETCcheck,
                 "order_id":order_ID,
                 "Address":self.addressToSend,
                 "IsFromLunchPopup":"1",
                 "NoLunchTaken" : NoLunchTaken,
                 "IsWarningConfirmed":self.warningStatus,
                 "mode":modeToCheck,
                 "CurrentDate":currentDateNTime(),
                 "ShowMealReturn": timeObject["ShowMealReturn"].stringValue,
                 "lunch_in2" :  lunchInTime2,
                 "lunch_out2" : lunchOutTime2,
                 "WarningType":WarningType, "DeviceId": "\(UIDevice.current.identifierForVendor!.uuidString.stripped)"]  as [String : Any]
            print(params)
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
        
        if enterDateObject["MessageStatus"].intValue == 1 {
            self.warningStatus = "false"
            self.WarningType = ""
//            let alert = UIAlertController.init(title: enterDateObject["Status"].stringValue, message: "", preferredStyle: .alert)
            
            let attributedString = NSAttributedString(string:enterDateObject["Status"].stringValue, attributes: [
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), //your font here
                NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            ])
            let alert = UIAlertController(title: "", message: "",  preferredStyle: .alert)
            alert.setValue(attributedString, forKey: "attributedTitle")
            
            let action1 = UIAlertAction.init(title: "Ok", style: .default) { (action) in
                self.lunchDetailsPopView.removeFromSuperview()
                print("called from gethEditEnterData")
                self.getETCData()
                
                if self.enterDateObject["SuccessStatus"].intValue == 1 {
                    print("Clockout success")
                    if let targetViewController = self.storyboard?.instantiateViewController(withIdentifier: "dash") {
                            self.navigationController?.pushViewController(targetViewController, animated: true)
                        }
                }
                
            }
            alert.addAction(action1)
            self.present(alert, animated: true, completion: nil)
        }
        
        else{
            if enterDateObject["WarningMessage"].stringValue == "true"
            {
                let attributedString = NSAttributedString(string:enterDateObject["Status"].stringValue, attributes: [
                    NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), //your font here
                    NSAttributedStringKey.foregroundColor : UIColor.red //viv black here
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
                
                let title = enterDateObject["Status"].stringValue
                let titleColor = ServerService.alertRed
                let titleBg = ServerService.alertRedBg
                let buttonBg = ServerService.alertRed
                let buttonTitleColor = UIColor.white
                
                self.showCustomAlertWithOkButton(title: title, titleColor: titleColor, titleBackgroundColor: titleBg, buttonBackgroundColor: buttonBg, buttonTitleColor: buttonTitleColor)

            }
        }
    }
    
    @IBAction func closeLunchPopUp(_ sender: UIButton) {
        self.lunchDetailsPopView.removeFromSuperview()
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
            
            if (self.activeTextField == self.popLunchOutTF)
            {
                self.popLunchOutTF.text = formatter.string(from: date)
            }
            else if (self.activeTextField == self.popLunchReturnTF)
            {
                self.popLunchReturnTF.text = formatter.string(from: date)
                
            }
            if (self.activeTextField == self.popLunchOutTF2)
            {
                self.popLunchOutTF2.text = formatter.string(from: date)
            }
            else if (self.activeTextField == self.popLunchReturnTF2)
            {
                self.popLunchReturnTF2.text = formatter.string(from: date)
                
            }
            
            
        }
        picker.delegate = self
        NotificationCenter.default.post(name: Notification.Name("Time"), object: nil)
    }
}

extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersData["LstEtimeclockGetClients"].arrayValue.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "position")
        cell?.selectionStyle = .none
        let dataLabel = cell?.viewWithTag(10) as! UILabel
        if ordersData["LstEtimeclockGetClients"].arrayValue.count > 1{
            dataLabel.text = ordersData["LstEtimeclockGetClients"][indexPath.row]["PositionType"].stringValue
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
         {
         "ClientId": 51785,
         "Address": "2 Lafayette Street",
         "Suite": "3rd floor",
         "City": "New York",
         "State": "NY",
         "CodeZip": 10007,
         "PositionType": "2019 DSP",
         "PositionId": 15949
         }
         */
        positionsPopView.isHidden = true
        positionID = ordersData["LstEtimeclockGetClients"][indexPath.row]["PositionId"].stringValue
        clientID = ordersData["LstEtimeclockGetClients"][indexPath.row]["ClientId"].stringValue
        positionCheck = "2"
        self.getETCData()
    }
}

extension UIViewController{
    
    //MARK:- Getting Current Date&Time
    func currentDateNTime() -> String{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        print(dateFormatter.string(from: date))
        return dateFormatter.string(from: date)
    }
    func checkLocationPermission() -> Bool
    {
        var access = Bool()
        print("viv the check location permission is called here")
        if CLLocationManager.locationServicesEnabled()
        {
            switch(CLLocationManager.authorizationStatus())
            {
            case .authorizedAlways, .authorizedWhenInUse:
                print("Authorize.")
                access = true
                break
            case .notDetermined:
                print("Not determined.")
                access = false
                break
            case .restricted:
                print("Restricted.")
                access = false
                break
            case .denied:
                print("Denied.")
                access = false
            }
        }
        return access
    }
    
    func askPermission(){
        let alertController = UIAlertController(title: "", message: "Allow TGCMobileApp to access your location and try again", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "DENY", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("Cancel Pressed")
            
        }
        
        let okAction = UIAlertAction(title: "ALLOW", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            if let bundleId = Bundle.main.bundleIdentifier,
               let url = URL(string: "\(UIApplicationOpenSettingsURLString)&path=LOCATION/\(bundleId)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        // Add the actions
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
}
extension OrderDetailViewController:UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        //        if activeTextField.text!.count > 0 {
        //            datePicker.setDate(self.geteTimeClockDateFromStringTime(stringdate: activeTextField.text!), animated:true)
        //        }
        
        self.lunchDetailsPopView.endEditing(true)
        self.showPicker(ampm:false)
    }
}
extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
extension OrderDetailViewController:DateTimePickerDelegate
{
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        print(picker.selectedDateString)
    }
}
