//
//  MessagesViewController.swift
//  EWA
//
//  Created by NFC Solutions on 20/10/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import ANLoader
import ActiveLabel
import WebKit
import CropViewController


class MessagesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CropViewControllerDelegate {
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var noMessageLabel: UILabel!
    var object: JSON = JSON.null
    var signedObjectResponse:JSON = JSON.null
    var message = String()
    var name = String()
    var level = String()
    var messageId = String()
    var email = String()
    var refreshControl: UIRefreshControl!
    var respond = String()
    var picUploadData:JSON = JSON.null
    
    @IBOutlet var messagesTableView: UITableView!
    
    
    var blurEffect = UIBlurEffect()
    var blurEffectView = UIVisualEffectView()
    var ASHTSkipStatus = Int()
    
    var checked = Bool()
    var acaRequire = Bool()
    var aca1905cRequire = Bool()
    var language = String()
    
    
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
        
        // Do any additional setup after loading the view.
        if UserDefaults.standard.object(forKey:"color") != nil
        {
            self.updateNavigationBarColor()
        }
        
        
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        self.automaticallyAdjustsScrollViewInsets = false
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:#selector(MessagesViewController.refresh), for: UIControlEvents.valueChanged)
        messagesTableView.addSubview(refreshControl)
        
        headerView.isHidden = true
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
    
    @objc func refresh()
    {
        //calling the api
        if ConnectionCheck.isConnectedToNetwork()
        {
            //ANLoader.showLoading("", disableUI:false)
            ServerService.showActivityIndicatory(uiView:self.view)
            let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"ASHTSkipStatus": "0"]
            ServerService.getMessages(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponse(response:))
        }
        else
        {
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        //calling the api
        DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
            ANLoader.hide()
        })
        ASHTSkipStatus = 0
        self.getMessages()
        
    }
    
    func getMessages(){
        if ConnectionCheck.isConnectedToNetwork()
        {
            //ANLoader.showLoading("", disableUI:false)
            ServerService.showActivityIndicatory(uiView:self.view)
            let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Language":"","ASHTSkipStatus": "\(ASHTSkipStatus)"]
            print(params)
            ServerService.getMessages(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponse(response:))
        }
        else
        {
            //ANLoader.hide()
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
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
        
        //ANLoader.hide()
        ServerService.hideProgressView()
        object = response as! JSON
        refreshControl.endRefreshing()
        print(object)
        noMessageLabel.text = object["Message"].stringValue
        
        if object.isEmpty
        {
            removeAll()
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if object["Status"].stringValue == "Success"
        {
            ASHTSkipStatus = 0
            removeAll()
            headerView.isHidden = false
            messagesTableView.backgroundColor = .white
            noMessageLabel.backgroundColor = .clear
            //self.navigationController?.navigationBar.topItem?.title = "View Messages"
            let tlabel = UILabel()
            tlabel.text = "View Messages"
            tlabel.textColor = UIColor.white
            tlabel.font = UIFont.systemFont(ofSize:17)
            tlabel.backgroundColor = UIColor.clear
            tlabel.adjustsFontSizeToFitWidth = true
            tlabel.textAlignment = .left
            tlabel.numberOfLines = 0
            tlabel.minimumScaleFactor = 0.5
            self.navigationItem.titleView = tlabel
            
            if object["listMessages"].arrayValue.count == 0
            {
                noMessageLabel.text = object["MessageStaus"].stringValue
                noMessageLabel.backgroundColor = UIColor(hexString:"#f2dede")
                messagesTableView.backgroundColor = .clear
                headerView.isHidden = true
                
            }
        }
        
        else if object["Status"].intValue == 3
        {
            removeAll()
            askLanguage()
        }
        
        else if object["Status"].intValue == 1
        {
            removeAll()
            let tlabel = UILabel()
            tlabel.text = "View Messages"
            tlabel.textColor = UIColor.white
            tlabel.font = UIFont.systemFont(ofSize:17)
            tlabel.backgroundColor = UIColor.clear
            tlabel.adjustsFontSizeToFitWidth = true
            tlabel.textAlignment = .left
            tlabel.numberOfLines = 0
            tlabel.minimumScaleFactor = 0.5
            self.navigationItem.titleView = tlabel
            
            noMessageLabel.text = object["MessageStaus"].stringValue
            noMessageLabel.backgroundColor = UIColor(hexString:"#f2dede")
            messagesTableView.backgroundColor = .clear
            headerView.isHidden = true
        }
        else
        {
            noMessageLabel.text = object["MessageStaus"].stringValue
            noMessageLabel.backgroundColor = UIColor(hexString:"#f2dede")
            messagesTableView.backgroundColor = .clear
            headerView.isHidden = true
            
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
                        aca1905WebView.load(request)
                        
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
                        Constants.Menu = "DashBoard"
                        VC.object = object
                        let navi = BaseNaviViewController(rootViewController:VC)
                        navi.navigationBar.tintColor = .white
                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"A1FormController")
                    }
                    else if object["FormName"].stringValue == Constants.A2Form {
//                        print("*********A2 Form clicked VIVEK*********/n")
                        let VC = A2FormController(nibName: "A2FormController", bundle: nil)
                        Constants.Menu = "DashBoard"
                        VC.object = object
                        let navi = BaseNaviViewController(rootViewController:VC)
                        navi.navigationBar.tintColor = .white
                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"A2FormController")
                    }
                    else if object["FormName"].stringValue == Constants.SCRConsent {
                        let VC = SCRConsent(nibName: "SCRConsent", bundle: nil)
                        Constants.Menu = "DashBoard"
                        VC.object = JSON(["FormName":Constants.SCRName])
                        VC.fromSideMenu = false
                        let navi = BaseNaviViewController(rootViewController:VC)
                        navi.navigationBar.tintColor = .white
                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"SCRConsent")
                        
                    }
                    else if object["FormName"].stringValue == Constants.SCRForm{
                        let VC = SCRConsentInfoController(nibName: "SCRConsentInfoController", bundle: nil)
                        Constants.Menu = "DashBoard"
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
                
            }
            
            
        }
        messagesTableView.reloadData()
    }
    
    //function to get date
    func getFormattedDate(string: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // This formate is input formated .
        let formateDate = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "MM/dd/yyyy" // Output Formated
        return dateFormatter.string(from: formateDate)
    }
    
    @IBAction func handleNavgationBarButtonTap(_ sender: UIBarButtonItem, event: UIEvent)
    
    {
        Constants.showUp(event:event,viewController:self)
        
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
                    cropController.modalPresentationStyle = .fullScreen
                }
                else
                {
                    
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
        else
        {
            if picUploadData["MessageStatus"].intValue == 1
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
    }
    
    
    
    
    
    
    
    //MARK:- TablView Delegate and DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return object["listMessages"].arrayValue.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"mCell") as! MessagesTableViewCell
        cell.nameLabel?.text = object["listMessages"][indexPath.row]["Name"].stringValue
        if object["listMessages"][indexPath.row]["EntryTime"].stringValue.count>=10
        {
            let date = getFormattedDate(string:object["listMessages"][indexPath.row]["EntryTime"].stringValue)
            cell.dateLabel?.text = date
        }
        else
        {
            cell.dateLabel?.text = ""
        }
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 3
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        message = object["listMessages"][indexPath.row]["Message"].stringValue
        level = object["listMessages"][indexPath.row]["Level"].stringValue
        messageId = object["listMessages"][indexPath.row]["MessageId"].stringValue
        name = object["listMessages"][indexPath.row]["Name"].stringValue
        respond = object["listMessages"][indexPath.row]["MessageType"].stringValue
        email = object["listMessages"][indexPath.row]["Email"].stringValue
        self.performSegue(withIdentifier: "mdSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "mdSegue"
        {
            let dvc = segue.destination as! MessageDetailViewController
            dvc.message = message
            dvc.level = level
            dvc.name  = name
            dvc.respond = respond
            dvc.messageId = messageId
            dvc.email = email
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
                        //ANLoader.showLoading("", disableUI:false)
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
                        // ANLoader.showLoading("", disableUI:false)
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
                
                if checked
                {
                    if signatureTextField.text!.count>0
                    {
                        self.view.endEditing(true)
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
        removeAll()
        signedObjectResponse = response as! JSON
        print(signedObjectResponse)
        if signedObjectResponse.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else
        {
            if signedObjectResponse["Status"].stringValue == "Success"
            {
                if ConnectionCheck.isConnectedToNetwork()
                {
                    blurEffectView.removeFromSuperview()
                    //ANLoader.showLoading("", disableUI:false)
                    ServerService.showActivityIndicatory(uiView:self.view)
                    let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"ASHTSkipStatus": "0"]
                    ServerService.getMessages(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponse(response:))
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
                //ServerService.ShowAlertMessage(ErrorMessage:signedObjectResponse["Message"].stringValue, title: "", view:self)
            }
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
        //calling the api
        DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
            ANLoader.hide()
        })
        if ConnectionCheck.isConnectedToNetwork()
        {
            //ANLoader.showLoading("", disableUI:false)
            ServerService.showActivityIndicatory(uiView:self.view)
            let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Language":language,"ASHTSkipStatus": "0"]
            ServerService.getMessages(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponse(response:))
        }
        else
        {
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
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
extension MessagesViewController:wageRateDelegate
{
    func wageRateStatus(success: Bool) {
        print("success")
        ASHTSkipStatus = 0
        self.getMessages()
    }
    
    
}

extension MessagesViewController:formDelegate
{
    func formStatus(success: Bool, skipStatus: Int) {
        print("success")
        ASHTSkipStatus = skipStatus
        self.getMessages()
    }
    
}

