//
//  DOEViewController.swift
//  EWA
//
//  Created by NFC Solutions on 20/11/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import DropDown
import ANLoader
import WebKit
import ActiveLabel
import CropViewController



class DOEViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CropViewControllerDelegate {
    
    @IBOutlet var selectWeekButton: UIButton!
    
    @IBOutlet var clientNameLabel: UILabel!
    @IBOutlet var errorLabel: UILabel!
    var object: JSON = JSON.null
    var picUploadData:JSON = JSON.null
    var signedObjectResponse:JSON = JSON.null
    
    var indexNumber = Int()
    var clientName = String()
    let chooseArticleDropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.chooseArticleDropDown
        ]
    }()
    @IBOutlet var enterTimeSlipTableView: UITableView!
    var weekends = [String]()
    var childList = [DOEUsersList]()
    var ASHTSkipStatus = Int()
    
    var blurEffect = UIBlurEffect()
    var blurEffectView = UIVisualEffectView()
    
    var checked = Bool()
    var acaRequire = Bool()
    var aca1905cRequire = Bool()
    var wageRateOne = Bool()
    var wageRateTwo = Bool()
    var language = String()
    
    
    //ACAConsentForm
    @IBOutlet var acaConsentView: UIView!
    @IBOutlet weak var acaWebView: WKWebView!
    
    //ACA Consent Form 1095-C
    @IBOutlet var acaConsentForm1095CView: UIView!
    @IBOutlet weak var aca1905Label: UILabel!
    @IBOutlet weak var aca1095WebView: WKWebView!
    
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
    @IBOutlet weak var serrorLabel: UILabel!
    @IBOutlet weak var signatureHeaderView: UIView!
    
    
    var clickedRow = Bool()
    
    //formView
    @IBOutlet var formView: UIView!
    @IBOutlet weak var formWebView: WKWebView!
    
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        self.updateNavigationBarColor()
        
        //calling the api
        DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
            ANLoader.hide()
        })
        self.getEnterTimeSlipForDOE()
        
        
        selectWeekButton.titleLabel?.textAlignment = .left
        
        
        
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
        
        let formattedStrings = NSMutableAttributedString()
        formattedStrings
            .normal("To indicate you would prefer")
            .bold("NOT")
            .normal("to receive the ACA form electronically, We will ask you to sign this form electronically by clicking the “Press to Sign” box to the right.")
        formattedStrings.addAttribute(NSAttributedStringKey.foregroundColor, value:UIColor.black, range: NSRange(location:0,length:formattedStrings.length))
        aca1905Label.attributedText = formattedStrings
        aca1905Label.font = UIFont.systemFont(ofSize:15)
        
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
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        ANLoader.hide()
    }
    
    func getEnterTimeSlipForDOE(){
        if ConnectionCheck.isConnectedToNetwork()
        {
            // ANLoader.showLoading("", disableUI:false)
            ServerService.showActivityIndicatory(uiView:self.view)
            let params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"ASHTSkipStatus":"\(ASHTSkipStatus)"]
            ServerService.getEnterTimeSlipDOEEnterTimeSlip(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponse(response:))
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
        //weekends.removeAll()
        childList.removeAll()
        clientNameLabel.text = UserDefaults.standard.object(forKey: "CandName") as? String
        if object.isEmpty
        {
            removeAll()
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if object["Status"].stringValue == "Fail"
        {
            
            errorLabel.text = object["Message"].stringValue
            errorLabel.backgroundColor = UIColor(hexString:"#f2dede")
            enterTimeSlipTableView.isScrollEnabled = false
            
            
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
                
                
                
                //            if object["FormName"].stringValue == "HandBook"
                //            {
                //
                //                formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                //
                //                self.view.addSubview(formView)
                //                self.view.bringSubview(toFront:formView)
                //                let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:""))
                //                let request = URLRequest(url:url!)
                //                formWebView.load(request)
                //            }
                //            else if object["FormName"].stringValue == "TermsAndConditions"
                //            {
                //
                //                formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                //
                //                self.view.addSubview(formView)
                //                self.view.bringSubview(toFront:formView)
                //                let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
                //                let request = URLRequest(url: url!)
                //                formWebView.load(request)
                //            }
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
                //            else if object["FormName"].stringValue == "ConsumerReports"
                //            {
                //
                //                 formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                //                self.view.addSubview(formView)
                //                self.view.bringSubview(toFront:formView)
                //                let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
                //                let request = URLRequest(url: url!)
                //                formWebView.load(request)
                //            }
                //            else if object["FormName"].stringValue == "DisclosureConsentForm"
                //            {
                //
                //                 formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                //                self.view.addSubview(formView)
                //                self.view.bringSubview(toFront:formView)
                //               let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
                //                let request = URLRequest(url: url!)
                //                formWebView.load(request)
                //
                //
                //            }
                //            else if object["FormName"].stringValue == "PaidSickLeaveFAQ"
                //            {
                //
                //                formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                //                self.view.addSubview(formView)
                //                self.view.bringSubview(toFront:formView)
                //                let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
                //                let request = URLRequest(url: url!)
                //                formWebView.load(request)
                //
                //            }
                //            else if object["FormName"].stringValue == "CaliforniaEmployeeAgreement"
                //            {
                //
                //                formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                //                self.view.addSubview(formView)
                //                self.view.bringSubview(toFront:formView)
                //                let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
                //                let request = URLRequest(url: url!)
                //                formWebView.load(request)
                //
                //            }
                else if object["FormName"].stringValue == "ACA1095CConsent"
                {
                    
                    acaConsentForm1095CView.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                    self.view.addSubview(acaConsentForm1095CView)
                    self.view.bringSubview(toFront:acaConsentForm1095CView)
                    let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
                    let request = URLRequest(url: url!)
                    aca1095WebView.load(request)
                    
                }
                //            else if object["FormName"].stringValue == "EmployeeProtectionAct"
                //            {
                //
                //     formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                //                self.view.addSubview(formView)
                //                self.view.bringSubview(toFront:formView)
                //                let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
                //                let request = URLRequest(url: url!)
                //                formWebView.load(request)
                //
                //            }
                //            else if object["FormName"].stringValue == "GenderInEqualityForm"
                //            {
                //
                //                 formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                //                self.view.addSubview(formView)
                //                self.view.bringSubview(toFront:formView)
                //                let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
                //                let request = URLRequest(url: url!)
                //                formWebView.load(request)
                //
                //            }
                else if object["FormName"].stringValue == "PayCardChangeAcknowledgementForm"
                {
                    
                    payGuardView.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.bounds.size.height)!+20, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                    self.view.addSubview(payGuardView)
                    self.view.bringSubview(toFront:payGuardView)
                    
                }
                
                //            else if object["FormName"].stringValue == "HealthCareCodeOfConduct"
                //            {
                //                 formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                //                self.view.addSubview(formView)
                //                self.view.bringSubview(toFront:formView)
                //                let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
                //                let request = URLRequest(url: url!)
                //                formWebView.load(request)
                //
                //            }
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
                    /*
                     formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height-(self.navigationController?.navigationBar.bounds.size.height)!-20)
                     
                     self.view.addSubview(formView)
                     self.view.bringSubview(toFront:formView)
                     let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:""))
                     let request = URLRequest(url:url!)
                     formWebView.load(request)
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
        
        
        else if object["ErrorMessage"].stringValue.count>0
        {
            removeAll()
            errorLabel.text = object["ErrorMessage"].stringValue
            errorLabel.backgroundColor = UIColor(hexString:"#f2dede")
            enterTimeSlipTableView.isScrollEnabled = false
            let tlabel = UILabel()
            tlabel.text = "Enter Timeslip"
            tlabel.textColor = UIColor.white
            tlabel.font = UIFont.systemFont(ofSize:17)
            tlabel.backgroundColor = UIColor.clear
            tlabel.adjustsFontSizeToFitWidth = true
            tlabel.textAlignment = .left
            tlabel.numberOfLines = 0
            tlabel.minimumScaleFactor = 0.5
            self.navigationItem.titleView = tlabel
        }
        
        else
        {
            removeAll()
            let tlabel = UILabel()
            tlabel.text = "Enter Timeslip"
            tlabel.textColor = UIColor.white
            tlabel.font = UIFont.systemFont(ofSize:17)
            tlabel.backgroundColor = UIColor.clear
            tlabel.adjustsFontSizeToFitWidth = true
            tlabel.textAlignment = .left
            tlabel.numberOfLines = 0
            tlabel.minimumScaleFactor = 0.5
            self.navigationItem.titleView = tlabel
            
            clientName = object["ClientName"].stringValue
            for week in 0..<object["WeekEndDropDown"].arrayValue.count {
                weekends.append(object["WeekEndDropDown"][week].stringValue)
            }
            
            errorLabel.text = ""
            errorLabel.backgroundColor = .clear
            enterTimeSlipTableView.isScrollEnabled = true
            
            for u in 0..<object["ChildList"].arrayValue.count
            {
                let user = DOEUsersList.init(childName: object["ChildList"][u]["FirstName"].stringValue+" "+object["ChildList"][u]["LastName"].stringValue+" "+"(\(object["ChildList"][u]["DoeChildId"].stringValue))")
                childList.append(user)
                
            }
            
        }
        enterTimeSlipTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "message"
        {
            
        }
        else
        {
            let dvc = segue.destination as! DOEEnterViewController
            dvc.weekEnds = object["WeekDays"]
            dvc.clientName = clientName
            dvc.object = object
            dvc.weekEnd = (selectWeekButton.titleLabel?.text)!
            dvc.indexNumber = indexNumber
        }
    }
    
    @IBAction func handleNavgationBarButtonTap(_ sender: UIBarButtonItem, event: UIEvent)
    
    {
        Constants.showUp(event:event,viewController:self)
        
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
                ANLoader.hide()
            })
            if ConnectionCheck.isConnectedToNetwork()
            {
                //ANLoader.showLoading("", disableUI:true)
                ServerService.showActivityIndicatory(uiView:self.view)
                let params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"SelectedWeekEnd":item,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"ASHTSkipStatus":"0"]
                ServerService.getEnterTimeSlipDOEEnterTimeSlip(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: self.getresponse(response:))
            }
            else
            {
                ANLoader.hide()
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            }
            
            
        }
    }
    @IBAction func selectWeekButton(_ sender: UIButton) {
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        setupChooseArticleDropDown(anchorView:sender,items:weekends)
        chooseArticleDropDown.show()
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
    
    
    
    //Form checks
    func removeAll()  {
        acaConsentView.removeFromSuperview()
        acaConsentForm1095CView.removeFromSuperview()
        caWageRate.removeFromSuperview()
        wageRateForm.removeFromSuperview()
        payGuardView.removeFromSuperview()
        formView.removeFromSuperview()
        
    }
    func showPopUp() {
        checked = false
        signatureTextField.text = ""
        acaRequire = false
        aca1905cRequire = false
        errorLabel.text = ""
        checkBoxButton.setImage(UIImage(named:"unchecked.png"), for:.normal)
        blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        signatureView.frame = CGRect(x:10, y:100, width:self.view.bounds.width-20, height:280)
        blurEffectView.contentView.addSubview(signatureView)
        view.addSubview(blurEffectView)
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
                let params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"ASHTSkipStatus":"0"]
                ServerService.getEnterTimeSlipDOEEnterTimeSlip(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponse(response:))
            }
            else
            {
                ANLoader.hide()
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            }
        }
        else
        {
            serrorLabel.text = signedObjectResponse["Message"].stringValue
            //ServerService.ShowAlertMessage(ErrorMessage:signedObjectResponse["Message"].stringValue, title: "", view:self)
        }
        
    }
    @IBAction func formSignAction(_ sender: UIButton) {
        showPopUp()
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
                        serrorLabel.text = "Signature Should Match to Your FirstName and LastName"
                    }
                    
                }
                else
                {
                    serrorLabel.text = "Please check the checkbox before submitting signature"
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
            //                        serrorLabel.text = "Signature Should Match to Your FirstName and LastName"
            //                    }
            //                }
            //                else
            //                {
            //                    serrorLabel.text = "Please check the checkbox before submitting signature"
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
                        serrorLabel.text = "Signature Should Match to Your FirstName and LastName"
                    }
                    
                }
                else
                {
                    serrorLabel.text = "Please check the checkbox before submitting signature"
                }
                
            }
            //
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
            //                        serrorLabel.text = "Signature Should Match to Your FirstName and LastName"
            //                    }
            //                }
            //                else
            //                {
            //                    serrorLabel.text = "Please check the checkbox before submitting signature"
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
            //                        serrorLabel.text = "Signature Should Match to Your FirstName and LastName"
            //                    }
            //                }
            //                else
            //                {
            //                    serrorLabel.text = "Please check the checkbox before submitting signature"
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
            //                        //ANLoader.showLoading("", disableUI:false)
            //                        ServerService.showActivityIndicatory(uiView:self.view)
            //                        let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextField.text!,"FormName":object["FormName"].stringValue]
            //                        print(params)
            //                        ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
            //                    }
            //                    else
            //                    {
            //                        serrorLabel.text = "Signature Should Match to Your FirstName and LastName"
            //                    }
            //                }
            //                else
            //                {
            //                    serrorLabel.text = "Please check the checkbox before submitting signature"
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
            //                        serrorLabel.text = "Signature Should Match to Your FirstName and LastName"
            //                    }
            //                }
            //                else
            //                {
            //                    serrorLabel.text = "Please check the checkbox before submitting signature"
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
                        serrorLabel.text = "Signature Should Match to Your FirstName and LastName"
                    }
                }
                else
                {
                    serrorLabel.text = "Please check the checkbox before submitting signature"
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
            //                        serrorLabel.text = "Signature Should Match to Your FirstName and LastName"
            //                    }
            //                }
            //                else
            //                {
            //                    serrorLabel.text = "Please check the checkbox before submitting signature"
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
            //                        serrorLabel.text = "Signature Should Match to Your FirstName and LastName"
            //                    }
            //                }
            //                else
            //                {
            //                    serrorLabel.text = "Please check the checkbox before submitting signature"
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
            //                        serrorLabel.text = "Signature Should Match to Your FirstName and LastName"
            //                    }
            //                }
            //                else
            //                {
            //                    serrorLabel.text = "Please check the checkbox before submitting signature"
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
            //                        serrorLabel.text = "Signature Should Match to Your FirstName and LastName"
            //                    }
            //                }
            //                else
            //                {
            //                    serrorLabel.text = "Please check the checkbox before submitting signature"
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
                        serrorLabel.text = "Signature Should Match to Your FirstName and LastName"
                    }
                }
                else
                {
                    serrorLabel.text = "Please check the checkbox before submitting signature"
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
                        
                        ServerService.showActivityIndicatory(uiView:self.view)
                        let params:[String:String] = ["CandID":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextField.text!,"FormName":object["FormName"].stringValue,"OrderId":object["OrderId"].stringValue,"CompanyName":object["CompanyName"].stringValue,"PreparerName":object["PreparerName"].stringValue,"CompAddress":object["CompAddress"].stringValue,"CompCity":object["CompCity"].stringValue,"CompState":object["CompState"].stringValue,"CompZip":object["CompZip"].stringValue,"CompPhone":object["CompPhone"].stringValue,"ApplicantSignDateTime":result,"Hiredate":object["Hiredate"].stringValue,"WageRateFullText":object["WageRateFullText"].stringValue,"DesignatedPayDay":object["DesignatedPayDay"].stringValue,"ApplicantSignature":signatureTextField.text!]
                        print(params)
                        ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                    }
                    else
                    {
                        serrorLabel.text = "Signature Should Match to Your FirstName and LastName"
                    }
                }
                else
                {
                    serrorLabel.text = "Please check the checkbox before submitting signature"
                }
            }
            else
            {
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
                        serrorLabel.text = "Signature Should Match to Your FirstName and LastName"
                    }
                }
                else
                {
                    serrorLabel.text = "Please check the checkbox before submitting signature"
                }
            }
            
            
        }
        
        else
        {
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
        
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
    //aca1905c
    @IBAction func aca1095cSignReceive(_ sender: Any) {
        aca1905cRequire = true
        showPopUp()
    }
    
    @IBAction func aca1095cSignDontReceive(_ sender: Any) {
        showPopUp()
    }
    //acaConsentView
    @IBAction func acaReceiveElectronically(_ sender: Any) {
        acaRequire = true
        showPopUp()
    }
    
    @IBAction func acaDontReceive(_ sender: UIButton) {
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



extension DOEViewController:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return object["ChildList"].arrayValue.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dCell") as! DOETableViewCell
        cell.textLabel?.text = childList[indexPath.row].childName!
        cell.selectionStyle = .none
        return cell
    }
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if object["ChildList"].arrayValue.count>0
        {
            return "Users"
        }
        else
        {
            return nil
        }
    }
}
extension DOEViewController:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexNumber = indexPath.row
        self.performSegue(withIdentifier: "detailSegue", sender: nil)
    }
}




extension DOEViewController:wageRateDelegate
{
    func wageRateStatus(success: Bool) {
        print("success")
        ASHTSkipStatus = 0
        self.getEnterTimeSlipForDOE()
    }
}
extension DOEViewController:formDelegate
{
    func formStatus(success: Bool, skipStatus: Int) {
        ASHTSkipStatus = skipStatus
        print("success")
        self.getEnterTimeSlipForDOE()
    }
    
}
