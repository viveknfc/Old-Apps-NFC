//
//  AddNewReportToViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 05/12/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//
/*
 here name and email id is mandatary fields
 
 */
import UIKit
import SwiftyJSON

@objc protocol addReportToDelegate: class{
    
    func addedReportTo(_ reportToPerson : ReportTo)
    func addedReportToLocation(_ locationName : ReportToLocation)
    func addReportToForOCC (_ reportTo : OCCReportToExp)
    func addedReportToLocationOffice(_ locationName : OfficeReportToLocation)
    
}
@objc protocol DOE_EditAddressDelegate: class{
    func DOE_EditAddress(_ locationName : String)
    
}
@objc protocol DOE_AddEditApplicantFromListDelegate: class{
    func DOE_AddEditApplicant(_ reportToPerson : DOEReportTo,prefixName: String)
    
}

@objc protocol HC_AddReportToDelegate: class{
    func HC_AddReportTo(_ reportToObj : ReportTo)
    
}

class AddNewReportToViewController: BaseTableViewController,UITextFieldDelegate,UITextViewDelegate,UIGestureRecognizerDelegate {
    
    
    
    var isSuccessMessage = false
    var isDuplicateAplicantsList = false
    
    var dropDownView = UIView()
    var  alertDropDownTableView = UITableView()
    let dropdownTableViewTag = 1009
    var dataEntryArray = NSMutableArray()
    @IBOutlet weak var addButton: UIButton!
    weak var delegate: addReportToDelegate? = nil
    weak var DOE_EditAddressDelegate: DOE_EditAddressDelegate? = nil
    weak var hcDelegate: HC_AddReportToDelegate? = nil
    weak var DOE_addEditApplFromListDelegate: DOE_AddEditApplicantFromListDelegate? = nil
    var isFromSummaryPage = false
    //MARK: OCC Add Report To
    var HC_First_Name  = ""
    var HC_Last_Name =  ""
    var HC_Title  = ""
    var HC_Phone =  ""
    var HC_Email = ""
    
    var isValidFirstName = true
    var isValidMiddleName = true
    var isValidLastName = true
    var isValidTitle = true
    var isValidPhone = true
    var isValidEmail = true
    var isValidDesc = true
    var isValidAddress = true
    var isValidCity = true
    var isValidFloor = true
    var isValidState = true
    var isValidZip = true
    var isValidConfirmEmail = true
    var isValidExtension = true
    
    var isValidFax = true
    
    var isValidCellphone = true
    
    //MARK: OCC Add Report To
    var OCC_ReportTo_First_Name  = ""
    var OCC_ReportTo_Last_Name =  ""
    var OCC_ReportTo_Title  = ""
    var OCC_ReportTo_Phone =  ""
    var OCC_ReportTo_Email = ""
    
    //MARK: Hospitality Add Report To
    var HOS_ReportTo_Title  = ""
    var HOS_ReportTo_First_Name  = ""
    var HOS_ReportTo_Last_Name =  ""
    var HOS_ReportTo_Phone =  ""
    var HOS_ReportTo_Email = ""
    var HOS_ReportTo_Desc = ""
    var HOS_ReportTo_Addess = ""
    var HOS_ReportTo_City = ""
    var HOS_ReportTo_Floor = ""
    var HOS_ReportTo_State = ""
    var HOS_ReportTo_Zip = ""
    var HOS_ReportTo_Directions = ""
        
    //MARK: DOE ADD APPLICANT
    var DOE_Name = ""
    var DOE_First_Name = ""
    var DOE_Middle_Name = ""
    var DOE_Last_Name = ""
    var DOE_Address = ""
    var DOE_City = ""
    var DOE_State_Name = ""
    var DOE_State_Code = ""
    
    var DOE_Zip = ""
    var DOE_Phone = ""
    var DOE_Email = ""
    var DOE_Confirm_Email = ""
    var DOE_Contact_ID = ""
    var DOE_Client_ID = ""
    var DOE_Prefix = ""
    var DOE_AddApplicantDict = NSDictionary()
    
    //MARK: DOE Edit Address
    var DOE_Edit_Location_Code = ""
    var DOE_Edit_Description = ""
    var DOE_Edit_Loc_Description = ""
    var DOE_Edit_Address = ""
    var DOE_Edit_City = ""
    var DOE_Edit_State = ""
    var DOE_Edit_Zip = ""
    var DOE_Edit_State_List = NSMutableArray()
    var selectedState = State.init(StateId: "", StateName: "", StateCode: "", isSelected: "0")
    //MARK: School Professional
    
    var ReportToName = ""
    var ReportToTitle = ""
    var ReportToPhone = ""
    var ReportToFax = ""
    var ReportToEmail = ""
    var ReportToAddress = ""
    var ReportToFloor = ""
    var ReportToState = ""
    var ReportToZip = ""
    var ReportToCellphone = ""
    var ReportToExtension = ""
    var ReportToCity = ""
    var ReportToDirections = ""
    
    var isForAddReportToSchoolProfessional = false
    var isForAddReportToHospitality = false
    var isForAddReportToLocationHospitality = false
    var isForAddReportToLocationOffice = false
    var isForAddReportToOffice = false
    var isForAddReportToOCC = false
    var isForAddReportToHealthCare = false
    var isForAddApplicantDOE = false
    var isForDOEEditAddress = false
    var isForDOEAddClientApplicantFromChooseList = false//from choose
    var isForDOEEditClientApplicantFromChooseList = false//from choose
    
    var activeField: UITextField?
    var activeTextView: UITextView?
    
    var LocationDescriptionTxtViewTAG = "101"
    var AddressTxtViewTAG = "102"
    var DirectionsTxtViewTAG = "103"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isForAddReportToLocationHospitality == true || isForAddReportToLocationOffice == true {
            self.titlelbl.text = "Add Report to Location"
        }else if isForAddReportToHealthCare == true{
            self.titlelbl.text = "Add Report to"
        }else if isForAddApplicantDOE == true  {
            self.titlelbl.text = "Add Applicant"
        }else if (isForDOEAddClientApplicantFromChooseList == true || isForDOEEditClientApplicantFromChooseList == true ) && (DOE_Name.count == 0){
            self.titlelbl.text = "Add client contact"
        }else if (isForDOEAddClientApplicantFromChooseList == true || isForDOEEditClientApplicantFromChooseList == true ) && (DOE_Name.count > 0){
            self.titlelbl.text = "Edit client contact"
        }else if isForDOEEditAddress == true{
            self.titlelbl.text = "Edit Address"
        } else{
            self.titlelbl.text = "Add New Report to"
        }
        
    }
    //MARK: View Methods
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.automaticallyAdjustsScrollViewInsets = false
        
        //        self.title = "Add New Report to"
        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        if isForAddReportToSchoolProfessional == true{
            
            self.createDataArrayForSchoolProfessional()
        }else if isForAddReportToHospitality == true || isForAddReportToOffice == true {
            self.createDataArrayForHospitality()
        }else if isForAddReportToLocationHospitality == true{
            self.createDataArrayForLocationHospitality()
        }else if isForAddReportToLocationOffice == true{
            self.createDataArrayForLocationOffice()
        }else if isForAddReportToOCC == true {
            self.createDataArrayForOCC()
        }else if isForAddReportToHealthCare == true{
            self.createDataArrayForHealthCare()
        }else if isForAddApplicantDOE == true{
            self.createDataArrayForDOE()
        }else if (isForDOEAddClientApplicantFromChooseList == true || isForDOEEditClientApplicantFromChooseList == true ){
            self.createDataArrayForDOEAddClient()
        }else if isForDOEEditAddress == true{
            self.createDataArrayForDOEEditAdress()
        }
        
        if dataEntryArray.count > 0{
            //add button cell in the array
            let buttonDict = ["placeholder":"Button Cell"]
            dataEntryArray.add(buttonDict)
        }
    }
    
    //MARK: Create Array
    
    func createDataArrayForDOEAddClient(){
        let nameDict = ["placeholder":"Name *","text":DOE_Name,"isError":"NO"]
        let addressDict = ["placeholder":"Address *","text":DOE_Address,"isError":"NO"]
        let cityDict = ["placeholder":"City *","text":DOE_City,"isError":"NO"]
        let stateDict = ["placeholder":"State *","text":DOE_State_Name,"isError":"NO"]
        let zipDict = ["placeholder":"Zip *","text":DOE_Zip,"isError":"NO"]
        let phoneDict = ["placeholder":"Phone Number *","text":DOE_Phone,"isError":"NO"]
        let emailDict = ["placeholder":"Email *","text":DOE_Email,"isError":"NO"]
        let confirmemailDict = ["placeholder":"Confirm Email *","text":DOE_Confirm_Email,"isError":"NO"]
        
        dataEntryArray = [nameDict,addressDict,cityDict,stateDict,zipDict,phoneDict,emailDict,confirmemailDict]
        
        self.tableView.reloadData()
    }
    func createDataArrayForDOEEditAdress(){
        let dataDict = ["placeholder":"LocDetails","text":DOE_Edit_Description,"isError":"NO"]
        let dataHeaderDict = ["placeholder":"LocDetailsHeader","text":DOE_Edit_Loc_Description,"isError":"NO"]
        let addressDict = ["placeholder":"Address *","text":DOE_Edit_Address,"isError":"NO"]
        let cityDict = ["placeholder":"City *","text":DOE_Edit_City,"isError":"NO"]
        let stateDict = ["placeholder":"State *","text":DOE_Edit_State,"isError":"NO"]
        let zipDict = ["placeholder":"Zip *","text":DOE_Edit_Zip,"isError":"NO"]
        
        dataEntryArray = [dataHeaderDict,dataDict,addressDict,cityDict,stateDict,zipDict]
        
        self.tableView.reloadData()
    }
    func createDataArrayForDOE(){
        let fNameDict = ["placeholder":"First Name *","text":DOE_First_Name,"isError":"NO"]
        let mNameDict = ["placeholder":"Middle Name ","text":DOE_Middle_Name,"isError":"NO"]
        let lNameDict = ["placeholder":"Last Name *","text":DOE_Last_Name,"isError":"NO"]
        let addressDict = ["placeholder":"Address *","text":DOE_Address,"isError":"NO"]
        let cityDict = ["placeholder":"City *","text":DOE_City,"isError":"NO"]
        let stateDict = ["placeholder":"State *","text":DOE_State_Name,"isError":"NO"]
        let zipDict = ["placeholder":"Zip *","text":DOE_Zip,"isError":"NO"]
        let phoneDict = ["placeholder":"Phone Number *","text":DOE_Phone,"isError":"NO"]
        let emailDict = ["placeholder":"Email *","text":DOE_Email,"isError":"NO"]
        let confirmemailDict = ["placeholder":"Confirm Email *","text":DOE_Confirm_Email,"isError":"NO"]
        
        dataEntryArray = [fNameDict,mNameDict,lNameDict,addressDict,cityDict,stateDict,zipDict,phoneDict,emailDict,confirmemailDict]
        
        self.tableView.reloadData()
    }
    func createDataArrayForHealthCare(){
        let fNameDict = ["placeholder":"First Name *","text":HC_First_Name,"isError":"NO"]
        let lNameDict = ["placeholder":"Last Name *","text":HC_Last_Name,"isError":"NO"]
        let titleDict = ["placeholder":"Title *","text":HC_Title,"isError":"NO"]
        let phoneDict = ["placeholder":"Phone Number","text":HC_Phone,"isError":"NO"]
        let emailDict = ["placeholder":"Email *","text":HC_Email,"isError":"NO"]
        
        dataEntryArray = [titleDict,fNameDict,lNameDict,phoneDict,emailDict]
        
        self.tableView.reloadData()
    }
    func createDataArrayForOCC(){
        let fNameDict = ["placeholder":"First Name *","text":OCC_ReportTo_First_Name,"isError":"NO"]
        let lNameDict = ["placeholder":"Last Name *","text":OCC_ReportTo_Last_Name,"isError":"NO"]
        let titleDict = ["placeholder":"Title *","text":OCC_ReportTo_Title,"isError":"NO"]
        let phoneDict = ["placeholder":"Phone Number","text":OCC_ReportTo_Phone,"isError":"NO"]
        let emailDict = ["placeholder":"Email *","text":OCC_ReportTo_Email,"isError":"NO"]
        
        dataEntryArray = [fNameDict,lNameDict,titleDict,phoneDict,emailDict]
        
        self.tableView.reloadData()
    }
    func createDataArrayForLocationOffice(){
        
        let descDict = ["placeholder":"Location Description","text":HOS_ReportTo_Desc,"isError":"NO","Tag":LocationDescriptionTxtViewTAG]
        let addressDict = ["placeholder":"Address *","text":HOS_ReportTo_Addess,"isError":"NO","Tag":AddressTxtViewTAG]
        let cityDict = ["placeholder":"City *","text":HOS_ReportTo_City,"isError":"NO"]
        let floorDict = ["placeholder":"Floor *","text":HOS_ReportTo_Floor,"isError":"NO"]
        let stateDict = ["placeholder":"State *","text":HOS_ReportTo_State,"isError":"NO"]
        let zipDict = ["placeholder":"Zip Code *","text":HOS_ReportTo_Zip,"isError":"NO"]
        let directionsDict = ["placeholder":"Directions","text":HOS_ReportTo_Directions,"isError":"NO","Tag":DirectionsTxtViewTAG]
        dataEntryArray = [descDict,addressDict,cityDict,floorDict,stateDict,zipDict,directionsDict]
        
        self.tableView.reloadData()
        
    }
    func createDataArrayForLocationHospitality(){
        
        let descDict = ["placeholder":"Location Description *","text":HOS_ReportTo_Desc,"isError":"NO","Tag":LocationDescriptionTxtViewTAG]
        let addressDict = ["placeholder":"Address *","text":HOS_ReportTo_Addess,"isError":"NO","Tag":AddressTxtViewTAG]
        let cityDict = ["placeholder":"City *","text":HOS_ReportTo_City,"isError":"NO"]
        let floorDict = ["placeholder":"Floor","text":HOS_ReportTo_Floor,"isError":"NO"]
        let stateDict = ["placeholder":"State *","text":HOS_ReportTo_State,"isError":"NO"]
        let zipDict = ["placeholder":"Zip Code *","text":HOS_ReportTo_Zip,"isError":"NO"]
        let directionsDict = ["placeholder":"Directions","text":HOS_ReportTo_Directions,"isError":"NO","Tag":DirectionsTxtViewTAG]
        
        dataEntryArray = [descDict,addressDict,cityDict,floorDict,stateDict,zipDict,directionsDict]
        
        self.tableView.reloadData()
        
    }
    func createDataArrayForHospitality(){
        
        let titleDict = ["placeholder":"Title *","text":HOS_ReportTo_Title,"isError":"NO"]
        let firstName = ["placeholder":"First Name *","text":HOS_ReportTo_First_Name,"isError":"NO"]
        let lastName = ["placeholder":"Last Name *","text":HOS_ReportTo_Last_Name,"isError":"NO"]
        let phoneDict = ["placeholder":"Phone Number","text":HOS_ReportTo_Phone,"isError":"NO"]
        let emailDict = ["placeholder":"Email *","text":HOS_ReportTo_Email,"isError":"NO"]
        
        dataEntryArray = [ titleDict,firstName,lastName,phoneDict,emailDict]
        
        self.tableView.reloadData()
        
    }
    func createDataArrayForSchoolProfessional(){
        
        let nameDict = ["placeholder":"Name *","text":ReportToName,"isError":"NO"]
        let titleDict = ["placeholder":"Title","text":ReportToTitle,"isError":"NO"]
        let phoneDict = ["placeholder":"Phone Number","text":ReportToPhone,"isError":"NO"]
        let extensionDict = ["placeholder":"Extension","text":ReportToExtension,"isError":"NO"]
        let faxDict = ["placeholder":"Fax","text":ReportToFax,"isError":"NO"]
        let cellPhDict = ["placeholder":"Cell Phone","text":ReportToCellphone,"isError":"NO"]
        let addressDict = ["placeholder":"Address","text":ReportToAddress,"isError":"NO"]
        let emailDict = ["placeholder":"Email *","text":ReportToEmail,"isError":"NO"]
        let cityDict = ["placeholder":"City","text":ReportToCity,"isError":"NO"]
        let floorDict = ["placeholder":"Floor","text":ReportToFloor,"isError":"NO"]
        let zipDict = ["placeholder":"Zip","text":ReportToZip,"isError":"NO"]
        let stateDict = ["placeholder":"State","text":ReportToState,"isError":"NO"]
        
        dataEntryArray = [nameDict,titleDict,phoneDict,extensionDict,cellPhDict,faxDict,emailDict,addressDict,floorDict,cityDict,stateDict,zipDict]
        
        self.tableView.reloadData()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TABLEVIEW METHODS
    //    override  public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
    //        if tableView.tag == Int(dropdownTableViewTag)  {
    //        return 0
    //        }
    //        return 70
    //    }
    //    override public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
    //        if tableView.tag == Int(dropdownTableViewTag)  {
    //        return nil
    //        }
    //        return self.nextBtnFooterView()
    //    }
    //
    //    func nextBtnFooterView() -> UIView{
    //
    //        let footerView = Bundle.main.loadNibNamed("ButtonFooterView", owner: self, options: nil)?[0] as! ButtonFooterView
    //        footerView.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: 70)
    //        footerView.nextButton.addTarget(self, action:#selector(self.addBtnTapped), for:.touchUpInside)
    //       footerView.nextButton.isHidden = false
    //       footerView.saveButton.isHidden = true
    //       footerView.cancelButton.isHidden = true
    //        if isForAddReportToHealthCare == true{
    //       footerView.nextButton.setTitle("Add", for: .normal)
    //        }
    //        if isForAddApplicantDOE == true || isForDOEEditAddress == true || isForDOEAddClientApplicantFromChooseList == true{
    //            footerView.nextButton.isHidden = true
    //            footerView.saveButton.isHidden = false
    //            footerView.cancelButton.isHidden = false
    //
    //            footerView.cancelButton.addTarget(self, action:#selector(self.cancelButtonTapped), for:.touchUpInside)
    //            footerView.saveButton.addTarget(self, action:#selector(self.saveButtonTapped), for:.touchUpInside)
    //
    //        }
    //        return footerView
    //    }
    func errorTextField(textField: UIView){
        
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1
    }
    override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == Int(dropdownTableViewTag)  {
            return DOE_Edit_State_List.count
        }
        return dataEntryArray.count
    }
    func dropDownTableViewCellWithIndexPath(indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?
        if !(cell != nil) {
            cell = UITableViewCell(style:.subtitle, reuseIdentifier: "CELL")
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let obj = DOE_Edit_State_List[indexPath.row]
        
        let  o:State = obj as! State
        cell?.textLabel?.text = o.StateName
        if o.isSelected == "1"{
            cell?.accessoryType = .checkmark
        }else{
            cell?.accessoryType = .none
        }
        return cell!
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView.tag == Int(dropdownTableViewTag)  {
            
            return self.dropDownTableViewCellWithIndexPath(indexPath: indexPath as NSIndexPath)
            
        }
        
        let dict = dataEntryArray[indexPath.row] as! NSDictionary
        
        let placeholder = dict["placeholder"] as! String
        if placeholder == "Button Cell"{
            return self.ButtonTableCell(indexPath: indexPath as NSIndexPath)
        }
        if isForAddReportToLocationHospitality == true || isForAddReportToLocationOffice == true{
            if placeholder.contains("Location Description")  || placeholder == "Address" || placeholder == "Directions"{
                return textViewCell(tableView: tableView, indexPath: indexPath as NSIndexPath, placeHolder: placeholder ,dataDict: dict)
                
            }
        }else  if isForDOEEditAddress == true{
            if placeholder == "LocDetailsHeader"{//placeholder    String    "LocDetails "
                var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?
                if !(cell != nil) {
                    cell = UITableViewCell(style:.subtitle, reuseIdentifier: "CELL")
                }
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                cell?.textLabel?.numberOfLines = 0
                cell?.backgroundColor = UIColor.white
                let value = dict["text"] as! String
                cell?.textLabel?.text = value
                
                cell?.textLabel?.numberOfLines = 0
                return cell!
            }
        }
        let cell:AddNewReportTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddNewReportTableViewCellIdentifier") as! AddNewReportTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.dataTextField.delegate = self
        
        
        cell.lblHeading.text = placeholder
        cell.dataTextField.text = (dict["text"] as! String)
        cell.dataTextField.placeholder = placeholder
        cell.TextFieldBGView.layer.borderColor = UIColor.black.cgColor
        cell.TextFieldBGView.layer.borderWidth = 1
        cell.lblHeading.textColor = UIColor.black
        if isForAddReportToSchoolProfessional == true {
            //For SP , Name and EMail is Req
            if placeholder.contains("Email") && isValidEmail == false {
                 self.errorTextField(textField: cell.TextFieldBGView)
             }
            if placeholder.contains("Name") && isValidEmail == false{
                self.errorTextField(textField: cell.TextFieldBGView)
            }
            if placeholder.contains("*"){
                cell.lblHeading.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.black)
            }
        }else if isForAddReportToHospitality == true || isForAddReportToOffice == true || isForAddReportToOCC == true || isForAddReportToHealthCare == true{
            
          
            if placeholder.contains("Email") && isValidEmail == false {
                 self.errorTextField(textField: cell.TextFieldBGView)
             }
            if placeholder.contains("First Name") && isValidFirstName == false {
                 self.errorTextField(textField: cell.TextFieldBGView)
             }
            if placeholder.contains("Last Name") && isValidFirstName == false {
                 self.errorTextField(textField: cell.TextFieldBGView)
             }
            if placeholder.contains("Title") && isValidTitle == false {
                 self.errorTextField(textField: cell.TextFieldBGView)
             }
//            if placeholder.contains("Phone") && isValidPhone == false {
//                 self.errorTextField(textField: cell.TextFieldBGView)
//             }
            if placeholder.contains("*"){
                cell.lblHeading.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.black)
            }
        }else if   isForAddReportToLocationHospitality == true{
 
            
            if   placeholder.contains("City") && isValidCity == false{
                 self.errorTextField(textField: cell.TextFieldBGView)
             }
            if   placeholder.contains("Zip") && isValidZip == false{
                 self.errorTextField(textField: cell.TextFieldBGView)
             }
            if   placeholder.contains("Address") && isValidAddress == false{
                 self.errorTextField(textField: cell.TextFieldBGView)
             }
            if   placeholder.contains("State") && isValidState == false{
                 self.errorTextField(textField: cell.TextFieldBGView)
             }
            if placeholder.contains("*"){
                cell.lblHeading.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.black)
            }
            
        }else if isForAddReportToLocationOffice == true{
             if   placeholder.contains("State") && isValidState == false{
                 self.errorTextField(textField: cell.TextFieldBGView)
             }
            if   placeholder.contains("City") && isValidCity == false{
                 self.errorTextField(textField: cell.TextFieldBGView)
             }
            if   placeholder.contains("Zip") && isValidZip == false{
                 self.errorTextField(textField: cell.TextFieldBGView)
             }
            if   placeholder.contains("Address") && isValidAddress == false{
                 self.errorTextField(textField: cell.TextFieldBGView)
             }
            if   placeholder.contains("Floor") && isValidFloor == false{
                 self.errorTextField(textField: cell.TextFieldBGView)
             }
            if placeholder.contains("*"){
                cell.lblHeading.halfTextColorChange(fullText: placeholder, changeText: "*", textColor: UIColor.black)
            }
        }
        
        /*
          var isForAddReportToHealthCare = false

         */
        if placeholder.contains("Phone") || placeholder == "Fax" || placeholder.contains("Mobile") || placeholder.contains("Number") || placeholder.contains("Zip") {
            cell.dataTextField.keyboardType = UIKeyboardType.numberPad
        }else if placeholder.contains("Email") {
            cell.dataTextField.keyboardType = UIKeyboardType.emailAddress
        }else{
            cell.dataTextField.keyboardType = UIKeyboardType.default
        }
        if (isForDOEEditAddress == true || isForDOEAddClientApplicantFromChooseList == true || isForDOEEditClientApplicantFromChooseList == true || isForAddApplicantDOE ) && placeholder == "State *"{
            
            let  dict:NSDictionary = dataEntryArray[(indexPath.row)] as! NSDictionary
            let myMutableDict: NSMutableDictionary = NSMutableDictionary(dictionary: dict)
            //convert immutable Dict to mutable Dict
            myMutableDict["text"] = selectedState.StateName
            dataEntryArray.replaceObject(at: (indexPath.row), with: myMutableDict)
            
            cell.dataTextField.text = selectedState.StateName
            self.addRightImageToTextField(textField: cell.dataTextField, imageName: "expand-arrow")
        }else{
            cell.dataTextField.rightViewMode = UITextField.ViewMode.never
            cell.dataTextField.rightViewMode = .never
            
        }
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(keyboardDoneBtnTapped))]
        toolBar.sizeToFit()
        cell.dataTextField.inputAccessoryView = toolBar
        
        
        cell.dataTextField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        return cell
    }
    
    func ButtonTableCell(indexPath: NSIndexPath) -> ButtonTableViewCell {
        
        let cell:ButtonTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "NextTableViewCellIdentifier") as! ButtonTableViewCell
        cell.dButton.isHidden = false
        cell.nextButton.isHidden = true
        cell.backButton.isHidden = true
        
        cell.dButton.removeTarget(self, action:#selector(self.addBtnTapped), for:.touchUpInside)
        
        cell.dButton.addTarget(self, action:#selector(self.addBtnTapped), for:.touchUpInside)
        
        //        if isForAddReportToHealthCare == true || isForAddReportToHospitality == true || isForAddReportToLocationHospitality == true{
        //            cell.dButton.setTitle("Add", for: .normal)
        //        }
        //        else
        
        cell.dButton.setTitle("Add", for: .normal)
        
        if isForDOEEditClientApplicantFromChooseList == true {
            cell.nextButton.setTitle("Update", for: .normal)
        }
        if isForAddApplicantDOE == true || isForDOEEditAddress == true || (isForDOEAddClientApplicantFromChooseList == true || isForDOEEditClientApplicantFromChooseList == true ){
            cell.dButton.isHidden = true
            cell.nextButton.isHidden = false
            cell.backButton.isHidden = false
            
            cell.backButton.addTarget(self, action:#selector(self.cancelButtonTapped), for:.touchUpInside)
            cell.nextButton.addTarget(self, action:#selector(self.saveButtonTapped), for:.touchUpInside)
            
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        return cell
        
    }
    func textViewCell(tableView: UITableView,indexPath: NSIndexPath,placeHolder: String,dataDict: NSDictionary) -> TextViewTableViewCell {
        
        let cell:TextViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TextViewTableViewCellIdentifier") as! TextViewTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        let tag =  dataDict["Tag"] as! String
        cell.entryTextView.tag = Int(tag)!
        
        cell.entryTextView.layer.borderColor = borderColor.cgColor
        cell.entryTextView.layer.borderWidth = 1
        cell.entryTextView.delegate = self
        cell.lblHeader.text = placeHolder
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(keyboardDoneBtnTapped))]
        toolBar.sizeToFit()
        cell.lblHeader.textColor = UIColor.black
        
        cell.entryTextView.inputAccessoryView = toolBar
        
        if isForAddReportToLocationOffice == true{
            if   placeHolder.contains("Address") && isValidAddress == false{
                if placeHolder.contains("*"){
                    cell.lblHeader.halfTextColorChange(fullText: placeHolder, changeText: "*", textColor: UIColor.black)
                }
                cell.entryTextView.layer.borderColor = UIColor.red.cgColor
            }
        }
        if isForAddReportToLocationHospitality == true{
            if   placeHolder.contains("Description") && isValidDesc == false{
                if placeHolder.contains("*"){
                    cell.lblHeader.halfTextColorChange(fullText: placeHolder, changeText: "*", textColor: UIColor.black)
                }
                cell.entryTextView.layer.borderColor = UIColor.red.cgColor
            }
        }
        
        return cell
        
    }
    override   public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == Int(dropdownTableViewTag)  {
            return 40
        }
        let dict = dataEntryArray[indexPath.row] as! NSDictionary
        
        let placeholder = dict["placeholder"] as! String
        if isForDOEEditAddress == true{
            if placeholder == "LocDetailsHeader"{
                return 60
            }else if placeholder == "LocDetails"{
                return 0
            }
            
        }
        if isForAddReportToLocationHospitality == true || isForAddReportToLocationOffice == true{
            if placeholder.contains("Location") || placeholder.contains("Directions"){
                return 111
            }
        }
        
        return 80
        
    }
    override  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if tableView.tag == dropdownTableViewTag{
            
            let obj = DOE_Edit_State_List[indexPath.row]
            
            let  o:State = obj as! State
            
            selectedState = o
            for obj in DOE_Edit_State_List{
                let reportObj:State = obj as! State
                reportObj.isSelected = "0"
            }
            DOE_State_Code = selectedState.StateCode!
            DOE_State_Name = selectedState.StateName!
            selectedState.isSelected = "1"
            self.removeDropDown()
            self.tableView.reloadData()
            
        }
    }
    @objc func keyboardDoneBtnTapped(sender: UIButton)  {
        self.view.endEditing(true)
    }
    //MARK: - Validation Methods
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate (with : testStr)
    }
    
    //    func isValidPhoneNumber(phoneNumber: String) -> Bool {
    //        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
    //        let inputString = phoneNumber.components(separatedBy: charcterSet)
    //        let filtered = inputString.joined(separator: "")
    //        return  phoneNumber == filtered
    //    }
    func isValidPhoneNumber(phoneNumber: String) -> Bool {
        if phoneNumber.count == 10{
            return true
        }
        return false
    }
    func isAlphanumeric(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z]"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate (with : testStr)
    }
    //MARK: UITEXTVIEW Delegate
    
    
    
    public func textViewDidEndEditing(_ textView: UITextView)
    {
        self.activeTextView = nil
        
        let txtFieldPosition  = textView.convert(CGPoint.zero, to: self.tableView)
        
        let indexPath =  self.tableView.indexPathForRow(at:txtFieldPosition)
        
        if indexPath  != nil{
            var dict = NSDictionary()
            if (isForAddReportToLocationHospitality || isForAddReportToLocationOffice) && textView.tag == Int(DirectionsTxtViewTAG) {
                dict = dataEntryArray[6] as! NSDictionary
            }
            else {
                dict = dataEntryArray[(indexPath?.row)!] as! NSDictionary
            }
            
         //   let  dict:NSDictionary = dataEntryArray[(indexPath?.row)!] as! NSDictionary
            
            let myMutableDict: NSMutableDictionary = NSMutableDictionary(dictionary: dict)
            //convert immutable Dict to mutable Dict
            
            if (textView.text?.count)! > 0 {
                
                //set values in dictionary to show in uitableview
                
                myMutableDict["text"] = textView.text!
                if textView.tag == Int(LocationDescriptionTxtViewTAG){
                    if textView.text.count == 0{
                        myMutableDict["isError"] = "YES"
                    }
                    HOS_ReportTo_Desc = textView.text
                }else if textView.tag == Int(AddressTxtViewTAG){
                    
                    HOS_ReportTo_Addess = textView.text
                }else if textView.tag == Int(DirectionsTxtViewTAG){
                    
                    HOS_ReportTo_Directions = textView.text
                }
                
                if (isForAddReportToLocationHospitality || isForAddReportToLocationOffice) && textView.tag == Int(DirectionsTxtViewTAG) {
                    dataEntryArray.replaceObject(at: 6, with: myMutableDict)

                }
                else {
                dataEntryArray.replaceObject(at: (indexPath?.row)!, with: myMutableDict)
                }
            }
        }
        
        self.tableView .reloadData()
        
    }
    
    
    func getLength(mNumber: String) -> Int{
        
        var length = 0
        var mobileNumber = mNumber
        mobileNumber =  mobileNumber.replacingOccurrences(of: "(", with: "")
        mobileNumber =  mobileNumber.replacingOccurrences(of: ")", with: "")
        mobileNumber =  mobileNumber.replacingOccurrences(of: " ", with: "")
        mobileNumber =  mobileNumber.replacingOccurrences(of: "-", with: "")
        mobileNumber =  mobileNumber.replacingOccurrences(of: "+", with: "")
        length = mobileNumber.count
        return length
        
    }
    func formatNumber(mNumber: String) -> String {
        var mobileNumber = mNumber
        
        mobileNumber =  mobileNumber.replacingOccurrences(of: "(", with: "")
        mobileNumber =  mobileNumber.replacingOccurrences(of: ")", with: "")
        mobileNumber =  mobileNumber.replacingOccurrences(of: " ", with: "")
        mobileNumber =  mobileNumber.replacingOccurrences(of: "-", with: "")
        mobileNumber =  mobileNumber.replacingOccurrences(of: "+", with: "")
        print(mobileNumber)
        if mobileNumber.count > 10
        {
            mobileNumber = mobileNumber.substring(from: mobileNumber.count - 10) //[mobileNumber substringFromIndex: length-10];
            print(mobileNumber)
            
        }
        
        return  mobileNumber
    }
    
    
    //MARK:-  textField Delegate method
    
    
    public  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let txtFieldPosition  = textField.convert(CGPoint.zero, to: self.tableView)
        
        let indexPath =  self.tableView.indexPathForRow(at:txtFieldPosition)
        
        
        if indexPath != nil{
            
            let  dict:NSDictionary = dataEntryArray[(indexPath?.row)!] as! NSDictionary
            
            let placeholder = dict["placeholder"] as! String
            if placeholder.contains("Phone") || placeholder == "Fax" || placeholder.contains("Mobile") || placeholder.contains("Number"){
                //            let charsLimit = 10
                //                let startingLength = textField.text?.count ?? 0
                //                let lengthToAdd = string.count
                //                let lengthToReplace =  range.length
                //                let newLength = startingLength + lengthToAdd - lengthToReplace
                //
                //                return newLength <= charsLimit
                ///////****////
                let length = self.getLength(mNumber: textField.text!)
                print(length)
                if length == 10{
                    if range.length == 0{
                        return false
                    }
                }
                
                if length == 3{
                    
                    let num = self.formatNumber(mNumber: textField.text!)
                    textField.text = String(format:"(%@)-",num)
                    
                    if range.length > 0{
                        textField.text = String(format:"%@",num.substring(to: 3))
                    }
                }else if length == 6{
                    let num = self.formatNumber(mNumber: textField.text!)
                    textField.text = String(format:"(%@)-%@-",num.substring(to: 3),num.substring(from: 3))
                    
                    if range.length > 0{
                        textField.text = String(format:"(%@)-%@",num.substring(to: 3),num.substring(from: 3))
                    }
                    
                }
                //////******////
            }else if placeholder.contains("Zip"){
                
                let allowedCharacters = CharacterSet.decimalDigits
                let characterSet = CharacterSet(charactersIn: string)
                let isAllNumbers = allowedCharacters.isSuperset(of: characterSet)
                if isAllNumbers == true{
                    
                    let charsLimit = 5
                    let startingLength = textField.text?.count ?? 0
                    let lengthToAdd = string.count
                    let lengthToReplace =  range.length
                    let newLength = startingLength + lengthToAdd - lengthToReplace
                    
                    return newLength <= charsLimit
                }else{
                    return false
                }
            }else if placeholder.contains("State"){
                
                if  isForAddReportToLocationHospitality == true  || isForAddReportToLocationOffice == true{
                    
                    let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ")
                    let characterSet = CharacterSet(charactersIn: string)
                    let isCharecters = allowedCharacters.isSuperset(of: characterSet)
                    if isCharecters == true{
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
            else {
                return true
            }
        }
        
        return true
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        // Try to find next responder
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
        
        if nextResponder != nil {
            // Found next responder, so set it
            nextResponder?.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }
        
        return false
    }
    public func textFieldDidBeginEditing(_ textField: UITextField){
        
        self.activeField = textField
        if (isForDOEEditAddress == true || (isForDOEAddClientApplicantFromChooseList == true || isForDOEEditClientApplicantFromChooseList == true || isForAddApplicantDOE == true )) && textField.placeholder == "State *"{
            if DOE_Edit_State_List.count > 0{
                //show dropdown of state list
                textField.resignFirstResponder()
                self.showDropDownTableViewWithTag(placeHolder: "Select State", tag: dropdownTableViewTag)
            }
            else{
                textField.becomeFirstResponder()
            }
        }else{
            if textField.placeholder == "Pick Location" {
                textField.resignFirstResponder()
            }else if (textField.placeholder?.contains("Phone Number"))! || textField.placeholder == "Fax" || textField.placeholder == "Cell Phone"{
                textField.keyboardType = UIKeyboardType.numberPad
            }else if(textField.placeholder?.contains("mail"))!{
                textField.keyboardType = UIKeyboardType.emailAddress
            }else{
                textField.keyboardType = UIKeyboardType.default
            }
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField){
        
        let txtFieldPosition  = textField.convert(CGPoint.zero, to: self.tableView)
        
        let indexPath =  self.tableView.indexPathForRow(at:txtFieldPosition)
        
        if indexPath  != nil{
            
            let  dict:NSDictionary = dataEntryArray[(indexPath?.row)!] as! NSDictionary
            
            let myMutableDict: NSMutableDictionary = NSMutableDictionary(dictionary: dict)
            //convert immutable Dict to mutable Dict
            
            if (textField.text?.count)! > 0 {
                
                //set values in dictionary to show in uitableview
                
                myMutableDict["text"] = textField.text!
                
            }
            
            //VALIDATIONS
            
            let placeholder = dict["placeholder"] as! String
            if placeholder == "Email"{
                
                if textField.text?.count == 0 {
                    
                    myMutableDict["isError"] = "YES"
                }else{
                    
                    let isValidEmail = self.isValidEmail(testStr: textField.text!)
                    
                    if isValidEmail {
                        myMutableDict["isError"] = "NO"
                    }else{
                        myMutableDict["isError"] = "YES"
                    }
                    
                }
                
            }else if placeholder == "Phone Number" || placeholder == "Cell Phone"{
                if isForAddReportToHospitality == true || isForAddReportToOffice == true || isForAddReportToOCC == true || isForAddReportToHealthCare == true{
                    myMutableDict["isError"] = "NO"
//#7800. CMA : iOS : Enhancement for ROS
                }else{
                    
                    if textField.text?.count == 0 {
                        myMutableDict["isError"] = "YES"
                    }else{
                        
                        var  isValidPhoneNumber = self.isValidPhoneNumber(phoneNumber: textField.text!)
                        if textField.text?.count == 10{
                            isValidPhoneNumber = true
                        }else{
                            isValidPhoneNumber = false
                        }
                        
                        if isValidPhoneNumber {//}&& (textField.text?.characters.count)! > 0 {
                            myMutableDict["isError"] = "NO"
                        }else{
                            myMutableDict["isError"] = "YES"
                        }
                    }
                }
                
            }else{
                
                ///
                if textField.text?.count == 0 {
                    myMutableDict["isError"] = "YES"
                }else{
                    myMutableDict["isError"] = "NO"
                }
                ///
            }
            
            
            dataEntryArray.replaceObject(at: (indexPath?.row)!, with: myMutableDict)
            
            self.tableView .reloadData()
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
      return newText.count <= 1000
    }
    
   
    
    func validateContactData() -> Bool {
        
        var isValidated  = false
        
        for dict1   in dataEntryArray {
            
            let  dict:NSDictionary = dict1 as! NSDictionary
            
            let placeholder = dict["placeholder"] as! String
            
            if placeholder.contains("Email"){
                if isForAddReportToHospitality == true{
                    HOS_ReportTo_Email = dict["text"] as! String
                }else{
                    ReportToEmail = dict["text"] as! String
                    
                }
            }else  if placeholder.contains("Name"){
                
                ReportToName = dict["text"] as! String
            }else  if placeholder == "Title"{
                if isForAddReportToHospitality == true{
                    HOS_ReportTo_Title = dict["text"] as! String
                }else{
                    
                    ReportToTitle = dict["text"] as! String
                }
            }else  if placeholder == "Phone Number"{
                if isForAddReportToHospitality == true{
                    HOS_ReportTo_Phone = dict["text"] as! String
                }else{
                    
                    ReportToPhone = dict["text"] as! String
                }
            }else  if placeholder == "Extension"{
                ReportToExtension = dict["text"] as! String
            }else  if placeholder == "Fax"{
                ReportToFax = dict["text"] as! String
            }else  if placeholder == "Cell Phone"{
                ReportToCellphone = dict["text"] as! String
            }else  if placeholder == "Address"{
                if isForAddReportToHospitality == true{
                    HOS_ReportTo_Addess = dict["text"] as! String
                }else{
                    
                    ReportToAddress = dict["text"] as! String
                }
            }else  if placeholder == "Email"{
                ReportToEmail = dict["text"] as! String
            }else  if placeholder == "City"{
                if isForAddReportToHospitality == true{
                    HOS_ReportTo_City = dict["text"] as! String
                }else{
                    
                    ReportToCity = dict["text"] as! String
                }
            }else  if placeholder == "Floor"{
                if isForAddReportToHospitality == true{
                    HOS_ReportTo_Floor = dict["text"] as! String
                }else{
                    
                    ReportToFloor = dict["text"] as! String
                }
            }else  if placeholder.contains("Zip"){
                if isForAddReportToHospitality == true{
                    HOS_ReportTo_Zip = dict["text"] as! String
                }else{
                    
                    ReportToZip = dict["text"] as! String
                }
            }else  if placeholder == "State"{
                if isForAddReportToHospitality == true{
                    HOS_ReportTo_State = dict["text"] as! String
                }else{
                    
                    ReportToState = dict["text"] as! String
                }
            }
            
            
        }
        
          isValidEmail = self.isValidEmail(testStr: ReportToEmail)
        
        
          isValidTitle = ReportToTitle.count >= 0 ? true : false
        isValidFirstName = ReportToName.count > 0 ? true : false
        
          isValidPhone = self.isValidPhoneNumber(phoneNumber: ReportToPhone.digitsOnly())
 
          isValidExtension = ReportToExtension.count >= 0 ? true : false
        
          isValidFax =  ReportToFax.count >= 0 ? true : false //self.isValidPhoneNumber(phoneNumber: ReportToFax)
        
          isValidCellphone = self.isValidPhoneNumber(phoneNumber: ReportToCellphone.digitsOnly())
 
          isValidAddress = ReportToAddress.count >= 0 ? true : false
        
        
          isValidCity = ReportToCity.count >= 0 ? true : false
        
          isValidFloor = ReportToFloor.count >= 0 ? true : false
          isValidZip = ReportToZip.count >= 0 ? true : false
          isValidState = ReportToState.count >= 0 ? true : false
        
        
 
        if isValidFirstName && isValidEmail {
            isValidated =  true

        }
 
        return isValidated
    }
    func HOS_ValidateAddReportToLocationData() -> Bool {
        
        var isValidated  = false
        
        for dict1   in dataEntryArray {
            
            let  dict:NSDictionary = dict1 as! NSDictionary
            
            let placeholder = dict["placeholder"] as! String
            
            if placeholder.contains("Location Description"){
                
                HOS_ReportTo_Desc = dict["text"] as! String
                
            }else  if placeholder == "Address *"{
                
                HOS_ReportTo_Addess = dict["text"] as! String
            }else  if placeholder == "City *"{
                
                HOS_ReportTo_City = dict["text"] as! String
                
            }else if placeholder.contains("Floor"){
                
                HOS_ReportTo_Floor = dict["text"] as! String
                
            }else  if placeholder.contains("State"){
                
                HOS_ReportTo_State = dict["text"] as! String
                
            }else if placeholder == "Zip Code *"{
                HOS_ReportTo_Zip = dict["text"] as! String
                
            }
            else  if placeholder == "Directions"{
                HOS_ReportTo_Directions = dict["text"] as! String
            }
        }
        
        
          isValidDesc = HOS_ReportTo_Desc.count > 0 ? true : false
        
          isValidCity  = HOS_ReportTo_City.count > 0 ? true : false
        
          isValidZip = HOS_ReportTo_Zip.count >= 5 ? true : false
         isValidState = HOS_ReportTo_State.count > 0 ? true : false

          isValidAddress = HOS_ReportTo_Addess.count > 0 ? true : false
         if  isValidState && isValidCity && isValidZip && isValidAddress && isValidDesc{
            
            isValidated =  true
            
        }else{
            
            isSuccessMessage = false
            isDuplicateAplicantsList = false
//            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Please enter all the mandatory fields", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
            isValidated =  false
         }
        
        
        
        return isValidated
    }
    func DOE_ValidateAddApplicantData() -> Bool {
        
        var isValidated  = false
        
        for dict1   in dataEntryArray {
            
            let  dict:NSDictionary = dict1 as! NSDictionary
            
            let placeholder = dict["placeholder"] as! String
            
            if placeholder.contains("First Name"){
                
                DOE_First_Name = dict["text"] as! String
                
            }else if placeholder.contains("Last Name"){
                
                DOE_Last_Name = dict["text"] as! String
                
            }else if placeholder.contains("Middle Name"){
                
                DOE_Middle_Name = dict["text"] as! String
                
            }else  if placeholder.contains("Address"){
                
                DOE_Address = dict["text"] as! String
            }else  if placeholder == "City *"{
                
                DOE_City = dict["text"] as! String
                
            }else if placeholder.contains("State"){
                
                DOE_State_Name = dict["text"] as! String
                
            }else if placeholder.contains("Zip"){
                DOE_Zip = dict["text"] as! String
                
            }else if placeholder.contains("Phone"){
                DOE_Phone = dict["text"] as! String
                
            }else if placeholder == "Email *"{
                
                DOE_Email = dict["text"] as! String
                
            }else if placeholder == "Confirm Email *"{
                
                DOE_Confirm_Email = dict["text"] as! String
                
            }
            
        }
        
        
        let isValidFName = DOE_First_Name.count > 0 ? true : false
        let isValidLName = DOE_Last_Name.count > 0 ? true : false
        let isValidAddress = DOE_Address.count > 0 ? true : false
        let isValidCity  = DOE_City.count > 0 ? true : false
        let isValidState  = DOE_State_Name.count > 0 ? true : false
        let isValidZip = DOE_Zip.count >= 5 ? true : false
        let isValidPhone = self.isValidPhoneNumber(phoneNumber: DOE_Phone.digitsOnly())
        let isValidEmail = self.isValidEmail(testStr: DOE_Email)
        let isValidConfirmEail = self.isValidEmail(testStr: DOE_Confirm_Email)
        
        
        if   isValidFName && isValidLName && isValidAddress && isValidCity && isValidState && isValidZip && isValidPhone && isValidEmail && isValidConfirmEail &&  (DOE_Email == DOE_Confirm_Email){
            
            isValidated =  true
            
        }else{
            var  message = "Please enter all the mandatory fields"
            
            if isValidFName && isValidLName && isValidAddress && isValidCity && isValidState && isValidZip && isValidPhone && !isValidEmail {
                message = "Please enter Valid Email"
            }else if isValidFName && isValidLName && isValidAddress && isValidCity && isValidState && isValidZip && isValidPhone && isValidEmail && !isValidConfirmEail{
                message = "Please enter Valid Confirm Email"
            }else if isValidFName && isValidLName && isValidAddress && isValidCity && isValidState && isValidZip && !isValidPhone && (isValidEmail != isValidConfirmEail){
                message = "Email should match with confirm email"
            }else if isValidFName && isValidLName && isValidAddress && isValidCity && isValidState && isValidZip && !isValidPhone && isValidEmail{
                message = "Please enter valid Phone"
            }
            isSuccessMessage = false
            isDuplicateAplicantsList = false
//            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
            isValidated =  false
            
            
        }
        
        
        
        return isValidated
    }
    func OCC_ValidateAddReportToData() -> Bool {
        
        var isValidated  = false
        
        for dict1   in dataEntryArray {
            
            let  dict:NSDictionary = dict1 as! NSDictionary
            
            let placeholder = dict["placeholder"] as! String
            
            if placeholder == "First Name *"{
                
                OCC_ReportTo_First_Name = dict["text"] as! String
                
            }else if placeholder.contains("Last Name *"){
                
                OCC_ReportTo_Last_Name = dict["text"] as! String
                
            }else  if placeholder.contains("Title *"){
                
                OCC_ReportTo_Title = dict["text"] as! String
                
            }
            else if placeholder == "Phone Number"{
                OCC_ReportTo_Phone = dict["text"] as! String
                
            }
            else if placeholder == "Email *"{
                OCC_ReportTo_Email = dict["text"] as! String
                
            }
            
        }
        
        
        isValidFirstName = OCC_ReportTo_First_Name.count > 0 ? true : false
        isValidLastName  = OCC_ReportTo_Last_Name.count > 0 ? true : false
        isValidTitle = OCC_ReportTo_Title.count > 0 ? true : false
        isValidPhone = self.isValidPhoneNumber(phoneNumber: OCC_ReportTo_Phone.digitsOnly())
        isValidEmail = self.isValidEmail(testStr: OCC_ReportTo_Email)
        
        if   isValidFirstName && isValidLastName && isValidTitle  && isValidEmail{
            
            isValidated =  true
            
        }else{
            
            var message = "Please enter all the mandatory fields"
            
            if  isValidFirstName && isValidLastName && isValidTitle && isValidPhone && !isValidEmail{
                message = "Please enter valid Email"
            }
            isSuccessMessage = false
            isDuplicateAplicantsList = false
//            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
            isValidated =  false
            
        }
        
        
        
        return isValidated
    }
    func Office_ValidateAddReportToLocationData() -> Bool {
        
        var isValidated  = false
        
        for dict1   in dataEntryArray {
            
            let  dict:NSDictionary = dict1 as! NSDictionary
            
            let placeholder = dict["placeholder"] as! String
            
            if placeholder.contains("Location Description"){
                
                HOS_ReportTo_Desc = dict["text"] as! String
                
            }else  if placeholder == "Address *"{
                
                HOS_ReportTo_Addess = dict["text"] as! String
            }else  if placeholder == "City *"{
                
                HOS_ReportTo_City = dict["text"] as! String
                
            }else if placeholder.contains("Floor"){
                
                HOS_ReportTo_Floor = dict["text"] as! String
                
            }else  if placeholder.contains("State"){
                
                HOS_ReportTo_State = dict["text"] as! String
                
            }else if placeholder == "Zip Code *"{
                HOS_ReportTo_Zip = dict["text"] as! String
                
            }
            else  if placeholder == "Directions"{
                HOS_ReportTo_Directions = dict["text"] as! String
            }
        }
        
        
        
          isValidCity  = HOS_ReportTo_City.count > 0 ? true : false
        
          isValidZip = HOS_ReportTo_Zip.count >= 5 ? true : false
        
          isValidAddress = HOS_ReportTo_Addess.count > 0 ? true : false
        
        isValidFloor = HOS_ReportTo_Floor.count > 0 ? true : false
        
          isValidState = HOS_ReportTo_State.count > 0 ? true : false
        
        if   isValidState  && isValidCity && isValidZip && isValidAddress && isValidFloor{
            
            isValidated =  true
            
        }else{
            isSuccessMessage = false
            isDuplicateAplicantsList = false
//            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Please enter all the mandatory fields", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
            isValidated =  false
        }
        
        
        
        return isValidated
    }
    func DOE_Edit_ValidateData() -> Bool{
        //    isForAddReportToHealthCare
        var isValidated  = false
        
        for dict1   in dataEntryArray {
            
            let  dict:NSDictionary = dict1 as! NSDictionary
            
            let placeholder = dict["placeholder"] as! String
            
            if placeholder.contains("Address"){
                DOE_Edit_Address = dict["text"] as! String
                
            }else  if placeholder == "City *"{
                
                DOE_Edit_City = dict["text"] as! String
            }else  if placeholder == "State *"{
                
                DOE_Edit_State = dict["text"] as! String
                
            }else if placeholder.contains("Zip"){
                
                DOE_Edit_Zip = dict["text"] as! String
                
            }
            
        }
        
        let isValidAddress = DOE_Edit_Address.count > 0 ? true : false
        let isValidCity = DOE_Edit_City.count > 0 ? true : false
        let isValidZip = DOE_Edit_Zip.count == 5 ? true : false
        let isValidState = DOE_Edit_State.count > 0 ? true : false
        
        if   isValidAddress && isValidCity && isValidZip && isValidState{
            
            isValidated =  true
            
        } else{
            isSuccessMessage = false
            isDuplicateAplicantsList = false
            var message = "Please enter all the mandatory fields"
            if  isValidAddress && isValidCity && !isValidZip && isValidState{
                message = "Please enter valid Zip"
            }
//            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
            isValidated =  false
        }
        return isValidated
    }
    
    func DOE_Add_Client_ValidateData() -> Bool{
        var isValidated  = false
        
        for dict1   in dataEntryArray {
            
            let  dict:NSDictionary = dict1 as! NSDictionary
            
            let placeholder = dict["placeholder"] as! String
            
            if placeholder.contains("Name"){
                
                DOE_Name = dict["text"] as! String
                
            }else  if placeholder.contains("Address"){
                
                DOE_Address = dict["text"] as! String
            }else  if placeholder == "City *"{
                
                DOE_City = dict["text"] as! String
                
            }else if placeholder.contains("State"){
                
                DOE_State_Name = dict["text"] as! String
                
            }else if placeholder.contains("Zip"){
                DOE_Zip = dict["text"] as! String
                
            }else if placeholder.contains("Phone"){
                DOE_Phone = dict["text"] as! String
                
            }else if placeholder == "Email *"{
                
                DOE_Email = dict["text"] as! String
                
            }else if placeholder == "Confirm Email *"{
                
                DOE_Confirm_Email = dict["text"] as! String
                
            }
            
        }
        
        
        let isValidName = DOE_Name.count > 0 ? true : false
        let isValidAddress = DOE_Address.count > 0 ? true : false
        let isValidCity  = DOE_City.count > 0 ? true : false
        let isValidState  = DOE_State_Name.count > 0 ? true : false
        let isValidZip = DOE_Zip.count >= 5 ? true : false
        let isValidPhone = self.isValidPhoneNumber(phoneNumber: DOE_Phone.digitsOnly())
        let isValidEmail = self.isValidEmail(testStr: DOE_Email)
        let isValidConfirmEail = self.isValidEmail(testStr: DOE_Confirm_Email)
        
        
        if   isValidName && isValidAddress && isValidCity && isValidState && isValidZip && isValidPhone && isValidEmail && isValidConfirmEail &&  (DOE_Email == DOE_Confirm_Email){
            
            isValidated =  true
            
        }else{
            var  message = "Please enter all the mandatory fields"
            
            if isValidName && isValidAddress && isValidCity && isValidState && isValidZip && isValidPhone && !isValidEmail {
                message = "Please enter valid Email"
            }else if isValidName && isValidAddress && isValidCity && isValidState && isValidZip && isValidPhone && isValidEmail && !isValidConfirmEail{
                message = "Please enter valid Confirm Email"
            }else if isValidName && isValidAddress && isValidCity && isValidState && isValidZip && !isValidPhone && isValidEmail {
                message = "Please enter valid Phone number"
            }else if DOE_Email != DOE_Confirm_Email{
                message = "Email and Confirm Email should match"
            }else if isValidName && isValidAddress && isValidCity && isValidState && !isValidZip && isValidPhone && isValidEmail && isValidConfirmEail{
                message = "Please enter valid Zip"
            }
            isSuccessMessage = false
            isDuplicateAplicantsList = false
//            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
            isValidated =  false
            
            
        }
        
        
        
        return isValidated
    }
    func HealthCare_ValidateAddReportToData() -> Bool{
        //    isForAddReportToHealthCare
        var isValidated  = false
        
        for dict1   in dataEntryArray {
            
            let  dict:NSDictionary = dict1 as! NSDictionary
            
            let placeholder = dict["placeholder"] as! String
            
            if placeholder.contains("Email"){
                HC_Email = dict["text"] as! String
                
            }else  if placeholder == "First Name *"{
                
                HC_First_Name = dict["text"] as! String
            }else  if placeholder == "Last Name *"{
                
                HC_Last_Name = dict["text"] as! String
                
            }else if placeholder.contains("Title"){
                
                HC_Title = dict["text"] as! String
                
            }else  if placeholder.contains("Phone Number"){
                
                HC_Phone = dict["text"] as! String
                
            }
            
        }
        
        isValidEmail = self.isValidEmail(testStr: HC_Email)
        
        isValidFirstName = HC_First_Name.count > 0 ? true : false
        isValidLastName = HC_Last_Name.count > 0 ? true : false
        
        isValidTitle = HC_Title.count > 0 ? true : false
        
        isValidPhone = self.isValidPhoneNumber(phoneNumber: HC_Phone.digitsOnly())
        
        if   isValidEmail && isValidFirstName && isValidLastName && isValidTitle {
            
            isValidated =  true
            
        } else{
            
            var message = "Please enter all the mandatory fields"
            if isValidFirstName && isValidLastName && isValidTitle && isValidPhone && !isValidEmail{
                message = "Please enter valid Email"
            }else if isValidFirstName && isValidLastName && isValidTitle && !isValidPhone && !isValidEmail{
                message = "Please enter valid Phone number and valid Email"
            }
            
            //            self.ShowAlertMessage(message: "Please enter all the mandatory fields", title: "")
            isSuccessMessage = false
            isDuplicateAplicantsList = false
//            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
            isValidated =  false
            
            
        }
        
        
        
        return isValidated
    }
    func HOS_ValidateAddReportToData() -> Bool {
        
        var isValidated  = false
        
        for dict1   in dataEntryArray {
            
            let  dict:NSDictionary = dict1 as! NSDictionary
            
            let placeholder = dict["placeholder"] as! String
            
            if placeholder.contains("Email"){
                HOS_ReportTo_Email = dict["text"] as! String
                
            }else  if placeholder == "First Name *"{
                
                HOS_ReportTo_First_Name = dict["text"] as! String
            }else  if placeholder == "Last Name *"{
                
                HOS_ReportTo_Last_Name = dict["text"] as! String
                
            }else if placeholder.contains("Title"){
                
                HOS_ReportTo_Title = dict["text"] as! String
                
            }else  if placeholder.contains("Phone Number"){
                
                HOS_ReportTo_Phone = dict["text"] as! String
                
            }
            
        }
        
        isValidEmail = self.isValidEmail(testStr: HOS_ReportTo_Email)
        
        isValidFirstName = HOS_ReportTo_First_Name.count > 0 ? true : false
        isValidLastName = HOS_ReportTo_Last_Name.count > 0 ? true : false
        
        isValidTitle = HOS_ReportTo_Title.count > 0 ? true : false
        
        isValidPhone = self.isValidPhoneNumber(phoneNumber: HOS_ReportTo_Phone.digitsOnly())
        
        if   isValidEmail && isValidFirstName && isValidLastName && isValidTitle  {
            
            isValidated =  true
            
        }else{
            var message = "Please enter all the mandatory fields"
            
            if   isValidFirstName && isValidLastName && isValidTitle && isValidPhone && !isValidEmail{
                message = "Please enter valid Email"
            }
            isSuccessMessage = false
            isValidated =  false
            isDuplicateAplicantsList = false
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
    //MARK: BTN ACTION METHODS
    
    @objc func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveButtonTapped(_ sender: Any) {
        if isForDOEEditAddress == true{
            if self.DOE_Edit_ValidateData() {
                
                self.DOE_Edit_AddressServerCall()
            }else{
                //                self.ShowAlertMessage(message: Error_Message, title: "")
                isSuccessMessage = false
                isDuplicateAplicantsList = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: Error_Message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }else if isForAddApplicantDOE == true{
            if self.DOE_ValidateAddApplicantData(){
                self.DOE_Add_Applicant_ServerCall()
            }else{
                isSuccessMessage = false
                isDuplicateAplicantsList = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: Error_Message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }else if (isForDOEAddClientApplicantFromChooseList == true || isForDOEEditClientApplicantFromChooseList == true ) {
            
            if self.DOE_Add_Client_ValidateData(){
                self.DOE_AddEditClientApplicantFromChooseListServerCall()
            }else{
                isSuccessMessage = false
                isDuplicateAplicantsList = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: Error_Message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }
        
    }
    
    @objc func addBtnTapped(_ sender: Any) {
        
        //check for validations then call API
        if isForAddReportToHealthCare == true{
            if self.HealthCare_ValidateAddReportToData() {
                
                self.HealthCare_addReportToServerCall()
            }else{
                 isSuccessMessage = false
                isDuplicateAplicantsList = false
 
            }
        }else if isForAddReportToSchoolProfessional == true{
            if self.validateContactData() {
                
                self.addReportToPersonServerCall()
            }else{
                isSuccessMessage = false
                isDuplicateAplicantsList = false
             }
        }else if isForAddReportToHospitality == true || isForAddReportToOffice == true{
            if self.HOS_ValidateAddReportToData(){
                if isForAddReportToOffice == true{
                    self.Office_addReportToPersonServerCall()
                }else{
                    self.HOS_addReportToPersonServerCall()
                }
            }else{
                isSuccessMessage = false
                isDuplicateAplicantsList = false
 
            }
        }else if isForAddReportToLocationHospitality == true{
            if self.HOS_ValidateAddReportToLocationData(){
                self.HOS_addReportToLocationServerCall()
            }else{
                isSuccessMessage = false
                isDuplicateAplicantsList = false
 
            }
            
        }else if isForAddReportToLocationOffice == true {
            if self.Office_ValidateAddReportToLocationData(){
                self.Office_addReportToLocationServerCall()
            }else{
                //
                isSuccessMessage = false
                isDuplicateAplicantsList = false
 
            }
            
        }else if isForAddReportToOCC == true {
            if self.OCC_ValidateAddReportToData(){
                self.OCC_addReportToServerCall()
            }else{
                isSuccessMessage = false
                isDuplicateAplicantsList = false
 
            }
            
        }else if isForAddApplicantDOE == true {
            if self.DOE_ValidateAddApplicantData(){
                self.DOE_addApplicantToServerCall()
            }else{
                isSuccessMessage = false
                isDuplicateAplicantsList = false
 
            }
            
        }
        self.tableView.reloadData()

    }
    
    
    //MARK: SERVER CALL
    
    func addReportToPersonServerCall(){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            let clientID = String(format:"%d", UserDefaults.standard.integer(forKey: "ClientID"))
            let ContactId = String(format:"%d", UserDefaults.standard.integer(forKey: "ContactId"))
            
            let params = ["ClientId" : clientID ,
                          "ReportToName" : ReportToName ,
                          "ReportToTitle" : ReportToTitle ,
                          "ReportToPhone" : ReportToPhone ,
                          "ReportToExtension" :  ReportToExtension,
                          "ReportToFax" : ReportToFax,
                          "ReportToEmail" : ReportToEmail,
                          "ReportToAddress": ReportToAddress,
                          "ReportToFloor": ReportToFloor,
                          "ReportToCity": ReportToCity,
                          "ReportToState": ReportToState,
                          "ReportToZip": ReportToZip,
                          "ReportToCellphone": ReportToCellphone,
                          "OSSource": "iOS",
                          "ContactId":ContactId]
            
            JustHUD.shared.showInView(view: view)
            print(params)
            RestAPI.addReportToContact(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
        }else{
            
            //            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
            isSuccessMessage = false
            isDuplicateAplicantsList = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    func Office_addReportToLocationServerCall(){
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            let defaults = UserDefaults.standard
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let params =  ["description" : HOS_ReportTo_Desc , "address" : HOS_ReportTo_Addess ,"city" : HOS_ReportTo_City , "state" : HOS_ReportTo_State ,"floor" : HOS_ReportTo_Floor, "zipcode" : HOS_ReportTo_Zip,"OSSource": "iOS" ,"OrderSource" : "iOS","Directions" : HOS_ReportTo_Directions,"ClientId":clientID]
            
            JustHUD.shared.showInView(view: view)
            print(params)
            RestAPI.addReportToLocationForOffice(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
        }else{
            isSuccessMessage = false
            isDuplicateAplicantsList = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
        
    }
    func OCC_addReportToServerCall(){
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            
            let name  = String(format:"%@ %@",OCC_ReportTo_First_Name,OCC_ReportTo_Last_Name)
            
            let params =  ["Name" : name , "Title" : OCC_ReportTo_Title ,"Phone" : OCC_ReportTo_Phone , "Email" : OCC_ReportTo_Email ,"ClientId" : clientID,"OSSource": "iOS"]
            
            JustHUD.shared.showInView(view: view)
            print(params)
            RestAPI.addReportToForOCC(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
        }else{
            isSuccessMessage = false
            isDuplicateAplicantsList = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    func DOE_addApplicantToServerCall(){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            
            let name  = String(format:"%@ %@",OCC_ReportTo_First_Name,OCC_ReportTo_Last_Name)
            
            let params =  ["Name" : name , "Title" : OCC_ReportTo_Title ,"Phone" : OCC_ReportTo_Phone , "Email" : OCC_ReportTo_Email ,"ClientId" : clientID]
            
            JustHUD.shared.showInView(view: view)
            print(params)
            
        }else{
            isSuccessMessage = false
            isDuplicateAplicantsList = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    func HOS_addReportToLocationServerCall(){
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            let ClientID = String(format:"%d", UserDefaults.standard.integer(forKey: "ClientID"))

            let params =  ["description" : HOS_ReportTo_Desc , "address" : HOS_ReportTo_Addess ,"city" : HOS_ReportTo_City , "state" : HOS_ReportTo_State ,"floor" : HOS_ReportTo_Floor, "zipcode" : HOS_ReportTo_Zip,"OSSource": "iOS","ClientId":ClientID,"Directions" : HOS_ReportTo_Directions ]
            
            JustHUD.shared.showInView(view: view)
            print(params)
            RestAPI.addReportToLocationForHospitality(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
        }else{
            isSuccessMessage = false
            isDuplicateAplicantsList = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    func Office_addReportToPersonServerCall(){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            let ClientID = String(format:"%d", UserDefaults.standard.integer(forKey: "ClientID"))

            let params = ["Title" : HOS_ReportTo_Title , "FirstName" : HOS_ReportTo_First_Name ,"LastName" : HOS_ReportTo_Last_Name , "PhoneNumber" : HOS_ReportTo_Phone , "Email" : HOS_ReportTo_Email,"OSSource": "iOS","ClientId":ClientID]
            
            RestAPI.addReportToContactForOffice(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
            
        }else{
            isSuccessMessage = false
            isDuplicateAplicantsList = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    func HealthCare_addReportToServerCall(){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            /*
             {
             "ContactId":"161293",
             "ClientID":"51785",
             "FirstName":"testFirst",
             "LastName":"LastName",
             "Title":"Dr",
             "Phone":"9856485927",
             "Email":"test@test.com"
             }
             
             */
            let clientID = String(format:"%d", UserDefaults.standard.integer(forKey: "ClientID"))
            let ContactId = String(format:"%d", UserDefaults.standard.integer(forKey: "ContactId"))
            
            let params = ["ContactId":ContactId, "ClientID":clientID, "Title" : HC_Title , "FirstName" : HC_First_Name ,"LastName" : HC_Last_Name , "Phone" : HC_Phone , "Email" : HC_Email,"OSSource": "iOS"]
             RestAPI.addReportToForHC(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
            
        }else{
            isSuccessMessage = false
            isDuplicateAplicantsList = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    func HOS_addReportToPersonServerCall(){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            
            let clientID = String(format:"%d", UserDefaults.standard.integer(forKey: "ClientID"))
            let params = ["Title" : HOS_ReportTo_Title , "FirstName" : HOS_ReportTo_First_Name ,"LastName" : HOS_ReportTo_Last_Name , "PhoneNumber" : HOS_ReportTo_Phone , "Email" : HOS_ReportTo_Email ,"ClientID" : clientID,"OSSource": "iOS"]
            print(params)
            
            RestAPI.addReportToContactForHospitality(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
        }else{
            isSuccessMessage = false
            isDuplicateAplicantsList = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
        
        
    }
    
    
    func DOE_AddEditClientApplicantFromChooseListServerCall(){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            let clientID = String(format:"%d", UserDefaults.standard.integer(forKey: "ClientID"))
            
            let params =  ["Address":DOE_Address,
                           "City":DOE_City,
                           "ClientId":clientID,//DOE_Client_ID,
                "ConfirmEmail":DOE_Email,
                "ContactId":DOE_Contact_ID.count == 0 ? "0": DOE_Contact_ID,
                "Email":DOE_Email,
                "Name":DOE_Name,
                "Phone":DOE_Phone,
                "Prefix":DOE_Prefix,
                "Zip":DOE_Zip,
                "StateCode":DOE_State_Code,
                "StateName":DOE_State_Name,
                "OSSource": "iOS"]
            
            print(params)
            RestAPI.DOE_AddEdit_ApplicantFrom_List_Call(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
            
        }else{
            isSuccessMessage = false
            isDuplicateAplicantsList = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    
    func DOE_Edit_AddressServerCall(){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            
            let params = ["City":DOE_Edit_City,
                          "LocationCode":DOE_Edit_Location_Code,
                          "State":DOE_Edit_State,
                          "StreetAddress":DOE_Edit_Address,
                          "Zip":DOE_Edit_Zip,
                          "LocationDescription":DOE_Edit_Description,
                          "OSSource": "iOS"]
            print(params)
            RestAPI.DOE_EditAddress_Call(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
            
        }else{
            isSuccessMessage = false
            isDuplicateAplicantsList = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    func DOE_Add_Applicant_ServerCall(){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            DOE_AddApplicantDict = ["FirstName":DOE_First_Name,
                                    "LastName":DOE_Last_Name,
                                    "MiddleName":DOE_Middle_Name,
                                    "Address":DOE_Address,
                                    "Phone":DOE_Phone,
                                    "City":DOE_City,
                                    "State":DOE_State_Name,
                                    "Zip":DOE_Zip,
                                    "Email":DOE_Email,
                                    "ConfirmEmail":DOE_Email,
                                    "SSN":"",
                                    "OSSource": "iOS"]
            print(DOE_AddApplicantDict)
            RestAPI.DOE_AddApplicant_Call(self, params: DOE_AddApplicantDict as! [String : String], method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
            
        }else{
            isSuccessMessage = false
            isDuplicateAplicantsList = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    func getResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        self.view.endEditing(true)
        print(response)
        if response is String{
            //            lblNoData.isHidden = false
            //            self.ShowAlertMessage(message: response as! String, title: "")
            isSuccessMessage = false
            isDuplicateAplicantsList = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            var message = object["Message"].stringValue
            
            if object["MessageStatus"].intValue == 1
            {
                if message.count == 0 {
                    
                    message = "Added Successfully"
                    
                }
                if isForAddReportToSchoolProfessional == true{
                    
                    let reportTo = ReportTo.init(ContactId: object["ContactId"].intValue, Name:object["ReportToName"].stringValue,isSelected: "0")
                    
                    self.delegate?.addedReportTo(reportTo)
                    isSuccessMessage = true
                    isDuplicateAplicantsList = false
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                    
                }else if isForAddReportToHospitality == true || isForAddReportToOffice == true {
                    let reportTo = ReportTo.init(ContactId: object["ContactId"].intValue, Name:object["FirstName"].stringValue,isSelected: "0")
                    
                    self.delegate?.addedReportTo(reportTo)
                    
                    isSuccessMessage = true
                    isDuplicateAplicantsList = false
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                    
                }else if isForAddReportToLocationHospitality == true {
                    
                    let locList = object["objLocationList"].array
                    if locList?.count == 0{
                        //Nothing to do
                    }else{
                        for dict in locList!{
                            let reportToLoc = ReportToLocation.init(ReportToLocation: dict["Key"].stringValue, Split_Add: dict["Value"].stringValue,isSelected: "0", ReportId: dict["Value"].stringValue)
                            self.delegate?.addedReportToLocation(reportToLoc)
                            break
                        }
                    }
                    isSuccessMessage = true
                    isDuplicateAplicantsList = false
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                    
                }else if isForAddReportToLocationOffice == true {
                    
                    let locList = object["objLocationList"].array
                    if locList?.count == 0{
                        //Nothing to do
                    }else{
                        for dict in locList!{
                            let reportToLoc = OfficeReportToLocation.init(ReportToName: dict["Key"].stringValue, ReportId: dict["Value"].stringValue, isSelected: "0")
                            self.delegate?.addedReportToLocationOffice(reportToLoc)
                            break
                        }
                    }
                    isSuccessMessage = true
                    isDuplicateAplicantsList = false
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                }else if isForAddReportToOCC == true {
                    
                    let value = String(format:"%d", object["Value"].doubleValue)
                    
                    let reportTo = OCCReportToExp.init(Value: value, Text: object["Name"].stringValue, isSelected: "0")
                    
                    self.delegate?.addReportToForOCC(reportTo)
                    
                    isSuccessMessage = true
                    isDuplicateAplicantsList = false
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                    
                }else if isForDOEEditAddress == true {
                    
                    //TODO: call the delegate
                    
                    let LocationDescription = object["LocationDescription"].stringValue
                    let StreetAddress = object["StreetAddress"].stringValue
                    let City = object["City"].stringValue
                    let State = object["State"].stringValue
                    let Zip = object["Zip"].stringValue
                    let Address = String(format:"%@\n%@\n%@\n%@,%@,%@",DOE_Edit_Location_Code,LocationDescription,StreetAddress,City,State,Zip)
                    self.DOE_EditAddressDelegate?.DOE_EditAddress(Address)
                    isSuccessMessage = true
                    isDuplicateAplicantsList = false
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                    
                }else if isForAddReportToHealthCare == true {
                    
                    let value = String(format:"%d", object["Value"].doubleValue)
                    let name = String(format:"%@ %@",object["FirstName"].stringValue,object["LastName"].stringValue)
                    
                    let reportTo = ReportTo.init(ContactId: object["ContactId"].intValue, Name: name, isSelected: "1")
                    
                    self.hcDelegate?.HC_AddReportTo(reportTo)
                    
                    isSuccessMessage = true
                    isDuplicateAplicantsList = false
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                    
                }else if isForDOEAddClientApplicantFromChooseList == true || isForDOEEditClientApplicantFromChooseList == true {
                    var stName = object["StateName"].stringValue
                    if stName.count == 0{
                        stName = object["StateCode"].stringValue
                    }
                    
                    let reportTo = DOEReportTo.init(Value: object["ContactId"].stringValue, Text: object["Name"].stringValue, ContAddr: object["Address"].stringValue, State: stName, Phone: object["Phone"].stringValue, City: object["City"].stringValue, Zip: object["Zip"].stringValue, AddETo: object["Email"].stringValue, isSelected: "1", ClientId: object["ClientId"].stringValue, ContactId: object["ContactId"].stringValue)
                    
                    self.DOE_addEditApplFromListDelegate?.DOE_AddEditApplicant(reportTo, prefixName: DOE_Prefix)
                    
                    isSuccessMessage = true
                    isDuplicateAplicantsList = false
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                    
                }else if isForAddApplicantDOE == true{
                    //push to search applicant page
                    if object["DuplicateAplicantsList"].null == nil{
                        let applicants = object["DuplicateAplicantsList"].array
                        let appls = NSMutableArray()
                        for dict in applicants! {
                            var ApplicationId = object["ApplicationId"].stringValue
                            if ApplicationId.count == 0{
                                ApplicationId = "0"
                            }
                            let applicantObj = Applicant.init(CandidateId: "0", ApplicantId: dict["AppId"].stringValue, Name: dict["Name"].stringValue, ConsultantType: "", Email: dict["Email"].stringValue, Address: dict["Address"].stringValue, City: dict["City"].stringValue, State: dict["State"].stringValue, Zip: dict["Zip"].stringValue,SSN: dict["SSN"].stringValue, isSelected: "0",appliType: "",ApplicationId:  ApplicationId,NewApplicant:  object["NewApplicant"].stringValue,extraCandId: "0")
                            
                            appls.add(applicantObj)
                        }
                        if appls.count == 0{
                            let Name = String(format:"%@ %@ %@",object["FirstName"].stringValue,object["MiddleName"].stringValue,object["LastName"].stringValue)
                            var ApplicationId = object["ApplicationId"].stringValue
                            if ApplicationId.count == 0{
                                ApplicationId = "0"
                            }
                            
                            let applicantObj = Applicant.init(CandidateId: object["CandidateId"].stringValue, ApplicantId: ApplicationId, Name:  Name , ConsultantType: "", Email: object["Email"].stringValue, Address: object["Address"].stringValue, City: object["City"].stringValue, State: object["State"].stringValue, Zip: object["Zip"].stringValue,SSN: object["SSN"].stringValue, isSelected: "0",appliType: object["Type"].stringValue,ApplicationId:  ApplicationId,NewApplicant:  object["NewApplicant"].stringValue,extraCandId: object["ApplicationId"].stringValue)
                            
                            let userDefaults = UserDefaults.standard
                            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: applicantObj)
                            userDefaults.set(encodedData, forKey: "DoeApplicantModel")
                            userDefaults.synchronize()
                            
                            self.pushToDOEChooseConsultantReportToViewController()
                        }else{
                            
                            
                            self.PushToDOESearchApplicantViewControllerPage(applicantList: appls,addApplicantParam:DOE_AddApplicantDict)
                        }
                    }else{
                        isSuccessMessage = false
                        isDuplicateAplicantsList = true
                        
                        self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                    }
                }
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                isSuccessMessage = false
                isDuplicateAplicantsList = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
    }
    
    @IBAction override func okButtonTapped(_ sender: Any) {
        //        self.tAlertController.dismiss(animated: true, completion: nil)
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
        if isSuccessMessage == true{
            self.navigationController?.popViewController(animated: true)
        }else if isDuplicateAplicantsList == true{
            self.pushToDOEChooseConsultantReportToViewController()
        }
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
        alertDropDownTableView.reloadData()
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
        self.tableView.reloadData()
        
    }
    // UIGestureRecognizerDelegate method
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if (touch.view?.isDescendant(of: self.alertDropDownTableView))! || (touch.view?.isDescendant(of:  self.tableView))!  {
            return false
        }
        return true
    }
    func removeDropDown(){
        dropDownView.removeFromSuperview()
    }
    func pushToDOEChooseConsultantReportToViewController(){
        var isControllerExists = false
        var vc = UIViewController()
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOEChooseConsultantReportToViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    vc =  viewController
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOEChooseConsultantReportToSegue") as! DOEChooseConsultantReportToViewController
            nextViewController.isFromSummaryPage =  self.isFromSummaryPage
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            let vc1:DOEChooseConsultantReportToViewController = vc as! DOEChooseConsultantReportToViewController
            vc1.isFromSummaryPage = self.isFromSummaryPage
            self.navigationController?.popToViewController(vc1, animated: true)
        }
    }
    func PushToDOESearchApplicantViewControllerPage(applicantList:NSMutableArray,addApplicantParam: NSDictionary){
        
        var isControllerExists = false
        var vc = UIViewController()
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOESearchApplicantViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    vc = viewController
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOESearchApplicantSegue") as! DOESearchApplicantViewController
            nextViewController.isFromAddApplicantPage = true
            nextViewController.existingApplicantList = applicantList
            nextViewController.AddApplicantDuplicateParam = addApplicantParam
            nextViewController.isFromSummaryPage = self.isFromSummaryPage
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }else{
            let vc1:DOESearchApplicantViewController = vc as! DOESearchApplicantViewController
            vc1.isFromSummaryPage = self.isFromSummaryPage
            vc1.isFromAddApplicantPage = true
            vc1.existingApplicantList = applicantList
            vc1.AddApplicantDuplicateParam = addApplicantParam
            
            self.navigationController?.popToViewController(vc1, animated: true)
        }
    }
}

/*
 PARAM:
 /*
 { "ClientId" : "70830" , "ReportToName" : "Naresh" , "ReportToTitle" : "" , "ReportToPhone" : "(212)-916-0864" , "ReportToExtension" :  "",
 "ReportToFax" : "(212)-867-1759",
 "ReportToEmail" : "",
 "ReportToAddress":"420 Lexington Avenue",
 "ReportToFloor":"",
 "ReportToCity":"Manhattan",
 "ReportToState":"NY",
 "ReportToZip":"10170",
 "ReportToCellphone":""
 }
 RESPONSE:
 {
 "HttpRequestStatus": 200,
 "DivisionId": 0,
 "ClientId": 70830,
 "ContactId": 0,
 "OrderSource": 0,
 "NewVision": 0,
 "DateDiff": 0,
 "NoofPositions": 0,
 "ReportToPhone": "(212)-916-0864",
 "ReportToFax": "(212)-867-1759",
 "ReportToAddress": "420 Lexington Avenue",
 "ReportToFloor": "",
 "ReportToCity": "Manhattan",
 "ReportToState": "NY",
 "ReportToZip": "10170",
 "ReportToName": "Naresh",
 "ReportToTitle": "",
 "ReportToExtension": "",
 "ReportToEmail": "",
 "ReportToCellphone": "",
 "ReportToContactId": 0,
 "MessageStatus": 2,
 "Message": "ReportTo Email Required",
 "IsModel": false,
 "MessageColor": 0,
 "DivisionCount": 0
 }
 
 */
 */
