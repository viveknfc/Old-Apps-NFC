//
//  TipCalViewController.swift
//  CWA
//
//  Created by NFC User on 3/25/19.
//  Copyright © 2019 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON
import MobileCoreServices

// protocol used for sending data back
protocol DataChagedDelegate: class {
    func userChangedInformation(changed: Bool,tempData:NSMutableDictionary,tempOldWeek:String,tempDayArray:NSMutableArray,selectedDayIndex:Int,weekDayInput:String,weekdayDateFormat:String)
    
    func userSubmittedSuccessFully(submitted:Bool,selectedDayIndex:Int,weekEnd:String,weekDayInput:String)
}


class TipCalViewController: HospitalityGroupTSViewController,UIDocumentPickerDelegate {

    // Outlet from storyboard
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addMoreBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var daysBtn: UIButton!
    @IBOutlet weak var calculateBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet var tableHeaderView: UIView!
    @IBOutlet weak var pendingErrorLabel: PaddingLabel!
    @IBOutlet weak var totalTipTxtField: UITextField!
    @IBOutlet weak var pendingLabelConstarin: NSLayoutConstraint!
    @IBOutlet weak var selectDayLabel: UILabel!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var rateHourTextField: UITextField!
    
    @IBOutlet weak var cashField: UITextField!
    @IBOutlet weak var creditField: UITextField!
    @IBOutlet var previewHeader: UIView!
    @IBOutlet weak var selectday: UILabel!
    @IBOutlet weak var preRatePerHour: UILabel!
    @IBOutlet weak var preCash: UILabel!
    @IBOutlet weak var preCredit: UILabel!
    @IBOutlet weak var preTotalTip: UILabel!
    @IBOutlet weak var pendingTextLabel: PaddingLabel!
    
    @IBOutlet weak var submitDaysButton: UIButton!
    @IBOutlet weak var submitRate: UILabel!
    @IBOutlet weak var submitCash: UILabel!
    @IBOutlet weak var submitCredit: UILabel!
    @IBOutlet weak var submitTipAmount: UILabel!
    @IBOutlet var submitView: UIView!
    @IBOutlet weak var fileNameTextField: UITextField!
    @IBOutlet weak var preViewFileName: UILabel!
    @IBOutlet weak var fileView: UIView!
    @IBOutlet weak var fileUploadLabel: UILabel!
    @IBOutlet weak var submitFileName: UILabel!
    
//Variable declaration's
    weak var delegate: DataChagedDelegate? = nil
    let DAYS_TABLEVIEW_TAG = 101
    var actionController = UIAlertController()
    var  eachTip = Double(0)
    var tempositionsList = NSMutableArray()
    var nonTempositionsList = NSMutableArray()
    var dayList = NSMutableArray()
    var selectedDateDay = ""
    var pendingText = String()
    var tipExistsText = String()
    var weekEnd = String()
    var cash = Double(0)
    var credit = Double(0)
    var selectedDayRow = Int()
    
    
    var isPreviewON = true
    var isTipSubmitted = false //true already tip is submitted
    var IsTimeSheetNotApprove = false // true we have pending timesheets
    var IsShowNonTemPostionsStaffEnable = false// true show non TS staff else hide
    var didChangeDay = false //true if changed any day using dropDown
    // tempData from previous screen
    var tempData = NSMutableDictionary()
    var tempOldWeekEnds = String()
    var tempDayArray = NSMutableArray()
    var invoiced = -1
    
    // picked file data
    var fileData = Data()
    var fileBytes = String()
    var fileName = String()
    var fileExt = String()
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // call this method on whichever class implements our delegate protocol
        //updating the HospitalityGroupTSViewController UI based on drop down selections
        delegate?.userChangedInformation(changed:didChangeDay, tempData:tempData, tempOldWeek:tempOldWeekEnds,tempDayArray:tempDayArray,selectedDayIndex:selectedDayIndex,weekDayInput:weekDayInput,weekdayDateFormat:weekdayDateFormat)
    }
    
    
    override func viewDidLoad() {
        
        
        pendingErrorLabel.isHidden = true
        daysBtn.setTitle(selectedDateDay, for: .normal)
        daysBtn.layer.borderColor = UIColor.lightGray.cgColor
        daysBtn.layer.borderWidth = 1
        
        submitDaysButton.setTitle(selectedDateDay, for: .normal)
        submitDaysButton.layer.borderColor = UIColor.lightGray.cgColor
        submitDaysButton.layer.borderWidth = 1
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(keyboardCalculateBtnTapped))]
        toolBar.sizeToFit()
        totalTipTxtField.inputAccessoryView = toolBar
        creditField.inputAccessoryView = toolBar
        cashField.inputAccessoryView = toolBar
        
        
        let backButton = UIBarButtonItem.init(customView: self.backButton())
        
        self.navigationItem.leftBarButtonItem = backButton
        
        // Do any additional setup after loading the view.
        
        //values are becoming as null as it is subcontroller
        //again storing the values
        weekdayDateFormat = selectedDateDay.components(separatedBy:" ")[0]
        weekDayInput = selectedDateDay.components(separatedBy:" ")[1]
        self.setupUIForPreview()
        
        selectedDayIndex = selectedDayRow
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.titlelbl.text = "Tip Calculator"
         
    }
    
    
// just changing it to prview or non preview
    func preSubmit()
    {
        if isPreviewON == true{
            self.titlelbl.text = "Tip Calculator"
            submitBtn.setTitle("Next", for: .normal)
            calculateBtn.isHidden = false
            daysBtn.isUserInteractionEnabled = true
            //totalTipTxtField.isUserInteractionEnabled = true
            cancelBtn.setTitle("Cancel", for: .normal)
            daysBtn.isHidden = false
            totalTipTxtField.isHidden = false
            calculateBtn.isHidden = false
            selectDayLabel.text = "Select Day"
            tipAmountLabel.text = "Tip Amount"
            tipAmountLabel.font = UIFont.systemFont(ofSize:13)
            selectDayLabel.font = UIFont.systemFont(ofSize:13)
            tableHeaderView.frame = CGRect(x:0, y:0, width:self.view.bounds.size.width, height:190)
            //fileView.isHidden = false
             //fileUploadLabel.isHidden = false
            tableView.tableHeaderView = tableHeaderView
        }else{
            self.titlelbl.text = "Tip Calculator Summary"
            if isTipSubmitted
            {
            if invoiced == 0
            {
            submitBtn.setTitle("Recalculate", for: .normal)
            }
            }
            else
            {
            submitBtn.setTitle("Submit", for: .normal)
            }
            calculateBtn.isHidden = true
            daysBtn.isUserInteractionEnabled = false
            //totalTipTxtField.isUserInteractionEnabled = false
            cancelBtn.setTitle("Back", for: .normal)
            daysBtn.isHidden = true
            totalTipTxtField.isHidden = true
            calculateBtn.isHidden = true
            //fileView.isHidden = true
            //fileUploadLabel.isHidden = true
            setUpPreViewHeader()
            
        }
        
        tableView.reloadData()
        
    }
    
    
    func setUpPreViewHeader()
    {
        
        selectday.text = "Day \(weekdayDateFormat)"
        preTotalTip.text = "Tip Amount \(totalTipTxtField.text!)"
        preCash.text = "Cash \(cash)"
        preCredit.text = "Credit \(credit)"
        preRatePerHour.text =  String(format:"Rate per hour %.2f",eachTip)
        selectday.halfTextMakeToBold(fullText:selectday.text!, changeText: "Day", textColor: UIColor.black)
        preTotalTip.halfTextMakeToBold(fullText:preTotalTip.text!, changeText: "Tip Amount", textColor:UIColor.black)
        preCash.halfTextMakeToBold(fullText:preCash.text!, changeText: "Cash", textColor: UIColor.black)
        preCredit.halfTextMakeToBold(fullText:preCredit.text!, changeText: "Credit", textColor: UIColor.black)
        preRatePerHour.halfTextMakeToBold(fullText:preRatePerHour.text!, changeText: "Rate per hour", textColor: UIColor.black)
        //preViewFileName.text = "File Name  \(fileName)"
         //preViewFileName.halfTextMakeToBold(fullText:preViewFileName.text!, changeText: "File Name", textColor: UIColor.black)
        previewHeader.frame = CGRect(x:0, y:0, width:self.view.bounds.size.width, height:150)
        tableView.tableHeaderView = previewHeader
    
    }
    
    //submitted header
    func setUpPreForSubmit()
    {
        if invoiced == 1
        {
        submitTipAmount.text = "Tip Amount \(cash+credit)"
        submitCash.text = "Cash \(cash)"
        submitCredit.text = "Credit \(credit)"
        submitRate.text =  String(format:"Rate per hour %.2f",eachTip)
        submitTipAmount.halfTextMakeToBold(fullText:submitTipAmount.text!, changeText: "Tip Amount", textColor:UIColor.black)
        submitCash.halfTextMakeToBold(fullText:submitCash.text!, changeText: "Cash", textColor: UIColor.black)
        submitCredit.halfTextMakeToBold(fullText:submitCredit.text!, changeText: "Credit", textColor: UIColor.black)
        submitRate.halfTextMakeToBold(fullText:submitRate.text!, changeText: "Rate per hour", textColor: UIColor.black)
        //submitFileName.text = "File Name "+fileName
         //submitFileName.halfTextMakeToBold(fullText:submitFileName.text!, changeText: "File Name", textColor: UIColor.black)
        submitView.frame = CGRect(x:0, y:0, width:self.view.bounds.size.width, height:180)
        tableView.tableHeaderView = submitView
        }
        else
        {
             tableView.tableHeaderView = tableHeaderView
        }
    }
    
    
    
    
//this is for the initial setup of the UI or when date is changes using dropdown
    func setupUIForPreview(){
    // if already tip amount submitted , not allwing to submit again
        if isTipSubmitted
        {
            
            if invoiced == 1
            {
                isPreviewON = false
                submitBtn.alpha = 0.5
                calculateBtn.isHidden = true
                submitBtn.isEnabled = false
                submitBtn.setTitle("Submit", for: .normal)
                //fileUploadLabel.isHidden = true
                //fileView.isHidden = true
                cancelBtn.setTitle("Back", for: .normal)
                pendingTextLabel.isHidden = true
                tableHeaderView.frame = CGRect(x:0, y:0, width:self.view.bounds.size.width, height:180)
                pendingLabelConstarin.constant = 0
                pendingTextLabel.text = ""
            }
            else
            {
                isPreviewON = true
                submitBtn.alpha = 1
                calculateBtn.isHidden = false
                submitBtn.isEnabled = true
                submitBtn.setTitle("Next", for: .normal)
                //fileUploadLabel.isHidden = false
                //fileView.isHidden = false
                cancelBtn.setTitle("Cancel", for: .normal)
                pendingErrorLabel.isHidden = false
                tableHeaderView.frame = CGRect(x:0, y:0, width:self.view.bounds.size.width, height:235)
                pendingLabelConstarin.constant = 65
                pendingTextLabel.text = tipExistsText
            }
            self.titlelbl.text = "Tip Calculator Summary"
            daysBtn.isUserInteractionEnabled = true
            //totalTipTxtField.isUserInteractionEnabled = false
           
            setUpPreForSubmit()
        }
        else
        {
            
            self.titlelbl.text = "Tip Calculator"
            isPreviewON = true
            submitBtn.setTitle("Next", for: .normal)
            calculateBtn.isHidden = false
            // if any pending sheets allowing for calculations but not for submit or preview
            if IsTimeSheetNotApprove
            {
                submitBtn.isEnabled = false
                submitBtn.alpha = 0.5
                pendingErrorLabel.isHidden = false
                tableHeaderView.frame = CGRect(x:0, y:0, width:self.view.bounds.size.width, height:220)
                pendingLabelConstarin.constant = 50
                pendingTextLabel.text = pendingText
                daysBtn.isUserInteractionEnabled = true
                //totalTipTxtField.isUserInteractionEnabled = true
            }
            else
            {
                if tempositionsList.count>0
                {
                    submitBtn.isEnabled = true
                    submitBtn.alpha = 1
                }
                else
                {
                    submitBtn.isEnabled = false
                    submitBtn.alpha = 0.5
                }
                //submitBtn.alpha = 1
                //submitBtn.isEnabled = true
                daysBtn.isUserInteractionEnabled = true
                //totalTipTxtField.isUserInteractionEnabled = true
                pendingErrorLabel.isHidden = true
                tableHeaderView.frame = CGRect(x:0, y:0, width:self.view.bounds.size.width, height:180)
                pendingLabelConstarin.constant = 0
                pendingTextLabel.text = ""
            }
            tableView.tableHeaderView = tableHeaderView
        }
        
        totalTipTxtField.text = "\(cash+credit)"
        rateHourTextField.text =  String(format:"%.2f",eachTip)
        cashField.text = String(format:"%.2f",cash)
        creditField.text = String(format:"%.2f",credit)
        tableView.reloadData()
        
    }
    

//this method is for calculating eachTip
    func eachTipCalculation(){
        
        if totalTipTxtField.text!.count > 0{
            let totalTip = totalTipTxtField.text!
            let totalCal:Double = Double(totalTip)!
            let totalStaffCount:Double = Double(tempositionsList.count + nonTempositionsList.count)
            var totalHours:Double = Double(0)
            print(totalStaffCount)
            for empObj in tempositionsList{
                let obj:HosGroupTS = empObj as! HosGroupTS
                totalHours =  totalHours + obj.TotalHours!
            }
            for empObj in nonTempositionsList{
                let obj:NonTSStaff = empObj as! NonTSStaff
                totalHours =  totalHours + obj.Hour!
            }
            eachTip  = Double(totalCal/totalHours)
            rateHourTextField.text =  String(format:"%.2f",eachTip)
            self.tableView.reloadData()
        }
        
        
    }
    
    override func backButton() -> UIButton {
        let bBtn = UIButton()
        
        bBtn.frame = CGRect(x:0,y:0,width: 40,height:40)
        bBtn.setImage(UIImage.init(named: "Back.png"),for:.normal)
        
        bBtn.addTarget(self, action:#selector(self.goBack), for: .touchUpInside)
        return bBtn
        
    }
    
    
    @objc override func goBack()
    {
        if isTipSubmitted
        {
            if invoiced == 1
            {
            self.navigationController?.popViewController(animated: true)
            }
            else
            {
                if self.isPreviewON == true{
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.isPreviewON = true
                    self.preSubmit()
                }
            }
        }
        else
        {
            if self.isPreviewON == true{
                self.navigationController?.popViewController(animated: true)
            }else{
                self.isPreviewON = true
                self.preSubmit()
            }
        }
    }
    
    @objc func keyboardCalculateBtnTapped(sender: UIButton)  {
        self.view.endEditing(true)
    }
    
    @IBAction func calculateBtnTapped(_ sender: Any) {
        self.view.endEditing(false)
        if totalTipTxtField.text!.count>0
        {
            if Double(totalTipTxtField.text!)==0
            {
                self.view.endEditing(true)
           self.showCustomAlert(Title:"", attMessage:NSAttributedString(), message:"Please enter cash or credit", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
            else
            {
                self.eachTipCalculation()
                self.view.endEditing(true)
                rateHourTextField.text =  String(format:"%.2f",eachTip)
            }
        }
        else
        {
            self.showCustomAlert(Title:"", attMessage:NSAttributedString(), message:"Please cash or credit", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
        
    }
    
    @IBAction func daysBtnTapped(_ sender: Any) {
        self.showDropDownWithTag(placeHolder: "Select Day")
        
    }
    
    @IBAction func submitDaytapped(_ sender: Any) {
         self.showDropDownWithTag(placeHolder: "Select Day")
    }
    
    
    
    
    @IBAction func addMoreBtnTapped(_ sender: UIButton){
        addMoreStaff()
    }
    
    @IBAction func submitBtnTapped(_ sender: UIButton){
        
        if totalTipTxtField.text!.count>0
        {
            if Double(totalTipTxtField.text!)==0
            {
                self.view.endEditing(true)
                self.showCustomAlert(Title:"", attMessage:NSAttributedString(), message:"Please enter cash or credit", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
            else
            {
//            if fileBytes.count>0
//            {
            if self.isPreviewON == true{
                self.isPreviewON = false
                //Call API for Preview
                showPreview()
            }else{
                self.isPreviewON = false
                //Call API for Submitting
                submitTip()
            }
            self.preSubmit()
            }
//            else
//            {
//                self.showCustomAlert(Title:"", attMessage:NSAttributedString(), message:"Please upload a file and then click on 'Next' button", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
//                }
//            }
        }
        else
        {
            
            self.showCustomAlert(Title:"", attMessage:NSAttributedString(), message:"Please enter cash or credit", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton){
        goBack()
    }
    
    
    
    
    
    @IBAction func deleteNonTemposStaffBtnTapped(_ sender: UIButton){
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        let  tsObj:NonTSStaff = nonTempositionsList[indexPath?.row ?? 0] as! NonTSStaff
        self.insertNonTSStaffServerCall(CandidateName:tsObj.Name!,TotalHours:tsObj.Hour!,Type:1,candId:"\(tsObj.CandidateId!)")
        if nonTempositionsList.contains(tsObj){
            nonTempositionsList.remove(tsObj)
        }
        eachTipCalculation()
        tableView.reloadData()
    }
    
 // this method is for adding non TS staff
    func addMoreStaff(){
        
        let alertController = UIAlertController(title: "Add New Staff", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Name"
            textField.delegate = self
            textField.keyboardType = .default
            textField.tag = 10102
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Hour"
            textField.delegate = self
            textField.keyboardType = .decimalPad
            textField.tag = 10101
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField
            if (firstTextField.text?.count)! > 0 && (secondTextField.text?.count)! > 0 {
                if self.isValidDecimal(newString: secondTextField.text!) == true {
                    let totalHr:Double = Double(secondTextField.text!)!
                    
                    if  totalHr < Double(24) && (totalHr > 0){
                        self.insertNonTSStaffServerCall(CandidateName:firstTextField.text!, TotalHours:Double(secondTextField.text!)!,Type:0, candId:"0")
                        let staff = NonTSStaff.init(Name: firstTextField.text!, Hour: Double(secondTextField.text!)!,CandidateId: Double(0),TimpAmount:0.0)
                        self.nonTempositionsList.add(staff)
                        self.eachTipCalculation()
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.tableView.reloadData()
                        })
                    }else{
                        if secondTextField.text == "0"
                        {
                            self.navigationController?.view.makeToast("Hour cannot be zero", duration: 1.5, position: .bottom, title: "", image: nil)
                        }
                        else
                        {
                            self.navigationController?.view.makeToast("Hours should be less than 24", duration: 1.5, position: .bottom, title: "", image: nil)
                        }
                    }
                    
                }else{
                    self.navigationController?.view.makeToast("Please enter hour in correct format", duration: 1.5, position: .bottom, title: "", image: nil)
                }
            }
            else
            {
                if (firstTextField.text?.count)! == 0
                {
                    self.showCustomAlert(Title:"", attMessage:NSAttributedString(), message:"Please enter name", okBtnTitle: "OK", cancelBtnTitle: "", type:self.Danger_Text, isAttributed: false)
                }
                else
                {
                    self.showCustomAlert(Title:"", attMessage:NSAttributedString(), message:"Please enter hour", okBtnTitle: "OK", cancelBtnTitle: "", type: self.Danger_Text, isAttributed: false)
                }
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
 //days dropDown Button
    func showDropDownWithTag( placeHolder: String){
        
        let modelName = UIDevice.current.modelName
        let  alertTableView = UITableView()
        alertTableView.tableFooterView = UIView()
        
        alertTableView.delegate = self
        alertTableView.dataSource = self
        alertTableView.tag = DAYS_TABLEVIEW_TAG
        alertTableView.backgroundColor = UIColor.clear
        actionController.view.clipsToBounds = true
        actionController.view.addSubview(alertTableView)
        alertTableView.reloadData()
        
        
        if modelName.contains("iPad") //||  modelName.contains("Simulator")
        {
            DispatchQueue.main.async(execute: { () -> Void in
                let vc = UIViewController()
                vc.view.isUserInteractionEnabled = true
                vc.preferredContentSize = CGSize(width: 250,height: 240)
                let margin = 8
                let rect = CGRect(x: margin, y: 0, width: 240, height: 230)
                alertTableView.frame = rect
                vc.view.addSubview(alertTableView)
                
                self.actionController = UIAlertController(title:placeHolder, message: nil, preferredStyle:
                    UIAlertController.Style.alert)
                self.actionController.setValue(vc, forKey: "contentViewController")
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: {
                    (alert: UIAlertAction!) in
                    print("OK")
                    self.tableView.reloadData()
                    self.actionController.dismiss(animated: true, completion: nil)
                    
                })
                self.actionController.addAction(okAction)
                
                self.present(self.actionController, animated: true, completion: nil)
            })
            
        }else{
            actionController = UIAlertController(title: placeHolder, message: "", preferredStyle: UIAlertController.Style.actionSheet)
            let alertHeight =  300 //self.view.frame.height * 0.80
            let margin = 8
            let rect = CGRect(x: margin, y: 50, width: Int(actionController.view.bounds.size.width - 35), height: alertHeight  - 120)
            alertTableView.frame = rect
            actionController.view.clipsToBounds = true
            actionController.view.addSubview(alertTableView)
            alertTableView.reloadData()
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: {
                (alert: UIAlertAction!) in
                print("OK")
                self.tableView.reloadData()
            })
            
            actionController.addAction(okAction)
            let modelName = UIDevice.current.modelName
            
            if modelName.contains("iPad") {
                actionController.modalPresentationStyle = .popover
                
                if let popoverController = actionController.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
                    popoverController.permittedArrowDirections = []
                    self.present(actionController, animated: true, completion: nil)
                    
                }
            }else{
                let height:NSLayoutConstraint = NSLayoutConstraint(item: actionController.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(alertHeight))
                actionController.view.addConstraint(height);
                self.present(actionController, animated: true, completion:{})
                
            }
        }
        
    }
    
    
//MARK: SERVER CALL
    func insertNonTSStaffServerCall(CandidateName:String,TotalHours:Any,Type:Int,candId:String){
        let isInternetAvailable =  self.isInternetAvailable()
        //
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            let params   = ["Clientid":clientID,
                            "Contactid":ContactId,
                            "WeekEnd":weekEnd,
                            "weekDayInput":weekdayDateFormat,
                            "CandidateName":CandidateName,
                            "TotalHours":TotalHours,
                            "Type":Type,"OSSource":"iOS","NonTSId":candId] as [String : Any] as NSDictionary
            
            print(params)
            let urlString = RestAPI.BaseUrl+RestAPI.HOS_GroupTS_InsertNonTSStaff_URL
            RestAPI.postRequestWithToken(urlString: urlString, params: params, callback: getInsertNonTSResponse(response:))
            
        }else{
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
    }
    //add or delete non TS staff response callback method
    func getInsertNonTSResponse(response:AnyObject)->()
    {
        JustHUD.shared.hide()
        self.navigationController?.view.hideAllToasts()
        
        print(response)
        if response is String{
            isGenerateInvoice = false
            isRemoveLogisticsTimeSheet = false
            isLogisticsTimeSheetRemoved = false
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            var object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
                
            }
            else if object["MessageStatus"].intValue == 2
            {
                goBack()
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message:object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
            getNonTSStaff()
        }
    }
    
    
    //This method calculates the tips from the server and shows before the final submit it's a preview
    func showPreview()
    {
        var existTip = Int()
        if isTipSubmitted == false
        {
            existTip = 0
        }
        else
        {
            existTip = 1
        }
        let isInternetAvailable =  self.isInternetAvailable()
        //
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            let params   = ["Clientid":clientID,
                            "Contactid":ContactId,
                            "WeekEnd":weekEnd,
                            "weekDayInput":weekdayDateFormat,
                            "TipAmount":totalTipTxtField.text!,
                            "ShowScheduledHours":ShowScheduledHours,"CashAmount":cash,"CreditAmount":credit,"FileName":"\(fileName)","ExistTip":existTip] as [String : Any] as NSDictionary
            
            print(params)
            let urlString = RestAPI.BaseUrl+RestAPI.HOS_GroupTS_Preview_URL
            RestAPI.postRequestWithToken(urlString: urlString, params: params, callback: getInsertNonTSResponse(response:))
            
        }else{
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
    }
    
    //preview response callback method
    func getPreviewResponse(response:AnyObject)->()
    {
        JustHUD.shared.hide()
        self.navigationController?.view.hideAllToasts()
        
        print(response)
        if response is String{
            isGenerateInvoice = false
            isRemoveLogisticsTimeSheet = false
            isLogisticsTimeSheetRemoved = false
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        else
        {
            let object = response as! JSON
            print(object)
            nonTSStaffArray.removeAllObjects()
            tempositionsList.removeAllObjects()
            if object["DaywiseNonTSGroupTimeSheet"].null == nil{
                let list = object["DaywiseNonTSGroupTimeSheet"].arrayValue
                
                for dict in list {
                    let staff = NonTSStaff.init(Name: dict["CandidateName"].stringValue, Hour: dict["TotalHours"].doubleValue, CandidateId: dict["CandidateId"].doubleValue,TimpAmount:dict["TipAmount"].doubleValue)
                    
                    nonTSStaffArray.add(staff)
                }
            }
            if object["DayGroupTimeSheet"].null == nil{
                let list = object["DayGroupTimeSheet"].arrayValue
                
                for dict in list {
                    let staff = HosGroupTS.init(CandidateName: dict["CandidateName"].stringValue,
                                                WeekEnd: dict["WeekEnd"].stringValue,
                                                PONumber: dict["PONumber"].stringValue,
                                                StartTime: dict["StartTime"].stringValue,
                                                EndTime: dict["EndTime"].stringValue,
                                                BreakValue: dict["BreakValue"].stringValue,
                                                TotalHours: dict["TotalHours"].doubleValue,
                                                Position: dict["Position"].stringValue,
                                                StartDate: dict["StartDate"].stringValue,
                                                PayForBreak: dict["PayForBreak"].boolValue,
                                                isSelected: "0",
                                                BackGroundColorCode: dict["BackGroundColorCode"].stringValue,
                                                EvalDB: dict["EvalDB"].doubleValue,
                                                TaxiVisible: dict["TaxiVisible"].boolValue,
                                                EvalDesc: dict["EvalDesc"].stringValue,
                                                IsApproveEnabled: dict["IsApproveEnabled"].boolValue,
                                                Taxi: dict["Taxi"].stringValue,
                                                EvalVisible: dict["EvalVisible"].boolValue,
                                                CandidateId: dict["CandidateId"].doubleValue,
                                                OrderId: dict["OrderId"].doubleValue,
                                                StartTimeTxtFieldTag: Start_Time_TextField_TAG,
                                                EndTimeTxtFieldTag: End_Time_TextField_TAG,
                                                willShow:"0",
                                                Eval: dict["Eval"].doubleValue,
                                                StartTimeDB: dict["StartTimeDB"].stringValue,
                                                EndTimeDB: dict["EndTimeDB"].stringValue,
                                                RecCode: dict["RecCode"].stringValue,
                                                Approver: dict["Approver"].doubleValue,
                                                IsApproved: dict["IsApproved"].boolValue,
                                                TaxiOk: dict["TaxiOk"].boolValue,
                                                TimeId: dict["TimeId"].doubleValue,
                                                DetailId: dict["DetailId"].doubleValue,
                                                AssignmentComplete: dict["AssignmentComplete"].doubleValue,
                                                Comments: dict["Comments"].stringValue,
                                                OriginalBreakValue: dict["BreakValue"].stringValue,
                                                OriginalComments: dict["Comments"].stringValue,
                                                ShowSave: dict["ShowSave"].boolValue,
                                                IsEvalDone: dict["IsEvalDone"].boolValue,TipAmount:dict["TipAmount"].doubleValue)
                    
                    tempositionsList.add(staff)
                }
            }
            
            tableView.reloadData()
            
        }
        
    }
    
    
    //this method is for submitting the final tip
    func submitTip()
    {
        
        var existTip = Int()
        if isTipSubmitted == false
        {
            existTip = 0
        }
        else
        {
            existTip = 1
        }
        
        let isInternetAvailable =  self.isInternetAvailable()
        //
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            let params   = ["Clientid":clientID,
                            "Contactid":ContactId,
                            "WeekEnd":weekEnd,
                            "weekDayInput":weekdayDateFormat,
                            "TipAmount":totalTipTxtField.text!,
                            "ShowScheduledHours":ShowScheduledHours,"OSSource":"iOS","CashAmount":cash,"CreditAmount":credit,"ExistTip":existTip] as [String : Any] as NSDictionary
            
            print(params)
            let urlString = RestAPI.BaseUrl+RestAPI.HOS_GroupTS_Submit_Tip
            RestAPI.postRequestWithToken(urlString: urlString, params: params, callback: geSubmitResponse(response:))
            
        }else{
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
    }
    
    //submit tip response callback method
    func geSubmitResponse(response:AnyObject)->()
    {
        JustHUD.shared.hide()
        self.navigationController?.view.hideAllToasts()
        
        print(response)
        if response is String{
            isGenerateInvoice = false
            isRemoveLogisticsTimeSheet = false
            isLogisticsTimeSheetRemoved = false
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        else
        {
            let object = response as! JSON
            print(object)
            if object["MessageStatus"].intValue == 1
            {
                //"MessageStatus": "0",
                //"Message": "Failure",
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message:object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                //navigating to HospitalityGroupTSViewController
                //and updating the HospitalityGroupTSViewController UI based on the TipSubmitted date
                self.navigationController?.popViewController(animated: true)
                delegate?.userSubmittedSuccessFully(submitted:true, selectedDayIndex:selectedDayIndex, weekEnd:weekEnd, weekDayInput:weekDayInput)
            }
            else
            {
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message:object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
            
            
        }
        
    }
    
    //overriding the method from base
    override func okButtonTapped(_ sender: Any) {
        
       alertController.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Server Call
    //this method gets the non TS staff array for the particular day
    func getNonTSStaff(){
        
        let isInternetAvailable =  self.isInternetAvailable()
        //
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            let params   = ["Clientid":clientID,
                            "Contactid":ContactId,
                            "WeekEnd":weekEnd,
                            "weekDayInput":weekdayDateFormat] as [String : Any] as NSDictionary
            
            print(params)
            let urlString = RestAPI.BaseUrl+RestAPI.HOS_GroupTS_GetNonTSStaff_URL
            RestAPI.postRequestWithToken(urlString: urlString, params: params, callback: getNonTSStaffResponse(response:))
            
        }else{
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
    }
    func getNonTSStaffResponse(response:AnyObject)->()
    {
        JustHUD.shared.hide()
        self.navigationController?.view.hideAllToasts()
        
        print(response)
        if response is String{
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            var object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
                nonTSStaffArray.removeAllObjects()
                if object["GetNonTsStaffList"].null == nil{
                    let list = object["GetNonTsStaffList"].arrayValue
                    
                    for dict in list {
                        let staff = NonTSStaff.init(Name: dict["CandidateName"].stringValue, Hour: dict["TotalHours"].doubleValue, CandidateId: dict["NonTSId"].doubleValue,TimpAmount:dict["TipAmount"].doubleValue)
                        
                        nonTSStaffArray.add(staff)
                    }
                }
            }
            tableView.reloadData()
        }
    }
    
    
    
    
//MARK: UITableView datasource and delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView.tag == DAYS_TABLEVIEW_TAG{
            return 1
        }
        if IsShowNonTemPostionsStaffEnable == false
        {
            return 1
        }
        else{
            return 2
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == DAYS_TABLEVIEW_TAG{
            return dayList.count
        }
        if section == 0{
            return tempositionsList.count
        }
        return nonTempositionsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == DAYS_TABLEVIEW_TAG{
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?
            if !(cell != nil) {
                cell = UITableViewCell(style:.subtitle, reuseIdentifier: "CELL")
            }
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            let dayDict = dayList[indexPath.row] as! NSDictionary
            cell?.textLabel!.text = String(format:"%@ %@",(dayDict["date"] as? String)!,(dayDict["day"] as? String)!)
            
            return cell!
        }
        let cell:TipCalTableCell = tableView.dequeueReusableCell(withIdentifier: "TipCalTableCell") as! TipCalTableCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.deleteBtn.isHidden = true
        if indexPath.section == 0{
            let  emp = tempositionsList[indexPath.row] as! HosGroupTS
            let  empObj:HosGroupTS = emp as HosGroupTS
            cell.nameLbl.text = empObj.CandidateName
            cell.hoursLbl.text = String(format:"%.2f",empObj.TotalHours!)
//            if empObj.TipAmount!>0.0
//            {
//                cell.tipLbl.text = String(format:"$%.2f",empObj.TipAmount!)
//            }
//            else
//            {
                cell.tipLbl.text = String(format:"$%.2f",(self.eachTip*empObj.TotalHours!))
           // }
            
        }else{
            if isPreviewON == true{
                cell.deleteBtn.isHidden = false
                cell.deleteBtn.addTarget(self, action: #selector(deleteNonTemposStaffBtnTapped), for: .touchUpInside)
            }else{
                cell.deleteBtn.isHidden = true
            }
            let staff = nonTempositionsList[indexPath.row] as? NonTSStaff
            cell.nameLbl.text = staff?.Name
            cell.hoursLbl.text = String(format:"%.2f",(staff?.Hour)!)
//            if staff!.TimpAmount!>0.0
//            {
//                cell.tipLbl.text = String(format:"$%.2f",staff!.TimpAmount!)
//            }
//            else
//            {
                cell.tipLbl.text = String(format:"$%.2f",(self.eachTip*(staff?.Hour)!))
            //e}
        }
        return cell
    }
    
    override   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.tag == DAYS_TABLEVIEW_TAG{
            return nil
        }
        let dView =  Bundle.main.loadNibNamed("TipCalHeaderView", owner: self, options: nil)?[0] as! TipCalHeaderView
        //let User_ColorCode = UserDefaults.standard.object(forKey:"ColorCode")as! String
        dView.headingview.backgroundColor = UIColor.lightGray
        dView.headingLbl.textColor = UIColor.white
        if section == 0{
            dView.headingLbl.text = "TemPositions Eden Hospitality Staff"
            dView.addMoreBtn.isHidden = true
        }else{
            dView.headingLbl.text = "Non-TemPositions Eden Hospitality Staff"
            if isPreviewON == true{
                if tempositionsList.count>0
                {
                dView.addMoreBtn.isHidden = false
                }
                else
                {
                dView.addMoreBtn.isHidden = true
                }
                dView.addMoreBtn.removeTarget(self, action: #selector(addMoreBtnTapped), for: .touchUpInside)
                dView.addMoreBtn.addTarget(self, action: #selector(addMoreBtnTapped), for: .touchUpInside)
            }else{
                dView.addMoreBtn.isHidden = true
            }
        }
        
        return dView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.tag == DAYS_TABLEVIEW_TAG{
            return 0
            
        }
        return 60
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == DAYS_TABLEVIEW_TAG{
            didChangeDay = true
            selectedDayIndex = indexPath.row
            let dayDict1 = dayList[indexPath.row] as! NSDictionary
            daysBtn.setTitle(String(format:"%@ %@",(dayDict1["date"] as? String)!,(dayDict1["day"] as? String)!), for: .normal)
            submitDaysButton.setTitle(String(format:"%@ %@",(dayDict1["date"] as? String)!,(dayDict1["day"] as? String)!), for: .normal)
            self.weekdayDateFormat = (dayDict1["date"] as? String)!
            self.actionController.dismiss(animated: false, completion: nil)
            let dayDict = self.dayList[indexPath.row] as! NSDictionary
            self.selectedDateDay = (dayDict["day"] as? String)!
            self.weekDayInput = self.selectedDateDay
            self.weekendDate = weekEnd
            cashField.text = ""
            creditField.text = ""
            eachTip = Double(0)
            cash = Double(0)
            credit = Double(0)
            totalTipTxtField.text = "\(cash+credit)"
            fileName = ""
            fileBytes = ""
            fileExt = ""
            //fileNameTextField.text = ""
            self.getHospitalityGroupTimeSheetData()
        }
        
    }
    
    
//MARK: TextField delegate methods
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    
        if textField==cashField||textField==creditField
        {
            if cashField.text!.count>0
            {
                cash = Double(cashField.text!)!
            }
            else
            {
                cash = Double(0)
            }
            if creditField.text!.count>0
            {
                credit = Double(creditField.text!)!
            }
            else
            {
                 credit = Double(0)
            }
            totalTipTxtField.text = "\(cash+credit)"
            self.eachTipCalculation()
            rateHourTextField.text =  String(format:"%.2f",eachTip)
            
        }
        return true
    }
    
    
    func isValidDecimal(newString: String)-> Bool{
        
        let scanner: Scanner = Scanner(string:newString)
        let isNumeric = scanner.scanDecimal(nil) && scanner.isAtEnd
        
        return isNumeric
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 10101{
            
            
            if (textField.text?.contains("."))!
            {
                if string == "."
                {
                    return false
                }
                else
                {
                    
                    return validateDecimal(textField,string:string,range:range)
                }
            }
            else
            {
                return validateDecimal(textField,string:string,range:range)
            }
            
        }
        else if textField.tag == 10102
        {
            return true
        }
        var dotLocation = Int()
        
        let nonNumberSet = CharacterSet(charactersIn: "0123456789.").inverted
        
        if Int(range.length) == 0 && string.count == 0 {
            return true
        }
        
        if (string == ".") {
            if (textField.text?.contains("."))!{
                return false
            }
            if Int(range.location) == 0 {
                return false
            }
            if dotLocation == 0 {
                dotLocation = range.location
                return true
            }
        }
        
        if range.location == dotLocation && string.count == 0 {
            dotLocation = 0
        }
        
        if dotLocation > 0 && range.location > dotLocation + 2 {
            return false
        }
        
        if range.location >= 4 {
            
            if dotLocation >= 4 || string.count == 0 {
                return true
            } else if range.location > dotLocation + 2 {
                if (textField.text?.contains("."))! {
                    let limitDecimalPlace = 2
                    let decimalPlace = textField.text?.components(separatedBy: ".").last
                    if (decimalPlace?.count)! < limitDecimalPlace {
                        return true
                    }
                    else {
                        return false
                    }
                }
                return false
            }
            
            var newValue = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            newValue = newValue?.components(separatedBy: nonNumberSet).joined(separator: "")
            textField.text = newValue
            
            return false
            
        } else {
            return true
        }
        
    }
    
    func validateDecimal(_ textField:UITextField,string:String,range:NSRange) ->Bool
    {
        var charsLimit = 2
        if (textField.text?.contains("."))!
        {
            charsLimit = 5
         return maxToSixty(textField:textField, string:string)
        }
        else if textField.text!.count>0
        {
            if Int(textField.text!)==24
            {
                charsLimit = 2
            }
            else if Int(textField.text!)!<24
            {
                if string == "."
                {
                    charsLimit = 5
                }
                else
                {
                    charsLimit = 2
                }
            }
            else if (textField.text?.contains("."))!
            {
                charsLimit = 5
                return maxToSixty(textField:textField, string:string)
            }
        }
        
        let startingLength = textField.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace =  range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        return newLength <= charsLimit
    }
    
    
    func maxToSixty(textField:UITextField,string:String) -> Bool {
        var startString = ""
        if textField.text != nil {
            startString += textField.text!.components(separatedBy:".")[1]
        }
        if startString.count>0
        {
            startString += string
            let limitNumber = Int(startString)!
            if limitNumber > 59 {
                return false
            } else {
                return true
            }
        }
        else
        {
            return true
        }
    }
    
    
    @IBAction func chooseFileAction(_ sender: Any)
    {
        uploadClicked()
    }
    
    @IBAction func deleteFileAction(_ sender: Any) {

        fileName = ""
        fileBytes = ""
        fileExt = ""
        fileNameTextField.text = ""
    }
    
    //chose file is clicked
    @objc func uploadClicked() {
        
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes:[String(kUTTypeContent)], in: UIDocumentPickerMode.import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(documentPicker, animated: true, completion: nil)
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        if controller.documentPickerMode == UIDocumentPickerMode.import {
            // This is what it should be
            let extensionsArray = [".docx",".doc",".pdf",".rtf",".txt"]
            let urlPath = url as URL
            print("The Url is",urlPath)
            fileData = try! Data(contentsOf:urlPath)
            fileBytes = fileData.base64EncodedString()
            fileName =  urlPath.lastPathComponent
            fileExt =   "."+url.lastPathComponent.components(separatedBy:".")[1]
            
            if extensionsArray.contains(fileExt)
            {
               fileNameTextField.text = fileName
            }
            else
            {
            
                self.showCustomAlert(Title:"", attMessage: NSAttributedString(), message:"Only '.pdf','.doc', '.txt', '.docx', '.rtf' formats are allowed.", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
    
}
