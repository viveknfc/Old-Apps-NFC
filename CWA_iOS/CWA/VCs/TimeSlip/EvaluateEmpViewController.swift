//
//  EvaluateEmpViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 15/12/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON

class EvaluateEmpViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate {
    
    var dataDictArray = NSMutableArray()
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    var activeTextView: UITextView?
    var isSuccessMessage = false
    let WorkPerformanceTxtFieldTag = "101"
    let AttendanceTxtFieldTag = "102"
    let EmpAttitudeTxtFieldTag = "103"
    let RequestEmpTxtFieldTag = "104"
    let EmpDressedTxtFieldTag = "105"
    let OverallQltyTxtFieldTag = "106"
    let QltyOfServTxtFieldTag = "107"
    
    let EmpCommentsTxtViewTag = "108"
    let ServiceCommentsTxtViewTag = "109"
    var reqd = " *Required"
    var WorkPerformanceError = "0"
    var AttendanceError = "0"
    var EmpAttitudeError = "0"
    var RequestEmpError = "0"
    var EmpDressedError = "0"
    var OverallQltyError = "0"
    var QltyOfServError = "0"
    var EmpCommentsError = "0"
    var ServiceCommentsError = "0"
    
    
    let dropDownTblViewTag = 1001
    
    var empComments = ""
    var serviceComments = ""
    var empName = ""
    var headerText = ""
    var orderID  = ""
    var CandId  = ""
    
    var WorkPerformanceList = NSMutableArray()
    var AttendanceList = NSMutableArray()
    var AttitudeList = NSMutableArray()
    var EmployeeRequestList = NSMutableArray()
    var QualityOfServiceInCurrentList = NSMutableArray()
    var QualityOfServiceInOtherServiceList = NSMutableArray()
    var EmployeeDressedList = NSMutableArray()
    
    var selectedWorkPerformance = EvaluateEmployee.init(Text: "", Value: "")
    var selectedAttendance =  EvaluateEmployee.init(Text: "", Value: "")
    var selectedAttitude =  EvaluateEmployee.init(Text: "", Value: "")
    var selectedQualityOfServiceInCurrent =  EvaluateEmployee.init(Text: "", Value: "")
    var selectedQualityOfServiceInOtherService = EvaluateEmployee.init(Text: "", Value: "")
    var selectedEmployeeDressed =  EvaluateEmployee.init(Text: "", Value: "")
    var selectedEmployeeRequest =  EvaluateEmployee.init(Text: "", Value: "")
 
    let empEvaPlaceholder = "Employee Evaluation"
    let workPerfPlaceholder = "Work Performance *"
    let attendancePlaceholder = "Attendance & Punctuality *"
    let empAttPlaceholder = "Employee's Attitude *"
    let dressedPlaceholder = "Was employee appropriately dressed? *"
    let reqAgainPlaceholder = "Would you request employee again? *"
    let addComtPlaceholder = "Additional comments *"
    let servEvalutionPlaceholder = "Service Evaluation"
    let servQltyPlaceholder = "Overall quality of service provided in staffing your current needs *"
    let servQltyCompPlaceholder = "Quality of service provided in comparison to other staffing services *"

    
    var alrtController = UIAlertController()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "Evaluate Employee"

        // Do any additional setup after loading the view.
        self.formLoadData()
        listTableView.isHidden = true
        self.getEvaluateEmployee()
        self.registerForKeyboardNotifications()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titlelbl.text = "Evaluate Employee"

    }
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(EvaluateEmpViewController.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EvaluateEmpViewController.keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(aNotification: NSNotification) {
        
        
        
        var info = aNotification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        
        listTableView.contentInset = contentInsets
        listTableView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = self.view.frame
        aRect.size.height -= (keyboardSize?.height)!
        if let activeField = self.activeTextView {
            if (!aRect.contains(activeField.frame.origin)){
                listTableView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(aNotification: NSNotification) {
         let contentInsets : UIEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        listTableView.contentInset = contentInsets
        listTableView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
     }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func keyboardDoneBtnTapped(sender: UIButton)  {
        self.view.endEditing(true)
    }
    
    @IBAction func saveButtonAction(_ sender: Any){
        var message = ""
        
        if selectedWorkPerformance.Text?.count == 0{
            message = "Work Performance"
            WorkPerformanceError = "1"
        }else{
            WorkPerformanceError = "0"
        }
        if selectedAttendance.Text?.count == 0{
            message = "Attendance & Punctuality"
            AttendanceError = "1"
        }else{
            AttendanceError = "0"
        }
        if selectedAttitude.Text?.count == 0{
            message = "Employee's Attitude"
            EmpAttitudeError = "1"
        }else{
            EmpAttitudeError = "0"
        }
        if selectedEmployeeDressed.Text?.count == 0{
            message = "Was employee appropriately dressed?"
            EmpDressedError = "1"
        }else{
            EmpDressedError = "0"
        }
        if selectedEmployeeRequest.Text?.count == 0{
            message = "Would you request employee again?"
            RequestEmpError = "1"
        }else{
            RequestEmpError = "0"
        }
        if empComments.count == 0{
            message = "Additional comments"
            EmpCommentsError = "1"
        }else{
            EmpCommentsError = "0"
        }
        if selectedQualityOfServiceInCurrent.Text?.count == 0{
            message = "Overall quality of service provided in staffing your current needs"
            OverallQltyError = "1"
        }else{
            OverallQltyError = "0"
        }
        if selectedQualityOfServiceInOtherService.Text?.count == 0{
            QltyOfServError = "1"
            message = "Quality of service provided in comparison to other staffing services"
            
        }else{
            QltyOfServError = "0"
        }
        if serviceComments.count == 0{
            ServiceCommentsError = "1"
            message = "Additional Comments"
        }else{
            ServiceCommentsError = "0"
        }
        
        if message.count == 0{
            //POST CAll
            
            let isInternetAvailable = self.isInternetAvailable()
            
            if isInternetAvailable {
                JustHUD.shared.showInView(view: (self.view)!)
                
                let params =  ["Name":empName,
                               "OrderId":orderID,
                               "CandId":CandId,
                               "WorkPerfermonce":selectedWorkPerformance.Value,
                               "AttenPunct":selectedAttendance.Value,
                               "EmpAttitude":selectedAttitude.Value,
                               "Dress":selectedEmployeeDressed.Value,
                               "Request":selectedEmployeeRequest.Value,
                               "AddComment":empComments,
                               "OveralQuality":selectedQualityOfServiceInCurrent.Value,
                               "CompareQuality":selectedQualityOfServiceInOtherService.Value,
                               "AddCommentService":serviceComments]
                print(params)
                RestAPI.InsertEmployeesWithEvaluation(self, params: params as! [String : String], method: "POST", accessToken: "", acces: true, callBack: getInsertResponse(response:))
                
            }else{
                
//                self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
              isSuccessMessage = false
                self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

            }
            
        }else{
            message = "Please fill all the mandatory fields"
//            self.ShowAlertMessage(message: message, title: "")
            isSuccessMessage = false
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            listTableView.reloadData()

        }
        
    }
    func formLoadData(){
        
        dataDictArray.removeAllObjects()
        

        let empTitleDict = ["name":empEvaPlaceholder,"type":"header","tag":"","value":""]
        let workPerformanceDict = ["name":workPerfPlaceholder,"type":"dropdown","tag":WorkPerformanceTxtFieldTag,"value":selectedWorkPerformance.Text]
        let AttendanceDict = ["name":attendancePlaceholder,"type":"dropdown","tag":AttendanceTxtFieldTag,"value":selectedAttendance.Text]
        let empAttitudeDict = ["name":empAttPlaceholder,"type":"dropdown","tag":EmpAttitudeTxtFieldTag,"value":selectedAttitude.Text]
        let appropriatelyDressedDict = ["name":dressedPlaceholder,"type":"dropdown","tag":EmpDressedTxtFieldTag,"value":selectedEmployeeDressed.Text]
        let reqAgainDict = ["name":reqAgainPlaceholder,"type":"dropdown","tag":RequestEmpTxtFieldTag,"value":selectedEmployeeRequest.Text]
        let addCommentDict = ["name":addComtPlaceholder,"type":"textentry","tag":EmpCommentsTxtViewTag,"value":empComments]
        
        let selectEvaluationDict = ["name":servEvalutionPlaceholder,"type":"header","tag":"","value":""]
        let serviceQltyDict = ["name":servQltyPlaceholder,"type":"dropdown","tag":OverallQltyTxtFieldTag,"value":selectedQualityOfServiceInCurrent.Text]
        let serviceQltyComparDict = ["name":servQltyCompPlaceholder,"type":"dropdown","tag":QltyOfServTxtFieldTag,"value":selectedQualityOfServiceInOtherService.Text]
        let addCommentDict2 = ["name":addComtPlaceholder,"type":"textentry","tag":ServiceCommentsTxtViewTag,"value":serviceComments]
        
        dataDictArray = [empTitleDict,workPerformanceDict,AttendanceDict,empAttitudeDict,appropriatelyDressedDict,reqAgainDict,addCommentDict,selectEvaluationDict,serviceQltyDict,serviceQltyComparDict,addCommentDict2]
        listTableView.reloadData()
    }
    
    //MARK:-  TABLEVIEW DATA SOURCE METHOD
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if tableView.tag == 101 {
            return WorkPerformanceList.count
        }else if tableView.tag == 102 {
            return AttendanceList.count
        }else if tableView.tag == 103 {
            return AttitudeList.count
        }else if tableView.tag == 104 {
            return EmployeeRequestList.count
        }else if tableView.tag == 105 {
            return EmployeeDressedList.count
        }else if tableView.tag == 106 {
            return QualityOfServiceInCurrentList.count
        }else if tableView.tag == 107 {
            return QualityOfServiceInOtherServiceList.count
        }
        return dataDictArray.count
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        if tableView.tag == 101 || tableView.tag == 102 || tableView.tag == 103 || tableView.tag == 104 || tableView.tag == 105 || tableView.tag == 106 || tableView.tag == 107{
            var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell!
            if !(cell != nil) {
                cell = UITableViewCell(style:.subtitle, reuseIdentifier: "CELL")
            }
            
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            
            var title = ""
            var evaEmp = EvaluateEmployee.init(Text: "", Value: "")
            if tableView.tag == 101 {
                evaEmp  =  WorkPerformanceList[indexPath.row] as! EvaluateEmployee
                title = evaEmp.Text!
               
            }else if tableView.tag == 102 {
                
                evaEmp  =  AttendanceList[indexPath.row] as! EvaluateEmployee
                title = evaEmp.Text!
                
            }else if tableView.tag == 103 {
                
                evaEmp  =  AttitudeList[indexPath.row] as! EvaluateEmployee
                title = evaEmp.Text!
                
            }else if tableView.tag == 104 {
                
                evaEmp  =  EmployeeRequestList[indexPath.row] as! EvaluateEmployee
                title = evaEmp.Text!
               
            }else if tableView.tag == 105 {
                
                evaEmp  =  EmployeeDressedList[indexPath.row] as! EvaluateEmployee
                title = evaEmp.Text!
               
            }else if tableView.tag == 106 {
                
                evaEmp  =  QualityOfServiceInCurrentList[indexPath.row] as! EvaluateEmployee
                title = evaEmp.Text!
               
            }else if tableView.tag == 107 {
                
                evaEmp  =  QualityOfServiceInOtherServiceList[indexPath.row] as! EvaluateEmployee
                title = evaEmp.Text!
              
            }
            
            cell?.textLabel?.text = title
            return cell!
            
        }
        let dict = dataDictArray[indexPath.row] as! NSDictionary
        
        let type = dict["type"] as! String
        let header = dict["name"] as! String
        
        if type == "dropdown"{
            
            return   self.textFieldDropDownCell(dataDict: dict, indexPath: indexPath as NSIndexPath )
        }else if type == "textentry"{
            return   self.textViewCell(dataDict: dict, indexPath: indexPath as NSIndexPath )
            
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell!
        if !(cell != nil) {
            cell = UITableViewCell(style:.subtitle, reuseIdentifier: "CELL")
        }
        
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cell?.textLabel?.text = ""
        cell?.textLabel?.textColor = UIColor.clear
 
        
        for lView in (cell?.contentView.subviews)!{
            
            let lab:UILabel = lView as! UILabel
            if lab.tag == 101{
                lab.removeFromSuperview()
            }
        }
        
        
        let labl = UILabel.init(frame: CGRect(x:0,y:0,width:(cell?.contentView.frame.size.width)!,height:40))
        labl.tag = 101
        labl.text = header
        labl.font = UIFont.boldSystemFont(ofSize: 14)
        labl.textAlignment = .center
        labl.backgroundColor = UIColor.clear
        cell?.contentView.addSubview(labl)
        return cell!
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == dropDownTblViewTag{
            return 50
        }
        let dict = dataDictArray[indexPath.row] as! NSDictionary
        
        let type = dict["type"] as! String
        let tag = dict["tag"] as! String
        
        if type == "dropdown"{
            if tag == OverallQltyTxtFieldTag || tag == QltyOfServTxtFieldTag{
                return 90
                
            }
            return 80
        }else if type == "textentry"{
            return 120
        }
        return 40
        
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if tableView.tag == 101 || tableView.tag == 102 || tableView.tag == 103 || tableView.tag == 104 || tableView.tag == 105 || tableView.tag == 106 || tableView.tag == 107{
            
            var evaEmp = EvaluateEmployee.init(Text: "", Value: "")
            if tableView.tag == 101 {
                evaEmp  =  WorkPerformanceList[indexPath.row] as! EvaluateEmployee
                selectedWorkPerformance = evaEmp
            }else if tableView.tag == 102 {
                
                evaEmp  =  AttendanceList[indexPath.row] as! EvaluateEmployee
                selectedAttendance = evaEmp
            }else if tableView.tag == 103 {
                
                evaEmp  =  AttitudeList[indexPath.row] as! EvaluateEmployee
                selectedAttitude = evaEmp
            }else if tableView.tag == 104 {
                
                evaEmp  =  EmployeeRequestList[indexPath.row] as! EvaluateEmployee
                selectedEmployeeRequest = evaEmp
                
            }else if tableView.tag == 105 {
                
                evaEmp  =  EmployeeDressedList[indexPath.row] as! EvaluateEmployee
                selectedEmployeeDressed = evaEmp
                
            }else if tableView.tag == 106 {
                
                evaEmp  =  QualityOfServiceInCurrentList[indexPath.row] as! EvaluateEmployee
                selectedQualityOfServiceInCurrent = evaEmp
            }else if tableView.tag == 107 {
                evaEmp  =  QualityOfServiceInOtherServiceList[indexPath.row] as! EvaluateEmployee
                selectedQualityOfServiceInOtherService = evaEmp
            }
            alrtController.dismiss(animated: true, completion: nil)
            self.formLoadData()
        }
        
    }
    
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.tag == 101 || tableView.tag == 102 || tableView.tag == 103 || tableView.tag == 104 || tableView.tag == 105 || tableView.tag == 106 || tableView.tag == 107{
            return UIView()
        }
        
        let height =  self.sizeOfString(string: headerText, constrainedToHeight: Double.greatestFiniteMagnitude).height + 50 + 20
        
        let stringHeight = max(95, height)
        
        let lbl = UILabel.init(frame: CGRect(x:10,y:0,width : UIScreen.main.bounds.size.width -  20 ,height:stringHeight + 15))
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.numberOfLines = 0
        lbl.backgroundColor = UIColor.clear
        
        let htmlString = "<html>" + headerText
        
        lbl.attributedText = htmlString.htmlToAttributedString
        
        let bgView = UIView.init(frame: CGRect(x:0,y:0,width : UIScreen.main.bounds.size.width  ,height:stringHeight + 20))
        bgView.backgroundColor = UIColor.white
        bgView.addSubview(lbl)
        
        return bgView
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if tableView.tag == 101 || tableView.tag == 102 || tableView.tag == 103 || tableView.tag == 104 || tableView.tag == 105 || tableView.tag == 106 || tableView.tag == 107{
            return 0
        }
        let height =  self.sizeOfString(string: headerText, constrainedToHeight: Double.greatestFiniteMagnitude).height + 50 + 40
        
        return max(95, height)
        
    }
    //MARK: Custom Cell
    
    func textFieldDropDownCell(dataDict: NSDictionary,indexPath: NSIndexPath) -> TextFieldTableViewCell {
        
        let cell:TextFieldTableViewCell = listTableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCellIdentifier") as! TextFieldTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        cell.entryTextField.delegate = self
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(keyboardDoneBtnTapped))]
        toolBar.sizeToFit()
        cell.entryTextField.inputAccessoryView = toolBar
        
        
        let header = dataDict["name"] as! String
        let tag = dataDict["tag"] as! String
        let value = dataDict["value"] as! String
        
        cell.entryTextField.tag = Int(tag)!
      
        if tag == WorkPerformanceTxtFieldTag{
            if WorkPerformanceError == "1"{
                //red
                cell.lblHeader.halfTextColorChange(fullText: header, changeText: "*", textColor: UIColor.red)
                
            }else{
                //clear
                cell.lblHeader.halfTextColorChange(fullText: header, changeText: "*", textColor: UIColor.clear)
                
            }
        }else if tag == AttendanceTxtFieldTag{
            if AttendanceError == "1"{
                //red
                cell.lblHeader.halfTextColorChange(fullText: header, changeText: "*", textColor: UIColor.red)

            }else{
                //clear
                cell.lblHeader.halfTextColorChange(fullText: header, changeText: "*", textColor: UIColor.clear)

            }
        }else if tag == EmpAttitudeTxtFieldTag{
            if EmpAttitudeError == "1"{
                //red
                cell.lblHeader.halfTextColorChange(fullText: header, changeText: "*", textColor: UIColor.red)

            }else{
                //clear
                cell.lblHeader.halfTextColorChange(fullText: header, changeText: "*", textColor: UIColor.clear)

            }
        }else if tag == RequestEmpTxtFieldTag{
            if RequestEmpError == "1"{
                //red
                cell.lblHeader.halfTextColorChange(fullText: header, changeText: "*", textColor: UIColor.red)

            }else{
                //clear
                cell.lblHeader.halfTextColorChange(fullText: header, changeText: "*", textColor: UIColor.clear)

            }
        }else if tag == EmpDressedTxtFieldTag{
            if EmpDressedError == "1"{
                //red
                cell.lblHeader.halfTextColorChange(fullText: header, changeText: "*", textColor: UIColor.red)
            }else{
                //clear
                cell.lblHeader.halfTextColorChange(fullText: header, changeText: "*", textColor: UIColor.clear)
            }
        }else if tag == OverallQltyTxtFieldTag{
            
            if OverallQltyError == "1"{
                //red
                cell.lblHeader.halfTextColorChange(fullText: header, changeText: "*", textColor: UIColor.red)
            }else{
                //clear
                cell.lblHeader.halfTextColorChange(fullText: header, changeText: "*", textColor: UIColor.clear)
            }
        }else if tag == QltyOfServTxtFieldTag{
            if QltyOfServError == "1"{
                //red
                cell.lblHeader.halfTextColorChange(fullText: header, changeText: "*", textColor: UIColor.red)
            }else{
                //clear
                cell.lblHeader.halfTextColorChange(fullText: header, changeText: "*", textColor: UIColor.clear)
            }
        }
//        cell.lblHeader.text = header
        cell.entryTextField.text = value
        
        let dropDownImage = UIImage.init(named: "drop-down")
        let rightImageView = UIImageView()
        rightImageView.image = dropDownImage
        rightImageView.frame = CGRect(x:0, y:0, width:20, height:20)
        cell.entryTextField.rightView = rightImageView
        cell.entryTextField.rightViewMode = UITextField.ViewMode.always
        return cell
        
    }
    func textViewCell(dataDict: NSDictionary,indexPath: NSIndexPath) -> TextViewTableViewCell {
        
        let cell:TextViewTableViewCell = listTableView.dequeueReusableCell(withIdentifier: "TextViewTableViewCellIdentifier") as! TextViewTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        cell.entryTextView.layer.borderColor = borderColor.cgColor
        cell.entryTextView.layer.borderWidth = 1
        cell.entryTextView.delegate = self
        activeTextView = cell.entryTextView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(keyboardDoneBtnTapped))]
        toolBar.sizeToFit()
        
        cell.entryTextView.inputAccessoryView = toolBar
        
        let header = dataDict["name"] as! String
        let tag = dataDict["tag"] as! String
        let value = dataDict["value"] as! String
        
        cell.lblHeader.text = header
        cell.entryTextView.tag = Int(tag)!
        cell.entryTextView.text = value
        if  tag ==  EmpCommentsTxtViewTag {
            cell.entryTextView.text =  empComments
            if EmpCommentsError == "1"{
                //red
                cell.lblHeader.halfTextColorChange(fullText: header, changeText: "*", textColor: UIColor.red)
            }else{
                //clear
                cell.lblHeader.halfTextColorChange(fullText: header, changeText: "*", textColor: UIColor.clear)
            }
        }else if tag ==  ServiceCommentsTxtViewTag {
            cell.entryTextView.text  = serviceComments
            if ServiceCommentsError == "1"{
                //red
                cell.lblHeader.halfTextColorChange(fullText: header, changeText: "*", textColor: UIColor.red)
            }else{
                //clear
                cell.lblHeader.halfTextColorChange(fullText: header, changeText: "*", textColor: UIColor.clear)
                
            }
        }
        return cell
        
    }
    
    //MARK: TextField Delegate
    public func textFieldDidBeginEditing(_ textField: UITextField){
        
        textField.resignFirstResponder()
        
        
        let senderPosition  = textField.convert(CGPoint.zero, to: listTableView)
        
        let indexPath =  listTableView.indexPathForRow(at:senderPosition)
        
        let s:NSDictionary = dataDictArray[(indexPath?.row)!] as! NSDictionary
        let header = s["name"] as! String
        let tag = s["tag"] as! String
        print(dataDictArray.count)
        self.showDropDownWithTag(placeHolder: header,tag: Int(tag)!)
        
    }
    
    //MARK: UITEXTVIEW Delegate
    
    
    public func textViewDidEndEditing(_ textView: UITextView)
    {
        
        if textView.tag == Int(EmpCommentsTxtViewTag){
            empComments = textView.text
        }else if textView.tag == Int(ServiceCommentsTxtViewTag){
            serviceComments = textView.text
        }
        
    }
    
    func showDropDownWithTag( placeHolder: String,tag: Int){
        
        alrtController = UIAlertController(title: placeHolder, message: "", preferredStyle: UIAlertController.Style.actionSheet)
        let alertHeight =  300 //self.view.frame.height * 0.80
        
        let margin = 8
        
        var rect = CGRect(x: margin, y: 50, width: Int(alrtController.view.bounds.size.width - 35), height: alertHeight  - 120)
        let  alertTableView = UITableView(frame: rect)
        
        let modelName = UIDevice.current.modelName
        if modelName.contains("iPad") {
             let defaultAction = UIAlertAction(title: "", style: .default, handler: nil)
            let deleteAction = UIAlertAction(title: "", style: .default, handler:nil)
            alrtController.addAction(defaultAction)
            alrtController.addAction(deleteAction)
            if tag == 106 || tag == 107 {
                rect = CGRect(x: 0, y: 65, width: alrtController.view.bounds.size.width, height: 110)

            }else{
                rect = CGRect(x: 0, y: 45, width: alrtController.view.bounds.size.width, height: 115)

            }

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
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: {(alert: UIAlertAction!) in print("OK")})
        
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
    
    // MARK: - SERVER CALL
    
    
    func getEvaluateEmployee() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            
            //userid as String
            let params :[String:String] = ["Name": empName]
            print(params)
            RestAPI.GetEvaluateEmployee(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
            
        }else{
            
//            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
         isSuccessMessage = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

        }
    }
    
    
    
    func getInsertResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            
//            self.ShowAlertMessage(message: response as! String, title: "")
            isSuccessMessage = false
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

        }else{
            
            var object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
//                 DispatchQueue.main.async(execute: { () -> Void in
//                    let alert = UIAlertController(title:"", message: object["Message"].stringValue, preferredStyle: UIAlertControllerStyle.alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{(alert) in
//                        self.navigationController?.popViewController(animated: true)
//                    }))
//                    self.present(alert, animated: true, completion: nil)
//                })
                isSuccessMessage = true
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                isSuccessMessage = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
        
    }
   @IBAction override func okButtonTapped(_ sender: Any) {
//    self.alertController.dismiss(animated: true, completion: nil)
    self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)

        if isSuccessMessage == true{
            self.navigationController?.popViewController(animated: true)
        }
    }
    func getResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            
//            self.ShowAlertMessage(message: response as! String, title: "")
            isSuccessMessage = false
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

        }else{
            
            var object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
                
                
                headerText  = object["Text"].stringValue
                
                let WorkPerformanceArray = object["WorkPerformanceList"].array
                let AttendanceArray  = object["AttendanceList"].array
                let AttitudeArray = object["AttitudeList"].array
                let   EmployeeRequestArray = object["EmployeeRequestList"].array
                let  QualityOfServiceInCurrentArray = object["QualityOfServiceInCurrentList"].array
                let  QualityOfServiceInOtherServiceArray = object["QualityOfServiceInOtherServiceList"].array
                let EmployeeDressedArray = object["EmployeeDressedList"].array
                
                for dict in WorkPerformanceArray! {
                    let emp = EvaluateEmployee.init(Text:dict["Text"].stringValue,Value:dict["Value"].stringValue)
                    WorkPerformanceList.add(emp)
                    
                }
                for dict in AttendanceArray! {
                    let emp = EvaluateEmployee.init(Text:dict["Text"].stringValue,Value:dict["Value"].stringValue)
                    AttendanceList.add(emp)
                    
                }
                for dict in AttitudeArray! {
                    let emp = EvaluateEmployee.init(Text:dict["Text"].stringValue,Value:dict["Value"].stringValue)
                    AttitudeList.add(emp)
                    
                }
                for dict in EmployeeRequestArray! {
                    let emp = EvaluateEmployee.init(Text:dict["Text"].stringValue,Value:dict["Value"].stringValue)
                    EmployeeRequestList.add(emp)
                    
                }
                for dict in QualityOfServiceInCurrentArray! {
                    let emp = EvaluateEmployee.init(Text:dict["Text"].stringValue,Value:dict["Value"].stringValue)
                    QualityOfServiceInCurrentList.add(emp)
                    
                }
                for dict in QualityOfServiceInOtherServiceArray! {
                    let emp = EvaluateEmployee.init(Text:dict["Text"].stringValue,Value:dict["Value"].stringValue)
                    QualityOfServiceInOtherServiceList.add(emp)
                    
                }
                for dict in EmployeeDressedArray! {
                    let emp = EvaluateEmployee.init(Text:dict["Text"].stringValue,Value:dict["Value"].stringValue)
                    EmployeeDressedList.add(emp)
                    
                }
                listTableView.isHidden = false
                listTableView.reloadData()
                
                
            }else{
                
                var message = object["message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                isSuccessMessage = false
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
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
