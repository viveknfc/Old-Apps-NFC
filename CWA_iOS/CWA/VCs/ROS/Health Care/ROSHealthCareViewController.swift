//
//  ROSHealthCareViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 06/03/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON
import FSCalendar

class ROSHealthCareViewController: BaseTableViewController,UITextFieldDelegate,UITextViewDelegate,HC_AddReportToDelegate,searchEmpDelegate,EditEmployeeOrderDelegate,SummaryDelegate,FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance {
    
    func HC_AddReportTo(_ reportToObj: ReportTo) {
        
        reportToList.add(reportToObj)
        selectedReportToList = reportToObj
        self.tableView.reloadData()
    }
    func createNewOrderFromSummary() {
        
        self.resetAll()
        self.getROSData()
        
    }
    
    func selecetdEmployee(_ emps: NSMutableArray)
    {
        if emps.count > 0{
            employeeArray.removeAllObjects()
            employeeArray = emps
            
            if employeeArray.count > 0 {
                //auto-check the check button
            }
            self.tableView.reloadData()
        }
    }
    func selectedEmployeeOrder(_ emps: NSMutableArray)
    {
        employeeArray = emps
        self.tableView.reloadData()
        
    }
    
    var keyboardShowing = false
    @IBOutlet var startDateView: UIView!
    @IBOutlet var startDateTxtField: UITextField!
    @IBOutlet var endDateView: UIView!
    @IBOutlet var endDateTxtField: UITextField!
    @IBOutlet var selectAllButton: UIButton!
    //    @IBOutlet var errorView: UIView!
    //    @IBOutlet var errorLbl: UILabel!
    
    var alrtController = UIAlertController()
    
    var isWarningmessage = false
    
    let SearchButtonCellIdentifier = "ButtonTableViewCellIdentifier"
    
    let NextButtonCellIdentifier = "NextTableViewCellIdentifier"
    var summaryJSON = NSDictionary()
    
    var profileList = NSMutableArray()
    var shiftList = NSMutableArray()
    var reportToList = NSMutableArray()
    var dataArray = NSMutableArray()
    
    var AllEmployeeArray = NSMutableArray()
    var employeeArray = NSMutableArray()
    var orderList = NSMutableArray()
    var summaryObjs = NSMutableArray()
    var WeekendingList  = NSMutableArray()
    var customPickerView = JPPickerView()
    var customCalendarView = CalendarView()

    let  MainTblViewTag =  1001
    let  reportToTblViewTag =  1002
    let emp_cmt_text_view_tag = "1008"
    let div_cmt_text_view_tag = "1009"
    var TappedTextFieldIndex = -1
    var firstResponderTxtFieldTag = 0
    let reportToTextFieldTag = 701
    let StartDateTextFieldTag = 702
    let EndDateTextFieldTag = 703
    var dayNumberIndex = 6
    let MONDefaultEndTimeTextFieldTag =   "100"
    let MONDefaultStartTimeTextFieldTag = "200"
    let MONDefaultShiftTextFieldTag =     "300"
    let MONDefaultProfileTextFieldTag =   "400"
    let MONDefaultEmpNumTextFieldTag =    "500"
    let MONDefaultDayNumber =    "0"
    
    
    let TUEDefaultEndTimeTextFieldTag =    "1000"
    let TUEDefaultStartTimeTextFieldTag =  "2000"
    let TUEDefaultShiftTextFieldTag =      "3000"
    let TUEDefaultProfileTextFieldTag =    "4000"
    let TUEDefaultEmpNumTextFieldTag =     "5000"
    let TUEDefaultDayNumber =    "1"
    
    let WEDDefaultEndTimeTextFieldTag =    "10000"
    let WEDDefaultStartTimeTextFieldTag =  "20000"
    let WEDDefaultShiftTextFieldTag =      "30000"
    let WEDDefaultProfileTextFieldTag =    "40000"
    let WEDDefaultEmpNumTextFieldTag =     "50000"
    let WEDDefaultDayNumber =    "2"
    
    let THUDefaultEndTimeTextFieldTag =    "100000"
    let THUDefaultStartTimeTextFieldTag =  "200000"
    let THUDefaultShiftTextFieldTag =      "300000"
    let THUDefaultProfileTextFieldTag =    "400000"
    let THUDefaultEmpNumTextFieldTag =     "500000"
    let THUDefaultDayNumber =    "3"
    
    let FRIDefaultEndTimeTextFieldTag =    "1000000"
    let FRIDefaultStartTimeTextFieldTag =  "2000000"
    let FRIDefaultShiftTextFieldTag =      "3000000"
    let FRIDefaultProfileTextFieldTag =    "4000000"
    let FRIDefaultEmpNumTextFieldTag =     "5000000"
    let FRIDefaultDayNumber =    "4"
    
    let SATDefaultEndTimeTextFieldTag =     "10000000"
    let SATDefaultStartTimeTextFieldTag =   "20000000"
    let SATDefaultShiftTextFieldTag =       "30000000"
    let SATDefaultProfileTextFieldTag =     "40000000"
    let SATDefaultEmpNumTextFieldTag =      "50000000"
    let SATDefaultDayNumber =    "5"
    
    let SUNDefaultEndTimeTextFieldTag =      "100000000"
    let SUNDefaultStartTimeTextFieldTag =    "200000000"
    let SUNDefaultShiftTextFieldTag =        "300000000"
    let SUNDefaultProfileTextFieldTag =      "400000000"
    let SUNDefaultEmpNumTextFieldTag =       "500000000"
    let SUNDefaultDayNumber =    "6"
    
    
    var selectedReportToList = ReportTo.init(ContactId: 0, Name: "", isSelected: "0")
    
    
    var isValidReportTo = true
    var StartDate = ""
    var EndDate = ""
    var minuteInterval = 0
    var empComments = ""
    var divComments = ""
    
    //MARK: UITableView Methods
    
    override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tagString = String(format:"%d",firstResponderTxtFieldTag)
        
        if (tagString.prefix(1) == "3" || tagString.prefix(1) == "4" || tableView.tag == reportToTblViewTag ) && (tableView.tag != MainTblViewTag){
            
            if tagString.prefix(1) == "3"{
                return shiftList.count
            }else if tagString.prefix(1) == "4"{
                return profileList.count
            }
            if tableView.tag == reportToTblViewTag{
                return reportToList.count
            }
        }else if tableView.tag == MainTblViewTag{
            return dataArray.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        if tableView.tag == reportToTblViewTag || tableView.tag == ShiftTblViewTag || tableView.tag == profileTblViewTag {
        
        let tagString = String(format:"%d",firstResponderTxtFieldTag)
        
        if (tagString.prefix(1) == "3" || tagString.prefix(1) == "4" || tableView.tag == reportToTblViewTag ) && (tableView.tag != MainTblViewTag){
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?
            if !(cell != nil) {
                cell = UITableViewCell(style:.subtitle, reuseIdentifier: "CELL")
            }
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            if tableView.tag == reportToTblViewTag{
                if reportToList.count  > indexPath.row{
                    
                    let obj = reportToList[indexPath.row]
                    
                    let  o:ReportTo = obj as! ReportTo
                    cell?.textLabel?.text = o.Name
                    if o.isSelected == "1"{
                        cell?.accessoryType = .checkmark
                    }else{
                        cell?.accessoryType = .none
                    }
                }
            }else if tagString.prefix(1) == "3"{
                if shiftList.count  > indexPath.row{
                    
                    let obj = shiftList[indexPath.row]
                    
                    let  o:HealthCareShift = obj as! HealthCareShift
                    cell?.textLabel?.text = o.Name
                    //                    if o.isSelected == "1"{
                    //                        cell?.accessoryType = .checkmark
                    //                    }else{
                    //                        cell?.accessoryType = .none
                    //                    }
                }
            }else if  tagString.prefix(1) == "4"{
                if profileList.count  > indexPath.row{
                    let obj = profileList[indexPath.row]
                    
                    let  o:HealthCareProfile = obj as! HealthCareProfile
                    cell?.textLabel?.text = o.Description
                    //                    if o.isSelected == "1"{
                    //                        cell?.accessoryType = .checkmark
                    //                    }else{
                    //                        cell?.accessoryType = .none
                    //                    }
                    
                    
                }
            }
            return cell!
            
        }else{
            
            if tableView.tag == MainTblViewTag{
                
                let dict =  dataArray[indexPath.row] as! NSDictionary
                let placeholder = dict["header"] as! String
                
                if placeholder == "MON" || placeholder == "TUE" || placeholder == "WED" || placeholder == "THU" || placeholder == "FRI" || placeholder == "SAT" || placeholder == "SUN"{
                    
                    return self.healthCareShiftCell(indexPath: indexPath as NSIndexPath)
                }else if placeholder.contains("Comment"){
                    return self.textViewCell(indexPath: indexPath as NSIndexPath, dataDict: dict)
                }else if placeholder.contains("Report"){
                    return  self.TextFieldCell(dataDict: dict, indexPath: indexPath as NSIndexPath)
                }else if placeholder.contains("Search"){
                    return self.ButtonTableCell(indexPath: indexPath as NSIndexPath,identifier: SearchButtonCellIdentifier)
                }else if placeholder == "Next"{
                    return self.ButtonTableCell(indexPath: indexPath as NSIndexPath,identifier: NextButtonCellIdentifier)
                }
                
            }
            
        }
        return UITableViewCell()
        
    }
    override   public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView.tag == MainTblViewTag{
            
            let dict =  dataArray[indexPath.row] as! NSDictionary
            let placeholder = dict["header"] as! String
            
            if placeholder == "MON" || placeholder == "TUE" || placeholder == "WED" || placeholder == "THU" || placeholder == "FRI" || placeholder == "SAT" || placeholder == "SUN"{
                
                return 130
                
            }else if placeholder.contains("Comment"){
                return 130
            }else if placeholder.contains("Report"){
                return 90
            }else if placeholder.contains("Search"){
                return 170
            }else if placeholder == "Next"{
                return 80
            }
            
        }
        
        return 50
        
    }
    override  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if tableView.tag == reportToTblViewTag{
            
            let reportTo = reportToList[(indexPath.row)]
            
            let  reportToObj:ReportTo = reportTo as! ReportTo
            
            let isSelected = reportToObj.isSelected
            
            if isSelected == "1"{
                reportToObj.isSelected = "0"
            }else{
                reportToObj.isSelected = "1"
            }
            selectedReportToList = reportToObj
            isValidReportTo = true
            reportToList.replaceObject(at: indexPath.row, with: reportToObj)
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
            
            //            tAlertController.dismiss(animated: true, completion: nil)
        }else{
            let tagString = String(format:"%d",firstResponderTxtFieldTag)
            
            if  tagString.prefix(1) == "3"{
                
                let obj = shiftList[indexPath.row]
                let  o:HealthCareShift = obj as! HealthCareShift
                
                let isSelected = o.isSelected
                for obj in shiftList{
                    let shiftObj:HealthCareShift = obj as! HealthCareShift
                    shiftObj.isSelected = "0"
                }
                if isSelected == "1"{
                    o.isSelected = "0"
                }else{
                    o.isSelected = "1"
                }
                //get the index of the object from dataArray
                
                var indexOfObj = -1
                for DayDict in dataArray{
                    let  dictObj = DayDict as! NSDictionary
                    let dayShiftTag = dictObj["ShiftTag"] as! String
                    if dayShiftTag == tagString{
                        indexOfObj = dataArray.index(of: dictObj)
                        break
                    }
                    
                }
                
                let di = dataArray[indexOfObj] as! NSDictionary
                let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: di)
                mutableDictObj["Shift"] = o.Name
                mutableDictObj["StartTime"] = o.startTime
                mutableDictObj["EndTime"] = o.EndTime
                if indexOfObj > -1{
                    dataArray.replaceObject(at: indexOfObj, with: mutableDictObj)
                }
                shiftList.replaceObject(at: indexPath.row, with: o)
                //                tAlertController.dismiss(animated: true, completion: nil)
                self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                
            }else if  tagString.prefix(1) == "4"{
                let obj = profileList[indexPath.row]
                let  o:HealthCareProfile = obj as! HealthCareProfile
                
                let isSelected = o.isSelected
                for obj in profileList{
                    let shiftObj:HealthCareProfile = obj as! HealthCareProfile
                    shiftObj.isSelected = "0"
                }
                if isSelected == "1"{
                    o.isSelected = "0"
                }else{
                    o.isSelected = "1"
                }
                //get the index of the object from dataArray
                
                var indexOfObj = -1
                for DayDict in dataArray{
                    let  dictObj = DayDict as! NSDictionary
                    let dayShiftTag = dictObj["ProfileTag"] as! String
                    if dayShiftTag == tagString{
                        indexOfObj = dataArray.index(of: dictObj)
                        break
                    }
                    
                }
                let di = dataArray[indexOfObj] as! NSDictionary
                let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: di)
                mutableDictObj["Profile"] = o.Description
                mutableDictObj["ProfileID"] = o.ProfileId
                if indexOfObj > -1{
                    dataArray.replaceObject(at: indexOfObj, with: mutableDictObj)
                }
                profileList.replaceObject(at: indexPath.row, with: o)
                //                tAlertController.dismiss(animated: true, completion: nil)
                self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                
            }
        }
        firstResponderTxtFieldTag = 0
        
        self.tableView.reloadData()
        
    }
    
    //MARK: TextField Delegate
    public func textFieldDidEndEditing(_ textField: UITextField){
        
        keyboardShowing = true
        if firstResponderTxtFieldTag == StartDateTextFieldTag || firstResponderTxtFieldTag == EndDateTextFieldTag{
            
        }else{
            let senderPosition  = textField.convert(CGPoint.zero, to: self.tableView)
            
            let indexPath =  self.tableView.indexPathForRow(at:senderPosition)
            
            let  dict = dataArray[(indexPath?.row)!] as! NSDictionary
            let placeholder = dict["header"] as! String
            
            if placeholder.contains("Report"){
                
            }else{
                let EmpNumTag = dict["EmpNumTag"] as! String
                
                if textField.tag == Int(EmpNumTag) {
                    
                    let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dict)
                    if textField.tag == Int(EmpNumTag) {
                        mutableDictObj["EmpNum"] = textField.text
                    }
                    dataArray.replaceObject(at: (indexPath?.row)!, with: mutableDictObj)
                    self.tableView.reloadData()
                }
                
            }
            
        }
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        firstResponderTxtFieldTag = textField.tag
        
        if firstResponderTxtFieldTag == StartDateTextFieldTag || firstResponderTxtFieldTag == EndDateTextFieldTag{
            //show datepicker
            self.view.endEditing(true)
            textField.resignFirstResponder()
        }else{
            let senderPosition  = textField.convert(CGPoint.zero, to: self.tableView)
            
            let indexPath =  self.tableView.indexPathForRow(at:senderPosition)
            
            let  dict = dataArray[(indexPath?.row)!] as! NSDictionary
            
            if firstResponderTxtFieldTag == reportToTextFieldTag{
                self.view.endEditing(true)
                textField.resignFirstResponder()
            }else{
                
                let ShiftTag = dict["ShiftTag"] as! String
                let ProfileTag = dict["ProfileTag"] as! String
                let StartTimeTag = dict["StartTimeTag"] as! String
                let EmpNumTag = dict["EmpNumTag"] as! String
                let EndTimeTag = dict["EndTimeTag"] as! String
                
                if textField.tag == Int(StartTimeTag) || textField.tag == Int(EndTimeTag){
                    self.view.endEditing(true)
                    
                    textField.resignFirstResponder()
                    //show time picker
                    
                }else if textField.tag == Int(ShiftTag) {
                    self.view.endEditing(true)
                    
                    textField.resignFirstResponder()
                    //show dropdown
                    
                    
                }else if  textField.tag == Int(ProfileTag){
                    self.view.endEditing(true)
                    
                    textField.resignFirstResponder()
                    
                    
                }else if textField.tag == Int(EmpNumTag) {
                    //show KB
                    //                    textField.becomeFirstResponder()
                    
                }
            }
        }
        ////
        
        
        
        return true
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let senderPosition  = textField.convert(CGPoint.zero, to: self.tableView)
        let indexPath =  self.tableView.indexPathForRow(at:senderPosition)
        let  dict = dataArray[(indexPath?.row)!] as! NSDictionary
        _ = dict["header"] as! String
        
        if firstResponderTxtFieldTag == reportToTextFieldTag || firstResponderTxtFieldTag == StartDateTextFieldTag || firstResponderTxtFieldTag == EndDateTextFieldTag{
       
        }else{
            
            let ShiftTag = dict["ShiftTag"] as! String
            let ProfileTag = dict["ProfileTag"] as! String
            let StartTimeTag = dict["StartTimeTag"] as! String
            let EmpNumTag = dict["EmpNumTag"] as! String
            let EndTimeTag = dict["EndTimeTag"] as! String
            
            if textField.tag == Int(StartTimeTag) || textField.tag == Int(EndTimeTag) || textField.tag == Int(ShiftTag) || textField.tag == Int(ProfileTag){
            }else if textField.tag == Int(EmpNumTag) {
                //show KB
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
        }
        return true
    }
    public func textFieldDidBeginEditing(_ textField: UITextField){
        firstResponderTxtFieldTag = textField.tag
        
        if firstResponderTxtFieldTag == StartDateTextFieldTag || firstResponderTxtFieldTag == EndDateTextFieldTag{
            //show datepicker
            self.view.endEditing(true)
            self.showPickerForDateAndTime(textField: textField)
            
        }else{
            let senderPosition  = textField.convert(CGPoint.zero, to: self.tableView)
            
            let indexPath =  self.tableView.indexPathForRow(at:senderPosition)
            
            let  dict = dataArray[(indexPath?.row)!] as! NSDictionary
            let placeholder = dict["header"] as! String
            
            if firstResponderTxtFieldTag == reportToTextFieldTag{
                textField.resignFirstResponder()
                self.view.endEditing(true)
                self.showDropDownWithTag(placeHolder: placeholder, tag: reportToTblViewTag)
            }else{
                
                let ShiftTag = dict["ShiftTag"] as! String
                let ProfileTag = dict["ProfileTag"] as! String
                let StartTimeTag = dict["StartTimeTag"] as! String
                let EmpNumTag = dict["EmpNumTag"] as! String
                let EndTimeTag = dict["EndTimeTag"] as! String
                
                if textField.tag == Int(StartTimeTag) || textField.tag == Int(EndTimeTag){
                    textField.resignFirstResponder()
                    //show time picker
                    TappedTextFieldIndex = (indexPath?.row)!
                    self.view.endEditing(true)
                    self.showPickerForDateAndTime(textField: textField)
                    
                }else if textField.tag == Int(ShiftTag) {
                    textField.resignFirstResponder()
                    //show dropdown
                    self.view.endEditing(true)
                    self.showDropDownWithTag(placeHolder: "Shift", tag: Int(ShiftTag)!)
                    
                }else if  textField.tag == Int(ProfileTag){
                    textField.resignFirstResponder()
                    self.view.endEditing(true)
                    self.showDropDownWithTag(placeHolder: "Profile", tag: Int(ProfileTag)!)
                    
                }else if textField.tag == Int(EmpNumTag) {
                    //show KB
                    textField.becomeFirstResponder()
                }
            }
        }
        
    }
    
    
    //MARK: UITEXTVIEW Delegate
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        
        
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        keyboardShowing = true
        if textView.tag == Int(emp_cmt_text_view_tag){
            empComments = textView.text
            
        }else if textView.tag == Int(div_cmt_text_view_tag){
            divComments = textView.text
            
        }
        
        view.endEditing(true)
        
        self.tableView.reloadData()
        
    }
    //MARK: Custom Cell
    func ButtonTableCell(indexPath: NSIndexPath,identifier: String) -> ButtonTableViewCell {
        
        let cell:ButtonTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: identifier) as! ButtonTableViewCell
        if identifier == NextButtonCellIdentifier{
            cell.dButton.removeTarget(self, action:#selector(self.nextButtonTapped), for: .touchUpInside)
            cell.dButton.addTarget(self, action:#selector(self.nextButtonTapped), for: .touchUpInside)
            
        }else if identifier == SearchButtonCellIdentifier{
            cell.dButton.removeTarget(self, action:#selector(self.searchBtnTapped), for: .touchUpInside)
            cell.dButton.addTarget(self, action:#selector(self.searchBtnTapped), for: .touchUpInside)
            
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
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
        cell.lblHeader.text = placeholder
        cell.entryTextField.tag = reportToTextFieldTag
        cell.entryTextField.delegate = self
        cell.btnBGView.layer.borderWidth = 1
        cell.btnBGView.layer.borderColor = borderColor.cgColor
        if isValidReportTo == true{
            cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.clear)
        }else{
            cell.lblHeader.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.red)
            cell.btnBGView.layer.borderColor = UIColor.red.cgColor
            //set the tag
        }
        cell.addButton.removeTarget(self, action:#selector(self.addReportToBtnTapped), for: .touchUpInside)
        cell.addButton.addTarget(self, action:#selector(self.addReportToBtnTapped), for: .touchUpInside)
        cell.entryTextField.text = selectedReportToList.Name
        self.addRightImageToTextField(textField: cell.entryTextField, imageName: "expand-arrow")
        
        return cell
    }
    
    
    func textViewCell(indexPath: NSIndexPath,dataDict: NSDictionary) -> TextViewTableViewCell {
        
        let cell:TextViewTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "TextViewTableViewCellIdentifier") as! TextViewTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        let dict =  dataArray[indexPath.row] as! NSDictionary
        let placeholderString = dict["header"] as! String
        
        cell.entryTextView.layer.borderColor = borderColor.cgColor
        cell.entryTextView.layer.borderWidth = 1
        cell.entryTextView.delegate = self
        cell.lblHeader.text = placeholderString
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(keyboardDoneBtnTapped))]
        toolBar.sizeToFit()
        if placeholderString == "Additional Comments for Employees"{
            cell.entryTextView.tag = Int(emp_cmt_text_view_tag)!
            cell.entryTextView.text = empComments
            
        }else{
            cell.entryTextView.tag = Int(div_cmt_text_view_tag)!
            cell.entryTextView.text = divComments
            
        }
        
        
        
        cell.entryTextView.inputAccessoryView = toolBar
        return cell
        
    }
    func healthCareShiftCell(indexPath: NSIndexPath) -> HealthCareShiftTableViewCell {
        
        let cell:HealthCareShiftTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "HealthCareShiftTableViewCellIdentifier") as! HealthCareShiftTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        self.addDropDownShadowToView(shadowView: cell.centerView)
        self.addBorderToView(viewT:cell.shiftView)
        self.addBorderToView(viewT:cell.profileView)
        self.addBorderToView(viewT:cell.endView)
        self.addBorderToView(viewT:cell.startView)
        self.addBorderToView(viewT:cell.empNumTextField)
        
        
        
        self.addRightImageToTextField(textField: cell.endTextField, imageName: "Timeslips")
        self.addRightImageToTextField(textField: cell.startTextField, imageName: "Timeslips")
        self.addRightImageToTextField(textField: cell.shiftTxtField, imageName: "expand-arrow")
        self.addRightImageToTextField(textField: cell.profileTxtField, imageName: "expand-arrow")
        
        cell.addShiftBtn.removeTarget(self, action:#selector(self.addShiftBtnTapped), for: .touchUpInside)
        cell.clearBtn.removeTarget(self, action:#selector(self.clearBtnTapped), for: .touchUpInside)
        cell.removeBtn.removeTarget(self, action:#selector(self.removeBtnTapped), for: .touchUpInside)
        cell.searchEmpBtn.removeTarget(self, action:#selector(self.cellSearchBtnTapped), for: .touchUpInside)
        cell.daySelectionBtn.removeTarget(self, action:#selector(self.checkDayBtnTapped), for: .touchUpInside)
        cell.reqstedEmpBtn.removeTarget(self, action:#selector(self.reqstedEmpBtnTapped), for: .touchUpInside)
        
        
        cell.addShiftBtn.addTarget(self, action:#selector(self.addShiftBtnTapped), for: .touchUpInside)
        cell.clearBtn.addTarget(self, action:#selector(self.clearBtnTapped), for: .touchUpInside)
        cell.removeBtn.addTarget(self, action:#selector(self.removeBtnTapped), for: .touchUpInside)
        cell.searchEmpBtn.addTarget(self, action:#selector(self.cellSearchBtnTapped), for: .touchUpInside)
        cell.daySelectionBtn.addTarget(self, action:#selector(self.checkDayBtnTapped), for: .touchUpInside)
        cell.reqstedEmpBtn.addTarget(self, action:#selector(self.reqstedEmpBtnTapped), for: .touchUpInside)
        
        let  dict = dataArray[(indexPath.row)] as! NSDictionary
        let placeholder = dict["header"] as! String
        let isSelected = dict["isSelected"] as! String
        
        let ShiftTag = dict["ShiftTag"] as! String
        let ProfileTag = dict["ProfileTag"] as! String
        let StartTimeTag = dict["StartTimeTag"] as! String
        let EmpNumTag = dict["EmpNumTag"] as! String
        let EndTimeTag = dict["EndTimeTag"] as! String
        
        let ShiftValue = dict["Shift"] as! String
        let ProfileValue = dict["Profile"] as! String
        let StartTimeValue = dict["StartTime"] as! String
        let EmpNumValue = dict["EmpNum"] as! String
        let EndTimeValue = dict["EndTime"] as! String
        
        cell.removeBtn.backgroundColor = UIColor.red
        cell.removeBtn.setTitle("Remove", for: .normal)
        cell.removeBtn.setTitleColor(UIColor.white, for: .normal)
        
        if ShiftTag == MONDefaultShiftTextFieldTag || ShiftTag == TUEDefaultShiftTextFieldTag  || ShiftTag == WEDDefaultShiftTextFieldTag  || ShiftTag == THUDefaultShiftTextFieldTag  || ShiftTag == FRIDefaultShiftTextFieldTag  || ShiftTag == SATDefaultShiftTextFieldTag  || ShiftTag == SUNDefaultShiftTextFieldTag {
            //main cell.so no need of remove button
            cell.removeBtn.isHidden = true
            if employeeArray.count == 0{
                cell.reqstedEmpBtn.isHidden = true
            }else{
                if isSelected == "0" {
                    cell.reqstedEmpBtn.isHidden = true
                }else{
                    cell.reqstedEmpBtn.isHidden = true
                    //make remove button to emp Reqst Butn. and add target to that button
                    cell.removeBtn.isHidden = false
                    cell.removeBtn.backgroundColor = UIColor.clear
                    cell.removeBtn.setTitle("Employees Requested", for: .normal)
                    cell.removeBtn.setTitleColor(UIColor(hexString:"438BCA"), for: .normal)//438BCA
                    cell.removeBtn.removeTarget(self, action:#selector(self.removeBtnTapped), for: .touchUpInside)
                    cell.removeBtn.addTarget(self, action:#selector(self.reqstedEmpBtnTapped), for: .touchUpInside)
                }
            }
        }else{
            cell.removeBtn.isHidden = false
            if employeeArray.count == 0{
                cell.reqstedEmpBtn.isHidden = true
            }else{
                if isSelected == "0" {
                    cell.reqstedEmpBtn.isHidden = true
                }else{
                    cell.reqstedEmpBtn.isHidden = false
                }
            }
            
        }
        
        if isSelected == "0"{
            cell.daySelectionBtn.isSelected = false
        }else{
            cell.daySelectionBtn.isSelected = true
        }
        
        
        //        cell.daySelectionBtn.setTitle(placeholder, for: .normal)
        cell.lblDay.text = placeholder
        cell.empNumTextField.tag = Int(EmpNumTag)!
        cell.endTextField.tag = Int(EndTimeTag)!
        cell.startTextField.tag = Int(StartTimeTag)!
        cell.shiftTxtField.tag = Int(ShiftTag)!
        cell.profileTxtField.tag = Int(ProfileTag)!
        
        cell.empNumTextField.text = EmpNumValue
        cell.endTextField.text = EndTimeValue
        cell.startTextField.text = StartTimeValue
        cell.shiftTxtField.text = ShiftValue
        cell.profileTxtField.text = ProfileValue
        
        cell.profileTxtField.delegate = self
        cell.startTextField.delegate = self
        cell.endTextField.delegate = self
        cell.shiftTxtField.delegate = self
        cell.empNumTextField.delegate = self
        cell.empNumTextField.keyboardType = .numberPad
        cell.daySelectionView.backgroundColor =   UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
        return cell
        
    }
    
    func addBorderToView(viewT: UIView){
        
        viewT.layer.borderColor = borderColor.cgColor
        viewT.layer.borderWidth = 1
        
    }
    
    //MARK: View Methods
    //
    //    override func viewDidLayoutSubviews() {
    //        if let rect = self.navigationController?.navigationBar.frame {
    //            let y = rect.size.height + rect.origin.y
    //            self.tableView.contentInset = UIEdgeInsetsMake( y, 0, 0, 0)
    //        }
    //    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.titlelbl.text = "Rapid Order System"
    }
    func resetAll(){
        
        profileList.removeAllObjects()
        shiftList.removeAllObjects()
        reportToList.removeAllObjects()
        dataArray.removeAllObjects()
        
        AllEmployeeArray.removeAllObjects()
        employeeArray.removeAllObjects()
        orderList.removeAllObjects()
        summaryObjs.removeAllObjects()
        WeekendingList.removeAllObjects()
        selectedReportToList = ReportTo.init(ContactId: 0, Name: "", isSelected: "0")
        
        
        isValidReportTo = true
        StartDate = ""
        EndDate = ""
        minuteInterval = 0
        empComments = ""
        divComments = ""
        selectAllButton.isSelected = false
        
        
        self.tableView.reloadData()
    }
    @objc override func appWillEnterForeground(){
        print("appWillEnterForeground Division")
        
        if dataArray.count == 0{
            self.getROSData()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        dayNumberIndex  = Int(SUNDefaultDayNumber)!
        
        self.startDateTxtField.tag = StartDateTextFieldTag
        self.endDateTxtField.tag = EndDateTextFieldTag
        
        self.setupPickerView()
        self.setupCalendarView()
        self.addBorderToView(viewT:startDateView)
        self.addBorderToView(viewT:endDateView)
        self.addRightImageToTextField(textField: startDateTxtField,imageName: "calendar_icon.png")
        self.addRightImageToTextField(textField: endDateTxtField,imageName: "calendar_icon.png")
        
        self.getROSData()
        //        self.self.tableViewTopConstraint.constant = 30
        //        view.layoutIfNeeded()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Server Calls
    
    func PreConfirmOrderAPICall(){
        
        let dayArray = NSMutableArray()
        
        for dict in dataArray{
            let  dictObj = dict as! NSDictionary
            let day = dictObj["header"] as! String
            if day == "SUN" || day == "MON" || day == "TUE" || day == "WED" || day == "THU" || day == "FRI" || day == "SAT"{
                
                // start time , end time and profile ID are the mandatory field for preconfirm order
                let startTime = dictObj["StartTime"] as! String
                let endTime = dictObj["EndTime"] as! String
                let profileID = dictObj["ProfileID"]as? Int ?? 0
                let EmpNumber = dictObj["EmpNum"]as? String
                let isSelected = dictObj["isSelected"]as? String
                
                let EmpNum = Int(EmpNumber!)
                //                if startTime.count > 0 && endTime.count > 0 && profileID > 0 && EmpNum! > 0 && isSelected == "1"{
                
                if  isSelected == "1"{
                    
                    let empCount = dictObj["EmpNum"] as! String
                    let DayNumber = dictObj["DayNumber"] as! String
                    let IsTempOrder = dictObj["IsTempOrder"] as! Bool
                    var monTime = ""
                    var tuesTime = ""
                    var wedTime = ""
                    var thuTime = ""
                    var friTime = ""
                    var satTime = ""
                    var sunTime = ""
                    
                    var  dayName = ""
                    
                    if day == "SUN"{
                        dayName = "Sunday"
                        let time = String(format:"%@ - %@",startTime,endTime)
                        sunTime += time
                        
                    }else if day == "MON"{
                        dayName = "Monday"
                        let time = String(format:"%@ - %@",startTime,endTime)
                        monTime += time
                    }else if day == "TUE"{
                        dayName = "Tuesday"
                        let time = String(format:"%@ - %@",startTime,endTime)
                        tuesTime += time
                        
                    }else if day == "WED"{
                        dayName = "Wednesday"
                        let time = String(format:"%@ - %@",startTime,endTime)
                        wedTime += time
                        
                    }else if day == "THU"{
                        dayName = "Thursday"
                        let time = String(format:"%@ - %@",startTime,endTime)
                        thuTime += time
                        
                    }else if day == "FRI"{
                        dayName = "Friday"
                        let time = String(format:"%@ - %@",startTime,endTime)
                        friTime += time
                        
                    }else if day == "SAT"{
                        dayName = "Saturday"
                        let time = String(format:"%@ - %@",startTime,endTime)
                        satTime += time
                    }
                    
                    let dayDict = ["Day" : dayName,
                                   "DayNumber" : DayNumber,
                                   "EndTime" : dictObj["EndTime"] as! String,
                                   "IsEmployeeChecked" : "true",
                                   "IsTempOrder" : IsTempOrder,
                                   "Position" : dictObj["Profile"] as! String,
                                   "ProfileId" : dictObj["ProfileID"] as? Int ?? 0,
                                   "Shift" : dictObj["Shift"] as! String,
                                   "StartTime" : dictObj["StartTime"] as! String,
                                   "TempCount" : empCount] as [String : Any]
                        as [String : Any]
                    dayArray.add(dayDict)
                    
                }
            }
        }
        
        let defaults = UserDefaults.standard
        
        let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
        let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
        let DivisionId = String(format:"%d", defaults.integer(forKey: "DivisionId"))
        let ContactName  = String(format:"%@", defaults.string(forKey: "UserName")!)
        
        let employeeNameArray = NSMutableArray()
        let employeeIDArray = NSMutableArray()
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
        
        
        let dataDict = ["ClientId" : clientID,
                        "ContactId" : ContactId,
                        "ContactName" : ContactName,
                        "CopyOrder" : "false",
                        "EndDate" : EndDate,
                        "HCValue" : "yes",
                        "IsMessageChecked" : "false",
                        "OnGoing" : "false",
                        "OrderComments" : empComments,
                        "OrderSource" : "iOS",
                        "OSSource" : "iOS",
                        "PositionType" : 0,
                        "ProfileId" : 0,
                        "ReportTo" : selectedReportToList.Name ?? "",
                        "ReportToValue" : selectedReportToList.ContactId ?? "",
                        "SafeHorizon" : clientID,
                        "SelectedCandidateId" : selectedEmployeeIds,
                        "SelectedCandidateName" : selectedEmployees,
                        "StartDate" : StartDate,
                        "Name" : ContactName,
                        "DivisionId" : DivisionId,
                        "OrderSourceName" : "iOS",
                        "retTempNames" : selectedEmployees,
                        "list" : dayArray,
                        "StaffComments" : divComments,
                        "SpreadAndOTHoursHCList" : tempEmps
            ] as [String : Any]
        
   
        
        print(dataDict)
        
        let urlString = RestAPI.BaseUrl+RestAPI.HC_PreconfirmOrderURL
        self.showLoading()
        print(urlString)
        
        RestAPI.HC_postRequestWithToken(urlString: urlString, params: dataDict, callback: getResponseForValidateCreateOrder(response:paramValue:))
        
    }
    func getResponseForValidateCreateOrder(response:AnyObject,paramValue: NSDictionary)->()
    {
        
        self.hideLoading()
        print(response)
        if response is String{
            
            isWarningmessage = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            var object = response as! JSON
            summaryJSON = paramValue
            print(object)
            
            if object["MessageStatus"].intValue == 1// || object["MessageStatus"].intValue == 1
            {
                let message = object["Message"].stringValue
                self.createSummaryDaysWithObject(object: object)
                
                if message.count == 0 || (message.caseInsensitiveCompare("Success") == ComparisonResult.orderedSame){
                    self.pushToOrderSummaryPage()
                }else{
                    isWarningmessage = true
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "Cancel", type: Warning_Text, isAttributed: false)
                }
            }else{
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                }
                isWarningmessage = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
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
            
            let params :[String:String] = ["ContactId":ContactId,"ClientID":clientID,"DivisionId":DivisionId]
            
            print(params)
            
            RestAPI.getROSHealthCare(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getROSResponse(response:))
        }else{
            isWarningmessage = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    func getROSResponse(response:AnyObject)->()
    {
        
        self.hideLoading()
        print(response)
        if response is String{
            isWarningmessage = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                dataArray .removeAllObjects()
                StartDate = object["StartDate"].stringValue
                EndDate = object["EndDate"].stringValue
                self.startDateTxtField.text = StartDate
                self.endDateTxtField.text = EndDate
                minuteInterval = object["stepping"].intValue
                
                if object["ReportToList"].null == nil{
                    let ReportToArray = object["ReportToList"].array // as! NSMutableArray
                    for dict in ReportToArray! {
                        
                        let reportTo = ReportTo.init(ContactId: dict["ContactId"].intValue, Name: dict["FullName"].stringValue, isSelected: "0")
                        reportToList.add(reportTo)
                        
                    }
                }
                if object["ClientProfileList"].null == nil{
                    let profileArray = object["ClientProfileList"].array // as! NSMutableArray
                    for dict in profileArray! {
                        
                        let profile = HealthCareProfile.init(ProfileId: dict["ProfileId"].intValue, ClientId: dict["ClientId"].intValue, isSelected: "0", Description: dict["Description"].stringValue)
                        profileList.add(profile)
                        
                    }
                }
                if object["Shift"].null == nil{
                    let shiftArray = object["Shift"].array // as! NSMutableArray
                    for dict in shiftArray! {
                        
                        let shift = HealthCareShift.init(EndTime: dict["EndTime"].stringValue.lowercased(), Name: dict["Name"].stringValue, startTime: dict["startTime"].stringValue.lowercased(), isSelected: "0")
                        shiftList.add(shift)
                        
                    }
                }
                if object["InitiateDayModelList"].null == nil{
                    let dayArray = object["InitiateDayModelList"].array // as! NSMutableArray
                    for dict in dayArray! {
                        
                        let day = dict["Day"].stringValue
                        var header = ""
                        let TempCount = dict["TempCount"].stringValue
                        let Capacity = ""//dict["Capacity"].stringValue
                        let Count = ""//dict["Count"].stringValue
                        
                        var ShiftTxtFTag = ""
                        var profileTxtFTag = ""
                        var StartTxtFTag = ""
                        var EndTxtFTag = ""
                        var EmpNumTxtFTag = ""
                        var DayNumber = ""
                        
                        if day.count == 0{}else{
                            header = day.prefix(3).uppercased()
                            
                            if header == "MON"{
                                ShiftTxtFTag = MONDefaultShiftTextFieldTag
                                profileTxtFTag = MONDefaultProfileTextFieldTag
                                StartTxtFTag = MONDefaultStartTimeTextFieldTag
                                EndTxtFTag = MONDefaultEndTimeTextFieldTag
                                EmpNumTxtFTag = MONDefaultEmpNumTextFieldTag
                                DayNumber = MONDefaultDayNumber
                            }else if header == "TUE"{
                                ShiftTxtFTag = TUEDefaultShiftTextFieldTag
                                profileTxtFTag = TUEDefaultProfileTextFieldTag
                                StartTxtFTag = TUEDefaultStartTimeTextFieldTag
                                EndTxtFTag = TUEDefaultEndTimeTextFieldTag
                                EmpNumTxtFTag = TUEDefaultEmpNumTextFieldTag
                                DayNumber = TUEDefaultDayNumber
                                
                            }else if header == "WED"{
                                ShiftTxtFTag = WEDDefaultShiftTextFieldTag
                                profileTxtFTag = WEDDefaultProfileTextFieldTag
                                StartTxtFTag = WEDDefaultStartTimeTextFieldTag
                                EndTxtFTag = WEDDefaultEndTimeTextFieldTag
                                EmpNumTxtFTag = WEDDefaultEmpNumTextFieldTag
                                DayNumber = WEDDefaultDayNumber
                                
                            }else if header == "THU"{
                                ShiftTxtFTag = THUDefaultShiftTextFieldTag
                                profileTxtFTag = THUDefaultProfileTextFieldTag
                                StartTxtFTag = THUDefaultStartTimeTextFieldTag
                                EndTxtFTag = THUDefaultEndTimeTextFieldTag
                                EmpNumTxtFTag = THUDefaultEmpNumTextFieldTag
                                DayNumber = THUDefaultDayNumber
                                
                            }else if header == "FRI"{
                                ShiftTxtFTag = FRIDefaultShiftTextFieldTag
                                profileTxtFTag = FRIDefaultProfileTextFieldTag
                                StartTxtFTag = FRIDefaultStartTimeTextFieldTag
                                EndTxtFTag = FRIDefaultEndTimeTextFieldTag
                                EmpNumTxtFTag = FRIDefaultEmpNumTextFieldTag
                                DayNumber = FRIDefaultDayNumber
                                
                            }else if header == "SAT"{
                                ShiftTxtFTag = SATDefaultShiftTextFieldTag
                                profileTxtFTag = SATDefaultProfileTextFieldTag
                                StartTxtFTag = SATDefaultStartTimeTextFieldTag
                                EndTxtFTag = SATDefaultEndTimeTextFieldTag
                                EmpNumTxtFTag = SATDefaultEmpNumTextFieldTag
                                DayNumber = SATDefaultDayNumber
                                
                            }else if header == "SUN"{
                                ShiftTxtFTag = SUNDefaultShiftTextFieldTag
                                profileTxtFTag = SUNDefaultProfileTextFieldTag
                                StartTxtFTag = SUNDefaultStartTimeTextFieldTag
                                EndTxtFTag = SUNDefaultEndTimeTextFieldTag
                                EmpNumTxtFTag = SUNDefaultEmpNumTextFieldTag
                                DayNumber = SUNDefaultDayNumber
                                
                            }
                            let dayDict = ["header":header,"EmpNum":TempCount,"Shift":"","ProfileID":"","Profile":"","StartTime":"","EndTime":"","ShiftTag":ShiftTxtFTag,"ProfileTag":profileTxtFTag,"StartTimeTag":StartTxtFTag,"EndTimeTag":EndTxtFTag,"EmpNumTag":EmpNumTxtFTag,"IsEmployeeChecked" : "0","TempCount" : TempCount,"Capacity" : Capacity,"IsTempOrder" : false,"isSelected": "0","DayNumber":DayNumber] as [String : Any]
                            dataArray.add(dayDict)
                            
                        }
                        
                        
                    }
                }
                let searchEmpDict = ["header":"Search Emp"]
                let empCommentDict = ["header":"Additional Comments for Employees","Tag":emp_cmt_text_view_tag]
                let reportToDict = ["header":"Report To"]
                let divCommentDict = ["header":"Comments for TemPositions internal staff only","Tag":div_cmt_text_view_tag]
                let nextDict = ["header":"Next"]
                
                dataArray.add(searchEmpDict)
                dataArray.add(empCommentDict)
                dataArray.add(divCommentDict)
                dataArray.add(reportToDict)
                dataArray.add(nextDict)
                
                self.tableView.reloadData()
                //                self.formDataArray()
                
            }
            
        }
        
    }
    func getSearchEmployeeDataForDay(flag: String,checkedDayName: String) {
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            
            let dayArray = NSMutableArray()
            
            for dict in dataArray{
                let  dictObj = dict as! NSDictionary
                
                if dictObj["isSelected"] != nil{
                    let sTime = dictObj["StartTime"] as! String
                    let eTime = dictObj["EndTime"] as! String
                    let profileID = dictObj["ProfileID"]as? Int ?? 0

                    //                        break
                    let isSelected = dictObj["isSelected"] as! String
                    
                    if isSelected.count == 0 || isSelected == "0"{
                    }else{
                        
                        if sTime.count == 0 || eTime.count == 0{
                            
                            self.showErrorViewWithMessage(message: "Please select both startime and endtime")
                        }else{
                            let day = dictObj["header"] as! String
                            var  dayName = ""
                            if day == "SUN"{
                                dayName = "Sunday"
                            }else if day == "MON"{
                                dayName = "Monday"
                            }else if day == "TUE"{
                                dayName = "Tuesday"
                            }else if day == "WED"{
                                dayName = "Wednesday"
                            }else if day == "THU"{
                                dayName = "Thursday"
                            }else if day == "FRI"{
                                dayName = "Friday"
                            }else if day == "SAT"{
                                dayName = "Saturday"
                            }//sin
                            if checkedDayName.count > 0 && checkedDayName == day {
                                let dayObj = ["Day" : dayName,
                                              "EndTime" : dictObj["EndTime"],
                                              "IsEmployeeChecked": "true",
                                              "ProfileId": profileID,
                                              "StartTime" : dictObj["StartTime"]]
                                if dayArray.contains(dayObj){}else{
                                    dayArray.add(dayObj)
                                }
                                break
                            }else if flag == "multiple"{
                                let dayObj = ["Day" : dayName,
                                              "EndTime" : dictObj["EndTime"],
                                              "IsEmployeeChecked": "true",
                                              "ProfileId": profileID,
                                              "StartTime" : dictObj["StartTime"]]
                                if dayArray.contains(dayObj){}else{
                                    dayArray.add(dayObj)
                                }
                            }
                        }
                    }
                }
            }
            
            if dayArray.count == 0{
                isWarningmessage = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Please check at least one day.", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
//                                self.showErrorViewWithMessage(message: "Please check at least one day.")
            }else{
                
                let params  = ["StartDate" : StartDate,
                               "EndDate" : EndDate,
                               "flag" : flag,//"multiple",
                               "ClientID" : clientID,
                               "InitiateDayModel" :dayArray] as [String : Any] as NSDictionary
                
                print(params)
                //                JustHUD.shared.showInView(view: view)
                self.showLoading()
                
                let urlString = RestAPI.BaseUrl+RestAPI.HC_getROSSearchEmployeeURL
                
                RestAPI.postRequestWithToken(urlString: urlString, params: params, callback: getResponseForSearchEmployee(response:))
                
            }
        }
        else{
            isWarningmessage = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    func getResponseForSearchEmployee(response:AnyObject)->()
    {
        //        JustHUD.shared.hide()
        self.hideLoading()
        
        print(response)
        if response is String{
            //            lblNoData.isHidden = false
            isWarningmessage = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                let empList = object["HCSearchList"].array
                AllEmployeeArray.removeAllObjects()
                if object["Indicationcolor"].null == nil {
                    
                    let ColorList = object["Indicationcolor"].array
                    for dict in ColorList! {
                        
                        let colorObj = ["Text":dict["Text"].stringValue,"color":dict["color"].stringValue]
                        AllEmployeeArray.add(colorObj)
                    }
                }
                
                let emps = NSMutableArray()
                let OTMessage = object["Note"].stringValue

                for dict in empList! {
                    
                    
                    let Weekly_Hours = String(format:"%.2f",dict["WeeklyHours"].doubleValue)
                    let YTD_Hours = String(format:"%.2f",dict["YTDHours"].doubleValue)
                    let Eval = String(format:"%d",dict["Eval"].intValue)
                    
                    let empObj = NewEmployee.init(CandidateId: dict["CandidateId"].intValue, Name: dict["Name"].stringValue, lastDate: dict["LastOrderDate"].stringValue, Weekly_Hours: Weekly_Hours, positions: dict["Position"].stringValue, Eval: Eval, YTD_Hours: YTD_Hours, isCheckedInRoaster:  "0",isSelected: "0",Photo: dict["Photo"].stringValue,Evaluation: dict["Evaluation"].doubleValue,DummyImagePath:dict["DummyImagePath"].stringValue,ShowOT : dict["ShowOT"].stringValue,OTNote : dict["Message"].stringValue, IsSpreadOfHour : "",MessageSpreadofHours : "",isfavourite:dict["isfavourite"].intValue,favColor:dict["FavoriteColor"].stringValue)
                    emps.add(empObj)
                    
                }
                if emps.count > 0{
                    
                    for emp in emps{
                        let empObj:NewEmployee = emp as! NewEmployee
                        if AllEmployeeArray.contains(empObj){}else{
                            AllEmployeeArray.add(empObj)}
                    }
                    self.pushToSearchEmpListPage(datas: AllEmployeeArray,message: OTMessage)
                }else{
                    isWarningmessage = false
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "No Employees found", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                }
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                isWarningmessage = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
            
        }
    }
    //MARK: Button Action
    //MARK: BUTTON ACTION
    @IBAction override func okButtonTapped(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        if isWarningmessage == true{
            self.pushToOrderSummaryPage()
        }
    }
    @objc func nextButtonTapped(sender:UIButton){
        
        let isDataValidated = self.validateData()
        if isDataValidated == true{
            self.PreConfirmOrderAPICall()
        }
    }
    @IBAction func selectAllButtonTapped(_ sender:UIButton){
        
        var isBtnSelected = ""
        if sender.isSelected == true{
            sender.isSelected = false
            isBtnSelected = "0"
        }else{
            isBtnSelected = "1"
            sender.isSelected = true
        }
        if isBtnSelected.count == 0{}else{
            //create a temp array
            let tempDataArray = NSMutableArray()
            
            for dict in dataArray{
                let di = dict as! NSDictionary
                let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: di)
                if mutableDictObj["isSelected"] != nil{
                    mutableDictObj["isSelected"] = isBtnSelected
                    tempDataArray.add(mutableDictObj)
                    
                }
            }
            let searchEmpDict = ["header":"Search Emp"]
            let empCommentDict = ["header":"Additional Comments for Employees"]
            let reportToDict = ["header":"Report To"]
            let divCommentDict = ["header":"Comments for TemPositions internal staff only","Tag":div_cmt_text_view_tag]
            let nextDict = ["header":"Next"]
            
            tempDataArray.add(searchEmpDict)
            tempDataArray.add(empCommentDict)
            tempDataArray.add(reportToDict)
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            
            
            tempDataArray.add(divCommentDict)
            tempDataArray.add(nextDict)
            dataArray = tempDataArray
        }
        
        self.tableView.reloadData()
    }
    @objc func reqstedEmpBtnTapped(sender: UIButton){
        if employeeArray.count > 0{
            self.presentEmployeeEditOrderPage()
        }else{
            isWarningmessage = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "No employees found", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    @objc func checkDayBtnTapped(sender: UIButton){
        
        let senderPosition  = sender.convert(CGPoint.zero, to: self.tableView)
        
        let indexPath =  self.tableView.indexPathForRow(at:senderPosition)
        
        var isBtnSelected = ""
        if sender.isSelected == true{
            sender.isSelected = false
            isBtnSelected = "0"
            selectAllButton.isSelected = false
        }else if sender.isSelected == false{
            isBtnSelected = "1"
            sender.isSelected = true
        }
        
        if isBtnSelected.count == 0{}else{
            
            let di = dataArray[(indexPath?.row)!] as! NSDictionary
            let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: di)
            mutableDictObj["isSelected"] = isBtnSelected
            dataArray.replaceObject(at: (indexPath?.row)!, with: mutableDictObj)
            
        }
        self.tableView.reloadData()
    }
    @objc func addReportToBtnTapped(sender: UIButton){
        
        self.pushToAddReportToPage()
        
    }
    
    @objc func searchBtnTapped(sender: UIButton){
        
        var isAnyDaySelected = false
        var selectedDayIndex = -1
        
        for dict in dataArray{
            let  dictObj:NSDictionary = dict as! NSDictionary
            
            let day = dictObj["header"] as! String
            
            if day == "SUN" || day == "MON" || day == "TUE" || day == "WED" || day == "THU" || day == "FRI" || day == "SAT"{
                let isSelected = dictObj["isSelected"] as! String
                if isSelected == "1"{
                    isAnyDaySelected = true
                    selectedDayIndex = dataArray.index(of: dictObj)
                }
            }
        }
        var message = ""
        if isAnyDaySelected == true{
            
            if selectedDayIndex >= 0{
                let  dictObj:NSDictionary = dataArray[selectedDayIndex] as! NSDictionary
                let sTime = dictObj["StartTime"] as! String
                let eTime = dictObj["EndTime"] as! String
                let profileID = dictObj["ProfileID"]as? Int ?? 0
                
                if profileID == 0{
                    message = "Please select a Profile"
                }else if sTime.count == 0 || eTime.count == 0{
                    message = "Please select a start and end time for the selected day."
                }
            }
            
            
        }else{
            message = "Please select at least one day."
            
        }
        
        self.getSearchEmployeeDataForDay(flag: "multiple",checkedDayName: "")
   
    }
    @objc func cellSearchBtnTapped(sender: UIButton){
        let senderPosition  = sender.convert(CGPoint.zero, to: self.tableView)
        
        let indexPath =  self.tableView.indexPathForRow(at:senderPosition)
        
        let dict:NSDictionary = self.dataArray[(indexPath?.row)!] as! NSDictionary
        
        let isSelected = dict["isSelected"] as! String
        let sTime = dict["StartTime"] as! String
        let eTime = dict["EndTime"] as! String
        let profileID = dict["ProfileID"]as? Int ?? 0
        let day = dict["header"] as! String

        var message = ""
        if isSelected == "1" && sTime.count > 0 && eTime.count > 0 && profileID > 0{
            self.getSearchEmployeeDataForDay(flag: "single",checkedDayName: day)
        }else if profileID == 0{
            message = "Please select a profile."
        }else if sTime.count == 0{
            message = "Please select a start time."
        }else if eTime.count == 0{
            message = "Please select an end time."
        }else if isSelected == "0"{
            message = "Please select the check box to search employees."//Please check at least one day."
        }
        if message.count > 0{
            isWarningmessage = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
        
    }
    @objc func keyboardDoneBtnTapped(sender: UIButton){
        self.view.endEditing(true)
    }
    
    @objc func addShiftBtnTapped(sender: UIButton){
        
        let senderPosition  = sender.convert(CGPoint.zero, to: self.tableView)
        
        let indexPath =  self.tableView.indexPathForRow(at:senderPosition)
        
        let  dict = dataArray[(indexPath?.row)!] as! NSDictionary
        
        let placeholder = dict["header"] as! String
        
        var ShiftTag = ""
        var ProfileTag = ""
        var StartTimeTag  = ""
        var EmpNumTag  = ""
        var EndTimeTag  = ""
        
        let index = (indexPath?.row)! + 1
        dayNumberIndex = dayNumberIndex + 1
        if placeholder == "MON"{
            
            ShiftTag =  String(format:"%d",Int(MONDefaultShiftTextFieldTag)! + index)
            ProfileTag =  String(format:"%d",Int(MONDefaultProfileTextFieldTag)! + index)
            StartTimeTag =  String(format:"%d",Int(MONDefaultStartTimeTextFieldTag)! + index)
            EndTimeTag =  String(format:"%d",Int(MONDefaultEndTimeTextFieldTag)! + index)
            EmpNumTag =  String(format:"%d",Int(MONDefaultEmpNumTextFieldTag)! + index)
            
        }else  if placeholder == "TUE"{
            
            ShiftTag =  String(format:"%d",Int(TUEDefaultShiftTextFieldTag)! + index)
            ProfileTag =  String(format:"%d",Int(TUEDefaultProfileTextFieldTag)! + index)
            StartTimeTag =  String(format:"%d",Int(TUEDefaultStartTimeTextFieldTag)! + index)
            EndTimeTag =  String(format:"%d",Int(TUEDefaultEndTimeTextFieldTag)! + index)
            EmpNumTag =  String(format:"%d",Int(TUEDefaultEmpNumTextFieldTag)! + index)
            
        }else  if placeholder == "WED"{
            
            ShiftTag =  String(format:"%d",Int(WEDDefaultShiftTextFieldTag)! + index)
            ProfileTag =  String(format:"%d",Int(WEDDefaultProfileTextFieldTag)! + index)
            StartTimeTag =  String(format:"%d",Int(WEDDefaultStartTimeTextFieldTag)! + index)
            EndTimeTag =  String(format:"%d",Int(WEDDefaultEndTimeTextFieldTag)! + index)
            EmpNumTag =  String(format:"%d",Int(WEDDefaultEmpNumTextFieldTag)! + index)
            
        }else  if placeholder == "THU"{
            
            ShiftTag =  String(format:"%d",Int(THUDefaultShiftTextFieldTag)! + index)
            ProfileTag =  String(format:"%d",Int(THUDefaultProfileTextFieldTag)! + index)
            StartTimeTag =  String(format:"%d",Int(THUDefaultStartTimeTextFieldTag)! + index)
            EndTimeTag =  String(format:"%d",Int(THUDefaultEndTimeTextFieldTag)! + index)
            EmpNumTag =  String(format:"%d",Int(THUDefaultEmpNumTextFieldTag)! + index)
            
        }else  if placeholder == "FRI"{
            
            ShiftTag =  String(format:"%d",Int(FRIDefaultShiftTextFieldTag)! + index)
            ProfileTag =  String(format:"%d",Int(FRIDefaultProfileTextFieldTag)! + index)
            StartTimeTag =  String(format:"%d",Int(FRIDefaultStartTimeTextFieldTag)! + index)
            EndTimeTag =  String(format:"%d",Int(FRIDefaultEndTimeTextFieldTag)! + index)
            EmpNumTag =  String(format:"%d",Int(FRIDefaultEmpNumTextFieldTag)! + index)
            
        }else  if placeholder == "SAT"{
            
            ShiftTag =  String(format:"%d",Int(SATDefaultShiftTextFieldTag)! + index)
            ProfileTag =  String(format:"%d",Int(SATDefaultProfileTextFieldTag)! + index)
            StartTimeTag =  String(format:"%d",Int(SATDefaultStartTimeTextFieldTag)! + index)
            EndTimeTag =  String(format:"%d",Int(SATDefaultEndTimeTextFieldTag)! + index)
            EmpNumTag =  String(format:"%d",Int(SATDefaultEmpNumTextFieldTag)! + index)
            
        }else  if placeholder == "SUN"{
            
            ShiftTag =  String(format:"%d",Int(SUNDefaultShiftTextFieldTag)! + index)
            ProfileTag =  String(format:"%d",Int(SUNDefaultProfileTextFieldTag)! + index)
            StartTimeTag =  String(format:"%d",Int(SUNDefaultStartTimeTextFieldTag)! + index)
            EndTimeTag =  String(format:"%d",Int(SUNDefaultEndTimeTextFieldTag)! + index)
            EmpNumTag =  String(format:"%d",Int(SUNDefaultEmpNumTextFieldTag)! + index)
            
        }
        let dayDict = ["header":placeholder,
                       "EmpNum":"1",
                       "Shift":"",
                       "Profile":"",
                       "StartTime":"",
                       "EndTime":"",
                       "ShiftTag":ShiftTag,
                       "ProfileTag":ProfileTag,
                       "StartTimeTag":StartTimeTag,
                       "EndTimeTag":EndTimeTag,
                       "EmpNumTag":EmpNumTag,
                       "IsEmployeeChecked" : "0",
                       "TempCount" : "1",
                       "Capacity" : "0",
                       "IsTempOrder" : true,
                       "isSelected": "0",
                       "DayNumber": String(format:"%d",dayNumberIndex) ] as [String : Any]
        print(dayDict)
        self.tableView.beginUpdates()
        dataArray.insert(dayDict, at: (indexPath?.row)! + 1)
        self.tableView.insertRows(at: [indexPath!], with: .middle)
        self.tableView.endUpdates()
        self.tableView .reloadData()
    }
    
    @objc func clearBtnTapped(sender: UIButton){
        
        let senderPosition  = sender.convert(CGPoint.zero, to: self.tableView)
        
        let indexPath =  self.tableView.indexPathForRow(at:senderPosition)
        
        let  dict = dataArray[(indexPath?.row)!] as! NSDictionary
        
        let placeholder = dict["header"] as! String
        let ShiftTag = dict["ShiftTag"] as! String
        let ProfileTag = dict["ProfileTag"] as! String
        let StartTimeTag = dict["StartTimeTag"] as! String
        let EmpNumTag = dict["EmpNumTag"] as! String
        let EndTimeTag = dict["EndTimeTag"] as! String
        let DayNumber = dict["DayNumber"] as! String
        let IsTempOrder = dict["IsTempOrder"] as! Bool
        
        
        let dayDict = ["header":placeholder,
                       "EmpNum":"1",
                       "Shift":"",
                       "Profile":"",
                       "StartTime":"",
                       "EndTime":"",
                       "ShiftTag":ShiftTag,
                       "ProfileTag":ProfileTag,
                       "StartTimeTag":StartTimeTag,
                       "EndTimeTag":EndTimeTag,
                       "EmpNumTag":EmpNumTag,
                       "IsEmployeeChecked" : "0",
                       "TempCount" : "1",
                       "Capacity" : "0",
                       "IsTempOrder" : IsTempOrder,
                       "isSelected": "0",
                       "DayNumber": DayNumber ] as [String : Any]
        
        dataArray.replaceObject(at: (indexPath?.row)!, with: dayDict)
        
        self.tableView.reloadData()
        
    }
    
    @objc func removeBtnTapped(sender: UIButton){
        let senderPosition  = sender.convert(CGPoint.zero, to: self.tableView)
        
        let indexPath =  self.tableView.indexPathForRow(at:senderPosition)
        
        
        
        let tempDataArray = NSMutableArray()
        
        for dict in dataArray{
            let  dictObj = dict as! NSDictionary
            tempDataArray.add(dictObj)
        }
        dayNumberIndex = dayNumberIndex - 1
        
        for index in 0...tempDataArray.count - 1{
            let dict = tempDataArray[index]
            
            //        for dict in tempDataArray{
            
            let dictObj:NSDictionary = dict as! NSDictionary
            let placeholder = dictObj["header"] as! String
            
            if placeholder == "MON" || placeholder == "TUE" || placeholder == "WED" || placeholder == "THU" || placeholder == "FRI" || placeholder == "SAT" || placeholder == "SUN"
            {
                
                let ShiftTag = dictObj["ShiftTag"] as! String
                
                if ShiftTag == MONDefaultShiftTextFieldTag || ShiftTag == TUEDefaultShiftTextFieldTag  || ShiftTag == WEDDefaultShiftTextFieldTag  || ShiftTag == THUDefaultShiftTextFieldTag  || ShiftTag == FRIDefaultShiftTextFieldTag  || ShiftTag == SATDefaultShiftTextFieldTag  || ShiftTag == SUNDefaultShiftTextFieldTag {
                    //don't decrease the default cell value
                }else{
                    let dayNumIndex = dictObj["DayNumber"] as! String
                    let toBRemovedDayDict = tempDataArray[(indexPath?.row)!] as! NSDictionary
                    let toBRemovedDayNumber = toBRemovedDayDict["DayNumber"] as! String
                    //(indexPath?.row)! >= index ||
                    if  Int(dayNumIndex)! > Int(toBRemovedDayNumber)!{
                        
                        //decrease the daynumber index
                        if Int(dayNumIndex)! > 6{
                            let dayNumIndexInt = Int(dayNumIndex)! - 1
                            
                            let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dictObj)
                            mutableDictObj["DayNumber"] = String(format:"%d",dayNumIndexInt)
                            print((indexPath?.row)!)
                            tempDataArray.replaceObject(at: index, with: mutableDictObj)
                            print(tempDataArray)
                        }
                    }
                }
            }
        }
        dataArray.removeAllObjects()
        for dict in tempDataArray{
            let  dictObj:NSDictionary = dict as! NSDictionary
            dataArray.add(dictObj)
        }
        self.tableView.beginUpdates()
        dataArray.removeObject(at: (indexPath?.row)!)
        self.tableView.deleteRows(at: [indexPath!], with: .left)
        self.tableView.endUpdates()
        print(dataArray)
        
        self.tableView .reloadData()
        
        
    }
    
    //MARK: Local Methods
    
    func validateData() -> Bool{
        var message = ""
        var isValidated = false
        
        
        let dayArray = NSMutableArray()
        var isAtLeastOneDaySelecetd = false
        for dict in dataArray{
            let  dictObj = dict as! NSDictionary
            let day = dictObj["header"] as! String
            
            if day == "SUN" || day == "MON" || day == "TUE" || day == "WED" || day == "THU" || day == "FRI" || day == "SAT"{
                
                // start time , end time and profile ID are the mandatory field for preconfirm order
                let startTime = dictObj["StartTime"] as! String
                let endTime = dictObj["EndTime"] as! String
                let profileID = dictObj["ProfileID"]as? Int ?? 0
                let isSelected = dictObj["isSelected"] as! String
                if isSelected == "1"{
                    isAtLeastOneDaySelecetd = true
                }
                if startTime.count > 0 && endTime.count > 0 && profileID > 0 && isSelected == "1"{
                    let dayDict = ["Day" : day,
                                   "Position" : dictObj["Profile"] as! String,
                                   "ProfileId" : dictObj["ProfileID"] as? Int ?? 0,
                                   "Shift" : dictObj["Shift"] as! String] as [String : Any]
                        as [String : Any]
                    if dayArray.contains(dayDict){}else{
                        dayArray.add(dayDict)}
                }
            }
        }
        
        
        if dayArray.count == 0 {
            if isAtLeastOneDaySelecetd == false{
                message = "Please select at least one day"
            }else{
                message = "Please select mandatory fields(profile,start time and end time) of the selected day"
            }
        }
        if selectedReportToList.ContactId == 0 && message.count == 0{
            isValidReportTo = false
            message = "Please select a Report to person."
            //yellow color
        }else{
            isValidReportTo = true
        }
        if message.count == 0{
            isValidated = true
        }else{
            isWarningmessage = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
        return isValidated
        
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
    
    func showErrorViewWithMessage(message: String){
        
        if message.count == 0{
            //            self.errorView.isHidden = true
            //            self.
            //            self.tableViewTopConstraint.constant = 30
            //            view.layoutIfNeeded()
            
        }else{
            //            self.self.tableViewTopConstraint.constant = 65
            //            view.layoutIfNeeded()
            
            //            self.errorView.isHidden = false
            //            self.errorLbl.text = message
        }
    }
    func showPickerForDateAndTime(textField: UITextField){
        
        
        textField.resignFirstResponder()
        firstResponderTxtFieldTag = textField.tag

        if textField.tag == Int(StartDateTextFieldTag) {
            customPickerView.dtPickerView.datePickerMode = UIDatePicker.Mode.date
            
            if StartDate.count == 0{
            }else{
                let date = self.convertDateStringToDefaultDate(dateString: StartDate, formatString: dateFormat)
                customPickerView.dtPickerView.date = date
                DispatchQueue.main.async(execute: { () -> Void in
                    self.customCalendarView.calendar.setCurrentPage(date, animated: true)
                    self.customCalendarView.calendar.select(date, scrollToDate: true)
                    
                })
            }
            customPickerView.dtPickerView.minimumDate = Date()
            customCalendarView.showPickerViewOnSuperView(superView: (self.navigationController?.view)!,isPortrait: self.isPortrait())

            
        }else if textField.tag == Int(EndDateTextFieldTag) {
            customPickerView.dtPickerView.datePickerMode = UIDatePicker.Mode.date
            
            customPickerView.dtPickerView.minimumDate = Date()
            
            if StartDate.count == 0 {}else{
                let minDate = self.convertDateStringToDefaultDate(dateString: StartDate, formatString: dateFormat)
                customPickerView.dtPickerView.minimumDate = minDate
            }
            if EndDate.count == 0 {}else{
                let date = self.convertDateStringToDefaultDate(dateString: EndDate, formatString: dateFormat)
                customPickerView.dtPickerView.date = date
                DispatchQueue.main.async(execute: { () -> Void in
                    self.customCalendarView.calendar.setCurrentPage(date, animated: true)
                    self.customCalendarView.calendar.select(date, scrollToDate: true)
                    
                })
            }
            
            customCalendarView.showPickerViewOnSuperView(superView: (self.navigationController?.view)!,isPortrait: self.isPortrait())

        }else{
            //Show the  previuosly  selected Time else show current date
            let senderPosition  = textField.convert(CGPoint.zero, to: self.tableView)
            
            let indexPath =  self.tableView.indexPathForRow(at:senderPosition)
            if indexPath != nil{
                
                let  dict = dataArray[(indexPath?.row)!] as! NSDictionary
                let StartTimeTag = dict["StartTimeTag"] as! String
                let EndTimeTag = dict["EndTimeTag"] as! String
                let StartTimeValue = dict["StartTime"] as! String
                let EndTimeValue = dict["EndTime"] as! String
                
                
                if textField.tag == Int(StartTimeTag){
                    if StartTimeValue.count == 0 {
                        customPickerView.dtPickerView.date = Date()
                    }else{
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale.preferredLocale()
                        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
                        let time = String(format:"%@ %@",StartDate,StartTimeValue)
                        
                        let sTime = dateFormatter.date(from: time)
                        
                        if sTime != nil{
                            customPickerView.dtPickerView.date = sTime!}
                    }
                }else  if textField.tag == Int(EndTimeTag){
                    if EndTimeValue.count == 0 {
                        customPickerView.dtPickerView.date = Date()
                    }else{
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale.preferredLocale()
                        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
                        let time = String(format:"%@ %@",EndDate,EndTimeValue)
                        
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
    @objc func timeButtonTapped(sender:UIButton) {
        
        customPickerView.removePickerViewFromSuperView()
        
        if firstResponderTxtFieldTag == Int(MONDefaultEndTimeTextFieldTag) || firstResponderTxtFieldTag == Int(MONDefaultStartTimeTextFieldTag) ||  firstResponderTxtFieldTag == Int(TUEDefaultEndTimeTextFieldTag) || firstResponderTxtFieldTag == Int(TUEDefaultStartTimeTextFieldTag) || firstResponderTxtFieldTag == Int(WEDDefaultEndTimeTextFieldTag) || firstResponderTxtFieldTag == Int(WEDDefaultStartTimeTextFieldTag)!  ||  firstResponderTxtFieldTag == Int(THUDefaultEndTimeTextFieldTag)! || firstResponderTxtFieldTag == Int(THUDefaultStartTimeTextFieldTag) ||  firstResponderTxtFieldTag == Int(FRIDefaultEndTimeTextFieldTag) || firstResponderTxtFieldTag == Int(FRIDefaultStartTimeTextFieldTag) || firstResponderTxtFieldTag == Int(SATDefaultEndTimeTextFieldTag) || firstResponderTxtFieldTag == Int(SATDefaultStartTimeTextFieldTag)!  ||  firstResponderTxtFieldTag == Int(SUNDefaultEndTimeTextFieldTag)! || firstResponderTxtFieldTag == Int(SUNDefaultStartTimeTextFieldTag)  {
            
            //Show the  previuosly  selected Time else show current date
            let changedDate = customPickerView.dtPickerView.date
            customPickerView.dtPickerView.locale = NSLocale(localeIdentifier: "en_US") as Locale
            self.setDatePickerValue(changedDate: changedDate)
        }
        
    }
    
    func setDatePickerValue(changedDate: Date){
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        var  pickedDateString = formatter.string(from: changedDate as Date)
        
        //time
        
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
//                pickedDateString =  String(format:"%@:%@ %@",hour,minute,ampm)

                print( hour,minute)
                var min = "00"
                if Int(minute) ?? 0 >= minuteInterval{
                    min = String(format:"%d",minuteInterval)
                }
                if Int(minute) == 0 || Int(minute) == minuteInterval{
                }else{
                    print(pickedDateString)
                    pickedDateString = String(format: "%@:%@ %@", hour,min,ampm)

//                    if pickedDateString.contains("m") || pickedDateString.contains("M"){
//                        pickedDateString = pickedDateString.replace(target: minute, withString: String(format:"%@",min))
//
//                    }else{
//                        pickedDateString = pickedDateString.replace(target: minute, withString: String(format:"%@ %@",min,ampm))
//                    }
                    
                }
            }
        }
        self.updateDatesFromPicker(dateString: pickedDateString)
        self.tableView.reloadData()
    }
    @objc func datePickerValueChanged(sender: UIDatePicker){
        
        sender.locale = NSLocale(localeIdentifier: "en_US") as Locale
        let changedDate = sender.date
        
        self.setDatePickerValue(changedDate: changedDate)

    }
    func updateDatesFromPicker(dateString: String){
        
        var isMatches = false
        if TappedTextFieldIndex >= 0{
            let   dictObj : NSDictionary = dataArray[TappedTextFieldIndex] as! NSDictionary
            let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dictObj)
            
            let startTag = Int(mutableDictObj["StartTimeTag"] as! String)
            let endTag = Int(mutableDictObj["EndTimeTag"] as! String)
            
            if startTag == firstResponderTxtFieldTag {
                //once start date is changed ,end date should change change accordingly
                mutableDictObj["StartTime"] = dateString
                //                mutableDictObj["EndTime"] = dateString
                isMatches = true
                
            }
            if endTag == firstResponderTxtFieldTag {
                mutableDictObj["EndTime"] = dateString
                isMatches = true
            }
            if isMatches ==  true {
                let tagString = String(format:"%d",firstResponderTxtFieldTag)
                
                if  tagString.prefix(1) == "2"{//start time
                    mutableDictObj["StartTime"]  = dateString
                    
                }else if  tagString.prefix(1) == "1"{//End time
                    mutableDictObj["EndTime"]  = dateString
                    
                }
                dataArray.replaceObject(at: TappedTextFieldIndex, with: mutableDictObj)
            }else{
                print("Did not matched")
            }
            self.tableView.reloadData()
        }
    }
    
    //    func updateWeeklyTimePickerValue(forArray: NSMutableArray,dateString: String){
    //
    //        var indexOfObj = -1
    //
    //        for d in forArray{
    //            let   dObj : NSDictionary = d as! NSDictionary
    //
    //            if dObj["StartTag"] != nil || dObj["EndTag"] != nil{
    //                let txtFStartTag = Int(dObj["StartTag"] as! String)
    //                let txtFEndTag = Int(dObj["EndTag"] as! String)
    //
    //                if txtFStartTag == firstResponderTxtFieldTag {
    //                    indexOfObj = forArray.index(of: dObj)
    //                    break
    //                }
    //                if txtFEndTag == firstResponderTxtFieldTag {
    //                    indexOfObj = forArray.index(of: dObj)
    //                    break
    //                }
    //            }else{}
    //        }
    //        if indexOfObj >= 0{
    //
    //            let   d1 : NSDictionary = forArray[indexOfObj] as! NSDictionary
    //
    //            let mutableDObj: NSMutableDictionary = NSMutableDictionary(dictionary: d1)
    //
    //            let startTag = Int(mutableDObj["StartTag"] as! String)
    //            let endTag = Int(mutableDObj["EndTag"] as! String)
    //            //            let breakTag = Int(mutableDObj["breakTag"] as! String)!
    //
    //            if startTag == firstResponderTxtFieldTag {
    //                mutableDObj["StartValue"] = dateString
    //                if firstResponderTxtFieldTag == Int(SunStartTxtFieldTag){
    //                    SundayStartTime = dateString
    //                }else if firstResponderTxtFieldTag == Int(MonStartTxtFieldTag){
    //                    MondayStartTime = dateString
    //                }else if firstResponderTxtFieldTag == Int(TueStartTxtFieldTag){
    //                    TuesdayStartTime = dateString
    //                }else if firstResponderTxtFieldTag == Int(WedStartTxtFieldTag){
    //                    WednesdayStartTime = dateString
    //                }else if firstResponderTxtFieldTag == Int(ThuStartTxtFieldTag){
    //                    ThursdayStartTime = dateString
    //                }else if firstResponderTxtFieldTag == Int(FriStartTxtFieldTag){
    //                    FridayStartTime = dateString
    //                }else if firstResponderTxtFieldTag == Int(SatStartTxtFieldTag){
    //                    SaturdayStartTime = dateString
    //                }
    //            }
    //            if endTag == firstResponderTxtFieldTag {
    //                mutableDObj["EndValue"] = dateString
    //                if firstResponderTxtFieldTag == Int(SunEndTxtFieldTag){
    //                    SundayEndTime = dateString
    //                }else if firstResponderTxtFieldTag == Int(MonEndTxtFieldTag){
    //                    MondayEndTime = dateString
    //                }else if firstResponderTxtFieldTag == Int(TueEndTxtFieldTag){
    //                    TuesdayEndTime = dateString
    //                }else if firstResponderTxtFieldTag == Int(WedEndTxtFieldTag){
    //                    WednesdayEndTime = dateString
    //                }else if firstResponderTxtFieldTag == Int(ThuEndTxtFieldTag){
    //                    ThursdayEndTime = dateString
    //                }else if firstResponderTxtFieldTag == Int(FriEndTxtFieldTag){
    //                    FridayEndTime = dateString
    //                }else if firstResponderTxtFieldTag == Int(SatEndTxtFieldTag){
    //                    SaturdayEndTime = dateString
    //                }
    //            }
    //            if startTag == Int(StartDateTxtFieldTag) || endTag == Int(EndDateTxtFieldTag){
    //            }else{
    //                let sValue = mutableDObj["StartValue"] as! String
    //                let eValue = mutableDObj["EndValue"] as! String
    //                var breakValue = ""
    //
    //                if mutableDObj["BreakValue"] != nil{
    //                    breakValue = mutableDObj["BreakValue"] as! String
    //                }
    //                if sValue.count > 0 &&  eValue.count > 0{
    //                    let diff = self.getTimeDifference(date1: sValue, date2: eValue,breakValue:breakValue )
    //                    dailyHour = diff
    //                } else{
    //                    dailyHour = "0"
    //                }
    //                self.updateTimeDiff()
    //            }
    //            if indexOfObj >= 0{
    //                forArray.replaceObject(at: indexOfObj, with: mutableDObj)
    //            }
    //        }
    //
    //    }
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
                
                vc.view.addSubview(alertTableView)
                
                self.alrtController = UIAlertController(title:placeHolder, message: nil, preferredStyle:
                    UIAlertController.Style.alert)
                self.alrtController.setValue(vc, forKey: "contentViewController")
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: {
                    (alert: UIAlertAction!) in
                    print("OK")
                    self.firstResponderTxtFieldTag = 0
                    
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !keyboardShowing {
            return
        }
        let modelName = UIDevice.current.modelName
        
        if modelName.contains("iPad"){
            self.tableView.contentInset.bottom = 0//view.bounds.height
            
        }
        
    }
    
    
    // MARK: - Navigation
    func pushToSearchEmpListPage(datas: NSMutableArray,message: String){
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
            nextViewController.isForOCC = false
            nextViewController.isFOrHealthCare = true
            nextViewController.Hos_Header_title = message
            
            for emp in datas {
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
            nextViewController.empDataArray = datas
            nextViewController.delegate = self
            self.navigationController?.pushViewController(nextViewController, animated: true)
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
            
            nextViewController.hcDelegate = self
            nextViewController.isForAddReportToHealthCare = true
            nextViewController.isForAddReportToOCC = false
            nextViewController.isForAddReportToOffice = false
            nextViewController.isForAddReportToLocationOffice = false
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    func presentEmployeeEditOrderPage(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EditEmployeeOrderSegue") as! EditEmployeeOrderViewController
        nextViewController.EmployeeList = employeeArray
        nextViewController.delegate = self
        //        nextViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        //        nextViewController.view.isOpaque = false
        //        nextViewController.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
        nextViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(nextViewController, animated: true, completion:{})
        
        //        self.navigationController?.pushViewController(nextViewController, animated: true)
        
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
            nextViewController.HC_CREATE_ORDER_FLAG = true
            nextViewController.summaryJSON = summaryJSON
            nextViewController.summaryDataArray = summaryObjs
            nextViewController.HC_weekendingList =  WeekendingList
            nextViewController.status = "New"
            nextViewController.delegate = self
            if WeekendingList.count > 0{
                nextViewController.selectedWeekEnd = WeekendingList[0] as! String
            }
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func createSummaryDaysWithObject(object: JSON){
        summaryObjs.removeAllObjects()
        
        let  employeeNameArray = NSMutableArray()
        let commentDict = ["Header":"Additional Comments for Employees","Value":object["OrderComments"].stringValue]
        let reportToDict = ["Header":"Report To","Value":selectedReportToList.Name]
        let divcommentDict = ["Header":"Comments for TemPositions internal staff only","Value":divComments]
        
        let dateDict = ["Header":String(format:"Start Date %@\nEnd Date   %@",object["StartDate"].stringValue,object["EndDate"].stringValue),"Value":""]
        
        summaryObjs.add(commentDict)
        summaryObjs.add(divcommentDict)
        summaryObjs.add(reportToDict)
        summaryObjs.add(dateDict)
        
        for obj in employeeArray{
            let eObj:NewEmployee = (obj as? NewEmployee)!
            let name = eObj.Name
            employeeNameArray.add(name)
        }
        let selectedEmployees = employeeNameArray.map({ String(describing: $0) }).joined(separator: ", ")
        
        if object["list"].null == nil{
            
            let DayList = object["list"].array
            
            for dict in DayList! {
                
                let sTime = dict["StartTime"].stringValue
                let eTime = dict["EndTime"].stringValue
                let Position = dict["Position"].stringValue
                let NoOfTemps = dict["TempCount"].stringValue
                
                let Day = dict["Day"].stringValue
                
                if employeeNameArray.count == 0{
                    
                    let header = String(format:"%@                        %@ - %@\nPosition                        %@\nEmployees Needed     %@",Day,sTime,eTime,Position,NoOfTemps)
                    let dayDict = ["Header":header,"Value":""]
                    summaryObjs.add(dayDict)
                    
                }else{
                    
                    let header = String(format:"%@                         %@ - %@\nPosition                           %@\nEmployees Needed        %@\nRequested Employees   %@",Day,sTime,eTime,Position,NoOfTemps,selectedEmployees)
                    //["StartDate": sDate,"Day":Day,"EndDate":eDate,"Position":Position,"TempCount":NoOfTemps]
                    let dayDict = ["Header":header,"Value":""]
                    summaryObjs.add(dayDict)
                    
                }
            }
        }
    }
    func createSummaryDaysWithObject1(object: JSON){
        
        if object["ddlWeekendList"].null == nil{
            let ddlWeekendList = object["ddlWeekendList"].array // as! NSMutableArray
            for dict in ddlWeekendList! {
                let weekendName = dict["Value"].stringValue
                if WeekendingList.contains(weekendName){}
                else{
                    WeekendingList.add(weekendName)
                }
            }
        }
        let TopList = NSMutableArray()
        
        if object["PreConfirmOrderList"].null == nil{
            let TopListArray = object["PreConfirmOrderList"].dictionary // as! NSMutableArray
            var dayTimeName = ""
            
            if TopListArray!["HeaderList"] != nil
            {
                let HeaderListArray = TopListArray!["HeaderList"]?.dictionary // as! NSMutableArray
                if HeaderListArray!["DayList"] != nil{
                    let DayList = HeaderListArray!["DayList"]?.array
                    for dict in DayList! {
                        let day = String(format:"%@: %@ - %@",dict["Day"].stringValue,dict["StartTime"].stringValue,dict["EndTime"].stringValue)
                        dayTimeName += String(format:"\n%@",day)
                    }
                }
                let sDate = HeaderListArray!["StartDate"]?.stringValue
                let eDate = HeaderListArray!["EndDate"]?.stringValue
                let Position = HeaderListArray!["Position"]?.stringValue
                let NoOfTemps = HeaderListArray!["NoOfTemps"]?.stringValue
                let dict = ["StartDate": sDate,"Day":dayTimeName,"EndDate":eDate,"Position":Position,"TempCount":NoOfTemps]
                if TopList.contains(dict){}else{
                    TopList.add(dict)}
            }
            
            if TopListArray!["childList"] != nil{
                let childList = TopListArray!["childList"]?.dictionary
                if childList != nil{
                    dayTimeName = ""
                    
                    let DuplicateOderList = childList!["DuplicateOderList"]?.array
                    for dict in DuplicateOderList!{
                        let DayList = dict["DayList"].array
                        for dict in DayList! {
                            let day = String(format:"%@: %@ - %@",dict["Day"].stringValue,dict["StartTime"].stringValue,dict["EndTime"].stringValue)
                            dayTimeName += String(format:"\n%@",day)
                        }
                        let dict = ["StartDate":dict["StartDate"].stringValue,"Day":dayTimeName,"EndDate":dict["EndDate"].stringValue,"Position":dict["Position"].stringValue,"TempCount":dict["NoOfTemps"].stringValue]
                        print(dict)
                        TopList.add(dict)
                    }
                }
            }
        }
        
        let  DayNameObjectArray = NSMutableArray()
        let  employeeNameArray = NSMutableArray()
        
        for obj in employeeArray{
            let eObj:NewEmployee = (obj as? NewEmployee)!
            let name = eObj.Name
            employeeNameArray.add(name)
        }
        let selectedEmployees = employeeNameArray.map({ String(describing: $0) }).joined(separator: ", ")
        
        for dict in TopList{
            let dictObj:NSDictionary = dict as! NSDictionary
            let sDate = dictObj["StartDate"] as! String
            let eDate = dictObj["EndDate"] as! String
            let Position = dictObj["Position"] as! String
            let NoOfTemps = dictObj["TempCount"] as! String
            let dayTime =  dictObj["Day"] as! String
            
            let value = String(format:"Start Date %@\n\nEnd Date %@\n%@\n\nPosition: %@\n\nEmployees Needed: %@\n\nRequested Employees: %@\n",sDate,eDate,dayTime,Position,NoOfTemps,selectedEmployees)
            DayNameObjectArray.add(value)
        }
        let selectedDays = DayNameObjectArray.map({ String(describing: $0) }).joined(separator: "\n")
        
        let commentDict = ["Header":"Additional Comments for Employees","Value":empComments]
        let divcommentDict = ["Header":"Comments for TemPositions internal staff only","Value":divComments]
        
        let dayDict = ["Header":selectedDays,"Value":""]
        let weekendDict = ["Header":"Week Ending","Value":""]
        summaryObjs = [commentDict,divcommentDict,dayDict,weekendDict]
        
        var monHeader = ""
        var tuesHeader = ""
        var wedHeader = ""
        var thuHeader = ""
        var friHeader = ""
        var satHeader = ""
        var sunHeader = ""
        
        var monTime = ""
        var tuesTime = ""
        var wedTime = ""
        var thuTime = ""
        var friTime = ""
        var satTime = ""
        var sunTime = ""
        
        var monPosition = ""
        var tuesPosition = ""
        var wedPosition = ""
        var thuPosition = ""
        var friPosition = ""
        var satPosition = ""
        var sunPosition = ""
        
        var monEmpNum =  0
        var tuesEmpNum = 0
        var wedEmpNum =  0
        var thuEmpNum =  0
        var friEmpNum =  0
        var satEmpNum =  0
        var sunEmpNum =  0
        
        for dict in dataArray{
            let  dictObj = dict as! NSDictionary
            let day = dictObj["header"] as! String
            if day == "SUN" || day == "MON" || day == "TUE" || day == "WED" || day == "THU" || day == "FRI" || day == "SAT"{
                
                let startTime = dictObj["StartTime"] as! String
                let endTime = dictObj["EndTime"] as! String
                let Position = dictObj["Profile"] as! String
                let empNum = dictObj["TempCount"] as! String
                
                if startTime.count > 0 && endTime.count > 0{
                    if day == "SUN"{
                        sunHeader = "Sunday"
                        sunEmpNum += Int(empNum)!
                        let time = String(format:"%@ - %@\n",startTime,endTime)
                        sunPosition +=  String(format:"%@ ",Position)
                        sunTime += time
                    }else if day == "MON"{
                        monHeader = "Monday"
                        let time = String(format:"%@ - %@\n",startTime,endTime)
                        monTime += time
                        monPosition +=  String(format:"%@ ",Position)
                        monEmpNum += Int(empNum)!
                        
                    }else if day == "TUE"{
                        tuesHeader = "Tuesday"
                        let time = String(format:"%@ - %@\n",startTime,endTime)
                        tuesTime += time
                        tuesPosition +=  String(format:"%@ ",Position)
                        tuesEmpNum += Int(empNum)!
                        
                    }else if day == "WED"{
                        wedHeader = "Wednesday"
                        let time = String(format:"%@ - %@\n",startTime,endTime)
                        wedTime += time
                        wedPosition +=  String(format:"%@ ",Position)
                        wedEmpNum += Int(empNum)!
                        
                    }else if day == "THU"{
                        thuHeader = "Thursday"
                        let time = String(format:"%@ - %@\n",startTime,endTime)
                        thuTime += time
                        thuPosition +=  String(format:"%@ ",Position)
                        thuEmpNum += Int(empNum)!
                        
                    }else if day == "FRI"{
                        friHeader = "Friday"
                        let time = String(format:"%@ - %@\n",startTime,endTime)
                        friTime += time
                        friPosition +=  String(format:"%@ ",Position)
                        friEmpNum += Int(empNum)!
                        
                    }else if day == "SAT"{
                        satHeader = "Saturday"
                        let time = String(format:"%@ - %@\n",startTime,endTime)
                        satTime += time
                        satPosition +=  String(format:"%@ ",Position)
                        satEmpNum += Int(empNum)!
                        
                    }
                }
            }
        }
        var wholeString = ""
        if monTime.count > 0{
            wholeString = String(format:"%@\n%@\n#of Employees: %d\n\nPosition: %@\n",monHeader,monTime,monEmpNum,monPosition)
            let dayListDict = ["Header":wholeString,"Value":"DownGrid"]
            summaryObjs.add(dayListDict)
            
        }
        if tuesTime.count > 0{
            wholeString = String(format:"%@\n%@\n#of Employees: %d\n\nPosition: %@\n",tuesHeader,tuesTime,tuesEmpNum,tuesPosition)
            let dayListDict = ["Header":wholeString,"Value":"DownGrid"]
            summaryObjs.add(dayListDict)
            
        }
        if wedTime.count > 0{
            wholeString = String(format:"%@\n%@\n#of Employees: %d\n\nPosition: %@\n",wedHeader,wedTime,wedEmpNum,wedPosition)
            let dayListDict = ["Header":wholeString,"Value":"DownGrid"]
            summaryObjs.add(dayListDict)
            
        }
        if thuTime.count > 0{
            wholeString = String(format:"%@\n%@\n#of Employees: %d\n\nPosition: %@\n",thuHeader,thuTime,thuEmpNum,thuPosition)
            let dayListDict = ["Header":wholeString,"Value":"DownGrid"]
            summaryObjs.add(dayListDict)
            
        }
        if friTime.count > 0{
            wholeString = String(format:"%@\n%@\n#of Employees: %d\n\nPosition: %@\n",friHeader,friTime,friEmpNum,friPosition)
            let dayListDict = ["Header":wholeString,"Value":"DownGrid"]
            summaryObjs.add(dayListDict)
            
        }
        if satTime.count > 0{
            wholeString = String(format:"%@\n%@\n#of Employees: %d\n\nPosition: %@\n",satHeader,satTime,satEmpNum,satPosition)
            let dayListDict = ["Header":wholeString,"Value":"DownGrid"]
            summaryObjs.add(dayListDict)
            
        }
        if sunTime.count > 0{
            wholeString = String(format:"%@\n%@\n#of Employees: %d\n\nPosition: %@\n",sunHeader,sunTime,sunEmpNum,sunPosition)
            let dayListDict = ["Header":wholeString,"Value":"DownGrid"]
            summaryObjs.add(dayListDict)
            
        }
        print(summaryObjs)
        //Header
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
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
        
        if firstResponderTxtFieldTag == Int(StartDateTextFieldTag){
            self.startDateTxtField.text = pickedDateString
            //            self.endDateTxtField.text = pickedDateString
            StartDate = pickedDateString
            
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
                    self.endDateTxtField.text = pickedDateString
                    EndDate = pickedDateString
                case .orderedSame?          :
                    print("The two dates are the same")
                case .none: break
                }
            }
            //            EndDate = pickedDateString
        }else if firstResponderTxtFieldTag == Int(EndDateTextFieldTag){
            self.endDateTxtField.text = pickedDateString
            EndDate = pickedDateString
        }
        customCalendarView.removePickerViewFromSuperView()
        
        
    }
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
