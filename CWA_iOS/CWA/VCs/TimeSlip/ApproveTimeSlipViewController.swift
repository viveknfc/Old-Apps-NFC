//
//  ApproveTimeSlipViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 15/12/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON
import FSCalendar
import FloatRatingView
class ApproveTimeSlipViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,ApproveTimeSheetDetailsDelegate,UITextFieldDelegate,FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance,UITextViewDelegate,FloatRatingViewDelegate {
    
    var customCalendarView = CalendarView()
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var approveAllButton: ShadowButton!
    @IBOutlet weak var empWithNoTimeSlipButton: ShadowButton!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var segControlHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var SuperViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ScrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var empWithNoTSBtnTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var baseScrollView: UIScrollView!
    
    var isApproveWarning = false
    var isGenerateInvoice = false

    var approveDataObject = NSDictionary()
    
    var customPickerView = JPPickerView()
    
    var datas = NSMutableArray()
    var approvedDatas = NSMutableArray()
    var pendingDatas = NSMutableArray()
    var prevDate = String()
    var checkedTimeSlipDatas = NSMutableArray()
    var NoIbClient = ""
    var infoMessage = ""
    var weekending = ""
    var willShowNoteAlert = "0"
    var DivisionId = ""
    let pendingTSMessage = "All pending timeslip(s) have been approved"
    let approvedTSMessage = "No approved timeslips"
    var showOnlyView = false
    var showBothViewEdit = false
    var showViewOREdit = false
    
    var showApprove = false
    var showGenerateInvoice = false
    
    var showPDF = false
    var showDetailApproveReject = false
    var isFromMenu = false
    var isFromSafety = false
    var IsClientAttorney = -1
    var New = -1
    var CApp = -1
    var CNew = -1
    var StartDate = ""
    var EndDate = ""
    
    var isMessageStatusSuccess = ""
    @IBOutlet var startDateView: UIView!
    @IBOutlet var startDateTxtField: UITextField!
    @IBOutlet var endDateView: UIView!
    @IBOutlet var endDateTxtField: UITextField!
    @IBOutlet weak var calendarBGView: UIView!
    @IBOutlet weak var calendar: FSCalendar!
    var commentPopupView = EmpEvaluationPopup()
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    var resultFromDate = String()
    var resultToDate = String()
    var selecetdFromDate = Date()
    var selecetdToDate = Date()
    let StartDateTextFieldTag = 702
    let EndDateTextFieldTag = 703
    var FirstRespondertextFieldTag = 0
    
    @IBOutlet weak var StartDateArrowImg: UIImageView!
    @IBOutlet weak var EndDateArrowImg: UIImageView!
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
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
    
    
    
    
    var getApproveTSObj = GetApproveTimeSlip.init(TypeValue: 0,WeekEnding: "",CandId: 0,Name: "",Hours: "",approvedBy: "",referenceBy: "",Approved: 0,TimeId: 0,OrderId: 0,BillDate: "",PrevBillDate:"",ShowOT: "")
    
    
    func addBorderToView(viewT: UIView){
        
        viewT.layer.borderColor = borderColor.cgColor
        viewT.layer.borderWidth = 1
        
    }
    func addRightImageToTextField(textField: UITextField,imageName: String ){
        
        let imageView = UIImageView.init(frame: CGRect(x:0,y:0,width:20,height:20));
        let image = UIImage(named: imageName);
        imageView.image = image;
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        textField.rightView = imageView;
        textField.rightViewMode = UITextField.ViewMode.always
        textField.rightViewMode = .always
        
    }
    @objc override func appWillEnterForeground(){
        print("appWillEnterForeground Division")
        if datas.count == 0{
            self.getApproveTimeSheetTimeSlips()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isPortrait() == true{
            self.baseScrollView.isScrollEnabled = false
        }else{
            let  screenWidth =  UIScreen.main.bounds.size.width
            let  screenHeight =  UIScreen.main.bounds.size.height
            print(screenWidth,screenHeight)
            DispatchQueue.main.async(execute: { () -> Void in
                self.baseScrollView.isScrollEnabled = true
                self.baseScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.width)
                self.SuperViewHeightConstraint.constant = UIScreen.main.bounds.size.width
                self.view.bringSubviewToFront(self.buttonView)
            })
        }
        
        self.setupCommentPopupView()
        self.setupCalendarView()
        self.addBorderToView(viewT:startDateView)
        self.addBorderToView(viewT:endDateView)
        self.addRightImageToTextField(textField: startDateTxtField,imageName: "calendar_icon.png")
        self.addRightImageToTextField(textField: endDateTxtField,imageName: "calendar_icon.png")
        
        //        self.title = "Approve TimeSlips"
        segControl.selectedSegmentIndex = 0
        segControlHeightConstraint.constant = 40
        segControl.layer.cornerRadius = 0
        segControl.layer.masksToBounds = true
        segControl.layer.cornerRadius = 0
        segControl.layer.borderColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String).cgColor
        segControl.layer.borderWidth = 1
        segControl.layer.masksToBounds = true
        segControl.layoutIfNeeded()
        
        segControl.tintColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        noDataView.isHidden = true
        noDataView.backgroundColor = UIColor(hexString:success_background_Color)
        lblNoData.textColor = UIColor(hexString:success_Color)
        
        //        self.getApproveTimeSheetTimeSlips()
        
        //        DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        //
        //        if DivisionId == "6"{ // Law dept
        //            approveAllButton.isHidden = true
        //        }else{
        //            approveAllButton.isHidden = false
        //        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titlelbl.text = "Approve Timeslips"
        if self.willShowNoteAlert == "1"{
            self.startDateTxtField.text = ""
            self.endDateTxtField.text = ""
        }
        self.getApproveTimeSheetTimeSlips()
        
    }
    func isTSAppoved(_ isApproved: Bool) {
        if isApproved{
            self.getApproveTimeSheetTimeSlips()
        }
    }
    func pushToClientInvoicePage(){
        
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is ClientInvoiceViewController {
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ClientInvoiceSegue") as! ClientInvoiceViewController
            nextViewController.MessageParam = "Approve"
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: Button Action
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl)
    {
        if isMessageStatusSuccess == "1"{
            noDataView.isHidden = true
            if sender.selectedSegmentIndex == 0 {
                selectAllButton.isHidden = false
                approveAllButton.isHidden = false
                if pendingDatas.count == 0{
                    noDataView.isHidden = false
                    buttonView.isHidden = true
                    selectAllButton.isHidden = true
                    
                    lblNoData.text = pendingTSMessage
                }
                approveAllButton.setTitle("Approve", for: .normal)
                //                empWithNoTimeSlipButton.frame.origin.x = 6
                empWithNoTSBtnTrailingConstraint.constant =  117
                buttonView.layoutIfNeeded()
            }else{
                
                self.showForApprovedSegment()
            }
            listTableView.reloadData()
            self.updateScrollviewForScreenOrientation()
        }
        
        
    }
    func showForApprovedSegment(){
        
        selectAllButton.isHidden = true
        approveAllButton.isHidden = true
        
        if approvedDatas.count == 0{
            noDataView.isHidden = false
            lblNoData.text = approvedTSMessage
        }
        if pendingDatas.count == 0 && approvedDatas.count > 0{
            buttonView.isHidden = false
            
            if showGenerateInvoice == true {
                approveAllButton.isHidden = false
                approveAllButton.setTitle("Generate Invoice", for: .normal)
            }
        }
        if approveAllButton.isHidden == true{
            empWithNoTSBtnTrailingConstraint.constant =  buttonView.bounds.size.width/2
            buttonView.layoutIfNeeded()
            //            empWithNoTimeSlipButton.center = CGPoint(x: buttonView.bounds.size.width/2, y: 4 + empWithNoTimeSlipButton.frame.size.height/2 )
        }else{
            //            empWithNoTimeSlipButton.frame.origin.x = 6
            
        }
        
    }
    @IBAction func selectAllBtnAction(_ sender: UIButton)
    {
        
        
        checkedTimeSlipDatas.removeAllObjects()
        if sender.isSelected == true{
            sender.isSelected = false
        }else if sender.isSelected == false{
            sender.isSelected = true
        }
        let tempArray = NSMutableArray()
        
        for dict in pendingDatas{
            
            let  tsObj:GetApproveTimeSlip = dict as! GetApproveTimeSlip
            if sender.isSelected == true{
                tsObj.isApproveSelected = 1
            }else{
                tsObj.isApproveSelected = 0
            }
            
            let approved = tsObj.Approved
            if approved == 0 && sender.isSelected == true{
                checkedTimeSlipDatas.add(tsObj)
            }
            
            tempArray.add(tsObj)
        }
        
        pendingDatas = tempArray
        //        print(datas)
        
        listTableView.reloadData()
        
    }
    @IBAction func approveAllBtnAction(_ sender: Any)
    {
        if pendingDatas.count == 0 && approvedDatas.count > 0 && showGenerateInvoice == true{
       self.generateInvoiceServerCall()
        }else{
            
            self.approveTimeSlipPostServerCall()
        }
        
        
    }
    @IBAction func empWithNoTimeSlipButtonAction(_ sender: UIButton)
    {
        
        self.pushToEmployeeWithNoTimeSlipPage()
    }
    @IBAction func infoBtnAction(_ sender: Any)
    {
        //        self.ShowCommentPopup()
        //WARNing: Remove Top Part
        
        //        "You must check at least one time slip to be approved."
        let m = infoMessage.replacingOccurrences(of: "<br><br>", with: "")
        
        if m.count == 0{
            
            
        }else{
            willShowNoteAlert = "1"
            self.showNoteAlertWithMessage(message: infoMessage)
            
            //            self.ShowAlertMessage(message: infoMessage, title: "" )
        }
        
    }
    @IBAction func approveCheckButtonTapped(_ sender: UIButton){
        let senderPosition  = sender.convert(CGPoint.zero, to: listTableView)
        
        let indexPath =  listTableView.indexPathForRow(at:senderPosition)
        let ts = pendingDatas[(indexPath?.row)!]
        let  tsObj:GetApproveTimeSlip = ts as! GetApproveTimeSlip
        
        let isSelected = tsObj.isApproveSelected
        
        if isSelected == 0{
            tsObj.isApproveSelected = 1
            if !checkedTimeSlipDatas.contains(tsObj){
            
                checkedTimeSlipDatas.add(tsObj)
            }
            
        }else if isSelected == 1{
            tsObj.isApproveSelected = 0
            selectAllButton.isSelected = false
            
            if checkedTimeSlipDatas.contains(tsObj){
                checkedTimeSlipDatas.remove(tsObj)
            }
        }
        
        pendingDatas.replaceObject(at: (indexPath?.row)!, with: tsObj)
        
        listTableView.reloadData()
    }
    @IBAction func approveButtonTapped(_ sender: UIButton){
        
        let senderPosition  = sender.convert(CGPoint.zero, to: listTableView)
        
        let indexPath =  listTableView.indexPathForRow(at:senderPosition)
        let ts = pendingDatas[(indexPath?.row)!]
        let  tsObj:GetApproveTimeSlip = ts as! GetApproveTimeSlip
       //this is for single approve
        checkedTimeSlipDatas.removeAllObjects()
             checkedTimeSlipDatas.add(tsObj)
 
//        self.approveTimeSlipPostServerCall()
        if pendingDatas.count == 0 && approvedDatas.count > 0 && showGenerateInvoice == true{
            self.generateInvoiceServerCall()
        }else{
            
            self.approveTimeSlipPostServerCall()
        }
        
        
    }
    
    @IBAction func viewEditButtonTapped(_ sender: UIButton){
        
        let senderPosition  = sender.convert(CGPoint.zero, to: listTableView)
        
        let indexPath =  listTableView.indexPathForRow(at:senderPosition)
        if segControl.selectedSegmentIndex == 0{
            let s = pendingDatas[(indexPath?.row)!] as! GetApproveTimeSlip
            if showPDF == true {//Test Company (Test Division)
                //Open PDF Page
                let timeID = String(format:"%d",s.TimeId!)
                self.pushToViewPDFPage(timeID: timeID)
            }else{
                self.pushToViewEditPage(getApproveObj: s,isFromApprovedList: false)
            }
        }else{
            let s = approvedDatas[(indexPath?.row)!] as! GetApproveTimeSlip
            if showPDF == true {//Test Company (Test Division)
                //Open PDF Page
                let timeID = String(format:"%d",s.TimeId!)
                self.pushToViewPDFPage(timeID: timeID)
            }else{
                self.pushToViewEditPage(getApproveObj:s,isFromApprovedList: true)
            }
        }
    }
    @IBAction func viewButtonTapped(_ sender: UIButton){
        
        let senderPosition  = sender.convert(CGPoint.zero, to: listTableView)
        
        let indexPath =  listTableView.indexPathForRow(at:senderPosition)
        if DivisionId == "6"{
            //open list page
            if segControl.selectedSegmentIndex == 0{
                let s = pendingDatas[(indexPath?.row)!] as! GetApproveTimeSlip
                self.pushToViewEditPage(getApproveObj: s,isFromApprovedList: false)
            }else{
                let s = approvedDatas[(indexPath?.row)!] as! GetApproveTimeSlip
                self.pushToViewEditPage(getApproveObj:s,isFromApprovedList: true)
            }
        }else{
            //open PDf
            if segControl.selectedSegmentIndex == 0{
                let s = pendingDatas[(indexPath?.row)!] as! GetApproveTimeSlip
                let timeID = String(format:"%d",s.TimeId!)
                self.pushToViewPDFPage(timeID: timeID)
            }else{
                let s = approvedDatas[(indexPath?.row)!] as! GetApproveTimeSlip
                let timeID = String(format:"%d",s.TimeId!)
                self.pushToViewPDFPage(timeID: timeID)
            }
        }
    }
    @IBAction func editButtonTapped(_ sender: UIButton){
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.listTableView)
        let indexPath = self.listTableView.indexPathForRow(at: buttonPosition)
        print(indexPath!.row)
        
        if segControl.selectedSegmentIndex == 0
        {
            
            getApproveTSObj = pendingDatas[indexPath!.row] as! GetApproveTimeSlip
        }
        else
        {
            
            getApproveTSObj = approvedDatas[indexPath!.row] as! GetApproveTimeSlip
            
        }
        
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is EditTimeSlipViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier:"EditTimeSheetSegue") as! EditTimeSlipViewController
            nextViewController.getApproveTSObj = getApproveTSObj
            nextViewController.prevDate = prevDate
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
        //self.performSegue(withIdentifier:"editSegue", sender:nil)
        
    }
    @IBAction func evaluateButtonTapped(_ sender: UIButton){
        
        //        self.ShowCommentPopup()
        let senderPosition  = sender.convert(CGPoint.zero, to: listTableView)
        
        let indexPath =  listTableView.indexPathForRow(at:senderPosition)
        var s = datas[(indexPath?.row)!] as! GetApproveTimeSlip
        if segControl.selectedSegmentIndex == 0{
            s = pendingDatas[(indexPath?.row)!] as! GetApproveTimeSlip
        }else{
            s = approvedDatas[(indexPath?.row)!] as! GetApproveTimeSlip
            
        }
        getApproveTSObj = s
        
        self.getEvaluateEmployeeServerCall()
        
    }
    //MARK:- GoBack
    override func goBack() {
        if isFromSafety {
            popToDasboardPageDirectly()
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - SERVER CALL
    func generateInvoiceServerCall(){
        
        //Do server call for
        let defaults = UserDefaults.standard
        
        let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
        let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            
            let urlString = RestAPI.BaseUrl+RestAPI.approvePendingTSURL
            
            if pendingDatas.count == 0 && approvedDatas.count > 0 && showGenerateInvoice == true{
                
                let ApproveList = NSMutableArray()
                for dict in approvedDatas{
                    
                    let  ts:GetApproveTimeSlip = dict as!  GetApproveTimeSlip
                    
                    let tsObj = ["Hours":ts.Hours,
                                 "BillDate":ts.BillDate,
                                 "Name":ts.Name,
                                 "timeId":String(format:"%d",ts.TimeId!),
                                 "IsApprove":"true",
                                 "Weekending":ts.WeekEnding,
                                 "Previousdate":"",
                                 "New": "1"
                    ]
                    if ApproveList.contains(tsObj){
                    }else{
                        ApproveList.add(tsObj)
                    }
                }
                
                let param = ["ContactId": ContactId,
                             "ClientId": clientID,
                             "ApproveConfirmation":"0",
                             "PreviousDate":weekending,
                             "Command":"Generate Invoice",
                             "OSSource": "iOS",
                             "ApproveList":ApproveList] as [String : Any]  as NSDictionary
                
                print(param)
                JustHUD.shared.showInView(view: (self.view)!)
                
                RestAPI.generateInvoicePostRequestWithToken(urlString: urlString, params: param, callback: getGenerateInvoiceResponse(response:))
                
                
            }
        }else{
            isApproveWarning = false
            isGenerateInvoice = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
            //            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
            
        }
    }

    func approveTimeSlipPostServerCall(){
        
        //Do server call for
        let defaults = UserDefaults.standard
        
        let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
        let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            
            let urlString = RestAPI.BaseUrl+RestAPI.approvePendingTSURL
            
            if pendingDatas.count == 0 && approvedDatas.count > 0 && showGenerateInvoice == true{
                
                let ApproveList = NSMutableArray()
                for dict in approvedDatas{
                    
                    let  ts:GetApproveTimeSlip = dict as!  GetApproveTimeSlip
                    
                    let tsObj = ["Hours":ts.Hours,
                                 "BillDate":ts.BillDate,
                                 "Name":ts.Name,
                                 "timeId":String(format:"%d",ts.TimeId!),
                                 "IsApprove":"true",
                                 "Weekending":ts.WeekEnding,
                                 "Previousdate":"",
                                 "New": "1"
                    ]
                    if ApproveList.contains(tsObj){
                    }else{
                        ApproveList.add(tsObj)
                    }
                }
                
                let param = ["ContactId": ContactId,
                             "ClientId": clientID,
                             "ApproveConfirmation":"0",
                             "PreviousDate":weekending,
                             "Command":"Generate Invoice",
                             "OSSource": "iOS",
                             "ApproveList":ApproveList] as [String : Any]  as NSDictionary
                
                print(param)
                JustHUD.shared.showInView(view: (self.view)!)
                
                RestAPI.postRequestWithToken(urlString: urlString, params: param, callback: getApproveResponse(response:))
                
                
            }else{
                if checkedTimeSlipDatas.count == 0{
                    isApproveWarning = false
                    isGenerateInvoice = false
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "You must check at least one time slip to be approved.", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                    
                    //                    self.ShowAlertMessage(message: "You must check at least one time slip to be approved.", title: "" )
                }else{
                    self.ApproveTSServerCall(URLString: urlString, ContactId: ContactId, clientID: clientID,isShowOT : true)
                }
                
            }
        }else{
            isApproveWarning = false
            isGenerateInvoice = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
            //            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
            
        }
    }
    
    func ApproveTSServerCall(URLString: String,ContactId: String,clientID: String,isShowOT: Bool){
        
        let ApproveList = NSMutableArray()
        for dict in checkedTimeSlipDatas{
            
            let  ts:GetApproveTimeSlip = dict as!  GetApproveTimeSlip
            var ShowOT = ""
            if isShowOT == true{
                if ts.ShowOT != nil{
                    ShowOT = ts.ShowOT!
                }
            }
            let tsObj = ["Hours":ts.Hours,
                         "BillDate":ts.BillDate,
                         "Name":ts.Name,
                         "timeId":String(format:"%d",ts.TimeId!),
                         "IsApprove":"true",
                         "Weekending":ts.WeekEnding,
                         "OSSource": "iOS",
                         "Previousdate":"",//ts.BillDate,
                "New":"0",
                "ShowOT": ShowOT
            ]
            if ApproveList.contains(tsObj){
            }else{
                ApproveList.add(tsObj)
            }
        }
        
        let param = ["ContactId": ContactId,
                     "ClientId": clientID,
                     "ApproveConfirmation":"0",
                     "PreviousDate":weekending,
                     "OSSource": "iOS",
                     "Command":"Approve",//Generate Invoice
            "ApproveList":ApproveList] as [String : Any]  as NSDictionary
        
        print(param)
        approveDataObject = param
        JustHUD.shared.showInView(view: (self.view)!)
        
        RestAPI.postRequestWithToken(urlString: URLString, params: param, callback: getApproveDataResponse(response:))
    }
    func getApproveTimeSheetTimeSlips() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let DivisionId = String(format:"%d", defaults.integer(forKey: "DivisionId"))
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            StartDate = startDateTxtField.text!
            EndDate = endDateTxtField.text!
            
            //userid as String
            let params :[String:String] = ["ContactId":ContactId,"ClientID":clientID,"DivisionId":DivisionId,"StartDate":StartDate,"EndDate":EndDate]
            print(params)
            RestAPI.getApproveTimeSheetTimeSlips(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
            
        }else{
            isApproveWarning = false
            isGenerateInvoice = false
            //            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    
    func getApproveDataResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            
            //            self.ShowAlertMessage(message: response as! String, title: "")
            isApproveWarning = false
            isGenerateInvoice = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            if object["MessageStatus"].intValue == 1
            {
                
                let message = object["Message"].stringValue
                if (message.caseInsensitiveCompare("Approved successfully") == ComparisonResult.orderedSame){
                    
                    
                    checkedTimeSlipDatas.removeAllObjects()
                    
                    self.getApproveTimeSheetTimeSlips()
                    isApproveWarning = false
                    isGenerateInvoice = false
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                    
                }else{
                    
                    isApproveWarning = true
                    isGenerateInvoice = false
                    let htmlString = "<html>" + message + "</html>"
                    
                    let messageText = htmlString.htmlToAttributedString
                    self.showCustomAlert(Title: "", attMessage: messageText! , message: message , okBtnTitle: "OK", cancelBtnTitle: "Cancel", type: Warning_Text,isAttributed: true)
                }
                
            }else{
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                isApproveWarning = false
                isGenerateInvoice = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
        
    }
    @IBAction override func okButtonTapped(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        if isApproveWarning == true{
            
            let clientID = String(format:"%d", UserDefaults.standard.integer(forKey: "ClientID"))
            let ContactId = String(format:"%d",UserDefaults.standard.integer(forKey: "ContactId"))
            
            let urlString = RestAPI.BaseUrl+RestAPI.approvePendingTSURL
            self.ApproveTSServerCall(URLString: urlString, ContactId: ContactId, clientID: clientID, isShowOT: false)
            
        }else if isGenerateInvoice == true{
            self.pushToClientInvoicePage()
        }
    }
    
    func getGenerateInvoiceResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            
            //            self.ShowAlertMessage(message: response as! String, title: "")
            isApproveWarning = false
            isGenerateInvoice = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            if object["MessageStatus"].intValue == 1
            {
                checkedTimeSlipDatas.removeAllObjects()
                self.getApproveTimeSheetTimeSlips()
                isApproveWarning = false
                isGenerateInvoice = true
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                
                //                self.ShowAlertMessage(message: object["Message"].stringValue, title: "")
                
            }else{
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                isApproveWarning = false
                isGenerateInvoice = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }
        
    }
    
    func getApproveResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            
            //            self.ShowAlertMessage(message: response as! String, title: "")
            isApproveWarning = false
            isGenerateInvoice = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            if object["MessageStatus"].intValue == 1
            {
                checkedTimeSlipDatas.removeAllObjects()
                self.getApproveTimeSheetTimeSlips()
                isApproveWarning = false
                isGenerateInvoice = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                
                //                self.ShowAlertMessage(message: object["Message"].stringValue, title: "")
                
            }else{
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                isApproveWarning = false
                isGenerateInvoice = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }
        
    }
    func getSaveEmpEvaluationResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            
            //            self.ShowAlertMessage(message: response as! String, title: "")
            isApproveWarning = false
            isGenerateInvoice = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                let message = object["Message"].stringValue
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                self.navigationController?.view.makeToast("Please wait...", duration: 3.0, position: .bottom, title: "", image: nil)
                
                self.getApproveTimeSheetTimeSlips()
                
            }else{
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }
        
    }
    func getResponse(response:AnyObject)->()
    {
        self.navigationController?.view.hideAllToasts()
        
        JustHUD.shared.hide()
        checkedTimeSlipDatas.removeAllObjects()

        print(response)
        if response is String{
            
            //            self.ShowAlertMessage(message: response as! String, title: "")
            isApproveWarning = false
            isGenerateInvoice = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
                isMessageStatusSuccess = "1"
                self.prevDate = object["PrevBillDate"].stringValue
                let dataArray = object["ApproveList"].array
                datas .removeAllObjects()
                pendingDatas.removeAllObjects()
                approvedDatas.removeAllObjects()
                NoIbClient = String(format:"%d",object["NoIbClient"].intValue)
                weekending  = self.getFormattedDate(string: (object["PrevBillDate"].stringValue))
                infoMessage = String(format:"%@<br><br>%@",object["Notes"].stringValue,object["Notessecond"].stringValue)
                IsClientAttorney = object["IsClientAttorney"].intValue
                New = object["New"].intValue
                CApp = object["CApp"].intValue
                CNew = object["CNew"].intValue
                if self.startDateTxtField.text?.count == 0{
                    self.startDateTxtField.text = object["StartDayOfMonth"].stringValue
                    StartDate = object["StartDayOfMonth"].stringValue
                    resultFromDate = StartDate
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale.preferredLocale()
                    dateFormatter.dateFormat = dateFormat
                    selecetdFromDate = dateFormatter.date(from: StartDate)!
                    
                }else{
                    self.startDateTxtField.text = object["StartDate"].stringValue
                    StartDate = object["StartDate"].stringValue
                    resultFromDate = StartDate
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale.preferredLocale()
                    dateFormatter.dateFormat = dateFormat
                    selecetdFromDate = dateFormatter.date(from: StartDate)!
                    
                }
                
                if self.endDateTxtField.text?.count == 0{
                    self.endDateTxtField.text = object["EndDayOfMonth"].stringValue
                    EndDate = object["EndDayOfMonth"].stringValue
                    resultToDate = EndDate
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale.preferredLocale()
                    dateFormatter.dateFormat = dateFormat
                    selecetdToDate = dateFormatter.date(from: EndDate)!
                    
                }else{
                    self.endDateTxtField.text = object["EndDate"].stringValue
                    EndDate = object["EndDate"].stringValue
                    resultToDate = EndDate
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale.preferredLocale()
                    dateFormatter.dateFormat = dateFormat
                    selecetdToDate = dateFormatter.date(from: EndDate)!
                    
                    
                }
                
                
                
                for dict in dataArray! {
                    
                    let WeekEnding = self.getFormattedDate(string: (dict["WeekEnding"].stringValue))
                    let BillDate = self.getFormattedDate(string: (dict["Billdate"].stringValue))
                    let PrevBillDate = self.getFormattedDate(string: (dict["PrevBillDate"].stringValue))
                    let ShowOT = dict["ShowOT"].stringValue
                    var isSelected = 0
                    if selectAllButton?.isSelected == true{
                        isSelected = 1
                    }
                    let div = GetApproveTimeSlip.init(TypeValue: dict["Type"].intValue,WeekEnding: WeekEnding,CandId: dict["CandId"].intValue,Name: dict["Name"].stringValue,Hours:  (dict["Hours"].stringValue),approvedBy: dict["Approvers"].stringValue,referenceBy: dict["PoNumber"].stringValue,Approved: dict["New"].intValue,TimeId: dict["TimeId"].intValue,isApproveSelected: isSelected,OrderId: dict["OrderId"].intValue,BillDate: BillDate,PrevBillDate:PrevBillDate,ShowOT: ShowOT
                    )
                    let approved = div.Approved
                    if approved == 0{
                        pendingDatas.add(div)
                    }else{
                        approvedDatas.add(div)
                    }
                    
                    datas.add(div)
                }
                
                
                listTableView.reloadData()
                var message = object["NotesSuccess"].stringValue
                if message.count == 0{
                    if segControl.selectedSegmentIndex == 0{
                        message = pendingTSMessage
                    }else{
                        message = approvedTSMessage
                    }
                }
                noDataView.isHidden = false
                lblNoData.text = message
                buttonView.isHidden = false
                
                if datas.count == 0{
                    noDataView.isHidden = false
                    buttonView.isHidden = true
                    selectAllButton.isHidden = true
                }else{
                    selectAllButton.isHidden = false

                    if pendingDatas.count == 0{
                        if segControl.selectedSegmentIndex == 0{
                            noDataView.isHidden = false
                            buttonView.isHidden = true
                        }else{
                            noDataView.isHidden = true
                        }
                    }else{
                        
                        noDataView.isHidden = true
                        buttonView.isHidden = false
                        
                    }
                    noDataView.backgroundColor = UIColor(hexString:success_background_Color)
                    lblNoData.textColor = UIColor(hexString:success_Color)
                    
                    self.checkConditionsForShowingBtn()
                    self.checkConditionsForShowingApproveBtn()
                    self.updateScrollviewForScreenOrientation()
                }
                
                let m = infoMessage.replacingOccurrences(of: "<br><br>", with: "")
                
                if m.count == 0{
               
                    infoButton.isHidden = true
                }else{
                    infoButton.isHidden = false
                    self.showNoteAlertWithMessage(message: infoMessage)
                }
                
            }else{
                buttonView.isHidden = true
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                isMessageStatusSuccess = "0"
                noDataView.isHidden = false
                lblNoData.text = "No data found"
                noDataView.backgroundColor = UIColor(hexString:danger_background_Color)
                lblNoData.textColor = UIColor(hexString:danger_Color)
                isApproveWarning = false
                isGenerateInvoice = false
//                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
    }
    func getEvaluateEmployeeServerCall() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let orderid = String(format:"%d",getApproveTSObj.OrderId!)
            let candId = String(format:"%d",getApproveTSObj.CandId!)
            let TimeId = String(format:"%d",getApproveTSObj.TimeId!)
            
            let params:[String : String] = ["TimeId":TimeId,"OrderId":orderid,"ClientId":clientID,"CandId":candId,"CandName":getApproveTSObj.Name!]
            
            print(params)
            RestAPI.GetEvaluateEmployee(self, params: params , method: "POST", accessToken: "", acces: true, callBack: getEvaluateEmployeeResponse(response:))
            
        }else{
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    
    func getEvaluateEmployeeResponse(response:AnyObject)->()
    {
        JustHUD.shared.hide()
        print(response)
        if response is String{
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }else{
            
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                let Rating = object["Evalution"].doubleValue
                let StatusMessage = object["StatusMessage"].stringValue
                let DisplayMessage = object["DisplayMessage"].stringValue
                let Comments = object["Comments"].stringValue
                
                self.ShowCommentPopupWithRating(Rating: Rating, StatusMessage: StatusMessage, DisplayMessage: DisplayMessage,Comments: Comments)
                
            }else{
                var message = object["message"].stringValue
                if message.count == 0 {
                    message = Error_Message
                }
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
    }
    
    func saveEvaluationServerCall(){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            
            let orderid = String(format:"%d",getApproveTSObj.OrderId!)
            let candId = String(format:"%d",getApproveTSObj.CandId!)
            let TimeId = String(format:"%d",getApproveTSObj.TimeId!)
            let  EmployeeEvaluation = String(format:"%.2f",commentPopupView.floatingView.rating)
            let Comment = commentPopupView.commentTextView.text
            
            let params: [String : String] =  ["OrderId":orderid,
                                              "ClientId":clientID,
                                              "CandId":candId,
                                              "AddComment":Comment!,
                                              "EmployeeEvaluation":EmployeeEvaluation,
                                              "ContactId":ContactId,
                                              "OSSource": "iOS",
                                              "TimeId":TimeId]
            print(params)
            RestAPI.saveEmpEvaluationWithComment(self, params: params  , method: "POST", accessToken: "", acces: true, callBack: getSaveEmpEvaluationResponse(response:))
            
        }else{
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
        
    }
    ///*******////
    //MARK:-  TABLEVIEW DATA SOURCE METHOD
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if segControl.selectedSegmentIndex == 0{
            return pendingDatas.count
        }else{
            return approvedDatas.count
        }
        
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        let cell:ApproveTimeSlipTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ApproveTimeSlipTableViewCellIdentifier") as! ApproveTimeSlipTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        self.addShadowToView(shadowView: cell.bgView)
        cell.btnView.layer.borderColor = UIColor.clear.cgColor
        cell.btnView.layer.borderWidth = 1
        
        var   s = datas[indexPath.row] as! GetApproveTimeSlip
        
        if segControl.selectedSegmentIndex == 0{
            s = pendingDatas[indexPath.row] as! GetApproveTimeSlip
        }else{
            s = approvedDatas[indexPath.row] as! GetApproveTimeSlip
            
        }
        
        let  ts:GetApproveTimeSlip = s
        
        let empName =   ts.Name
        let weekEnd = ts.WeekEnding
        let hours =  ts.Hours
        let approved = ts.Approved
        let isApproveSelected  = ts.isApproveSelected
        cell.lblEmpName.text = empName
        cell.lblDate.text = weekEnd
        cell.lblHours.text = hours
        cell.lblReference.text = String(format:"%@",ts.referenceBy!)
        cell.lblApprovedBy.text = String(format:"%@",ts.approvedBy!)
        
        
        
        cell.evaluateButton.addTarget(self, action:#selector(self.evaluateButtonTapped), for: .touchUpInside)
        
        if approved == 0{
            //Not Approved
            cell.approveButton.isHidden = true
            cell.viewEditButton.isHidden = false
            cell.bgView.backgroundColor = UIColor.white
            cell.approveCheckButton.isHidden = true
            
        }else{
            //Approved
            cell.approveCheckButton.isHidden = true
            cell.approveButton.isHidden = true
            cell.viewEditButton.isHidden = true
            cell.bgView.backgroundColor = UIColor(hexString:"#99FF99")
        }
        
        if showOnlyView == true {
            
            cell.viewEditButton.isHidden = false
            cell.viewEditButton.setTitle("View", for: .normal)
            cell.viewEditButton.addTarget(self, action:#selector(self.viewEditButtonTapped), for: .touchUpInside)
            if approved == 0{
                //Not Approved
                
            }else{
                //Approved
                cell.editButton.isHidden = true
                cell.approveButton.isHidden = true
                cell.approveCheckButton.isHidden = true
                
            }
        }else if showBothViewEdit == true{
            //hide View/Edit Btn,show view & edit Btn
            cell.viewEditView.isHidden = false
            cell.viewEditButton.isHidden = true
            
            cell.editButton.isHidden = false
            cell.approveButton.isHidden = false
            cell.viewButton.isHidden = false
            cell.approveCheckButton.isHidden = false
            
            if approved == 0{
                //Not Approved
                cell.viewButton.setTitle("View", for: .normal)
                cell.editButton.setTitle("Edit", for: .normal)
                
                cell.viewButton.addTarget(self, action:#selector(self.viewButtonTapped), for: .touchUpInside)
                cell.editButton.addTarget(self, action:#selector(self.editButtonTapped), for: .touchUpInside)
            }else{
                //Approved:rename edit button as View else white space is coming
                cell.editButton.isHidden = false
                cell.approveButton.isHidden = true
                cell.approveCheckButton.isHidden = true
                cell.viewEditButton.isHidden = true
                cell.viewButton.isHidden = true
                cell.editButton.setTitle("View", for: .normal)
                cell.editButton.removeTarget(self, action: #selector(self.viewButtonTapped), for: .touchUpInside)
                cell.editButton.addTarget(self, action:#selector(self.viewButtonTapped), for: .touchUpInside)
            }
            
        }else if showViewOREdit == true{
            cell.viewEditView.isHidden = true//hide view & edit butn
            cell.viewEditButton.setTitle("View/Edit", for: .normal)
            cell.viewEditButton.isHidden = false
            cell.viewEditButton.addTarget(self, action:#selector(self.viewEditButtonTapped), for: .touchUpInside)
            if approved == 0{
                //Not Approved
            }else{
                //Approved
                cell.editButton.isHidden = true
                cell.approveButton.isHidden = true
                cell.viewEditButton.isHidden = true
                cell.approveCheckButton.isHidden = true
                
            }
        }else{
            cell.viewEditButton.isHidden = true
            cell.editButton.isHidden = true
            cell.viewButton.isHidden = true
            if approved == 0{
                //Not Approved
            }else{
                //Approved
                cell.editButton.isHidden = true
                cell.approveButton.isHidden = true
                cell.viewEditButton.isHidden = true
                cell.viewButton.isHidden = true
                cell.approveCheckButton.isHidden = true
                
            }
        }
        
        if approved == 0{
            
            if showApprove == true{
                cell.approveCheckButton.addTarget(self, action:#selector(self.approveCheckButtonTapped), for: .touchUpInside)
                cell.approveCheckButton.isHidden = false
                cell.approveButton.isHidden = false
                cell.approveButton.addTarget(self, action:#selector(self.approveButtonTapped), for: .touchUpInside)
            }else{
                cell.approveButton.isHidden = true
                cell.approveCheckButton.isHidden = true
                
            }
            
        }
        if isApproveSelected == 0{
            cell.approveCheckButton.isSelected = false
        }else{
            cell.approveCheckButton.isSelected = true
            
        }
        if cell.approveCheckButton.isHidden == true{
            cell.lblEmpLeadingConstraint.constant = 5
            cell.lblHoursLeadingConstraint.constant = 5
            cell.lblApprovedByLeadingConstraint.constant = 5
            cell.lblDateLeadingConstraint.constant = 5
            cell.lblReferenceLeadingConstraint.constant = 5
        }else{
            cell.lblEmpLeadingConstraint.constant = 38
            cell.lblHoursLeadingConstraint.constant = 38
            cell.lblApprovedByLeadingConstraint.constant = 38
            cell.lblDateLeadingConstraint.constant = 38
            cell.lblReferenceLeadingConstraint.constant = 38
        }
        if selectAllButton.isSelected == true || checkedTimeSlipDatas.count > 1{
            cell.approveButton.isEnabled = false
            cell.approveButton.backgroundColor = UIColor.lightGray
            
        }else{
            cell.approveButton.isEnabled = true
            cell.approveButton.backgroundColor = greenColor
            
        }
        cell.lblColon1.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.lblColon2.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.lblColon3.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.lblColon4.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.lblColon5.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)

        cell.lblColon1.isHidden = true
        cell.lblColon2.isHidden = true
        cell.lblColon3.isHidden = true
        cell.lblColon4.isHidden = true
        cell.lblColon5.isHidden = true

        
        cell.lblEmpNameTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.lblHoursTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.lblDateTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.lblApprovedByTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.lblReferenceTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
        
        
        
        cell.updateConstraints()
        
        return cell
        
    }
    
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 203
        
    }
    
    // MARK: - Navigation
    func pushToViewEditPage(getApproveObj: GetApproveTimeSlip,isFromApprovedList: Bool){
        
        
        
        
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is ApproveTimeSheetDetailsViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ApproveTimeSheetDetailsSegue") as! ApproveTimeSheetDetailsViewController
            
            nextViewController.getApproveTSObj = getApproveObj
            nextViewController.weekending = weekending
            nextViewController.delegate = self
            nextViewController.showOnlyView = showOnlyView
            nextViewController.prevDate = prevDate
            
            if DivisionId == "6" && showOnlyView == true{
                
                let CandId  = String(format:"%d",getApproveObj.CandId!)
                let OrderId  = String(format:"%d",getApproveObj.OrderId!)
                let WeekEnding = getApproveObj.WeekEnding!
                let TimeId = String(format:"%d",getApproveObj.TimeId!)
                
                nextViewController.CandId  = CandId
                nextViewController.OrderId  = OrderId
                nextViewController.WeekEnding = WeekEnding
                nextViewController.TimeId = TimeId
                nextViewController.isFromApprovedList = isFromApprovedList
                
            }
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    func pushToViewPDFPage(timeID: String){
        
        if DivisionId == "6"{
            
        }
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is LoadWebContentViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoadWebContentSegue") as! LoadWebContentViewController
            
            nextViewController.TimeID = timeID
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    //
    func pushToEvaluateEmployeePage(empName: String,orderID: String,CandId: String){
        
        
        
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is EvaluateEmpViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EvaluateEmpSegue") as! EvaluateEmpViewController
            
            nextViewController.empName = empName
            nextViewController.orderID = orderID
            nextViewController.CandId  = CandId
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func pushToEmployeeWithNoTimeSlipPage(){
        
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is EmployeeWithNoTimeSlipListViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EmployeeWithNoTimeSlipListSegue") as! EmployeeWithNoTimeSlipListViewController
            
            nextViewController.weekending = weekending
            
            nextViewController.NoIbClient = NoIbClient
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func showNoteAlertWithMessage(message: String){
        if willShowNoteAlert == "1"{
            
            let htmlString = "<html>" + message
            
            let messageText = htmlString.htmlToAttributedString
            isApproveWarning = false
            isGenerateInvoice = false
            self.showCustomAlert(Title: "Note", attMessage: messageText! , message: message , okBtnTitle: "OK", cancelBtnTitle: "", type: info_Text,isAttributed: true)
            willShowNoteAlert = "0"
        }
    }
    
    
    func checkConditionsForShowingBtn(){
        
        DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
        
        if IsClientAttorney == -1 && New == -1{
            
        }else{
            
            if IsClientAttorney == 0{
                if (DivisionId == "13" || DivisionId == "7" || DivisionId == "16") && New == 0{
                    showBothViewEdit = true
                }else{
                    showViewOREdit = true
                }
            }else if IsClientAttorney == 1{
                showOnlyView = true
                showDetailApproveReject = true
                
            }
            
        }//end of else
        
    }//end of func
    
    
    func checkConditionsForShowingApproveBtn(){
        
        if (IsClientAttorney == 0)
        {
            if ((CNew + CApp) > 0)
            {
                if (CNew == 0 && NoIbClient == "0")
                {
                    //Generate Invoice
                    showGenerateInvoice = true
                    approveAllButton.isHidden = false
                    approveAllButton.setTitle("Generate Invoice", for: .normal)
                }
                else
                {
                    //Approve
                    showApprove = true
                    approveAllButton.isHidden = false
                    
                }
            }else{
                showApprove = true
                
                approveAllButton.isHidden = false
            }
        }else{
            //hide
            approveAllButton.isHidden = true
        }
        if pendingDatas.count == 0{
            approveAllButton.isHidden = true
        }
        if segControl.selectedSegmentIndex == 1{
            self.showForApprovedSegment()
        }
    }
    
    
    //MARK: Textfield Delegate Methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        //show datepicker
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        textField.resignFirstResponder()
        FirstRespondertextFieldTag = textField.tag
        customCalendarView.calendar.reloadData()
        if textField.tag == Int(StartDateTextFieldTag) {
            
             if (StartDate.count) > 0 {
                let date = self.convertDateStringToDefaultDate(dateString: StartDate, formatString: dateFormat)
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.customCalendarView.calendar.setCurrentPage(date, animated: true)
                                        self.customCalendarView.calendar.select(date, scrollToDate: true)

                    })
            }
 
        }else if textField.tag == Int(EndDateTextFieldTag) {
            if (StartDate.count) > 0 {
             }
            if (EndDate.count) > 0 {
                let date = self.convertDateStringToDefaultDate(dateString: EndDate, formatString: dateFormat)
                DispatchQueue.main.async(execute: { () -> Void in
                    self.customCalendarView.calendar.setCurrentPage(date, animated: true)
                    self.customCalendarView.calendar.select(date, scrollToDate: true)
                    
                })
             }
            
        }
        self.customCalendarView.showPickerViewOnSuperView(superView: (self.navigationController?.view)!, isPortrait: self.isPortrait())


    }
    
    //MARK: Show Picker
    func setupCalendarView(){
        customCalendarView = Bundle.main.loadNibNamed("CalendarView", owner: self, options: nil)?[0] as! CalendarView
        customCalendarView.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
        customCalendarView.setupCalendar()
        customCalendarView.calendar.delegate = self
        customCalendarView.calendar.dataSource = self
        
    }
    func setupPickerView(){
        
        self.calendar.layer.borderWidth = 2
        self.calendar.layer.borderColor = UIColor.black.cgColor
        self.calendar.select(Date())
        //        self.view.addGestureRecognizer(self.scopeGesture)
        self.calendar.scope = .month
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        //        self.calendar.appearance.eventDefaultColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        //        self.calendar.appearance.eventSelectionColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        self.calendar.appearance.todayColor = UIColor.clear//bg circle
        self.calendar.appearance.titleTodayColor = UIColor.black
        self.calendar.select(self.calendar.currentPage)
        
        
    }
    func setupJPPickerView(){
        customPickerView = Bundle.main.loadNibNamed("JPPickerView", owner: self, options: nil)?[0] as! JPPickerView
        
        customPickerView.setupUI()
        customPickerView.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
        customPickerView.doneButton.addTarget(self, action:#selector(self.timeButtonTapped), for:.touchUpInside)
        customPickerView.bgButton.addTarget(self, action:#selector(self.timeButtonTapped), for:.touchUpInside)
        
        customPickerView.dtPickerView.addTarget(self, action:#selector(self.datePickerValueChanged), for:.valueChanged)
        //         hoursSegment.tintColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        customPickerView.dtPickerView.setValue(UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String), forKey: "textColor")
        customPickerView.dtPickerView.backgroundColor = UIColor.white
        
    }
    @objc func datePickerValueChanged(sender: UIDatePicker){
        
        let changedDate = sender.date
        //▿ 2017-10-29 11:20:00 +0000
        sender.locale = NSLocale(localeIdentifier: "en_US") as Locale
        
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        let  pickedDateString = formatter.string(from: changedDate as Date)
        
        if FirstRespondertextFieldTag == StartDateTextFieldTag {
            resultFromDate = pickedDateString
            startDateTxtField.text = resultFromDate
            selecetdFromDate =  changedDate
        }else if FirstRespondertextFieldTag == EndDateTextFieldTag{
            resultToDate = pickedDateString
            endDateTxtField.text = resultToDate
            selecetdToDate =  changedDate
        }
        let compare = describeComparison(date1: selecetdFromDate, date2: selecetdToDate)
        print(compare)
        if compare ==  "date1 > date2"{
            if resultToDate.count == 0{
                
            }else{
                
                self.navigationController?.view.makeToast("Start date should be less than end date", duration: 1.5, position: .bottom, title: "", image: nil)
            }
        }else{
            if resultFromDate.count > 0 && resultToDate.count > 0{
                if FirstRespondertextFieldTag == StartDateTextFieldTag {
                    startDateTxtField.text = resultFromDate
                }else if FirstRespondertextFieldTag == EndDateTextFieldTag{
                    endDateTxtField.text = resultToDate
                }
                self.getApproveTimeSheetTimeSlips()
                
            }
        }
        
    }
    @objc func timeButtonTapped(sender:UIButton) {
        
        customPickerView.removePickerViewFromSuperView()
        
    }
    
    
    //MARK: Calendar Methods
    
//     func minimumDate(for calendar: FSCalendar) -> Date {
//        if FirstRespondertextFieldTag == Int(StartDateTextFieldTag){
//            let date = self.convertDateStringToDefaultDate(dateString: "01/01/1997", formatString: dateFormat)
//            return date
//
//        }else if FirstRespondertextFieldTag == Int(EndDateTextFieldTag){
//            let date = self.convertDateStringToDefaultDate(dateString: StartDate, formatString: dateFormat)
//            return date
//
//        }
//        return Date()
//    }
//    func maximumDate(for calendar: FSCalendar) -> Date {
//        if FirstRespondertextFieldTag == Int(StartDateTextFieldTag){
//            let date = self.convertDateStringToDefaultDate(dateString: EndDate, formatString: dateFormat)
//            return date
//
//        }else if FirstRespondertextFieldTag == Int(EndDateTextFieldTag){
//            let date = self.convertDateStringToDefaultDate(dateString: "01/01/3997", formatString: dateFormat)
//            return date
//
//        }
//        return Date()
//    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int
    {
        return 0
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return nil
    }
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        self.calendarHeightConstraint.constant = 0
        self.calendarBGView.isHidden = true
        self.view.layoutIfNeeded()
        
        print("did select date \(self.dateFormatter.string(from: date))")
        
        customCalendarView.removePickerViewFromSuperView()

        
        if FirstRespondertextFieldTag == StartDateTextFieldTag {
            selecetdFromDate = date
            resultFromDate = self.dateFormatter.string(from: date)
         }else if FirstRespondertextFieldTag == EndDateTextFieldTag{
            selecetdToDate = date
            resultToDate = self.dateFormatter.string(from: date)
         }
        
        let compare = describeComparison(date1: selecetdFromDate, date2: selecetdToDate)
        
        print(compare)
        if compare ==  "date1 > date2"{
            if resultToDate.count > 0{
                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                    self.navigationController?.view.makeToast("Start date should be less than end date", duration: 1.5, position: .bottom, title: "", image: nil)
                })
            }
        }else{
            if selecetdFromDate != nil{
                resultFromDate = self.dateFormatter.string(from: date)
                StartDate = resultFromDate

            }
            if selecetdToDate != nil{
                 resultToDate = self.dateFormatter.string(from: date)
                EndDate = resultToDate

            }
            if FirstRespondertextFieldTag == StartDateTextFieldTag {
                 startDateTxtField.text = resultFromDate
             }else if FirstRespondertextFieldTag == EndDateTextFieldTag{
                 endDateTxtField.text = resultToDate
            }
            if resultFromDate.count > 0 && resultToDate.count > 0{
                self.getApproveTimeSheetTimeSlips()
                
            }
        }

    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        if startDateTxtField.isFirstResponder {
            
            //            resultFromDate = self.dateFormatter.string(from: calendar.currentPage)
            
        }else{
            
            resultToDate = self.dateFormatter.string(from: calendar.currentPage)
            
        }
        
        
        self.calendar.select(calendar.currentPage)
        //        self.getHistoricOrdersOnDate(StartDate: resultFromDate, EndDate: resultToDate)
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    deinit {
        print("\(#function)")
    }
    //MARK: Popup
    
    func setupCommentPopupView(){
        
        commentPopupView = Bundle.main.loadNibNamed("EmpEvaluationPopup", owner: self, options: nil)?[0] as! EmpEvaluationPopup
        commentPopupView.setupUI()
        commentPopupView.commentTextView.delegate = self
        commentPopupView.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
        commentPopupView.floatingView.delegate = self
        commentPopupView.cancelBtn.addTarget(self, action:#selector(self.closeCommentBtnTapped), for:.touchUpInside)
        commentPopupView.okBtn.addTarget(self, action:#selector(self.empEvaluationOKBtnTapped), for:.touchUpInside)
        
    }
    func ShowCommentPopupWithRating(Rating: Double,StatusMessage: String,DisplayMessage: String,Comments: String){
        
        commentPopupView.floatingView.rating = Rating
        let changeText = String(format: "(%.f of 5 stars)", Rating)
        commentPopupView.empEvaluationLbl.text = changeText
        if Rating == 0{
            commentPopupView.floatingView.isUserInteractionEnabled = true
            commentPopupView.okBtn.isEnabled = true
            commentPopupView.commentTextView.isUserInteractionEnabled = true
            commentPopupView.okBtn.backgroundColor = UIColor(hexString:"#5CB85C")
        }else{
            commentPopupView.floatingView.isUserInteractionEnabled = false
            commentPopupView.okBtn.isEnabled = false
            commentPopupView.commentTextView.isUserInteractionEnabled = false
            commentPopupView.okBtn.backgroundColor = UIColor(hexString:"#8CC19D")
            
        }
        commentPopupView.commentTextView.text = Comments
        let htmlString = "<html>" + DisplayMessage
        commentPopupView.lblTop.attributedText = htmlString.htmlToAttributedString
        commentPopupView.lblStatus.text = StatusMessage
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        commentPopupView.ShowPopup(superView: appDelegate.window!)
        DispatchQueue.main.async(execute: { () -> Void in
            
            if self.isPortrait() == true{
                self.commentPopupView.baseScrollView.isScrollEnabled = false
                self.commentPopupView.baseScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: 353)
                self.commentPopupView.scrollSubViewHeightConstraint.constant = 353
                self.commentPopupView.layoutIfNeeded()
            }else{
                self.commentPopupView.baseScrollView.isScrollEnabled = true
                self.commentPopupView.baseScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
                self.commentPopupView.scrollSubViewHeightConstraint.constant = UIScreen.main.bounds.size.height - 100
                self.commentPopupView.layoutIfNeeded()
            }
        })
 
    }
    @IBAction func closeCommentBtnTapped(_ sender: UIButton){
        commentPopupView.removeCommentPopupViewFromSuperView()
    }
    
    
    @IBAction func empEvaluationOKBtnTapped(_ sender: UIButton){
        if commentPopupView.floatingView.rating  == 0{
            commentPopupView.lblStatus.text = "Please select the Rating"
        }else{
            commentPopupView.lblStatus.text = ""
            
            self.saveEvaluationServerCall()
            commentPopupView.removeCommentPopupViewFromSuperView()
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
        commentPopupView.whiteBGTopConstraint.constant = 5
        commentPopupView.superViewTopConstraint.constant = 36
        
        commentPopupView.layoutIfNeeded()
        
        
    }
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if self.isPortrait() == true{
            commentPopupView.whiteBGTopConstraint.constant = -50
            commentPopupView.superViewTopConstraint.constant = 0
        }else{
            commentPopupView.whiteBGTopConstraint.constant = -150
            commentPopupView.superViewTopConstraint.constant = 0
        }
        commentPopupView.layoutIfNeeded()
    }
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        commentPopupView.floatingView.rating = rating
        let changeText = String(format: "(%.f of 5 stars)", rating)
        commentPopupView.empEvaluationLbl.text = changeText

        
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        self.customCalendarView.showPickerViewInOrientation(superView: (self.navigationController?.view)!, isPortrait: self.isPortrait())

        if commentPopupView.commentTextView.isFirstResponder == true{
            if self.isPortrait() == true{
                commentPopupView.whiteBGTopConstraint.constant = -50
                commentPopupView.superViewTopConstraint.constant = 0
            }else{
                commentPopupView.whiteBGTopConstraint.constant = -150
                commentPopupView.superViewTopConstraint.constant = 0
            }
            commentPopupView.layoutIfNeeded()
            
        }
        if approveAllButton.isHidden == true{
            empWithNoTSBtnTrailingConstraint.constant =  buttonView.bounds.size.width/2
            buttonView.layoutIfNeeded()
        }
        
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            DispatchQueue.main.async(execute: { () -> Void in
                self.addDivisionNameOnTop()
                self.updateScrollviewForScreenOrientation()
            })
        case .portraitUpsideDown:
            text="PortraitUpsideDown"
        case .landscapeLeft:
            text="LandscapeLeft"
            DispatchQueue.main.async(execute: { () -> Void in
                self.addDivisionNameOnTop()
                
                self.updateScrollviewForScreenOrientation()
            })
        case .landscapeRight:
            text="LandscapeRight"
            DispatchQueue.main.async(execute: { () -> Void in
                self.addDivisionNameOnTop()
                
                self.updateScrollviewForScreenOrientation()
            })
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
        
    }
    func updateScrollviewForScreenOrientation(){
        self.listTableView.isScrollEnabled = true
        if self.isPortrait() == true{
            self.baseScrollView.isScrollEnabled = false
            self.commentPopupView.baseScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.width)
            self.commentPopupView.baseScrollView.isScrollEnabled = false
            self.view.bringSubviewToFront(self.buttonView)
            self.listTableView.isScrollEnabled = true
            self.baseScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: 0)
            self.SuperViewHeightConstraint.constant = 0
            
            self.tableViewBottomConstraint.constant = 5
            self.ScrollViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }else{
            let  screenWidth =  UIScreen.main.bounds.size.width
            let  screenHeight =  UIScreen.main.bounds.size.height
            print(screenWidth,screenHeight)
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                self.baseScrollView.isScrollEnabled = true
                self.listTableView.isScrollEnabled = false
                self.commentPopupView.baseScrollView.isScrollEnabled = true
                self.commentPopupView.baseScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.width)
                var datas = NSMutableArray()
                if self.segControl.selectedSegmentIndex == 0{
                    datas = self.pendingDatas
                }else{
                    datas = self.approvedDatas
                }
                let totalRowHeight = CGFloat(150 + (205 * datas.count))
                let height1 = max(screenHeight, totalRowHeight)
                self.SuperViewHeightConstraint.constant = height1
                self.listTableView.setContentOffset(.zero, animated: true)
                self.baseScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: height1)
            })
        }
    }//end of method
    
}




