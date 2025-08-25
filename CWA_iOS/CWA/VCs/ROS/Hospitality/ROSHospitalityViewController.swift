//
//  ROSHospitalityViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 08/01/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON
import FSCalendar
import  Toast_Swift

class ROSHospitalityViewController: BaseTableViewController,UICollectionViewDelegateFlowLayout ,UIGestureRecognizerDelegate,FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance{
 
   
    
    let SearchButtonCellIdentifier = "ButtonTableViewCellIdentifier"
    
    let NextButtonCellIdentifier = "NextTableViewCellIdentifier"
    
   var keyboardShowing = false
    
    var empTableView: UITableView!
    
    var customPickerView = JPPickerView()
    var customCalendarView = CalendarView()
    
    var createOrderObj = NSDictionary()
    var saveEditOrderObj = NSDictionary()
    
    var isWarningMessage = false
    var isErrorMessage = false
    
    var firstResponderTxtFieldTag = 0
    let empTblViewTag =  1005
    var segHeader = ""
    //MARK: Textfiled Tags
    let MonStartTxtFieldTag = "10001"
    let MonEndTxtFieldTag = "10002"
    
    let TueStartTxtFieldTag = "10003"
    let TueEndTxtFieldTag = "10004"
    
    let WedStartTxtFieldTag = "10005"
    let WedEndTxtFieldTag = "10006"
    
    let ThuStartTxtFieldTag = "10007"
    let ThuEndTxtFieldTag = "10008"
    
    let FriStartTxtFieldTag = "10009"
    let FriEndTxtFieldTag = "100010"
    
    let SatStartTxtFieldTag = "100011"
    let SatEndTxtFieldTag = "100012"
    
    let SunStartTxtFieldTag = "100013"
    let SunEndTxtFieldTag = "100014"
    
    let StartDateTxtFieldTag = "100015"
    let EndDateTxtFieldTag = "100016"
    
    let StartTimeTxtFieldTag = "100017"
    let EndTimeTxtFieldTag = "100018"
    
    let reportToTxtFieldTag = 1004
    let empNeededTxtFieldTag = 100019
    let eventTxtFieldTag = 100020
    let positionTxtFieldTag = 100021
    let reportToLocTxtFieldTag = 100022
    
    let empCommentTxtViewTag = "100023"
    let divisionCommentTxtViewTag = "100024"
    
    var TempEmployeesNeeded = 0
    var activeField: UITextField?
    var activeTextView: UITextView?
    var minuteInterval = 0
    var orderID = 0
    var isCopyOrder = false
    let divisionTextViewPlaceHolder = ""
    
    let empTextViewPlaceHolder = ""
    var eventPlaceHolder = "Event"
    let ReportToLocationPlaceHolder = "Report To Location *"
    let StartDatePlaceHolder = "Start Date *"
    let EndDatePlaceHolder = "End Date *"
    let StartTimePlaceHolder = "Start Time *"
    let EndTimePlaceHolder = "End Time *"
    let ReportToPlaceHolder = "Report To *"
    let PositionPlaceHolder = "Position *"
    let EmployeesNeededPlaceHolder = "No. of employees needed *"
    let IncludeWeekendPlaceHolder = "Include Weekend?"
    let DisplayAllowOTPlaceHolder = "I would like to offer this position to staff that may be able to work the assignment however may already be at 40 hours for the week or 8 hours for the day and if they work this assignment it would be paid and billed at overtime."
    let substituteEmpPlaceHolder = "If one or more of the selected employees is not available, check here if we may substitute other qualified employees."
    var StartDate = ""
    var EndDate = ""
    var SelectedHeaderName  = "Order With Varying Schedule"
    var  HeaderName  = "Order With Same Schedule"
    
    var empCommentText = ""
    var divisionCommentText = ""
    var empListTableView = UITableView()
    
    
    var selectedReportTo = ReportTo.init(ContactId: 0, Name: "",isSelected: "")
    var selectedPositionType = HOSPositionType.init(KeyValue: "",PositionName: "",isSelected: "" )
    var selectedReportToLoc = ReportToLocation.init(ReportToLocation: "",Split_Add: "",isSelected: "",ReportId: "")
    var eventName = ""
    var DisplayAllowOT = -1
    
    var reportToArray = NSMutableArray()
    var reportToLocArray = NSMutableArray()
    var positionArray = NSMutableArray()
    var employeeArray = NSMutableArray()
    var dataArray = NSMutableArray()
    var multiDayDataArray = NSMutableArray()
    var selectedEmployeeArray = NSMutableArray()
    var weekDayArray = NSMutableArray()
    var ResponseEmployeeArray = NSMutableArray()
    
    var selectedSementTag = 0
    
    //MSRK: Validation Variables
    
    var isValidReportToLocation = true
    var isValidReportTo = true
    var isValidPosition = true
    var isValidEmployeeNeeded = true
    var isValidStartTime = true
    var isValidEndTime = true
    
    var allDataValidated = false
    
    
    //MARK: Post Params
    var StartTime = ""
    var EndTime = ""
    var ReportToAddress = ""
    var ReportToCity = ""
    var ReportToPhone = ""
    var ReportToZip = ""
    var ReportToFax = ""
    var ReportToState = ""
    
    
    //    var startDate = ""
    //    var endDate = ""
    //    var startTime = ""
    //    var endTime = ""
    var EmpNeed = ""
    var chkSendComp = ""
    var SelectedEmployeeNames = ""
    
    var WednesdayStartTime = ""
    var WednesdayEndTime = ""
    var MondayStartTime = ""
    var MondayEndTime = ""
    var TuesdayStartTime = ""
    var TuesdayEndTime = ""
    var ThursdayStartTime = ""
    var ThursdayEndTime = ""
    var FridayStartTime = ""
    var FridayEndTime = ""
    var SaturdayStartTime = ""
    var SaturdayEndTime = ""
    var SundayStartTime = ""
    var SundayEndTime = ""
    var IncludeWeekend = "false"
    var IsCheckAllowOT = "false"
    var SubstituteEmpChecked = "0"
    var DivisionId = ""
    
    func resetAllData(){
        
        selectedSementTag = 0
        
        reportToArray.removeAllObjects()
        reportToLocArray.removeAllObjects()
        positionArray.removeAllObjects()
        employeeArray.removeAllObjects()
        dataArray.removeAllObjects()
        
        selectedReportTo = ReportTo.init(ContactId: 0, Name: "",isSelected: "")
        selectedReportToLoc = ReportToLocation.init(ReportToLocation: "",Split_Add: "",isSelected: "", ReportId: "")
        selectedPositionType = HOSPositionType.init(KeyValue: "",PositionName: "",isSelected: "" )
        
        multiDayDataArray.removeAllObjects()
        selectedEmployeeArray.removeAllObjects()
        weekDayArray.removeAllObjects()
        ResponseEmployeeArray.removeAllObjects()
        
        createOrderObj = NSDictionary()
        TempEmployeesNeeded = 0
        empTableView.reloadData()
        self.tableView.reloadData()
        empCommentText = ""
        divisionCommentText = ""
        eventName = ""
        self.StartTime = ""
        self.EndTime = ""
        self.formMultiDayArray()
        
    }
    @objc override func appWillEnterForeground(){
        print("appWillEnterForeground Division")
        
        if dataArray.count == 0{
            self.getROSData()
        }
        
    }
    //MARK: View Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.orderID == 0{
            self.titlelbl.text = "Rapid Order System"
        }else{
            if self.isCopyOrder == true{
                self.titlelbl.text = "Rapid Order System"
            }else{
                
                self.titlelbl.text = "Edit Order"
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        if self.orderID > 0 && DivisionId == "92"{
            eventPlaceHolder = "Reference Note"
        }
        
        //        self.isKeyboardOnScreen()
        
        selectedSementTag = 0
        self.formMultiDayArray()
        self.setupPickerView()
        self.setupCalendarView()
        if self.orderID == 0{
            self.getROSData()
        }else{
            if self.isCopyOrder == true{
                self.getCopyOrderData()
                
            }else{
                self.GetEditOrderDataServerCall()
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func setupPickerView(){
        customPickerView = Bundle.main.loadNibNamed("JPPickerView", owner: self, options: nil)?[0] as! JPPickerView
        
        customPickerView.setupUI()
        customPickerView.dataPickerView.delegate = self
        customPickerView.dataPickerView.dataSource = self
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
        
        let monDict = ["day":"MON","header":startTimePlaceHolder,"showDropDown":"0","StartTag":MonStartTxtFieldTag,"EndTag":MonEndTxtFieldTag,"StartValue":"","EndValue":"","subHeader":endTimePlaceHolder]
        let tuesDict = ["day":"TUE","header":startTimePlaceHolder,"showDropDown":"0","StartTag":TueStartTxtFieldTag,"EndTag":TueEndTxtFieldTag,"StartValue":"","EndValue":"","subHeader":endTimePlaceHolder]
        let wedDict = ["day":"WED","header":startTimePlaceHolder,"showDropDown":"0","StartTag":WedStartTxtFieldTag,"EndTag":WedEndTxtFieldTag,"StartValue":"","EndValue":"","subHeader":endTimePlaceHolder]
        let thurDict = ["day":"THU","header":startTimePlaceHolder,"showDropDown":"0","StartTag":ThuStartTxtFieldTag,"EndTag":ThuEndTxtFieldTag,"StartValue":"","EndValue":"","subHeader":endTimePlaceHolder]
        let friDict = ["day":"FRI","header":startTimePlaceHolder,"showDropDown":"0","StartTag":FriStartTxtFieldTag,"EndTag":FriEndTxtFieldTag,"StartValue":"","EndValue":"","subHeader":endTimePlaceHolder]
        let satDict = ["day":"SAT","header":startTimePlaceHolder,"showDropDown":"0","StartTag":SatStartTxtFieldTag,"EndTag":SatEndTxtFieldTag,"StartValue":"","EndValue":"","subHeader":endTimePlaceHolder]
        let sunDict = ["day":"SUN","header":startTimePlaceHolder,"showDropDown":"0","StartTag":SunStartTxtFieldTag,"EndTag":SunEndTxtFieldTag,"StartValue":"","EndValue":"","subHeader":endTimePlaceHolder]
        
        
        
        weekDayArray = [monDict,tuesDict,wedDict,thurDict,friDict,satDict,sunDict]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:  Action
    @IBAction override func okButtonTapped(_ sender: Any) {
        self.tAlertController.dismiss(animated: true, completion: nil)
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
        if isWarningMessage == true{
            self.pushToOrderSummaryPage()
        }else if isErrorMessage == true{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0{
            selectedSementTag = 0
            segHeader = HeaderName
        }else{
            selectedSementTag = 1
            segHeader = SelectedHeaderName
            
        }
        self.tableView.reloadData()
    }
    @objc func submitEditButtonTapped(sender: UIButton){
        
        if self.validateSaveEditOrderData() == true{
            self.saveEditOrderAPI()
        }
    }
    
    //MARK:- NextButton Action
    
    @objc func nextButtonTapped(sender: UIButton) {
        let isValidated = self.validatePositionTab()
        if isValidated == true{
            sender.isEnabled = false
            self.createOrderAPICall()
        }else{
            isWarningMessage = false
            isErrorMessage = false
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Please enter all the mandatory fields   ", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
    }
    @IBAction func addReportToLocBtnTapped(_ sender: UIButton) {
        
        self.pushToAddReportToPage(isForReportTo: false, isForReportToLoc: true)
        
    }
    @IBAction func addReportToBtnTapped(_ sender: UIButton) {
        
        self.pushToAddReportToPage(isForReportTo: true, isForReportToLoc: false)
        
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
        empTableView.reloadData()
        self.tableView.reloadData()
        
    }
    /////start
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
            print(indexArray)
            
            let a = NSArray.init(array: indexArray)
            let sortedArray = a.ascendingArrayWithKeyValue(key: "")
            
            print(sortedArray)
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
                            print(indexOfObj)
                            indexArray.add(indexOfObj)}
                    }
                }
            }
            print(indexArray)
            
            let a = NSArray.init(array: indexArray)
            let sortedArray = a.discendingArrayWithKeyValue(key: "")
            
            print(sortedArray)
            
            if sortedArray.contains(employeeArray.count - 1){
                //if any element is on down no need to move down again
            }else{
                //increase indexpath of array and reload tableview
                var index = -1
                for i  in sortedArray{
                    index = Int(String(describing: i))!
                    print(index)
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
    ////end
    
    ////end
    
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
        empTableView.reloadData()
        //        self.reloadTableViewRow(sender: sender)
        
    }
    @objc func searchBtnTapped(sender: UIButton)  {
        
        if selectedPositionType.KeyValue?.count == 0{
            isValidPosition = false
        }else{
            isValidPosition = true
        }
        
        if StartTime.count == 0{
            if selectedSementTag == 0{
                isValidStartTime = false
                
            }else{
                isValidStartTime = true
                
            }
        }else{
            isValidStartTime = true
        }
        if EndTime.count == 0{
            if selectedSementTag == 0{
                isValidEndTime = false
            }else{
                isValidEndTime = true
            }
            
        }else{
            isValidEndTime = true
            
        }
        if selectedReportTo.Name?.count == 0{
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
        
        if isValidPosition == true && isValidStartTime == true  && isValidEndTime == true && isValidReportTo == true && isValidEmployeeNeeded == true {
            
//            if ResponseEmployeeArray.count == 0{
                self.getSearchedEmployee()
//            }else{
//                //push to employee list screen
//                self.pushToSearchEmpListPage(dataArray: ResponseEmployeeArray)
//
//            }
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
        
        
        
    }
    @objc func DisplayAllowOTBtnTapped(sender: UIButton){
        if sender.isSelected == true{
            sender.isSelected = false
            IsCheckAllowOT = "false"
        }else{
            sender.isSelected = true
            IsCheckAllowOT = "true"
        }
        //        self.reloadTableViewRow(sender: sender)
        //self.listTableView.reloadData()
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
        self.tableView.reloadData()
        
    }
    @objc func timeButtonTapped(sender:UIButton) {
        
      
        if firstResponderTxtFieldTag == empNeededTxtFieldTag || firstResponderTxtFieldTag == eventTxtFieldTag ||  firstResponderTxtFieldTag == reportToTxtFieldTag || firstResponderTxtFieldTag == reportToLocTxtFieldTag || firstResponderTxtFieldTag == positionTxtFieldTag || firstResponderTxtFieldTag == Int(StartDateTxtFieldTag)!  ||  firstResponderTxtFieldTag == Int(EndDateTxtFieldTag)! {
            
        }else{
            //Show the  previuosly  selected Time else show current date
                 let changedDate = customPickerView.dtPickerView.date
                customPickerView.dtPickerView.locale = NSLocale(localeIdentifier: "en_US") as Locale
                self.setDatePickerValue(changedDate: changedDate)
         }
        
        

        if customPickerView.dataPickerView.selectedRow(inComponent: 0) == 0{
            
            if firstResponderTxtFieldTag ==  Int(reportToTxtFieldTag){
                let obj = reportToArray[0]
                let  o:ReportTo = obj as! ReportTo
                selectedReportTo = o
                isValidReportTo = true
            }else if firstResponderTxtFieldTag ==  Int(reportToLocTxtFieldTag){
                let obj = reportToLocArray[0]
                
                let  selectedReportToLocObj:ReportToLocation = obj as! ReportToLocation
                selectedReportToLoc = selectedReportToLocObj
                isValidReportToLocation = true
            }else if firstResponderTxtFieldTag ==  Int(positionTxtFieldTag){
                
                let obj = positionArray[0]
                
                let  o:HOSPositionType = obj as! HOSPositionType
                selectedPositionType =  o
                isValidPosition = true
                self.getEmployeeCommentAfterSelectingPosition()
            }
            self.tableView.reloadData()
        }
        customPickerView.removePickerViewFromSuperView()
        
    }
    @objc func keyboardDoneBtnTapped(sender: UIButton)  {
        self.view.endEditing(true)
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
        self.tableView.reloadData()
        //        self.reloadTableViewRow(sender: sender)
    }
    @objc func clearEndTimeBtnTapped(sender: UIButton){
        
        //        let btnTag = String(format:"%d",sender.tag)
        firstResponderTxtFieldTag = sender.tag
        
        
        //Time
        if selectedSementTag == 1{
            self.updateDatesFromPicker(dateString: "", forArray: multiDayDataArray)
            //multi schdule array
        }else{
            //schdule array
            self.updateDatesFromPicker(dateString: "", forArray: dataArray)
            
        }
        
        self.tableView.reloadData()
        
    }
    func reloadTableViewRow(sender: UIButton) {
        
        let senderPosition  = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath =  self.tableView.indexPathForRow(at:senderPosition)
        let indexPaths = IndexPath(item: (indexPath?.row)!, section: 0)
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.reloadRows(at: [indexPaths], with: .none)
        })
        
    }
    
    
    func updateWeeklyTimePickerValue(forArray: NSMutableArray,dateString: String){
        
        var indexOfObj = -1
        
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
            
            if startTag == firstResponderTxtFieldTag {
                mutableDObj["StartValue"] = dateString
                if firstResponderTxtFieldTag == Int(StartDateTxtFieldTag){
                    mutableDObj["EndValue"] = dateString
                }
            }
            if endTag == firstResponderTxtFieldTag {
                mutableDObj["EndValue"] = dateString
            }
            if indexOfObj >= 0{
                if firstResponderTxtFieldTag == Int(StartDateTxtFieldTag) || firstResponderTxtFieldTag == Int(EndDateTxtFieldTag){
                    dataArray.replaceObject(at: indexOfObj, with: mutableDObj)
                    multiDayDataArray.replaceObject(at: indexOfObj, with: mutableDObj)
                }else{
                    
                    forArray.replaceObject(at: indexOfObj, with: mutableDObj)
                }
                
            }
        }
        
    }
    func updateDatesFromPicker(dateString: String,forArray: NSMutableArray){
        var indexOfObj = -1
        var placeholderheader = ""
        
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
        var isMatches = false
        if indexOfObj >= 0{
            let   dictObj : NSDictionary = forArray[indexOfObj] as! NSDictionary
            let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dictObj)
            
            let startTag = Int(mutableDictObj["StartTag"] as! String)
            let endTag = Int(mutableDictObj["EndTag"] as! String)
            
            if startTag == firstResponderTxtFieldTag {
                //once start date is changed ,end date should change change accordingly
                mutableDictObj["StartValue"] = dateString
                StartDate = dateString
                //                if selectedSementTag == 0{
                //                    mutableDictObj["EndValue"] = dateString
                //                }
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
                            EndDate = dateString
                        }
                    case .orderedSame?          :
                        print("The two dates are the same")
                    case .none: break
                    }
                }
                isMatches = true
                
            }
            if endTag == firstResponderTxtFieldTag {
                mutableDictObj["EndValue"] = dateString
                EndDate = dateString
                isMatches = true
            }
            if isMatches ==  true {
                forArray.replaceObject(at: indexOfObj, with: mutableDictObj)
            }else{
                print("Did not matched")
                //Again Check with the tag
                self.updateWeeklyTimePickerValue(forArray: forArray, dateString: dateString)
            }
            self.tableView.reloadData()
            
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
                    
                    let stringArray = pickedDateString.components(separatedBy: " ")
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
                                if min == "0"{
                                    min = "00"
                                }
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
                        if min == "0"{
                            min = "00"
                        }
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
        self.tableView.reloadData()

    }
    @objc func datePickerValueChanged(sender: UIDatePicker){
        
        sender.locale = NSLocale(localeIdentifier: "en_US") as Locale
        //▿ 2017-10-29 11:20:00 +0000
        let changedDate = sender.date
        
       self.setDatePickerValue(changedDate: changedDate)
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
    
    //MARK: UITableView Methods
    
    //MARK: UICollectionView Methods
    
    //MARK: Server Call
    func validateCreateOrderData(){
        
        print(createOrderObj)
        
        let urlString = RestAPI.BaseUrl+RestAPI.ROSHospitalityValidateCreateOrderURL
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
            tableView.reloadData()
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                //                let continueMessage = object["Message"].stringValue
                //                if continueMessage == "Some of the time entries exceed 12 or more than 12 hour . Are you sure you want to continue ?"{
                //                    isWarningMessage = true
                //                    isErrorMessage = false
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
                    tableView.reloadData()
                    isWarningMessage = true
                    isErrorMessage = false
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: continueMessage, okBtnTitle: "OK", cancelBtnTitle: "Cancel", type: Danger_Text, isAttributed: false)
                }
                
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                tableView.reloadData()
                isWarningMessage = false
                isErrorMessage = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
            
        }
        
    }

    func getEmployeeCommentAfterSelectingPosition() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            //            JustHUD.shared.showInView(view: view)
            self.showLoading()
            
            let PositionID = String(format:"%@", selectedPositionType.KeyValue!)
            
            let params :[String:String] = ["PositionID" : PositionID]
            print(params)
            RestAPI.getROSHospitalityEmpComments(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getCommentResponse(response:))
        }else{
            isWarningMessage = false
            isErrorMessage = false
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    func GetEditOrderDataServerCall(){
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            //            JustHUD.shared.showInView(view: view)
            self.showLoading()
            
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            let orderId = String(format:"%d", self.orderID)
            //            {"OrderId":954683,"contactId":194847,"message":null,"ClientId":70829}
            let params :[String:String] = ["contactId" : ContactId , "ClientID" : clientID,"OrderId":orderId]
            print(params)
           
            RestAPI.EditOrders(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getEditOrderResponse(response:))
        }else{
            
             isWarningMessage = false
            isErrorMessage = false
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    func getCopyOrderData() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            //            JustHUD.shared.showInView(view: view)
            self.showLoading()
            
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let DivisionId = String(format:"%d", defaults.integer(forKey: "DivisionId"))
            let orderId = String(format:"%d", self.orderID)
            
            
            let params :[String:String] = ["DivId" : DivisionId , "ClientID" : clientID,"OrderId": orderId]
            print(params)
            
            RestAPI.getCopyOrderForHospitality(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getROSResponse(response:))
        }else{
            
            //            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
            isWarningMessage = false
            isErrorMessage = false
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    func getROSData() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            //            JustHUD.shared.showInView(view: view)
            self.showLoading()
            
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let DivisionId = String(format:"%d", defaults.integer(forKey: "DivisionId"))
            
            
            let params :[String:String] = ["DivId" : DivisionId , "ClientID" : clientID]
            print(params)
            
            RestAPI.getROSHospitality(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getROSResponse(response:))
        }else{
            
            //            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
            isWarningMessage = false
            isErrorMessage = false
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    func getEditOrderResponse(response:AnyObject)->()
    {
        
        //        JustHUD.shared.hide()
        self.hideLoading()
        
        print(response)
        if response is String{
            isWarningMessage = false
            isErrorMessage = false
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                
                let orderDataArray = NSMutableArray()
                
                orderDataArray .removeAllObjects()
                positionArray .removeAllObjects()
                let reportToDataArray = object["ReportTo"].array // as! NSMutableArray
                
                let reportToLocDataArray  = object["ReportToLocationValues"].array  //as! NSMutableArray
                
                
                minuteInterval = object["stepping"].intValue
                
                SelectedHeaderName  = object["SelectedHeaderName"].stringValue
                
                HeaderName  = object["HeaderName"].stringValue
                segHeader = HeaderName
                TempEmployeesNeeded = object["EmpNeeded"].intValue
                selectedReportToLoc.ReportToLocation = object["ReportToLocationValue"].stringValue
                
                //By default 1st item wil be selected
                
                for dict in reportToLocDataArray! {
                    let reportoLocName = ReportToLocation.init(ReportToLocation: dict["Text"].stringValue, Split_Add: dict["Value"].stringValue,isSelected: "0", ReportId: dict["ReportTolocationId"].stringValue)
                    if selectedReportToLoc.ReportToLocation == dict["Text"].stringValue || selectedReportToLoc.ReportToLocation == dict["Value"].stringValue{
                        selectedReportToLoc.Split_Add = dict["Value"].stringValue
                    }
                    reportToLocArray.add(reportoLocName)
                }
                for dict in reportToDataArray! {
                    
                    let posType = ReportTo.init(ContactId: dict["Value"].intValue,Name: dict["Text"].stringValue,isSelected: "0" )
                    reportToArray.add(posType)
                }
                
                
                
                StartTime = object["StartTime"].stringValue
                EndTime = object["EndTime"].stringValue
                eventName = object["Event"].stringValue
                empCommentText = object["RegionEmp"].stringValue
                divisionCommentText = object["intteliComments"].stringValue
                selectedReportTo.Name = object["ReportToName"].stringValue
                selectedReportTo.ContactId = object["ReportToValue"].intValue
                self.formEditOrderDataArrayForTableview()
                
                
            }else{
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message =    Error_Message
                    
                }
                
                
                isErrorMessage = true
                isWarningMessage = false
                
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
                let OTMessage = object["Note"].stringValue
                let spreadOfHoursMessage = object["NoteSpreadOfHours"].stringValue

                var NoteMessage = String(format:"%@\n\n%@",OTMessage,spreadOfHoursMessage )
                if spreadOfHoursMessage.count == 0 || OTMessage.count == 0{
                    NoteMessage = NoteMessage.replace(target: "\n", withString: "")
                }
                let empDataArray = NSMutableArray()
                if (empArray?.count)! > 0{
                    for dict in empArray! {
                        
                        let Weekly_Hours = String(format:"%.2f",dict["WeeklyHours"].doubleValue)
                        let YTD_Hours = String(format:"%.2f",dict["YTDHours"].doubleValue)
                        let Eval = String(format:"%d",dict["Eval"].intValue)
                        
                        let empObj = NewEmployee.init(CandidateId: dict["CandidateId"].intValue, Name: dict["Name"].stringValue, lastDate: dict["LastOrderDate"].stringValue, Weekly_Hours: Weekly_Hours, positions: dict["Position"].stringValue, Eval: Eval, YTD_Hours: YTD_Hours, isCheckedInRoaster:  "0",isSelected: "0",Photo: dict["Photo"].stringValue,Evaluation: dict["Evaluation"].doubleValue,DummyImagePath:dict["DummyImagePath"].stringValue,ShowOT : dict["ShowOT"].stringValue,OTNote : dict["Message"].stringValue, IsSpreadOfHour : dict["IsSpreadOfHour"].stringValue,MessageSpreadofHours : dict["MessageSpreadofHours"].stringValue,isfavourite:dict["isfavourite"].intValue,favColor:dict["FavoriteColor"].stringValue)
                        
                        
                        empDataArray.add(empObj)
                    }
                }
                ResponseEmployeeArray =  empDataArray
                
                if empDataArray.count == 0{
                    //                    self.ShowAlertMessage(message: "No employee found", title: "")
                    isWarningMessage = false
                    isErrorMessage = false
                    
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "No employee found", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                    
                }else{
                    
                    //push to employee list screen
                    self.pushToSearchEmpListPage(dataArray: empDataArray,message: NoteMessage)
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
    func getSearchedEmployee(){
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
             self.showLoading()
            
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            
            let Positions = String(format:"%@",selectedPositionType.KeyValue!)
 
            
            let tempArray = NSMutableArray()
            
            if selectedSementTag == 0{
                tempArray.removeAllObjects()
            }else{
                for dict in multiDayDataArray {
                    print(dict)
                    let dictObj:NSDictionary = dict as! NSDictionary
                    if dictObj["StartTag"] != nil{
                        
                        var day = ""
                        if dictObj["day"] != nil{
                            day = dictObj["day"] as! String
                        }
                        
                        let StartValue = dictObj["StartValue"] as! String
                        let EndValue = dictObj["EndValue"] as! String
                        var dayValue = ""
                        
                        if  day == "SUN" {
                            dayValue = "1"
                        }
                        if   day == "MON" {
                            dayValue = "2"
                        }
                        if   day == "TUE"{
                            dayValue = "3"
                        }
                        if   day == "WED"{
                            dayValue = "4"
                        }
                        if   day == "THU"{
                            dayValue = "5"
                        }
                        if  day == "FRI"{
                            dayValue = "6"
                        }
                        if   day == "SAT"{
                            dayValue = "7"
                        }
                        
                        if day.count > 0 && (StartValue.count > 0 || EndValue.count > 0){
                            let dict = ["AdvanceDay":dayValue,"AdvanceStartTime":StartValue,"AdvanceEndTime":EndValue]
                            if !tempArray.contains(dict){
                                tempArray .add(dict)
                            }
                        }
                        
                    }
                }

            }
            var CheckDiv81 = false
            if IsCheckAllowOT == "true"{
              CheckDiv81 = true
            }
            let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))

            let params  = ["Positions" : Positions , "ClientID" : clientID ,"StartDate" : StartDate, "EndDate" : EndDate,"EndTime" : EndTime,"StartTime" : StartTime,"IsCheckAllowOT":"true","SelectedHeaderName":segHeader,"AdvanceScheduleList":tempArray,"CheckDiv81":CheckDiv81,"DivId":DivisionId,"PositionTitle":selectedPositionType.PositionName!] as [String : Any]  as NSDictionary

            print(tempArray)
            print(params)

            let urlString = RestAPI.BaseUrl+RestAPI.HospitalitySearchEmployeeURL
            RestAPI.postRequestWithToken(urlString: urlString, params: params, callback: getSearchedEmpResponse(response:))

         }else{
            isWarningMessage = false
            isErrorMessage = false
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    
    func getCommentResponse(response:AnyObject)->()
    {
        
        //        JustHUD.shared.hide()
        self.hideLoading()
        
        print(response)
        if response is String{
            isWarningMessage = false
            isErrorMessage = false
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                empCommentText =  object["Comments"].stringValue
                self.tableView.reloadData()
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                
            }
        }
    }
    func saveEditOrderAPI(){
        /*
         {"StartTime":"01:00 AM","EndTime"10:00 AM","ReportTo":"194847","ReportToLocation":null,"ReportToLocationValue":"420 Lexington Avenue||Manhattan|NY|10170|","ReportToLocationName":null,"ReportToName":"","ClientID":0,"EmpNeed":"1","RegionEmp":"testing","OrderSource":null,"Intelistaff":"testing","Event":"testing","orderid":954683,"ContactId":194847,"ClientId":70829}
         */
        self.showLoading()
        let defaults = UserDefaults.standard
        
        let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
        let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
        let UserName  = String(format:"%@", defaults.string(forKey: "UserName")!)
        
        saveEditOrderObj =
            ["ClientID" : clientID,
             "Divid" : DivisionId,
             "ContactName" : UserName,
             "ContactId" : ContactId,
             "orderid" : self.orderID,
             "ordersource" : "iOS",
             "EndTime" : EndTime.uppercased(),
             "Event" : eventName,
             "Intelistaff" : divisionCommentText,
             "RegionEmp" : empCommentText,
             "ReportTo" : selectedReportTo.ContactId!,
             "ReportToLocationValue" : selectedReportToLoc.ReportToLocation!,//Split_Add
                "ReportToLocationName" : selectedReportToLoc.Split_Add!,
                "ReportToName" : selectedReportTo.Name!,
                "StartTime" : StartTime.uppercased(),
                "EmpNeed" : TempEmployeesNeeded
              
            ] as [String : Any] as NSDictionary
        
        let urlString = RestAPI.BaseUrl+RestAPI.Save_Edit_Order_URL
        print(self.saveEditOrderObj)
        RestAPI.postRequestWithToken(urlString: urlString, params: self.saveEditOrderObj, callback: saveEditOrderResponse(response:))
        
    }
    func saveEditOrderResponse(response:AnyObject)->()
    {
        self.hideLoading()
        JustHUD.shared.hide()
        print(response)
        if response is String{
            var message = response as! String
            if message.count == 0 {
                message = Error_Message
            }
            isErrorMessage = false
            isWarningMessage = false
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }else{
            var object = response as! JSON
            if object["MessageStatus"].intValue == 1
            {
                
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = "You have successfully submitted the changes."
                    
                }
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                
            }else{
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message //"There is some error while geeting data"
                    
                }
                isErrorMessage = false
                isWarningMessage = false
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
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
            isErrorMessage = true
            isWarningMessage = false
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
            
        }else{
            
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                let orderDataArray = NSMutableArray()
                
                orderDataArray .removeAllObjects()
                positionArray .removeAllObjects()
                let reportToDataArray = object["ReportToList"].array // as! NSMutableArray
                
                let reportToLocDataArray  = object["ReportToLocationList"].array  //as! NSMutableArray
                
                
                minuteInterval = object["stepping"].intValue
                
                SelectedHeaderName  = object["SelectedHeaderName"].stringValue
                
                HeaderName  = object["HeaderName"].stringValue
                segHeader = HeaderName
                if object["PositionsList"].null == nil{
                    let positionsDataArray = object["PositionsList"].array // as! NSMutableArray
                    for dict in positionsDataArray! {
                        if isCopyOrder == true &&  self.orderID > 0{
                            let posType = HOSPositionType.init(KeyValue: dict["Value"].stringValue,PositionName: dict["Text"].stringValue ,isSelected: "0")
                            positionArray.add(posType)
                            
                        }else{
                            let posType = HOSPositionType.init(KeyValue: dict["KeyValue"].stringValue,PositionName: dict["Description"].stringValue ,isSelected: "0")
                            positionArray.add(posType)
                            
                        }
                    }
                }
                //By default 1st item wil be selected
                
                for dict in reportToLocDataArray! {
                    if isCopyOrder == true &&  self.orderID > 0{
                        let reportoLocName = ReportToLocation.init(ReportToLocation: dict["Text"].stringValue, Split_Add: dict["Value"].stringValue,isSelected: "0", ReportId: dict["ReportTolocationId"].stringValue)
                        reportToLocArray.add(reportoLocName)
                        
                    }else{
                        let reportoLocName = ReportToLocation.init(ReportToLocation: dict["ReportToLocation"].stringValue, Split_Add: dict["Split_Add"].stringValue,isSelected: "0", ReportId: dict["ReportTolocationId"].stringValue)
                        reportToLocArray.add(reportoLocName)
                        
                    }
                }
                for dict in reportToDataArray! {
                    if isCopyOrder == true &&  self.orderID > 0{
                        let reportToObj = ReportTo.init(ContactId: dict["Value"].intValue,Name: dict["Text"].stringValue,isSelected: "0" )
                        reportToArray.add(reportToObj)
                        
                    }else{
                        let reportToObj = ReportTo.init(ContactId: dict["ContactId"].intValue,Name: dict["ReportToName"].stringValue,isSelected: "0" )
                        reportToArray.add(reportToObj)
                        
                    }
                }
                
                self.empCommentText = object["AdditionalComments"].stringValue
                self.divisionCommentText = object["StaffComments"].stringValue
                
                StartDate = object["StartDate"].stringValue
                EndDate = object["EndDate"].stringValue
                DisplayAllowOT = object["DisplayAllowOT"].intValue
                if object["EmpNeed"].null == nil{
                    TempEmployeesNeeded = object["EmpNeed"].intValue
                }
                self.formDataArrayForTableview()
                
                
                
                
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = "There is some error while geeting data"
                    
                }
                isErrorMessage = true
                isWarningMessage = false
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }
    }
    
    func formEditOrderDataArrayForTableview(){
        
        
        let eventDict = ["header":eventPlaceHolder,"type":"picker","showDropDown":"0"]
        let rtLocationDict = ["header":ReportToLocationPlaceHolder,"type":"picker","showDropDown":"0"]
        let reportToDict = ["header":ReportToPlaceHolder,"type":"picker","showDropDown":"0"]
        let timeDict = ["header":StartTimePlaceHolder,"subHeader":EndTimePlaceHolder,"type":"Date Cell","showDropDown":"0","StartTag":StartTimeTxtFieldTag,"EndTag":EndTimeTxtFieldTag,"StartValue":StartTime,"EndValue":EndTime]
        let  EmployeesNeededDict = ["header":EmployeesNeededPlaceHolder,"type":"txtField","showDropDown":"0"]
        let empCommentDict = ["header":"Additional Comments for Employees ","type":"TextView","subHeader":"","Tag":empCommentTxtViewTag,"placeholder":empTextViewPlaceHolder]
        let divCommentDict = ["header":"Comments for TemPositions internal staff only","subHeader":" ","type":"TextView","Tag":divisionCommentTxtViewTag,"placeholder":divisionTextViewPlaceHolder]
        let nextButtonDict = ["header":"Next","type":"Button"]
        if self.orderID > 0 && DivisionId == "92"{
            dataArray = [eventDict,timeDict,reportToDict,empCommentDict,divCommentDict,EmployeesNeededDict,nextButtonDict]
            
        }else if self.orderID > 0 && DivisionId == "29"{
            dataArray = [rtLocationDict,timeDict,reportToDict,empCommentDict,divCommentDict,EmployeesNeededDict,nextButtonDict]
            
        }else{
            dataArray = [eventDict,rtLocationDict,timeDict,reportToDict,empCommentDict,divCommentDict,EmployeesNeededDict,nextButtonDict]
            
        }
        
        
        self.tableView.reloadData()
    }
    func formDataArrayForTableview(){
        
        
        let eventDict = ["header":eventPlaceHolder,"type":"picker","showDropDown":"0"]
        let rtLocationDict = ["header":ReportToLocationPlaceHolder,"type":"picker","showDropDown":"0"]
        let positionDict = ["header":PositionPlaceHolder,"type":"picker","showDropDown":"0"]
        let reportToDict = ["header":ReportToPlaceHolder,"type":"picker","showDropDown":"0"]
        
        let dateDict = ["header":StartDatePlaceHolder,"subHeader":EndDatePlaceHolder,"type":"Date Cell","showDropDown":"0","StartTag":StartDateTxtFieldTag,"EndTag":EndDateTxtFieldTag,"StartValue":StartDate,"EndValue":EndDate]
        
        
        let timeDict = ["header":StartTimePlaceHolder,"subHeader":EndTimePlaceHolder,"type":"Date Cell","showDropDown":"0","StartTag":StartTimeTxtFieldTag,"EndTag":EndTimeTxtFieldTag,"StartValue":StartTime,"EndValue":EndTime]
        let EmployeesNeededDict = ["header":EmployeesNeededPlaceHolder,"type":"txtField","showDropDown":"0"]
        let includeWeekendDict = ["header":IncludeWeekendPlaceHolder,"type":"btn","showDropDown":"0"]
        let DisplayAllowOTDict = ["header":DisplayAllowOTPlaceHolder,"type":"btn","showDropDown":"0"]
        let substituteEmpDict = ["header":substituteEmpPlaceHolder,"type":"btn","showDropDown":"0"]
        
        let empCommentDict = ["header":"Additional Comments for Employees ","type":"TextView","subHeader":"","Tag":empCommentTxtViewTag,"placeholder":empTextViewPlaceHolder]
        let divCommentDict = ["header":"Comments for TemPositions internal staff only:","subHeader":" ","type":"TextView","Tag":divisionCommentTxtViewTag,"placeholder":divisionTextViewPlaceHolder]
        
        let searchEmpBtnDict = ["header":"Search Button","type":"Button"]
        let searchEmpListDict = ["header":"Search Emp List","type":"TableView"]
        let SegmentDict = ["header":"Segment","type":"Segment"]
        let nextButtonDict = ["header":"Next","type":"Button"]
        
        //Disable Position number testfield for UPK
        
        
        if DisplayAllowOT == 1 {
            dataArray = [eventDict,rtLocationDict,dateDict,SegmentDict,timeDict,reportToDict,positionDict,EmployeesNeededDict,includeWeekendDict,DisplayAllowOTDict,searchEmpBtnDict,searchEmpListDict,substituteEmpDict,empCommentDict,divCommentDict,nextButtonDict]
            
        }else{
            dataArray = [eventDict,rtLocationDict,dateDict,SegmentDict,timeDict,reportToDict,positionDict,EmployeesNeededDict,includeWeekendDict,searchEmpBtnDict,searchEmpListDict,substituteEmpDict,empCommentDict,divCommentDict,nextButtonDict]
            
        }
        //        dataArray = [eventDict,rtLocationDict,dateDict,SegmentDict,timeDict,reportToDict,positionDict,EmployeesNeededDict,includeWeekendDict,searchEmpBtnDict,searchEmpListDict,empCommentDict,divCommentDict]
        self.tableView.reloadData()
    }
    //MARK: Navigation Methods
    
    func pushToSearchEmpListPage(dataArray: NSMutableArray,message: String){
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
            nextViewController.isForOffice = false
            nextViewController.isForHospitality = true
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
            nextViewController.Hos_Header_title = message
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
            nextViewController.isForAddReportToHospitality = isForReportTo
            nextViewController.isForAddReportToLocationHospitality = isForReportToLoc
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
                        indexOfObj += 1
                    }
                    return multiDayDataArray.count
                }
            }else{
                return dataArray.count
            }
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == empTblViewTag{
            var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?
            if !(cell != nil) {
                cell = UITableViewCell(style:.subtitle, reuseIdentifier: "CELL")
            }
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            let  emp = employeeArray[indexPath.row] as! NewEmployee
            
            
            let  empObj:NewEmployee = emp as NewEmployee
            
            let name =   empObj.Name
            cell?.textLabel?.text = name
            
            
            if empObj.isSelected == "0"{
                cell?.backgroundColor = UIColor.white
            }else{
                cell?.backgroundColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
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
            
            if placeholder == eventPlaceHolder || placeholder == ReportToPlaceHolder || placeholder == ReportToLocationPlaceHolder || placeholder == EmployeesNeededPlaceHolder || placeholder == PositionPlaceHolder
            {
                return self.textEntryCell(placeholder: placeholder, tableView: tableView)
                
            }else if placeholder == "Search Button" {
                //Button
                return self.ButtonTableCell(tableView: tableView,indexPath: indexPath as NSIndexPath,identifier: SearchButtonCellIdentifier)
                
            }else if placeholder == "Search Emp List"{
                //TableView CEll
                return self.TableViewCell(tableView: tableView)
                
            }else if placeholder.contains("Date") {
                
                return self.dateViewCell(tableView: tableView,indexPath: indexPath as NSIndexPath,placeHolder: "" )
                
            }else if placeholder.contains("Additional Comments for Employees") || placeholder.contains("Comments for TemPositions internal staff only") {
                //textView
                return textViewCell(tableView: tableView, indexPath: indexPath as NSIndexPath, placeHolder: "" ,dataDict: dict)
                
            }else if placeholder == IncludeWeekendPlaceHolder || placeholder == DisplayAllowOTPlaceHolder || placeholder == substituteEmpPlaceHolder{
                
                return CheckButtonTableCell(tableView: tableView, indexPath: indexPath as NSIndexPath)
                
            }else if placeholder == "Segment"{
                
                return segmentTableViewCell(tableView: tableView)
                
            }else if placeholder.contains("Time") {
                if selectedSementTag == 0{
                    return self.dateViewCell(tableView: tableView,indexPath: indexPath as NSIndexPath,placeHolder: "" )
                }else{
                    return self.weekTimeViewCell(tableView: tableView, indexPath: indexPath as NSIndexPath)
                }
            }else if placeholder == "Next" {
                //Button
                return self.ButtonTableCell(tableView: tableView,indexPath: indexPath as NSIndexPath,identifier: NextButtonCellIdentifier)
                
            }
            
        }
        
        return UITableViewCell()
    }
    override   public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView.tag == empTblViewTag{
            
            return 60
            
        }else{
            var dict = NSDictionary()
            
            if selectedSementTag == 0{
                dict = dataArray[indexPath.row] as! NSDictionary
            }else{
                dict = multiDayDataArray[indexPath.row] as! NSDictionary
            }
            
            let placeholder = dict["header"] as! String
            let modelName = UIDevice.current.modelName

            if placeholder == eventPlaceHolder || placeholder == ReportToPlaceHolder || placeholder == ReportToLocationPlaceHolder  || placeholder == PositionPlaceHolder{
                if modelName.contains("iPad") {
                return 120
                }
                return 80
            }else if  placeholder == EmployeesNeededPlaceHolder{
                return 80

            }else if placeholder == "Search Button" {
                //Button
                return 170
            }else if placeholder == "Search Emp List"{
                //TableView CEll
                if employeeArray.count > 0{
                    return max(120,CGFloat(60 + (employeeArray.count * 55)))
                }
                return 120
            }else if placeholder.contains("Date") || placeholder == "Next" {
                return 80
            }else if  placeholder.contains("Comments for TemPositions internal staff only")
            {
                //textView
                return 130
            }else if placeholder.contains("Additional Comments for Employees")
            {
                //textView
                
                empCommentText = empCommentText.replacingOccurrences(of: "</p>", with: "")
                empCommentText = empCommentText.replacingOccurrences(of: "<p>", with: "")
                let height =  empCommentText.heightWithConstrainedWidth(width: UIScreen.main.bounds.size.width - 20, font: UIFont.boldSystemFont(ofSize: CGFloat(14))) + CGFloat(35)

                return max(130, height)
            }else if placeholder.contains("Time") {
                if selectedSementTag == 0{
                    return 80
                }
            }else if placeholder == DisplayAllowOTPlaceHolder {
                return 150
            }else if placeholder == substituteEmpPlaceHolder{
                return 100
            }else  if placeholder == "Segment"{
                if selectedSementTag == 0{
                    return 50
                }else{
                    return 84
                    
                }
            }else if placeholder == IncludeWeekendPlaceHolder{
                if selectedSementTag == 0{
                    return 50
                }else{
                    return 0
                }
            }
        }
        return 50
    }
    override    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
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
            tableView.reloadData()
        }
        
    }
    //MARK: Custom Cell
    func segmentTableViewCell(tableView: UITableView) -> SegmentTableViewCell {
        
        let cell:SegmentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SegmentTableViewCellIdentifier") as! SegmentTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        cell.optionSegmentControl.addTarget(self, action:#selector(self.segmentValueChanged), for: .valueChanged)
        cell.optionSegmentControl.tintColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
        cell.optionSegmentControl.setTitle(HeaderName, forSegmentAt: 0)
        cell.optionSegmentControl.setTitle(SelectedHeaderName, forSegmentAt: 1)
        let font = UIFont.systemFont(ofSize: 12)
        cell.optionSegmentControl.setTitleTextAttributes([NSAttributedString.Key.font: font],
                                                         for: .normal)
        cell.optionSegmentControlHeightConstraint.constant = 40
        cell.optionSegmentControl.layer.cornerRadius = 0
        cell.optionSegmentControl.layer.borderColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String).cgColor
        cell.optionSegmentControl.layer.borderWidth = 1
        cell.optionSegmentControl.layer.masksToBounds = true
        cell.optionSegmentControl.layoutIfNeeded()
        
        cell.StartTimePlaceHolderLbl.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.EndTimePlaceHolderLbl.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.DayPlaceHolderLbl.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
        if selectedSementTag == 0{
            cell.borderView.isHidden = true
            
        }else{
            cell.borderView.isHidden = false
        }
        return cell
        
    }
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
        cell.checkBtn.removeTarget(self, action:#selector(self.DisplayAllowOTBtnTapped), for: .touchUpInside)
        cell.checkBtn.removeTarget(self, action:#selector(self.SubstitueEmpBtnTapped), for: .touchUpInside)
        
        if placeholder == IncludeWeekendPlaceHolder{
            
            cell.checkBtn.addTarget(self, action:#selector(self.includeWeekendBtnTapped), for: .touchUpInside)
        }else if placeholder == DisplayAllowOTPlaceHolder{
            
            cell.checkBtn.addTarget(self, action:#selector(self.DisplayAllowOTBtnTapped), for: .touchUpInside)
        }else if placeholder == substituteEmpPlaceHolder{
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
        
        if identifier == SearchButtonCellIdentifier{
            
            var dict = NSDictionary()
            
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
            if self.orderID == 0 || (isCopyOrder == true && self.orderID > 0){
                cell.dButton.isEnabled = true
                cell.dButton.addTarget(self, action:#selector(self.nextButtonTapped), for: .touchUpInside)
            }else{
                cell.dButton.setTitle("Submit Changes", for: .normal)
                cell.dButton.addTarget(self, action:#selector(self.submitEditButtonTapped), for: .touchUpInside)
            }
            
            
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
        
        cell.startTimeView.layer.borderColor = borderColor.cgColor
        cell.endTimeView.layer.borderColor = borderColor.cgColor
        cell.endTimeView.layer.borderWidth = CGFloat(1)
        cell.startTimeView.layer.borderWidth = CGFloat(1)
        
        
        
        if placeHolder.count > 0 {
            //            if selectedSementTag == 2 && timeSegmentSelectedIndex == 0{
            placeholder = StartTimePlaceHolder
            subplaceholder = EndTimePlaceHolder
            
        }else{
            var dict = NSDictionary()
            
            if selectedSementTag == 0{
                dict = dataArray[indexPath.row] as! NSDictionary
                
            }else{
                dict = multiDayDataArray[indexPath.row] as! NSDictionary
                
            }
            //            let dict = dataArray[indexPath.row] as! NSDictionary
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
            //            let dict = dataArray[indexPath.row] as! NSDictionary
            startTag = Int(dict["StartTag"] as! String)!
            endTag = Int(dict["EndTag"] as! String)!
            startValue = dict["StartValue"] as! String
            endValue = dict["EndValue"] as! String
            StartDate = startValue
            EndDate = endValue
            cell.clearEndTimeBtn.tag = Int(dict["EndTag"] as! String)!
            cell.clearStartTimeBtn.tag = Int(dict["StartTag"] as! String)!
            cell.startTimeView.layer.borderColor = borderColor.cgColor
            cell.endTimeView.layer.borderColor = borderColor.cgColor
            
            cell.StartDateImageView.image = UIImage.init(named: "calendar_icon.png")
            cell.EndDateImageView.image = UIImage.init(named: "calendar_icon.png")
        }else{
            cell.StartDateImageView.image = UIImage.init(named: "Timeslips")
            cell.EndDateImageView.image = UIImage.init(named: "Timeslips")
            
            if isValidEndTime == true{
                cell.endTimeView.layer.borderColor = borderColor.cgColor
                
            }else{
                cell.endTimeView.layer.borderColor = UIColor.red.cgColor
                
            }
            if isValidStartTime == true{
                cell.startTimeView.layer.borderColor = borderColor.cgColor
                
            }else{
                cell.startTimeView.layer.borderColor = UIColor.red.cgColor
                
            }
            //             customPickerView.dtPickerView.minuteInterval = minuteInterval
            
            if selectedSementTag == 1{
                let dict = multiDayDataArray[indexPath.row] as! NSDictionary
                startTag = Int(dict["StartTag"] as! String)!
                endTag = Int(dict["EndTag"] as! String)!
                startValue = dict["StartValue"] as! String
                endValue = dict["EndValue"] as! String
                cell.clearEndTimeBtn.tag = Int(dict["EndTag"] as! String)!
                cell.clearStartTimeBtn.tag = Int(dict["StartTag"] as! String)!
                cell.clearEndTimeBtn.addTarget(self, action:#selector(self.clearEndTimeBtnTapped), for: .touchUpInside)
                cell.clearStartTimeBtn.addTarget(self, action:#selector(self.clearStartTimeBtnTapped), for: .touchUpInside)
                
            }else{
                let dict = dataArray[indexPath.row] as! NSDictionary
                startTag = Int(dict["StartTag"] as! String)!
                endTag = Int(dict["EndTag"] as! String)!
                startValue = dict["StartValue"] as! String
                endValue = dict["EndValue"] as! String
                StartTime = startValue
                EndTime = endValue
                cell.clearEndTimeBtn.tag = Int(dict["EndTag"] as! String)!
                cell.clearStartTimeBtn.tag = Int(dict["StartTag"] as! String)!
                
                
            }
            
        }
        cell.textFStart.tag = startTag
        cell.textFEnd.tag = endTag
        
        cell.lblStart.text = placeholder
        cell.lblEnd.text = subplaceholder
        cell.textFStart.delegate = self
        cell.textFEnd.delegate = self
        
        cell.textFStart.text = startValue
        cell.textFEnd.text = endValue
        
        
        return cell
        
    }
    func textEntryCell(placeholder: String,tableView: UITableView) -> TextFieldTableViewCell {
        
        let cell:TextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCellIdentifier") as! TextFieldTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.lblHeader.text = placeholder
        cell.entryTextField.delegate = self
        cell.btnBGView.layer.borderColor = borderColor.cgColor
        cell.btnBGView.layer.borderWidth = 1
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
                
            }else{
                cell.btnBGView.layer.borderColor = UIColor.red.cgColor
                
            }
        }else{
            cell.entryTextField.keyboardType =  UIKeyboardType.default
            
        }
        
        if placeholder == eventPlaceHolder  {
            cell.entryTextField.text = eventName
            cell.entryTextField.tag = eventTxtFieldTag
        }else if placeholder == ReportToPlaceHolder{
            cell.entryTextField.tag = reportToTxtFieldTag
            cell.entryTextField.text = selectedReportTo.Name
            if isValidReportTo == true{
            }else{
                cell.btnBGView.layer.borderColor = UIColor.red.cgColor
            }
            
        }else if placeholder == ReportToLocationPlaceHolder{
            cell.entryTextField.tag = reportToLocTxtFieldTag
            cell.entryTextField.text = selectedReportToLoc.ReportToLocation
            if isValidReportToLocation == true{
            }else{
                cell.btnBGView.layer.borderColor = UIColor.red.cgColor
                
            }
        }else if placeholder == PositionPlaceHolder{
            cell.entryTextField.tag = positionTxtFieldTag
            cell.entryTextField.text = selectedPositionType.PositionName
            if isValidPosition == true{
            }else{
                cell.btnBGView.layer.borderColor = UIColor.red.cgColor
                
            }
        }
        cell.addButton.removeTarget(self, action: #selector(self.addReportToBtnTapped), for: .touchUpInside)
        cell.addButton.removeTarget(self, action:#selector(self.addReportToLocBtnTapped), for: .touchUpInside)
        
        if placeholder == ReportToLocationPlaceHolder{
            cell.addButton.isHidden = false
            cell.addButton.addTarget(self, action:#selector(self.addReportToLocBtnTapped), for: .touchUpInside)
            
        }else if placeholder == ReportToPlaceHolder{
            if self.orderID > 0 {
                cell.addButton.isHidden = true
            }
            else{
                cell.addButton.isHidden = false
                cell.addButton.addTarget(self, action:#selector(self.addReportToBtnTapped), for: .touchUpInside)
            }
        }else{
            
            cell.addButton.isHidden = true
            
        }
        if self.orderID > 0 && DivisionId == "92"{
            cell.addButton.isHidden = true
        }
        
        //show dropdownIcon
        if placeholder ==  ReportToPlaceHolder || placeholder == ReportToLocationPlaceHolder || placeholder == PositionPlaceHolder{
            
            let imageView = UIImageView.init(frame: CGRect(x:0,y:0,width:20,height:20));
            let image = UIImage(named: "expand-arrow");
            imageView.image = image;
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            cell.entryTextField.rightView = imageView;
            
            cell.entryTextField.rightViewMode = UITextField.ViewMode.always
            
            cell.entryTextField.rightViewMode = .always
            
            
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
    func weekTimeViewCell(tableView: UITableView,indexPath: NSIndexPath) -> EnterTimeTableViewCell {
        
        let cell:EnterTimeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EnterTimeTableViewCellIdentifier") as! EnterTimeTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        var startTag = 0
        var endTag = 0
        var startValue = ""
        var endValue = ""
        
        cell.startTimeView.layer.borderColor = borderColor.cgColor
        cell.endTimeView.layer.borderColor = borderColor.cgColor
        cell.endTimeView.layer.borderWidth = CGFloat(1)
        cell.startTimeView.layer.borderWidth = CGFloat(1)
        
        cell.clearEndTimeBtn.addTarget(self, action:#selector(self.clearEndTimeBtnTapped), for: .touchUpInside)
        cell.clearStartTimeBtn.addTarget(self, action:#selector(self.clearStartTimeBtnTapped), for: .touchUpInside)
        
        let dict = multiDayDataArray[indexPath.row] as! NSDictionary
        
        let day = dict["day"] as! String
        
        cell.lblDay.text = day
        cell.lblDay.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        customPickerView.dtPickerView.minuteInterval = minuteInterval
        
        startTag = Int(dict["StartTag"] as! String)!
        endTag = Int(dict["EndTag"] as! String)!
        startValue = dict["StartValue"] as! String
        endValue = dict["EndValue"] as! String
        
        cell.clearEndTimeBtn.tag = Int(dict["EndTag"] as! String)!
        cell.clearStartTimeBtn.tag = Int(dict["StartTag"] as! String)!
        
        cell.startTimeTxtField.tag = startTag
        cell.endTimeTxtField.tag = endTag
        
        cell.startTimeTxtField.delegate = self
        cell.endTimeTxtField.delegate = self
        cell.startTimeTxtField.text = startValue
        cell.endTimeTxtField.text = endValue
        return cell
        
        
    }
    func textViewCell(tableView: UITableView,indexPath: NSIndexPath,placeHolder: String,dataDict: NSDictionary) -> TextViewTableViewCell {
        
        let cell:TextViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TextViewTableViewCellIdentifier") as! TextViewTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
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
        if placeholderString.contains("internal staff only"){
            cell.lblHeader.font = UIFont.boldSystemFont(ofSize: 14)
        }else{
            cell.lblHeader.font = UIFont.systemFont(ofSize: 14)
        }
        self.activeTextView = cell.entryTextView
        
        if cell.entryTextView.tag == Int(empCommentTxtViewTag){
//            let htmlString = "<html>" + empCommentText + "</html>"
//
//            let messageText = htmlString.htmlToAttributedString
//cell.entryTextView.attributedText = messageText
            empCommentText = empCommentText.replacingOccurrences(of: "</p>", with: "")
            empCommentText = empCommentText.replacingOccurrences(of: "<p>", with: "")
            cell.entryTextView.text = empCommentText
            
        }else  if cell.entryTextView.tag == Int(divisionCommentTxtViewTag){
            cell.entryTextView.text = divisionCommentText
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
    //    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    //
    //        if (touch.view?.isDescendant(of: self.empTableView))! || (touch.view?.isDescendant(of:  self.tableView))! || (touch.view?.isDescendant(of:  self.empListTableView))! || (touch.view?.isDescendant(of:  self.empListTableView))! {
    //            return false
    //        }
    //        return true
    //    }
    //    func addTapGestureToPicker()  {
    ////        customPickerView.dataPickerView
    //        let tap = UITapGestureRecognizer(target: self, action: #selector(self.pickerTapped))
    //        tap.delegate = self
    //        customPickerView.dataPickerView.addGestureRecognizer(tap)
    //
    //    }
    //    @objc func pickerTapped(sender: UITapGestureRecognizer?) {
    //
    //        if customPickerView.dataPickerView.selectedRow(inComponent: 0) == 0{
    //
    //            if firstResponderTxtFieldTag ==  Int(reportToTxtFieldTag){
    //                let obj = reportToArray[0]
    //                let  o:ReportTo = obj as! ReportTo
    //                selectedReportTo = o
    //                isValidReportTo = true
    //            }else if firstResponderTxtFieldTag ==  Int(reportToLocTxtFieldTag){
    //                let obj = reportToLocArray[0]
    //
    //                let  selectedReportToLocObj:ReportToLocation = obj as! ReportToLocation
    //                selectedReportToLoc = selectedReportToLocObj
    //                isValidReportToLocation = true
    //            }else if firstResponderTxtFieldTag ==  Int(positionTxtFieldTag){
    //
    //                let obj = positionArray[0]
    //
    //                let  o:HOSPositionType = obj as! HOSPositionType
    //                selectedPositionType =  o
    //                isValidPosition = true
    //                self.getEmployeeCommentAfterSelectingPosition()
    //            }
    //            self.tableView.reloadData()
    //        }
    //
    //    }
    //MARK: TextField Delegate
   
    func showSelectedValueInTextFieldWithIndexPath(indexPath: NSIndexPath,textField: UITextField){
        
        var dict = NSDictionary()
        
        if selectedSementTag == 0{
            dict = dataArray[(indexPath.row)] as! NSDictionary
        }else{
            dict = multiDayDataArray[(indexPath.row)] as! NSDictionary
        }
        let placeholder = dict["header"] as! String
        
        if placeholder.contains("Time") {
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
            }}
    }
   
    //MARK: UIPickerView Datasource & Delegate Methods
    // DataSource
    
    
    func formOrderSummaryData() -> NSMutableArray{
        
        var summaryDataArray = NSMutableArray()
        let employeeNameArray = NSMutableArray()
        
        
        for obj in employeeArray{
            let eObj:NewEmployee = (obj as? NewEmployee)!
            let name = eObj.Name
            employeeNameArray.add(name)
        }
        let eventDict = ["Header":"Event","Value":eventName]
        let reportToLocDict = ["Header":"Report To Location","Value":selectedReportToLoc.ReportToLocation]
        let startDateDict =  ["Header":"Start Date","Value":StartDate]
        let endDateDict =  ["Header":"End Date","Value":EndDate]
        let startTimeDict =  ["Header":"Start Time","Value":StartTime]
        let endTimeDict =  ["Header":"End Time","Value":EndTime]
        let reportToNameDict = ["Header":"Report To","Value":selectedReportTo.Name]
        let posTypeDict = ["Header":"Position","Value":selectedPositionType.PositionName]
        let selectedEmployeeDict =  ["Header":"Selected Employee(s):","Value":employeeNameArray.map({ String(describing: $0) }).joined(separator: ", ")]
        
        let EmployeesNeededDict = ["Header":"No. of employees needed","Value":String(format:"%d",TempEmployeesNeeded)]
        
        let empCommentsDict =  ["Header":"Additional Comments for Employees","Value":empCommentText]
        let divCommentsDict =  ["Header":"Comments for TemPositions internal staff only","Value":divisionCommentText]
        
        
        let MondayTime =    String(format:"Monday        : %@ - %@",MondayStartTime,MondayEndTime)
        let TuesdayTime = String(format:"\nTuesday       : %@ - %@",TuesdayStartTime,TuesdayEndTime)
        let WednesdayTime =   String(format:"\nWednesday : %@ - %@",WednesdayStartTime,WednesdayEndTime)
        let ThursdayTime =    String(format:"\nThursday     : %@ - %@",ThursdayStartTime,ThursdayEndTime)
        let FridayTime =  String(format:"\nFriday         : %@ - %@",FridayStartTime,FridayEndTime)
        let SaturdayTime =    String(format:"\nSaturday     : %@ - %@",SaturdayStartTime,SaturdayEndTime)
        let SundayTime =  String(format:"\nSunday       : %@ - %@",SundayStartTime,SundayEndTime)
        
        
        if selectedSementTag == 0{
            summaryDataArray = [eventDict,reportToLocDict,startDateDict,endDateDict,startTimeDict,endTimeDict,reportToNameDict,posTypeDict,selectedEmployeeDict,EmployeesNeededDict,empCommentsDict,divCommentsDict]
            
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
            
            
            summaryDataArray = [eventDict,reportToLocDict,startDateDict,endDateDict,TimeDict,reportToNameDict,posTypeDict,selectedEmployeeDict,EmployeesNeededDict,empCommentsDict,divCommentsDict]
            
        }
        return summaryDataArray
    }
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
            nextViewController.HOS_CREATE_ORDER_FLAG = true
            nextViewController.summaryObj = createOrderObj
            nextViewController.summaryDataArray = self.formOrderSummaryData()
            nextViewController.status = "New"
            nextViewController.delegate = self
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func createOrderAPICall(){
        
        let defaults = UserDefaults.standard
        
        let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
        let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
        let UserName  = String(format:"%@", defaults.string(forKey: "UserName")!)
        
        let employeeNameArray = NSMutableArray()
        let employeeIDArray = NSMutableArray()
        
        
        for obj in employeeArray{
            let eObj:NewEmployee = (obj as? NewEmployee)!
            let name = eObj.Name
            employeeNameArray.add(name)
            employeeIDArray.add(String(format:"%d",eObj.CandidateId!))
        }
//        "SpreadAndOTHoursList":[
//        {
//        "OTCandidate"    :"0",
//        "SpreadOfHourCandidate":"1",
//        "Position":"Waiter",
//        "WeeklyHours":"45.87",
//        "CandidateName":"test123",
//        "CandidateId":"4567"
//
        //        }]
        let tempEmps = NSMutableArray()
        for obj in employeeArray{
            let eObj:NewEmployee = (obj as? NewEmployee)!
            let name = eObj.Name
            employeeNameArray.add(name)
            employeeIDArray.add(String(format:"%d",eObj.CandidateId!))
            let dict =
                ["ShowOT":eObj.ShowOT,
                 "ShowSpreadofHours":eObj.IsSpreadOfHour,
                 "Position":eObj.positions,
                 "WeeklyHours":eObj.Weekly_Hours,
                 "Name":name,
                 "CandidateId":String(format:"%d",eObj.CandidateId!)]
            if !tempEmps.contains(dict){
                tempEmps.add(dict)
            }
        }
        
        
        let selectedEmployees = employeeNameArray.map({ String(describing: $0) }).joined(separator: "|")
        let selectedEmployeeIds = employeeIDArray.map({ String(describing: $0) }).joined(separator: "|")
        
        if selectedSementTag == 0{
            
            createOrderObj =
                ["ClientID" : clientID,
                 "Divid" : DivisionId,
                 "ContactName" : UserName,
                 "ContactId" : ContactId,
                 "OrderSourceName":"iOS",
                 "EndDate" : EndDate,
                 "EndTime" : EndTime.uppercased(),
                 "Event" : eventName,
                 "IncludeWeekend" : IncludeWeekend,
                 "Intelistaff" : divisionCommentText,
                 "IsCheckAllowOT" : IsCheckAllowOT,
                 "PositionName" : selectedPositionType.PositionName!,
                 "Positions" : selectedPositionType.KeyValue!,
                 "RegionEmp" : empCommentText,
                 "ReportTo" : selectedReportTo.ContactId!,
                 "ReportToLocation" : selectedReportToLoc.Split_Add!,//Split_Add
                    "ReportToLocationName" : selectedReportToLoc.ReportToLocation!,
                    "ReportToName" : selectedReportTo.Name!,
                    "SelectedEmployees" : selectedEmployeeIds,
                    "SelectedEmployeeNames" : selectedEmployees,
                    "StartDate" : StartDate,
                    "StartTime" : StartTime.uppercased(),
                    "EmpNeed" : TempEmployeesNeeded,
                    "HeaderName" : segHeader,
                    "SpreadAndOTHoursList":tempEmps,
                    "ReportLocationId":selectedReportToLoc.ReportId!
                ] as [String : Any] as NSDictionary
            
        }else{
            
            for dict in multiDayDataArray {
                print(dict)
                let dictObj:NSDictionary = dict as! NSDictionary
                if dictObj["StartTag"] != nil{
                    
                    let startTag = dictObj["StartTag"] as! String
                    let endTag = dictObj["EndTag"] as! String
                    var day = ""
                    if dictObj["day"] != nil{
                        day = dictObj["day"] as! String
                    }
                    
                    let StartValue = dictObj["StartValue"] as! String
                    let EndValue = dictObj["EndValue"] as! String
                    
                    if startTag == SunStartTxtFieldTag && day == "SUN" {
                        SundayStartTime = StartValue
                        
                    }
                    if startTag == MonStartTxtFieldTag && day == "MON" {
                        MondayStartTime = StartValue
                        
                    }
                    if startTag == TueStartTxtFieldTag && day == "TUE"{
                        TuesdayStartTime = StartValue
                        
                    }
                    if startTag == WedStartTxtFieldTag && day == "WED"{
                        WednesdayStartTime = StartValue
                    }
                    if startTag == ThuStartTxtFieldTag && day == "THU"{
                        ThursdayStartTime = StartValue
                        
                    }
                    if startTag == FriStartTxtFieldTag && day == "FRI"{
                        FridayStartTime = StartValue
                        
                    }
                    if startTag == SatStartTxtFieldTag && day == "SAT"{
                        SaturdayStartTime = StartValue
                        
                    }
                    if  day == "SUN" && endTag == SunEndTxtFieldTag{
                        SundayEndTime = EndValue
                        
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
                 "Divid" : DivisionId,
                 "ContactName" : UserName,
                 "ContactId" : ContactId,
                 "OrderSourceName":"iOS",
                 "EndDate" : EndDate,
                 "Event" : eventName,
                 "IncludeWeekend" : IncludeWeekend,
                 "Intelistaff" : divisionCommentText,
                 "IsCheckAllowOT" : IsCheckAllowOT,
                 "PositionName" : selectedPositionType.PositionName!,
                 "Positions" : selectedPositionType.KeyValue!,
                 "RegionEmp" : empCommentText,
                 "ReportTo" : selectedReportTo.ContactId!,
                 "ReportToLocation" : selectedReportToLoc.Split_Add!,//Split_Add
                    "ReportToLocationName" : selectedReportToLoc.ReportToLocation,
                    "ReportToName" : selectedReportTo.Name,
                    "SelectedEmployees" : selectedEmployeeIds,
                    "SelectedEmployeeNames" : selectedEmployees,
                    "StartDate" : StartDate,
                    "MondayStartTime" : MondayStartTime.uppercased(),
                    "MondayEndTime" : MondayEndTime.uppercased(),
                    "TuesdayStartTime" : TuesdayStartTime.uppercased(),
                    "TuesdayEndTime" : TuesdayEndTime.uppercased(),
                    "WednesdayStartTime" :WednesdayStartTime.uppercased(),
                    "WednesdayEndTime" : WednesdayEndTime.uppercased(),
                    "ThursdayStartTime" : ThursdayStartTime.uppercased(),
                    "ThursdayEndTime" : ThursdayEndTime.uppercased(),
                    "FridayStartTime" : FridayStartTime.uppercased(),
                    "FridayEndTime" : FridayEndTime.uppercased(),
                    "SaturdayStartTime" : SaturdayStartTime.uppercased(),
                    "SaturdayEndTime" : SaturdayEndTime.uppercased(),
                    "SundayStartTime" : SundayStartTime.uppercased(),
                    "SundayEndTime" : SundayEndTime.uppercased(),
                    "EmpNeed" : TempEmployeesNeeded,
                    "HeaderName" : segHeader,
                    "SpreadAndOTHoursList":tempEmps,
                    "ReportLocationId":selectedReportToLoc.ReportId!

                ] as [String : Any] as NSDictionary
        }
        
        self.validateCreateOrderData()
        
        
    }
    func validateSaveEditOrderData() -> Bool{
        if selectedReportToLoc.ReportToLocation?.count == 0{
            isValidReportToLocation = false
        }else{
            isValidReportToLocation = true
            
        }
        if selectedReportTo.Name?.count == 0{
            
            isValidReportTo = false
        }else{
            isValidReportTo = true
            
        }
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
        if TempEmployeesNeeded == 0{
            isValidEmployeeNeeded = false
        }else{
            isValidEmployeeNeeded = true
            
        }
        
        if isValidReportToLocation ==  true && isValidReportTo ==  true  && isValidEmployeeNeeded ==  true && isValidStartTime == true && isValidEndTime == true{
            
            allDataValidated = true
        }else {
            
            allDataValidated = false
        }
        self.tableView.reloadData()
        return allDataValidated
        
    }
    func validatePositionTab() -> Bool{
        
        if selectedReportToLoc.ReportToLocation?.count == 0{
            isValidReportToLocation = false
        }else{
            isValidReportToLocation = true
            
        }
        if selectedReportTo.Name?.count == 0{
            
            isValidReportTo = false
        }else{
            isValidReportTo = true
            
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
        
        if isValidReportToLocation ==  true && isValidReportTo ==  true && isValidPosition ==  true && isValidEmployeeNeeded ==  true && isValidStartTime == true && isValidEndTime == true{
            
            allDataValidated = true
        }else {
            
            allDataValidated = false
        }
        self.tableView.reloadData()
        return allDataValidated
        
    }
    
    //    func isKeyboardOnScreen(){
    //
    //
    //        let isKeyboardShown = false
    //        let windows = UIApplication.shared.windows
    //        if windows.count > 1{
    //            let windowSubviews = windows[1].subviews
    //            if windowSubviews.count > 0{
    //                let kbFrame = windowSubviews[0].frame
    //                let screenFrame = windows[1].frame
    //                if kbFrame.origin.y + kbFrame.size.height == screenFrame.size.height{
    //                    //print yes
    //                    print("yes")
    //                }else{
    //                    //print no
    //                    print("NO")
    //
    //                }
    //            }
    //        }
    //    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        
       
        DispatchQueue.main.async(execute: { () -> Void in
            self.addDivisionNameOnTop()
            
            self.customPickerView.showPickerViewInOrientation(superView: (self.navigationController?.view)!, isPortrait: self.isPortrait())
            self.customCalendarView.showPickerViewInOrientation(superView: (self.navigationController?.view)!, isPortrait: self.isPortrait())
            
            
        })
        
    }
    
    //MARK: Calendar Delegate Methods
    
    //    func minimumDate(for calendar: FSCalendar) -> Date {
    //        if firstResponderTxtFieldTag == Int(StartDateTxtFieldTag)! {
    //
    //            let minDate = self.convertDateStringToDefaultDate(dateString: "01/01/1800", formatString: dateFormat)
    //            return minDate
    //
    //        }else if firstResponderTxtFieldTag == Int(EndDateTxtFieldTag)! {
    //
    //             let minDate = self.convertDateStringToDefaultDate(dateString: StartDate, formatString: dateFormat)
    //            return minDate
    //          }
    //        return Date()
    //    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        //        calendar.minimumDate = date
        
        
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        
        let pickedDateString = formatter.string(from: date)
        
        //Time
        if selectedSementTag == 1{
            self.updateDatesFromPicker(dateString: pickedDateString, forArray: multiDayDataArray)
            //multi schdule array
        }else{
            //schdule array
            self.updateDatesFromPicker(dateString: pickedDateString, forArray: dataArray)
        }
        customCalendarView.removePickerViewFromSuperView()
    }
}

extension ROSHospitalityViewController:SummaryDelegate{
    func createNewOrderFromSummary() {
        
        selectedSementTag = 0
        self.resetAllData()
        self.getROSData()
        
    }
}
extension ROSHospitalityViewController:UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if firstResponderTxtFieldTag ==  Int(reportToTxtFieldTag){
            return reportToArray.count
        }else if firstResponderTxtFieldTag ==  Int(reportToLocTxtFieldTag){
            return reportToLocArray.count
        }else if firstResponderTxtFieldTag ==  Int(positionTxtFieldTag){
            return positionArray.count
        }
        return 0
    }
    
    // MARK:Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var titleString = ""
        
        if firstResponderTxtFieldTag ==  Int(reportToTxtFieldTag){
            
            let obj = reportToArray[row]
            
            let  o:ReportTo = obj as! ReportTo
            
            titleString =  o.Name!
            
        }else if firstResponderTxtFieldTag ==  Int(reportToLocTxtFieldTag){
            let obj = reportToLocArray[row]
            
            let  selectedReportToLocObj:ReportToLocation = obj as! ReportToLocation
            titleString = selectedReportToLocObj.ReportToLocation!
        }else if firstResponderTxtFieldTag ==  Int(positionTxtFieldTag){
            
            let obj = positionArray[row]
            
            let  o:HOSPositionType = obj as! HOSPositionType
            titleString =  o.PositionName!
            
        }
        return titleString
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if firstResponderTxtFieldTag ==  Int(reportToTxtFieldTag){
            
            let obj = reportToArray[row]
            
            let  o:ReportTo = obj as! ReportTo
            selectedReportTo = o
            isValidReportTo = true
        }else if firstResponderTxtFieldTag ==  Int(reportToLocTxtFieldTag){
            let obj = reportToLocArray[row]
            
            let  selectedReportToLocObj:ReportToLocation = obj as! ReportToLocation
            selectedReportToLoc = selectedReportToLocObj
            isValidReportToLocation = true
        }else if firstResponderTxtFieldTag ==  Int(positionTxtFieldTag){
            
            let obj = positionArray[row]
            
            let  o:HOSPositionType = obj as! HOSPositionType
            selectedPositionType =  o
            isValidPosition = true
            //call API for getting comments for employee
            self.getEmployeeCommentAfterSelectingPosition()
        }
        self.tableView.reloadData()
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var titleString = ""
        
        if firstResponderTxtFieldTag ==  Int(reportToTxtFieldTag){
            
            let obj = reportToArray[row]
            
            let  o:ReportTo = obj as! ReportTo
            
            titleString =  o.Name!
            
        }else if firstResponderTxtFieldTag ==  Int(reportToLocTxtFieldTag){
            let obj = reportToLocArray[row]
            
            let  o:ReportToLocation = obj as! ReportToLocation
            
            titleString =  o.ReportToLocation!
            
        }else if firstResponderTxtFieldTag ==  Int(positionTxtFieldTag){
            
            let obj = positionArray[row]
            
            let  o:HOSPositionType = obj as! HOSPositionType
            titleString =  o.PositionName!
            
        }
        
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            let modelName = UIDevice.current.modelName
            if modelName.contains("iPad") {
                pickerLabel?.font =  UIFont.systemFont(ofSize: 18)
            }else{
                if modelName.contains("iPhone 5"){
                    pickerLabel?.font =  UIFont.systemFont(ofSize: 14)
                }else{
                    pickerLabel?.font =  UIFont.systemFont(ofSize: 16)
                    
                }
            }
            pickerLabel?.textAlignment = .center
            pickerLabel?.numberOfLines = 0
        }
        pickerLabel?.text = titleString
        pickerLabel?.textColor = UIColor.black
        
        return pickerLabel!
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        let modelName = UIDevice.current.modelName
        if modelName.contains("iPad") {
            return 80
        }
        return 60
    }
   

}

extension ROSHospitalityViewController:UITextViewDelegate{
 
    public func textViewDidBeginEditing(_ textView: UITextView)
    {
        self.activeTextView = textView
        
        //        let pointInTable:CGPoint = textView.convert(CGPoint.zero, to: listTableView) //textView.superview!.convertPoint(textView.frame.origin, toView:dataTableView)
        //        var contentOffset:CGPoint = listTableView.contentOffset
        //        contentOffset.y  = pointInTable.y
        //        if let accessoryView = textView.inputAccessoryView {
        //            contentOffset.y -= accessoryView.frame.size.height
        //        }
        //        listTableView.contentOffset = contentOffset
        
        
        if textView.tag == Int(empCommentTxtViewTag) || textView.tag == Int(divisionCommentTxtViewTag){
            
            if textView.textColor == UIColor.lightGray {
                textView.text = ""
                textView.textColor = UIColor.black
            }
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView)
    {
        self.activeTextView = nil
        keyboardShowing = true
        if textView.tag == Int(empCommentTxtViewTag){
            empCommentText = textView.text
        }else if textView.tag == Int(divisionCommentTxtViewTag){
            divisionCommentText = textView.text
        }
        view.endEditing(true)
        //        textView.resignFirstResponder()
        //        listTableView.reloadData()
        
        self.tableView.reloadData()
        
    }
}
extension ROSHospitalityViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField.tag ==  empNeededTxtFieldTag
        {
            
            let charsLimit = 2
            
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            let isAllNumbers = allowedCharacters.isSuperset(of: characterSet)
            if isAllNumbers == true{
                
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
        if textField.tag == empNeededTxtFieldTag || textField.tag == eventTxtFieldTag{
        }else if textField.tag == reportToTxtFieldTag || textField.tag == reportToLocTxtFieldTag || textField.tag == positionTxtFieldTag{
            firstResponderTxtFieldTag = textField.tag
            textField.resignFirstResponder()
            self.view.endEditing(true)
            
        }else{
            textField.resignFirstResponder()
            
            view.endEditing(true)
            
        }
        return true
    }
    public func textFieldDidBeginEditing(_ textField: UITextField){
        self.activeField = textField
        
        if textField.tag == empNeededTxtFieldTag || textField.tag == eventTxtFieldTag{
            textField.becomeFirstResponder()
        }else if textField.tag == reportToTxtFieldTag || textField.tag == reportToLocTxtFieldTag || textField.tag == positionTxtFieldTag{
            firstResponderTxtFieldTag = textField.tag
            textField.resignFirstResponder()
            
            if textField.tag ==  reportToTxtFieldTag  && reportToArray.count == 0 {
                self.navigationController?.view.makeToast("No record found", duration: 1.5, position: .bottom, title: "", image: nil)
                
                return
            }else if textField.tag ==   reportToLocTxtFieldTag && reportToLocArray.count == 0{
                self.navigationController?.view.makeToast("No record found", duration: 1.5, position: .bottom, title: "", image: nil)
                
                return
            }else if textField.tag ==   positionTxtFieldTag && positionArray.count == 0{
                self.navigationController?.view.makeToast("No record found", duration: 1.5, position: .bottom, title: "", image: nil)
                
                return
            }
            
            customPickerView.showPickerViewOnSuperView(superView: (self.navigationController?.view)!, isDatePicker: false,minuteInterval: minuteInterval,isPortrait: self.isPortrait())
            customPickerView.dataPickerView.reloadAllComponents()
            
        }else{
            
            if textField.tag == Int(StartDateTxtFieldTag)! {
                
                let minDate = self.convertDateStringToDefaultDate(dateString: "01/01/1800", formatString: dateFormat)
                let date = self.convertDateStringToDefaultDate(dateString: StartDate, formatString: dateFormat)
                
                customPickerView.dtPickerView.date = date
                customPickerView.dtPickerView.minimumDate = minDate
                DispatchQueue.main.async(execute: { () -> Void in
                    self.customCalendarView.calendar.setCurrentPage(date, animated: true)
                    self.customCalendarView.calendar.select(date, scrollToDate: true)
                    
                })
            }else if textField.tag == Int(EndDateTxtFieldTag)! {
                
                let date = self.convertDateStringToDefaultDate(dateString: EndDate, formatString: dateFormat)
                let minDate = self.convertDateStringToDefaultDate(dateString: StartDate, formatString: dateFormat)
                
                customPickerView.dtPickerView.minimumDate = minDate
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.customCalendarView.calendar.setCurrentPage(date, animated: true)
                    self.customCalendarView.calendar.select(date, scrollToDate: true)
                    
                })
                customPickerView.dtPickerView.date = date
            }
            if textField.tag == Int(EndDateTxtFieldTag)! || textField.tag == Int(StartDateTxtFieldTag)!{
                //                customPickerView.dtPickerView.datePickerMode = UIDatePickerMode.date
                
                customCalendarView.showPickerViewOnSuperView(superView: (self.navigationController?.view)!, isPortrait: self.isPortrait())
            }else{
                //Show the  previuosly  selected Time else show current date
                let senderPosition  = textField.convert(CGPoint.zero, to: self.tableView)
                let indexPath =  self.tableView.indexPathForRow(at:senderPosition)
                print(indexPath?.row ?? 0)
                if indexPath != nil{
                    self.showSelectedValueInTextFieldWithIndexPath(indexPath: indexPath! as NSIndexPath,textField: textField)
                }
                //                customPickerView.dtPickerView.date = Date()
                
                customPickerView.dtPickerView.datePickerMode = UIDatePicker.Mode.time
                customPickerView.showPickerViewOnSuperView(superView: (self.navigationController?.view)!, isDatePicker: true,minuteInterval: minuteInterval,isPortrait: self.isPortrait())
            }
            textField.resignFirstResponder()
            
            view.endEditing(true)
            
            firstResponderTxtFieldTag = textField.tag
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField){
        
        self.activeField = nil
        keyboardShowing = true
        if textField.tag == empNeededTxtFieldTag {
            
            if textField.text?.count == 0{
                textField.text = ""
            }
            if textField.text?.isNumeric == true{
                TempEmployeesNeeded = Int(textField.text!)!
            }else{
                textField.text = ""
            }
        }else if textField.tag == eventTxtFieldTag{
            eventName = textField.text!
        }
        //        else if textField.tag == EndTimeTxtFieldTag{
        //            EndTime =  textField.text!
        //        }else if textField.tag == StartTimeTxtFieldTag{
        //            StartTime =  textField.text!
        //        }
        
        self.tableView.reloadData()
    }
}
extension ROSHospitalityViewController:addReportToDelegate{
    func addReportToForOCC(_ reportTo: OCCReportToExp) {
     }
    
    func addedReportToLocationOffice(_ locationName: OfficeReportToLocation) {
     }
 
    func addedReportTo(_ reportToPerson : ReportTo){
        
        if reportToPerson.Name?.count  == 0{
        }else{
            reportToArray.add(reportToPerson)
            selectedReportTo = reportToPerson
            self.tableView.reloadData()
        }
    }
    func addedReportToLocation (_ locationName : ReportToLocation ){
        
        reportToLocArray.add(locationName)
        selectedReportToLoc = locationName
        self.tableView.reloadData()
        
    }
 
}
extension ROSHospitalityViewController: searchEmpDelegate{
    func selecetdEmployee(_ emps: NSMutableArray) {
        
        
        if emps.count > 0{
            employeeArray.removeAllObjects()
            employeeArray = emps
            
            //            if employeeArray.count == 0{
            //
            //                employeeArray = emps
            //            }else{
            //                //avoid Duplicate values.
            //                let tempEmpArray = NSMutableArray()
            //                for e in emps{
            //                    let  eObj:HospitalityEmployee = e as! HospitalityEmployee
            //                    let eObjCandID = eObj.CandidateId
            //                    for emp in employeeArray{
            //                        let  empObj:HospitalityEmployee = emp as! HospitalityEmployee
            //                        let empObjCandID = empObj.CandidateId
            //                        if eObjCandID == empObjCandID{
            //                        }else{
            //                            if tempEmpArray.contains(e){
            //                            }else{
            //                                tempEmpArray.add(e)
            //                            }
            //                        }
            //                    }
            //                }
            //                //add the new employee selected fromm search page to employeeArray array
            //                employeeArray.addObjects(from: tempEmpArray as! [Any])
            //            }
            if employeeArray.count > 0 {
                SubstituteEmpChecked = "1"
                //auto-check the check button
            }
            empTableView.reloadData()
            self.tableView.reloadData()
        }
    }

}
