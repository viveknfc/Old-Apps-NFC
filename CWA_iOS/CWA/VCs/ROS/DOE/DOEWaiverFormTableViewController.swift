//
//  DOEWaiverFormTableViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 20/04/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON

class DOEWaiverFormTableViewController: BaseTableViewController,UITextViewDelegate {
    
    var justification = ""
    var dailyCompensationValue = ""
    var crntYrCompIncludingEarning = ""
    var crntYrCompl = ""
    //
    var isRetireeReceivingPensionYesBtnTapped = false
    var isRetireeReceivingPensionNoBtnTapped = true
    var isConsultantJoinPrior1973YesBtnTapped = false
    var isConsultantJoinPrior1973NoBtnTapped = false
    var isOver65YesBtnTapped = false
    var isOver65NoBtnTapped = false
    
    var isFromSummaryPage = false
var PDFfilePath = ""
    var sched = ""
    var selectedApplicant = Applicant.init(CandidateId: "0", ApplicantId: "", Name: "", ConsultantType: "", Email: "", Address: "", City: "", State: "", Zip: "", SSN: "", isSelected: "",appliType: "",ApplicationId:  "0",NewApplicant:  "",extraCandId: "0")

    
    var isValidJustification = true
    var responseObject:JSON = JSON.null
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getWaiverFormCall()
        
    }
    
    @objc func methodOfReceivedNotification(){
        
         isFromSummaryPage = true
//        self.getWaiverFormCall()

        let defaults = UserDefaults.standard
 
        let DoeWaiverModel =  defaults.dictionary(forKey: "DoeWaiverModel")
        crntYrCompl = DoeWaiverModel!["FormatCurrYearCompensationOver30k"] as! String
        crntYrCompIncludingEarning = DoeWaiverModel!["FormatYtdCompensationCurrYear"] as! String//PayYearOne
        dailyCompensationValue = DoeWaiverModel!["DailyCompensation"] as! String
        justification = DoeWaiverModel!["WaiverText"] as! String
        isOver65YesBtnTapped = DoeWaiverModel!["OverAge"] as! String == "0" ? false : true
        isRetireeReceivingPensionYesBtnTapped = DoeWaiverModel!["RetireeReceivingPensionYesno"] as! String == "0" ? false : true
        isConsultantJoinPrior1973YesBtnTapped = DoeWaiverModel!["RetirementSystem"] as! String == "0" ? false : true
        
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
        
        if  UserDefaults.standard.dictionary(forKey: "DoeWaiverModel") != nil{
            let DoeWaiverModel  =  UserDefaults.standard.dictionary(forKey: "DoeWaiverModel")
            justification = DoeWaiverModel!["WaiverText"] as! String
            
        }
        

        self.titlelbl.text = "DOE Waiver form"
 
        if isFromSummaryPage == true{
            self.methodOfReceivedNotification()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Button Action
    
    @objc func RetireeReceivingPensionNoBtnTapped(_ sender: UIButton){
        if sender.isSelected == true{
            sender.isSelected = false
            if isRetireeReceivingPensionYesBtnTapped == true{
            isRetireeReceivingPensionNoBtnTapped = false
            }
        }else{
            sender.isSelected = true
            isRetireeReceivingPensionNoBtnTapped = true
            isRetireeReceivingPensionYesBtnTapped = false
 
        }
 
         //all cells needs to be reloaded
        let indPath1 = IndexPath(row: 1, section: 0)
        let indPath2 = IndexPath(row: 2, section: 0)
        
        DispatchQueue.main.async(execute: { () -> Void in
//            print("DispatchQueue")
            
            self.tableView.reloadRows(at: [indPath1,indPath2], with: .none)
        })
        
    }
    
    @objc func RetireeReceivingPensionYesBtnTapped(_ sender: UIButton){
        
        if sender.isSelected == true{
            sender.isSelected = false
            if isRetireeReceivingPensionNoBtnTapped == true{
                isRetireeReceivingPensionYesBtnTapped = false
            }
        }else{
            sender.isSelected = true
            isRetireeReceivingPensionYesBtnTapped = true
            isRetireeReceivingPensionNoBtnTapped = false
        }
        
        let indPath1 = IndexPath(row: 1, section: 0)
        let indPath2 = IndexPath(row: 2, section: 0)

        DispatchQueue.main.async(execute: { () -> Void in
//            print("DispatchQueue")
            
            self.tableView.reloadRows(at: [indPath1,indPath2], with: .none)
        })
        
    }
    @objc func ConsultantJoinPrior1973YesBtnTapped(_ sender: UIButton){
        
        if sender.isSelected == true{
            sender.isSelected = false
            if isConsultantJoinPrior1973NoBtnTapped == true{
                isConsultantJoinPrior1973YesBtnTapped = false
            }
        }else{
            sender.isSelected = true
            isConsultantJoinPrior1973YesBtnTapped = true
            isConsultantJoinPrior1973NoBtnTapped = false

        }
        
        
        let indPath1 = IndexPath(row: 1, section: 0)
        let indPath2 = IndexPath(row: 2, section: 0)
        
        DispatchQueue.main.async(execute: { () -> Void in
//            print("DispatchQueue")
            
            self.tableView.reloadRows(at: [indPath1,indPath2], with: .none)
        })
        
    }
    @objc func ConsultantJoinPrior1973NoBtnTapped(_ sender: UIButton){
        
        
        
        if sender.isSelected == true{
            sender.isSelected = false
            if isConsultantJoinPrior1973YesBtnTapped == true{
                isConsultantJoinPrior1973NoBtnTapped = false
            }
        }else{
            sender.isSelected = true
            isConsultantJoinPrior1973NoBtnTapped = true
            isConsultantJoinPrior1973YesBtnTapped = false
        }
        
        
        
        let indPath1 = IndexPath(row: 1, section: 0)
        let indPath2 = IndexPath(row: 2, section: 0)
        
        DispatchQueue.main.async(execute: { () -> Void in
//            print("DispatchQueue")
            
            self.tableView.reloadRows(at: [indPath1,indPath2], with: .none)
        })
        
    }
    @objc func Over65YesBtnTapped(_ sender: UIButton){
        
        
        
        if sender.isSelected == true{
            sender.isSelected = false
            if isOver65NoBtnTapped == true{
                isOver65YesBtnTapped = false
            }
        }else{
            sender.isSelected = true
            isOver65YesBtnTapped = true
            isOver65NoBtnTapped = false
        }
        
        
        
        
        
        
        let indPath1 = IndexPath(row: 1, section: 0)
        let indPath2 = IndexPath(row: 2, section: 0)
        
        DispatchQueue.main.async(execute: { () -> Void in
//            print("DispatchQueue")
            
            self.tableView.reloadRows(at: [indPath1,indPath2], with: .none)
        })
        
    }
    @objc func Over65NoBtnTapped(_ sender: UIButton){
        
        if sender.isSelected == true{
            sender.isSelected = false
            if isOver65YesBtnTapped == true{
                isOver65NoBtnTapped = false
            }
        }else{
            sender.isSelected = true
            isOver65NoBtnTapped = true
            isOver65YesBtnTapped = false
        }
        
        
        let indPath1 = IndexPath(row: 1, section: 0)
        let indPath2 = IndexPath(row: 2, section: 0)
        
        DispatchQueue.main.async(execute: { () -> Void in
//            print("DispatchQueue")
            
            self.tableView.reloadRows(at: [indPath1,indPath2], with: .none)
        })
        
    }
    @IBAction func keyboardDoneBtnTapped (_ sender: UIButton){
        self.view.endEditing(true)
    }
    @objc func nextButtonTapped(sender:UIButton){
        
        if justification.count == 0{
            isValidJustification = false
            self.tableView.reloadData()
            self.showCustomAlert(Title: "" , attMessage: NSAttributedString(), message: "Please enter waiver text", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

        }else{
            self.ValidateWaiverForm()
        }
    }
    
    @objc func undoButtonTapped(sender:UIButton){
        justification = ""
        
          isRetireeReceivingPensionYesBtnTapped = false
          isRetireeReceivingPensionNoBtnTapped = true
          isConsultantJoinPrior1973YesBtnTapped = false
          isConsultantJoinPrior1973NoBtnTapped = false
          isOver65YesBtnTapped = false
          isOver65NoBtnTapped = false
        self.tableView.reloadData()
    }
    
    @objc func backButtonTapped(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func ClickHereBtnTapped(sender:UIButton){
//open the PDF
      self.pushToViewPDFPage()
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
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 1:
            do {
                return self.WaiverFormCell(indexPath: indexPath as NSIndexPath)
            }
        case 2:
            do {
                return self.textViewCell(indexPath: indexPath as NSIndexPath)
            }
        case 3:
            do {
                return self.ButtonTableCell(indexPath: indexPath as NSIndexPath)
            }
        case 0:
            do {
                return self.WaiverNeededTableCell(indexPath: indexPath as NSIndexPath)
            }
        default:
            break
        }
        return UITableViewCell()
    }
    override   public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 1:
            do {
                if isRetireeReceivingPensionYesBtnTapped == true{
                    return 400
                }
                return 251
            }
        case 2:
            do {
                if isRetireeReceivingPensionYesBtnTapped == true && isConsultantJoinPrior1973NoBtnTapped == true && isOver65NoBtnTapped == true{
                    return 300
                }
                return 260
            }
        case 3:
            do {
                return 60
            }
        case 0:
            do {
                if sched == "n"{
                    return 399
                }
                return 295
            }
        default:
            break
        }
        return 44
    }
    //MARK: Cell
    
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
            cell.nextButton.addTarget(self, action:#selector(self.nextButtonTapped), for: .touchUpInside)
            cell.undoButton.addTarget(self, action:#selector(self.undoButtonTapped), for: .touchUpInside)
            cell.backButton.addTarget(self, action:#selector(self.backButtonTapped), for: .touchUpInside)

            cell.returnToConfirmOrderButton.isHidden = true
            cell.nextButton.isHidden = false
            cell.undoButton.isHidden = false
            cell.backButton.isHidden = false

        }
        return cell
        
    }
    @objc func returnToConfirmOrderButtonTapped(sender: UIButton){
        
        isFromSummaryPage = false
         if justification.count == 0{
            isValidJustification = false
            self.tableView.reloadData()
        }else{
            self.ValidateWaiverForm()
        }
    }
    func WaiverNeededTableCell(indexPath: NSIndexPath) -> WaiverNeededTableCell {
        
        let cell:WaiverNeededTableCell = self.tableView.dequeueReusableCell(withIdentifier: "WaiverNeededTableCellIdentifier") as! WaiverNeededTableCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.dailyCompensationValueLabel.text =  dailyCompensationValue
        cell.topHeadingLabel.text = responseObject["WaiverText"].stringValue
        cell.DailyCompensationTextLabel.text = responseObject["DailyCompensationText"].stringValue
       
        return cell
    }
    
    func WaiverFormCell(indexPath: NSIndexPath) -> WaiverFormTableCell {
        
        let cell:WaiverFormTableCell = self.tableView.dequeueReusableCell(withIdentifier: "WaiverFormTableCellIdentifier") as! WaiverFormTableCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.crntYrCompIncludingEarninglLab.text = String(format:"$%@",crntYrCompIncludingEarning)
        cell.crntYrComplLab.text = String(format:"$%@",crntYrCompl)
        cell.FormatYtdCompensationNextYearTextLabel.text = responseObject["FormatYtdCompensationNextYearText"].stringValue
        cell.FormatCurrYearCompensationOver30kTextLabel.text = responseObject["FormatCurrYearCompensationOver30kText"].stringValue
        cell.ConsultantPensionTextLabel.text = responseObject["ConsultantPensionText"].stringValue
         cell.ConsultantPriortoMayTextLabel.text = responseObject["ConsultantPriortoMayText"].stringValue
         cell.ConsultantOver65TextLabel.text = responseObject["ConsultantOver65Text"].stringValue
         
        
        cell.RetireeReceivingPensionYesBtn.removeTarget(self, action: #selector(RetireeReceivingPensionYesBtnTapped), for: .touchUpInside)
        cell.RetireeReceivingPensionNoBtn.removeTarget(self, action: #selector(RetireeReceivingPensionNoBtnTapped), for: .touchUpInside)
        
        cell.ConsultantJoinPrior1973YesBtn.removeTarget(self, action: #selector(ConsultantJoinPrior1973YesBtnTapped), for: .touchUpInside)
        cell.ConsultantJoinPrior1973NoBtn.removeTarget(self, action: #selector(ConsultantJoinPrior1973NoBtnTapped), for: .touchUpInside)
        
        cell.Over65YesBtn.removeTarget(self, action: #selector(Over65YesBtnTapped), for: .touchUpInside)
        cell.Over65NoBtn.removeTarget(self, action: #selector(Over65NoBtnTapped), for: .touchUpInside)
        
        
        
        cell.RetireeReceivingPensionYesBtn.addTarget(self, action: #selector(RetireeReceivingPensionYesBtnTapped), for: .touchUpInside)
        cell.RetireeReceivingPensionNoBtn.addTarget(self, action: #selector(RetireeReceivingPensionNoBtnTapped), for: .touchUpInside)
        
        cell.ConsultantJoinPrior1973YesBtn.addTarget(self, action: #selector(ConsultantJoinPrior1973YesBtnTapped), for: .touchUpInside)
        cell.ConsultantJoinPrior1973NoBtn.addTarget(self, action: #selector(ConsultantJoinPrior1973NoBtnTapped), for: .touchUpInside)
        
        cell.Over65YesBtn.addTarget(self, action: #selector(Over65YesBtnTapped), for: .touchUpInside)
        cell.Over65NoBtn.addTarget(self, action: #selector(Over65NoBtnTapped), for: .touchUpInside)
        
       
        if isRetireeReceivingPensionYesBtnTapped == true{
            cell.Over65View.isHidden = false
            cell.ConsultantJoinPrior1973View.isHidden = false
         }else{
            cell.Over65View.isHidden = true
            cell.ConsultantJoinPrior1973View.isHidden = true
        }
        
        
        
        if isRetireeReceivingPensionYesBtnTapped == false && isRetireeReceivingPensionNoBtnTapped == false{
       
        }else{
        
            if isRetireeReceivingPensionYesBtnTapped == true{
             cell.Over65View.isHidden = false
             cell.ConsultantJoinPrior1973View.isHidden = false
            cell.RetireeReceivingPensionYesBtn.isSelected = true
            cell.RetireeReceivingPensionNoBtn.isSelected = false
        }else{
            cell.Over65View.isHidden = true
            cell.ConsultantJoinPrior1973View.isHidden = true
            cell.RetireeReceivingPensionYesBtn.isSelected = false
            cell.RetireeReceivingPensionNoBtn.isSelected = true

            }
            
        }
        if isConsultantJoinPrior1973NoBtnTapped == false && isConsultantJoinPrior1973YesBtnTapped == false{
        }else{
        if isConsultantJoinPrior1973NoBtnTapped == true{
            cell.ConsultantJoinPrior1973NoBtn.isSelected = true
            cell.ConsultantJoinPrior1973YesBtn.isSelected = false
        }else{
            cell.ConsultantJoinPrior1973NoBtn.isSelected = false
            cell.ConsultantJoinPrior1973YesBtn.isSelected = true

            }
        }
        
        if isOver65YesBtnTapped == false && isOver65NoBtnTapped == false{
        }else{
        if isOver65YesBtnTapped == true{
            cell.Over65YesBtn.isSelected = true
            cell.Over65NoBtn.isSelected = false
        }else{
            cell.Over65YesBtn.isSelected = false
            cell.Over65NoBtn.isSelected = true
            }
        }
        

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
        cell.lblSubHeader.text = responseObject["InternalDOEWaiverText"].stringValue
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(keyboardDoneBtnTapped))]
        toolBar.sizeToFit()
        cell.entryTextView.inputAccessoryView = toolBar
        cell.entryTextView.text = justification
        
        if isValidJustification == false{
            cell.entryTextView.layer.borderColor = UIColor.red.cgColor
        }
        if isRetireeReceivingPensionYesBtnTapped == true && isConsultantJoinPrior1973NoBtnTapped == true && isOver65NoBtnTapped == true{
             cell.dropDownBtn.isHidden = false
 cell.lblHeader.text = "211 Waiver"
            cell.dropDownBtn.removeTarget(self, action: #selector(self.ClickHereBtnTapped), for: .touchUpInside)

            cell.dropDownBtn.addTarget(self, action: #selector(self.ClickHereBtnTapped), for: .touchUpInside)
        }else{
 cell.lblHeader.text = "Internal DOE Waiver"
            cell.dropDownBtn.isHidden = true
        }
        return cell
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        justification = textView.text
    }
    
    //MARK: Server Call
    
    func getWaiverFormCall(){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
 
            self.showLoading()
            let defaults = UserDefaults.standard
            
            let userDefaults = UserDefaults.standard
            if userDefaults.object(forKey: "DoeApplicantModel") != nil{
                let decoded  = userDefaults.object(forKey: "DoeApplicantModel") as! Data
                let decodedApplicant = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Applicant
                selectedApplicant = decodedApplicant
            }
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let DoePayrateScheduleModel = defaults.value(forKey: "DoePayrateScheduleModel")
            let DoePayrateModel = defaults.value(forKey: "DoePayrateModel")
            let DoeScheduleModel = defaults.dictionary(forKey: "DoeScheduleModel")
            let DoeEditWorkOrderModel = ["ClientId": clientID]
            
            let Param = ["DoeEditWorkOrderModel":DoeEditWorkOrderModel,
                         "DoePayrateModel": DoePayrateModel,
                         "DoePayrateScheduleModel": DoePayrateScheduleModel,
                         "DoeApplicantModel":["Type":selectedApplicant.appliType,"CandidateId":selectedApplicant.CandidateId,"ApplicationId":selectedApplicant.ApplicationId,"NewApplicant":selectedApplicant.NewApplicant],
                         "DoeCandidateModel": ["Referral":"1"],
                         "DoeScheduleModel": DoeScheduleModel] as [String : Any]
            
            print(Param)
            
            let urlString = RestAPI.BaseUrl+RestAPI.DOE_Waiver_Form_URL
            
            RestAPI.postRequestWithToken(urlString: urlString, params: Param, callback: getWaiverFormCallResponse(response:))
            
        }else{
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
    }
    func getWaiverFormCallResponse(response:AnyObject)->()
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
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            responseObject = response as! JSON
            Constants.DOEResponseObject = responseObject
            if responseObject["MessageStatus"].intValue == 1
            {
                
                 crntYrCompIncludingEarning = responseObject["FormatYtdCompensationCurrYear"].stringValue
                crntYrCompl = responseObject["FormatCurrYearCompensationOver30k"].stringValue
           
                PDFfilePath = responseObject["DOEWaiverMemorandum"].stringValue
                let RetireeReceivingPensionYesno = responseObject["RetireeReceivingPensionYesno"].stringValue
                let ConsultantJoinPrior1973Yesno = responseObject["ConsultantJoinPrior1973Yesno"].stringValue
                let Over65Yesno = responseObject["Over65Yesno"].stringValue
                 sched = responseObject["sched"].stringValue
                if sched == "s"{
                    dailyCompensationValue = String(format:"$%@",responseObject["DailyCompensation"].stringValue)

                }else{
                    let sunComp = String(format:"Sun: $%@",responseObject["DailyCompensationSun"].stringValue)
                    let monComp = String(format:"Mon: $%@",responseObject["DailyCompensationMon"].stringValue)
                    let tueComp = String(format:"Tue:  $%@",responseObject["DailyCompensationTue"].stringValue)
                    let wedComp = String(format:"Wed: $%@",responseObject["DailyCompensationWed"].stringValue)
                    let thuComp = String(format:"Thu:  $%@",responseObject["DailyCompensationThu"].stringValue)
                    let friComp = String(format:"Fri:    $%@",responseObject["DailyCompensationFri"].stringValue)
                    let satComp = String(format:"Sat:  $%@",responseObject["DailyCompensationSat"].stringValue)

                    dailyCompensationValue = String(format:"%@\n%@\n%@\n%@\n%@\n%@\n%@\n",sunComp,monComp,tueComp,wedComp,thuComp,friComp,satComp)

                }
                if RetireeReceivingPensionYesno.count > 0  {
                    if RetireeReceivingPensionYesno == "1"{
                        isRetireeReceivingPensionYesBtnTapped = true
                        isRetireeReceivingPensionNoBtnTapped = false
                    }else if RetireeReceivingPensionYesno == "0"{
                        isRetireeReceivingPensionYesBtnTapped = false
                        isRetireeReceivingPensionNoBtnTapped = true
                    }
                }
                if ConsultantJoinPrior1973Yesno.count > 0 {
                    
                    if ConsultantJoinPrior1973Yesno == "1"{
                        isConsultantJoinPrior1973YesBtnTapped = true
                        isConsultantJoinPrior1973NoBtnTapped = false
                        
                    }else if ConsultantJoinPrior1973Yesno == "0"{
                        isConsultantJoinPrior1973YesBtnTapped = false
                        isConsultantJoinPrior1973NoBtnTapped = true
                    }
                }
                
                if Over65Yesno.count > 0{
                    if Over65Yesno == "1"{
                        isOver65YesBtnTapped = true
                        isOver65NoBtnTapped = false
                    }else if Over65Yesno == "0"{
                        isOver65YesBtnTapped = false
                        isOver65NoBtnTapped = true
                    }
                }
                

                self.tableView.reloadData()
                
            }else{
                
                var message = responseObject["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
    }
    
    func ValidateWaiverForm(){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            //            JustHUD.shared.showInView(view: view)
            self.showLoading()
           var RetireeReceivingPensionYesno = false
           var RetirementSystem = false
            var OverAge = false
            
            if isOver65YesBtnTapped == true{
                OverAge = true
            }
            if isRetireeReceivingPensionYesBtnTapped == true {
                RetireeReceivingPensionYesno = true
            }
            if isConsultantJoinPrior1973YesBtnTapped == true{
                RetirementSystem = true
            }
            let Param = ["WaiverText":justification,
                         "RetireeReceivingPensionYesno": RetireeReceivingPensionYesno,
                         "RetirementSystem": RetirementSystem,
                         "OverAge": OverAge] as [String : Any]
            
            print(Param)
            
            let urlString = RestAPI.BaseUrl+RestAPI.DOE_Validate_Waiver_URL
            
            RestAPI.postRequestWithToken(urlString: urlString, params: Param, callback: getValidateWaiverFormResponse(response:))
            
        }else{
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    func getValidateWaiverFormResponse(response:AnyObject)->()
    {
 
    self.hideLoading()
        print(response)
        if response is String{
            //            lblNoData.isHidden = false
            var message = response as! String
            if message.count == 0 {
                message = Error_Message
            }
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                
                let RetireeReceivingPensionYesno = object["RetireeReceivingPensionYesno"].stringValue
                let RetirementSystem = object["RetirementSystem"].stringValue
                let OverAge = object["OverAge"].stringValue
                
                crntYrCompIncludingEarning = object["FormatYtdCompensationCurrYear"].stringValue
                crntYrCompl = object["FormatCurrYearCompensationOver30k"].stringValue
                let DoeWaiverModel = ["OverAge": OverAge == "True" ? "1" : "0",
                                      "RetirementSystem":RetirementSystem == "True" ? "1" : "0",
                                      "RetireeReceivingPensionYesno":RetireeReceivingPensionYesno == "True" ? "1" : "0",
                                      "WaiverText":object["WaiverText"].stringValue,
                                      "DailyCompensation":dailyCompensationValue,
                                      "FormatYtdCompensationCurrYear":crntYrCompIncludingEarning,
                                      "FormatCurrYearCompensationOver30k":crntYrCompl]
 
                UserDefaults.standard.setValue(DoeWaiverModel, forKey: "DoeWaiverModel")
                UserDefaults.standard.synchronize()
                
                self.pushToDetailsPage()
 //push to summary page
                
                
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
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
        } else{
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
