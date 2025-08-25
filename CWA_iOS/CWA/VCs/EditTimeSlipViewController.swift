//
//  EditTimeSlipViewController.swift
//  CWA
//
//  Created by NFC Solutions on 01/02/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import  SwiftyJSON
import DropDown

class EditTimeSlipViewController: BaseViewController,UITextViewDelegate {

    var editObject:JSON = JSON.null
    var addObject:JSON = JSON.null
    var updateObject:JSON = JSON.null
    var rejectObject:JSON = JSON.null
    var deleteObject:JSON = JSON.null
    var editTimesSlips = [EditTimeSlip]()
    @IBOutlet var editTableView: UITableView!
    @IBOutlet var billingDateLabel: UILabel!
    @IBOutlet var weekendDateLabel: UILabel!
    @IBOutlet var tempNameLabel: UILabel!
    @IBOutlet var hoursLabel: UILabel!
    
    @IBOutlet var hourLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var billLabel: UILabel!
    @IBOutlet var weekLabel: UILabel!
    @IBOutlet var addView: UIView!
    @IBOutlet var addLabel: UILabel!
    @IBOutlet var headerView: UIView!
    @IBOutlet var popupScrollview: UIScrollView!
    var blurEffect = UIBlurEffect()
    
    var blurEffectView = UIVisualEffectView()
    var isSuccess = false
    @IBOutlet var popSelectWeekEnd: PKButton!
    @IBOutlet var addStartField: BorderTextField!
    @IBOutlet var endTextField: BorderTextField!
    @IBOutlet var breakTextField: BorderTextField!
    @IBOutlet var popTextField: BorderTextField!
    @IBOutlet var popTotalHours: UILabel!
    var popTotalHoursValue = ""
    
    var isApproveWarningMessage = false
    let chooseArticleDropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.chooseArticleDropDown
        ]
    }()
    var prevDate = String()
    var hours = String()
    var weekEnd = String()
    var name = String()
    var timeId = Int()
    var billDate = String()
    var activeTextField: UITextField?
    var cleared = Bool()
    var addSelectedWeekDAy = String()
    var weekending = ""
    var getApproveTSObj = GetApproveTimeSlip.init(TypeValue: 0,WeekEnding: "",CandId: 0,Name: "",Hours: "",approvedBy: "",referenceBy: "",Approved: 0,TimeId: 0,OrderId: 0,BillDate: "",PrevBillDate:"",ShowOT: "")
    
    @IBOutlet var rejectReasonView: UIView!
    @IBOutlet var rejectReasonHView: UIView!
    @IBOutlet var reasonTextView: UITextView!
    @IBOutlet var deleteLabel: PaddingLabel!
    @IBOutlet var dHView: UIView!
    @IBOutlet var deleteView: UIView!
    @IBOutlet var rejectReasonBGView: UIView!
    
    @IBOutlet weak var whiteBGHeightConstraint: NSLayoutConstraint!

   
   var deletRow = Int()
    
    
    
    @IBAction func popDatesAction(_ sender: PKButton) {
        
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        
        //Week Ending
        var nextDatesList:[String] = ["Please Select"]
        
        for Weekend in 0..<editObject["NextDateList"].arrayValue.count
        {
            nextDatesList.append(editObject["NextDateList"][Weekend]["Text"].stringValue)
        }
        //       object["Weekending"].arrayValue.map({$0["Weekend"].stringValue})
        setupChooseArticleDropDown(anchorView:sender,items:nextDatesList)
        chooseArticleDropDown.show()
    }
    func setupChooseArticleDropDown(anchorView:UIButton,items:[String]) {
        chooseArticleDropDown.anchorView = anchorView
        chooseArticleDropDown.bottomOffset = CGPoint(x: 0, y: anchorView.bounds.height)
        chooseArticleDropDown.backgroundColor = .white
        chooseArticleDropDown.dataSource =  items
        chooseArticleDropDown.selectionAction = { [unowned self] (index,item) in
            print(self.index)
            print(item)
            self.popSelectWeekEnd.setTitle(item,for:.normal)
            if item == "Please Select"
            {
                
            }
            else
            {
                self.addSelectedWeekDAy = self.editObject["NextDateList"][index-1]["Value"].stringValue
                
            }
        }
        
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        rejectReasonView.removeFromSuperview()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.automaticallyAdjustsScrollViewInsets = false
        JustHUD.shared.showInView(view: view)
        hours = getApproveTSObj.Hours!
        name = getApproveTSObj.Name!
        weekEnd = getApproveTSObj.WeekEnding!
        billDate = getApproveTSObj.BillDate!
        timeId = getApproveTSObj.TimeId!
        self.EditTimeSheet()
       
        self.rejectReasonBGView.layer.borderColor = UIColor.black.cgColor
        self.rejectReasonBGView.layer.borderWidth = 1

        
    hourLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
    tempLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
    billLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
    weekLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
    addLabel.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        addLabel.textColor = .white
    headerView.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
    rejectReasonHView.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        dHView.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        addView.frame = CGRect(x:10, y:50, width:self.view.bounds.size.width-20, height:400)
       
        if #available(iOS 11.0, *) {
            if self.isPortrait() == false {
                if ((UIApplication.shared.keyWindow?.safeAreaInsets.bottom)! > CGFloat(0.0)) {
                    addView.frame = CGRect(x:45, y:50, width:self.view.bounds.size.width-90, height:400)

                }
            }
        }
        rejectReasonView.frame = CGRect(x:10, y:100, width:self.view.bounds.size.width-20, height:300)
        reasonTextView.layer.borderColor = borderColor.cgColor
        reasonTextView.layer.borderWidth = 1.5
        //reasonTextView.layer.masksToBounds = tr
        self.title = "Edit Timeslip"
        deleteView.frame = CGRect(x:10, y:100, width:self.view.bounds.size.width-20, height:230)
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(keyboardDoneBtnTapped))]
        toolBar.sizeToFit()
        breakTextField.inputAccessoryView = toolBar
        popTextField.inputAccessoryView = toolBar
        reasonTextView.inputAccessoryView = toolBar

    }
    @objc func keyboardDoneBtnTapped(sender: UIButton)  {
        self.view.endEditing(true)
        self.navigationController?.view.endEditing(true)
    }
    func EditTimeSheet(){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            
            
            JustHUD.shared.showInView(view: view)
            
            
            let defaults = UserDefaults.standard
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            
            let Testparams = ["TimeId":timeId,
                              "BillDate":billDate,
                              "WeekEnding":weekEnd,
                              "Name":name,
                              "Hours":hours,
                              "ClientId":clientID,
                              "OSSource": "iOS",
                              "ContactId":ContactId] as [String : Any]
            print(Testparams)
            RestAPI.EditTimeSheet(self,params:Testparams, method:"POST", accessToken:"", acces: true, callBack:getResponse(response:))
            
        }else{
            isSuccess = false
            isApproveWarningMessage  = false

            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    
    func getResponse(response:AnyObject)->()
    {
        JustHUD.shared.hide()
        editTimesSlips.removeAll()
        print(response)
        if response is String{
            
            //            self.ShowAlertMessage(message: response as! String, title: "")
            isSuccess = false
            isApproveWarningMessage  = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            editObject = response as! JSON
            print(response)
            for edit in 0..<editObject["TimeSlipDetails"].arrayValue.count
            {
                //    {
                //    "Day": "Thursday",
                //    "DivisionId": 50,
                //    "DetailId": 2699845,
                //    "Date": "12/07/2017",
                //    "NextDate": "0001-01-01T00:00:00",
                //    "StartTime": " 7:45PM",
                //    "EndTime": "10:45PM",
                //    "BreakMin": 15,
                //    "Hours": 2.75,
                //    "TaxiFare": 0
                //    }
                let et = EditTimeSlip.init(day:editObject["TimeSlipDetails"][edit]["Day"].stringValue, divisionId: editObject["TimeSlipDetails"][edit]["DivisionId"].stringValue, detailId: editObject["TimeSlipDetails"][edit]["DetailId"].stringValue, date: editObject["TimeSlipDetails"][edit]["Date"].stringValue, nexDate: editObject["TimeSlipDetails"][edit]["NextDate"].stringValue, startTime: editObject["TimeSlipDetails"][edit]["StartTime"].stringValue, endTime: editObject["TimeSlipDetails"][edit]["EndTime"].stringValue, breakMin: editObject["TimeSlipDetails"][edit]["BreakMin"].stringValue, hours: editObject["TimeSlipDetails"][edit]["Hours"].stringValue, taxiFare: editObject["TimeSlipDetails"][edit]["TaxiFare"].stringValue)
                editTimesSlips.append(et)
            }
            editTableView.reloadData()
            billingDateLabel.text = Constants.getFormattedDateForEdit(string:prevDate)
            weekendDateLabel.text = Constants.getFormattedDateForEdit(string:editObject["WeekEnding"].stringValue)
            tempNameLabel.text = editObject["Name"].stringValue
            hoursLabel.text = editObject["TotalHours"].stringValue
            getApproveTSObj.Hours = editObject["TotalHours"].stringValue
            
        }
    }
    
    @IBAction func addAction(_ sender: ShadowButton) {
        

        popSelectWeekEnd.setTitle("Please Select", for:.normal)
        addStartField.text = ""
        endTextField.text = ""
        breakTextField.text = ""
        popTextField.text = ""
        popTotalHours.text = ""
        
        blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.contentView.addSubview(addView)
        view.addSubview(blurEffectView)
    }
    @IBAction func updateAction(_ sender: ShadowButton) {
//        {"UpdateTimeSheetList":[
//            {
//            "BreakMin":"0",
//            "Date":"12/19/2017",
//            "DetailId":"2700381",
//            "EndTime":"12:00 PM",
//            "StartTime":"11:30 AM",
//            "Hours":"0.30",
//            "NextDate":"12/19/2017"
//
//            },
//            {
//            "BreakMin":"0",
//            "Date":"12/20/2017",
//            "DetailId":"2700386",
//            "EndTime":"4:30 AM",
//            "StartTime":"1:00 AM",
//            "Hours":"3.5",
//            "NextDate":"12/20/2017"
//
//            }],
//            "TimeId":"960888"
//
//        }
        var isNegative = Bool()
        var isLess = Bool()
        var isZero = Bool()
        
        var updatedList = Array<[String:Any]>()
        for updateList in 0..<editTimesSlips.count
        {
            if editTimesSlips[updateList].hours!.hasPrefix("-")
            {
                isNegative = true
                break
            }
            else if Double((editTimesSlips[updateList].hours!)) != nil
            {
                if Double((editTimesSlips[updateList].hours!))!==0
                {
                isZero = true
                break
                }
                else
                {
                    let u = ["BreakMin":editTimesSlips[updateList].breakMin!,
                             "Date":editTimesSlips[updateList].date!,
                             "DetailId":editTimesSlips[updateList].detailId!,
                             "EndTime":editTimesSlips[updateList].endTime!,
                             "StartTime":editTimesSlips[updateList].startTime!,
                             "Hours":editTimesSlips[updateList].hours!,
                             "TaxiFare":editTimesSlips[updateList].taxiFare!,
                             "NextDate":editTimesSlips[updateList].nexDate!]
                    updatedList.append(u)
                }
            }
            else if editTimesSlips[updateList].hours! == ""
            {
                isLess = true
                break
            }
            
        }
        
        if isNegative
        {
//             self.ShowAlertMessage(message:"Please make sure total hours should not be less than zero or zero.", title:"")
            isSuccess = false
            isApproveWarningMessage  = false

            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Please make sure total hours should not be less than zero or zero.", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

        }
        else if isZero
        {
             isSuccess = false
            isApproveWarningMessage  = false

            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Start and end time cannot be same", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

        }
        else if isLess
        {
             isSuccess = false
            isApproveWarningMessage  = false

            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Please make sure total hours should not be less than zero or zero.", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

        }
        else
        {
            
            
            let isInternetAvailable = self.isInternetAvailable()
            
            if isInternetAvailable {
                
                
              
                JustHUD.shared.showInView(view: view)
                let addParams = ["TimeId":timeId,"UpdateTimeSheetList":updatedList,"OSSource": "iOS"] as [String : Any]
                print(addParams)
                RestAPI.updateTimeSheet(self,params:addParams, method:"POST", accessToken:"", acces: true, callBack:getResponseForUpdate(response:))
                
            }else{
                isSuccess = false
                isApproveWarningMessage  = false

                self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
            
            
            
        }

    }
    func getResponseForUpdate(response:AnyObject)->()
    {
//        {
//            "ClientId": 0,
//            "TimeId": 960888,
//            "Message": "Updated Successfully.",
//            "MessageStatus": "1",
//            "DetailId": 0,
//            "BreakMin": 0,
//            "Hours": 0,
//            "TaxiFare": 0,
//            "UpdateTimeSheetList": [
//            {
//            "DivisionId": 0,
//            "DetailId": 2700381,
//            "Date": "12/19/2017",
//            "NextDate": "2017-12-19T00:00:00",
//            "StartTime": "11:30 AM",
//            "EndTime": "12:00 PM",
//            "BreakMin": 0,
//            "Hours": 0.3,
//            "TaxiFare": 0
//            },
//            {
//            "DivisionId": 0,
//            "DetailId": 2700386,
//            "Date": "12/20/2017",
//            "NextDate": "2017-12-20T00:00:00",
//            "StartTime": "1:00 AM",
//            "EndTime": "4:30 AM",
//            "BreakMin": 0,
//            "Hours": 3.5,
//            "TaxiFare": 0
//            }
//            ],
//            "ConfictTimeSlip": 0
//        }

        print(response)
        JustHUD.shared.hide()
        if response is String{
            
            //            self.ShowAlertMessage(message: response as! String, title: "")
            isSuccess = false
            isApproveWarningMessage  = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            updateObject = response as! JSON
            if updateObject["MessageStatus"].stringValue == "1"
            {
                getApproveTSObj.Hours = updateObject["TotalHours"].stringValue
                let defaults = UserDefaults.standard
                let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
                let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
                let Testparams = ["TimeId":timeId,
                                  "BillDate":billDate,
                                  "WeekEnding":weekEnd,
                                  "Name":name,
                                  "Hours":hours,
                                  "ClientId":clientID,
                                  "OSSource": "iOS",
                                  "ContactId":ContactId] as [String : Any]
                
                print(Testparams)
                
                RestAPI.EditTimeSheet(self,params:Testparams, method:"POST", accessToken:"", acces: true, callBack:getResponse(response:))
                //           self.ShowAlertMessage(message: updateObject["Message"].stringValue, title:"")
                isSuccess = false
                isApproveWarningMessage  = false
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: updateObject["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                
            }
            else
            {
                //            self.ShowAlertMessage(message: updateObject["Message"].stringValue, title:"")
                isSuccess = false
                isApproveWarningMessage  = false
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: updateObject["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
            
        }
    }
    
    
    @IBAction func approveAction(_ sender: ShadowButton) {
        let  DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
        if DivisionId == "6"{ // Law dept
            self.approveRejectLawDeptPendingTS(command:"Approve")
        }else{
            self.approvePendingTimeSlip(ApproveKey: "0")
        }
    }
    
    
//approveFunctionForLawAction
    func approveRejectLawDeptPendingTS(command: String) {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            let ContactId = String(format:"%d", UserDefaults.standard.integer(forKey: "ContactId"))
            let ClientID = String(format:"%d", UserDefaults.standard.integer(forKey: "ClientID"))
            
            let params :[String:String] =  ["ContactId":ContactId,"ClientId":ClientID,"TimeId":"\(getApproveTSObj.TimeId!)","OrderId":"\(getApproveTSObj.OrderId!)","CandId":"\(getApproveTSObj.CandId!)","WeekEnding":getApproveTSObj.WeekEnding!,"Command":command,"OSSource": "iOS"]
            print(params)
            RestAPI.approveTSAttonerySubmit(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getApproveResponse(response:))
            
        }else{
            
            isSuccess = false
            isApproveWarningMessage  = false

            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

        }
    }
    
    
 //approveFunction
    func approvePendingTimeSlip(ApproveKey: String){
        
        
        let defaults = UserDefaults.standard
        
        let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
        let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
       // let ApproveList = NSMutableArray()
        
        
//        "TimeId":"961237",
//        "Name":"test test50",
//        "Weekending":"2/4/2018",
//        "Hours":"0.5",
//        "ContactId":"194848",
//        "ClientId":"70830"
        
        
//        let tsObj = ["Hours":getApproveTSObj.Hours,
//                     "BillDate":getApproveTSObj.BillDate,
//                     "Name":getApproveTSObj.Name,
//                     "TimeId":String(format:"%d",getApproveTSObj.TimeId!),
//                     "IsApprove":"true",
//                     "Weekending":getApproveTSObj.WeekEnding,
//                     "Previousdate":"",//ts.BillDate,
//                    "New":"0"
//        ]
//        ApproveList.add(tsObj)
 
        let param = ["ContactId": ContactId,
                     "ClientId": clientID,
                     "Hours":getApproveTSObj.Hours!,
                     "Name":getApproveTSObj.Name!,
                     "Weekending":getApproveTSObj.WeekEnding!,
                     "ApproveKey": ApproveKey,
                     "OSSource": "iOS",
                     "TimeId":String(format:"%d",getApproveTSObj.TimeId!)] as [String : Any]  as NSDictionary
        
        print(param)
        
        let urlString = RestAPI.BaseUrl+RestAPI.ApproveTimeSlip
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            
            RestAPI.postRequestWithToken(urlString: urlString, params: param, callback: getApproveResponse(response:))
            
        }else{
            
//            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
            isSuccess = false
            isApproveWarningMessage  = false

            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

        }
    
    }
    func getApproveResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        print(response)
        if response is String{
            
//            self.ShowAlertMessage(message: response as! String, title: "")
           isSuccess = false
            isApproveWarningMessage  = false

            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

        }else{
            
            var object = response as! JSON
            if object["MessageStatus"].intValue == 1
            {
            
//                let alert = UIAlertController(title:"", message: object["Message"].stringValue, preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(alert) in
//                    self.pushToApproveTimeSlipPage()
//                }))
//
//                self.present(alert, animated: true, completion: nil)
//
//                isSuccess = true
//
//                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)

                let message = object["Message"].stringValue
                if (message.caseInsensitiveCompare("Approved successfully") == ComparisonResult.orderedSame){
                    
                    
                    isSuccess = true
                    isApproveWarningMessage  = false
                    
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                    
 
                }else{
                    
                     isSuccess = false
                    isApproveWarningMessage = true
                    let htmlString = "<html>" + message
                    
                    let messageText = htmlString.htmlToAttributedString
                    self.showCustomAlert(Title: "", attMessage: messageText! , message: message , okBtnTitle: "OK", cancelBtnTitle: "Cancel", type: Warning_Text,isAttributed: true)
                }
                
            }else{
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
//                self.ShowAlertMessage(message: message, title: "")
                isSuccess = false
                isApproveWarningMessage  = false

                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

                
            }
        }
        
    }
    
    
    @IBAction func rejectAction(_ sender: ShadowButton) {
        let  DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
        if DivisionId == "6"{ // Law dept
            self.approveRejectLawDeptPendingTS(command: "Reject")
        }
        else
        {
            reasonTextView.text = ""
//            blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
//            blurEffectView = UIVisualEffectView(effect: blurEffect)
//            blurEffectView.frame = view.bounds
//            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            blurEffectView.contentView.addSubview(rejectReasonView)
//            view.addSubview(blurEffectView)
            self.ShowPopup()
        }

    }
    
    func removeRejectPopupViewFromSuperView(){
        
        rejectReasonBGView.transform =  .identity
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            
            self.rejectReasonBGView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            
        }, completion: {(finished: Bool) -> Void in
            // do something once the animation finishes, put it here
            self.rejectReasonView.removeFromSuperview()
            
        })
    }
    
    func ShowPopup(){
        self.navigationController?.view.addSubview(rejectReasonView)
        rejectReasonView.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
        
        self.rejectReasonBGView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.rejectReasonBGView.transform = .identity
        }, completion: {(finished: Bool) -> Void in
            // do something once the animation finishes, put it here
        })
     }
    
    
    @IBAction func popCancel(_ sender: UIButton) {
        blurEffectView.removeFromSuperview()
    }
    @IBAction func popAddAction(_ sender: UIButton) {
        
        
 
        if (popTotalHoursValue.hasPrefix("-"))
        {
//            self.ShowAlertMessage(message:"Please make sure total hours should not be less than zero or zero.", title:"")
            isSuccess = false
            isApproveWarningMessage  = false

            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Please make sure total hours should not be less than zero or zero.", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

        }
        else if self.popSelectWeekEnd.titleLabel!.text == "Please Select"
        {
         
//            self.ShowAlertMessage(message:"Please select day", title:"")
            isSuccess = false
            isApproveWarningMessage  = false

            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Please select day", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

        }
        else
        {
        let defaults = UserDefaults.standard
        let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
        let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
        JustHUD.shared.showInView(view: view)
        let addParams = ["TimeId":timeId,
                         "BillDate":billDate,
                         "WeekEnding":weekEnd,
                         "Name":name,
                         "Hours":popTotalHoursValue,
                         "ClientId":clientID,
                         "ContactId":ContactId,
                         "DetailId":0,
                         "StartTime":addStartField.text!,
                         "EndTime":endTextField.text!,
                         "Date":addSelectedWeekDAy,
                         "OSSource": "iOS",
                         "BreakMin":breakTextField.text!,
                         "TaxiFare":popTextField.text!] as [String : Any]
            print(addParams)
        RestAPI.addTimeSheet(self,params:addParams, method:"POST", accessToken:"", acces: true, callBack:getResponseForAdd(response:))
        }
    }
    
    func getResponseForAdd(response:AnyObject)->()
    {
        
//        Response:
//        a)If we have the duplicate timeSheet enteries
//
//        {
//            "TimeId": 960883,
//            "DetailId": 0,
//            "WeekEnding": "2017-12-26T00:00:00",
//            "BillDate": "2017-12-26T00:00:00",
//            "Message": "The hours you have entered above conflict with a time slip that already exists in the our system.   Duplicate time slips are not allowed!",
//            "MessageStatus": "0",
//            "StartTime": "11:15 AM",
//            "EndTime": "4:00 PM",
//            "BreakMin": 0,
//            "Hours": 2.75,
//            "TaxiFare": 0,
//            "Date": "12/26/2017"
//        }
//        b)Without any duplicate timeSheet
//        {
//            "TimeId": 960888,
//            "DetailId": 0,
//            "WeekEnding": "2017-12-26T00:00:00",
//            "BillDate": "2017-12-26T00:00:00",
//            "Message": "Added Successfully.",
//            "MessageStatus": "1",
//            "StartTime": "01:15 AM",
//            "EndTime": "06:15 AM",
//            "BreakMin": 0,
//            "Hours": 5,
//            "TaxiFare": 0,
//            "Date": "12/21/2017"
//        }
        JustHUD.shared.hide()
        print(response)
        
        if response is String{
            
            //            self.ShowAlertMessage(message: response as! String, title: "")
            isSuccess = false
            isApproveWarningMessage  = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            
            addObject = response as! JSON
            if addObject["MessageStatus"].stringValue == "1"
            {
                getApproveTSObj.Hours = addObject["TotalHours"].stringValue
                blurEffectView.removeFromSuperview()
                let isInternetAvailable = self.isInternetAvailable()
                
                if isInternetAvailable {
                    let defaults = UserDefaults.standard
                    let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
                    let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
                    let Testparams = ["TimeId":timeId,
                                      "BillDate":billDate,
                                      "WeekEnding":weekEnd,
                                      "Name":name,
                                      "Hours":hours,
                                      "ClientId":clientID,
                                      "OSSource": "iOS",
                                      "ContactId":ContactId] as [String : Any]
                    print(Testparams)

                    RestAPI.EditTimeSheet(self,params:Testparams, method:"POST", accessToken:"", acces: true, callBack:getResponse(response:))
                }else{
                    isSuccess = false
                    isApproveWarningMessage  = false
                    
                    self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                    
                }
                
            }
            else
            {
                if addObject["Message"].stringValue == "Taxi fare should be less than 1000 only"
                {
                    isSuccess = false
                    isApproveWarningMessage  = false
                    
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: addObject["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                }
                else
                {
                    isSuccess = false
                    isApproveWarningMessage  = false
                    
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: addObject["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                    
                    //            self.ShowAlertMessage(message: addObject["Message"].stringValue, title:"")
                }
            }
            
        }
        
    }
    
    
    //TimePickerControl
    func showPicker(ampm:Bool,selectedDate: Date)
    {
        let min = selectedDate.addingTimeInterval(-60 * 60 * 24 * 4) //4 days -
        let max = selectedDate.addingTimeInterval(60 * 60 * 24 * 4)//4 days +
        let picker = DateTimePicker.show(selected: selectedDate, minimumDate: min, maximumDate: max)
        
        picker.timeInterval = DateTimePicker.MinuteInterval.fifteen
        picker.highlightColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = "Done"
        picker.doneBackgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        picker.locale = Locale(identifier: "en_GB")
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
            if (self.activeTextField!.tag>7)&&(self.activeTextField!.tag)<16
            {
                self.activeTextField?.text = formatter.string(from: date)
                self.editTimesSlips[(self.activeTextField?.tag)!-8].startTime = formatter.string(from:date)
             
            }
            else if (self.activeTextField!.tag>96)&&(self.activeTextField!.tag)<104
            {
                self.activeTextField?.text = formatter.string(from: date)
                 self.editTimesSlips[(self.activeTextField?.tag)!-97].endTime = formatter.string(from:date)
               
            }
            else
            {
                self.activeTextField?.text = formatter.string(from:date)
                if (self.addStartField.text!.count>0)&&(self.endTextField.text!.count>0)
                {
                    self.getHours(start:self.addStartField.text!,end:self.endTextField.text!,i:100,min:false)
                      self.total()
                }
                
                
            }
            self.editTableView.reloadData()
        }
        picker.delegate = self
        NotificationCenter.default.post(name: Notification.Name("Time"), object: nil)
    }

    //TimeCalculations

    func convertDate(date:String,min:Bool) -> String
    {
        let tt = date
        let dateFormatterf = DateFormatter()
        dateFormatterf.locale = Locale.preferredLocale()
        if min
        {
            dateFormatterf.dateFormat = "h:mm"
        }
        else
        {
            dateFormatterf.dateFormat = "h:mm a"
        }

        let dateee = dateFormatterf.date(from: tt)
        dateFormatterf.dateFormat = "HH:mm"

        let Date24 = dateFormatterf.string(from: dateee!)
        print("24 hour formatted Date:",Date24)
        return Date24
    }
    func addTimes(start:String,end:String,min:Bool) -> Int
    {
        let startDate = start
        let endDate = end

        let startArray = startDate.components(separatedBy: (":"))
        let endArray = endDate.components(separatedBy: (":"))

        let startHours = Int(startArray[0])! * 60
        let startMinutes = Int(startArray[1])! + startHours

        let endHours = Int(endArray[0])! * 60
        let endMinutes = Int(endArray[1])! + endHours

        var timeDifference = 0
        if min
        {
            timeDifference = startMinutes - endMinutes
        }
        else
        {
            timeDifference = endMinutes - startMinutes
        }
        let day = 24 * 60

        if timeDifference < 0 {
            timeDifference += day
        }
        print(timeDifference)
        return timeDifference
    }
    func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
    func getHours(start:String,end:String,i:Int,min:Bool)
    {
        let tuple = minutesToHoursMinutes(minutes: self.addTimes(start:self.convertDate(date:start,min:min), end: self.convertDate(date:end,min:min),min:min))


        var totalTimeConversionArray = Double()
        let hours = String(format:"%d:%d",tuple.hours,tuple.leftMinutes)
        let fileArray = hours.components(separatedBy:":")
        var hoursToMin:Double = Double()
        if fileArray.count>0
        {
            hoursToMin = Double(fileArray[0])!
        }
        var mins:Double = Double()
        if fileArray.count == 2
        {
            mins = Double(fileArray[1])!
        }
        totalTimeConversionArray = hoursToMin+mins/60
        
        if i == 100
        {
            if hours.hasPrefix("-")
            {
                popTotalHoursValue = String(format:"-%.2f",totalTimeConversionArray)
                self.popTotalHours.text = "Hours : "+popTotalHoursValue
            }
            else{
                popTotalHoursValue = String(format:"%.2f",totalTimeConversionArray)
                self.popTotalHours.text =  "Hours : "+popTotalHoursValue

            }
        }
        else
        {
        if hours.hasPrefix("-")
        {
            self.editTimesSlips[i-1].hours = String(format:"-%.2f",totalTimeConversionArray)
            
        }
        else{
            self.editTimesSlips[i-1].hours = String(format:"%.2f",totalTimeConversionArray)
            
        }
        }
       // self.addTotal()
       //self.editTableView.reloadData()

    }

//    func addTotal()
//    {
//        var toatHours = Double()
//        for i in 0..<7
//        {
//            var hours = Double()
//            if totalHours[i] as! String != ""
//            {
//                hours = Double(totalHours[i] as! String)!
//                toatHours += hours
//            }
//            else
//            {
//
//            }
//        }
//        totalLabel.text = String(format:"%.2f",toatHours)
//    }
    func total()
    {

            if (self.addStartField.text!.count>0)&&(self.endTextField.text!.count>0)&&(self.breakTextField.text!.count>0)
            {
                self.getHours(start:self.addStartField.text!, end:self.endTextField.text!, i:100,min:false)
                let timeInTotal = Double(popTotalHoursValue) //Double(popTotalHours.text!)
                let lunchTime = Double(self.breakTextField.text!)!
//                self.popTotalHours.text = String(format:"%.2f",timeInTotal!-lunchTime/60)
                popTotalHoursValue = String(format:"%.2f",timeInTotal!-lunchTime/60)
                self.popTotalHours.text = "Hours : "+popTotalHoursValue

            }
            else if (self.addStartField.text!.count>0)&&(self.endTextField.text!.count>0)
            {
                self.getHours(start:self.addStartField.text!, end:self.endTextField.text!, i:100,min:false)
            }
        else
            {
                self.popTotalHours.text = ""
                self.popTotalHoursValue = ""

        }

    }
    
    @IBAction func submitRejectResaon(_ sender: ShadowButton) {
        JustHUD.shared.showInView(view:self.view)
        let defaults = UserDefaults.standard
        let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
        let rejectParams = ["TimeId":getApproveTSObj.TimeId!,
                            "ClientId": clientID,
                            "OSSource": "iOS",
                            "Reason":reasonTextView.text] as [String : Any]
        print(rejectParams)
        RestAPI.rejectTimeSheet(self,params:rejectParams, method:"POST", accessToken:"", acces: true, callBack:getResponseForReject(response:))
    }
    
    //resonapiresponse
    func getResponseForReject(response:AnyObject)->()
    {
        JustHUD.shared.hide()
        
        if response is String{
            
            //            self.ShowAlertMessage(message: response as! String, title: "")
            isSuccess = false
            isApproveWarningMessage  = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            rejectObject = response as! JSON
            if rejectObject["MessageStatus"].stringValue == "1"
            {
                blurEffectView.removeFromSuperview()
                //            let alert = UIAlertController(title:"", message:rejectObject["Message"].stringValue, preferredStyle: UIAlertControllerStyle.alert)
                //            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(alert) in
                //                self.pushToApproveTimeSlipPage()
                //            }))
                //
                //            self.present(alert, animated: true, completion: nil)
                //
                isSuccess = true
                isApproveWarningMessage  = false
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: rejectObject["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
            }
            else
            {
                //            self.ShowAlertMessage(message: rejectObject["Message"].stringValue, title:"")
                isSuccess = false
                isApproveWarningMessage  = false
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: rejectObject["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }
    }
    
    func pushToApproveTimeSlipPage(){
        //        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        //
        //        let nextViewController = storyBoard.instantiateViewController(withIdentifier:"ApproveTimeSlipSegue") as! ApproveTimeSlipViewController
        //        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        var isControllerExists = false
        
        var ApproveTimeSlipVC = UIViewController()
        
        if let viewControllers = self.navigationController?.viewControllers {
            
            for viewController in viewControllers {
                
                if viewController is ApproveTimeSlipViewController {
                    print("Your controller exist")
                    ApproveTimeSlipVC = viewController
                    isControllerExists = true
                    break
                }
            }
            
        }
        
        if isControllerExists {
            
            self.navigationController?.popToViewController(ApproveTimeSlipVC, animated: true)
            
        }else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ApproveTimeSlipSegue") as! ApproveTimeSlipViewController
            nextViewController.willShowNoteAlert = "0"
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
    }
    
    
    @IBAction func reasonCancelAction(_ sender: ShadowButton) {
       self.removeRejectPopupViewFromSuperView()
//        blurEffectView.removeFromSuperview()
    }
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "EEEE"
        return  dateFormatter.string(from: date!)
        
    }
    @IBAction func deleteAction(_ sender: UIButton) {
        let indexPath = editTableView.indexPathForView(view:sender)
        print(indexPath!)
        deletRow = indexPath!.row
        deleteLabel.text = "Are you sure you want to delete this entry for (\(self.convertDateFormater(editTimesSlips[deletRow-1].date!)))?"
        blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.contentView.addSubview(deleteView)
        view.addSubview(blurEffectView)
    }
    @IBAction func deleteYesAction(_ sender: UIButton) {
        let deletParams = ["DetailId":editTimesSlips[deletRow-1].detailId!,
                           "TimeId":getApproveTSObj.TimeId!,"OSSource": "iOS"] as [String : Any]
        RestAPI.deleteTimeSheet(self,params:deletParams, method:"POST", accessToken:"", acces: true, callBack:getResponseForDelete(response:))
    
    }
    func getResponseForDelete(response:AnyObject)->()
    {
        print(response)
        if response is String{
            
            //            self.ShowAlertMessage(message: response as! String, title: "")
            isSuccess = false
            isApproveWarningMessage  = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            deleteObject = response as! JSON
            if deleteObject["MessageStatus"].stringValue == "1"
            {
                getApproveTSObj.Hours = deleteObject["TotalHours"].stringValue
                blurEffectView.removeFromSuperview()
                
                let isInternetAvailable = self.isInternetAvailable()
                
                if isInternetAvailable {
                    
                    let defaults = UserDefaults.standard
                    let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
                    let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
                    let Testparams = ["TimeId":timeId,
                                      "BillDate":billDate,
                                      "WeekEnding":weekEnd,
                                      "Name":name,
                                      "Hours":hours,
                                      "OSSource": "iOS",
                                      "ClientId":clientID,
                                      "ContactId":ContactId] as [String : Any]
                    print(Testparams)

                    RestAPI.EditTimeSheet(self,params:Testparams, method:"POST", accessToken:"", acces: true, callBack:getResponse(response:))
                }else{
                    isSuccess = false
                    isApproveWarningMessage  = false
                    
                    self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                    
                }
            }
            else
            {
                //            self.ShowAlertMessage(message: addObject["Message"].stringValue, title:"")
                isSuccess = false
                isApproveWarningMessage  = false
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: addObject["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
            
        }
    }
    
    @IBAction func deleteNoAction(_ sender: UIButton) {
        blurEffectView.removeFromSuperview()
    }
    @IBAction override func okButtonTapped(_ sender: Any) {
        self.alertController.dismiss(animated: true, completion: nil)
       
        if isSuccess == true {
            self.pushToApproveTimeSlipPage()
        }else if isApproveWarningMessage == true {
            self.approvePendingTimeSlip(ApproveKey: "1")
        }
        
    }
    //MARK:UITextView Delegate Methods
    
    func textView(_ textView: UITextView, shouldChangeTextIn: NSRange, replacementText: String) -> Bool
    {
        
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView)
    {
        view.endEditing(true)
//        commentPopupView.whiteBGTopConstraint.constant = 10
//        commentPopupView.superViewTopConstraint.constant = 36
//
//        commentPopupView.layoutIfNeeded()
//
        
    }
    func textViewDidBeginEditing(_ textView: UITextView)
    {
//        if self.isPortrait() == true{
//            commentPopupView.whiteBGTopConstraint.constant = -50
//            commentPopupView.superViewTopConstraint.constant = 0
//        }else{
//            commentPopupView.whiteBGTopConstraint.constant = -150
//            commentPopupView.superViewTopConstraint.constant = 0
//        }
//        commentPopupView.layoutIfNeeded()
    }
    func updatesFramesForScreenRotation(){
        DispatchQueue.main.async(execute: { () -> Void in
            self.addView.frame = CGRect(x:10, y:50, width:self.view.bounds.size.width-20, height:400)
            if #available(iOS 11.0, *) {
                if self.isPortrait() == false {
                    if ((UIApplication.shared.keyWindow?.safeAreaInsets.bottom)! > CGFloat(0.0)) {
                        self.addView.frame = CGRect(x:45, y:50, width:self.view.bounds.size.width-90, height:400)
                    }
                }
            }
            self.rejectReasonView.frame = CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.size.height)

            if self.isPortrait() == true{
                self.deleteView.frame = CGRect(x:10, y:100, width:self.view.bounds.size.width-20, height:230)
                self.whiteBGHeightConstraint.constant = 356
                self.popupScrollview.contentSize =  CGSize(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
                self.deleteView.layoutIfNeeded()
                
            }else{
                 self.deleteView.frame = CGRect(x:10, y:60, width:self.view.bounds.size.width-20, height:230)
                self.whiteBGHeightConstraint.constant = 400
                self.popupScrollview.contentSize =  CGSize(width: UIScreen.main.bounds.size.height,height: 400)
                self.deleteView.layoutIfNeeded()
                
            }
        })
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        
        self.updatesFramesForScreenRotation()

        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            DispatchQueue.main.async(execute: { () -> Void in
                self.addDivisionNameOnTop()
             })
        case .portraitUpsideDown:
            text="PortraitUpsideDown"
        case .landscapeLeft:
            text="LandscapeLeft"
            DispatchQueue.main.async(execute: { () -> Void in
                self.addDivisionNameOnTop()
                
             })
        case .landscapeRight:
            text="LandscapeRight"
            DispatchQueue.main.async(execute: { () -> Void in
                self.addDivisionNameOnTop()
                
             })
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
        
    }
    
}



//End of class



extension EditTimeSlipViewController:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
        return 35
        }
        else
        {
            return 106
        }
    }
}
extension EditTimeSlipViewController:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editTimesSlips.count+1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0
        {
        let cell = tableView.dequeueReusableCell(withIdentifier:"hCell") as! THTableViewCell
            cell.selectionStyle = .none
            cell.startTimeLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
            cell.endLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
            cell.lunchLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
            cell.totalLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
            cell.dateLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "etdCell") as! EnterTimeSlipDetailTableViewCell
            cell.dateLabel.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
            cell.dateLabel.text = Constants.getFormattedDateForEditTimeSlip(string:editTimesSlips[indexPath.row-1].date!).uppercased()
            cell.startTimeTextField.tag = 7+indexPath.row
            cell.endTimeTextField.tag   = 96+indexPath.row
            cell.lunchTimeTextField.tag =  128+indexPath.row
            cell.taxFareTextField.tag = 112+indexPath.row
            
            if editTimesSlips.count>1
            {
                cell.deleteConstarin.constant = 100
                cell.deleteButton.isHidden = false
            }
            else
            {
                cell.deleteConstarin.constant = 2
                cell.deleteButton.isHidden = true
            }
            
            
            cell.startTimeTextField.text = editTimesSlips[indexPath.row-1].startTime!
            cell.endTimeTextField.text = editTimesSlips[indexPath.row-1].endTime!
            if editTimesSlips[indexPath.row-1].taxiFare!.count>0
            {
                 if Double(editTimesSlips[indexPath.row-1].taxiFare!)!>0
                 {
            cell.taxFareTextField.text =  String(format:"%.2f",Double(editTimesSlips[indexPath.row-1].taxiFare!)!)
                }
                else
                 {
                   cell.taxFareTextField.text = ""
                }
            }
            else
            {
                cell.taxFareTextField.text = ""
            }
            if editTimesSlips[indexPath.row-1].breakMin!.count>0
            {
            if Double(editTimesSlips[indexPath.row-1].breakMin!)!>0
            {
            cell.lunchTimeTextField.text = editTimesSlips[indexPath.row-1].breakMin!
            }
            else
            {
                cell.lunchTimeTextField.text = ""
            }
            }
            if (cell.startTimeTextField.text!.count>0)&&(cell.endTimeTextField.text?.count)!>0
            {
                self.getHours(start:cell.startTimeTextField.text!, end:cell.endTimeTextField.text!, i:indexPath.row,min:false)
                cell.totalHoursLabel.text = String(format:"%.2f",Double(editTimesSlips[indexPath.row-1].hours!)!)
            }
            else
            {
                cell.totalHoursLabel.text = ""
                editTimesSlips[indexPath.row-1].hours! = ""
            }
            if (cell.lunchTimeTextField.text!.count>0)&&(cell.startTimeTextField.text!.count>0)&&(cell.endTimeTextField.text?.count)!>0
            {
                let timeInTotal = Double(editTimesSlips[indexPath.row-1].hours!)
                let lunchTime = Double((cell.lunchTimeTextField.text)!)!
                editTimesSlips[indexPath.row-1].hours! = String(format:"%.2f",timeInTotal!-lunchTime/60)
                cell.totalHoursLabel.text = editTimesSlips[indexPath.row-1].hours!
               
            }
            else
            {
                editTimesSlips[indexPath.row-1].breakMin! = cell.lunchTimeTextField.text!
            
            }
            
            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
            toolBar.barStyle = UIBarStyle.default
            toolBar.items = [
                UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(keyboardDoneBtnTapped))]
            toolBar.sizeToFit()
            
            cell.lunchTimeTextField.inputAccessoryView = toolBar
          
            cell.taxFareTextField.inputAccessoryView = toolBar

            cell.selectionStyle = .none
            return cell
        }
    }
}
extension EditTimeSlipViewController:DateTimePickerDelegate
{
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        
        print(picker.selectedDateString)
    }
}
extension EditTimeSlipViewController:UITextFieldDelegate
{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if (textField.tag>7&&textField.tag<16)||(textField.tag>96&&textField.tag<104)
        {
            activeTextField = textField
            self.view.endEditing(true)
            if cleared
            {
                cleared = false
                
            }
            else
            {
                if textField.text?.count == 0{
                    self.showPicker(ampm:false,selectedDate: Date())
                }else{
                    let TimeValue = textField.text
                    let dateFormatter1 = DateFormatter()
                    dateFormatter1.locale = Locale.preferredLocale()
                    dateFormatter1.dateFormat = "MM/dd/yyyy hh:mm a"
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale.preferredLocale()
                    dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
                    let myString = dateFormatter.string(from: Date())//"07/26/2018 01:28 PM"
                    let yourDate = dateFormatter.date(from: myString)//2018-07-26 07:58:00 +0000
                    
                    dateFormatter.dateFormat = dateFormat
                    // again convert your date to string
                    let date = dateFormatter.string(from: yourDate!)
                    let time = date+" "+TimeValue!//
                    let sDate = dateFormatter1.date(from: time)
                    self.showPicker(ampm:false,selectedDate: sDate!)
                }
            }
            return false
            
        }
        else if textField.tag<3
        {
            activeTextField = textField
            if cleared
            {
                cleared = false
                textField.endEditing(true)
            }
            else
            {
                if textField.text?.count == 0{
                    self.showPicker(ampm:false,selectedDate: Date())
                }else{
                    let TimeValue = textField.text
                    let dateFormatter1 = DateFormatter()
                    dateFormatter1.locale = Locale.preferredLocale()
                    dateFormatter1.dateFormat = "MM/dd/yyyy hh:mm a"
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale.preferredLocale()
                    dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
                    let myString = dateFormatter.string(from: Date())//"07/26/2018 01:28 PM"
                    let yourDate = dateFormatter.date(from: myString)//2018-07-26 07:58:00 +0000
                    
                    dateFormatter.dateFormat = dateFormat
                    // again convert your date to string
                    let date = dateFormatter.string(from: yourDate!)
                    let time = date+" "+TimeValue!
                    let sDate = dateFormatter1.date(from: time)
                    self.showPicker(ampm:false,selectedDate: sDate!)
                }            }
             return false
        }
        else
        {
            return true
            
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
//        if activeTextField != nil
//        {
//            if (textField.tag)>128&&(textField.tag)<136||(textField.tag)>102&&(textField.tag)<113||(textField.tag)>2&&(textField.tag)<5
//            {
//                activeTextField?.resignFirstResponder()
//            }
//        }
        activeTextField = textField
//        if (textField.tag>7&&textField.tag<16)||(textField.tag>96&&textField.tag<104)
//        {
//            textField.resignFirstResponder()
//            if cleared
//            {
//                cleared = false
//                textField.endEditing(true)
//            }
//            else
//            {
//                self.showPicker(ampm:false)
//            }
//        }
//         else if textField.tag<3
//        {
//            textField.resignFirstResponder()
//            if cleared
//            {
//                cleared = false
//                textField.endEditing(true)
//            }
//            else
//            {
//                self.showPicker(ampm:false)
//            }
//        }
        
            
        if textField.tag>128&&textField.tag<135
        {
            textField.becomeFirstResponder()
        }
        else if textField.tag>102&&textField.tag<113
        {
            textField.becomeFirstResponder()
            
        }
//        if cleared
//        {
//            cleared = false
//            textField.endEditing(true)
//        }
//        else
//        {
//
//        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.tag>7&&textField.tag<16)
        {
            self.editTimesSlips[textField.tag-8].startTime = textField.text!
            editTableView.reloadData()

        }
        else if (textField.tag>96&&textField.tag<104)
        {
            self.editTimesSlips[textField.tag-97].endTime = textField.text!
            editTableView.reloadData()
        }
        else if textField.tag>128&&textField.tag<136
        {
            self.editTimesSlips[textField.tag-129].breakMin = textField.text!
            editTableView.reloadData()
        }
        else if textField.tag>112&&textField.tag<119
        {
            self.editTimesSlips[textField.tag-113].taxiFare = textField.text!
            editTableView.reloadData()
        }
        else if textField.tag == 3
        {
            self.total()
        }
        else if textField.tag<3
        {
           
        }
        
        
    }
    public func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        if (textField.tag>7&&textField.tag<16)
        {
            self.editTimesSlips[textField.tag-8].startTime = ""
            editTableView.reloadData()
            
        }
        else if (textField.tag>96&&textField.tag<104)
        {
            self.editTimesSlips[textField.tag-97].endTime = ""
            editTableView.reloadData()
        }
        else if textField.tag>128&&textField.tag<136
        {
            self.editTimesSlips[textField.tag-129].breakMin = ""
            editTableView.reloadData()
        }
        else if textField.tag>112&&textField.tag<119
        {
            self.editTimesSlips[textField.tag-113].taxiFare = ""
            editTableView.reloadData()
        }
        else if textField.tag == 3
        {
            self.total()
        }
        else if textField.tag<3
        {
            textField.text = ""
            print("cleared")
            self.total()
        }
        cleared = true
        return true
    }
}
extension UITableView {
    func indexPathForView(view: AnyObject) -> IndexPath? {
        let originInTableView = self.convert(CGPoint.zero, from: (view as! UIView))
        return (self.indexPathForRow(at:originInTableView)! as IndexPath)
    }
}
