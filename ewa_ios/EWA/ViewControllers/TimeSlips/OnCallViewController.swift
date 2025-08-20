//
//  OnCallViewController.swift
//  EWA
//
//  Created by NFC Solutions on 21/11/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import DropDown
import MobileCoreServices
import ANLoader
import WebKit
import ActiveLabel
import CropViewController


class OnCallViewController: UIViewController,UIScrollViewDelegate,UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,CropViewControllerDelegate{
    
    @IBOutlet var weeklyTimeErrorLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var overTimeView: UIView!
    @IBOutlet var weeklyTimeView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var timeView: UIView!
    var activeTextField: UITextField?
    
    @IBOutlet var jobView: UIView!
    @IBOutlet var oneJobView: UIView!
    @IBOutlet var endTimeField: UITextField!
    @IBOutlet var startTimeField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var timeSlipButton: UIButton!
    @IBOutlet var weeklyTimeButton: UIButton!
    @IBOutlet var overtTimeButton: UIButton!
    var object: JSON = JSON.null
    var entryData:  JSON = JSON.null
    var submitData: JSON = JSON.null
    var deleteData: JSON = JSON.null
    var weekSubmitData: JSON = JSON.null
    var picUploadData:JSON = JSON.null
    var signedObjectResponse:JSON = JSON.null
    var theme: SambagTheme = .light
    var ASHTSkipStatus = Int()
    
    @IBOutlet var contentViewHeight: NSLayoutConstraint!
    @IBOutlet var buttonView: UIView!
    
    @IBOutlet var height: NSLayoutConstraint!
    @IBOutlet var selectJobDropDwon: PKButton!
    @IBOutlet var dropDownView: UIView!
    var weekItems = [String]()
    var workItems = [String]()
    var matterItems = [String]()
    var jobs = [String]()
    
    @IBOutlet var selectWeek: PKButton!
    @IBOutlet weak var selectMatterButton: PKButton!
    @IBOutlet weak var workPerformedButton: PKButton!
    
    @IBOutlet var assignmentLabel: UILabel!
    @IBOutlet var startDateLabel: UILabel!
    @IBOutlet var referenceLabel: UILabel!
    @IBOutlet var endTimeLabel: UILabel!
    
    let chooseArticleDropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.chooseArticleDropDown
        ]
    }()
    
    @IBOutlet var weeklyTableView: UITableView!
    @IBOutlet var otTableView: UITableView!
    
    var mondays = Array<JSON>()
    var tuesdays = Array<JSON>()
    var wednesdays = Array<JSON>()
    var thursdays = Array<JSON>()
    var fridays = Array<JSON>()
    var sarturdays = Array<JSON>()
    var sundays = Array<JSON>()
    
    var selectWorkPerformed = String()
    var selectMatter = String()
    // var newMatter = String()
    var orderId = String()
    //var newWorkPerformed = String()
    
    @IBOutlet var noTaksLabel: UILabel!
    @IBOutlet var totalTimeLabel: UILabel!
    @IBOutlet var addnewMatterTextField: UITextField!
    @IBOutlet var addNewMatterHeight: NSLayoutConstraint!
    
    @IBOutlet var addWorkHeightConstrain: NSLayoutConstraint!
    @IBOutlet var addWorkTextView: UITextView!
    var addMatter = Bool()
    var addWork = Bool()
    var edit = Bool()
    var delete = Bool()
    var detailId = 0
    
    @IBOutlet var submitButtonForWeek: UIButton!
    @IBOutlet var addMatterButton: UIButton!
    @IBOutlet var aveExpensesButton: UIButton!
    @IBOutlet var submitTimeButton: UIButton!
    var selectedIndexPath = IndexPath()
    var fileName = String()
    var fileExt = String()
    var fileData = Data()
    var fileBytes = String()
    var formsData:JSON = JSON.null
    @IBOutlet var chooseFileTextField: UITextField!
    @IBOutlet var amountTextField: UITextField!
    @IBOutlet var workPerformedConstrain: NSLayoutConstraint!
    @IBOutlet var workPerformedLabelConstarin: NSLayoutConstraint!
    
    @IBOutlet var workDropImage: UIImageView!
    
    
    var blurEffect = UIBlurEffect()
    var blurEffectView = UIVisualEffectView()
    
    
    var checked = Bool()
    var acaRequire = Bool()
    var aca1905cRequire = Bool()
    
    
    
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
    @IBOutlet weak var aca1905WebView: WKWebView!
    
    
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
    
    
    //formView
    @IBOutlet var formView: UIView!
    @IBOutlet weak var formWebView: WKWebView!
    
    
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateNavigationBarColor()
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        self.automaticallyAdjustsScrollViewInsets = false
        
        timeView.frame =  CGRect(x: 0, y:0, width: self.view.bounds.size.width, height:690)
        
        
        scrollView.isScrollEnabled = true
        buttonView.isHidden = true
        contentView.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
            ANLoader.hide()
        })
        ASHTSkipStatus = 0
        self.getOnCallWeekends()
        
        
        
        scrollView.delegate = self
        
        noTaksLabel.isHidden = true
        submitButtonForWeek.isHidden = true
        addnewMatterTextField.isHidden = true
        addWorkTextView.isHidden = true
        addWorkTextView.placeholder = "Other Work Performed"
        
        timeSlipButton.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        weeklyTimeButton.backgroundColor = UIColor(hexString:"#EFEFF4")
        overtTimeButton.backgroundColor = UIColor(hexString:"#EFEFF4")
        timeSlipButton.setTitleColor(UIColor.white, for:.normal)
        weeklyTimeButton.setTitleColor(UIColor.black, for:.normal)
        overtTimeButton.setTitleColor(UIColor.black, for:.normal)
        
        overtTimeButton.titleLabel?.textAlignment = .center
        self.workPerformedButton.titleLabel?.textAlignment = .left
        self.selectJobDropDwon.titleLabel?.textAlignment = .left
        self.selectMatterButton.titleLabel?.textAlignment = .left
        
        
        let dollarLabel = UILabel()
        dollarLabel.frame = CGRect(x:0, y:5, width:25, height:25)
        dollarLabel.backgroundColor = .white
        dollarLabel.textAlignment = .center
        dollarLabel.text = "$"
        dollarLabel.font = UIFont.systemFont(ofSize:17)
        amountTextField.leftViewMode = .always
        amountTextField.leftView = dollarLabel
        
        
        
        
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
        
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal("To indicate you would prefer")
            .bold("NOT")
            .normal("to receive the ACA form electronically, We will ask you to sign this form electronically by clicking the “Press to Sign” box to the right.")
        formattedString.addAttribute(NSAttributedStringKey.foregroundColor, value:UIColor.black, range: NSRange(location:0,length:formattedString.length))
        aca1905Label.attributedText = formattedString
        
        
    }
    
    func getOnCallWeekends(){
        if ConnectionCheck.isConnectedToNetwork()
        {
            //ANLoader.showLoading("", disableUI:true)
            ServerService.showActivityIndicatory(uiView:self.view)
            let params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"FormCheckFlag":"OnCallCounsel","ASHTSkipStatus":"\(ASHTSkipStatus)"]
            print(params)
            ServerService.getOncallcounselWeekEnding(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponse(response:))
        }
        else
        {
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
    }
    
    func alert(_ title: String, message: String) {
        print("tapped")
        //ANLoader.showLoading("", disableUI:false)
        ServerService.showActivityIndicatory(uiView:self.view)
        let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "cID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":UserDefaults.standard.object(forKey:"CandName") as! String,"FormName":object["FormName"].stringValue]
        print(params)
        ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
    }
    
    
    
    
    func setupChooseArticleDropDown(anchorView:UIButton,items:[String]) {
        chooseArticleDropDown.anchorView = anchorView
        chooseArticleDropDown.bottomOffset = CGPoint(x: 0, y: selectMatterButton.bounds.height)
        chooseArticleDropDown.backgroundColor = .white
        chooseArticleDropDown.dataSource =  items
        chooseArticleDropDown.selectionAction = { [unowned self] (index,item) in
            print(self.index)
            print(item)
            if anchorView == self.selectWeek
            {
                self.selectWeek.setTitle((item), for:.normal)
                self.edit = false
                self.submitTimeButton.setTitle("Add Time", for:.normal)
                self.timeSlipButton.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
                self.weeklyTimeButton.backgroundColor = UIColor(hexString:"#EFEFF4")
                self.overtTimeButton.backgroundColor = UIColor(hexString:"#EFEFF4")
                self.timeSlipButton.setTitleColor(UIColor.white, for:.normal)
                self.weeklyTimeButton.setTitleColor(UIColor.black, for:.normal)
                self.overtTimeButton.setTitleColor(UIColor.black, for:.normal)
                DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
                    ANLoader.hide()
                })
                if ConnectionCheck.isConnectedToNetwork()
                {
                    //ANLoader.showLoading("", disableUI:true)
                    ServerService.showActivityIndicatory(uiView:self.view)
                    let params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"weekend":item]
                    ServerService.getOncallcounselWeekEndTimeEntry(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: self.getresponseForEntry(response:))
                }
                else
                {
                    ANLoader.hide()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                }
                
            }
            else if anchorView == self.workPerformedButton
            {
                if item == "Other"
                {
                    if self.addWork
                    {
                        self.addWork = false
                    }
                    else
                    {
                        self.addWorkTextView.isHidden = false
                        self.addWorkHeightConstrain.constant += 50
                        self.addWork = true
                    }
                }
                else
                {
                    if self.addWork
                    {
                        self.addWorkTextView.isHidden = false
                        self.addWorkHeightConstrain.constant -= 50
                        self.addWork = false
                    }
                }
                self.selectWorkPerformed = item
                self.workPerformedButton.setTitle((item), for:.normal)
            }
            else if anchorView == self.selectMatterButton
            {
                self.selectMatter = item
                self.selectMatterButton.setTitle((item), for:.normal)
                if item == "Lunch Break"
                {
                    self.workPerformedConstrain.constant = 0
                    self.workPerformedLabelConstarin.constant = 0
                    self.workDropImage.isHidden = true
                    self.addMatterButton.isHidden = true
                    self.selectWorkPerformed = ""
                }
                else
                {
                    self.workPerformedConstrain.constant = 40
                    self.workPerformedLabelConstarin.constant = 20
                    self.workDropImage.isHidden = false
                    self.addMatterButton.isHidden = false
                }
                
            }
            else
            {
                self.orderId = self.entryData["BindAvailableJob"][index]["ID"].stringValue
                self.edit = false
                self.submitTimeButton.setTitle("Add Time", for:.normal)
                self.timeSlipButton.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
                self.weeklyTimeButton.backgroundColor = UIColor(hexString:"#EFEFF4")
                self.overtTimeButton.backgroundColor = UIColor(hexString:"#EFEFF4")
                self.timeSlipButton.setTitleColor(UIColor.white, for:.normal)
                self.weeklyTimeButton.setTitleColor(UIColor.black, for:.normal)
                self.overtTimeButton.setTitleColor(UIColor.black, for:.normal)
                DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
                    ANLoader.hide()
                })
                if ConnectionCheck.isConnectedToNetwork()
                {
                    //ANLoader.showLoading("", disableUI:true)
                    ServerService.showActivityIndicatory(uiView:self.view)
                    let params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"weekend":(self.selectWeek.titleLabel?.text)!,"orderId":self.orderId]
                    ServerService.getOncallcounselWeekEndTimeEntry(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: self.getresponseForEntry(response:))
                }
                else
                {
                    ANLoader.hide()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                }
                
                self.selectJobDropDwon.setTitle((item), for:.normal)
            }
        }
    }
    @IBAction func selectMatter(_ sender: PKButton) {
        
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        setupChooseArticleDropDown(anchorView:sender,items:matterItems)
        chooseArticleDropDown.show()
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
        print(object)
        if object.isEmpty
        {
            removeAll()
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if object["Status"].stringValue == "Fail"
        {
            
            noTaksLabel.isHidden = false
            noTaksLabel.backgroundColor = UIColor(hexString:"#f2dede")
            noTaksLabel.text = object["Message"].stringValue
            
            
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
            self.navigationItem.titleView = tlabel
            
            if object["FormName"].stringValue.count>0
            {
                
                //                if object["FormName"].stringValue == "HandBook"
                //                {
                //
                //                    formView.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                //
                //                    self.view.addSubview(formView)
                //                    self.view.bringSubview(toFront:formView)
                //                    let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
                //                    let request = URLRequest(url: url!)
                //                    formWebView.load(request)
                //                }
                //                else if object["FormName"].stringValue == "TermsAndConditions"
                //                {
                //
                //                    formView.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                //
                //                    self.view.addSubview(formView)
                //                    self.view.bringSubview(toFront:formView)
                //                    let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
                //                    let request = URLRequest(url: url!)
                //                    formWebView.load(request)
                //                }
                //else
                if object["FormName"].stringValue == "ACAElectronicDeliveryConsent"
                {
                    
                    acaConsentView.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                    
                    self.view.addSubview(acaConsentView)
                    self.view.bringSubview(toFront:acaConsentView)
                    let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
                    let request = URLRequest(url: url!)
                    acaWebView.load(request)
                    
                }
                //                else if object["FormName"].stringValue == "ConsumerReports"
                //                {
                //
                //                    formView.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                //                    self.view.addSubview(formView)
                //                    self.view.bringSubview(toFront:formView)
                //                    let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
                //                    let request = URLRequest(url: url!)
                //                    formWebView.load(request)
                //                }
                //                else if object["FormName"].stringValue == "DisclosureConsentForm"
                //                {
                //
                //                    formView.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                //                    self.view.addSubview(formView)
                //                    self.view.bringSubview(toFront:formView)
                //                    let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
                //                    let request = URLRequest(url: url!)
                //                    formWebView.load(request)
                //
                //                }
                //                else if object["FormName"].stringValue == "PaidSickLeaveFAQ"
                //                {
                //
                //                    formView.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                //                    self.view.addSubview(formView)
                //                    self.view.bringSubview(toFront:formView)
                //                    let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
                //                    let request = URLRequest(url: url!)
                //                    formWebView.load(request)
                //
                //                }
                //                else if object["FormName"].stringValue == "CaliforniaEmployeeAgreement"
                //                {
                //
                //                    formView.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                //                    self.view.addSubview(formView)
                //                    self.view.bringSubview(toFront:formView)
                //                    let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
                //                    let request = URLRequest(url: url!)
                //                    formWebView.load(request)
                //
                //                }
                else if object["FormName"].stringValue == "ACA1095CConsent"
                {
                    
                    acaConsentForm1095CView.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                    self.view.addSubview(acaConsentForm1095CView)
                    self.view.bringSubview(toFront:acaConsentForm1095CView)
                    let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
                    let request = URLRequest(url: url!)
                    aca1905WebView.load(request)
                    
                }
                //                else if object["FormName"].stringValue == "EmployeeProtectionAct"
                //                {
                //
                //                    formView.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                //                    self.view.addSubview(formView)
                //                    self.view.bringSubview(toFront:formView)
                //                    let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
                //                    let request = URLRequest(url: url!)
                //                    formWebView.load(request)
                //
                //                }
                //                else if object["FormName"].stringValue == "GenderInEqualityForm"
                //                {
                //
                //                    formView.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                //                    self.view.addSubview(formView)
                //                    self.view.bringSubview(toFront:formView)
                //                    let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
                //                    let request = URLRequest(url: url!)
                //                    formWebView.load(request)
                //
                //                }
                else if object["FormName"].stringValue == "PayCardChangeAcknowledgementForm"
                {
                    
                    payGuardView.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                    self.view.addSubview(payGuardView)
                    self.view.bringSubview(toFront:payGuardView)
                    
                }
                
                //                else if object["FormName"].stringValue == "HealthCareCodeOfConduct"
                //                {
                //                    formView.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                //                    self.view.addSubview(formView)
                //                    self.view.bringSubview(toFront:formView)
                //                    let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:""))
                //                    let request = URLRequest(url: url!)
                //                    formWebView.load(request)
                //
                //                }
                else if object["FormName"].stringValue == "WageRateForm"
                {
                    let formView = Bundle.main.loadNibNamed("WageRate", owner: nil, options: nil)![0] as! WageRate
                    formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height)
                    formView.object = object
                    formView.setUp()
                    formView.wagRateDelegate = self
                    self.view.addSubview(formView)
                    self.view.bringSubview(toFront:formView)
                    /*
                     wageRateForm.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                     self.view.addSubview(wageRateForm)
                     self.view.bringSubview(toFront:wageRateForm)
                     if object["Hiring"].boolValue == true
                     {
                     hiring.setImage(UIImage(named:"radio.png"), for:.normal)
                     }
                     if object["onorbeforefebfirst"].boolValue == true
                     {
                     onFeb.setImage(UIImage(named:"radio.png"), for:.normal)
                     }
                     if object["BeforeChangeInPayRate"].boolValue == true
                     {
                     beforeChange.setImage(UIImage(named:"radio.png"), for:.normal)
                     }
                     if object["RegularPayDay"].boolValue == true
                     {
                     regularPay.setImage(UIImage(named:"radio.png"), for:.normal)
                     }
                     if object["UnknownPayDay"].boolValue == true
                     {
                     unknownPay.setImage(UIImage(named:"radio.png"), for:.normal)
                     }
                     if object["AverageWageRate"].boolValue == true
                     {
                     avgRate.setImage(UIImage(named:"radio.png"), for:.normal)
                     }
                     if object["EmployeeRate"].boolValue == true
                     {
                     employRate.setImage(UIImage(named:"radio.png"), for:.normal)
                     }
                     if object["None"].boolValue == true
                     {
                     none.setImage(UIImage(named:"radio.png"), for:.normal)
                     }
                     if object["Tips"].boolValue == true
                     {
                     tips.setImage(UIImage(named:"radio.png"), for:.normal)
                     }
                     if object["Meals"].boolValue == true
                     {
                     meals.setImage(UIImage(named:"radio.png"), for:.normal)
                     }
                     if object["Lodging"].boolValue == true
                     {
                     loading.setImage(UIImage(named:"radio.png"), for:.normal)
                     }
                     if object["Other"].boolValue == true
                     {
                     other.setImage(UIImage(named:"radio.png"), for:.normal)
                     }
                     if object["Weekly"].boolValue == true
                     {
                     weekly.setImage(UIImage(named:"radio.png"), for:.normal)
                     }
                     if object["BiWeekly"].boolValue == true
                     {
                     biWeekly.setImage(UIImage(named:"radio.png"), for:.normal)
                     }
                     if object["OtherWeekly"].boolValue == true
                     {
                     other.setImage(UIImage(named:"radio.png"), for:.normal)
                     }
                     */
                }
                else if object["FormName"].stringValue == "CaliforniaWageRateForm"
                {
                    caWageRate.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                    self.view.addSubview(caWageRate)
                    self.view.bringSubview(toFront:caWageRate)
                }
                else
                {
                    /* formView.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                     self.view.addSubview(formView)
                     self.view.bringSubview(toFront:formView)
                     let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:""))
                     let request = URLRequest(url: url!)
                     formWebView.load(request) */
                    
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
        else
        {
            removeAll()
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
            
            noTaksLabel.isHidden = true
            var items = [String]()
            for  i in 0..<object["LastThreeMonthWeekendList"].count
            {
                items.append(object["LastThreeMonthWeekendList"][i].stringValue)
            }
            weekItems = items
            if weekItems.count>0
            {
                self.selectWeek.setTitle(weekItems[0], for:.normal)
                DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
                    ANLoader.hide()
                })
                if ConnectionCheck.isConnectedToNetwork()
                {
                    
                    ServerService.showActivityIndicatory(uiView:self.view)
                    let params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"weekend":weekItems[0]]
                    ServerService.getOncallcounselWeekEndTimeEntry(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: self.getresponseForEntry(response:))
                    
                }
                else
                {
                    ANLoader.hide()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                }
            }
            
        }
    }
    
    @IBAction func selectWorkPerformed(_ sender: Any) {
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        setupChooseArticleDropDown(anchorView:sender as! UIButton,items:workItems)
        chooseArticleDropDown.show()
    }
    
    @IBAction func selectWeek(_ sender: PKButton)
    {
        
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        setupChooseArticleDropDown(anchorView:sender as UIButton,items:weekItems)
        chooseArticleDropDown.show()
    }
    
    @IBAction func timeSlipAction(_ sender: Any)
    {
        contentViewHeight.constant = 940
        scrollView.isScrollEnabled = true
        weeklyTimeView.removeFromSuperview()
        overTimeView.removeFromSuperview()
        contentView.addSubview(timeView)
        
        timeSlipButton.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        weeklyTimeButton.backgroundColor = UIColor(hexString:"#EFEFF4")
        overtTimeButton.backgroundColor = UIColor(hexString:"#EFEFF4")
        timeSlipButton.setTitleColor(UIColor.white, for:.normal)
        weeklyTimeButton.setTitleColor(UIColor.black, for:.normal)
        overtTimeButton.setTitleColor(UIColor.black, for:.normal)
    }
    
    @IBAction func weeklyAction(_ sender: Any)
    {
        delete = false
        scrollView.isScrollEnabled = true
        contentViewHeight.constant = 850
        contentViewHeight.constant += CGFloat(entryData["TimeCardList"].arrayValue.count*200-100)
        weeklyTimeView.frame =  CGRect(x: 0, y: 0, width: Int(self.view.bounds.size.width),height:entryData["TimeCardList"].arrayValue.count*200+500)
        
        //weeklyTableView.isUserInteractionEnabled = false
        timeView.removeFromSuperview()
        overTimeView.removeFromSuperview()
        contentView.addSubview(weeklyTimeView)
        
        timeSlipButton.backgroundColor = UIColor(hexString:"#EFEFF4")
        weeklyTimeButton.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        overtTimeButton.backgroundColor = UIColor(hexString:"#EFEFF4")
        timeSlipButton.setTitleColor(UIColor.black, for:.normal)
        weeklyTimeButton.setTitleColor(UIColor.white, for:.normal)
        overtTimeButton.setTitleColor(UIColor.black, for:.normal)
        
    }
    
    @IBAction func overTmeAction(_ sender: Any)
    {
        
        contentViewHeight.constant = 650
        contentViewHeight.constant += CGFloat(entryData["OCCAuthorizedHours"].arrayValue.count*200)
        overTimeView.frame =  CGRect(x: 0, y: 0, width: Int(self.view.bounds.size.width),height:entryData["OCCAuthorizedHours"].arrayValue.count*200+250)
        weeklyTimeView.removeFromSuperview()
        timeView.removeFromSuperview()
        contentView.addSubview(overTimeView)
        
        timeSlipButton.backgroundColor = UIColor(hexString:"#EFEFF4")
        weeklyTimeButton.backgroundColor = UIColor(hexString:"#EFEFF4")
        overtTimeButton.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        timeSlipButton.setTitleColor(UIColor.black, for:.normal)
        weeklyTimeButton.setTitleColor(UIColor.black, for:.normal)
        overtTimeButton.setTitleColor(.white, for:.normal)
    }
    
    
    //aftergettingResponseFrom the server
    func getresponseForEntry(response:AnyObject)->()
    {
        ANLoader.hide()
        ServerService.hideProgressView()
        contentViewHeight.constant = 940
        mondays.removeAll()
        tuesdays.removeAll()
        wednesdays.removeAll()
        thursdays.removeAll()
        fridays.removeAll()
        sarturdays.removeAll()
        sundays.removeAll()
        entryData = response as! JSON
        print(entryData)
        
        if entryData.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else
        {
            matterItems =  entryData["Matters"].arrayValue.map({$0["Matter"].stringValue})
            workItems = entryData["WorkPerformedList"].arrayValue.map({$0["Name"].stringValue})
            
            if entryData["BindAvailableJob"].arrayValue.count>0
            {
                dropDownView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height:60)
                selectJobDropDwon.setTitle(entryData["BindAvailableJob"][0]["Name"].stringValue,for:.normal)
                jobs = entryData["BindAvailableJob"].arrayValue.map({$0["Name"].stringValue})
                self.orderId = self.entryData["BindAvailableJob"][0]["ID"].stringValue
                oneJobView.removeFromSuperview()
                height.constant = 100
                submitButtonForWeek.isHidden = false
                jobView.addSubview(dropDownView)
            }
            else if entryData["AvailableJobs"].arrayValue.count>0
            {
                height.constant = 170
                dropDownView.removeFromSuperview()
                assignmentLabel.text = entryData["AvailableJobs"][0]["CompanyName"].stringValue
                startDateLabel.text = Constants.getFormattedDateForPersonalJob(string:entryData["AvailableJobs"][0]["StartDate"].stringValue.substring(to: 10))
                endTimeLabel.text = Constants.getFormattedDateForPersonalJob(string:entryData["AvailableJobs"][0]["EndDate"].stringValue.substring(to: 10))
                referenceLabel.text = entryData["AvailableJobs"][0]["PONumber"].stringValue
                orderId = entryData["AvailableJobs"][0]["OrderId"].stringValue
                oneJobView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height:120)
                submitButtonForWeek.isHidden = false
                jobView.addSubview(oneJobView)
            }
            else
            {
                oneJobView.removeFromSuperview()
                dropDownView.removeFromSuperview()
                height.constant = 0
                submitButtonForWeek.isHidden = true
            }
            
            
            
            if entryData["TotalTimeCardList"].arrayValue.count == 0
            {
                weeklyTimeErrorLabel.text = "No orders to show"
            }
            else
            {
                for day in 0..<entryData["TotalTimeCardList"].arrayValue.count
                {
                    if entryData["TotalTimeCardList"][day]["DayOfWeek"].stringValue == "Monday"
                    {
                        mondays.append(entryData["TotalTimeCardList"][day])
                    }
                    else if entryData["TotalTimeCardList"][day]["DayOfWeek"].stringValue == "Tuesday"
                    {
                        tuesdays.append(entryData["TotalTimeCardList"][day])
                    }
                    else if entryData["TotalTimeCardList"][day]["DayOfWeek"].stringValue == "Wednesday"
                    {
                        wednesdays.append(entryData["TotalTimeCardList"][day])
                    }else if entryData["TotalTimeCardList"][day]["DayOfWeek"].stringValue == "Thursday"
                    {
                        thursdays.append(entryData["TotalTimeCardList"][day])
                    }
                    else if entryData["TotalTimeCardList"][day]["DayOfWeek"].stringValue == "Friday"
                    {
                        fridays.append(entryData["TotalTimeCardList"][day])
                    }
                    else if entryData["TotalTimeCardList"][day]["DayOfWeek"].stringValue == "Saturday"
                    {
                        sarturdays.append(entryData["TotalTimeCardList"][day])
                    }
                    else if entryData["TotalTimeCardList"][day]["DayOfWeek"].stringValue == "Sunday"
                    {
                        sundays.append(entryData["TotalTimeCardList"][day])
                    }
                }
                weeklyTimeErrorLabel.text = ""
            }
            dateTextField.text = Constants.getFormattedDate(string:entryData["Date"].stringValue)
            startTimeField.text = entryData["StartTime"].stringValue
            endTimeField.text = entryData["EndTime"].stringValue
            totalTimeLabel.text = entryData["TimeTotal"].stringValue
            let selectMatterToShow = entryData["Matter"].stringValue
            if selectMatterToShow.count>0
            {
                selectMatterButton.setTitle(entryData["Matter"].stringValue, for:.normal)
            }
            else
            {
                selectMatterButton.setTitle("Select Matter", for:.normal)
            }
            
            
            if edit
            {
                selectMatterButton.setTitle(entryData["Matter"].stringValue, for:.normal)
                workPerformedButton.setTitle(entryData["WorkPerformed"].stringValue, for:.normal)
                selectWorkPerformed = entryData["WorkPerformed"].stringValue
                if entryData["WorkPerformed"].stringValue == "Other"
                {
                    if self.addWork
                    {
                        self.addWork = false
                    }
                    else
                    {
                        self.addWorkTextView.isHidden = false
                        self.addWorkHeightConstrain.constant += 50
                        self.addWorkTextView.placeholder = ""
                        self.addWorkTextView.text = entryData["NewWorkPerformed"].stringValue
                        
                        self.addWork = true
                    }
                }
                else
                {
                    if self.addWork
                    {
                        self.addWorkTextView.isHidden = false
                        self.addWorkHeightConstrain.constant -= 50
                        self.addWork = false
                    }
                }
            }
            else
            {
                //selectMatterButton.setTitle("Select Matter", for:.normal)
                workPerformedButton.setTitle("Select Work Performed", for:.normal)
            }
            
            if entryData["Message"].stringValue.count>0
            {
                if entryData["Message"].stringValue == "success"
                {
                    
                }
                else
                {
                    noTaksLabel.isHidden = false
                    noTaksLabel.text = entryData["Message"].stringValue.removeHtmlFromString(inPutString: entryData["Message"].stringValue)
                    contentView.isHidden = true
                    buttonView.isHidden = true
                }
            }
            else
            {
                noTaksLabel.isHidden = true
                contentView.isHidden = false
                buttonView.isHidden = false
                weeklyTimeView.removeFromSuperview()
                overTimeView.removeFromSuperview()
                contentView.addSubview(timeView)
            }
            if entryData["IsEnable"].stringValue == "disabled"
            {
                submitButtonForWeek.isEnabled = false
                addMatterButton.isEnabled = false
                submitTimeButton.isEnabled = false
                aveExpensesButton.isEnabled = false
                submitButtonForWeek.alpha = 0.5
                addMatterButton.alpha = 0.5
                submitTimeButton.alpha = 0.5
                aveExpensesButton.alpha = 0.5
                otTableView.isUserInteractionEnabled = false
            }
            else
            {
                submitButtonForWeek.isEnabled = true
                addMatterButton.isEnabled = true
                submitTimeButton.isEnabled = true
                aveExpensesButton.isEnabled = true
                submitButtonForWeek.alpha = 1
                addMatterButton.alpha = 1
                submitTimeButton.alpha = 1
                aveExpensesButton.alpha = 1
                otTableView.isUserInteractionEnabled = true
            }
            otTableView.reloadData()
            if delete
            {
                self.weeklyTableView.selectRow(at:selectedIndexPath, animated: true, scrollPosition:.none)
                self.weeklyAction(self)
            }
            else
            {
                
            }
            weeklyTableView.reloadData()
        }
    }
    @IBAction func addMatter(_ sender: UIButton) {
        if addMatter
        {
            
        }
        else
        {
            addnewMatterTextField.isHidden = false
            addNewMatterHeight.constant += 40
            addMatter = true
        }
    }
    
    @IBAction func submitAction(_ sender: Any)
    {
        if selectMatter.count>0||addnewMatterTextField.text!.count>0
        {
            if selectWorkPerformed.count>0||addWorkTextView.text.count>0
            {
                
                let confromAlert = UIAlertController(title: "Would you like to save data for this Date", message:"", preferredStyle: UIAlertControllerStyle.alert)
                confromAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { (action:UIAlertAction!) in
                    
                    
                })
                
                var title = String()
                if edit
                {
                    title = "Update Time"
                }
                else
                {
                    title = "Add Time"
                }
                confromAlert.addAction(UIAlertAction(title:title, style: .default) { (action:UIAlertAction!) in
                    
                    //var totalTimeafterConversion = Double()
                    
                    if self.edit
                    {
                        //                        let charset = CharacterSet(charactersIn: ":")
                        //                        if self.totalTimeLabel.text!.rangeOfCharacter(from: charset) != nil {
                        //                            let hours = self.totalTimeLabel.text!
                        //                            let fileArray = hours.components(separatedBy: ":")
                        //                            let hoursToMin:Double = Double(fileArray[0])!
                        //                            var mins = Double()
                        //                            if fileArray.count==2
                        //                            {
                        //                                mins = Double(fileArray[1])!
                        //                            }
                        //                            totalTimeafterConversion = (hoursToMin+mins/60)
                        //                        }
                        //                        else
                        //                        {
                        //                            totalTimeafterConversion = Double(self.totalTimeLabel.text!)!
                        //                        }
                        
                    }
                    else
                    {
                        //                        let hours = self.totalTimeLabel.text!
                        //                        let fileArray = hours.components(separatedBy: ":")
                        //                        let hoursToMin:Double = Double(fileArray[0])!
                        //                        var mins = Double()
                        //                        if fileArray.count==2
                        //                        {
                        //                            mins = Double(fileArray[1])!
                        //                        }
                        //                        totalTimeafterConversion = (hoursToMin+mins/60)
                    }
                    
                    if Double((self.totalTimeLabel.text)!)! == 0
                    {
                        ServerService.ShowAlertMessage(ErrorMessage: "", title:"Timeslip Total hour should not be zero.", view: self)
                    }
                    else
                    {
                        
                        let params:[String:Any] = ["StartTime" : self.startTimeField.text!,
                                                   "EndTime" :self.endTimeField.text!,
                                                   "DivisionId" : UserDefaults.standard.object(forKey: "dID") as! String,
                                                   "CandidateId" : UserDefaults.standard.object(forKey: "cID") as! String,
                                                   "currentdate" : self.dateTextField.text!,
                                                   "OrderId" : self.orderId,
                                                   "WeekendDate" : (self.selectWeek.titleLabel?.text!)!,
                                                   "TimeId" : self.entryData["TimeId"].intValue,
                                                   "Matter" : self.selectMatter,
                                                   "NewMatter" : self.addnewMatterTextField.text!,
                                                   "WorkPerformed" : self.selectWorkPerformed,
                                                   "NewWorkPerformed" : self.addWorkTextView.text!,
                                                   "TotalTime" : self.totalTimeLabel.text!,
                                                   "DetailId" : self.detailId,              // for edit timeslip specify detailid
                                                   "Date" : self.dateTextField.text!,"Source":"iOS"]
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
                            ANLoader.hide()
                        })
                        if ConnectionCheck.isConnectedToNetwork()
                        {
                            //ANLoader.showLoading("", disableUI:true)
                            ServerService.showActivityIndicatory(uiView:self.view)
                            ServerService.getOncallcounselSaveTimeList(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: self.getresponseAddTime(response:))
                        }
                        else
                        {
                            ANLoader.hide()
                            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                        }
                        
                    }
                })
                self.present(confromAlert, animated: true)
                confromAlert.view.tintColor = UIColor(hexString: "#449D44")
            }
            else
            {
                ServerService.ShowAlertMessage(ErrorMessage:"Please Select Work Performed/Enter New Work Performed", title:"", view: self)
            }
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage:"", title:"Please Select Matter/Enter New Matter", view: self)
        }
        
        
    }
    
    
    
    
    //aftergettingResponseFrom the server
    func getresponseAddTime(response:AnyObject)->()
    {
        ANLoader.hide()
        ServerService.hideProgressView()
        submitData = response as! JSON
        print(submitData)
        if submitData.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if submitData["StatusCode"].intValue == 0
        {
            edit = false
            ServerService.ShowAlertMessage(ErrorMessage: "", title: submitData["StatusMessage"].stringValue, view: self)
            submitTimeButton.setTitle("Add Time", for:.normal)
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
            //                ANLoader.hide()
            //            })
            //            if ConnectionCheck.isConnectedToNetwork()
            //            {
            //                ANLoader.showLoading("", disableUI:true)
            //            }
            //            else
            //            {
            //                ANLoader.hide()
            //            }
            let params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"weekend":(selectWeek.titleLabel?.text!)!]
            ServerService.getOncallcounselWeekEndTimeEntry(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: self.getresponseForEntry(response:))
            
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage: "", title: submitData["StatusMessage"].stringValue, view: self)
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
        activeTextField = textField
        
        if textField == dateTextField
        {
            edit = false
            textField.resignFirstResponder()
            submitTimeButton.setTitle("Add Time", for:.normal)
            //            let vc = SambagDatePickerViewController()
            //            vc.theme = theme
            //            vc.delegate = self
            //            present(vc, animated: true, completion: nil)
            datePickerTapped()
        }
        else if textField == chooseFileTextField
        {
            
        }
        else if textField == amountTextField
        {
            
        }
        else
        {
            //let vc = SambagTimePickerViewController()
            textField.resignFirstResponder()
            self.showPicker()
            //            var itemsMin = [Int]()
            //            for i in 0..<entryData["BindActivityMinutesList"].arrayValue.count
            //            {
            //                let item = entryData["BindActivityMinutesList"][i].intValue
            //                if item == 60
            //                {
            //                }
            //                else
            //                {
            //                    itemsMin.append(item)
            //                }
            //
            //            }
            //
            //            var minuteItems = [String]()
            //            for j in 0..<entryData["BindActivityMinutesList"].arrayValue.count
            //            {
            //                let item = entryData["BindActivityMinutesList"][j].stringValue
            //                if item == "0"
            //                {
            //                    minuteItems.append("00")
            //                }
            //                else if item == "60"
            //                {
            //
            //                }
            //                else
            //                {
            //                    minuteItems.append(item)
            //                }
            //            }
            //            vc.minutes = itemsMin
            //            vc.timeMintutes = minuteItems
            //            vc.meridians = []
            //            vc.theme = theme
            //            vc.delegate = self
            //            present(vc, animated: true, completion: nil)
        }
        
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
    }
    
    @IBAction func handleNavgationBarButtonTap(_ sender: UIBarButtonItem, event: UIEvent)
    
    {
        Constants.showUp(event:event,viewController:self)
        
    }
    
    @IBAction func jodAction(_ sender: PKButton)
    {
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        setupChooseArticleDropDown(anchorView:sender as UIButton,items:jobs)
        chooseArticleDropDown.show()
    }
    
    @IBAction func deleteACtion(_ sender: UIButton)
    {
        delete = true
        var params = [String:Any]()
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: self.weeklyTableView)
        let indexPath = self.weeklyTableView.indexPathForRow(at:buttonPosition)
        selectedIndexPath = IndexPath(row: (indexPath?.row)!-1, section:(indexPath?.section)!-1)
        if indexPath?.section == 0
        {
            params = ["DetailId" : mondays[indexPath!.row]["DetailId"].intValue , "TimeID" : entryData["TimeId"].intValue, "IsApproved" : mondays[indexPath!.row]["IsApproved"].intValue,  "weekend" : mondays[indexPath!.row]["Date"].stringValue.substring(to: 10),  "CurrentDate" : mondays[indexPath!.row]["Date"].stringValue.substring(to: 10), "Matter" : mondays[indexPath!.row]["Matter"].stringValue]
        }
        else if indexPath?.section == 1
        {
            params = ["DetailId" : tuesdays[indexPath!.row]["DetailId"].intValue , "TimeID" : entryData["TimeId"].intValue, "IsApproved" : tuesdays[indexPath!.row]["IsApproved"].intValue,  "weekend" : tuesdays[indexPath!.row]["Date"].stringValue.substring(to: 10),  "CurrentDate" : tuesdays[indexPath!.row]["Date"].stringValue.substring(to: 10), "Matter" : tuesdays[indexPath!.row]["Matter"].stringValue]
        }
        else if indexPath?.section == 2
        {
            params = ["DetailId" : wednesdays[indexPath!.row]["DetailId"].intValue , "TimeID" : entryData["TimeId"].intValue, "IsApproved" :wednesdays[indexPath!.row]["IsApproved"].intValue,  "weekend" : wednesdays[indexPath!.row]["Date"].stringValue.substring(to: 10),  "CurrentDate" : wednesdays[indexPath!.row]["Date"].stringValue.substring(to: 10), "Matter" : wednesdays[indexPath!.row]["Matter"].stringValue]
        }
        else if indexPath?.section == 3
        {
            params = ["DetailId" : thursdays[indexPath!.row]["DetailId"].intValue , "TimeID" : entryData["TimeId"].intValue, "IsApproved" : thursdays[indexPath!.row]["IsApproved"].intValue,  "weekend" : thursdays[indexPath!.row]["Date"].stringValue.substring(to: 10),  "CurrentDate" : thursdays[indexPath!.row]["Date"].stringValue.substring(to: 10), "Matter" : thursdays[indexPath!.row]["Matter"].stringValue]
        }
        else if indexPath?.section == 4
        {
            params = ["DetailId" : fridays[indexPath!.row]["DetailId"].intValue , "TimeID" : entryData["TimeId"].intValue, "IsApproved" : fridays[indexPath!.row]["IsApproved"].intValue,  "weekend" : fridays[indexPath!.row]["Date"].stringValue.substring(to: 10),  "CurrentDate" : fridays[indexPath!.row]["Date"].stringValue.substring(to: 10), "Matter" : fridays[indexPath!.row]["Matter"].stringValue]
        }
        else if indexPath?.section == 5
        {
            params = ["DetailId" : sarturdays[indexPath!.row]["DetailId"].intValue , "TimeID" : entryData["TimeId"].intValue, "IsApproved" : sarturdays[indexPath!.row]["IsApproved"].intValue,  "weekend" : sarturdays[indexPath!.row]["Date"].stringValue.substring(to: 10),  "CurrentDate" : sarturdays[indexPath!.row]["Date"].stringValue.substring(to: 10), "Matter" : sarturdays[indexPath!.row]["Matter"].stringValue]
        }
        else if indexPath?.section == 6
        {
            params = ["DetailId" : sundays[indexPath!.row]["DetailId"].intValue , "TimeID" : entryData["TimeId"].intValue, "IsApproved" : sundays[indexPath!.row]["IsApproved"].intValue,  "weekend" : sundays[indexPath!.row]["Date"].stringValue.substring(to: 10),  "CurrentDate" : sundays[indexPath!.row]["Date"].stringValue.substring(to: 10), "Matter" : sundays[indexPath!.row]["Matter"].stringValue]
        }
        if ConnectionCheck.isConnectedToNetwork()
        {
            //ANLoader.showLoading("", disableUI:true)
            ServerService.showActivityIndicatory(uiView:self.view)
            ServerService.getOnCallcounselDeleteTimeSlip(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseDelete(response:))
        }
        else
        {
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
        
    }
    @IBAction func editAction(_ sender: Any)
    {
        submitTimeButton.setTitle("Update Time", for:.normal)
        timeSlipButton.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        weeklyTimeButton.backgroundColor = UIColor(hexString:"#EFEFF4")
        overtTimeButton.backgroundColor = UIColor(hexString:"#EFEFF4")
        timeSlipButton.setTitleColor(UIColor.white, for:.normal)
        weeklyTimeButton.setTitleColor(UIColor.black, for:.normal)
        overtTimeButton.setTitleColor(UIColor.black, for:.normal)
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: self.weeklyTableView)
        let indexPath = self.weeklyTableView.indexPathForRow(at:buttonPosition)
        var params = [String:Any]()
        if indexPath?.section == 0
        {
            params = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"weekend":(selectWeek.titleLabel?.text)!,"DetailId":mondays[indexPath!.row]["DetailId"].intValue,"orderId":orderId]
            selectMatter = mondays[(indexPath?.row)!]["Matter"].stringValue
            selectWorkPerformed = mondays[(indexPath?.row)!]["WorkPerformed"].stringValue
            detailId =
            mondays[indexPath!.row]["DetailId"].intValue
        }
        else if indexPath?.section == 1
        {
            params = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"weekend":(selectWeek.titleLabel?.text)!,"DetailId":tuesdays[indexPath!.row]["DetailId"].intValue,"orderId":orderId]
            selectMatter = tuesdays[(indexPath?.row)!]["Matter"].stringValue
            selectWorkPerformed = tuesdays[(indexPath?.row)!]["WorkPerformed"].stringValue
            detailId = tuesdays[indexPath!.row]["DetailId"].intValue
        }
        else if indexPath?.section == 2
        {
            params = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"weekend":(selectWeek.titleLabel?.text)!,"DetailId":wednesdays[indexPath!.row]["DetailId"].intValue,"orderId":orderId]
            selectMatter = wednesdays[(indexPath?.row)!]["Matter"].stringValue
            selectWorkPerformed = wednesdays[(indexPath?.row)!]["WorkPerformed"].stringValue
            detailId = wednesdays[indexPath!.row]["DetailId"].intValue
        }
        else if indexPath?.section == 3
        {
            params = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"weekend":(selectWeek.titleLabel?.text)!,"DetailId":thursdays[indexPath!.row]["DetailId"].intValue,"orderId":orderId]
            selectMatter = thursdays[(indexPath?.row)!]["Matter"].stringValue
            selectWorkPerformed = thursdays[(indexPath?.row)!]["WorkPerformed"].stringValue
            detailId = thursdays[indexPath!.row]["DetailId"].intValue
        }
        else if indexPath?.section == 4
        {
            params = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"weekend":(selectWeek.titleLabel?.text)!,"DetailId":fridays[indexPath!.row]["DetailId"].intValue,"orderId":orderId]
            selectMatter = fridays[(indexPath?.row)!]["Matter"].stringValue
            selectWorkPerformed = fridays[(indexPath?.row)!]["WorkPerformed"].stringValue
            detailId = fridays[indexPath!.row]["DetailId"].intValue
        }
        else if indexPath?.section == 5
        {
            params = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"weekend":(selectWeek.titleLabel?.text)!,"DetailId":sarturdays[indexPath!.row]["DetailId"].intValue,"orderId":orderId]
            selectMatter = sarturdays[(indexPath?.row)!]["Matter"].stringValue
            selectWorkPerformed = sarturdays[(indexPath?.row)!]["WorkPerformed"].stringValue
            detailId = sarturdays[indexPath!.row]["DetailId"].intValue
        }
        else if indexPath?.section == 6
        {
            params = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"weekend":(selectWeek.titleLabel?.text)!,"DetailId":sundays[indexPath!.row]["DetailId"].intValue,"orderId":orderId]
            selectMatter = sundays[(indexPath?.row)!]["Matter"].stringValue
            selectWorkPerformed = sundays[(indexPath?.row)!]["WorkPerformed"].stringValue
            detailId = sundays[indexPath!.row]["DetailId"].intValue
        }
        contentViewHeight.constant = 940
        scrollView.isScrollEnabled = true
        weeklyTimeView.removeFromSuperview()
        overTimeView.removeFromSuperview()
        contentView.addSubview(timeView)
        edit = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
            ANLoader.hide()
        })
        if ConnectionCheck.isConnectedToNetwork()
        {
            //ANLoader.showLoading("", disableUI:true)
            ServerService.showActivityIndicatory(uiView:self.view)
            ServerService.getOncallcounselWeekEndTimeEntry(self, params: params, method:"POST",accessToken:Constants.Token, acces:true, callBack: self.getresponseForEntry(response:))
        }
        else
        {
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
        
    }
    func getresponseDelete(response:AnyObject)->()
    {
        ANLoader.hide()
        ServerService.hideProgressView()
        deleteData = response as! JSON
        print(deleteData)
        if deleteData.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if deleteData["StatusCode"].intValue == 0
        {
            let params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"weekend":(selectWeek.titleLabel?.text!)!]
            DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
                ANLoader.hide()
            })
            if ConnectionCheck.isConnectedToNetwork()
            {
                //ANLoader.showLoading("", disableUI:true)
                ServerService.showActivityIndicatory(uiView:self.view)
                ServerService.getOncallcounselWeekEndTimeEntry(self, params: params, method:"POST", accessToken:Constants.Token, acces:true,callBack: self.getresponseForEntry(response:))
            }
            else
            {
                ANLoader.hide()
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            }
            
            
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage: "", title:deleteData["Message"].stringValue, view: self)
        }
        
    }
    
    @IBAction func submitWeekTime(_ sender: UIButton)
    {
        let confromAlert = UIAlertController(title: "Time that is submitted for approval cannot be edited, and additional time for the week cannot be entered until payroll has processed for the week. Are you sure you wish submit your time for the week?", message:"", preferredStyle: UIAlertControllerStyle.alert)
        confromAlert.addAction(UIAlertAction(title: "Close", style: .destructive) { (action:UIAlertAction!) in
            
            
        })
        confromAlert.addAction(UIAlertAction(title:"Submit", style: .default) { (action:UIAlertAction!) in
            let params:[String:Any] = ["TimeID" : self.entryData["TimeId"].intValue,"CurrentWeekendDate":(self.selectWeek.titleLabel?.text!)!,"Source":"iOS"]
            DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
                ANLoader.hide()
            })
            if ConnectionCheck.isConnectedToNetwork()
            {
                //ANLoader.showLoading("", disableUI:true)
                ServerService.showActivityIndicatory(uiView:self.view)
                ServerService.getOnCallcounselSaveWeeklyTime(self, params: params, method:"POST", accessToken:Constants.Token,acces:true, callBack: self.getresponseWeekData(response:))
            }
            else
            {
                ANLoader.hide()
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            }
            
        })
        self.present(confromAlert, animated: true)
        confromAlert.view.tintColor = UIColor(hexString: "#449D44")
    }
    
    func getresponseWeekData(response:AnyObject)->()
    {
        ANLoader.hide()
        ServerService.hideProgressView()
        weekSubmitData = response as! JSON
        print(weekSubmitData)
        if weekSubmitData.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if weekSubmitData["StatusCode"].intValue == 0
        {
            ServerService.ShowAlertMessage(ErrorMessage: "", title:weekSubmitData["Message"].stringValue, view: self)
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage: "", title:weekSubmitData["Message"].stringValue, view: self)
        }
    }
    
    
    
    @IBAction func saveExpenses(_ sender: Any)
    {
        if chooseFileTextField.text!.count>0&&amountTextField.text!.count>0
        {
            //server call
            let paramsMenu:[String:Any] = ["TotalExpensesAmount": Int(amountTextField.text!)!,
                                           "CurrentWeekendDate":(self.selectWeek.titleLabel?.text)!,
                                           "CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,
                                           "TimeID":self.entryData["TimeId"].intValue,
                                           "FileName":fileName,
                                           "FileType":fileExt,
                                           "FileBytes": fileBytes
            ]
            DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
                ANLoader.hide()
            })
            if ConnectionCheck.isConnectedToNetwork()
            {
                //ANLoader.showLoading("", disableUI:true)
                ServerService.showActivityIndicatory(uiView:self.view)
                ServerService.getTimeSlipOncallcounselSaveExpenses(self, params: paramsMenu, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseForForms(response:))
            }
            else
            {
                ANLoader.hide()
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            }
            
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage:"", title:"Please Add Amount/Add File", view: self)
        }
    }
    
    @IBAction func chooseFile(_ sender: Any)
    {
        self.showMenu()
    }
    
    
    
    //aftergettingResponseFrom the server
    func getresponseForForms(response:AnyObject)->()
    {
        ANLoader.hide()
        ServerService.hideProgressView()
        print(response)
        formsData = response as! JSON
        if formsData.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if formsData["Status"] == "Success"
        {
            ServerService.ShowAlertMessage(ErrorMessage:"", title: formsData["Message"].stringValue, view: self)
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage:"", title: formsData["Message"].stringValue, view: self)
        }
    }
    
    
    @available(iOS 8.0, *)
    public func documentPicker(_ controller:UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let urlPath = url as URL
        print("The Url is",urlPath)
        
        fileName = urlPath.lastPathComponent
        chooseFileTextField.text = urlPath.lastPathComponent
        fileExt = fileName.fileExtension()
        fileData = try! Data(contentsOf:urlPath)
        fileBytes = fileData.base64EncodedString()
        print(fileBytes)
        
        
        
    }
    
    @available(iOS 8.0, *)
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController)
    {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
        
    }
    func documentPickerWasCancelled(_ controller:UIDocumentPickerViewController) {
        print("we cancelled")
        
        //  dismiss(animated: true, completion: nil)
    }
    func showMenu(){
        
        let importMenu = UIDocumentMenuViewController(documentTypes:[String(kUTTypeContent)], in: .import)
        importMenu.delegate = self
        if #available(iOS 13.0, *) {
            importMenu.modalPresentationStyle = .fullScreen;
        } else {
            // Fallback on earlier versions
        }
        self.present(importMenu, animated: true, completion: nil)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        
    }
    
    
    func showPicker()
    {
        let min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
        let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
        let picker = DateTimePicker.show(selected: Date(), minimumDate: min, maximumDate: max)
        let stepping = entryData["BindActivityMinutesList"][1].intValue - entryData["BindActivityMinutesList"][0].intValue
        
        if stepping == 30
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.thirty
        }
        else if stepping == 15
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.fifteen
        }
        else if stepping == 10
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.ten
        }
        else if stepping == 6
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.six
        }
        else if stepping == 5
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.five
        }
        else if stepping == 1
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.default
        }
        else{
            picker.timeInterval = DateTimePicker.MinuteInterval.default
        }
        picker.highlightColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = "Select"
        picker.doneBackgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        picker.locale = Locale(identifier: "en_GB")
        picker.isDefault = true
        picker.todayButtonTitle = ""
        picker.is12HourFormat = true
        picker.dateFormat = "hh:mm aa"
        picker.isTimePickerOnly = true
        //picker.isDatePickerOnly = true
        picker.includeMonth = false // if true the month shows at top
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.locale = Locale.preferredLocale()
            formatter.dateFormat = "hh:mm aa"
            // self.activeTextField?.text = formatter.string(from: date)
            if self.activeTextField?.tag == 1
            {
                self.startTimeField.text = formatter.string(from: date)
            }
            else
            {
                self.endTimeField.text = formatter.string(from: date)
            }
            if (self.startTimeField.text!.count>0)&&(self.endTimeField.text?.count)!>0
            {
                self.getHours(start: self.startTimeField.text!, end:self.endTimeField.text!)
                
            }
            
            //self.title = formatter.string(from: date)
        }
        picker.delegate = self
        NotificationCenter.default.post(name: Notification.Name("Time"), object: nil)
    }
    
    
    
    
    func datePickerTapped() {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.month = -6
        let sixMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        dateComponents.month = 12
        let twelveMonth =  Calendar.current.date(byAdding: dateComponents, to: currentDate)
        
        let datePicker = DatePickerDialog(textColor: .black,
                                          buttonColor: UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String),
                                          font: UIFont.boldSystemFont(ofSize: 17),
                                          showCancelButton: true)
        datePicker.show("SelectDate",
                        doneButtonTitle: "Done",
                        cancelButtonTitle: "Cancel",
                        minimumDate: sixMonthAgo,
                        maximumDate: twelveMonth,
                        datePickerMode: .date) { (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.locale = Locale.preferredLocale()
                formatter.dateFormat = "MM/dd/yyyy"
                
                self.activeTextField?.text = formatter.string(from: dt)
                
            }
        }
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
        print(response)
        ANLoader.hide()
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
        errorLabel.text = ""
        checkBoxButton.setImage(UIImage(named: "unchecked.png"), for:.normal)
        acaRequire = false
        aca1905cRequire = false
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
    
    
    
    
    
    
    @IBAction func submitSignature(_ sender: UIButton) {
        
        
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
            //            else if object["FormName"].stringValue == "TermsAndConditions"
            //            {
            //                if checked
            //                {
            //                    if signatureTextField.text!.count>0
            //                    {
            //                        //ANLoader.showLoading("", disableUI:false)
            //                        ServerService.showActivityIndicatory(uiView:self.view)
            //                        let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextField.text!,"FormName":object["FormName"].stringValue]
            //                        print(params)
            //                        ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
            //                    }
            //                    else
            //                    {
            //                        errorLabel.text = "Signature Should Match to Your FirstName and LastName"
            //                    }
            //                }
            //                else
            //                {
            //                    errorLabel.text = "Please check the checkbox before submitting signature"
            //                }
            //
            //            }
            else if object["FormName"].stringValue == "ACAElectronicDeliveryConsent"
            {
                if checked
                {
                    if signatureTextField.text!.count>0
                    {
                        //ANLoader.showLoading("", disableUI:false)
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
            
            //            else if object["FormName"].stringValue == "ConsumerReports"
            //            {
            //                if checked
            //                {
            //                    if signatureTextField.text!.count>0
            //                    {
            //                        //ANLoader.showLoading("", disableUI:false)
            //                        ServerService.showActivityIndicatory(uiView:self.view)
            //                        let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextField.text!,"FormName":object["FormName"].stringValue]
            //                        print(params)
            //                        ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
            //                    }
            //                    else
            //                    {
            //                        errorLabel.text = "Signature Should Match to Your FirstName and LastName"
            //                    }
            //                }
            //                else
            //                {
            //                    errorLabel.text = "Please check the checkbox before submitting signature"
            //                }
            //
            //            }
            //            else if object["FormName"].stringValue == "DisclosureConsentForm"
            //            {
            //                if checked
            //                {
            //                    if signatureTextField.text!.count>0
            //                    {
            //                        //ANLoader.showLoading("", disableUI:false)
            //                        ServerService.showActivityIndicatory(uiView:self.view)
            //                        let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextField.text!,"FormName":object["FormName"].stringValue]
            //                        print(params)
            //                        ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
            //                    }
            //                    else
            //                    {
            //                        errorLabel.text = "Signature Should Match to Your FirstName and LastName"
            //                    }
            //                }
            //                else
            //                {
            //                    errorLabel.text = "Please check the checkbox before submitting signature"
            //                }
            //
            //            }
            //            else if object["FormName"].stringValue == "PaidSickLeaveFAQ"
            //            {
            //                if checked
            //                {
            //
            //                    if signatureTextField.text!.count>0
            //                    {
            //                       // ANLoader.showLoading("", disableUI:false)
            //                        ServerService.showActivityIndicatory(uiView:self.view)
            //                        let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextField.text!,"FormName":object["FormName"].stringValue]
            //                        print(params)
            //                        ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
            //                    }
            //                    else
            //                    {
            //                        errorLabel.text = "Signature Should Match to Your FirstName and LastName"
            //                    }
            //                }
            //                else
            //                {
            //                    errorLabel.text = "Please check the checkbox before submitting signature"
            //                }
            //
            //            }
            //            else if object["FormName"].stringValue == "CaliforniaEmployeeAgreement"
            //            {
            //                if checked
            //                {
            //                    if signatureTextField.text!.count>0
            //                    {
            //
            //                        //ANLoader.showLoading("", disableUI:false)
            //                        ServerService.showActivityIndicatory(uiView:self.view)
            //                        let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextField.text!,"FormName":object["FormName"].stringValue]
            //                        print(params)
            //                        ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
            //                    }
            //                    else
            //                    {
            //                        errorLabel.text = "Signature Should Match to Your FirstName and LastName"
            //                    }
            //                }
            //                else
            //                {
            //                    errorLabel.text = "Please check the checkbox before submitting signature"
            //                }
            //
            //            }
            else if object["FormName"].stringValue == "ACA1095CConsent"
            {
                if checked
                {
                    if signatureTextField.text!.count>0
                    {
                        //ANLoader.showLoading("", disableUI:false)
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
            //            else if object["FormName"].stringValue == "GenderInEqualityForm"
            //            {
            //                if checked
            //                {
            //                    if signatureTextField.text!.count>0
            //                    {
            //                        //ANLoader.showLoading("", disableUI:false)
            //                        ServerService.showActivityIndicatory(uiView:self.view)
            //                        let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextField.text!,"FormName":object["FormName"].stringValue]
            //                        print(params)
            //                        ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
            //                    }
            //                    else
            //                    {
            //                        errorLabel.text = "Signature Should Match to Your FirstName and LastName"
            //                    }
            //                }
            //                else
            //                {
            //                    errorLabel.text = "Please check the checkbox before submitting signature"
            //                }
            //
            //            }
            //            else if object["FormName"].stringValue == "PayCardChangeAcknowledgementForm"
            //            {
            //                if checked
            //                {
            //
            //                    if signatureTextField.text!.count>0
            //                    {
            //                        //ANLoader.showLoading("", disableUI:false)
            //                        ServerService.showActivityIndicatory(uiView:self.view)
            //                        let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextField.text!,"FormName":object["FormName"].stringValue]
            //                        print(params)
            //                        ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
            //                    }
            //                    else
            //                    {
            //                        errorLabel.text = "Signature Should Match to Your FirstName and LastName"
            //                    }
            //                }
            //                else
            //                {
            //                    errorLabel.text = "Please check the checkbox before submitting signature"
            //                }
            //
            //            }
            //            else if object["FormName"].stringValue == "HealthCareCodeOfConduct"
            //            {
            //                if checked
            //                {
            //                    if signatureTextField.text!.count>0
            //                    {
            //                        //ANLoader.showLoading("", disableUI:false)
            //                        ServerService.showActivityIndicatory(uiView:self.view)
            //                        let params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextField.text!,"FormName":object["FormName"].stringValue]
            //                        print(params)
            //                        ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
            //                    }
            //                    else{
            //                        errorLabel.text = "Signature Should Match to Your FirstName and LastName"
            //                    }
            //                }
            //                else
            //                {
            //                    errorLabel.text = "Please check the checkbox before submitting signature"
            //                }
            //
            //            }
            //            else if object["FormName"].stringValue == "EmployeeProtectionAct"
            //            {
            //                if checked
            //                {
            //                    if signatureTextField.text!.count>0
            //                    {
            //                        //ANLoader.showLoading("", disableUI:false)
            //                        ServerService.showActivityIndicatory(uiView:self.view)
            //                        let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextField.text!,"FormName":object["FormName"].stringValue]
            //                        print(params)
            //                        ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
            //                    }
            //                    else
            //                    {
            //                        errorLabel.text = "Signature Should Match to Your FirstName and LastName"
            //                    }
            //                }
            //                else
            //                {
            //                    errorLabel.text = "Please check the checkbox before submitting signature"
            //                }
            //
            //            }
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
                if checked
                {
                    if signatureTextField.text!.count>0
                    {
                        //ANLoader.showLoading("", disableUI:false)
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
        signedObjectResponse = response as! JSON
        print(signedObjectResponse)
        if signedObjectResponse.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if signedObjectResponse["Status"].stringValue == "Success"
        {
            if ConnectionCheck.isConnectedToNetwork()
            {
                blurEffectView.removeFromSuperview()
                //ANLoader.showLoading("", disableUI:false)
                ServerService.showActivityIndicatory(uiView:self.view)
                let params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"weekend":(self.selectWeek.titleLabel?.text)!,"orderId":self.orderId]
                ServerService.getOncallcounselWeekEndTimeEntry(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: self.getresponseForEntry(response:))            }
            else
            {
                ANLoader.hide()
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            }
        }
        else
        {
            errorLabel.text = signedObjectResponse["Message"].stringValue
            //ServerService.ShowAlertMessage(ErrorMessage:signedObjectResponse["Message"].stringValue, title: "", view:self)
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
        
        employeeHandBookView.removeFromSuperview()
        termsAndConditionsView.removeFromSuperview()
        consumerView.removeFromSuperview()
        acaConsentView.removeFromSuperview()
        acaConsentForm1095CView.removeFromSuperview()
        disclosureConsentview.removeFromSuperview()
        conscientiousEmployeeProtectionAct.removeFromSuperview()
        genderEqualityView.removeFromSuperview()
        caWageRate.removeFromSuperview()
        wageRateForm.removeFromSuperview()
        payGuardView.removeFromSuperview()
        codeOfConductView.removeFromSuperview()
        paidSickLeaveFAQView.removeFromSuperview()
        caEmpAgreement.removeFromSuperview()
        formView.removeFromSuperview()
        
        
    }
    @IBAction func formSignAction(_ sender: UIButton) {
        showPopUp()
    }
    
    //catching the device orentation
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            formViewFrames()
        case .landscapeLeft:
            text="LandscapeLeft"
            formViewFrames()
        case .landscapeRight:
            text="LandscapeRight"
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
    
    
}







//extensions
extension OnCallViewController:UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView==weeklyTableView
        {
            return 7
        }
        else
        {
            return entryData["OCCAuthorizedHours"].arrayValue.count
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView==weeklyTableView
        {
            if section == 0
            {
                return mondays.count
            }
            else if section == 1
            {
                return tuesdays.count
            }
            else if section == 2
            {
                return wednesdays.count
            }
            else if section == 3
            {
                return thursdays.count
            }
            else if section == 4
            {
                return fridays.count
            }
            else if section == 5
            {
                return sarturdays.count
            }
            else
            {
                return sundays.count
            }
        }
        else
        {
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == weeklyTableView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "occCell") as! OCCTableViewCell
            cell.selectionStyle = .none
            
            if indexPath.section == 0
            {
                cell.dateLabel.text = Constants.getFormattedDate(string:mondays[indexPath.row]["Date"].stringValue)
                cell.startTimeLabel.text = mondays[indexPath.row]["StartTime"].stringValue
                cell.endTimeLabel.text = mondays[indexPath.row]["EndTime"].stringValue
                cell.totalTime.text = mondays[indexPath.row]["TotalTime"].stringValue
                cell.matterlabel.text = mondays[indexPath.row]["Matter"].stringValue
                cell.workPerformed.text = mondays[indexPath.row]["WorkPerformed"].stringValue
                cell.cView.backgroundColor = UIColor(hexString: mondays[indexPath.row]["ColorCode"].stringValue)
                if mondays[indexPath.row]["IsApproved"].intValue == 0
                {
                    cell.editButton.isHidden = false
                    cell.deleteButton.isHidden = false
                }
                else
                {
                    cell.editButton.isHidden = true
                    cell.deleteButton.isHidden = true
                }
                return cell
            }
            else if indexPath.section  == 1
            {
                cell.dateLabel.text = Constants.getFormattedDate(string:tuesdays[indexPath.row]["Date"].stringValue)
                cell.startTimeLabel.text = tuesdays[indexPath.row]["StartTime"].stringValue
                cell.endTimeLabel.text = tuesdays[indexPath.row]["EndTime"].stringValue
                cell.totalTime.text = tuesdays[indexPath.row]["TotalTime"].stringValue
                cell.matterlabel.text = tuesdays[indexPath.row]["Matter"].stringValue
                cell.workPerformed.text = tuesdays[indexPath.row]["WorkPerformed"].stringValue
                cell.cView.backgroundColor = UIColor(hexString:tuesdays[indexPath.row]["ColorCode"].stringValue)
                if tuesdays[indexPath.row]["IsApproved"].intValue == 0
                {
                    cell.editButton.isHidden = false
                    cell.deleteButton.isHidden = false
                }
                else
                {
                    cell.editButton.isHidden = true
                    cell.deleteButton.isHidden = true
                }
                return cell
            }
            else if indexPath.section  == 2
            {
                cell.dateLabel.text = Constants.getFormattedDate(string:wednesdays[indexPath.row]["Date"].stringValue)
                cell.startTimeLabel.text = wednesdays[indexPath.row]["StartTime"].stringValue
                cell.endTimeLabel.text = wednesdays[indexPath.row]["EndTime"].stringValue
                cell.totalTime.text = wednesdays[indexPath.row]["TotalTime"].stringValue
                cell.matterlabel.text = wednesdays[indexPath.row]["Matter"].stringValue
                cell.workPerformed.text = wednesdays[indexPath.row]["WorkPerformed"].stringValue
                cell.cView.backgroundColor = UIColor(hexString: wednesdays[indexPath.row]["ColorCode"].stringValue)
                if wednesdays[indexPath.row]["IsApproved"].intValue == 0
                {
                    cell.editButton.isHidden = false
                    cell.deleteButton.isHidden = false
                }
                else
                {
                    cell.editButton.isHidden = true
                    cell.deleteButton.isHidden = true
                }
                return cell
            }
            else if indexPath.section  == 3
            {
                cell.dateLabel.text = Constants.getFormattedDate(string:thursdays[indexPath.row]["Date"].stringValue)
                cell.startTimeLabel.text = thursdays[indexPath.row]["StartTime"].stringValue
                cell.endTimeLabel.text = thursdays[indexPath.row]["EndTime"].stringValue
                cell.totalTime.text = thursdays[indexPath.row]["TotalTime"].stringValue
                cell.matterlabel.text = thursdays[indexPath.row]["Matter"].stringValue
                cell.workPerformed.text = thursdays[indexPath.row]["WorkPerformed"].stringValue
                cell.cView.backgroundColor = UIColor(hexString:thursdays[indexPath.row]["ColorCode"].stringValue)
                if thursdays[indexPath.row]["IsApproved"].intValue == 0
                {
                    cell.editButton.isHidden = false
                    cell.deleteButton.isHidden = false
                }
                else
                {
                    cell.editButton.isHidden = true
                    cell.deleteButton.isHidden = true
                }
                return cell
            }
            else if indexPath.section  == 4
            {
                cell.dateLabel.text = Constants.getFormattedDate(string:fridays[indexPath.row]["Date"].stringValue)
                cell.startTimeLabel.text = fridays[indexPath.row]["StartTime"].stringValue
                cell.endTimeLabel.text = fridays[indexPath.row]["EndTime"].stringValue
                cell.totalTime.text = fridays[indexPath.row]["TotalTime"].stringValue
                cell.matterlabel.text = fridays[indexPath.row]["Matter"].stringValue
                cell.workPerformed.text = fridays[indexPath.row]["WorkPerformed"].stringValue
                cell.cView.backgroundColor = UIColor(hexString:fridays[indexPath.row]["ColorCode"].stringValue)
                if fridays[indexPath.row]["IsApproved"].intValue == 0
                {
                    cell.editButton.isHidden = false
                    cell.deleteButton.isHidden = false
                }
                else
                {
                    cell.editButton.isHidden = true
                    cell.deleteButton.isHidden = true
                }
                return cell
            }
            else if indexPath.section  == 5
            {
                cell.dateLabel.text = Constants.getFormattedDate(string:sarturdays[indexPath.row]["Date"].stringValue)
                cell.startTimeLabel.text = sarturdays[indexPath.row]["StartTime"].stringValue
                cell.endTimeLabel.text = sarturdays[indexPath.row]["EndTime"].stringValue
                cell.totalTime.text = sarturdays[indexPath.row]["TotalTime"].stringValue
                cell.matterlabel.text = sarturdays[indexPath.row]["Matter"].stringValue
                cell.workPerformed.text = sarturdays[indexPath.row]["WorkPerformed"].stringValue
                cell.cView.backgroundColor = UIColor(hexString:sarturdays[indexPath.row]["ColorCode"].stringValue)
                if sarturdays[indexPath.row]["IsApproved"].intValue == 0
                {
                    cell.editButton.isHidden = false
                    cell.deleteButton.isHidden = false
                }
                else
                {
                    cell.editButton.isHidden = true
                    cell.deleteButton.isHidden = true
                }
                return cell
            }
            else
            {
                cell.dateLabel.text = Constants.getFormattedDate(string:sundays[indexPath.row]["Date"].stringValue)
                cell.startTimeLabel.text = sundays[indexPath.row]["StartTime"].stringValue
                cell.endTimeLabel.text = sundays[indexPath.row]["EndTime"].stringValue
                cell.totalTime.text = sundays[indexPath.row]["TotalTime"].stringValue
                cell.matterlabel.text = sundays[indexPath.row]["Matter"].stringValue
                cell.workPerformed.text = sundays[indexPath.row]["WorkPerformed"].stringValue
                cell.cView.backgroundColor = UIColor(hexString:sundays[indexPath.row]["ColorCode"].stringValue)
                if sundays[indexPath.row]["IsApproved"].intValue == 0
                {
                    cell.editButton.isHidden = false
                    cell.deleteButton.isHidden = false
                }
                else
                {
                    cell.editButton.isHidden = true
                    cell.deleteButton.isHidden = true
                }
                return cell
            }
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "otCell") as! OverTimeTableViewCell
            cell.selectionStyle = .none
            cell.payRollPeriod.text = entryData["OCCAuthorizedHours"][indexPath.section]["PayrollPeriod"].stringValue
            cell.payRollPeriodHours.text = entryData["OCCAuthorizedHours"][indexPath.section]["PayrollPeriodHrs"].stringValue
            cell.otHoursUse.text = entryData["OCCAuthorizedHours"][indexPath.section]["OtHoursUsed"].stringValue
            cell.otHoursAprroved.text = entryData["OCCAuthorizedHours"][indexPath.section]["OtHoursApproved"].stringValue
            cell.otHoursAvailable.text = entryData["OCCAuthorizedHours"][indexPath.section]["OtHoursAvailable"].stringValue
            return cell
        }
    }
    
}
extension OnCallViewController:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == weeklyTableView
        {
            return 200
        }
        else
        {
            return 200
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == otTableView
        {
            return 5
        }
        else
        {
            if section == 0
            {
                if mondays.count>0
                {
                    return  30
                }
                else
                {
                    return 0.01
                }
            }
            else if section == 1
            {
                if tuesdays.count>0
                {
                    return  30
                }
                else
                {
                    return 0.01
                }
            }
            else if section == 2
            {
                if wednesdays.count>0
                {
                    return  30
                }
                else
                {
                    return 0.01
                }
            }
            else if section == 3
            {
                if thursdays.count>0
                {
                    return  30
                }
                else
                {
                    return 0.01
                }
            }
            else if section == 4
            {
                if fridays.count>0
                {
                    return  30
                }
                else
                {
                    return 0.01
                }
            }
            else if section == 5
            {
                if sarturdays.count>0
                {
                    return  30
                }
                else
                {
                    return 0.01
                }
            }
            else
            {
                if sundays.count>0
                {
                    return  30
                }
                else
                {
                    return 0.01
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if tableView == otTableView
        {
            return 5
        }
        else
        {
            if section == 0
            {
                if mondays.count>0
                {
                    return  30
                }
                else
                {
                    return 0.01
                }
            }
            else if section == 1
            {
                if tuesdays.count>0
                {
                    return  30
                }
                else
                {
                    return 0.01
                }
            }
            else if section == 2
            {
                if wednesdays.count>0
                {
                    return  30
                }
                else
                {
                    return 0.01
                }
            }
            else if section == 3
            {
                if thursdays.count>0
                {
                    return  30
                }
                else
                {
                    return 0.01
                }
            }
            else if section == 4
            {
                if fridays.count>0
                {
                    return  30
                }
                else
                {
                    return 0.01
                }
            }
            else if section == 5
            {
                if sarturdays.count>0
                {
                    return  30
                }
                else
                {
                    return 0.01
                }
            }
            else
            {
                if sundays.count>0
                {
                    return  30
                }
                else
                {
                    return 0.01
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if tableView == weeklyTableView
        {
            let headerView = UIView()
            headerView.frame = CGRect(x:0, y: 0, width: self.view.bounds.size.width, height:30)
            let dayLabel = UILabel()
            dayLabel.frame = CGRect(x:10, y: 0, width: self.view.bounds.size.width, height:30)
            if section == 0
            {
                if mondays.count>0
                {
                    dayLabel.text = "Monday"
                }
                else
                {
                    dayLabel.text = ""
                }
            }
            else if section == 1
            {
                if tuesdays.count>0
                {
                    dayLabel.text = "Tuesday"
                }
                else
                {
                    dayLabel.text = ""
                }
            }
            else if section == 2
            {
                if wednesdays.count>0
                {
                    dayLabel.text = "Wednesday"
                }
                else
                {
                    dayLabel.text = ""
                }
            }else if section == 3
            {
                if thursdays.count>0
                {
                    dayLabel.text = "Thursday"
                }
                else
                {
                    dayLabel.text = ""
                }
            }else if section == 4
            {
                if fridays.count>0
                {
                    dayLabel.text = "Friday"
                }
                else
                {
                    dayLabel.text = ""
                }
            }else if section == 5
            {
                if sarturdays.count>0
                {
                    dayLabel.text = "Sarturday"
                }
                else
                {
                    dayLabel.text = ""
                }
            }else if section == 6
            {
                if sundays.count>0
                {
                    dayLabel.text = "Sunday"
                }
                else
                {
                    dayLabel.text = ""
                }
            }
            headerView.addSubview(dayLabel)
            return headerView
        }
        else
        {
            return nil
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == weeklyTableView
        {
            let footerView = UIView()
            footerView.frame = CGRect(x:0, y: 0, width: self.view.bounds.size.width, height:30)
            let totalLabel = UILabel()
            totalLabel.frame = CGRect(x:10, y: 0, width: self.view.bounds.size.width-20, height:30)
            totalLabel.textAlignment = .right
            if section == 0
            {
                if mondays.count>0
                {
                    totalLabel.text = "Monday Total Work Hours:"+entryData["TotalWorkHoursMonday"].stringValue+"Hours"
                }
                else
                {
                    totalLabel.text = ""
                }
            }
            else if section == 1
            {
                if tuesdays.count>0
                {
                    totalLabel.text = "Tuesday Total Work Hours:"+entryData["TotalWorkHoursTuesday"].stringValue+"Hours"
                }
                else
                {
                    totalLabel.text = ""
                }
            }
            else if section == 2
            {
                if wednesdays.count>0
                {
                    totalLabel.text = "Wednesday Total Work Hours:"+entryData["TotalWorkHoursWednesday"].stringValue+"Hours"
                }
                else
                {
                    totalLabel.text = ""
                }
            }else if section == 3
            {
                if thursdays.count>0
                {
                    totalLabel.text = "Thursday Total Work Hours:"+entryData["TotalWorkHoursThursday"].stringValue+"Hours"
                }
                else
                {
                    totalLabel.text = ""
                }
            }else if section == 4
            {
                if fridays.count>0
                {
                    totalLabel.text = "Friday Total Work Hours:"+entryData["TotalWorkHoursFriday"].stringValue+"Hours"
                }
                else
                {
                    totalLabel.text = ""
                }
            }else if section == 5
            {
                if sarturdays.count>0
                {
                    totalLabel.text = "Saturday Total Work Hours:"+entryData["TotalWorkHoursSaturday"].stringValue+"Hours"
                }
                else
                {
                    totalLabel.text = ""
                }
            }else if section == 6
            {
                if sundays.count>0
                {
                    totalLabel.text = "Sunday Total Work Hours:"+entryData["TotalWorkHoursSunday"].stringValue+"Hours"
                }
                else
                {
                    totalLabel.text = ""
                }
                let totalWeeekLabel = UILabel()
                totalWeeekLabel.frame = CGRect(x:10, y: 0, width: self.view.bounds.size.width-20, height:30)
                totalWeeekLabel.textAlignment = .right
                totalWeeekLabel.text = "Total Weekly Time :"+entryData["TotalWeekTimeSlipTotal"].stringValue+"Hours"
                if entryData["TotalWeekTimeSlipTotal"].stringValue.count>0
                {
                    footerView.addSubview(totalWeeekLabel)
                }
            }
            footerView.addSubview(totalLabel)
            return footerView
        }
        else
        {
            return nil
        }
    }
    
    //Time Label
    func convertDate(date:String) -> String
    {
        let tt = date
        let dateFormatterf = DateFormatter()
        dateFormatterf.locale = Locale.preferredLocale()
        dateFormatterf.dateFormat = "h:mm aa"
        
        let dateee = dateFormatterf.date(from: tt)
        dateFormatterf.dateFormat = "HH:mm"
        if (dateee != nil)
        {
            let Date24 = dateFormatterf.string(from: dateee!)
            print("24 hour formatted Date:",Date24)
            return Date24
        }
        else
        {
            return ""
        }
    }
    func addTimes(start:String,end:String) -> Int
    {
        let startDate = start
        let endDate = end
        
        let startArray = startDate.components(separatedBy: (":"))
        let endArray = endDate.components(separatedBy: (":"))
        
        let startHours = startArray[0].integerValue * 60
        let startMinutes = startArray[1].integerValue + startHours
        
        let endHours = endArray[0].integerValue * 60
        let endMinutes = endArray[1].integerValue + endHours
        
        var timeDifference = endMinutes - startMinutes
        
        let day = 24 * 60
        
        if timeDifference < 0 {
            timeDifference += day
        }
        print(timeDifference)
        return timeDifference
    }
    func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    func getHours(start:String,end:String)
    {
        let tuple = minutesToHoursMinutes(minutes: self.addTimes(start:self.convertDate(date:start), end: self.convertDate(date:end)))
        //        if tuple.hours<10
        //        {
        //            if tuple.leftMinutes<10
        //            {
        //                totalTimeLabel.text = String(format:"0%d",tuple.hours)+":"+String(format:"0%d",tuple.leftMinutes)
        //            }
        //            else
        //            {
        //                totalTimeLabel.text = String(format:"0%d",tuple.hours)+":"+String(format:"%d",tuple.leftMinutes)
        //            }
        //        }
        //        else
        //        {
        //            if tuple.leftMinutes<10
        //            {
        //                totalTimeLabel.text = String(format:"%d",tuple.hours)+":"+String(format:"0%d",tuple.leftMinutes)
        //            }
        //            else
        //            {
        //                totalTimeLabel.text = String(format:"%d",tuple.hours)+":"+String(format:"%d",tuple.leftMinutes)
        //            }
        //        }
        var totalTimeConversionArray = Double()
        let hours = String(format:"%d:%d",tuple.hours,tuple.leftMinutes)
        let fileArray = hours.components(separatedBy:":")
        var hoursToMin:Double = Double()
        if fileArray.count>0
        {
            hoursToMin = Double(fileArray[0])!
        }
        var mins:Double = Double()
        if fileArray.count == 2
        {
            mins = Double(fileArray[1])!
        }
        totalTimeConversionArray = hoursToMin+mins/60
        if hours.hasPrefix("-")
        {
            totalTimeLabel.text = String(format:"-%.2f",totalTimeConversionArray)
        }
        else{
            totalTimeLabel.text = String(format:"%.2f",totalTimeConversionArray)
        }
    }
    
    
}
extension OnCallViewController: SambagTimePickerViewControllerDelegate
{
    func sambagTimePickerDidCancel(_ viewController: SambagTimePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    func sambagTimePickerDidSet(_ viewController: SambagTimePickerViewController, result: SambagTimePickerResult)
    {
        
        if activeTextField?.tag == 1
        {
            startTimeField.text = String(describing: result)
        }
        else
        {
            endTimeField.text = String(describing: result)
        }
        if (startTimeField.text!.count>0)&&(endTimeField.text?.count)!>0
        {
            self.getHours(start: startTimeField.text!, end:endTimeField.text!)
            
        }
        
        viewController.dismiss(animated: true, completion: nil)
    }
}
extension OnCallViewController: SambagDatePickerViewControllerDelegate {
    
    func sambagDatePickerDidSet(_ viewController: SambagDatePickerViewController, result: SambagDatePickerResult)
    {   print(result)
        activeTextField?.text = Constants.getFormattedDateForPicker(string:String(describing: result))
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func sambagDatePickerDidCancel(_ viewController: SambagDatePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
extension OnCallViewController:DateTimePickerDelegate
{
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        print(picker.selectedDateString)
    }
}

extension OnCallViewController:wageRateDelegate
{
    func wageRateStatus(success: Bool) {
        print("success")
        ASHTSkipStatus = 0
        self.getOnCallWeekends()
    }
    
    
}
extension OnCallViewController:formDelegate
{
    func formStatus(success: Bool, skipStatus: Int) {
        print("success")
        ASHTSkipStatus = skipStatus
        self.getOnCallWeekends()
    }
    
    
}
