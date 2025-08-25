//
//  ROSSchoolProfessionalViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 24/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//
/*
 KB Issue
 https://stackoverflow.com/questions/24529373/tableview-scroll-content-when-keyboard-shows
 http://iosdevelopertip.blogspot.in/2014/10/scroll-uitextfield-above-keyboard-in.html
 
 
 NOTE: Div_id = 50,117,92
 50 = school professional
 117 = school professional UPK
 92 = school professional S.F
 
 */
import UIKit
import SwiftyJSON
import MobileCoreServices
import FSCalendar

class ROSSchoolProfessionalViewController: BaseTableViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UITextViewDelegate,searchEmpDelegate,addReportToDelegate,SummaryDelegate,UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate,FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance{
    
    func addReportToForOCC(_ reportTo: OCCReportToExp) {
    }
    func addedReportToLocationOffice(_ locationName: OfficeReportToLocation) {}
    
    
    //MARK: Document Picker View
    //    var blurEffect = UIBlurEffect()
    //    var blurEffectView = UIVisualEffectView()
    //    @IBOutlet var documentsView: UIView!
    //    @IBOutlet var documentsTableView: UITableView!
    //    @IBOutlet var topView: UIView!
    
    var fileData = Data()
    var fileBytes = String()
    var documentsArray = NSMutableArray()
    var documetBytes = NSMutableArray()
    var fileExtensions = NSMutableArray()
    var listOfDocuments = Array<[String:Any]>()
    let docTblViewTag =  10025
    
    var isWarningMessage = false
    var isErrorMessage = false
    var keyboardShowing = false
    //MARK: END of Doc
    
    let colCellIdentifier = "MenuCollectionViewCellIdentifier"
    let TimeCellIdentifier = "EnterTimeTableViewCellIdentifier"
    
    let SearchButtonCellIdentifier = "ButtonTableViewCellIdentifier"
    
    let NextButtonCellIdentifier = "NextTableViewCellIdentifier"
    
    //EnterTimeTableViewCellIdentifier
    
    //MARK: COLLECTIONVIEW TAG SET
    let positionTypeColTag = 1001
    let gradesColTag = 1002
    let subjectsColTag = 1003
    let reportToColTag = 1004
    let reasonforOrderColTag = 1005
    
    let reportToTblViewTag = 300001
    let subjectsTblViewTag = 300002
    let reasonforOrderTblViewTag = 300003
    let gradesTblViewTag = 300004
    
    
    //MARK: TABLEVIEW TAG SET
    let mainTblViewTag = 101
    let dropDownTblViewTag = 102
    var selectedSementTag = 0
    let reportToTxtFieldTag = 1004
    let reasonforOrderTxtFieldTag = 1005
    var alrtController = UIAlertController()
    
    var selectedDropDown = ""
    var showLessonPlanTextView = false
    
    //    @IBOutlet weak var dropDownView: UIView!
    
    //    @IBOutlet weak var dataTableView: UITableView!
    var dataTableView: UITableView!
    var dropDownView: UIView!
    var empTableView: UITableView!
    
    //    @IBOutlet weak var lblNoData: UILabel!
    //    @IBOutlet weak var createButton: UIButton!
    
    var selectedGradesArray = NSMutableArray()
    var selectedSubjectsArray = NSMutableArray()
    var selectedEmployeeArray = NSMutableArray()
    var multiDayDataArray = NSMutableArray()
    var orderDataArray = NSMutableArray()
    var uploadedFileName = ""
    var selectedReportTo = ReportTo.init(ContactId: 0, Name: "",isSelected: "")
    var selectedReasonForOrder = ReasonForOrder.init(ReasonId: 0, ReasonDescription: "",isSelected: "")
    var selectedPositionType = PositionType.init(PositionId: 0,PositionName: "",isSelected: "" )
    var createOrderObj = NSDictionary()
    
    var positionTypeArray = NSMutableArray()
    var gradeArray = NSMutableArray()
    var reportToArray = NSMutableArray()
    var reasonForOrderArray = NSMutableArray()
    var positionSkillArray = NSMutableArray()
    var employeeArray = NSMutableArray()
    var weekDayArray = NSMutableArray()
    var minutes = NSMutableArray()
    var ResponseEmployeeArray = NSMutableArray()
    
    var TempNoofPositions = 0
    var copyOrderNoofPositions = ""

    var StartDate = ""
    var EndDate = ""
    var StartTime = ""
    var EndTime = ""
    var ReportToAddress = ""
    var ReportToCity = ""
    var ReportToPhone = ""
    var ReportToZip = ""
    var ReportToFax = ""
    var ReportToState = ""
    var NoofPositions = 0
    var referenceNote = ""
    var empCommentText = ""
    var lessonPlanText = ""
    var divisionCommentText = ""
//    var startDate = ""
//    var endDate = ""
//    var startTime = ""
//    var endTime = ""
    var ScheduleType = "1"
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
    var dropdownTableView = UITableView()
    var minuteInterval = 0
    var TeacherCreditSelection = ""
    var willEnableCreditSelection = false
    var TempTeacherCreditSelection = ""
    var minimalHoursPerOrder = ""
    
    
    
    var orderID = 0

    
    var firstResponderTxtFieldTag = 0
    let empTblViewTag =  1005
    
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
    
    let positionNumberTxtFieldTag = 100019
    
    let referenceNoteTxtViewTag = "100020"
    let empCommentTxtViewTag = "100021"
    let divisionCommentTxtViewTag = "100022"
    let lessonPlanTxtViewTag = "100023"
    
    
    var TempEmployeesNeeded = 0
    var activeField: UITextField?
    var activeTextView: UITextView?
    
    let divisionTextViewPlaceHolder = "Use this field to share any additional information regarding this position that should be viewed by School Professionals only.  This information will not be shared with prospective substitutes. To provide feedback regarding a previous candidate's performance, please contact your representative directly."
    
    var empTextViewPlaceHolder = "These comments will be relayed to the assigned employee(s)."
    //Use this field to describe the duties of this position. This information will be shared with prospective substitute teachers via phone, email or text message"
    
    
    
    
    //MARK: Placeholder
    let posTypePlaceHolder = "Position Type *"
    let gradePlaceHolder = "Grade(s) *"
    let subjectPlaceHolder = "Subject(s) *"
    let noOfPosPlaceHolder = "No. of Positions *"
    let startDatePlaceHolder = "Start Date *"
    let endDatePlaceHolder = "End Date *"
    let repotToPlaceHolder = "Report To *"
    let reasonForOrderPlaceHolder = "Reason for Order *"
    let startTimePlaceHolder = "Start Time *"
    let endTimePlaceHolder = "End Time *"
    
    
    let creditSelectionPlaceholder = "If no credentialed teachers respond to the job within a reasonable amount of time, can we open the job up to CBEST II teachers ?"
    
    
    var customPickerView = JPPickerView()
    var customCalendarView = CalendarView()

    //MSRK: Validation Variables
    
    var isValidGrades = true
    var isValidSubjects = true
    var isValidReportTo = true
    var isValidReasonForOrder = true
    var allDataValidated = false
    
    //MARK: Methods Started
    func resetAllData(){
        selectedGradesArray.removeAllObjects()
        selectedSubjectsArray.removeAllObjects()
        selectedEmployeeArray.removeAllObjects()
        multiDayDataArray.removeAllObjects()
        orderDataArray.removeAllObjects()
        employeeArray.removeAllObjects()
        
        selectedReportTo = ReportTo.init(ContactId: 0, Name: "",isSelected: "")
        selectedReasonForOrder = ReasonForOrder.init(ReasonId: 0, ReasonDescription: "",isSelected: "")
        selectedPositionType = PositionType.init(PositionId: 0,PositionName: "",isSelected: "" )
        
        positionTypeArray.removeAllObjects()
        gradeArray.removeAllObjects()
        reportToArray.removeAllObjects()
        reasonForOrderArray.removeAllObjects()
        positionSkillArray.removeAllObjects()
        employeeArray.removeAllObjects()
        weekDayArray.removeAllObjects()
        ResponseEmployeeArray.removeAllObjects()
        minutes = NSMutableArray()
        createOrderObj = NSDictionary()
        TempNoofPositions = 0
        uploadedFileName = ""
        empCommentText = ""
        lessonPlanText = ""
        divisionCommentText = ""
        referenceNote = ""
        self.formMultiDayArray()
        DispatchQueue.main.async(execute: { () -> Void in
            self.empTableView.reloadData()
            self.tableView.reloadData()
        })
 
    }
    func createNewOrderFromSummary(){
        
        selectedSementTag = 0
        self.resetAllData()
        self.getROSData()
        
    }
    func addedReportToLocation(_ locationName: ReportToLocation) {
        //not reqd
    }
    
    func selecetdEmployee(_ emps: NSMutableArray) {
        
        
        if emps.count > 0{
            employeeArray.removeAllObjects()
            employeeArray = emps
            self.tableView.reloadData()
            
            
        }
    }
    
    func addedReportTo(_ reportToPerson : ReportTo){
        
        if reportToPerson.Name?.count  == 0{
        }else{
            selectedReportTo = reportToPerson
            reportToArray.add(reportToPerson)
            self.tableView.reloadData()
        }
    }
    @objc override func appWillEnterForeground(){
        print("appWillEnterForeground Division")
        
        if orderDataArray.count == 0{
            self.getROSData()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedSementTag = 0
        
        self.title = "Rapid Order System"
        self.formMultiDayArray()
        self.setupPickerView()
        self.setupCalendarView()
        let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))

        if self.orderID > 0 && DivisionId == "50"{
            self.getCopyOrderData()

        }else{
            
            self.getROSData()
        }
        
        // Do any additional setup after loading the view.
        
      //  customPickerView.dtPickerView.
    }
    
    func addInputAccessoryView(dTextView: UITextView){
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(keyboardDoneBtnTapped))]
        toolBar.sizeToFit()
        
        dTextView.inputAccessoryView = toolBar
    }
    
    @objc func keyboardDoneBtnTapped(sender: UIButton)  {
        self.view.endEditing(true)
    }
    
    func setupPickerView(){
        customPickerView = Bundle.main.loadNibNamed("JPPickerView", owner: self, options: nil)?[0] as! JPPickerView
        
        customPickerView.setupUI()
        customPickerView.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
        customPickerView.doneButton.addTarget(self, action:#selector(self.timeButtonTapped), for:.touchUpInside)
        customPickerView.dtPickerView.addTarget(self, action:#selector(self.datePickerValueChanged), for:.valueChanged)
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
    @objc func timeButtonTapped(sender:UIButton) {
        
        customPickerView.removePickerViewFromSuperView()
        
        if firstResponderTxtFieldTag == Int(MonStartTxtFieldTag) || firstResponderTxtFieldTag == Int(MonEndTxtFieldTag) ||  firstResponderTxtFieldTag == Int(TueStartTxtFieldTag) || firstResponderTxtFieldTag == Int(TueEndTxtFieldTag) || firstResponderTxtFieldTag == Int(WedStartTxtFieldTag) || firstResponderTxtFieldTag == Int(WedEndTxtFieldTag)!  ||  firstResponderTxtFieldTag == Int(ThuStartTxtFieldTag)! || firstResponderTxtFieldTag == Int(ThuEndTxtFieldTag) ||  firstResponderTxtFieldTag == Int(FriStartTxtFieldTag) || firstResponderTxtFieldTag == Int(FriEndTxtFieldTag) || firstResponderTxtFieldTag == Int(SatStartTxtFieldTag) || firstResponderTxtFieldTag == Int(SatEndTxtFieldTag)!  ||  firstResponderTxtFieldTag == Int(SunStartTxtFieldTag)! || firstResponderTxtFieldTag == Int(EndTimeTxtFieldTag) || firstResponderTxtFieldTag == Int(SunEndTxtFieldTag) || firstResponderTxtFieldTag == Int(StartTimeTxtFieldTag){
            
            //Show the  previuosly  selected Time else show current date
            let changedDate = customPickerView.dtPickerView.date
            customPickerView.dtPickerView.locale = NSLocale(localeIdentifier: "en_US") as Locale
            self.setDatePickerValue(changedDate: changedDate)
        }
    }
    @objc func yesBtnTapped(sender: UIButton){
        TempTeacherCreditSelection = "Yes"
        self.tableView.reloadData()
        
    }
    
    @objc func addLessonPlanBtnTapped(sender: UIButton){
        
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
        showLessonPlanTextView = sender.isSelected
        self.tableView.reloadData()
    }
    
    @objc func uploadLessonPlanBtnTapped(sender: UIButton){
        //Present iCloud Files
        //        showMenu()
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypeContent)], in: .import)
        importMenu.delegate = self
        
        let modelName = UIDevice.current.modelName
        
        if modelName.contains("iPad"){
            importMenu.modalPresentationStyle = .popover
            importMenu.popoverPresentationController?.sourceView = self.view
            
            importMenu.preferredContentSize   = CGSize(width:600, height:600)
            
            let popoverPresentationViewController = importMenu.popoverPresentationController
            
            popoverPresentationViewController?.permittedArrowDirections = UIPopoverArrowDirection.any
            popoverPresentationViewController?.sourceView = sender
            popoverPresentationViewController?.sourceRect = sender.bounds
            
            present(importMenu, animated: true, completion: nil)
            
            
            
        }else{
            
            importMenu.modalPresentationStyle = .fullScreen
            
            self.present(importMenu, animated: true, completion: nil)
        }
    }
    @objc func deleteLessonPlanBtnTapped(sender: UIButton){
        documentsArray.removeAllObjects()
        documetBytes.removeAllObjects()
        fileExtensions.removeAllObjects()
        //        documentsTableView.reloadData()
        uploadedFileName = ""
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.reloadData()
            //            self.navigationController?.view.makeToast("File Deleted", duration: 0.5, position: .bottom, title: "", image: nil)
        })
        
        
    }
    @objc func noBtnTapped(sender: UIButton){
        TempTeacherCreditSelection = "No"
        self.tableView.reloadData()
    }
    func formMultiDayArray(){
        
        //        let startTimePlaceHolder = "Start Time"
        //        let endTimePlaceHolder = "End Time"
        
        let monDict = ["day":"MON","header":startTimePlaceHolder,"showDropDown":"0","StartTag":MonStartTxtFieldTag,"EndTag":MonEndTxtFieldTag,"StartValue":"","EndValue":"","subHeader":endTimePlaceHolder]
        let tuesDict = ["day":"TUE","header":startTimePlaceHolder,"showDropDown":"0","StartTag":TueStartTxtFieldTag,"EndTag":TueEndTxtFieldTag,"StartValue":"","EndValue":"","subHeader":endTimePlaceHolder]
        let wedDict = ["day":"WED","header":startTimePlaceHolder,"showDropDown":"0","StartTag":WedStartTxtFieldTag,"EndTag":WedEndTxtFieldTag,"StartValue":"","EndValue":"","subHeader":endTimePlaceHolder]
        let thurDict = ["day":"THU","header":startTimePlaceHolder,"showDropDown":"0","StartTag":ThuStartTxtFieldTag,"EndTag":ThuEndTxtFieldTag,"StartValue":"","EndValue":"","subHeader":endTimePlaceHolder]
        let friDict = ["day":"FRI","header":startTimePlaceHolder,"showDropDown":"0","StartTag":FriStartTxtFieldTag,"EndTag":FriEndTxtFieldTag,"StartValue":"","EndValue":"","subHeader":endTimePlaceHolder]
        let satDict = ["day":"SAT","header":startTimePlaceHolder,"showDropDown":"0","StartTag":SatStartTxtFieldTag,"EndTag":SatEndTxtFieldTag,"StartValue":"","EndValue":"","subHeader":endTimePlaceHolder]
        let sunDict = ["day":"SUN","header":startTimePlaceHolder,"showDropDown":"0","StartTag":SunStartTxtFieldTag,"EndTag":SunEndTxtFieldTag,"StartValue":"","EndValue":"","subHeader":endTimePlaceHolder]
        
        
        
        weekDayArray = [monDict,tuesDict,wedDict,thurDict,friDict,satDict,sunDict]
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
            }else{
                
            }
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
                    orderDataArray.replaceObject(at: indexOfObj, with: mutableDObj)
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
                placeholderheader = startDatePlaceHolder
            }
                
            else if  firstResponderTxtFieldTag == Int(StartTimeTxtFieldTag) || firstResponderTxtFieldTag == Int(EndTimeTxtFieldTag){
                
                placeholderheader = startTimePlaceHolder
            }
            
        }else if selectedSementTag == 1{
            
            placeholderheader = "Start Time"
            
        }
        for dict in forArray{
            
            let   dictObj : NSDictionary = dict as! NSDictionary
            let headerValue = dictObj["header"] as! String
            
            if placeholderheader.count>0 && headerValue.contains(placeholderheader) {
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
                forArray.replaceObject(at: indexOfObj, with: mutableDictObj)
            }else{
                print("Did not matched")
                //Again Check with the tag
                self.updateWeeklyTimePickerValue(forArray: forArray, dateString: dateString)
            }
            self.tableView.reloadData()
            
        }
        
        
    }
    @objc func clearAllBtnBtnTapped(sender: UIButton){
        for emp in employeeArray {
            
            let  empObj:NewEmployee = emp as! NewEmployee
            
            empObj.isCheckedInRoaster = "0"
            empObj.isSelected = "0"
            employeeArray.remove(empObj)
        }
        employeeArray.removeAllObjects()
        self.tableView.reloadData()
        
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
    @objc func clearEntryBtnTapped(sender: UIButton){
        
        for emp in selectedEmployeeArray {
            
            let  empObj:NewEmployee = emp as! NewEmployee
            empObj.isSelected = "0"
            empObj.isCheckedInRoaster = "0"
            if employeeArray.contains(empObj){
                employeeArray.remove(empObj)
            }
        }
        selectedEmployeeArray.removeAllObjects()
        self.tableView.reloadData()
        
    }
    @objc func dropDownBtnTapped(sender: UIButton)  {
        
        let senderPosition  = sender.convert(CGPoint.zero, to: self.tableView)
        
        let indexPath =  self.tableView.indexPathForRow(at:senderPosition)
        
        var dict = NSDictionary()
        if selectedSementTag == 0{
            dict = orderDataArray[(indexPath?.row)!] as! NSDictionary
        }else{
            dict = multiDayDataArray[(indexPath?.row)!] as! NSDictionary
        }
        
        
        let placeholder = dict["header"] as! String
        
        selectedDropDown = placeholder
        //         dataTableView.reloadRows(at: [indexPath!], with: .top)
        var tag = 0
        
        if placeholder == repotToPlaceHolder{
            tag = reportToTblViewTag
        }else if placeholder == reasonForOrderPlaceHolder{
            tag = reasonforOrderTblViewTag
        }else if placeholder == subjectPlaceHolder{
            tag = subjectsTblViewTag
        }else if placeholder == gradePlaceHolder{
            tag = gradesTblViewTag
        }
        
        self.showDropDownWithTag(placeHolder: placeholder, tag: tag)
        
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
//
                            if  Int(minute)! >  (minutes.lastObject as! NSString).integerValue  {
                                min =   minutes.lastObject as! String
                            }else{
                                for i in 0...minutes.count-1 {
                                    let dValue = (minutes[i] as! NSString).integerValue
                                    if Int(minute)! == dValue {
                                        min = String(format:"%d",dValue)
                                        break
                                    } else{
                                        if i > 0{
                                            let dPrevValue =  minutes[i - 1] //as! NSString).integerValue
                                            if Int(minute)! < dValue  {
                                                min = dPrevValue as! String //String(format:"%d",minuteInterval)
                                                break
                                            }
                                        }
                                    }
                                }
                            }
                            print(min)
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
                self.updateDatesFromPicker(dateString: pickedDateString, forArray: orderDataArray)
                
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
                    if  Int(minute)! >  (minutes.lastObject as! NSString).integerValue  {
                        min =   minutes.lastObject as! String
                    }else{
                        for i in 0...minutes.count-1 {
                            let dValue = (minutes[i] as! NSString).integerValue
                            if Int(minute)! == dValue {
                                min = String(format:"%d",dValue)
                                break
                            } else{
                                if i > 0{
                                    let dPrevValue =  minutes[i - 1] //as! NSString).integerValue
                                    if Int(minute)! < dValue  {
                                        min = dPrevValue as! String //String(format:"%d",minuteInterval)
                                        break
                                    }
                                }
                            }
                        }
                    }
                    print(min)
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
                self.updateDatesFromPicker(dateString: pickedDateString, forArray: orderDataArray)
                
            }
            
        }
        self.tableView.reloadData()
    }
    @objc func datePickerValueChanged(sender: UIDatePicker){
        
        //▿ 2017-10-29 11:20:00 +0000
        sender.locale = NSLocale(localeIdentifier: "en_US") as Locale
        let changedDate = sender.date
      
        self.setDatePickerValue(changedDate: changedDate)

       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - SERVER CALL
    
    //7684042448
    func getCopyOrderData() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            //            JustHUD.shared.showInView(view: view)
            self.showLoading()
            
            let defaults = UserDefaults.standard
            
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let DivisionId = String(format:"%d", defaults.integer(forKey: "DivisionId"))
             let orderId = String(format:"%d", self.orderID)
             let noOfPositions = copyOrderNoofPositions

            let params :[String:String] = ["ContactId":ContactId,"ClientID":clientID,"DivisionId":DivisionId,"OrderSource":"iOS","Order_Id":orderId,"NoofPositions":noOfPositions,"StartTime":StartTime,"EndTime":EndTime]
            
            print(params)
            
            RestAPI.getCopyOrderForSchoolProfessional(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getCopyOrderResponse(response:))
        }else{
            isWarningMessage = false
            isErrorMessage = false
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
            //            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
        }
        
    }
    
    func getROSData() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            //            JustHUD.shared.showInView(view: view)
            self.showLoading()
            
            let defaults = UserDefaults.standard
            
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let DivisionId = String(format:"%d", defaults.integer(forKey: "DivisionId"))
            
            let params :[String:String] = ["ContactId":ContactId,"ClientID":clientID,"DivisionId":DivisionId,"OrderSource":"iOS"]
            
            print(params)
            
            RestAPI.getROSSchoolProfesOrders(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getROSResponse(response:))
        }else{
            isWarningMessage = false
            isErrorMessage = false
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
            //            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
        }
        
    }
    func getCopyOrderResponse(response:AnyObject)->()
    {
        
        //        JustHUD.shared.hide()
        self.hideLoading()
        
        print(response)
        if response is String{
            
            isWarningMessage = false
            isErrorMessage = true
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                orderDataArray .removeAllObjects()
                let positionTypeDataArray = object["PositionsList"].array // as! NSMutableArray
                let gradeDataArray  = object["GradeList"].array  //as! NSMutableArray
                let positionSkillDataArray = object["NewPositionSkillList"].array // as! NSMutableArray
                let   reportToDataArray = object["ReportToList"].array  //as! NSMutableArray
                let  reasonForOrderDataArray = object["OrderReasonList"].array // as! NSMutableArray
                let  durationArray = object["DurationList"].array // as! NSMutableArray
                
                for dict in durationArray! {
                    
                    let duration = String(dict["Duration"].intValue)
                    minutes.add(duration)
                    
                }
                //set the time interval for entering time
                if minutes.count >= 2 {
                    minuteInterval = Int(minutes[1] as! String)!
                    customPickerView.dtPickerView.minuteInterval = minuteInterval
                    
                }
                for dict in positionTypeDataArray! {
                    
                    let posType = PositionType.init(PositionId: dict["PositionId"].intValue,PositionName: dict["PositionName"].stringValue ,isSelected: "0")
                    positionTypeArray.add(posType)
                    //                    selectedSementTag = 1
                }
                //By default 1st item wil be selected
                
                if positionTypeArray.count > 0{
                    
                    let posType = positionTypeArray[0] as! PositionType
                    selectedPositionType = PositionType.init(PositionId: posType.PositionId,PositionName:posType.PositionName,isSelected: "1" )
                    positionTypeArray.replaceObject(at: 0, with: selectedPositionType)
                }
                
                for dict in gradeDataArray! {
                    
                    let posType = Grade.init(GradeCode: dict["GradeCode"].intValue,GradeName: dict["GradeName"].stringValue,isSelected: "0" )
                    gradeArray.add(posType)
                }
                for dict in positionSkillDataArray! {
                    
                    let posType = PositionSkill.init(SkillCode: dict["SkillCode"].intValue,SkillName: dict["SkillName"].stringValue,isSelected: "0",SkillExperience: dict["SkillExperience"].intValue)
                    positionSkillArray.add(posType)
                }
                for dict in reportToDataArray! {
                    
                    let posType = ReportTo.init(ContactId: dict["ContactId"].intValue,Name: dict["Name"].stringValue,isSelected: "0" )
                    reportToArray.add(posType)
                }
                for dict in reasonForOrderDataArray! {
                    
                    let posType = ReasonForOrder.init(ReasonId: dict["ReasonId"].intValue,ReasonDescription: dict["ReasonDescription"].stringValue,isSelected: "0" )
                    reasonForOrderArray.add(posType)
                }
                
                
                StartDate = object["Start_Date"].stringValue
                EndDate = object["End_Date"].stringValue
                StartTime = object["StartTime"].stringValue
                EndTime = object["EndTime"].stringValue
                ReportToAddress = object["ReportToAddress"].stringValue
                ReportToCity = object["ReportToCity"].stringValue
                ReportToPhone = object["ReportToPhone"].stringValue
                ReportToZip = object["ReportToZip"].stringValue
                ReportToFax = object["ReportToFax"].stringValue
                ReportToState = object["ReportToState"].stringValue
                NoofPositions = object["NoofPositions"].intValue
                TempNoofPositions = NoofPositions
                TeacherCreditSelection = object["TeacherCreditSelection"].stringValue
                TempTeacherCreditSelection = TeacherCreditSelection
                self.formDataArrayForTableview()
                
                //                if orderDataArray.count == 0 {
                //                    lblNoData.isHidden = false
                //                }else{
                //                    lblNoData.isHidden = true
                //                }
                //
                
                
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                isWarningMessage = false
                isErrorMessage = true
                
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
            
            isWarningMessage = false
            isErrorMessage = true
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                orderDataArray .removeAllObjects()
                let positionTypeDataArray = object["PositionsList"].array // as! NSMutableArray
                let gradeDataArray  = object["GradeList"].array  //as! NSMutableArray
                let positionSkillDataArray = object["NewPositionSkillList"].array // as! NSMutableArray
                let   reportToDataArray = object["ReportToList"].array  //as! NSMutableArray
                let  reasonForOrderDataArray = object["OrderReasonList"].array // as! NSMutableArray
                let  durationArray = object["DurationList"].array // as! NSMutableArray
                
                for dict in durationArray! {
                    
                    let duration = String(dict["Duration"].intValue)
                    minutes.add(duration)
                    
                }
                //set the time interval for entering time
                if minutes.count >= 2 {
                    minuteInterval = Int(minutes[1] as! String)!
                    customPickerView.dtPickerView.minuteInterval = minuteInterval
                    
                }
                for dict in positionTypeDataArray! {
                    
                    let posType = PositionType.init(PositionId: dict["PositionId"].intValue,PositionName: dict["PositionName"].stringValue ,isSelected: "0")
                    positionTypeArray.add(posType)
                    //                    selectedSementTag = 1
                }
                //By default 1st item wil be selected
                
                if positionTypeArray.count > 0{
                    
                    let posType = positionTypeArray[0] as! PositionType
                    selectedPositionType = PositionType.init(PositionId: posType.PositionId,PositionName:posType.PositionName,isSelected: "1" )
                    positionTypeArray.replaceObject(at: 0, with: selectedPositionType)
                }
                
                for dict in gradeDataArray! {
                    
                    let posType = Grade.init(GradeCode: dict["GradeCode"].intValue,GradeName: dict["GradeName"].stringValue,isSelected: "0" )
                    gradeArray.add(posType)
                }
                for dict in positionSkillDataArray! {
                    
                    let posType = PositionSkill.init(SkillCode: dict["SkillCode"].intValue,SkillName: dict["SkillName"].stringValue,isSelected: "0",SkillExperience: dict["SkillExperience"].intValue)
                    positionSkillArray.add(posType)
                }
                for dict in reportToDataArray! {
                    
                    let posType = ReportTo.init(ContactId: dict["ContactId"].intValue,Name: dict["Name"].stringValue,isSelected: "0" )
                    reportToArray.add(posType)
                }
                for dict in reasonForOrderDataArray! {
                    
                    let posType = ReasonForOrder.init(ReasonId: dict["ReasonId"].intValue,ReasonDescription: dict["ReasonDescription"].stringValue,isSelected: "0" )
                    reasonForOrderArray.add(posType)
                }
                
                
                StartDate = self.getFormattedDate(string:  object["StartDate"].stringValue)
                EndDate = self.getFormattedDate(string:  object["EndDate"].stringValue)
                StartTime = object["StartTime"].stringValue
                EndTime = object["EndTime"].stringValue
                ReportToAddress = object["ReportToAddress"].stringValue
                ReportToCity = object["ReportToCity"].stringValue
                ReportToPhone = object["ReportToPhone"].stringValue
                ReportToZip = object["ReportToZip"].stringValue
                ReportToFax = object["ReportToFax"].stringValue
                ReportToState = object["ReportToState"].stringValue
                NoofPositions = object["NoofPositions"].intValue
                TempNoofPositions = NoofPositions
                TeacherCreditSelection = object["TeacherCreditSelection"].stringValue
                if object["AdditionalComments"].stringValue.count > 0 {
                empTextViewPlaceHolder = object["AdditionalComments"].stringValue
            }
                TempTeacherCreditSelection = TeacherCreditSelection
                self.formDataArrayForTableview()
                
                //                if orderDataArray.count == 0 {
                //                    lblNoData.isHidden = false
                //                }else{
                //                    lblNoData.isHidden = true
                //                }
                //
                
                
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                isWarningMessage = false
                isErrorMessage = true
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
    }
    
    func formDataArrayForTableview(){
        
        
        let posDict = ["header":posTypePlaceHolder,"type":"collectionView","showDropDown":"0"]
        let gradeDict = ["header":gradePlaceHolder,"type":"collectionView","showDropDown":"0"]
        let subjectDict = ["header":subjectPlaceHolder,"type":"collectionView","showDropDown":"0"]
        let posNumDict = ["header":noOfPosPlaceHolder,"type":"TextField","showDropDown":"0"]
        
        let dateDict = ["header":startDatePlaceHolder,"subHeader":endDatePlaceHolder,"type":"Date Cell","showDropDown":"0","StartTag":StartDateTxtFieldTag,"EndTag":EndDateTxtFieldTag,"StartValue":StartDate,"EndValue":EndDate]
        let creditSelectionDict = ["header":creditSelectionPlaceholder]
        
        let timeDict = ["header":startTimePlaceHolder,"subHeader":endTimePlaceHolder,"type":"Date Cell","showDropDown":"0","StartTag":StartTimeTxtFieldTag,"EndTag":EndTimeTxtFieldTag,"StartValue":StartTime,"EndValue":EndTime]
        
        let reportToDict = ["header":repotToPlaceHolder,"type":"Drop Down","showDropDown":"0"]
        let reasonforOrderDict = ["header":reasonForOrderPlaceHolder,"type":"Drop Down","showDropDown":"0"]
        let referenceNoteDict = ["header":"Reference Note","type":"TextView","showDropDown":"0","Tag":referenceNoteTxtViewTag]
        
        let empCommentDict = ["header":"Additional Comments for Employees","type":"TextView","subHeader":"","Tag":empCommentTxtViewTag,"placeholder":empTextViewPlaceHolder]
        let divCommentDict = ["header":"Comments for School Professionals","subHeader":"These comments are not to be relayed to the employee, and will be viewed by School Professionals only ","type":"TextView","Tag":divisionCommentTxtViewTag,"placeholder":divisionTextViewPlaceHolder]
        let searchEmpBtnDict = ["header":"Search Button","type":"Button"]
        let searchEmpListDict = ["header":"Search Emp List","type":"TableView"]
        let SegmentDict = ["header":"Segment","type":"Segment"]
        let lessonPlanDict = ["header":"Lesson Plan","type":"Upload"]
        let nextbtnDict = ["header":"Next","type":"Button"]
        
        let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
        if DivisionId == "117"{
            orderDataArray = [posDict,gradeDict,posNumDict,lessonPlanDict,dateDict,SegmentDict,timeDict,reportToDict,reasonforOrderDict,referenceNoteDict,empCommentDict,divCommentDict,searchEmpBtnDict,searchEmpListDict,nextbtnDict]
            
        }else{
            if DivisionId == "92"{
                orderDataArray = [posDict,gradeDict,subjectDict,posNumDict,lessonPlanDict,dateDict,creditSelectionDict,SegmentDict,timeDict,reportToDict,reasonforOrderDict,referenceNoteDict,empCommentDict,divCommentDict,searchEmpBtnDict,searchEmpListDict,nextbtnDict]
                
            }else{
                orderDataArray = [posDict,gradeDict,subjectDict,posNumDict,lessonPlanDict,dateDict,SegmentDict,timeDict,reportToDict,reasonforOrderDict,referenceNoteDict,empCommentDict,divCommentDict,searchEmpBtnDict,searchEmpListDict,nextbtnDict]
                
            }
            
            
        }
        
        self.tableView.reloadData()
        
    }
    func getSearchedEmployee(){
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            //            JustHUD.shared.showInView(view: view)
            self.showLoading()
            
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            
            /*
             {"ClientId":70830,"SearchEndDate":"08/08/2018","SearchStartDate":"08/08/2018"}
             */
            let selecetdPosTypeID = String(format:"%d",selectedPositionType.PositionId!)

            let params :[String:String] = ["ClientId" : clientID ,"SearchStartDate" : StartDate, "SearchEndDate" : EndDate,"PositionType": selecetdPosTypeID,"PositionName":selectedPositionType.PositionName!]
            
            print(params)
            
            RestAPI.getSearchedEmpROSSchoolProfes(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getSearchedEmpResponse(response:))
        }else{
            //            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
            //            self.ShowAlertMessage(ErrorMessage: "No Internet Connection", titleMessage: "", view: self)
            isWarningMessage = false
            isErrorMessage = false
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
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
                let empArray = object["SearchEmployeeList"].array
                let empDataArray = NSMutableArray()
                
                for dict in empArray! {
                    
                    
                    
                    let Weekly_Hours = String(format:"%.2f",dict["WeeklyHours"].doubleValue)
                    let YTD_Hours = String(format:"%.2f",dict["YTDHours"].doubleValue)
                    let Eval = String(format:"%d",dict["Eval"].intValue)
                    
                    let empObj = NewEmployee.init(CandidateId: dict["CandidateId"].intValue, Name: dict["Name"].stringValue, lastDate: dict["LastOrderDate"].stringValue, Weekly_Hours: Weekly_Hours, positions: dict["Position"].stringValue, Eval: Eval, YTD_Hours: YTD_Hours, isCheckedInRoaster:  "0",isSelected: "0",Photo: dict["Photo"].stringValue,Evaluation: dict["Evaluation"].doubleValue,DummyImagePath:dict["DummyImagePath"].stringValue,isfavourite:dict["isfavourite"].intValue,favColor:dict["FavoriteColor"].stringValue)
                    
                    
                    empDataArray.add(empObj)
                    
                }
                ResponseEmployeeArray = empDataArray
                
                if empDataArray.count == 0{
                    self.ShowAlertMessage(message: "No employee found", title: "")
                    
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
    ////****
    
    
    
    func validatePositionTab() -> Bool{
        let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
        //        var errorMessage = ""
        
        if selectedGradesArray.count == 0{
            isValidGrades = false
            //            errorMessage = "Please select at least one grade"
        }else{
            isValidGrades = true
            
        }
        if selectedSubjectsArray.count == 0{
            
            if DivisionId == "117"{
                //                errorMessage = ""
                isValidSubjects = true
            }else{
                isValidSubjects = false
                //                errorMessage = "Please select at least one Subject"
            }
        }else{
            isValidSubjects = true
            
        }
        if selectedReasonForOrder.ReasonId == 0{
            isValidReasonForOrder = false
            //            errorMessage = "Please select Reason for Order"
            
        }else{
            isValidReasonForOrder = true
            
        }
        if selectedReportTo.Name?.count == 0{
            isValidReportTo = false
            
            //            errorMessage = "Please select Report to"
            
        }else{
            isValidReportTo = true
            
        }
        
        if isValidGrades ==  true && isValidSubjects ==  true && isValidReportTo ==  true && isValidReasonForOrder ==  true{
            
            allDataValidated = true
        }else {
            allDataValidated = false
            self.tableView.setContentOffset(CGPoint.zero, animated: true)
            
        }
        
        return allDataValidated
        
    }
    
    
    /////*****
    
    
    
    
    //MARK: Delegates
    @objc func nextButtonTapped( sender: UIButton) {
        
        let isValidated = self.validatePositionTab()
        
        if isValidated == true{
            self.createOrderAPIFormParamAndPushToSummaryPage()
        }else{
            isWarningMessage = false
            isErrorMessage = false
            
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Please enter all the mandatory fields   ", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            self.tableView.reloadData()
        }
        
    }
    @objc func searchBtnTapped(sender: UIButton)  {
        
        self.getSearchedEmployee()
//        if ResponseEmployeeArray.count == 0{
//
//
//        }else{
//
//            self.pushToSearchEmpListPage(dataArray: ResponseEmployeeArray)
//        }
        
    }
    @objc func clearStartTimeBtnTapped(sender: UIButton){
        
        firstResponderTxtFieldTag = sender.tag
        
        
        //Time
        if selectedSementTag == 1{
            self.updateDatesFromPicker(dateString: "", forArray: multiDayDataArray)
            //multi schdule array
        }else{
            //schdule array
            self.updateDatesFromPicker(dateString: "", forArray: orderDataArray)
            
        }
        self.tableView.reloadData()
        
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
            self.updateDatesFromPicker(dateString: "", forArray: orderDataArray)
            
        }
        self.tableView.reloadData()
        
    }
    @objc func addReportToBtnTapped(sender: UIButton)  {
        self.pushToAddReportToPage()
    }
    @objc func referenceNoteBtnTapped(sender: UIButton)  {
        let message = "Any information added in the Reference Note box will be displayed on the timeslip for this substitute. You can use this information as an internal reference for timeslip approval and other reports. An example of something you can enter in this field would be the name of the permanent teacher the substitute is covering for."
        //        DispatchQueue.main.async(execute: { () -> Void in
        //            let alert = UIAlertController(title:"", message: message, preferredStyle: UIAlertControllerStyle.alert)
        //            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        //
        //            let paragraph = NSMutableParagraphStyle()
        //            paragraph.alignment = .left
        //
        //            let messageText = NSMutableAttributedString(
        //                string: message,
        //                attributes: [
        //                    NSAttributedStringKey.paragraphStyle: paragraph,
        //                    NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12),
        //                    NSAttributedStringKey.foregroundColor : UIColor.black
        //                ]
        //            )
        //
        //            alert.setValue(messageText, forKey: "attributedMessage")
        //
        //            self.present(alert, animated: true, completion: nil)
        //        })
        
        isWarningMessage = false
        isErrorMessage = false
        
        self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: info_Text, isAttributed: false)
    }
    @objc func subjectCellBtnTapped(sender: UIButton)  {
        
        
        let senderPosition  = sender.convert(CGPoint.zero, to: dropdownTableView)
        
        let indexPath =  dropdownTableView.indexPathForRow(at:senderPosition)
        let posSkill = positionSkillArray[(indexPath?.row)!]
        
        let  posSkillObj:PositionSkill = posSkill as! PositionSkill
        
        
        let isSelecetd = posSkillObj.isSelected
        
        if isSelecetd == "1"{
            posSkillObj.isSelected = "0"
            posSkillObj.SkillExperience = 0
            selectedSubjectsArray.remove(posSkillObj)
            
        }else{
            posSkillObj.isSelected = "1"
            posSkillObj.SkillExperience = 1
            selectedSubjectsArray.add(posSkillObj)
        }
        positionSkillArray.replaceObject(at: (indexPath?.row)!, with: posSkillObj)
        
        dropdownTableView.reloadData()
        
        self.tableView.reloadData()
    }
    @objc func expReqdCellBtnTapped(sender: UIButton)  {
        
        
        let senderPosition  = sender.convert(CGPoint.zero, to: dropdownTableView)
        
        let indexPath =  dropdownTableView.indexPathForRow(at:senderPosition)
        let posSkill = positionSkillArray[(indexPath?.row)!]
        
        let  posSkillObj:PositionSkill = posSkill as! PositionSkill
        
        if posSkillObj.isSelected == "1"{
            
            let SkillExperience = String(format:"%d",posSkillObj.SkillExperience!)
            
            if SkillExperience == "1"{
                posSkillObj.SkillExperience = 0
                
            }else{
                posSkillObj.SkillExperience = 1
                
            }
            positionSkillArray.replaceObject(at: (indexPath?.row)!, with: posSkillObj)
            
            dropdownTableView.reloadData()
        }
        
        
        
    }
    //MARK: TableView DataSource & Delegate
    override  public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
        if (tableView.tag == subjectsTblViewTag) &&  (DivisionId == "92"){
            return 20
        }
        return 0
    }
    override public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
        if (tableView.tag == subjectsTblViewTag) &&  (DivisionId == "92"){
            
            let headerView = UIView()
            headerView.frame = CGRect(x: 0,y: 0, width: tableView.bounds.size.width,height: 20)
            headerView.backgroundColor = UIColor(hexString:"#F0F1F2")
            
            let subjectLbl = UILabel.init(frame: CGRect(x: 0,y: 0, width: tableView.bounds.size.width/2,height: 20))
            let expLbl = UILabel.init(frame: CGRect(x: tableView.bounds.size.width/2,y: 0, width: tableView.bounds.size.width/2,height: 20))
            subjectLbl.text = "Select"
            expLbl.text = "Exp. Required"
            subjectLbl.font = UIFont.systemFont(ofSize: 12)
            expLbl.font = UIFont.systemFont(ofSize: 12)
            expLbl.textAlignment = .right
            subjectLbl.textAlignment = .left
            subjectLbl.textColor = UIColor.darkGray
            expLbl.textColor = UIColor.darkGray
            headerView.addSubview(subjectLbl)
            headerView.addSubview(expLbl)
            
            return headerView
        }
        
        return nil
    }
    
    
    override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == empTblViewTag{
            return  employeeArray.count
        }else if tableView.tag == reportToTblViewTag{
            return reportToArray.count
        }else if tableView.tag == reasonforOrderTblViewTag{
            return reasonForOrderArray.count
        }else if tableView.tag == subjectsTblViewTag{
            return positionSkillArray.count
        }else if tableView.tag == gradesTblViewTag{
            return gradeArray.count
            
        }else{
            if selectedSementTag == 1{
                if multiDayDataArray.count > 0{
                    print(multiDayDataArray)
                    return multiDayDataArray.count
                    
                }else{
                    let tempDataArray = NSMutableArray()
                    //First element is being removed from original array
                    for dict in orderDataArray{
                        let  dictObj = dict as! NSDictionary
                        tempDataArray.add(dictObj)
                    }
                    //get the index of Time Dict and fill the details
                    
                    var indexOfObj = -1
                    
                    let placeholderheader = startTimePlaceHolder
                    
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
                    print(multiDayDataArray)
                    
                    return multiDayDataArray.count
                    
                    
                }
            }else{
                
                return orderDataArray.count
            }
            
        }
        //        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
        if tableView.tag == empTblViewTag ||  tableView.tag == reportToTblViewTag ||  tableView.tag == reasonforOrderTblViewTag ||  tableView.tag == subjectsTblViewTag ||  tableView.tag == gradesTblViewTag{
            
            
            if (tableView.tag == subjectsTblViewTag) &&  (DivisionId == "92"){
                
                return self.dropDownCell(tableView:tableView, indexPath:indexPath)
                
            }
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?
            if !(cell != nil) {
                cell = UITableViewCell(style:.subtitle, reuseIdentifier: "CELL")
            }
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            
            if tableView.tag == empTblViewTag{
                
                let  emp = employeeArray[indexPath.row] as! NewEmployee
                let  empObj:NewEmployee = emp as NewEmployee
                let name =   empObj.Name
                cell?.textLabel?.text = name
                if empObj.isSelected == "0"{
                    cell?.backgroundColor = UIColor.white
                }else{
                    cell?.backgroundColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
                }
                
                
            }else  if tableView.tag == reportToTblViewTag{
                
                let obj = reportToArray[indexPath.row]
                
                let  o:ReportTo = obj as! ReportTo
                cell?.textLabel?.text = o.Name
                if o.isSelected == "1"{
                    cell?.accessoryType = .checkmark
                }else{
                    cell?.accessoryType = .none
                }
            }else if tableView.tag == reasonforOrderTblViewTag{
                
                let reasonOrder = reasonForOrderArray[indexPath.row]
                
                let  reasonOrderObj:ReasonForOrder = reasonOrder as! ReasonForOrder
                cell?.textLabel?.text = reasonOrderObj.ReasonDescription
                if reasonOrderObj.isSelected == "1"{
                    cell?.accessoryType = .checkmark
                }else{
                    cell?.accessoryType = .none
                }
            }else if tableView.tag == subjectsTblViewTag{
                
                let posSkill = positionSkillArray[indexPath.row]
                
                let  posSkillObj:PositionSkill = posSkill as! PositionSkill
                cell?.textLabel?.text = posSkillObj.SkillName
                if posSkillObj.isSelected == "1"{
                    cell?.accessoryType = .checkmark
                }else{
                    cell?.accessoryType = .none
                }
                
            }else if tableView.tag == gradesTblViewTag{
                
                let oGrade = gradeArray[indexPath.row]
                
                let  gradeObj:Grade = oGrade as! Grade
                cell?.textLabel?.text = gradeObj.GradeName
                if gradeObj.isSelected == "1"{
                    cell?.accessoryType = .checkmark
                }else{
                    cell?.accessoryType = .none
                }
                
            }
            
            
            return cell!
            
        }
        
        
        
        var dict = NSDictionary()
        if selectedSementTag == 0{
            dict = orderDataArray[indexPath.row] as! NSDictionary
        }else{
            dict = multiDayDataArray[indexPath.row] as! NSDictionary
        }
        
        let placeholder = dict["header"] as! String
        
        if placeholder == gradePlaceHolder || placeholder == subjectPlaceHolder || placeholder == posTypePlaceHolder || placeholder == repotToPlaceHolder || placeholder == reasonForOrderPlaceHolder
        {
           
            return  self.collectionViewCell(indexPath: indexPath as NSIndexPath)
            
        }else if placeholder == "Search Button" {
            //Button
            return self.ButtonTableCell(indexPath: indexPath as NSIndexPath,identifier: SearchButtonCellIdentifier)
        }else if placeholder == "Search Emp List"{
            //TableView CEll
            return self.TableViewCell(tableView: tableView)
        } else if placeholder.contains("Time") {
            if selectedSementTag == 0{
                return self.dateViewCell(tableView: tableView,indexPath: indexPath as NSIndexPath,placeHolder: "" )
            }else{
                return self.weekTimeViewCell(tableView: tableView, indexPath: indexPath as NSIndexPath)
            }
        }else if placeholder == noOfPosPlaceHolder{
            return self.textEntryCell(placeholder: placeholder, tableView: tableView)
        }else if placeholder == creditSelectionPlaceholder{
            return self.TeacherCreditSelectionCell(placeholder: placeholder, tableView: tableView)
        }else if placeholder.contains("Date") {
            
            return self.dateViewCell(tableView: tableView,indexPath: indexPath as NSIndexPath,placeHolder: "" )
        }else if placeholder.contains("Segment"){
            return segmentTableViewCell(tableView: tableView)
            
        }else if placeholder.contains("Comment")  {
            
            return textViewCell(tableView: tableView, indexPath: indexPath as NSIndexPath, placeHolder: placeholder, dataDict: dict)
            
        }else if placeholder == "Reference Note"{
            
            return referenceNoteTextViewCell(tableView: tableView, indexPath: indexPath as NSIndexPath, placeHolder: placeholder, dataDict: dict)
        }else if placeholder.contains("Lesson"){
            //LessonPlanTableViewCellIdentifier
            
            return self.lessonPlanCell(placeholder: placeholder, tableView: tableView)
        }else if placeholder == "Next"{
            //LessonPlanTableViewCellIdentifier
            
            return self.ButtonTableCell(indexPath: indexPath as NSIndexPath,identifier: NextButtonCellIdentifier)
            
        }
        
        return UITableViewCell()
        
    }
    override  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
        if tableView.tag == mainTblViewTag{
            
            var dict = NSDictionary()
            if selectedSementTag == 0{
                dict = orderDataArray[indexPath.row] as! NSDictionary
            }else{
                dict = multiDayDataArray[indexPath.row] as! NSDictionary
            }
            
            let placeholder = dict["header"] as! String
            
            if placeholder == posTypePlaceHolder{
                let height = CGFloat(positionTypeArray.count * 42) + 55
                return  max(105,height)
            } else if placeholder == gradePlaceHolder || placeholder == subjectPlaceHolder || placeholder == repotToPlaceHolder || placeholder == reasonForOrderPlaceHolder
            {
                return  105
                
            }else if placeholder == "Search Button" {
                //Button"
                return  145
            }else if placeholder == "Search Emp List"{
                //TableView CEll
                
                return max(260,CGFloat(140 + (employeeArray.count * 55)))
                
            } else if placeholder.contains("Time") {
                if selectedSementTag == 0{
                    return 80
                }else if selectedSementTag == 1{
                    return 50
                }
            } else if placeholder.contains("Date") || placeholder == "Reference Note"  || placeholder == creditSelectionPlaceholder {
                return 90
                
            }else if placeholder.contains("Comments") {
                return 170
            }else if placeholder.contains(noOfPosPlaceHolder) {
                return 70
            }else if placeholder.contains("Next") {
                return 80
            }else if placeholder.contains("Segment"){
                
                if selectedSementTag == 0{
                    return 50
                }else if selectedSementTag == 1{
                    return 84
                }
            }else if placeholder.contains("Lesson"){
                
                if showLessonPlanTextView == true{
                    return 180
                    
                }else{
                    return 90
                    
                }
            }
            
        }
        return 50
    }
    override   public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if tableView.tag == mainTblViewTag{
            
        }else if tableView.tag == empTblViewTag{
            
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
            
        } else if tableView.tag == reportToTblViewTag{
            
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
            
        }else if tableView.tag == reasonforOrderTblViewTag{
            
            let obj = reasonForOrderArray[indexPath.row]
            
            let  o:ReasonForOrder = obj as! ReasonForOrder
            for obj in reasonForOrderArray{
                let reportObj:ReasonForOrder = obj as! ReasonForOrder
                reportObj.isSelected = "0"
            }
            selectedReasonForOrder = o
            selectedReasonForOrder.isSelected = "1"
            isValidReasonForOrder = true
            alrtController.dismiss(animated: true, completion: nil)
            
        }else if tableView.tag == subjectsTblViewTag{
            
            
            //            if DivisionId == "92"{
            //                //                cell.colBgView.isHidden = true
            //            }else{
            let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))

            if DivisionId == "92" {
            
            }else{
                let obj = positionSkillArray[indexPath.row]
                
                let  o:PositionSkill = obj as! PositionSkill
                
                if selectedSubjectsArray.contains(o){
                    o.isSelected = "0"
                    selectedSubjectsArray.remove(o)
                    
                }else{
                    o.isSelected = "1"
                    selectedSubjectsArray.add( o)
                    
                }
                if selectedSubjectsArray.count  == 0{
                    isValidSubjects = false
                }else{
                    isValidSubjects = true
                }
                positionSkillArray.replaceObject(at: indexPath.row, with: o)
            }
            
            
            //            }
        }else if tableView.tag == gradesTblViewTag{
            let oGrade = gradeArray[indexPath.row]
            
            let  gradeObj:Grade = oGrade as! Grade
            
            if selectedGradesArray.contains(gradeObj){
                gradeObj.isSelected = "0"
                selectedGradesArray.remove(gradeObj)
                
            }else{
                gradeObj.isSelected = "1"
                
                selectedGradesArray.add(gradeObj)
            }
            if selectedGradesArray.count  == 0{
                isValidGrades = false
            }else{
                isValidGrades = true
            }
            gradeArray.replaceObject(at: indexPath.row, with: gradeObj)
        }
        
        tableView.reloadData()
        self.tableView.reloadData()
        
    }
    //MARK:  Custom Cell
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
    
    func dropDownCell (tableView: UITableView,indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectExperienceTableViewCellIdentifier", for: indexPath) as! SubjectExperienceTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundColor = UIColor.clear
        
        
        let posSkill = positionSkillArray[indexPath.row]
        
        let  posSkillObj:PositionSkill = posSkill as! PositionSkill
        
        let SubjectName = posSkillObj.SkillName
        let SkillExperience = posSkillObj.SkillExperience
        let isSelected = posSkillObj.isSelected
        
        cell.subjectBtn.setTitle(SubjectName, for: .normal)
        
        if SkillExperience == 0{
            cell.expReqdBtn.isSelected = false
            
        }else{
            cell.expReqdBtn.isSelected = true
        }
        //if subject button is selecetd then only enable exp button
        if isSelected == "0"{
            cell.subjectBtn.isSelected = false
            cell.expReqdBtn.isEnabled = false
            
        }else{
            cell.subjectBtn.isSelected = true
            cell.expReqdBtn.isEnabled = true
        }
        
        dropdownTableView = tableView
        cell.subjectBtn.removeTarget(self, action:#selector(self.subjectCellBtnTapped), for: .touchUpInside)
        cell.expReqdBtn.removeTarget(self, action:#selector(self.expReqdCellBtnTapped), for: .touchUpInside)

        cell.subjectBtn.addTarget(self, action:#selector(self.subjectCellBtnTapped), for: .touchUpInside)
        cell.expReqdBtn.addTarget(self, action:#selector(self.expReqdCellBtnTapped), for: .touchUpInside)
//        cell.subjectBtn.backgroundColor = UIColor.red
//        cell.expReqdBtn.backgroundColor = UIColor.yellow

        return cell
        
    }
    func textEntryCell(placeholder: String,tableView: UITableView) -> TextFieldTableViewCell {
        
        let cell:TextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCellIdentifier") as! TextFieldTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.lblHeader.text = placeholder
        cell.entryTextField.delegate = self
        self.activeField = cell.entryTextField
        
        cell.entryTextField.tag = positionNumberTxtFieldTag
        if placeholder == noOfPosPlaceHolder{
            cell.entryTextField.text = String(TempNoofPositions)
        }
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(keyboardDoneBtnTapped))]
        toolBar.sizeToFit()
        cell.entryTextField.inputAccessoryView = toolBar
        
        let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        //Disable Position number testfield for UPK
        if DivisionId == "117"{
            cell.entryTextField.isUserInteractionEnabled = false
            cell.entryTextField.backgroundColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
            cell.entryTextField.layer.borderColor = UIColor.lightGray.cgColor
            
        }else{
            cell.entryTextField.isUserInteractionEnabled = true
            cell.entryTextField.backgroundColor = UIColor.white
            cell.entryTextField.layer.borderColor = borderColor.cgColor
            
        }
        cell.entryTextField.layer.borderWidth = 1
        return cell
        
    }
    func lessonPlanCell(placeholder: String,tableView: UITableView) -> TextFieldTableViewCell {
        
        let cell:TextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LessonPlanTableViewCellIdentifier") as! TextFieldTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.lblHeader.text = placeholder
        cell.btnBGView.layer.borderColor = borderColor.cgColor
        cell.btnBGView.layer.borderWidth = 1
        
        cell.lessonTextView.layer.borderColor = borderColor.cgColor
        cell.lessonTextView.layer.borderWidth = 1
        cell.lessonTextView.tag = Int(lessonPlanTxtViewTag)!
        cell.lessonTextView.text = lessonPlanText
        cell.lessonTextView.delegate = self
        self.activeTextView = cell.lessonTextView
        //TODO: cell.lessonTextView text is not saved
        cell.uploadBtn.layer.borderColor = borderColor.cgColor
        cell.uploadBtn.layer.borderWidth = 1
        cell.uploadBtn.layer.cornerRadius = 7
        
        cell.deleteBtn.removeTarget(self, action:#selector(self.deleteLessonPlanBtnTapped), for: .touchUpInside)
        cell.uploadBtn.removeTarget(self, action:#selector(self.uploadLessonPlanBtnTapped), for: .touchUpInside)
        cell.addButton.removeTarget(self, action:#selector(self.addLessonPlanBtnTapped), for: .touchUpInside)
        
        cell.deleteBtn.addTarget(self, action:#selector(self.deleteLessonPlanBtnTapped), for: .touchUpInside)
        cell.uploadBtn.addTarget(self, action:#selector(self.uploadLessonPlanBtnTapped), for: .touchUpInside)
        cell.addButton.addTarget(self, action:#selector(self.addLessonPlanBtnTapped), for: .touchUpInside)
        
        cell.lblFileName.text = uploadedFileName
        
        
        
        self.addInputAccessoryView(dTextView: cell.lessonTextView)
        
        return cell
        
    }
    func TeacherCreditSelectionCell(placeholder: String,tableView: UITableView) -> CreditSelectionTableViewCell {
        
        let cell:CreditSelectionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CreditSelectionTableViewCellIdentifier") as! CreditSelectionTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.lblHeader.text = placeholder
        if willEnableCreditSelection == true{
            cell.noBtn.isUserInteractionEnabled = true
            cell.yesBtn.isUserInteractionEnabled = true
            
        }else{
            cell.noBtn.isUserInteractionEnabled = false
            cell.yesBtn.isUserInteractionEnabled = false
            TempTeacherCreditSelection = TeacherCreditSelection
        }
        if TempTeacherCreditSelection == "No"{
            cell.noBtn.isSelected = true
            cell.yesBtn.isSelected = false
        }else if TempTeacherCreditSelection == "Yes"{
            cell.yesBtn.isSelected = true
            cell.noBtn.isSelected = false
        }
        cell.yesBtn.addTarget(self, action:#selector(self.yesBtnTapped), for: .touchUpInside)
        cell.noBtn.addTarget(self, action:#selector(self.noBtnTapped), for: .touchUpInside)
        
        return cell
        
    }
    //
    func referenceNoteTextViewCell(tableView: UITableView,indexPath: NSIndexPath,placeHolder: String,dataDict: NSDictionary) -> TextViewTableViewCell {
        
        let cell:TextViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ReferenceNoteCellIdentifier") as! TextViewTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        if placeHolder == "Reference Note" {
            cell.dropDownBtn.removeTarget(self, action:#selector(self.referenceNoteBtnTapped), for: .touchUpInside)
            
            cell.dropDownBtn.addTarget(self, action:#selector(self.referenceNoteBtnTapped), for: .touchUpInside)
        }
        
        
        self.addInputAccessoryView(dTextView: cell.entryTextView)
        
        
        cell.entryTextView.layer.borderColor = borderColor.cgColor
        cell.entryTextView.layer.borderWidth = 1
        cell.entryTextView.layer.cornerRadius = 2
        cell.entryTextView.tag = Int(referenceNoteTxtViewTag)!
        cell.entryTextView.text = referenceNote
        cell.entryTextView.delegate = self
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
            dict = orderDataArray[indexPath.row] as! NSDictionary
        }else{
            dict = multiDayDataArray[indexPath.row] as! NSDictionary
        }
        
        placeholderString = dict["header"] as! String
        if dict["subHeader"] != nil{
            let subPlaceholder = dict["subHeader"] as! String
            //                print(subPlaceholder)
            //            if subPlaceholder.contains("School Professionals only"){
            ////                cell.lblSubHeader.font = UIFont.boldSystemFont(ofSize: 14)
            //            }else{
            ////                cell.lblSubHeader.font = UIFont.systemFont(ofSize: 14)
            //            }
            //            if subPlaceholder.count > 0{
            ////                cell.lblSubHeader.text = subPlaceholder
            ////                cell.lblSubHeaderHeightConstraint.constant = 35
            //                cell.lblHeaderHeightConstraint.constant = 21
            //
            //            }else{
            ////                cell.lblSubHeader.text = ""
            ////                cell.lblSubHeaderHeightConstraint.constant = 0
            //                cell.lblHeaderHeightConstraint.constant = 55
            //
            //            }
        }else{
        }
        cell.layoutIfNeeded()
        let tag =  dataDict["Tag"] as! String
        
        cell.entryTextView.tag = Int(tag)!
        cell.entryTextView.layer.borderColor = borderColor.cgColor
        cell.entryTextView.layer.borderWidth = 1
        cell.entryTextView.delegate = self
        cell.lblHeader.text = placeholderString
        self.activeTextView = cell.entryTextView
        
        if cell.entryTextView.tag == Int(empCommentTxtViewTag){
            
            if empCommentText.count == 0 || cell.entryTextView.text == empTextViewPlaceHolder{
                cell.entryTextView.text = empTextViewPlaceHolder
                cell.entryTextView.textColor = UIColor.lightGray
            }else{
                cell.entryTextView.text = empCommentText
                cell.entryTextView.textColor = UIColor.black
            }
        }else  if cell.entryTextView.tag == Int(divisionCommentTxtViewTag){
            if divisionCommentText.count == 0 || cell.entryTextView.text == divisionTextViewPlaceHolder{
                cell.entryTextView.text = divisionTextViewPlaceHolder
                cell.entryTextView.textColor = UIColor.lightGray
                
            }else{
                cell.entryTextView.text = divisionCommentText
                cell.entryTextView.textColor = UIColor.black
                
                
            }
        }
        
        
        
        self.addInputAccessoryView(dTextView: cell.entryTextView)
        
        return cell
        
    }
    func collectionViewCell(indexPath: NSIndexPath) -> CollectionTableViewCell {
        
        let cell:CollectionTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCellIdentifier") as! CollectionTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        var dict = NSDictionary()
        if selectedSementTag == 0{
            dict = orderDataArray[indexPath.row] as! NSDictionary
        }else{
            dict = multiDayDataArray[indexPath.row] as! NSDictionary
        }
        
        let placeholder = dict["header"] as! String
        cell.dataColView.isHidden = false
        cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.darkGray)
        
        if allDataValidated == true{
            
            cell.colBgView.layer.borderColor = borderColor.cgColor
        }
        
        cell.colBgView.layer.borderWidth = 1
        cell.addreportToButton.removeTarget(self, action: #selector(self.addReportToBtnTapped), for: .touchUpInside)
        
        cell.dropDownButton.isHidden = true
        cell.addreportToButton.isHidden = true
        
        if let layout = cell.dataColView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        cell.colViewTrailingConstraint.constant = 39
        
        
        if placeholder == gradePlaceHolder{
            cell.dropDownButton.isHidden = false
             cell.dataColView.tag = gradesColTag
            
            var lbltext = placeholder
            
            if selectedGradesArray.count > 0{
                lbltext = String(format:"%@ : %d Selected",placeholder,selectedGradesArray.count)
            }
            if isValidGrades == false{
                cell.colBgView.layer.borderColor = UIColor.red.cgColor
                cell.lblHeader.halfTextColorChange(fullText: lbltext, changeText: "*", textColor: UIColor.red)
             }else{
                cell.colBgView.layer.borderColor = borderColor.cgColor
                cell.lblHeader.halfTextColorChange(fullText: lbltext, changeText: "*", textColor: UIColor.darkGray)
            }
        }else if placeholder == subjectPlaceHolder{
            cell.dropDownButton.isHidden = false
            cell.dataColView.tag = subjectsColTag
            var lbltext = placeholder
            
            if selectedSubjectsArray.count > 0{
                lbltext = String(format:"%@ : %d Selected",placeholder,selectedSubjectsArray.count)
            }
            if isValidSubjects == false{
                cell.colBgView.layer.borderColor = UIColor.red.cgColor
                cell.lblHeader.halfTextColorChange(fullText: lbltext, changeText: "*", textColor: UIColor.red)
                
            }else{
                cell.colBgView.layer.borderColor = borderColor.cgColor
                cell.lblHeader.halfTextColorChange(fullText: lbltext, changeText: "*", textColor: UIColor.darkGray)
                
            }
        }else if placeholder == posTypePlaceHolder{
            cell.dataColView.tag = positionTypeColTag
            cell.colBgView.layer.borderColor = borderColor.cgColor

            cell.colBgView.layer.borderWidth = 1
//            if let layout = cell.dataColView.collectionViewLayout as? UICollectionViewFlowLayout {
//                layout.scrollDirection = .vertical
//            }
 
            cell.colViewTrailingConstraint.constant = 0
         }else if placeholder == repotToPlaceHolder{
            cell.dropDownButton.isHidden = false
            cell.dataColView.tag = reportToColTag
            cell.addreportToButton.isHidden = false
            cell.addreportToButton.addTarget(self, action:#selector(self.addReportToBtnTapped), for: .touchUpInside)
            if isValidReportTo == false{
                cell.colBgView.layer.borderColor = UIColor.red.cgColor
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.red)
             }else{
                cell.colBgView.layer.borderColor = borderColor.cgColor
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.darkGray)
             }
        }else if placeholder == reasonForOrderPlaceHolder{
            cell.dropDownButton.isHidden = false
            cell.dataColView.tag = reasonforOrderColTag
            if isValidReasonForOrder == false{
                cell.colBgView.layer.borderColor = UIColor.red.cgColor
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.red)
             }else{
                cell.colBgView.layer.borderColor = borderColor.cgColor
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.darkGray)
             }
         }
         cell.dataColView.delegate = self
        cell.dataColView.dataSource = self
        cell.dataColView.reloadData()
        cell.dropDownButton.addTarget(self, action:#selector(self.dropDownBtnTapped), for: .touchUpInside)
        //        cell.lblHeader.text = placeholder
        
        cell.layoutIfNeeded()
        
        return cell
        
    }
    func SFSchoolProfesstionalSubjectCell(indexPath: NSIndexPath) -> CollectionTableViewCell {
        
        let cell:CollectionTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "DropDownTableViewCellIdentifier") as! CollectionTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        var dict = NSDictionary()
        if selectedSementTag == 0{
            dict = orderDataArray[indexPath.row] as! NSDictionary
        }else{
            dict = multiDayDataArray[indexPath.row] as! NSDictionary
        }
        
        let placeholder = dict["header"] as! String
        
        cell.colBgView.layer.borderColor = borderColor.cgColor
        cell.colBgView.layer.borderWidth = 1
        
        cell.lblHeader.text = placeholder
        //        cell.dropDownTblView.delegate = self
        //cell.dropDownTblView.dataSource = self
        
        cell.dropDownTblView.tag = dropDownTblViewTag
        
        cell.dropDownTblView.reloadData()
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
            placeholder = startTimePlaceHolder
            subplaceholder = endTimePlaceHolder
            
        }else{
            var dict = NSDictionary()
            
            if selectedSementTag == 0{
                dict = orderDataArray[indexPath.row] as! NSDictionary
                
            }else{
                dict = multiDayDataArray[indexPath.row] as! NSDictionary
                
            }
            //            let dict = dataArray[indexPath.row] as! NSDictionary
            placeholder = dict["header"] as! String
            subplaceholder = dict["subHeader"] as! String
        }
        if placeholder.contains("Date") || placeholder.contains("Date") {
            cell.StartDateImageView.image = UIImage.init(named: "calendar_icon.png")
            cell.EndDateImageView.image = UIImage.init(named: "calendar_icon.png")
        }else if placeholder.contains("Date") || placeholder.contains("Time") {
            
            cell.StartDateImageView.image = UIImage.init(named: "Timeslips")
            cell.EndDateImageView.image = UIImage.init(named: "Timeslips")
        }
        if placeholder.contains("Date") {
            var dict = NSDictionary()
            
            if selectedSementTag == 0{
                dict = orderDataArray[indexPath.row] as! NSDictionary
                
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
        }else{
            
            customPickerView.dtPickerView.minuteInterval = minuteInterval
            
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
                if placeholder.contains("Date"){
                    
                    StartDate = startValue
                    EndDate = endValue
                }
            }else{
                let dict = orderDataArray[indexPath.row] as! NSDictionary
                startTag = Int(dict["StartTag"] as! String)!
                endTag = Int(dict["EndTag"] as! String)!
                startValue = dict["StartValue"] as! String
                endValue = dict["EndValue"] as! String
                if placeholder.contains("Date"){
                    
                    StartDate = startValue
                    EndDate = endValue
                }
                if placeholder.contains("Time"){
                    
                    StartTime = startValue
                    EndTime = endValue
                }
                
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
        
        //        if placeholder == StartDate || placeholder == EndDate {
        //
        //            let dropDownImage = UIImage.init(named: "calendar_icon")
        //            let rightImageView = UIImageView()
        //            rightImageView.image = dropDownImage
        //            rightImageView.frame = CGRect(x:0, y:0, width:15, height:15)
        //            cell.textFStart.rightView = rightImageView
        //            cell.textFStart.rightViewMode = UITextFieldViewMode.always
        //            cell.textFEnd.rightView = rightImageView
        //            cell.textFEnd.rightViewMode = UITextFieldViewMode.always
        //
        //
        //        }else{
        //
        //            let dropDownImage = UIImage.init(named: "Time Slips")
        //            let rightImageView = UIImageView()
        //            rightImageView.image = dropDownImage
        //            rightImageView.frame = CGRect(x:0, y:0, width:15, height:15)
        //            cell.textFStart.rightView = rightImageView
        //            cell.textFStart.rightViewMode = UITextFieldViewMode.always
        //            cell.textFEnd.rightView = rightImageView
        //            cell.textFEnd.rightViewMode = UITextFieldViewMode.always
        //
        //
        //        }
        
        
        
        
        
        
        
        return cell
        
    }
    
    func TableViewCell(tableView: UITableView) -> TableViewTableViewCell {
        
        let cell:TableViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewTableViewCellIdentifier") as! TableViewTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        cell.dataCellTblView.tag = empTblViewTag
        cell.TblBGView.layer.borderWidth = 1
        cell.TblBGView.layer.borderColor = borderColor.cgColor

//        if employeeArray.count == 0{
//        }else{
//            cell.TblBGView.layer.borderColor = UIColor.darkGray.cgColor
//        }
        cell.dataCellTblView.delegate = self
        cell.dataCellTblView.dataSource = self
        self.empTableView = cell.dataCellTblView
        cell.dataCellTblView.reloadData()
        
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
    func segmentTableViewCell(tableView: UITableView) -> SegmentTableViewCell {
        
        let cell:SegmentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SegmentTableViewCellIdentifier") as! SegmentTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        cell.optionSegmentControl.addTarget(self, action:#selector(self.segmentValueChanged), for: .valueChanged)
        cell.optionSegmentControl.tintColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
        let font = UIFont.systemFont(ofSize: 12)
        cell.optionSegmentControl.setTitleTextAttributes([NSAttributedString.Key.font: font],
                                                         for: .normal)
        cell.optionSegmentControlHeightConstraint.constant = 40
        
        cell.optionSegmentControl.layer.cornerRadius = 0
        cell.optionSegmentControl.layer.borderColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String).cgColor
        cell.optionSegmentControl.layer.borderWidth = 1
        cell.optionSegmentControl.layer.masksToBounds = true
        cell.optionSegmentControl.layoutIfNeeded()
        cell.DayPlaceHolderLbl.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.StartTimePlaceHolderLbl.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.EndTimePlaceHolderLbl.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
        if selectedSementTag == 0{
            cell.borderView.isHidden = true
        }else if selectedSementTag == 1{
            cell.borderView.isHidden = false
        }
        return cell
        
    }
    
    func ButtonTableCell(indexPath: NSIndexPath,identifier: String) -> ButtonTableViewCell {
        
        let cell:ButtonTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: identifier) as! ButtonTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        if identifier == SearchButtonCellIdentifier{
            
            var dict = NSDictionary()
            if selectedSementTag == 0{
                dict = orderDataArray[indexPath.row] as! NSDictionary
            }else{
                dict = multiDayDataArray[indexPath.row] as! NSDictionary
            }
            cell.dButton.removeTarget(self, action:#selector(self.searchBtnTapped), for: .touchUpInside)
            
            let placeholder = dict["header"] as! String
            if placeholder == "Search Button"{
                cell.dButton.setTitle("Search Employees", for: .normal)
                cell.dButton.addTarget(self, action:#selector(self.searchBtnTapped), for: .touchUpInside)
                
            }else  if placeholder == "Next Button"{
                cell.dButton.setTitle("Next", for: .normal)
            }
        }else if identifier == NextButtonCellIdentifier{
            cell.dButton.addTarget(self, action:#selector(self.nextButtonTapped), for: .touchUpInside)
            
        }
        
        
        
        return cell
        
    }
    
    //MARK: -UICOLLECTIONVIEW DELEGATE & DATASOURCE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == positionTypeColTag {
            return positionTypeArray.count
        }else if collectionView.tag == gradesColTag {
            return selectedGradesArray.count
        }else if collectionView.tag == subjectsColTag {
            let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
            //            if DivisionId == "92"{
            //                return 0
            //            }else{
            return selectedSubjectsArray.count
            
            //            }
        }else if collectionView.tag == reportToColTag {
            if selectedReportTo.Name?.count == 0{
                
            }else{
                return 1
            }
        }else if collectionView.tag == reasonforOrderColTag {
            if selectedReasonForOrder.ReasonDescription?.count == 0{
                
            }else{
                return 1
            }
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: colCellIdentifier, for: indexPath) as! MenuCollectionViewCell
        
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.backgroundColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        cell.menuImageView.isHidden = false
        cell.lblLeadingConstraint.constant = 24
        cell.menuNameBtn.isHidden = true

        if collectionView.tag == positionTypeColTag {
            
            let postionType = positionTypeArray[indexPath.row]
            cell.menuNameBtn.isHidden = false
            let  posType:PositionType = postionType as! PositionType
            cell.menuLabel.text = posType.PositionName
            cell.backgroundColor = UIColor.white
            let isSelected = posType.isSelected
            cell.menuImageView.isHidden = true
            cell.menuLabel.text = ""
            cell.menuNameBtn.setTitle(posType.PositionName, for: .normal)
            if isSelected == "0"{
                 cell.menuNameBtn.setImage(UIImage.init(named: "radio-button-off"), for: .normal)
            }else{
                 cell.menuNameBtn.setImage(UIImage.init(named: "radio-button-on"), for: .normal)
            }
            cell.menuNameBtn.isUserInteractionEnabled = false
        }else if collectionView.tag == gradesColTag {
            
            let oGrade = selectedGradesArray[indexPath.row]
            
            let  gradeObj:Grade = oGrade as! Grade
            cell.menuLabel.text = gradeObj.GradeName
            cell.menuImageView.image = UIImage.init(named: "delete")
            cell.layer.borderColor = borderColor.cgColor
        }else if collectionView.tag == subjectsColTag {
            
            let oSkill = selectedSubjectsArray[indexPath.row]
            
            let  posSkill:PositionSkill = oSkill as! PositionSkill
            cell.menuLabel.text = posSkill.SkillName
            cell.menuImageView.image = UIImage.init(named: "delete")
            cell.layer.borderColor = borderColor.cgColor
        }else if collectionView.tag == reportToColTag {
            
            cell.menuLabel.text = selectedReportTo.Name
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.backgroundColor = UIColor.clear
            cell.menuImageView.isHidden = true
            cell.lblLeadingConstraint.constant = 5
        }else if collectionView.tag == reasonforOrderColTag {
            cell.menuImageView.isHidden = true
            cell.menuLabel.text = selectedReasonForOrder.ReasonDescription
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.backgroundColor = UIColor.clear
            cell.lblLeadingConstraint.constant = 5
            
        }
        cell.layoutIfNeeded()
        
        cell.layer.cornerRadius = 2
        cell.clipsToBounds = true
        cell.layer.borderWidth = 1
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if collectionView.tag == positionTypeColTag {
            let sizeWidth = UIScreen.main.bounds.size.width
            
            let postionType = positionTypeArray[indexPath.row]
            
            let  posType:PositionType = postionType as! PositionType
            let positionName = posType.PositionName
//            let width = (positionName?.width(withConstraintedHeight: 40, font: UIFont.boldSystemFont(ofSize: 13)))! + 30
            
            return CGSize(width: sizeWidth, height: 40)
            //            return CGSize(width:max(60, (positionName!.count) * 11) , height: 40)
            
        }else if collectionView.tag == gradesColTag {
            let oGrade = selectedGradesArray[indexPath.row]
            
            let  gradeObj:Grade = oGrade as! Grade
            
            let gradeName = gradeObj.GradeName
            let width = (gradeName?.width(withConstraintedHeight: 40, font: UIFont.boldSystemFont(ofSize: 13)))! + 30
            
            return CGSize(width:max(60, CGFloat(width)) , height: 40)
            
        }else if collectionView.tag == subjectsColTag {
            let oSkill = selectedSubjectsArray[indexPath.row]
            
            let  posSkill:PositionSkill = oSkill as! PositionSkill
            let subjectName = posSkill.SkillName
            
            let width = (subjectName?.width(withConstraintedHeight: 40, font: UIFont.boldSystemFont(ofSize: 13)))! + 30
            
            return CGSize(width:max(60, CGFloat(width)) , height: 40)
            
        }
        
        return CGSize(width:collectionView.frame.size.width , height: 48)
        
    }
    //Use for interspacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        //        collectionView.reloadData()
        
        if collectionView.tag == gradesColTag {
            
            let grade = selectedGradesArray[indexPath.row] as! Grade
            
            for g in gradeArray{
                let  gradeObj:Grade = g as! Grade
                
                if gradeObj.GradeCode == grade.GradeCode{
                    gradeObj.isSelected = "0"
                }
            }
            
            selectedGradesArray.removeObject(at: indexPath.row)
            
        }else if collectionView.tag == subjectsColTag {
            
            let grade = selectedSubjectsArray[indexPath.row] as! PositionSkill
            
            for g in positionSkillArray{
                let  gradeObj:PositionSkill = g as! PositionSkill
                
                if gradeObj.SkillCode == grade.SkillCode{
                    gradeObj.isSelected = "0"
                }
            }
            
            selectedSubjectsArray.removeObject(at: indexPath.row)
            
        }else if collectionView.tag == positionTypeColTag {
            
            //MAKE THIS TO RADIO BUTTON,create a new array store all the default data and then assig the appropriate value
            let tempPosArray = NSMutableArray()
            for pos in positionTypeArray{
                
                let   posn: PositionType = pos as! PositionType
                posn.isSelected = "0"
                tempPosArray.add(posn)
            }
            positionTypeArray.removeAllObjects()
            positionTypeArray = tempPosArray
            
            //assign the one selected value.all old values are set to 0
            
            let postionType = positionTypeArray[indexPath.row]
            let  posType:PositionType = postionType as! PositionType
            let isSelected = posType.isSelected
            if isSelected == "0"{
                posType.isSelected = "1"
                selectedPositionType = posType
            }else if isSelected == "1"{
                posType.isSelected = "0"
            }
            if posType.PositionName == "Credentialed"{
                willEnableCreditSelection = true
            }else{
                willEnableCreditSelection = false
            }
            positionTypeArray.replaceObject(at: (indexPath.row), with: posType)
            DispatchQueue.main.async(execute: { () -> Void in
                 collectionView.reloadData()
            })
        }
        //TODO: Reload dropdown tableview
        DispatchQueue.main.async(execute: { () -> Void in
        self.tableView.reloadData()
        collectionView.reloadData()
        })
        
    }
    
    //MARK: BUtton Action
    @objc func segmentValueChanged(sender: UISegmentedControl){
        
        print("segment, value added")
        
        if sender.selectedSegmentIndex == 0{
            selectedSementTag = 0
        }else{
            selectedSementTag = 1
            
        }
        self.tableView.reloadData()
        
    }
    
    
    //MARK: TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag ==  positionNumberTxtFieldTag
        {
            
            let charsLimit = 2
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace =  range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace
            return newLength <= charsLimit
        }
        else
        {
            return true
        }
    }
    public func textFieldDidBeginEditing(_ textField: UITextField){
        self.activeField = textField
        
        if textField.tag == positionNumberTxtFieldTag{
            let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
            //Disable Position number testfield for UPK
            if DivisionId == "117"{
                textField.resignFirstResponder()
            }
        }else if textField.tag == reportToTxtFieldTag{
            textField.resignFirstResponder()
            
        }else if textField.tag == reasonforOrderTxtFieldTag{
            textField.resignFirstResponder()
            
        }else{
            textField.resignFirstResponder()
            
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
            
            //Show the  previuosly  selected Time else show current date
            
            let senderPosition  = textField.convert(CGPoint.zero, to: self.tableView)
            
            let indexPath =  self.tableView.indexPathForRow(at:senderPosition)
            
            var dict = NSDictionary()
            if selectedSementTag == 0{
                dict = orderDataArray[(indexPath?.row)!] as! NSDictionary
            }else{
                dict = multiDayDataArray[(indexPath?.row)!] as! NSDictionary
            }
            //            let dict = orderDataArray[(indexPath?.row)!] as! NSDictionary
            let placeholder = dict["header"] as! String
            
            if placeholder.contains("Time"){
                
                
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
                
                customPickerView.dtPickerView.datePickerMode = UIDatePicker.Mode.time
                customPickerView.showPickerViewOnSuperView(superView: (self.navigationController?.view)!, isDatePicker: true,minuteInterval: minuteInterval,isPortrait: self.isPortrait())
                
//                self.setDatePickerValue(changedDate: customPickerView.dtPickerView.date)

                
            }else if placeholder.contains("Date"){
                customCalendarView.showPickerViewOnSuperView(superView: (self.navigationController?.view)!, isPortrait: self.isPortrait())
            }
            firstResponderTxtFieldTag = textField.tag
        }
    }
    public func textFieldDidEndEditing(_ textField: UITextField){
        
        self.activeField = nil
        keyboardShowing =  true
        if textField.tag == positionNumberTxtFieldTag {
            
            if textField.text?.count == 0{
                textField.text = String(format:"%d",NoofPositions)
            }
            if textField.text?.isNumeric == true{
                TempNoofPositions = Int(textField.text!)!
            }else{
                textField.text = String(format:"%d",NoofPositions)
            }
            
        }
    }
    //MARK: UITEXTVIEW Delegate
    
    public func textViewDidBeginEditing(_ textView: UITextView)
    {
        self.activeTextView = textView
        
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
        keyboardShowing =  true
        if textView.tag == Int(empCommentTxtViewTag){
            if textView.text.count == 0 || textView.text == empTextViewPlaceHolder  {
                textView.text = empTextViewPlaceHolder
                textView.textColor = UIColor.lightGray
            }else{
                textView.textColor = UIColor.black
                
            }
        }else if textView.tag == Int(divisionCommentTxtViewTag){
            if textView.text.count == 0 || textView.text == divisionCommentText  {
                textView.text = divisionTextViewPlaceHolder
                textView.textColor = UIColor.lightGray
            }else{
                textView.textColor = UIColor.black
                
            }
        }else if textView.tag == Int(lessonPlanTxtViewTag){
            lessonPlanText = textView.text
        }
        if textView.tag == Int(referenceNoteTxtViewTag){
            
            referenceNote = textView.text
        }else if textView.tag == Int(empCommentTxtViewTag){
            if textView.textColor == UIColor.black {
                empCommentText = textView.text
            }
        }else if textView.tag == Int(divisionCommentTxtViewTag){
            if textView.textColor == UIColor.black {
                divisionCommentText = textView.text
            }
        }
        self.tableView.reloadData()
    }
    
    func showDropDownWithTag( placeHolder: String,tag: Int){
        let modelName = UIDevice.current.modelName
        
        let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
        if modelName.contains("iPad") //||  modelName.contains("Simulator")
        {
            DispatchQueue.main.async(execute: { () -> Void in
                let vc = UIViewController()
                vc.view.isUserInteractionEnabled = true
                vc.preferredContentSize = CGSize(width: 250,height: 240)
                
                let margin = 8
                
                let rect = CGRect(x: margin, y: 0, width: 240, height: 230)
                let  alertTableView = UITableView(frame: rect)
                
                alertTableView.tableFooterView = UIView()
                alertTableView.frame = rect
                alertTableView.delegate = self
                alertTableView.dataSource = self
                alertTableView.tag = tag
                alertTableView.backgroundColor = UIColor.clear
                alertTableView.reloadData()
                if DivisionId == "92" && tag == self.subjectsTblViewTag{
                    
                    alertTableView.register(UINib(nibName: "SubjectExperienceTableViewCell", bundle: nil), forCellReuseIdentifier: "SubjectExperienceTableViewCellIdentifier")
                }
                
                vc.view.addSubview(alertTableView)
                
                self.alrtController = UIAlertController(title:placeHolder, message: nil, preferredStyle:
                    UIAlertController.Style.alert)
                self.alrtController.setValue(vc, forKey: "contentViewController")
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: {
                    (alert: UIAlertAction!) in
                    print("OK")
                    self.tableView.reloadData()
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
                
                alrtController.addAction(defaultAction)
                alrtController.addAction(deleteAction)
                alrtController.addAction(deleteAction1)
                alrtController.addAction(deleteAction2)
                alrtController.addAction(deleteAction3)
                
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
            alertTableView.reloadData()
            
            
            if DivisionId == "92" && tag == subjectsTblViewTag{
                
                alertTableView.register(UINib(nibName: "SubjectExperienceTableViewCell", bundle: nil), forCellReuseIdentifier: "SubjectExperienceTableViewCellIdentifier")
            }
            
            
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: {
                (alert: UIAlertAction!) in
                print("OK")
                self.tableView.reloadData()
            })
            
            alrtController.addAction(okAction)
            if modelName.contains("iPad") {
                alrtController.modalPresentationStyle = .popover
                
                if let popoverController = alrtController.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
                    popoverController.permittedArrowDirections = []
                    self.present(alrtController, animated: true, completion: nil)
                    
                }
            }else{
                let height:NSLayoutConstraint = NSLayoutConstraint(item: alrtController.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(alertHeight))
                alrtController.view.addConstraint(height);
                self.present(alrtController, animated: true, completion:{})
            }
        }
        
    }
    //Navigation methods
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
            nextViewController.isForOffice = false
            nextViewController.isForHospitality = false
            nextViewController.isForSchoolProfessional = true
          
 
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
    func pushToAddReportToPage(){
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
            nextViewController.isForAddReportToSchoolProfessional = true
            nextViewController.ReportToAddress = ReportToAddress
            nextViewController.ReportToCity = ReportToCity
            nextViewController.ReportToPhone = ReportToPhone
            nextViewController.ReportToZip = ReportToZip
            nextViewController.ReportToFax = ReportToFax
            nextViewController.ReportToState = ReportToState
            nextViewController.delegate = self
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
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
            
            nextViewController.summaryObj = createOrderObj
            nextViewController.summaryDataArray = self.formOrderSummaryData()
            nextViewController.status = "New"
            nextViewController.delegate = self
            nextViewController.SCHOOL_CREATE_ORDER_FLAG = true
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    // MARK: - SERVER CALL
    func createOrderAPIFormParamAndPushToSummaryPage() {
        //    func createOrderParam(){
        
        var FileName = ""
        var FileExtension = ""
        var FileDescription = ""
        
        if documentsArray.count>0
        {
            for doc in 0..<documentsArray.count
            {
                //                let docs = [ "DocFile" : documetBytes[doc],
                //                             "FileName" : self.documentsArray[doc],
                //                             "DocExtension" : self.fileExtensions[doc],
                //                             "DocDescription" : self.documentsArray[doc]]
                //                listOfDocuments.append(docs)
                
                let FileName_ = self.documentsArray[doc] as! String
                if FileName_.count == 0{
                }else{
                    let   stringArray = FileName_.components(separatedBy: ".")
                    if stringArray.count > 0{
                        FileName = stringArray[0]
                        FileExtension = stringArray[1]
                    }
                }
                //                FileExtension = self.fileExtensions[doc] as! String
                FileDescription = documetBytes[doc] as! String
                break
            }
        }
        
        
        
        
        var dictDatas = NSMutableArray()
        if selectedSementTag == 0{
            dictDatas = orderDataArray
        }else{
            dictDatas = multiDayDataArray
        }
        print(dictDatas)
        if selectedSementTag == 1{
            for dict in dictDatas {
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
        }
        
        
        let defaults = UserDefaults.standard
        NoofPositions = TempNoofPositions
        
        let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
        let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
        let DivisionId = String(format:"%d", defaults.integer(forKey: "DivisionId"))
        ScheduleType = String(format:"%d",selectedSementTag+1)
        let  NoofPositionsStr = String(format:"%d",NoofPositions)
        let reportToContactID = String(format:"%d", selectedReportTo.ContactId!)
        let reasonForOrderID = String(format:"%d", selectedReasonForOrder.ReasonId!)
        let selecetdPosTypeID = String(format:"%d",selectedPositionType.PositionId!)
        let  ReportToName = selectedReportTo.Name!
        let ReassonfororderName  = selectedReasonForOrder.ReasonDescription
        var PositionSkillList =  [[String:String]]()
        var GradeList = [[String:String]]()
        var SearchEmployeeList = [[String:String]]()
        let errorMessage = ""
        var  params = NSDictionary()
        
        if errorMessage.count == 0 {
            
            
            for grade in selectedGradesArray{
                let gradeObj:Grade = grade as!  Grade
                let dict = ["GradeCode":String(format:"%d",gradeObj.GradeCode!),"GradeName":gradeObj.GradeName] as! [String : String]
                GradeList.append(dict)
            }
            for skillList in selectedSubjectsArray{
                
                let subject:PositionSkill = skillList as!  PositionSkill
                if DivisionId == "92"{
                    let dict = ["SkillCode":String(format:"%d",subject.SkillCode!),"SkillName":subject.SkillName,"SkillExperience":String(format:"%d",subject.SkillExperience!)] as! [String : String]
                    PositionSkillList.append(dict)
                    
                }else{
                    
                    let dict = ["SkillCode":String(format:"%d",subject.SkillCode!),"SkillName":subject.SkillName] as! [String : String]
                    PositionSkillList.append(dict)
                }
            }
            for emp in employeeArray{
                let empObj:NewEmployee = emp as!  NewEmployee
                let dict = ["CandidateId":String(format:"%d",empObj.CandidateId!),"Name":empObj.Name] as! [String : String]
                SearchEmployeeList.append(dict)
            }
            
            //Check for Validations
            //            JustHUD.shared.showInView(view: view)
            
            if selectedSementTag == 0{
                
                params  = ["ClientId" : clientID,
                           "ContactId":  ContactId,
                           "DivisionId":DivisionId,
                           "StartDate":StartDate,
                           "EndDate":EndDate,
                           "ReferenceNote":referenceNote,
                           "NoofPositions":NoofPositionsStr,
                           "ScheduleType":ScheduleType,
                           "StartTime":StartTime,
                           "EndTime":EndTime,
                           "GradeList":GradeList ,
                           "PositionSkillList":PositionSkillList,
                           "SearchEmployeeList":SearchEmployeeList ,
                           "FileName" : FileName,
                           "FileExtension":FileExtension,
                           "FileDescription" :FileDescription,
                           //                            "File":self.listOfDocuments,
                    "OrderSourceName":"iOS",
                    "ReportToName":ReportToName,
                    "ReportTo":reportToContactID,
                    "PositionType": selecetdPosTypeID,
                    "PositionName":selectedPositionType.PositionName!,
                    "CommentsforEmployee":empCommentText,
                    "CommentsforSchoolProfessionals":divisionCommentText,
                    "ReassonfororderName":ReassonfororderName!,
                    "ReasonforOrder":reasonForOrderID,
                    "TeacherCreditSelection":TempTeacherCreditSelection,
                    "LessonText": lessonPlanText
                    ] as [String : Any] as NSDictionary
                print(params)
                if DivisionId == "117"{
                    //remove positionskilllist
                    let myMutableDict: NSMutableDictionary = NSMutableDictionary(dictionary: params)
                    for key in myMutableDict.allKeys{
                        if key as! String == "NewPositionSkillList"{
                            myMutableDict.removeObject(forKey: key)
                            break
                        }
                    }
                    createOrderObj = params
                    self.validateCreateOrderData()
                    
                }else{
                    createOrderObj = params
                    self.validateCreateOrderData()
                }
                
                
            }else if selectedSementTag == 1{
                params  = ["ClientId" : clientID,
                           "ContactId":  ContactId,
                           "DivisionId":DivisionId,
                           "StartDate":StartDate,
                           "EndDate":EndDate,
                           "ReferenceNote":referenceNote,
                           "NoofPositions":NoofPositionsStr,
                           "ScheduleType":ScheduleType,
                           "WednesdayStartTime":WednesdayStartTime,
                           "WednesdayEndTime" : WednesdayEndTime,
                           "MondayStartTime" : MondayStartTime,
                           "MondayEndTime" : MondayEndTime,
                           "TuesdayStartTime" : TuesdayStartTime,
                           "TuesdayEndTime" : TuesdayEndTime,
                           "ThursdayStartTime" : ThursdayStartTime,
                           "ThursdayEndTime" : ThursdayEndTime,
                           "FridayStartTime" : FridayStartTime,
                           "FridayEndTime" : FridayEndTime,
                           "SaturdayStartTime" : SaturdayStartTime,
                           "SaturdayEndTime" : SaturdayEndTime,
                           "SundayStartTime" : SundayStartTime,
                           "SundayEndTime" : SundayEndTime,
                           "GradeList":GradeList ,
                           "PositionSkillList":PositionSkillList,
                           "SearchEmployeeList":SearchEmployeeList,
                           "FileName" : FileName,
                           "FileExtension":FileExtension,
                           "FileDescription" :FileDescription,
                           //                          "File":self.listOfDocuments,
                    "OrderSourceName":"iOS",
                    "ReportToName":ReportToName,
                    "ReportTo":reportToContactID,
                    "PositionType": selecetdPosTypeID,
                    "PositionName":selectedPositionType.PositionName!,
                    "CommentsforEmployee":empCommentText,
                    "CommentsforSchoolProfessionals":divisionCommentText,
                    "ReassonfororderName":ReassonfororderName!,
                    "ReasonforOrder":reasonForOrderID,
                    "TeacherCreditSelection":TempTeacherCreditSelection,
                    "LessonText": lessonPlanText
                    ] as [String : Any] as NSDictionary
                print(params)
                
                createOrderObj = params
                self.validateCreateOrderData()
            }
        }else{
            //            self.ShowAlertMessage(message: errorMessage, title: "")
            isWarningMessage = false
            isErrorMessage = false
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: errorMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    
    func validateCreateOrderData(){
        
        print(createOrderObj)
        
        let urlString = RestAPI.BaseUrl+RestAPI.ROSSchoolProfessionalValidationURL
        //        JustHUD.shared.showInView(view: view)
        self.showLoading()
        
        RestAPI.postRequestWithToken(urlString: urlString, params: createOrderObj, callback: getResponseForCreateOrder(response:))
        
    }
    func getResponseForCreateOrder(response:AnyObject)->()
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
                
                let continueMessage = object["Message"].stringValue
                let WarningMessage =  object["WarningMessage"].stringValue
                
                if WarningMessage.count == 0{
                    self.pushToOrderSummaryPage()
                }else{
                    
                    isWarningMessage = true
                    isErrorMessage = false
                    
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: continueMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Warning_Text, isAttributed: false)
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
    func formOrderSummaryData() -> NSMutableArray{
        
        var summaryDataArray = NSMutableArray()
        let gradeNameArray = NSMutableArray()
        let subjectNameArray = NSMutableArray()
        let employeeNameArray = NSMutableArray()
        
        for obj in selectedGradesArray{
            
            let gObj:Grade = (obj as? Grade)!
            let name = gObj.GradeName!
            gradeNameArray.add(name)
        }
        for obj in selectedSubjectsArray{
            let gObj:PositionSkill = (obj as? PositionSkill)!
            let name = gObj.SkillName!
            subjectNameArray.add(name)
        }
        for obj in employeeArray{
            let eObj:NewEmployee = (obj as? NewEmployee)!
            let name = eObj.Name!
            employeeNameArray.add(name)
        }
        let posTypeDict = ["Header":"Position Type","Value":selectedPositionType.PositionName]
        let gradeDict = ["Header":"Grades","Value":gradeNameArray.map({ String(describing: $0) }).joined(separator: ", ")]
        let subjectDict = ["Header":"Subjects","Value":subjectNameArray.map({ String(describing: $0) }).joined(separator: ", ")]
        let lessonPlanDict = ["Header":"Lesson Plan","Value":String(format:"%@\n%@",uploadedFileName,lessonPlanText)]
        let reportToNameDict = ["Header":"Report To","Value":selectedReportTo.Name]
        let reasonForOrderDict = ["Header":"Reason for Order","Value":selectedReasonForOrder.ReasonDescription]
        let startDateDict =  ["Header":"Start Date","Value":StartDate]
        let endDateDict =  ["Header":"End Date","Value":EndDate]
        let noOfPosDict =  ["Header":"No. of Positions","Value":String(format:"%d",NoofPositions)]
        let startTimeDict =  ["Header":"Start Time","Value":StartTime]
        let endTimeDict =  ["Header":"End Time","Value":EndTime]
        let referenceNoteDict =  ["Header":"Reference Note","Value":referenceNote]
        let empCommentsDict =  ["Header":"Additional Comments for Employees","Value":empCommentText]
        
        var comt = "Comments for School Professionals"
        let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
        if DivisionId == "92"{
            comt = "Comments for School Professionals Office Only"
        }
        let schProfCommentsDict =  ["Header":comt,"Value":divisionCommentText]
        
        
        let MondayTime =    String(format:"Monday        : %@ - %@",MondayStartTime,MondayEndTime)
        let TuesdayTime = String(format:"\nTuesday       : %@ - %@",TuesdayStartTime,TuesdayEndTime)
        let WednesdayTime =   String(format:"\nWednesday : %@ - %@",WednesdayStartTime,WednesdayEndTime)
        let ThursdayTime =    String(format:"\nThursday     : %@ - %@",ThursdayStartTime,ThursdayEndTime)
        let FridayTime =  String(format:"\nFriday         : %@ - %@",FridayStartTime,FridayEndTime)
        let SaturdayTime =    String(format:"\nSaturday     : %@ - %@",SaturdayStartTime,SaturdayEndTime)
        let SundayTime =  String(format:"\nSunday       : %@ - %@",SundayStartTime,SundayEndTime)
        
        
        let selectedEmployeeDict =  ["Header":"Selected Candidates","Value":employeeNameArray.map({ String(describing: $0) }).joined(separator: ", ")]
        
        
        if selectedSementTag == 0{
            
            if DivisionId == "117"{
                summaryDataArray = [posTypeDict,gradeDict,noOfPosDict,lessonPlanDict,startDateDict,endDateDict,startTimeDict,endTimeDict,reportToNameDict,reasonForOrderDict,referenceNoteDict,empCommentsDict,schProfCommentsDict,selectedEmployeeDict]
                
            }else{
                summaryDataArray = [posTypeDict,gradeDict,subjectDict,noOfPosDict,lessonPlanDict,startDateDict,endDateDict,startTimeDict,endTimeDict,reportToNameDict,reasonForOrderDict,referenceNoteDict,empCommentsDict,schProfCommentsDict,selectedEmployeeDict]
                
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
            
            if DivisionId == "117"{
                summaryDataArray = [posTypeDict,gradeDict,noOfPosDict,lessonPlanDict,startDateDict,endDateDict,TimeDict,reportToNameDict,reasonForOrderDict,referenceNoteDict,empCommentsDict,schProfCommentsDict,selectedEmployeeDict]
                
            }else{
                summaryDataArray = [posTypeDict,gradeDict,subjectDict,noOfPosDict,lessonPlanDict,startDateDict,endDateDict,TimeDict,reportToNameDict,reasonForOrderDict,referenceNoteDict,empCommentsDict,schProfCommentsDict,selectedEmployeeDict]
                
            }
            
        }
        return summaryDataArray
    }
    
    @IBAction override func okButtonTapped(_ sender: Any) {
        self.tAlertController.dismiss(animated: true, completion: nil)
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
        if isWarningMessage == true{
            self.pushToOrderSummaryPage()
        }else if isErrorMessage == true{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: UIDocPicker
    
    @IBAction func chooseFileAction(_ sender: Any)
    {
        showMenu()
    }
    @IBAction func deleteAction(_ sender: Any) {
        //        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: self.documentsTableView)
        //        let indexPath = self.documentsTableView.indexPathForRow(at:buttonPosition)
        //        documentsArray.removeObject(at:(indexPath?.section)!)
        //        documetBytes.removeObject(at:(indexPath?.section)!)
        //        fileExtensions.removeObject(at:(indexPath?.section)!)
        //        documentsTableView.reloadData()
    }
    @IBAction func uploadAction(_ sender: Any)
    {
        //        blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        //        blurEffectView = UIVisualEffectView(effect: blurEffect)
        //        blurEffectView.frame = view.bounds
        //        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //        documentsView.frame = CGRect(x:10,y:20,width: self.view.bounds.width-20,height:self.view.bounds.size.height-40)
        //        blurEffectView.contentView.addSubview(documentsView)
        //        view.addSubview(blurEffectView)
        //        documentsTableView.reloadData()
    }
    func showMenu(){
        
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypeContent)], in: .import)
        importMenu.delegate = self
        
        let modelName = UIDevice.current.modelName
        
        if modelName.contains("iPad"){
            importMenu.modalPresentationStyle = .popover
            importMenu.popoverPresentationController?.sourceView = self.view
        }else{
            
            importMenu.modalPresentationStyle = .fullScreen
            
            self.present(importMenu, animated: true, completion: nil)
        }
    }
    @available(iOS 8.0, *)
    public func documentPicker(_ controller:UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        let urlPath = url as URL
        print("The Url is",urlPath)
        if urlPath != nil{
            
            let fileExtension =  urlPath.pathExtension.lowercased()
            if fileExtension == "pdf" || fileExtension == "doc"||fileExtension == "txt"||fileExtension == "docx"||fileExtension == "rtf"{
                uploadedFileName = urlPath.lastPathComponent
                
                fileData = try! Data(contentsOf:urlPath)
                fileBytes = fileData.base64EncodedString()
                documentsArray.add(urlPath.lastPathComponent)
                documetBytes.add(fileBytes)
                fileExtensions.add(urlPath.lastPathComponent)
                //        documentsTableView.reloadData()
                self.tableView.reloadData()
            }else{
                isWarningMessage = false
                isErrorMessage = false
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Only '.pdf','.doc','.txt','.docx','.rtf' formats are allowed", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }
        
    }
    
    
    @available(iOS 8.0, *)
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController)
    {
        documentPicker.delegate = self
        if #available(iOS 11.0, *) {
            documentPicker.allowsMultipleSelection = true
        } else {
            // Fallback on earlier versions
        }
        present(documentPicker, animated: true, completion: nil)
        
    }
    func documentPickerWasCancelled(_ controller:UIDocumentPickerViewController) {
        print("we cancelled")
        //dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: Screen Orientation
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.addDivisionNameOnTop()
            self.screenOrientationLoading()
            self.tableView.reloadData()
            self.customPickerView.showPickerViewInOrientation(superView: (self.navigationController?.view)!, isPortrait: self.isPortrait())
            self.customCalendarView.showPickerViewInOrientation(superView: (self.navigationController?.view)!, isPortrait: self.isPortrait())
        })
        
    }
    //MARK: Calendar
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {

        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        
        let pickedDateString = formatter.string(from: date)
        
        if firstResponderTxtFieldTag == Int(StartDateTxtFieldTag) || firstResponderTxtFieldTag == Int(EndDateTxtFieldTag) {
            
            if selectedSementTag == 0{
                 self.updateDatesFromPicker(dateString: pickedDateString, forArray: orderDataArray)
             }else{
                 self.updateDatesFromPicker(dateString: pickedDateString, forArray: multiDayDataArray)
            }
         }
        customCalendarView.removePickerViewFromSuperView()
        
        
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
}
//extension NSArray{
//    //sorting- ascending
//    func ascendingArrayWithKeyValue(key:String) -> NSArray{
//        let ns = NSSortDescriptor.init(key: key, ascending: true)
//        let aa = NSArray(object: ns)
//        let arrResult = self.sortedArray(using: aa as! [NSSortDescriptor])
//        return arrResult as NSArray
//    }
//
//    //sorting - descending
//    func discendingArrayWithKeyValue(key:String) -> NSArray{
//        let ns = NSSortDescriptor.init(key: key, ascending: false)
//        let aa = NSArray(object: ns)
//        let arrResult = self.sortedArray(using: aa as! [NSSortDescriptor])
//        return arrResult as NSArray
//    }
//}

