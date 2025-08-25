//
//  E_AllSubmitVC.swift
//  CWA
//
//  Created by NFC User on 28/09/23.
//  Copyright © 2023 NFC Solutionsusa. All rights reserved.
//

import UIKit
import FSCalendar
import DropDown
import SwiftyJSON

class E_AllSubmitVC: BaseViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, UITextFieldDelegate, DateTimePickerDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var selectDateTF: UITextField!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var goButton: UIButton!
 
    @IBOutlet weak var noItemView: UIView!
    @IBOutlet weak var overallSubmitButton: UIButton!
    
    var customCalendarView = CalendarView()
    var resultDate = String()
    let today = Date()
    var todayString: String?

    let defaultTime = "1900-01-01 00:00:00"
    var activeTextField: UITextField?
    
    let itemList = NSMutableArray()
    var selectedItemList = NSMutableDictionary()
    var notValidItemList = NSMutableDictionary()
    var totalSelected = NSMutableArray()
    var notValidArrayList = NSMutableArray()
    
    let defaults = UserDefaults.standard
    var clientID: String?
    var contactID: String?
    var WeekEndDate: String?
    
    let chooseArticleDropDown = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.chooseArticleDropDown
        ]
    }()
    
    //Params for All
    
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
    var ClientId: Int?
    var ContactId: Int?
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
    var ReasonId: Int?
    var IsSubmitted: Int?
    
    var ratingNumber: Int?
    var ratingReason: String?
    
    var otherReasonVariable: String?
    
    //End
    
    var latToSend = Double()
    var lognToSend = Double()
    
    var IPAddress = String()
    
    var regularHours: Int?
    
    var selectedCells = [IndexPath]()
    
    var activeCellIndex: IndexPath?
    var totalH = String()
    var reasonIndex = String()
    var reason = String()
    var chkOutValue = String()
    var chkInValue = String()
    var isIrregular = String()
    var reasonEnter = String()
    var validReason: Int?
    var cellInfoColor: Int?
    
    var statusValue: Int?
    var transactionValue: Int?
    var edgeColor: UIColor?
    var userType: Int?
    
    var client = String()
    
    var OtherReason = String()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        clientID = defaults.string(forKey: "ClientID")!
        contactID = defaults.string(forKey: "ContactId")!
        
        ClientId = Int(clientID!)
        ContactId = Int(contactID!)
        
                if let selectedDate = DateManager.shared.selectedDate {
                    selectDateTF.text = self.dateFormatter.string(from: selectedDate)
                    WeekEndDate = self.dateFormatter.string(from: selectedDate)
                    
                    getAllDataCall(clientId: clientID!, contactId: contactID!, weekEnd: WeekEndDate!)
                } else {
                    
                    //To load default date
                    
                    let todayDate = self.dateFormatter.string(from: today)
                    print("viv today's date is ", todayDate)
                    selectDateTF.text = todayDate
                    WeekEndDate = todayDate
                    getAllDataCall(clientId: clientID!, contactId: contactID!, weekEnd: todayDate)
                    
                    //end
                    
                }
     
        noItemView.layer.cornerRadius = 10
        titlelbl.text = "E-Check In"
        
        //IP
        
        if let ipAddress = getIPv4Address() {
            print("IP Address: \(ipAddress)")
            IPAddress = ipAddress
        } else {
            print("Unable to retrieve IP address")
        }
        
        //End
        
        //Lat Long
        
        checkLocationAccess { hasAccess in
            if hasAccess {
                DispatchQueue.main.async {
                CMALocationManager.shared.requestLocationAtOnce()
                if let recentLocation = CMALocationManager.shared.currentLocation?.coordinate, CMALocationManager.shared.currentLocation?.horizontalAccuracy ?? -1 >= 0 {
                    self.latToSend = recentLocation.latitude
                    self.lognToSend = recentLocation.longitude
                }
                else {
                    //                    JustHUD.shared.showInView(view: (self.view)!)
                    let delayInSeconds = 5
                    let delayInNanoSeconds = UInt64(delayInSeconds * 1_000_000_000)
                    DispatchQueue.main.asyncAfter(deadline: .now() + .nanoseconds(Int(delayInNanoSeconds))) { [self] in
                        CMALocationManager.shared.requestLocationAtOnce()
                        if let recentLocation = CMALocationManager.shared.currentLocation?.coordinate {
                            latToSend = recentLocation.latitude
                            lognToSend = recentLocation.longitude
                        }
                        //                        JustHUD.shared.hide()
                    }
                }
                print("the latitude from view will appear is",self.latToSend)
                print("the longitude from view will appear is", self.lognToSend)
                
                self.longitude = self.lognToSend
                self.latitude = self.latToSend
                
                self.reverseGeoCode1(lat: self.latToSend, long: self.lognToSend) { address in
                    if let address = address {
                        // Use the address here
                        print("Address from chk in is:", address)
                        self.Address = address
                    } else {
                        print("Failed to retrieve address")
                    }
                }
                
            }
            } else {
                self.askPermission()
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        //End
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupCalendarView()
  
     //   let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
       //         view.addGestureRecognizer(tapGesture)

        selectDateTF.delegate = self
        
        mainTableView.allowsMultipleSelection = true
        
        overallSubmitButton.isEnabled = false
        
        clientID = defaults.string(forKey: "ClientID")!
        contactID = defaults.string(forKey: "ContactId")!
        
        ClientId = Int(clientID!)
        ContactId = Int(contactID!)
        
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
        getAllDataCall(clientId: clientID!, contactId: contactID!, weekEnd: WeekEndDate!)
    }
    
    
    
    //MARK: - Info Button
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        
        if let popoverViewController = self.storyboard?.instantiateViewController(withIdentifier: "colorLegendSegue") {
            popoverViewController.modalPresentationStyle = .popover
            
            if let popoverPresentationController = popoverViewController.popoverPresentationController {
                popoverPresentationController.sourceView = sender as? UIView
                popoverPresentationController.sourceRect = (sender as AnyObject).bounds
                popoverPresentationController.permittedArrowDirections = .up
                
                self.present(popoverViewController, animated: true, completion: nil)
            }
        }
        
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
    
    //MARK: - Go Action Button
    
    @IBAction func goActionClicked(_ sender: Any) {
        
        print("the textfield value taken as", selectDateTF.text!)

        WeekEndDate = selectDateTF.text!
        
        ClientId = Int(clientID!)
        ContactId = Int(contactID!)
        
        getAllDataCall(clientId: clientID!, contactId: contactID!, weekEnd: WeekEndDate!)
        
    }
    
    //MARK: - Go API Call
    
    func getAllDataCall(clientId: String, contactId: String, weekEnd: String) {
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable{
            
            JustHUD.shared.showInView(view: (self.view)!)
            
            let params :[String:String] = ["ClientId":clientId,
                "ContactId":contactId,
                "WeekEnd":weekEnd]
            
            print("the Go Button Params are", params)
            
            RestAPI.getListOfAllDatas(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
        }
        else{
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    
    //MARK: - Go Response
    
    func getResponse(response:AnyObject)->() {
        
        JustHUD.shared.hide()
        
        if response is String{
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        else{
            
            itemList.removeAllObjects()
            totalSelected.removeAllObjects()
            selectedItemList.removeAllObjects()
            selectedCells.removeAll()
            notValidArrayList.removeAllObjects()
            
            self.mainTableView.reloadData()
            
            let object = response as! JSON
            print("the Go Button Response is", object)
            
            if object[0]["message"].stringValue.count > 0 {
                print("the message response is ",object[0]["message"].stringValue)
                noItemView.isHidden = false
            }
            else {
                
                let dataArray = object.array
                
                if dataArray != nil {
                    
                    for dict in dataArray!{
                        
                        let item = AllItems.init(Name: dict["CandidateName"].stringValue, Position: dict["Position"].stringValue, StartTime: dict["StartTime"].stringValue, EndTime: dict["EndTime"].stringValue, OrderId: dict["OrderId"].intValue, WeekEnd: dict["WeekEnd"].stringValue, ISAdminUser: dict["ISAdminUser"].intValue, CheckOut: dict["CheckOut"].stringValue, BillDate: dict["BillDate"].stringValue, PayforBreak: dict["PayforBreak"].boolValue, RecCode: dict["RecCode"].stringValue, CandId: dict["CandId"].intValue, CheckIn: dict["CheckIn"].stringValue, breakMinutes: dict["BreakMinutes"].intValue, Id: dict["Id"].intValue, Status: dict["Status"].intValue, TxnType: dict["TxnType"].intValue,IsSubmitted: dict["IsSubmitted"].intValue, ReasonId: dict["ReasonId"].intValue, Rating: dict["Rating"].intValue, RatingComments: dict["RatingComments"].stringValue, PositionLabelColor: dict["PositionLabelColor"].stringValue, OtherReason: dict["OtherReason"].stringValue)
                        
                        var dict1 = NSMutableDictionary()
                        
                        totalH = "0"
                        reasonIndex = "10"
                        reason = "Select Reason for Irregular Hours"
                        isIrregular = "0"
                        
                        chkOutValue = "\(item.CheckOut!)"
                        let outTime = scheduledTime(dateTime: chkOutValue)
                        let outTimeFormat = convertTo12HourFormat(outTime)!
                        chkOutValue = outTimeFormat
                        
                        chkInValue = "\(item.CheckIn!)"
                        let inTime = scheduledTime(dateTime: chkInValue)
                        let inTimeFormat = convertTo12HourFormat(inTime)!
                        chkInValue = inTimeFormat
                        
                        dict1 = ["Name":"\(item.Name!)", "Position":"\(item.Position!)", "StartTime":"\(item.StartTime!)", "EndTime":"\(item.EndTime!)", "OrderId":"\(item.OrderId!)",
                                 "WeekEnd":"\(item.WeekEnd!)", "ISAdminUser":"\(item.ISAdminUser!)", "CheckOut":chkOutValue, "BillDate":"\(item.BillDate!)", "PayforBreak":"\(item.PayforBreak!)", "RecCode":"\(item.RecCode!)", "CandId":"\(item.CandId!)", "CheckIn":chkInValue, "BreakMinutes":"\(item.breakMinutes!)", "Id":"\(item.Id!)", "TotalHours": totalH, "ReasonIndex":reasonIndex, "Reason":reason, "Status":"\(item.Status!)", "TxnType":"\(item.TxnType!)", "IsIrregular":isIrregular, "IsSubmitted": "\(item.IsSubmitted!)", "ReasonId":"\(item.ReasonId!)", "Rating":"\(item.Rating!)", "RatingComments":"\(item.RatingComments!)", "PositionLabelColor":"\(item.PositionLabelColor!)", "OtherReason":"\(item.OtherReason!)"]
                        
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
    
    //MARK: - Textfield Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("viv enters did begin editing")
        
        textField.resignFirstResponder()
        
        if textField == selectDateTF {
            showCalendar()
        }
        else {
            
            if textField.tag % 11 == 0 {
                
                activeTextField = textField
                
                if let indexPath = getIndexPath(for: textField) {
                        activeCellIndex = indexPath
                    }

                self.showPicker(ampm:false,selectedDate: Date())
                
            }
            else if textField.tag % 13 == 0 {
                
                activeTextField = textField
                
                if let indexPath = getIndexPath(for: textField) {
                        activeCellIndex = indexPath
                    }

                self.showPicker(ampm:false,selectedDate: Date())
                
            }
            else if textField.tag % 17 == 0 {
                print("drop down reason menu clicked")
                
                var itemsDrop:[String] = []
                
                itemsDrop = ["Select Reason for Irregular Hours","Left Early", "Arrive Late", "Replacement","Ask to work additional time", "Sent Home", "Other"]
                
                activeTextField = textField
                
                if let indexPath = getIndexPath(for: textField) {
                        activeCellIndex = indexPath
                    }
                
                setupChooseArticleDropDown(anchorView: textField, items: itemsDrop)
                self.chooseArticleDropDown.show()
            }
            
        }
        
    }

    
    @objc func dismissKeyboard() {
           view.endEditing(true)
       }
    
    //MARK: - Get IndexPath of selected Item
    
    func getIndexPath(for textField: UITextField) -> IndexPath? {
        let point = textField.convert(CGPoint.zero, to: self.mainTableView)
        return self.mainTableView.indexPathForRow(at: point)
    }
    
    private func findIndexPathForView(_ view: UIView, in tableView: UITableView) -> IndexPath? {
            let point = view.convert(CGPoint.zero, to: tableView)
            return tableView.indexPathForRow(at: point)
        }
    
    //MARK: - Drop Down Menu
    
    func setupChooseArticleDropDown(anchorView:UITextField,items:[String]) {
        
        chooseArticleDropDown.anchorView = anchorView
        chooseArticleDropDown.bottomOffset = CGPoint(x: 0, y: anchorView.bounds.height)
        chooseArticleDropDown.backgroundColor = .white
        chooseArticleDropDown.dataSource =  items
        
        chooseArticleDropDown.selectionAction = { [unowned self] (index,item) in
            
            print("the selected item from the drop down is", item)
            
            if let activeCellIndex = self.activeCellIndex{
                
                let dataDict:NSMutableDictionary = self.itemList[activeCellIndex.row] as! NSMutableDictionary
                
                if self.activeTextField!.tag % 17 == 0 {
                    
                    self.ReasonId = items.index(of: item)!
                    dataDict["ReasonId"] = String(self.ReasonId!)
                    dataDict["ReasonIndex"] = String(self.ReasonId!)
                    dataDict["Reason"] = item
                   // dataDict["isIrregular"] = "1"
                    
                    if item.lowercased() == "other" {
                                    // Show a popup for "Others"
                                    self.showPopupForOthers { additionalInfo in
                                        print("Other Reason Entered is : \(additionalInfo)")
                                        dataDict["OtherReason"] = additionalInfo
                                        
                                        self.saveReasonCommonAPICall(with: activeCellIndex.row)
                                    }
                                }
                    
                    print("The selected textfield index is",self.ReasonId!)
                    self.mainTableView.reloadData()
                }
                
            }
   
        }
        
    }
    
    //MARK: - Show Pop Up for others
    
    func showPopupForOthers(completion: @escaping (String) -> Void) {
        
        let alertController = UIAlertController(title: "Other", message: "Enter Other Reason", preferredStyle: .alert)
            
            alertController.addTextField { (textField) in
                textField.placeholder = "Other Reason"
            }
        
        let okAction = UIAlertAction(title: "Save", style: .default) { (action) in
                // Handle OK button click, you can retrieve the entered information using alertController.textFields
                if let textField = alertController.textFields?.first {
                    let additionalInfo = textField.text ?? ""
                    completion(additionalInfo)
                }
            }
            
            alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
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
            
            if let activeCellIndex = self.activeCellIndex {
                
                let dataDict:NSMutableDictionary = self.itemList[activeCellIndex.row] as! NSMutableDictionary
                
                if self.activeTextField!.tag % 13 == 0{
                    dataDict["CheckOut"] = formatter.string(from: date)
                    self.mainTableView.reloadData()
                } else if self.activeTextField!.tag % 11 == 0{
                    dataDict["CheckIn"] = formatter.string(from: date)
                    self.mainTableView.reloadData()
                }
                
            }
            
        }
        
        picker.delegate = self
        NotificationCenter.default.post(name: Notification.Name("Time"), object: nil)
    }
    
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        print(picker.selectedDateString)
    }
    
    //MARK: - Overall Submit Button
    
    @IBAction func overallSubmitClicked(_ sender: Any) {
        print("overall submit pressed")
        
        for item in totalSelected {
            
            if let dict = item as? [String: Any], let type = dict["ReasonId"] as? Int, let hour = dict["totlaHours"] as? Int {
                  if type == 0 && (hour < 330 || hour > 810) {
                      print("Type is equal to 0 and irregular")
                      
                      let name = dict["Name"]
                      
                      notValidItemList = ["Name":name!]
                      
                      if notValidArrayList.contains(notValidItemList){}
                      else {
                          notValidArrayList.add(notValidItemList)
                          print("the notValidArrayList count is", notValidArrayList.count)
                      }
                      
                  } else {
                      print("Type is not equal to 0")
                  }
              } else {
                  print("Type key not found in dictionary or this is a regular item")
              }
            
        }
        
        if notValidArrayList.count == 0 {
            
            checkLocationAccess { hasAccess in
                
                if hasAccess{
                    DispatchQueue.main.async {
                    let isInternetAvailable = self.isInternetAvailable()
                    
                    if isInternetAvailable {
                        
                        JustHUD.shared.showInView(view: (self.view)!)
                        
                        RestAPI.submitAllApi(self, params: self.totalSelected as! [[String : Any]], method: "POST", accessToken: "", acces: true, callBack: self.overallSubmitResponse(response:))
                        
                    }
                    else{
                        
                        self.showCustomAlert(Title: self.InternetConnectionTitle, attMessage: NSAttributedString(), message: self.InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: self.Danger_Text, isAttributed: false)
                        
                    }
                }
                }
                else {
                    // Location Permission not available
                    self.askPermission()
                }
            }
            
        }else {
            print("The not valid array list items are", notValidArrayList)
            
            let names = notValidArrayList.compactMap { ($0 as? [String: String])?["Name"] }
            let combinedString = names.joined(separator: ",\n")
            
            self.showCustomAlert(Title: "Enter Irregular Hours Reason for", attMessage: NSAttributedString(), message: combinedString, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
            totalSelected.removeAllObjects()
            selectedItemList.removeAllObjects()
            selectedCells.removeAll()
            notValidArrayList.removeAllObjects()
            mainTableView.reloadData()
            updateButtonState()
            
        }
        
       
  
    }
    
    //MARK: - Overall SUbmit API Response
    
    func overallSubmitResponse(response:AnyObject)->() {
        
        JustHUD.shared.hide()
        
        if response is String{
            
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
            
            if object[0]["StatusCode"].intValue == 0 {
                
                let title = object[0]["message"].stringValue
                let titleColor = #colorLiteral(red: 0.8576444983, green: 0.3266127706, blue: 0.3078376949, alpha: 1)
                let titleBg = #colorLiteral(red: 0.9495584369, green: 0.8718144298, blue: 0.8732326627, alpha: 1)
                let buttonBg = #colorLiteral(red: 0.8576444983, green: 0.3266127706, blue: 0.3078376949, alpha: 1)
                let buttonTitleColor = UIColor.white
                
                self.showCustomAlertWithOkButton(title: title, titleColor: titleColor, titleBackgroundColor: titleBg, buttonBackgroundColor: buttonBg, buttonTitleColor: buttonTitleColor, targetViewControllerIdentifier: nil) { [weak self] in
                    guard let self = self else { return }
                    self.getAllDataCall(clientId: self.clientID!, contactId: self.contactID!, weekEnd: self.WeekEndDate!)
                }

            }
            
            else if object[0]["StatusCode"].intValue == 1 {
                
                let title = object[0]["message"].stringValue
                let titleColor = #colorLiteral(red: 0.2352941176, green: 0.462745098, blue: 0.2392156863, alpha: 1)
                let titleBg = #colorLiteral(red: 0.8745098039, green: 0.9411764706, blue: 0.8470588235, alpha: 1)
                let buttonBg = #colorLiteral(red: 0.2352941176, green: 0.462745098, blue: 0.2392156863, alpha: 1)
                let buttonTitleColor = UIColor.white
                
                self.showCustomAlertWithOkButton(title: title, titleColor: titleColor, titleBackgroundColor: titleBg, buttonBackgroundColor: buttonBg, buttonTitleColor: buttonTitleColor, targetViewControllerIdentifier: nil) { [weak self] in
                    guard let self = self else { return }
                    self.getAllDataCall(clientId: self.clientID!, contactId: self.contactID!, weekEnd: self.WeekEndDate!)
                }
            }
            
            else {
                getAllDataCall(clientId: clientID!, contactId: contactID!, weekEnd: WeekEndDate!)
            }
            
        }
        
    }
    

}

extension E_AllSubmitVC: UITableViewDataSource, UITableViewDelegate, CellDelegate{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"CAllHCell", for: indexPath) as! CAllHeadingCell
        cell.selectionStyle = .none
  
       // cell.selectImageIcon.image = UIImage(named: "check_box")
        
        cell.checkInTF.tag = (indexPath.row + 1) * 11
        cell.checkOutTF.tag = (indexPath.row + 1) * 13
        cell.ReasonTF.tag = (indexPath.row + 1) * 17
        
        cell.checkInTF.delegate = self
        cell.checkOutTF.delegate = self
        cell.ReasonTF.delegate = self
        
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
            
            StartTime = dataDict["StartTime"] as? String
            let start = scheduledTime(dateTime: StartTime!)
            let startTime = convertTo12HourFormat(start)!
            
            EndTime = dataDict["EndTime"] as? String
            let end = scheduledTime(dateTime: EndTime!)
            let endTime = convertTo12HourFormat(end)!
            
            let scheduleTime = "\(startTime) - \(endTime)"
            
            cell.Time.text = scheduleTime
            
            //end
            
            //for Check in
            let inTimeFormat = dataDict["CheckIn"] as? String
            cell.checkInTF.text = inTimeFormat
            
            //for Check out time
            let outTimeFormat = dataDict["CheckOut"] as? String

            if dataDict["CheckOut"] as! String == "12:00 AM" {
                cell.checkOutTF.isHidden = true
                cell.checkOutImg.isHidden = true
                
                print("for the client name ", clientName!, "we are hiding checkout and the value for checkout is",outTimeFormat!)
                
                cell.TotalHours.text = "0 H"
                
                regularHours = 500 //set from viv end to hide irregular hours
            } else {
                cell.checkOutTF.isHidden = false
                cell.checkOutImg.isHidden = false
                cell.checkOutTF.text = outTimeFormat
                
                //for Total Hours
                let endCheckOutTime = convert12HourTo24Hour(timeString: outTimeFormat!)
                
                let startCheckInTime = convert12HourTo24Hour(timeString: inTimeFormat!)
                
                let tHours = addTimes(start: endCheckOutTime!, end: startCheckInTime!, min: true)
                
                regularHours = tHours
                dataDict["TotalHours"] = String(tHours)
                print("the dataDict[TotalHours] is ", tHours)
                
                let (hours, minutes) = convertMinutesToHoursAndMinutes(minutes: tHours)
                
                cell.TotalHours.text = "\(hours) H : \(minutes) M"
            }
            
            //end

            
            //for Break Min
            cell.BMinutesLabel.text = dataDict["BreakMinutes"] as? String
   
            //for Irregular reason
            
            let indexValue = Int(dataDict["ReasonId"] as? String ?? "0")!
            
            if indexValue > 0 {
                
                            if indexValue == 1 {
                                cell.ReasonTF.text = "Left Early"
                            } else if indexValue == 2 {
                                cell.ReasonTF.text = "Arrive Late"
                            } else if indexValue == 3 {
                                cell.ReasonTF.text = "Replacement"
                            } else if indexValue == 4 {
                                cell.ReasonTF.text = "Ask to work additional time"
                            } else if indexValue == 5 {
                                cell.ReasonTF.text = "Sent Home"
                            } else if indexValue == 6 {
                                cell.ReasonTF.text = "Others"
                            }
                
            } else {
                cell.ReasonTF.text = dataDict["Reason"] as? String
            }
            
            if indexValue == 6 {
                cell.othersInfo.isHidden = false
            } else {
                cell.othersInfo.isHidden = true
            }
            
            //end
  
            //for cell color
            statusValue = Int(dataDict["Status"] as? String ?? "0")
            transactionValue = Int(dataDict["TxnType"] as? String ?? "0")
            
            //for delete button to show
            Id = Int(dataDict["Id"] as? String ?? "0")
            userType = Int(dataDict["ISAdminUser"] as? String ?? "0")
            
            //for Irregular reason
            reasonEnter = (dataDict["IsIrregular"] as? String)!
            validReason = Int(dataDict["ReasonIndex"] as? String ?? "10")
            
            //for cell info color
            cellInfoColor = Int(dataDict["IsSubmitted"] as? String ?? "0")
            
            //for Star Rating
            
            let rating = Int(dataDict["Rating"] as? String ?? "0")!
            cell.ratingStackView.setStarsRating(rating: rating)

            cell.ratingStackView.delegate = self
            cell.ratingStackView.row = indexPath.row
            
            if rating < 3 && rating > 0 {
                cell.ratingCommentsInfo.isHidden = false
            } else {
                cell.ratingCommentsInfo.isHidden = true
            }
            
        }
        
        if self.regularHours != nil {
            if self.regularHours! < 330 || self.regularHours! > 810 {
                cell.reasonView.isHidden = false
            }
            else{
                cell.reasonView.isHidden = true
            }
        }
        
        
//        if (cell.reasonView.isHidden == true) || ((cell.reasonView.isHidden == false) && ( reasonEnter == "1")) {
//
//            cell.saveButton.isEnabled = true
//            cell.saveButton.titleLabel?.textColor = .white
//
//        } else {
//            cell.saveButton.isEnabled = false
//        }
        
        //for supervisor
        
        if userType == 0 && cellInfoColor == 1 {
            
            //rating not enabled
            cell.ratingStackView.isUserInteractionEnabled = false
            
            cell.saveButton.isEnabled = false
            cell.trashButton.isEnabled = false
            cell.ReasonTF.isEnabled = false
            cell.ReasonTF.textColor = UIColor.gray
            cell.addButton.isHidden = true
            cell.checkInTF.isEnabled = false
            cell.checkOutTF.isEnabled = false
            cell.saveReason.isEnabled = false
            cell.cellInfoColor.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            
        } else if userType == 0 && cellInfoColor == 0{
            
            cell.saveButton.isEnabled = false
            cell.trashButton.isEnabled = false
            cell.addButton.isHidden = true
            cell.ReasonTF.isEnabled = true
            cell.checkInTF.isEnabled = false
            cell.checkOutTF.isEnabled = false
            
            //rating enabled
            cell.ratingStackView.isUserInteractionEnabled = true
            
            if validReason! < 6 && validReason! > 0 {
                cell.saveReason.isEnabled = true
            } else {
                cell.saveReason.isEnabled = false
            }
            
            cell.cellInfoColor.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
            
        }
        
        //For Admin
        
       else if statusValue == 1 && userType == 1{
           
           //rating not enable
           cell.ratingStackView.isUserInteractionEnabled = false
           
           cell.saveButton.isEnabled = false
           cell.trashButton.isEnabled = false
           cell.ReasonTF.isEnabled = false
           cell.ReasonTF.textColor = UIColor.gray
           cell.checkInTF.isEnabled = false
           cell.checkOutTF.isEnabled = false
           cell.saveReason.isEnabled = false
           cell.cellInfoColor.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
           cell.addButton.isHidden = false
        }
        
        else if statusValue == 0 && userType == 1 && cellInfoColor == 1{
            
            //rating enabled
            cell.ratingStackView.isUserInteractionEnabled = true
            
            cell.saveButton.isEnabled = true
            cell.trashButton.isEnabled = true
            cell.ReasonTF.isEnabled = true
            cell.checkInTF.isEnabled = true
            cell.checkOutTF.isEnabled = true
            cell.addButton.isHidden = true
            
            if validReason! < 6 && validReason! > 0 {
                cell.saveReason.isEnabled = true
            } else {
                cell.saveReason.isEnabled = false
            }
            
            cell.cellInfoColor.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        }
        
        else if statusValue == 0 && userType == 1 && cellInfoColor == 0{
            
            //rating enable
            cell.ratingStackView.isUserInteractionEnabled = true
            
            cell.saveButton.isEnabled = true
            cell.trashButton.isEnabled = true
            cell.ReasonTF.isEnabled = true
            cell.checkInTF.isEnabled = true
            cell.checkOutTF.isEnabled = true
            cell.addButton.isHidden = true
            
            if validReason! < 6 && validReason! > 0 {
                cell.saveReason.isEnabled = true
            } else {
                cell.saveReason.isEnabled = false
            }
            
            cell.cellInfoColor.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        }
 
        cell.addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        
        cell.saveButton.addTarget(self, action: #selector(submitButtonTapped(_:)), for: .touchUpInside)
        
        
        cell.saveReason.addTarget(self, action: #selector(saveReasonButtonTapped(_:)), for: .touchUpInside)
        
        cell.trashButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        
        cell.ratingCommentsInfo.addTarget(self, action: #selector(ratingCommentsInfoButtonTapped(_:)), for: .touchUpInside)
        
        cell.othersInfo.addTarget(self, action: #selector(othersInfoButtonTapped(_:)), for: .touchUpInside)
       
        
        if (statusValue == 0 && transactionValue == 0) {
            edgeColor = #colorLiteral(red: 1, green: 0.9529411765, blue: 0.8039215686, alpha: 1)
        } else if (statusValue == 0 && transactionValue == 3) {
            edgeColor = #colorLiteral(red: 0.9882352941, green: 0.8784313725, blue: 0.7803921569, alpha: 1)
        } else if statusValue == 1 {
            edgeColor = #colorLiteral(red: 0.8196078431, green: 0.9058823529, blue: 0.8666666667, alpha: 1)
        } else if statusValue == 2 {
            edgeColor = #colorLiteral(red: 0.9725490196, green: 0.8431372549, blue: 0.8549019608, alpha: 1)
        }

        let edgeWidth: CGFloat = 3.0
        let edgeHeight: CGFloat = 285.0
            
            let leftBorder = CALayer()
            leftBorder.frame = CGRect(x: 0, y: 0, width: edgeWidth, height: edgeHeight)
            leftBorder.backgroundColor = edgeColor?.cgColor
           
            leftBorder.cornerRadius = 8.0
            leftBorder.masksToBounds = true
           
        cell.outerView.layer.addSublayer(leftBorder)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 310 //265 previous
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dataDict:NSMutableDictionary = itemList[indexPath.row] as! NSMutableDictionary
        
        userType = Int(dataDict["ISAdminUser"] as? String ?? "0")
        
        cellInfoColor = Int(dataDict["IsSubmitted"] as? String ?? "0")
        
        if dataDict.allKeys.count == 0{}else {
            
            CandId = Int(dataDict["CandId"] as? String ?? "0")
            OrderId = Int(dataDict["OrderId"] as? String ?? "0")
            WeekEnd = dataDict["WeekEnd"] as? String
            BillDate = dataDict["BillDate"] as? String
            RecCode = dataDict["RecCode"] as? String
            CheckIn = dataDict["CheckIn"] as? String
            CheckOut = dataDict["CheckOut"] as? String
            EndTime = dataDict["EndTime"] as? String
            StartTime = dataDict["StartTime"] as? String
            breakMinutes = Int(dataDict["BreakMinutes"] as? String ?? "0")
            totlaHours = Int(dataDict["TotalHours"] as? String ?? "0")
            ReasonId = Int(dataDict["ReasonId"] as? String ?? "20")
            
            client = (dataDict["Name"] as? String)!
            
            isIrregular = dataDict["IsIrregular"] as? String ?? "0"
            
            ChkInType = 0
            RouteName = "iOS"
            timeOut = defaultTime
            timeIn = defaultTime
            PayforBreak = 0
            Id = Int(dataDict["Id"] as? String ?? "0")

            
        }
        
        if userType == 0 && cellInfoColor == 1 {
            
        }
        else if statusValue == 1 && userType == 1 {
            
        }
        else if userType == 0 && cellInfoColor == 0 || statusValue == 0 && userType == 1{
            
            selectedItemList = ["CandId":CandId!, "OrderId":OrderId!, "WeekEnd":WeekEnd!, "BillDate":BillDate!, "StartTime":StartTime!, "EndTime": EndTime!, "CheckIn":CheckIn!, "CheckOut":CheckOut!, "Type":ChkInType!, "RouteName":RouteName!, "ClientId":ClientId!, "ContactId":ContactId!, "timeOut":timeOut!, "timeIn":timeIn!, "breakMinutes":breakMinutes!, "totlaHours":totlaHours!, "RecCode":RecCode!, "PayforBreak":PayforBreak!, "Id":Id!, "longitude":longitude!, "latitude": latitude!, "Address":Address!, "Name":client, "ReasonId":ReasonId!, "IPAddress":IPAddress]
            
            if totalSelected.contains(selectedItemList){} else {
                totalSelected.add(selectedItemList)
            }
            

            selectedCells.append(indexPath)
            print("the selected cells are",selectedCells)
           print("the selected items are", totalSelected)
            updateButtonState()
            
        }

     }
     
     func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
 
         if let index = selectedCells.firstIndex(of: indexPath) {

             selectedCells.remove(at: index)
             print("the index value is ",index)
             totalSelected.removeObject(at: index) //viv added newly jan5
             selectedItemList.removeObject(forKey: index)
             notValidItemList.removeObject(forKey: index)
             print("the cells after removed are",selectedCells)
             print("the selected items after removal are", selectedItemList)
         }
         updateButtonState()
     }
    
    
    //MARK: - Add Button Tapped
    
    @objc func addButtonTapped(_ sender: UIButton) {
        
        print("add button pressed")
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.mainTableView)
        let indexPath = self.mainTableView.indexPathForRow(at: buttonPosition)
        
        let dataDict:NSMutableDictionary = itemList[indexPath!.row] as! NSMutableDictionary
        
        if dataDict.allKeys.count == 0{}else {
            
            CandId = Int(dataDict["CandId"] as? String ?? "0")
            OrderId = Int(dataDict["OrderId"] as? String ?? "0")
            WeekEnd = dataDict["WeekEnd"] as? String
            BillDate = dataDict["BillDate"] as? String
            RecCode = dataDict["RecCode"] as? String
           // CheckIn = dataDict["CheckIn"] as? String
            //CheckOut = dataDict["CheckOut"] as? String
            breakMinutes = Int(dataDict["BreakMinutes"] as? String ?? "0")
            totlaHours = Int(dataDict["TotalHours"] as? String ?? "0")
            StartTime = dataDict["StartTime"] as? String
            EndTime = dataDict["EndTime"] as? String
            
            ChkInType = 0
            RouteName = "iOS"
            timeOut = dataDict["CheckOut"] as? String
            timeIn = dataDict["CheckIn"] as? String
            PayforBreak = 0
            Id = Int(dataDict["Id"] as? String ?? "0")
            
        }
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AdditionalHoursSegue") as! E_AdditionalHoursVC
        
        nextViewController.modalPresentationStyle = .overCurrentContext
        nextViewController.modalTransitionStyle = .crossDissolve
        
        //params sending
        
        nextViewController.CandId = CandId
        nextViewController.OrderId = OrderId
        nextViewController.WeekEnd = WeekEnd
        nextViewController.BillDate = BillDate
        //nextViewController.CheckIn = CheckIn
        //nextViewController.CheckOut = CheckOut
        nextViewController.ChkInType = ChkInType
        nextViewController.RouteName = RouteName
        nextViewController.ClientId = ClientId
        nextViewController.ContactId = ContactId
        nextViewController.timeOut = timeOut
        nextViewController.timeIn = timeIn
        nextViewController.breakMinutes = breakMinutes
        nextViewController.totlaHours = totlaHours
        nextViewController.RecCode = RecCode
        nextViewController.PayforBreak = PayforBreak
        nextViewController.Id = Id
        nextViewController.longitude = longitude
        nextViewController.latitude = latitude
        nextViewController.Address = Address
        nextViewController.StartTime = StartTime
        nextViewController.EndTime = EndTime
        
        
        //end

        self.navigationController?.present(nextViewController, animated: true)
        //pushViewController

        
    }
    
    //MARK: - Delete Button Tapped
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        
        print("delete button pressed")
        print("the Id value is",Id!)
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.mainTableView)
        let indexPath = self.mainTableView.indexPathForRow(at: buttonPosition)
        
        let dataDict:NSMutableDictionary = itemList[indexPath!.row] as! NSMutableDictionary
        
        //IP
        
        if let ipAddress = getIPv4Address() {
            print("IP Address: \(ipAddress)")
            IPAddress = ipAddress
        } else {
            print("Unable to retrieve IP address")
        }
        
        //End
        
        if dataDict.allKeys.count == 0{}else {
            
            CandId = Int(dataDict["CandId"] as? String ?? "0")
            OrderId = Int(dataDict["OrderId"] as? String ?? "0")
            WeekEnd = dataDict["WeekEnd"] as? String
            BillDate = dataDict["BillDate"] as? String
            RecCode = dataDict["RecCode"] as? String
            CheckIn = dataDict["CheckIn"] as? String
            CheckOut = dataDict["CheckOut"] as? String
            EndTime = dataDict["EndTime"] as? String
            StartTime = dataDict["StartTime"] as? String
            breakMinutes = Int(dataDict["BreakMinutes"] as? String ?? "0")
            totlaHours = Int(dataDict["TotalHours"] as? String ?? "0")
            
            ChkInType = 0
            RouteName = "iOS"
            timeOut = defaultTime
            timeIn = defaultTime
            PayforBreak = 0
            Id = Int(dataDict["Id"] as? String ?? "0")
            
        }
        
        
        if (CandId != nil && OrderId != nil && WeekEnd != nil && BillDate != nil && StartTime != nil && EndTime != nil && CheckIn != nil && CheckOut != nil && ClientId != nil && ContactId != nil && ChkInType != nil && RouteName != nil && timeOut != nil && timeIn != nil && breakMinutes != nil && totlaHours != nil && RecCode != nil && PayforBreak != nil && Id != nil && latitude != nil && longitude != nil) {
            
            let params: [String: Any] = ["CandId":CandId!, "OrderId":OrderId!, "WeekEnd":WeekEnd!, "BillDate":BillDate!, "StartTime":StartTime!, "EndTime": EndTime!, "CheckIn":CheckIn!, "CheckOut":CheckOut!, "Type":ChkInType!, "RouteName":RouteName!, "ClientId":ClientId!, "ContactId":ContactId!, "timeOut":timeOut!, "timeIn":timeIn!, "breakMinutes":breakMinutes!, "totlaHours":totlaHours!, "RecCode":RecCode!, "PayforBreak":PayforBreak!, "Id":Id!, "longitude":longitude!, "latitude": latitude!, "Address":Address ?? "Not Found", "IPAddress":IPAddress]
                
                print("the Parameters for the API call is", params)
            
                
                let isInternetAvailable = self.isInternetAvailable()
                
                if isInternetAvailable {
                    
                    JustHUD.shared.showInView(view: (self.view)!)
                    
                    RestAPI.deleteApi(self, params: params, method: "POST", accessToken: "", acces: true, callBack: deleteResponse(response:))
                    
                }
                else{
                    
                    self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                    
                }
                
            }
            else {
                print("in Parameters some is nill")
            }
        
    }
    
    //MARK: - Delete API Response
    
    func deleteResponse(response:AnyObject)->() {
        
        JustHUD.shared.hide()
        
        if response is String{
            
            let title = response as! String
            let titleColor = #colorLiteral(red: 0.8576444983, green: 0.3266127706, blue: 0.3078376949, alpha: 1)
            let titleBg = #colorLiteral(red: 0.9495584369, green: 0.8718144298, blue: 0.8732326627, alpha: 1)
            let buttonBg = #colorLiteral(red: 0.8576444983, green: 0.3266127706, blue: 0.3078376949, alpha: 1)
            let buttonTitleColor = UIColor.white

            self.showCustomAlertWithOkButton(title: title, titleColor: titleColor, titleBackgroundColor: titleBg, buttonBackgroundColor: buttonBg, buttonTitleColor: buttonTitleColor)
            
        }
        else {
            
            let object = response as! JSON
            print("the API delete Response is", object)
            
            if object[0]["StatusCode"].intValue == 0 {
                
                let title = object[0]["message"].stringValue
                let titleColor = #colorLiteral(red: 0.8576444983, green: 0.3266127706, blue: 0.3078376949, alpha: 1)
                let titleBg = #colorLiteral(red: 0.9495584369, green: 0.8718144298, blue: 0.8732326627, alpha: 1)
                let buttonBg = #colorLiteral(red: 0.8576444983, green: 0.3266127706, blue: 0.3078376949, alpha: 1)
                let buttonTitleColor = UIColor.white
                
                self.showCustomAlertWithOkButton(title: title, titleColor: titleColor, titleBackgroundColor: titleBg, buttonBackgroundColor: buttonBg, buttonTitleColor: buttonTitleColor, targetViewControllerIdentifier: nil) { [weak self] in
                    guard let self = self else { return }
                    self.getAllDataCall(clientId: self.clientID!, contactId: self.contactID!, weekEnd: self.WeekEndDate!)
                }

            }
            
            else if object[0]["StatusCode"].intValue == 1 {
                
                let title = object[0]["message"].stringValue
                let titleColor = #colorLiteral(red: 0.2352941176, green: 0.462745098, blue: 0.2392156863, alpha: 1)
                let titleBg = #colorLiteral(red: 0.8745098039, green: 0.9411764706, blue: 0.8470588235, alpha: 1)
                let buttonBg = #colorLiteral(red: 0.2352941176, green: 0.462745098, blue: 0.2392156863, alpha: 1)
                let buttonTitleColor = UIColor.white
                
                self.showCustomAlertWithOkButton(title: title, titleColor: titleColor, titleBackgroundColor: titleBg, buttonBackgroundColor: buttonBg, buttonTitleColor: buttonTitleColor, targetViewControllerIdentifier: nil) { [weak self] in
                    guard let self = self else { return }
                    self.getAllDataCall(clientId: self.clientID!, contactId: self.contactID!, weekEnd: self.WeekEndDate!)
                }
            }
            
            else {
                getAllDataCall(clientId: clientID!, contactId: contactID!, weekEnd: WeekEndDate!)
            }

            
        }
        
    }
    
    //MARK: - Save Rating Button Tapped
    
    func saveRatingButtonTapped(with starsRating: Int, at row: Int) {

        print("Stars Rating Value from table view is : \(starsRating) at the row number : \(row)")
        
        let dataDict:NSMutableDictionary = itemList[row] as! NSMutableDictionary
        dataDict["Rating"] = String(starsRating)
 
        if starsRating < 3 {
                    let ac = UIAlertController(title: "Enter Remark", message: nil, preferredStyle: .alert)
                    ac.addTextField()
            
                    let submitAction = UIAlertAction(title: "Submit", style: .default){ [weak ac] _ in
                        guard let answer = ac?.textFields?[0].text else {return}
                        submit(answer) {
                            ratingAPICall {
                                print("API call and Rating saved here")
                            }
                        }
                    }
            
                    ac.addAction(submitAction)
                    present(ac, animated: true)
        } else {
            ratingAPICall {
                print("API call alone happen here")
            }
        }
        
        func submit(_ answer: String, completion: @escaping () -> Void) {
            print("The remarks mentioned is : ", answer)
            dataDict["RatingComments"] = answer
            completion()
        }
        
        func ratingAPICall(completion: @escaping () -> Void){
            
            if dataDict.allKeys.count == 0{} else {
                
                CandId = Int(dataDict["CandId"] as? String ?? "0")
                OrderId = Int(dataDict["OrderId"] as? String ?? "0")
                WeekEnd = dataDict["WeekEnd"] as? String
                ratingNumber = Int(dataDict["Rating"] as? String ?? "0")
                ratingReason = dataDict["RatingComments"] as? String ?? ""
                
                print("the rating for \(String(describing: dataDict["Name"])) is the value \(String(describing: dataDict["Rating"]))")
                
                if (CandId != nil && OrderId != nil && WeekEnd != nil && clientID != nil && contactID != nil) {
                    let params: [String: String] = [ "ClientId":clientID!, "CandId":"\(CandId!)", "OrderId":"\(OrderId!)", "WeekEnd":WeekEnd!, "WorkDate":WeekEnd!, "Rating":"\(ratingNumber!)", "RatingComments":ratingReason!, "Source":"2", "ClientContacts":contactID!]
                    
                    print("the Parameters for the Rating API call is", params)
                    
                    let isInternetAvailable = self.isInternetAvailable()
                    
                    if isInternetAvailable {
                        
                        JustHUD.shared.showInView(view: (self.view)!)
                        
                        RestAPI.getsaveRating(self, params: params, method: "POST", accessToken: "", acces: true, callBack: ratingResponse(response:))
                        
                    }
                    else{
                        
                        self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                        
                    }
                }
                else {
                    print("in Rating some Parameters are nill")
                }
                
            }
            completion()
            mainTableView.reloadData()
        }
        
        }
    
    //MARK: - Rating Response after saving
    
    func ratingResponse(response:AnyObject)->() {
        
        JustHUD.shared.hide()
        
        if response is String{
            
            let title = response as! String
            let titleColor = #colorLiteral(red: 0.8576444983, green: 0.3266127706, blue: 0.3078376949, alpha: 1)
            let titleBg = #colorLiteral(red: 0.9495584369, green: 0.8718144298, blue: 0.8732326627, alpha: 1)
            let buttonBg = #colorLiteral(red: 0.8576444983, green: 0.3266127706, blue: 0.3078376949, alpha: 1)
            let buttonTitleColor = UIColor.white

            self.showCustomAlertWithOkButton(title: title, titleColor: titleColor, titleBackgroundColor: titleBg, buttonBackgroundColor: buttonBg, buttonTitleColor: buttonTitleColor)
            
        }
        
        else {
            
            let object = response as! JSON
            print("the API Rating Response is", object)
            
        }
        
    }
    
    //MARK: - Rating Comments Info Button
    
    @objc func ratingCommentsInfoButtonTapped(_ sender: UIButton) {
        print("ratingCommentsInfo button pressed")
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.mainTableView)
        let indexPath = self.mainTableView.indexPathForRow(at: buttonPosition)
        
        let dataDict:NSMutableDictionary = itemList[indexPath!.row] as! NSMutableDictionary
        
        if dataDict.allKeys.count == 0{}else{
            ratingReason = dataDict["RatingComments"] as? String ?? ""
            
            let ac = UIAlertController(title: "Remarks", message: ratingReason, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: {(alert: UIAlertAction!) in print("OK")
                ac.dismiss(animated: true, completion: nil)
            })
            ac.addAction(cancelAction)
            self.present(ac, animated: true, completion: {})
            
        }
    }
    
    //MARK: - Others Info Button Pressed
    
    @objc func othersInfoButtonTapped(_ sender: UIButton) {
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.mainTableView)
        let indexPath = self.mainTableView.indexPathForRow(at: buttonPosition)
        
        let dataDict:NSMutableDictionary = itemList[indexPath!.row] as! NSMutableDictionary
        
        if dataDict.allKeys.count == 0{}else{
            otherReasonVariable = dataDict["OtherReason"] as? String ?? ""
            
            let ac = UIAlertController(title: "Other", message: otherReasonVariable, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: {(alert: UIAlertAction!) in print("OK")
                ac.dismiss(animated: true, completion: nil)
            })
            ac.addAction(cancelAction)
            self.present(ac, animated: true, completion: {})
            
        }
        
    }
    
    //MARK: - Save Reason Button Tapped
    
    @objc func saveReasonButtonTapped(_ sender: UIButton) {
        
        print("save reason button pressed")
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.mainTableView)
        let indexPath = self.mainTableView.indexPathForRow(at: buttonPosition)
        
        saveReasonCommonAPICall(with: indexPath!.row)
        
    }
    
    //MARK: - Save Reason Common API Call
    
    func saveReasonCommonAPICall(with index: Int) {
        
        let dataDict:NSMutableDictionary = itemList[index] as! NSMutableDictionary
        
        //IP
        
        if let ipAddress = getIPv4Address() {
            print("IP Address: \(ipAddress)")
            IPAddress = ipAddress
        } else {
            print("Unable to retrieve IP address")
        }
        
        //End
        
        if dataDict.allKeys.count == 0{}else {
            
            CandId = Int(dataDict["CandId"] as? String ?? "0")
            OrderId = Int(dataDict["OrderId"] as? String ?? "0")
            WeekEnd = dataDict["WeekEnd"] as? String
            BillDate = dataDict["BillDate"] as? String
            RecCode = dataDict["RecCode"] as? String
            CheckIn = dataDict["CheckIn"] as? String
            CheckOut = dataDict["CheckOut"] as? String
            EndTime = dataDict["EndTime"] as? String
            StartTime = dataDict["StartTime"] as? String
            breakMinutes = Int(dataDict["BreakMinutes"] as? String ?? "0")
            totlaHours = Int(dataDict["TotalHours"] as? String ?? "0")
            
            dataDict["IsIrregular"] = "1"
            print("The irrelar value is", dataDict["IsIrregular"]!)
            totalSelected.removeAllObjects()
            selectedItemList.removeAllObjects()
            selectedCells.removeAll()
            print("the totalselcted items from save reason is", totalSelected)
            print("the total selected cells are",selectedCells)
            mainTableView.reloadData()
            
            ChkInType = 0
            RouteName = "iOS"
            timeOut = defaultTime
            timeIn = defaultTime
            PayforBreak = 0
            Id = Int(dataDict["Id"] as? String ?? "0")
            ReasonId = Int(dataDict["ReasonId"] as? String ?? "10")
            
            OtherReason = dataDict["OtherReason"] as? String ?? ""
            
            print("vivek the reason ID for ", CandId!, "is equal to", dataDict["ReasonId"]! )
            
        }
        
        if (CandId != nil && OrderId != nil && WeekEnd != nil && BillDate != nil && StartTime != nil && EndTime != nil && CheckIn != nil && CheckOut != nil && ClientId != nil && ContactId != nil && ChkInType != nil && RouteName != nil && timeOut != nil && timeIn != nil && breakMinutes != nil && totlaHours != nil && RecCode != nil && PayforBreak != nil && Id != nil && latitude != nil && longitude != nil && ReasonId != nil){
            
            let params: [String: Any] = ["CandId":CandId!, "OrderId":OrderId!, "WeekEnd":WeekEnd!, "BillDate":BillDate!, "StartTime":StartTime!, "EndTime": EndTime!, "CheckIn":CheckIn!, "CheckOut":CheckOut!, "Type":ChkInType!, "RouteName":RouteName!, "ClientId":ClientId!, "ContactId":ContactId!, "timeOut":timeOut!, "timeIn":timeIn!, "breakMinutes":breakMinutes!, "totlaHours":totlaHours!, "RecCode":RecCode!, "PayforBreak":PayforBreak!, "Id":Id!, "longitude":longitude!, "latitude": latitude!, "Address":Address ?? "Not Found", "ReasonId":ReasonId!, "OtherReason":OtherReason, "Retry": 0]

            print("the Parameters for the API call is", params)
            
            let isInternetAvailable = self.isInternetAvailable()
            
            if isInternetAvailable {
                
                JustHUD.shared.showInView(view: (self.view)!)
                
                RestAPI.saveReasonApi(self, params: params, method: "POST", accessToken: "", acces: true, callBack: saveIrregularResponse(response:))
                
            }
            else{
                
                self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }
        
        else {
            print("in Parameters some is nill")
        }
        
    }
    
    //MARK: - Save Reason API Response
    
    func saveIrregularResponse(response:AnyObject)->() {
        
//        JustHUD.shared.hide()
        
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
            print("the API save reason Response is", object)
            
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
                                
                                RestAPI.saveReasonApi(self, params: params, method: "POST", accessToken: "", acces: true, callBack: saveIrregularResponse(response:))
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
                let title = object[0]["message"].stringValue
                let titleColor = #colorLiteral(red: 0.8576444983, green: 0.3266127706, blue: 0.3078376949, alpha: 1)
                let titleBg = #colorLiteral(red: 0.9495584369, green: 0.8718144298, blue: 0.8732326627, alpha: 1)
                let buttonBg = #colorLiteral(red: 0.8576444983, green: 0.3266127706, blue: 0.3078376949, alpha: 1)
                let buttonTitleColor = UIColor.white
                
                self.showCustomAlertWithOkButton(title: title, titleColor: titleColor, titleBackgroundColor: titleBg, buttonBackgroundColor: buttonBg, buttonTitleColor: buttonTitleColor)
            }
            
            else if object[0]["StatusCode"].intValue == 1 {
                let title = object[0]["message"].stringValue
                let titleColor = #colorLiteral(red: 0.2352941176, green: 0.462745098, blue: 0.2392156863, alpha: 1)
                let titleBg = #colorLiteral(red: 0.8745098039, green: 0.9411764706, blue: 0.8470588235, alpha: 1)
                let buttonBg = #colorLiteral(red: 0.2352941176, green: 0.462745098, blue: 0.2392156863, alpha: 1)
                let buttonTitleColor = UIColor.white
                
                self.showCustomAlertWithOkButton(title: title, titleColor: titleColor, titleBackgroundColor: titleBg, buttonBackgroundColor: buttonBg, buttonTitleColor: buttonTitleColor)
            }
            
            
            else {
                JustHUD.shared.hide()
            }
            
        }
        
    }
    
    
    //MARK: - Submit Button Tapped
    
    @objc func submitButtonTapped(_ sender: UIButton) {
                        
            print("submit button pressed")
            
            let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.mainTableView)
            let indexPath = self.mainTableView.indexPathForRow(at: buttonPosition)
            
            let dataDict:NSMutableDictionary = itemList[indexPath!.row] as! NSMutableDictionary
            
            if dataDict.allKeys.count == 0{}else {
                
                CandId = Int(dataDict["CandId"] as? String ?? "0")
                OrderId = Int(dataDict["OrderId"] as? String ?? "0")
                WeekEnd = dataDict["WeekEnd"] as? String
                BillDate = dataDict["BillDate"] as? String
                RecCode = dataDict["RecCode"] as? String
                CheckIn = dataDict["CheckIn"] as? String
                CheckOut = dataDict["CheckOut"] as? String
                EndTime = dataDict["EndTime"] as? String
                StartTime = dataDict["StartTime"] as? String
                breakMinutes = Int(dataDict["BreakMinutes"] as? String ?? "0")
                totlaHours = Int(dataDict["TotalHours"] as? String ?? "0")
                
                ChkInType = 2
                RouteName = "iOS"
                timeOut = defaultTime
                timeIn = defaultTime
                PayforBreak = 0
                Id = Int(dataDict["Id"] as? String ?? "0")
                
                print("viv the id before sending is", Id!)
                
//
            }
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AllTabSaveSegue") as! E_AllTabSaveVC
        
        nextViewController.modalPresentationStyle = .overCurrentContext
        nextViewController.modalTransitionStyle = .crossDissolve
                
        //params sending
        
        nextViewController.CandId = CandId
        nextViewController.OrderId = OrderId
        nextViewController.WeekEnd = WeekEnd
        nextViewController.BillDate = BillDate
        nextViewController.CheckIn = CheckIn
        nextViewController.CheckOut = CheckOut
        nextViewController.ChkInType = ChkInType
        nextViewController.RouteName = RouteName
        nextViewController.ClientId = ClientId
        nextViewController.ContactId = ContactId
        nextViewController.timeOut = timeOut
        nextViewController.timeIn = timeIn
        nextViewController.breakMinutes = breakMinutes
        nextViewController.totlaHours = totlaHours
        nextViewController.RecCode = RecCode
        nextViewController.PayforBreak = PayforBreak
        nextViewController.Id = Id
        nextViewController.longitude = longitude
        nextViewController.latitude = latitude
        nextViewController.Address = Address
        nextViewController.StartTime = StartTime
        nextViewController.EndTime = EndTime
        
        //end
        
        self.navigationController?.present(nextViewController, animated: true)
        //pushViewController
     
   
    }
    
    //MARK: - API Submit Response
    
    func getSubmitResponse(response:AnyObject)->() {
        
        JustHUD.shared.hide()
        
        if response is String{
            
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
         
            if object[0]["StatusCode"].intValue == 0 {
                
                let title = object[0]["message"].stringValue
                let titleColor = #colorLiteral(red: 0.8576444983, green: 0.3266127706, blue: 0.3078376949, alpha: 1)
                let titleBg = #colorLiteral(red: 0.9495584369, green: 0.8718144298, blue: 0.8732326627, alpha: 1)
                let buttonBg = #colorLiteral(red: 0.8576444983, green: 0.3266127706, blue: 0.3078376949, alpha: 1)
                let buttonTitleColor = UIColor.white
                
                self.showCustomAlertWithOkButton(title: title, titleColor: titleColor, titleBackgroundColor: titleBg, buttonBackgroundColor: buttonBg, buttonTitleColor: buttonTitleColor, targetViewControllerIdentifier: nil) { [weak self] in
                    guard let self = self else { return }
                    self.getAllDataCall(clientId: self.clientID!, contactId: self.contactID!, weekEnd: self.WeekEndDate!)
                }

            }
            
            else if object[0]["StatusCode"].intValue == 1 {
                
                let title = object[0]["message"].stringValue
                let titleColor = #colorLiteral(red: 0.2352941176, green: 0.462745098, blue: 0.2392156863, alpha: 1)
                let titleBg = #colorLiteral(red: 0.8745098039, green: 0.9411764706, blue: 0.8470588235, alpha: 1)
                let buttonBg = #colorLiteral(red: 0.2352941176, green: 0.462745098, blue: 0.2392156863, alpha: 1)
                let buttonTitleColor = UIColor.white
                
                self.showCustomAlertWithOkButton(title: title, titleColor: titleColor, titleBackgroundColor: titleBg, buttonBackgroundColor: buttonBg, buttonTitleColor: buttonTitleColor, targetViewControllerIdentifier: nil) { [weak self] in
                    guard let self = self else { return }
                    self.getAllDataCall(clientId: self.clientID!, contactId: self.contactID!, weekEnd: self.WeekEndDate!)
                }
            }
            
            else {
                getAllDataCall(clientId: clientID!, contactId: contactID!, weekEnd: WeekEndDate!)
            }
            
        }
        
    }
    
    //MARK: - Overall submit enabling
    
    func updateButtonState() {
        if selectedCells.count > 0 {
            overallSubmitButton.isEnabled = true
        } else {
            overallSubmitButton.isEnabled = false
        }
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
    
    //MARK: - Convert Back to 24 hours Format
    
    func convert12HourTo24Hour(timeString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        if let date = dateFormatter.date(from: timeString) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
    
    //MARK: - Break Time Calculate
    
    func addTimes(start:String,end:String,min:Bool) -> Int
    {
        let startDate = start
        let endDate = end
        
        var startArray = startDate.components(separatedBy: (":"))
        
        for (index, component) in startArray.enumerated() {
            // Check if the component contains "AM"
            if component.contains("AM") {
                // If it does, replace it with an empty string
                startArray[index] = component.replacingOccurrences(of: "AM", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
            }
            else if component.contains("PM") {
                // If it does, replace it with an empty string
                startArray[index] = component.replacingOccurrences(of: "PM", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }

        var endArray = endDate.components(separatedBy: (":"))
        
        for (index, component) in endArray.enumerated() {
            // Check if the component contains "AM"
            if component.contains("AM") {
                // If it does, replace it with an empty string
                endArray[index] = component.replacingOccurrences(of: "AM", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
            }
            else if component.contains("PM") {
                // If it does, replace it with an empty string
                endArray[index] = component.replacingOccurrences(of: "PM", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        
        print("the start array is ", startArray)
        
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
    
    //MARK: - Min to Hours
    
    func convertMinutesToHoursAndMinutes(minutes: Int) -> (hours: Int, minutes: Int) {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        return (hours, remainingMinutes)
    }

    
}

