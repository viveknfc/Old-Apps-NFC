//
//  ActiveOrderViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 23/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON
import FSCalendar

//ActiveOrderTableViewCellIdentififer
class ActiveOrderViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance,UITextFieldDelegate {
    
    
     var customCalendarView = CalendarView()

    @IBOutlet weak var lblGrand: UILabel!
    @IBOutlet weak var lblGrandTotalValue: UILabel!
    @IBOutlet weak var selectdateTxtxField: UITextField!
    @IBOutlet weak var displayButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var txtBgView: UIView!
    @IBOutlet weak var noDataView: UIView!
    
    @IBOutlet weak var activeOrderListTableView: UITableView!
    var activeOrderDataArray = NSMutableArray()
    var resultDate = String()
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter
    }()
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titlelbl.text = "Active Orders Report"
        //        self.getTodaysActiveOrders()
        self.getActiveOrdersOnDate(date: "")
        
        
    }
    @objc override func appWillEnterForeground(){
        print("appWillEnterForeground Division")
        if activeOrderDataArray.count == 0{
            //            self.getTodaysActiveOrders()
            self.getActiveOrdersOnDate(date: "")
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isPortrait() == true{
         }else{
            let  screenWidth =  UIScreen.main.bounds.size.width
            
            let  screenHeight =  UIScreen.main.bounds.size.height
            print(screenWidth,screenHeight)
            DispatchQueue.main.async(execute: { () -> Void in
//                 self.SuperViewHeightConstraint.constant = UIScreen.main.bounds.size.width
            })
        }
        
        calendarButton.isSelected = true
        //        self.title = "Active Orders Report"
        txtBgView.layer.borderColor = borderColor.cgColor
        txtBgView.layer.borderWidth = 1
        txtBgView.backgroundColor = UIColor.white
        
        lblGrand.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        lblGrandTotalValue.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
        
        noDataView.backgroundColor = UIColor(hexString:danger_background_Color)
        lblNoData.textColor = UIColor(hexString:danger_Color)
        self.setupCalendarView()
    }
    func setupCalendarView(){
        customCalendarView = Bundle.main.loadNibNamed("CalendarView", owner: self, options: nil)?[0] as! CalendarView
        customCalendarView.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
        customCalendarView.setupCalendar()
        customCalendarView.calendar.delegate = self
        customCalendarView.calendar.dataSource = self
        
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int
    {
        
        //        let eventDate = self.dateFormatter.string(from: date)
        //        if self.datesWithMultipleEvents.contains(eventDate)
        //        {
        //
        //            return self.datesWithMultipleEvents.filter{$0 == eventDate}.count
        //        }
        return 0
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        //        let key = self.dateFormatter.string(from: date)
        
        return nil
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
            return false
            
        }
    }
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
     }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        
        print("did select date \(self.dateFormatter.string(from: date))")
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        
        
        let todayDate = date
        let todayString = formatter.string(from: todayDate)
        let todaysDay = self.getDayOfWeek(today: todayString)
        
        if todaysDay == "Sunday" {
            resultDate = self.dateFormatter.string(from: date)
            selectdateTxtxField.text = resultDate
            
            activeOrderDataArray.removeAllObjects()
            
            self.getActiveOrdersOnDate(date: resultDate)
            activeOrderListTableView.reloadData()
            
        }else{
        }
        self.hideCalendar()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
    }
    
    
    
    
    deinit {
        print("\(#function)")
    }
    
    func getTodaysActiveOrders(){
        
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        
        var result = ""
        
        let todayDate = Date()
        formatter.locale =  Locale(identifier: "en_US")
        
        let todayString = formatter.string(from: todayDate)
        let todaysDay = self.getDayOfWeek(today: todayString)
        
        if todaysDay == "Sunday" {
            result = formatter.string(from: todayDate)
        }else{
            let date = Date().sundayOfWeek
            
            let  endOfWeekString = formatter.string(from: date)
            result =  endOfWeekString
            
        }
        
        let date = self.convertDateStringToDefaultDate(dateString: result, formatString: dateFormat)
        self.customCalendarView.calendar.select(date)
        selectdateTxtxField.text = result
        self.getActiveOrdersOnDate(date: result)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Button Action
    
    @IBAction func displayAction(_ sender: Any)
    {
        selectdateTxtxField.text = resultDate
        
        self.getActiveOrdersOnDate(date: resultDate)
        
    }
    @IBAction func calendarBtnAction(_ sender: UIButton)
    {
        if sender.isSelected == true{
            noDataView.isHidden = true
            
            sender.isSelected =  false
            self.showCalendar()

        }else{
            if activeOrderDataArray.count == 0{
                noDataView.isHidden = false
                
            }
            sender.isSelected = true
self.hideCalendar()
            
        }
        
        self.view.layoutIfNeeded()
        
    }
    func hideCalendar(){
        self.customCalendarView.removePickerViewFromSuperView()
    }
    func showCalendar(){
        let date = self.convertDateStringToDefaultDate(dateString: selectdateTxtxField.text!, formatString: dateFormat)
        DispatchQueue.main.async(execute: { () -> Void in
            self.customCalendarView.calendar.setCurrentPage(date, animated: true)
            self.customCalendarView.calendar.select(date, scrollToDate: true)
            
        })
        
        self.customCalendarView.showPickerViewOnSuperView(superView: (self.navigationController?.view)!, isPortrait: true)
    }
    //MARK: TableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeOrderDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ActiveOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ActiveOrderTableViewCellIdentifier") as! ActiveOrderTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let s = activeOrderDataArray[indexPath.row]
        
        
        let  oObj:ActiveOrder = s as! ActiveOrder
        
        let empName =   oObj.EmployeeName
        let positionName =   oObj.Position
        let startDate =   oObj.StartDate
        let endDate =   oObj.EndDate
        let estimate =  oObj.EstimatedBilling!
        
        cell.lblName.text = empName
        cell.lblPosition.text = positionName
        cell.lblDate.text =  startDate!+" - "+endDate!
        cell.lblAmount.text =  estimate
        
        cell.lblNameTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.lblPositionTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.lblDateTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.lblAmountTitle.textColor =  UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        //        cell.bgView.layer.borderColor = borderColor.cgColor
        //        cell.bgView.layer.borderWidth = 2
        self.addDropDownShadowToView(shadowView: cell.bgView)
        return cell
        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 115
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    // MARK: - SERVER CALL
    
    
    func getActiveOrdersOnDate(date:String) {
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            let defaults = UserDefaults.standard
            
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let DivisionId = String(format:"%d", defaults.integer(forKey: "DivisionId"))
            
            //userid as String
            let params :[String:String] = ["ContactId":ContactId,"ClientID":clientID,"DivisionId":DivisionId,"StartDate":date]
            print(params)
            RestAPI.getActiveOrders(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
        }else{
            
            //            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message:  InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
        
    }
    
    func getResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        activeOrderDataArray.removeAllObjects()

self.hideCalendar()
        self.view.layoutIfNeeded()
        
        print(response)
        if response is String{
            noDataView.isHidden = false
            lblNoData.text = response as? String
            //            self.ShowAlertMessage(message: response as! String, title: "")
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            if object["StartDate"].null == nil  {
                
                let startDate = object["StartDate"].stringValue
                if selectdateTxtxField.text?.count == 0  {
                    resultDate = startDate
                    selectdateTxtxField.text = startDate
                }
            }
            
            if object["MessageStatus"].intValue == 1
            {
                
                let dataArray = object["ActiveList"].array
                
                lblGrandTotalValue.text = object["TotalEstimatedBilling"].stringValue
                
                
               
                
                
                
                for dict in dataArray! {
                    var startDate = ""
                    var endDate = ""
                    if dict["StartDate"].stringValue.count == 0{
                    }else{
                        startDate = dict["StartDateNew"].stringValue //self.getFormattedDate(string:   )
                    }
                    if dict["EndDate"].stringValue.count == 0{
                    }else{
                        endDate =  dict["EndDateNew"].stringValue//self.getFormattedDate(string:   )
                    }
                    
                    let div = ActiveOrder.init(EstimatedBilling: dict["EstBilling"].stringValue, StartDate: startDate, EndDate: endDate, EmployeeName: dict["EmployeeName"].stringValue, Position: dict["Position"].stringValue)
                    
                    activeOrderDataArray.add(div)
                    activeOrderListTableView.reloadData()
                }
                if activeOrderDataArray.count == 0 {
                    noDataView.isHidden = false
                    var message = object["Message"].stringValue
                    
                    if message.count == 0 {
                        
                        message = "No Records Found"
                        
                    }
                    
                    lblNoData.text = message
                    lblNoData.textColor = UIColor(hexString:danger_Color)
                    noDataView.backgroundColor = UIColor(hexString:danger_background_Color)

                }else{
                    noDataView.isHidden = true
                }
                
                
            }else{
                noDataView.isHidden = false
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                lblGrandTotalValue.text = "$ 0.00"
//                if message == "No Record Found"{
//                    lblNoData.textColor = UIColor.black
//
//                }else{
//                 }
                lblNoData.text = message
                lblNoData.textColor = UIColor(hexString:danger_Color)
                noDataView.backgroundColor = UIColor(hexString:danger_background_Color)
            }
        }
    }
    //MARK: TEXTFIELD DELEGATE
    //called when 'return' key pressed. return NO to ignore.
    
   
    public func textFieldDidBeginEditing(_ textField: UITextField){
        textField.resignFirstResponder()
        if (textField.text?.count)! > 0{
            self.showCalendar()
        }else{
            self.getActiveOrdersOnDate(date: "")
            
        }
        
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        
        
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            DispatchQueue.main.async(execute: { () -> Void in
                self.addDivisionNameOnTop()
//                self.baseScrollView.isScrollEnabled = false
//                self.SuperViewHeightConstraint.constant = UIScreen.main.bounds.size.width
//
//                self.baseScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.width)
            })
        case .portraitUpsideDown:
            text="PortraitUpsideDown"
        case .landscapeLeft:
            text="LandscapeLeft"
            DispatchQueue.main.async(execute: { () -> Void in
                self.addDivisionNameOnTop()
//                self.SuperViewHeightConstraint.constant = UIScreen.main.bounds.size.width
//
//                self.baseScrollView.isScrollEnabled = true
//                self.baseScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.width)
                
            })
        case .landscapeRight:
            text="LandscapeRight"
            DispatchQueue.main.async(execute: { () -> Void in
                self.addDivisionNameOnTop()
//                self.SuperViewHeightConstraint.constant = UIScreen.main.bounds.size.width
//
//                self.baseScrollView.isScrollEnabled = true
//                self.baseScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.width)
                
            })
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
        
    }
    
    
}
//extension Date {
//    var startOfWeek: Date {
//        let date = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
//        let dslTimeOffset = NSTimeZone.local.daylightSavingTimeOffset(for: date)
//        return date.addingTimeInterval(dslTimeOffset)
//    }
//
//    var endOfWeek: Date {
//        return Calendar.current.date(byAdding: .second, value: 604799, to: self.startOfWeek)!
//    }
//}


