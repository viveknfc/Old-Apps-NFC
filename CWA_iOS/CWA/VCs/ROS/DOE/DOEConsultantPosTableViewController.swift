//
//  DOEConsultantPosTableViewController.swift
//  CWA
//
//  Created by Jayaprada on 01/04/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON

class DOEConsultantPosTableViewController: BaseTableViewController,UITextFieldDelegate,UITextViewDelegate,DOE_EditAddressDelegate,DOESelectLocationDelegate {
    
    func selectedLocation(_ emps: DOELocation) {
        LocationCode = emps.LocationCode!
        let LocationDescription = emps.LocationDescription
        let StreetAddress = emps.StreetAddress
        let City = emps.City
        let State = emps.State
        let Zip = emps.Zip
        Address = String(format:"%@\n%@\n%@\n%@,%@,%@",LocationCode,LocationDescription!,StreetAddress!,City!,State!,Zip!)
        self.saveLocationDetails()
        self.tableView.reloadData()
    }
    
    
    func DOE_EditAddress(_ locationName: String) {
        if locationName.count == 0{}else{
            Address = locationName
            self.tableView.reloadData()
        }
    }
    
    var Original_LocationCode = ""
    var Original_Address = ""
    
    var  textCount = ""
    var isFromSummaryPage = false
    
    var JobTitle = ""
    var JobDesc = ""
    var LocationCode = ""
    var Address = ""
    ///Edit Address///
    var Edit_Address_LocationDescription = ""
    var Edit_Address_StreetAddress = ""
    var Edit_Address_City = ""
    var Edit_Address_State = ""
    var Edit_Address_Zip = ""
    var StateList = NSMutableArray()
    var PDFfilePath = ""
    var isWarningMessage = false
    var isWarningCancelled = true
    
    var JobTitleArry = NSArray()
    ///
    var DOE_Search_Loc_List = NSMutableArray()
    
    let searchTxtFieldTag = 1001
    @objc override func appWillEnterForeground(){
        print("appWillEnterForeground Division")
        
        
        if JobTitle.count == 0 && JobDesc.count == 0 && LocationCode.count == 0 && Address.count == 0{
            self.getROSData()
        }
     }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
  
    @objc func methodOfReceivedNotification(notification: Notification){
        
        //        var info = notification.userInfo!
        isFromSummaryPage = true
        self.tableView.reloadData()
    }
    @objc override func goBack()
    {
        if isFromSummaryPage == true{
            isFromSummaryPage = false
            self.pushToDetailsPage()
 
        }else{
            isFromSummaryPage = false
            self.navigationController?.popViewController(animated: true)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
        super.viewDidAppear(animated)
        
        isWarningCancelled = false
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.value(forKey: "PositionTitle") != nil{
            
            JobTitle = userDefaults.value(forKey: "PositionTitle") as! String
        }else{
            JobTitle = ""
        }
        if userDefaults.value(forKey: "PositionDescription") != nil{
            JobDesc = userDefaults.value(forKey: "PositionDescription") as! String
        }else{
            JobDesc = ""
        }
        if userDefaults.value(forKey: "LocationCode") != nil{
            LocationCode = userDefaults.value(forKey: "LocationCode") as! String
        }else{
           LocationCode = ""
        }
        if userDefaults.value(forKey: "Location") != nil{
            Address = userDefaults.value(forKey: "Location") as! String
        }else{
           Address = ""
        }
        
        if JobTitle.count == 0 && JobDesc.count == 0 && LocationCode.count == 0 && Address.count == 0{
            self.getROSData()
        }else{
            self.tableView.reloadData()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        
        
        self.titlelbl.text = "Rapid Order System"
         if isFromSummaryPage == true{
            self.tableView.reloadData()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    //MARK: UITableView Methods
    
    override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            return self.DOEHeaderTableViewCell(indexPath: indexPath as NSIndexPath)
        }else if indexPath.row == 1{
            return self.DOEConsultantPosTableViewCell(indexPath: indexPath as NSIndexPath)
        }else if indexPath.row == 2{
            return self.TextFieldCell(indexPath: indexPath as NSIndexPath)
            
        }else if indexPath.row == 3{
            return self.textViewCell(indexPath: indexPath as NSIndexPath)
            
        }else if indexPath.row == 4{
            return self.ButtonTableCell(indexPath: indexPath as NSIndexPath)
            
        }
        return UITableViewCell()
        
    }
    override   public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 180
        }else if indexPath.row == 1{
            if LocationCode.count > 0 && Address.count > 0{
                return 305
            }
            return 190
        }else if indexPath.row == 2{
            return 104
            
        }else if indexPath.row == 3{
            return 145
            
        }
        return 60
    }
    
    //MARK: Custom Cell
    //DOEHeaderTableViewCell
    func DOEHeaderTableViewCell(indexPath: NSIndexPath) -> DOEHeaderTableViewCell {
        
        let cell:DOEHeaderTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "DOEHeaderTableViewCellIdentifier") as! DOEHeaderTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.clickHereBtn.removeTarget(self, action: #selector(self.clickHereBtnTapped), for: .touchUpInside)
        cell.clickHereBtn.addTarget(self, action: #selector(self.clickHereBtnTapped), for: .touchUpInside)
        return cell
        
    }
    func ButtonTableCell(indexPath: NSIndexPath) -> ButtonTableViewCell {
        
        let cell:ButtonTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCellIdentifier") as! ButtonTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.nextButton.removeTarget(self, action:#selector(self.nextButtonTapped), for: .touchUpInside)
        cell.undoButton.removeTarget(self, action:#selector(self.undoButtonTapped), for: .touchUpInside)
        
        cell.nextButton.addTarget(self, action:#selector(self.nextButtonTapped), for: .touchUpInside)
        cell.undoButton.addTarget(self, action:#selector(self.undoButtonTapped), for: .touchUpInside)
        
        if isFromSummaryPage == true{
            cell.returnToConfirmOrderButton.removeTarget(self, action:#selector(self.returnToConfirmOrderButtonTapped), for: .touchUpInside)
            cell.returnToConfirmOrderButton.addTarget(self, action:#selector(self.returnToConfirmOrderButtonTapped), for: .touchUpInside)
            
            cell.returnToConfirmOrderButton.isHidden = false
            cell.undoButton.isHidden = true
            cell.nextButton.isHidden = true
        }else{
            cell.undoButton.isHidden = false
            cell.nextButton.isHidden = false
            
            cell.returnToConfirmOrderButton.isHidden = true
        }
        
        return cell
        
    }
    func TextFieldCell( indexPath: NSIndexPath) -> TextFieldTableViewCell {
        
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
        cell.entryTextField.delegate = self
        cell.btnBGView.layer.borderWidth = 1
        cell.btnBGView.layer.borderColor = borderColor.cgColor
        
        cell.entryTextField.text = JobTitle
        cell.entryTextField.delegate = self
        return cell
    }
    
    func DOEConsultantPosTableViewCell(indexPath: NSIndexPath ) -> DOEConsultantPosTableViewCell {
        
        let cell:DOEConsultantPosTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "DOEConsultantPosTableViewCellIdentifier") as! DOEConsultantPosTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.searchTxtField.text = LocationCode
        cell.searchTxtField.layer.borderWidth  = 1
        if  LocationCode.count > 0 && Address.count > 0{
            cell.addressLabl.text = Address
            cell.editAddressBtn.isHidden = false
            cell.searchTxtField.layer.borderColor = borderColor.cgColor
            
        }else{
            cell.addressLabl.text = ""
            cell.editAddressBtn.isHidden = true
            cell.searchTxtField.layer.borderColor = UIColor.red.cgColor
        }
        
        
        cell.searchTxtField.delegate = self
        cell.searchTxtField.tag = 1001
        cell.searchBtn.removeTarget(self, action:#selector(self.searchLocationCodeButtonTapped), for: .touchUpInside)
        cell.searchBtn.addTarget(self, action:#selector(self.searchLocationCodeButtonTapped), for: .touchUpInside)
        
        cell.editAddressBtn.removeTarget(self, action: #selector(self.EditAddressButtonTapped), for: .touchUpInside)
        cell.editAddressBtn.addTarget(self, action: #selector(self.EditAddressButtonTapped), for: .touchUpInside)
        return cell
        
    }
    
    
    func textViewCell(indexPath: NSIndexPath ) -> TextViewTableViewCell {
        
        let cell:TextViewTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "TextViewTableViewCellIdentifier") as! TextViewTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        
        cell.entryTextView.layer.borderColor = borderColor.cgColor
        cell.entryTextView.layer.borderWidth = 1
        cell.entryTextView.delegate = self
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(keyboardDoneBtnTapped))]
        toolBar.sizeToFit()
        cell.entryTextView.inputAccessoryView = toolBar
        cell.entryTextView.text = JobDesc
        cell.lblTextCount.text = textCount
//        cell.lblTextCount.isHidden = false
        return cell
        
    }
    @objc func keyboardDoneBtnTapped(sender: UIButton){
        self.view.endEditing(true)
    }
    
    @objc func clickHereBtnTapped(sender: UIButton){
        if PDFfilePath.count == 0{
            isWarningMessage = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "File not available", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }else{
            self.pushToViewPDFPage()
            
        }
    }
    
    @objc func nextButtonTapped(sender:UIButton){
     self.validationForNextPage()
    }
    
    @objc func undoButtonTapped(sender:UIButton){
        LocationCode =    Original_LocationCode
        Address = Original_Address
        JobTitle = ""
        JobDesc = ""
        self.tableView.reloadData()
    }
    
    @objc func returnToConfirmOrderButtonTapped(sender: UIButton){
        
self.validationForNextPage()
    }
    func validationForNextPage(){
        if LocationCode.count == 0 {
            let message = "You must enter a location code that is EXACTLY 6 characters in length.\nIt is a combination of the District Code (2 digits) and the Location Code (4 characters)."
            isWarningMessage = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else if JobTitle.count == 0  {
            isWarningMessage = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "You must enter a Job Title  to continue", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else if  JobDesc.count == 0{
            isWarningMessage = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "You must enter a Job Description to continue", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }else{
            if isFromSummaryPage == false{
                if isWarningCancelled == true{
                    self.pushToDOEConsultantSourcedViewController()
                }else{
                    self.CreateOrderValidation()
                    
                }
            }else{
                if isWarningCancelled == true{
                    isWarningCancelled = false
                    self.pushToDetailsPage()
                }else{
                    self.CreateOrderValidation()
                    
                }
            }
 
           
        }
    }
    @objc func searchLocationCodeButtonTapped(sender:UIButton){
        
        
        if LocationCode.count > 0{
            self.getSearchLocationCodeDetailsData()
        }
        
        //            if LocationCode.count == 6{
        //            }else{
        //                let message = "You must enter a location code that is EXACTLY 6 characters in length.\nIt is a combination of the District Code (2 digits) and the Location Code (4 characters)."
        //                self.showCustomAlert(Title: "Alert", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        //            }
        
    }
    @objc func EditAddressButtonTapped(sender:UIButton){
        
        self.getEditAddressDetailsServerCall()
        
    }
    func pushToSearchLocationPage(){
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
            nextViewController.isFOrHealthCare = false
            nextViewController.isForDOESearchLoc = true
            nextViewController.empDataArray = self.DOE_Search_Loc_List
            nextViewController.DOEdelegate = self
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        
    }
    func pushToDOEConsultantSourcedViewController(){
        self.saveLocationDetails()
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOEConsultantSourcedViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOEConsultantSourcedSegue") as! DOEConsultantSourcedViewController
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
            
            nextViewController.isForAddReportToOCC = false
            nextViewController.isForAddReportToOffice = false
            nextViewController.isForDOEEditAddress = true
            nextViewController.DOE_Edit_Zip = Edit_Address_Zip
            nextViewController.DOE_Edit_State = Edit_Address_State
            nextViewController.DOE_Edit_City = Edit_Address_City
            nextViewController.DOE_Edit_Address = Edit_Address_StreetAddress
            let Desc = String(format:"\nCode: %@\nDescription: %@\n",LocationCode,Edit_Address_LocationDescription)
            nextViewController.DOE_Edit_Description = Edit_Address_LocationDescription
            nextViewController.DOE_Edit_State_List = StateList
            nextViewController.DOE_Edit_Loc_Description = Desc
            nextViewController.DOE_Edit_Location_Code = LocationCode
            nextViewController.selectedState = State.init(StateId: "", StateName: Edit_Address_State, StateCode: "", isSelected: "1")
            
            nextViewController.DOE_EditAddressDelegate = self
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    func pushToViewPDFPage(){
        
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is LoadWebContentViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoadWebContentSegue") as! LoadWebContentViewController
            
            nextViewController.fileName = PDFfilePath
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    //MARK: Server Call
    func getROSData() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            self.showLoading()
            
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            
            let params :[String:String] = ["ClientID":clientID]
            
            print(params)
            
            RestAPI.getROSDOE(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getROSResponse(response:))
        }else{
            isWarningMessage = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    func getROSResponse(response:AnyObject)->()
    {
        self.hideLoading()
        print(response)
        if response is String{
            isWarningMessage = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                PDFfilePath = object["FilePath"].stringValue
                
                LocationCode = object["LocationCode"].stringValue
                let LocationDescription = object["LocationDescription"].stringValue
                let StreetAddress = object["StreetAddress"].stringValue
                let City = object["City"].stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
                let State = object["State"].stringValue
                let Zip = object["Zip"].stringValue
                Address = String(format:"%@\n%@\n%@\n%@,%@,%@",LocationCode,LocationDescription,StreetAddress,City,State,Zip)
                Original_LocationCode = LocationCode
                Original_Address = Address
                //                self.updateCharacterCount(text: "")
                
                self.tableView.reloadData()
            }else{
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

            }
        }
    }
    func getSearchLocationCodeDetailsData() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            self.showLoading()
            
            
            let params :[String:String] = ["LocationCode":LocationCode]
            
            print(params)
            
            RestAPI.getDOESearchLocationCodeDetailsData(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getSearchLocationCodeDetailsResponse(response:))
        }else{
            isWarningMessage = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    func getSearchLocationCodeDetailsResponse(response:AnyObject)->()
    {
        self.hideLoading()
        print(response)
        if response is String{
            isWarningMessage = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                DOE_Search_Loc_List.removeAllObjects()
                let locList = object["DoeLocationList"].array
                for dict in locList!{
                    let loc = DOELocation.init(LocationId: dict["LocationId"].stringValue, City: dict["City"].stringValue.trimmingCharacters(in: .whitespacesAndNewlines), State: dict["State"].stringValue, Zip: dict["Zip"].stringValue, LocationDescription: dict["LocationDescription"].stringValue, StreetAddress: dict["StreetAddress"].stringValue, isJson: dict["isJson"].stringValue, LocationCode: dict["LocationCode"].stringValue)
                    DOE_Search_Loc_List.add(loc)
                }
                self.pushToSearchLocationPage()
            }else{
                isWarningMessage = false
                self.showCustomAlert(Title: ""  , attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
            
        }
    }
    func getEditAddressDetailsServerCall() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            self.showLoading()
            
            
            let params :[String:String] = ["LocationCode":LocationCode]
            
            print(params)
            
            RestAPI.getDOEEditAddressDetailsServerCall(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getEditAddressDetailsResponse(response:))
        }else{
            isWarningMessage = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    func getEditAddressDetailsResponse(response:AnyObject)->()
    {
        self.hideLoading()
        print(response)
        if response is String{
            isWarningMessage = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                
                Edit_Address_LocationDescription = object["LocationDescription"].stringValue
                Edit_Address_StreetAddress = object["StreetAddress"].stringValue
                Edit_Address_City = object["City"].stringValue
//                Edit_Address_State = object["State"].stringValue
                Edit_Address_Zip = object["Zip"].stringValue
                
                let stateDataArray  = object["StateList"].array  //as! NSMutableArray
                
                for dict in stateDataArray! {
                    let stateObj =  State.init(StateId: dict["StateId"].stringValue, StateName: dict["StateName"].stringValue, StateCode: dict["StateCode"].stringValue,isSelected: "0")
                    if stateObj.StateCode == object["State"].stringValue || stateObj.StateName == object["State"].stringValue{
                        Edit_Address_State = stateObj.StateName!
                        stateObj.isSelected = "1"
                    }
                    StateList.add(stateObj)
                }
                self.pushToAddReportToPage()
            }
        }
    }
    func CreateOrderValidation()  {
        //        //
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            self.showLoading()
            
            
            let params :[String:String] = ["PositionTitle":JobTitle,
                                           "PositionDescription":JobDesc,
                                           "LocationCode":LocationCode]
            
            print(params)
            
            RestAPI.DOE_CreateOrderValidationCall(self, params: params, method: "POST", accessToken: "", acces: true, callBack: CreateOrderValidationResponse(response:))
        }else{
            isWarningMessage = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    
    func saveLocationDetails(){
        let defaults = UserDefaults.standard
        defaults.set(JobTitle, forKey: "PositionTitle")
        defaults.set(JobDesc, forKey: "PositionDescription")
        defaults.set(LocationCode, forKey: "LocationCode")
        defaults.set(Address, forKey: "Location")
        defaults.synchronize()
        
        
    }
    func CreateOrderValidationResponse(response:AnyObject)->()
    {
        self.hideLoading()
        print(response)
        if response is String{
            isWarningMessage = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                let message = object["Message"].stringValue
                
                if  object["IsError"] != nil && object["IsWarning"] != nil{
                    if object["IsError"].stringValue == "1" && object["IsWarning"].stringValue == "0"{
                        isWarningMessage = false
                        self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                    }
                    else if object["IsWarning"].stringValue == "1" && object["IsError"].stringValue == "0"{
                        JobTitleArry = message.components(separatedBy: "\"") as NSArray
                        isWarningMessage = true
                        if isWarningCancelled == true{
                            if isFromSummaryPage == true{
                                isFromSummaryPage = false
                                self.saveLocationDetails()
                                self.pushToDetailsPage()
                            }else{
                                self.saveLocationDetails()

                                self.pushToDOEConsultantSourcedViewController()
                                
                            }                        }else{
                            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "Cancel", type: Warning_Text, isAttributed: false)
                        }
                    }else{
                        if isFromSummaryPage == true{
                           isFromSummaryPage = false
                            self.saveLocationDetails()
                           self.pushToDetailsPage()
                        }else{
                            self.saveLocationDetails()

                            self.pushToDOEConsultantSourcedViewController()
                            
                        }
                    }
                }
                else{
                    if object["IsWarning"].stringValue == "1" && object["IsError"].stringValue == "1"{
                        if isFromSummaryPage == true{
                            isFromSummaryPage = false
                            self.saveLocationDetails()
                            self.pushToDetailsPage()
                        }else{
                            self.saveLocationDetails()

                            self.pushToDOEConsultantSourcedViewController()
                            
                        }
                        
                    }
                }
            }else{
                let message = object["Message"].stringValue
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "Cancel", type: Danger_Text, isAttributed: false)
                
                
            }
        }
    }
    //
    @IBAction override func okButtonTapped(_ sender: Any) {
        //    self.alertController.dismiss(animated: true, completion: nil)
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
        if isWarningMessage == true{
            if JobTitleArry.count > 1{
                JobTitle = JobTitleArry[1] as! String
                self.tableView.reloadData()
            }
        }
    }
    @IBAction override func cancelBtnTapped(_ sender: Any) {
        //    self.alertController.dismiss(animated: true, completion: nil)
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
        if isWarningMessage == true{
            isWarningCancelled = true
        }
    }
    //10/5
    public  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField.tag == 1001{//LocationCode text field
            let charsLimit = 6
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace =  range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace
            
            return newLength <= charsLimit
        }else if textField.tag == 100019{
            let charsLimit = 45
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace =  range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace
            
            return newLength <= charsLimit
        }
        
        
        return true
        
    }
    public func textFieldDidEndEditing(_ textField: UITextField){
        if textField.tag == 1001{
            
            LocationCode = textField.text!
            if LocationCode.count == 0{
                Address = ""
            }
        }else{
            JobTitle = textField.text!
            isWarningCancelled = false
        }
        self.tableView.reloadData()
        
    }
    //MARK: UITEXTVIEW DELEGATE
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        
        let charsLimit = 700
        let startingLength = textView.text?.count ?? 0
        let lengthToAdd = text.count
        let lengthToReplace =  range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        print(newLength)
        textCount = String(format:"%d/700",newLength)
//        self.tableView.reloadData()
        return newLength <= charsLimit
    }
    public  func textViewDidEndEditing(_ textView: UITextView)
    {
        JobDesc = textView.text
    }
    
    
    
    //       public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
    //
    //
    //        let characterCountLimit = 700
    //
    //        // We need to figure out how many characters would be in the string after the change happens
    //        let startingLength = textView.text?.count ?? 0
    //        let lengthToAdd = text.count
    //        let lengthToReplace = range.length
    //
    //
    //        let newLength = startingLength + lengthToAdd - lengthToReplace
    //        print(newLength)
    //        self.updateCharacterCount(text: textView.text)
    //
    //        self.tableView.reloadData()
    //let sd = newLength <= characterCountLimit
    //        return newLength <= characterCountLimit
    //
    //
    //    }
    //
    //
    //      public func textViewDidChange(_ textView: UITextView){
    //        self.updateCharacterCount(text: textView.text)
    //        self.tableView.reloadData()
    //
    //    }
    //
    
    
    
    
    
    func updateCharacterCount(text: String) {
        textCount = "\((700) - text.count)"
        print(textCount)
    }
    func pushToDetailsPage(){
        var isControllerExists = false
        var vc = UIViewController()
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOEOrderDetailsViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    vc = viewController
                    break
                }
            }
        }
        if isControllerExists == false{
            self.saveLocationDetails()

            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOEOrderDetailsSegue") as! DOEOrderDetailsViewController
            nextViewController.isFromROSDOE = true
            nextViewController.isFromHistoricalOrder = false

            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            let vc1:DOEOrderDetailsViewController = vc as! DOEOrderDetailsViewController
            vc1.isFromROSDOE = true
            vc1.isFromHistoricalOrder = false
            self.navigationController?.popToViewController(vc1, animated: true)
        }
    }
    /*
     cell.lblNameValue.text = self.DOE_Search_Loc_Dict["Code"] as! String
     cell.lblEval.text = self.DOE_Search_Loc_Dict["Description"] as! String
     cell.lblYTDHRValue.text = self.DOE_Search_Loc_Dict["Address"] as! String
     cell.lblSubjectValue.text = self.DOE_Search_Loc_Dict["City"] as! String
     cell.lblDateValue.text = self.DOE_Search_Loc_Dict["State"] as! String
     cell.lblPositionvalue.text = self.DOE_Search_Loc_Dict["Zip"] as! String
     
     
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
