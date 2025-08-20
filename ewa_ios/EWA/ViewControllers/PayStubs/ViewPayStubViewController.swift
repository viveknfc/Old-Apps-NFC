//
//  ViewPayStubViewController.swift
//  EWA
//
//  Created by NFC India on 25/09/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import PDFReader

class ViewPayStubViewController: BaseViewController {
    
    @IBOutlet weak var tableBottom: NSLayoutConstraint!
    var paySubObjects:JSON = JSON.null
    var printPayStub:JSON = JSON.null
    var payStubs = [PayStubDetails]()
    @IBOutlet weak var payStubTableView: UITableView!
    var checkNumber = String()
    var companyId = Int()
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var messagwButton: UIBarButtonItem!
    
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    var ASHTSkipStatus = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateNavigationBarColor()
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        //  self.title = "View Pay Stubs"
        self.changeNavigationTitle("View Pay Stubs")
        if #available(iOS 11.0, *) {
            payStubTableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        
        // calling the api to get all the paystubs
        ASHTSkipStatus = 0
        getPayStubs()
        
        //registering notification to load objects from viewPayStubs
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(viewPayStubDetails(notfication:)), name: Notification.Name("viewPayStub"), object: nil)
        
        if UserDefaults.standard.integer(forKey:"EmployeeType") == 1
        {
            navigationItem.deleteFromRightBar(item: messagwButton)
            navigationItem.deleteFromRightBar(item: logOutButton)
        }
        
    }
    
    
    
    
    @objc func viewPayStubDetails(notfication: NSNotification) {
        
        companyId = (notfication.userInfo!["companyID"] as? Int)!
        checkNumber = (notfication.userInfo!["checkNumber"] as? String)!
        
        payStubTableView.setContentOffset(.zero, animated: true)
        // calling the api to get all the paystubs
        ASHTSkipStatus = 0
        getPayStubs()
    }
    
    //MARK:- Change Navigation Title
    func changeNavigationTitle(_ titleStr: String) {
        let tlabel = UILabel()
        tlabel.text = titleStr
        tlabel.textColor = UIColor.white
        tlabel.font = UIFont.systemFont(ofSize:17)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.textAlignment = .left
        tlabel.numberOfLines = 0
        tlabel.minimumScaleFactor = 0.5
        self.navigationItem.titleView = tlabel
    }
    
    
    //function to get paystubs
    func getPayStubs()  {
        self.changeNavigationTitle("View Pay Stubs")
        if ConnectionCheck.isConnectedToNetwork()
        {
            
            ServerService.showActivityIndicatory(uiView:self.view)
            let params = ["CandidateId":UserDefaults.standard.object(forKey:"cID") as! String, "EmployeeName":UserDefaults.standard.object(forKey:"CandName") as! String,"DivisionId":UserDefaults.standard.object(forKey:"dID") as! String,"EmployeeType":UserDefaults.standard.object(forKey:"EmployeeType") as! Int ,"CheckNumber":checkNumber, "CompanyId":companyId, "ASHTSkipStatus":"\(ASHTSkipStatus)"] as [String : Any]
            print(params)
            ServerService.getPayStubs(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.getPayStubsDetails(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            
        }
        
    }
    
    //getting allPayStubsList
    func getPayStubsDetails(response:AnyObject)->()
    {
        payStubs.removeAll()
        ServerService.hideProgressView()
        paySubObjects = response as! JSON
        print(paySubObjects)
        errorMessageLabel.text = paySubObjects["Message"].stringValue
        
        if paySubObjects["Status"].string == "Fail"
        {
            tableBottom.constant = 0
            payStubTableView.backgroundColor = .clear
            companyId = paySubObjects["CompanyId"].intValue
            checkNumber = paySubObjects["CheckNumber"].stringValue
            payStubTableView.reloadData()
            payStubTableView.backgroundColor = .clear
            
            if paySubObjects["FormName"].stringValue.count>0
            {
                if paySubObjects["LynkType"].intValue > 0 && paySubObjects["File"].stringValue.count > 5{
                    Constants.LinkUrl = paySubObjects["File"].stringValue
                    Constants.LinkText = paySubObjects["FormName"].stringValue
                    Constants.iSFormOkRequired = false
                    Constants.ShowStandAlone = true
                    self.pushToStandAlone()
                }
                else {
                    self.changeNavigationTitle(paySubObjects["Title"].stringValue)
                    
                    if paySubObjects["FormName"].stringValue == "ACA1095CConsent"
                    {
                        let formView = Bundle.main.loadNibNamed("ACAConsent", owner: nil, options: nil)![0] as! ACAConsent
                        formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height)
                        formView.payStubDetails = paySubObjects
                        formView.loadForm()
                        formView.setUp()
                        formView.acaDelegate = self
                        self.view.addSubview(formView)
                        self.view.bringSubview(toFront:formView)
                    }
                    else if paySubObjects["FormName"].stringValue == "ACA1095CConsent"
                    {
                        
                        let formView = Bundle.main.loadNibNamed("ACAElectronicDelivery", owner: nil, options: nil)![0] as! ACAElectronicDelivery
                        formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height)
                        formView.payStubDetails = paySubObjects
                        formView.loadForm()
                        formView.acaDelegate = self
                        self.view.addSubview(formView)
                        self.view.bringSubview(toFront:formView)
                        
                    }
                    else if paySubObjects["FormName"].stringValue == "PayCardChangeAcknowledgementForm"
                    {
                        
                        let formView = Bundle.main.loadNibNamed("PayCard", owner: nil, options: nil)![0] as! PayCrad
                        formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height)
                        formView.payStubDetails = paySubObjects
                        formView.payCardDelegate = self
                        self.view.addSubview(formView)
                        self.view.bringSubview(toFront:formView)
                        
                    }
                    else if paySubObjects["FormName"].stringValue == "WageRateForm"
                    {
                        let formView = Bundle.main.loadNibNamed("WageRate", owner: nil, options: nil)![0] as! WageRate
                        formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height)
                        formView.object = paySubObjects
                        formView.setUp()
                        formView.wagRateDelegate = self
                        self.view.addSubview(formView)
                        self.view.bringSubview(toFront:formView)
                    }
                    else if paySubObjects["FormName"].stringValue == "CaliforniaWageRateForm"
                    {
                        let formView = Bundle.main.loadNibNamed("CAWageRate", owner: nil, options: nil)![0] as! CAWageRate
                        formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height)
                        formView.object = paySubObjects
                        formView.setUp()
                        formView.caWageRateDelegate = self
                        self.view.addSubview(formView)
                        self.view.bringSubview(toFront:formView)
                    }
                    
                    else if paySubObjects["FormName"].stringValue == Constants.A1Form {
                        let VC = A1FormController(nibName: "A1FormController", bundle: nil)
                        VC.object = paySubObjects
                        let navi = BaseNaviViewController(rootViewController:VC)
                        navi.navigationBar.tintColor = .white
                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"A1FormController")
                    }
                    else if paySubObjects["FormName"].stringValue == Constants.A2Form {
                        let VC = A2FormController(nibName: "A2FormController", bundle: nil)
                        VC.object = paySubObjects
                        let navi = BaseNaviViewController(rootViewController:VC)
                        navi.navigationBar.tintColor = .white
                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"A2FormController")
                    }
                    else if paySubObjects["FormName"].stringValue == Constants.SCRConsent {
                        let VC = SCRConsent(nibName: "SCRConsent", bundle: nil)
                        VC.object = JSON(["FormName":Constants.SCRName])
                        VC.fromSideMenu = false
                        let navi = BaseNaviViewController(rootViewController:VC)
                        navi.navigationBar.tintColor = .white
                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"SCRConsent")
                        
                    }
                    else if paySubObjects["FormName"].stringValue == Constants.SCRForm{
                        let VC = SCRConsentInfoController(nibName: "SCRConsentInfoController", bundle: nil)
                        VC.object = JSON(["FormName":Constants.SCRName])
                        VC.fromSideMenu = false
                        let navi = BaseNaviViewController(rootViewController:VC)
                        navi.navigationBar.tintColor = .white
                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"SCRConsentInfoController")
                    }
                    else
                    {
                        let formView = Bundle.main.loadNibNamed("FormView", owner: nil, options: nil)![0] as! FormView
                        formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height)
                        formView.formsObject = paySubObjects
                        formView.loadForm()
                        formView.formDelegate = self
                        
                        self.view.addSubview(formView)
                        self.view.bringSubview(toFront:formView)
                    }
                }
            }
        }
        else
        {
            
            if paySubObjects["MasterList"].arrayValue.count>0
            {
                tableBottom.constant = 50
                // paySubObjects["ShowPaystubs"].boolValue = true
                for p in 0..<paySubObjects["MasterList"].arrayValue.count
                {
                    var earningArray = [Earnings]()
                    for e in 0..<paySubObjects["MasterList"][p]["PayStubsList"].arrayValue.count
                    {
                        //PayStubsList
                        let earnig = Earnings.init(code: paySubObjects["MasterList"][p]["PayStubsList"][e]["Code"].stringValue, division: paySubObjects["MasterList"][p]["PayStubsList"][e]["Division"].stringValue, description: paySubObjects["MasterList"][p]["PayStubsList"][e]["Description"].stringValue, units: String(format:"%.2f",paySubObjects["MasterList"][p]["PayStubsList"][e]["Units"].doubleValue), rate: String(format:"%.2f",paySubObjects["MasterList"][p]["PayStubsList"][e]["Rate"].doubleValue), earnings: String(format:"%.2f",paySubObjects["MasterList"][p]["PayStubsList"][e]["Earnings"].doubleValue))
                        earningArray.append(earnig)
                    }
                    var miscArray = [MiscAdjustments]()
                    for m in 0..<paySubObjects["MasterList"][p]["MiscAdjustmentList"].arrayValue.count
                    {
                        //MiscAdjustmentList
                        let misc = MiscAdjustments.init(ytd:String(format:"%.2f",paySubObjects["MasterList"][p]["MiscAdjustmentList"][m]["Amount"].doubleValue), adjustments: paySubObjects["MasterList"][p]["MiscAdjustmentList"][m]["Description"].stringValue)
                        miscArray.append(misc)
                    }
                    var clientDetails = [ClientDetails]()
                    var code = String()
                    for c in 0..<paySubObjects["MasterList"][p]["PayStubsList"].arrayValue.count
                    {
                        // clientDetails
                        
                        if code ==  paySubObjects["MasterList"][p]["PayStubsList"][c]["Code"].stringValue
                        {
                            
                        }
                        else
                        {
                            let clientD = ClientDetails.init(code: paySubObjects["MasterList"][p]["PayStubsList"][c]["Code"].stringValue, clientName: paySubObjects["MasterList"][p]["PayStubsList"][c]["Client"].stringValue, clientAddress: paySubObjects["MasterList"][p]["PayStubsList"][c]["ClientAddress"].stringValue, clientPhone: paySubObjects["MasterList"][p]["PayStubsList"][c]["ClientPhone"].stringValue, regRate: String(format:"%.2f",paySubObjects["MasterList"][p]["PayStubsList"][c]["Rate"].doubleValue), otRate: String(format:"%.2f",paySubObjects["MasterList"][p]["PayStubsList"][c]["OTRate"].doubleValue), doubleTimeRate:String(format:"%.2f",paySubObjects["MasterList"][p]["PayStubsList"][c]["DoubleTimeRate"].doubleValue), totalHours: String(format:"%.2f",paySubObjects["MasterList"][p]["PayStubsList"][c]["ClientHours"].doubleValue))
                            code =  paySubObjects["MasterList"][p]["PayStubsList"][c]["Code"].stringValue
                            clientDetails.append(clientD)
                        }
                    }
                    
                    
                    
                    
                    let payStubDetsils = PayStubDetails.init(legalName: paySubObjects["MasterList"][p]["PayStubsList"][0]["NameOfEmployer"].stringValue, localOffice: paySubObjects["MasterList"][p]["PayStubsList"][0]["EmployeeAddrPhnnmbr"].stringValue, empName: paySubObjects["MasterList"][p]["PayStubsList"][0]["EmpName"].stringValue, ssn: paySubObjects["MasterList"][p]["PayStubsList"][0]["Ssn"].stringValue, payPeriod: paySubObjects["MasterList"][p]["PayStubsList"][0]["PayPeriod"].stringValue, checkDate: paySubObjects["MasterList"][p]["PayStubsList"][0]["ChekDate"].stringValue, checkNumber: paySubObjects["MasterList"][p]["PayStubsList"][0]["ChekNumber"].stringValue, grossPay: String(format:"%.2f", paySubObjects["MasterList"][p]["PayStubsList"][0]["GrossPay"].doubleValue), fica:String(format:"%.2f", paySubObjects["MasterList"][p]["PayStubsList"][0]["FICA"].doubleValue), medicare: String(format:"%.2f", paySubObjects["MasterList"][p]["PayStubsList"][0]["Medicare"].doubleValue), fit: String(format:"%.2f", paySubObjects["MasterList"][p]["PayStubsList"][0]["FIT"].doubleValue), state: String(format:"%.2f", paySubObjects["MasterList"][p]["PayStubsList"][0]["State"].doubleValue), city: String(format:"%.2f", paySubObjects["MasterList"][p]["PayStubsList"][0]["City"].doubleValue), disabilityPaid: String(format:"%.2f", paySubObjects["MasterList"][p]["PayStubsList"][0]["Disability"].doubleValue), forOneK:String(format:"%.2f",paySubObjects["MasterList"][p]["PayStubsList"][0]["FournotoneK"].doubleValue),earningArry:earningArray, miscs:miscArray,totalHour:String(format:"%.2f",paySubObjects["MasterList"][p]["PayStubsList"][0]["TotalHours"].doubleValue),totalHourDA:String(format:"%.2f", paySubObjects["MasterList"][p]["PayStubsList"][0]["TTldedTTlAdj"].doubleValue),netPay:String(format:"%.2f", paySubObjects["MasterList"][p]["PayStubsList"][0]["NetPay"].doubleValue),grossPayYTD:String(format:"%.2f", paySubObjects["MasterList"][p]["PayStubsList"][0]["YtdGrossPay"].doubleValue),ficaYTD:String(format:"%.2f", paySubObjects["MasterList"][p]["PayStubsList"][0]["YtdFICA"].doubleValue),medicareYTD:String(format:"%.2f",paySubObjects["MasterList"][p]["PayStubsList"][0]["YtdMedicare"].doubleValue),fitYTD:String(format:"%.2f",paySubObjects["MasterList"][p]["PayStubsList"][0]["YtdFIT"].doubleValue),stateYTD:String(format:"%.2f",paySubObjects["MasterList"][p]["PayStubsList"][0]["YtdState"].doubleValue),cityYTD:String(format:"%.2f", paySubObjects["MasterList"][p]["PayStubsList"][0]["YtdCity"].doubleValue),disabilityPaidYTD:String(format:"%.2f", paySubObjects["MasterList"][p]["PayStubsList"][0]["YtdDisability"].doubleValue),forOneKYTD:String(format:"%.2f", paySubObjects["MasterList"][p]["PayStubsList"][0]["YtdFournotoneK"].doubleValue),note:paySubObjects["MasterList"][p]["Note"].stringValue,ASTHFUIC:String(format:"%.2f",paySubObjects["MasterList"][p]["CAEmpModel"]["AccruedSickTimeHoursForUseInCalifornia"].doubleValue),ASTHFUIS:String(format:"%.2f",paySubObjects["MasterList"][p]["CAEmpModel"]["AccruedSickTimeHoursForUseInSanFrancisco"].doubleValue),ASTHFUIO:String(format:"%.2f",paySubObjects["MasterList"][p]["CAEmpModel"]["AccruedSickTimeHoursForUseInOakland"].doubleValue),ASTHFUIE:String(format:"%.2f",paySubObjects["MasterList"][p]["CAEmpModel"]["AccruedSickTimeHoursForUseInEmeryville"].doubleValue),STAFUIC:String(format:"%.2f",paySubObjects["MasterList"][p]["CAEmpModel"]["SickTimeAvailableForUseInCalifornia"].doubleValue),STAFUIS:String(format:"%.2f",paySubObjects["MasterList"][p]["CAEmpModel"]["SickTimeAvailableForUseInSanFrancisco"].doubleValue),STAFUIO:String(format:"%.2f",paySubObjects["MasterList"][p]["CAEmpModel"]["SickTimeAvailableForUseInOakland"].doubleValue),STAFUIE:String(format:"%.2f",paySubObjects["MasterList"][p]["CAEmpModel"]["SickTimeAvailableForUseInEmeryville"].doubleValue),isCAEmpl:paySubObjects["MasterList"][p]["IsCAEmpl"].boolValue,clientDetails:clientDetails)
                    
                    payStubs.append(payStubDetsils)
                }
                
            }
            else
            {
                tableBottom.constant = 0
                if errorMessageLabel.text?.count==0
                {
                    errorMessageLabel.text = "No Records Found"
                }
                payStubTableView.backgroundColor = .clear
            }
            companyId = paySubObjects["CompanyId"].intValue
            checkNumber = paySubObjects["CheckNumber"].stringValue
            payStubTableView.reloadData()
        }
    }
    @IBAction func viewPayStub(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"payStub") as? PayStubsViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func printAction(_ sender: Any) {
        
        //getPdf's
        if ConnectionCheck.isConnectedToNetwork()
        {
            
            ServerService.showActivityIndicatory(uiView:self.view)
            let params = ["CandidateId":UserDefaults.standard.object(forKey:"cID") as! String, "EmployeeName":UserDefaults.standard.object(forKey:"CandName") as! String,"DivisionId":UserDefaults.standard.object(forKey:"dID") as! String,"EmployeeType":UserDefaults.standard.object(forKey:"EmployeeType") as! Int ,"CheckNumber":checkNumber.replacingOccurrences(of: " ", with: ""), "CompanyId":companyId,"Ssn":paySubObjects["Ssn"].stringValue.replacingOccurrences(of: " ", with: "")] as [String : Any]
            print(params)
            ServerService.printPayStub(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.getPrintPayStubsDetails(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            
        }
    }
    
    
    //getting pdfData
    func getPrintPayStubsDetails(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        printPayStub = response as! JSON
        print(printPayStub)
        if printPayStub["Status"].intValue == 1
        {
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let privacyViewController = mainStoryboard.instantiateViewController(withIdentifier: "pVC") as! PrivacyPolicyViewController
            privacyViewController.link = printPayStub["PDFFileName"].stringValue
            privacyViewController.headerText = "Pay Stub"
            Constants.iSFormOkRequired = false
            privacyViewController.isPush = true
            self.navigationController?.pushViewController(privacyViewController, animated: true)
            
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage:"", title:printPayStub["Message"].stringValue, view:self)
        }
        
    }
    /// Initializes a document with the remote url of the pdf
    private func document(_ remoteURL: URL) -> PDFDocument? {
        return PDFDocument(url: remoteURL)
    }
    
    
    /// Presents a document
    ///
    /// - parameter document: document to present
    ///
    /// Add `thumbnailsEnabled:false` to `createNew` to not load the thumbnails in the controller.
    private func showDocument(_ document: PDFDocument) {
        let image = UIImage(named: "")
        let controller = PDFViewController.createNew(with: document, title: "Pay Stub", actionButtonImage: image, actionStyle: .activitySheet)
        navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func messagesAction(_ sender: Any) {
        //message
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"message") as? MessagesViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func handleNavgationBarButtonTap(_ sender: UIBarButtonItem, event: UIEvent)
    
    {
        Constants.showUp(event:event,viewController:self)
        
    }
    
    
}


//UITableView DataSource and Delegate Methods

extension ViewPayStubViewController:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payStubs.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if payStubs[indexPath.row].isCAEmpl
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:"payCalCell") as! ViewPayStubTableViewCell
            cell.legalName.text = payStubs[indexPath.row].legalName
            cell.localOffice.text = payStubs[indexPath.row].localOffice
            cell.empName.text = " "+payStubs[indexPath.row].empName
            cell.ssnNumber.text = " "+payStubs[indexPath.row].ssn
            cell.payPeriod.text = " "+payStubs[indexPath.row].payPeriod
            cell.checkDate.text = " "+payStubs[indexPath.row].checkDate
            cell.checkNumber.text = " "+payStubs[indexPath.row].checkNumber
            cell.grossPay.text = payStubs[indexPath.row].grossPay
            cell.fica.text = payStubs[indexPath.row].fica
            cell.medicare.text = payStubs[indexPath.row].medicare
            cell.fit.text = payStubs[indexPath.row].fit
            cell.state.text = payStubs[indexPath.row].state
            cell.city.text = payStubs[indexPath.row].city
            cell.disabilitypay.text = payStubs[indexPath.row].disabilityPaid
            cell.fortyOneK.text = payStubs[indexPath.row].forOneK
            cell.totalHour.text = " "+payStubs[indexPath.row].totalHour
            cell.totalDandA.text = " "+payStubs[indexPath.row].totalHourDA
            cell.netpay.text = " "+payStubs[indexPath.row].netPay
            cell.ytdGross.text = payStubs[indexPath.row].grossPayYTD
            cell.ficaYTD.text = payStubs[indexPath.row].ficaYTD
            cell.medicareYTD.text = payStubs[indexPath.row].medicareYTD
            cell.fitYTD.text = payStubs[indexPath.row].fitYTD
            cell.ytdCity.text = payStubs[indexPath.row].cityYTD
            cell.ytdState.text = payStubs[indexPath.row].stateYTD
            cell.ytdDisability.text = payStubs[indexPath.row].disabilityPaidYTD
            cell.ytdForOneK.text = payStubs[indexPath.row].forOneKYTD
            cell.earningsArray = payStubs[indexPath.row].earningArry
            cell.miscArray = payStubs[indexPath.row].miscs
            cell.clientDetails = payStubs[indexPath.row].clientDetails
            cell.caAH.text = payStubs[indexPath.row].STAFUIC
            cell.sfAH.text = payStubs[indexPath.row].STAFUIS
            cell.okAH.text = payStubs[indexPath.row].STAFUIO
            cell.emAH.text = payStubs[indexPath.row].STAFUIE
            cell.caACH.text = payStubs[indexPath.row].ASTHFUIC
            cell.sfACH.text = payStubs[indexPath.row].ASTHFUIS
            cell.okACH.text = payStubs[indexPath.row].ASTHFUIO
            cell.emACH.text = payStubs[indexPath.row].ASTHFUIE
            
            var attributes = [NSAttributedStringKey: AnyObject]()
            attributes[.foregroundColor] = UIColor(red:0.20, green:0.48, blue:0.72, alpha:1.0)
            
            let note = NSMutableAttributedString(attributedString:payStubs[indexPath.row].note.htmlToAttributedString!)
            note.addAttributes(attributes, range:NSRange(location:0, length:payStubs[indexPath.row].note.htmlToAttributedString!.length))
            /*
             "PaystubPSL" : {
             "HoursSickUsedTTL" : 0,
             "SickHoursAvailableTTL" : "14.00",
             "AccruedHours" : "14.00"
             },
             */
            if paySubObjects["ShowPaystubs"].boolValue == true {
                cell.paidSickLeave.isHidden = false
                cell.paidSickLeaveHeight.constant = 120
                cell.paidSickAmountLabel.text = ":"+"\(paySubObjects["PaystubPSL"]["AccruedHours"].doubleValue)"
                cell.payPeriodHours.text = ":"+"\(paySubObjects["PaystubPSL"]["HoursSickUsedTTL"].doubleValue)"
                cell.paidSickTotalBalanceLabel.text = ":"+"\(paySubObjects["PaystubPSL"]["SickHoursAvailableTTL"].doubleValue)"
            }
            else {
                cell.paidSickLeave.isHidden = true
                cell.paidSickLeaveHeight.constant = 0
            }
            
            cell.noteLabel.attributedText = note
            cell.earningsConstant.constant = CGFloat(payStubs[indexPath.row].earningArry.count*50)
            cell.miscConstrain.constant = CGFloat(payStubs[indexPath.row].miscs.count*40)
            cell.codeHeight.constant = CGFloat(payStubs[indexPath.row].clientDetails.count*220)
            cell.earningsTableView.reloadData()
            cell.miscTableView.reloadData()
            cell.codeTableView.reloadData()
            cell.selectionStyle = .none
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:"payCell") as! ViewPayStubTableViewCell
            cell.legalName.text = payStubs[indexPath.row].legalName
            cell.localOffice.text = payStubs[indexPath.row].localOffice
            cell.empName.text = " "+payStubs[indexPath.row].empName
            cell.ssnNumber.text = " "+payStubs[indexPath.row].ssn
            cell.payPeriod.text = " "+payStubs[indexPath.row].payPeriod
            cell.checkDate.text = " "+payStubs[indexPath.row].checkDate
            cell.checkNumber.text = " "+payStubs[indexPath.row].checkNumber
            cell.grossPay.text = payStubs[indexPath.row].grossPay
            cell.fica.text = payStubs[indexPath.row].fica
            cell.medicare.text = payStubs[indexPath.row].medicare
            cell.fit.text = payStubs[indexPath.row].fit
            cell.state.text = payStubs[indexPath.row].state
            cell.city.text = payStubs[indexPath.row].city
            cell.disabilitypay.text = payStubs[indexPath.row].disabilityPaid
            cell.fortyOneK.text = payStubs[indexPath.row].forOneK
            cell.totalHour.text = " "+payStubs[indexPath.row].totalHour
            cell.totalDandA.text = " "+payStubs[indexPath.row].totalHourDA
            cell.netpay.text = " "+payStubs[indexPath.row].netPay
            cell.ytdGross.text = payStubs[indexPath.row].grossPayYTD
            cell.ficaYTD.text = payStubs[indexPath.row].ficaYTD
            cell.medicareYTD.text = payStubs[indexPath.row].medicareYTD
            cell.fitYTD.text = payStubs[indexPath.row].fitYTD
            cell.ytdCity.text = payStubs[indexPath.row].cityYTD
            cell.ytdState.text = payStubs[indexPath.row].stateYTD
            cell.ytdDisability.text = payStubs[indexPath.row].disabilityPaidYTD
            cell.ytdForOneK.text = payStubs[indexPath.row].forOneKYTD
            cell.earningsArray = payStubs[indexPath.row].earningArry
            cell.miscArray = payStubs[indexPath.row].miscs
            cell.earningsConstant.constant = CGFloat(payStubs[indexPath.row].earningArry.count*50)
            cell.miscConstrain.constant = CGFloat(payStubs[indexPath.row].miscs.count*40)
            /*
             "PaystubPSL" : {
             "HoursSickUsedTTL" : 0,
             "SickHoursAvailableTTL" : "14.00",
             "AccruedHours" : "14.00"
             },
             */
            if paySubObjects["ShowPaystubs"].boolValue == true {
                cell.paidSickLeave.isHidden = false
                cell.paidSickLeaveHeight.constant = 120
                cell.paidSickAmountLabel.text = ":"+"\(paySubObjects["PaystubPSL"]["AccruedHours"].doubleValue)"
                cell.payPeriodHours.text = ":"+"\(paySubObjects["PaystubPSL"]["HoursSickUsedTTL"].doubleValue)"
                cell.paidSickTotalBalanceLabel.text = ":"+"\(paySubObjects["PaystubPSL"]["SickHoursAvailableTTL"].doubleValue)"
            }
            else {
                cell.paidSickLeave.isHidden = true
                cell.paidSickLeaveHeight.constant = 0
            }
            
            cell.earningsTableView.reloadData()
            cell.miscTableView.reloadData()
            cell.selectionStyle = .none
            return cell
        }
        
        
        
    }
}

extension ViewPayStubViewController:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if payStubs[indexPath.row].isCAEmpl
        {
            if paySubObjects["ShowPaystubs"].boolValue == true {
                return CGFloat(120+1120+payStubs[indexPath.row].earningArry.count*50+payStubs[indexPath.row].miscs.count*40+payStubs[indexPath.row].clientDetails.count*220)
            }
            else {
                return CGFloat(1120+payStubs[indexPath.row].earningArry.count*50+payStubs[indexPath.row].miscs.count*40+payStubs[indexPath.row].clientDetails.count*220)
            }
        }
        else
        {
            if paySubObjects["ShowPaystubs"].boolValue == true {
                return CGFloat(120+800+payStubs[indexPath.row].earningArry.count*50+payStubs[indexPath.row].miscs.count*40)
            }
            else {
                return CGFloat(800+payStubs[indexPath.row].earningArry.count*50+payStubs[indexPath.row].miscs.count*40)
            }
        }
    }
}


extension ViewPayStubViewController:formDelegate
{
    func formStatus(success: Bool, skipStatus: Int) {
        print("success")
        ASHTSkipStatus = skipStatus
        getPayStubs()
    }
    
}
extension ViewPayStubViewController:aCAConsent
{
    func acaStatus(success: Bool) {
        print("success")
        ASHTSkipStatus = 0
        getPayStubs()
    }
    
}

extension ViewPayStubViewController:acaConsentDelivery
{
    func acaElectronicDeliveryStatus(success: Bool) {
        print("success")
        ASHTSkipStatus = 0
        getPayStubs()
    }
    
}

extension ViewPayStubViewController:payCardDelegate
{
    func payCardStatus(success: Bool) {
        print("success")
        ASHTSkipStatus = 0
        getPayStubs()
    }
    
}

extension ViewPayStubViewController:wageRateDelegate
{
    func wageRateStatus(success: Bool) {
        print("success")
        ASHTSkipStatus = 0
        getPayStubs()
    }
    
    
}
extension ViewPayStubViewController:caWageRateDelegate
{
    func caWageRateStatus(success: Bool) {
        print("success")
        ASHTSkipStatus = 0
        getPayStubs()
    }
    
    
}
