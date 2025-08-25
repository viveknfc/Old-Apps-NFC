//
//  DOEPayrateViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 16/04/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON

class DOEPayrateViewController: BaseTableViewController,UITextFieldDelegate,UIGestureRecognizerDelegate {
    
    let Daily_PayRate_Identifier = "DOEDailyPayRateTableViewCellIdentifier"
    let PO_BillRate_Identifier = "DOEPOBillRateTableViewCellIdentifier"
    
    let Enter_The_Daily_Rate_TxtField_TAG = 1001
    let Hours_TxtField_TAG = 1002
    let Minutes_TxtField_TAG = 1003
    let Hourly_PayRate_TxtField_TAG = 1004
    let MAX_BEFORE_DECIMAL_DIGITS = 7
    let MAX_AFTER_DECIMAL_DIGITS = 2

    let Hour_TblView_TAG = 101
    let Minute_TblView_TAG = 102
    
    var selectedApplicant = Applicant.init(CandidateId: "0", ApplicantId: "", Name: "", ConsultantType: "", Email: "", Address: "", City: "", State: "", Zip: "", SSN: "", isSelected: "",appliType: "",ApplicationId:  "0",NewApplicant:  "",extraCandId: "0")
    
    var dataArray = NSMutableArray()
    var HoursList = NSMutableArray()
    var MinuteList = NSMutableArray()
    var dropDownView = UIView()
    var  alertDropDownTableView = UITableView()
    var PayRateType = ""
    var Note = ""
    var willPushToWaiver = false

    var isFromSummaryPage = false

    //Calculation
    
    var selectedHour = "0"
    var selectedMinute = "0"
    var dailyRate = "0"
    var AnnualRate = "0"
    var DhourlyPayRate = "0"
    var AhourlyPayRate = "0"

    var RoundedDailyRate = ""
    var POBillRate = "0"
    var ReferralMarkup = ""
    var NonReferralMarkup = ""
    var MinimumWage = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getPayrateCall()
        let ErrorDict = ["header": "Error"]
        let calculatorDict = ["header": "DOECalculator"]
        let hourlyPayRateDict = ["header": "Hourly"]
        let dailyPayRateDict = ["header": "Daily"]
        let POBillRateDict = ["header": "POBill"]
        let ButtonDict = ["header": "Button"]
        
        dataArray = [ErrorDict,calculatorDict,hourlyPayRateDict,dailyPayRateDict,POBillRateDict,ButtonDict]
        
        // Do any additional setup after loading the view.
        
    }
    
    @objc func methodOfReceivedNotification(){
        
        //        var info = notification.userInfo!
        isFromSummaryPage = true
        //set all the values
        let defaults = UserDefaults.standard
        
        let DoePayrateModel =  defaults.dictionary(forKey: "DoePayrateModel")
        selectedHour = DoePayrateModel!["Hours"] as! String
        selectedMinute = DoePayrateModel!["Minutes"] as! String
        dailyRate = DoePayrateModel!["PayRate"] as! String
        PayRateType = DoePayrateModel!["PayRateType"] as! String
        POBillRate = DoePayrateModel!["PoBillRate"] as! String
        RoundedDailyRate = DoePayrateModel!["RoundedDailyPayRate"] as! String
      
        if POBillRate.contains("$"){
            POBillRate = POBillRate.replace(target: "$", withString: "")
        }
        if RoundedDailyRate.contains("$"){
            RoundedDailyRate = RoundedDailyRate.replace(target: "$", withString: "")
        }
        
        if PayRateType == "D"{
            DhourlyPayRate = DoePayrateModel!["HourlyPayRate"] as! String
            if DhourlyPayRate.contains("$"){
                DhourlyPayRate = DhourlyPayRate.replace(target: "$", withString: "")
            }
        }else{
            AhourlyPayRate = DoePayrateModel!["HourlyPayRate"] as! String
            if AhourlyPayRate.contains("$"){
                AhourlyPayRate = AhourlyPayRate.replace(target: "$", withString: "")
            }
        }
        
        self.tableView.reloadData()
    }
    @objc override func goBack()
    {
        if isFromSummaryPage == true{
           isFromSummaryPage = false
            self.pushToDetailsPage()
            NotificationCenter.default.removeObserver(self)

        }else{
            isFromSummaryPage = false

            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        
        self.titlelbl.text = "DOE Payrate"
        if isFromSummaryPage == true{
            self.methodOfReceivedNotification()
        }
    }
    
    func resetAllDataForUndo(){
        selectedHour = "0"
        selectedMinute = "0"
        dailyRate = "0"
        DhourlyPayRate = "0"
        AhourlyPayRate = "0"
        RoundedDailyRate = ""
        POBillRate = "0"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: UITableView Methods
    
    override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == Hour_TblView_TAG {
            return HoursList.count
        }
        else if tableView.tag == Minute_TblView_TAG{
            return MinuteList.count
        }
        
        return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == Hour_TblView_TAG || tableView.tag == Minute_TblView_TAG{
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?
            if !(cell != nil) {
                cell = UITableViewCell(style:.subtitle, reuseIdentifier: "CELL")
            }
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            
            var obj = NSDictionary()
            if tableView.tag == Hour_TblView_TAG{
                obj = HoursList[indexPath.row] as! NSDictionary
            }else{
                obj = MinuteList[indexPath.row] as! NSDictionary
            }
            cell?.textLabel?.text = obj["Value"] as? String
//            if obj["isSelected"] as? String == "1"{
//                cell?.accessoryType = .checkmark
//            }else{
//                cell?.accessoryType = .none
//            }
            return cell!
        }else{
            
            let dict =  dataArray[indexPath.row] as! NSDictionary
            
            let placeholder = dict["header"] as! String
            
            if placeholder == "Error"{
                //DOEHeaderTableViewCellIdentifier
                return self.DOEHeaderTableViewCell(indexPath: indexPath as NSIndexPath)
            }else if placeholder == "DOECalculator"{
                return self.DOEPayRateCalculatorTableViewCell(indexPath: indexPath as NSIndexPath)
                
            }else if placeholder == "Hourly"{
                return self.TextFieldCell(indexPath: indexPath as NSIndexPath)
                
            }else if placeholder == "Daily"{
                return self.DOEPayRateTableViewCell(indexPath: indexPath as NSIndexPath, identifier: Daily_PayRate_Identifier)
                
            }else if placeholder == "POBill"{
                return self.DOEPayRateTableViewCell(indexPath: indexPath as NSIndexPath, identifier: PO_BillRate_Identifier)
                
            }else if placeholder == "Button"{
                return self.ButtonTableCell(indexPath: indexPath as NSIndexPath)
            }
        }
        
        return UITableViewCell()
        
    }
    override   public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == Hour_TblView_TAG || tableView.tag == Minute_TblView_TAG{
            return 44
        }
        let dict =  dataArray[indexPath.row] as! NSDictionary
        
        let placeholder = dict["header"] as! String
        
        if placeholder == "Error"{
            return  110
        }else if placeholder == "DOECalculator"{
            
            if PayRateType == "D"{
                return 370
            }else{
                return 275
            }
            
        }else if placeholder == "Hourly"{
            return 75
            
        }else if placeholder == "Daily"{
            let hourlyPayRateStrArray = DhourlyPayRate.components(separatedBy: ".")
            if hourlyPayRateStrArray.count > 1{
                
                let afterDecimal = hourlyPayRateStrArray[1]
                if Int(afterDecimal)! == 0 || PayRateType == "A"{
                    return 0
                }
            }else if hourlyPayRateStrArray.count == 0 || Double(dailyRate) == 0 || PayRateType == "A"{
                return 0
            }
//            if Double(dailyRate) == 0 || PayRateType == "A"{
//                return 0
//            }
            return 135
            
            
        }else if placeholder == "POBill"{
            return 100
            
        }else if placeholder == "Button"{
            return 60
        }
        
        return 60
    }
    
    override  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if tableView.tag == Hour_TblView_TAG || tableView.tag == Minute_TblView_TAG{
            
            var obj = NSDictionary()
            if tableView.tag == Hour_TblView_TAG{
                //Step - 1: Make all objs as unselecetd
                for o in HoursList{
                    let   dictObj : NSDictionary = o as! NSDictionary
                    let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dictObj)
                    mutableDictObj["isSelected"] = "0"
                }
                //Step - 2: Then make selecetd indexpath Object as selected = 1
                obj = HoursList[indexPath.row] as! NSDictionary
                let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: obj)
                mutableDictObj["isSelected"] = "1"
                selectedHour = mutableDictObj["Value"] as! String
                HoursList.replaceObject(at: indexPath.row, with: mutableDictObj)
            }else{
                //Step - 1: Make all objs as unselecetd
                for o in MinuteList{
                    let   dictObj : NSDictionary = o as! NSDictionary
                    let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dictObj)
                    mutableDictObj["isSelected"] = "0"
                }
                //Step - 2: Then make selecetd indexpath Object as selected = 1
                obj = MinuteList[indexPath.row] as! NSDictionary
                
                let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: obj)
                mutableDictObj["isSelected"] = "1"
                selectedMinute = mutableDictObj["Value"] as! String
                MinuteList.replaceObject(at: indexPath.row, with: mutableDictObj)
            }
            self.calculatePayRate()
            self.removeDropDown()
            self.tableView.reloadData()
            
        }
    }
    //MARK: Custom Cell
    //DOEHeaderTableViewCell
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
        cell.entryTextField.tag = Hourly_PayRate_TxtField_TAG
//        cell.entryTextField.text = hourlyPayRate
        if PayRateType == "D"{
             cell.entryTextField.text = DhourlyPayRate
        }else{
             cell.entryTextField.text = AhourlyPayRate

        }
        cell.entryTextField.delegate = self
        return cell
    }
    
    func DOEHeaderTableViewCell(indexPath: NSIndexPath) -> DOEHeaderTableViewCell {
        
        let cell:DOEHeaderTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "DOEHeaderTableViewCellIdentifier") as! DOEHeaderTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.lblHeader.text = Note
        return cell
        
    }
    func DOEPayRateTableViewCell(indexPath: NSIndexPath,identifier: String) -> DOEPayrateTableViewCell {
        //
        let cell:DOEPayrateTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: identifier) as! DOEPayrateTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        if identifier == Daily_PayRate_Identifier
        {
            cell.lblValue.text = String(format:"Rounded Daily Rate = $%@",RoundedDailyRate)
        }else if identifier == PO_BillRate_Identifier{
            cell.lblValue.text = String(format:"PO Bill Rate     $%@",POBillRate)
        }
        return cell
        
    }
    func DOEPayRateCalculatorTableViewCell(indexPath: NSIndexPath) -> DOEPayrateCalculatorCell {
        
        let cell:DOEPayrateCalculatorCell = self.tableView.dequeueReusableCell(withIdentifier: "DOEPayrateCalculatorCellIdentifier") as! DOEPayrateCalculatorCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        self.addRightImageToTextField(textField: cell.HoursTxtField, imageName: "expand-arrow")
        self.addRightImageToTextField(textField: cell.MinuteTxtField, imageName: "expand-arrow")
        if PayRateType == "D"{
            cell.DailyRateTxtField.text = dailyRate
 
            cell.infoLbl.text = "Use this screen to calculate the hourly pay rate for a consultant from a specific daily rate. To use this screen do the following:\n1. Enter a Daily Rate (such as $500).\n2. Enter the Hours and Minutes Worked Per Day."
            cell.PayRateHeaderLbl.text = "Enter The Daily Rate"
            cell.DailyRateBtn.isSelected = true
            cell.AnnualRateBtn.isSelected = false
        }else{
            cell.DailyRateTxtField.text = AnnualRate

            cell.infoLbl.text = "Use this screen to calculate the hourly pay rate for a consultant from a specific annual rate. To use this screen do the following:\n1. Enter an Annual Rate (such as $50,000).\n2. Click the tab button to move of the annual rate field."
            cell.PayRateHeaderLbl.text = "Enter The Annual Rate"
            cell.DailyRateBtn.isSelected = false
            cell.AnnualRateBtn.isSelected = true
        }
        /*
         annual
         Use this screen to calculate the hourly pay rate for a consultant from a specific annual rate. To use this screen do the following:\n1. Enter an Annual Rate (such as $50,000).\n2. Click the tab button to move of the annual rate field.
         daily
         Use this screen to calculate the hourly pay rate for a consultant from a specific daily rate. To use this screen do the following:
         1. Enter a Daily Rate (such as $500).
         2. Enter the Hours and Minutes Worked Per Day.
         */
        cell.DailyRateBtn.removeTarget(self, action: #selector(dailyRateBtnTapped), for: .touchUpInside)
        cell.AnnualRateBtn.removeTarget(self, action: #selector(AnnualRateBtnTapped), for: .touchUpInside)
        
        cell.DailyRateBtn.addTarget(self, action: #selector(dailyRateBtnTapped), for: .touchUpInside)
        cell.AnnualRateBtn.addTarget(self, action: #selector(AnnualRateBtnTapped), for: .touchUpInside)
        
        cell.HoursTxtField.tag = Hours_TxtField_TAG
        cell.MinuteTxtField.tag = Minutes_TxtField_TAG
        cell.DailyRateTxtField.tag = Enter_The_Daily_Rate_TxtField_TAG
        
        cell.HoursTxtField.delegate = self
        cell.MinuteTxtField.delegate = self
        cell.DailyRateTxtField.delegate = self
        
        cell.HoursTxtFieldBGView.layer.borderColor = borderColor.cgColor
        cell.HoursTxtFieldBGView.layer.borderWidth = 1
        cell.MinuteTxtFieldBGView.layer.borderColor = borderColor.cgColor
        cell.MinuteTxtFieldBGView.layer.borderWidth = 1

        cell.DailyRateTxtField.layer.borderWidth = 1
        cell.DailyRateTxtField.layer.borderColor = borderColor.cgColor

        cell.HoursTxtField.text = selectedHour
        cell.MinuteTxtField.text = selectedMinute

        
        
        return cell
        
    }
    func ButtonTableCell(indexPath: NSIndexPath) -> ButtonTableViewCell {
        
        let cell:ButtonTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCellIdentifier") as! ButtonTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        cell.nextButton.removeTarget(self, action:#selector(self.nextButtonTapped), for: .touchUpInside)
        cell.undoButton.removeTarget(self, action:#selector(self.undoButtonTapped), for: .touchUpInside)
        cell.backButton.removeTarget(self, action:#selector(self.backButtonTapped), for: .touchUpInside)
        
        cell.nextButton.addTarget(self, action:#selector(self.nextButtonTapped), for: .touchUpInside)
        cell.undoButton.addTarget(self, action:#selector(self.undoButtonTapped), for: .touchUpInside)
        cell.backButton.addTarget(self, action:#selector(self.backButtonTapped), for: .touchUpInside)
        if isFromSummaryPage == true{
            cell.returnToConfirmOrderButton.removeTarget(self, action:#selector(self.returnToConfirmOrderButtonTapped), for: .touchUpInside)
            cell.returnToConfirmOrderButton.addTarget(self, action:#selector(self.returnToConfirmOrderButtonTapped), for: .touchUpInside)
            cell.nextButton.isHidden = true
            cell.undoButton.isHidden = true
            cell.backButton.isHidden = true

            cell.returnToConfirmOrderButton.isHidden = false
        }else{
            cell.returnToConfirmOrderButton.isHidden = true
            cell.nextButton.isHidden = false
            cell.undoButton.isHidden = false
            cell.backButton.isHidden = false

        }
        return cell
        
    }
    @objc func returnToConfirmOrderButtonTapped(sender: UIButton){
        
        self.ValidatePayrateCall()

    }
    @objc func nextButtonTapped(sender: UIButton){
        
        //        self.pushToDOEWaiverFormPage()
        ////        self.createParamForValidatingPayRate()
        self.ValidatePayrateCall()
    }
    @objc func undoButtonTapped(sender: UIButton){
        
        selectedHour = "0"
        selectedMinute = "0"
        dailyRate = "0"
        DhourlyPayRate = "0"
         AhourlyPayRate = "0"
            
         RoundedDailyRate = ""
        POBillRate = "0"
        AnnualRate = "0"
        self.tableView.reloadData()
    }
    @objc func backButtonTapped(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func keyboardDoneBtnTapped (_ sender: UIButton){
        self.view.endEditing(true)
    }
    
    @objc func dailyRateBtnTapped(sender: UIButton){
        
        if sender.isSelected == true{
            sender.isSelected = false
            PayRateType = "A"
        }else{
            sender.isSelected = true
            PayRateType = "D"
        }
         self.tableView.reloadData()
    }
    @objc func AnnualRateBtnTapped(sender: UIButton){
        
        if sender.isSelected == true{
            sender.isSelected = false
            PayRateType = "D"
        }else{
            sender.isSelected = true
            PayRateType = "A"
        }
  
        self.tableView.reloadData()
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
    //MARK:Server Call
    func getPayrateCall(){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            //            JustHUD.shared.showInView(view: view)
            self.showLoading()
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let params :[String:String] = ["ClientId" : clientID]
            print(params)
            RestAPI.getDoePayrateData(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getPayrateCallResponse(response:))
        }else{
            willPushToWaiver = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    func getPayrateCallResponse(response:AnyObject)->()
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
            willPushToWaiver = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                
                PayRateType = object["PayRateType"].stringValue
                ReferralMarkup = object["ReferralMarkup"].stringValue
                NonReferralMarkup  = object["NonReferralMarkup"].stringValue
                MinimumWage = object["MinimumWage"].stringValue
                Note = object["Note"].stringValue
                let Hours = object["HoursList"].array
                let Minutes = object["MinutesList"].array
                
                for dict in Hours!{
                    let dictObj = ["Text":dict["Text"].stringValue,"Value":dict["Value"].stringValue,"isSelected":"0"]
                    HoursList.add(dictObj)
                }
                for dict in Minutes!{
                    let dictObj = ["Text":dict["Text"].stringValue,"Value":dict["Value"].stringValue,"isSelected":"0"]
                    MinuteList.add(dictObj)
                }
                
                self.tableView.reloadData()
                
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                willPushToWaiver = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }
    }
    func ValidatePayrateCall(){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            //            JustHUD.shared.showInView(view: view)
            self.showLoading()
            let defaults = UserDefaults.standard
            
            let userDefaults = UserDefaults.standard
            if userDefaults.object(forKey: "DoeApplicantModel") != nil{
                let decoded  = userDefaults.object(forKey: "DoeApplicantModel") as! Data
                let decodedApplicant = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Applicant
                selectedApplicant = decodedApplicant
            }
            var hPayRate = ""
            if PayRateType == "D"{
                hPayRate = DhourlyPayRate
            }else{
                hPayRate = AhourlyPayRate
            }
            let DoePayrateModel = ["HourlyPayRate" : String(format:"$%@",hPayRate),
                                   "Hours": selectedHour,
                                   "Minutes" :selectedMinute,
                                   "PayRate": dailyRate,
                                   "PayRateType": PayRateType,
                                   "PoBillRate" : String(format:"$%@",POBillRate),
                                   "RoundedDailyPayRate":String(format:"$%@",RoundedDailyRate)] as [String : Any]
            
            defaults.setValue(DoePayrateModel, forKey: "DoePayrateModel")
            defaults.synchronize()
            
            let DoeScheduleModel = defaults.dictionary(forKey: "DoeScheduleModel")
            
            let DOEModel = ["NonReferralMarkup": NonReferralMarkup,
                            "ReferralMarkup": ReferralMarkup,
                            "MinimumWage": MinimumWage,
                            "HourlyPayRate":String(format:"$%@",hPayRate),
                            "PoBillRate": String(format:"$%@",POBillRate)] as [String : Any]
            
            let Param = ["DoePayrateModel":DOEModel,
                         "DoeApplicantModel":["Type":selectedApplicant.appliType,"CandidateId":selectedApplicant.CandidateId,"ApplicationId":selectedApplicant.ApplicationId,"NewApplicant":selectedApplicant.NewApplicant],
                         "DoeCandidateModel":["Referral":"1"],
                         "DoeScheduleModel":DoeScheduleModel] as [String : Any]
            
            print(Param)
            
            //            RestAPI.ValidateDoePayrateData(self, params: Param as! [String : String], method: "POST", accessToken: "", acces: true, callBack: getValidatePayrateResponse(response:))
            
            let urlString = RestAPI.BaseUrl+RestAPI.DOE_Validate_Payrate_URL
            
            RestAPI.postRequestWithToken(urlString: urlString, params: Param, callback: getValidatePayrateResponse(response:))
            
        }else{
            willPushToWaiver = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    func getValidatePayrateResponse(response:AnyObject)->()
    {
        
        
        self.hideLoading()
        print(response)
        if response is String{
            //            lblNoData.isHidden = false
            var message = response as! String
            if message.count == 0 {
                message = Error_Message
            }
            willPushToWaiver = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                
                let WaiverNecessary = object["WaiverNecessary"].boolValue
                
                var DCMon = ""
                var DCTue = ""
                var DCWed = ""
                var DCThu = ""
                var DCFri = ""
                var DCSat = ""
                var DCSun = ""
                let Compensation = object["Compensation"].stringValue
                let PayYear1 = object["PayYear1"].stringValue
                let PayYearOne = object["PayYearOne"].stringValue

                let Totalpay = object["Totalpay"].stringValue
                let CurrYearCompensationOver50kYesno = object["CurrYearCompensationOver50kYesno"].stringValue
                let CurrYearCompensationOver30k = object["CurrYearCompensationOver30K"].stringValue
                let CurrYearCompensationOverThirtyk = object["CurrYearCompensationOverThirtyK"].stringValue

                if object["DailyCompensationMon"] != nil{
                    DCMon = object["DailyCompensationMon"].stringValue
                }
                if object["DailyCompensationTue"] != nil{
                    DCTue = object["DailyCompensationTue"].stringValue
                    
                }
                if object["DailyCompensationWed"] != nil{
                    DCWed = object["DailyCompensationWed"].stringValue
                    
                }
                if object["DailyCompensationThu"] != nil{
                    DCThu = object["DailyCompensationThu"].stringValue
                    
                }
                if object["DailyCompensationFri"] != nil{
                    DCFri = object["DailyCompensationFri"].stringValue
                    
                }
                if object["DailyCompensationSat"] != nil{
                    DCSat = object["DailyCompensationSat"].stringValue
                    
                }
                if object["DailyCompensationSun"] != nil{
                    DCSun = object["DailyCompensationSun"].stringValue
                    
                }
                let WorkOrderPayRoll = object["WorkOrderPayRoll"].stringValue
                //TODO: WorkOrderPOBilling value is saving as empty
                var WorkOrderPOBillingValue = ""
                if object["WorkOrderPoBilling"] != nil{
                      WorkOrderPOBillingValue = object["WorkOrderPoBilling"].stringValue
                }
                let DoePayrateScheduleModel = ["Compensation":Compensation,
                                               "CurrYearCompensationOver30k":CurrYearCompensationOver30k,
                                               "CurrYearCompensationOverThirtyK":CurrYearCompensationOver30k,
                                               "CurrYearCompensationOver50kYesno":CurrYearCompensationOver50kYesno,
                                               "DailyCompensationFri": DCFri,
                                               "DailyCompensationMon": DCMon,
                                               "DailyCompensationSat": DCSat,
                                               "DailyCompensationSun":DCSun,
                                               "DailyCompensationTue":DCTue,
                                               "DailyCompensationWed":DCWed,
                                               "DailyCompensationThu":DCThu,
                                               "PayYearOne": PayYearOne,
                                               "PayYear1": PayYear1,
                                               "Totalpay":Totalpay,
                                               "WaiverNecessary":WaiverNecessary,
                                               "WorkOrderPayRoll":WorkOrderPayRoll,
                                               "WorkOrderPOBilling":WorkOrderPOBillingValue] as [String : Any]
                
                UserDefaults.standard.setValue(DoePayrateScheduleModel, forKey: "DoePayrateScheduleModel")
                UserDefaults.standard.synchronize()
                
                
                if WaiverNecessary == true{
                    let message = object["Message"].stringValue
                    if message.count == 0 || (message.caseInsensitiveCompare("Success") == ComparisonResult.orderedSame){
                        
                        self.pushToDOEWaiverFormPage()
                        
                    }else{
                        willPushToWaiver = true
                        
                        self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Warning_Text, isAttributed: false)
                    }
                }else{
                     self.pushToDOEAcaBilling()
                }
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                willPushToWaiver = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }
    }
    @IBAction override func okButtonTapped(_ sender: Any) {
        //    self.alertController.dismiss(animated: true, completion: nil)
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
        if willPushToWaiver == true{
            self.pushToDOEWaiverFormPage()
            
        }
    }
    //MARK: TextField Methods
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == Hours_TxtField_TAG || textField.tag == Minutes_TxtField_TAG{
            
            self.view.endEditing(true)
            textField.resignFirstResponder()
        }else{
 
        }
        return true
    }
    public func textFieldDidBeginEditing(_ textField: UITextField){
        
        
        
        if textField.tag == Hours_TxtField_TAG || textField.tag == Minutes_TxtField_TAG{
            textField.resignFirstResponder()
            
            let placeholder = "Please Select"
            
            var tbleViewTag = Minute_TblView_TAG
            if textField.tag == Hours_TxtField_TAG{
                tbleViewTag = Hour_TblView_TAG
            }
            self.showDropDownTableViewWithTag(placeHolder: placeholder, tag: tbleViewTag)
        }else{
            
            textField.becomeFirstResponder()
                 if textField.text == "0"{
                    textField.text = ""
                }
         }
        
        
    }
    

    public  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
       

        if textField.tag == Enter_The_Daily_Rate_TxtField_TAG{//LocationCode text field
            var charsLimit = 7
            if PayRateType == "D"{
                charsLimit = 3
            }
            
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
            
        }else if textField.tag == Hourly_PayRate_TxtField_TAG{
            let charsLimit = 6
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace =  range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace
       
            let computationString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            
            // Take number of digits present after the decimal point.
            let arrayOfSubStrings = computationString.components(separatedBy: ".")
            
            if arrayOfSubStrings.count == 1 && computationString.count > MAX_BEFORE_DECIMAL_DIGITS {
                return false
            } else if arrayOfSubStrings.count == 2 {
                let stringPostDecimal = arrayOfSubStrings[1]
                return stringPostDecimal.count <= MAX_AFTER_DECIMAL_DIGITS
            }
            
            return newLength <= charsLimit
        }
        
        
        return true
        
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == Enter_The_Daily_Rate_TxtField_TAG{
            
            if PayRateType == "D"{
                if (textField.text?.count)! > 0{
                    dailyRate = textField.text!
                    
                    self.calculatePayRate()}
                
                }
            else{
                if (textField.text?.count)! > 0{
                
                    AnnualRate = textField.text!
                    self.CalculateAnnualPayRate()
                }
            }
        }else if textField.tag == Hourly_PayRate_TxtField_TAG{
            if (textField.text?.count)! > 0{
                
                if PayRateType == "D"{
                    DhourlyPayRate = textField.text!
                    
                    // only PO Bill rate will change
                    let POBillRateFloat:Double  = Double(DhourlyPayRate)! * Double(ReferralMarkup)!
                    POBillRate = String(format:"%.2f",POBillRateFloat)
                }else{
                    AhourlyPayRate = textField.text!
                    
                    // only PO Bill rate will change
                    let POBillRateFloat:Double  = Double(AhourlyPayRate)! * Double(ReferralMarkup)!
                    POBillRate = String(format:"%.2f",POBillRateFloat)
                }
                
            }
        }
        self.tableView.reloadData()

    }
    
    //MARK: Local Methods
    
    func calculatePayRate(){
        var POBillRateFloat:Double = Double(0)
        var HourlyPayRateFloat:Double = Double(0)
        var RoundedDailyPayRateFloat:Double = Double(0)
        var MinFloat:Double = Double(0)
        var MinuteFloat:Double = Double(0)
        var TimeFloat:Double = Double(0)
        
        MinFloat = 60/Double(selectedMinute)!
        MinuteFloat = 1/MinFloat
        let tFloat:Double = Double(selectedHour.isDouble())! + MinuteFloat
        let TimeString  = String(format:"%.2f",self.convertDoubleToTwoDecimalDouble(DoubleValue: tFloat))
        TimeFloat = Double(TimeString)!
        
        if TimeString == "0.00"{
            HourlyPayRateFloat = Double(0)
        }else{
            HourlyPayRateFloat = Double(dailyRate.isDouble())!/TimeFloat
        }
        DhourlyPayRate = String(format:"%.2f",self.convertDoubleToTwoDecimalDouble(DoubleValue: HourlyPayRateFloat))
        POBillRateFloat = Double(DhourlyPayRate.isDouble())! * Double(ReferralMarkup)!
        RoundedDailyPayRateFloat = Double(DhourlyPayRate.isDouble())! * TimeFloat
        RoundedDailyRate = String(format:"%.2f", RoundedDailyPayRateFloat)
        POBillRate = String(format:"%.2f",POBillRateFloat)
        
        self.tableView.reloadData()
    }
    func CalculateAnnualPayRate(){
        var POBillRateFloat:Double = Double(0)
        var HourlyPayRateFloat:Double = Double(0)
        HourlyPayRateFloat = Double(AnnualRate.isDouble())!/2080
        AhourlyPayRate = String(format:"%.2f",Double(HourlyPayRateFloat))
        //self.convertDoubleToTwoDecimalDouble(DoubleValue: HourlyPayRateFloat))
        POBillRateFloat = Double(AhourlyPayRate.isDouble())! * Double(ReferralMarkup.isDouble())!
        POBillRate = String(format:"%.2f", POBillRateFloat)

    }
    func convertDoubleToTwoDecimalDouble(DoubleValue: Double) -> Double{
 
        let stringValue = String(format:"%f",DoubleValue)
        let arr = stringValue.components(separatedBy: ".")
        if arr.count > 1{
            let afterDecimalStr = arr[1]
            let beforeDecimalStr = arr[0]
            
            let charDecimalStr =  afterDecimalStr.prefix(2)
            
            let valueStr = String(format:"%@.%@",beforeDecimalStr,charDecimalStr as CVarArg)
            
            
            return Double(valueStr)!
        }
        
        return DoubleValue
    }
    
    func showDropDownTableViewWithTag( placeHolder: String,tag: Int){
        
        for view in dropDownView.subviews {
            view.removeFromSuperview()
        }
        dropDownView.frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        dropDownView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        let clearView = UIView()
        clearView.backgroundColor = UIColor.white
        clearView.layer.borderColor = UIColor.darkGray.cgColor
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
    
    //MARK: Navigation
    func pushToDOEAcaBilling(){
//
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOEAcaBillingViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOEAcaBillingSegue") as! DOEAcaBillingViewController
            nextViewController.CandidateId = selectedApplicant.CandidateId!
         
            if PayRateType == "D"{
                nextViewController.HourlyPayRate = DhourlyPayRate
            }
            else{
                nextViewController.HourlyPayRate = AhourlyPayRate

            }
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    func pushToDOEWaiverFormPage(){
        
        var isControllerExists = false
        var vc = UIViewController()
        
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOEWaiverFormTableViewController {
                    print("Your controller exist")
                    isControllerExists = true
                     vc = UIViewController()
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOEWaiverFormSegue") as! DOEWaiverFormTableViewController
            nextViewController.isFromSummaryPage = self.isFromSummaryPage
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            let vc1:DOEWaiverFormTableViewController = vc as! DOEWaiverFormTableViewController
            vc1.isFromSummaryPage = self.isFromSummaryPage
            self.navigationController?.popToViewController(vc1, animated: true)
        }
        
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
        //
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
