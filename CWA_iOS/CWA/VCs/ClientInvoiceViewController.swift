//
//  ClientInvoiceViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 02/08/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import FSCalendar
import SwiftyJSON
class ClientInvoiceViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance,UISearchBarDelegate {
    
        
    var customCalendarView = CalendarView()

    //MARK: Outlets
    @IBOutlet weak var baseScrollView: UIScrollView!
    
    @IBOutlet weak var endDateTxtField: UITextField!
    @IBOutlet weak var unpaidBtn: UIButton!
    
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var lblNoData: UILabel!
    
    @IBOutlet weak var endDateView: UIView!
    @IBOutlet weak var startDateTxtField: UITextField!
    @IBOutlet weak var startDateView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var ClientSearchBar: UISearchBar!
    @IBOutlet weak var lblGrandTotal: UILabel!
    @IBOutlet weak var lblGrandBalance: UILabel!
    @IBOutlet weak var lblGrand: UILabel!
    var isFromSafety = false
    
    @IBOutlet weak var SuperViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: Intialise Variables
    var resultFromDate = String()
    var resultToDate = String()
    var selecetdFromDate = Date()
    var selecetdToDate = Date()
    var StartDate = ""
    var EndDate = ""
    
    let StartDateTextFieldTag = 702
    let EndDateTextFieldTag = 703
    var FirstRespondertextFieldTag = 0
    var datas = NSMutableArray()
    var filteredDataArray = NSMutableArray()
    var isSearching = false
    var InvoiceName = ""
    var MessageParam = ""
    var customPickerView = JPPickerView()
    //MARK: View Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titlelbl.text = "Client Invoices"
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UISetup()
        startDateTxtField.text = resultFromDate
        endDateTxtField.text = resultToDate
        self.getClientInvoiceServerCall()
        
        // Do any additional setup after loading the view.
    }
    func UISetup(){
        startDateTxtField.text = ""
        endDateTxtField.text = ""
        noDataView.isHidden = true
        noDataView.backgroundColor = UIColor(hexString:danger_background_Color)
        lblNoData.textColor = UIColor(hexString:danger_Color)
        
        listTableView.tableFooterView = UIView()
        
        unpaidBtn.isSelected = true
        startDateTxtField.tag = StartDateTextFieldTag
        endDateTxtField.tag = EndDateTextFieldTag
         self.setupCalendarView()
        self.addBorderToView(viewT:startDateView)
        self.addBorderToView(viewT:endDateView)
        self.addRightImageToTextField(textField: startDateTxtField,imageName: "calendar_icon.png")
        self.addRightImageToTextField(textField: endDateTxtField,imageName: "calendar_icon.png")
        
        
        if self.isPortrait() == true{
            self.baseScrollView.isScrollEnabled = false
        }else{
            let  screenWidth =  UIScreen.main.bounds.size.width
            
            let  screenHeight =  UIScreen.main.bounds.size.height
            print(screenWidth,screenHeight)
            DispatchQueue.main.async(execute: { () -> Void in
                self.baseScrollView.isScrollEnabled = true
                self.baseScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.width)
            })
        }
        if UserDefaults.standard.value(forKey: "ColorCode") == nil{
            
        }else{
            let divColorCode = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
            
            lblGrand.textColor = divColorCode
            lblGrandBalance.textColor = divColorCode
            lblGrandTotal.textColor = divColorCode
            ClientSearchBar.barTintColor = divColorCode
            
        }
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(keyboardDoneBtnTapped))]
        toolBar.sizeToFit()
        
        ClientSearchBar.inputAccessoryView = toolBar
    }
    @objc override func appWillEnterForeground(){
        print("appWillEnterForeground Division")
        if datas.count == 0{
            self.getClientInvoiceServerCall()
        }
        
    }
    @objc func keyboardDoneBtnTapped(sender: UIButton)  {
        //        isSearching = false
        ClientSearchBar.endEditing(true)
    }
    
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unpaidBtnTapped(_ sender: Any) {
        
        if unpaidBtn.isSelected == true{
            unpaidBtn.isSelected = false
        }else{
            unpaidBtn.isSelected = true
        }
        
        self.getClientInvoiceServerCall()
    }
    @objc func timeButtonTapped(sender:UIButton) {
        
        if resultFromDate.count > 0 && resultToDate.count > 0{
            self.getClientInvoiceServerCall()
            
        }
        customPickerView.removePickerViewFromSuperView()
        
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
            selecetdFromDate =  changedDate
        }else if FirstRespondertextFieldTag == EndDateTextFieldTag{
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
            if FirstRespondertextFieldTag == StartDateTextFieldTag {
                resultFromDate = pickedDateString
                startDateTxtField.text = resultFromDate
                selecetdFromDate =  changedDate
            }else if FirstRespondertextFieldTag == EndDateTextFieldTag{
                resultToDate = pickedDateString
                endDateTxtField.text = resultToDate
                selecetdToDate =  changedDate
            }
            
        }
        
        listTableView.reloadData()
    }
    //Methods
    func setupCalendarView(){
        customCalendarView = Bundle.main.loadNibNamed("CalendarView", owner: self, options: nil)?[0] as! CalendarView
        customCalendarView.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
        customCalendarView.setupCalendar()
        customCalendarView.calendar.delegate = self
        customCalendarView.calendar.dataSource = self
        
    }
    func setupPickerView(){
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
                self.getClientInvoiceServerCall()
             }
        }
        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        if startDateTxtField.isFirstResponder {
         }else{
             resultToDate = self.dateFormatter.string(from: calendar.currentPage)
         }
         customCalendarView.calendar.select(calendar.currentPage)
         print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    deinit {
        print("\(#function)")
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
    //MARK: TEXTFIELD DELEGATE
    func textFieldShouldReturn(_ textField: UITextField) -> Bool     {
        textField.resignFirstResponder()
        return true;
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField){
        FirstRespondertextFieldTag = textField.tag
        
        textField.resignFirstResponder()
          if textField.tag == Int(StartDateTextFieldTag) {
            
            if (StartDate.count) > 0 {
                let date = self.convertDateStringToDefaultDate(dateString: StartDate, formatString: dateFormat)
                DispatchQueue.main.async(execute: { () -> Void in
                    self.customCalendarView.calendar.setCurrentPage(date, animated: false)
                    self.customCalendarView.calendar.select(date, scrollToDate: false)
                    
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
    //MARK: - UISEARCHBAR DELEGATE METHODS
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        //        isSearching = false
        noDataView.isHidden = true
        
        searchBar.endEditing(false)
        
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) // called when text changes (including clear)
    {
        isSearching = true
        //////////////////**********************SEARCH**********///////////////
        filteredDataArray.removeAllObjects()
        if searchText.count > 0
        {
            var found = false
            for s in datas{
                let  oObj:ClientInvoice = s as! ClientInvoice
                let Total = String(format:"%.2f",oObj.Total!)
                let balance = String(format:"%.2f",oObj.Balance!)
                let poNum =   (oObj.InvoiceType?.lowercased())!+(oObj.InvoiceNumber?.lowercased())!+(oObj.BillDate?.lowercased())!+(Total.lowercased())+(balance.lowercased())
                let searchString = searchText.lowercased()
                found = (poNum.contains(searchString)) || (poNum.caseInsensitiveCompare(searchString) == ComparisonResult.orderedSame)
                if found {
                    filteredDataArray.add(oObj)
                }
            }
            if filteredDataArray.count == 0{
                noDataView.isHidden = false
                lblNoData.text = "Search results not found"
            }else{
                noDataView.isHidden = true
            }
        }
        else
        {
            noDataView.isHidden = true
            
            isSearching = false
            searchBar.endEditing(true)
        }
        listTableView.reloadData()
        
        /////////////////////******** END OF SEARCH *********//////
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) // called when cancel button pressed
    {
        noDataView.isHidden = true
        
        isSearching = false
        searchBar.endEditing(true)
        
    }
    //MARK: UITableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching == true{
            return filteredDataArray.count
        }
        return  datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ClientInvoiceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ClientInvoiceTableViewCellIdentifier") as! ClientInvoiceTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.bgView.layer.borderColor = borderColor.cgColor
        cell.bgView.layer.borderWidth = 1
        cell.bgView.backgroundColor = UIColor.white
        
        var s = ClientInvoice.init(StartDate: "", EndDate: "", UnPaid: "", OrigInvoiceNumber: "", InvoiceNumber: "", InvoiceType: "", BillDate: "", Total: 0, Balance: 0, Paid: "", Expense: "", OrderStatus: 0)
        if isSearching == true {
            s = filteredDataArray[indexPath.row] as! ClientInvoice
            
        }else{
            s = datas[indexPath.row] as! ClientInvoice
            
        }
        
        cell.lblInvoiceType.text = "Invoice Type   "+s.InvoiceType!
        cell.lblBillDate.text =  "Bill Date   "+s.BillDate!
        cell.lblTotal.text = String(format:"Total   $%.2f",s.Total!)
        cell.lblBalance.text = String(format:"Balance   $%.2f",s.Balance!)
        cell.lblPaid.text =  "Paid   "+s.Paid!
        
        let invoiceNum = s.InvoiceNumber! //"Invoice Number   "+s.InvoiceNumber!
        
      //  cell.btnInvoiceNum.setTitle(invoiceNum, for: .normal)
        
        let divColorCode = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
        cell.lblInvoiceType.halfTextMakeToBold(fullText: cell.lblInvoiceType.text!, changeText: "Invoice Type", textColor: divColorCode)
        cell.lblBillDate.halfTextMakeToBold(fullText: cell.lblBillDate.text!, changeText: "Bill Date", textColor: divColorCode)
        cell.lblTotal.halfTextMakeToBold(fullText: cell.lblTotal.text!, changeText: "Total", textColor: divColorCode)
        cell.lblBalance.halfTextMakeToBold(fullText: cell.lblBalance.text!, changeText: "Balance", textColor: divColorCode)
        cell.lblPaid.halfTextMakeToBold(fullText: cell.lblPaid.text!, changeText: "Paid", textColor: divColorCode)
        
        cell.btnViewTS.removeTarget(self, action:#selector(self.viewTSButtonTapped), for: .touchUpInside)
        cell.btnInvoiceNum.removeTarget(self, action:#selector(self.InvoiceNumberButtonTapped), for: .touchUpInside)
        cell.btnInvoiceName.removeTarget(self, action:#selector(self.InvoiceNumberButtonTapped), for: .touchUpInside)
        
        cell.btnViewTS.addTarget(self, action:#selector(self.viewTSButtonTapped), for: .touchUpInside)
        cell.btnInvoiceNum.addTarget(self, action:#selector(self.InvoiceNumberButtonTapped), for: .touchUpInside)
        cell.btnInvoiceName.addTarget(self, action:#selector(self.InvoiceNumberButtonTapped), for: .touchUpInside)
        //        cell.clickHereLbl.BoldAndUnderline(fullText: sameDayTimePlaceHolder, changeText: "Click here", textColor: UIColor(hexString: colorCode), fontSize: 15)
        cell.btnInvoiceName.setTitleColor(divColorCode, for: .normal)
        
        /*
        let strNumber: NSString = invoiceNum as NSString
        let range = (strNumber).range(of: s.InvoiceNumber!)
        let range12 = (strNumber).range(of: "Invoice Number")
        let attribute = NSMutableAttributedString.init(string: invoiceNum)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: divColorCode , range: range12)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: range)
        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: CGFloat(14)) , range: range)
        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: CGFloat(14)) , range: range12)
        
        attribute.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range)
        
        
        cell.btnInvoiceNum.setAttributedTitle(attribute, for: .normal)
        */
        let strNumber: NSString = invoiceNum as NSString
        let range = (strNumber).range(of: invoiceNum)
        let attribute = NSMutableAttributedString.init(string: invoiceNum)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue , range: range)
        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: CGFloat(14)) , range: range)
        attribute.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range)
        cell.btnInvoiceNum.setAttributedTitle(attribute, for: .normal)
        
        
        
        let strNumber1: NSString = "View Timeslip(s)" as NSString
        let range1 = (strNumber1).range(of: "View Timeslip(s)")
        let attribute1 = NSMutableAttributedString.init(string: "View Timeslip(s)")
        attribute1.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue , range: range1)
        attribute1.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: CGFloat(14)) , range: range1)
        attribute1.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range1)
        cell.btnViewTS.setAttributedTitle(attribute1, for: .normal)
        
        
        
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
        
    }
    //MARK: Button Action
    @IBAction func viewTSButtonTapped(_ sender: UIButton){
        
        //        self.ShowCommentPopup()
        let senderPosition  = sender.convert(CGPoint.zero, to: listTableView)
        
        let indexPath =  listTableView.indexPathForRow(at:senderPosition)
        let s = datas[(indexPath?.row)!] as! ClientInvoice
        
        self.getClientInvoiceApprovalReportServerCall(ClinetInvoiceObj: s)
        
    }
    @IBAction func InvoiceNumberButtonTapped(_ sender: UIButton){
        
        //        self.ShowCommentPopup()
        let senderPosition  = sender.convert(CGPoint.zero, to: listTableView)
        
        let indexPath =  listTableView.indexPathForRow(at:senderPosition)
        let s = datas[(indexPath?.row)!] as! ClientInvoice
        
        self.GetClientInvoiceReportServerCall(ClinetInvoiceObj: s)
        
    }
    //MARK:Server Call
    
    //    GetClientInvoiceReport_URL =  "ClientInvoiceController/InvoiceReport"
    //    static let GetClientInvoiceApprovalReport_URL
    
    func GetClientInvoiceReportServerCall(ClinetInvoiceObj: ClientInvoice) {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            let defaults = UserDefaults.standard
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            InvoiceName = ClinetInvoiceObj.InvoiceNumber!
            let params  = ["ClientId":clientID,"BillDate":ClinetInvoiceObj.BillDate!,
                           "Office":1,
                           "Status":ClinetInvoiceObj.OrderStatus!,
                           "InvoiceNumber":ClinetInvoiceObj.InvoiceNumber!] as [String : Any] as NSDictionary
            
            /*
             {
             "BillDate":"07/01/2018",
             "ClientId":70956,
             "Office":1,
             "Status":0,
             "InvoiceNumber":"INV17-7387"
             }
             */
            print(params)
            
            let urlString = RestAPI.BaseUrl+RestAPI.GetClientInvoiceReport_URL
            
            RestAPI.postRequestWithToken(urlString: urlString, params: params, callback: getInvoiceReportResponse(response:))
            
            
        }else{
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    
    func getClientInvoiceServerCall() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            customPickerView.removePickerViewFromSuperView()
            
            JustHUD.shared.showInView(view: (self.view)!)
            let defaults = UserDefaults.standard
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            
            /*
             {
             "ClientID":"70956",
             "StartDate":"08/09/2014",
             "EndDate":"08/09/2018",
             "IsUnPaidChecked":true
             }
             
             */
            //userid as String
            let params  = ["ClientID":clientID,
                           "StartDate":startDateTxtField.text!,
                           "EndDate":endDateTxtField.text!,
                           "IsUnPaidChecked":unpaidBtn.isSelected,
                           "Message": MessageParam] as [String : Any] as NSDictionary
            
            print(params)
            let urlString = RestAPI.BaseUrl+RestAPI.GetClientInvoice_URL
            
            RestAPI.postRequestWithToken(urlString: urlString, params: params, callback: getResponse(response:))
            
            
        }else{
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    
    func getClientInvoiceApprovalReportServerCall(ClinetInvoiceObj: ClientInvoice) {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            let defaults = UserDefaults.standard
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            InvoiceName = ""
            let params  = ["ClientId":clientID,
                           "BillDate":ClinetInvoiceObj.BillDate!,
                           "Office":1,
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
            
            //            self.ShowAlertMessage(message: response as! String, title: "")
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            let object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
                //                "Message": "Success",
                //                "MessageStatus": "1",
                //                "Filepath":””
                let fileName = object["Filepath"].stringValue
                self.pushToViewPDFPage(fileName: fileName,PageTitle :InvoiceName)
                
            }else{
                var message = object["message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }
    }
    func getResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        datas .removeAllObjects()
         lblGrandTotal.text =  "Total : $"+"0.00"
        lblGrandBalance.text = "Balance : $"+"0.00"

        listTableView.reloadData()
        
        print(response)
        if response is String{
            
            //            self.ShowAlertMessage(message: response as! String, title: "")
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            let object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
                
                let dataArray = object["ClientInvoiceList"].array
                datas .removeAllObjects()
                for dict in dataArray! {
                    
                    
                    let obj = ClientInvoice.init(StartDate: dict["StartDate"].stringValue, EndDate: dict["EndDate"].stringValue, UnPaid: dict["UnPaid"].stringValue, OrigInvoiceNumber: dict["OrigInvoiceNumber"].stringValue, InvoiceNumber: dict["InvoiceNumber"].stringValue, InvoiceType: dict["InvoiceType"].stringValue, BillDate: dict["BillDate"].stringValue, Total: dict["Total"].doubleValue, Balance: dict["Balance"].doubleValue, Paid: dict["Paid"].stringValue, Expense: dict["Expense"].stringValue,OrderStatus: dict["OrderStatus"].doubleValue)
                    datas.add(obj)
                    listTableView.reloadData()
                }
                if datas.count == 0 {
                    let message = object["Message"].stringValue
                    noDataView.isHidden = false
                    lblNoData.text = message
                }else{
                    noDataView.isHidden = true
                    lblGrandTotal.text = "Total : "+object["GrandTotal"].stringValue
                    lblGrandBalance.text = "Balance : "+object["GrandBalance"].stringValue
                    
                }
                if object["StartDate"].null == nil && object["EndDate"].null == nil{
                    
                    if object["StartDate"].stringValue .count > 0{
                        StartDate = object["StartDate"].stringValue
                        
                    }
                    
                    if object["EndDate"].stringValue .count > 0{
                        EndDate = object["EndDate"].stringValue
                        
                    }
                    if startDateTxtField.text?.count == 0 && endDateTxtField.text?.count == 0{
                        resultFromDate = StartDate
                        resultToDate = EndDate
                        startDateTxtField.text = StartDate
                        endDateTxtField.text = EndDate
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale.preferredLocale()
                        dateFormatter.dateFormat = dateFormat
                        selecetdFromDate = dateFormatter.date(from: StartDate)!
                        selecetdToDate = dateFormatter.date(from: EndDate)!
                    }
                }
                
            }else{
                lblGrandTotal.text =  "Total : $"+"0.00"
                lblGrandBalance.text = "Balance : $"+"0.00"
                
                var message = object["Message"].stringValue
                
                if object["StartDate"] .null == nil && object["EndDate"] .null == nil{
                    
                    if object["StartDate"].stringValue .count > 0{
                        StartDate = object["StartDate"].stringValue

                    }
                    
                    if object["EndDate"].stringValue .count > 0{
                        EndDate = object["EndDate"].stringValue

                    }
                    if startDateTxtField.text?.count == 0 && endDateTxtField.text?.count == 0{
                        resultFromDate = StartDate
                        resultToDate = EndDate
                        startDateTxtField.text = StartDate
                        endDateTxtField.text = EndDate
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale.preferredLocale()
                        dateFormatter.dateFormat = dateFormat
                        selecetdFromDate = dateFormatter.date(from: StartDate)!
                        selecetdToDate = dateFormatter.date(from: EndDate)!
                    }
                }
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                self.noDataView.isHidden = false
                self.lblNoData.text = message
                
                //                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
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
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        
        
        
        customPickerView.showPickerViewInOrientation(superView: (self.navigationController?.view)!, isPortrait: self.isPortrait())
        
        self.customCalendarView.showPickerViewInOrientation(superView: (self.navigationController?.view)!, isPortrait: self.isPortrait())

        
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            DispatchQueue.main.async(execute: { () -> Void in
                self.addDivisionNameOnTop()
                self.baseScrollView.isScrollEnabled = false
                self.SuperViewHeightConstraint.constant = UIScreen.main.bounds.size.width
                
                self.baseScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.width)
            })
        case .portraitUpsideDown:
            text="PortraitUpsideDown"
        case .landscapeLeft:
            text="LandscapeLeft"
            DispatchQueue.main.async(execute: { () -> Void in
                self.addDivisionNameOnTop()
                self.SuperViewHeightConstraint.constant = UIScreen.main.bounds.size.width
                
                self.baseScrollView.isScrollEnabled = true
                self.baseScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.width)
                
            })
        case .landscapeRight:
            text="LandscapeRight"
            DispatchQueue.main.async(execute: { () -> Void in
                self.addDivisionNameOnTop()
                self.SuperViewHeightConstraint.constant = UIScreen.main.bounds.size.width
                
                self.baseScrollView.isScrollEnabled = true
                self.baseScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.width)
                
            })
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
