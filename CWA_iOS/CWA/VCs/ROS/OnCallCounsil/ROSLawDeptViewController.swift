//
//  ROSLawDeptViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 15/02/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON
import MobileCoreServices
import FSCalendar

class ROSLawDeptViewController: BaseTableViewController,UITextFieldDelegate,UITextViewDelegate,searchEmpDelegate,SummaryDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate,UIDocumentMenuDelegate,addReportToDelegate,FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance {
    func addedReportToLocationOffice(_ locationName: OfficeReportToLocation) {}
    
    func addedReportTo(_ reportToPerson: ReportTo) {
    }
    
    func addedReportToLocation(_ locationName: ReportToLocation) {
    }
    
    func addReportToForOCC(_ reportTo: OCCReportToExp) {
        if reportTo.Value?.count == 0{
        }else{
            let NewTSApprover = TimeSlipAppr.init(Value: reportTo.Value, Text: reportTo.Text, isSelected: "0")
            let NewAltTSApprover =  AltTimeSlipAppr.init(Value: reportTo.Value, Text: reportTo.Text, isSelected: "0")
            let NewContact =  Contact.init(Value: reportTo.Value, Text: reportTo.Text, isSelected: "0")
            
            ReportToList.add(reportTo)
            TimeSlipApprList.add(NewTSApprover)
            AltTimeSlipApprList.add(NewAltTSApprover)
            ContactList.add(NewContact)
            self.tableView.reloadData()
        }
        
    }
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
    var uploadedFileName = ""
    var keyboardShowing = false
    
    //TableView Tag
    let docTblViewTag =  1001
    let mainTblViewTag =  1002
    let empTblViewTag =  1003
    let ReportToTblViewTag =  1004
    let TSApproverTblViewTag =  1005
    let AltTSApproverTblViewTag =  1006
    let ContactPersonTblViewTag =  1007
    let YrsOfExpReqdTblViewTag =  1008
    let bgSkillSetTblViewTag =  1009
    let TaskMainTblViewTag =  10010
    //MARK: OUTLET VARIBALE
    //    @IBOutlet weak var listTableView: UITableView!
    //    @IBOutlet weak var nextButton : UIButton!
    
    var empTableView: UITableView!
    var customPickerView = JPPickerView()
    var customCalendarView = CalendarView()
    var timeSegment = UISegmentedControl()
    var activeField: UITextField?
    var activeTextView: UITextView?
    var alrtController = UIAlertController()
    var TaskTableView: UITableView!
    
    var createOrderObj = NSDictionary()
    
    //MARK: Array Initialisation
    var dataArray  = NSMutableArray()
    var TaskList = NSMutableArray()
    var ReportToList = NSMutableArray()
    var TimeSlipApprList  = NSMutableArray()
    var AltTimeSlipApprList  = NSMutableArray()
    var YearsOfExpList  = NSMutableArray()
    var ContactList  = NSMutableArray()
    var BackgroundAttorneyList  = NSMutableArray()
    var EmployeeList  = NSMutableArray()
    var AllEmployeeList  = NSMutableArray()
    var selectedTaskList  = NSMutableArray()
    
    var selectedEmployeeArray = NSMutableArray()
    var SelectanyadditionaladmissionsrequiredList = NSMutableArray()
    
    //MARK: Validation Variables
    
    var isValidEformExp = true
    var isValidStartDate = true
    var isValidEndDate = true
    var isValidAttorneysNeeded = true
    var isValidYrOfExp = true
    var isValidReportTo = true
    var isValidTSApprover = true
    var isValidAltTSApprover = true
    var isValidContact = true
    var isValidAttachment = true
    var isValidApprovedEFormExp = true
    var isValidMatterShownEForm = true
    var isValidTaskList  = true
    var isValidAnyAdditionalAdmissionReqd = true
    var isValidFindAttorney = true
    
    var allDataValidated = true
    
    //TextField And TextView Tag
    var firstResponderTxtFieldTag = 0
    
    let StartDateTxtFieldTag = "100015"
    let EndDateTxtFieldTag = "100016"
    let TotalApprovedEFormExpenseTxtFieldTag = "10001"
    let MattershownonEFormTxtFieldTag = "10002"
    let AttorneyNeededTextFieldTag =  "10003"
    let YrOfExpTxtFieldTag = "10004"
    let ReportToTxtFieldTag = "10005"
    let TimeslipApproverTxtFieldTag = "10006"
    let AltTimeslipApproverTxtFieldTag = "10007"
    let ContactPersonTxtFieldTag = "10008"
    let FindAttorneyWithSimilarSkillTxtFieldTag = "10009"
    
    //TextView Tag
    let PositionDutiesTxtViewTag = "101"
    let SkillsetBackgroundTxtViewTag = "102"
    let TechnologySkillsetTxtViewTag =  "103"
    let litigationTxtViewTag = "104"
    let AdditionalExperienceRequiredTxtViewTag = "105"
    
    //Placeholders
    let AttachEFormDocPlaceHolder = "Attached Approved E-Form Document"
    let TotalApprovedEFormExpensePlaceHolder = "Total Approved E-Form Expense *"
    let MattershownonEFormPlaceHolder  = "Matter # shown on E-Form *"
    let startDatePlaceHolder = "Start Date *"
    let endDatePlaceHolder = "End Date *"
    let AttorneyNeededPlaceHolder = "Attorney(s) Needed *"
    let IsAdmissionReqdPlaceHolder = "Is NY Bar Admission Required?"
    let  AnyAdditionalAdmisnPlaceHolder = "Select any additional admissions required"
    let YrOfExpPlaceHolder = "Years of Experience *"
    let TaskPlaceHolder = "Tasks *"
    let PositionDutiesPlaceHolder = "Position Duties"
    let SkillsetBackgroundPlaceHolder = "Skillset/Background"
    let TechnologySkillsetPlaceHolder = "Technology Skillset"
    let litigationMatterPlaceHolder = "If this is a litigation matter, what is the nature of the case?"
    let AdditionalExperienceRequiredPlaceHolder = "Additional Experience Required (eg. Years of Experience) ?"
    let ReportToPlaceHolder = "Report To *"
    let TimeslipApproverPlaceHolder = "Timeslip Approver *"
    let AltTimeslipApproverPlaceHolder = "Alternate Timeslip Approver *"
    let ContactPersonPlaceHolder = "Contact Person *"
    let findAttorneyPlaceHolder = "Select any of the three methods below to find attorney(s): *"
    //
    var selectedReportTo = OCCReportToExp.init(Value: "", Text: "", isSelected: "0")
    var selectedTSApprover = TimeSlipAppr.init(Value: "", Text: "", isSelected: "0")
    var selectedAltTSApprover =  AltTimeSlipAppr.init(Value: "", Text: "", isSelected: "0")
    var selectedYrsOfExpReqd = YearsOfExp.init(Value: "", Text: "", isSelected: "0")
    var selectedbgSkillSet = Attorney.init(Value: "", Text: "", isSelected: "0")
    var selectedContact =  Contact.init(Value: "", Text: "", isSelected: "0")
    
    //    UI Checkings
    var noMatterChecked = false
    var ApprovedEFormExpense = ""
    //Variable
    var PositionDutiesText = ""
    var SkillsetBackgroundText = ""
    var TechnologySkillsetText = ""
    var litigationMatterText = ""
    var AdditionalExperienceRequiredText = ""
    var StartDate = ""
    var EndDate = ""
    var AttorneysNeeded = ""
    var matterShownIneForm = ""
    var IsNYBarAdmissionRequired = ""
    var isEDNYSelected = false
    var isSDNYSelected = false
    var findAttWithSimilarSkill = false
    var occToRecriut = true
    
    @objc override func appWillEnterForeground(){
        print("appWillEnterForeground Division")
        
        if dataArray.count == 0{
            self.getROSData()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getROSData()
        //        self.registerForKeyboardNotifications()
        
        self.setupPickerView()
        self.setupCalendarView()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titlelbl.text = "Enter New Temp Attorney Order"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Delegate Methods
    func selecetdEmployee(_ emps: NSMutableArray) {
        if emps.count > 0{
            EmployeeList.removeAllObjects()
            EmployeeList = emps
            empTableView.reloadData()
            self.tableView.reloadData()
        }
    }
    
    func createNewOrderFromSummary() {
        self.resetAllDataForNewOrder()
        self.getROSData()
        
    }
    //    override  public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
    //        if tableView.tag == mainTblViewTag && isDataLoaded == true
    //{
    //
    //            return 70}
    //        return 0
    //    }
    //    override public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
    //        if tableView.tag == mainTblViewTag{
    //
    //            return self.nextBtnFooterView()
    //        }
    //        return nil
    //    }
    //
    //    func nextBtnFooterView() -> UIView{
    //
    //        let footerView = Bundle.main.loadNibNamed("ButtonFooterView", owner: self, options: nil)?[0] as! ButtonFooterView
    //        footerView.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: 70)
    //        footerView.nextButton.addTarget(self, action:#selector(self.nextButtonTapped), for:.touchUpInside)
    //
    //        return footerView
    //    }
    //
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == empTblViewTag{
            return EmployeeList.count
        }else if tableView.tag == ReportToTblViewTag{
            return ReportToList.count
        }else if tableView.tag == TSApproverTblViewTag{
            return TimeSlipApprList.count
        }else if tableView.tag == AltTSApproverTblViewTag{
            return AltTimeSlipApprList.count
        }else if tableView.tag == ContactPersonTblViewTag{
            return ContactList.count
        }else if tableView.tag == YrsOfExpReqdTblViewTag{
            return YearsOfExpList.count
        }else if tableView.tag == mainTblViewTag{
            return dataArray.count
        }else if tableView.tag == bgSkillSetTblViewTag{
            return BackgroundAttorneyList.count
        }else if tableView.tag == TaskMainTblViewTag{
            return TaskList.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView.tag == empTblViewTag ||  tableView.tag == ReportToTblViewTag ||  tableView.tag == TSApproverTblViewTag ||  tableView.tag == AltTSApproverTblViewTag ||  tableView.tag == ContactPersonTblViewTag || tableView.tag == YrsOfExpReqdTblViewTag || tableView.tag == bgSkillSetTblViewTag {
            var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell!
            if !(cell != nil) {
                cell = UITableViewCell(style:.subtitle, reuseIdentifier: "CELL")
            }
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            if tableView.tag == empTblViewTag{
                
                let  emp = EmployeeList[indexPath.row] as! NewEmployee
                let  empObj:NewEmployee = emp as NewEmployee
                let name =   empObj.Name
                cell?.textLabel?.text = name
                if empObj.isSelected == "0"{
                    cell?.backgroundColor = UIColor.white
                }else{
                    cell?.backgroundColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
                }
                
                
            }else  if tableView.tag == ReportToTblViewTag{
                
                let obj = ReportToList[indexPath.row]
                
                let  o:OCCReportToExp = obj as! OCCReportToExp
                cell?.textLabel?.text = o.Text
                if o.isSelected == "1"{
                    cell?.accessoryType = .checkmark
                }else{
                    cell?.accessoryType = .none
                }
            }else if tableView.tag == TSApproverTblViewTag{
                
                let tsAppr = TimeSlipApprList[indexPath.row]
                
                let  tsApprObj:TimeSlipAppr = tsAppr as! TimeSlipAppr
                cell?.textLabel?.text = tsApprObj.Text
                if tsApprObj.isSelected == "1"{
                    cell?.accessoryType = .checkmark
                }else{
                    cell?.accessoryType = .none
                }
            }else if tableView.tag == AltTSApproverTblViewTag{
                
                let tsAppr = AltTimeSlipApprList[indexPath.row]
                
                let  tsApprObj:AltTimeSlipAppr = tsAppr as! AltTimeSlipAppr
                cell?.textLabel?.text = tsApprObj.Text
                if tsApprObj.isSelected == "1"{
                    cell?.accessoryType = .checkmark
                }else{
                    cell?.accessoryType = .none
                }
            }else if tableView.tag == ContactPersonTblViewTag{
                
                let contactPer = ContactList[indexPath.row]
                
                let  contactPerObj:Contact = contactPer as! Contact
                cell?.textLabel?.text = contactPerObj.Text
                if contactPerObj.isSelected == "1"{
                    cell?.accessoryType = .checkmark
                }else{
                    cell?.accessoryType = .none
                }
                
            }else if tableView.tag == YrsOfExpReqdTblViewTag{
                
                let yrsExp = YearsOfExpList[indexPath.row]
                
                let  yrsExpObj:YearsOfExp = yrsExp as! YearsOfExp
                cell?.textLabel?.text = yrsExpObj.Text
                if yrsExpObj.isSelected == "1"{
                    cell?.accessoryType = .checkmark
                }else{
                    cell?.accessoryType = .none
                }
                
            }else if tableView.tag == bgSkillSetTblViewTag{
                
                let attorney = BackgroundAttorneyList[indexPath.row]
                
                let  attorneyObj:Attorney = attorney as! Attorney
                cell?.textLabel?.text = attorneyObj.Text
                if attorneyObj.isSelected == "1"{
                    cell?.accessoryType = .checkmark
                }else{
                    cell?.accessoryType = .none
                }
            }
            
            return cell!
        }else if  tableView.tag == TaskMainTblViewTag{
            
            return  self.TaskCell(dTableView: tableView, indexPath:  indexPath as NSIndexPath)
        }
        
        // Main Table View
        
        let dict =  dataArray[indexPath.row] as! NSDictionary
        let placeholder = dict["header"] as! String
        
        if placeholder == ReportToPlaceHolder || placeholder == TimeslipApproverPlaceHolder || placeholder == AltTimeslipApproverPlaceHolder || placeholder == ContactPersonPlaceHolder || placeholder == MattershownonEFormPlaceHolder || placeholder == AttorneyNeededPlaceHolder || placeholder == TotalApprovedEFormExpensePlaceHolder || placeholder == YrOfExpPlaceHolder
        {
            
            return  self.TextFieldCell(dataDict: dict, indexPath: indexPath as NSIndexPath)
            
        }else if placeholder == PositionDutiesPlaceHolder || placeholder == SkillsetBackgroundPlaceHolder || placeholder == TechnologySkillsetPlaceHolder || placeholder == litigationMatterPlaceHolder || placeholder == AdditionalExperienceRequiredPlaceHolder
        {
            //textview
            return self.textViewCell(indexPath: indexPath as NSIndexPath, dataDict: dict)
        }else if placeholder == findAttorneyPlaceHolder{
            //long cell
            return self.FindAttorneyCell(dataDict: dict, indexPath: indexPath as NSIndexPath)
        }else if placeholder == AttachEFormDocPlaceHolder{
            //upload cell
            return self.UploadDocCell(dataDict: dict, indexPath: indexPath as NSIndexPath)
        }else if placeholder.contains("Date"){
            //date cell
            return self.DateCell(dataDict: dict, indexPath: indexPath as NSIndexPath)
        }else if placeholder.contains("Task"){
            
            return self.TaskMainCell(dataDict: dict, indexPath: indexPath as NSIndexPath)
        }else if placeholder == IsAdmissionReqdPlaceHolder || placeholder == AnyAdditionalAdmisnPlaceHolder{
            
            return self.admissionRequiredCell(dataDict: dict, indexPath: indexPath as NSIndexPath)
        }else if placeholder == "Next"{
            return self.ButtonTableCell(indexPath: indexPath as NSIndexPath)
        }
        return UITableViewCell()
    }
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView.tag == mainTblViewTag{
            
            let dict =  dataArray[indexPath.row] as! NSDictionary
            let placeholder = dict["header"] as! String
            
            if placeholder == PositionDutiesPlaceHolder || placeholder == SkillsetBackgroundPlaceHolder || placeholder == TechnologySkillsetPlaceHolder || placeholder == litigationMatterPlaceHolder || placeholder == AdditionalExperienceRequiredPlaceHolder
            {
                //textview
                return 130
            }else if placeholder == findAttorneyPlaceHolder{
                //OCC cell
                return 500
            }else if placeholder == AttachEFormDocPlaceHolder{
                //upload cell
                return 90
            }else if placeholder == ReportToPlaceHolder || placeholder == TimeslipApproverPlaceHolder || placeholder == AltTimeslipApproverPlaceHolder || placeholder == ContactPersonPlaceHolder || placeholder == MattershownonEFormPlaceHolder || placeholder == AttorneyNeededPlaceHolder || placeholder == TotalApprovedEFormExpensePlaceHolder || placeholder == YrOfExpPlaceHolder{
                
                
                return 90
                
            }else if placeholder == IsAdmissionReqdPlaceHolder || placeholder == AnyAdditionalAdmisnPlaceHolder ||  placeholder.contains("Date"){
                return 70
            }else if placeholder.contains("Task"){
                
                return 200
            }else if placeholder == "Next"{
                return 80
            }
        }
        
        return 44
        
    }
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if tableView.tag == TaskMainTblViewTag{
            
            let task = TaskList[(indexPath.row)]
            
            let  taskObj:Task = task as! Task
            
            let isSelecetd = taskObj.isChecked
            
            if isSelecetd == "1"{
                taskObj.isChecked = "0"
                selectedTaskList.remove(taskObj)
                
            }else{
                taskObj.isChecked = "1"
                if selectedTaskList.contains(taskObj){}else{
                    selectedTaskList.add(taskObj)}
            }
            if selectedTaskList.count == 0{}else{
                isValidTaskList = true
            }
            tableView.reloadData()
            
        }else if tableView.tag == empTblViewTag{
            
            let  emp = EmployeeList[indexPath.row] as! NewEmployee
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
            EmployeeList.replaceObject(at: indexPath.row, with: empObj)
        } else  if tableView.tag == ReportToTblViewTag{
            
            let obj = ReportToList[indexPath.row]
            
            let  o:OCCReportToExp = obj as! OCCReportToExp
            selectedReportTo = o
            for obj in ReportToList{
                let reportObj:OCCReportToExp = obj as! OCCReportToExp
                reportObj.isSelected = "0"
            }
            selectedReportTo.isSelected = "1"
            isValidReportTo = true
            alrtController.dismiss(animated: true, completion: nil)
            
        }else if tableView.tag == TSApproverTblViewTag{
            
            let tsAppr = TimeSlipApprList[indexPath.row]
            
            let  tsApprObj:TimeSlipAppr = tsAppr as! TimeSlipAppr
            selectedTSApprover = tsApprObj
            for obj in TimeSlipApprList{
                let tsApprObj:TimeSlipAppr = obj as! TimeSlipAppr
                tsApprObj.isSelected = "0"
            }
            selectedTSApprover.isSelected = "1"
            isValidTSApprover = true
            alrtController.dismiss(animated: true, completion: nil)
            
        }else if tableView.tag ==  AltTSApproverTblViewTag{
            
            let tsAppr = AltTimeSlipApprList[indexPath.row]
            
            let  tsApprObj:AltTimeSlipAppr = tsAppr as! AltTimeSlipAppr
            selectedAltTSApprover = tsApprObj
            for obj in AltTimeSlipApprList{
                let tsApprObj:AltTimeSlipAppr = obj as! AltTimeSlipAppr
                tsApprObj.isSelected = "0"
            }
            isValidAltTSApprover = true
            selectedAltTSApprover.isSelected = "1"
            alrtController.dismiss(animated: true, completion: nil)
            
        }else if tableView.tag == ContactPersonTblViewTag{
            
            let contactPer = ContactList[indexPath.row]
            
            let  contactPerObj:Contact = contactPer as! Contact
            selectedContact = contactPerObj
            for obj in ContactList{
                let contactPerObj:Contact = obj as! Contact
                contactPerObj.isSelected = "0"
            }
            isValidContact = true
            selectedContact.isSelected = "1"
            alrtController.dismiss(animated: true, completion: nil)
            
            
        }else if tableView.tag == YrsOfExpReqdTblViewTag{
            
            let yrsExp = YearsOfExpList[indexPath.row]
            
            let  yrsExpObj:YearsOfExp = yrsExp as! YearsOfExp
            selectedYrsOfExpReqd = yrsExpObj
            for obj in YearsOfExpList{
                let yrsExpObj:YearsOfExp = obj as! YearsOfExp
                yrsExpObj.isSelected = "0"
            }
            selectedYrsOfExpReqd.isSelected = "1"
            isValidYrOfExp = true
            alrtController.dismiss(animated: true, completion: nil)
            
            
        }else if tableView.tag == bgSkillSetTblViewTag{
            
            let attorney = BackgroundAttorneyList[indexPath.row]
            let  attorneyObj:Attorney = attorney as! Attorney
            selectedbgSkillSet = attorneyObj
            for obj in YearsOfExpList{
                let attorneyObj:YearsOfExp = obj as! YearsOfExp
                attorneyObj.isSelected = "0"
            }
            selectedbgSkillSet.isSelected = "1"
            alrtController.dismiss(animated: true, completion: nil)
            
        }
        tableView.reloadData()
        
        self.tableView.reloadData()
        
    }
    //MARK: Custom Cell
    func ButtonTableCell(indexPath: NSIndexPath) -> ButtonTableViewCell {
        
        let cell:ButtonTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "NextTableViewCellIdentifier") as! ButtonTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        cell.dButton.removeTarget(self, action:#selector(self.nextButtonTapped), for: .touchUpInside)
        cell.dButton.addTarget(self, action:#selector(self.nextButtonTapped), for: .touchUpInside)
        return cell
        
    }
    func DateCell(dataDict: NSDictionary,indexPath: NSIndexPath) -> DateTableViewCell {
        
        let cell:DateTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "DateTableViewCellIdentifier") as! DateTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        
        var startTag = 0
        var endTag = 0
        var startValue = ""
        var endValue = ""
        
        cell.startTimeView.layer.borderColor = borderColor.cgColor
        cell.endTimeView.layer.borderColor = borderColor.cgColor
        cell.endTimeView.layer.borderWidth = CGFloat(1)
        cell.startTimeView.layer.borderWidth = CGFloat(1)
        
        
        let placeholder = dataDict["header"] as! String
        let subplaceholder = dataDict["subHeader"] as! String
        
        
        startTag = Int(dataDict["StartTag"] as! String)!
        endTag = Int(dataDict["EndTag"] as! String)!
        startValue = dataDict["StartValue"] as! String
        endValue = dataDict["EndValue"] as! String
        StartDate = startValue
        EndDate = endValue
        cell.startTimeView.layer.borderColor = borderColor.cgColor
        cell.endTimeView.layer.borderColor = borderColor.cgColor
        
        cell.textFStart.tag = startTag
        cell.textFEnd.tag = endTag
        
        cell.lblStart.text = placeholder
        cell.lblEnd.text = subplaceholder
        cell.textFStart.delegate = self
        cell.textFEnd.delegate = self
        
        cell.textFStart.text = startValue
        cell.textFEnd.text = endValue
        if isValidStartDate == false{
            cell.lblStart.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.red)
            cell.startTimeView.layer.borderColor = UIColor.red.cgColor
            
        }else{
            cell.lblStart.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.clear)
        }
        if isValidEndDate == false{
            cell.lblEnd.halfTextColorChange(fullText: subplaceholder, changeText: "*", textColor: UIColor.red)
            cell.endTimeView.layer.borderColor = UIColor.red.cgColor
            
        }else{
            cell.lblEnd.halfTextColorChange(fullText: subplaceholder, changeText: "*", textColor: UIColor.clear)
        }
        return cell
        
    }
    func UploadDocCell(dataDict: NSDictionary,indexPath: NSIndexPath) -> TextFieldTableViewCell {
        
        let cell:TextFieldTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "LessonPlanTableViewCellIdentifier") as! TextFieldTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        let placeholder = dataDict["header"] as! String
        
        cell.lblHeader.text = placeholder
        cell.btnBGView.layer.borderColor = borderColor.cgColor
        cell.btnBGView.layer.borderWidth = 1
        
        
        
        cell.uploadBtn.layer.borderColor = borderColor.cgColor
        cell.uploadBtn.layer.borderWidth = 1
        cell.uploadBtn.layer.cornerRadius = 7
        
        cell.uploadBtn.removeTarget(self, action:#selector(self.uploadAttachmentBtnTapped), for: .touchUpInside)
        cell.uploadBtn.addTarget(self, action:#selector(self.uploadAttachmentBtnTapped), for: .touchUpInside)
        //
        cell.lblFileName.text = uploadedFileName
        
        //        if isValidAttachment == true{
        //            cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.clear)
        //        }else{
        //            cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.red)
        //            cell.btnBGView.layer.borderColor = UIColor.red.cgColor
        //
        //        }
        return cell
        
    }
    
    func TaskCell(dTableView: UITableView,indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = dTableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell!
        if !(cell != nil) {
            cell = UITableViewCell(style:.subtitle, reuseIdentifier: "CELL")
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        
        //        let cell = dTableView.dequeueReusableCell(withIdentifier: "SubjectExperienceTableViewCellIdentifier", for: indexPath as IndexPath) as! SubjectExperienceTableViewCell
        //
        //        cell.selectionStyle = UITableViewCellSelectionStyle.none
        //        cell.backgroundColor = UIColor.clear
        //
        //
        let task = TaskList[indexPath.row]
        
        let  taskObj:Task = task as! Task
        
        let Name = taskObj.Text
        
        cell?.textLabel?.text = Name
        
        var imageName = "check_box"
        if taskObj.isChecked == "0"{
        }else{
            imageName =  "check_box_filled"
        }
        cell?.imageView?.image = imageWithImage(image: UIImage.init(named: imageName)!, scaledToSize: CGSize(width: 20, height: 20))
        //
        //
        return cell!
        
    }
    func FindAttorneyCell (dataDict: NSDictionary,indexPath: NSIndexPath) -> OCCEmployeeTableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "OCCEmployeeTableViewCellIdentifier", for: indexPath as IndexPath) as! OCCEmployeeTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundColor = UIColor.clear
        
        cell.empTableView.tag = empTblViewTag
        cell.empTableView.delegate = self
        cell.empTableView.dataSource = self
        cell.TblBGView.layer.borderColor = borderColor.cgColor
        cell.TblBGView.layer.borderWidth = 1
        empTableView = cell.empTableView
        cell.searchEmpBtn.removeTarget(self, action:#selector(self.searchBtnTapped), for: .touchUpInside)
        cell.findAttorneyBtn.removeTarget(self, action:#selector(self.findAttorneyBtnTapped), for: .touchUpInside)
        cell.occToRecruitBtn.removeTarget(self, action:#selector(self.occToRecruitBtnTapped), for: .touchUpInside)
        cell.moveUpBtn.removeTarget(self, action:#selector(self.moveUpBtnTapped), for: .touchUpInside)
        cell.moveDownBtn.removeTarget(self, action:#selector(self.moveDownBtnTapped), for: .touchUpInside)
        cell.deleteBtn.removeTarget(self, action:#selector(self.deleteBtnTapped), for: .touchUpInside)
        
        
        cell.searchEmpBtn.addTarget(self, action:#selector(self.searchBtnTapped), for: .touchUpInside)
        cell.findAttorneyBtn.addTarget(self, action:#selector(self.findAttorneyBtnTapped), for: .touchUpInside)
        cell.occToRecruitBtn.addTarget(self, action:#selector(self.occToRecruitBtnTapped), for: .touchUpInside)
        cell.moveUpBtn.addTarget(self, action:#selector(self.moveUpBtnTapped), for: .touchUpInside)
        cell.moveDownBtn.addTarget(self, action:#selector(self.moveDownBtnTapped), for: .touchUpInside)
        cell.deleteBtn.addTarget(self, action:#selector(self.deleteBtnTapped), for: .touchUpInside)
        
        if findAttWithSimilarSkill == true{
            cell.attorneyTxtField.isHidden = false
            cell.toRecruitViewTopConstraint.constant = 46
        }else{
            
            cell.attorneyTxtField.isHidden = false
            cell.toRecruitViewTopConstraint.constant = 5
        }
        cell.attorneyTxtField.text = selectedbgSkillSet.Text
        cell.attorneyTxtField.tag = Int(FindAttorneyWithSimilarSkillTxtFieldTag)!
        cell.attorneyTxtField.delegate = self
        cell.layoutIfNeeded()
        cell.occToRecruitLbl.isHidden = occToRecriut
        
        if isValidFindAttorney == true{
            cell.headerLbl.halfTextColorChange(fullText: findAttorneyPlaceHolder, changeText: "*", textColor: UIColor.clear)
        }else{
            cell.headerLbl.halfTextColorChange(fullText: findAttorneyPlaceHolder, changeText: "*", textColor: UIColor.red)
        }
        //        .
        
        let imageView = UIImageView.init(frame: CGRect(x:0,y:0,width:20,height:20));
        let image = UIImage(named: "expand-arrow");
        imageView.image = image;
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        cell.attorneyTxtField.rightView = imageView;
        cell.attorneyTxtField.rightViewMode = UITextField.ViewMode.always
        cell.attorneyTxtField.rightViewMode = .always
        return cell
        
    }
    //
    func TaskMainCell(dataDict: NSDictionary,indexPath: NSIndexPath ) -> OCCTaskTableViewCell {
        
        let cell:OCCTaskTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "OCCTaskTableViewCellIdentifier") as! OCCTaskTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.taskTableView.tag  = TaskMainTblViewTag
        cell.taskTableView.delegate = self
        cell.taskTableView.dataSource = self
        cell.taskTableView.layer.borderColor = borderColor.cgColor
        cell.taskTableView.layer.borderWidth = 1
        TaskTableView = cell.taskTableView
        TaskTableView.reloadData()
        if isValidTaskList == true{
            cell.lblHeader.halfTextColorChange(fullText: TaskPlaceHolder, changeText: "*", textColor: UIColor.clear)
        }else{
            cell.lblHeader.halfTextColorChange(fullText: TaskPlaceHolder, changeText: "*", textColor: UIColor.red)
        }
        return cell
        
    }
    func admissionRequiredCell(dataDict: NSDictionary,indexPath: NSIndexPath ) -> CreditSelectionTableViewCell {
        
        let cell:CreditSelectionTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "CreditSelectionTableViewCellIdentifier") as! CreditSelectionTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        let placeholder = dataDict["header"] as! String
        
        cell.lblHeader.text = placeholder
        
        let radio_ON = "radio-button-on"
        let radio_OFF = "radio-button-off"
        let check_Filled = "check_box_filled"
        let check_UnFilled = "check_box"
        
        cell.yesBtn.removeTarget(self, action:#selector(self.SDNYBtnTapped), for: .touchUpInside)
        cell.noBtn.removeTarget(self, action:#selector(self.EDNYBtnTapped), for: .touchUpInside)
        cell.yesBtn.removeTarget(self, action:#selector(self.yesBtnTapped), for: .touchUpInside)
        cell.noBtn.removeTarget(self, action:#selector(self.noBtnTapped), for: .touchUpInside)
        
        if placeholder == IsAdmissionReqdPlaceHolder{
            cell.yesBtn.setImage(UIImage.init(named: radio_OFF), for: .normal)
            cell.yesBtn.setImage(UIImage.init(named: radio_ON), for: .selected)
            cell.noBtn.setImage(UIImage.init(named: radio_OFF), for: .normal)
            cell.noBtn.setImage(UIImage.init(named: radio_ON), for: .selected)
            cell.yesBtn.addTarget(self, action:#selector(self.yesBtnTapped), for: .touchUpInside)
            cell.noBtn.addTarget(self, action:#selector(self.noBtnTapped), for: .touchUpInside)
            
            
            if IsNYBarAdmissionRequired.caseInsensitiveCompare("Yes") == ComparisonResult.orderedSame{
                
                cell.yesBtn.isSelected = true
                cell.noBtn.isSelected = false
            }else{
                cell.yesBtn.isSelected = false
                cell.noBtn.isSelected = true
            }
            cell.yesBtn.setTitle( "Yes", for: .normal)
            cell.noBtn.setTitle( "No", for: .normal)
            
        }else if placeholder == AnyAdditionalAdmisnPlaceHolder{
            cell.yesBtn.setImage(UIImage.init(named: check_UnFilled), for: .normal)
            cell.yesBtn.setImage(UIImage.init(named: check_Filled), for: .selected)
            cell.noBtn.setImage(UIImage.init(named: check_UnFilled), for: .normal)
            cell.noBtn.setImage(UIImage.init(named: check_Filled), for: .selected)
            cell.yesBtn.addTarget(self, action:#selector(self.SDNYBtnTapped), for: .touchUpInside)
            cell.noBtn.addTarget(self, action:#selector(self.EDNYBtnTapped), for: .touchUpInside)
            cell.yesBtn.isSelected = isSDNYSelected
            cell.noBtn.isSelected = isEDNYSelected
            
            
            if SelectanyadditionaladmissionsrequiredList.count == 2{
                
                let yesBtnDict = SelectanyadditionaladmissionsrequiredList[0] as! NSDictionary
                let noBtnDict = SelectanyadditionaladmissionsrequiredList[1] as! NSDictionary
                
                cell.yesBtn.setTitle( yesBtnDict["Text"] as? String, for: .normal)
                cell.noBtn.setTitle( noBtnDict["Text"] as? String, for: .normal)
                
            }
            //            if isValidAnyAdditionalAdmissionReqd == true{
            //                cell.lblHeader.halfTextColorChange(fullText: AnyAdditionalAdmisnPlaceHolder, changeText: "*", textColor: UIColor.clear)
            //            }else{
            //                cell.lblHeader.halfTextColorChange(fullText: AnyAdditionalAdmisnPlaceHolder, changeText: "*", textColor: UIColor.red)
            //            }
        }
        
        return cell
        
    }
    func TextFieldCell(dataDict: NSDictionary,indexPath: NSIndexPath) -> TextFieldTableViewCell {
        
        let cell:TextFieldTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCellIdentifier") as! TextFieldTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(keyboardDoneBtnTapped))]
        toolBar.sizeToFit()
        cell.entryTextField.inputAccessoryView = toolBar
        
        let placeholder = dataDict["header"] as! String
        let tag =  dataDict["Tag"] as! String
        
        cell.lblHeader.text = placeholder
        cell.entryTextField.tag = Int(tag)!
        cell.entryTextField.delegate = self
        self.activeField = cell.entryTextField
        cell.entryTextField.isUserInteractionEnabled = true
        cell.btnBGView.backgroundColor = UIColor.white
        
        cell.btnBGView.layer.borderWidth = 1
        cell.btnBGView.layer.borderColor = borderColor.cgColor
        
        cell.dStpper.isHidden = true
        cell.noMatterBtn.isHidden = true
        cell.addButton.isHidden = true
        cell.txtFieldTrailingConstraint.constant =  5
        cell.entryTextField.placeholder  = ""
        cell.entryTextField.keyboardType = UIKeyboardType.default
        cell.lblDollar.isHidden = true
        if tag == YrOfExpTxtFieldTag{
            cell.entryTextField.text = selectedYrsOfExpReqd.Text
            cell.addButton.isHidden = true
            if isValidYrOfExp == true{
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.clear)
            }else{
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.red)
                cell.btnBGView.layer.borderColor = UIColor.red.cgColor
                
            }
        }else if tag == AttorneyNeededTextFieldTag{
            cell.entryTextField.text = AttorneysNeeded
            cell.entryTextField.keyboardType = UIKeyboardType.numberPad
            
            cell.addButton.isHidden = true
            if isValidAttorneysNeeded == true{
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.clear)
            }else{
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.red)
                cell.btnBGView.layer.borderColor = UIColor.red.cgColor
                
            }
        }else if tag == TotalApprovedEFormExpenseTxtFieldTag {
            //show stepper
            cell.lblHeaderTrailingConstraint.constant = 5
            cell.layoutIfNeeded()
            cell.entryTextField.keyboardType = UIKeyboardType.decimalPad
            cell.lblDollar.isHidden = false
            cell.entryTextField.text = ApprovedEFormExpense
            cell.dStpper.isHidden = true
            cell.dStpper.removeTarget(self, action: #selector(self.stepperAction), for: .valueChanged)
            cell.dStpper.addTarget(self, action: #selector(self.stepperAction), for: .valueChanged)
            cell.txtFieldTrailingConstraint.constant =  110
            if isValidEformExp == true{
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.clear)
            }else{
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.red)
                cell.btnBGView.layer.borderColor = UIColor.red.cgColor
                
            }
        }else if tag == MattershownonEFormTxtFieldTag {
            //show no matter check button
            cell.lblHeaderTrailingConstraint.constant = 120
            cell.layoutIfNeeded()
            cell.noMatterBtn.isHidden = false
            cell.entryTextField.placeholder = "####-###### or ##AL###### format"
            if noMatterChecked == true{
                cell.btnBGView.backgroundColor = UIColor.lightGray
                cell.entryTextField.isUserInteractionEnabled = false
                cell.entryTextField.text = ""
                matterShownIneForm = ""
                cell.noMatterBtn.isSelected = true
            }else{
                cell.entryTextField.text = matterShownIneForm
                
                cell.noMatterBtn.isSelected = false
                
            }
            cell.noMatterBtn.removeTarget(self, action: #selector(self.noMatterAction), for: .touchUpInside)
            cell.noMatterBtn.addTarget(self, action: #selector(self.noMatterAction), for: .touchUpInside)
            
            if isValidMatterShownEForm == true{
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.clear)
            }else{
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.red)
                cell.btnBGView.layer.borderColor = UIColor.red.cgColor
                
            }
        }else if tag == ReportToTxtFieldTag {
            //show Add button
            cell.entryTextField.text = selectedReportTo.Text
            
            cell.addButton.isHidden = false
            if isValidReportTo == true{
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.clear)
            }else{
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.red)
                cell.btnBGView.layer.borderColor = UIColor.red.cgColor
                
            }
        }else if tag == TimeslipApproverTxtFieldTag {
            //show Add button
            cell.entryTextField.text = selectedTSApprover.Text
            cell.addButton.isHidden = false
            if isValidTSApprover == true{
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.clear)
            }else{
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.red)
                cell.btnBGView.layer.borderColor = UIColor.red.cgColor
                
            }
        }else if tag == AltTimeslipApproverTxtFieldTag {
            //show Add button
            cell.entryTextField.text = selectedAltTSApprover.Text
            cell.addButton.isHidden = false
            if isValidAltTSApprover == false{
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.red)
                cell.btnBGView.layer.borderColor = UIColor.red.cgColor
                
            }else{
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.clear)
            }
        }else if tag == ContactPersonTxtFieldTag {
            //show Add button
            cell.entryTextField.text = selectedContact.Text
            
            cell.addButton.isHidden = false
            if isValidContact == false{
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.red)
                cell.btnBGView.layer.borderColor = UIColor.red.cgColor
                
            }else{
                cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.clear)
            }
        }
        
        if tag == ReportToTxtFieldTag || tag == TimeslipApproverTxtFieldTag || tag == AltTimeslipApproverTxtFieldTag || tag == ContactPersonTxtFieldTag {
            cell.addButton.removeTarget(self, action: #selector(self.addReportToAction), for: .touchUpInside)
            cell.addButton.addTarget(self, action: #selector(self.addReportToAction), for: .touchUpInside)
            
        }
        cell.layoutIfNeeded()
        
        if tag == ContactPersonTxtFieldTag || tag == AltTimeslipApproverTxtFieldTag || tag == TimeslipApproverTxtFieldTag || tag == ReportToTxtFieldTag || tag == YrOfExpTxtFieldTag{
            
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
        
        //set the tag
        return cell
        
    }
    func textViewCell(indexPath: NSIndexPath,dataDict: NSDictionary) -> TextViewTableViewCell {
        
        let cell:TextViewTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "TextViewTableViewCellIdentifier") as! TextViewTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        let dict =  dataArray[indexPath.row] as! NSDictionary
        let placeholderString = dict["header"] as! String
        let tag =  dataDict["Tag"] as! String
        
        cell.entryTextView.tag = Int(tag)!
        cell.entryTextView.layer.borderColor = borderColor.cgColor
        cell.entryTextView.layer.borderWidth = 1
        cell.entryTextView.delegate = self
        
        cell.lblHeader.text = placeholderString
        self.activeTextView = cell.entryTextView
        
        if cell.entryTextView.tag == Int(PositionDutiesTxtViewTag){
            cell.entryTextView.text = PositionDutiesText
        }else  if cell.entryTextView.tag == Int(SkillsetBackgroundTxtViewTag){
            cell.entryTextView.text = SkillsetBackgroundText
        }else  if cell.entryTextView.tag == Int(TechnologySkillsetTxtViewTag){
            cell.entryTextView.text = TechnologySkillsetText
        }else  if cell.entryTextView.tag == Int(litigationTxtViewTag){
            cell.entryTextView.text = litigationMatterText
        }else  if cell.entryTextView.tag == Int(AdditionalExperienceRequiredTxtViewTag){
            cell.entryTextView.text = AdditionalExperienceRequiredText
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
        
        if textField.tag ==  Int(AttorneyNeededTextFieldTag)
        {
            
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            let isAllNumbers = allowedCharacters.isSuperset(of: characterSet)
            if isAllNumbers == true{
                
                let charsLimit = 3
                let startingLength = textField.text?.count ?? 0
                let lengthToAdd = string.count
                let lengthToReplace =  range.length
                let newLength = startingLength + lengthToAdd - lengthToReplace
                
                return newLength <= charsLimit
            }else{
                return false
            }
        }else if textField.tag == Int(TotalApprovedEFormExpenseTxtFieldTag){
            
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let decimalRegex = try! NSRegularExpression(pattern: "^\\d*\\.?\\d{0,2}$", options: [])
            let matches = decimalRegex.matches(in: newString, options: [], range: NSMakeRange(0, newString.count))
            if matches.count == 1
            {
                let charsLimit = 14
                let startingLength = textField.text?.count ?? 0
                let lengthToAdd = string.count
                let lengthToReplace =  range.length
                let newLength = startingLength + lengthToAdd - lengthToReplace
                
                return newLength <= charsLimit
            }
            return false
        }
        else
        {
            return true
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.tag == Int(AttorneyNeededTextFieldTag) || textField.tag == Int(MattershownonEFormTxtFieldTag) || textField.tag == Int(TotalApprovedEFormExpenseTxtFieldTag)  {
            
        }else if textField.tag == Int(YrOfExpTxtFieldTag) || textField.tag == Int(ReportToTxtFieldTag) || textField.tag == Int(TimeslipApproverTxtFieldTag) || textField.tag == Int(AltTimeslipApproverTxtFieldTag) || textField.tag == Int(ContactPersonTxtFieldTag) || textField.tag == Int(FindAttorneyWithSimilarSkillTxtFieldTag)
        {
            firstResponderTxtFieldTag = textField.tag
            var tag = 0
            var placeholder = ""
            if firstResponderTxtFieldTag == Int(FindAttorneyWithSimilarSkillTxtFieldTag){
                tag = bgSkillSetTblViewTag
                placeholder = "Find Attorney(s) with similar Background/Skillset to"
            }else if firstResponderTxtFieldTag == Int(ReportToTxtFieldTag){
                tag = ReportToTblViewTag
                placeholder = ReportToPlaceHolder
            }else if firstResponderTxtFieldTag == Int(YrOfExpTxtFieldTag){
                tag = YrsOfExpReqdTblViewTag
                placeholder = YrOfExpPlaceHolder
            }else if firstResponderTxtFieldTag == Int(TimeslipApproverTxtFieldTag){
                tag = TSApproverTblViewTag
                placeholder = TimeslipApproverPlaceHolder
            }else if firstResponderTxtFieldTag == Int(AltTimeslipApproverTxtFieldTag){
                tag = AltTSApproverTblViewTag
                placeholder = AltTimeslipApproverPlaceHolder
            }else if firstResponderTxtFieldTag == Int(ContactPersonTxtFieldTag)  {
                
                tag = ContactPersonTblViewTag
                placeholder = ContactPersonPlaceHolder
            }
            textField.resignFirstResponder()
            
            if placeholder.count == 0 {
                //Nothing to do
            }else{
                self.showDropDownWithTag(placeHolder: placeholder, tag: tag)
            }
            
        }else{
            textField.resignFirstResponder()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.preferredLocale()
            dateFormatter.dateFormat = dateFormat
            let todayDate = dateFormatter.string(from: Date())
            

            
            customCalendarView.calendar.appearance.selectionColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
            if textField.tag == Int(StartDateTxtFieldTag)! {
                 if StartDate.count == 0{
                    customCalendarView.calendar.appearance.todayColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
                    if todayDate == StartDate{
                    }else{
                        customCalendarView.calendar.appearance.titleSelectionColor = UIColor.black
                        customCalendarView.calendar.appearance.selectionColor = UIColor.clear
                    }
                }else{
                    
                    if todayDate == StartDate{
                    }else{
                        customCalendarView.calendar.appearance.todayColor = UIColor(hexString:"#EDEFF2")//bg circle
                    }
                    let date = self.convertDateStringToDefaultDate(dateString: StartDate, formatString: dateFormat)
//                    customPickerView.dtPickerView.date = date
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.customCalendarView.calendar.setCurrentPage(date, animated: true)
                        self.customCalendarView.calendar.select(date, scrollToDate: true)
                        
                    })
                }
//                customPickerView.dtPickerView.minimumDate = minDate
            }else if textField.tag == Int(EndDateTxtFieldTag)! {
                //set minimum date
                if StartDate.count == 0{
                    customCalendarView.calendar.appearance.todayColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
                }else{
                    if todayDate == StartDate{
                    }else{
                        customCalendarView.calendar.appearance.todayColor = UIColor(hexString:"#EDEFF2")//bg circle
                    }
                }
                if EndDate.count == 0{
                    customCalendarView.calendar.appearance.todayColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
                    customCalendarView.calendar.appearance.titleSelectionColor = UIColor.black
                    if todayDate == StartDate{
                    }else{
 
                        customCalendarView.calendar.appearance.selectionColor = UIColor.clear
                    }
                }else{
                    let date = self.convertDateStringToDefaultDate(dateString: EndDate, formatString: dateFormat)
//                    customPickerView.dtPickerView.date = date
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.customCalendarView.calendar.setCurrentPage(date, animated: true)
                        self.customCalendarView.calendar.select(date, scrollToDate: true)
                        
                    })
                    customCalendarView.calendar.appearance.selectionColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
                    if todayDate == StartDate{
                    }else{
                        customCalendarView.calendar.appearance.todayColor = UIColor(hexString:"#EDEFF2")//bg circle
                     }
                }
            }
            
            firstResponderTxtFieldTag = textField.tag
            if textField.tag == Int(EndDateTxtFieldTag)! || textField.tag == Int(StartDateTxtFieldTag)!{
                customPickerView.dtPickerView.datePickerMode = UIDatePicker.Mode.date
                self.customCalendarView.showPickerViewOnSuperView(superView: (self.navigationController?.view)!, isPortrait: self.isPortrait())

            }else{
                customPickerView.dtPickerView.datePickerMode = UIDatePicker.Mode.time
                customPickerView.showPickerViewOnSuperView(superView: (self.navigationController?.view)!, isDatePicker: true,minuteInterval: 0,isPortrait: self.isPortrait())
            }
        }
        return true
    }
    public func textFieldDidBeginEditing(_ textField: UITextField){
        self.activeField = textField
        self.activeTextView = nil
        if textField.tag == Int(AttorneyNeededTextFieldTag) || textField.tag == Int(MattershownonEFormTxtFieldTag) || textField.tag == Int(TotalApprovedEFormExpenseTxtFieldTag)  {
            textField.becomeFirstResponder()
            
        }else if textField.tag == Int(YrOfExpTxtFieldTag) || textField.tag == Int(ReportToTxtFieldTag) || textField.tag == Int(TimeslipApproverTxtFieldTag) || textField.tag == Int(AltTimeslipApproverTxtFieldTag) || textField.tag == Int(ContactPersonTxtFieldTag) || textField.tag == Int(FindAttorneyWithSimilarSkillTxtFieldTag)
        {
            textField.resignFirstResponder()
            
        }else{
            textField.resignFirstResponder()
            
        }
    }
    public func textFieldDidEndEditing(_ textField: UITextField){
        
        self.activeField = nil
        self.activeTextView = nil
        keyboardShowing = true
        if textField.tag == Int(AttorneyNeededTextFieldTag) || textField.tag == Int(MattershownonEFormTxtFieldTag)  {
            
            if textField.tag == Int(AttorneyNeededTextFieldTag) {
                
                if textField.text?.count == 0{
                    textField.text = ""
                }
                if textField.text?.isNumeric == true{
                    AttorneysNeeded =  textField.text!
                    
                }else{
                    AttorneysNeeded = ""
                    textField.text = ""
                }
                if AttorneysNeeded.count == 0{}else{
                    isValidAttorneysNeeded = true
                }
            }else if textField.tag == Int(MattershownonEFormTxtFieldTag){
                matterShownIneForm =  textField.text!
            }
        }else if textField.tag == Int(TotalApprovedEFormExpenseTxtFieldTag){
            ApprovedEFormExpense = textField.text!
            //               ApprovedEFormExpense =  String(format:"%.2f",Double(textField.text)!)
            print(ApprovedEFormExpense)
            self.tableView.reloadData()
            
        }
        self.tableView.reloadData()
    }
    
    //MARK: UITEXTVIEW Delegate
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        
        self.activeTextView = textView
        self.activeField = nil
        //        let pointInTable:CGPoint = textView.convert(CGPoint.zero, to: listTableView)
        //        var contentOffset:CGPoint = listTableView.contentOffset
        //        contentOffset.y  = pointInTable.y
        //        if let accessoryView = textView.inputAccessoryView {
        //            contentOffset.y -= accessoryView.frame.size.height
        //        }
        //        listTableView.contentOffset = contentOffset
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        keyboardShowing = true 
        self.activeTextView = nil
        self.activeField = nil
        if textView.tag == Int(PositionDutiesTxtViewTag){
            PositionDutiesText = textView.text
        }else if textView.tag == Int(SkillsetBackgroundTxtViewTag){
            SkillsetBackgroundText = textView.text
        }else if textView.tag == Int(TechnologySkillsetTxtViewTag){
            TechnologySkillsetText = textView.text
        }else if textView.tag == Int(litigationTxtViewTag){
            litigationMatterText = textView.text
        }else if textView.tag == Int(AdditionalExperienceRequiredTxtViewTag){
            AdditionalExperienceRequiredText = textView.text
        }
        view.endEditing(true)
        //        textView.resignFirstResponder()
        //        listTableView.reloadData()
        
        self.tableView.reloadData()
        
    }
    
    //MARK: Local Methods
    func resetAllDataForNewOrder(){
        
        
        AdditionalExperienceRequiredText = ""
        AttorneysNeeded = ""
        selectedReportTo = OCCReportToExp.init(Value: "", Text: "", isSelected: "0")
        selectedTSApprover = TimeSlipAppr.init(Value: "", Text: "", isSelected: "0")
        selectedAltTSApprover =  AltTimeSlipAppr.init(Value: "", Text: "", isSelected: "0")
        selectedYrsOfExpReqd = YearsOfExp.init(Value: "", Text: "", isSelected: "0")
        selectedbgSkillSet = Attorney.init(Value: "", Text: "", isSelected: "0")
        selectedContact =  Contact.init(Value: "", Text: "", isSelected: "0")
        
        EndDate = ""
        uploadedFileName = ""
        PositionDutiesText = ""
        SkillsetBackgroundText = ""
        TechnologySkillsetText = ""
        litigationMatterText = ""
        AdditionalExperienceRequiredText = ""
        StartDate = ""
        EndDate = ""
        AttorneysNeeded = ""
        matterShownIneForm = ""
        ApprovedEFormExpense = ""
        isEDNYSelected = false
        isSDNYSelected = false
        findAttWithSimilarSkill = false
        noMatterChecked = false
        occToRecriut = true
        IsNYBarAdmissionRequired = "Yes"
        dataArray  = NSMutableArray()
        TaskList = NSMutableArray()
        ReportToList = NSMutableArray()
        TimeSlipApprList  = NSMutableArray()
        AltTimeSlipApprList  = NSMutableArray()
        YearsOfExpList  = NSMutableArray()
        ContactList  = NSMutableArray()
        BackgroundAttorneyList  = NSMutableArray()
        EmployeeList  = NSMutableArray()
        AllEmployeeList  = NSMutableArray()
        selectedTaskList  = NSMutableArray()
        
        selectedEmployeeArray = NSMutableArray()
        SelectanyadditionaladmissionsrequiredList = NSMutableArray()
        
        
        dataArray.removeAllObjects()
        TaskList.removeAllObjects()
        ReportToList.removeAllObjects()
        TimeSlipApprList.removeAllObjects()
        AltTimeSlipApprList.removeAllObjects()
        YearsOfExpList.removeAllObjects()
        ContactList.removeAllObjects()
        BackgroundAttorneyList.removeAllObjects()
        EmployeeList .removeAllObjects()
        AllEmployeeList .removeAllObjects()
        selectedTaskList .removeAllObjects()
        
        selectedEmployeeArray.removeAllObjects()
        SelectanyadditionaladmissionsrequiredList.removeAllObjects()
        self.tableView.reloadData()
        //        TaskTableView.reloadData()
        empTableView.reloadData()
        
        
    }
    func formOrderSummaryData() -> NSMutableArray{
        
        var summaryDataArray = NSMutableArray()
        let yesBtnDict = SelectanyadditionaladmissionsrequiredList[0] as! NSDictionary
        let noBtnDict = SelectanyadditionaladmissionsrequiredList[1] as! NSDictionary
        
        var deptName = ""
        if isEDNYSelected == true{
            deptName =  (noBtnDict["Text"] as? String)!
        }
        if isSDNYSelected == true{
            deptName = String(format:"%@,%@",deptName,(yesBtnDict["Text"] as? String)!)
        }
        let taskNameArray = NSMutableArray()
        for obj in selectedTaskList{
            let eObj:Task = (obj as? Task)!
            let name = eObj.Text
            taskNameArray.add(name)
        }
        let SelectedTaskNames = taskNameArray.map({ String(describing: $0) }).joined(separator: ",")
        
        
        let employeeNameArray = NSMutableArray()
        
        
        for obj in EmployeeList{
            let eObj:NewEmployee = (obj as? NewEmployee)!
            let name = eObj.Name
            employeeNameArray.add(name)
        }
        let SelectedEmployeeNames = employeeNameArray.map({ String(describing: $0) }).joined(separator: "; ")
        
        var occToRecruitValue = "Yes"
        if occToRecriut == true{
            occToRecruitValue = "No"
        }
        var nomatter = ""
        let attachDocDict = ["Header":AttachEFormDocPlaceHolder.replace(target: "*", withString: ""),"Value":uploadedFileName]
        let totalApprvedDocDict = ["Header":TotalApprovedEFormExpensePlaceHolder.replace(target: "*", withString: ""),"Value":String(format:"$%@",ApprovedEFormExpense)]
        let matterShownNumDict = ["Header":"Matter # shown on E-Form","Value":matterShownIneForm]
        
        if noMatterChecked == true{
            nomatter = "Yes"
        }else{
            nomatter = "No"
        }
        let noMatterDict = ["Header":"No Matter #","Value":nomatter]
        
        let startDateDict =  ["Header":startDatePlaceHolder.replace(target: "*", withString: ""),"Value":StartDate]
        let endDateDict =  ["Header":endDatePlaceHolder.replace(target: "*", withString: ""),"Value":EndDate]
        
        let attorneyDict = ["Header":AttorneyNeededPlaceHolder.replace(target: "*", withString: ""),"Value":AttorneysNeeded]
        let isAdmissionReqdDict = ["Header":IsAdmissionReqdPlaceHolder,"Value":IsNYBarAdmissionRequired]
        let anyAdditionalAdmisnDict = ["Header": AnyAdditionalAdmisnPlaceHolder.replace(target: "*", withString: ""),"Value":deptName]
        let yrOfExpDict = ["Header":YrOfExpPlaceHolder.replace(target: "*", withString: ""),"Value":selectedYrsOfExpReqd.Text]
        let TaskDict = ["Header":TaskPlaceHolder.replace(target: "*", withString: ""),"Value":SelectedTaskNames]
        
        let PositionDutiesDict = ["Header":PositionDutiesPlaceHolder,"Value":PositionDutiesText]
        let SkillsetBackgroundDict = ["Header":SkillsetBackgroundPlaceHolder,"Value":SkillsetBackgroundText]
        let TechnologySkillsetDict = ["Header":TechnologySkillsetPlaceHolder,"Value":TechnologySkillsetText]
        let litigationMatterDict = ["Header":litigationMatterPlaceHolder,"Value":litigationMatterText]
        let AdditionalExperienceRequired = ["Header":AdditionalExperienceRequiredPlaceHolder,"Value":AdditionalExperienceRequiredText]
        
        let reportToDict = ["Header":ReportToPlaceHolder.replace(target: "*", withString: ""),"Value":selectedReportTo.Text]
        let TimeslipApproverDict = ["Header":TimeslipApproverPlaceHolder.replace(target: "*", withString: ""),"Value":selectedTSApprover.Text]
        let AltTimeslipApproverDict = ["Header":AltTimeslipApproverPlaceHolder.replace(target: "*", withString: ""),"Value":selectedAltTSApprover.Text ]
        let ContactPersonDict = ["Header":ContactPersonPlaceHolder.replace(target: "*", withString: ""),"Value":selectedContact.Text ]
        
        let reqstedPriorAttorneyDict = ["Header":"Requested Prior Temporary Attorney(s)","Value": SelectedEmployeeNames ]
        let attorneyWithSimilarBGSkillDict = ["Header":"Find Attorney(s) with similar Background/Skillset to","Value": selectedbgSkillSet.Text ]
        let occToRecruitDict = ["Header":"On Call Counsel To Recruit","Value": occToRecruitValue ]
        
        summaryDataArray = [attachDocDict,totalApprvedDocDict,matterShownNumDict,noMatterDict,startDateDict,endDateDict,attorneyDict,isAdmissionReqdDict,anyAdditionalAdmisnDict,yrOfExpDict,TaskDict,PositionDutiesDict,SkillsetBackgroundDict,TechnologySkillsetDict,litigationMatterDict,AdditionalExperienceRequired,reportToDict,TimeslipApproverDict,AltTimeslipApproverDict,ContactPersonDict,reqstedPriorAttorneyDict,attorneyWithSimilarBGSkillDict,occToRecruitDict]
        
        return summaryDataArray
    }
    
    func formCreateOrderObject(){
        
        let defaults = UserDefaults.standard
        
        let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
        let DivisionId = String(format:"%d", defaults.integer(forKey: "DivisionId"))
        
        var IsAdmRequired = "0"
        var OnCallToRecruit = "0"
        let employeeNameArray = NSMutableArray()
        let employeeIDArray = NSMutableArray()
        
        
        for obj in EmployeeList{
            let eObj:NewEmployee = (obj as? NewEmployee)!
            let name = eObj.Name
            employeeNameArray.add(name)
            employeeIDArray.add(String(format:"%d",eObj.CandidateId!))
        }
        
        
        let SelectedEmployeeNames = employeeNameArray.map({ String(describing: $0) }).joined(separator: "|")
        let SelectedEmployees = employeeIDArray.map({ String(describing: $0) }).joined(separator: "|")
        
        let taskNameArray = NSMutableArray()
        let taskIDArray = NSMutableArray()
        
        
        for obj in selectedTaskList{
            let eObj:Task = (obj as? Task)!
            let name = eObj.Text
            taskNameArray.add(name)
            taskIDArray.add(String(format:"%d",eObj.Id!))
        }
        
        
        let SelectedTaskNames = taskNameArray.map({ String(describing: $0) }).joined(separator: ",")
        let SelectedTaskIds = taskIDArray.map({ String(describing: $0) }).joined(separator: ",")
        
        if documentsArray.count>0
        {
            for doc in 0..<documentsArray.count
            {
                let docs = [ "DocFile" : documetBytes[doc],
                             "FileName" : self.documentsArray[doc],
                             "DocExtension" : self.fileExtensions[doc],
                             "DocDescription" : self.documentsArray[doc]]
                listOfDocuments.append(docs)
                break
            }
            
            
        }
        if IsNYBarAdmissionRequired == "Yes"{
            IsAdmRequired = "1"
        }
        
        if occToRecriut == true{
            OnCallToRecruit = "1"
        }
        let yesBtnDict = SelectanyadditionaladmissionsrequiredList[0] as! NSDictionary
        let noBtnDict = SelectanyadditionaladmissionsrequiredList[1] as! NSDictionary
        
        var deptName = ""
        var deptId = ""
        var NoMatter = "0"
        if isEDNYSelected == true{
            deptName =  (noBtnDict["Text"] as? String)!
            deptId = "1"
        }
        if isSDNYSelected == true{
            deptName = String(format:"%@,%@",deptName,(yesBtnDict["Text"] as? String)!)
            deptId = "1,2"
        }
        if noMatterChecked == true{
            NoMatter = "true"
        }else{
            NoMatter = "false"
        }
        createOrderObj =  [
            "listEFormDocUpload" :listOfDocuments,
            "OrderSourceName" : "iOS",
            "AdditionalExp": AdditionalExperienceRequiredText,
            "AlternateTimeApprover": selectedAltTSApprover.Value,
            "AlternateTimeApproverName" :selectedAltTSApprover.Text,
            "Attorneys" : AttorneysNeeded,
            "ClientId" : clientID,
            "ContactPerson" : selectedContact.Value,
            "ContactPersonName" : selectedContact.Text,
            "Department" : deptId,
            "DepartmentNames" : deptName,
            "Divid" : DivisionId,
            "EndDate" : EndDate,
            "FileName" : uploadedFileName,
            "IsAdmRequired" : IsAdmRequired,
            "MatterShown" : matterShownIneForm,
            "NatureOfCase" : litigationMatterText,
            "NoMatter" : NoMatter,
            "OnCallToRecruit" : OnCallToRecruit,
            "PositionDuties" : PositionDutiesText,
            "PriorAttorneys" : selectedbgSkillSet.Text,
            "ReportTo" : selectedReportTo.Value,
            "ReportToName" : selectedReportTo.Text,
            "SelectedEmployeeNames" : SelectedEmployeeNames,
            "SelectedEmployees" : SelectedEmployees,
            "SimSkillId" : selectedbgSkillSet.Value,
            "SimSkillName" : selectedbgSkillSet.Text,
            "SkillsetBackground" : SkillsetBackgroundText,
            "StartDate" : StartDate,
            "TaskIds" : SelectedTaskIds,
            "TaskNames" : SelectedTaskNames,
            "TaskOther" : "Other",
            "TechnologySkillset" : TechnologySkillsetText,
            "TimeslipApprover" : selectedTSApprover.Value,
            "TimeslipApproverName" : selectedTSApprover.Text,
            "TotalApproved" : ApprovedEFormExpense,
            "YearsOfExp" : selectedYrsOfExpReqd.Value,
            "YearsOfExpText" : selectedYrsOfExpReqd.Text]
        //PriorAttorneys
        print(createOrderObj)
    }
    func updateDatesFromPicker(dateString: String,forArray: NSMutableArray){
        var indexOfObj = -1
        var placeholderheader = ""
        
        //get the index of the object to replace
        //Date
        if firstResponderTxtFieldTag == Int(StartDateTxtFieldTag) || firstResponderTxtFieldTag == Int(EndDateTxtFieldTag) {
            placeholderheader = startDatePlaceHolder
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
                //                mutableDictObj["EndValue"] = dateString
                if EndDate.count == 0{
                    mutableDictObj["EndValue"] = dateString

                }else{
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale.preferredLocale()
                    dateFormatter.dateFormat = dateFormat
                    let dateA = dateFormatter.date(from: StartDate)
                    let dateB = dateFormatter.date(from: EndDate)
                    switch dateA?.compare(dateB!) {
                        
                    case .orderedAscending?     :
                        print("Date A is earlier than date B")
                    case .orderedDescending?    :
                        mutableDictObj["EndValue"] = dateString
                        EndDate = dateString
                    case .orderedSame?          :
                        print("The two dates are the same")
                    case .none: break
                    }
                }
                isMatches = true
                
            }
            if endTag == firstResponderTxtFieldTag {
                mutableDictObj["EndValue"] = dateString
                isMatches = true
            }
            if isMatches ==  true {
                forArray.replaceObject(at: indexOfObj, with: mutableDictObj)
            }
            self.tableView.reloadData()
        }
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
    func showDropDownWithTag( placeHolder: String,tag: Int){
        
        let modelName = UIDevice.current.modelName
        
        
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
    
    func validateData() -> Bool{
        
        
        //        var isValidMatterShownEForm = true
        //        var isValidAnyAdditionalAdmissionReqd = true
        //        var isValidFindAttorney = true
        if EmployeeList.count == 0 && selectedbgSkillSet.Text?.count == 0 && occToRecriut == true {
            
            isValidFindAttorney = false
        }else{
            isValidFindAttorney = true
        }
        //        if uploadedFileName.count == 0{
        //          isValidAttachment = false
        //        }else{
        //            isValidAttachment = true
        //        }
        
        if selectedTaskList.count == 0{
            isValidTaskList = false
        }else{
            isValidTaskList = true
        }
        
        if noMatterChecked == true{
            isValidMatterShownEForm = true
            
        }else{
            if matterShownIneForm.count == 0{
                isValidMatterShownEForm = false
            }else{
                isValidMatterShownEForm = true
            }
        }
        
        if ApprovedEFormExpense.count == 0{
            isValidEformExp = false
        }else{
            isValidEformExp = true
            
        }
        if StartDate.count == 0{
            
            isValidStartDate = false
        }else{
            isValidStartDate = true
            
        }
        if EndDate.count == 0{
            
            isValidEndDate = false
        }else{
            isValidEndDate = true
            
        }
        if AttorneysNeeded.count == 0{
            isValidAttorneysNeeded = false
        }else{
            if Int(AttorneysNeeded) == 0{
                isValidAttorneysNeeded = false
            }else{
                isValidAttorneysNeeded = true
            }
            
        }
        if selectedYrsOfExpReqd.Text?.count == 0{
            isValidYrOfExp = false
            
        }else{
            isValidYrOfExp = true
            
        }
        if selectedReportTo.Text?.count == 0{
            isValidReportTo = false
        }else{
            isValidReportTo = true
            
        }
        if selectedTSApprover.Text?.count == 0{
            isValidTSApprover = false
            
        }else{
            isValidTSApprover = true
            
        }
        if selectedAltTSApprover.Text?.count == 0{
            isValidAltTSApprover = false
        }else{
            isValidAltTSApprover = true
        }
        if selectedContact.Text?.count == 0{
            isValidContact = false
        }else{
            isValidContact = true
        }
        
        
        if isValidEformExp ==  true && isValidStartDate ==  true && isValidEndDate ==  true && isValidAttorneysNeeded ==  true && isValidYrOfExp == true && isValidReportTo == true && isValidTSApprover == true && isValidAltTSApprover == true && isValidContact == true && isValidFindAttorney == true  && isValidTaskList == true && isValidMatterShownEForm == true{
            
            allDataValidated = true
        }else {
            //            listTableView.setContentOffset(CGPoint.zero, animated: true)
            
            allDataValidated = false
        }
        self.tableView.reloadData()
        return allDataValidated
        
    }
    //MARK: Button Action
    //    @IBAction func stepperAction(sender: UIStepper) {
    
    @objc func nextButtonTapped(sender:UIButton){
        let isValidated = self.validateData()
        
        if isValidated == true{
            self.validateCreateOrderData()
        }else{
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Please enter all the mandatory fields  ", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
    }
    @objc func taskCellBtnTapped(sender:UIButton){
        
        
        
        //        let senderPosition  = sender.convert(CGPoint.zero, to: listTableView)
        //        let indexPath =  TaskTableView.indexPathForRow(at:senderPosition)
        //
        //        let task = TaskList[(indexPath?.row)!]
        //
        //        let  taskObj:Task = task as! Task
        //
        //
        //        let isSelecetd = taskObj.isChecked
        //
        //        if isSelecetd == "1"{
        //            taskObj.isChecked = "0"
        //            selectedTaskList.remove(taskObj)
        //
        //        }else{
        //            taskObj.isChecked = "1"
        //             selectedTaskList.add(taskObj)
        //        }
        //        listTableView.reloadData()
    }
    
    @objc func addReportToAction(sender:UIButton) {
        
        
        self.pushToAddReportToPage()
        
    }
    @objc func searchBtnTapped(sender:UIButton) {
        
        //push to search Employee page
        self.getSearchEmployee()
        
//        if AllEmployeeList.count > 0{
//            self.pushToSearchEmpListPage(dataArray: AllEmployeeList)
//            
//        }else{
//        }
        
    }
    @objc func findAttorneyBtnTapped(sender:UIButton) {
        
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
        findAttWithSimilarSkill = sender.isSelected
        self.tableView.reloadData()
    }
    @objc func occToRecruitBtnTapped(sender:UIButton) {
        
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
        occToRecriut = sender.isSelected
        self.tableView.reloadData()
    }
    @objc func moveUpBtnTapped(sender: UIButton){
        if selectedEmployeeArray == EmployeeList{
            //nothing to move up
        }else{
            
            var indexOfObj = -1
            
            let indexArray = NSMutableArray()
            for e in selectedEmployeeArray{
                let  eObj:NewEmployee = e as! NewEmployee
                let eObjCandID = eObj.CandidateId
                for emp in EmployeeList{
                    let  empObj:NewEmployee = emp as! NewEmployee
                    let empObjCandID = empObj.CandidateId
                    if eObjCandID == empObjCandID{
                        indexOfObj = EmployeeList.index(of: eObj)
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
                        swap(&EmployeeList[index], &EmployeeList[index - 1])
                    }
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.empTableView.reloadData()
                    })
                }
            }
            
        }//end of else
        
    }
    @objc func moveDownBtnTapped(sender: UIButton){
        if selectedEmployeeArray == EmployeeList{
            //nothing to move down
        }else{
            var indexOfObj = -1
            let indexArray = NSMutableArray()
            for e in selectedEmployeeArray{
                let  eObj:NewEmployee = e as! NewEmployee
                let eObjCandID = eObj.CandidateId
                for emp in EmployeeList{
                    let  empObj:NewEmployee = emp as! NewEmployee
                    let empObjCandID = empObj.CandidateId
                    if eObjCandID == empObjCandID{
                        indexOfObj = EmployeeList.index(of: eObj)
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
            
            if sortedArray.contains(EmployeeList.count - 1){
                //if any element is on down no need to move down again
            }else{
                //increase indexpath of array and reload tableview
                var index = -1
                for i  in sortedArray{
                    index = Int(String(describing: i))!
                    print(index)
                    if EmployeeList.count - 1 > index {
                        swap(&EmployeeList[index], &EmployeeList[index + 1])
                    }
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.empTableView.reloadData()
                    })
                }
            }
            
        }//end of else
    }
    
    @objc func deleteBtnTapped(sender:UIButton) {
        
        for emp in selectedEmployeeArray {
            
            let  empObj:NewEmployee = emp as! NewEmployee
            empObj.isSelected = "0"
            empObj.isCheckedInRoaster = "0"
            if EmployeeList.contains(empObj){
                EmployeeList.remove(empObj)
            }
        }
        
        selectedEmployeeArray.removeAllObjects()
        empTableView.reloadData()
        self.tableView.reloadData()
        
    }
    @objc func timeButtonTapped(sender:UIButton) {
        
        customPickerView.removePickerViewFromSuperView()
        
    }
    @objc func datePickerValueChanged(sender: UIDatePicker){
        
        let changedDate = sender.date
        //▿ 2017-10-29 11:20:00 +0000
        sender.locale = NSLocale(localeIdentifier: "en_US") as Locale
        
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        var  pickedDateString = formatter.string(from: changedDate as Date)
        
        if firstResponderTxtFieldTag == Int(StartDateTxtFieldTag) || firstResponderTxtFieldTag == Int(EndDateTxtFieldTag){
            self.updateDatesFromPicker(dateString: pickedDateString, forArray: dataArray)
            
        }
        self.tableView.reloadData()
    }
    @IBAction func stepperAction(sender: UIStepper) {
        
        //        stepperValue.text = "\(Int(stepper.value))"
        ApprovedEFormExpense = "\(Int(sender.value))"
        print(ApprovedEFormExpense)
        self.tableView.reloadData()
    }
    @objc func noMatterAction(sender: UIButton){
        if sender.isSelected == true{
            sender.isSelected = false
            
        }else{
            sender.isSelected = true
            //remove the textfield value
        }
        noMatterChecked = sender.isSelected
        self.tableView.reloadData()
    }
    @objc func yesBtnTapped(sender: UIButton){
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
        IsNYBarAdmissionRequired = "Yes"
        
        self.tableView.reloadData()
    }
    @objc func noBtnTapped(sender: UIButton){
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
            
        }
        IsNYBarAdmissionRequired = "No"
        
        self.tableView.reloadData()
    }
    @objc func SDNYBtnTapped(sender: UIButton){
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
        isSDNYSelected = sender.isSelected
        
        self.tableView.reloadData()
    }
    @objc func EDNYBtnTapped(sender: UIButton){
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
        
        isEDNYSelected = sender.isSelected
        self.tableView.reloadData()
    }
    @objc func keyboardDoneBtnTapped(sender: UIButton)  {
        self.view.endEditing(true)
    }
    @objc func uploadAttachmentBtnTapped(sender: UIButton){
        //Present iCloud Files
        showMenu()
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
        
//        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypeContent)], in: .import)
//        importMenu.delegate = self
//        importMenu.modalPresentationStyle = .fullScreen
//        self.present(importMenu, animated: true, completion: nil)
        
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
        uploadedFileName = urlPath.lastPathComponent
        //        if uploadedFileName.count == 0{}else{
        //            isValidAttachment = true}
        fileData = try! Data(contentsOf:urlPath)
        fileBytes = fileData.base64EncodedString()
        documentsArray.add(urlPath.lastPathComponent)
        documetBytes.add(fileBytes)
        fileExtensions.add(urlPath.lastPathComponent)
        self.tableView.reloadData()
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
    // MARK: - SERVER CALL
    //9700110286-arjun
    func validateCreateOrderData(){
        
        let isInternetAvailable =  self.isInternetAvailable()
        //
        if isInternetAvailable {
            //            JustHUD.shared.showInView(view: view)
            self.showLoading()
            
            var NoMatter = ""
            if noMatterChecked == true{
                NoMatter = "true"
            }else{
                NoMatter = "false"
            }
            let validationParam =   [
                "AttachApprovedEFormDocument" : uploadedFileName,
                "TotalApprovedEFormExpense" : ApprovedEFormExpense,
                "Startdate" : StartDate,
                "Enddate" : EndDate,
                "AttorneysNeeded" : AttorneysNeeded,
                "YearsofExperience" : selectedYrsOfExpReqd.Text,
                "ReportTo" : selectedReportTo.Text,
                "TimeslipApprover" : selectedTSApprover.Text,
                "AlternateTimeslipApprover" : selectedAltTSApprover.Text,
                "ContactPerson" : selectedContact.Text,
                "Matter": matterShownIneForm,
                "NoMatter" : NoMatter
            ]
            
            print(validationParam)
            
            let urlString = RestAPI.BaseUrl+RestAPI.OCCCreateOrderValidationURL
            //            JustHUD.shared.showInView(view: view)
            self.showLoading()
            
            RestAPI.postRequestWithToken(urlString: urlString, params: validationParam, callback: getResponseForValidateCreateOrder(response:))
            
        }else{
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            //            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
            
        }
        
    }
    func getROSData() {
        let isInternetAvailable =  self.isInternetAvailable()
        //
        if isInternetAvailable {
            //            JustHUD.shared.showInView(view: view)
            self.showLoading()
            
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let DivisionId = String(format:"%d", defaults.integer(forKey: "DivisionId"))
            
            let params :[String:String] = ["ClientID":clientID,"Divid":DivisionId]
            
            print(params)
            
            RestAPI.getROSOCCOrders(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getROSResponse(response:))
        }else{
            //
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
        
    }
    func getSearchEmployee(){
        let isInternetAvailable = self.isInternetAvailable()
        //
        if isInternetAvailable {
            //            JustHUD.shared.showInView(view: view)
            self.showLoading()
            
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            /*
             "StartDate":"07/30/2018",
             "EndDate": "07/30/2018",
             "Sortby":1
             */
            let params :[String:String] = ["ClientId" : clientID,"StartDate":StartDate,"EndDate":EndDate,"Sortby":"1"]
            print(params)
            RestAPI.getSearchEmpOCC(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getEmpHistoryResponse(response:))
            
        }else{
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    func getEmpHistoryResponse(response:AnyObject)->(){
        //        JustHUD.shared.hide()
        self.hideLoading()
        
        print(response)
        if response is String{
            //            lblNoData.isHidden = false
            //            self.ShowAlertMessage(message: response as! String, title: "")
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                
                let empHistory = object["OccModelList"].array
                AllEmployeeList.removeAllObjects()
                for dict in empHistory! {
                    
                    
                    let Weekly_Hours = String(format:"%.2f",dict["WeeklyHours"].doubleValue)
                    let YTD_Hours = String(format:"%.2f",dict["YTDHours"].doubleValue)
                    let Eval = String(format:"%d",dict["Eval"].intValue)
                    
                    let empObj = NewEmployee.init(CandidateId: dict["CandidateId"].intValue, Name: dict["Name"].stringValue, lastDate: dict["LastOrderDate"].stringValue, Weekly_Hours: Weekly_Hours, positions: dict["Position"].stringValue, Eval: Eval, YTD_Hours: YTD_Hours, isCheckedInRoaster:  "0",isSelected: "0",Photo: dict["Photo"].stringValue,Evaluation: dict["Evaluation"].doubleValue,DummyImagePath:dict["DummyImagePath"].stringValue,isfavourite:dict["isfavourite"].intValue,favColor:dict["FavoriteColor"].stringValue)
                    
                    AllEmployeeList.add(empObj)
                    
                }
                if AllEmployeeList.count > 0{
                    self.pushToSearchEmpListPage(dataArray: AllEmployeeList)
                }else{
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "No Employees found", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                }
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
            
        }
    }
    func getResponseForValidateCreateOrder(response:AnyObject)->()
    {
        //        JustHUD.shared.hide()
        self.hideLoading()
        print(response)
        if response is String{
            //            lblNoData.isHidden = false
            //            self.ShowAlertMessage(message: response as! String, title: "")
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                self.formCreateOrderObject()
                self.pushToOrderSummaryPage()
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                
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
            //            self.ShowAlertMessage(message: response as! String, title: "")
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
                
                //                nextButton.isHidden = false
                dataArray .removeAllObjects()
                if object["IsNYBarAdmissionRequired"].null == nil{
                    
                    IsNYBarAdmissionRequired = object["IsNYBarAdmissionRequired"].stringValue
                }
                if object["Selectanyadditionaladmissionsrequired"].null == nil{
                    let additionalAdmissionArray = object["Selectanyadditionaladmissionsrequired"].array
                    for dict in additionalAdmissionArray! {
                        SelectanyadditionaladmissionsrequiredList.add(["Text":dict["Text"].stringValue])
                    }
                    
                }
                if object["TaskList"].null == nil{
                    let TaskDataArray = object["TaskList"].array // as! NSMutableArray
                    for dict in TaskDataArray! {
                        
                        let taskObj = Task.init(Text: dict["Text"].stringValue, Id: dict["Id"].intValue, isChecked: "0")
                        TaskList.add(taskObj)
                        
                    }
                }
                if object["ReportToExpList"].null == nil{
                    let ReportToDataArray  = object["ReportToExpList"].array  //as! NSMutableArray
                    for dict in ReportToDataArray! {
                        
                        let reportToObj = OCCReportToExp.init(Value:  dict["Value"].stringValue, Text:  dict["Text"].stringValue, isSelected: "0")
                        ReportToList.add(reportToObj)
                    }
                }
                if object["TimeSlipApprList"].null == nil{
                    let TimeSlipApprDataArray = object["TimeSlipApprList"].array // as! NSMutableArray
                    for dict in TimeSlipApprDataArray! {
                        
                        let TSAObj = TimeSlipAppr.init(Value: dict["Value"].stringValue, Text: dict["Text"].stringValue, isSelected: "0")
                        TimeSlipApprList.add(TSAObj)
                    }
                }
                if object["TimeSlipApprList"].null == nil{
                    let TimeSlipApprDataArray = object["TimeSlipApprList"].array // as! NSMutableArray
                    for dict in TimeSlipApprDataArray! {
                        
                        let TSAObj = AltTimeSlipAppr.init(Value: dict["Value"].stringValue, Text: dict["Text"].stringValue, isSelected: "0")
                        AltTimeSlipApprList.add(TSAObj)
                    }
                }
                if object["ContactList"].null == nil{
                    let   ContactDataArray = object["ContactList"].array  //as! NSMutableArray
                    for dict in ContactDataArray! {
                        
                        let contactObj = Contact.init(Value: dict["Value"].stringValue, Text: dict["Text"].stringValue, isSelected: "0")
                        ContactList.add(contactObj)
                    }
                }
                if object["BackgroundAttorneyList"].null == nil{
                    let  BackgroundAttorneyDataArray = object["BackgroundAttorneyList"].array // as! NSMutableArray
                    for dict in BackgroundAttorneyDataArray! {
                        
                        let attorneyObj = Attorney.init(Value: dict["Value"].stringValue, Text: dict["Text"].stringValue, isSelected: "0")
                        BackgroundAttorneyList.add(attorneyObj)
                        
                    }
                }
                //                if object["EmployeeList"] != nil{
                //                    let  EmployeeDataArray = object["EmployeeList"].array // as! NSMutableArray
                //                    for dict in EmployeeDataArray! {
                //
                //                        let empObj = OCCEmployee.init(Id: dict["Value"].intValue, Name: dict["Name"].stringValue, LastDateWorked: dict["LastDateWorked"].stringValue, Position: dict["Position"].stringValue, Eval: dict["Eval"].stringValue, YTDHours: dict["YTDHours"].stringValue , isCheckedInRoaster: "0", isSelected: "0")
                //                        AllEmployeeList.add(empObj)
                //
                //                    }
                //                }
                
                if object["YearsOfExpList"].null == nil{
                    let  YearsOfExpDataArray = object["YearsOfExpList"].array // as! NSMutableArray
                    for dict in YearsOfExpDataArray! {
                        
                        let taskObj = YearsOfExp.init(Value:  dict["Value"].stringValue, Text:  dict["Text"].stringValue, isSelected: "0")
                        YearsOfExpList.add(taskObj)
                        
                    }
                }
                
                //9090579814 - pinky papa
                //9937752714 - dipu dada
                //health line , board school ,uper mahal
                self.formDataArrayForTableview()
                
                
                
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message =  Error_Message
                    
                }
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
    }
    
    func formDataArrayForTableview(){
        
        let attachDocDict = ["header":AttachEFormDocPlaceHolder,"type":"collectionView","showDropDown":"0"]
        let totalApprvedDocDict = ["header":TotalApprovedEFormExpensePlaceHolder,"type":"TextField","Tag": TotalApprovedEFormExpenseTxtFieldTag]
        let matterShownNumDict = ["header":MattershownonEFormPlaceHolder,"Tag": MattershownonEFormTxtFieldTag]
        let dateDict = ["header":startDatePlaceHolder,"subHeader":endDatePlaceHolder,"type":"Date Cell","showDropDown":"0","StartTag":StartDateTxtFieldTag,"EndTag":EndDateTxtFieldTag,"StartValue":"","EndValue":""]
        let attorneyDict = ["header":AttorneyNeededPlaceHolder,"Tag": AttorneyNeededTextFieldTag]
        let isAdmissionReqdDict = ["header":IsAdmissionReqdPlaceHolder]
        let anyAdditionalAdmisnDict = ["header": AnyAdditionalAdmisnPlaceHolder]
        let yrOfExpDict = ["header":YrOfExpPlaceHolder,"Tag": YrOfExpTxtFieldTag]
        let TaskDict = ["header":TaskPlaceHolder]
        
        let PositionDutiesDict = ["header":PositionDutiesPlaceHolder,"Tag": PositionDutiesTxtViewTag]
        let SkillsetBackgroundDict = ["header":SkillsetBackgroundPlaceHolder,"Tag": SkillsetBackgroundTxtViewTag]
        let TechnologySkillsetDict = ["header":TechnologySkillsetPlaceHolder,"Tag": TechnologySkillsetTxtViewTag]
        let litigationMatterDict = ["header":litigationMatterPlaceHolder,"Tag": litigationTxtViewTag]
        let AdditionalExperienceRequired = ["header":AdditionalExperienceRequiredPlaceHolder,"Tag": AdditionalExperienceRequiredTxtViewTag]
        
        let reportToDict = ["header":ReportToPlaceHolder,"Tag": ReportToTxtFieldTag]
        let TimeslipApproverDict = ["header":TimeslipApproverPlaceHolder,"Tag": TimeslipApproverTxtFieldTag]
        let AltTimeslipApproverDict = ["header":AltTimeslipApproverPlaceHolder,"Tag": AltTimeslipApproverTxtFieldTag ]
        let ContactPersonDict = ["header":ContactPersonPlaceHolder,"Tag": ContactPersonTxtFieldTag ]
        let findAttorneyDict = ["header":findAttorneyPlaceHolder ]
        let nextButtonDict = ["header":"Next" ]
        
        dataArray = [attachDocDict,totalApprvedDocDict,matterShownNumDict,dateDict,attorneyDict,isAdmissionReqdDict,anyAdditionalAdmisnDict,yrOfExpDict,TaskDict,PositionDutiesDict,SkillsetBackgroundDict,TechnologySkillsetDict,litigationMatterDict,AdditionalExperienceRequired,reportToDict,TimeslipApproverDict,AltTimeslipApproverDict,ContactPersonDict,findAttorneyDict,nextButtonDict]
        
        
        self.tableView.reloadData()
        
    }
    
    
    // MARK: - Navigation
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
            nextViewController.isForSchoolProfessional = false
            nextViewController.isForOCC = true
           
 
            for emp in dataArray {
                let  empObj:NewEmployee = emp as! NewEmployee
                if EmployeeList.count == 0{
                    empObj.isCheckedInRoaster = "0"
                }else{
                    for eObj in EmployeeList{
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
            
            nextViewController.delegate = self
            nextViewController.isForAddReportToOCC = true
            nextViewController.isForAddReportToOffice = false
            nextViewController.isForAddReportToLocationOffice = false
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
            nextViewController.OCC_CREATE_ORDER_FLAG = true
            nextViewController.summaryObj = createOrderObj
            nextViewController.summaryDataArray = self.formOrderSummaryData()
            nextViewController.status = "New"
            nextViewController.delegate = self
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
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
        
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        
        let pickedDateString = formatter.string(from: date)
        
        if firstResponderTxtFieldTag == Int(StartDateTxtFieldTag) || firstResponderTxtFieldTag == Int(EndDateTxtFieldTag){
            self.updateDatesFromPicker(dateString: pickedDateString, forArray: dataArray)
            
        }
        self.tableView.reloadData()

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

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //     // Get the new view controller using segue.destinationViewController.
    //     // Pass the selected object to the new view controller.
    //     }
    
}
