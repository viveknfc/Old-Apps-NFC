//
//  CashApplicationController.swift
//  CWA
//
//  Created by NFC User on 6/16/20.
//  Copyright © 2020 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON
import FSCalendar
import IQKeyboardManagerSwift

class CashApplicationController: BaseViewController,FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance{
    
    var customCalendarView = CalendarView()
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    
    @IBOutlet weak var endDateTxtField: UITextField!
    @IBOutlet weak var startDateTxtField: UITextField!
    @IBOutlet weak var startDateView: UIView!
    @IBOutlet weak var endDateView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var dataTable: UITableView!
    var rowsOpen = [Int]()
    var sectionsToDisplay = [String]()
    var selectedSection = Int()
    var noOfRows = [Int]()
    @IBOutlet weak var achButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var amountPaidLabel: UILabel!
    
    @IBOutlet weak var titleClientNameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    var resultFromDate = String()
    var resultToDate = String()
    var selecetdFromDate = Date()
    var selecetdToDate = Date()
    var StartDate = ""
    var EndDate = ""
    let StartDateTextFieldTag = 902
    let EndDateTextFieldTag = 903
    var FirstRespondertextFieldTag = 0
    //  var selectedIndexes = [IndexPath]()
    var cashApplicationObject:JSON = JSON.null
    var submitResponseObject:JSON = JSON.null
    var InvoiceName = ""
    var balanceTag = 1001
    var achFieldTag = 1002
    var commentsTag = 1003
    var calculatedAmount = Double()
    var PaymentType = String()
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var clientNameLabel: UILabel!
    var isWarningmessage = Bool()
    var isSuccessMessage = Bool()
    var scrollableIndexPath = IndexPath()
     var isFromSafety = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculatedAmount = 0
        // Do any additional setup after loading the view.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        
        dataTable.tableFooterView = UIView()
        dataTable.delegate = self
        dataTable.dataSource = self
        sectionsToDisplay = [String]()
        
        startDateView.dropCornerRadius(UIColor.black)
        endDateView.dropCornerRadius(UIColor.black)
        startDateTxtField.tag = StartDateTextFieldTag
        endDateTxtField.tag = EndDateTextFieldTag
        startDateTxtField.delegate = self
        endDateTxtField.delegate = self
        self.setupCalendarView()
        noDataView.isHidden = true
        noDataView.backgroundColor = UIColor(hexString:danger_background_Color)
        
        lblNoData.textColor = UIColor(hexString:danger_Color)
        PaymentType = "ACH"
        self.isWarningmessage = false
        self.isSuccessMessage = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titlelbl.text = "Cash Application Payment Details"
        let divColorCode = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        bottomView.backgroundColor = divColorCode
        self.getDataFromServer()
    }
    
    //MARK:- GetDetailsFromServer
    func getDataFromServer(){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            let defaults = UserDefaults.standard
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            print(clientID)
            let params :[String:String] = ["Client_id":clientID,"StartDate":startDateTxtField.text!,"EndDate":endDateTxtField.text!]
            
            print(params)
            RestAPI.getPaymentDetails(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getCashDataResponse(response:))
        }else{
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
    }
    
    
    func getCashDataResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        cashApplicationObject = response as! JSON
        print(response)
        if response is String{
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            
            //Period4List
            
            if cashApplicationObject["MessageStatus"].intValue == 1
            {
                if cashApplicationObject["PaymentInformationList"].arrayValue.count > 0 {
                    titleClientNameLabel.isHidden = false
                    self.clientNameLabel.text =
                        cashApplicationObject["PaymentInformationList"][0]["ClientName"].stringValue
                }
                else {
                    titleClientNameLabel.isHidden = true
                }
                self.infoLabel.text = cashApplicationObject["Info"].stringValue
                noOfRows = [cashApplicationObject["Period1List"].arrayValue.count,cashApplicationObject["Period2List"].arrayValue.count,cashApplicationObject["Period3List"].arrayValue.count,cashApplicationObject["Period4List"].arrayValue.count,cashApplicationObject["Period5List"].arrayValue.count]
                
                self.totalAmountLabel.text = "Total $\(cashApplicationObject["GrandTotal"].doubleValue)"
                self.amountPaidLabel.text = "Amount Paid $0.00"
                //.stringValue.prefix(10)
                
                if startDateTxtField.text?.count == 0 && endDateTxtField.text?.count == 0{
                    StartDate =  self.getFormattedDate(string: (String(cashApplicationObject["StartDate"].stringValue.prefix(19))))
                    EndDate = self.getFormattedDate(string: (String(cashApplicationObject["EndDate"].stringValue.prefix(19))))
                    resultFromDate = StartDate
                    resultToDate = EndDate
                    
                    startDateTxtField.text = StartDate
                    endDateTxtField.text = EndDate
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale.preferredLocale()
                    dateFormatter.dateFormat = dateFormat
                    if StartDate.count == 0 && EndDate.count == 0{}else{
                        selecetdFromDate = dateFormatter.date(from: StartDate)!
                        selecetdToDate = dateFormatter.date(from: EndDate)!}
                }
                
                if cashApplicationObject["Period1List"].arrayValue.count == 0 && cashApplicationObject["Period1List"].arrayValue.count == 0 && cashApplicationObject["Period1List"].arrayValue.count == 0 && cashApplicationObject["Period1List"].arrayValue.count == 0 && cashApplicationObject["Period1List"].arrayValue.count == 0 {
                    sectionsToDisplay.removeAll()
                    noDataView.isHidden = false
                    lblNoData.text = "No Records Found"
                }
                else {
                    sectionsToDisplay = ["00 - 30 days","31 - 60 days","61 - 90 days","91 - 120 days","121 and Over"]
                    noDataView.isHidden = true
                  //  self.lateFeeUpdate()
                    
                }
                self.dataTable.reloadData()
                
            }else{
                var message = cashApplicationObject["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
    }
    
    //MARK:- updatevalues
    func lateFeeUpdate() {
        
        for i in 0..<5 {
            let sectionValue = "Period\(i+1)List"
            for j in 0..<cashApplicationObject[sectionValue].count {
                if  cashApplicationObject[sectionValue][j]["IsLateFee"].boolValue == true {
                    cashApplicationObject[sectionValue][j]["IsLateFeeEnable"].boolValue = true
                    
                }
                else {
                    cashApplicationObject[sectionValue][j]["IsLateFeeEnable"].boolValue = false
                }
                
            }
        }
        self.dataTable.reloadData()
        
        
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
    
    //MARK:- Setup CalendarView
    
    func setupCalendarView(){
        customCalendarView = Bundle.main.loadNibNamed("CalendarView", owner: self, options: nil)?[0] as! CalendarView
        customCalendarView.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
        customCalendarView.setupCalendar()
        customCalendarView.calendar.delegate = self
        customCalendarView.calendar.dataSource = self
        
    }
    //MARK: Calendar Methods
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        return formatter
    }()
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int
    {
        return 0
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return nil
    }
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        
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
            if FirstRespondertextFieldTag == StartDateTextFieldTag {
                if selecetdFromDate != nil {
                    resultFromDate = self.dateFormatter.string(from: date)
                    StartDate = resultFromDate
                    
                }
            }
            if FirstRespondertextFieldTag == EndDateTextFieldTag{
                if selecetdToDate != nil{
                    resultToDate = self.dateFormatter.string(from: date)
                    EndDate = resultToDate
                    
                }
            }
            if FirstRespondertextFieldTag == StartDateTextFieldTag {
                startDateTxtField.text = resultFromDate
            }else if FirstRespondertextFieldTag == EndDateTextFieldTag{
                
                
                endDateTxtField.text = resultToDate
            }
            if resultFromDate.count > 0 && resultToDate.count > 0{
                self.getDataFromServer()
            }
        }
        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        if FirstRespondertextFieldTag == StartDateTextFieldTag {
            
            
        }else{
            
            resultToDate = self.dateFormatter.string(from: calendar.currentPage)
            
        }
        
        
        customCalendarView.calendar.select(calendar.currentPage)
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    deinit {
        print("\(#function)")
    }
    @objc func openCloseSectionClicked(_ sender: UIButton) {
        if rowsOpen.contains(sender.tag) {
            if let selectedRowIndex = rowsOpen.index(where: { $0 == sender.tag  }) {
                rowsOpen.remove(at: selectedRowIndex)
            }
            
        }
        else {
            rowsOpen.append(sender.tag)
        }
        
        self.dataTable.reloadData()
        
        if noOfRows[sender.tag] > 0{
            let index = IndexPath(item: 0, section: sender.tag)
            self.dataTable.scrollToRow(at: index, at: UITableView.ScrollPosition.middle, animated: true)
        }
        else {
            
        }
    }
    //MARK:- CheckBox Action
    @objc func checkBoxClicked(_ sender: UIButton) {
        
        let buttonPosition:CGPoint = (sender as AnyObject).convert(CGPoint.zero, to:dataTable)
        let selectedIndePath = self.dataTable.indexPathForRow(at: buttonPosition)!
        let sectionValue = "Period\(selectedIndePath.section+1)List"
        if  cashApplicationObject[sectionValue][selectedIndePath.row]["IsChecked"].boolValue == true {
            cashApplicationObject[sectionValue][selectedIndePath.row]["IsChecked"].boolValue = false
            cashApplicationObject[sectionValue][selectedIndePath.row]["AmountPaid"].stringValue = "0"
            cashApplicationObject[sectionValue][selectedIndePath.row]["ACHRefenceNo"].stringValue = ""
            cashApplicationObject[sectionValue][selectedIndePath.row]["Comments"].stringValue = ""
        }
        else {
            cashApplicationObject[sectionValue][selectedIndePath.row]["IsChecked"].boolValue = true
            if  cashApplicationObject[sectionValue][selectedIndePath.row]["IsLateFee"].boolValue == true {
                
                cashApplicationObject[sectionValue][selectedIndePath.row]["AmountPaid"].stringValue = self.getFinalValue(obj: cashApplicationObject[sectionValue][selectedIndePath.row])
            }
            else {
                let val = cashApplicationObject[sectionValue][selectedIndePath.row]["BalanceDue"].doubleValue
                cashApplicationObject[sectionValue][selectedIndePath.row]["AmountPaid"].stringValue = "\(String(format:"%.2f", val))"
            }
            
        }
        
        dataTable.reloadData()
        calculateTotalAmount()
    }
    
    func getFinalValue(obj: JSON) -> String {
        
        let val = obj["BalanceDue"].doubleValue + obj["LateFee"].doubleValue
        
        let finalval = "\(String(format:"%.2f", val))"
        return finalval
        
    }
    
    //MARK:- ViewTimeSlips Action
    @objc func viewTimeSlipsClicked(_ sender: UIButton) {
        print("View TimeSlips Clicked")
        
        let buttonPosition:CGPoint = (sender as AnyObject).convert(CGPoint.zero, to:dataTable)
        let selectedIndePath = self.dataTable.indexPathForRow(at: buttonPosition)!
        let sectionValue = "Period\(selectedIndePath.section+1)List"
        
        let s = ClientInvoice.init(StartDate: "", EndDate: "", UnPaid: "", OrigInvoiceNumber: cashApplicationObject[sectionValue][selectedIndePath.row]["Office"].stringValue, InvoiceNumber: cashApplicationObject[sectionValue][selectedIndePath.row]["InvoiceNo"].stringValue, InvoiceType: "", BillDate: cashApplicationObject[sectionValue][selectedIndePath.row]["BillDate"].stringValue, Total: 0, Balance: 0, Paid: "", Expense: "", OrderStatus: cashApplicationObject[sectionValue][selectedIndePath.row]["OrderStatus"].doubleValue)
        
        self.getClientInvoiceApprovalReportServerCall(ClinetInvoiceObj: s)
    }
    func getClientInvoiceApprovalReportServerCall(ClinetInvoiceObj: ClientInvoice) {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            let defaults = UserDefaults.standard
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            InvoiceName = ClinetInvoiceObj.InvoiceNumber! //""
            let params  = ["ClientId":clientID,
                           "BillDate":ClinetInvoiceObj.BillDate!,
                           "Office":"\(String(describing: ClinetInvoiceObj.OrigInvoiceNumber!))",//1,
                "Status":ClinetInvoiceObj.OrderStatus!,
                "InvoiceNumber":ClinetInvoiceObj.InvoiceNumber!] as [String : Any] as NSDictionary
            print(params)
            
            let urlString = RestAPI.BaseUrl+RestAPI.GetClientInvoiceApprovalReport_URL
            
            RestAPI.postRequestWithToken(urlString: urlString, params: params, callback: getInvoiceReportResponse(response:))
            
            
        }else{
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    func getInvoiceReportResponse(response:AnyObject)->()
    {
        JustHUD.shared.hide()
        print(response)
        if response is String{
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }else{
            
            let object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
                let fileName = object["Filepath"].stringValue
                self.pushToViewPDFPage(fileName: fileName,PageTitle :InvoiceName)
                
            }else{
                var message = object["Message"].stringValue
                if message.count == 0 {
                    message = Error_Message
                }
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
    }
    
    func pushToViewPDFPage(fileName: String,PageTitle: String){
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
            
            nextViewController.isForPrivacyPolicy = false
            nextViewController.fileName = fileName
            nextViewController.PageTitle = PageTitle
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
        
        
    }
    
    //MARK:- LateFee CheckBox Clicked
    @objc func lateFeeCheckBoxClicked(_ sender: UIButton) {
        print("Late Fee Clicked")
        let buttonPosition:CGPoint = (sender as AnyObject).convert(CGPoint.zero, to:dataTable)
        let selectedIndePath = self.dataTable.indexPathForRow(at: buttonPosition)!
        let sectionValue = "Period\(selectedIndePath.section+1)List"
        if  cashApplicationObject[sectionValue][selectedIndePath.row]["IsLateFeeEnable"].boolValue == true {
            //IsLateFeeEnable
            cashApplicationObject[sectionValue][selectedIndePath.row]["IsLateFeeEnable"].boolValue = false
            
            let val = cashApplicationObject[sectionValue][selectedIndePath.row]["BalanceDue"].doubleValue
            cashApplicationObject[sectionValue][selectedIndePath.row]["AmountPaid"].stringValue = "\(String(format:"%.2f", val))"
        }
        else {
            cashApplicationObject[sectionValue][selectedIndePath.row]["IsLateFeeEnable"].boolValue = true
            cashApplicationObject[sectionValue][selectedIndePath.row]["AmountPaid"].stringValue = self.getFinalValue(obj: cashApplicationObject[sectionValue][selectedIndePath.row])
        }
        
        dataTable.reloadData()
        calculateTotalAmount()
    }
    
    //MARK:- InvoiceButton Action
    @objc func invoiceClicked(_ sender: UIButton) {
        print("Invoice Clicked")
        let buttonPosition:CGPoint = (sender as AnyObject).convert(CGPoint.zero, to:dataTable)
        let selectedIndePath = self.dataTable.indexPathForRow(at: buttonPosition)!
        let sectionValue = "Period\(selectedIndePath.section+1)List"
        
        let s = ClientInvoice.init(StartDate: "", EndDate: "", UnPaid: "", OrigInvoiceNumber: cashApplicationObject[sectionValue][selectedIndePath.row]["Office"].stringValue, InvoiceNumber: cashApplicationObject[sectionValue][selectedIndePath.row]["InvoiceNo"].stringValue, InvoiceType: "", BillDate: cashApplicationObject[sectionValue][selectedIndePath.row]["BillDate"].stringValue, Total: 0, Balance: 0, Paid: "", Expense: "", OrderStatus: cashApplicationObject[sectionValue][selectedIndePath.row]["OrderStatus"].doubleValue)
        self.GetClientInvoiceReportServerCall(ClinetInvoiceObj: s)
    }
    
    func GetClientInvoiceReportServerCall(ClinetInvoiceObj: ClientInvoice) {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            let defaults = UserDefaults.standard
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            InvoiceName = ClinetInvoiceObj.InvoiceNumber!
            let params  = ["ClientId":clientID,"BillDate":ClinetInvoiceObj.BillDate!,
                           "Office":"\(String(describing: ClinetInvoiceObj.OrigInvoiceNumber!))",//1,
                "Status":ClinetInvoiceObj.OrderStatus!,
                "InvoiceNumber":ClinetInvoiceObj.InvoiceNumber!] as [String : Any] as NSDictionary
            
            print(params)
            
            let urlString = RestAPI.BaseUrl+RestAPI.GetClientInvoiceReport_URL
            
            RestAPI.postRequestWithToken(urlString: urlString, params: params, callback: getInvoiceReportResponse(response:))
            
            
        }else{
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    
    
    //MARK:- Button Actions
    @IBAction func achButtonClicked(_ sender: UIButton) {
        //radio-button-on
        //radio-button-off
        achButton.setImage(UIImage.init(named: "radio-button-on"), for: .normal)
        checkButton.setImage(UIImage.init(named: "radio-button-off"), for: .normal)
        PaymentType = "ACH"
    }
    
    
    @IBAction func checkButtonClicked(_ sender: UIButton) {
        checkButton.setImage(UIImage.init(named: "radio-button-on"), for: .normal)
        achButton.setImage(UIImage.init(named: "radio-button-off"), for: .normal)
        PaymentType = "Check"
    }
    
    @IBAction func startDateButtonClicked(_ sender: UIButton) {
        FirstRespondertextFieldTag = StartDateTextFieldTag
        if (StartDate.count) > 0 {
            let date = self.convertDateStringToDefaultDate(dateString: StartDate, formatString: dateFormat)
            DispatchQueue.main.async(execute: { () -> Void in
                self.customCalendarView.calendar.setCurrentPage(date, animated: true)
                self.customCalendarView.calendar.select(date, scrollToDate: true)
            })
        }
        self.customCalendarView.showPickerViewOnSuperView(superView: (self.navigationController?.view)!, isPortrait: self.isPortrait())
        
    }
    
    @IBAction func endDateButtonClicked(_ sender: UIButton) {
        FirstRespondertextFieldTag = EndDateTextFieldTag
        if (StartDate.count) > 0 {
        }
        if (EndDate.count) > 0 {
            let date = self.convertDateStringToDefaultDate(dateString: EndDate, formatString: dateFormat)
            DispatchQueue.main.async(execute: { () -> Void in
                self.customCalendarView.calendar.setCurrentPage(date, animated: true)
                self.customCalendarView.calendar.select(date, scrollToDate: true)
            })
        }
        self.customCalendarView.showPickerViewOnSuperView(superView: (self.navigationController?.view)!, isPortrait: self.isPortrait())
    }
    
    //MARK:- Submit Payment Action
    @IBAction func submitPayment(_ sender: UIButton) {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            if calculatedAmount > 0.0 {
                
                JustHUD.shared.showInView(view: view)
                let defaults = UserDefaults.standard
                
                let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
                
                print(clientID)
                
                
                let tempArray = NSMutableArray()
                for i in 0..<5 {
                    let sectionValue = "Period\(i+1)List"
                    for j in 0..<cashApplicationObject[sectionValue].count {
                        if  cashApplicationObject[sectionValue][j]["IsChecked"].boolValue == true {
                            /*
                             if cashApplicationObject[sectionValue][j]["ACHRefenceNo"].stringValue.replacingOccurrences(of: " ", with: "").count == 0 {
                             JustHUD.shared.hide()
                             self.isWarningmessage = true
                             self.scrollableIndexPath = IndexPath.init(row: j, section: i)
                             self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Please Enter ACH reference number", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                             return;
                             }
                             */
                            /*
                             {"ACHRefenceNo":"test","AmountPaid":"1235.48","BalanceDue":"1235.48","BillDate":"2020-05-24T00:00:00","ClientName":"Samaritan Village - Van Wyck","Comments":"test","Discount":0.0,"FinalAmount":1235.48,"GPCompany":"ESSEY","InvoiceNo":"INV17-7107IB","IsChecked":true,"IsLateFee":1,"IsLateFeeEnable":0,"LateFee":62.0,"Office":1,"OrderStatus":0}
                             */
                            
                            let dataDict = ["ACHRefenceNo":cashApplicationObject[sectionValue][j]["ACHRefenceNo"].stringValue,
                                            "AmountPaid":cashApplicationObject[sectionValue][j]["AmountPaid"].stringValue,
                                            "BalanceDue":cashApplicationObject[sectionValue][j]["BalanceDue"].stringValue,
                                            "BillDate":cashApplicationObject[sectionValue][j]["BillDate"].stringValue,
                                            "Comments":cashApplicationObject[sectionValue][j]["Comments"].stringValue,
                                            "InvoiceNo":cashApplicationObject[sectionValue][j]["InvoiceNo"].stringValue,
                                            "IsChecked":cashApplicationObject[sectionValue][j]["IsChecked"].boolValue,
                                            "Discount":cashApplicationObject[sectionValue][j]["Discount"].stringValue,
                                            "IsLateFee":cashApplicationObject[sectionValue][j]["IsLateFee"].boolValue,
                                            "IsLateFeeEnable":cashApplicationObject[sectionValue][j]["IsLateFeeEnable"].boolValue,
                                            "LateFee":cashApplicationObject[sectionValue][j]["LateFee"].stringValue,
                                            "GPCompany":cashApplicationObject[sectionValue][j]["GPCompany"].stringValue,
                                            "Office":cashApplicationObject[sectionValue][j]["Office"].stringValue,
                                            "ClientName":cashApplicationObject[sectionValue][j]["ClientName"].stringValue,
                                            "OrderStatus":cashApplicationObject[sectionValue][j]["OrderStatus"].stringValue] as [String : Any]
                            //GPCompany
                            //Office
                            //ClientName
                            //OrderStatus
                            tempArray.add(dataDict)
                            // tempArray.add(cashApplicationObject[sectionValue][j])
                        }
                        
                    }
                }
                
                let DivisionId = String(format:"%d", defaults.integer(forKey: "DivisionId"))
                let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
                let params: [String : Any]   = ["ClientId":"\(clientID)",
                    "DivId":"\(DivisionId)",
                    "StartDate":startDateTxtField.text!,
                    "EndDate":endDateTxtField.text!,
                    "PaymentType":"\(PaymentType)",
                    "PaymentInformationList":tempArray,
                    "GrandTotal":"\(cashApplicationObject["GrandTotal"].stringValue)",
                    "AmountPaid":"\(String(format:"%.2f", calculatedAmount))",
                    "ContactId":"\(ContactId)"] //as [String : Any] as NSDictionary
                print(params)
                RestAPI.PaymentInsert(self, params: params, method: "POST", accessToken: "", acces: true, callBack: insertPaymentResponse(response:))
            }
            else {
                 self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Please select atleast one Invoice", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
        else {
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
        
    }
    //MARK:- AlertOkButtonAction
    @IBAction override func okButtonTapped(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        if isWarningmessage == true{
            self.isWarningmessage = false
            self.dataTable.scrollToRow(at: self.scrollableIndexPath, at: .top, animated: true)
        }
        else if isSuccessMessage == true {
            self.isSuccessMessage = false
            self.getDataFromServer()
        }
    }
    
    func insertPaymentResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        submitResponseObject = response as! JSON
        print(response)
        if response is String{
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            if submitResponseObject["MessageStatus"].intValue == 1
            {
                calculatedAmount = 0
                //Handle Success
                self.isSuccessMessage = true
                self.isWarningmessage = false
                //Message
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: submitResponseObject["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                
            }else{
                self.isSuccessMessage = false
                self.isWarningmessage = false
                var message = submitResponseObject["message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
    }
    
    //MARK:- CalculateTotal
    func calculateTotalAmount() {
        
        calculatedAmount = 0
        
        for i in 0..<5 {
            let sectionValue = "Period\(i+1)List"
            for j in 0..<cashApplicationObject[sectionValue].count {
                if  cashApplicationObject[sectionValue][j]["IsChecked"].boolValue == true {
                    calculatedAmount = calculatedAmount + cashApplicationObject[sectionValue][j]["AmountPaid"].doubleValue
                }
                
            }
        }
        
        print(calculatedAmount)
        self.amountPaidLabel.text
            = "Amount Paid $\(String(format:"%.2f", calculatedAmount))"
        
        
    }
    
}

extension CashApplicationController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsToDisplay.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if noOfRows.count > 0 {
            return noOfRows[section]
        }
        else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CashApplicationCell") as! CashApplicationCell
        cell.checkBox.tag = indexPath.row
        cell.checkBox.addTarget(self, action: #selector(checkBoxClicked(_ :)), for: .touchUpInside)
        cell.viewTimeSlips.addTarget(self, action: #selector(viewTimeSlipsClicked(_ :)), for: .touchUpInside)
        cell.inVoiceButton.addTarget(self, action: #selector(invoiceClicked(_ :)), for: .touchUpInside)
        cell.selectionStyle = .none
        cell.lateFeeCheckBox.tag = indexPath.row
        cell.lateFeeCheckBox.addTarget(self, action: #selector(lateFeeCheckBoxClicked(_ :)), for: .touchUpInside)
        
        //object["Period1List"].arrayValue.count
        let sectionValue = "Period\(indexPath.section+1)List"
        print(sectionValue)
        cell.balanceTF.delegate = self
        cell.achNumberTF.delegate = self
        cell.commentsTF.delegate = self
        
        cell.balanceTF.tag = balanceTag
        cell.achNumberTF.tag = achFieldTag
        cell.commentsTF.tag = commentsTag
        
        if cashApplicationObject[sectionValue].arrayValue.count > 0 {
            let obj = cashApplicationObject[sectionValue][indexPath.row]
            
            cell.inVoiceButton.setTitle(obj["InvoiceNo"].stringValue, for: .normal)
            cell.billDateLabel.text = String(obj["BillDate"].stringValue.prefix(10))
            let invoiceNum = obj["InvoiceNo"].stringValue
            let strNumber: NSString = invoiceNum as NSString
            let range = (strNumber).range(of: invoiceNum)
            let attribute = NSMutableAttributedString.init(string: invoiceNum)
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hexString: "002763") , range: range)
            attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: CGFloat(14)) , range: range)
            attribute.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range)
            cell.inVoiceButton.setAttributedTitle(attribute, for: .normal)
            
            
            
            let strNumber1: NSString = "View Timeslip(s)" as NSString
            let range1 = (strNumber1).range(of: "View Timeslip(s)")
            let attribute1 = NSMutableAttributedString.init(string: "View Timeslip(s)")
            attribute1.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hexString: "002763") , range: range1)
            attribute1.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: CGFloat(14)) , range: range1)
            attribute1.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range1)
            cell.viewTimeSlips.setAttributedTitle(attribute1, for: .normal)
            
            //String(format:"%.2f", Double(textField.text!)!)
            cell.invoiceTotalLabel.text = "$ \(obj["BalanceDue"].stringValue)"
            if obj["IsLateFeeEnable"].boolValue == true {
                cell.lateFeeCheckBox.setImage(UIImage.init(named: "check_box_filled"), for: .normal)
            }
            else {
                cell.lateFeeCheckBox.setImage(UIImage.init(named: "check_box"), for: .normal)
            }
            if obj["IsLateFee"].boolValue == true {
                
                
                cell.lateFeeCheckBox.isHidden = false
                cell.titleLateFeeLabel.isHidden = false
                cell.lateFeeLabel.isHidden = false
            }
            else {
                
                cell.lateFeeCheckBox.isHidden = true
                cell.titleLateFeeLabel.isHidden = true
                cell.lateFeeLabel.isHidden = true
            }
            //IsLateFeeEnable
            
            cell.lateFeeLabel.text = "$ \(obj["LateFee"].stringValue)"
            cell.discountLabel.text = "$ \(obj["Discount"].stringValue)"
            // if selectedIndexes.contains(indexPath) {
            if obj["IsChecked"].boolValue == true {
                cell.checkBox.setImage(UIImage.init(named: "check_box_filled"), for: .normal)
                cell.achNumberTF.isEnabled = true
                cell.balanceTF.isEnabled = true
                cell.commentsTF.isUserInteractionEnabled = true
                cell.balanceTF.text = obj["AmountPaid"].stringValue
                cell.commentsTF.text = obj["Comments"].stringValue
                cell.achNumberTF.text = obj["ACHRefenceNo"].stringValue
                cell.lateFeeCheckBox.isEnabled = true
                cell.lateFeeLabel.isEnabled = true
                
            }
            else {
                cell.lateFeeCheckBox.isEnabled = false
                cell.checkBox.setImage(UIImage.init(named: "check_box"), for: .normal)
                cell.achNumberTF.isEnabled = false
                cell.balanceTF.isEnabled = false
                cell.commentsTF.isUserInteractionEnabled = false
                cell.balanceTF.text = ""
                cell.commentsTF.text = ""
                cell.achNumberTF.text = ""
                cell.lateFeeLabel.isEnabled = false
                
            }
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CashApplicationHeaderCell") as! CashApplicationHeaderCell
        let divColorCode = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.headerNameLabel.text = sectionsToDisplay[section]
        
        cell.headerOpenButton.tag = section
        cell.headerOpenButton.addTarget(self, action: #selector(openCloseSectionClicked(_ :)), for: .touchUpInside)
        
        if rowsOpen.contains(section) {
            cell.headerOpenButton.setImage(UIImage.init(named: "openrow"), for: .normal)
        }
        else {
            cell.headerOpenButton.setImage(UIImage.init(named: "closerow"), for: .normal)
        }
        cell.headerBackView.backgroundColor = divColorCode
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if rowsOpen.contains(indexPath.section) {
            return 230
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

extension CashApplicationController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == balanceTag {
            let buttonPosition:CGPoint = (textField as AnyObject).convert(CGPoint.zero, to:dataTable)
            let selectedIndePath = self.dataTable.indexPathForRow(at: buttonPosition)!
            print(selectedIndePath)
            
            let sectionValue = "Period\(selectedIndePath.section+1)List"
            
            print("Balance field edited")
            var actualVal = Double()
            if cashApplicationObject[sectionValue][selectedIndePath.row]["IsLateFeeEnable"].boolValue == true {
                actualVal = Double.init(self.getFinalValue(obj: cashApplicationObject[sectionValue][selectedIndePath.row]))!
            }
            else {
                actualVal = cashApplicationObject[sectionValue][selectedIndePath.row]["BalanceDue"].doubleValue
            }
            
            
            if Double(textField.text!)! < 1 || Double(textField.text!)! > actualVal {
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Amount should not greater than the Invoice Total", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
            else {
                
                cashApplicationObject[sectionValue][selectedIndePath.row]["AmountPaid"].stringValue = String(format:"%.2f", Double(textField.text!)!)
            }
            self.calculateTotalAmount()
            
        }
        else if textField.tag == achFieldTag {
            let buttonPosition:CGPoint = (textField as AnyObject).convert(CGPoint.zero, to:dataTable)
            let selectedIndePath = self.dataTable.indexPathForRow(at: buttonPosition)!
            print(selectedIndePath)
            
            let sectionValue = "Period\(selectedIndePath.section+1)List"
            //   let obj = cashApplicationObject[sectionValue][selectedIndePath.row]
            // ACH Field
            print("ACH field edited")
            if textField.text!.count > 0 {
                
                
                cashApplicationObject[sectionValue][selectedIndePath.row]["ACHRefenceNo"].stringValue = textField.text!
            }
            
        }
        DispatchQueue.main.async {
            self.dataTable.reloadData()
        }
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool     {
        if textField.tag == Int(StartDateTextFieldTag) || textField.tag == Int(EndDateTextFieldTag){
            //textField.resignFirstResponder()
            return false;
        }
        else {
            //textField.becomeFirstResponder()
            return true;
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
        //        FirstRespondertextFieldTag = textField.tag
        //
        //        if textField.tag == Int(StartDateTextFieldTag) || textField.tag == Int(EndDateTextFieldTag){
        //            textField.resignFirstResponder()
        //        }
        //        else {
        //            textField.becomeFirstResponder()
        //        }
        //        if textField.tag == Int(StartDateTextFieldTag) {
        //
        //            if (StartDate.count) > 0 {
        //                let date = self.convertDateStringToDefaultDate(dateString: StartDate, formatString: dateFormat)
        //                DispatchQueue.main.async(execute: { () -> Void in
        //                    self.customCalendarView.calendar.setCurrentPage(date, animated: true)
        //                    self.customCalendarView.calendar.select(date, scrollToDate: true)
        //                })
        //            }
        //            self.customCalendarView.showPickerViewOnSuperView(superView: (self.navigationController?.view)!, isPortrait: self.isPortrait())
        //        }
        //        else if textField.tag == Int(EndDateTextFieldTag) {
        //            if (StartDate.count) > 0 {
        //            }
        //            if (EndDate.count) > 0 {
        //                let date = self.convertDateStringToDefaultDate(dateString: EndDate, formatString: dateFormat)
        //                DispatchQueue.main.async(execute: { () -> Void in
        //                    self.customCalendarView.calendar.setCurrentPage(date, animated: true)
        //                    self.customCalendarView.calendar.select(date, scrollToDate: true)
        //                })
        //            }
        //            self.customCalendarView.showPickerViewOnSuperView(superView: (self.navigationController?.view)!, isPortrait: self.isPortrait())
        //        }
        
        
    }
    
    //       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //        if textField.tag == achFieldTag {
    //           let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
    //           let filtered = string.components(separatedBy: cs).joined(separator: "")
    //
    //           return (string == filtered)
    //        }
    //        return true
    //       }
    
}
extension CashApplicationController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        let buttonPosition:CGPoint = (textView as AnyObject).convert(CGPoint.zero, to:dataTable)
        let selectedIndePath = self.dataTable.indexPathForRow(at: buttonPosition)!
        print(selectedIndePath)
        let sectionValue = "Period\(selectedIndePath.section+1)List"
        if textView.tag == commentsTag {
            print("Comments field edited")
            if textView.text!.replacingOccurrences(of: " ", with: "").count > 0 {
                
                cashApplicationObject[sectionValue][selectedIndePath.row]["Comments"].stringValue = textView.text!
            }
            
        }
    }
}

/*
 {
 "BankAccount" : "",
 "Office" : 1,
 "BalanceDue" : 1193.4000000000001,
 "Balance" : 1193.4000000000001,
 "GPCompany" : "ESSEY",
 "IsLateFeeEnable" : 0,
 "Period4" : 0,
 "InvoiceNo" : "INV17-7105IB",
 "Period2" : 1193.4000000000001,
 "Discount" : 0,
 "FinanceChargeDays" : 30,
 "Comments" : "",
 "AgingType" : 1,
 "BillDate" : "2020-05-10T00:00:00",
 "IsChecked" : false,
 "Col0" : "0001-01-01T00:00:00",
 "Period6" : 0,
 "EndDate" : "0001-01-01T00:00:00",
 "ClientId" : 81774,
 "LateFee" : 60,
 "AgingURL" : null,
 "ACHRefenceNo" : "",
 "Period3" : 0,
 "Period1" : 0,
 "StartDate" : "0001-01-01T00:00:00",
 "Days" : 0,
 "Period5" : 0,
 "Col1" : "2020-07-09T00:00:00",
 "InvoiceURL" : null,
 "DivId" : 0,
 "AmountPaid" : 0,
 "ClientName" : "Samaritan Village - Van Wyck",
 "OrderStatus" : 0,
 "IsLateFee" : 1,
 "Paid" : false
 }
 */
