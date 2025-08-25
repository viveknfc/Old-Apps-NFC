//
//  E_CheckInVC.swift
//  CWA
//
//  Created by NFC User on 28/09/23.
//  Copyright © 2023 NFC Solutionsusa. All rights reserved.
//

import UIKit
import FSCalendar
import SwiftyJSON

class E_CheckInVC: BaseViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, UITextFieldDelegate, DateTimePickerDelegate {
    
    @IBOutlet weak var selectDateTF: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var mainTableView: UITableView!
    
    @IBOutlet weak var noItemView: UIView!
    
    var customCalendarView = CalendarView()
    var resultDate = String()
    let today = Date()
    var todayString: String?
    
    var timeSelected: String?
    let defaultTime = "1900-01-01 00:00:00"
    var activeTextField: UITextField?
    
    let itemList = NSMutableArray()
    
    let defaults = UserDefaults.standard
    
    var clientID: String?
    var contactID: String?
    var WeekEndDate: String?
    
    //Params for Check In
    
    var CandId: Int?
    var OrderId: Int?
    var WeekEnd: String?
    var BillDate: String?
    var StartTime: String?
    var EndTime: String?
    var CheckIn: String?
    var CheckOut: String?
    var ChkInType: Int?
    var RouteName: String?
    var ClientId: Int? // getting from previous screen
    var ContactId: Int? // getting from previous screen
    var timeOut: String?
    var timeIn: String?
    var breakMinutes: Int?
    var totlaHours: Int?
    var RecCode: String?
    var PayforBreak: Int?
    var Id: Int?
    var longitude: Double?
    var latitude: Double?
    var Address: String?
    
    //End
    
    var latToSend = Double()
    var lognToSend = Double()
    var addressToSend = String()
    
    var IPAddress = String()
    
    var activeCellIndex: IndexPath?
    
    override func viewWillAppear(_ animated: Bool) {
        
        clientID = defaults.string(forKey: "ClientID")!
        contactID = defaults.string(forKey: "ContactId")!
        
        ClientId = Int(clientID!)
        ContactId = Int(contactID!)
        
                if let selectedDate = DateManager.shared.selectedDate {
                    selectDateTF.text = self.dateFormatter.string(from: selectedDate)
                    WeekEndDate = self.dateFormatter.string(from: selectedDate)
                    
                    getCheckInDataCall(clientId: clientID!, contactId: contactID!, weekEnd: WeekEndDate!)
                } else {
                    
                    //To load default date
                    
                    let todayDate = self.dateFormatter.string(from: today)
                    print("viv today's date is ", todayDate)
                    selectDateTF.text = todayDate
                    WeekEndDate = todayDate
                    getCheckInDataCall(clientId: clientID!, contactId: contactID!, weekEnd: todayDate)
                    
                    //end
                    
                }
        
        noItemView.layer.cornerRadius = 10
   
        if itemList.count == 0 {
            noItemView.isHidden = false
        } else {
            noItemView.isHidden = true
        }
        titlelbl.text = "E-Check In"
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCalendarView()
        
        noItemView.layer.cornerRadius = 10

        selectDateTF.delegate = self
        
        clientID = defaults.string(forKey: "ClientID")!
        contactID = defaults.string(forKey: "ContactId")!
        
        ClientId = Int(clientID!)
        ContactId = Int(contactID!)
        
        titlelbl.text = "E-Check In"

    }
    
    override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
          
          // Unregister for notifications when the view is about to disappear
          NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
          NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
      }
    
    // Method called when the app enters the background
    @objc func appDidEnterBackground() {
        print("App entered the background from \(String(describing: self))")
    }

    // Method called when the app becomes active
    @objc func appDidBecomeActive() {
        print("App became active on \(String(describing: self))")
        getCheckInDataCall(clientId: clientID!, contactId: contactID!, weekEnd: WeekEndDate!)
    }

    
    //MARK: - Calander View
    
    func setupCalendarView(){
        customCalendarView = Bundle.main.loadNibNamed("CalendarView", owner: self, options: nil)?[0] as! CalendarView
        customCalendarView.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
        customCalendarView.setupCalendar()
        customCalendarView.calendar.delegate = self
        customCalendarView.calendar.dataSource = self
        
    }
    
    //MARK: - Show / Hide Calander
    
    func hideCalendar(){
        self.customCalendarView.removePickerViewFromSuperView()
    }
    func showCalendar(){
        
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        let calendar = Calendar.current
        let sunday = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: Date()))!
        todayString = formatter.string(from: sunday)
        
        let date = self.convertDateStringToDefaultDate(dateString: todayString!, formatString: dateFormat)
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.customCalendarView.calendar.setCurrentPage(date, animated: true)
            self.customCalendarView.calendar.select(date, scrollToDate: true)
        })
        
        self.customCalendarView.showPickerViewOnSuperView(superView: (self.navigationController?.view)!, isPortrait: true)
    }
    
    //MARK: - Go Action Button
    
    
    @IBAction func goActionClicked(_ sender: UIButton) {
            
        print("the textfield value taken as", selectDateTF.text!)

        WeekEndDate = selectDateTF.text!
        ClientId = Int(clientID!)
        ContactId = Int(contactID!)
        
 
        let WeekEndDateFormat = convertDateFormat(inputDate: WeekEndDate!)
        print("the Week end date in required format is", WeekEndDateFormat as Any)
        
        getCheckInDataCall(clientId: clientID!, contactId: contactID!, weekEnd: WeekEndDate!)
        
    }
    
    //MARK: - Go API Call
    
    func getCheckInDataCall(clientId: String, contactId: String, weekEnd: String) {
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable{
            
            JustHUD.shared.showInView(view: (self.view)!)
            
            let params :[String:String] = ["ClientId":clientId,
                "ContactId":contactId,
                "WeekEnd":weekEnd]
            
            RestAPI.getListOfECheckInDatas(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
            
        }
        else{
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    
    //MARK: - Go API Response
    
    func getResponse(response:AnyObject)->(){
        
        JustHUD.shared.hide()
        
        if response is String{
         
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        else {
            
            itemList.removeAllObjects()

            self.mainTableView.reloadData()
            
            var dict1 = NSMutableDictionary()
            
            let object = response as! JSON
            print("the Go Button Response is", object)
            
            if object[0]["message"].stringValue.count > 0 {
                print("the message response is ",object[0]["message"].stringValue)
                noItemView.isHidden = false
            }
            
            else {
                
                let dataArray = object.array
                
                if dataArray != nil {
                    
                    for dict in dataArray! {
                        
                        let item = ChkInItems.init(Name: dict["CandidateName"].stringValue, Position: dict["Position"].stringValue, StartTime: dict["StartTime"].stringValue, EndTime: dict["EndTime"].stringValue, OrderId: dict["OrderId"].intValue, WeekEnd: dict["WeekEnd"].stringValue, ISAdminUser: dict["ISAdminUser"].intValue, CheckOut: dict["CheckOut"].stringValue, BillDate: dict["BillDate"].stringValue, PayforBreak: dict["PayforBreak"].boolValue, RecCode: dict["RecCode"].stringValue, CandId: dict["CandId"].intValue, CheckIn: dict["CheckIn"].stringValue, PositionLabelColor: dict["PositionLabelColor"].stringValue)
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "hh:mm aa"

                        let currentTime = dateFormatter.string(from: Date())
                        let tempCheckIn = currentTime
                        
                        
                        dict1 = ["Name":"\(item.Name!)", "Position":"\(item.Position!)", "StartTime":"\(item.StartTime!)", "EndTime":"\(item.EndTime!)", "OrderId":"\(item.OrderId!)",
                                 "WeekEnd":"\(item.WeekEnd!)", "ISAdminUser":"\(item.ISAdminUser!)", "CheckOut":"\(item.CheckOut!)", "BillDate":"\(item.BillDate!)", "PayforBreak":"\(item.PayforBreak!)", "RecCode":"\(item.RecCode!)", "CandId":"\(item.CandId!)", "CheckIn":tempCheckIn, "PositionLabelColor":"\(item.PositionLabelColor!)"]
       
                        if itemList.contains(dict1){} else {
                            print("The dict1 Item is", dict1)
                            itemList.add(dict1)
                        }
                        
                    }
                    
                   
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.mainTableView.reloadData()
                    })
                    
                }
                
            }
 
            if itemList.count == 0{
                noItemView.isHidden = false
            } else {
                noItemView.isHidden = true
            }
            
        }
        
    }
    
    //MARK: - Calendar Fucntions
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int
    {
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        
        let todayDate = Calendar.current.startOfDay(for: Date())
        let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: todayDate)!
        
        let dateString = formatter.string(from: date)
        let dayOfWeek = self.getDayOfWeek(today: dateString)
        
        if date == todayDate || date == yesterdayDate {
            return #colorLiteral(red: 0.1515013874, green: 0.1768231988, blue: 0.4189088941, alpha: 1)
        } else {
            return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        
//        let todayDate = date
//        let todayString = formatter.string(from: todayDate)
//        let todaysDay = self.getDayOfWeek(today: todayString)
//        
//        if todaysDay == "Sunday" {
//            return #colorLiteral(red: 0.1515013874, green: 0.1768231988, blue: 0.4189088941, alpha: 1)
//        }else{
//            return #colorLiteral(red: 0.260161221, green: 0.3038564622, blue: 0.7233690619, alpha: 1)
//        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
     }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let selectedDate = Calendar.current.startOfDay(for: date)
        let today = Calendar.current.startOfDay(for: Date())
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!

        return selectedDate == today || selectedDate == yesterday
//        return true
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        
        let selectedDate = Calendar.current.startOfDay(for: date)
        let today = Calendar.current.startOfDay(for: Date())
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        
        if selectedDate == today || selectedDate == yesterday {
            print("did select date \(self.dateFormatter.string(from: date))")
            
            DateManager.shared.selectedDate = date
            
            resultDate = self.dateFormatter.string(from: date)
            selectDateTF.text = resultDate
            customCalendarView.removePickerViewFromSuperView()
        } else {
            print("Wrong date entered")
        }
        
        
    }


    //MARK: - Date Format
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter
    }()
    
    //MARK: - Textfield Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("viv enters did begin editing")
        
        textField.resignFirstResponder()
        
        if textField == selectDateTF {
            showCalendar()
        }
        
        else {
            print("viv entering here for active tf tag")
            
//            if let indexPath = getIndexPath(for: textField) {
//                    activeCellIndex = indexPath
//                }
//            
//            self.showPicker(ampm:false,selectedDate: Date())
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        
        }
    

    
    //MARK: - Time Picker
    
    func showPicker(ampm:Bool,selectedDate: Date) {
        
        let min = selectedDate.addingTimeInterval(-60 * 60 * 24 * 4) //4 days -
        let max = selectedDate.addingTimeInterval(60 * 60 * 24 * 4)//4 days +
        let picker = DateTimePicker.show(selected: selectedDate, minimumDate: min, maximumDate: max)
        
        picker.timeInterval = DateTimePicker.MinuteInterval.default
        
        picker.highlightColor = #colorLiteral(red: 0.1515013874, green: 0.1768231988, blue: 0.4189088941, alpha: 1)
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = "Done"
        picker.doneBackgroundColor = #colorLiteral(red: 0.3742285371, green: 0.426192522, blue: 0.3634500504, alpha: 1)
        picker.locale = Locale(identifier: "en_GB")
        
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
        picker.includeMonth = false
        
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
            
         //   self.activeTextField?.text = formatter.string(from: date)
            
            if let activeCellIndex = self.activeCellIndex {
                
                let dataDict:NSMutableDictionary = self.itemList[activeCellIndex.row] as! NSMutableDictionary
                dataDict["CheckIn"] = formatter.string(from: date)
                self.mainTableView.reloadData()
                
                    }
            

            self.timeSelected = formatter.string(from: date)
        }
        
        picker.delegate = self
        NotificationCenter.default.post(name: Notification.Name("Time"), object: nil)
    }

    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        print(picker.selectedDateString)
    }
    
    //MARK: - Get IndexPath of selected row
    
//    private func findIndexPathForView(_ view: UIView, in tableView: UITableView) -> IndexPath? {
//            let point = view.convert(CGPoint.zero, to: tableView)
//            return tableView.indexPathForRow(at: point)
//        }
    
    func getIndexPath(for textField: UITextField) -> IndexPath? {
        let point = textField.convert(CGPoint.zero, to: self.mainTableView)
        return self.mainTableView.indexPathForRow(at: point)
    }
    
    
    
}

extension E_CheckInVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return itemList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"CInHCell", for: indexPath) as! CInHeadingCell
        
        cell.checkInTF.delegate = self
        cell.checkInTF.tag = indexPath.row
        
        let dataDict:NSMutableDictionary = itemList[indexPath.row] as! NSMutableDictionary
        
        if dataDict.allKeys.count == 0{}else {
            
            let clientName = dataDict["Name"]
            cell.FName.text = clientName as? String
            
            let position = dataDict["Position"]
            cell.PName.text = position as? String
            
            if let positionColor = dataDict["PositionLabelColor"] as? String {
                cell.PName.backgroundColor = UIColor(hexString: positionColor)
                cell.PName.textColor = .white
            }
            
            //for Time
            
            if ((dataDict["StartTime"] != nil) && (dataDict["EndTime"] != nil)) {
                
                StartTime = dataDict["StartTime"] as? String
                let start = scheduledTime(dateTime: StartTime!)
                let startTime = convertTo12HourFormat(start)!
                
                EndTime = dataDict["EndTime"] as? String
                let end = scheduledTime(dateTime: EndTime!)
                let endTime = convertTo12HourFormat(end)!
                
                let scheduleTime = "\(startTime) - \(endTime)"
                
                cell.Time.text = scheduleTime
                
            }
  
            //end
            
            cell.checkInTF.text = dataDict["CheckIn"] as? String
 
                
            cell.checkInSubmit.removeTarget(self, action: #selector(submitButtonTapped(_:)), for: .touchUpInside)
            cell.checkInSubmit.addTarget(self, action: #selector(submitButtonTapped(_:)), for: .touchUpInside)
            
        }
        cell.checkInSubmit.titleLabel?.textColor = .white
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 150
    }
    
    
    //MARK: - Scheduled Time Fucntion
    
    func scheduledTime(dateTime: String) -> String {
        
        let dateString = dateTime
        let components = dateString.split(separator: "T")
        
        if components.count > 1 {
            let timePart = components[1]
            let components = timePart.split(separator: ":")
            if components.count >= 2 {
                let hour = components[0]
                let minute = components[1]
                
                let formattedTime = "\(hour):\(minute)"
                
                return formattedTime // This will print "10:30"
            } else {
                print("Invalid time format")
            }
        } else {
            print("Invalid date format")
        }
        
        return "NA"
    }
    
    //MARK: - AM PM Convert
    
    func convertTo12HourFormat(_ timeString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if let date = dateFormatter.date(from: timeString) {
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        }
        
        return nil
    }
    
    //MARK: - Input Check In Time Format
    
    
    func convertTimeFormat(inputTime: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "h:mm a"
        
        if let date = inputFormatter.date(from: inputTime) {
            
            var components = Calendar.current.dateComponents([.hour, .minute], from: date)
                    components.year = 1900
                    components.month = 1
                    components.day = 1
                    let newDate = Calendar.current.date(from: components)!
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let outputTime = outputFormatter.string(from: newDate)
            return outputTime
        } else {
            return nil
        }
    }
    
    //MARK: - Add 1 hour to Input Time
    
    func addOneHour(inputTime: String) -> String? {
        
        let dateString = inputTime

        // Create a date formatter to convert the string to a Date object
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC") // Assuming your date is in UTC

        if let startDate = dateFormatter.date(from: dateString) {
            // Add one hour (3600 seconds) to the start date
            let endDate = startDate.addingTimeInterval(3600)
            
            // Convert the end date back to a string if needed
            let endDateString = dateFormatter.string(from: endDate)
            
            return endDateString
        } else {
            print("Invalid date format")
            return nil
        }
        
    }
    
    //MARK: - Input Date Formater
    
    func convertDateFormat(inputDate: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "MM/dd/yyyy"
        
        if let date = inputFormatter.date(from: inputDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            outputFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let outputDate = outputFormatter.string(from: date)
            return outputDate
        } else {
            return nil
        }
    }
    
    //MARK: - Submit Button Tapped
    
    @objc func submitButtonTapped(_ sender: UIButton) {
        
        checkLocationAccess { [self] hasAccess in
  
            if hasAccess {
                // Handle permission granted case
                DispatchQueue.main.async {
                
                CMALocationManager.shared.requestLocationAtOnce()
                
                if let recentLocation = CMALocationManager.shared.currentLocation?.coordinate, CMALocationManager.shared.currentLocation?.horizontalAccuracy ?? -1 >= 0 {
                    self.latToSend = recentLocation.latitude
                    self.lognToSend = recentLocation.longitude
                }
                else {
                    //                JustHUD.shared.showInView(view: (self.view)!)
                    let delayInSeconds = 5
                    let delayInNanoSeconds = UInt64(delayInSeconds * 1_000_000_000)
                    DispatchQueue.main.asyncAfter(deadline: .now() + .nanoseconds(Int(delayInNanoSeconds))) { [self] in
                        CMALocationManager.shared.requestLocationAtOnce()
                        if let recentLocation = CMALocationManager.shared.currentLocation?.coordinate {
                            latToSend = recentLocation.latitude
                            lognToSend = recentLocation.longitude
                        }
                        //                    JustHUD.shared.hide()
                    }
                }
                
                print("the latitude is",self.latToSend)
                print("the longitude is", self.lognToSend)
                
                self.reverseGeoCode1(lat: self.latToSend, long: self.lognToSend) { address in
                    if let address = address {
                        // Use the address here
                        print("Address from chk in is:", address)
                        self.Address = address
                    } else {
                        print("Failed to retrieve address")
                    }
                }
                
                self.longitude = self.lognToSend
                self.latitude = self.latToSend
                
                let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.mainTableView)
                let indexPath = self.mainTableView.indexPathForRow(at: buttonPosition)
                
                let dataDict:NSMutableDictionary = self.itemList[indexPath!.row] as! NSMutableDictionary
                
                if self.timeSelected != nil {
                    print("the time selected is ", self.timeSelected!)
                    let newFormat = self.convertTimeFormat(inputTime: self.timeSelected!)
                    print("the New Format entered Time is",newFormat!)
                    let addHour = self.addOneHour(inputTime: newFormat!)
                    print("the New Format check out Time is",addHour!)
                    
                    self.CheckIn = newFormat
                    
                }
                else{
                    let defaultTime = dataDict["CheckIn"] as? String
                    let newFormatDefaultTime = self.convertTimeFormat(inputTime: defaultTime!)
                    self.CheckIn = newFormatDefaultTime
                    print("Selected the current time")
                }
                
                //IP
                
                if let ipAddress = self.getIPv4Address() {
                    print("IP Address getting is: \(ipAddress)")
                    self.IPAddress = ipAddress
                } else {
                    print("Unable to retrieve IP address")
                }
                
                //End
                
                
                
                if dataDict.allKeys.count == 0{}else {
                    
                    //Param Values
                    
                    self.CandId = Int(dataDict["CandId"] as? String ?? "0")
                    self.OrderId = Int(dataDict["OrderId"] as? String ?? "0")
                    self.WeekEnd = dataDict["WeekEnd"] as? String
                    self.BillDate = dataDict["BillDate"] as? String
                    self.RecCode = dataDict["RecCode"] as? String ?? "S"
                    self.CheckOut = dataDict["CheckOut"] as? String
                    self.EndTime = dataDict["EndTime"] as? String
                    self.StartTime = dataDict["StartTime"] as? String
                    
                    self.ChkInType = 0
                    self.RouteName = "iOS"
                    self.timeOut = self.defaultTime
                    self.timeIn = self.defaultTime
                    self.breakMinutes = 0
                    self.totlaHours = 0
                    self.PayforBreak = 0
                    self.Id = 0
                    
                    //End
                    
                }
                
                
                print("CandId",self.CandId as Any) //done
                print("OrderId",self.OrderId as Any) // done
                print("WeekEnd",self.WeekEnd as Any) //done
                print("BillDate",self.BillDate as Any) //done
                print("EndTime",self.EndTime as Any) //done
                print("CheckIn",self.CheckIn as Any) //done
                print("CheckOut",self.CheckOut as Any) //done
                print("ClientId",self.ClientId as Any) //done
                print("ContactId",self.ContactId as Any) //done
                print("ChkInType",self.ChkInType as Any) // done
                print("RouteName",self.RouteName as Any) //done
                print("timeOut",self.timeOut as Any) //done
                print("timeIn",self.timeIn as Any) //done
                print("breakMinutes",self.breakMinutes as Any) //done
                print("totlaHours",self.totlaHours as Any) //done
                print("RecCode",self.RecCode as Any) // done
                print("PayforBreak",self.PayforBreak as Any) //done
                print("Id",self.Id as Any) //done
                print("longitude",self.longitude as Any)
                print("latitude",self.latitude as Any)
                print("Address",self.Address as Any)
                
                if (self.CandId != nil && self.OrderId != nil && self.WeekEnd != nil && self.BillDate != nil && self.StartTime != nil && self.EndTime != nil && self.CheckIn != nil && self.CheckOut != nil && self.ClientId != nil && self.ContactId != nil && self.ChkInType != nil && self.RouteName != nil && self.timeOut != nil && self.timeIn != nil && self.breakMinutes != nil && self.totlaHours != nil && self.RecCode != nil && self.PayforBreak != nil && self.Id != nil && self.latitude != nil && self.longitude != nil) {
                    
                    let params: [String: Any] = ["CandId":self.CandId!, "OrderId":self.OrderId!, "WeekEnd":self.WeekEnd!, "BillDate":self.BillDate!, "StartTime":self.StartTime!, "EndTime": self.EndTime!, "CheckIn":self.CheckIn!, "CheckOut":self.CheckOut!, "Type":self.ChkInType!, "RouteName":self.RouteName!, "ClientId":self.ClientId!, "ContactId":self.ContactId!, "timeOut":self.timeOut!, "timeIn":self.timeIn!, "breakMinutes":self.breakMinutes!, "totlaHours":self.totlaHours!, "RecCode":self.RecCode!, "PayforBreak":self.PayforBreak!, "Id":self.Id!, "longitude":self.longitude!, "latitude": self.latitude!, "Address":self.Address ?? "Not Found", "IPAddress":self.IPAddress, "Retry": 0 ]
                    
                    print("the Parameters for the API call is", params)
                    
                    let isInternetAvailable = self.isInternetAvailable()
                    
                    if isInternetAvailable {
                        
                        JustHUD.shared.showInView(view: (self.view)!)
                        
                        RestAPI.getECheckInTime(self, params: params, method: "POST", accessToken: "", acces: true, callBack: self.getSubmitResponse(response:))
                    }
                    else{
                        
                        self.showCustomAlert(Title: self.InternetConnectionTitle, attMessage: NSAttributedString(), message: self.InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: self.Danger_Text, isAttributed: false)
                        
                    }
                    
                } else {
                    print("in Parameters some is nill")
                }
                
            }
                    } else {
                        // Handle permission denied/restricted case
                        self.askPermission()
                    }
                
            }
         
  
    }
    
    //MARK: - API Submit Response
    
    func getSubmitResponse(response:AnyObject)->() {
        
        if response is String{
            
            JustHUD.shared.hide()
            
            let title = response as! String
            let titleColor = #colorLiteral(red: 0.8576444983, green: 0.3266127706, blue: 0.3078376949, alpha: 1)
            let titleBg = #colorLiteral(red: 0.9495584369, green: 0.8718144298, blue: 0.8732326627, alpha: 1)
            let buttonBg = #colorLiteral(red: 0.8576444983, green: 0.3266127706, blue: 0.3078376949, alpha: 1)
            let buttonTitleColor = UIColor.white

            self.showCustomAlertWithOkButton(title: title, titleColor: titleColor, titleBackgroundColor: titleBg, buttonBackgroundColor: buttonBg, buttonTitleColor: buttonTitleColor)
            
        }
        else {
            
            let object = response as! JSON
            print("the API Submit Response is", object)
            
            if object[0]["Retry"].intValue == 1 {
                print("retry mechanism calling")
                
                //start
                
                let delayInSeconds = object[0]["Sleep"].intValue
                let delayInNanoSeconds = UInt64(delayInSeconds * 1_000_000_000)

                DispatchQueue.main.asyncAfter(deadline: .now() + .nanoseconds(Int(delayInNanoSeconds))) { [self] in
                        
                        CMALocationManager.shared.requestLocationAtOnce()
                        
                                if let recentLocation = CMALocationManager.shared.currentLocation?.coordinate, CMALocationManager.shared.currentLocation?.horizontalAccuracy ?? -1 >= 0 {
                                    latToSend = recentLocation.latitude
                                    lognToSend = recentLocation.longitude
                                }
                        
                        reverseGeoCode1(lat: latToSend, long: lognToSend) { address in
                            if let address = address {
                                // Use the address here
                                print("Address from retry chk in is:", address)
                                self.Address = address
                            } else {
                                print("Failed to retrieve address")
                            }
                        }
                        
                        longitude = lognToSend
                        latitude = latToSend
                        
                        if (CandId != nil && OrderId != nil && WeekEnd != nil && BillDate != nil && StartTime != nil && EndTime != nil && CheckIn != nil && CheckOut != nil && ClientId != nil && ContactId != nil && ChkInType != nil && RouteName != nil && timeOut != nil && timeIn != nil && breakMinutes != nil && totlaHours != nil && RecCode != nil && PayforBreak != nil && Id != nil && latitude != nil && longitude != nil) {
                            
                            let params: [String: Any] = ["CandId":CandId!, "OrderId":OrderId!, "WeekEnd":WeekEnd!, "BillDate":BillDate!, "StartTime":StartTime!, "EndTime": EndTime!, "CheckIn":CheckIn!, "CheckOut":CheckOut!, "Type":ChkInType!, "RouteName":RouteName!, "ClientId":ClientId!, "ContactId":ContactId!, "timeOut":timeOut!, "timeIn":timeIn!, "breakMinutes":breakMinutes!, "totlaHours":totlaHours!, "RecCode":RecCode!, "PayforBreak":PayforBreak!, "Id":Id!, "longitude":longitude!, "latitude": latitude!, "Address":Address ?? "Not Found", "IPAddress":IPAddress, "Retry": 1 ]
                            
                            print("the Parameters for the API call from retry mechanicsm is", params)
                            
                            let isInternetAvailable = self.isInternetAvailable()
                            
                            if isInternetAvailable {
                                
                                RestAPI.getECheckInTime(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getSubmitResponse(response:))
                            }
                            else{
                                
                                JustHUD.shared.hide()
                                
                                self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                                
                            }
                    
                        } else {
                            JustHUD.shared.hide()
                            print("in Parameters some is nill")
                        }
                        

                    
                }
            
                //end
                
            }

            else if object[0]["StatusCode"].intValue == 0 {
                JustHUD.shared.hide()
                
                let title = object[0]["message"].stringValue
                let titleColor = #colorLiteral(red: 0.8576444983, green: 0.3266127706, blue: 0.3078376949, alpha: 1)
                let titleBg = #colorLiteral(red: 0.9495584369, green: 0.8718144298, blue: 0.8732326627, alpha: 1)
                let buttonBg = #colorLiteral(red: 0.8576444983, green: 0.3266127706, blue: 0.3078376949, alpha: 1)
                let buttonTitleColor = UIColor.white
                
//                self.showCustomAlertWithOkButton(title: title, titleColor: titleColor, titleBackgroundColor: titleBg, buttonBackgroundColor: buttonBg, buttonTitleColor: buttonTitleColor, targetViewControllerIdentifier: nil) { [weak self] in
//                    guard let self = self else { return }
//                    self.getCheckInDataCall(clientId: self.clientID!, contactId: self.contactID!, weekEnd: self.WeekEndDate!)
//                }
                
                self.showCustomAlertWithRetryAndCancelButtons(title: title, titleColor: titleColor, titleBackgroundColor: titleBg, primaryButtonBackgroundColor: buttonBg, primaryButtonTitleColor: buttonTitleColor, secondaryButtonBackgroundColor: buttonBg, secondaryButtonTitleColor: buttonTitleColor, completion: {
                    [weak self] in
                    guard let self = self else { return }
                    self.getCheckInDataCall(clientId: self.clientID!, contactId: self.contactID!, weekEnd: self.WeekEndDate!)
                    print("Cancel button tapped") // Replace with your actual cancel action
                },
                    secondaryCompletion: {
                    print("Retry button tapped") // Call another function here for retry
                    //start
                    JustHUD.shared.showInView(view: (self.view)!)
                    let isInternetAvailable = self.isInternetAvailable()
                    
                    if isInternetAvailable {
                        
                        let delayInSeconds = object[0]["Sleep"].intValue
                        let delayInNanoSeconds = UInt64(delayInSeconds * 1_000_000_000)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + .nanoseconds(Int(delayInNanoSeconds))) { [self] in
                            
                            CMALocationManager.shared.requestLocationAtOnce()
                            
                            if let recentLocation = CMALocationManager.shared.currentLocation?.coordinate, CMALocationManager.shared.currentLocation?.horizontalAccuracy ?? -1 >= 0 {
                                latToSend = recentLocation.latitude
                                lognToSend = recentLocation.longitude
                            }
                            
                            reverseGeoCode1(lat: latToSend, long: lognToSend) { address in
                                if let address = address {
                                    // Use the address here
                                    print("Address from retry chk in is:", address)
                                    self.Address = address
                                } else {
                                    print("Failed to retrieve address")
                                }
                            }
                            
                            longitude = lognToSend
                            latitude = latToSend
                            
                            if (CandId != nil && OrderId != nil && WeekEnd != nil && BillDate != nil && StartTime != nil && EndTime != nil && CheckIn != nil && CheckOut != nil && ClientId != nil && ContactId != nil && ChkInType != nil && RouteName != nil && timeOut != nil && timeIn != nil && breakMinutes != nil && totlaHours != nil && RecCode != nil && PayforBreak != nil && Id != nil && latitude != nil && longitude != nil) {
                                
                                let params: [String: Any] = ["CandId":CandId!, "OrderId":OrderId!, "WeekEnd":WeekEnd!, "BillDate":BillDate!, "StartTime":StartTime!, "EndTime": EndTime!, "CheckIn":CheckIn!, "CheckOut":CheckOut!, "Type":ChkInType!, "RouteName":RouteName!, "ClientId":ClientId!, "ContactId":ContactId!, "timeOut":timeOut!, "timeIn":timeIn!, "breakMinutes":breakMinutes!, "totlaHours":totlaHours!, "RecCode":RecCode!, "PayforBreak":PayforBreak!, "Id":Id!, "longitude":longitude!, "latitude": latitude!, "Address":Address ?? "Not Found", "IPAddress":IPAddress, "Retry": 0 ]
                                
                                print("the Parameters for the API call from retry mechanicsm is", params)
                                    
                                    JustHUD.shared.showInView(view: (self.view)!)
                                    
                                    RestAPI.getECheckInTime(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getSubmitResponse(response:))
                                
                            } else {
                                JustHUD.shared.hide()
                                print("in Parameters some is nill")
                            }
                            
                            
                        }
                        
                        //end
                    }
                    else{
                        
                        JustHUD.shared.hide()
                        
                        self.showCustomAlert(Title: self.InternetConnectionTitle, attMessage: NSAttributedString(), message: self.InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: self.Danger_Text, isAttributed: false)
                        
                    }})

            }
            
            else if object[0]["StatusCode"].intValue == 1 {
                JustHUD.shared.hide()
                
                let title = object[0]["message"].stringValue
                let titleColor = #colorLiteral(red: 0.2352941176, green: 0.462745098, blue: 0.2392156863, alpha: 1)
                let titleBg = #colorLiteral(red: 0.8745098039, green: 0.9411764706, blue: 0.8470588235, alpha: 1)
                let buttonBg = #colorLiteral(red: 0.2352941176, green: 0.462745098, blue: 0.2392156863, alpha: 1)
                let buttonTitleColor = UIColor.white
                
                self.showCustomAlertWithOkButton(title: title, titleColor: titleColor, titleBackgroundColor: titleBg, buttonBackgroundColor: buttonBg, buttonTitleColor: buttonTitleColor, targetViewControllerIdentifier: nil) { [weak self] in
                    guard let self = self else { return }
                    self.getCheckInDataCall(clientId: self.clientID!, contactId: self.contactID!, weekEnd: self.WeekEndDate!)
                }
                
//                getCheckInDataCall(clientId: clientID!, contactId: contactID!, weekEnd: WeekEndDate!)
            }
            else {
                JustHUD.shared.hide()
                getCheckInDataCall(clientId: clientID!, contactId: contactID!, weekEnd: WeekEndDate!)
            }
            
        }
        
    }
    
    
}
