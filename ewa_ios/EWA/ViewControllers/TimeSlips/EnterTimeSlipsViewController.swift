
//
//  EnterTimeSlipsViewController.swift
//  EWA
//
//  Created by NFC Solutions on 13/11/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import SideMenuController
import DropDown
import ANLoader
import WebKit
import ActiveLabel
import CropViewController


class EnterTimeSlipsViewController: UIViewController,SideMenuControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,CropViewControllerDelegate {
    
    @IBOutlet var timeSlipTableView: UITableView!
    
    @IBOutlet var headerView: UIView!
    var timeSlipNextObject: JSON = JSON.null
    var object: JSON = JSON.null
    var selectedData: JSON = JSON.null
    var detailData: JSON = JSON.null
    var picUploadData:JSON = JSON.null
    var signedObjectResponse:JSON = JSON.null
    var nextObject:JSON = JSON.null
    @IBOutlet var noAssignmentLabel: UILabel!
    var orderId = String()
    var weekEnd = String()
    let chooseArticleDropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.chooseArticleDropDown
        ]
    }()
    @IBOutlet var selectWeekButton: PKButton!
    @IBOutlet var asssignmentLabel: UILabel!
    var division = String()
    var blurEffect = UIBlurEffect()
    var blurEffectView = UIVisualEffectView()
    @IBOutlet var infoView: UIView!
    var enterTimeSlipAssignments = [EnterTimeSlip]()
    @IBOutlet var infoLabel: PaddingLabel!
    var checked = Bool()
    var ASHTSkipStatus = Int()
    var acaRequire = Bool()
    var aca1905cRequire = Bool()
    var wageRateOne = Bool()
    var wageRateTwo = Bool()
    var language = String()
    var dates = [String]()
    var fromETC = String()
    var etcWeekend = String()
    var isETCStart = String()
    
    //employeeWebAccess
    @IBOutlet var employeeHandBookView: UIView!
    @IBOutlet weak var employeeWebview: WKWebView!
    @IBOutlet var ackLabel: UILabel!
    
    //ACAConsentForm
    @IBOutlet var acaConsentView: UIView!
    @IBOutlet weak var acaWebView: WKWebView!
    
    //TermsAndConditions
    @IBOutlet var termsAndConditionsView: UIView!
    @IBOutlet var termsWebView: WKWebView!
    
    //CONSUMER_REPORTS
    @IBOutlet var consumerView: UIView!
    @IBOutlet var consumerWebView: WKWebView!
    
    //GenderEquality
    @IBOutlet var genderEqualityView: UIView!
    @IBOutlet var genderWebView: WKWebView!
    
    //ConscientiousEmployeeProtectionAct
    @IBOutlet var conscientiousEmployeeProtectionAct: UIView!
    @IBOutlet var protectionWebView: WKWebView!
    
    //CAEmpAgreement
    @IBOutlet var caEmpAgreement: UIView!
    @IBOutlet var camEmpWebView: WKWebView!
    @IBOutlet weak var caAcceptLabel: UILabel!
    
    //ACA Consent Form 1095-C
    @IBOutlet var acaConsentForm1095CView: UIView!
    @IBOutlet weak var aca1905Label: UILabel!
    @IBOutlet weak var aca1095WebView: WKWebView!
    
    //Disclosure Consent
    @IBOutlet var disclosureConsentview: UIView!
    
    //Code of Conduct
    @IBOutlet var codeOfConductView: UIView!
    @IBOutlet weak var caAckLabel: UILabel!
    
    //Paid Sick Leave FAQ'S
    @IBOutlet var paidSickLeaveFAQView: UIView!
    
    //Pay Guard hange Act
    @IBOutlet var payGuardView: UIView!
    @IBOutlet weak var payGuradLabel: ActiveLabel!
    
    //Wage Rate
    @IBOutlet var wageRateForm: UIView!
    @IBOutlet weak var wageRateTextField: UITextField!
    @IBOutlet weak var wageRateCheckBoxOne: UIButton!
    @IBOutlet weak var wageRateCheckBoxTwo: UIButton!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var hiring: UIButton!
    @IBOutlet weak var onFeb: UIButton!
    @IBOutlet weak var beforeChange: UIButton!
    @IBOutlet weak var regularPay: UIButton!
    @IBOutlet weak var unknownPay: UIButton!
    @IBOutlet weak var avgRate: UIButton!
    @IBOutlet weak var employRate: UIButton!
    @IBOutlet weak var none: UIButton!
    @IBOutlet weak var tips: UIButton!
    @IBOutlet weak var meals: UIButton!
    @IBOutlet weak var loading: UIButton!
    @IBOutlet weak var other: UIButton!
    @IBOutlet weak var weekly: UIButton!
    @IBOutlet weak var biWeekly: UIButton!
    @IBOutlet weak var payOther: UIButton!
    @IBOutlet weak var preparesNameLabel: UILabel!
    
    //CAWAGERATE
    @IBOutlet var caWageRate: UIView!
    @IBOutlet weak var peoYes: UIButton!
    @IBOutlet weak var peoNo: UIButton!
    @IBOutlet weak var hour: UIButton!
    @IBOutlet weak var shift: UIButton!
    @IBOutlet weak var day: UIButton!
    @IBOutlet weak var week: UIButton!
    @IBOutlet weak var salary: UIButton!
    @IBOutlet weak var piecerRate: UIButton!
    @IBOutlet weak var comission: UIButton!
    @IBOutlet weak var caOther: UIButton!
    @IBOutlet weak var rateYes: UIButton!
    @IBOutlet weak var rateNo: UIButton!
    @IBOutlet weak var agYes: UIButton!
    @IBOutlet weak var agNo: UIButton!
    @IBOutlet weak var certCheck: UIButton!
    @IBOutlet weak var topUserLabel: UILabel!
    @IBOutlet weak var bottomUserLabel: UILabel!
    @IBOutlet weak var one: UIButton!
    @IBOutlet weak var two: UIButton!
    @IBOutlet weak var three: UIButton!
    @IBOutlet weak var four: UIButton!
    
    //signatureView
    @IBOutlet var signatureView: UIView!
    @IBOutlet var signatureTextField: UITextField!
    @IBOutlet var checkBoxButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signatureHeaderView: UIView!
    
    var clickedRow = Bool()
    
    //formView
    @IBOutlet var formView: UIView!
    @IBOutlet weak var formWebView: WKWebView!
    
    @IBOutlet var formSubmitButton: UIButton!
    @IBOutlet weak var signitureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    //  @IBAction var
    
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(String(describing: EnterTimeSlipsViewController.self))
        ASHTSkipStatus = 0
        if fromETC == "1"{
            isETCStart = "1"
        }
        else {
            isETCStart = "0"
        }
        self.updateNavigationBarColor()
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        self.navigationItem.title = "Enter Timeslips"
        if #available(iOS 11.0, *) {
            timeSlipTableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        if fromETC == "1"{
            self.selectWeekButton.setTitle(etcWeekend, for: .normal)
        }
        if ConnectionCheck.isConnectedToNetwork()
        {
            //ANLoader.showLoading("", disableUI:false)
            ServerService.showActivityIndicatory(uiView:self.view)
            let params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"ASHTSkipStatus":"0"]
            print("viv from view did load its coming\(params)***")
            ServerService.getEnterTimeSlipWeekEnds(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponse(response:))
        }
        else
        {
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
        
        asssignmentLabel.isHidden = true
        noAssignmentLabel.isHidden = true
        sideMenuController?.delegate = self
        selectWeekButton.titleLabel?.textAlignment = .left
        timeSlipTableView.isScrollEnabled = false
        
        headerView.backgroundColor = .white
        let formattedString = NSMutableAttributedString()
        formattedString
            .bold("NOTE:")
            .normal("You must enter your timeslip hours ")
            .bold("before ")
            .normal("Sunday at midnight to receive your check that week. All employees who enter their timeslips ")
            .bold("after ")
            .normal("Sunday at midnight will receive their check the following week.")
        formattedString.addAttribute(NSAttributedStringKey.foregroundColor, value:UIColor.init(hexString:"#3A87AD"), range: NSRange(location:0,length:formattedString.length))
        infoLabel.attributedText = formattedString
        
        let customType = ActiveType.custom(pattern: "\\sHere\\b")
        payGuradLabel.enabledTypes.append(customType)
        payGuradLabel.customize { label in
            label.text = "Please click Here to acknowledge the change to the new Bank of America Money Network Pay Service"
            label.numberOfLines = 0
            label.lineSpacing = 4
            label.textColor = UIColor.black
            
            //Custom types
            label.customColor[customType] = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
            label.handleCustomTap(for: customType) { self.alert("Custom type", message: $0) }
            
        }
        signatureHeaderView.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        
        caAckLabel.text = """
        I, \(UserDefaults.standard.object(forKey:"CandName") as! String),  pledge to prevent abuse, neglect, or harm toward any person with special needs. If I learn of, or witness, any incident of abuse, neglect or harm toward any person with special needs, I will offer immediate assistance and then notify emergency personnel, including 9-1-1 where appropriate, and inform the management of this organization. I pledge also to report the incident to the Justice Center for the Protection of People with Special Needs.
        
        I acknowledge that I have read and that I understand the Code of Conduct.
        
        I agree to abide by this Code of Conduct.
        """
        caAcceptLabel.text = "I, \(UserDefaults.standard.object(forKey:"CandName") as! String) , have carefully read and understand all of the company’s policies/procedures. By electronically signing below, I agree to adhere to all policies/procedures and understand these policies/procedures."
        
        ackLabel.text = "I, \(UserDefaults.standard.object(forKey:"CandName") as! String)  , have carefully read the and understand all of the company’s policies/procedures. By electronically signing below, I agree to adhere to all policies/procedures and understand that my employment may be terminated by not abiding by these policies/procedures."
        
        topUserLabel.text = """
        Employee
        Employee Name: \(UserDefaults.standard.object(forKey:"CandName") as! String)
        Start Date: 01/01/1900 12:00 AM
        Employer
        Legal Name of Hiring Employer: TemPositions Inc.
        Is hiring employer a staffing agency/business (e.g., Temporary Services Agency; Employee Leasing
        """
        
        bottomUserLabel.text = """
        Acknowledgment Of Receipt
        Prasad Kadrikar
        (PRINT NAME of Employer representative) \(UserDefaults.standard.object(forKey:"CandName") as! String)
        (PRINT NAME of Employee)
        Prasad Kadrikar
        (SIGNATURE of Employer representative) \(UserDefaults.standard.object(forKey:"CandName") as! String)
        (SIGNATURE of Employee)
        01/01/1753
        (Date provided to employee & signed by representative) 12/15/2017 12:00 AM
        (Date received by employee & signed by employee)
        
        We are required by law to provide you with a copy of this form. Select "E-Mail" below to have the form emailed to you or "Paper" to print out the form. The form will be emailed or printed when you press "Print Form".
        """
        
        let formattedStrings = NSMutableAttributedString()
        formattedStrings
            .normal("To indicate you would prefer")
            .bold("NOT")
            .normal("to receive the ACA form electronically, We will ask you to sign this form electronically by clicking the “Press to Sign” box to the right.")
        formattedStrings.addAttribute(NSAttributedStringKey.foregroundColor, value:UIColor.black, range: NSRange(location:0,length:formattedStrings.length))
        aca1905Label.attributedText = formattedStrings
        aca1905Label.font = UIFont.systemFont(ofSize:15)
    }
    
    func alert(_ title: String, message: String) {
        print("tapped")
        //ANLoader.showLoading("", disableUI:false)
        ServerService.showActivityIndicatory(uiView:self.view)
        let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "cID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":UserDefaults.standard.object(forKey:"CandName") as! String,"FormName":object["FormName"].stringValue]
        print(params)
        ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
    }
    
    //aftergettingResponseFrom the server
    func getresponse(response:AnyObject)->()
    {
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        ANLoader.hide()
        ServerService.hideProgressView()
        object = response as! JSON
        print("viv the response from 318 line is \(object)***")
        if (object["Message"].stringValue.count>0){
            noAssignmentLabel.text = object["Message"].stringValue
        }
        if object.isEmpty
        {
            removeAll()
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if object["Status"].stringValue == "success"||object["Status"].stringValue == "Success"
        {
            removeAll()
            noAssignmentLabel.isHidden = true
            timeSlipTableView.backgroundColor = .white
            timeSlipTableView.isScrollEnabled = false
            headerView.backgroundColor = .white
            
            let tlabel = UILabel()
            tlabel.text = "Enter Timeslips"
            tlabel.textColor = UIColor.white
            tlabel.font = UIFont.systemFont(ofSize:17)
            tlabel.backgroundColor = UIColor.clear
            tlabel.adjustsFontSizeToFitWidth = true
            tlabel.textAlignment = .left
            tlabel.numberOfLines = 0
            tlabel.minimumScaleFactor = 0.5
            self.navigationItem.titleView = tlabel
            
            if isETCStart == "1"{
                callSelectedWeekendForETC(item: etcWeekend)
            }
            if clickedRow
            {
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
                //                    ANLoader.hide()
                //                })
                if ConnectionCheck.isConnectedToNetwork()
                {
                    timeSlipTableView.isScrollEnabled = true
                    //timeSlipTableView.isUserInteractionEnabled = false
                    // ANLoader.showLoading("", disableUI:true)
                    ServerService.showActivityIndicatory(uiView:self.view)
                    var params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"WeekendDate":weekEnd,"OrderId":orderId,"Division":division]
                    if fromETC == "1" {
                        params.updateValue("1", forKey: "EtcChecked")
                    }
                    print(params)
                    ServerService.getEnterTimeSlip(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseForDetail(response:))
                }
                else
                {
                    ANLoader.hide()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                }
            }
            else
            {
                
            }
        }
        
        else if object["Status"].intValue == 3
        {
            removeAll()
            askLanguage()
        }
        else
        {
            noAssignmentLabel.isHidden = false
            if (object["Message"].stringValue.count>0){
                noAssignmentLabel.text = object["Message"].stringValue
            }
            noAssignmentLabel.backgroundColor = UIColor(hexString:"#f2dede")
            timeSlipTableView.backgroundColor = .clear
            timeSlipTableView.isScrollEnabled = false
            headerView.backgroundColor = .white
            let tlabel = UILabel()
            tlabel.text = object["Title"].stringValue
            tlabel.textColor = UIColor.white
            tlabel.font = UIFont.systemFont(ofSize:17)
            tlabel.backgroundColor = UIColor.clear
            tlabel.adjustsFontSizeToFitWidth = true
            tlabel.textAlignment = .left
            tlabel.numberOfLines = 0
            tlabel.minimumScaleFactor = 0.5
            if tlabel.text?.count == 0
            {
                tlabel.text = "Enter Timeslips"
            }
            self.navigationItem.titleView = tlabel
            
            
            if object["FormName"].stringValue.count>0
            {
                if object["LynkType"].intValue > 0 && object["File"].stringValue.count > 5{
                    print("vivek enter 413 line")
                    Constants.LinkUrl = object["File"].stringValue
                    Constants.LinkText = object["FormName"].stringValue
                    Constants.iSFormOkRequired = false
                    Constants.ShowStandAlone = true
                    self.pushToStandAlone()
                }
                else {
                    if object["FormName"].stringValue == "ACAElectronicDeliveryConsent"
                    {
                        
                        acaConsentView.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                        
                        self.view.addSubview(acaConsentView)
                        self.view.bringSubview(toFront:acaConsentView)
                        let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
                        let request = URLRequest(url: url!)
                        acaWebView.load(request)
                        
                    }
                    
                    else if object["FormName"].stringValue == "ACA1095CConsent"
                    {
                        
                        acaConsentForm1095CView.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                        self.view.addSubview(acaConsentForm1095CView)
                        self.view.bringSubview(toFront:acaConsentForm1095CView)
                        let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
                        let request = URLRequest(url: url!)
                        aca1095WebView.load(request)
                    }
                    else if object["FormName"].stringValue == "PayCardChangeAcknowledgementForm"
                    {
                        payGuardView.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                        self.view.addSubview(payGuardView)
                        self.view.bringSubview(toFront:payGuardView)
                    }
                    
                    else if object["FormName"].stringValue == "WageRateForm"
                    {
                        let formView = Bundle.main.loadNibNamed("WageRate", owner: nil, options: nil)![0] as! WageRate
                        formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height)
                        formView.object = object
                        formView.setUp()
                        formView.wagRateDelegate = self
                        self.view.addSubview(formView)
                        self.view.bringSubview(toFront:formView)
                        
                    }
                    else if object["FormName"].stringValue == "CaliforniaWageRateForm"
                    {
                        caWageRate.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                        self.view.addSubview(caWageRate)
                        self.view.bringSubview(toFront:caWageRate)
                    }
                    else if object["FormName"].stringValue == Constants.A1Form {
                        let VC = A1FormController(nibName: "A1FormController", bundle: nil)
                        VC.object = object
                        let navi = BaseNaviViewController(rootViewController:VC)
                        navi.navigationBar.tintColor = .white
                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"A1FormController")
                    }
                    else if object["FormName"].stringValue == Constants.A2Form {
                        let VC = A2FormController(nibName: "A2FormController", bundle: nil)
                        VC.object = object
                        let navi = BaseNaviViewController(rootViewController:VC)
                        navi.navigationBar.tintColor = .white
                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"A2FormController")
                    }
                    
                    else if object["FormName"].stringValue == Constants.SCRConsent {
                        let VC = SCRConsent(nibName: "SCRConsent", bundle: nil)
                        VC.object = JSON(["FormName":Constants.SCRName])
                        VC.fromSideMenu = false
                        let navi = BaseNaviViewController(rootViewController:VC)
                        navi.navigationBar.tintColor = .white
                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"SCRConsent")
                        
                    }
                    else if object["FormName"].stringValue == Constants.SCRForm{
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
                        print("viv enter form view in 506")
                        /*
                         ASHTSkip = 0  -> Signature enable ( default)
                         ASHTSkip = 1  -> Skip Enable , Signature disable
                         ASHTSkip = 2  -> Skip disable , Signature disable
                         */
                        let formView = Bundle.main.loadNibNamed("FormView", owner: nil, options: nil)![0] as! FormView
                        formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height)
                        formView.formsObject = object
                        formView.loadForm()
                        formView.formDelegate = self
                        
                        self.view.addSubview(formView)
                        self.view.bringSubview(toFront:formView)
                    }
                }
                
            }
            else {
                ANLoader.hide()
                if (object["Message"].stringValue.count>0) && noAssignmentLabel.text!.count>0{
                    
                }
                else {
                    
                    if object["Message"].stringValue.count != 0 {
                        ServerService.ShowAlertMessage(ErrorMessage:object["Message"].stringValue, title: "", view:self)
                    }
                    
                }
            }
        }
    }
    
    //aftergettingResponseFrom the server
    func OnClickgetresponse(response:AnyObject)->()
    {
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        //  ANLoader.hide()
        
        ServerService.hideProgressView()
        timeSlipNextObject = response as! JSON
        object = response as! JSON
        print(object)
        
        if object.isEmpty
        {
            removeAll()
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if object["Status"].stringValue == "success"||object["Status"].stringValue == "Success"
        {
            removeAll()
            noAssignmentLabel.isHidden = true
            timeSlipTableView.backgroundColor = .white
            timeSlipTableView.isScrollEnabled = false
            headerView.backgroundColor = .white
            
            let tlabel = UILabel()
            tlabel.text = "Enter Timeslips"
            tlabel.textColor = UIColor.white
            tlabel.font = UIFont.systemFont(ofSize:17)
            tlabel.backgroundColor = UIColor.clear
            tlabel.adjustsFontSizeToFitWidth = true
            tlabel.textAlignment = .left
            tlabel.numberOfLines = 0
            tlabel.minimumScaleFactor = 0.5
            self.navigationItem.titleView = tlabel
            
            if isETCStart == "1"{
                callSelectedWeekendForETC(item: etcWeekend)
            }
            if clickedRow
            {
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
                //                    ANLoader.hide()
                //                })
                if ConnectionCheck.isConnectedToNetwork()
                {
                    timeSlipTableView.isScrollEnabled = true
                    
                    ServerService.showActivityIndicatory(uiView:self.view)
                    var params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"WeekendDate":weekEnd,"OrderId":orderId,"Division":division]
                    if fromETC == "1" {
                        params.updateValue("1", forKey: "EtcChecked")
                    }
                    print(params)
                    ServerService.getEnterTimeSlip(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseForDetail(response:))
                }
                else
                {
                    //ANLoader.hide()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                }
            }
            else
            {
                
            }
        }
        
        else if object["Status"].intValue == 3
        {
            removeAll()
            askLanguage()
        }
        else
        {
            noAssignmentLabel.isHidden = true
            noAssignmentLabel.backgroundColor = UIColor(hexString:"#f2dede")
            timeSlipTableView.backgroundColor = .clear
            timeSlipTableView.isScrollEnabled = false
            headerView.backgroundColor = .white
            //self.navigationController?.navigationBar.topItem?.title = object["Title"].stringValue
            
            let tlabel = UILabel()
            tlabel.text = object["Title"].stringValue
            tlabel.textColor = UIColor.white
            tlabel.font = UIFont.systemFont(ofSize:17)
            tlabel.backgroundColor = UIColor.clear
            tlabel.adjustsFontSizeToFitWidth = true
            tlabel.textAlignment = .left
            tlabel.numberOfLines = 0
            tlabel.minimumScaleFactor = 0.5
            if tlabel.text?.count == 0
            {
                tlabel.text = "Enter Timeslips"
            }
            self.navigationItem.titleView = tlabel
            
            
            if object["FormName"].stringValue.count>0
            {
                if object["LynkType"].intValue > 0 && object["File"].stringValue.count > 5{
                    Constants.LinkUrl = object["File"].stringValue
                    Constants.LinkText = object["FormName"].stringValue
                    Constants.iSFormOkRequired = false
                    Constants.ShowStandAlone = true
                    self.pushToStandAlone()
                }
                else {
                    if object["FormName"].stringValue == "ACAElectronicDeliveryConsent"
                    {
                        
                        acaConsentView.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                        
                        self.view.addSubview(acaConsentView)
                        self.view.bringSubview(toFront:acaConsentView)
                        let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
                        let request = URLRequest(url: url!)
                        acaWebView.load(request)
                    }
                    
                    else if object["FormName"].stringValue == "ACA1095CConsent"
                    {
                        
                        acaConsentForm1095CView.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                        self.view.addSubview(acaConsentForm1095CView)
                        self.view.bringSubview(toFront:acaConsentForm1095CView)
                        let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
                        let request = URLRequest(url: url!)
                        aca1095WebView.load(request)
                        
                    }
                    
                    else if object["FormName"].stringValue == "PayCardChangeAcknowledgementForm"
                    {
                        
                        payGuardView.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                        self.view.addSubview(payGuardView)
                        self.view.bringSubview(toFront:payGuardView)
                        
                    }
                    
                    
                    else if object["FormName"].stringValue == "WageRateForm"
                    {
                        let formView = Bundle.main.loadNibNamed("WageRate", owner: nil, options: nil)![0] as! WageRate
                        formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height)
                        formView.object = object
                        formView.setUp()
                        formView.wagRateDelegate = self
                        self.view.addSubview(formView)
                        self.view.bringSubview(toFront:formView)
                        
                    }
                    else if object["FormName"].stringValue == "CaliforniaWageRateForm"
                    {
                        caWageRate.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                        self.view.addSubview(caWageRate)
                        self.view.bringSubview(toFront:caWageRate)
                    }
                    else
                    {
                        /*
                         ASHTSkip = 0  -> Signature enable ( default)
                         ASHTSkip = 1  -> Skip Enable , Signature disable
                         ASHTSkip = 2  -> Skip disable , Signature disable
                         */
                        let formView = Bundle.main.loadNibNamed("FormView", owner: nil, options: nil)![0] as! FormView
                        formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height)
                        formView.formsObject = object
                        formView.loadForm()
                        formView.formDelegate = self
                        
                        self.view.addSubview(formView)
                        self.view.bringSubview(toFront:formView)
                    }
                }
                
            }
            else {
                
                if (object["Message"].stringValue.count>0){
                    self.loadAlertPopupWithObject(3, messageText: object["Message"].stringValue, popKeyToSend: "", apiCallrequired: false)
                }
            }
        }
    }
    
    func loadAlertPopupWithObject(_ viewStatus: Int, messageText: String, popKeyToSend: String, apiCallrequired: Bool)
    {
        let window = UIApplication.shared.keyWindow!
        
        let formView = Bundle.main.loadNibNamed("AlertPopView", owner: nil, options: nil)![0] as! AlertPopView
        
        formView.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
        formView.viewStatus = viewStatus
        formView.popKeyToSend = popKeyToSend
        formView.messageText = messageText
        formView.loadForm()
        formView.toCOntroller = self
        formView.popAlertDelegate = self
        formView.apiCallrequired = apiCallrequired
        formView.removeHard = true
        window.addSubview(formView)
        window.bringSubview(toFront:formView)
    }
    //aftergettingResponseFrom the server
    func selectedObjectResponse(response:AnyObject)->()
    {
        ANLoader.hide()
        ServerService.hideProgressView()
        selectedData = response as! JSON
        print(selectedData)
        enterTimeSlipAssignments.removeAll()
        isETCStart = "0"
        if selectedData["Status"].stringValue == "Success"
        {
            if selectedData["OrdersCount"].intValue>0
            {
                asssignmentLabel.isHidden = false
                noAssignmentLabel.backgroundColor = .clear
                timeSlipTableView.backgroundColor = .white
                
                timeSlipTableView.isScrollEnabled = true
                headerView.backgroundColor = UIColor(hexString:"#EEEEEE")
                
                for a in 0..<selectedData["Weekending"].arrayValue.count
                {
                    
                    var WorkSchedAssignmentArray = [String]()
                    if selectedData["Weekending"][a]["WorkSchedAssignment"].arrayObject.isNilOrEmpty
                    {
                        
                    }
                    else
                    {
                        WorkSchedAssignmentArray = selectedData["Weekending"][a]["WorkSchedAssignment"].arrayObject as! [String]
                    }
                    
                    let timeslip = EnterTimeSlip.init(orderId: selectedData["Weekending"][a]["OrderId"].stringValue, clientName: selectedData["Weekending"][a]["CompName"].stringValue, position: selectedData["Weekending"][a]["Position"].stringValue, reference: selectedData["Weekending"][a]["Reference"].stringValue, schedule:WorkSchedAssignmentArray, division: selectedData["Weekending"][a]["Division"].stringValue)
                    enterTimeSlipAssignments.append(timeslip)
                }
                timeSlipTableView.reloadData()
            }
            else
            {
                asssignmentLabel.isHidden = true
                timeSlipTableView.backgroundColor = .clear
                noAssignmentLabel.isHidden = false
                noAssignmentLabel.text = selectedData["Message"].stringValue
                noAssignmentLabel.backgroundColor = UIColor(hexString:"#f2dede")
                timeSlipTableView.isScrollEnabled = false
                headerView.backgroundColor = .white
            }
        }
        else
        {
            asssignmentLabel.isHidden = true
            timeSlipTableView.backgroundColor = .clear
            noAssignmentLabel.isHidden = false
            noAssignmentLabel.text = selectedData["Message"].stringValue
            noAssignmentLabel.backgroundColor = UIColor(hexString:"#f2dede")
            headerView.backgroundColor = UIColor(hexString:"#EEEEEE")
            timeSlipTableView.reloadData()
            timeSlipTableView.isScrollEnabled = false
            headerView.backgroundColor = .white
        }
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailSegue"
        {
            let dvc = segue.destination as! EnterTimeSlipDetailViewController
            dvc.orderId = orderId
            dvc.weekEnd = weekEnd
            dvc.division = division
            dvc.object = detailData
        }
    }
    @IBAction func handleNavgationBarButtonTap(_ sender: UIBarButtonItem, event: UIEvent)
    
    {
        Constants.showUp(event:event,viewController:self)
        
    }
    func sideMenuControllerDidHide(_ sideMenuController: SideMenuController) {
        
    }
    
    func sideMenuControllerDidReveal(_ sideMenuController: SideMenuController) {
        
        
    }
    
    
    
    
    func setupChooseArticleDropDown(anchorView:UIButton,items:[String]) {
        chooseArticleDropDown.anchorView = anchorView
        chooseArticleDropDown.bottomOffset = CGPoint(x: 0, y: anchorView.bounds.height)
        chooseArticleDropDown.backgroundColor = .white
        chooseArticleDropDown.dataSource =  items
        chooseArticleDropDown.selectionAction = { [unowned self] (index,item) in
            print(self.index)
            print(item)
            self.selectWeekButton.setTitle(item, for: .normal)
            self.selectWeekButton.titleLabel?.textAlignment = .left
            if item == "---Select Week Ending---"
            {
                
            }
            else
            {
                self.weekEnd = item
                if ConnectionCheck.isConnectedToNetwork()
                {
                    //ANLoader.showLoading("", disableUI:true)
                    ServerService.showActivityIndicatory(uiView:self.view)
                    var params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"WeekendDate":item]
                    if fromETC == "1" {
                        params.updateValue("1", forKey: "EtcChecked")
                    }
                    print("The Params are from 868, \(params)")
                    ServerService.getTimeSlipAssignments(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: self.selectedObjectResponse(response:))
                }
                else
                {
                    ANLoader.hide()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                }
                
            }
        }
    }
    
    func callSelectedWeekendForETC(item:String) {
        
        self.weekEnd = item
        //                   DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
        //                       ANLoader.hide()
        //                   })
        if ConnectionCheck.isConnectedToNetwork()
        {
            //ANLoader.showLoading("", disableUI:true)
            ServerService.showActivityIndicatory(uiView:self.view)
            var params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"WeekendDate":item]
            if fromETC == "1" {
                params.updateValue("1", forKey: "EtcChecked")
            }
            print(params)
            ServerService.getTimeSlipAssignments(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: self.selectedObjectResponse(response:))
        }
        else
        {
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
        
        
    }
    
    @IBAction func selectWeekAction(_ sender: PKButton) {
        
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        
        if clickedRow
        {
            
        }
        else
        {
            //Week Ending
            var itemsDrop:[String] = ["---Select Week Ending---"]
            for Weekend in 0..<object["ListWeekEndDate"].arrayValue.count
            {
                itemsDrop.append(Constants.getFormattedDateForPersonalJob(string:object["ListWeekEndDate"][Weekend].stringValue.substring(to: 10)))
            }
            dates = itemsDrop
        }
        //       object["Weekending"].arrayValue.map({$0["Weekend"].stringValue})
        setupChooseArticleDropDown(anchorView:sender,items:dates)
        chooseArticleDropDown.show()
        
    }
    @IBAction func infoAction(_ sender: UIButton) {
        if self.view.bounds.height<=568
        {
            infoView.frame = CGRect(x:10, y:self.view.bounds.height/2-90, width: self.view.bounds.width-20, height:250)
        }
        else
        {
            infoView.frame = CGRect(x:10, y:self.view.bounds.height/2-90, width: self.view.bounds.width-20, height:250)
        }
        blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.contentView.addSubview(infoView)
        view.addSubview(blurEffectView)
    }
    @IBAction func okAction(_ sender: UIButton) {
        blurEffectView.removeFromSuperview()
    }
    //imagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = (info[UIImagePickerControllerOriginalImage] as? UIImage) else { return }
        
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.delegate = self
        
        // Uncomment this if you wish to provide extra instructions via a title label
        //cropController.title = "Crop Image"
        
        // -- Uncomment these if you want to test out restoring to a previous crop setting --
        //cropController.angle = 90 // The initial angle in which the image will be rotated
        //cropController.imageCropFrame = CGRect(x: 0, y: 0, width: 2848, height: 4288) //The initial frame that the crop controller will have visible.
        
        // -- Uncomment the following lines of code to test out the aspect ratio features --
        cropController.aspectRatioPreset = .presetSquare; //Set the initial aspect ratio as a square
        cropController.aspectRatioLockEnabled = true // The crop box is locked to the aspect ratio and can't be resized away from it
        cropController.resetAspectRatioEnabled = false // When tapping 'reset', the aspect ratio will NOT be reset back to default
        cropController.aspectRatioPickerButtonHidden = true
        
        // -- Uncomment this line of code to place the toolbar at the top of the view controller --
        //cropController.toolbarPosition = .top
        
        cropController.rotateButtonsHidden = true
        cropController.rotateClockwiseButtonHidden = true
        
        //cropController.doneButtonTitle = "Title"
        //cropController.cancelButtonTitle = "Title"
        
        self.image = image
        
        
        //If profile picture, push onto the same navigation stack
        if croppingStyle == .circular {
            picker.pushViewController(cropController, animated: true)
        }
        else { //otherwise dismiss, and then present from the main controller
            picker.dismiss(animated: true, completion: {
                if #available(iOS 13.0, *) {
                    cropController.modalPresentationStyle = .fullScreen;
                } else {
                    // Fallback on earlier versions
                }
                self.present(cropController, animated: true, completion: nil)
                //self.navigationController!.pushViewController(cropController, animated: true)
            })
        }
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        cropViewController.dismiss(animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            ANLoader.showLoading("", disableUI:true)
            let selectedImage:UIImage = image.resize(withWidth:200)!
            let base64String = selectedImage.toBase64()
            let params = ["CandId":UserDefaults.standard.object(forKey:"cID") as! String,"ImageFile":base64String!] as [String:Any]
            ServerService.AccountInsertProfilePicture(self, params: params, method: "POST", accessToken:Constants.Token,acces:true, callBack:self.getresponseForPic(response:))
        })
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    //aftergettingResponseFrom the server
    func getresponseForPic(response:AnyObject)->()
    {
        ANLoader.hide()
        print(response)
        picUploadData = response as! JSON
        if picUploadData.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if picUploadData["MessageStatus"].intValue == 1
        {
            UserDefaults.standard.set(picUploadData["ImageFile"].stringValue, forKey: "ImageFile")
            NotificationCenter.default.post(name: Notification.Name("updateImage"), object: nil)
            ServerService.ShowAlertMessage(ErrorMessage:Constants.imageMessage, title:"", view:self)
            
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage:picUploadData["Message"].stringValue, title:"", view:self)
        }
    }
    
    func showPopUp() {
        checked = false
        signatureTextField.text = ""
        acaRequire = false
        aca1905cRequire = false
        errorLabel.text = ""
        checkBoxButton.setImage(UIImage(named: "unchecked.png"), for:.normal)
        blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        signatureView.frame = CGRect(x:10, y:100, width:self.view.bounds.width-20, height:280)
        blurEffectView.contentView.addSubview(signatureView)
        view.addSubview(blurEffectView)
    }
    
    
    //employee handbook
    @IBAction func handBookSign(_ sender: UIButton) {
        showPopUp()
    }
    //terms and conditions
    @IBAction func termsSign(_ sender: UIButton) {
        showPopUp()
    }
    
    ////acaConsentView
    @IBAction func acaReceiveElectronically(_ sender: Any) {
        acaRequire = true
        showPopUp()
    }
    
    @IBAction func acaDontReceive(_ sender: UIButton) {
        showPopUp()
    }
    
    //disclosureSign
    @IBAction func disclosureSign(_ sender: Any) {
        showPopUp()
    }
    
    //CAAgreement
    @IBAction func caEmpSign(_ sender: Any) {
        showPopUp()
    }
    
    //protection Sign
    @IBAction func protectionSign(_ sender: Any) {
        showPopUp()
    }
    
    //genderEquality
    @IBAction func genderEquailtySign(_ sender: UIButton) {
        showPopUp()
    }
    
    //consumerSign
    @IBAction func consumerSign(_ sender: Any) {
        showPopUp()
    }
    
    //aca1905c
    @IBAction func aca1095cSignReceive(_ sender: Any) {
        aca1905cRequire = true
        showPopUp()
    }
    
    @IBAction func aca1095cSignDontReceive(_ sender: Any) {
        showPopUp()
    }
    
    //paidSickLeave
    @IBAction func paidSickLeaveSign(_ sender: Any) {
        showPopUp()
    }
    
    //codeOfConduct
    @IBAction func codeOfConductSign(_ sender: Any) {
        showPopUp()
    }
    //wage Rate
    @IBAction func wageRateAction(_ sender: UIButton) {
        showPopUp()
    }
    
    @IBAction func wageRateOneAction(_ sender: UIButton) {
        wageRateCheckBoxOne.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    @IBAction func wageRateTwoAction(_ sender: UIButton) {
        wageRateCheckBoxTwo.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    
    //CAWAGERATE
    @IBAction func caWageRate(_ sender: UIButton) {
        showPopUp()
    }
    
    @IBAction func poeYes(_ sender: UIButton) {
        peoYes.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    
    @IBAction func poeNo(_ sender: UIButton) {
        peoNo.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    
    @IBAction func shiftAction(_ sender: UIButton) {
        shift.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    @IBAction func hrAction(_ sender: UIButton) {
        hour.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    
    @IBAction func dayAction(_ sender: UIButton) {
        day.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    
    @IBAction func weekAction(_ sender: Any) {
        week.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    
    @IBAction func salaryAction(_ sender: Any) {
        salary.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    
    @IBAction func rateAction(_ sender: Any) {
        piecerRate.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    @IBAction func comissionAction(_ sender: Any) {
        comission.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    @IBAction func otherAction(_ sender: Any) {
        caOther.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    
    @IBAction func payYes(_ sender: Any) {
        rateYes.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    @IBAction func payNo(_ sender: Any) {
        rateNo.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    
    @IBAction func agrYes(_ sender: Any) {
        agYes.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    @IBAction func agrNo(_ sender: Any) {
        agNo.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    @IBAction func certAction(_ sender: Any) {
        certCheck.setImage(UIImage(named: "check.png"), for:.normal)
    }
    
    @IBAction func oneAction(_ sender: Any) {
        one.setImage(UIImage(named: "check.png"), for:.normal)
    }
    @IBAction func twoAction(_ sender: Any) {
        two.setImage(UIImage(named: "check.png"), for:.normal)
    }
    @IBAction func threeAction(_ sender: Any) {
        three.setImage(UIImage(named: "check.png"), for:.normal)
    }
    
    @IBAction func fourAction(_ sender: Any) {
        four.setImage(UIImage(named: "check.png"), for:.normal)
    }
    
    
    func convertToJSONString(value: AnyObject) -> String? {
        if JSONSerialization.isValidJSONObject(value) {
            do{
                let data = try JSONSerialization.data(withJSONObject: value, options: [])
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }catch{
            }
        }
        return nil
    }
    
    
    
    @IBAction func submitSignature(_ sender: UIButton) {
        self.submitFormSignatureServiceCall()
    }
    
    func submitFormSignatureServiceCall(){
        
        
        if ConnectionCheck.isConnectedToNetwork()
        {
            if object["FormName"].stringValue == "HandBook"
            {
                if checked
                {
                    if signatureTextField.text!.count>0
                    {
                        self.view.endEditing(true)
                        ServerService.showActivityIndicatory(uiView:self.view)
                        let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextField.text!,"AgreementId":object["AgreementId"].stringValue,"FormName":object["FormName"].stringValue]
                        print(params)
                        ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                    }
                    else
                    {
                        errorLabel.text = "Signature Should Match to Your FirstName and LastName"
                    }
                    
                }
                else
                {
                    errorLabel.text = "Please check the checkbox before submitting signature"
                }
            }
            
            else if object["FormName"].stringValue == "ACAElectronicDeliveryConsent"
            {
                if checked
                {
                    if signatureTextField.text!.count>0
                    {
                        ServerService.showActivityIndicatory(uiView:self.view)
                        if acaRequire
                        {
                            let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextField.text!,"FormName":object["FormName"].stringValue,"ACADecline":"","AcaDeclineSignName":""]
                            print(params)
                            ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                        }
                        else
                        {
                            let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":"","FormName":object["FormName"].stringValue,"ACADecline":"1","AcaDeclineSignName":signatureTextField.text!]
                            print(params)
                            ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                        }
                    }
                    else
                    {
                        errorLabel.text = "Signature Should Match to Your FirstName and LastName"
                    }
                    
                }
                else
                {
                    errorLabel.text = "Please check the checkbox before submitting signature"
                }
                
            }
            
            else if object["FormName"].stringValue == "ACA1095CConsent"
            {
                if checked
                {
                    if signatureTextField.text!.count>0
                    {
                        ServerService.showActivityIndicatory(uiView:self.view)
                        if aca1905cRequire
                        {
                            let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextField.text!,"FormName":object["FormName"].stringValue,"ACADecline":""]
                            print(params)
                            ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                        }
                        else
                        {
                            let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextField.text!,"FormName":object["FormName"].stringValue,"ACADecline":"1"]
                            print(params)
                            ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                        }
                    }
                    else
                    {
                        errorLabel.text = "Signature Should Match to Your FirstName and LastName"
                    }
                }
                else
                {
                    errorLabel.text = "Please check the checkbox before submitting signature"
                }
                
            }
            
            else if object["FormName"].stringValue == "WageRateForm"
            {
                if checked
                {
                    if signatureTextField.text!.count>0
                    {
                        let date = Date()
                        let formatter = DateFormatter()
                        formatter.locale = Locale.preferredLocale()
                        formatter.dateFormat = "MM/dd/yyyy"
                        let result = formatter.string(from: date)
                        
                        //ANLoader.showLoading("", disableUI:false)
                        ServerService.showActivityIndicatory(uiView:self.view)
                        let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextField.text!,"FormName":object["FormName"].stringValue,"OrderId":object["OrderId"].stringValue,"CompanyName":object["CompanyName"].stringValue,"DbaName":object["DbaName"].stringValue,"PreparerName":object["PreparerName"].stringValue,"CompAddress":object["CompAddress"].stringValue,"CompCity":object["CompCity"].stringValue,"CompState":object["CompState"].stringValue,"CompZip":object["CompZip"].stringValue,"CompPhone":object["CompPhone"].stringValue,"SignedDate":result,"prepSignDate":object["prepSignDate"].stringValue,"WageRateFullText":object["WageRateFullText"].stringValue]
                        print(params)
                        ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                    }
                    else
                    {
                        errorLabel.text = "Signature Should Match to Your FirstName and LastName"
                    }
                }
                else
                {
                    errorLabel.text = "Please check the checkbox before submitting signature"
                }
            }
            
            else if object["FormName"].stringValue == "CaliforniaWageRateForm"
            {
                if checked
                {
                    if signatureTextField.text!.count>0
                    {
                        let date = Date()
                        let formatter = DateFormatter()
                        formatter.locale = Locale.preferredLocale()
                        formatter.dateFormat = "MM/dd/yyyy"
                        let result = formatter.string(from: date)
                        
                        
                        //ANLoader.showLoading("", disableUI:false)
                        ServerService.showActivityIndicatory(uiView:self.view)
                        let params:[String:String] = ["CandID":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextField.text!,"FormName":object["FormName"].stringValue,"OrderId":object["OrderId"].stringValue,"CompanyName":object["CompanyName"].stringValue,"PreparerName":object["PreparerName"].stringValue,"CompAddress":object["CompAddress"].stringValue,"CompCity":object["CompCity"].stringValue,"CompState":object["CompState"].stringValue,"CompZip":object["CompZip"].stringValue,"CompPhone":object["CompPhone"].stringValue,"ApplicantSignDateTime":result,"Hiredate":object["Hiredate"].stringValue,"WageRateFullText":object["WageRateFullText"].stringValue,"DesignatedPayDay":object["DesignatedPayDay"].stringValue,"ApplicantSignature":signatureTextField.text!]
                        print(params)
                        ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                    }
                    else
                    {
                        errorLabel.text = "Signature Should Match to Your FirstName and LastName"
                    }
                }
                else
                {
                    errorLabel.text = "Please check the checkbox before submitting signature"
                }
            }
            else
            {
                if object["ASHTSkip"].stringValue == "1" {
                    ServerService.showActivityIndicatory(uiView:self.view)
                    let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":"","FormName":object["FormName"].stringValue]
                    print(params)
                    ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                    
                }
                else {
                    if checked
                    {
                        if signatureTextField.text!.count>0
                        {
                            ServerService.showActivityIndicatory(uiView:self.view)
                            let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextField.text!,"FormName":object["FormName"].stringValue]
                            print(params)
                            ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                        }
                        else
                        {
                            errorLabel.text = "Signature Should Match to Your FirstName and LastName"
                        }
                    }
                    else
                    {
                        errorLabel.text = "Please check the checkbox before submitting signature"
                    }
                    
                }
            }
        }
        else
        {
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
    }
    //submitSignature Response
    func getresponseFormResponse(response:AnyObject)->()
    {
        ANLoader.hide()
        ServerService.hideProgressView()
        removeAll()
        signedObjectResponse = response as! JSON
        print("viv line 1422\(signedObjectResponse)***")
        if signedObjectResponse["Status"].stringValue == "Success"
        {
            if ConnectionCheck.isConnectedToNetwork()
            {
                blurEffectView.removeFromSuperview()
                //ANLoader.showLoading("", disableUI:false)
                ServerService.showActivityIndicatory(uiView:self.view)
                let params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"ASHTSkipStatus":"0"]
                print("viv its from getresponseFormResponse \(params)***")
                ServerService.getEnterTimeSlipWeekEnds(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponse(response:))
            }
            else
            {
                ANLoader.hide()
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            }
        }
        else
        {
            errorLabel.text = signedObjectResponse["Message"].stringValue
        }
        
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        blurEffectView.removeFromSuperview()
    }
    
    @IBAction func closePopUpAction(_ sender: UIButton) {
        blurEffectView.removeFromSuperview()
    }
    @IBAction func checkboxAction(_ sender: UIButton) {
        if checked
        {
            checkBoxButton.setImage(UIImage(named: "unchecked.png"), for:.normal)
            checked = false
        }
        else
        {
            checkBoxButton.setImage(UIImage(named:"check.png"), for:.normal)
            checked = true
        }
        
    }
    func removeAll()  {
        
        DispatchQueue.main.async {
            self.employeeHandBookView.removeFromSuperview()
            self.termsAndConditionsView.removeFromSuperview()
            self.consumerView.removeFromSuperview()
            self.acaConsentView.removeFromSuperview()
            self.acaConsentForm1095CView.removeFromSuperview()
            self.disclosureConsentview.removeFromSuperview()
            self.conscientiousEmployeeProtectionAct.removeFromSuperview()
            self.genderEqualityView.removeFromSuperview()
            self.caWageRate.removeFromSuperview()
            self.wageRateForm.removeFromSuperview()
            self.payGuardView.removeFromSuperview()
            self.codeOfConductView.removeFromSuperview()
            self.paidSickLeaveFAQView.removeFromSuperview()
            self.caEmpAgreement.removeFromSuperview()
            self.formView.removeFromSuperview()
        }
    }
    
    @IBAction func formSignAction(_ sender: UIButton) {
        if formSubmitButton.currentTitle == "Skip" {
            self.submitFormSignatureServiceCall()
        }
        else {
            showPopUp()
        }
    }
    
    
    func askLanguage()
    {
        // Create the alert controller
        let alertController = UIAlertController(title: "Please", message: "Select a language", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "English", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.language = "English"
            self.languageForms()
        }
        let cancelAction = UIAlertAction(title: "Spanish", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.language = "Spanish"
            self.languageForms()
        }
        
        // Add the actions
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func languageForms()
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:self.view)
            let params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Language":language,"ASHTSkipStatus":"0"]
            print("viv languageforms \(params)***")
            ServerService.getEnterTimeSlipWeekEnds(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponse(response:))
            language = ""
        }
        else
        {
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
    }
    
    
    func getresponseForNext(response:AnyObject)->()
    {
        ANLoader.hide()
        ServerService.hideProgressView()
        nextObject = response as! JSON
        print(response)
        if nextObject["Status"].stringValue == "Success"
        {
            
        }
        else
        {
            
        }
        
    }
    
    
    func getresponseForDetail(response:AnyObject)->()
    {
        ANLoader.hide()
        ServerService.hideProgressView()
        detailData = response as! JSON
        print(response)
        if detailData.isEmpty
        {
            print("empty")
            //timeSlipTableView.isUserInteractionEnabled = true
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else
        {
            if timeSlipNextObject["IsCAOrder"].stringValue == "1" {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "MainNew", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "CAEnterTimeSlipsController") as! CAEnterTimeSlipsController
                viewController.MealBreakCount = timeSlipNextObject["MealBreakCount"].stringValue
                viewController.orderId = orderId
                viewController.weekEnd = weekEnd
                viewController.division = division
                viewController.object = detailData
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else {
                self.performSegue(withIdentifier: "detailSegue", sender: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //timeSlipTableView.isUserInteractionEnabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //timeSlipTableView.isUserInteractionEnabled = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    //catching the device orentation
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            if self.view.bounds.height<=568
            {
                infoView.frame = CGRect(x:10, y:self.view.bounds.height/2-90, width: self.view.bounds.width-20, height:250)
            }
            else
            {
                infoView.frame = CGRect(x:10, y:self.view.bounds.height/2-90, width: self.view.bounds.width-20, height:250)
            }
            formViewFrames()
        case .landscapeLeft:
            text="LandscapeLeft"
            if self.view.bounds.height<=568
            {
                infoView.frame = CGRect(x:10, y:self.view.bounds.height/2-90, width: self.view.bounds.width-20, height:250)
            }
            else
            {
                infoView.frame = CGRect(x:10, y:self.view.bounds.height/2-90, width: self.view.bounds.width-20, height:250)
            }
            formViewFrames()
        case .landscapeRight:
            text="LandscapeRight"
            if self.view.bounds.height<=568
            {
                infoView.frame = CGRect(x:10, y:self.view.bounds.height/2-90, width: self.view.bounds.width-20, height:250)
            }
            else
            {
                infoView.frame = CGRect(x:10, y:self.view.bounds.height/2-90, width: self.view.bounds.width-20, height:250)
            }
            formViewFrames()
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
    }
    
    
    func formViewFrames()
    {
        formView.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
        acaConsentView.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
        acaConsentForm1095CView.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
        payGuardView.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
        wageRateForm.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
        caWageRate.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
    }
    
    func getTimeSlipsData(){
        if ConnectionCheck.isConnectedToNetwork()
        {
            blurEffectView.removeFromSuperview()
            ServerService.showActivityIndicatory(uiView:self.view)
            let params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"ASHTSkipStatus":"\(ASHTSkipStatus)"]
            print("Get Timeslips Dates \(params)")
            ServerService.getEnterTimeSlipWeekEnds(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponse(response:))
        }
        else
        {
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
    }
    
    
}

//END OF CLASS

extension EnterTimeSlipsViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var scheduleString = String()
        for string in 0..<enterTimeSlipAssignments[indexPath.section].schedule.count
        {
            scheduleString += enterTimeSlipAssignments[indexPath.section].schedule[string].replace(target:"\n\r", withString:" -- ").replace(target: "\n", withString:"")+" \r\n"
        }
        let heightOfRow = Constants.calculateHeight(inString:scheduleString,width:self.view.bounds.size.width)
        return (heightOfRow+220)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            return 5
        }
        else
        {
            return 10
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        orderId = enterTimeSlipAssignments[indexPath.section].orderId!
        division = enterTimeSlipAssignments[indexPath.section].division!
        clickedRow = true
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:self.view)
            let params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Flag":"","OrderId":orderId]
            print(params)
            ServerService.timeSlipNext(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: OnClickgetresponse(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
    }
}


extension EnterTimeSlipsViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return enterTimeSlipAssignments.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedData["Weekending"].arrayValue.count>0
        {
            return 1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "etCell") as! EnterTimeSlipTableViewCell
        cell.clientNameLabel.text = enterTimeSlipAssignments[indexPath.section].clientName!
        cell.referenceLabel.text = enterTimeSlipAssignments[indexPath.section].reference!
        cell.postitionLabel.text = enterTimeSlipAssignments[indexPath.section].position!
        
        cell.assignementTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        cell.postitionTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        cell.referenceTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        cell.scheduleTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        
        var scheduleString = String()
        var days = String()
        for string in 0..<enterTimeSlipAssignments[indexPath.section].schedule.count
        {
            days += enterTimeSlipAssignments[indexPath.section].schedule[string].substring(to: 3)+"\r\n"
            scheduleString += enterTimeSlipAssignments[indexPath.section].schedule[string].substring(with:6..<enterTimeSlipAssignments[indexPath.section].schedule[string].count).replace(target:"\n\r", withString:"--").replace(target:"\n",withString:"").replace(target: " ", withString:"")+"\r\n"
        }
        if self.view.bounds.size.height <= 568
        {
            cell.scheduleLabel.font = UIFont.boldSystemFont(ofSize:11)
            //cell.scheduleLabel.font = UIFont.systemFont(ofSize:11)
            cell.scheduleTimeLabel.font = UIFont.systemFont(ofSize: 11)
        }
        else
        {
            //cell.scheduleLabel.font = UIFont.systemFont(ofSize:13)
            cell.scheduleLabel.font = UIFont.boldSystemFont(ofSize:13)
            cell.scheduleTimeLabel.font = UIFont.systemFont(ofSize: 13)
        }
        cell.scheduleLabel.text = days
        
        cell.scheduleTimeLabel.text = scheduleString
        cell.selectionStyle = .none
        return cell
    }
}

extension EnterTimeSlipsViewController:wageRateDelegate
{
    func wageRateStatus(success: Bool) {
        print("success")
        ASHTSkipStatus = 0
        getTimeSlipsData()
    }
    
    
}

extension EnterTimeSlipsViewController:formDelegate
{
    func formStatus(success: Bool, skipStatus: Int) {
        print("success")
        ASHTSkipStatus = skipStatus
        getTimeSlipsData()
    }
    
}
extension EnterTimeSlipsViewController: popAlertDelegate
{
    func formStatus(success: Bool) {
        callSelectedWeekendForETC(item: self.selectWeekButton.currentTitle!)
    }
    
}

