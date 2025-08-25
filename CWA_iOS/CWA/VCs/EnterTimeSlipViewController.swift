
//
//  EnterTimeSlipViewController.swift
//  CWA
//
//  Created by NFC Solutions on 03/01/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON
import FSCalendar

class EnterTimeSlipViewController: BaseViewController,FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance {
    
    
    var TimeSlipOrderSelect:JSON = JSON.null
    var enterTimeSlipArray = NSMutableArray()
    var selectedData:JSON = JSON.null
    var weekEnd = String()
    var menuName = ""
     var isFromSafety = false
    @IBOutlet var headerView: UIView!
    @IBOutlet var noAssignmentLabel: UILabel!
    @IBOutlet var enterTimeSlipTableView: UITableView!
    @IBOutlet var datepickerButton: PKButton!
    var selectedDate = String()
    
    
    @IBOutlet var calenderHeight: NSLayoutConstraint!
    @IBOutlet var tableTop: NSLayoutConstraint!
    @IBOutlet var calenderView: FSCalendar!
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        return formatter
    }()
    
    @IBOutlet var cView: UIView!
    var calendeIsOpen = false
    var weekEndDate = Date()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titlelbl.text = menuName
      
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calenderHeight.constant = 250

        // Do any additional setup after loading the view.
        
//        self.navigationController?.navigationBar.barTintColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
//        if self.view.bounds.height <= 568
//        {
//            let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font:UIFont.systemFont(ofSize:13)]
//            self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
//        }
//        else
//        {
//            let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font:UIFont.systemFont(ofSize:17)]
//            self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
//        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        weekEndDate = Calendar.current.date(byAdding: .day, value: 1, to: date.endOfWeek(weekday: 1))!
        print(weekEndDate)
        selectedDate = formatter.string(from: weekEndDate)
        datepickerButton.setTitle(selectedDate, for: .normal)
        
        enterTimeSlipTableView.isScrollEnabled = false
        self.getTimeSilpData()
        
        
        tableTop.constant = 20
        cView.isHidden = true
//        calenderHeight.constant = 0
        
        
    }
    @objc override func appWillEnterForeground(){
        print("appWillEnterForeground Division")
        if enterTimeSlipArray.count == 0{
            self.getTimeSilpData()
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
            return false
            
        }
    }
    
    
    
    private func calendar(calendar: FSCalendar, appearance: FSCalendarAppearance, selectionColorForDate date: Date) -> UIColor? {
        
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
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        
        print("did select date \(self.dateFormatter.string(from: date))")
        selectedDate = self.dateFormatter.string(from: date)
        
       /////
 
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        
        let todayDate = date
        let todayString = formatter.string(from: todayDate)
        let todaysDay = self.getDayOfWeek(today: todayString)
        
        if todaysDay == "Sunday" {
            weekEndDate = date
            datepickerButton.setTitle(selectedDate, for: .normal)
            self.getTimeSilpData()

        }else{
//            self.navigationController?.view.makeToast("Please select weekend", duration: 1.5, position: .bottom, title: "", image: nil)
        }
 
        
        /////
        
        
    }
    func getTimeSilpData()
    {
        
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
 
            JustHUD.shared.showInView(view: view)
            
            let defaults = UserDefaults.standard
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let DivisionId = String(format:"%d", defaults.integer(forKey: "DivisionId"))
            
            let params:[String:Any] = ["WeekendDate" : selectedDate , "ClientId" : clientID , "ContactID" : ContactId , "DivisionId" : DivisionId,"OSSource": "iOS"]
            
            //  TestData
            //let params:[String:Any] = ["WeekendDate" : "12/03/2017" , "ClientId" : 70830 , "ContactID" : 194848 , "DivisionId" : 50]
            
            RestAPI.TimeSlipOrderSelect(self, params: params, method:"POST", accessToken:"", acces: true, callBack:  getresponseForTimeSlipOrderSelect(response:))
            headerView.isHidden = true
        }else{
             self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    
    
    
    
    //TimeSlipOrderSelect
    func getresponseForTimeSlipOrderSelect(response:AnyObject)->()
    {
        JustHUD.shared.hide()
        if response is String{
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            TimeSlipOrderSelect = response as! JSON
            print(TimeSlipOrderSelect)
//            calenderView.removeFromSuperview()
            tableTop.constant = 20
            cView.isHidden = true
            calenderHeight.constant = 0
            calendeIsOpen = false
            if TimeSlipOrderSelect["MessageStatus"].intValue == 0
            {
                noAssignmentLabel.text =  " "+TimeSlipOrderSelect["Message"].stringValue.replace(target:"\n", withString:"")
                noAssignmentLabel.backgroundColor = UIColor(hexString:danger_background_Color)
                noAssignmentLabel.textColor = UIColor(hexString:danger_Color)
                
                enterTimeSlipTableView.isScrollEnabled = false
                enterTimeSlipTableView.backgroundColor = .clear
                enterTimeSlipTableView.reloadData()
                headerView.isHidden = true
            }
            else
            {
                enterTimeSlipTableView.isScrollEnabled = true
                enterTimeSlipTableView.backgroundColor = UIColor(hexString:"#EEEEEE")
                let ListEmployeeeTimeslips = TimeSlipOrderSelect["ListEmployeeeTimeslips"].array
                headerView.isHidden = false
                enterTimeSlipArray.removeAllObjects()
                for dict in ListEmployeeeTimeslips!
                {
                    if dict["WorkSched"].count>0
                    {
                        let data = EnterTimeSlip.init(OrderId: dict["OrderId"].intValue,CandidateName: dict["CandidateName"].stringValue,Assignment: dict["Position"].stringValue,Reference: dict["PhoneNumber"].stringValue,Schedule: dict["WorkSched"].arrayObject as! [String])
                        enterTimeSlipArray.add(data)
                    }
                    else
                    {
                        let data = EnterTimeSlip.init(OrderId: dict["OrderId"].intValue,CandidateName: dict["CandidateName"].stringValue,Assignment: dict["Position"].stringValue,Reference: dict["PhoneNumber"].stringValue,Schedule:[])
                        enterTimeSlipArray.add(data)
                    }
                }
                self.weekEnd = TimeSlipOrderSelect["WeekendDate"].stringValue
                
                enterTimeSlipTableView.reloadData()
            }
            
        }
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
    
    @IBAction func datePickerAction(_ sender: PKButton) {

        if calendeIsOpen
        {
            tableTop.constant = 20
            cView.isHidden = true
            calenderHeight.constant = 0
            calendeIsOpen = false
        }
        else
        {
//        calenderView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 280)
            self.calenderView.select(weekEndDate)
        self.calenderView.delegate = self
        self.calenderView.scope = .month
        // For UITest
        self.calenderView.accessibilityIdentifier = "calendar"
        self.calenderView.appearance.selectionColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        self.calenderView.appearance.weekdayTextColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        self.calenderView.appearance.headerTitleColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        self.calenderView.appearance.todayColor =  UIColor.clear
            
//        cView.addSubview(calenderView)
        tableTop.constant = 300
        cView.isHidden = false
        calenderHeight.constant = 250
            calendeIsOpen = true
        }
    }
    
    
    
    //passing Data
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! EnterTimeSlipDetailViewController
        dvc.selectedData = selectedData
        dvc.weekEnd = weekEnd
        dvc.menuName = menuName
    }
    
    
    
}
extension EnterTimeSlipViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var scheduleString = String()
        let dictData:EnterTimeSlip = enterTimeSlipArray[indexPath.section] as! EnterTimeSlip
        for string in 0..<dictData.Schedule.count
        {
            scheduleString += dictData.Schedule[string].replace(target:"\n\r", withString:"--").replace(target: "\n", withString:"")+" \r\n"
        }
        let heightOfRow = Constants.calculateHeight(inString:scheduleString,width:self.view.bounds.size.width)
        let orderHeight = Constants.calculateHeight(inString:
            "\(dictData.OrderId!)",width:self.view.bounds.size.width)
        let nameHeight = Constants.calculateHeight(inString:dictData.CandidateName!,width:self.view.bounds.size.width)
        let assHeight = Constants.calculateHeight(inString:dictData.Assignment!,width:self.view.bounds.size.width)
        let referenceHeight = Constants.calculateHeight(inString:dictData.Reference!,width:self.view.bounds.size.width)
        var Padding = CGFloat(110)
        if dictData.Reference?.count == 0{
             Padding = 90
        }
 
        return (heightOfRow+orderHeight+nameHeight+assHeight+referenceHeight + Padding)
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            return 10
        }
        else
        {
            return 5
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedData = TimeSlipOrderSelect["ListEmployeeeTimeslips"][indexPath.section]
        self.performSegue(withIdentifier: "detailSegue", sender:nil)
    }
}
extension EnterTimeSlipViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return TimeSlipOrderSelect["ListEmployeeeTimeslips"].arrayValue.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if enterTimeSlipArray.count == 0{
            return 0
            
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "etCell") as! EnterTableViewCell
        
        
        let dictData:EnterTimeSlip = enterTimeSlipArray[indexPath.section] as! EnterTimeSlip
        cell.orderId.text = "\(dictData.OrderId!)"
        cell.candidateNameLabel.text = dictData.CandidateName
        cell.assignmentLabel.text = dictData.Assignment
        cell.referenceLabel.text = dictData.Reference
        
        let orderHeight = Constants.calculateHeight(inString:
            String(format:"%d",dictData.OrderId!),width:self.view.bounds.size.width)
        let nameHeight = Constants.calculateHeight(inString:dictData.CandidateName!,width:self.view.bounds.size.width)
        let assHeight = Constants.calculateHeight(inString:dictData.Assignment!,width:self.view.bounds.size.width)
        let referenceHeight = Constants.calculateHeight(inString:dictData.Reference!,width:self.view.bounds.size.width)
        
        cell.orderHeight.constant =  orderHeight+10
        cell.assignmentHeight.constant =  assHeight+10
        cell.candidateHeight.constant =  nameHeight+10
        var Padding = CGFloat(15)
        if dictData.Reference?.count == 0{
        }else{
           Padding = 30
        }
        cell.referenceHeight.constant =  referenceHeight + Padding
        
        cell.assignementTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.orderIdTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.referenceTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.scheduleTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.candidateNameTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
        var scheduleString = String()
        var days = String()
        for string in 0..<dictData.Schedule.count
        {
            days += dictData.Schedule[string].substring(to:3)+"\r\n"
            scheduleString += dictData.Schedule[string].substring(with:4..<dictData.Schedule[string].count).replace(target:"\n\r", withString:"--").replace(target:"\n",withString:"").replace(target: " ", withString:"")+"\r\n"
        }
        
        if self.view.bounds.size.height <= 568
        {
            cell.scheduleLabel.font = UIFont.systemFont(ofSize:11)
            cell.scheduleDays.font = UIFont.systemFont(ofSize: 11)
        }
        else
        {
            cell.scheduleLabel.font = UIFont.systemFont(ofSize:13)
            cell.scheduleDays.font = UIFont.systemFont(ofSize: 13)
        }
        cell.scheduleLabel.text = scheduleString
        cell.scheduleDays.text = days
        
        cell.selectionStyle = .none
        return cell
        
    }
    
}
extension String
{
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}
extension String
{
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}
extension Date {
    func startOfWeek(weekday: Int?) -> Date {
        var cal = Calendar.current
        var component = cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self as Date)
        component.to12am()
        cal.firstWeekday = weekday ?? 1
        return cal.date(from: component)!
    }
    
    func endOfWeek(weekday: Int) -> Date {
        let cal = Calendar.current
        var component = DateComponents()
        component.weekOfYear = 1
        component.day = -1
        component.to12pm()
        return cal.date(byAdding: component, to: startOfWeek(weekday: weekday))!
    }
}
internal extension DateComponents {
    mutating func to12am() {
        self.hour = 0
        self.minute = 0
        self.second = 0
    }
    
    mutating func to12pm(){
        self.hour = 23
        self.minute = 59
        self.second = 59
    }
}

