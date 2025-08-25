//
//  OrderListViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 02/08/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON
import FSCalendar

class OrderListViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate ,FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance{
    var customCalendarView = CalendarView()
    
    @IBOutlet weak var endDateTxtField: UITextField!
    @IBOutlet weak var endDateView: UIView!
    @IBOutlet weak var startDateTxtField: UITextField!
    @IBOutlet weak var startDateView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var  CancelColourImageView: UIImageView!
    
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
    var CancelColour = String()
    
    var customPickerView = JPPickerView()
    //MARK: View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UISetup()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titlelbl.text = "Order List"
        self.getOrderListServerCall()
        
    }
    func UISetup(){
        startDateTxtField.tag = StartDateTextFieldTag
        endDateTxtField.tag = EndDateTextFieldTag
        
        startDateTxtField.text = ""
        endDateTxtField.text = ""
        noDataView.isHidden = true
        noDataView.backgroundColor = UIColor(hexString:danger_background_Color)
        lblNoData.textColor = UIColor(hexString:danger_Color)
        listTableView.tableFooterView = UIView()
        
        startDateTxtField.tag = StartDateTextFieldTag
        endDateTxtField.tag = EndDateTextFieldTag
        self.setupCalendarView()
        self.addBorderToView(viewT:startDateView)
        self.addBorderToView(viewT:endDateView)
        self.addRightImageToTextField(textField: startDateTxtField,imageName: "calendar_icon.png")
        self.addRightImageToTextField(textField: endDateTxtField,imageName: "calendar_icon.png")
        
        
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
    func addBorderToView(viewT: UIView){
        
        viewT.layer.borderColor = borderColor.cgColor
        viewT.layer.borderWidth = 1
            
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func timeButtonTapped(sender:UIButton) {
        
        //        let selectedYearPicker = pickerData[yearPicker.selectedRow(inComponent:0)]
        //        print(selectedYearPicker)
        
        
        if resultFromDate.count > 0 && resultToDate.count > 0{
            self.getOrderListServerCall()
            
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
        customPickerView.bgButton.addTarget(self, action:#selector(self.timeButtonTapped), for:.touchUpInside)
        customPickerView.doneButton.addTarget(self, action:#selector(self.timeButtonTapped), for:.touchUpInside)
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
                self.getOrderListServerCall()
                
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
    //MARK: UITableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:OrderListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "OrderListTableViewCellIdentifier") as! OrderListTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.bgView.layer.borderColor = borderColor.cgColor
        cell.bgView.layer.borderWidth = 1
        cell.bgView.backgroundColor = UIColor.white
        
        let   s = datas[indexPath.row] as! Order
        
        cell.lblOrder.text = "Order                         "+s.OrderId!
        cell.lblDept.text = "Dept                               "+s.Department!
        cell.lblPoNum.text =  "PO Number             "+s.PoNumber!
        cell.lblDate.text = "Date                          "+s.StartDate!+" - "+s.EndDate!
        cell.lblTime.text = "Time                          "+s.StartTime!+" - "+s.EndTime!
        cell.lblPosition.text = "Position                    "+s.Position!
        cell.lblReportTo.text = "Report To                 "+s.ReportTo!
        cell.lblTotalNumTemps.text = "Total No of Temps  "+s.TotalNumberTemps!
        
        cell.locationDetailsBtn.isHidden = true
     
        if s.Cancelled == 1{
            cell.bgView.backgroundColor =  UIColor(hexString:CancelColour)
        }else{
            cell.bgView.backgroundColor =  UIColor.white
            if s.IsTrackLink == 1{
                cell.locationDetailsBtn.isHidden = false
            }
        }
        
        
        let divColorCode = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
        cell.lblOrder.halfTextMakeToBold(fullText: cell.lblOrder.text!, changeText: "Order", textColor: divColorCode)
        cell.lblDept.halfTextMakeToBold(fullText: cell.lblDept.text!, changeText: "Dept", textColor: divColorCode)
        cell.lblPoNum.halfTextMakeToBold(fullText: cell.lblPoNum.text!, changeText: "PO Number", textColor: divColorCode)
        cell.lblDate.halfTextMakeToBold(fullText: cell.lblDate.text!, changeText: "Date", textColor: divColorCode)
        cell.lblTime.halfTextMakeToBold(fullText: cell.lblTime.text!, changeText: "Time", textColor: divColorCode)
        cell.lblPosition.halfTextMakeToBold(fullText: cell.lblPosition.text!, changeText: "Position", textColor: divColorCode)
        cell.lblReportTo.halfTextMakeToBold(fullText: cell.lblReportTo.text!, changeText: "Report To", textColor: divColorCode)
        
        cell.lblTotalNumTemps.halfTextMakeToBold(fullText: cell.lblTotalNumTemps.text!, changeText: "Total No of Temps", textColor: divColorCode)
        let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
       // if DivisionId == "92" || DivisionId == "113" || DivisionId == "29"{
        if s.IsCopyOrder == 0 {
            cell.BtnCopyOrder.isHidden = true
            cell.editBtnTrailingConstraint.constant = 5
            cell.layoutIfNeeded()
         }else{
             cell.BtnCopyOrder.isHidden = false
            cell.BtnCopyOrder.removeTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)
            cell.BtnCopyOrder.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)
            if s.IsEditOrder == 0{
                cell.editBtnTrailingConstraint.constant = 5
            }else{
                cell.editBtnTrailingConstraint.constant = 85

            }
        }
        if s.IsEditOrder == 0{
            cell.BtnEditOrder.isHidden = true
        }else{
            cell.BtnEditOrder.isHidden = false
            cell.BtnEditOrder.removeTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
            cell.BtnEditOrder.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        }
        
        
        cell.locationDetailsBtn.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)

 
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 245
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
    //MARK: Button Actions
    
    @IBAction func copyButtonTapped(_ sender: UIButton){
        let senderPosition  = sender.convert(CGPoint.zero, to: listTableView)
        
        let indexPath =  listTableView.indexPathForRow(at:senderPosition)
        let   s = datas[(indexPath?.row)!] as! Order
        /*
        let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        if DivisionId == "50" ||  DivisionId == "117" || DivisionId == "92"{
            
            self.pushToROSSchoolProfessionalPage(orderObj: s)
        }else{
            self.pushToROSHospitalityPage(OrderObj: s,isForCopy: true)
        }
 */
        if s.CopyOrderType == "School" {
            self.pushToROSSchoolProfessionalPage(orderObj: s)
        }
        else if s.CopyOrderType == "Hospitality" {
            self.pushToROSHospitalityPage(OrderObj: s,isForCopy: true)
        }
    }
    @IBAction func editButtonTapped(_ sender: UIButton){
        let senderPosition  = sender.convert(CGPoint.zero, to: listTableView)
        
        let indexPath =  listTableView.indexPathForRow(at:senderPosition)
        let   s = datas[(indexPath?.row)!] as! Order
        /*
        let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        if DivisionId == "50" ||  DivisionId == "117" || DivisionId == "92"{
            
//            self.pushToROSSchoolProfessionalPage(orderObj: s)
        }else{
            self.pushToROSHospitalityPage(OrderObj: s,isForCopy: false)
        }
 */
        
        if s.EditOrderType == "School" {
            
        }
        else if s.EditOrderType == "Hospitality" {
            self.pushToROSHospitalityPage(OrderObj: s,isForCopy: false)
        }
        
        
    }
    @IBAction func locationButtonTapped(_ sender: UIButton){
        let senderPosition  = sender.convert(CGPoint.zero, to: listTableView)
        
        let indexPath =  listTableView.indexPathForRow(at:senderPosition)
     
        let   s = datas[(indexPath?.row)!] as! Order

            self.pushToLocationDetailsPage(OrderObj: s)
 
    }
    
    //MARK:Server Call
    
    func getOrderListServerCall() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            let defaults = UserDefaults.standard
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            let DivisionId = String(format:"%d", defaults.integer(forKey: "DivisionId"))
            
            //userid as String
            let params :[String:String] = ["ContactId":ContactId,"ClientId":clientID,"DivId":DivisionId,"FromDate":startDateTxtField.text!,"ToDate":endDateTxtField.text!]
            print(params)
            
            RestAPI.getOrdersList(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
            
            //             {"FromDate":"08/06/2018","ToDate":"08/06/2018","ClientId":70829,"ContactId":194847,"DivId":55}
            
        }else{
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    
    func getResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            if object["FromDate"].null == nil && object["ToDate"].null == nil{
                
                if object["FromDate"].stringValue .count > 0{
                    StartDate = object["FromDate"].stringValue
                    
                }
                
                if object["ToDate"].stringValue .count > 0{
                    EndDate = object["ToDate"].stringValue
                    
                }
                if startDateTxtField.text?.count == 0 && endDateTxtField.text?.count == 0{
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
            }
            if object["CancelColour"].null == nil{
                CancelColour = object["CancelColour"].stringValue
                CancelColourImageView.backgroundColor =  UIColor(hexString:CancelColour)
                
            }
            datas .removeAllObjects()

            if object["MessageStatus"].intValue == 1
            {
                
                let dataArray = object["OrderHistoryList"].array
                datas .removeAllObjects()
                for dict in dataArray! {
                    
                    let OrderObj = Order.init(OrderId:  dict["OrderId"].stringValue, Department: dict["Department"].stringValue, PoNumber: dict["PoNumber"].stringValue, StartDate: dict["StartDate"].stringValue, EndDate: dict["EndDate"].stringValue, StartTime: dict["StartTime"].stringValue, EndTime: dict["EndTime"].stringValue, Position: dict["Position"].stringValue, ReportTo: dict["ReportTo"].stringValue, TotalNumberTemps: dict["TotalNumberTemps"].stringValue, Cancelled:  dict["Cancelled"].intValue, IsEditOrder:  dict["IsEditOrder"].intValue,IsTrackLink: dict["IsTrackLink"].intValue,IsCopyOrder:
                        dict["IsCopyOrder"].intValue, CopyOrderType: dict["CopyOrderType"].stringValue, EditOrderType: dict["EditOrderType"].stringValue)
                    
                    datas.add(OrderObj)
                    listTableView.reloadData()
                }
                if datas.count == 0 {
                    noDataView.isHidden = false
                    lblNoData.text = object["Message"].stringValue
                }else{
                    noDataView.isHidden = true
                }
                if object["CancelColour"].null == nil{
                    CancelColour = object["CancelColour"].stringValue
                }
            }else{
                listTableView.reloadData()

                var message = object["Message"].stringValue
                if message.count == 0 {
                    message = Error_Message
                }
                noDataView.isHidden = false
                lblNoData.text = message
                
            }
        }
    }
    //MARK: Navigation
    func pushToROSHospitalityPage(OrderObj: Order,isForCopy: Bool){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is ROSHospitalityViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ROSHospitalitySegue") as! ROSHospitalityViewController
            
            nextViewController.StartDate = OrderObj.StartDate!
            nextViewController.EndDate = OrderObj.EndDate!
            nextViewController.StartTime = OrderObj.StartTime!
            nextViewController.EndTime = OrderObj.EndTime!
            
            nextViewController.orderID = Int(OrderObj.OrderId!)!
            nextViewController.isCopyOrder = isForCopy
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            //            self.navigationController?.popViewController(animated: true)
        }
        
    }
    func pushToLocationDetailsPage(OrderObj: Order){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is TrackEmpLocationVC {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Location", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TrackEmpLocationVC") as! TrackEmpLocationVC
            nextViewController.OrderID = Int(OrderObj.OrderId!)!
            print("\(OrderObj.StartDate!) \(OrderObj.StartTime!)")
            nextViewController.OrderStartTimeDate = "\(OrderObj.StartDate!) \(OrderObj.StartTime!)"
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
    }
    func pushToROSSchoolProfessionalPage(orderObj: Order){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is ROSSchoolProfessionalViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ROSSchoolProfessionalSegue") as! ROSSchoolProfessionalViewController
            nextViewController.orderID  = Int(orderObj.OrderId!)!
            nextViewController.copyOrderNoofPositions =  orderObj.TotalNumberTemps!
            nextViewController.StartTime =  orderObj.StartTime!
            nextViewController.EndTime =  orderObj.EndTime!
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        
        self.addDivisionNameOnTop()
        
        customPickerView.showPickerViewInOrientation(superView: (self.navigationController?.view)!, isPortrait: self.isPortrait())
        self.customCalendarView.showPickerViewInOrientation(superView: (self.navigationController?.view)!, isPortrait: self.isPortrait())
        
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
