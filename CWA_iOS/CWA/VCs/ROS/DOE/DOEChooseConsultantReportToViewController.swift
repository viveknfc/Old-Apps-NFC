//
//  DOEChooseConsultantReportToViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 02/04/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON

class DOEChooseConsultantReportToViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,DOE_AddEditApplicantFromListDelegate {
    func DOE_AddEditApplicant(_ reportToPerson: DOEReportTo, prefixName: String) {
        
        //        dataArray = [PersonToReportToDict,PrimaryReasonToApproveTSDict,AltPersonToApproveTSDict,FAMISPOCertifierDict,TSApproverSupervisorDict,ButtonsDict]
        var index = -1
        isAddEditApplicantDelegate = true
        if prefixName == PersonToReportTo_Prefix {
            SelectedPersonToReportTo = reportToPerson
            isValidPersonToReportTo = true
            //            PersonToReportToArray.add(SelectedPersonToReportTo)
            index = 0
        }else if prefixName == PrimaryReasonToApproveTS_Prefix {
            SelectedPrimaryReasonToApproveTS = reportToPerson
            isValidPrimaryReasonToApproveTS = true
            //            PrimaryReasonToApproveTSArray.add(SelectedPrimaryReasonToApproveTS)
            index = 1
        }else if prefixName == AltPersonToApproveTS_Prefix {
            SelectedAltPersonToApproveTS = reportToPerson
            isValidAltPersonToApproveTS = true
            //            AltPersonToApproveTSArray.add(SelectedAltPersonToApproveTS)
            
            index = 2
        }else if prefixName == FAMISPOCertifier_Prefix {
            SelectedFAMISPOCertifier = reportToPerson
            isValidFAMISPOCertifier = true
            //            FAMISPOCertifierArray.add(SelectedFAMISPOCertifier)
            
            index = 3
        }else if prefixName == TSApproverSupervisor_Prefix {
            SelectedTSApproverSupervisor = reportToPerson
            isValidTSApproverSupervisor = true
            //            TSApproverSupervisorArray.add(SelectedTSApproverSupervisor)
            
            index = 4
        }
        self.getExistingConsultantsListData()
        
        self.updateAddressWithObject(reportToObj: reportToPerson, index: index)
        self.mainTableView.reloadData()
    }
    var isAddEditApplicantDelegate = false
    
    let PersonToReportTo_Prefix = "report_to"
    let PrimaryReasonToApproveTS_Prefix = "approve_timeslip"
    let AltPersonToApproveTS_Prefix = "alt_approve_timeslip"
    let FAMISPOCertifier_Prefix = "certify_hours"
    let TSApproverSupervisor_Prefix = "ts_approver_supervisor"
    
    @IBOutlet var mainTableView: UITableView!
    var dropDownView = UIView()
    var  alertDropDownTableView = UITableView()
    
    let MaintableView_Tag = 101
    let PersonToReportToTxtFTag = "1001"
    let PrimaryReasonToApproveTSTxtFTag = "1002"
    let AltPersonToApproveTSTxtFTag = "1003"
    let FAMISPOCertifierTxtFTag = "1004"
    let TSApproverSupervisorTxtFTag = "1005"
    
    let PersonToReportToTblViewTag = "10001"
    let PrimaryReasonToApproveTSTblViewTag = "10002"
    let AltPersonToApproveTSTblViewTag = "10003"
    let FAMISPOCertifierTblViewTag = "10004"
    let TSApproverSupervisorTblViewTag = "10005"
    
    let PersonToReportTo_Cell_Index = 0
    let PrimaryReasonToApproveTS_Cell_Index = 1
    let AltPersonToApproveTS_Cell_Index = 2
    let FAMISPOCertifier_Cell_Index = 3
    let TSApproverSupervisor_Cell_Index = 4
    
    var isValidPersonToReportTo = true
    var isValidPrimaryReasonToApproveTS = true
    var isValidAltPersonToApproveTS = true
    var isValidFAMISPOCertifier = true
    var isValidTSApproverSupervisor = true
    
    
    var isFromSummaryPage = false
    
    var dataArray = NSMutableArray()
    
    var PersonToReportToArray = NSMutableArray()
    var PrimaryReasonToApproveTSArray = NSMutableArray()
    var AltPersonToApproveTSArray = NSMutableArray()
    var FAMISPOCertifierArray = NSMutableArray()
    var TSApproverSupervisorArray = NSMutableArray()
    var StateArray = NSMutableArray()
    var SelectedPersonToReportTo = DOEReportTo.init(Value: "", Text: "",ContAddr: "",State: "",Phone: "",City: "",Zip: "",AddETo:"",isSelected: "0",ClientId: "",ContactId:"")
    var SelectedPrimaryReasonToApproveTS = DOEReportTo.init(Value: "", Text: "",ContAddr: "",State: "",Phone: "",City: "",Zip: "",AddETo:"",isSelected: "0",ClientId: "",ContactId:"")
    var SelectedAltPersonToApproveTS = DOEReportTo.init(Value: "", Text: "",ContAddr: "",State: "",Phone: "",City: "",Zip: "",AddETo:"",isSelected: "0",ClientId: "",ContactId:"")
    var SelectedFAMISPOCertifier = DOEReportTo.init(Value: "", Text: "",ContAddr: "",State: "",Phone: "",City: "",Zip: "",AddETo:"",isSelected: "0",ClientId: "",ContactId:"")
    var SelectedTSApproverSupervisor = DOEReportTo.init(Value: "", Text: "",ContAddr: "",State: "",Phone: "",City: "",Zip: "",AddETo:"",isSelected: "0",ClientId: "",ContactId:"")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.mainTableView.tableFooterView = UIView()
        self.refreshData()
        self.getExistingConsultantsListData()
        //
        
    }
    
    @objc func methodOfReceivedNotification(){
        
        //        var info = notification.userInfo!
        isFromSummaryPage = true
        self.mainTableView.reloadData()
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
    func pushToDetailsPage(){
        var isControllerExists = false
        var vc = UIViewController()
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOEOrderDetailsViewController {
                    print("Your controller exist")
                    vc = viewController
                    isControllerExists = true
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
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    func refreshData(){
        
        isValidPersonToReportTo = true
        isValidPrimaryReasonToApproveTS = true
        isValidAltPersonToApproveTS = true
        isValidFAMISPOCertifier = true
        isValidTSApproverSupervisor = true
        
        let PersonToReportToDict = ["Header":"Person To Report To","Name":"","Value":"","TextFieldTag":PersonToReportToTxtFTag,"TableViewTag":PersonToReportToTblViewTag]
        let PrimaryReasonToApproveTSDict = ["Header":"Primary Person To Approve Timeslip","Name":"","Value":"","TextFieldTag":PrimaryReasonToApproveTSTxtFTag,"TableViewTag":PrimaryReasonToApproveTSTblViewTag]
        let AltPersonToApproveTSDict = ["Header":"Alternate Person To Approve Timeslip","Name":"","Value":"","SubHeader":"Note: This is the person who will approve timeslips in the absence of the primary approver listed above.","TextFieldTag":AltPersonToApproveTSTxtFTag,"TableViewTag":AltPersonToApproveTSTblViewTag]
        let FAMISPOCertifierDict = ["Header":"FAMIS PO Certifier","Name":"","Value":"","TextFieldTag":FAMISPOCertifierTxtFTag,"TableViewTag":FAMISPOCertifierTblViewTag]
        let TSApproverSupervisorDict = ["Header":"Timeslip Approver Supervisor","Name":"","Value":"","TextFieldTag":TSApproverSupervisorTxtFTag,"TableViewTag":TSApproverSupervisorTblViewTag]
        let ButtonsDict = ["Header":"Buttons"]
        
        dataArray = [PersonToReportToDict,PrimaryReasonToApproveTSDict,AltPersonToApproveTSDict,FAMISPOCertifierDict,TSApproverSupervisorDict,ButtonsDict]
        self.mainTableView.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        
        //        self.titlelbl.text = "Rapid Order System"
        //        NotificationCenter.default.removeObserver(self, name: Notification.Name("PushToDOEOrderPageFromDetails"), object: nil)
        //        if isFromSchoolProfToRecruit == true {
        self.titlelbl.text = "School Professionals to Recruit"
        
        //        }else{
        //            self.titlelbl.text = "Rapid Order System"
        //
        //        }
        if isFromSummaryPage == true{
            self.methodOfReceivedNotification()
        }else{
            isFromSummaryPage = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: UITableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == Int(PersonToReportToTblViewTag) {
            return PersonToReportToArray.count
        }else if tableView.tag == Int(PrimaryReasonToApproveTSTblViewTag) {
            return PrimaryReasonToApproveTSArray.count
        }else if tableView.tag == Int(AltPersonToApproveTSTblViewTag) {
            return AltPersonToApproveTSArray.count
        }else if tableView.tag == Int(FAMISPOCertifierTblViewTag) {
            return FAMISPOCertifierArray.count
        }else if tableView.tag == Int(TSApproverSupervisorTblViewTag){
            return TSApproverSupervisorArray.count
        }
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == Int(PersonToReportToTblViewTag) ||
            tableView.tag == Int(PrimaryReasonToApproveTSTblViewTag) ||
            tableView.tag == Int(AltPersonToApproveTSTblViewTag) ||
            tableView.tag == Int(FAMISPOCertifierTblViewTag) ||
            tableView.tag == Int(TSApproverSupervisorTblViewTag){
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?
            if !(cell != nil) {
                cell = UITableViewCell(style:.subtitle, reuseIdentifier: "CELL")
            }
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            
            
            if tableView.tag == Int(PersonToReportToTblViewTag){
                let obj = PersonToReportToArray[indexPath.row]
                
                let  o:DOEReportTo = obj as! DOEReportTo
                cell?.textLabel?.text = o.Text
                if o.isSelected == "1"{
                    cell?.accessoryType = .checkmark
                }else{
                    cell?.accessoryType = .none
                }
                
            }else if tableView.tag == Int(PrimaryReasonToApproveTSTblViewTag){
                let obj = PrimaryReasonToApproveTSArray[indexPath.row]
                
                let  o:DOEReportTo = obj as! DOEReportTo
                cell?.textLabel?.text = o.Text
                if o.isSelected == "1"{
                    cell?.accessoryType = .checkmark
                }else{
                    cell?.accessoryType = .none
                }
                
            }else if tableView.tag == Int(AltPersonToApproveTSTblViewTag){
                let obj = AltPersonToApproveTSArray[indexPath.row]
                
                let  o:DOEReportTo = obj as! DOEReportTo
                cell?.textLabel?.text = o.Text
                if o.isSelected == "1"{
                    cell?.accessoryType = .checkmark
                }else{
                    cell?.accessoryType = .none
                }
                
            }else if tableView.tag == Int(FAMISPOCertifierTblViewTag){
                let obj = FAMISPOCertifierArray[indexPath.row]
                
                let  o:DOEReportTo = obj as! DOEReportTo
                cell?.textLabel?.text = o.Text
                if o.isSelected == "1"{
                    cell?.accessoryType = .checkmark
                }else{
                    cell?.accessoryType = .none
                }
                
            }else if tableView.tag == Int(TSApproverSupervisorTblViewTag){
                let obj = TSApproverSupervisorArray[indexPath.row]
                
                let  o:DOEReportTo = obj as! DOEReportTo
                cell?.textLabel?.text = o.Text
                if o.isSelected == "1"{
                    cell?.accessoryType = .checkmark
                }else{
                    cell?.accessoryType = .none
                }
                
            }
            return cell!
            
        }
        
        if indexPath.row == dataArray.count - 1{
            
            return self.ButtonTableCell(indexPath: indexPath as NSIndexPath)
        }
        return self.TextFieldCell(indexPath: indexPath as NSIndexPath)
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == MaintableView_Tag{
            
            if indexPath.row == dataArray.count - 1{
                return 60
            }
            let dict = dataArray[indexPath.row] as! NSDictionary
            
            let Value = dict["Value"] as? String
            
            
            if dict["SubHeader"] != nil{
                let SubHeader = dict["SubHeader"] as? String
                let height =  (SubHeader?.heightWithConstrainedWidth(width: UIScreen.main.bounds.size.width - 20, font: UIFont.boldSystemFont(ofSize: CGFloat(13))))! + CGFloat(20) //self.sizeOfString(string: message!, constrainedToHeight: Double.greatestFiniteMagnitude).height + 10
                
                if Value?.count == 0{
                    return 115
                }
                return 115 + height + 20
            }else{
                if Value?.count == 0{
                    return 90
                }
                let height =  (Value?.heightWithConstrainedWidth(width: UIScreen.main.bounds.size.width - 20, font: UIFont.boldSystemFont(ofSize: CGFloat(13))))! + CGFloat(20) //self.sizeOfString(string: message!, constrainedToHeight: Double.greatestFiniteMagnitude).height + 10
                
                return 90 + height
            }
            
            
        }
        return 50
    }
    func updateAddressWithObject(reportToObj: DOEReportTo,index:Int){
        if dataArray.count > index{
            let address = String(format:"%@\n%@,%@ %@\n%@\n%@",reportToObj.ContAddr!,reportToObj.City!,reportToObj.State!,reportToObj.Zip!,reportToObj.Phone!,reportToObj.AddETo!)
            let di = dataArray[index] as! NSDictionary
            let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: di)
            mutableDictObj["Value"] = address
            mutableDictObj["Name"] = reportToObj.Text
            dataArray.replaceObject(at: index, with: mutableDictObj)
        }
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        
        if tableView.tag == Int(PersonToReportToTblViewTag){
            let obj = PersonToReportToArray[indexPath.row]
            let  o:DOEReportTo = obj as! DOEReportTo
            SelectedPersonToReportTo = o
            for obj in PersonToReportToArray{
                let reportObj:DOEReportTo = obj as! DOEReportTo
                reportObj.isSelected = "0"
            }
            isValidPersonToReportTo = true
            SelectedPersonToReportTo.isSelected = "1"
            self.updateAddressWithObject(reportToObj: SelectedPersonToReportTo, index: PersonToReportTo_Cell_Index)
            //            let address = String(format:"%@\n%@,%@ %@\n%@\n%@",SelectedPersonToReportTo.ContAddr!,SelectedPersonToReportTo.City!,SelectedPersonToReportTo.State!,SelectedPersonToReportTo.Zip!,SelectedPersonToReportTo.Phone!,SelectedPersonToReportTo.AddETo!)
            //            let di = dataArray[PersonToReportTo_Cell_Index] as! NSDictionary
            //            let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: di)
            //            mutableDictObj["Value"] = address
            //            mutableDictObj["Name"] = SelectedPersonToReportTo.Text
            //            dataArray.replaceObject(at: PersonToReportTo_Cell_Index, with: mutableDictObj)
            
        }else if tableView.tag == Int(PrimaryReasonToApproveTSTblViewTag){
            let obj = PrimaryReasonToApproveTSArray[indexPath.row]
            let  o:DOEReportTo = obj as! DOEReportTo
            SelectedPrimaryReasonToApproveTS = o
            for obj in PrimaryReasonToApproveTSArray{
                let reportObj:DOEReportTo = obj as! DOEReportTo
                reportObj.isSelected = "0"
            }
            isValidPrimaryReasonToApproveTS = true
            SelectedPrimaryReasonToApproveTS.isSelected = "1"
            self.updateAddressWithObject(reportToObj: SelectedPrimaryReasonToApproveTS, index: PrimaryReasonToApproveTS_Cell_Index)
            //
            //            let address = String(format:"%@\n%@,%@ %@\n%@\n%@",SelectedPrimaryReasonToApproveTS.ContAddr!,SelectedPrimaryReasonToApproveTS.City!,SelectedPrimaryReasonToApproveTS.State!,SelectedPrimaryReasonToApproveTS.Zip!,SelectedPrimaryReasonToApproveTS.Phone!,SelectedPrimaryReasonToApproveTS.AddETo!)
            //
            //            let di = dataArray[PrimaryReasonToApproveTS_Cell_Index] as! NSDictionary
            //            let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: di)
            //            mutableDictObj["Value"] = address
            //            mutableDictObj["Name"] = SelectedPrimaryReasonToApproveTS.Text
            //            dataArray.replaceObject(at: PrimaryReasonToApproveTS_Cell_Index, with: mutableDictObj)
            
            
        }else if tableView.tag == Int(AltPersonToApproveTSTblViewTag){
            let obj = AltPersonToApproveTSArray[indexPath.row]
            
            let  o:DOEReportTo = obj as! DOEReportTo
            isValidAltPersonToApproveTS = true
            
            SelectedAltPersonToApproveTS = o
            for obj in AltPersonToApproveTSArray{
                let reportObj:DOEReportTo = obj as! DOEReportTo
                reportObj.isSelected = "0"
            }
            SelectedAltPersonToApproveTS.isSelected = "1"
            self.updateAddressWithObject(reportToObj: SelectedAltPersonToApproveTS, index: AltPersonToApproveTS_Cell_Index)
            //
            //            let address = String(format:"%@\n%@,%@ %@\n%@\n%@",SelectedAltPersonToApproveTS.ContAddr!,SelectedAltPersonToApproveTS.City!,SelectedAltPersonToApproveTS.State!,SelectedAltPersonToApproveTS.Zip!,SelectedAltPersonToApproveTS.Phone!,SelectedAltPersonToApproveTS.AddETo!)
            //
            //            let di = dataArray[AltPersonToApproveTS_Cell_Index] as! NSDictionary
            //            let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: di)
            //            mutableDictObj["Value"] = address
            //            mutableDictObj["Name"] = SelectedAltPersonToApproveTS.Text
            //            dataArray.replaceObject(at: AltPersonToApproveTS_Cell_Index, with: mutableDictObj)
            
        }else if tableView.tag == Int(FAMISPOCertifierTblViewTag){
            let obj = FAMISPOCertifierArray[indexPath.row]
            
            let  o:DOEReportTo = obj as! DOEReportTo
            isValidFAMISPOCertifier = true
            
            SelectedFAMISPOCertifier = o
            for obj in FAMISPOCertifierArray{
                let reportObj:DOEReportTo = obj as! DOEReportTo
                reportObj.isSelected = "0"
            }
            SelectedFAMISPOCertifier.isSelected = "1"
            self.updateAddressWithObject(reportToObj: SelectedFAMISPOCertifier, index: FAMISPOCertifier_Cell_Index)
            
            //             let address = String(format:"%@\n%@,%@ %@\n%@\n%@",SelectedFAMISPOCertifier.ContAddr!,SelectedFAMISPOCertifier.City!,SelectedFAMISPOCertifier.State!,SelectedFAMISPOCertifier.Zip!,SelectedFAMISPOCertifier.Phone!,SelectedFAMISPOCertifier.AddETo!)
            //
            //            let di = dataArray[FAMISPOCertifier_Cell_Index] as! NSDictionary
            //            let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: di)
            //            mutableDictObj["Value"] = address
            //            mutableDictObj["Name"] = SelectedFAMISPOCertifier.Text
            //
            //            dataArray.replaceObject(at: FAMISPOCertifier_Cell_Index, with: mutableDictObj)
            
            
        }else if tableView.tag == Int(TSApproverSupervisorTblViewTag){
            let obj = TSApproverSupervisorArray[indexPath.row]
            
            let  o:DOEReportTo = obj as! DOEReportTo
            isValidTSApproverSupervisor = true
            
            SelectedTSApproverSupervisor = o
            for obj in TSApproverSupervisorArray{
                let reportObj:DOEReportTo = obj as! DOEReportTo
                reportObj.isSelected = "0"
            }
            SelectedTSApproverSupervisor.isSelected = "1"
            
            self.updateAddressWithObject(reportToObj: SelectedTSApproverSupervisor, index: TSApproverSupervisor_Cell_Index)
            
            //            let address = String(format:"%@\n%@,%@ %@\n%@\n%@",SelectedTSApproverSupervisor.ContAddr!,SelectedTSApproverSupervisor.City!,SelectedTSApproverSupervisor.State!,SelectedTSApproverSupervisor.Zip!,SelectedTSApproverSupervisor.Phone!,SelectedTSApproverSupervisor.AddETo!)
            //
            //            let di = dataArray[TSApproverSupervisor_Cell_Index] as! NSDictionary
            //            let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: di)
            //            mutableDictObj["Value"] = address
            //            mutableDictObj["Name"] = SelectedTSApproverSupervisor.Text
            //
            //            dataArray.replaceObject(at: TSApproverSupervisor_Cell_Index, with: mutableDictObj)
            
        }
        self.mainTableView.reloadData()
        self.removeDropDown()
        
    }
    
    //MARK: Custom Cell
    //DOEHeaderTableViewCell
    
    func ButtonTableCell(indexPath: NSIndexPath ) -> ButtonTableViewCell {
        
        let cell:ButtonTableViewCell = mainTableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCellidentifier") as! ButtonTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.nextButton.removeTarget(self, action:#selector(self.nextButtonTapped), for: .touchUpInside)
        cell.backButton.removeTarget(self, action:#selector(self.backButtonTapped), for: .touchUpInside)
        cell.undoButton.removeTarget(self, action:#selector(self.undoButtonTapped), for: .touchUpInside)
        
        
        cell.nextButton.addTarget(self, action:#selector(self.nextButtonTapped), for: .touchUpInside)
        cell.backButton.addTarget(self, action:#selector(self.backButtonTapped), for: .touchUpInside)
        cell.undoButton.addTarget(self, action:#selector(self.undoButtonTapped), for: .touchUpInside)
        
        if isFromSummaryPage == true {
            cell.returnToConfirmOrderButton.removeTarget(self, action:#selector(self.returnToConfirmOrderButtonTapped), for: .touchUpInside)
            cell.returnToConfirmOrderButton.addTarget(self, action:#selector(self.returnToConfirmOrderButtonTapped), for: .touchUpInside)
            cell.nextButton.isHidden = true
            cell.backButton.isHidden = true
            cell.undoButton.isHidden = true
            cell.returnToConfirmOrderButton.isHidden = false
        }else{
            cell.returnToConfirmOrderButton.isHidden = true
            cell.undoButton.isHidden = false
            cell.nextButton.isHidden = false
            cell.backButton.isHidden = false
        }
        return cell
        
    }
    func TextFieldCell( indexPath: NSIndexPath ) -> TextFieldTableViewCell {
        
        let cell:TextFieldTableViewCell = mainTableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCellIdentifier" ) as! TextFieldTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        
        cell.btnBGView.layer.borderWidth = 1
        cell.btnBGView.layer.borderColor = borderColor.cgColor
        
        let dict = dataArray[indexPath.row] as! NSDictionary
        let Value = dict["Value"] as? String
        let Name = dict["Name"] as? String
        let header = dict["Header"] as? String
        
        cell.lblHeader.text = dict["Header"] as? String
        
        if dict["SubHeader"] != nil{
            cell.lblNote.text = dict["SubHeader"]  as? String
            cell.lblNote.isHidden = false
            cell.bgViewTopConstraint.constant = 32
        }else{
            cell.lblNote.isHidden = true
            cell.bgViewTopConstraint.constant = 5
        }
        if Value?.count == 0{
            cell.editButton.isHidden = true
            cell.lblFileName.isHidden = true
            cell.addNewBtnTrailingConstraint.constant = 5
            cell.lblHeaderTrailingConstraint.constant = 75
        }else{
            cell.editButton.isHidden = false
            cell.lblFileName.isHidden = false
            cell.addNewBtnTrailingConstraint.constant = 75
            cell.lblFileName.text = Value
            cell.lblHeaderTrailingConstraint.constant = 148
        }
        cell.layoutIfNeeded()
        cell.entryTextField.text = Name
        cell.entryTextField.delegate = self
        cell.btnBGView.layer.borderColor = borderColor.cgColor
        cell.btnBGView.layer.borderWidth = 1
        let textFTag = dict["TextFieldTag"]  as? String
        cell.entryTextField.tag = Int(textFTag!)!
        self.addRightImageToTextField(textField: cell.entryTextField, imageName: "expand-arrow")
        
        //8249132351
        
        if header == "Person To Report To" {
            if isValidPersonToReportTo == false{
                cell.btnBGView.layer.borderColor = UIColor.red.cgColor
            }
        }else  if header == "Primary Person To Approve Timeslip" {
            if isValidPrimaryReasonToApproveTS == false{
                cell.btnBGView.layer.borderColor = UIColor.red.cgColor
            }
        }else  if header == "Alternate Person To Approve Timeslip" {
            if isValidAltPersonToApproveTS == false{
                cell.btnBGView.layer.borderColor = UIColor.red.cgColor
            }
        }else  if header == "FAMIS PO Certifier" {
            if isValidFAMISPOCertifier == false{
                cell.btnBGView.layer.borderColor = UIColor.red.cgColor
            }
        }else  if header == "Timeslip Approver Supervisor" {
            if isValidTSApproverSupervisor == false{
                cell.btnBGView.layer.borderColor = UIColor.red.cgColor
            }
        }
        cell.addButton.removeTarget(self, action: #selector(self.AddApplicantBtnTapped), for: .touchUpInside)
        cell.editButton.removeTarget(self, action: #selector(self.EditApplicantBtnTapped), for: .touchUpInside)
        
        cell.addButton.addTarget(self, action: #selector(self.AddApplicantBtnTapped), for: .touchUpInside)
        cell.editButton.addTarget(self, action: #selector(self.EditApplicantBtnTapped), for: .touchUpInside)
        
        return cell
    }
    @objc func AddApplicantBtnTapped(sender:UIButton){
        
        let senderPosition  = sender.convert(CGPoint.zero, to: self.mainTableView)
        
        let indexPath =  self.mainTableView.indexPathForRow(at:senderPosition)
        
        self.pushToAddReportToPage(isForEdit: false, forIndexPath: indexPath! as NSIndexPath)
    }
    @objc func EditApplicantBtnTapped(sender:UIButton){
        
        let senderPosition  = sender.convert(CGPoint.zero, to: self.mainTableView)
        
        let indexPath =  self.mainTableView.indexPathForRow(at:senderPosition)
        
        self.pushToAddReportToPage(isForEdit: true, forIndexPath: indexPath! as NSIndexPath)
        
    }
    
    @objc func nextButtonTapped(sender:UIButton){
        self.validationForSchdulePage()
    }
    func validationForSchdulePage(){
        
        if (SelectedPersonToReportTo.Text?.count)! > 0{
            isValidPersonToReportTo = true
        }else{
            isValidPersonToReportTo = false
            
        }
        if (SelectedPrimaryReasonToApproveTS.Text?.count)! > 0{
            isValidPrimaryReasonToApproveTS = true
        }else{
            isValidPrimaryReasonToApproveTS = false
            
        }
        if (SelectedAltPersonToApproveTS.Text?.count)! > 0{
            isValidAltPersonToApproveTS = true
        }else{
            isValidAltPersonToApproveTS = false
            
        }
        if (SelectedFAMISPOCertifier.Text?.count)! > 0{
            isValidFAMISPOCertifier = true
        }else{
            isValidFAMISPOCertifier = false
            
        }
        if (SelectedTSApproverSupervisor.Text?.count)! > 0{
            isValidTSApproverSupervisor = true
        }else{
            isValidTSApproverSupervisor = false
            
        }
        self.mainTableView.reloadData()
        
        if isValidPersonToReportTo && isValidPrimaryReasonToApproveTS && isValidAltPersonToApproveTS && isValidFAMISPOCertifier && isValidTSApproverSupervisor {
            
            let userDefaults = UserDefaults.standard
            let TsApproverSupervisorEncodedData: Data = NSKeyedArchiver.archivedData(withRootObject: SelectedTSApproverSupervisor)
            let ApproveTimeslipEncodedData: Data = NSKeyedArchiver.archivedData(withRootObject: SelectedPrimaryReasonToApproveTS)
            let AltApproveTimeslipEncodedData: Data = NSKeyedArchiver.archivedData(withRootObject: SelectedAltPersonToApproveTS)
            let CertifyHoursEncodedData: Data = NSKeyedArchiver.archivedData(withRootObject: SelectedFAMISPOCertifier)
            let PersonToReportEncodedData: Data = NSKeyedArchiver.archivedData(withRootObject: SelectedPersonToReportTo)
            userDefaults.set(ApproveTimeslipEncodedData, forKey: "ApproveTimeslip")
            userDefaults.set(AltApproveTimeslipEncodedData, forKey: "AltApproveTimeslip")
            userDefaults.set(TsApproverSupervisorEncodedData, forKey: "TsApproverSupervisor")
            userDefaults.set(PersonToReportEncodedData, forKey: "PersonToReport")
            userDefaults.set(CertifyHoursEncodedData, forKey: "CertifyHours")
            
            userDefaults.synchronize()

            self.ValidateRecruitData()

        }
    }
    @objc func backButtonTapped(sender:UIButton){
        
        //pop to DOEConsultantSourcedViewController
                self.navigationController?.popViewController(animated: true)
//        self.pushToDOEConsultantSourcedViewController()
    }
    @objc func undoButtonTapped(sender:UIButton){
        
        self.refreshData()
    }
    @objc func returnToConfirmOrderButtonTapped(sender:UIButton){
        
        
        self.validationForSchdulePage()
        
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
        self.mainTableView.reloadData()
        
    }
    // UIGestureRecognizerDelegate method
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if (touch.view?.isDescendant(of: self.alertDropDownTableView))! || (touch.view?.isDescendant(of:  self.mainTableView))!  {
            return false
        }
        return true
    }
    func removeDropDown(){
        dropDownView.removeFromSuperview()
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField){
        
        textField.resignFirstResponder()
        
        let senderPosition  = textField.convert(CGPoint.zero, to: self.mainTableView)
        
        let indexPath =  self.mainTableView.indexPathForRow(at:senderPosition)
        let placeholder = "Please Select"
        
        let dict = dataArray[(indexPath?.row)!] as! NSDictionary
        let  Tag = dict["TableViewTag"]  as? String
        let tbleViewTag = Int(Tag!)
        self.showDropDownTableViewWithTag(placeHolder: placeholder, tag: tbleViewTag!)
        
    }
    
    //MARK: Server Call
    
    func ValidateRecruitData() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            
            let defaults = UserDefaults.standard
            
            let ApproveTimeslipDict = ["ContactId":SelectedPrimaryReasonToApproveTS.ContactId]
            let AltApproveTimeslipDict = ["ContactId":SelectedAltPersonToApproveTS.ContactId]
            let TsApproverSupervisorDict = ["ContactId":SelectedTSApproverSupervisor.ContactId]
            let PersonToReportDict = ["ContactId":SelectedPersonToReportTo.ContactId]
            let CertifyHoursDict = ["ContactId":SelectedFAMISPOCertifier.ContactId]

            let Param   = [
                "ApproveTimeslip":ApproveTimeslipDict,
                "AltApproveTimeslip":AltApproveTimeslipDict,
                "TsApproverSupervisor":TsApproverSupervisorDict,
                "PersonToReport":PersonToReportDict,
                "CertifyHours":CertifyHoursDict
                ] as [String : Any]
            
            print(Param)
            
            let urlString = RestAPI.BaseUrl+RestAPI.DOE_Validate_Recruit_URL
            
            RestAPI.postRequestWithToken(urlString: urlString, params: Param, callback: getValidateResponse(response:))
            
//            RestAPI.getDOEChooseReportToServerCall(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
        }else{
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
    }
    
    func getExistingConsultantsListData() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            
            let defaults = UserDefaults.standard
            
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            let ClientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            
            let params :[String:String] = ["ContactId":ContactId,"ClientID":ClientID]
            
            print(params)
            
            RestAPI.getDOEChooseReportToServerCall(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
        }else{
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
    }
    func getValidateResponse(response:AnyObject)->()
    {
        print(response)
        JustHUD.shared.hide()
        if response is String{
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                if isFromSummaryPage == true && UserDefaults.standard.object(forKey: "DoeScheduleModel") != nil{
                    isFromSummaryPage = false
                    self.pushToDetailsPage()
                }else{
                    self.pushToSchdulePage()
                }

            }else{
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
            
        }
    }
    func getResponse(response:AnyObject)->()
    {
        print(response)
        JustHUD.shared.hide()
        if response is String{
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                let PersonToReportToList = object["ClientContactsList"].array
                let PrimaryReasonToApproveTSList = object["ClientContactsList"].array
                let AltPersonToApproveTSList = object["ClientContactsList"].array
                let FAMISPOCertifierList = object["ClientContactsList"].array
                let TSApproverSupervisorList = object["ClientContactsList"].array
                let stateList = object["StatesList"].array
                
                for dict in stateList!{
                    let stateObj =  State.init(StateId: dict["StateId"].stringValue, StateName: dict["StateName"].stringValue, StateCode: dict["StateCode"].stringValue,isSelected: "0")
                    StateArray.add(stateObj)
                }
                let userDefaults = UserDefaults.standard
                if userDefaults.object(forKey: "TsApproverSupervisor") != nil{
                    let decoded  = userDefaults.object(forKey: "TsApproverSupervisor") as! Data
                    let decodedApplicant = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! DOEReportTo
                    if SelectedTSApproverSupervisor != nil{
                        if  SelectedTSApproverSupervisor.ContactId?.count  == 0{
                            SelectedTSApproverSupervisor = decodedApplicant
                            
                        }
                    }else{
                        SelectedTSApproverSupervisor = decodedApplicant
                        
                    }
                    
                }
                if userDefaults.object(forKey: "AltApproveTimeslip") != nil{
                    let decoded  = userDefaults.object(forKey: "AltApproveTimeslip") as! Data
                    let decodedApplicant = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! DOEReportTo
                    if SelectedAltPersonToApproveTS != nil{
                        if  SelectedAltPersonToApproveTS.ContactId?.count == 0{
                            
                            SelectedAltPersonToApproveTS = decodedApplicant
                            
                        }
                        
                    }else{
                        SelectedAltPersonToApproveTS = decodedApplicant
                        
                    }
                }
                if userDefaults.object(forKey: "ApproveTimeslip") != nil{
                    let decoded  = userDefaults.object(forKey: "ApproveTimeslip") as! Data
                    let decodedApplicant = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! DOEReportTo
                    if SelectedPrimaryReasonToApproveTS != nil{
                        if  SelectedPrimaryReasonToApproveTS.ContactId?.count == 0{
                            
                            SelectedPrimaryReasonToApproveTS = decodedApplicant
                            
                        }
                    }else{
                        SelectedPrimaryReasonToApproveTS = decodedApplicant
                        
                    }
                    
                }
                if userDefaults.object(forKey: "PersonToReport") != nil{
                    let decoded  = userDefaults.object(forKey: "PersonToReport") as! Data
                    let decodedApplicant = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! DOEReportTo
                    if SelectedPersonToReportTo != nil{
                        
                        if  SelectedPersonToReportTo.ContactId?.count == 0{
                            
                            
                            SelectedPersonToReportTo = decodedApplicant}
                    }else{
                        SelectedPersonToReportTo = decodedApplicant
                    }
                }
                if userDefaults.object(forKey: "CertifyHours") != nil{
                    let decoded  = userDefaults.object(forKey: "CertifyHours") as! Data
                    let decodedApplicant = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! DOEReportTo
                    if SelectedFAMISPOCertifier != nil{
                        if  SelectedFAMISPOCertifier.ContactId?.count == 0{
                            
                            SelectedFAMISPOCertifier = decodedApplicant
                            
                        }
                    }else{
                        SelectedFAMISPOCertifier = decodedApplicant
                        
                    }
                }
                
                
                for dict in PersonToReportToList! {
                    
                    let applicantObj = DOEReportTo.init(Value: dict["Value"].stringValue, Text: dict["Text"].stringValue,ContAddr: dict["ContAddr"].stringValue,State: dict["State"].stringValue,Phone: dict["Phone"].stringValue,City: dict["City"].stringValue,Zip: dict["Zip"].stringValue,AddETo: dict["AddETo"].stringValue,isSelected: "0",ClientId: dict["ClientId"].stringValue,ContactId:dict["Value"].stringValue)
                    //if selected  = "1",it will show  in cell
                    if SelectedPersonToReportTo.Text?.count == 0{
                        applicantObj.isSelected = "0"
                        
                    }else{
                        if isAddEditApplicantDelegate == true{
                            if SelectedPersonToReportTo.Text == applicantObj.Text{
                                applicantObj.isSelected = "1"
                                self.updateAddressWithObject(reportToObj: SelectedPersonToReportTo, index: PersonToReportTo_Cell_Index)
                                
                            }else{
                                applicantObj.isSelected = "0"
                            }
                        }else{
                            if SelectedPersonToReportTo.ContactId == applicantObj.ContactId{
                                applicantObj.isSelected = "1"
                                self.updateAddressWithObject(reportToObj: SelectedPersonToReportTo, index: PersonToReportTo_Cell_Index)
                                
                            }else{
                                applicantObj.isSelected = "0"
                            }
                            
                        }
                    }
                    PersonToReportToArray.add(applicantObj)
                }
                for dict in PrimaryReasonToApproveTSList! {
                    
                    let applicantObj = DOEReportTo.init(Value: dict["Value"].stringValue, Text: dict["Text"].stringValue,ContAddr: dict["ContAddr"].stringValue,State: dict["State"].stringValue,Phone: dict["Phone"].stringValue,City: dict["City"].stringValue,Zip: dict["Zip"].stringValue,AddETo: dict["AddETo"].stringValue,isSelected: "0",ClientId: dict["ClientId"].stringValue,ContactId:dict["Value"].stringValue)
                    if SelectedPrimaryReasonToApproveTS.Text?.count == 0{
                        applicantObj.isSelected = "0"
                        
                    }else{
                        if isAddEditApplicantDelegate == true{
                            if SelectedPrimaryReasonToApproveTS.Text == applicantObj.Text{
                                
                                applicantObj.isSelected = "1"
                                self.updateAddressWithObject(reportToObj: SelectedPrimaryReasonToApproveTS, index: PrimaryReasonToApproveTS_Cell_Index)
                            }else{
                                applicantObj.isSelected = "0"
                            }
                        }else{
                          
                            if SelectedPrimaryReasonToApproveTS.ContactId == applicantObj.ContactId{
                                
                                applicantObj.isSelected = "1"
                                self.updateAddressWithObject(reportToObj: SelectedPrimaryReasonToApproveTS, index: PrimaryReasonToApproveTS_Cell_Index)
                            }else{
                                applicantObj.isSelected = "0"
                            }
                        }
                       
                        //                        SelectedPrimaryReasonToApproveTS.ContactId = applicantObj.ContactId
                        
                    }
                    PrimaryReasonToApproveTSArray.add(applicantObj)
                }
                for dict in AltPersonToApproveTSList! {
                    
                    let applicantObj = DOEReportTo.init(Value: dict["Value"].stringValue, Text: dict["Text"].stringValue,ContAddr: dict["ContAddr"].stringValue,State: dict["State"].stringValue,Phone: dict["Phone"].stringValue,City: dict["City"].stringValue,Zip: dict["Zip"].stringValue,AddETo: dict["AddETo"].stringValue,isSelected: "0",ClientId: dict["ClientId"].stringValue,ContactId:dict["Value"].stringValue)
                    if SelectedAltPersonToApproveTS.Text?.count == 0{
                        applicantObj.isSelected = "0"
                        
                    }else{
                        if isAddEditApplicantDelegate == true{
                            if SelectedAltPersonToApproveTS.Text == applicantObj.Text{
                                
                                applicantObj.isSelected = "1"
                                self.updateAddressWithObject(reportToObj: SelectedAltPersonToApproveTS, index: AltPersonToApproveTS_Cell_Index)
                            }else{
                                applicantObj.isSelected = "0"
                            }

                        }else{
                            if SelectedAltPersonToApproveTS.ContactId == applicantObj.ContactId{
                                
                                applicantObj.isSelected = "1"
                                self.updateAddressWithObject(reportToObj: SelectedAltPersonToApproveTS, index: AltPersonToApproveTS_Cell_Index)
                            }else{
                                applicantObj.isSelected = "0"
                            }

                        }
                    }
                    AltPersonToApproveTSArray.add(applicantObj)
                }
                for dict in FAMISPOCertifierList! {
                    
                    let applicantObj = DOEReportTo.init(Value: dict["Value"].stringValue, Text: dict["Text"].stringValue,ContAddr: dict["ContAddr"].stringValue,State: dict["State"].stringValue,Phone: dict["Phone"].stringValue,City: dict["City"].stringValue,Zip: dict["Zip"].stringValue,AddETo: dict["AddETo"].stringValue,isSelected: "0",ClientId: dict["ClientId"].stringValue,ContactId:dict["Value"].stringValue)
                    if SelectedFAMISPOCertifier.Text?.count == 0{
                        applicantObj.isSelected = "0"
                        
                    }else{
                        if isAddEditApplicantDelegate == true{
                            if SelectedFAMISPOCertifier.Text == applicantObj.Text{
                                applicantObj.isSelected = "1"
                                self.updateAddressWithObject(reportToObj: SelectedFAMISPOCertifier, index: FAMISPOCertifier_Cell_Index)
                            }else{
                                applicantObj.isSelected = "0"
                            }

                        }else{
                            if SelectedFAMISPOCertifier.ContactId == applicantObj.ContactId{
                                applicantObj.isSelected = "1"
                                self.updateAddressWithObject(reportToObj: SelectedFAMISPOCertifier, index: FAMISPOCertifier_Cell_Index)
                            }else{
                                applicantObj.isSelected = "0"
                            }

                        }
                        
                    }
                    FAMISPOCertifierArray.add(applicantObj)
                }
                for dict in TSApproverSupervisorList! {
                    
                    let applicantObj = DOEReportTo.init(Value: dict["Value"].stringValue, Text: dict["Text"].stringValue,ContAddr: dict["ContAddr"].stringValue,State: dict["State"].stringValue,Phone: dict["Phone"].stringValue,City: dict["City"].stringValue,Zip: dict["Zip"].stringValue,AddETo: dict["AddETo"].stringValue,isSelected: "0",ClientId: dict["ClientId"].stringValue,ContactId:dict["Value"].stringValue)
                    if SelectedTSApproverSupervisor.Text?.count == 0{
                        applicantObj.isSelected = "0"
                        
                    }else{
                        if isAddEditApplicantDelegate == true{
                            if SelectedTSApproverSupervisor.Text == applicantObj.Text{
                                applicantObj.isSelected = "1"
                                self.updateAddressWithObject(reportToObj: SelectedTSApproverSupervisor, index: TSApproverSupervisor_Cell_Index)}
                            else{
                                applicantObj.isSelected = "0"
                            }
                        }else{
                            if SelectedTSApproverSupervisor.ContactId == applicantObj.ContactId{
                                applicantObj.isSelected = "1"
                                self.updateAddressWithObject(reportToObj: SelectedTSApproverSupervisor, index: TSApproverSupervisor_Cell_Index)}
                            else{
                                
                                applicantObj.isSelected = "0"
                            }
                        }
                        
                    }
                    isAddEditApplicantDelegate = false
                    TSApproverSupervisorArray.add(applicantObj)
                }
                
                
                self.mainTableView.reloadData()
                
            }else{
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
            
        }
    }
    
    func pushToSchdulePage(){
        var isControllerExists = false
        var vc = UIViewController()
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOESchduleViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    vc = viewController
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOESchduleSegue") as! DOESchduleViewController
            nextViewController.isFromSummaryPage = self.isFromSummaryPage
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }else{
            let nextVC:DOESchduleViewController = vc as! DOESchduleViewController
            nextVC.isFromSummaryPage = self.isFromSummaryPage
            self.navigationController?.popToViewController(nextVC, animated: true)
        }
        
    }
    func pushToDOEConsultantSourcedViewController(){
        var isControllerExists = false
        var ConsultantSourcedViewController = UIViewController()
        
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOEConsultantSourcedViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    ConsultantSourcedViewController = viewController
                    break
                }
            }
        }
        if isControllerExists == true{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOEConsultantSourcedSegue") as! DOEConsultantSourcedViewController
            nextViewController.isFromSummaryPage = self.isFromSummaryPage
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }else{
            let nextViewController:DOEConsultantSourcedViewController = ConsultantSourcedViewController as! DOEConsultantSourcedViewController
            nextViewController.isFromSummaryPage = self.isFromSummaryPage
            self.navigationController?.popToViewController(nextViewController, animated: true)
        }
        
    }
    func pushToAddReportToPage(isForEdit: Bool,forIndexPath: NSIndexPath){
        var isControllerExists = false
        
        var vc = UIViewController()
        
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is AddNewReportToViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    vc = viewController
                    break
                }
            }
        }
        let dict = dataArray[forIndexPath.row] as! NSDictionary
        let header = dict["Header"] as? String
        var prefix = ""
        
        if header == "Person To Report To" {
            prefix = PersonToReportTo_Prefix
        }else  if header == "Primary Person To Approve Timeslip" {
            prefix = PrimaryReasonToApproveTS_Prefix
        }else  if header == "Alternate Person To Approve Timeslip" {
            prefix = AltPersonToApproveTS_Prefix
        }else  if header == "FAMIS PO Certifier" {
            prefix = FAMISPOCertifier_Prefix
        }else  if header == "Timeslip Approver Supervisor" {
            prefix = TSApproverSupervisor_Prefix
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddNewReportToSegue") as! AddNewReportToViewController
            
            nextViewController.isForAddReportToOCC = false
            nextViewController.isForAddReportToOffice = false
            nextViewController.isForAddReportToLocationOffice = false
            nextViewController.isForAddApplicantDOE = false
            nextViewController.isForDOEAddClientApplicantFromChooseList = true
            nextViewController.DOE_Edit_State_List = StateArray
            nextViewController.DOE_Prefix = prefix
            
            
            
            if isForEdit == true{
                nextViewController.isForDOEEditClientApplicantFromChooseList = true
                nextViewController.isForDOEAddClientApplicantFromChooseList = false
                var Name = ""
                var Address = ""
                var City = ""
                var StateName = ""
                var Zip = ""
                var Phone = ""
                var Email = ""
                var ClientId = ""
                var ContactID = ""
                if header == "Person To Report To" {
                    Name = SelectedPersonToReportTo.Text!
                    Address = SelectedPersonToReportTo.ContAddr!
                    City = SelectedPersonToReportTo.City!
                    StateName = SelectedPersonToReportTo.State!
                    Zip = SelectedPersonToReportTo.Zip!
                    Phone = SelectedPersonToReportTo.Phone!
                    Email = SelectedPersonToReportTo.AddETo!
                    prefix = PersonToReportTo_Prefix
                    ContactID = SelectedPersonToReportTo.Value!
                    ClientId = SelectedPersonToReportTo.ClientId!
                }else  if header == "Primary Person To Approve Timeslip" {
                    Name = SelectedPrimaryReasonToApproveTS.Text!
                    Address = SelectedPrimaryReasonToApproveTS.ContAddr!
                    City = SelectedPrimaryReasonToApproveTS.City!
                    StateName = SelectedPrimaryReasonToApproveTS.State!
                    Zip = SelectedPrimaryReasonToApproveTS.Zip!
                    Phone = SelectedPrimaryReasonToApproveTS.Phone!
                    Email = SelectedPrimaryReasonToApproveTS.AddETo!
                    
                    prefix = PrimaryReasonToApproveTS_Prefix
                    ContactID = SelectedPrimaryReasonToApproveTS.Value!
                    ClientId = SelectedPrimaryReasonToApproveTS.ClientId!
                    
                }else  if header == "Alternate Person To Approve Timeslip" {
                    Name = SelectedAltPersonToApproveTS.Text!
                    Address = SelectedAltPersonToApproveTS.ContAddr!
                    City = SelectedAltPersonToApproveTS.City!
                    StateName = SelectedAltPersonToApproveTS.State!
                    Zip = SelectedAltPersonToApproveTS.Zip!
                    Phone = SelectedAltPersonToApproveTS.Phone!
                    Email = SelectedAltPersonToApproveTS.AddETo!
                    prefix = AltPersonToApproveTS_Prefix
                    ContactID = SelectedAltPersonToApproveTS.Value!
                    ClientId = SelectedAltPersonToApproveTS.ClientId!
                }else  if header == "FAMIS PO Certifier" {
                    Name = SelectedFAMISPOCertifier.Text!
                    Address = SelectedFAMISPOCertifier.ContAddr!
                    City = SelectedFAMISPOCertifier.City!
                    StateName = SelectedFAMISPOCertifier.State!
                    Zip = SelectedFAMISPOCertifier.Zip!
                    Phone = SelectedFAMISPOCertifier.Phone!
                    Email = SelectedFAMISPOCertifier.AddETo!
                    prefix = FAMISPOCertifier_Prefix
                    ContactID = SelectedFAMISPOCertifier.Value!
                    ClientId = SelectedFAMISPOCertifier.ClientId!
                }else  if header == "Timeslip Approver Supervisor" {
                    Name = SelectedTSApproverSupervisor.Text!
                    Address = SelectedTSApproverSupervisor.ContAddr!
                    City = SelectedTSApproverSupervisor.City!
                    StateName = SelectedTSApproverSupervisor.State!
                    Zip = SelectedTSApproverSupervisor.Zip!
                    Phone = SelectedTSApproverSupervisor.Phone!
                    Email = SelectedTSApproverSupervisor.AddETo!
                    prefix = TSApproverSupervisor_Prefix
                    ContactID = SelectedTSApproverSupervisor.Value!
                    ClientId = SelectedTSApproverSupervisor.ClientId!
                }
                //                get the sate name w.r.t state code
                
                for dict in StateArray{
                    let stateObj = dict as! State
                    if stateObj.StateCode == StateName || stateObj.StateName == StateName{
                        nextViewController.DOE_State_Code = stateObj.StateCode!
                        nextViewController.DOE_State_Name = StateName
                        
                        nextViewController.selectedState = State.init(StateId: stateObj.StateId, StateName: stateObj.StateName, StateCode: stateObj.StateCode, isSelected: "1")
                        break
                    }
                }
                nextViewController.DOE_Name = Name
                nextViewController.DOE_Address = Address
                nextViewController.DOE_City = City
                //                nextViewController.DOE_State_Name = StateName
                nextViewController.DOE_Zip = Zip
                nextViewController.DOE_Phone = Phone
                nextViewController.DOE_Email = Email
                nextViewController.DOE_Confirm_Email = Email
                nextViewController.DOE_Contact_ID = ContactID
                nextViewController.DOE_Client_ID = ClientId
                nextViewController.DOE_Prefix = prefix
                
            }
            nextViewController.DOE_addEditApplFromListDelegate = self
            nextViewController.isFromSummaryPage = self.isFromSummaryPage
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }else{
            let nextVC:AddNewReportToViewController = vc as! AddNewReportToViewController
            
            if isForEdit == true{
                nextVC.isForDOEEditClientApplicantFromChooseList = true
                nextVC.isForDOEAddClientApplicantFromChooseList = false
                var Name = ""
                var Address = ""
                var City = ""
                var StateName = ""
                var Zip = ""
                var Phone = ""
                var Email = ""
                var ClientId = ""
                var ContactID = ""
                if header == "Person To Report To" {
                    Name = SelectedPersonToReportTo.Text!
                    Address = SelectedPersonToReportTo.ContAddr!
                    City = SelectedPersonToReportTo.City!
                    StateName = SelectedPersonToReportTo.State!
                    Zip = SelectedPersonToReportTo.Zip!
                    Phone = SelectedPersonToReportTo.Phone!
                    Email = SelectedPersonToReportTo.AddETo!
                    prefix = PersonToReportTo_Prefix
                    ContactID = SelectedPersonToReportTo.Value!
                    ClientId = SelectedPersonToReportTo.ClientId!
                }else  if header == "Primary Person To Approve Timeslip" {
                    Name = SelectedPrimaryReasonToApproveTS.Text!
                    Address = SelectedPrimaryReasonToApproveTS.ContAddr!
                    City = SelectedPrimaryReasonToApproveTS.City!
                    StateName = SelectedPrimaryReasonToApproveTS.State!
                    Zip = SelectedPrimaryReasonToApproveTS.Zip!
                    Phone = SelectedPrimaryReasonToApproveTS.Phone!
                    Email = SelectedPrimaryReasonToApproveTS.AddETo!
                    
                    prefix = PrimaryReasonToApproveTS_Prefix
                    ContactID = SelectedPrimaryReasonToApproveTS.Value!
                    ClientId = SelectedPrimaryReasonToApproveTS.ClientId!
                    
                }else  if header == "Alternate Person To Approve Timeslip" {
                    Name = SelectedAltPersonToApproveTS.Text!
                    Address = SelectedAltPersonToApproveTS.ContAddr!
                    City = SelectedAltPersonToApproveTS.City!
                    StateName = SelectedAltPersonToApproveTS.State!
                    Zip = SelectedAltPersonToApproveTS.Zip!
                    Phone = SelectedAltPersonToApproveTS.Phone!
                    Email = SelectedAltPersonToApproveTS.AddETo!
                    prefix = AltPersonToApproveTS_Prefix
                    ContactID = SelectedAltPersonToApproveTS.Value!
                    ClientId = SelectedAltPersonToApproveTS.ClientId!
                }else  if header == "FAMIS PO Certifier" {
                    Name = SelectedFAMISPOCertifier.Text!
                    Address = SelectedFAMISPOCertifier.ContAddr!
                    City = SelectedFAMISPOCertifier.City!
                    StateName = SelectedFAMISPOCertifier.State!
                    Zip = SelectedFAMISPOCertifier.Zip!
                    Phone = SelectedFAMISPOCertifier.Phone!
                    Email = SelectedFAMISPOCertifier.AddETo!
                    prefix = FAMISPOCertifier_Prefix
                    ContactID = SelectedFAMISPOCertifier.Value!
                    ClientId = SelectedFAMISPOCertifier.ClientId!
                }else  if header == "Timeslip Approver Supervisor" {
                    Name = SelectedTSApproverSupervisor.Text!
                    Address = SelectedTSApproverSupervisor.ContAddr!
                    City = SelectedTSApproverSupervisor.City!
                    StateName = SelectedTSApproverSupervisor.State!
                    Zip = SelectedTSApproverSupervisor.Zip!
                    Phone = SelectedTSApproverSupervisor.Phone!
                    Email = SelectedTSApproverSupervisor.AddETo!
                    prefix = TSApproverSupervisor_Prefix
                    ContactID = SelectedTSApproverSupervisor.Value!
                    ClientId = SelectedTSApproverSupervisor.ClientId!
                }
                //                get the sate name w.r.t state code
                
                for dict in StateArray{
                    let stateObj = dict as! State
                    if stateObj.StateCode == StateName || stateObj.StateName == StateName{
                        nextVC.DOE_State_Code = stateObj.StateCode!
                        nextVC.DOE_State_Name = StateName
                        
                        nextVC.selectedState = State.init(StateId: stateObj.StateId, StateName: stateObj.StateName, StateCode: stateObj.StateCode, isSelected: "1")
                        break
                    }
                }
                nextVC.DOE_Name = Name
                nextVC.DOE_Address = Address
                nextVC.DOE_City = City
                //                nextVC.DOE_State_Name = StateName
                nextVC.DOE_Zip = Zip
                nextVC.DOE_Phone = Phone
                nextVC.DOE_Email = Email
                nextVC.DOE_Confirm_Email = Email
                nextVC.DOE_Contact_ID = ContactID
                nextVC.DOE_Client_ID = ClientId
                nextVC.DOE_Prefix = prefix
                
            }
            nextVC.isFromSummaryPage = self.isFromSummaryPage
            
            nextVC.DOE_addEditApplFromListDelegate = self
            self.navigationController?.popToViewController(nextVC, animated: true)
        }
    }
}
