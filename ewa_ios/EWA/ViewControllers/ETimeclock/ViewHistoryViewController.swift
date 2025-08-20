//
//  ViewHistoryViewController.swift
//  EWA
//
//  Created by NFC India on 24/12/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import FSCalendar
//import MXSegmentedPager


class ViewHistoryViewController: UIViewController{
    
    //MXSegmentedPagerDelegate
    //object references
    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var tableTop: NSLayoutConstraint! // 32 to 0
    @IBOutlet weak var wouldYouLikeButton: UIButton!
    @IBOutlet weak var orderConformationLabel: UILabel!
    @IBOutlet var orderconformationView: UIView!
    @IBOutlet weak var popCheckBox: UIButton!
    @IBOutlet weak var tableBottomHeight: NSLayoutConstraint!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var enterNewDayButton: UIButton!
    @IBOutlet weak var ordersList: UITableView!
    @IBOutlet weak var dateView: ShadowView!
    @IBOutlet weak var calnederView: FSCalendar!
    @IBOutlet var cView: UIView!
    @IBOutlet weak var fromTextField: UITextField!
    var IsWarningConfirmed = String()
    @IBOutlet weak var submitTimeSheetButton: ShadowButton!
    let dateFormat = "MM/dd/yyyy"
    var acceptedTerms = false
    //variable declarations
    var historyData:JSON = JSON.null
    var timeslipsData:JSON = JSON.null
    var historyList = [HistoryObject]()
    var blurEffect = UIBlurEffect()
    var blurEffectView = UIVisualEffectView()
    var isEdit = Bool()
    var activeField = UITextField()
    var selectedHistoryObj = HistoryObject.init(orderID:"", date:"", loginStart:"", lunchOut:"", lunchReturn:"", logoutFinish:"", canID:"", sent:"", comments:"",timeID: "", isEtcCheck: "", isNote: "", isEdit: "", ETCLogId: "",ColorCode:"",IsSubmitted:"",ErrorMessage:"",IsvalidToSubmit:"",ConflictMessage:"", IsMultipleLunch: "",lunchOut2: "",lunchReturn2: "")
    var fromdate = Date()
    var todate = Date()
    var fromOldValue = String()
    var toOldValue = String()
    var loginstr = String()
    var logoutstr = String()
    var lunchoutstr = String()
    var lunchoutstr2 = String()
    var lunchreturnstr2 = String()
    var lunchreturnstr = String()
    var selectedEtimeLogIds = [String]()
    var submittedIDs = [String]()
    var ETCLogIds = NSMutableArray()
    @IBOutlet weak var finalpopViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var popTableView: UITableView!
    @IBOutlet var finalConfirmationPopView: UIView!
    
    @IBOutlet weak var conformationHeaderLabel: UILabel!
    let Legend_Tbl_Tag = 1001
    var infoViewColorsArray = NSMutableArray()
    var PleaseSelectMessage = String()
    var NoOrdersMessage = String()
    var starTimes = NSMutableArray()
    var endTimes   = NSMutableArray()
    var lunchHours  = NSMutableArray()
    var totalTimeInHours = NSMutableArray()
    var isApiCalled = Bool()
    var WarningStatus = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wouldYouLikeButton.titleLabel?.textAlignment = .center
        wouldYouLikeButton.titleLabel?.numberOfLines = 0
        tableTop.constant = 30 //30 here
        infoButton.isHidden = false
        
        let dateww = Date().description(with: .current)   // "Monday, February 9, 2015 at 05:47:51 Brasilia Summer Time"
        IsWarningConfirmed = "false"
        WarningStatus = "0"
        print(dateww)
        

    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "History"
        super.viewWillAppear(animated)
        submitTimeSheetButton.layer.cornerRadius = 3.0
        //  submitTimeSheetButton.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        enterNewDayButton.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        configure_Calender ()
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectIndex(_:)), name: Notification.Name(rawValue: "didSelectIndex"), object: nil)
        popTableView.delegate = self
        popTableView.dataSource = self
        popTableView.tableFooterView = UIView()
        if Constants.naviLiteral.count > 0 {
            Constants.naviLiteral = ""
        }

        getHistoryOrders() //for default loading its added vivek
       
        
    }
    
    
    @objc func didSelectIndex(_ notification: Notification) {
        if ((notification.object) != nil){
            print("Selected Index : \(notification.object as! Int)")
            let indd = notification.object as! Int
            if indd == 1 {
                UserDefaults.standard.set("1", forKey: "eTimeClock")
                tableBottomHeight.constant = 0
                cView.removeFromSuperview()
                if isApiCalled == false {
                    getHistoryOrders()
                }
            }
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let index = UserDefaults.standard.object(forKey: "eTimeClock") as!  String
        if index == "1" {
            if isApiCalled == false {
                getHistoryOrders()
            }
        }

    }
    func loadFinalConfirmationPopup(){
        acceptedTerms = false
        popCheckBox.setImage(UIImage.init(named: "unchecked.png"), for: .normal)
        updateWithETCData()
        finalConfirmationPopView.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
        
        if  UIScreen.main.bounds.size.height < 600 {
            finalpopViewHeight.constant =  UIScreen.main.bounds.size.height - 40
        }
        else {
            finalpopViewHeight.constant = 600
        }
        UIApplication.getTopMostViewController()!.view.addSubview(finalConfirmationPopView)
        //  UIApplication.getTopMostViewController()!.view.bringSubview(toFront:finalConfirmationPopView)
        popTableView.reloadData()
    }
    
    //MARK:- For eTimeClock Only
    func updateWithETCData() {
        self.starTimes = ["","","","","","",""]
        self.endTimes = ["","","","","","",""]
        self.lunchHours = ["","","","","","",""]
        self.totalTimeInHours = ["","","","","","",""]
        self.ETCLogIds = ["","","","","","",""]
        for etcObj in 0..<timeslipsData["lstEtcOrderDetailsList"].count{
            
            let strttime  =   timeslipsData["lstEtcOrderDetailsList"][etcObj]["StartTime"].stringValue
            let enddtime =  timeslipsData["lstEtcOrderDetailsList"][etcObj]["EndTime"].stringValue
            
            if timeslipsData["lstEtcOrderDetailsList"][etcObj]["OrderDay"].stringValue == "Monday"{
                starTimes.replaceObject(at: 0, with: strttime)
                endTimes.replaceObject(at: 0, with: enddtime)
                if timeslipsData["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue.count > 0 {
                    let lunch = roundLunchTime(Double(timeslipsData["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue)!)
                    lunchHours.replaceObject(at: 0, with: lunch)
                }
                else {
                    lunchHours.replaceObject(at: 0, with: "")
                }
                let hour =  timeslipsData["lstEtcOrderDetailsList"][etcObj]["Hour"].doubleValue
                
                totalTimeInHours.replaceObject(at: 0, with: String(format:"%.2f", hour))
                ETCLogIds.replaceObject(at: 0, with: timeslipsData["lstEtcOrderDetailsList"][etcObj]["LogId"].stringValue)
            }
            else if timeslipsData["lstEtcOrderDetailsList"][etcObj]["OrderDay"].stringValue == "Tuesday"{
                
                starTimes.replaceObject(at: 1, with: strttime)
                endTimes.replaceObject(at: 1, with: enddtime)
                if timeslipsData["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue.count > 0 {
                    let lunch = roundLunchTime(Double(timeslipsData["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue)!)
                    lunchHours.replaceObject(at: 1, with: lunch)
                }
                else {
                    lunchHours.replaceObject(at: 1, with: "")
                }
                let hour =  timeslipsData["lstEtcOrderDetailsList"][etcObj]["Hour"].doubleValue
                
                totalTimeInHours.replaceObject(at: 1, with: String(format:"%.2f", hour))
                ETCLogIds.replaceObject(at: 1, with: timeslipsData["lstEtcOrderDetailsList"][etcObj]["LogId"].stringValue)
            }
            else if timeslipsData["lstEtcOrderDetailsList"][etcObj]["OrderDay"].stringValue == "Wednesday"{
                
                starTimes.replaceObject(at: 2, with: strttime)
                endTimes.replaceObject(at: 2, with: enddtime)
                if timeslipsData["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue.count > 0 {
                    let lunch = roundLunchTime(Double(timeslipsData["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue)!)
                    lunchHours.replaceObject(at: 2, with: lunch)
                }
                else {
                    lunchHours.replaceObject(at: 2, with: "")
                }
                let hour =  timeslipsData["lstEtcOrderDetailsList"][etcObj]["Hour"].doubleValue
                
                totalTimeInHours.replaceObject(at: 2, with: String(format:"%.2f", hour))
                ETCLogIds.replaceObject(at: 2, with: timeslipsData["lstEtcOrderDetailsList"][etcObj]["LogId"].stringValue)
            }
            else if timeslipsData["lstEtcOrderDetailsList"][etcObj]["OrderDay"].stringValue == "Thursday"{
                
                starTimes.replaceObject(at: 3, with: strttime)
                endTimes.replaceObject(at: 3, with: enddtime)
                if timeslipsData["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue.count > 0 {
                    let lunch = roundLunchTime(Double(timeslipsData["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue)!)
                    lunchHours.replaceObject(at: 3, with: lunch)
                }
                else {
                    lunchHours.replaceObject(at: 3, with: "")
                }
                let hour =  timeslipsData["lstEtcOrderDetailsList"][etcObj]["Hour"].doubleValue
                
                totalTimeInHours.replaceObject(at: 3, with: String(format:"%.2f", hour))
                ETCLogIds.replaceObject(at: 3, with: timeslipsData["lstEtcOrderDetailsList"][etcObj]["LogId"].stringValue)
            }
            else if timeslipsData["lstEtcOrderDetailsList"][etcObj]["OrderDay"].stringValue == "Friday"{
                
                starTimes.replaceObject(at: 4, with: strttime)
                endTimes.replaceObject(at: 4, with: enddtime)
                if timeslipsData["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue.count > 0 {
                    let lunch = roundLunchTime(Double(timeslipsData["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue)!)
                    lunchHours.replaceObject(at: 4, with: lunch)
                }
                else {
                    lunchHours.replaceObject(at: 4, with: "")
                }
                let hour =  timeslipsData["lstEtcOrderDetailsList"][etcObj]["Hour"].doubleValue
                
                totalTimeInHours.replaceObject(at: 4, with: String(format:"%.2f", hour))
                ETCLogIds.replaceObject(at: 4, with: timeslipsData["lstEtcOrderDetailsList"][etcObj]["LogId"].stringValue)
            }
            else if timeslipsData["lstEtcOrderDetailsList"][etcObj]["OrderDay"].stringValue == "Saturday"{
                
                starTimes.replaceObject(at: 5, with: strttime)
                endTimes.replaceObject(at: 5, with: enddtime)
                if timeslipsData["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue.count > 0 {
                    let lunch = roundLunchTime(Double(timeslipsData["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue)!)
                    lunchHours.replaceObject(at: 5, with: lunch)
                }
                else {
                    lunchHours.replaceObject(at: 5, with: "")
                }
                let hour =  timeslipsData["lstEtcOrderDetailsList"][etcObj]["Hour"].doubleValue
                
                totalTimeInHours.replaceObject(at: 5, with: String(format:"%.2f", hour))
                ETCLogIds.replaceObject(at: 5, with: timeslipsData["lstEtcOrderDetailsList"][etcObj]["LogId"].stringValue)
            }
            else if timeslipsData["lstEtcOrderDetailsList"][etcObj]["OrderDay"].stringValue == "Sunday"{
                
                starTimes.replaceObject(at: 6, with: strttime)
                endTimes.replaceObject(at: 6, with: enddtime)
                if timeslipsData["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue.count > 0 {
                    let lunch = roundLunchTime(Double(timeslipsData["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue)!)
                    lunchHours.replaceObject(at: 6, with: lunch)
                }
                else {
                    lunchHours.replaceObject(at: 6, with: "")
                }
                let hour =  timeslipsData["lstEtcOrderDetailsList"][etcObj]["Hour"].doubleValue
                
                totalTimeInHours.replaceObject(at: 6, with: String(format:"%.2f", hour))
                ETCLogIds.replaceObject(at: 6, with: timeslipsData["lstEtcOrderDetailsList"][etcObj]["LogId"].stringValue)
            }
        }
        self.popTableView.reloadData()
    }
    func getCorrectTimeFormat(string: String) -> String{
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "h:mma" // This formate is input formated .
        let formateDate = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "hh:mm a" // Output Formated
        return dateFormatter.string(from: formateDate)
    }
    
    func roundLunchTime(_ value: Double) -> String
    {
        
        //        let toNearest = timeslipsData["lunchIntervel"].doubleValue //15.0
        //        if toNearest>0 {
        //            return String(format: "%.0f", round(value / toNearest) * toNearest)
        //        }
        //        else {
        //            return String(format: "%.0f",value)
        //        }
        return String(format: "%.0f",value)
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
        self.setUpCalendarForWeekends()
    }
    func setUpCalendarForWeekends(){
        
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        
        var result = ""
        
        let todayDate = Date()
        // formatter.locale =  Locale(identifier: "en_US")
        
        let todayString = formatter.string(from: todayDate)
        let todaysDay = self.getDayOfWeek(today: todayString)
        
        if todaysDay == "Sunday" {
            result = formatter.string(from: todayDate)
        }else{
            let date = Date.today().next(.sunday)      //Date().sundayOfWeek
            
            let  endOfWeekString = formatter.string(from: date)
            result =  endOfWeekString
            
        }
        
        
        if Constants.ETCSelectedWeekend.count > 0 {
            let date = self.convertDateStringToDefaultDate(dateString: Constants.ETCSelectedWeekend, formatString: dateFormat)
            self.calnederView.select(date)
            self.fromTextField.text = Constants.ETCSelectedWeekend
        }
        else {
            let date = self.convertDateStringToDefaultDate(dateString: result, formatString: dateFormat)
            self.calnederView.select(date)
            self.fromTextField.text = result
        }
        
    }
    func convertDateStringToDefaultDate(dateString: String,formatString: String) -> Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = formatString//"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        let date = dateFormatter.date (from: dateString)
        return date!
    }
    
    //MARK:- Catching the device orentation
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            cView.frame = CGRect.init(x:0, y:0, width: self.view.bounds.size.width, height:self.view.bounds.size.height)
            finalConfirmationPopView.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
            if  UIScreen.main.bounds.size.height < 600 {
                finalpopViewHeight.constant =  UIScreen.main.bounds.size.height - 40
            }
            else {
                finalpopViewHeight.constant = 600
            }
            orderconformationView.frame = CGRect(x: 10, y:self.view.bounds.size.height/2-140, width:self.view.bounds.size.width-20, height:180)
        case .landscapeLeft:
            text="LandscapeLeft"
            cView.frame = CGRect.init(x:0, y:0, width: self.view.bounds.size.width, height:self.view.bounds.size.height)
            finalConfirmationPopView.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
            if  UIScreen.main.bounds.size.height < 600 {
                finalpopViewHeight.constant =  UIScreen.main.bounds.size.height - 40
            }
            else {
                finalpopViewHeight.constant = 600
            }
            orderconformationView.frame = CGRect(x: 40, y:10, width:self.view.bounds.size.width-80, height:180)
        case .landscapeRight:
            text="LandscapeRight"
            cView.frame = CGRect.init(x:0, y:0, width: self.view.bounds.size.width, height:self.view.bounds.size.height)
            finalConfirmationPopView.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
            if  UIScreen.main.bounds.size.height < 600 {
                finalpopViewHeight.constant =  UIScreen.main.bounds.size.height - 40
            }
            else {
                finalpopViewHeight.constant = 600
            }
            orderconformationView.frame = CGRect(x: 40, y:10, width:self.view.bounds.size.width-80, height:180)
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
    }
    
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
    
    //this method is used to create the rightside view to the textField
    func setRightViewIcon(textField:UITextField) {
        
        let btnView = UIButton(frame: CGRect(x: 0, y: 5, width:30, height:30))
        btnView.setImage(UIImage(named:"icons8-calendar.png"), for: .normal)
        btnView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
        btnView.tag = textField.tag
        textField.rightViewMode = .always
        textField.rightView = btnView
        
        
    }
    
    
    
    //function to get the orders history
    func getHistoryOrders()
    {
        print("Content Offset:", ordersList.contentOffset)

        if ConnectionCheck.isConnectedToNetwork()
        {
            isApiCalled = true
            fromOldValue = fromTextField.text!
            toOldValue = ""
            let params = ["CandidateId":UserDefaults.standard.object(forKey:"cID") as! String,"WeekendDate":fromTextField.text!] as [String : Any]
            print(params)
            self.showLoaderForThisScreen()
            ServerService.getViewHistory(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.gethistoryData(response:))
        }
        else
        {
            self.hideLoaderForThisScreen()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            
            
        }
    }
    
    // response from the server
    func gethistoryData(response:AnyObject)->()
    {
        isApiCalled = false
        print (response)
        historyList.removeAll()
        self.hideLoaderForThisScreen()
        historyData = response as! JSON
        print("****** historyData data is ************\n",historyData)
        
        if historyData["SubmitTimesheet"].stringValue == "True"{
            submitTimeSheetButton.isHidden = false
        }
        else {
            submitTimeSheetButton.isHidden = true
        }
        
        if historyData["isEnterNewDayShow"].stringValue == "0" {
            tableBottomHeight.constant = 0 //0 here
        }
        else {
            tableBottomHeight.constant = 50
        }
        enterNewDayButton.setTitle(historyData["EnterNewDay"].stringValue, for: .normal)
        selectedEtimeLogIds.removeAll()
        submittedIDs.removeAll()
        infoViewColorsArray.removeAllObjects()
        
        if historyData["ColourText"].arrayValue.count>0 {
            
            let colourTextArray = historyData["ColourText"].array
            
            for dict in colourTextArray! {
                if infoViewColorsArray.count == historyData["ColourText"].arrayValue.count {}else{
                    infoViewColorsArray.add(["Text":dict["Text"].stringValue,"Color":dict["Color"].stringValue])
                }
            }
            
        }
        //infoViewColorsArray.removingDuplicates(byKey: { $0.uid })
        // infoViewColorsArray.removingDuplicates
        if historyData["LstETimeClockViewHistory"].arrayValue.count>0
        {
            for his in 0..<historyData["LstETimeClockViewHistory"].arrayValue.count
            {
                if historyData["LstETimeClockViewHistory"][his]["IsvalidToSubmit"].stringValue == "1" && historyData["LstETimeClockViewHistory"][his]["IsSubmitted"].stringValue == "0"{
                    selectedEtimeLogIds.append(historyData["LstETimeClockViewHistory"][his]["ETCLogId"].stringValue)
                }
                if  historyData["LstETimeClockViewHistory"][his]["IsSubmitted"].stringValue == "1"{
                    submittedIDs.append(historyData["LstETimeClockViewHistory"][his]["ETCLogId"].stringValue)
                }
                
                
                if historyData["LstETimeClockViewHistory"][his]["Log_In"].stringValue == "0001-01-01T00:00:00"{
                    loginstr = ""
                }
                else{
                    loginstr = historyData["LstETimeClockViewHistory"][his]["Log_In"].stringValue
                }
                if historyData["LstETimeClockViewHistory"][his]["Log_Out"].stringValue == "0001-01-01T00:00:00"{
                    logoutstr = ""
                }
                else{
                    logoutstr = historyData["LstETimeClockViewHistory"][his]["Log_Out"].stringValue
                }
                if historyData["LstETimeClockViewHistory"][his]["Lunch_Out"].stringValue == "0001-01-01T00:00:00"{
                    lunchoutstr = ""
                }
                else{
                    lunchoutstr = historyData["LstETimeClockViewHistory"][his]["Lunch_Out"].stringValue
                }
                if historyData["LstETimeClockViewHistory"][his]["Lunch_In"].stringValue == "0001-01-01T00:00:00"{
                    lunchreturnstr = ""
                }
                else{
                    lunchreturnstr = historyData["LstETimeClockViewHistory"][his]["Lunch_In"].stringValue
                }
                
                if historyData["LstETimeClockViewHistory"][his]["Lunch_Out2"].stringValue != "0001-01-01T00:00:00" && historyData["LstETimeClockViewHistory"][his]["Lunch_Out2"].stringValue.count > 0 {
                    lunchoutstr2 = historyData["LstETimeClockViewHistory"][his]["Lunch_Out2"].stringValue
                    
                }
                else{
                    lunchoutstr2 = ""
                }
                if historyData["LstETimeClockViewHistory"][his]["Lunch_In2"].stringValue != "0001-01-01T00:00:00" && historyData["LstETimeClockViewHistory"][his]["Lunch_In2"].stringValue.count > 0 {
                    lunchreturnstr2 = historyData["LstETimeClockViewHistory"][his]["Lunch_In2"].stringValue
                    
                }
                else{
                    lunchreturnstr2 = ""
                }
                ordersList.backgroundColor = .white // this determine background color of orderslist table view
                self.errorLabel.text = ""
                let history = HistoryObject.init(
                    orderID: historyData["LstETimeClockViewHistory"][his]["OrderId"].stringValue,
                    date:historyData["LstETimeClockViewHistory"][his]["workingDate"].stringValue,
                    loginStart: loginstr,
                    lunchOut: lunchoutstr,
                    lunchReturn: lunchreturnstr,
                    logoutFinish: logoutstr, canID:historyData["LstETimeClockViewHistory"][his]["Cand_id"].stringValue,
                    sent:historyData["LstETimeClockViewHistory"][his]["Sent"].stringValue,
                    comments:historyData["LstETimeClockViewHistory"][his]["Comments"].stringValue,
                    timeID: historyData["LstETimeClockViewHistory"][his]["TimeId"].stringValue, isEtcCheck: historyData["LstETimeClockViewHistory"][his]["isETCcheck"].stringValue, isNote: historyData["LstETimeClockViewHistory"][his]["isNote"].stringValue, isEdit: historyData["LstETimeClockViewHistory"][his]["isEdit"].stringValue, ETCLogId: historyData["LstETimeClockViewHistory"][his]["ETCLogId"].stringValue,ColorCode:historyData["LstETimeClockViewHistory"][his]["ColorCode"].stringValue,IsSubmitted:historyData["LstETimeClockViewHistory"][his]["IsSubmitted"].stringValue,ErrorMessage:historyData["LstETimeClockViewHistory"][his]["ErrorMessage"].stringValue,IsvalidToSubmit:historyData["LstETimeClockViewHistory"][his]["IsvalidToSubmit"].stringValue,ConflictMessage:historyData["LstETimeClockViewHistory"][his]["ConflictMessage"].stringValue, IsMultipleLunch: historyData["LstETimeClockViewHistory"][his]["IsMultipleLunch"].stringValue,lunchOut2: lunchoutstr2,lunchReturn2: lunchreturnstr2)
                
                historyList.append(history)
            }
            
            
        }
        else
        {
            if historyData["History_Message"].stringValue.count>0{
                self.errorLabel.text = historyData["History_Message"].stringValue
            }
            else {
                self.errorLabel.text = "No data available"
            }
            ordersList.backgroundColor = .clear
        }
        
        ordersList.reloadData()

    }
    //MARK:- CompareDates
    func isValidDates() -> Bool{
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = "MM/dd/yyyy"
        fromdate = formatter.date(from: fromTextField.text!)!
        //  todate = formatter.date(from: toTextField.text!)!
        if fromdate > todate{
            ServerService.ShowAlertMessage(ErrorMessage:"", title: "From Date should not be greater than To Date", view:self)
            fromTextField.text  = fromOldValue
            //  toTextField.text  = toOldValue
            return false
        }
        else if fromdate == todate {
            ServerService.ShowAlertMessage(ErrorMessage:"", title: "From Date and To Date should not be same", view:self)
            fromTextField.text  = fromOldValue
            //toTextField.text  = toOldValue
            return false
        }
        else {
            return true
        }
        
    }
    
    //MARK:- EnterNewDayAction
    @IBAction func enterNewDayAction(_ sender: Any) {
        isEdit = false
        let vc = UIStoryboard.init(name:"Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"EnterND") as! EnterNewDateViewController
        Constants.ETCSelectedWeekend = fromTextField.text!
        Constants.eTimeClockOrderID = ""
        Constants.ETCcheck = ""
        Constants.ETCIsMultipleLunch = ""
        vc.historyData = self.historyData
        vc.hisObject = selectedHistoryObj
        self.navigationController?.pushViewController(vc, animated: true)
        
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
    
    //MARK:- NotesButtoAction
    @objc func notesButtonClicked(_ sender: UIButton){
        
        
        if historyList[sender.tag].comments != nil && historyList[sender.tag].comments.count>0 {
            ServerService.ShowAlertMessage(ErrorMessage:"", title: historyList[sender.tag].comments, view:self)
        }
        else{
            ServerService.ShowAlertMessage(ErrorMessage:"", title: "No Comments Available", view:self)
        }
    }
    
    //MARK:- EditButtonAction
    @objc func editButtonClicked(_ sender: UIButton){
        selectedHistoryObj = historyList[sender.tag]
        isEdit = true
        let vc = UIStoryboard.init(name:"Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"EditEtimeClock") as! EditEtimeClock
        Constants.ETCSelectedWeekend = fromTextField.text!
        vc.historyData = self.historyData
        vc.hisObject = selectedHistoryObj
        vc.IsFromEditTimsheet = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
//        ordersList.scrollsToTop = false
    }
    
    //MARK:- SubmitTimeSheetAction
    
    @IBAction func submitTimeSheetClicked(_ sender: ShadowButton) {
        /*
         let screen = self.storyboard?.instantiateViewController(withIdentifier: "Enter Timeslips") as! EnterTimeSlipsViewController
         screen.fromETC = "1"
         screen.etcWeekend = self.fromTextField.text!
         self.navigationController?.pushViewController(screen, animated: true)
         */
        if selectedEtimeLogIds.count > 0 {
            getTheTimePendingTimeSlips()
        }
        else {
            
            print(historyData["PleaseSelectMessage"].stringValue)
            print(historyData["NoOrdersMessage"].stringValue)
            if historyList.count == submittedIDs.count {
                if historyData["NoOrdersMessage"].stringValue.count > 0 {
                    NoOrdersMessage = historyData["NoOrdersMessage"].stringValue
                }
                else{
                    NoOrdersMessage = "You don't have pending time slips for this weekend. You have already submitted the time slips"
                }
                ServerService.ShowAlertMessage(ErrorMessage:"", title: NoOrdersMessage, view:self)
            }
            else {
                if historyData["PleaseSelectMessage"].stringValue.count > 0 {
                    PleaseSelectMessage = historyData["PleaseSelectMessage"].stringValue
                }
                else{
                    PleaseSelectMessage = "Please select the orders to submit the time sheet"
                }
                ServerService.ShowAlertMessage(ErrorMessage:"", title: PleaseSelectMessage, view:self)
            }
        }
    }
    
    
    func getTheTimePendingTimeSlips () {
        if ConnectionCheck.isConnectedToNetwork()
        {
            self.showLoaderForThisScreen()
            var params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"WeekendDate":fromTextField.text!,"OrderId":"","Division":"",
                                          "ETCLogIdList":"\(selectedEtimeLogIds.joined(separator: ","))"]
            params.updateValue("1", forKey: "EtcChecked")
            print(params)
            ServerService.EtimeClockEnterTimeSlips(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseForDetail(response:))
        }
        else
        {
            //ANLoader.hide()
            self.hideLoaderForThisScreen()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
    }
    
    func getresponseForDetail(response:AnyObject)->()
    {
        self.hideLoaderForThisScreen()
        timeslipsData = response as! JSON
        print(response)
        if timeslipsData.isEmpty
        {
            print("empty")
            //timeSlipTableView.isUserInteractionEnabled = true
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else
        {
            if timeslipsData["Status"].stringValue == "Success" {
                loadFinalConfirmationPopup()
                popTableView.reloadData()
            }
            else {
                ServerService.ShowAlertMessage(ErrorMessage:timeslipsData["ETCMessage"].stringValue, title:"", view:self)
            }
        }
        
    }
    
    @IBAction func correctAction(_ sender: UIButton) {
        if acceptedTerms {
//            if ConnectionCheck.isConnectedToNetwork()
//            {
//                self.showLoaderForThisScreen()
//                var params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"WeekendDate":fromTextField.text!,"OrderId":"","Division":"",
//                                              "ETCLogIdList":"\(selectedEtimeLogIds.joined(separator: ","))"]
//                params.updateValue("1", forKey: "EtcChecked")
//                print(params)
//                ServerService.ETimeClockSubmitTimeSlip(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseForSubmitTimeSheet(response:))
//            }
//            else
//            {
//                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
//            }
            self.methodToSubmit()
        }
        else {
            let attributedString = NSAttributedString(string: "If you do not agree to the statement below, you can't submit your hours through this system. Contact your personal representative to discuss this further.", attributes: [
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), //your font here
                NSAttributedStringKey.foregroundColor : UIColor.red
            ])
            let alert = UIAlertController(title: "", message: "",  preferredStyle: .alert)
            alert.setValue(attributedString, forKey: "attributedTitle")
            let ok = UIAlertAction(title: "Ok",
                                   style: .default) { (action: UIAlertAction!) -> Void in
            }
            alert.addAction(ok)
            present(alert,animated: true,completion: nil)
        }
        
    }
    
    func getresponseForSubmitTimeSheet(response:AnyObject)->()
    {
        self.hideLoaderForThisScreen()
        let submittTimeslipsData = response as! JSON
        print(response)
        if submittTimeslipsData.isEmpty
        {
            print("empty")
            IsWarningConfirmed = "false"
            WarningStatus = "0"
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else
        {
            if submittTimeslipsData["warningmessage"].stringValue == "true"
            {
                let attributedString = NSAttributedString(string:submittTimeslipsData["ErrorMessage"].stringValue, attributes: [
                    NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), //your font here
                    NSAttributedStringKey.foregroundColor : UIColor.black //red
                ])
                let alert = UIAlertController(title: "", message: "",  preferredStyle: .alert)
                alert.setValue(attributedString, forKey: "attributedTitle")
                let ok = UIAlertAction(title: "YES",
                                       style: .default) { (action: UIAlertAction!) -> Void in
                    OperationQueue.main.addOperation({
                        self.IsWarningConfirmed = "true"
                        self.WarningStatus = submittTimeslipsData["WarningStatus"].stringValue
                        self.methodToSubmit()
                    })
                    
                    
                }
                let cancel = UIAlertAction(title: "NO",
                                           style: .destructive) { (action: UIAlertAction!) -> Void in
                    self.IsWarningConfirmed = "false"
                    self.WarningStatus = "0"
                }
                alert.addAction(cancel)
                alert.addAction(ok)
                present(alert,animated: true,completion: nil)
            }
            else if submittTimeslipsData["Status"].stringValue == "true" {
                IsWarningConfirmed = "false"
                WarningStatus = "0"
                self.selectedEtimeLogIds.removeAll()
                
                if UIDevice.current.orientation == .portrait {
                    orderconformationView.frame = CGRect(x: 10, y:self.view.bounds.size.height/2-140, width:self.view.bounds.size.width-20, height:180)
                }
                else {
                orderconformationView.frame = CGRect(x: 40, y:10, width:self.view.bounds.size.width-80, height:180)
                }
                    
                
                self.finalConfirmationPopView.removeFromSuperview()
               
                
                orderConformationLabel.text = "Timeslip(s) Entered Sucessfully Your confirmation number is \(submittTimeslipsData["ConfirmationNo"].stringValue)"
                blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
                blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.frame = view.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                blurEffectView.contentView.addSubview(orderconformationView)
                view.addSubview(blurEffectView)
                
            }
            else {
                IsWarningConfirmed = "false"
                WarningStatus = "0"
                ServerService.ShowAlertMessage(ErrorMessage: "", title:submittTimeslipsData["ErrorMessage"].stringValue, view: self)
            }
        }
    }
    
    
    func methodToSubmit() {
        if ConnectionCheck.isConnectedToNetwork()
        {
            self.showLoaderForThisScreen()
            var params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"WeekendDate":fromTextField.text!,"OrderId":"","Division":"",
                                          "ETCLogIdList":"\(selectedEtimeLogIds.joined(separator: ","))",
                                          "WarningStatus":WarningStatus,
                                          "IsWarningConfirmed":self.IsWarningConfirmed]
            params.updateValue("1", forKey: "EtcChecked")
            print(params)
            ServerService.ETimeClockSubmitTimeSlip(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseForSubmitTimeSheet(response:))
        }
        else
        {
            self.hideLoaderForThisScreen()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
    }
    
    @IBAction func inCorrectAction(_ sender: UIButton) {
        
        finalConfirmationPopView.removeFromSuperview()
    }
    
    //MARK:- Pop Check Buttons Clicked
    
    
    @IBAction func popAuthCheckBoxClicked(_ sender: UIButton) {
        
        if popCheckBox.currentImage == UIImage.init(named: "check.png") {
            acceptedTerms = false
            popCheckBox.setImage(UIImage.init(named: "unchecked.png"), for: .normal)
        }
        else {
            acceptedTerms = true
            popCheckBox.setImage(UIImage.init(named: "check.png"), for: .normal)
        }
    }
    @objc func cellCheckBoxCLicked(_ sender: UIButton) {
        
        if selectedEtimeLogIds.contains(historyList[sender.tag].ETCLogId) {
            if let index = selectedEtimeLogIds.firstIndex(of: historyList[sender.tag].ETCLogId) {
                selectedEtimeLogIds.remove(at: index)
            }
        }
        else {
            if historyList[sender.tag].IsvalidToSubmit == "0" {
                ServerService.ShowAlertMessage(ErrorMessage:"", title: historyList[sender.tag].ErrorMessage, view:self)
                
            }
            else {
                selectedEtimeLogIds.append(historyList[sender.tag].ETCLogId)
            }
        }
        ordersList.reloadData()
    }
    //function to get date
    func getFormattedDate(string: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // This formate is input formated .
        let formateDate = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "dd  EEE" // Output Formated
        return dateFormatter.string(from: formateDate)
    }
    
    //MARK:- TimePickerActions
    @IBAction func EnterAnotherTimeSlip(_ sender: UIButton) {
        
        blurEffectView.removeFromSuperview()
        self.getHistoryOrders()
    }
    
    @IBAction func orderConformationCancelAction(_ sender: UIButton) {
        blurEffectView.removeFromSuperview()
        self.getHistoryOrders()
    }
    
    @IBAction func infoIconClicked(_ sender: UIButton) {
        
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
        tableView.backgroundColor = UIColor.white
        tableView.separatorInset = .zero
        tableView.separatorStyle = .none
        alrController.view.addSubview(tableView)
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alrController.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(rectHeight+60))
        alrController.view.addConstraint(height);
        
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: {(alert: UIAlertAction!) in print("OK")
            alrController.dismiss(animated: true, completion: nil)
        })
        
        alrController.addAction(cancelAction)
        //        let backView = alrController.view.subviews.last?.subviews.last
        //            backView?.layer.cornerRadius = 10.0
        //            backView?.backgroundColor = UIColor.white
        
        let FirstSubview = alrController.view.subviews.first
        let AlertContentView = FirstSubview?.subviews.first
        for subview in (AlertContentView?.subviews)! {
            subview.backgroundColor = UIColor.init(red: 242/255, green: 242/255, blue: 247/55, alpha: 1.0)
            subview.layer.cornerRadius = 10
            subview.alpha = 1
            subview.layer.borderWidth = 0
            subview.layer.borderColor = UIColor.black.cgColor
        }
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
    
    @objc func editTimeClicked(_ sender: UIButton) {
        if sender.currentImage ==  UIImage.init(named: "editd")  {
            print("Dummy Clicked")
        }
        else {
            print("Move To Corresponding Edit Screen")
            
            if ConnectionCheck.isConnectedToNetwork()
            {
                self.showLoaderForThisScreen()
                let params:[String:Any] = ["ETCLogId":"\(ETCLogIds[sender.tag])"]
                print(params)
                ServerService.getParticularDayData(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: self.getresponse(response:))
                
            }
            else
            {
                self.hideLoaderForThisScreen()
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            }
        }
    }
    func getresponse(response:AnyObject)->()
    {
        print (response)
        self.hideLoaderForThisScreen()
        let ordersObject = response as! JSON
        print("****** Order Deatais is ************\n",ordersObject)
        if ordersObject["OrderId"].stringValue == "0" || ordersObject["OrderId"].stringValue.count < 2 {
            ServerService.ShowAlertMessage(ErrorMessage:"", title:"We were unable to get data, please try again after some time", view:self)
        }
        else {
            finalConfirmationPopView.removeFromSuperview()
            selectedHistoryObj = HistoryObject.init(
                orderID: ordersObject["OrderId"].stringValue,
                date:ordersObject["workingDate"].stringValue,
                loginStart: ordersObject["Log_In"].stringValue,
                lunchOut: ordersObject["Lunch_Out"].stringValue,
                lunchReturn: ordersObject["Lunch_In"].stringValue,
                logoutFinish: ordersObject["Log_Out"].stringValue, canID:ordersObject["Cand_id"].stringValue,
                sent:ordersObject["Sent"].stringValue,
                comments:ordersObject["Comments"].stringValue,
                timeID: ordersObject["TimeId"].stringValue, isEtcCheck: ordersObject["isETCcheck"].stringValue, isNote: ordersObject["isNote"].stringValue, isEdit: ordersObject["isEdit"].stringValue, ETCLogId: ordersObject["ETCLogId"].stringValue,ColorCode:ordersObject["ColorCode"].stringValue,IsSubmitted:ordersObject["IsSubmitted"].stringValue,ErrorMessage:ordersObject["ErrorMessage"].stringValue,IsvalidToSubmit:ordersObject["IsvalidToSubmit"].stringValue,ConflictMessage:ordersObject["ConflictMessage"].stringValue, IsMultipleLunch: ordersObject["IsMultipleLunch"].stringValue,lunchOut2: ordersObject["Lunch_Out2"].stringValue,lunchReturn2: ordersObject["Lunch_In2"].stringValue)
            isEdit = true
            let vc = UIStoryboard.init(name:"Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"EditEtimeClock") as! EditEtimeClock
            Constants.ETCSelectedWeekend = fromTextField.text!
            vc.historyData = self.historyData
            vc.hisObject = selectedHistoryObj
            vc.IsFromEditTimsheet = 1
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getCellIdentifier(type: String) -> String {
        if type == "0" {
            return "HistoryTableViewCell"
        }
        else {
            return "HistoryTableViewCell1"
        }
        
    }
    
}
//END OF CLASS


//MARK:- EXTENSIONS
extension ViewHistoryViewController:UITableViewDelegate,UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == ordersList || tableView.tag == Legend_Tbl_Tag {
            return 1
        }
        else {
            return 3
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == Legend_Tbl_Tag {
            return infoViewColorsArray.count
        }
        else {
            if tableView == ordersList {
                return historyList.count
            }
            else {
                if section == 1 {
                    return timeslipsData["WeekDays"].arrayValue.count
                }
                else {
                    return 1
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  tableView.tag == Legend_Tbl_Tag{
            let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell") ?? UITableViewCell(style: .default, reuseIdentifier: "timeCell")
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.numberOfLines = 0
            cell.contentView.backgroundColor = .white
            cell.imageView?.image = nil
            if infoViewColorsArray.count>0 {
                let colorDict = infoViewColorsArray[indexPath.row] as! NSDictionary
                let text = colorDict["Text"] as? String
                let bgColor = colorDict["Color"] as? String
                
                cell.contentView.backgroundColor = UIColor(hexString:bgColor!)
                cell.textLabel?.textColor = UIColor.black
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.text = text?.replace(target: "<br/>", withString: "\n")
            }
            return cell
        }
        else {
            if tableView == ordersList {
                
                
                print("viv enters orderlist table of cell for row")
                
                if historyList.count > 0 {
                    
                    if historyList[indexPath.row].IsMultipleLunch == "1" {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell1") as! HistoryTableViewCell
                        cell.checkBoxButton.tag = indexPath.row
                        cell.checkBoxButton.addTarget(self, action: #selector(cellCheckBoxCLicked (_ :)), for: .touchUpInside)
                        cell.orderId.textColor = .black
                        
                        cell.shadowView.backgroundColor = UIColor(hexString:historyList[indexPath.row].ColorCode)
                        cell.loginNameLabel.text  = historyData["Login"].stringValue
                        cell.logoutNameLabel.text  = historyData["LogOut"].stringValue
                        
                        if historyList[indexPath.row].IsMultipleLunch == "0" {
                            cell.lunchOutNameLabel.text  = historyData["LunchOut"].stringValue
                            cell.lunchInNameLabel.text  = historyData["LunchIn"].stringValue
                        }
                        else {
                            cell.lunchOutNameLabel.text  = historyData["LunchOut1"].stringValue
                            cell.lunchInNameLabel.text  = historyData["LunchIn1"].stringValue
                            cell.lunchOutNameLabel2.text  = historyData["LunchOut2"].stringValue
                            cell.lunchReturnNameLabel2.text  = historyData["LunchIn2"].stringValue
                        }
                        cell.errorLabel.text = ""
                        cell.errorLabelHeight.constant = 2
                        if historyList[indexPath.row].ConflictMessage.count > 0 {
                            cell.errorLabel.text = historyList[indexPath.row].ConflictMessage
                            let heightOfAddress  = Constants.calculateHeightWithFont(inString:historyList[indexPath.row].ConflictMessage,width:self.view.bounds.size.width-20,font:UIFont(name:"Avenir Heavy", size: 15.0)!)
                            cell.errorLabelHeight.constant = heightOfAddress + 9
                        }
                        
                        
                        cell.dateLabel.text = Constants.getFormattedDate(string:        historyList[indexPath.row].date)
                        if selectedEtimeLogIds.contains(historyList[indexPath.row].ETCLogId) {
                            cell.checkBoxButton.setImage(UIImage.init(named: "check.png"), for: .normal)
                        }
                        else {
                            cell.checkBoxButton.setImage(UIImage.init(named: "unchecked.png"), for: .normal)
                        }
                        
                        if historyList[indexPath.row].IsSubmitted == "1" {
                            cell.checkBoxButton.isUserInteractionEnabled = false
                            cell.checkBoxButton.isEnabled = false
                            cell.checkBoxButton.setImage(UIImage.init(named: "check.png"), for: .normal)
                        }
                        else {
                            cell.checkBoxButton.isUserInteractionEnabled = true
                            cell.checkBoxButton.isEnabled = true
                        }
                        cell.luncOutLabl.text =  self.geteTimeClockFormattedTime(string:  historyList[indexPath.row].lunchOut)
                        
                        cell.lunchReturnLabel.text =  self.geteTimeClockFormattedTime(string:  historyList[indexPath.row].lunchReturn)
                        
                        if historyList[indexPath.row].IsMultipleLunch == "1" {
                            cell.lunchOutLabel2.text =  self.geteTimeClockFormattedTime(string:  historyList[indexPath.row].lunchOut2)
                            
                            cell.lunchReturnLabel2.text =  self.geteTimeClockFormattedTime(string:  historyList[indexPath.row].lunchReturn2)
                        }
                        else {
                            cell.lunchOutLabel2.text =  ""
                            cell.lunchReturnLabel2.text =  ""
                        }
                        
                        
                        cell.orderId.text = historyList[indexPath.row].orderID
                        
                        cell.loginStart.text =  self.geteTimeClockFormattedTime(string:  historyList[indexPath.row].loginStart)
                        
                        cell.logoutFinishLabel.text =  self.geteTimeClockFormattedTime(string:  historyList[indexPath.row].logoutFinish)
                        
                        cell.editButton.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
                        cell.editButton.setTitleColor(.white, for: .normal)
                        
                        cell.notesButton.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
                        cell.notesButton.setTitleColor(.white, for: .normal)
                        
                        cell.notesButton.tag = indexPath.row
                        cell.notesButton.addTarget(self, action: #selector(notesButtonClicked(_:)), for: .touchUpInside)
                        
                        cell.editButton.tag = indexPath.row
                        cell.editButton.addTarget(self, action: #selector(editButtonClicked(_:)), for: .touchUpInside)
                        
                        if historyList[indexPath.row].isEdit == "0" && historyList[indexPath.row].isNote == "0"{
                            cell.bottomLabel.isHidden = true
                            cell.editButton.isHidden = true
                            cell.notesButton.isHidden = true
                        }
                        else if  historyList[indexPath.row].isEdit == "1" && historyList[indexPath.row].isNote == "1"{
                            cell.bottomLabel.isHidden = false
                            cell.editButton.isHidden = false
                            cell.notesButton.isHidden = false
                        }
                        
                        else if historyList[indexPath.row].isEdit == "0" && historyList[indexPath.row].isNote == "1"{
                            cell.bottomLabel.isHidden = false
                            cell.editButton.isHidden = true
                            cell.notesButton.isHidden = false
                            cell.noteButtonRight.constant = 9
                        }
                        else if historyList[indexPath.row].isEdit == "1" && historyList[indexPath.row].isNote == "0"{
                            cell.bottomLabel.isHidden = false
                            cell.editButton.isHidden = false
                            cell.notesButton.isHidden = true
                        }
                        cell.selectionStyle = .none
                        return cell
                    }
                    else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell") as! HistoryTableViewCell
                        cell.checkBoxButton.tag = indexPath.row
                        cell.checkBoxButton.addTarget(self, action: #selector(cellCheckBoxCLicked (_ :)), for: .touchUpInside)
                        cell.orderId.textColor = .black
                        
                        cell.shadowView.backgroundColor = UIColor(hexString:historyList[indexPath.row].ColorCode)
                        cell.loginNameLabel.text  = historyData["Login"].stringValue
                        cell.logoutNameLabel.text  = historyData["LogOut"].stringValue
                        
                        cell.lunchOutNameLabel.text  = historyData["LunchOut"].stringValue
                        cell.lunchInNameLabel.text  = historyData["LunchIn"].stringValue
                        
                        cell.errorLabel.text = ""
                        cell.errorLabelHeight.constant = 2
                        if historyList[indexPath.row].ConflictMessage.count > 0 {
                            cell.errorLabel.text = historyList[indexPath.row].ConflictMessage
                            let heightOfAddress  = Constants.calculateHeightWithFont(inString:historyList[indexPath.row].ConflictMessage,width:self.view.bounds.size.width-20,font:UIFont(name:"Avenir Heavy", size: 15.0)!)
                            cell.errorLabelHeight.constant = heightOfAddress + 9
                        }
                        
                        
                        cell.dateLabel.text = Constants.getFormattedDate(string:        historyList[indexPath.row].date)
                        if selectedEtimeLogIds.contains(historyList[indexPath.row].ETCLogId) {
                            cell.checkBoxButton.setImage(UIImage.init(named: "check.png"), for: .normal)
                        }
                        else {
                            cell.checkBoxButton.setImage(UIImage.init(named: "unchecked.png"), for: .normal)
                        }
                        
                        if historyList[indexPath.row].IsSubmitted == "1" {
                            cell.checkBoxButton.isUserInteractionEnabled = false
                            cell.checkBoxButton.isEnabled = false
                            cell.checkBoxButton.setImage(UIImage.init(named: "check.png"), for: .normal)
                        }
                        else {
                            cell.checkBoxButton.isUserInteractionEnabled = true
                            cell.checkBoxButton.isEnabled = true
                        }
                        cell.luncOutLabl.text =  self.geteTimeClockFormattedTime(string:  historyList[indexPath.row].lunchOut)
                        
                        cell.lunchReturnLabel.text =  self.geteTimeClockFormattedTime(string:  historyList[indexPath.row].lunchReturn)
                        
                        cell.orderId.text = historyList[indexPath.row].orderID
                        
                        cell.loginStart.text =  self.geteTimeClockFormattedTime(string:  historyList[indexPath.row].loginStart)
                        
                        cell.logoutFinishLabel.text =  self.geteTimeClockFormattedTime(string:  historyList[indexPath.row].logoutFinish)
                        
                        cell.editButton.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
                        cell.editButton.setTitleColor(.white, for: .normal)
                        
                        cell.notesButton.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
                        cell.notesButton.setTitleColor(.white, for: .normal)
                        
                        cell.notesButton.tag = indexPath.row
                        cell.notesButton.addTarget(self, action: #selector(notesButtonClicked(_:)), for: .touchUpInside)
                        
                        cell.editButton.tag = indexPath.row
                        cell.editButton.addTarget(self, action: #selector(editButtonClicked(_:)), for: .touchUpInside)
                        
                        if historyList[indexPath.row].isEdit == "0" && historyList[indexPath.row].isNote == "0"{
                            cell.bottomLabel.isHidden = true
                            cell.editButton.isHidden = true
                            cell.notesButton.isHidden = true
                        }
                        else if  historyList[indexPath.row].isEdit == "1" && historyList[indexPath.row].isNote == "1"{
                            cell.bottomLabel.isHidden = false
                            cell.editButton.isHidden = false
                            cell.notesButton.isHidden = false
                        }
                        
                        else if historyList[indexPath.row].isEdit == "0" && historyList[indexPath.row].isNote == "1"{
                            cell.bottomLabel.isHidden = false
                            cell.editButton.isHidden = true
                            cell.notesButton.isHidden = false
                            cell.noteButtonRight.constant = 9
                        }
                        else if historyList[indexPath.row].isEdit == "1" && historyList[indexPath.row].isNote == "0"{
                            cell.bottomLabel.isHidden = false
                            cell.editButton.isHidden = false
                            cell.notesButton.isHidden = true
                        }
                        cell.selectionStyle = .none

                        return cell
                    }
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell") as! HistoryTableViewCell
                    return cell
                }
                
            }
            else {
                if indexPath.section==0
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier:"hCell1", for: indexPath) as! THTableViewCell
                    cell.selectionStyle = .none
                    cell.startTimeLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
                    cell.endLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
                    cell.lunchLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
                    cell.totalLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
                    cell.dateLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
                    cell.selectionStyle = .none
                    return cell
                }
                
                else if indexPath.section == 2 {
                    let cell = tableView.dequeueReusableCell(withIdentifier:"bottomcell", for: indexPath)
                    cell.selectionStyle = .none
                    let totalHoursLabel = cell.viewWithTag(10) as! UILabel
                    let hour = timeslipsData["TotalHour"].doubleValue
                    totalHoursLabel.text = String(format:"%.2f", hour)
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "etdCell") as! EnterTimeSlipDetailTableViewCell
                    
                    cell.selectionStyle = .none
                    cell.startTimeTextField.tag = 7+indexPath.row
                    cell.endTimeTextField.tag   = 96+indexPath.row
                    cell.lunchTimeTextField.tag =  128+indexPath.row
                    cell.startTimeTextField.isEnabled = false
                    cell.endTimeTextField.isEnabled = false
                    cell.lunchTimeTextField.isEnabled = false
                    cell.startTimeTextField.backgroundColor = UIColor(hexString:"#EEEEEE")
                    cell.endTimeTextField.backgroundColor =     UIColor(hexString:"#EEEEEE")
                    cell.lunchTimeTextField.backgroundColor = UIColor(hexString:"#EEEEEE")
                    
                    cell.startTimeTextField.leftView?.isHidden = true
                    cell.endTimeTextField.leftView?.isHidden = true
                    if UIDevice.current.userInterfaceIdiom == .pad
                    {
                        cell.startTimeTextField.font = UIFont.systemFont(ofSize:15)
                        cell.endTimeTextField.font = UIFont.systemFont(ofSize:15)
                        
                    }
                    else if UIDevice.current.userInterfaceIdiom == .phone
                    {
                        
                        
                        if self.view.bounds.size.height <= 568
                        {
                            cell.startTimeTextField.font = UIFont.systemFont(ofSize:11)
                            cell.endTimeTextField.font = UIFont.systemFont(ofSize:11)
                            cell.lunchTimeTextField.font = UIFont.systemFont(ofSize:11)
                            cell.totalHoursLabel.font = UIFont.systemFont(ofSize:11)
                        }
                        else
                        {
                            cell.startTimeTextField.font = UIFont.systemFont(ofSize:13)
                            cell.endTimeTextField.font = UIFont.systemFont(ofSize:13)
                            cell.lunchTimeTextField.font = UIFont.systemFont(ofSize:13)
                            cell.totalHoursLabel.font = UIFont.systemFont(ofSize:13)
                        }
                        
                    }
                    
                    if timeslipsData["WeekDays"].arrayValue.count>0
                    {
                        cell.dateLabel.text = getFormattedDate(string:timeslipsData["WeekDays"][indexPath.row].stringValue).uppercased()
                    }
                    
                    let strtTime = (starTimes[indexPath.row] as! String)
                    let endTime = (endTimes[indexPath.row] as! String)
                    
                    if strtTime.count > 0 {
                        cell.startTimeTextField.leftView?.isHidden = false
                        cell.editButton.setImage(UIImage.init(named: "edit3"), for: .normal)
                    }
                    else {
                        cell.editButton.setImage(UIImage.init(named: "editd"), for: .normal)
                    }
                    cell.editButton.tag = indexPath.row
                    cell.editButton.addTarget(self, action: #selector(editTimeClicked(_ :)), for: .touchUpInside)
                    if endTime.count > 0 {
                        cell.endTimeTextField.leftView?.isHidden = false
                        
                    }
                    cell.startTimeTextField.text = strtTime
                    cell.endTimeTextField.text = endTime
                    cell.lunchTimeTextField.text = (lunchHours[indexPath.row] as! String)
                    cell.totalHoursLabel.text = (totalTimeInHours[indexPath.row] as! String)
                    return cell
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("viv selected row number", indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == Legend_Tbl_Tag{
            if infoViewColorsArray.count>0 {
                return 40
            }
            else{
                return 0
            }
        }
        else{
            if tableView == ordersList {
                if historyList[indexPath.row].IsMultipleLunch == "0" {
                    var heightOfAddress:CGFloat = 0.0
                    let errorText = historyList[indexPath.row].ConflictMessage
                    if errorText.count > 0 {
                        heightOfAddress  = Constants.calculateHeightWithFont(inString:errorText,width:self.view.bounds.size.width-20,font:UIFont(name:"Avenir Heavy", size: 15.0)!) + 9
                    }
                    
                    if historyList[indexPath.row].isEdit == "0" && historyList[indexPath.row].isNote == "0"{
                        return 160 + heightOfAddress
                    }
                    else {
                        return 215 + heightOfAddress
                        
                    }
                }
                else {
                    var heightOfAddress:CGFloat = 0.0
                    let errorText = historyList[indexPath.row].ConflictMessage
                    if errorText.count > 0 {
                        heightOfAddress  = Constants.calculateHeightWithFont(inString:errorText,width:self.view.bounds.size.width-20,font:UIFont(name:"Avenir Heavy", size: 15.0)!) + 9
                    }
                    
                    if historyList[indexPath.row].isEdit == "0" && historyList[indexPath.row].isNote == "0"{
                        return 205 + heightOfAddress
                    }
                    else {
                        return 260 + heightOfAddress
                        
                    }
                }
            }
            else{
                if indexPath.section == 0 {
                    return 35
                }
                else if indexPath.section == 1 {
                    return 50
                }
                else {
                    return 54
                }
            }
            
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0.0
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    
}


extension ViewHistoryViewController:UITextFieldDelegate
{
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        activeField = textField
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = "MM/dd/yyyy"
        calnederView.select(formatter.date(from: activeField.text!))
        showCalener()
        return false
    }
    
}

extension UIViewController {
    func geteTimeClockFormattedDate(string: String) -> String{
        if string.count>10
        {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.preferredLocale()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // This formate is input formated .
            let formateDate = dateFormatter.date(from: string)!
            dateFormatter.dateFormat = "MM/dd/yyyy hh:mm aa" // Output Formated
            return dateFormatter.string(from: formateDate)
        }
        else
        {
            return string
        }
    }
    
    
    func geteTimeClockDateFromString(stringdate: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm aa" // Output Formated
        return dateFormatter.date(from: stringdate)!
    }
    func geteTimeClockDateFromStringTime(stringdate: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "hh:mm aa" // Output Formated
        return dateFormatter.date(from: stringdate)!
    }
    
    func geteTimeClockFormattedTime(string: String) -> String{
        if string.count>10
        {
            if string == "0001-01-01T00:00:00" || string == "1900-01-01T00:00:00" {
                return ""
            }
            else {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale.preferredLocale()//Locale.preferredLocale()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // This formate is input formated .
                let formateDate = dateFormatter.date(from: string)!
                dateFormatter.dateFormat = "hh:mm a" // Output Formated
                return dateFormatter.string(from: formateDate)
            }
            
        }
        else
        {
            return ""
        }
    }
    
    func geteTimeClockFormattedOnlyDate(string: String) -> String{
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
            return string
        }
    }
}
//Calender Extension
extension ViewHistoryViewController:FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance
{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        //chnaging the dateFormat
        let date = date
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = "MM/dd/yyyy"
        let result = formatter.string(from: date)
        fromTextField.text = result
        cView.removeFromSuperview()
        getHistoryOrders()
        
    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int
    {
        
        return 0
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        
        return nil
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, selectionColorFor date: Date) -> UIColor? {
        
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        
        let todayDate = date
        let todayString = formatter.string(from: todayDate as Date)
        let todaysDay = self.getDayOfWeek(today: todayString)
        
        if todaysDay == "Sunday" {
            return UIColor.red
        }else{
            return UIColor.clear
        }
        
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        
        let todayDate = date
        let todayString = formatter.string(from: todayDate)
        let todaysDay = self.getDayOfWeek(today: todayString)
        
        if todaysDay == "Sunday" {
            return UIColor.black
        }else{
            return UIColor.lightGray
        }
    }
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        let todayDate = date
        let todayString = formatter.string(from: todayDate)
        let todaysDay = self.getDayOfWeek(today: todayString)
        
        if todaysDay == "Sunday" {
            return true
        }else{
            return true //this was false if we want to select only sunday
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
extension Date {
    var startOfWeek: Date {
        let date = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        let dslTimeOffset = NSTimeZone.local.daylightSavingTimeOffset(for: date)
        return date.addingTimeInterval(dslTimeOffset)
    }
    
    var endOfWeek: Date {
        return Calendar.current.date(byAdding: .second, value: 604799, to: self.startOfWeek)!
    }
    var sundayOfWeek: Date {
        
        return Calendar.current.date(byAdding: .day, value: 1, to: self.endOfWeek)!
        
    }
}


extension Date {
    
    static func today() -> Date {
        return Date()
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.next,
                   weekday,
                   considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
        nextDateComponent.weekday = searchWeekdayIndex
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
    
}

// MARK: Helper methods
extension Date {
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale.preferredLocale()
        return calendar.weekdaySymbols
    }
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    enum SearchDirection {
        case next
        case previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .next:
                return .forward
            case .previous:
                return .backward
            }
        }
    }
}
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
extension Array where Element: Hashable {
    
    func removingDuplicates<T: Hashable>(byKey key: (Element) -> T)  -> [Element] {
        var result = [Element]()
        var seen = Set<T>()
        for value in self {
            if seen.insert(key(value)).inserted {
                result.append(value)
            }
        }
        return result
    }
    
}
extension Locale {
    static func preferredLocale() -> Locale {
        //        guard let preferredIdentifier = Locale.preferredLanguages.first else {
        //            return Locale.current
        //        }
        //        return Locale(identifier: preferredIdentifier)
        return Locale(identifier: "en_US") //en_US_POSIX
    }
}
