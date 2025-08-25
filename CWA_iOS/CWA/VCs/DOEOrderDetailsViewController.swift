//
//  DOEOrderDetailsViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 29/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON

class DOEOrderDetailsViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    let schduleHeader = "Tell us when you need them."
    let refferHeader = "Tell us how the consultant is to be sourced"
    let orderHeader = "Tell us who the consultant will report to, who will approve their hours, and who will certify in FAMIS"
    let payHeader = "Please tell us how much to pay them"
    let waiverHeader = "Waiver Needed"
    let locHeader  = "Enter information about the consultant's position"
    var isCancelOrder = false
var isFromHistoricalOrder = false
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblHeaderBGView: UIView!

    var divisionDataArray = NSMutableArray()
    var dataArray = NSMutableArray()
    var isFromROSDOE = false
    var isCancelOrderAndPopToDashboard = false
    
    let boldHeaderTitle = "Section header"
    let lTitle = "Title"
    let subTitle = "SubTitle"
    
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var noDataView: UIView!
    
    private let tblRefreshControl = UIRefreshControl()
    @IBOutlet var tableTopConstraint: NSLayoutConstraint!

    var OrderID = 0
    var PayRate = ""
    var WaiverNecessary = false

    var selectedApplicant = Applicant.init(CandidateId: "0", ApplicantId: "", Name: "", ConsultantType: "", Email: "", Address: "", City: "", State: "", Zip: "", SSN: "", isSelected: "",appliType: "",ApplicationId:  "0",NewApplicant:  "",extraCandId: "0")
    
    var SelectedPersonToReportTo = DOEReportTo.init(Value: "", Text: "",ContAddr: "",State: "",Phone: "",City: "",Zip: "",AddETo:"",isSelected: "0",ClientId: "",ContactId:"")
    var SelectedPrimaryReasonToApproveTS = DOEReportTo.init(Value: "", Text: "",ContAddr: "",State: "",Phone: "",City: "",Zip: "",AddETo:"",isSelected: "0",ClientId: "",ContactId:"")
    var SelectedAltPersonToApproveTS = DOEReportTo.init(Value: "", Text: "",ContAddr: "",State: "",Phone: "",City: "",Zip: "",AddETo:"",isSelected: "0",ClientId: "",ContactId:"")
    var SelectedFAMISPOCertifier = DOEReportTo.init(Value: "", Text: "",ContAddr: "",State: "",Phone: "",City: "",Zip: "",AddETo:"",isSelected: "0",ClientId: "",ContactId:"")
    var SelectedTSApproverSupervisor = DOEReportTo.init(Value: "", Text: "",ContAddr: "",State: "",Phone: "",City: "",Zip: "",AddETo:"",isSelected: "0",ClientId: "",ContactId:"")

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titlelbl.text = "DOE Confirm Order"
        if isFromROSDOE == true && self.OrderID == 0{
            lblHeader.text = ""
            tableTopConstraint.constant = 0
            lblHeaderBGView.isHidden = true
            lblHeaderBGView.backgroundColor = UIColor.clear
            tableTopConstraint.constant =   20

            self.titlelbl.text = "DOE Confirm"
            self.formDatArrayForDetails(HeaderTitle: "Final Step: Please review your order before it is submitted", HeaderValue: "If the information below is correct click the \"Save Order\" button at the bottom of the page",isOrderSaved: false)
            
        }else{
            lblHeader.text = String(format:"Order List:Below are the details for Order #%d", self.OrderID)
            dataArray.removeAllObjects()
            detailsTableView.reloadData()
            self.getDOEOrderDetailsCall()

            lblHeaderBGView.isHidden = false
            lblHeader.textColor = UIColor.black
            lblHeaderBGView.backgroundColor = UIColor.white
            tableTopConstraint.constant = 45 + 20
        }
    }
    @objc override func appWillEnterForeground(){
        print("appWillEnterForeground Division")
        if isFromROSDOE == true && self.OrderID == 0{
         }else{
            dataArray.removeAllObjects()
            detailsTableView.reloadData()
             self.getDOEOrderDetailsCall()
         }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        noDataView.isHidden = true
        noDataView.backgroundColor = UIColor(hexString:danger_background_Color)
        lblNoData.textColor = UIColor(hexString:danger_Color)
        
        //        self.title = "DOE Confirm Order"
        if isFromROSDOE == true && self.OrderID == 0{
            self.formDatArrayForDetails(HeaderTitle: "Final Step: Please review your order before it is submitted", HeaderValue: "If the information below is correct click the \"Save Order\" button at the bottom of the page",isOrderSaved: false)
            lblHeader.text = ""
             tableTopConstraint.constant = 0
            lblHeaderBGView.isHidden = true
            lblHeaderBGView.backgroundColor = UIColor.clear
            tableTopConstraint.constant =   20

        }else{
            lblHeaderBGView.isHidden = false
            lblHeader.textColor = UIColor.black

            lblHeader.text = String(format:"Order List:Below are the details for Order #%d", self.OrderID)
            lblHeaderBGView.backgroundColor = UIColor.white
            dataArray.removeAllObjects()
            detailsTableView.reloadData()
            self.getDOEOrderDetailsCall()
            tableTopConstraint.constant = 45 + 20
        }
        self.view.layoutIfNeeded()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func editButtonView(title: String) -> UIButton{
        
        var width = 45
        var font = 13
        if title.contains("Edit Work Order"){
             width = 165
             font = 13
        }
        let editButton = UIButton(frame: CGRect(x: 0,y: 0, width:width,  height: 35))
        editButton.backgroundColor = UIColor(hexString:"#39B3D7")
        editButton.setTitle(title, for: .normal)
        editButton.setTitleColor(UIColor.white, for: .normal)
        editButton.titleLabel?.font =  UIFont.systemFont(ofSize: CGFloat(font))
        editButton.addTarget(self, action: #selector(self.editBtnTapped), for: .touchUpInside)
        editButton.titleLabel?.lineBreakMode = .byWordWrapping
        editButton.titleLabel?.textAlignment = .left

        return editButton
    }
    //MARK: Button Action
    @objc override func goBack()
    {
        
        if isFromROSDOE == true && self.OrderID > 0 && isFromHistoricalOrder == false{
            self.clearDOEData()
            self.isFromROSDOE = false
            self.pushToLocationPage()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc func cancelButtonTapped(_ sender: UIButton){
        
      isCancelOrder = true
      
        
        self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Would you like to cancel the order and go back to dashboard?", okBtnTitle: "Yes", cancelBtnTitle: "No", type: Warning_Text, isAttributed: false)

    }
  
    @IBAction override func okButtonTapped(_ sender: Any) {
         self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        if isCancelOrder == true{
            self.PushToDashboard()
        }
        
    }
    
    @objc func saveButtonTapped(_ sender: UIButton){
        
        self.saveDOEOrder()
    }
    @objc func returnToConfirmOrderButtonTapped(_ sender: UIButton){
        
        self.pushToOrderListPage()
    }
    @IBAction func editBtnTapped(_ sender: UIButton){
        let senderPosition  = sender.convert(CGPoint.zero, to: self.detailsTableView)
        
        let indexPath =  self.detailsTableView.indexPathForRow(at:senderPosition)
        
        let  dict = dataArray[(indexPath?.row)!] as! NSDictionary
        
        let headerTtl =   dict[boldHeaderTitle]  as? String

        
        if headerTtl == schduleHeader {
 
            self.pushToSchdulePage()
            
        }
        else if headerTtl == refferHeader{
//             NotificationCenter.default.post(name: Notification.Name("PushToDOEReferConsultantPageFromDetails"), object: nil)

            self.pushToReferConsultantPage()
        }
        else if headerTtl == orderHeader{
//             NotificationCenter.default.post(name: Notification.Name("PushToDOEOrderPageFromDetails"), object: nil)

            self.pushToOrderPage()
        }
        else if headerTtl == payHeader{
//             NotificationCenter.default.post(name: Notification.Name("PushToDOEPayratePageFromDetails"), object: nil)

            self.pushToPayratePage()
        }
        else if headerTtl == waiverHeader{
//             NotificationCenter.default.post(name: Notification.Name("PushToWaiverPageFromDetails"), object: nil)

            self.pushToWaiverPage()
        }
        else if headerTtl == locHeader{
//             NotificationCenter.default.post(name: Notification.Name("PushToDOELocationPageFromDetails"), object: nil)

            self.pushToLocationPage()
        }
        
    }
    
    func ButtonTableCell(indexPath: NSIndexPath) -> ButtonTableViewCell {
        
        let cell:ButtonTableViewCell = self.detailsTableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCellIdentifier") as! ButtonTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        let  dict = dataArray[indexPath.row] as! NSDictionary
        
        let headerTtl =  ""
         var subTitleText =  ""
        
        
        
        if dict[subTitle] != nil{
            subTitleText =   (dict[subTitle]  as? String)!
        }
        
        if subTitleText ==  "Return To Order List"{
            cell.returnToConfirmOrderButton.removeTarget(self, action:#selector(self.returnToConfirmOrderButtonTapped), for: .touchUpInside)
            
            cell.returnToConfirmOrderButton.addTarget(self, action:#selector(self.returnToConfirmOrderButtonTapped), for: .touchUpInside)
            cell.nextButton.isHidden = true
            cell.backButton.isHidden = true
            cell.returnToConfirmOrderButton.isHidden = false
            
        }else{
            cell.nextButton.isHidden = false
            cell.backButton.isHidden = false
            cell.returnToConfirmOrderButton.isHidden = true
            cell.nextButton.removeTarget(self, action:#selector(self.saveButtonTapped), for: .touchUpInside)
            cell.backButton.removeTarget(self, action:#selector(self.cancelButtonTapped), for: .touchUpInside)
            
            cell.nextButton.addTarget(self, action:#selector(self.saveButtonTapped), for: .touchUpInside)
            cell.backButton.addTarget(self, action:#selector(self.cancelButtonTapped), for: .touchUpInside)
            
        }
        
        return cell
        
    }
   
    //MARK:-  TABLEVIEW DATA SOURCE METHOD
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return dataArray.count
        
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let  dict = dataArray[indexPath.row] as! NSDictionary
        
        var headerTtl =  ""
        var titleText =  ""
        var subTitleText =  ""
        
        if dict[boldHeaderTitle] != nil{
            headerTtl =   (dict[boldHeaderTitle]  as? String)!
        }
        if dict[lTitle] != nil{
            titleText =   (dict[lTitle]  as? String)!
        }
        if dict[subTitle] != nil{
            subTitleText =   (dict[subTitle]  as? String)!
        }
        
        if isFromROSDOE == true{
            if titleText == "Buttons" {
                return self.ButtonTableCell(indexPath: indexPath as NSIndexPath)
            }
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?
        if !(cell != nil) {
            cell = UITableViewCell(style:.subtitle, reuseIdentifier: "CELL")
        }
   
        cell?.textLabel?.text = titleText
        cell?.detailTextLabel?.text = subTitleText
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none

        
        
        if headerTtl.count == 0 {
            cell?.backgroundColor = UIColor.white
            cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.textLabel?.textColor = UIColor.black
            cell?.accessoryView = UIView()
            
        }else{
            if isFromROSDOE == true && self.OrderID == 0{
                
                if headerTtl == schduleHeader || headerTtl == refferHeader || headerTtl == orderHeader || headerTtl == payHeader || headerTtl == waiverHeader || headerTtl == locHeader{
                    cell?.accessoryType = UITableViewCell.AccessoryType.none
                    cell?.accessoryView = self.editButtonView(title: "Edit")
                    

                }else{
                    cell?.accessoryView = UIView()
                }
            }else{
                if headerTtl == schduleHeader{
                    cell?.accessoryType = UITableViewCell.AccessoryType.none
                    cell?.accessoryView = self.editButtonView(title: "Edit Work Order Hours or Billing")
                }else{
                    cell?.accessoryView = UIView()
                }
            }
            if headerTtl.contains("Thank you"){
                cell?.textLabel?.textColor =  UIColor.clear
                cell?.backgroundColor = UIColor.white
            }else{
                cell?.textLabel?.textColor =  UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
                cell?.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0)

            }
            cell?.textLabel?.text = headerTtl
            cell?.detailTextLabel?.text = ""
            cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            
        }
        
        cell?.textLabel?.numberOfLines = 0
        cell?.detailTextLabel?.numberOfLines = 0
        return cell!
        
    }
    
    
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        let  dict = dataArray[indexPath.row] as! NSDictionary

        var headerTtl =  ""
        var titleText =  ""
        var subTitleText =  ""

        if dict[boldHeaderTitle] != nil{
            headerTtl =   (dict[boldHeaderTitle]  as? String)!
        }
        if dict[lTitle] != nil{
            titleText =   (dict[lTitle]  as? String)!
        }
        if dict[subTitle] != nil{
            subTitleText =   (dict[subTitle]  as? String)!
        }
        
 
        if isFromROSDOE == true{
            if titleText == "Buttons"  {
            return 60
            }else if headerTtl.contains("Thank you: Your order has been confirmed") {
                return 0
            }
            
        }
        
        var message = headerTtl
        let screenWidth = UIScreen.main.bounds.size.width
        
         if headerTtl.count == 0 {
            
            message =  String(format:"%@\n%@",titleText,subTitleText)
         }else{
            let fontSize = 15
            let padding  = 20

            let height =  headerTtl.heightWithConstrainedWidth(width: UIScreen.main.bounds.size.width - 20, font: UIFont.boldSystemFont(ofSize: CGFloat(fontSize))) + CGFloat(padding) //self.sizeOfString(string: message!, constrainedToHeight: Double.greatestFiniteMagnitude).height + 10
            if height > 800{
                return height - 300
            }
            return max(35, height)

        }
        
        if message.count == 0 ||  message == nil {
            
            return 60
            
        }else{
            var padding  = 20
            var fontSize = 15
            if screenWidth == 320 {
                padding = 10
                fontSize = 14
             }
            let height =  message.heightWithConstrainedWidth(width: UIScreen.main.bounds.size.width - 153, font: UIFont.boldSystemFont(ofSize: CGFloat(fontSize))) + CGFloat(padding) //self.sizeOfString(string: message!, constrainedToHeight: Double.greatestFiniteMagnitude).height + 10
            if height > 800{
                return height - 300
            }
            return max(60, height)
            
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
    // MARK: - SERVER CALL
    
    
    func getDOEOrderDetailsCall() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            let oID = String(format:"%d", self.OrderID)
            
            //userid as String
            let params :[String:String] = ["OrderId":oID,"ClientID":clientID,"ContactId":ContactId]
            dataArray.removeAllObjects()
            RestAPI.getHistoricOrderDetails(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
        }else{
            isCancelOrder = false
             self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
        
    }
    
    func getSaveOrderResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            isCancelOrder = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            if object["MessageStatus"].intValue == 1
            {
                
                let Value1 = object["Message"].stringValue.replace(target: "<br/>", withString: "\n")
                let Value = Value1.replace(target: "<br />", withString: "\n")

                self.OrderID  = Int (object["OrderId"].stringValue)!
                
                self.formDatArrayForDetails(HeaderTitle: object["HeaderMessage"].stringValue, HeaderValue: Value,isOrderSaved: true)
                isCancelOrder = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["HeaderMessage"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                
//                lblHeader.backgroundColor = UIColor.init(hexString: success_background_Color)
                lblHeader.textColor = UIColor.init(hexString: success_Color)
                lblHeader.text = object["HeaderMessage"].stringValue
                lblHeaderBGView.isHidden = false
                lblHeaderBGView.backgroundColor = UIColor.init(hexString: success_background_Color)
                tableTopConstraint.constant = 45 + 20
                self.view.layoutIfNeeded()
                self.detailsTableView.setContentOffset(.zero, animated: true)
                self.clearDOEData()
            }else{
                let message = object["Message"].stringValue//.trimmingCharacters(in: .whitespacesAndNewlines)
//                let htmlString = "<html>" + message + "</html>"
                isCancelOrder = false
                
//                let messageText = htmlString.htmlToAttributedString
//                self.showCustomAlert(Title: "", attMessage: messageText! , message: message , okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text,isAttributed: true)
                let vMesage  = message.replace(target: "<br/>", withString: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
                let dMesage = vMesage.replace(target: "\t", withString: " ").trimmingCharacters(in: .whitespacesAndNewlines)
                self.showCustomAlert(Title: "", attMessage: NSAttributedString() , message: dMesage , okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text,isAttributed: false)

            }
        }
    }
    
    func getResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            
//            self.ShowAlertMessage(message: response as! String, title: "")
            noDataView.isHidden = false
            lblNoData.text = response as? String
            isCancelOrder = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

        }else{
            
            let object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
                
                dataArray.removeAllObjects()
                detailsTableView.reloadData()

                let textData = "Thank you: Your order has been confirmed\n\nYour order has been submitted to FAMIS. When it is entered into FAMIS, a PO will be generated which will need to be verified and then certified. Within the next 2 business hours, the PO should be ready for approval within FAMIS. If the PO is not visible within FAMIS within one business day from the date of this submittal, please send an email to questions@schoolprofessionals.com and reference the Work Order number shown on the summary sheet. We will investigate and get back to you.\n\nAfter the PO is approved and generated in FAMIS, if you are referring a consultant, they will receive notification on how to register with School Professionals. Do not have them register on their own UNTIL they receive this notification or they will not be linked to your work order. You will be notified via email when the registration process is complete and the consultant is authorized to start work. Please note: Approving a PO in FAMIS does NOT authorize the start of the assignment. Under no circumstances may the consultant begin work before you receive an email from our system authorizing them to start, or they will not be paid.\n\nIf you have asked School Professionals to locate a consultant for you, we will notify you via email when we have identified some candidates for your review.\n\nThank you for allowing School Professionals to handle your staffing needs."
                //////************Enter information about the consultant's position****************//////////
                let locTitle = [boldHeaderTitle:"Enter information about the consultant's position"]
                
//                let locDict = [ lTitle:"Location",subTitle:textData]

                let locDict = [lTitle:"Location",subTitle:self.convertHTMLToString(valueString: object["Location"].stringValue)]
                
                let posTitleDict = [lTitle:"Position Title",subTitle: object["Position_Title"].stringValue]
                
                let posDescDict = [lTitle:"Position Description",subTitle: object["Position_Description"].stringValue]
                
                
                //////************Tell us how the consultant is to be sourced****************//////////
                let refferTitle = [boldHeaderTitle:refferHeader]
                
                let ReferredConsultantDict = [lTitle:"Referred Consultant",subTitle:self.convertHTMLToString(valueString:object["Candidate_Name"].stringValue)]
                
                //////************Tell us who the consultant will report to, who will approve their hours, and who will certify in FAMIS****************//////////
                let orderTitle = [boldHeaderTitle:orderHeader]
                
                let OrderPlacerDict = [lTitle:"Order Placer",subTitle:self.convertHTMLToString(valueString:object["Order_Placer"].stringValue)]
                
                let reportToPersonDict = [lTitle:"Report To Person",subTitle:self.convertHTMLToString(valueString:object["Reportto"].stringValue)]
                
                let personToApproveTimeSlipDict = [lTitle:"Person To Approve Timeslip",subTitle:self.convertHTMLToString(valueString:object["ApproveTimeSlip"].stringValue)]
                
                let altvPersonToApproveTimeSlipDict = [lTitle:"Alternate Person To Approve Timeslip",subTitle:self.convertHTMLToString(valueString:object["AlternativePersonApproveTimeSlip"].stringValue)]
                
                let FAMISPOCertifierDict = [lTitle:"FAMIS PO Certifier",subTitle:self.convertHTMLToString(valueString:object["FamisProCertifier"].stringValue)]
                
                let TimeslipApproverSupervisorDict = [lTitle:"Timeslip Approver Supervisor",subTitle:self.convertHTMLToString(valueString:object["TimeSlipApproverSupervisor"].stringValue)]
                
                //////************Tell us when you need them.****************//////////
                //                let ScheduleDict = ["Schedule":object["Schedule"].stringValue]
                let schduleTitle = [boldHeaderTitle: schduleHeader]
                
                let scheduleValue = String(format:
                    "Sun    :   %@\nMon   :   %@\nTue    :   %@\nWed   :   %@\nThu    :   %@\nFri      :   %@\nSat     :   %@",object["ScheduleSun"].stringValue,
                                                                                                                               object["ScheduleMon"].stringValue,
                                                                                                                               object["ScheduleTue"].stringValue,
                                                                                                                               object["ScheduleWed"].stringValue,
                                                                                                                               object["ScheduleThu"].stringValue,
                                                                                                                               object["ScheduleFri"].stringValue,
                                                                                                                               object["ScheduleSat"].stringValue)
                let  ScheduleDict = [lTitle:"Schedule",subTitle:scheduleValue]
                
                //                let str = String(format:"%@ - %@",object["ScheduleStartTime"].stringValue,object["ScheduleEndTime"].stringValue)
                
                let ScheduleStartEndDateDict = [lTitle:"Start Date - End Date",subTitle:object["DateInfo"].stringValue]
                
                let TotalWorkOrderHoursDict = [lTitle:"Total Work Order Hours",subTitle:object["OrderHours"].stringValue]
                
                //////************Please tell us how much to pay them****************//////////
                let payTitle = [boldHeaderTitle:payHeader]
                
                let PayRateDict  = [lTitle:"Pay Rate",subTitle:object["HourlyPayRate"].stringValue]
                
                let  TotalWorkOrderPayrollDict = [lTitle:"Total Work Order Payroll",subTitle:object["WorkOrderPayRoll"].stringValue]
                
                let POBillRate = [lTitle:"PO Bill Rate",subTitle:object["PoBillRate"].stringValue]
                
                let  TotalWorkOrderPOBillingDict = [lTitle:"Total Work Order/PO Billing",subTitle:object["PoBilling"].stringValue]
                
                
                dataArray = [locTitle,
                             locDict,
                             posTitleDict,
                             posDescDict,
                             refferTitle,
                             ReferredConsultantDict,
                             orderTitle,
                             OrderPlacerDict,
                             reportToPersonDict,
                             personToApproveTimeSlipDict,
                             altvPersonToApproveTimeSlipDict,
                             FAMISPOCertifierDict,
                             TimeslipApproverSupervisorDict,
                             schduleTitle,
                             ScheduleDict,
                             ScheduleStartEndDateDict,
                             TotalWorkOrderHoursDict,
                             payTitle,
                             PayRateDict,
                             TotalWorkOrderPayrollDict,
                             POBillRate,
                             TotalWorkOrderPOBillingDict]
                /////************Waiver Needed*************//////
                let WaiverNecessary = object["WaiverNecessary"].boolValue
                
                if WaiverNecessary == true{
                    let waiverTitle = [boldHeaderTitle:waiverHeader]
                    
                    let subValue = String(format:
                        "Sun:%@\nMon:%@\nTue%@\nWed:%@\nThu:%@\nFri:%@\nSat%@",object["DCSun"].stringValue,
                                                                               object["DCMon"].stringValue,
                                                                               object["DCTue"].stringValue,
                                                                               object["DCWed"].stringValue,
                                                                               object["DCThu"].stringValue,
                                                                               object["DCFri"].stringValue,
                                                                               object["DCSat"].stringValue)
                    let prevDOEObj = Constants.DOEResponseObject
                    let  DailyCompensationDict = [lTitle:prevDOEObj["DailyCompensationText"].stringValue,subTitle:subValue]
                    let curntYrCalDict = [lTitle:prevDOEObj["FormatYtdCompensationNextYearText"].stringValue,subTitle: object["CompensationCurrentYear"].stringValue]
                    let curntYrCal30kDict = [lTitle:prevDOEObj["FormatCurrYearCompensationOver30kText"].stringValue,subTitle: object["CompensationCurrentYear30K"].stringValue]
                    
                    let pensionDict = [lTitle:prevDOEObj["ConsultantPensionText"].stringValue,subTitle: object["Pension"].stringValue]
                    
                    let retirmentDict = [lTitle:prevDOEObj["ConsultantPriortoMayText"].stringValue,subTitle: object["CompensationCurrentYear30K"].stringValue]
                    
                    let over65Dict = [lTitle:prevDOEObj["ConsultantOver65Text"].stringValue,subTitle: object["ConsultantAge"].stringValue]
                    
                    let WaiverExplanationDict = [lTitle:"WaiverExplanation",subTitle: object["WaiverExplanation"].stringValue]
                    dataArray.add(waiverTitle)
                    dataArray.add(DailyCompensationDict)
                    dataArray.add(curntYrCalDict)
                    dataArray.add(curntYrCal30kDict)
                    dataArray.add(pensionDict)
                    dataArray.add(retirmentDict)
                    dataArray.add(over65Dict)
                    dataArray.add(WaiverExplanationDict)
                    
                }
                
                     let buttonDict = [lTitle:"Buttons",subTitle: "Return To Order List" ]
                    dataArray.add(buttonDict)
                    
                 
                
                detailsTableView.reloadData()
                /*
                 Daily Compensation:Sun:$0.00
                 Mon:$0.00
                 Tue:$0.00
                 Wed:$0.00
                 Thu:$0.00
                 Fri:$1,682.66
                 Sat:$0.00
                 Projected current calendar year compensation(includes earnings from other work orders, if any):$2,019.22
                 Projected current calendar year compensation over $30,000:$0.00
                 Is the consultant a retiree receiving a NY state or local government pension?Yes
                 Did the consultant join the retirement system prior to May 31, 1973?Yes
                 Is the consultant over 65 years of age?Yes
                 Waiver Explanation
                 */
                
                noDataView.isHidden = true
                
                
                
            }else{
                
                var message = object["message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                noDataView.isHidden = false
                lblNoData.text = message
                isCancelOrder = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                //            RestAPI.ShowAlertMessage(ErrorMessage: message, titleMessage: " ", view: self)
            }
        }
    }
    
    func saveDOEOrder(){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
 
            let defaults = UserDefaults.standard
            var Param  = NSMutableDictionary()
            
            let DoeScheduleModel = defaults.dictionary(forKey: "DoeScheduleModel")
            var Referral = ""
            let CertifyHours = ["ContactId":SelectedFAMISPOCertifier.ContactId]
            let ApproveTimeslip = ["ContactId":SelectedPrimaryReasonToApproveTS.ContactId]
            let AltApproveTimeslip = ["ContactId": SelectedAltPersonToApproveTS.ContactId]
            let TsApproverSupervisor = ["ContactId": SelectedTSApproverSupervisor.ContactId]
            let PersonToReport = ["ContactId": SelectedPersonToReportTo.ContactId]
            
            let DoeSchoolProfessionalToRecruitModel = ["CertifyHours": CertifyHours,"ApproveTimeslip": ApproveTimeslip, "AltApproveTimeslip" : AltApproveTimeslip, "TsApproverSupervisor": TsApproverSupervisor,"PersonToReport": PersonToReport]
            
            let CreateOrderModel = [
                "PositionTitle":defaults.value(forKey: "PositionTitle"),
                "PositionDescription":defaults.value(forKey: "PositionDescription"),
                "LocationCode":defaults.value(forKey: "LocationCode")
            ]
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            
            if Int(selectedApplicant.CandidateId!)! == 0 && Int(selectedApplicant.ApplicationId!)! == 0 && Int(selectedApplicant.extraCandId!)! == 0{
                Referral = "0"
            }else{
                Referral = "1"
            }
            let DoeCandidateModel = ["Referral": Referral]
            
            
            
            
            
            
            if Int(selectedApplicant.CandidateId!)! > 0 || Int(selectedApplicant.ApplicationId!)! > 0  ||  Int(selectedApplicant.extraCandId!)! > 0 {
                
//                var appId = "0"
//                if Int(selectedApplicant.CandidateId!)! > 0{
//                    appId = selectedApplicant.CandidateId!
//                }else if Int(selectedApplicant.ApplicationId!)! > 0{
//                    appId = selectedApplicant.ApplicationId!
//
//                }else{
//                    appId = selectedApplicant.extraCandId!
//
//                }
                
                
                let DoeApplicantModel = ["CandidateId":selectedApplicant.CandidateId,
                                         "Type":selectedApplicant.appliType,
                                         "ClientId":clientID,
                                         "DivId":DivisionId,
                                         "ContactId":ContactId,
                                         "ApplicationId":selectedApplicant.ApplicationId,
                                         "NewApplicant":selectedApplicant.NewApplicant]

                if defaults.dictionary(forKey: "DoePayrateModel") != nil{
     
                    let DoePayrateModel =  defaults.dictionary(forKey: "DoePayrateModel")
                    PayRate = DoePayrateModel!["PayRate"] as! String
                    let PayRateType = DoePayrateModel!["PayRateType"] as! String
                    
                    let HourlyPayRate = DoePayrateModel!["HourlyPayRate"] as! String
                    let DoeEditWorkOrderModel = ["hourlyPayRate": HourlyPayRate,
                                                 "AnnualPayRate" : PayRateType == "D" ? 0 : 1,
                                                 "waiverNecessary":WaiverNecessary,
                                                 "clientId": clientID] as [String : Any]
                    let DoeWaiverModel  =  defaults.dictionary(forKey: "DoeWaiverModel")
                    
                    if DoeWaiverModel != nil{
                        
                        let   WaiverText = DoeWaiverModel!["WaiverText"] as! String
                        var pensionValue = false
                        var retirmentValue = false
                        var over65Value = false
                        
                        if DoeWaiverModel!["RetireeReceivingPensionYesno"] as! String  == "1"{
                            pensionValue = true
                        }
                        if DoeWaiverModel!["RetirementSystem"] as! String  == "1"{
                            retirmentValue = true
                        }
                        if DoeWaiverModel!["OverAge"] as! String  == "1"{
                            over65Value = true
                        }
                        
                        let DoeWaiverformModel = ["RetireeReceivingPensionYesno": pensionValue,
                                                  "RetirementSystem": retirmentValue,
                                                  "OverAge": over65Value,
                                                  "WaiverText": WaiverText]  as [String : Any]
                        Param = [
                            "DoeEditWorkOrderModel": DoeEditWorkOrderModel,
                            "DoeApplicantModel": DoeApplicantModel,
                            "DoeCandidateModel": DoeCandidateModel,
                            "DoePayrateModel": DoePayrateModel,
                            "CreateOrderModel":CreateOrderModel,
                            "DoeSchoolProfessionalToRecruitModel": DoeSchoolProfessionalToRecruitModel,
                            "DoeScheduleModel": DoeScheduleModel,
                            "DoeWaiverformModel":DoeWaiverformModel]
                    }else{
                        Param = [
                            "DoeEditWorkOrderModel": DoeEditWorkOrderModel,
                            "DoeApplicantModel": DoeApplicantModel,
                            "DoeCandidateModel": DoeCandidateModel,
                            "DoePayrateModel": DoePayrateModel,
                            "CreateOrderModel":CreateOrderModel,
                            "DoeSchoolProfessionalToRecruitModel": DoeSchoolProfessionalToRecruitModel,
                            "DoeScheduleModel": DoeScheduleModel]
                    }
                    
                   
                }
            }
            else{
                let DoeApplicantModel = ["CandidateId": "0",
                                         "Type":"0",
                                         "ClientId":clientID,
                                         "DivId":DivisionId,
                                         "ContactId":ContactId,"ApplicationId":"0","NewApplicant":"0"]

                Param = ["CreateOrderModel":CreateOrderModel,
                         "DoeApplicantModel": DoeApplicantModel,
                         "DoeCandidateModel": DoeCandidateModel,
                          "DoeSchoolProfessionalToRecruitModel": DoeSchoolProfessionalToRecruitModel,
                         "DoeScheduleModel": DoeScheduleModel]
                
            }
            JustHUD.shared.showInView(view: self.view)

            print(Param)
            let urlString = RestAPI.BaseUrl+RestAPI.DOE_SaveOrder_URL
            
            RestAPI.postRequestWithToken(urlString: urlString, params: Param, callback: getSaveOrderResponse(response:))
            
        }else{
            isCancelOrder = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    func convertHTMLToString(valueString : String) -> String{
        
        
        var normalString = ""
        
        if valueString.count == 0 || valueString == nil{
            
        }else{
            normalString = valueString.replacingOccurrences(of: "<br/>", with: "\n")
        }
        return normalString
    }
    
    
    func formDatArrayForDetails(HeaderTitle: String, HeaderValue: String,isOrderSaved: Bool){
      
        dataArray.removeAllObjects()
        
        let defaults = UserDefaults.standard
       
        var scheduleValue = ""
        var endDate = ""
        var startDate = ""
        var TotalHours = ""
        var POBillRateValue = ""
        var TotalWorkOrderPOBilling = ""
        var TotalWorkOrderPayroll = ""
        var curntYrCal30k = ""
        var curntYrCal = ""
         var pensionValue = "No"
        var retirmentValue = "No"
        var over65Value = "No"
        var WaiverText = ""
        var schdule = ""
        var DailyCompensation = "0"
//        var FormatYtdCompensationCurrYear = "0"
//        var FormatCurrYearCompensationOver30k = "0"


        
        if defaults.object(forKey: "DoeApplicantModel") != nil{
            let decoded  = defaults.object(forKey: "DoeApplicantModel") as! Data
            let decodedApplicant = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Applicant
            selectedApplicant = decodedApplicant
        }
        
        if defaults.object(forKey: "TsApproverSupervisor") != nil{
            let decoded  = defaults.object(forKey: "TsApproverSupervisor") as! Data
            let decodedApplicant = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! DOEReportTo
            SelectedTSApproverSupervisor = decodedApplicant
        }
        if defaults.object(forKey: "AltApproveTimeslip") != nil{
            let decoded  = defaults.object(forKey: "AltApproveTimeslip") as! Data
            let decodedApplicant = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! DOEReportTo
            SelectedAltPersonToApproveTS = decodedApplicant
        }
        if defaults.object(forKey: "ApproveTimeslip") != nil{
            let decoded  = defaults.object(forKey: "ApproveTimeslip") as! Data
            let decodedApplicant = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! DOEReportTo
            SelectedPrimaryReasonToApproveTS = decodedApplicant
        }
        if defaults.object(forKey: "PersonToReport") != nil{
            let decoded  = defaults.object(forKey: "PersonToReport") as! Data
            let decodedApplicant = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! DOEReportTo
            SelectedPersonToReportTo = decodedApplicant
        }
        if defaults.object(forKey: "CertifyHours") != nil{
            let decoded  = defaults.object(forKey: "CertifyHours") as! Data
            let decodedApplicant = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! DOEReportTo
            SelectedFAMISPOCertifier = decodedApplicant
        }

        let Location = defaults.value(forKey: "Location")
        let PositionTitle = defaults.value(forKey: "PositionTitle")
        let PositionDescription = defaults.value(forKey: "PositionDescription")
        
        var ReferredConsultant = "School Professionals Recruited Consultant"
        if Int(selectedApplicant.CandidateId!)! == 0 && Int(selectedApplicant.ApplicationId!)! == 0 && Int(selectedApplicant.extraCandId!)! == 0 {

//        if (selectedApplicant.CandidateId?.count)! > 0 || (selectedApplicant.ApplicationId?.count)! > 0 {

        }else{
            ReferredConsultant =  String(format:"%@\n%@\n%@,%@ %@\n%@\n%@",selectedApplicant.Name!,selectedApplicant.Address!,selectedApplicant.City!,selectedApplicant.State!,selectedApplicant.Zip!,selectedApplicant.SSN!,selectedApplicant.Email!)

        }
        
        let reportToPerson = String(format:"%@\n%@\n%@,%@ %@\n%@\n%@",SelectedPersonToReportTo.Text!,SelectedPersonToReportTo.ContAddr!,SelectedPersonToReportTo.City!,SelectedPersonToReportTo.State!,SelectedPersonToReportTo.Zip!,SelectedPersonToReportTo.Phone!,SelectedPersonToReportTo.AddETo!)
        
        
        let personToApproveTimeSlip = String(format:"%@\n%@\n%@,%@ %@\n%@\n%@",SelectedPrimaryReasonToApproveTS.Text!,SelectedPrimaryReasonToApproveTS.ContAddr!,SelectedPrimaryReasonToApproveTS.City!,SelectedPrimaryReasonToApproveTS.State!,SelectedPrimaryReasonToApproveTS.Zip!,SelectedPrimaryReasonToApproveTS.Phone!,SelectedPrimaryReasonToApproveTS.AddETo!)
        
        let altvPersonToApproveTimeSlip = String(format:"%@\n%@\n%@,%@ %@\n%@\n%@",SelectedAltPersonToApproveTS.Text!,SelectedAltPersonToApproveTS.ContAddr!,SelectedAltPersonToApproveTS.City!,SelectedAltPersonToApproveTS.State!,SelectedAltPersonToApproveTS.Zip!,SelectedAltPersonToApproveTS.Phone!,SelectedAltPersonToApproveTS.AddETo!)
        
        let FAMISPOCertifier = String(format:"%@\n%@\n%@,%@ %@\n%@\n%@",SelectedFAMISPOCertifier.Text!,SelectedFAMISPOCertifier.ContAddr!,SelectedFAMISPOCertifier.City!,SelectedFAMISPOCertifier.State!,SelectedFAMISPOCertifier.Zip!,SelectedFAMISPOCertifier.Phone!,SelectedFAMISPOCertifier.AddETo!)
        
        let TimeslipApproverSupervisor = String(format:"%@\n%@\n%@,%@ %@\n%@\n%@",SelectedTSApproverSupervisor.Text!,SelectedTSApproverSupervisor.ContAddr!,SelectedTSApproverSupervisor.City!,SelectedTSApproverSupervisor.State!,SelectedTSApproverSupervisor.Zip!,SelectedTSApproverSupervisor.Phone!,SelectedTSApproverSupervisor.AddETo!)
        
        
        if defaults.dictionary(forKey: "DoeScheduleModel") != nil{
            
            let DoeScheduleModel = defaults.dictionary(forKey: "DoeScheduleModel")
              schdule = DoeScheduleModel!["Schedule"] as! String
              startDate = DoeScheduleModel!["StartDate"] as! String
              endDate = DoeScheduleModel!["EndDate"] as! String
              TotalHours = DoeScheduleModel!["TotalHours"] as! String
            if schdule == "s"{
                //single Day
                let WeekDayDict = DoeScheduleModel!["WeekDay"] as! [String: Any]
                let startTime = WeekDayDict["StartTime"] as! String
                let endTime = WeekDayDict["EndTime"] as! String
                scheduleValue = String(format:"Monday - Friday\n%@ - %@",startTime,endTime)
            }else{
                //multiday
//                var MonChecked  = "Off"
//                var TueChecked  =  "Off"
//                var WedChecked  =  "Off"
//                var ThuChecked  =  "Off"
//                var FriChecked  =  "Off"
//                var SatChecked  =  "Off"
//                var SunChecked  =  "Off"
                

                let MonTimeDict = DoeScheduleModel!["Monday"] as! [String: Any]
                let TueTimeDict = DoeScheduleModel!["Tuesday"] as! [String: Any]
                let WedTimeDict = DoeScheduleModel!["Wednesday"] as!  [String: Any]
                let ThuTimeDict = DoeScheduleModel!["Thursday"] as!  [String: Any]
                let FriTimeDict = DoeScheduleModel!["Friday"] as!  [String: Any]
                let SatTimeDict = DoeScheduleModel!["Saturday"] as!  [String: Any]
                let SunTimeDict = DoeScheduleModel!["Sunday"] as!  [String: Any]
                
                var MonTime  =  "Off"
                var TueTime  =  "Off"
                var WedTime  =  "Off"
                var ThuTime  =  "Off"
                var FriTime  =  "Off"
                var SatTime  =  "Off"
                var SunTime  =  "Off"
                
                if MonTimeDict["IsSchedule"] as! Bool == true{
                    MonTime  = String(format:"%@ - %@",MonTimeDict["StartTime"] as! String , MonTimeDict["EndTime"] as! String )
                }
                if TueTimeDict["IsSchedule"] as! Bool == true{
                    TueTime  =  String(format:"%@ - %@",TueTimeDict["StartTime"] as! String , TueTimeDict["EndTime"] as! String )
                }
                if WedTimeDict["IsSchedule"] as! Bool == true{
                    WedTime  =  String(format:"%@ - %@",WedTimeDict["StartTime"] as! String , WedTimeDict["EndTime"] as! String )
                }
                if ThuTimeDict["IsSchedule"] as! Bool == true{
                    ThuTime  =  String(format:"%@ - %@",ThuTimeDict["StartTime"] as! String , ThuTimeDict["EndTime"] as! String )
                }
                if FriTimeDict["IsSchedule"] as! Bool == true{
                    FriTime  =  String(format:"%@ - %@",FriTimeDict["StartTime"] as! String , FriTimeDict["EndTime"] as! String )
                }
                if SatTimeDict["IsSchedule"] as! Bool == true{
                    SatTime  =  String(format:"%@ - %@",SatTimeDict["StartTime"] as! String , SatTimeDict["EndTime"] as! String )
                }
                if SunTimeDict["IsSchedule"] as! Bool == true{
                    SunTime  =  String(format:"%@ - %@",SunTimeDict["StartTime"] as! String , SunTimeDict["EndTime"] as! String )
                }
                
                scheduleValue = String(format:"Sun    :   %@\nMon   :   %@\nTue    :   %@\nWed   :   %@\nThu    :   %@\nFri      :   %@\nSat     :   %@",SunTime,MonTime,TueTime,WedTime,ThuTime,FriTime,SatTime)

              }
        }
        
        
        if defaults.dictionary(forKey: "DoePayrateModel") != nil{
            
            let DoePayrateModel =  defaults.dictionary(forKey: "DoePayrateModel")
              PayRate = DoePayrateModel!["HourlyPayRate"] as! String
              POBillRateValue = DoePayrateModel!["PoBillRate"] as! String

        }
       

        if defaults.dictionary(forKey: "DoePayrateScheduleModel") != nil{
            var DoePayrateScheduleModel =  defaults.dictionary(forKey: "DoePayrateScheduleModel")
            TotalWorkOrderPayroll = String(format:"%.2f",Double(PayRate.replace(target: "$", withString: ""))! * Double(TotalHours)!)
            
            // DoePayratseScheduleModel!["WorkOrderPayRoll"] as! String
            WaiverNecessary = DoePayrateScheduleModel!["WaiverNecessary"] as! Bool
            curntYrCal = DoePayrateScheduleModel!["PayYearOne"] as! String
            curntYrCal30k = DoePayrateScheduleModel!["CurrYearCompensationOverThirtyK"] as! String
            if  curntYrCal30k.count == 0{
                if DoePayrateScheduleModel!["CurrYearCompensationOver30K"] != nil{
                    curntYrCal30k = DoePayrateScheduleModel!["CurrYearCompensationOver30K"] as! String}
            }
            if  curntYrCal30k.count == 0{
                curntYrCal30k = "0.00"
            }
//            DCSun = DoePayrateScheduleModel!["DailyCompensationSun"] as! String
//            DCMon = DoePayrateScheduleModel!["DailyCompensationMon"] as! String
//            DCTue = DoePayrateScheduleModel!["DailyCompensationTue"] as! String
//            DCWed = DoePayrateScheduleModel!["DailyCompensationWed"] as! String
//            DCThu = DoePayrateScheduleModel!["DailyCompensationThu"] as! String
//            DCFri = DoePayrateScheduleModel!["DailyCompensationFri"] as! String
//            DCSat = DoePayrateScheduleModel!["DailyCompensationSat"] as! String
            TotalWorkOrderPOBilling = String(format:"%.2f",Double(POBillRateValue.replace(target: "$", withString: ""))! * Double(TotalHours)!)
            DoePayrateScheduleModel!["WorkOrderPOBilling"] = TotalWorkOrderPOBilling
            DoePayrateScheduleModel!["WorkOrderPayRoll"] = TotalWorkOrderPayroll
            defaults.synchronize()
            //DoePayrateScheduleModel!["WorkOrderPOBilling"] as! String

            
//            Pay Rate* Total Work Order Hours = Total Work Order Payroll
//            PO Bill Rate *Total Work Order Hours  = Total Work Order/PO Billing
        }
        
      
        if defaults.dictionary(forKey: "DoeWaiverModel") != nil{
            let DoeWaiverModel  =  defaults.dictionary(forKey: "DoeWaiverModel")
            
            DailyCompensation =  DoeWaiverModel!["DailyCompensation"] as! String
 
              WaiverText = DoeWaiverModel!["WaiverText"] as! String
            
            if DoeWaiverModel!["RetireeReceivingPensionYesno"] as! String  == "1"{
                pensionValue = "Yes"
            }
            if DoeWaiverModel!["RetirementSystem"] as! String  == "1"{
                retirmentValue = "Yes"
            }
            if DoeWaiverModel!["OverAge"] as! String  == "1"{
                over65Value = "Yes"
            }
        }
        //////************ Header  ****************//////////
       

        let headerTitle = [boldHeaderTitle: HeaderTitle]
        let headerValue = [subTitle: HeaderValue]
        
        
        //////************Enter information about the consultant's position****************//////////
         let locTitle = [boldHeaderTitle:locHeader]
        
        let locDict = [lTitle:"Location",subTitle:Location]
        
        let posTitleDict = [lTitle:"Position Title",subTitle: PositionTitle]
        
        let posDescDict = [lTitle:"Position Description",subTitle: PositionDescription]
        
        //////************Tell us how the consultant is to be sourced****************//////////
        let refferTitle = [boldHeaderTitle:"Tell us how the consultant is to be sourced"]
        var ReferredConsultantTitle = "Referred Consultant"
        if ReferredConsultant == "School Professionals Recruited Consultant"{
            ReferredConsultantTitle = ""
        }
        let ReferredConsultantDict = [lTitle:ReferredConsultantTitle,subTitle:ReferredConsultant]
        
        //////************Tell us who the consultant will report to, who will approve their hours, and who will certify in FAMIS****************//////////
        let orderTitle = [boldHeaderTitle:"Tell us who the consultant will report to, who will approve their hours, and who will certify in FAMIS"]
        
 
        let reportToPersonDict = [lTitle:"Report To Person",subTitle:reportToPerson]
        
        let personToApproveTimeSlipDict = [lTitle:"Person To Approve Timeslip",subTitle:personToApproveTimeSlip]
        
        let altvPersonToApproveTimeSlipDict = [lTitle:"Alternate Person To Approve Timeslip",subTitle:altvPersonToApproveTimeSlip]
        
        let FAMISPOCertifierDict = [lTitle:"FAMIS PO Certifier",subTitle:FAMISPOCertifier]
        
        let TimeslipApproverSupervisorDict = [lTitle:"Timeslip Approver Supervisor",subTitle:TimeslipApproverSupervisor]
        
        //////************Tell us when you need them.****************//////////
        //                let ScheduleDict = ["Schedule":object["Schedule"].stringValue]
        let schduleTitle = [boldHeaderTitle:"Tell us when you need them."]
        
       
        let  ScheduleDict = [lTitle:"Schedule",subTitle:scheduleValue]
        
        //                let str = String(format:"%@ - %@",object["ScheduleStartTime"].stringValue,object["ScheduleEndTime"].stringValue)
        
        let ScheduleStartEndDateDict = [lTitle:"Start Date - End Date",subTitle:String(format:"%@ - %@",startDate,endDate)]
        
        let TotalWorkOrderHoursDict = [lTitle:"Total Work Order Hours",subTitle: TotalHours]
        
        //////************Please tell us how much to pay them****************//////////
        let payTitle = [boldHeaderTitle:"Please tell us how much to pay them"]
       
        var PayRateValue = PayRate
       
        if PayRate.contains("$"){
            PayRateValue = PayRateValue.replace(target: "$", withString: "")
        }
        let PayRateDict  = [lTitle:"Pay Rate",subTitle:String(format:"$%@",PayRateValue)]
        
        
        let  TotalWorkOrderPayrollDict = [lTitle:"Total Work Order Payroll",subTitle: String(format:"%@",TotalWorkOrderPayroll)]
        
        let POBillRate = [lTitle:"PO Bill Rate",subTitle: String(format:"%@",POBillRateValue)]
        
        let  TotalWorkOrderPOBillingDict = [lTitle:"Total Work Order/PO Billing",subTitle: String(format:"%@",TotalWorkOrderPOBilling)]
        if Int(selectedApplicant.CandidateId!)! == 0 && Int(selectedApplicant.ApplicationId!)! == 0 && Int(selectedApplicant.extraCandId!)! == 0{
            dataArray = [headerTitle,
                         headerValue,
                         locTitle,
                         locDict,
                         posTitleDict,
                         posDescDict,
                         refferTitle,
                         ReferredConsultantDict,
                         orderTitle,
                         reportToPersonDict,
                         personToApproveTimeSlipDict,
                         altvPersonToApproveTimeSlipDict,
                         FAMISPOCertifierDict,
                         TimeslipApproverSupervisorDict,
                         schduleTitle,
                         ScheduleDict,
                         ScheduleStartEndDateDict,
            TotalWorkOrderHoursDict]
            
        }else{
            
            dataArray = [headerTitle,
                         headerValue,
                         locTitle,
                         locDict,
                         posTitleDict,
                         posDescDict,
                         refferTitle,
                         ReferredConsultantDict,
                         orderTitle,
                         reportToPersonDict,
                         personToApproveTimeSlipDict,
                         altvPersonToApproveTimeSlipDict,
                         FAMISPOCertifierDict,
                         TimeslipApproverSupervisorDict,
                         schduleTitle,
                         ScheduleDict,
                         ScheduleStartEndDateDict,
                         TotalWorkOrderHoursDict,
                         payTitle,
                         PayRateDict,
                         TotalWorkOrderPayrollDict,
                         POBillRate,
                         TotalWorkOrderPOBillingDict]
        }
        /////************Waiver Needed*************//////
        
        if WaiverNecessary == true{
            let waiverTitle = [boldHeaderTitle:"Waiver Needed"]
            let prevDOEObj = Constants.DOEResponseObject
            let  DailyCompensationDict = [lTitle:prevDOEObj["DailyCompensationText"].stringValue,subTitle:DailyCompensation]
            let curntYrCalDict = [lTitle:prevDOEObj["FormatYtdCompensationNextYearText"].stringValue,subTitle: String(format:"$%@",curntYrCal)]
            let curntYrCal30kDict = [lTitle:prevDOEObj["FormatCurrYearCompensationOver30kText"].stringValue,subTitle: String(format:"$%@",curntYrCal30k)]
            
            let pensionDict = [lTitle:prevDOEObj["ConsultantPensionText"].stringValue,subTitle: pensionValue]
            let retirmentDict = [lTitle:prevDOEObj["ConsultantPriortoMayText"].stringValue,subTitle: retirmentValue]
            let over65Dict = [lTitle:prevDOEObj["ConsultantOver65Text"].stringValue,subTitle: over65Value]
            let WaiverExplanationDict = [lTitle:"WaiverExplanation",subTitle: WaiverText ]

            dataArray.add(waiverTitle)
            dataArray.add(DailyCompensationDict)
            dataArray.add(curntYrCalDict)
            dataArray.add(curntYrCal30kDict)
            dataArray.add(pensionDict)
            dataArray.add(retirmentDict)
            dataArray.add(over65Dict)
            dataArray.add(WaiverExplanationDict)
            
        }
        if self.OrderID > 0{
            let buttonDict = [lTitle:"Buttons",subTitle: "Return To Order List" ]
            dataArray.add(buttonDict)

        }else{
            let buttonDict = [lTitle:"Buttons",subTitle: "" ]
            dataArray.add(buttonDict)
        }
        
        detailsTableView.reloadData()
    }
    
    //MARK: Navigation
    func PushToDashboard()
    {
        
        var isControllerExists = false
 var vc = UIViewController()
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DashboardViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    vc = viewController
                     break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DashboardSegue") as! DashboardViewController
             self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            let nextVC : DashboardViewController = vc as! DashboardViewController
            self.navigationController?.popToViewController(nextVC, animated: true)
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
            
            let info = ["OrderID":"\(self.OrderID)","isFromDOEROS":"0"]
            
            NotificationCenter.default.post(name: Notification.Name("PushToDOESchdulePageFromDetails"), object: nil, userInfo: info)

            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOESchduleSegue") as! DOESchduleViewController
            nextViewController.orderID = "\(self.OrderID)"
            nextViewController.WaiverNecessary = WaiverNecessary
             if isFromHistoricalOrder == true{
            nextViewController.isFromSummaryPage = false
            }else{
                nextViewController.isFromSummaryPage = true
            }
            nextViewController.isFromHistoricOrder = isFromHistoricalOrder

            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }else {
 
            let vc1:DOESchduleViewController = vc as! DOESchduleViewController
             vc1.orderID = "\(self.OrderID)"
            vc1.WaiverNecessary = WaiverNecessary
            if isFromHistoricalOrder == true{
                vc1.isFromSummaryPage = false
            }else{
                vc1.isFromSummaryPage = true
            }
            vc1.isFromHistoricOrder = isFromHistoricalOrder
            self.navigationController?.popToViewController(vc1, animated: true)

        }
        
    }
    func pushToLocationPage(){
        var isControllerExists = false
        var vc = UIViewController()
        

        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOEConsultantPosTableViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    vc = viewController
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOEConsultantPosSegue") as! DOEConsultantPosTableViewController
            nextViewController.isFromSummaryPage = self.isFromROSDOE
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
//            vc = UIViewController.self as! DOEConsultantPosTableViewController
            let vc1:DOEConsultantPosTableViewController = vc as! DOEConsultantPosTableViewController
            vc1.isFromSummaryPage = self.isFromROSDOE

            self.navigationController?.popToViewController(vc1, animated: true)
        }
        
    }
    func pushToReferConsultantPage(){
        var isControllerExists = false
        var vc = UIViewController()

        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOEConsultantSourcedViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    vc = viewController
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOEConsultantSourcedSegue") as! DOEConsultantSourcedViewController
            nextViewController.isFromSummaryPage = true
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            let vc1:DOEConsultantSourcedViewController = vc as! DOEConsultantSourcedViewController
            vc1.isFromSummaryPage = true

            self.navigationController?.popToViewController(vc1, animated: true)

        }
    }
    func pushToPayratePage(){
        
        var isControllerExists = false
        var vc = UIViewController()

        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOEPayrateViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    vc = viewController
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOEPayrateViewControllerSegue") as! DOEPayrateViewController
            nextViewController.isFromSummaryPage = true
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            let vc1:DOEPayrateViewController = vc as! DOEPayrateViewController
            vc1.isFromSummaryPage = true

            self.navigationController?.popToViewController(vc1, animated: true)

        }
    }
    func pushToWaiverPage(){
        var isControllerExists = false
        var vc = UIViewController()

        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOEWaiverFormTableViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    vc = viewController
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOEWaiverFormSegue") as! DOEWaiverFormTableViewController
            nextViewController.isFromSummaryPage = true
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            let vc1:DOEWaiverFormTableViewController = vc as! DOEWaiverFormTableViewController
            vc1.isFromSummaryPage = true

            self.navigationController?.popToViewController(vc1, animated: true)

        }
        
        
    }
    func pushToOrderPage(){
        var isControllerExists = false
        var vc = UIViewController()

        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOEChooseConsultantReportToViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    vc = viewController
                    break
                }
            }
        }
     
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOEChooseConsultantReportToSegue") as! DOEChooseConsultantReportToViewController
            nextViewController.isFromSummaryPage = true
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            let vc1:DOEChooseConsultantReportToViewController = vc as! DOEChooseConsultantReportToViewController
            vc1.isFromSummaryPage = true
            self.navigationController?.popToViewController(vc1, animated: true)
        }
    }
    func pushToROSDOEPage(){
        self.clearDOEData()
        var isControllerExists = false
        var vc = UIViewController()
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOEConsultantPosTableViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    vc = viewController
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOEConsultantPosSegue") as! DOEConsultantPosTableViewController
            nextViewController.isFromSummaryPage = true
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            let vc1:DOEConsultantPosTableViewController = vc as! DOEConsultantPosTableViewController
            vc1.isFromSummaryPage = true
            self.navigationController?.popToViewController(vc1, animated: true)
        }
        
    }
    func pushToOrderListPage(){
        self.clearDOEData()
        var isControllerExists = false
        var vc = UIViewController()
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is HistoricOrderViewController {
                    print("Your controller exist")
                    vc = viewController
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HistoricOrderSegue") as! HistoricOrderViewController
             self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }else{
            
            self.navigationController?.popToViewController(vc, animated: true)
        }
    }
    func clearDOEData(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "PositionTitle")
        defaults.removeObject(forKey: "PositionDescription")
        defaults.removeObject(forKey: "LocationCode")
        defaults.removeObject(forKey: "Location")
        
        defaults.removeObject(forKey: "DoeApplicantModel")
        
        defaults.removeObject(forKey: "DoeScheduleModel")
        
        defaults.removeObject(forKey: "ApproveTimeslip")
        defaults.removeObject(forKey: "AltApproveTimeslip")
        defaults.removeObject(forKey: "TsApproverSupervisor")
        defaults.removeObject(forKey: "PersonToReport")
        defaults.removeObject(forKey: "CertifyHours")
        
        defaults.removeObject(forKey: "DoePayrateModel")
        
        defaults.removeObject(forKey: "DoePayrateScheduleModel")
        
        defaults.removeObject(forKey: "DoeWaiverModel")
        
        defaults.synchronize()
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("PushToDOESchdulePageFromDetails"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("PushToDOEReferConsultantPageFromDetails"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("PushToDOEOrderPageFromDetails"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("PushToDOEPayratePageFromDetails"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("PushToWaiverPageFromDetails"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("PushToDOELocationPageFromDetails"), object: nil)
        
 

    }
}
/*
 {
 "MessageStatus" : 1,
 "ApproveStatus" : 0,
 "ScheduleType" : "s",
 "OrderId" : 897138,
 "AlternativePersonApproveTimeSlip" : "JOHN SMITH<br\/>420 Lexington Avenue<br\/>New York,NY 10170<br\/>(212) 555-5555<br\/>jsmith@schools.nyc.gov",
 "ShowApproved" : false,
 "DCMon" : "$1,050.00",
 "PoBilling" : "$0.00",
 "DenyShowHide" : "visible",
 "ApproveShowHide" : "visible",
 "ScheduleSat" : " - ",
 "FiscalYearCompensation" : "$0.00",
 "DateInfo" : "12\/3\/2017 - 12\/3\/2017",
 "WaiverExplanation" : "test",
 "ContactId" : 0,
 "DCWed" : "$1,050.00",
 "CompensationCurrentYear30K" : "$2,449.38",
 "DCThu" : "$1,050.00",
 "Rational" : "",
 "ShowApprove" : 0,
 "CompensationCurrentYear" : "$32,449.38",
 "ApproveTimeSlip" : "Keith Delaski12<br\/>420 Lexington Avenue<br\/>New York,NY 10170<br\/>(111) 111-1111<br\/>ksdelaski@gmail.com",
 "Retirement" : "No",
 "PayRate" : "$150.00",
 "YtdCompensionNextYear" : 0,
 "DCSun" : "$0.00",
 "ScheduleSun" : " - ",
 "ScheduleEndTime" : "03:30 PM",
 "NewOrderId" : 0,
 "ScheduleFri" : " - ",
 "MessageColor" : 0,
 "DCFri" : "$1,050.00",
 "Candidate_Name" : "Test Consultant<br\/>Test<br\/>test,NY 10710<br\/>111-111-1111  <br\/>test@test.com",
 "DivisionCount" : 0,
 "Order_Placer" : "Prasad Kadrikar<br\/>420 Lexington Avenue<br\/>New York,NY 10170<br\/>(212) 916-0831<br\/>pkadrikar@tempositions.com",
 "Email" : "pkadrikar@tempositions.com",
 "ScheduleTue" : " - ",
 "ScheduleWed" : " - ",
 "ScheduleHour" : "7",
 "ScheduleMon" : " - ",
 "FiscalYearCompensation30K" : "$0.00",
 "ProjectedFiscalYearYtdCompensation" : "$32,449.38",
 "ShowDenied" : false,
 "PoBillRate" : "$181.36",
 "WorkOrderPayRoll" : "$0.00",
 "LocationCode" : "00TEST",
 "Location" : "00TEST<br\/>Test Location Code<br\/>420 Lexington Avenue<br\/>New York, NY 10170",
 "ShowDeny" : 0,
 "Reportto" : "John Principal<br\/>420 Lexington Avenue<br\/>New York,NY 10170<br\/><br\/>tempositionsdemo@gmail.com",
 "ConsultantAge" : "No",
 "Position_Description" : "testing please ignore it",
 "errorStatus" : false,
 "WaiverNecessary" : true,
 "WaiverStatus" : 0,
 "DCTue" : "$1,050.00",
 "FamisProCertifier" : "Keith Delaski12<br\/>420 Lexington Avenue<br\/>New York,NY 10170<br\/>(111) 111-1111<br\/>ksdelaski@gmail.com",
 "ClientID" : 0,
 "ScheduleThu" : " - ",
 "OrderHours" : "0",
 "ErrorMessage" : "hidden",
 "ShowPend" : 0,
 "IsModel" : false,
 "DCSat" : "$0.00",
 "Position_Title" : "Testing ",
 "ShowPending" : false,
 "Pension" : "No",
 "TimeSlipApproverSupervisor" : "John Principal<br\/>420 Lexington Avenue<br\/>New York,NY 10170<br\/><br\/>tempositionsdemo@gmail.com",
 "Status" : 0,
 "ScheduleStartTime" : "08:00 AM"
 }
 
 */
