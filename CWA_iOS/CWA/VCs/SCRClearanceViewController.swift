//
//  SCRClearanceViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 02/11/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON

class SCRClearanceViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource
{
    var selectedMenuName = ""

    let Approve_Status = "1"
    let Deny_Status = "2"
    let Deny_Bg_Color = "#FF020F"
    let Approve_Bg_Color = "#5CB85C"
    
    let Deny_Disabled_Bg_Color = "#FF5558"
    let Approve_Disabled_Bg_Color = "#84B88D"

    var scrList = [SCRClearance]()
    var colorLegendArray = NSMutableArray()
    let Legend_Tbl_Tag = 1001
    
    @IBOutlet var noDataView: UIView!
    @IBOutlet var lblNoData: UILabel!
    @IBOutlet var approvedBtnOutlet: UIButton!
    @IBOutlet var deniedBtnOutlet: UIButton!
    @IBOutlet var pendingBtnOutlet: UIButton!
    @IBOutlet var scrTblView: UITableView!
    
    
    
    
    @objc override func appWillEnterForeground(){
        print("appWillEnterForeground")
        
        self.getScrServerCall()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titlelbl.text = selectedMenuName
        
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        noDataView.isHidden = true
        noDataView.backgroundColor = UIColor(hexString:danger_background_Color)
        lblNoData.textColor = UIColor(hexString:danger_Color)
//        approvedBtnOutlet.setTitleColor(UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String), for: .normal)
//        pendingBtnOutlet.setTitleColor(UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String), for: .normal)
//        deniedBtnOutlet.setTitleColor(UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String), for: .normal)
        approvedBtnOutlet.isSelected = false
        pendingBtnOutlet.isSelected = false
        deniedBtnOutlet.isSelected = false
        getScrServerCall()
    }
    func ShowTablePopup(Message: String){
        
        let msg = "\n\n\n\n\n\n"
        var alrController = UIAlertController()
        alrController = UIAlertController(title: Message, message: msg, preferredStyle: UIAlertController.Style.alert)
        let margin:CGFloat = 8.0
        let rect = CGRect(x: Int(margin), y: 10, width: 255, height: 120)
        let tableView = UITableView(frame: rect)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tag = Legend_Tbl_Tag
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
        alrController.view.addSubview(tableView)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: {(alert: UIAlertAction!) in print("OK")
            alrController.dismiss(animated: true, completion: nil)
        })
        
        alrController.addAction(cancelAction)
        self.present(alrController, animated: true, completion: {})
        
        
    }
    //MARK: Server Call
    
    func getScrServerCall()
    {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable
        {
            JustHUD.shared.showInView(view: (self.view)!)
            let defaults = UserDefaults.standard
            
            let ContactId = String(format: "%d", defaults.integer(forKey: "ContactId"))
            
            let params :[String:Any] = ["ApprovedSCRForms":approvedBtnOutlet.isSelected,
                                        "DeniedSCRForms":deniedBtnOutlet.isSelected,
                                        "PendingSCRForms":pendingBtnOutlet.isSelected,
                                        "ContactId":ContactId]
            print(params)
            RestAPI.scrclearancegetSCRClearance(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
            
        }
        else {
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    func ApproveDenyServerCall(ApplicantId: String, ScrApprovalStatus: String, Name: String)
    {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable
        {
            JustHUD.shared.showInView(view: (self.view)!)
            let defaults = UserDefaults.standard
            
            let ContactId = String(format: "%d", defaults.integer(forKey: "ContactId"))
            let ClientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let  DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))

            
            let params :[String:Any] = ["ScrApprovalStatus":ScrApprovalStatus,
                                        "OSSource":"iOS",
                                        "ApplicantId":ApplicantId,
                                        "ContactId":ContactId,
                                        "ClientID": ClientID,
                                        "Name":"",
                                        "DivId":DivisionId]//Divid
            print(params)
            RestAPI.approveDenySCRClearance(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getApproveDenyResponse(response:))
            
        }
        else {
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    func getApproveDenyResponse(response: AnyObject)
    {
        JustHUD.shared.hide()
        print(response)
        if response is String {
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
        else
        {
            let  object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = "Submitted Successfully"
                    
                }
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                self.navigationController?.view.makeToast("Please wait...", duration: 3.0, position: .bottom, title: "", image: nil)
                self.getScrServerCall()
            }else{
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    message = Error_Message
                }
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }
    }
    func getResponse(response: AnyObject)
    {
        scrList.removeAll()
        JustHUD.shared.hide()
        self.navigationController?.view.hideAllToasts()

        print(response)
        if response is String {
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
        else
        {
            let  scrobject = response as! JSON
            
            if scrobject["MessageStatus"].intValue == 1
            {
                
                if  scrobject["colourText"].null == nil{
                    let colourTextArray = scrobject["colourText"].array // as! NSMutableArray
                    colorLegendArray.removeAllObjects()
                    for dict in colourTextArray! {
                        colorLegendArray.add(["Text":dict["Text"].stringValue,"Color":dict["Color"].stringValue])
                    }
                }
                
                
                if  scrobject["SCRDetailsList"].null == nil{
                    
                    if scrobject["SCRDetailsList"].arrayValue.count>0
                    {
                        for dict in scrobject["SCRDetailsList"].arrayValue
                        {
                            let scr = SCRClearance.init(ApplicantId: dict["ApplicantId"].stringValue, FirstName: dict["FirstName"].stringValue, LastName: dict["LastName"].stringValue, DateOfBirth: dict["DateOfBirth"].stringValue, ScrSubmissionDate: dict["ScrSubmissionDate"].stringValue, ApprovedOrDeniedBy: dict["ApprovedOrDeniedBy"].stringValue, ScrApprovalStatus: dict["ScrApprovalStatus"].intValue, ApprovalOrDenialDate: dict["ApprovalOrDenialDate"].stringValue, ScrFormSentDate: dict["ScrFormSentDate"].stringValue, AplDOB: dict["AplDOB"].stringValue, ScrFormStatus: dict["ScrFormStatus"].stringValue, ScrFormAprvDate: dict["ScrFormAprvDate"].stringValue, ScrFormDnyDate: dict["ScrFormDnyDate"].stringValue, ScrFormAprvDenialBy: dict["ScrFormAprvDenialBy"].stringValue, ScrColor: dict["ScrColor"].stringValue)
                            scrList.append(scr)
                        }
                        if scrList.count == 0{
                            // No data view should show here
                            noDataView.isHidden = false
                            var message = scrobject["Message"].stringValue
                            if message.count == 0{
                                message = "No record found"
                            }
                            lblNoData.text = message
                        }else{
                            
                            self.scrTblView.setContentOffset(.zero, animated: false)
                        }
                    }
                }else{
                    // No data view should show here
                    noDataView.isHidden = false
                    var message = scrobject["Message"].stringValue
                    if message.count == 0{
                        message = "No record found"
                    }
                    lblNoData.text = message
                }
            }else{
                var message = scrobject["Message"].stringValue
                if message.count == 0{
                    message = Error_Message
                }
                noDataView.isHidden = false
                
                lblNoData.text = message

                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
            DispatchQueue.main.async(execute: { () -> Void in
                self.scrTblView.reloadData()
                
            })        }
    }
    
    
    //MARK: UITableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView.tag == Legend_Tbl_Tag{
            return colorLegendArray.count
        }
        return scrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if  tableView.tag == Legend_Tbl_Tag{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell") ?? UITableViewCell(style: .default, reuseIdentifier: "timeCell")
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.numberOfLines = 0
            
            let colorDict = colorLegendArray[indexPath.row] as! NSDictionary
            let text = colorDict["Text"] as? String
            let bgColor = colorDict["Color"] as? String
            
            cell.backgroundColor = UIColor(hexString:bgColor!)
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.textAlignment = .center
            
            cell.textLabel?.text = text
            
            return cell
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "scrCell", for: indexPath) as! SCRClearanceTableViewCell
        cell.selectionStyle = .none
        
        
        let   k = scrList[indexPath.row]
        /*
         "ScrFormSentDate" : "08\/29\/2014 01:39 PM",
         "ScrColor" : "#99FF99",
         "ScrFormDnyDate" : "11\/14\/2018 12:54 AM",
         "DateOfBirth" : "01\/01\/0001 12:00 AM",
         "ScrApprovalStatus" : 0,
         "ScrFormAprvDenialBy" : "James Morriss",
         "ScrFormStatus" : "Approved",
         "FirstName" : "william",
         "ScrSubmissionDate" : "01\/01\/0001",
         "AplDOB" : "11\/22\/1964",
         "ApplicantId" : 105676,
         "ScrFormAprvDate" : "01\/01\/0001 12:00 AM",
         "ApprovedOrDeniedBy" : null,
         "LastName" : "abaidoo",
         "ApprovalOrDenialDate" : "01\/01\/0001 12:00 AM"
         */
        cell.firstNameLbl.text = k.FirstName
        cell.lastNameLbl.text = k.LastName
        cell.applicantIdLbl.text = k.ApplicantId
        cell.dobLbl.text = k.ScrFormSentDate
        cell.scrSubmissionDateLbl.text = k.AplDOB
        cell.scrApprovalStatusLbl.text = k.ScrFormStatus
        cell.deniedByLbl.text = k.ScrFormAprvDenialBy
        cell.deniedDateLbl.text = k.ScrFormDnyDate
        
        cell.colorView.backgroundColor = UIColor(hexString: k.ScrColor!)
        
        cell.sAppLbl.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.sFirstLbl.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.sLastLbl.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.sDobLbl.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.sSubmissionDate.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.sApproveStatus.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.sDeniedBy.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.sDeniedDate.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
        cell.approveBtnOutlet.removeTarget(self, action: #selector(self.approveAction), for: .touchUpInside)
        cell.denyBtnOutlet.removeTarget(self, action: #selector(self.denyAction), for: .touchUpInside)
        
        cell.approveBtnOutlet.addTarget(self, action: #selector(self.approveAction), for: .touchUpInside)
        cell.denyBtnOutlet.addTarget(self, action: #selector(self.denyAction), for: .touchUpInside)
        
        let formStatus = k.ScrFormStatus
        
        cell.denyBtnOutlet.backgroundColor =  UIColor(hexString:Deny_Bg_Color)
        cell.approveBtnOutlet.backgroundColor =  UIColor(hexString:Approve_Bg_Color)
        cell.denyBtnOutlet.isUserInteractionEnabled = true
        cell.approveBtnOutlet.isUserInteractionEnabled = true
        cell.approveBtnOutlet.layer.borderColor = UIColor.white.cgColor
        cell.denyBtnOutlet.layer.borderColor = UIColor.white.cgColor
        
        cell.approveBtnOutlet.layer.borderWidth = 1
        cell.denyBtnOutlet.layer.borderWidth = 1
        
        if formStatus?.caseInsensitiveCompare("Denied") == ComparisonResult.orderedSame{
            cell.denyBtnOutlet.isUserInteractionEnabled = false
            cell.approveBtnOutlet.isUserInteractionEnabled = true
            cell.denyBtnOutlet.backgroundColor =  UIColor(hexString:Deny_Disabled_Bg_Color)

        }else if formStatus?.caseInsensitiveCompare("Approved") == ComparisonResult.orderedSame{
            cell.denyBtnOutlet.isUserInteractionEnabled = true
            cell.approveBtnOutlet.isUserInteractionEnabled = false
             cell.approveBtnOutlet.backgroundColor =  UIColor(hexString:Approve_Disabled_Bg_Color)

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if  tableView.tag == Legend_Tbl_Tag{
            return 40
        }
        return 265
    }
    //MARK: UIButton Action Methods
    
    @IBAction func ApprovedSCRFormsAction(_ sender: UIButton)
    {
        if (approvedBtnOutlet.isSelected == true)
        {
            approvedBtnOutlet.isSelected = false
        }
        else {
            approvedBtnOutlet.isSelected = true
        }
        self.getScrServerCall()
        
    }
    
    @IBAction func DeniedSCRFormsAction(_ sender: UIButton)
    {
        
        if (deniedBtnOutlet.isSelected == true)
        {
            deniedBtnOutlet.isSelected = false
        }
        else {
            deniedBtnOutlet.isSelected = true
        }
        self.getScrServerCall()
        
    }
    
    @IBAction func PendingSCRFormsAction(_ sender: UIButton)
    {
        
        if (pendingBtnOutlet.isSelected == true)
        {
            pendingBtnOutlet.isSelected = false
        }
        else {
            pendingBtnOutlet.isSelected = true
        }
        self.getScrServerCall()
    }
    
    @IBAction func ColorIndicatorAction(_ sender: UIButton)
    {
        if colorLegendArray.count > 0{
            
            self.ShowTablePopup(Message:"")
        }else{
            self.navigationController?.view.makeToast("No info", duration: 1.0, position: .bottom, title: "", image: nil)

        }
    }
    
    
    @IBAction func GetListAction(_ sender: UIButton)
    {
        self.getScrServerCall()
        
    }
    @objc func approveAction(_ sender: AnyObject)
    {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.scrTblView)
        let indexPath = self.scrTblView.indexPathForRow(at: buttonPosition)
        
        let  SCRObj = scrList[indexPath!.row]
        
        let applicantID = SCRObj.ApplicantId  ?? ""
        
        if applicantID.count == 0{
            self.navigationController?.view.makeToast("Please try again", duration: 1.0, position: .bottom, title: "", image: nil)
            
        }else{
            let  Name = SCRObj.FirstName!+" "+SCRObj.LastName!//String(format:"%@ %@", SCRObj.FirstName!, SCRObj.LastName! )

            self.ApproveDenyServerCall(ApplicantId: applicantID, ScrApprovalStatus: Approve_Status,Name: Name )
        }
        
    }
    
    @objc func denyAction(_ sender: AnyObject)
    {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.scrTblView)
        let indexPath = self.scrTblView.indexPathForRow(at: buttonPosition)
        
        let  SCRObj = scrList[indexPath!.row]
        
        let applicantID = SCRObj.ApplicantId  ?? ""
        
        if applicantID.count == 0{
            self.navigationController?.view.makeToast("Please try again", duration: 1.0, position: .bottom, title: "", image: nil)
        }else{
            
             let  Name = SCRObj.FirstName!+" "+SCRObj.LastName!//String(format:"%@ %@", SCRObj.FirstName!, SCRObj.LastName! )
            
            self.ApproveDenyServerCall(ApplicantId: applicantID, ScrApprovalStatus: Deny_Status,Name: Name )

        }
    }
}
