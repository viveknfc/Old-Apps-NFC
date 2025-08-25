//
//  ROSOfficeViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 05/02/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON
import FSCalendar

class NewRosOfficeVC: BaseTableViewController,searchEmpDelegate,UITextFieldDelegate,UITextViewDelegate,SummaryDelegate,addReportToDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance  {
    
    var customCalendarView = CalendarView()
    
    let SearchButtonCellIdentifier = "ButtonTableViewCellIdentifier"
    var keyboardShowing = false
    let NextButtonCellIdentifier = "NextTableViewCellIdentifier"
    
    var dropDownView = UIView()
    var  alertDropDownTableView = UITableView()
    
    var isTimeDataReloaded = ""
    
    var isErrorMessage = false
    var isWarningMessage = false
    //MARK: OUTLET VARIBALE
    //    @IBOutlet weak var listTableView: UITableView!
    var empTableView: UITableView!
    var customPickerView = JPPickerView()
    var timeSegment = UISegmentedControl()
    var activeField: UITextField?
    var activeTextView: UITextView?
    var alrtController = UIAlertController()
    
    var selectedReportTo = ReportTo.init(ContactId: 0, Name: "",isSelected:"")
    var selectedPositionType = HOSPositionType.init(KeyValue: "",PositionName: "",isSelected: "" )
    var selectedReportToLoc = OfficeReportToLocation.init(ReportToName: "",ReportId: "",isSelected: "")
    var selectedReasonForPosition = HOSPositionType.init(KeyValue: "",PositionName: "",isSelected: "" )
    var selectedMealBreakTime = MealBreakMin.init(Text: "", Value: "", isSelected: "")
    
    var createOrderObj = NSDictionary()
    
    //MARK: Array Initialisation
    
    var reportToArray = NSMutableArray()
    var reportToLocArray = NSMutableArray()
    var positionArray = NSMutableArray()
    var ReasonForPositionArray = NSMutableArray()
    var employeeArray = NSMutableArray()
    var dataArray = NSMutableArray()
    var multiDayDataArray = NSMutableArray()
    var selectedEmployeeArray = NSMutableArray()
    var weekDayArray = NSMutableArray()
    var ResponseEmployeeArray = NSMutableArray()
    var MealBreakMinArray = NSMutableArray()
    
    var selectedSementTag = 0
    var TempEmployeesNeeded = 0
    var minimalHoursPerOrder = "0"
    //    var dailyHour = "0"
    var sameDayHour = "0"
    var multiDayHour = "0"
    var JobTitleValue = ""
    
    //MARK: Validation Variables
    
    var isValidReportToLocation = true
    var isValidReportTo = true
    var isValidPosition = true
    var isValidEmployeeNeeded = true
    var isValidStartTime = true
    var isValidEndTime = true
    var isValidJobDuty = true
    var isValidJobDesc = true
    var isValidReasonForPosition = true
    var isValidJobTitle = true
    
    
    var allDataValidated = false
    var isPositionTypeSelecetdOnce = true
    
    //MARK: View Tags
    
    let PositionTblViewTag = 300001
    let ReasonForPositionTblViewTag = 300002
    let ReportToLocationTblViewTag = 300003
    let ReportToTblViewTag = 300004
    let breakTimeTblViewTag = 300005
    
    
    var firstResponderTxtFieldTag = 0
    let empTblViewTag =  1005
    let mainTblViewTag =  1006
    var segHeader = ""
    
    let MonStartTxtFieldTag = "10001"
    let MonEndTxtFieldTag = "10002"
    let MonBreakTxtFieldTag = "110002"
    
    let TueStartTxtFieldTag = "10003"
    let TueEndTxtFieldTag = "10004"
    let TueBreakTxtFieldTag = "110005"
    
    let WedStartTxtFieldTag = "10005"
    let WedEndTxtFieldTag = "10006"
    let WedBreakTxtFieldTag = "110007"
    
    let ThuStartTxtFieldTag = "10007"
    let ThuEndTxtFieldTag = "10008"
    let ThuBreakTxtFieldTag = "110009"
    
    let FriStartTxtFieldTag = "10009"
    let FriEndTxtFieldTag = "100010"
    let FriBreakTxtFieldTag = "1100011"
    
    let SatStartTxtFieldTag = "100011"
    let SatEndTxtFieldTag = "100012"
    let SatBreakTxtFieldTag = "110013"
    
    let SunStartTxtFieldTag = "100013"
    let SunEndTxtFieldTag = "100014"
    let SunBreakTxtFieldTag = "110014"
    
    let StartDateTxtFieldTag = "100015"
    let EndDateTxtFieldTag = "100016"
    
    let StartTimeTxtFieldTag = "100017"
    let EndTimeTxtFieldTag = "100018"
    let BreakTimeTxtFieldTag = "1100018"
    
    let reportToTxtFieldTag = 1004
    let empNeededTxtFieldTag = 100019
    let eventTxtFieldTag = 100020
    let positionTxtFieldTag = 100021
    let reportToLocTxtFieldTag = 100022
    let ReasonForPositionTxtFieldTag = 1000023
    let jobTitleTxtFieldTag = 100033
    
    let empCommentTxtViewTag = "100023"
    let divisionCommentTxtViewTag = "100024"
    let jobDutyTxtViewTag = "100025"
    let jobDescTxtViewTag = "100026"
    
    
    //MARK: Placeholder
    var PositionPlaceHolder = "Position *"
    var JobTitlePlaceHolder = "Job Title *"
    
    var ReasonForPositionPlaceHolder = "Reason For Position *"
    var ReportToLocationPlaceHolder = "Report To Location *"
    var ReportToPlaceHolder = "Report To *"
    var EmployeesNeededPlaceHolder = "No. of employees needed *"
    let StartDatePlaceHolder = "Start Date *"
    let EndDatePlaceHolder = "End Date *"
    let StartTimePlaceHolder = "Start Time *"
    let EndTimePlaceHolder = "End Time *"
    let IncludeWeekendPlaceHolder = "Include Weekend?"
    let substituteEmpPlaceHolder = "If one or more of the selected employees is not available, check here if we may substitute other qualified employees."
    let jobDutyPlaceHolder = "Job Duties/Responsibilities *"
    let jobDescPlaceHolder = "Job Description *"
    let empTextViewHeader = "Additional Comments for Employees"
    let divTextViewHeader = "Comments for TemPositions internal staff only"
    //    let whenNeededPlaceHolder = String(format:"%@\n%@","Tell us when you need them","Please select start and end dates of the assignment")
    let sameDayTimePlaceHolder = "Click Here if your employee's will work on Saturday or Sunday, or at different times on different days during the week"
    let multiDayTimePlaceHolder = "Click Here if you require the same time on all days."
    let divisionTextViewPlaceHolder = "These comments will be viewed by TemPositions staff only."
    let empTextViewPlaceHolder = "These comments will be relayed to the assigned employee(s)."
    
    
    var defaultMealBreakTime = ""
    //MARK: Initialisation
    
    var StartDate = ""
    var EndDate = ""
    var minuteInterval = 0
    var  HeaderName  = "if you require the same time on all days"
    var SelectedHeaderName = "if your employees will work on Saturday or Sunday, or at different times different days during the week; otherwise enter times below"
    
    //MARK: Post Params
    var StartTime = ""
    var EndTime = ""
    var MealBreakTime = ""
    var empCommentText = ""
    var divisionCommentText = ""
    var jobDescText = ""
    var jobDutyText = ""
    
    var ReportToAddress = ""
    var ReportToCity = ""
    var ReportToPhone = ""
    var ReportToZip = ""
    var ReportToFax = ""
    var ReportToState = ""
    
    var EmpNeed = ""
    var chkSendComp = ""
    var SelectedEmployeeNames = ""
    
    var WednesdayStartTime = ""
    var WednesdayEndTime = ""
    var WednesdayBreakTime = ""
    
    var MondayStartTime = ""
    var MondayEndTime = ""
    var MondayBreakTime = ""
    
    var TuesdayStartTime = ""
    var TuesdayEndTime = ""
    var TuesdayBreakTime = ""
    
    var ThursdayStartTime = ""
    var ThursdayEndTime = ""
    var ThursdayBreakTime = ""
    
    var FridayStartTime = ""
    var FridayEndTime = ""
    var FridayBreakTime = ""
    
    var SaturdayStartTime = ""
    var SaturdayEndTime = ""
    var SaturdayBreakTime = ""
    
    var SundayStartTime = ""
    var SundayEndTime = ""
    var SundayBreakTime = ""
    
    
    var IncludeWeekend = "false"
    var IsCheckAllowOT = "false"
    var SubstituteEmpChecked = "0"
    
    //MARK:View Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titlelbl.text = "Rapid Order System"
    }
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //        NotificationCenter.default.removeObserver(self)
    //
    //        self.view.endEditing(true)
    //    }
    @objc override func appWillEnterForeground(){
        print("appWillEnterForeground Division")
        
        if dataArray.count == 0{
            self.getROSData()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tag = 1006
        //        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.keyboardDismissMode = .interactive
        //        self.isKeyboardOnScreen()
        self.registerNotif()
        selectedSementTag = 0
        self.formMultiDayArray()
        self.setupPickerView()
        self.setupCalendarView()
        
        self.getROSData()
        
        // Do any additional setup after loading the view.
    }
    override  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        //        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupPickerView(){
        customPickerView = Bundle.main.loadNibNamed("JPPickerView", owner: self, options: nil)?[0] as! JPPickerView
        
        customPickerView.setupUI()
        customPickerView.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
        customPickerView.doneButton.addTarget(self, action:#selector(self.timeButtonTapped), for:.touchUpInside)
        customPickerView.dtPickerView.addTarget(self, action:#selector(self.datePickerValueChanged), for:.valueChanged)
        //         hoursSegment.tintColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        customPickerView.dtPickerView.setValue(UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String), forKey: "textColor")
        customPickerView.dtPickerView.backgroundColor = UIColor.white
        
    }
    func setupCalendarView(){
        customCalendarView = Bundle.main.loadNibNamed("CalendarView", owner: self, options: nil)?[0] as! CalendarView
        customCalendarView.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
        customCalendarView.setupCalendar()
        customCalendarView.calendar.delegate = self
        customCalendarView.calendar.dataSource = self
        
    }
    func formMultiDayArray(){
        
        let startTimePlaceHolder = "Start Time"
        let endTimePlaceHolder = "End Time"
        let   mealBreakTimePlaceholder = "00"
        
        
        let monDict = ["day":"MON","header":startTimePlaceHolder,"showDropDown":"0","StartTag":MonStartTxtFieldTag,"EndTag":MonEndTxtFieldTag,"StartValue":"","EndValue":"","subHeader":endTimePlaceHolder,
                       "breakTag":MonBreakTxtFieldTag,"BreakValue":mealBreakTimePlaceholder]
        
        let tuesDict = ["day":"TUE","header":startTimePlaceHolder,"showDropDown":"0","StartTag":TueStartTxtFieldTag,"EndTag":TueEndTxtFieldTag,"StartValue":"","EndValue":"","subHeader":endTimePlaceHolder,
                        "breakTag":TueBreakTxtFieldTag,"BreakValue":mealBreakTimePlaceholder]
        let wedDict = ["day":"WED","header":startTimePlaceHolder,"showDropDown":"0","StartTag":WedStartTxtFieldTag,"EndTag":WedEndTxtFieldTag,"StartValue":"","EndValue":"","subHeader":endTimePlaceHolder,
                       "breakTag":WedBreakTxtFieldTag,"BreakValue":mealBreakTimePlaceholder]
        let thurDict = ["day":"THU","header":startTimePlaceHolder,"showDropDown":"0","StartTag":ThuStartTxtFieldTag,"EndTag":ThuEndTxtFieldTag,"StartValue":"","EndValue":"","subHeader":endTimePlaceHolder,
                        "breakTag":ThuBreakTxtFieldTag,"BreakValue":mealBreakTimePlaceholder]
        let friDict = ["day":"FRI","header":startTimePlaceHolder,"showDropDown":"0","StartTag":FriStartTxtFieldTag,"EndTag":FriEndTxtFieldTag,"StartValue":"","EndValue":"","subHeader":endTimePlaceHolder,
                       "breakTag":FriBreakTxtFieldTag,"BreakValue":mealBreakTimePlaceholder]
        let satDict = ["day":"SAT","header":startTimePlaceHolder,"showDropDown":"0","StartTag":SatStartTxtFieldTag,"EndTag":SatEndTxtFieldTag,"StartValue":"","EndValue":"","subHeader":endTimePlaceHolder,
                       "breakTag":SatBreakTxtFieldTag,"BreakValue": mealBreakTimePlaceholder]
        let sunDict = ["day":"SUN","header":startTimePlaceHolder,"showDropDown":"0","StartTag":SunStartTxtFieldTag,"EndTag":SunEndTxtFieldTag,"StartValue":"","EndValue":"","subHeader":endTimePlaceHolder,
                       "breakTag":SunBreakTxtFieldTag,"BreakValue": mealBreakTimePlaceholder]
        
        
        
        weekDayArray = [monDict,tuesDict,wedDict,thurDict,friDict,satDict,sunDict]
    }
    
    
    //MARK: BUTTON ACTION
    @IBAction override func okButtonTapped(_ sender: Any) {
        self.tAlertController.dismiss(animated: true, completion: nil)
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
        if isWarningMessage == true{
            self.pushToOrderSummaryPage()
        }else if isErrorMessage == true{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    @objc func nextButtonTapped(sender:UIButton){
        
        let isValidated = self.validateData()
        
        if isValidated == true{
            //            self.pushToOrderSummaryPage()
            self.createOrderAPICall()
        }else {
            isWarningMessage = false
            isErrorMessage = false
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Please enter all the mandatory fields", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
        
    }
    @objc func timeButtonTapped(sender:UIButton) {
        
        customPickerView.removePickerViewFromSuperView()
        if firstResponderTxtFieldTag == Int(MonStartTxtFieldTag) || firstResponderTxtFieldTag == Int(MonEndTxtFieldTag) ||  firstResponderTxtFieldTag == Int(TueStartTxtFieldTag) || firstResponderTxtFieldTag == Int(TueEndTxtFieldTag) || firstResponderTxtFieldTag == Int(WedStartTxtFieldTag) || firstResponderTxtFieldTag == Int(WedEndTxtFieldTag)!  ||  firstResponderTxtFieldTag == Int(ThuStartTxtFieldTag)! || firstResponderTxtFieldTag == Int(ThuEndTxtFieldTag) ||  firstResponderTxtFieldTag == Int(FriStartTxtFieldTag) || firstResponderTxtFieldTag == Int(FriEndTxtFieldTag) || firstResponderTxtFieldTag == Int(SatStartTxtFieldTag) || firstResponderTxtFieldTag == Int(SatEndTxtFieldTag)!  ||  firstResponderTxtFieldTag == Int(SunStartTxtFieldTag)! || firstResponderTxtFieldTag == Int(EndTimeTxtFieldTag) || firstResponderTxtFieldTag == Int(SunEndTxtFieldTag) || firstResponderTxtFieldTag == Int(StartTimeTxtFieldTag){
            
            //Show the  previuosly  selected Time else show current date
            customPickerView.dtPickerView.locale = NSLocale(localeIdentifier: "en_US") as Locale
            let changedDate = customPickerView.dtPickerView.date
            self.setDatePickerValue(changedDate: changedDate)
        }
        
    }
    func setDatePickerValue(changedDate: Date){
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        var  pickedDateString = formatter.string(from: changedDate as Date)
        
        if firstResponderTxtFieldTag == Int(StartDateTxtFieldTag) || firstResponderTxtFieldTag == Int(EndDateTxtFieldTag) || firstResponderTxtFieldTag == Int(StartTimeTxtFieldTag) || firstResponderTxtFieldTag == Int(EndTimeTxtFieldTag){
            
            if selectedSementTag == 0{
                if  firstResponderTxtFieldTag == Int(StartTimeTxtFieldTag) || firstResponderTxtFieldTag == Int(EndTimeTxtFieldTag){
                    formatter.dateFormat = "MM/dd/yyyy hh:mm a"
                    pickedDateString = formatter.string(from: changedDate as Date)
                    
                    let   stringArray = pickedDateString.components(separatedBy: " ")
                    if stringArray.count>2{
                        pickedDateString = String(format:"%@ %@",stringArray[1],stringArray[2])
                        if minuteInterval > 1{
                            
                            let timeArray = stringArray[1].components(separatedBy: ":")
                            let minute = timeArray[1]
                            let hour = timeArray[0]
                            let ampm = stringArray[2]
                            print( hour,minute,ampm)
                            
                            var min = "00"
                            if Int(minute) ?? 0 >= minuteInterval{
                                min = String(format:"%d",minuteInterval)
                            }
                            if Int(minute) == 0 || Int(minute) == minuteInterval{
                            }else{
                                pickedDateString = String(format: "%@:%@ %@", hour,min,ampm)

//                                if pickedDateString.contains("m") || pickedDateString.contains("M"){
//                                    pickedDateString = pickedDateString.replace(target: minute, withString: String(format:"%@",min))
//
//                                }else{
//                                    pickedDateString = pickedDateString.replace(target: minute, withString: String(format:"%@ %@",min,ampm))
//                                }
                                print(pickedDateString)
                            }
                        }
                    }
                }
                self.updateDatesFromPicker(dateString: pickedDateString, forArray: dataArray)
                
            }else{
                
                self.updateDatesFromPicker(dateString: pickedDateString, forArray: multiDayDataArray)
            }
            //Position TableView
        }else {
            formatter.dateFormat = "MM/dd/yyyy hh:mm a"
            pickedDateString = formatter.string(from: changedDate as Date)
            
            let   stringArray = pickedDateString.components(separatedBy: " ")
            if stringArray.count>2{
                pickedDateString = String(format:"%@ %@",stringArray[1],stringArray[2])
                if minuteInterval > 1{
                    
                    let timeArray = stringArray[1].components(separatedBy: ":")
                    let minute = timeArray[1]
                    let hour = timeArray[0]
                    let ampm = stringArray[2]
                    print( hour,minute,ampm)
                    
                    var min = "00"
                    if Int(minute) ?? 0 >= minuteInterval{
                        min = String(format:"%d",minuteInterval)
                    }
                    if Int(minute) == 0 || Int(minute) == minuteInterval{
                    }else{
                        pickedDateString = String(format: "%@:%@ %@", hour,min,ampm)

//                        if pickedDateString.contains("m") || pickedDateString.contains("M"){
//                            pickedDateString = pickedDateString.replace(target: minute, withString: String(format:"%@",min))
//
//                        }else{
//                            pickedDateString = pickedDateString.replace(target: minute, withString: String(format:"%@ %@",min,ampm))
//                        }
                        print(pickedDateString)
                    }
                }
            }
            //Time
            if selectedSementTag == 1{
                self.updateDatesFromPicker(dateString: pickedDateString, forArray: multiDayDataArray)
                //multi schdule array
            }else{
                //schdule array
                self.updateDatesFromPicker(dateString: pickedDateString, forArray: dataArray)
            }
        }
        self.isTimeDataReloaded = "0"
    }
    @objc func datePickerValueChanged(sender: UIDatePicker){
        
        //▿ 2017-10-29 11:20:00 +0000
        sender.locale = NSLocale(localeIdentifier: "en_US") as Locale
        let changedDate = sender.date
        
        self.setDatePickerValue(changedDate: changedDate)
        
        
        //        self.tableView.reloadData()
    }
    
    @IBAction func addReportToLocBtnTapped(_ sender: UIButton) {
        
        self.pushToAddReportToPage(isForReportTo: false, isForReportToLoc: true)
        
    }
    @IBAction func addReportToBtnTapped(_ sender: UIButton) {
        
        self.pushToAddReportToPage(isForReportTo: true, isForReportToLoc: false)
        
    }
    @objc func clickHereSegBtnTapped(_ sender: UIButton) {
        
        if self.timeSegment .selectedSegmentIndex == 0{
            self.timeSegment.selectedSegmentIndex = 1
            selectedSementTag = 1
        }else{
            selectedSementTag = 0
            self.timeSegment.selectedSegmentIndex = 0
        }
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.reloadData()
        })
        
    }
    
    @objc func clearAllBtnBtnTapped(sender: UIButton){
        
        //        employeeArray.removeAllObjects()
        
        for emp in employeeArray {
            
            let  empObj:NewEmployee = emp as! NewEmployee
            
            empObj.isCheckedInRoaster = "0"
            empObj.isSelected = "0"
            employeeArray.remove(empObj)
        }
        employeeArray.removeAllObjects()
        selectedEmployeeArray.removeAllObjects()
        SubstituteEmpChecked = "0"
        DispatchQueue.main.async(execute: { () -> Void in
            self.empTableView.reloadData()
            self.tableView.reloadData()
        })
        
    }
    
    
    /////start
    @objc func moveUpBtnTapped(sender: UIButton){
        if selectedEmployeeArray == employeeArray{
            //nothing to move up
        }else{
            
            var indexOfObj = -1
            
            let indexArray = NSMutableArray()
            for e in selectedEmployeeArray{
                let  eObj:NewEmployee = e as! NewEmployee
                let eObjCandID = eObj.CandidateId
                for emp in employeeArray{
                    let  empObj:NewEmployee = emp as! NewEmployee
                    let empObjCandID = empObj.CandidateId
                    if eObjCandID == empObjCandID{
                        indexOfObj = employeeArray.index(of: eObj)
                        if indexArray.contains(indexOfObj){}else{
                            indexArray.add(indexOfObj)}
                    }
                }
            }
            //            print(indexArray)
            
            let a = NSArray.init(array: indexArray)
            let sortedArray = a.ascendingArrayWithKeyValue(key: "")
            
            //            print(sortedArray)
            if sortedArray.contains(0){
                //if any element is on top no need to move up again
            }else{
                //decrease indexpath of array and reload tableview
                var index = -1
                for i  in sortedArray{
                    index = Int(String(describing: i))!
                    //                    print(index)
                    if index > 0 {
                        swap(&employeeArray[index], &employeeArray[index - 1])
                    }
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.empTableView.reloadData()
                    })
                }
            }
            
        }//end of else
        
    }
    @objc func moveDownBtnTapped(sender: UIButton){
        if selectedEmployeeArray == employeeArray{
            //nothing to move down
        }else{
            var indexOfObj = -1
            let indexArray = NSMutableArray()
            for e in selectedEmployeeArray{
                let  eObj:NewEmployee = e as! NewEmployee
                let eObjCandID = eObj.CandidateId
                for emp in employeeArray{
                    let  empObj:NewEmployee = emp as! NewEmployee
                    let empObjCandID = empObj.CandidateId
                    if eObjCandID == empObjCandID{
                        indexOfObj = employeeArray.index(of: eObj)
                        if indexArray.contains(indexOfObj){}else{
                            //                            print(indexOfObj)
                            indexArray.add(indexOfObj)}
                    }
                }
            }
            //            print(indexArray)
            
            let a = NSArray.init(array: indexArray)
            let sortedArray = a.discendingArrayWithKeyValue(key: "")
            
            //            print(sortedArray)
            
            if sortedArray.contains(employeeArray.count - 1){
                //if any element is on down no need to move down again
            }else{
                //increase indexpath of array and reload tableview
                var index = -1
                for i  in sortedArray{
                    index = Int(String(describing: i))!
                    //                    print(index)
                    if employeeArray.count - 1 > index {
                        swap(&employeeArray[index], &employeeArray[index + 1])
                    }
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.empTableView.reloadData()
                    })
                }
            }
            
        }//end of else
    }
    
    @objc func clearEntryBtnTapped(sender: UIButton){
        
        
        for emp in selectedEmployeeArray {
            
            let  empObj:NewEmployee = emp as! NewEmployee
            
            if employeeArray.contains(empObj){
                empObj.isCheckedInRoaster = "0"
                empObj.isSelected = "0"
                employeeArray.remove(empObj)
            }
        }
        
        selectedEmployeeArray.removeAllObjects()
        if employeeArray.count == 0{
            SubstituteEmpChecked = "0"
        }
        DispatchQueue.main.async(execute: { () -> Void in
            self.empTableView.reloadData()
        })
        //        self.reloadTableViewRow(sender: sender)
        
    }
    @objc func searchBtnTapped(sender: UIButton)  {
        
        if selectedPositionType.PositionName?.count == 0{
            isValidPosition = false
            
        }else{
            isValidPosition = true
            
        }
        
        if JobTitleValue.count == 0{
            isValidJobTitle = false
        }else{
            isValidJobTitle = true
            isValidPosition = true
        }
        
        
        if selectedReportTo.Name!.count == 0{
            isValidReportTo = false
        }else{
            isValidReportTo = true
            
        }
        if TempEmployeesNeeded == 0{
            isValidEmployeeNeeded = false
        }else{
            isValidEmployeeNeeded = true
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.reloadData()
        })
        
        if isValidReportTo == true && isValidEmployeeNeeded == true && isValidPosition == true {
            self.getHospitalitySearchedEmployee()
            
            
            
        }else{
            //            self.ShowAlertMessage(message: "Please Select Required Field", title: "")
            isWarningMessage = false
            isErrorMessage = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Please select required fields", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
            
        }
        
    }
    @objc func includeWeekendBtnTapped(sender: UIButton){
        if sender.isSelected == true{
            sender.isSelected = false
            IncludeWeekend = "false"
        }else{
            sender.isSelected = true
            IncludeWeekend = "true"
        }
        //        self.reloadTableViewRow(sender: sender)
        
        let senderPosition  = sender.convert(CGPoint.zero, to: self.tableView)
        
        let indexPath =  self.tableView.indexPathForRow(at:senderPosition)
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.tableView.reloadRows(at: [indexPath!], with: .none)
        })
        //        self.tableView.reloadData()
        
    }
    
    @objc func SubstitueEmpBtnTapped(sender: UIButton){
        
        if SubstituteEmpChecked == "0"{
            sender.isSelected = true
            SubstituteEmpChecked = "1"
        }else{
            sender.isSelected = false
            SubstituteEmpChecked = "0"
            
        }
        //        self.reloadTableViewRow(sender: sender)
        let senderPosition  = sender.convert(CGPoint.zero, to: self.tableView)
        
        let indexPath =  self.tableView.indexPathForRow(at:senderPosition)
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.tableView.reloadRows(at: [indexPath!], with: .none)
        })
    }
    
    @objc func keyboardDoneBtnTapped(sender: UIButton)  {
        self.view.endEditing(true)
    }
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0{
            selectedSementTag = 0
            segHeader = HeaderName
        }else{
            selectedSementTag = 1
            segHeader = SelectedHeaderName
            
        }
        isTimeDataReloaded = "0"
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.reloadData()
        })
        
    }
    //MARK: Delegates
    
    @objc func clearStartTimeBtnTapped(sender: UIButton){
        
        firstResponderTxtFieldTag = sender.tag
        
        
        //Time
        if selectedSementTag == 1{
            self.updateDatesFromPicker(dateString: "", forArray: multiDayDataArray)
            //multi schdule array
        }else{
            //schdule array
            self.updateDatesFromPicker(dateString: "", forArray: dataArray)
        }
        let senderPosition  = sender.convert(CGPoint.zero, to: self.tableView)
        
        let indexPath =  self.tableView.indexPathForRow(at:senderPosition)
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.reloadRows(at: [indexPath!], with: .none)
        })
    }
    @objc func clearEndTimeBtnTapped(sender: UIButton){
        
        firstResponderTxtFieldTag = sender.tag
        //Time
        if selectedSementTag == 1{
            self.updateDatesFromPicker(dateString: "", forArray: multiDayDataArray)
            //multi schdule array
        }else{
            //schdule array
            self.updateDatesFromPicker(dateString: "", forArray: dataArray)
        }
        
        let senderPosition  = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath =  self.tableView.indexPathForRow(at:senderPosition)
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.reloadRows(at: [indexPath!], with: .none)
        })
    }
    //MARK: Server Call
    func validateCreateOrderData(){
        
        print(createOrderObj)
        
        let urlString = RestAPI.BaseUrl+RestAPI.OfficeCreateOrderValidationURL
        //        JustHUD.shared.showInView(view: view)
        self.showLoading()
        RestAPI.postRequestWithToken(urlString: urlString, params: createOrderObj, callback: getResponseForValidateCreateOrder(response:))
        
    }
    func getResponseForValidateCreateOrder(response:AnyObject)->()
    {
        
        //        JustHUD.shared.hide()
        self.hideLoading()
        
        print(response)
        if response is String{
            //            lblNoData.isHidden = false
            //            self.ShowAlertMessage(message: response as! String, title: "")
            isWarningMessage = false
            isErrorMessage = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                
                //                let continueMessage = object["Message"].stringValue
                //                if continueMessage == "Some of the hours entered is 6 or more than 6 hours without 30 min break. Are u sure you want to continue?"{
                //
                //                    isWarningMessage = true
                //                    isErrorMessage = false
                //
                //                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: continueMessage, okBtnTitle: "OK", cancelBtnTitle: "Cancel", type: Danger_Text, isAttributed: false)
                //
                //                }else{
                //                    self.pushToOrderSummaryPage()
                //                }
                
                let continueMessage = object["Message"].stringValue
                let WarningMessage =  object["WarningMessage"].stringValue
                
                if WarningMessage.count == 0{
                    self.pushToOrderSummaryPage()
                }else{
                    
                    isWarningMessage = true
                    isErrorMessage = false
                    
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: continueMessage, okBtnTitle: "OK", cancelBtnTitle: "Cancel", type: Danger_Text, isAttributed: false)
                }
                
                
                
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                isWarningMessage = false
                isErrorMessage = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
            
        }
        
    }
    func getSearchedEmpResponse(response:AnyObject)->()
    {
        
        //        JustHUD.shared.hide()
        self.hideLoading()
        print(response)
        if response is String{
            //            lblNoData.isHidden = false
            //            self.ShowAlertMessage(message: response as! String, title: "")
            isWarningMessage = false
            isErrorMessage = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                let empArray = object["SearchList"].array
                let empDataArray = NSMutableArray()
                if empArray != nil{
                    
                    for dict in empArray! {
                        
                        let Weekly_Hours = String(format:"%.2f",dict["WeeklyHours"].doubleValue)
                        let YTD_Hours = String(format:"%.2f",dict["YTDHours"].doubleValue)
                        let Eval = String(format:"%d",dict["Eval"].intValue)
                        
                        let empObj = NewEmployee.init(CandidateId: dict["CandidateId"].intValue, Name: dict["Name"].stringValue, lastDate: dict["LastOrderDate"].stringValue, Weekly_Hours: Weekly_Hours, positions: dict["Position"].stringValue, Eval: Eval, YTD_Hours: YTD_Hours, isCheckedInRoaster:  "0",isSelected: "0",Photo: dict["Photo"].stringValue,Evaluation: dict["Evaluation"].doubleValue,DummyImagePath:dict["DummyImagePath"].stringValue,isfavourite:dict["isfavourite"].intValue,favColor:dict["FavoriteColor"].stringValue)
                        
                        empDataArray.add(empObj)
                    }
                }
                
                ResponseEmployeeArray =  empDataArray
                
                if empDataArray.count == 0{
                    //                    self.ShowAlertMessage(message: "No employee found", title: "")
                    isWarningMessage = false
                    isErrorMessage = false
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "No employees found", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                    
                }else{
                    //push to employee list screen
                    self.pushToSearchEmpListPage(dataArray: empDataArray)
                }
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                isWarningMessage = false
                isErrorMessage = false
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
    }
    func getHospitalitySearchedEmployee(){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            //            JustHUD.shared.showInView(view: view)
            self.showLoading()
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            
            let stringArray = selectedPositionType.KeyValue?.components(separatedBy: "|")
            //String(format:"%@",selectedPositionType.KeyValue!)
            var position = ""
            var profileId = ""
            if stringArray?.count == 2 {
                position = stringArray![0]
                profileId = stringArray![1]
            }
            
            
            IsCheckAllowOT = "true"
            
            let params :[String:String] = ["position" : position ,"profileId": profileId , "clientId" : clientID ,"startDate" : StartDate, "endDate" : EndDate,"allowOT":"1","noOfOrders":String(format:"%d",TempEmployeesNeeded),"sortBy":"1"]
            
            /*
             {
             "clientId" : 70825,
             "startDate":"07/30/2018",
             "endDate":"07/30/2018",
             "startTime":"07:00 AM",
             "endTime":"02:00 PM",
             "noOfOrders":1,
             "sortBy":1,
             "position":"1405",
             "profileId":"12104",
             "allowOT":1
             }
             
             */
            
            print(params)
            
            RestAPI.OfficeGetSearchEmployee(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getSearchedEmpResponse(response:))
        }else{
            //            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
            isWarningMessage = false
            isErrorMessage = false
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
            //            self.ShowAlertMessage(ErrorMessage: "No Internet Connection", titleMessage: "", view: self)
            
        }
    }
    func getROSData() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            //            JustHUD.shared.showInView(view: view)
            self.showLoading()
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            //            let DivisionId = String(format:"%d", defaults.integer(forKey: "DivisionId"))
            let params :[String:String] = ["ClientId" : clientID]
            print(params)
            RestAPI.getROSOfficeOrderData(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getROSResponse(response:))
        }else{
            
            //            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
            isErrorMessage = false
            isWarningMessage = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    func getROSResponse(response:AnyObject)->()
    {
        
        //        JustHUD.shared.hide()
        
        self.hideLoading()
        print(response)
        if response is String{
            //            lblNoData.isHidden = false
            var message = response as! String
            if message.count == 0 {
                message = Error_Message
            }
            
            //            let alert = UIAlertController(title:"", message: message, preferredStyle: UIAlertControllerStyle.alert)
            //            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:  {(alert) in
            //
            //                self.navigationController?.popViewController(animated: true)
            //            }))
            //            self.present(alert, animated: true, completion: nil)
            isWarningMessage = false
            isErrorMessage = true
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                let orderDataArray = NSMutableArray()
                
                orderDataArray .removeAllObjects()
                if object["ReportsList"] .null == nil{
                    
                    let reportToDataArray = object["ReportsList"].array // as! NSMutableArray
                    for dict in reportToDataArray! {
                        
                        let posType = ReportTo.init(ContactId: dict["ReportId"].intValue,Name: dict["ReportToName"].stringValue,isSelected: "0" )
                        reportToArray.add(posType)
                    }
                    
                }
                
                if object["ReportLocationList"].null == nil{
                    let reportToLocDataArray  = object["ReportLocationList"].array  //as! NSMutableArray
                    
                    for dict in reportToLocDataArray! {
                        let reportoLocName = OfficeReportToLocation.init(ReportToName: dict["ReportToName"].stringValue, ReportId: String(format:"%d",dict["ReportId"].intValue),isSelected: "")
                        reportToLocArray.add(reportoLocName)
                    }
                    
                }
                
                
                if object["PositionsList"].null == nil{
                    
                    let positionsDataArray = object["PositionsList"].array // as! NSMutableArray
                    for dict in positionsDataArray! {
                        
                        let posType = HOSPositionType.init(KeyValue: dict["PositionProfileId"].stringValue,PositionName: dict["Description"].stringValue ,isSelected: "0")
                        positionArray.add(posType)
                    }
                    
                }
                if object["ReasonForPositionList"].null == nil{
                    
                    let reasonForPositionDataArray = object["ReasonForPositionList"].array
                    
                    for dict in reasonForPositionDataArray! {
                        
                        let posType = HOSPositionType.init(KeyValue: dict["ReasonId"].stringValue,PositionName: dict["ReasonDescription"].stringValue ,isSelected: "0")
                        ReasonForPositionArray.add(posType)
                    }
                }
                
                if object["MealBreakMin"].null == nil{
                    let mealBreakMinDataArray = object["MealBreakMin"].array
                    for dict in mealBreakMinDataArray! {
                        let mealBreakMin = MealBreakMin.init(Text: dict["Text"].stringValue, Value: dict["Value"].stringValue,isSelected: "0")
                        MealBreakMinArray.add(mealBreakMin)
                    }
                    
                }
                
                SelectedHeaderName  = object["HeaderName"].stringValue
                if object["Interval"].null == nil{
                    minuteInterval = Int(object["Interval"].stringValue)!
                    
                }else{
                    minuteInterval = 30
                }
                HeaderName  = object["SeletedHeaderName"].stringValue
                segHeader = HeaderName
                //                StartDate = self.getFormattedDate(string: (object["StartDate"].stringValue))
                //                EndDate = self.getFormattedDate(string: (object["EndDate"].stringValue))
                
                if MealBreakMinArray.count > 0{
                    selectedMealBreakTime = MealBreakMinArray[0] as! MealBreakMin
                    defaultMealBreakTime = selectedMealBreakTime.Text!
                }
                StartDate = object["StDate"].stringValue
                EndDate = object["EdDate"].stringValue
                self.formDataArrayForTableview()
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = "There is some error while geeting data"
                    
                }
                //                let alert = UIAlertController(title:"", message: message, preferredStyle: UIAlertControllerStyle.alert)
                //                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:  {(alert) in
                //                    //pop to dashboard page
                //                    self.navigationController?.popViewController(animated: true)
                //                }))
                //                self.present(alert, animated: true, completion: nil)
                
                isWarningMessage = false
                isErrorMessage = true
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }
    }
    
    //MARK: Local Methods
    //    func getTimeDifference(date: Date, date2: Date) -> String{
    //
    //        let difference = Calendar.current.dateComponents([.hour, .minute], from: date, to: date2)
    //        let formattedString = String(format: "%02ld%02ld", difference.hour!, difference.minute!)
    //        print(formattedString)
    //
    //        return formattedString
    //    }
    
    func getTimeDifference(date1: String, date2: String,breakValue: String) -> String{
        if date1.count > 0 && date2.count > 0 {
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.preferredLocale()
            dateFormatter.dateFormat = "hh:mm a"
            let date3 = dateFormatter.date(from: date1)
            let date4 = dateFormatter.date(from: date2)
            
            let interval1 = date4?.timeIntervalSince(date3!)
            let interval = Int(interval1!)
            //        print(interval)
            var minutes = (interval / 60) % 60
            var hours = (interval / 3600)
            if hours < 0 {
                hours = 24 + hours // 24 + (-2)
            }
            if minutes == 30{
                minutes = 50
            }
            let timeString = String(format: "%02d.%02d", hours, abs(minutes))
            
            var time = Double(timeString)
            var timeDiff = ""
            
            
            if breakValue == "00"{
                time = time! - 00
            }else if breakValue == "30"{
                if minutes > 0 || hours > 0{
                    time = time! - 0.50
                }
            }else if breakValue == "45"{
                if minutes > 30 || hours > 0{
                    time = time! - 0.75
                }
            }else if breakValue == "60"{
                if minutes > 45 || hours > 0{
                    time = time! - 1.00
                }
            }
            
            timeDiff = String(format:"%.2f", time!)
            
            return timeDiff
            
        }
        return ""
    }
    func getProfileCommentsResponse(response:AnyObject){
        self.hideLoading()
        print(response)
        if response is String{
            var message = response as! String
            if message.count == 0 {
                message = Error_Message
            }
            isWarningMessage = false
            isErrorMessage = true
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            var object = response as! JSON
            if object["MessageStatus"].intValue == 1
            {
                jobDescText = object["Comments"].stringValue
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tableView.reloadData()
                })
            }else{
                var message = object["Message"].stringValue
                if message.count == 0 {
                    message = "There is some error while geeting data"
                }
                isWarningMessage = false
                isErrorMessage = true
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
        
    }
    
    func getProfileCommentsServerCall(){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            self.showLoading()
            
            let profileID  = selectedPositionType.KeyValue
            
            let params :[String:String] = ["selectedProfileId" : profileID! ]
            
            print(params)
            
            RestAPI.OfficeGetProfileComments(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getProfileCommentsResponse(response:))
        }else{
            isWarningMessage = false
            isErrorMessage = false
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
            
        }
    }
    func formOrderSummaryData() -> NSMutableArray{
        
        var summaryDataArray = NSMutableArray()
        let employeeNameArray = NSMutableArray()
        
        
        for obj in employeeArray{
            let eObj:NewEmployee = (obj as? NewEmployee)!
            let name = eObj.Name
            employeeNameArray.add(name!)
        }
        
        var includeWeekEndValue = "No"
        if IncludeWeekend == "true"{
            includeWeekEndValue = "Yes"
        }
        var PositionTypeName = ""
        if selectedPositionType.isSelected == "1"{
            PositionTypeName = selectedPositionType.PositionName!
        }
        let positionDict = ["Header":"Position","Value":PositionTypeName]
        let jobTitleDict = ["Header":"Job Title","Value":JobTitleValue]
        
        let ReasonForPositionDict = ["Header":"Reason For Position ","Value":selectedReasonForPosition.PositionName]
        let rtLocationDict =  ["Header":"Report To Location","Value":selectedReportToLoc.ReportToName]
        let reportToDict =  ["Header":"Report To","Value":selectedReportTo.Name]
        let EmployeesNeededDict =  ["Header":"No. of employees needed","Value":String(format:"%d",TempEmployeesNeeded)]
        let startDateDict =  ["Header":"Start Date","Value":StartDate]
        let endDateDict =  ["Header":"End Date","Value":EndDate]
        let startTimeDict =  ["Header":"Start Time","Value":StartTime]
        let endTimeDict =  ["Header":"End Time","Value":EndTime]
        let includeWeekendDict = ["Header":"Include Weekend","Value":includeWeekEndValue]
        
        let jobDutyDict = ["Header":"Job Duties/Responsibilities","Value":jobDutyText]
        let jobDescDict = ["Header":"Job Description","Value":jobDescText]
        let selectedEmpDict =  ["Header":"Selected Employee(s)","Value":employeeNameArray.map({ String(describing: $0) }).joined(separator: ", ")]
        
        
        let empCommentsDict =  ["Header":"Additional Comments for Employees","Value":empCommentText]
        let divCommentsDict =  ["Header":"Comments for TemPositions internal staff only","Value":divisionCommentText]
        
        
        let MondayTime =    String(format:"Monday        : %@ - %@",MondayStartTime,MondayEndTime)
        let TuesdayTime = String(format:"\nTuesday       : %@ - %@",TuesdayStartTime,TuesdayEndTime)
        let WednesdayTime =   String(format:"\nWednesday : %@ - %@",WednesdayStartTime,WednesdayEndTime)
        let ThursdayTime =    String(format:"\nThursday     : %@ - %@",ThursdayStartTime,ThursdayEndTime)
        let FridayTime =  String(format:"\nFriday          : %@ - %@",FridayStartTime,FridayEndTime)
        let SaturdayTime =    String(format:"\nSaturday     : %@ - %@",SaturdayStartTime,SaturdayEndTime)
        let SundayTime =  String(format:"\nSunday       : %@ - %@",SundayStartTime,SundayEndTime)
        
        
        let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
        if selectedSementTag == 0{
            
            if DivisionId == "2"{
                summaryDataArray = [positionDict,jobTitleDict,ReasonForPositionDict,rtLocationDict,reportToDict,EmployeesNeededDict,startDateDict,endDateDict,startTimeDict,endTimeDict,includeWeekendDict,jobDutyDict,jobDescDict,selectedEmpDict,empCommentsDict,divCommentsDict]
                
            }else{
                summaryDataArray = [positionDict,jobTitleDict,ReasonForPositionDict,rtLocationDict,reportToDict,EmployeesNeededDict,startDateDict,endDateDict,startTimeDict,endTimeDict,includeWeekendDict,jobDescDict,selectedEmpDict,empCommentsDict,divCommentsDict]
            }
        }else{
            var weekDayStartEndTime = ""
            
            
            if MondayStartTime.count == 0 && MondayEndTime.count == 0{
            }else{
                weekDayStartEndTime = MondayTime
            }
            
            if TuesdayStartTime.count == 0 && TuesdayEndTime.count == 0{
            }else{
                weekDayStartEndTime += TuesdayTime
            }
            
            if WednesdayStartTime.count == 0 && WednesdayEndTime.count == 0{
            }else{
                weekDayStartEndTime += WednesdayTime
            }
            
            if ThursdayStartTime.count == 0 && ThursdayEndTime.count == 0{
            }else{
                weekDayStartEndTime += ThursdayTime
            }
            
            if FridayStartTime.count == 0 && FridayEndTime.count == 0{
            }else{
                weekDayStartEndTime += FridayTime
            }
            
            if SaturdayStartTime.count == 0 && SaturdayEndTime.count == 0{
            }else{
                weekDayStartEndTime += SaturdayTime
            }
            
            
            if SundayStartTime.count == 0 && SundayEndTime.count == 0{
            }else{
                weekDayStartEndTime += SundayTime
            }
            let TimeDict =  ["Header":"Time","Value":weekDayStartEndTime]
            
            //            summaryDataArray = [positionDict,ReasonForPositionDict,rtLocationDict,reportToDict,EmployeesNeededDict,startDateDict,endDateDict,TimeDict,includeWeekendDict,jobDutyDict,jobDescDict,selectedEmpDict,empCommentsDict,divCommentsDict]
            
            if DivisionId == "2"{
                summaryDataArray = [positionDict,jobTitleDict,ReasonForPositionDict,rtLocationDict,reportToDict,EmployeesNeededDict,startDateDict,endDateDict,TimeDict,includeWeekendDict,jobDutyDict,jobDescDict,selectedEmpDict,empCommentsDict,divCommentsDict]
                
            }else{
                summaryDataArray = [positionDict,jobTitleDict,ReasonForPositionDict,rtLocationDict,reportToDict,EmployeesNeededDict,startDateDict,endDateDict,TimeDict,includeWeekendDict,jobDescDict,selectedEmpDict,empCommentsDict,divCommentsDict]
            }
            
        }
        return summaryDataArray
    }
    func createOrderAPICall(){
        
        let defaults = UserDefaults.standard
        
        let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
        let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
        let UserName  = String(format:"%d", defaults.string(forKey: "UserName")!)
        
        let employeeNameArray = NSMutableArray()
        let employeeIDArray = NSMutableArray()
        
        
        for obj in employeeArray{
            let eObj:NewEmployee = (obj as? NewEmployee)!
            let name = eObj.Name
            employeeNameArray.add(name!)
            employeeIDArray.add(String(format:"%d",eObj.CandidateId!))
        }
        
        var IsShiftAvailable = "0"
        if selectedSementTag == 1{
            IsShiftAvailable = "1"
        }
        
        let HdSearchEmployee = employeeNameArray.map({ String(describing: $0) }).joined(separator: "|")
        let selectedEmployeeIds = employeeIDArray.map({ String(describing: $0) }).joined(separator: ",")
        var positionTypeName = ""
        var positionTypeKeyValue = ""
        
        if selectedPositionType.isSelected == "1"{
            positionTypeName = selectedPositionType.PositionName!
            positionTypeKeyValue = selectedPositionType.KeyValue!
        }
        
        if selectedSementTag == 0{
            if MealBreakTime.count == 0{
                MealBreakTime = "00"
            }
            createOrderObj =
                ["ClientID" : clientID,
                 "DivisionId" : DivisionId,
                 "OrderSourceName" : "iOS",
                 "EndDate" : EndDate,
                 "EndTime" : EndTime,
                 "ContactId" : ContactId,
                 "includeWeekend" : IncludeWeekend,
                 "HdSearchEmployee": HdSearchEmployee,
                 "PositionName" : positionTypeName,
                 "PositionId" : positionTypeKeyValue,
                 "EmployeeComments" : empCommentText,
                 "ReportLocation" : selectedReportToLoc.ReportToName!,
                 "ReportTo" : selectedReportTo.Name!,
                 "SelectedEmployees" : employeeIDArray,//selectedEmployeeIds,
                    "StartDate" : StartDate,
                    "StartTime" : StartTime,
                    "EmployeesNeeded" : TempEmployeesNeeded,
                    "HeaderName" : segHeader,
                    "IsShiftAvailable": IsShiftAvailable,
                    "ReasonForPositionId": selectedReasonForPosition.KeyValue!,
                    "JobDuties":jobDutyText,
                    "JobDescription":jobDescText,
                    "StaffComments":divisionCommentText,
                    "MealBreak": MealBreakTime,
                    "JobTitle": JobTitleValue,
                    "ReportLocationId":selectedReportToLoc.ReportId!
                ] as [String : Any] as NSDictionary
            
        }else{
            for dict in multiDayDataArray {
                //                print(dict)
                let dictObj:NSDictionary = dict as! NSDictionary
                if dictObj["StartTag"] != nil{
                    
                    let startTag = dictObj["StartTag"] as! String
                    let endTag = dictObj["EndTag"] as! String
                    var breakTimeTag = ""
                    if dictObj["breakTag"] != nil{
                        breakTimeTag = dictObj["breakTag"] as! String
                    }
                    
                    
                    var day = ""
                    if dictObj["day"] != nil{
                        day = dictObj["day"] as! String
                    }
                    
                    let StartValue = dictObj["StartValue"] as! String
                    let EndValue = dictObj["EndValue"] as! String
                    var breakTimeValue = ""
                    if dictObj["breakTag"] != nil{
                        breakTimeValue = dictObj["BreakValue"] as! String
                    }
                    
                    if startTag == SunStartTxtFieldTag && day == "SUN" {
                        SundayStartTime = StartValue
                        
                    }
                    if startTag == MonStartTxtFieldTag && day == "MON" {
                        MondayStartTime = StartValue
                        
                    }
                    if breakTimeTag == MonBreakTxtFieldTag && day == "MON" {
                        MondayBreakTime = breakTimeValue
                        
                    }
                    if startTag == TueStartTxtFieldTag && day == "TUE"{
                        TuesdayStartTime = StartValue
                        
                    }
                    if breakTimeTag == TueBreakTxtFieldTag && day == "TUE" {
                        TuesdayBreakTime = breakTimeValue
                        
                    }
                    if startTag == WedStartTxtFieldTag && day == "WED"{
                        WednesdayStartTime = StartValue
                    }
                    if breakTimeTag == WedBreakTxtFieldTag && day == "WED" {
                        WednesdayBreakTime = breakTimeValue
                        
                    }
                    if startTag == ThuStartTxtFieldTag && day == "THU"{
                        ThursdayStartTime = StartValue
                        
                    }
                    if breakTimeTag == ThuBreakTxtFieldTag && day == "THU" {
                        ThursdayBreakTime = breakTimeValue
                        
                    }
                    if startTag == FriStartTxtFieldTag && day == "FRI"{
                        FridayStartTime = StartValue
                        
                    }
                    if breakTimeTag == FriBreakTxtFieldTag && day == "FRI" {
                        FridayBreakTime = breakTimeValue
                        
                    }
                    if startTag == SatStartTxtFieldTag && day == "SAT"{
                        SaturdayStartTime = StartValue
                        
                    }
                    if breakTimeTag == SatBreakTxtFieldTag && day == "SAT" {
                        SaturdayBreakTime = breakTimeValue
                        
                    }
                    if  day == "SUN" && endTag == SunEndTxtFieldTag{
                        SundayEndTime = EndValue
                        
                    }
                    if breakTimeTag == SunBreakTxtFieldTag && day == "SUN" {
                        SundayBreakTime = breakTimeValue
                        
                    }
                    if   day == "MON" && endTag == MonEndTxtFieldTag{
                        MondayEndTime = EndValue
                        
                    }
                    
                    if   day == "TUE" && endTag == TueEndTxtFieldTag{
                        TuesdayEndTime = EndValue
                        
                    }
                    if   day == "WED" && endTag == WedEndTxtFieldTag{
                        WednesdayEndTime = EndValue
                    }
                    if   day == "THU" && endTag == ThuEndTxtFieldTag{
                        ThursdayEndTime = EndValue
                        
                    }
                    if   day == "FRI" && endTag == FriEndTxtFieldTag{
                        FridayEndTime = EndValue
                        
                    }
                    if day == "SAT" && endTag == SatEndTxtFieldTag{
                        SaturdayEndTime = EndValue
                        
                    }
                }
            }
            
            createOrderObj =
                ["ClientID" : clientID,
                 "DivisionId" : DivisionId,
                 "ContactId" : ContactId,
                 "OrderSourceName" : "iOS",
                 "EndDate" : EndDate,
                 "OrderSource": "iOS",
                 "JobTitle": JobTitleValue,
                 "HdSearchEmployee": HdSearchEmployee,
                 "includeWeekend" : IncludeWeekend,
                 "PositionName" : positionTypeName,
                 "PositionId" : positionTypeKeyValue,
                 "EmployeeComments" : empCommentText,
                 "ReportLocation" : selectedReportToLoc.ReportToName!,
                 "ReportTo" : selectedReportTo.Name!,
                 "SelectedEmployees" : employeeIDArray,
                 "StartDate" : StartDate,
                 "EmployeesNeeded" : TempEmployeesNeeded,
                 "HeaderName" : segHeader,
                 "IsShiftAvailable": IsShiftAvailable,
                 "ReasonForPositionId": selectedReasonForPosition.KeyValue!,
                 "JobDuties":jobDutyText,
                 "JobDescription":jobDescText,
                 "StaffComments":divisionCommentText,
                 "MondayStartTime" : MondayStartTime,
                 "MondayEndTime" : MondayEndTime,
                 "MonMealBreak": MondayBreakTime,
                 "TuesdayStartTime" : TuesdayStartTime,
                 "TuesdayEndTime" : TuesdayEndTime,
                 "TueMealBreak" : TuesdayBreakTime,
                 "WednesdayStartTime" : WednesdayStartTime,
                 "WednesdayEndTime" : WednesdayEndTime,
                 "WedMealBreak" : WednesdayBreakTime,
                 "ThursdayStartTime" : ThursdayStartTime,
                 "ThursdayEndTime" : ThursdayEndTime,
                 "ThuMealBreak" : ThursdayBreakTime,
                 "FridayStartTime" : FridayStartTime,
                 "FridayEndTime" : FridayEndTime,
                 "FriMealBreak" : FridayBreakTime,
                 "SaturdayStartTime" : SaturdayStartTime,
                 "SaturdayEndTime" : SaturdayEndTime,
                 "SatMealBreak" : SaturdayBreakTime,
                 "SundayStartTime" : SundayStartTime,
                 "SundayEndTime" : SundayEndTime,
                 "SunMealBreak" : SundayBreakTime,
                 "ReportLocationId":selectedReportToLoc.ReportId!
                ] as [String : Any] as NSDictionary
        }
        
        self.validateCreateOrderData()
        
        
    }
    func validateData() -> Bool{
        
        if selectedReportToLoc.ReportToName?.count == 0{
            isValidReportToLocation = false
        }else{
            isValidReportToLocation = true
            
        }
        if selectedReportTo.Name!.count == 0{
            
            isValidReportTo = false
        }else{
            isValidReportTo = true
            
        }
        if selectedReasonForPosition.PositionName?.count == 0{
            isValidReasonForPosition = false
        }else{
            isValidReasonForPosition = true
        }
        if selectedPositionType.PositionName?.count == 0{
            isValidPosition = false
            
        }else{
            isValidPosition = true
            
        }
        if TempEmployeesNeeded == 0{
            isValidEmployeeNeeded = false
        }else{
            isValidEmployeeNeeded = true
            
        }
        if jobDescText.count > 0{
            isValidJobDesc = true
            
        }else{
            isValidJobDesc = false
            
        }
        if JobTitleValue.count == 0{
            isValidJobTitle = false
        }else{
            isValidJobTitle = true
            isValidPosition = true
            
        }
        let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
        if DivisionId == "2"{
            
            if jobDutyText.count > 0{
                isValidJobDuty = true
            }else{
                isValidJobDuty = false
            }
        }else{
            isValidJobDuty = true
            jobDutyText = ""
            
        }//76121
        if selectedSementTag == 0{
            
            if EndTime.count == 0{
                isValidEndTime = false
            }else{
                isValidEndTime = true
            }
            if StartTime.count == 0{
                isValidStartTime = false
            }else{
                isValidStartTime = true
            }
        }else{
            isValidEndTime = true
            
            isValidStartTime = true
        }
        
        if isValidReportToLocation ==  true && isValidReportTo ==  true && isValidPosition ==  true && isValidEmployeeNeeded ==  true && isValidStartTime == true && isValidEndTime == true && isValidJobDuty == true && isValidJobDesc == true && isValidJobTitle == true{
            
            allDataValidated = true
        }else {
            //            listTableView.setContentOffset(CGPoint.zero, animated: true)
            
            allDataValidated = false
        }
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.reloadData()
        })
        return allDataValidated
        
    }
    func showDropDownWithTag( placeHolder: String,tag: Int){
        let modelName = UIDevice.current.modelName
        self.view.endEditing(true)
        
        if modelName.contains("iPad") //||  modelName.contains("Simulator")
        {
            DispatchQueue.main.async(execute: { () -> Void in
                let vc = UIViewController()
                vc.view.isUserInteractionEnabled = true
                vc.preferredContentSize = CGSize(width: 250,height: 240)
                
                let margin = 8
                
                let rect = CGRect(x: margin, y: 0, width: 240, height: 230)
                
                let alertTableView = UITableView(frame: rect)
                
                alertTableView.tableFooterView = UIView()
                alertTableView.frame = rect
                alertTableView.delegate = self
                alertTableView.dataSource = self
                alertTableView.tag = tag
                alertTableView.backgroundColor = UIColor.clear
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    alertTableView.reloadData()
                })
                vc.view.addSubview(alertTableView)
                
                self.alrtController = UIAlertController(title:placeHolder, message: nil, preferredStyle:
                    UIAlertController.Style.alert)
                self.alrtController.setValue(vc, forKey: "contentViewController")
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: {
                    (alert: UIAlertAction!) in
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        self.tableView.reloadData()
                    })
                })
                self.alrtController.addAction(okAction)
                
                self.present(self.alrtController, animated: true, completion: nil)
            })
            
        }else{
            
            alrtController = UIAlertController(title: placeHolder, message: "", preferredStyle: UIAlertController.Style.actionSheet)
            let alertHeight =  300 //self.view.frame.height * 0.80
            
            let margin = 8
            
            var rect = CGRect(x: margin, y: 50, width: Int(alrtController.view.bounds.size.width - 35), height: alertHeight  - 120)
            let  alertTableView = UITableView(frame: rect)
            
            if modelName.contains("iPad") {
                let defaultAction = UIAlertAction(title: "", style: .default, handler: nil)
                let deleteAction = UIAlertAction(title: "", style: .default, handler:nil)
                let deleteAction1 = UIAlertAction(title: "", style: .default, handler:nil)
                let deleteAction2 = UIAlertAction(title: "", style: .default, handler:nil)
                let deleteAction3 = UIAlertAction(title: "", style: .default, handler:nil)
                
                self.alrtController.addAction(defaultAction)
                self.alrtController.addAction(deleteAction)
                self.alrtController.addAction(deleteAction1)
                self.alrtController.addAction(deleteAction2)
                self.alrtController.addAction(deleteAction3)
                
                rect = CGRect(x: 0, y: 45, width: alrtController.view.bounds.size.width - 30, height: 285)
                
                
            }
            alertTableView.tableFooterView = UIView()
            alertTableView.frame = rect
            alertTableView.delegate = self
            alertTableView.dataSource = self
            alertTableView.tag = tag
            alertTableView.backgroundColor = UIColor.clear
            alrtController.view.clipsToBounds = true
            alrtController.view.addSubview(alertTableView)
            DispatchQueue.main.async(execute: { () -> Void in
                alertTableView.reloadData()
            })
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: {
                (alert: UIAlertAction!) in
                self.tableView.reloadData()
            })
            
            alrtController.addAction(okAction)
            if modelName.contains("iPad") {
                alrtController.modalPresentationStyle = .popover
                
                if let popoverController = alrtController.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
                    popoverController.permittedArrowDirections = []
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.present(self.alrtController, animated: true, completion: nil)
                    })
                    
                }
            }else{
                let height:NSLayoutConstraint = NSLayoutConstraint(item: alrtController.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(alertHeight))
                alrtController.view.addConstraint(height);
                DispatchQueue.main.async(execute: { () -> Void in
                    self.present(self.alrtController, animated: true, completion:{})
                    
                })
            }
        }
        
    }
    func resetAllData(){
        
        selectedSementTag = 0
        
        reportToArray.removeAllObjects()
        reportToLocArray.removeAllObjects()
        positionArray.removeAllObjects()
        employeeArray.removeAllObjects()
        dataArray.removeAllObjects()
        ReasonForPositionArray.removeAllObjects()
        multiDayDataArray.removeAllObjects()
        selectedEmployeeArray.removeAllObjects()
        weekDayArray.removeAllObjects()
        MealBreakMinArray.removeAllObjects()
        
        
        selectedReportTo = ReportTo.init(ContactId: 0, Name: "",isSelected: "")
        selectedReportToLoc = OfficeReportToLocation.init(ReportToName: "",ReportId: "",isSelected: "")
        selectedPositionType = HOSPositionType.init(KeyValue: "",PositionName: "",isSelected: "" )
        selectedReasonForPosition = HOSPositionType.init(KeyValue: "",PositionName: "",isSelected: "" )
        selectedMealBreakTime = MealBreakMin.init(Text: "", Value: "", isSelected: "")
        
        
        TempEmployeesNeeded = 0
        empCommentText = ""
        sameDayHour = "0"
        multiDayHour = "0"
        divisionCommentText = ""
        jobDutyText = ""
        jobDescText = ""
        minuteInterval = 0
        JobTitleValue = ""
        self.formMultiDayArray()
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.reloadData()
            self.empTableView.reloadData()
        })
        
    }
    func updateDatesFromPicker(dateString: String,forArray: NSMutableArray){
        var indexOfObj = -1
        var placeholderheader = ""
        var indexOfTimeCalCell = -1
        
        //get the index of the object to replace
        if  selectedSementTag == 0{
            //Date
            if firstResponderTxtFieldTag == Int(StartDateTxtFieldTag) || firstResponderTxtFieldTag == Int(EndDateTxtFieldTag) {
                placeholderheader = StartDatePlaceHolder
            }
                
            else if  firstResponderTxtFieldTag == Int(StartTimeTxtFieldTag) || firstResponderTxtFieldTag == Int(EndTimeTxtFieldTag){
                
                placeholderheader = StartTimePlaceHolder
            }
            
        }else if selectedSementTag == 1{
            
            placeholderheader = "Start Time"
            
        }
        for dict in forArray{
            
            let   dictObj : NSDictionary = dict as! NSDictionary
            let headerValue = dictObj["header"] as! String
            
            if placeholderheader.count>0 && headerValue == placeholderheader {
                indexOfObj = forArray.index(of: dictObj)
                break
            }
        }
        for dict in forArray{
            
            let   dictObj : NSDictionary = dict as! NSDictionary
            let headerValue = dictObj["header"] as! String
            
            if placeholderheader.count>0 && headerValue == "Segment" {
                indexOfTimeCalCell = forArray.index(of: dictObj)
                break
            }
        }
        
        var isMatches = false
        if indexOfObj >= 0{
            let   dictObj : NSDictionary = forArray[indexOfObj] as! NSDictionary
            let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dictObj)
            
            let startTag = Int(mutableDictObj["StartTag"] as! String)
            let endTag = Int(mutableDictObj["EndTag"] as! String)
            
            if startTag == firstResponderTxtFieldTag {
                //once start date is changed ,end date should change change accordingly
                mutableDictObj["StartValue"] = dateString
                if  firstResponderTxtFieldTag == Int(StartTimeTxtFieldTag){
                    StartTime = dateString
                }else if    firstResponderTxtFieldTag == Int(StartDateTxtFieldTag){
                    StartDate = dateString
                }
                
                if EndDate.count == 0{}else{
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale.preferredLocale()
                    dateFormatter.dateFormat = dateFormat
                    let dateA = dateFormatter.date(from: StartDate)
                    let dateB = dateFormatter.date(from: EndDate)
                    switch dateA?.compare(dateB!) {
                        
                    case .orderedAscending?     :
                        print("Date A is earlier than date B")
                    case .orderedDescending?    :
                        print("Date A is later than date B")
                        
                        if selectedSementTag == 0{
                            mutableDictObj["EndValue"] = dateString
                            if   firstResponderTxtFieldTag == Int(EndDateTxtFieldTag){
                                EndDate = dateString
                            }else if   firstResponderTxtFieldTag == Int(EndTimeTxtFieldTag){
                                EndTime = dateString
                            }
                        }
                    case .orderedSame?          :
                        print("The two dates are the same")
                    case .none: break
                    }}
                isMatches = true
                
            }
            if endTag == firstResponderTxtFieldTag {
                mutableDictObj["EndValue"] = dateString
                isMatches = true
            }
            if isMatches ==  true {
                let sValue = mutableDictObj["StartValue"] as! String
                let eValue = mutableDictObj["EndValue"] as! String
                var breakValue = "0"
                if mutableDictObj["BreakValue"]  != nil{
                    
                    breakValue = mutableDictObj["BreakValue"] as! String
                }
                if  selectedSementTag == 0{
                    if  firstResponderTxtFieldTag == Int(StartTimeTxtFieldTag){
                        StartTime = sValue
                    }else if    firstResponderTxtFieldTag == Int(StartDateTxtFieldTag){
                        StartDate = sValue
                    }else if  firstResponderTxtFieldTag == Int(EndTimeTxtFieldTag){
                        EndTime = eValue
                    }else if    firstResponderTxtFieldTag == Int(EndDateTxtFieldTag){
                        EndDate = eValue
                    }
                    MealBreakTime = breakValue
                    //                    selectedMealBreakTime.Text!
                    if firstResponderTxtFieldTag == Int(StartDateTxtFieldTag) || firstResponderTxtFieldTag == Int(EndDateTxtFieldTag){
                    }else{
                        
                        if StartTime.count > 0 && EndTime.count > 0{
                            let diff = self.getTimeDifference(date1: StartTime, date2: EndTime,breakValue: breakValue)
                            sameDayHour = diff
                            isValidStartTime = true
                            isValidEndTime = true
                        }
                    }
                }else  if  selectedSementTag == 1{
                    
                    if firstResponderTxtFieldTag == Int(MonStartTxtFieldTag) || firstResponderTxtFieldTag == Int(MonEndTxtFieldTag){
                        MondayStartTime = sValue
                        MondayEndTime = eValue
                        MondayBreakTime = breakValue
                        self.updateTimeDiff()
                    }
                }
                
                forArray.replaceObject(at: indexOfObj, with: mutableDictObj)
                
                let indPath = IndexPath(row: indexOfObj, section: 0)
                
                DispatchQueue.main.async(execute: { () -> Void in
                    if indexOfTimeCalCell >= 0{
                        let timeCellIndPath = IndexPath(row: indexOfTimeCalCell, section: 0)
                        self.tableView.reloadRows(at: [indPath,timeCellIndPath], with: .none)
                        
                    }else{
                        self.tableView.reloadData()
                    }
                })
                
            }else{
                //                print("Did not matched")
                //Again Check with the tag
                self.updateWeeklyTimePickerValue(forArray: forArray, dateString: dateString)
            }
            //            self.tableView.reloadData()
            
        }
    }
    
    func updateWeeklyTimePickerValue(forArray: NSMutableArray,dateString: String){
        
        var indexOfObj = -1
        var indexOfTimeCalculationCell = -1
        
        for d in forArray{
            
            let   dObj : NSDictionary = d as! NSDictionary
            let placeholder = dObj["header"] as! String
            
            if placeholder == "Segment"{
                indexOfTimeCalculationCell = forArray.index(of: dObj)
                break
            }
        }
        
        for d in forArray{
            let   dObj : NSDictionary = d as! NSDictionary
            
            if dObj["StartTag"] != nil || dObj["EndTag"] != nil{
                let txtFStartTag = Int(dObj["StartTag"] as! String)
                let txtFEndTag = Int(dObj["EndTag"] as! String)
                
                if txtFStartTag == firstResponderTxtFieldTag {
                    indexOfObj = forArray.index(of: dObj)
                    break
                }
                if txtFEndTag == firstResponderTxtFieldTag {
                    indexOfObj = forArray.index(of: dObj)
                    break
                }
            }else{}
        }
        if indexOfObj >= 0{
            
            let   d1 : NSDictionary = forArray[indexOfObj] as! NSDictionary
            
            let mutableDObj: NSMutableDictionary = NSMutableDictionary(dictionary: d1)
            
            let startTag = Int(mutableDObj["StartTag"] as! String)
            let endTag = Int(mutableDObj["EndTag"] as! String)
            //            let breakTag = Int(mutableDObj["breakTag"] as! String)!
            
            if startTag == firstResponderTxtFieldTag {
                mutableDObj["StartValue"] = dateString
                if firstResponderTxtFieldTag == Int(SunStartTxtFieldTag){
                    SundayStartTime = dateString
                }else if firstResponderTxtFieldTag == Int(MonStartTxtFieldTag){
                    MondayStartTime = dateString
                }else if firstResponderTxtFieldTag == Int(TueStartTxtFieldTag){
                    TuesdayStartTime = dateString
                }else if firstResponderTxtFieldTag == Int(WedStartTxtFieldTag){
                    WednesdayStartTime = dateString
                }else if firstResponderTxtFieldTag == Int(ThuStartTxtFieldTag){
                    ThursdayStartTime = dateString
                }else if firstResponderTxtFieldTag == Int(FriStartTxtFieldTag){
                    FridayStartTime = dateString
                }else if firstResponderTxtFieldTag == Int(SatStartTxtFieldTag){
                    SaturdayStartTime = dateString
                }
            }
            if endTag == firstResponderTxtFieldTag {
                mutableDObj["EndValue"] = dateString
                if firstResponderTxtFieldTag == Int(SunEndTxtFieldTag){
                    SundayEndTime = dateString
                }else if firstResponderTxtFieldTag == Int(MonEndTxtFieldTag){
                    MondayEndTime = dateString
                }else if firstResponderTxtFieldTag == Int(TueEndTxtFieldTag){
                    TuesdayEndTime = dateString
                }else if firstResponderTxtFieldTag == Int(WedEndTxtFieldTag){
                    WednesdayEndTime = dateString
                }else if firstResponderTxtFieldTag == Int(ThuEndTxtFieldTag){
                    ThursdayEndTime = dateString
                }else if firstResponderTxtFieldTag == Int(FriEndTxtFieldTag){
                    FridayEndTime = dateString
                }else if firstResponderTxtFieldTag == Int(SatEndTxtFieldTag){
                    SaturdayEndTime = dateString
                }
            }
            if startTag == Int(StartDateTxtFieldTag) || endTag == Int(EndDateTxtFieldTag){
            }else{
                let sValue = mutableDObj["StartValue"] as! String
                let eValue = mutableDObj["EndValue"] as! String
                var breakValue = "0"
                
                if mutableDObj["BreakValue"] != nil{
                    breakValue = mutableDObj["BreakValue"] as! String
                }
                var timeDiff = "0"
                if sValue.count > 0 &&  eValue.count > 0{
                    let diff = self.getTimeDifference(date1: sValue, date2: eValue,breakValue:breakValue )
                    timeDiff = diff
                }
                if selectedSementTag == 0{
                    sameDayHour = timeDiff
                }else{
                    multiDayHour = timeDiff
                }
                
                self.updateTimeDiff()
            }
            if indexOfObj >= 0{
                forArray.replaceObject(at: indexOfObj, with: mutableDObj)
            }
        }
        
        let indPath = IndexPath(row: indexOfObj, section: 0)
        if indexOfTimeCalculationCell >= 0 {
            let timeIndexPath = IndexPath(row: indexOfTimeCalculationCell, section: 0)
            DispatchQueue.main.async(execute: { () -> Void in
                self.tableView.reloadRows(at: [indPath,timeIndexPath], with: .none)
            })
        }else{
            DispatchQueue.main.async(execute: { () -> Void in
                
                self.tableView.reloadData()
            })
        }
    }
    func formDataArrayForTableview(){
        let positionDict = ["header":PositionPlaceHolder,"type":"picker","showDropDown":"0"]
        let jobTitleDict = ["header":JobTitlePlaceHolder,"type":"txtField","showDropDown":"0"]
        
        let ReasonForPositionDict = ["header":ReasonForPositionPlaceHolder,"type":"picker","showDropDown":"0"]
        let rtLocationDict = ["header":ReportToLocationPlaceHolder,"type":"picker","showDropDown":"0"]
        let reportToDict = ["header":ReportToPlaceHolder,"type":"picker","showDropDown":"0"]
        let EmployeesNeededDict = ["header":EmployeesNeededPlaceHolder,"type":"txtField","showDropDown":"0"]
        //        let whenNeededDict = ["header":whenNeededPlaceHolder,"type":"txtField","showDropDown":"0"]
        
        let dateDict = ["header":StartDatePlaceHolder,"subHeader":EndDatePlaceHolder,"type":"Date Cell","showDropDown":"0","StartTag":StartDateTxtFieldTag,"EndTag":EndDateTxtFieldTag,"StartValue":StartDate,"EndValue":EndDate]
        
        let timeDict = ["header":StartTimePlaceHolder,"subHeader":EndTimePlaceHolder,"type":"Date Cell","showDropDown":"0","StartTag":StartTimeTxtFieldTag,"EndTag":EndTimeTxtFieldTag,"StartValue":"","EndValue":"","breakTag":BreakTimeTxtFieldTag,"BreakValue":defaultMealBreakTime]
        let includeWeekendDict = ["header":IncludeWeekendPlaceHolder,"type":"btn","showDropDown":"0"]
        //        let selectTimePlaceHolder = ["header":self.selectTimePlaceHolder,"type":"txtField","showDropDown":"0"]
        
        
        let substituteEmpDict = ["header":substituteEmpPlaceHolder,"type":"btn","showDropDown":"0"]
        
        let jobDutyDict = ["header":jobDutyPlaceHolder,"type":"TextView","subHeader":"","Tag":jobDutyTxtViewTag,"placeholder":jobDutyPlaceHolder]
        let jobDescDict = ["header":jobDescPlaceHolder,"type":"TextView","subHeader":"","Tag":jobDescTxtViewTag,"placeholder":jobDescPlaceHolder]
        
        let empCommentDict = ["header":empTextViewHeader,"type":"TextView","subHeader":"","Tag":empCommentTxtViewTag,"placeholder":empTextViewPlaceHolder]
        let divCommentDict = ["header":divTextViewHeader,"subHeader":" ","type":"TextView","Tag":divisionCommentTxtViewTag,"placeholder":divisionTextViewPlaceHolder]
        
        let searchEmpBtnDict = ["header":"Search Button","type":"Button"]
        let searchEmpListDict = ["header":"Search Emp List","type":"TableView"]
        let SegmentDict = ["header":"Segment","type":"Segment"]
        let nextButtonDict = ["header":"Next","type":"Button"]
        
        let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
        if DivisionId == "2"{
            dataArray = [positionDict,jobTitleDict,ReasonForPositionDict,rtLocationDict,reportToDict,EmployeesNeededDict,dateDict,SegmentDict,timeDict,searchEmpBtnDict,searchEmpListDict,substituteEmpDict,jobDutyDict,jobDescDict,empCommentDict,divCommentDict,nextButtonDict]
            
        }else{
            dataArray = [positionDict,jobTitleDict,ReasonForPositionDict,rtLocationDict,reportToDict,EmployeesNeededDict,dateDict,SegmentDict,timeDict,searchEmpBtnDict,searchEmpListDict,substituteEmpDict,jobDescDict,empCommentDict,divCommentDict,nextButtonDict]
        }
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.reloadData()
        })
    }
    override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == breakTimeTblViewTag{
            return MealBreakMinArray.count
            
        }else if tableView.tag == PositionTblViewTag{
            return positionArray.count
        }else if tableView.tag == ReasonForPositionTblViewTag{
            return ReasonForPositionArray.count
        }else if tableView.tag == ReportToLocationTblViewTag{
            return reportToLocArray.count
        }else if tableView.tag == ReportToTblViewTag{
            return reportToArray.count
            
        }else{
            if tableView.tag == empTblViewTag{
                return  employeeArray.count
                
            }else{
                if selectedSementTag == 1{
                    if multiDayDataArray.count > 0{
                        return multiDayDataArray.count
                        
                    }else{
                        let tempDataArray = NSMutableArray()
                        //First element is being removed from original array
                        for dict in dataArray{
                            let  dictObj = dict as! NSDictionary
                            tempDataArray.add(dictObj)
                        }
                        //                    if tempDataArray.count > 0{
                        //                        tempDataArray.removeObject(at: 0)
                        //
                        //                    }
                        //get the index of Time Dict and fill the details
                        
                        var indexOfObj = -1
                        
                        let placeholderheader = StartTimePlaceHolder
                        
                        for dict in tempDataArray{
                            
                            let   dictObj : NSDictionary = dict as! NSDictionary
                            let headerValue = dictObj["header"] as! String
                            
                            if  headerValue .contains(placeholderheader) {
                                
                                indexOfObj = tempDataArray.index(of: dictObj)
                                
                                break
                            }
                        }
                        
                        for dict in tempDataArray{
                            
                            let  dictObj:NSDictionary = dict as! NSDictionary
                            multiDayDataArray.add(dictObj)
                        }
                        multiDayDataArray.removeObject(at: indexOfObj)
                        for dict in weekDayArray{
                            let  dictObj:NSDictionary = dict as! NSDictionary
                            multiDayDataArray.insert(dictObj, at: indexOfObj)
                            //                        multiDayDataArray.add(dictObj)
                            indexOfObj += 1
                            
                        }
                        
                        
                        return multiDayDataArray.count
                        
                        
                    }
                }else{
                    //                print(scheduleArray.count)
                    return dataArray.count
                }
                
            }
            
        }
    }
    override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == empTblViewTag || tableView.tag == ReasonForPositionTblViewTag || tableView.tag == ReportToLocationTblViewTag || tableView.tag == PositionTblViewTag || tableView.tag == ReportToTblViewTag || tableView.tag == Int(breakTimeTblViewTag){
            
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?
            if !(cell != nil) {
                cell = UITableViewCell(style:.subtitle, reuseIdentifier: "CELL")
            }
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            cell?.textLabel?.numberOfLines = 0
            cell?.backgroundColor = UIColor.white
            
            if tableView.tag == breakTimeTblViewTag{
                
                let obj = MealBreakMinArray[indexPath.row]
                
                let  o:MealBreakMin = obj as! MealBreakMin
                let name =   o.Text
                cell?.textLabel?.text = name
                
                if o.isSelected == "1"{
                    cell?.accessoryType = .checkmark
                }else{
                    cell?.accessoryType = .none
                }
                
                
            }else if tableView.tag == empTblViewTag{
                let  emp = employeeArray[indexPath.row] as! NewEmployee
                
                
                let  empObj:NewEmployee = emp as NewEmployee
                
                let name =   empObj.Name
                cell?.textLabel?.text = name
                
                
                if empObj.isSelected == "0"{
                    cell?.backgroundColor = UIColor.white
                }else{
                    cell?.backgroundColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
                }
            }else  if tableView.tag == ReportToTblViewTag{
                
                let obj = reportToArray[indexPath.row]
                
                let  o:ReportTo = obj as! ReportTo
                cell?.textLabel?.text = o.Name
                if o.isSelected == "1"{
                    cell?.accessoryType = .checkmark
                }else{
                    cell?.accessoryType = .none
                }
            }else if tableView.tag == ReasonForPositionTblViewTag{
                
                let reasonOrder = ReasonForPositionArray[indexPath.row]
                
                let  reasonOrderObj:HOSPositionType = reasonOrder as! HOSPositionType
                cell?.textLabel?.text = reasonOrderObj.PositionName
                if reasonOrderObj.isSelected == "1"{
                    cell?.accessoryType = .checkmark
                }else{
                    cell?.accessoryType = .none
                }
            }else if tableView.tag == ReportToLocationTblViewTag{
                
                let posSkill = reportToLocArray[indexPath.row]
                
                let  posSkillObj:OfficeReportToLocation = posSkill as! OfficeReportToLocation
                cell?.textLabel?.text = posSkillObj.ReportToName
                if posSkillObj.isSelected == "1"{
                    cell?.accessoryType = .checkmark
                }else{
                    cell?.accessoryType = .none
                }
                
            }else if tableView.tag == PositionTblViewTag{
                
                let oGrade = positionArray[indexPath.row]
                
                let  gradeObj:HOSPositionType = oGrade as! HOSPositionType
                cell?.textLabel?.text = gradeObj.PositionName
                if gradeObj.isSelected == "1"{
                    cell?.accessoryType = .checkmark
                }else{
                    cell?.accessoryType = .none
                }
                
            }
            return cell!
            
        }else{
            
            var dict = NSDictionary()
            
            if selectedSementTag == 0{
                dict = dataArray[indexPath.row] as! NSDictionary
                
            }else{
                dict = multiDayDataArray[indexPath.row] as! NSDictionary
                
            }
            
            let placeholder = dict["header"] as! String
            
            if placeholder == PositionPlaceHolder || placeholder == ReasonForPositionPlaceHolder || placeholder == ReportToLocationPlaceHolder || placeholder == ReportToPlaceHolder || placeholder == EmployeesNeededPlaceHolder || placeholder == JobTitlePlaceHolder
            {
                return self.textEntryCell(placeholder: placeholder, tableView: tableView)
                
            }else if placeholder == "Search Button" {
                //Button
                return self.ButtonTableCell(tableView: tableView,indexPath: indexPath as NSIndexPath,identifier: SearchButtonCellIdentifier)
                
            }else if placeholder == "Search Emp List"{
                //TableView CEll
                return self.TableViewCell(tableView: tableView)
                
            }else if placeholder == StartDatePlaceHolder || placeholder == EndDatePlaceHolder {
                
                return self.dateViewCell(tableView: tableView,indexPath: indexPath as NSIndexPath,placeHolder: "" )
                
            }else if placeholder == StartTimePlaceHolder || placeholder == EndTimePlaceHolder {
                
                return self.TimeViewCell(tableView: tableView,indexPath: indexPath as NSIndexPath,placeHolder: "" )
                
            }else if placeholder.contains("Comment") || placeholder.contains("Job") {
                //textView
                return textViewCell(tableView: tableView, indexPath: indexPath as NSIndexPath, placeHolder: "" ,dataDict: dict)
                
            }else if  placeholder == substituteEmpPlaceHolder{
                
                return CheckButtonTableCell(tableView: tableView, indexPath: indexPath as NSIndexPath)
                
            }else if placeholder == "Segment"{
                
                return segmentTableViewCell(tableView: tableView)
                
            }else if placeholder.contains("Time") {
                if selectedSementTag == 0{
                    return self.dateViewCell(tableView: tableView,indexPath: indexPath as NSIndexPath,placeHolder: "" )
                }else{
                    return self.weekTimeViewCell(tableView: tableView, indexPath: indexPath as NSIndexPath)
                }
            }else if placeholder == "Next"{
                return self.ButtonTableCell(tableView: tableView,indexPath: indexPath as NSIndexPath,identifier: NextButtonCellIdentifier)
            }
            
        }
        
        return UITableViewCell()
    }
    override    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.size.width
        let modelName = UIDevice.current.modelName
        
        if tableView.tag == empTblViewTag{
            
            return 60
            
        }else if tableView.tag == ReportToLocationTblViewTag{
            
            let posSkill = reportToLocArray[indexPath.row]
            
            let  posSkillObj:OfficeReportToLocation = posSkill as! OfficeReportToLocation
            let modelName = UIDevice.current.modelName
            
            var width = screenWidth - 140
            if modelName.contains("iPad"){
                width = screenWidth/3 - 140
            }
            var height =  (posSkillObj.ReportToName?.heightWithConstrainedWidth(width: width, font: UIFont.boldSystemFont(ofSize: CGFloat(14))))!
            if screenWidth == 320{
                height = height + 40
            }
            
            return max(80, height)
            
        }else{
            
            if tableView.tag == mainTblViewTag{
                
                var dict = NSDictionary()
                
                if selectedSementTag == 0{
                    dict = dataArray[indexPath.row] as! NSDictionary
                    
                }else{
                    dict = multiDayDataArray[indexPath.row] as! NSDictionary
                    
                }
                
                let placeholder = dict["header"] as! String
                
                if placeholder == PositionPlaceHolder || placeholder == ReasonForPositionPlaceHolder || placeholder == ReportToLocationPlaceHolder || placeholder == ReportToPlaceHolder || placeholder == EmployeesNeededPlaceHolder || placeholder == JobTitlePlaceHolder
                {
                    
                    if tableView.tag == ReportToLocationTblViewTag{
                        
                        let posSkill = reportToLocArray[indexPath.row]
                        let  posSkillObj:OfficeReportToLocation = posSkill as! OfficeReportToLocation
                        let message = posSkillObj.ReportToName
                        var padding  = 20
                        var fontSize = 15
                        if screenWidth == 320 {
                            padding = 10
                            fontSize = 14
                        }
                        let height =  message!.heightWithConstrainedWidth(width: screenWidth - 20, font: UIFont.boldSystemFont(ofSize: CGFloat(fontSize))) + CGFloat(padding)
                        if modelName.contains("iPad"){
                            return max(120, height)
                            
                        }
                        return max(80, height)
                    }
                    if modelName.contains("iPad"){
                        return  120
                        
                    }
                    return 80
                    
                }else if placeholder == IncludeWeekendPlaceHolder{
                    if selectedSementTag == 0{
                        return 0
                    }else{
                        return 50
                    }
                }else if placeholder == "Search Button" {
                    //Button
                    return 80
                }else if placeholder == "Search Emp List"{
                    //TableView CEll
                    
                    if employeeArray.count > 0{
                        return max(120,CGFloat(60 + (employeeArray.count * 55)))
                    }
                    return 120
                }else if placeholder == StartDatePlaceHolder || placeholder == EndDatePlaceHolder  {
                    
                    return 155
                }else if placeholder.contains("Comment") || placeholder.contains("Job") {
                    //textView
                    return 130
                }else if placeholder.contains("Time") {
                    if selectedSementTag == 0{
                        return 80
                    }
                } else if placeholder == substituteEmpPlaceHolder{
                    return 100
                }else if placeholder == "Segment"{
                    if selectedSementTag == 0 {
                        return 210
                    }else{
                        return 260
                    }
                    
                }else if placeholder == "Next"{
                    return 80
                }
                
            }
            
        }
        return 50
    }
    
    //    override  public   func tableView(_ tableView: UITableView,
    //                            didDeselectRowAt indexPath: IndexPath){
    //
    //          if tableView.tag == PositionTblViewTag{
    //            let oPos = positionArray[indexPath.row]
    //
    //            let  PosObj:HOSPositionType = oPos as! HOSPositionType
    //
    //            selectedPositionType = PosObj
    //            for obj in positionArray{
    //                let reportObj:HOSPositionType = obj as! HOSPositionType
    //                reportObj.isSelected = "0"
    //            }
    //                 selectedPositionType.isSelected = "0"
    //          }
    //
    //        tableView.reloadData()
    //        self.tableView.reloadData()
    //
    //    }
    
    override  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if tableView.tag == empTblViewTag{
            
            let  emp = employeeArray[indexPath.row] as! NewEmployee
            let  empObj:NewEmployee = emp as NewEmployee
            if selectedEmployeeArray.contains(empObj){
                empObj.isSelected = "0"
                empObj.isCheckedInRoaster = "0"
                selectedEmployeeArray.remove(empObj)
                
            }else{
                empObj.isSelected = "1"
                empObj.isCheckedInRoaster = "1"
                selectedEmployeeArray.add(empObj)
                
            }
            employeeArray.replaceObject(at: indexPath.row, with: empObj)
            
        }else if tableView.tag == breakTimeTblViewTag{
            isTimeDataReloaded = "0"
            let obj = MealBreakMinArray[indexPath.row]
            
            let  o:MealBreakMin = obj as! MealBreakMin
            
            for obj in MealBreakMinArray{
                let reportObj:MealBreakMin = obj as! MealBreakMin
                reportObj.isSelected = "0"
            }
            
            if selectedSementTag == 0 {
                selectedMealBreakTime = o
                MealBreakTime = selectedMealBreakTime.Text!
                selectedMealBreakTime.isSelected = "1"
                if StartTime.count > 0 && EndTime.count > 0{
                    let diff =  self.getTimeDifference(date1: StartTime, date2: EndTime, breakValue: MealBreakTime)
                    sameDayHour = diff
                }
            }else if selectedSementTag == 1{
                var indexOfObj = -1
                for d in multiDayDataArray{
                    let   dObj : NSDictionary = d as! NSDictionary
                    
                    if dObj["breakTag"] != nil{
                        let txtFBreaktartTag = Int(dObj["breakTag"] as! String)
                        
                        if txtFBreaktartTag == firstResponderTxtFieldTag {
                            indexOfObj = multiDayDataArray.index(of: dObj)
                            break
                        }
                    }
                }
                
                ////
                var isMatches = false
                if indexOfObj >= 0{
                    let   dictObj : NSDictionary = multiDayDataArray[indexOfObj] as! NSDictionary
                    let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dictObj)
                    
                    let bTag = Int(mutableDictObj["breakTag"] as! String)
                    
                    if bTag == firstResponderTxtFieldTag {
                        mutableDictObj["BreakValue"] = o.Text
                        isMatches = true
                    }
                    
                    if isMatches ==  true {
                        var diff = "0"
                        if bTag == Int(MonBreakTxtFieldTag){
                            MondayBreakTime =  mutableDictObj["BreakValue"] as! String
                            diff =  self.getTimeDifference(date1: MondayStartTime, date2: MondayEndTime, breakValue: MondayBreakTime)
                            
                        }else if bTag == Int(TueBreakTxtFieldTag){
                            TuesdayBreakTime =  mutableDictObj["BreakValue"] as! String
                            diff =   self.getTimeDifference(date1: TuesdayStartTime, date2: TuesdayEndTime, breakValue: TuesdayBreakTime)
                            
                        }else if bTag == Int(WedBreakTxtFieldTag){
                            WednesdayBreakTime =  mutableDictObj["BreakValue"] as! String
                            diff =   self.getTimeDifference(date1: WednesdayStartTime, date2: WednesdayEndTime, breakValue: WednesdayBreakTime)
                            
                        }else if bTag == Int(ThuBreakTxtFieldTag){
                            ThursdayBreakTime =  mutableDictObj["BreakValue"] as! String
                            diff =    self.getTimeDifference(date1: ThursdayStartTime, date2: ThursdayEndTime, breakValue: ThursdayBreakTime)
                            
                        }else if bTag == Int(FriBreakTxtFieldTag){
                            FridayBreakTime =  mutableDictObj["BreakValue"] as! String
                            diff =    self.getTimeDifference(date1: FridayStartTime, date2: FridayEndTime, breakValue: FridayBreakTime)
                            
                        }else if bTag == Int(SatBreakTxtFieldTag){
                            SaturdayBreakTime =  mutableDictObj["BreakValue"] as! String
                            diff =  self.getTimeDifference(date1: FridayStartTime, date2: FridayEndTime, breakValue: FridayBreakTime)
                            
                        }else if bTag == Int(SunBreakTxtFieldTag){
                            SundayBreakTime =  mutableDictObj["BreakValue"] as! String
                            diff =  self.getTimeDifference(date1: SundayStartTime, date2: SundayEndTime, breakValue: SundayBreakTime)
                            
                        }
                        if selectedSementTag == 0{
                            sameDayHour = diff
                        }else{
                            multiDayHour = diff
                        }
                        
                        //                        dailyHour = diff
                        
                        multiDayDataArray.replaceObject(at: indexOfObj, with: mutableDictObj)
                        //                        print(multiDayDataArray)
                        self.updateTimeDiff()
                        isTimeDataReloaded = "0"
                        
                    }else{
                        //                        print("Did not matched")
                        //Again Check with the tag
                    }
                }
            }
            alrtController.dismiss(animated: true, completion: nil)
            
            self.removeDropDown()
        } else if tableView.tag == ReportToTblViewTag{
            
            let obj = reportToArray[indexPath.row]
            
            let  o:ReportTo = obj as! ReportTo
            
            selectedReportTo = o
            for obj in reportToArray{
                let reportObj:ReportTo = obj as! ReportTo
                reportObj.isSelected = "0"
            }
            selectedReportTo.isSelected = "1"
            isValidReportTo = true
            alrtController.dismiss(animated: true, completion: nil)
            self.removeDropDown()
            /*
             let PositionTblViewTag = 300001
             */
        }else if tableView.tag == ReasonForPositionTblViewTag{
            
            let obj = ReasonForPositionArray[indexPath.row]
            
            let  o:HOSPositionType = obj as! HOSPositionType
            for obj in ReasonForPositionArray{
                let reportObj:HOSPositionType = obj as! HOSPositionType
                reportObj.isSelected = "0"
            }
            selectedReasonForPosition = o
            selectedReasonForPosition.isSelected = "1"
            //                        isValidReportToLocation
            alrtController.dismiss(animated: true, completion: nil)
            self.removeDropDown()
        }else if tableView.tag == ReportToLocationTblViewTag{
            
            
            let obj = reportToLocArray[indexPath.row]
            
            let  o:OfficeReportToLocation = obj as! OfficeReportToLocation
            
            for obj in reportToLocArray{
                let reportObj:OfficeReportToLocation = obj as! OfficeReportToLocation
                reportObj.isSelected = "0"
            }
            selectedReportToLoc = o
            selectedReportToLoc.isSelected = "1"
            isValidReportToLocation = true
            alrtController.dismiss(animated: true, completion: nil)
            self.removeDropDown()
            
            
        }else if tableView.tag == PositionTblViewTag{
            let oPos = positionArray[indexPath.row]
            
            let  PosObj:HOSPositionType = oPos as! HOSPositionType
            
            selectedPositionType = PosObj
            if selectedPositionType.isSelected == "1"{
                for obj in positionArray{
                    let reportObj:HOSPositionType = obj as! HOSPositionType
                    reportObj.isSelected = "0"
                }
                selectedPositionType.isSelected = "0"
                isValidPosition = false
                JobTitleValue = ""
                
            }else{
                for obj in positionArray{
                    let reportObj:HOSPositionType = obj as! HOSPositionType
                    reportObj.isSelected = "0"
                }
                selectedPositionType.isSelected = "1"
                isValidPosition = true
                JobTitleValue = selectedPositionType.PositionName!
                
            }
            self.getProfileCommentsServerCall()
            //             alrtController.dismiss(animated: true, completion: nil)
            //            self.removeDropDown()
        }
        DispatchQueue.main.async(execute: { () -> Void in
            tableView.reloadData()
            self.tableView.reloadData()
        })
        
        
    }
    //MARK: Custom Cell
    func defaultTextCell(tableView: UITableView,placeHolder: String) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?
        if !(cell != nil) {
            cell = UITableViewCell(style:.subtitle, reuseIdentifier: "CELL")
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell?.textLabel?.text = placeHolder
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 13)
        cell?.textLabel?.numberOfLines = 0
        
        return cell!
        
    }
    
    func segmentTableViewCell(tableView: UITableView) -> SegmentTableViewCell {
        
        let cell:SegmentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SegmentTableViewCellIdentifier") as! SegmentTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.white
        cell.backgroundColor = UIColor.white
        
        cell.optionSegmentControl.selectedSegmentIndex = selectedSementTag
        
        cell.optionSegmentControl.removeTarget(self, action:#selector(self.segmentValueChanged), for: .valueChanged)
        
        cell.optionSegmentControl.addTarget(self, action:#selector(self.segmentValueChanged), for: .valueChanged)
        cell.optionSegmentControl.tintColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        self.timeSegment = cell.optionSegmentControl
        cell.optionSegmentControlHeightConstraint.constant = 40
        cell.optionSegmentControl.layer.cornerRadius = 0
        cell.optionSegmentControl.layer.borderColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String).cgColor
        cell.optionSegmentControl.layer.borderWidth = 1
        cell.optionSegmentControl.layer.masksToBounds = true
        cell.clickHereBtn.removeTarget(self, action:#selector(self.clickHereSegBtnTapped), for: .touchUpInside)
        
        cell.includeWeekendBtn.removeTarget(self, action:#selector(self.includeWeekendBtnTapped), for: .touchUpInside)
        
        cell.includeWeekendBtn.addTarget(self, action:#selector(self.includeWeekendBtnTapped), for: .touchUpInside)
        
        cell.clickHereBtn.addTarget(self, action:#selector(self.clickHereSegBtnTapped), for: .touchUpInside)
        
        if IncludeWeekend == "false"{
            cell.includeWeekendBtn.isSelected = false
        }else{
            cell.includeWeekendBtn.isSelected = true
        }
        if selectedSementTag == 0{
            cell.includeWeekendBtn .isHidden = false
            cell.SegmentControlViewTopConstraint.constant = 45
            cell.clickHereLbl.BoldAndUnderline(fullText: sameDayTimePlaceHolder, changeText: "Click Here", textColor: UIColor.blue, fontSize: 15)
            
            cell.timePlaceHolderView.isHidden = true
        }else{
            cell.includeWeekendBtn .isHidden = true
            cell.SegmentControlViewTopConstraint.constant = 5
            cell.clickHereLbl.BoldAndUnderline(fullText: multiDayTimePlaceHolder, changeText: "Click Here", textColor: UIColor.blue, fontSize: 15)
            
            cell.timePlaceHolderView.isHidden = false
        }
        
        cell.optionSegmentControl.layoutIfNeeded()
        
        if isTimeDataReloaded == "0"{
            DispatchQueue.main.async(execute: { () -> Void in
                if self.selectedSementTag == 0{
                    cell.lblTimeDiff.text =  self.sameDayHour
                }else{
                    cell.lblTimeDiff.text = self.multiDayHour
                }
                self.isTimeDataReloaded = "1"
            })
        }
        
        
        cell.DayPlaceHolderLbl.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.StartTimePlaceHolderLbl.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.EndTimePlaceHolderLbl.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.MealbreakPlaceHolderLbl.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
        
        return cell
        
    }
    func updateTimeDiff(){
        
        var sundayDailyHrDiff:Float = Float(0)
        var mondayDailyHrDiff:Float = Float(0)
        var tuesdayDailyHrDiff:Float = Float(0)
        var wednesdayDailyHrDiff:Float = Float(0)
        var thursdayDailyHrDiff:Float = Float(0)
        var fridayDailyHrDiff:Float = Float(0)
        var saturdayDailyHrDiff:Float = Float(0)
        
        if SundayStartTime.count > 0 &&  SundayEndTime.count > 0{
            sundayDailyHrDiff = Float(self.getTimeDifference(date1: SundayStartTime, date2: SundayEndTime,breakValue: SundayBreakTime))!
        }
        
        if MondayStartTime.count > 0 &&  MondayEndTime.count > 0{
            mondayDailyHrDiff = Float(self.getTimeDifference(date1: MondayStartTime, date2: MondayEndTime,breakValue: MondayBreakTime))!
        }
        
        if TuesdayStartTime.count > 0 &&  TuesdayEndTime.count > 0{
            tuesdayDailyHrDiff = Float(self.getTimeDifference(date1: TuesdayStartTime, date2: TuesdayEndTime,breakValue: TuesdayBreakTime))!
        }
        
        if WednesdayStartTime.count > 0 &&  WednesdayEndTime.count > 0{
            wednesdayDailyHrDiff = Float(self.getTimeDifference(date1: WednesdayStartTime, date2: WednesdayEndTime,breakValue: WednesdayBreakTime))!
        }
        
        if ThursdayStartTime.count > 0 &&  ThursdayEndTime.count > 0{
            thursdayDailyHrDiff = Float(self.getTimeDifference(date1: ThursdayStartTime, date2: ThursdayEndTime,breakValue: ThursdayBreakTime))!
        }
        
        if FridayStartTime.count > 0 &&  FridayEndTime.count > 0{
            fridayDailyHrDiff = Float(self.getTimeDifference(date1: FridayStartTime, date2: FridayEndTime,breakValue: FridayBreakTime))!
        }
        
        if SaturdayEndTime.count > 0 &&  SaturdayStartTime.count > 0{
            saturdayDailyHrDiff = Float(self.getTimeDifference(date1: SaturdayStartTime, date2: SaturdayEndTime,breakValue: SaturdayBreakTime))!
        }
        
        let totalDiffHrs = (sundayDailyHrDiff + mondayDailyHrDiff + tuesdayDailyHrDiff + wednesdayDailyHrDiff + thursdayDailyHrDiff + fridayDailyHrDiff + saturdayDailyHrDiff)
        
        let timeDiff = String(format:"%.2f",totalDiffHrs)
        
        if selectedSementTag == 0{
            sameDayHour = timeDiff
        }else{
            multiDayHour = timeDiff
        }
        
    }
    //    func getBreakTime(breakValue : String) -> Float{
    //
    //        var time  = 0
    //
    //        if breakValue == "00"{
    //            time = time! - 00
    //        }else if breakValue == "30"{
    //            if minutes > 0 || hours > 0{
    //                time = time! - 0.50
    //            }
    //        }else if breakValue == "45"{
    //            if minutes > 30 || hours > 0{
    //                time = time! - 0.75
    //            }
    //        }else if breakValue == "60"{
    //            if minutes > 45 || hours > 0{
    //                time = time! - 1.00
    //            }
    //        }
    //
    //    }
    func TableViewCell(tableView: UITableView) -> TableViewTableViewCell {
        
        let cell:TableViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewTableViewCellIdentifier") as! TableViewTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        cell.dataCellTblView.tag = empTblViewTag
        cell.TblBGView.layer.borderColor = borderColor.cgColor
        cell.TblBGView.layer.borderWidth = 1
        
        empTableView = cell.dataCellTblView
        cell.dataCellTblView.delegate = self
        cell.dataCellTblView.dataSource = self
        empTableView.delegate = self
        empTableView.dataSource = self
        
        //        cell.dataCellTblView.reloadData()
        
        cell.clearAllBtn.removeTarget(self, action:#selector(self.clearAllBtnBtnTapped), for: .touchUpInside)
        cell.moveUPBtn.removeTarget(self, action:#selector(self.moveUpBtnTapped), for: .touchUpInside)
        cell.moveDownBtn.removeTarget(self, action:#selector(self.moveDownBtnTapped), for: .touchUpInside)
        cell.clearEntryBtn.removeTarget(self, action:#selector(self.clearEntryBtnTapped), for: .touchUpInside)
        
        
        cell.clearAllBtn.addTarget(self, action:#selector(self.clearAllBtnBtnTapped), for: .touchUpInside)
        cell.moveUPBtn.addTarget(self, action:#selector(self.moveUpBtnTapped), for: .touchUpInside)
        cell.moveDownBtn.addTarget(self, action:#selector(self.moveDownBtnTapped), for: .touchUpInside)
        cell.clearEntryBtn.addTarget(self, action:#selector(self.clearEntryBtnTapped), for: .touchUpInside)
        
        
        
        return cell
        
    }
    func CheckButtonTableCell(tableView: UITableView,indexPath: NSIndexPath) -> CheckButtonTableViewCell {
        
        let cell:CheckButtonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CheckButtonCellIdentififer") as! CheckButtonTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        //        let dict = dataArray[indexPath.row] as! NSDictionary
        var dict = NSDictionary()
        
        if selectedSementTag == 0{
            dict = dataArray[indexPath.row] as! NSDictionary
            
        }else{
            dict = multiDayDataArray[indexPath.row] as! NSDictionary
            
        }
        let placeholder = dict["header"] as! String
        cell.checkBtn.setTitle(placeholder, for: .normal)
        cell.checkBtn.isEnabled = true
        cell.checkBtn.setTitleColor(UIColor.black, for: .normal)
        cell.checkBtn.removeTarget(self, action:#selector(self.includeWeekendBtnTapped), for: .touchUpInside)
        cell.checkBtn.removeTarget(self, action:#selector(self.SubstitueEmpBtnTapped), for: .touchUpInside)
        
        if placeholder == IncludeWeekendPlaceHolder{
            cell.checkBtn.addTarget(self, action:#selector(self.includeWeekendBtnTapped), for: .touchUpInside)
        } else if placeholder == substituteEmpPlaceHolder{
            if employeeArray.count == 0{
                cell.checkBtn.isEnabled = false
                cell.checkBtn.setTitleColor(UIColor.lightGray, for: .normal)
            }else{
                cell.checkBtn.isEnabled = true
                cell.checkBtn.setTitleColor(UIColor.black, for: .normal)
                
            }
            if SubstituteEmpChecked == "1" {
                cell.checkBtn.isSelected = true
            }else{
                cell.checkBtn.isSelected = false
            }
            
            cell.checkBtn.addTarget(self, action:#selector(self.SubstitueEmpBtnTapped), for: .touchUpInside)
            
            
        }
        return cell
        
    }
    func ButtonTableCell(tableView: UITableView,indexPath: NSIndexPath,identifier: String) -> ButtonTableViewCell {
        
        let cell:ButtonTableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier) as! ButtonTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        //        let dict = dataArray[indexPath.row] as! NSDictionary
        var dict = NSDictionary()
        
        if identifier == SearchButtonCellIdentifier{
            
            
            if selectedSementTag == 0{
                dict = dataArray[indexPath.row] as! NSDictionary
                
            }else{
                dict = multiDayDataArray[indexPath.row] as! NSDictionary
                
            }
            let placeholder = dict["header"] as! String
            if placeholder == "Search Button"{
                cell.dButton.setTitle("Search Employees", for: .normal)
                cell.dButton.addTarget(self, action:#selector(self.searchBtnTapped), for: .touchUpInside)
                
            }
        }else if identifier == NextButtonCellIdentifier{
            cell.dButton.addTarget(self, action:#selector(self.nextButtonTapped), for: .touchUpInside)
            
        }
        
        self.addDropDownShadowToView(shadowView: cell.dButton)
        return cell
        
    }
    func dateViewCell(tableView: UITableView,indexPath: NSIndexPath,placeHolder: String) -> DateTableViewCell {
        
        let cell:DateTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DateTableViewCellIdentifier") as! DateTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        
        var placeholder = ""
        var subplaceholder =  ""
        var startTag = 0
        var endTag = 0
        var startValue = ""
        var endValue = ""
        
//        cell.startTimeView.layer.borderColor = borderColor.cgColor
//        cell.endTimeView.layer.borderColor = borderColor.cgColor
//        cell.endTimeView.layer.borderWidth = CGFloat(1)
//        cell.startTimeView.layer.borderWidth = CGFloat(1)
        
        if placeHolder.count > 0 {
            placeholder = StartTimePlaceHolder
            subplaceholder = EndTimePlaceHolder
            
        }else{
            var dict = NSDictionary()
            
            if selectedSementTag == 0{
                dict = dataArray[indexPath.row] as! NSDictionary
            }else{
                dict = multiDayDataArray[indexPath.row] as! NSDictionary
            }
            placeholder = dict["header"] as! String
            subplaceholder = dict["subHeader"] as! String
        }
        
        if placeholder == StartDatePlaceHolder || placeholder == EndDatePlaceHolder {
            var dict = NSDictionary()
            
            if selectedSementTag == 0{
                dict = dataArray[indexPath.row] as! NSDictionary
            }else{
                dict = multiDayDataArray[indexPath.row] as! NSDictionary
            }
            startTag = Int(dict["StartTag"] as! String)!
            endTag = Int(dict["EndTag"] as! String)!
            startValue = dict["StartValue"] as! String
            endValue = dict["EndValue"] as! String
            StartDate = startValue
            EndDate = endValue
//            cell.startTimeView.layer.borderColor = borderColor.cgColor
//            cell.endTimeView.layer.borderColor = borderColor.cgColor
            
        }
        cell.textFStart.tag = startTag
        cell.textFEnd.tag = endTag
        
        cell.lblStart.text = placeholder
        cell.lblEnd.text = subplaceholder
        cell.textFStart.delegate = self
        cell.textFEnd.delegate = self
        
        cell.textFStart.text = startValue
        cell.textFEnd.text = endValue
        
        self.addRightImageToTextField(textField: cell.textFStart,imageName: "calendar_icon.png")
        self.addRightImageToTextField(textField: cell.textFEnd,imageName: "calendar_icon.png")
        
        return cell
        
    }
    func TimeViewCell(tableView: UITableView,indexPath: NSIndexPath,placeHolder: String) -> DateTableViewCell {
        
        let cell:DateTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DateBreakTableViewCellIdentifier") as! DateTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        var placeholder = ""
        var subplaceholder =  ""
        var startTag = 0
        var endTag = 0
        var startValue = ""
        var endValue = ""
        var breakValue = ""
        var breakTag = 0
        
//        cell.startTimeView.layer.borderColor = borderColor.cgColor
//        cell.endTimeView.layer.borderColor = borderColor.cgColor
//        cell.endTimeView.layer.borderWidth = CGFloat(1)
//        cell.startTimeView.layer.borderWidth = CGFloat(1)
//        cell.mealBreakTimeView.layer.borderWidth = CGFloat(1)
//        cell.mealBreakTimeView.layer.borderColor = borderColor.cgColor
        
        
        if placeHolder.count > 0 {
            placeholder = StartTimePlaceHolder
            subplaceholder = EndTimePlaceHolder
            
        }else{
            var dict = NSDictionary()
            
            if selectedSementTag == 0{
                dict = dataArray[indexPath.row] as! NSDictionary
            }else{
                dict = multiDayDataArray[indexPath.row] as! NSDictionary
            }
            placeholder = dict["header"] as! String
            subplaceholder = dict["subHeader"] as! String
        }
        
        
        
        
        if selectedSementTag == 1{
            let dict = multiDayDataArray[indexPath.row] as! NSDictionary
            startTag = Int(dict["StartTag"] as! String)!
            endTag = Int(dict["EndTag"] as! String)!
            startValue = dict["StartValue"] as! String
            endValue = dict["EndValue"] as! String
            if dict["BreakValue"] != nil{
                
                breakValue = dict["BreakValue"] as! String
            }
            if dict["breakTag"] != nil{
                
                breakTag = Int(dict["breakTag"] as! String)!
            }
            
        }else{
            let dict = dataArray[indexPath.row] as! NSDictionary
            let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dict)
            
            if mutableDictObj["BreakValue"] != nil{
                
                mutableDictObj["BreakValue"] = MealBreakTime
            }
            
            dataArray.replaceObject(at: indexPath.row, with: mutableDictObj)
            
            startTag = Int(dict["StartTag"] as! String)!
            endTag = Int(dict["EndTag"] as! String)!
            startValue = dict["StartValue"] as! String
            endValue = dict["EndValue"] as! String
            if dict["breakTag"] != nil{
                
                breakTag = Int(dict["breakTag"] as! String)!
            }
            
            breakValue = selectedMealBreakTime.Text!//dict["BreakValue"] as! String
            //            print(breakValue)
            //TODO:
            //            StartTime = startValue
            //            EndTime = endValue
            //            //calculate difference
            //            if StartTime.count > 0 && EndTime.count > 0{
            //                let diff = self.getTimeDifference(date1: StartTime, date2: EndTime,breakValue: breakValue)
            //                sameDayHour = diff
            //
            //                if isTimeDataReloaded == "0"{
            //                    DispatchQueue.main.async(execute: { () -> Void in
            //                        let indPath = IndexPath(row: indexPath.row - 1, section: 0)
            //                        self.tableView.reloadRows(at: [indPath], with: .none)
            //                        self.isTimeDataReloaded = "1"
            //                    })
            //                }
            //
            //                isValidStartTime = true
            //                isValidEndTime = true
            //            }
        }
        cell.textFStart.tag = startTag
        cell.textFEnd.tag = endTag
        cell.textFMealBreak.tag = breakTag
        
        cell.lblStart.text = placeholder
        cell.lblEnd.text = subplaceholder
        cell.textFStart.delegate = self
        cell.textFEnd.delegate = self
        cell.textFMealBreak.delegate = self
        
        cell.textFStart.text = startValue
        cell.textFEnd.text = endValue
        cell.textFMealBreak.text = breakValue
        
        if isValidEndTime == true{
//            cell.endTimeView.layer.borderColor = borderColor.cgColor
            cell.lblEnd.halfTextColorChange(fullText: subplaceholder, changeText: "*", textColor: UIColor.clear)
            
        }else{
//            cell.endTimeView.layer.borderColor = UIColor.red.cgColor
            cell.lblEnd.halfTextColorChange(fullText: subplaceholder, changeText: "*", textColor: UIColor.red)
            
        }
        if isValidStartTime == true{
//            cell.startTimeView.layer.borderColor = borderColor.cgColor
            cell.lblStart.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.clear)
            
        }else{
//            cell.startTimeView.layer.borderColor = UIColor.red.cgColor
            cell.lblStart.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.red)
            
        }
        
        self.addLeftImageToTextField(textField: cell.textFStart)
        self.addLeftImageToTextField(textField: cell.textFEnd)
        self.addRightImageToTextField(textField: cell.textFMealBreak,imageName: "expand-arrow")
        
        return cell
        
    }
    func textEntryCell(placeholder: String,tableView: UITableView) -> TextFieldTableViewCell {
        
        let cell:TextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCellIdentifier") as! TextFieldTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.white
        cell.backgroundColor = UIColor.white
        cell.lblHeader.text = placeholder
        cell.entryTextField.delegate = self
        cell.entryTextField.backgroundColor = UIColor.clear
//        cell.btnBGView.backgroundColor = UIColor.white
//        cell.btnBGView.layer.borderColor = borderColor.cgColor
//        cell.btnBGView.layer.borderWidth = 1
        self.activeField = cell.entryTextField
        
        if placeholder == EmployeesNeededPlaceHolder {
            cell.entryTextField.keyboardType =  UIKeyboardType.numberPad
            if TempEmployeesNeeded > 0{
                cell.entryTextField.text = String(TempEmployeesNeeded)
                
            }else{
                cell.entryTextField.text = ""
            }
            cell.entryTextField.tag = empNeededTxtFieldTag
            if isValidEmployeeNeeded == true{
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.clear)
                
            }else{
//                cell.btnBGView.layer.borderColor = UIColor.red.cgColor
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.red)
                
            }
        }else{
            cell.entryTextField.keyboardType =  UIKeyboardType.default
            
        }
        if placeholder == JobTitlePlaceHolder{
            cell.entryTextField.tag = jobTitleTxtFieldTag
            if selectedPositionType.isSelected == "1"
            {
                if selectedPositionType.PositionName?.count == 0{
                    cell.entryTextField.isUserInteractionEnabled = true
//                    cell.btnBGView.isUserInteractionEnabled = true
                    
                }else{
//                    cell.btnBGView.backgroundColor = borderColor
//                    cell.btnBGView.isUserInteractionEnabled = false
                }
            }
            else{
                cell.entryTextField.isUserInteractionEnabled = true
//                cell.btnBGView.isUserInteractionEnabled = true
                
            }
            
            cell.entryTextField.text = JobTitleValue
            if isValidJobTitle == true{
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.clear)
                
            }else{
//                cell.btnBGView.layer.borderColor = UIColor.red.cgColor
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.red)
                
            }
        }else if placeholder == ReportToPlaceHolder{
            cell.entryTextField.tag = reportToTxtFieldTag
            cell.entryTextField.text = selectedReportTo.Name
            if isValidReportTo == true{
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.clear)
                
            }else{
//                cell.btnBGView.layer.borderColor = UIColor.red.cgColor
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.red)
                
            }
            
        }else if placeholder == ReportToLocationPlaceHolder{
            cell.entryTextField.tag = reportToLocTxtFieldTag
            cell.entryTextField.text = selectedReportToLoc.ReportToName
            if isValidReportToLocation == true{
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.clear)
                
            }else{
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.red)
//                cell.btnBGView.layer.borderColor = UIColor.red.cgColor
                
            }
        }else if placeholder == PositionPlaceHolder{
            cell.entryTextField.tag = positionTxtFieldTag
            if selectedPositionType.isSelected == "1"
            {
                cell.entryTextField.text = selectedPositionType.PositionName
                
            }else{
                cell.entryTextField.text = ""
            }
            if isValidPosition == true{
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.clear)
                
            }else{
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.red)
//                cell.btnBGView.layer.borderColor = UIColor.red.cgColor
                
            }
        }else if placeholder == ReasonForPositionPlaceHolder{
            cell.entryTextField.tag = ReasonForPositionTxtFieldTag
            cell.entryTextField.text = selectedReasonForPosition.PositionName
            if isValidReasonForPosition == true{
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.clear)
                
            }else{
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.red)
//                cell.btnBGView.layer.borderColor = UIColor.red.cgColor
                
            }
        }
        cell.addButton.removeTarget(self, action: #selector(self.addReportToBtnTapped), for: .touchUpInside)
        cell.addButton.removeTarget(self, action:#selector(self.addReportToLocBtnTapped), for: .touchUpInside)
        
        if placeholder == ReportToLocationPlaceHolder{
            cell.addButton.isHidden = false
            cell.addButton.addTarget(self, action:#selector(self.addReportToLocBtnTapped), for: .touchUpInside)
            
        }else if placeholder == ReportToPlaceHolder{
            cell.addButton.isHidden = false
            cell.addButton.addTarget(self, action:#selector(self.addReportToBtnTapped), for: .touchUpInside)
            
        } else{
            
            cell.addButton.isHidden = true
            
        }
        //show dropdownIcon
        if placeholder ==  ReportToPlaceHolder || placeholder == ReportToLocationPlaceHolder || placeholder == PositionPlaceHolder || placeholder == ReasonForPositionPlaceHolder{
            
            
            self.addRightImageToTextField(textField: cell.entryTextField,imageName: "expand-arrow")
            
        }else{
            //emp needed cell
            cell.entryTextField.rightViewMode = .never
            
        }
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(keyboardDoneBtnTapped))]
        toolBar.sizeToFit()
        cell.entryTextField.inputAccessoryView = toolBar
        
        return cell
        
    }
    func pickUpDate(_ textField : UITextField){
        
        // DatePicker
        let datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        datePicker.backgroundColor = UIColor.white
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
//        customPickerView.dtPickerView.addTarget(self, action:#selector(self.datePickerValueChanged), for:.valueChanged)

        datePicker.datePickerMode = UIDatePicker.Mode.time
        datePicker.minuteInterval = minuteInterval
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        textField.inputView =  datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(NewRosOfficeVC.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(NewRosOfficeVC.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
        
        
        
    }
   @objc func doneClick() {
    self.view.endEditing(true)
//        textField_Date.text = dateFormatter1.string(from: datePicker.date)
//        textField_Date.resignFirstResponder()
    }
    @objc func cancelClick() {
//        textField_Date.resignFirstResponder()
        self.view.endEditing(true)
    }
    func weekTimeViewCell(tableView: UITableView,indexPath: NSIndexPath) -> EnterTimeTableViewCell {
        
        let cell:EnterTimeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EnterTimeTableViewCellIdentifier") as! EnterTimeTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        var startTag = 0
        var endTag = 0
        var startValue = ""
        var endValue = ""
        var breakTag = 0
        var breakValue = "00"
        
//        cell.startTimeView.layer.borderColor = borderColor.cgColor
//        cell.endTimeView.layer.borderColor = borderColor.cgColor
//        cell.endTimeView.layer.borderWidth = CGFloat(1)
//        cell.startTimeView.layer.borderWidth = CGFloat(1)
//
//        cell.mealBreakTimeView.layer.borderWidth = CGFloat(1)
//        cell.mealBreakTimeView.layer.borderColor = borderColor.cgColor
        
//        cell.clearEndTimeBtn.addTarget(self, action:#selector(self.clearEndTimeBtnTapped), for: .touchUpInside)
//        cell.clearStartTimeBtn.addTarget(self, action:#selector(self.clearStartTimeBtnTapped), for: .touchUpInside)
        
        let dict = multiDayDataArray[indexPath.row] as! NSDictionary
        let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dict)
        
        //        mutableDictObj["BreakValue"] = MealBreakTime
        
        multiDayDataArray.replaceObject(at: indexPath.row, with: mutableDictObj)
        
        let day = dict["day"] as! String
        
        cell.lblDay.text = day
        cell.lblDay.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        customPickerView.dtPickerView.minuteInterval = minuteInterval
        
        startTag = Int(dict["StartTag"] as! String)!
        endTag = Int(dict["EndTag"] as! String)!
        startValue = dict["StartValue"] as! String
        endValue = dict["EndValue"] as! String
        breakTag = Int(dict["breakTag"] as! String)!
        breakValue = dict["BreakValue"] as! String
        
//        cell.clearEndTimeBtn.tag = Int(dict["EndTag"] as! String)!
//        cell.clearStartTimeBtn.tag = Int(dict["StartTag"] as! String)!
//        cell.startTimeTxtField.clearButtonMode = .whileEditing
//        cell.endTimeTxtField.clearButtonMode = .whileEditing
        
        cell.startTimeTxtField.clearButtonMode = UITextField.ViewMode.always
        cell.startTimeTxtField.clearsOnBeginEditing = true;

        cell.endTimeTxtField.clearButtonMode = UITextField.ViewMode.always
        cell.endTimeTxtField.clearsOnBeginEditing = true;

        cell.startTimeTxtField.tag = startTag
        cell.endTimeTxtField.tag = endTag
        cell.mealBreakTimeTxtField.tag = breakTag
        
        self.pickUpDate(cell.startTimeTxtField)
        self.pickUpDate(cell.endTimeTxtField)

        cell.startTimeTxtField.delegate = self
        cell.endTimeTxtField.delegate = self
        cell.mealBreakTimeTxtField.delegate = self
        cell.startTimeTxtField.text = startValue
        cell.endTimeTxtField.text = endValue
        cell.mealBreakTimeTxtField.text = breakValue
        
        self.addLeftImageToTextField(textField: cell.startTimeTxtField)
        self.addLeftImageToTextField(textField: cell.endTimeTxtField)
        self.addRightImageToTextField(textField: cell.mealBreakTimeTxtField,imageName: "expand-arrow")
        return cell
        
        
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
    func addLeftImageToTextField(textField: UITextField){
        let imageView = UIImageView.init(frame: CGRect(x:0,y:0,width:20,height:20));
        let image = UIImage(named: "Timeslips");
        imageView.image = image;
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        textField.leftView = imageView;
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftViewMode = .always
        
    }
    func textViewCell(tableView: UITableView,indexPath: NSIndexPath,placeHolder: String,dataDict: NSDictionary) -> TextViewTableViewCell {
        
        let cell:TextViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TextViewTableViewCellIdentifier") as! TextViewTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.white
        cell.backgroundColor = UIColor.white
        var   placeholderString = placeHolder
        
        var dict = NSDictionary()
        
        if selectedSementTag == 0{
            dict = dataArray[indexPath.row] as! NSDictionary
            
        }else{
            dict = multiDayDataArray[indexPath.row] as! NSDictionary
            
        }
        placeholderString = dict["header"] as! String
        let tag =  dataDict["Tag"] as! String
        
        cell.entryTextView.tag = Int(tag)!
        cell.entryTextView.layer.borderColor = borderColor.cgColor
        cell.entryTextView.layer.borderWidth = 1
        cell.entryTextView.delegate = self
        cell.lblHeader.text = placeholderString
        self.activeTextView = cell.entryTextView
        if placeholderString.contains("internal staff"){
            cell.lblHeader.font = UIFont.boldSystemFont(ofSize: 14)
        }else{
            cell.lblHeader.font = UIFont.systemFont(ofSize: 14)
        }
        if cell.entryTextView.tag == Int(empCommentTxtViewTag){
            //add placeholder
            if empCommentText.count == 0 || cell.entryTextView.text == empTextViewPlaceHolder{
                cell.entryTextView.text = empTextViewPlaceHolder
                cell.entryTextView.textColor = UIColor.lightGray
                
            }else{
                cell.entryTextView.text = empCommentText
                cell.entryTextView.textColor = UIColor.black
            }
            
        }else  if cell.entryTextView.tag == Int(divisionCommentTxtViewTag){
            //add placeholder
            if divisionCommentText.count == 0 || cell.entryTextView.text == divisionTextViewPlaceHolder{
                cell.entryTextView.text = divisionTextViewPlaceHolder
                cell.entryTextView.textColor = UIColor.lightGray
                
            }else{
                cell.entryTextView.text = divisionCommentText
                cell.entryTextView.textColor = UIColor.black
            }
        }else  if cell.entryTextView.tag == Int(jobDutyTxtViewTag){
            cell.entryTextView.text = jobDutyText
            cell.entryTextView.textColor = UIColor.black
            
            if isValidJobDuty ==  true {
                
                cell.lblHeader.halfTextColorChange(fullText: placeholderString, changeText: "*", textColor: UIColor.clear)
                
            }else{
                cell.entryTextView.layer.borderColor = UIColor.red.cgColor
                
                cell.lblHeader.halfTextColorChange(fullText: placeholderString, changeText: "*", textColor: UIColor.red)
                
            }
        }else  if cell.entryTextView.tag == Int(jobDescTxtViewTag){
            cell.entryTextView.text = jobDescText
            cell.entryTextView.textColor = UIColor.black
            
            if isValidJobDesc ==  true {
                
                cell.lblHeader.halfTextColorChange(fullText: placeholderString, changeText: "*", textColor: UIColor.clear)
                
            }else{
                cell.entryTextView.layer.borderColor = UIColor.red.cgColor
                cell.lblHeader.halfTextColorChange(fullText: placeholderString, changeText: "*", textColor: UIColor.red)
            }
            
        }
        
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(keyboardDoneBtnTapped))]
        toolBar.sizeToFit()
        
        cell.entryTextView.inputAccessoryView = toolBar
        
        
        
        return cell
        
    }
    //MARK: TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag ==  empNeededTxtFieldTag
        {
            
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            let isAllNumbers = allowedCharacters.isSuperset(of: characterSet)
            if isAllNumbers == true{
                
                let charsLimit = 2
                let startingLength = textField.text?.count ?? 0
                let lengthToAdd = string.count
                let lengthToReplace =  range.length
                let newLength = startingLength + lengthToAdd - lengthToReplace
                
                return newLength <= charsLimit
            }else{
                return false
            }
            
            
        }
        else
        {
            return true
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        firstResponderTxtFieldTag = textField.tag

        if textField.tag == empNeededTxtFieldTag || textField.tag == jobTitleTxtFieldTag || textField.tag == Int(MonStartTxtFieldTag)
            || textField.tag == Int(TueStartTxtFieldTag)
            || textField.tag == Int(WedStartTxtFieldTag)
            || textField.tag == Int(ThuStartTxtFieldTag)
            || textField.tag == Int(FriStartTxtFieldTag)
            || textField.tag == Int(SatStartTxtFieldTag)
            || textField.tag == Int(SunStartTxtFieldTag)
            || textField.tag == Int(MonEndTxtFieldTag)
            || textField.tag == Int(TueEndTxtFieldTag)
            || textField.tag == Int(WedEndTxtFieldTag)
            || textField.tag == Int(ThuEndTxtFieldTag)
            || textField.tag == Int(FriEndTxtFieldTag)
            || textField.tag == Int(SatEndTxtFieldTag)
            || textField.tag == Int(SunEndTxtFieldTag)
         {
            
        }else if textField.tag == reportToTxtFieldTag || textField.tag == reportToLocTxtFieldTag || textField.tag == positionTxtFieldTag || textField.tag == ReasonForPositionTxtFieldTag || textField.tag == Int(BreakTimeTxtFieldTag) || textField.tag == Int(MonBreakTxtFieldTag)
            || textField.tag == Int(TueBreakTxtFieldTag)
            || textField.tag == Int(WedBreakTxtFieldTag)
            || textField.tag == Int(ThuBreakTxtFieldTag)
            || textField.tag == Int(FriBreakTxtFieldTag)
            || textField.tag == Int(SatBreakTxtFieldTag)
            || textField.tag == Int(SunBreakTxtFieldTag)
        {
            var tag = 0
            var placeholder = ""
            
            if firstResponderTxtFieldTag == reportToTxtFieldTag{
                tag = ReportToTblViewTag
                placeholder = ReportToPlaceHolder
            }else if firstResponderTxtFieldTag == ReasonForPositionTxtFieldTag{
                tag = ReasonForPositionTblViewTag
                placeholder = ReasonForPositionPlaceHolder
            }else if firstResponderTxtFieldTag == reportToLocTxtFieldTag{
                tag = ReportToLocationTblViewTag
                placeholder = ReportToLocationPlaceHolder
            }else if firstResponderTxtFieldTag == positionTxtFieldTag{
                tag = PositionTblViewTag
                placeholder = PositionPlaceHolder
            }else if firstResponderTxtFieldTag == Int(BreakTimeTxtFieldTag) || firstResponderTxtFieldTag == Int(MonBreakTxtFieldTag)
                || firstResponderTxtFieldTag == Int(TueBreakTxtFieldTag)
                || firstResponderTxtFieldTag == Int(WedBreakTxtFieldTag)
                || firstResponderTxtFieldTag == Int(ThuBreakTxtFieldTag)
                || firstResponderTxtFieldTag == Int(FriBreakTxtFieldTag)
                || firstResponderTxtFieldTag == Int(SatBreakTxtFieldTag)
                || firstResponderTxtFieldTag == Int(SunBreakTxtFieldTag){
                
                tag = breakTimeTblViewTag
                placeholder = "Meal Break"
            }
            textField.resignFirstResponder()
            
            if placeholder.count == 0 {
                //Nothing to do
            }else{
                self.view.endEditing(true)
                //                self.showDropDownTableViewWithTag(placeHolder: placeholder, tag: tag)
                textField.resignFirstResponder()
                
                self.showDropDownWithTag(placeHolder: placeholder, tag: tag)
            }
            
        }else {
            textField.resignFirstResponder()
            
            if textField.tag == Int(StartDateTxtFieldTag)! {
                
                let minDate = self.convertDateStringToDefaultDate(dateString: "01/01/1800", formatString: dateFormat)
                if StartDate.count == 0{
                }else{
                    let date = self.convertDateStringToDefaultDate(dateString: StartDate, formatString: dateFormat)
                    customPickerView.dtPickerView.date = date
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.customCalendarView.calendar.setCurrentPage(date, animated: true)
                        self.customCalendarView.calendar.select(date, scrollToDate: true)
                        
                    })                }
                customPickerView.dtPickerView.minimumDate = minDate
                
            }else if textField.tag == Int(EndDateTxtFieldTag)! {
                if StartDate.count > 0 {
                    let minDate = self.convertDateStringToDefaultDate(dateString: StartDate, formatString: dateFormat)
                    customPickerView.dtPickerView.minimumDate = minDate
                }
                if EndDate.count > 0 {
                    let date = self.convertDateStringToDefaultDate(dateString: EndDate, formatString: dateFormat)
                    customPickerView.dtPickerView.date = date
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.customCalendarView.calendar.setCurrentPage(date, animated: true)
                        self.customCalendarView.calendar.select(date, scrollToDate: true)
                        
                    })
                    
                }
                
            }
            firstResponderTxtFieldTag = textField.tag
            
            
            if textField.tag == Int(EndDateTxtFieldTag)! || textField.tag == Int(StartDateTxtFieldTag)!{
                self.customCalendarView.showPickerViewOnSuperView(superView: (self.navigationController?.view)!, isPortrait: self.isPortrait())
            }else{
                
                //Show the  previuosly  selected Time else show current date
                let senderPosition  = textField.convert(CGPoint.zero, to: self.tableView)
                
                let indexPath =  self.tableView.indexPathForRow(at:senderPosition)
                if indexPath != nil{
                    
                    var dict = NSDictionary()
                    
                    if selectedSementTag == 0{
                        dict = dataArray[(indexPath?.row)!] as! NSDictionary
                        
                    }else{
                        dict = multiDayDataArray[(indexPath?.row)!] as! NSDictionary
                    }
                    let startTag = Int(dict["StartTag"] as! String)!
                    let endTag = Int(dict["EndTag"] as! String)!
                    let startValue = dict["StartValue"] as! String
                    let endValue = dict["EndValue"] as! String
                    if textField.tag == startTag{
                        if startValue.count == 0 {
                            customPickerView.dtPickerView.date = Date()
                            
                        }else{
                            let dateFormatter = DateFormatter()
                            dateFormatter.locale = Locale.preferredLocale()
                            dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
                            let time = String(format:"%@ %@",StartDate,startValue)
                            let sTime = dateFormatter.date(from: time)
                            if sTime != nil{
                                customPickerView.dtPickerView.date = sTime!
                            }
                        }
                    }else  if textField.tag == endTag{
                        if endValue.count == 0 {
                            customPickerView.dtPickerView.date = Date()
                            
                        }else{
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.locale = Locale.preferredLocale()
                            dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
                            let time = String(format:"%@ %@",EndDate,endValue)
                            let eTime = dateFormatter.date(from: time)
                            if eTime != nil{
                                customPickerView.dtPickerView.date = eTime!
                            }
                        }
                    }
                }
                customPickerView.dtPickerView.datePickerMode = UIDatePicker.Mode.time
                customPickerView.showPickerViewOnSuperView(superView: (self.navigationController?.view)!, isDatePicker: true,minuteInterval: minuteInterval,isPortrait: self.isPortrait())
            }
            firstResponderTxtFieldTag = textField.tag
        }
        return true
    }
    public func textFieldDidBeginEditing(_ textField: UITextField){
        self.activeField = textField
        
        if textField.tag == empNeededTxtFieldTag || textField.tag == jobTitleTxtFieldTag  || textField.tag == Int(MonStartTxtFieldTag)
            || textField.tag == Int(TueStartTxtFieldTag)
            || textField.tag == Int(WedStartTxtFieldTag)
            || textField.tag == Int(ThuStartTxtFieldTag)
            || textField.tag == Int(FriStartTxtFieldTag)
            || textField.tag == Int(SatStartTxtFieldTag)
            || textField.tag == Int(SunStartTxtFieldTag)
            || textField.tag == Int(MonEndTxtFieldTag)
            || textField.tag == Int(TueEndTxtFieldTag)
            || textField.tag == Int(WedEndTxtFieldTag)
            || textField.tag == Int(ThuEndTxtFieldTag)
            || textField.tag == Int(FriEndTxtFieldTag)
            || textField.tag == Int(SatEndTxtFieldTag)
            || textField.tag == Int(SunEndTxtFieldTag)
        {
            textField.becomeFirstResponder()
            
        }else{
            textField.resignFirstResponder()
            
        }
    }
    public func textFieldDidEndEditing(_ textField: UITextField){
        keyboardShowing = true
        self.activeField = textField
        textField.resignFirstResponder()
        if textField.tag == empNeededTxtFieldTag {
            
            if textField.text?.count == 0{
                textField.text = ""
            }
            if textField.text?.isNumeric == true{
                TempEmployeesNeeded = Int(textField.text!)!
            }else{
                textField.text = ""
            }
        }else if textField.tag == jobTitleTxtFieldTag{
            JobTitleValue = textField.text!
        }
        let senderPosition  = textField.convert(CGPoint.zero, to: self.tableView)
        
        let indexPath =  self.tableView.indexPathForRow(at:senderPosition)
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.tableView.reloadRows(at: [indexPath!], with: .none)
        })
        //        self.tableView.reloadData()
    }
//    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//
//        firstResponderTxtFieldTag = textField.tag
//
//        let senderPosition  = textField.convert(CGPoint.zero, to: self.tableView)
//
//        let indexPath =  self.tableView.indexPathForRow(at:senderPosition)
//
//        //Time
//        if selectedSementTag == 1{
//            self.updateDatesFromPicker(dateString: "", forArray: multiDayDataArray)
//            //multi schdule array
//        }else{
//            //schdule array
//            self.updateDatesFromPicker(dateString: "", forArray: dataArray)
//        }
//
//         DispatchQueue.main.async(execute: { () -> Void in
//            self.tableView.reloadRows(at: [indexPath!], with: .none)
//        })
//         return true
//     }
    
    //MARK: UITEXTVIEW Delegate
    
    public func textViewDidBeginEditing(_ textView: UITextView)
    {
        let modelName = UIDevice.current.modelName
        
        if modelName.contains("iPad"){
        }else{
            self.tableView.isScrollEnabled = false
        }
        //
        if textView.tag == Int(empCommentTxtViewTag) || textView.tag == Int(divisionCommentTxtViewTag){
            if textView.textColor == UIColor.lightGray {
                textView.text = ""
                textView.textColor = UIColor.black
            }
        }
    }
    
    
    public func textViewDidEndEditing(_ textView: UITextView)
    {
        keyboardShowing = true
        
        let modelName = UIDevice.current.modelName
        
        if modelName.contains("iPad"){
        }else{
            self.tableView.isScrollEnabled = true
        }
        textView.resignFirstResponder()
        self.activeTextView = textView
        if textView.tag == Int(empCommentTxtViewTag){
            if textView.text.count == 0 || textView.text == empTextViewPlaceHolder  {
                textView.text = empTextViewPlaceHolder
                textView.textColor = UIColor.lightGray
            }else{
                empCommentText = textView.text
                textView.textColor = UIColor.black
            }
        }else if textView.tag == Int(divisionCommentTxtViewTag){
            if textView.text.count == 0 || textView.text == divisionCommentText  {
                textView.text = divisionTextViewPlaceHolder
                textView.textColor = UIColor.lightGray
            }else{
                divisionCommentText = textView.text
                textView.textColor = UIColor.black
            }
        }else if textView.tag == Int(jobDescTxtViewTag){
            jobDescText = textView.text
            if jobDescText.count == 0{}else{
                isValidJobDesc = true}
        }else if textView.tag == Int(jobDutyTxtViewTag){
            jobDutyText = textView.text
            if jobDutyText.count == 0{}else{
                isValidJobDuty = true}
        }
        
        let senderPosition  = textView.convert(CGPoint.zero, to: self.tableView)
        
        let indexPath =  self.tableView.indexPathForRow(at:senderPosition)
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.tableView.reloadRows(at: [indexPath!], with: .none)
        })
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !keyboardShowing {
            return
        }
        let modelName = UIDevice.current.modelName
        
        if modelName.contains("iPad"){
            self.tableView.contentInset.bottom = 0//view.bounds.height
            
        }
        
    }
    
    //MARK: Delegate Methods
    func createNewOrderFromSummary() {
        
        selectedSementTag = 0
        self.resetAllData()
        self.getROSData()
        
    }
    func selecetdEmployee(_ emps: NSMutableArray) {
        
        
        if emps.count > 0{
            employeeArray.removeAllObjects()
            employeeArray = emps
            
            if employeeArray.count > 0 {
                SubstituteEmpChecked = "1"
                //auto-check the check button
            }
            DispatchQueue.main.async(execute: { () -> Void in
                self.empTableView.reloadData()
                self.tableView.reloadData()
            })
        }
    }
    
    func addedReportTo(_ reportToPerson : ReportTo){
        
        reportToArray.add(reportToPerson)
        selectedReportTo = reportToPerson
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.reloadData()
        })
        
    }
    func addedReportToLocation (_ locationName : ReportToLocation ){}
    func addedReportToLocationOffice (_ locationName : OfficeReportToLocation ){
        
        reportToLocArray.add(locationName)
        selectedReportToLoc = locationName
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    func addReportToForOCC(_ reportTo: OCCReportToExp) {}
    
    //MARK: Navigation Methods
    func pushToOrderSummaryPage(){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is ROSOrderSummaryViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ROSOrderSummarySegue") as! ROSOrderSummaryViewController
            nextViewController.OFFICE_CREATE_ORDER_FLAG = true
            nextViewController.summaryObj = createOrderObj
            nextViewController.summaryDataArray = self.formOrderSummaryData()
            nextViewController.status = "New"
            nextViewController.delegate = self
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func pushToSearchEmpListPage(dataArray: NSMutableArray){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is SearchViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SearchSegue") as! SearchViewController
            nextViewController.isForOffice = true
            nextViewController.isForHospitality = false
            nextViewController.isForSchoolProfessional = false
            for emp in dataArray {
                let  empObj:NewEmployee = emp as! NewEmployee
                if employeeArray.count == 0{
                    empObj.isCheckedInRoaster = "0"
                }else{
                    for eObj in employeeArray{
                        let  emObj:NewEmployee = eObj as! NewEmployee
                        if emObj.CandidateId == empObj.CandidateId{
                            empObj.isCheckedInRoaster = "1"
                        }
                    }
                }
            }
            nextViewController.empDataArray = dataArray
            nextViewController.delegate = self
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    func pushToAddReportToPage(isForReportTo: Bool,isForReportToLoc: Bool){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is AddNewReportToViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddNewReportToSegue") as! AddNewReportToViewController
            
            nextViewController.delegate = self
            nextViewController.isForAddReportToOffice = isForReportTo
            nextViewController.isForAddReportToLocationOffice = isForReportToLoc
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    //Mark: Notification
    func registerNotif() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillAppear() {
        //Do something here
        print("keyboardWillAppear")
    }
    
    @objc func keyboardWillDisappear() {
        //Do something here
        print("keyboardWillDisappear")
    }
    func showDropDownTableViewWithTag( placeHolder: String,tag: Int){
        
        for view in dropDownView.subviews {
            view.removeFromSuperview()
        }
        dropDownView.frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        dropDownView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        let clearView = UIView()
        clearView.backgroundColor = UIColor.white
        clearView.layer.borderColor = borderColor.cgColor
        clearView.layer.cornerRadius = 5
        clearView.frame =  CGRect(x: 10, y: UIScreen.main.bounds.size.height , width: UIScreen.main.bounds.size.width - 20, height: 270)
        
        let titleLabel = UILabel.init(frame: CGRect(x: 10, y: 0, width: clearView.bounds.size.width - 20, height: 40))
        titleLabel.text = placeHolder
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.darkGray
        titleLabel.backgroundColor = UIColor.clear
        clearView.addSubview(titleLabel)
        
        //UItableview
        alertDropDownTableView.tableFooterView = UIView()
        alertDropDownTableView.delegate = self
        alertDropDownTableView.dataSource = self
        alertDropDownTableView.frame = CGRect(x: 10, y: titleLabel.frame.size.height, width: clearView.bounds.size.width - 20 , height: clearView.bounds.size.height -  titleLabel.frame.size.height )
        alertDropDownTableView.tag = tag
        alertDropDownTableView.backgroundColor = UIColor.white
        DispatchQueue.main.async(execute: { () -> Void in
            self.alertDropDownTableView.reloadData()
        })
        clearView.addSubview(alertDropDownTableView)
        
        
        UIView.animate(withDuration: 0.5, animations: {
            
            clearView.frame =  CGRect(x: 10, y: UIScreen.main.bounds.size.height - 270, width: UIScreen.main.bounds.size.width - 20, height: 270)
            
        }) { (animationComplete) in
        }
        
        dropDownView.addSubview(clearView)
        self.navigationController?.view.addSubview(dropDownView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dropDownTapGesture))
        tap.delegate = self
        dropDownView.addGestureRecognizer(tap)
        
    }
    
    @objc func dropDownTapGesture(sender: UITapGestureRecognizer?) {
        dropDownView.removeFromSuperview()
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.tableView.reloadData()
        })
    }
    // UIGestureRecognizerDelegate method
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if (touch.view?.isDescendant(of: self.alertDropDownTableView))! || (touch.view?.isDescendant(of:  self.tableView))! || (touch.view?.isDescendant(of:  self.empTableView))! {
            return false
        }
        return true
    }
    
    func removeDropDown(){
        dropDownView.removeFromSuperview()
    }
    
    //MARK: Screen Orientation
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.addDivisionNameOnTop()
            
            self.customPickerView.showPickerViewInOrientation(superView: (self.navigationController?.view)!, isPortrait: self.isPortrait())
            self.customCalendarView.showPickerViewInOrientation(superView: (self.navigationController?.view)!, isPortrait: self.isPortrait())
        })
        
    }
    //MARK: Calendar
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        /*
         Printing description of date:
         ▿ 2018-11-12 18:30:00 +0000
         - timeIntervalSinceReferenceDate : 563740200.0
         */
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        
        let pickedDateString = formatter.string(from: date)
        
        if firstResponderTxtFieldTag == Int(StartDateTxtFieldTag) || firstResponderTxtFieldTag == Int(EndDateTxtFieldTag) {
            
            if selectedSementTag == 0{
                self.updateDatesFromPicker(dateString: pickedDateString, forArray: dataArray)
            }else{
                self.updateDatesFromPicker(dateString: pickedDateString, forArray: multiDayDataArray)
            }
        }
        customCalendarView.removePickerViewFromSuperView()
        
        
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
