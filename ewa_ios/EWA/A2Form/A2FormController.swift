//
//  A2FormController.swift
//  EWA
//
//  Created by NFC User on 7/22/21.
//  Copyright © 2021 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON

class A2FormController: BaseViewController, popAlertDelegate, UITextFieldDelegate, popDateDelegate {
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var securityNumberTF: UITextField!
    @IBOutlet weak var printButton: UIButton!
    
    @IBOutlet weak var viewBottom: NSLayoutConstraint!
    @IBOutlet weak var pressToSignButton: UIButton!
    @IBOutlet weak var signDateLabel: UILabel!
    @IBOutlet weak var signatureLabel: UILabel!
    @IBOutlet weak var registrationNumber: UITextField!
    @IBOutlet weak var dobTF: UITextField!
    @IBOutlet weak var middleNameTF: UITextField!
    @IBOutlet weak var mainHeadingLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    var object: JSON = JSON.null
    var A2FormObject: JSON = JSON.null
    var fromSideMenu = Bool()
    let allowedCharacters = CharacterSet(charactersIn:"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ").inverted
    override func viewDidLoad() {
        super.viewDidLoad()
        coverView.isHidden = false
        self.loadViewss()
        delayWithSeconds(0.5) {
            self.getFormData()
        }
    }
    
    func loadViewss(){
        firstNameTF.delegate = self
        middleNameTF.delegate = self
        lastNameTF.delegate = self
        securityNumberTF.delegate = self
        registrationNumber.delegate = self
        dobTF.delegate = self
        self.changeNavigationTitle(object["FormName"].stringValue)
    }
    func changeNavigationTitle(_ titleStr: String) {
        let tlabel = UILabel()
        tlabel.text = titleStr
        tlabel.textColor = UIColor.white
        tlabel.font = UIFont.systemFont(ofSize:15)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.textAlignment = .center
        tlabel.numberOfLines = 0
        tlabel.minimumScaleFactor = 0.5
        self.navigationItem.titleView = tlabel
    }
    func getFormData()
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:self.view)
            
            let params =
                ["CandId" : UserDefaults.standard.object(forKey: "cID") as! String]  as [String : Any]
            print(params)
            ServerService.GetUPKA2Detail(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.getA2FormDataObject(response:))
            
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            
        }
        
    }
    
    // response from the server
    func getA2FormDataObject(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        self.A2FormObject = response as! JSON
        print(A2FormObject)
        if A2FormObject["Status"].intValue == 1{
            coverView.isHidden = true
            if self.A2FormObject["DontAllowEdit"].boolValue {
                //Signed Form
                printButton.isHidden = false
                viewBottom.constant = 120
                firstNameTF.isEnabled = false
                middleNameTF.isEnabled = false
                lastNameTF.isEnabled = false
                securityNumberTF.isEnabled = false
                registrationNumber.isEnabled = false
                dobTF.isEnabled = false
                pressToSignButton.isHidden = true
                signatureLabel.text = "\(self.A2FormObject["Signature"].stringValue)\nApplicant’s Signature"
                signDateLabel.text  = "\(self.A2FormObject["SignDate"].stringValue)\nDate (month/day/year)"
            }
            else {
                
                // NOt Signed Form
                printButton.isHidden = true
                viewBottom.constant = 80
                pressToSignButton.isHidden = false
                signatureLabel.text = "Signature"
                signDateLabel.text  = "Date"
                firstNameTF.isEnabled = true
                middleNameTF.isEnabled = true
                lastNameTF.isEnabled = true
                securityNumberTF.isEnabled = true
                registrationNumber.isEnabled = true
                dobTF.isEnabled = true
            }
            
            self.logoImageView.sd_setImage(with:URL(string:self.A2FormObject["ImagePath"].stringValue), placeholderImage: UIImage(named:"No_Image"))
            self.mainHeadingLabel.text = self.A2FormObject["MainHeading"].stringValue
            firstNameTF.text = self.A2FormObject["FirstName"].stringValue
            middleNameTF.text = self.A2FormObject["MiddleName"].stringValue
            lastNameTF.text = self.A2FormObject["LastName"].stringValue
            securityNumberTF.text = self.A2FormObject["SSN"].stringValue
            dobTF.text = self.A2FormObject["DOB"].stringValue
            registrationNumber.text = self.A2FormObject["AlienRegistration"].stringValue
        }
        else {
            var messagee = String()
            if A2FormObject["Message"].stringValue.count > 0 {
                messagee = A2FormObject["Message"].stringValue
            }
            else {
                messagee = "Something is not right here try again later"
            }
            ServerService.ShowAlertMessage(ErrorMessage:"", title: messagee, view:self)
        }
    }
    
    func formStatus(success: Bool) {
        
    }
    
    
    //MARK:- Info Button Actions
    @IBAction func registrationInfoClicked(_ sender: UIButton) {
        self.loadAlertPopupWithObject(4, messageText: self.A2FormObject["RegistrationNumberInstructions"].stringValue.htmlToAttributedString!.string, attrbtedText: NSMutableAttributedString(), popKeyToSend: "", apiCallrequired: false)
        
    }
    @IBAction func dobInfoClicked(_ sender: UIButton) {
        
        self.loadAlertPopupWithObject(4, messageText: self.A2FormObject["DOBInstructions"].stringValue.htmlToAttributedString!.string, attrbtedText: NSMutableAttributedString(), popKeyToSend: "", apiCallrequired: false)
    }
    
    @IBAction func instructionsInfoClicked(_ sender: UIButton) {
        self.loadAlertPopupWithObject(4, messageText: "", attrbtedText: self.A2FormObject["MainIstructions"].stringValue.htmlToAttributedString!, popKeyToSend: "", apiCallrequired: false)
        
    }
    func loadAlertPopupWithObject(_ viewStatus: Int, messageText: String, attrbtedText: NSAttributedString, popKeyToSend: String, apiCallrequired: Bool)
    {
        let window = UIApplication.shared.keyWindow!
        
        let formView = Bundle.main.loadNibNamed("AlertPopView", owner: nil, options: nil)![0] as! AlertPopView
        
        formView.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
        formView.viewStatus = viewStatus
        formView.popKeyToSend = popKeyToSend
        formView.attrbtedText = attrbtedText
        formView.messageText = messageText
        formView.loadForm()
        formView.toCOntroller = UIApplication.getTopMostViewController()!
        formView.popAlertDelegate = self
        formView.apiCallrequired = apiCallrequired
        window.addSubview(formView)
        window.bringSubview(toFront:formView)
    }
    
    //MARK:- Press To SIgn Action
    @IBAction func pressToSignClicked(_ sender: UIButton) {
        /*
         if firstNameTF.text!.replacingOccurrences(of: " ", with: "").count == 0{
         ServerService.ShowAlertMessage(ErrorMessage:"", title: "First name should not be empty", view:self)
         }
         
         else if lastNameTF.text!.replacingOccurrences(of: " ", with: "").count == 0 {
         ServerService.ShowAlertMessage(ErrorMessage:"", title: "Last name should not be empty", view:self)
         }
         else if securityNumberTF.text!.replacingOccurrences(of: " ", with: "").count == 0 {
         ServerService.ShowAlertMessage(ErrorMessage:"", title: "Sicial security number should not be empty", view:self)
         }
         else if dobTF.text!.replacingOccurrences(of: " ", with: "").count == 0 {
         ServerService.ShowAlertMessage(ErrorMessage:"", title: "Date of birth should not be empty", view:self)
         }
         else if registrationNumber.text!.replacingOccurrences(of: " ", with: "").count == 0 {
         ServerService.ShowAlertMessage(ErrorMessage:"", title: "Alien registration number should not be empty", view:self)
         }
         else {
         self.callFinalService()
         }
         */
        self.callFinalService()
    }
    
    func callFinalService() {
        
        let paramss:[String:String] = ["CandId":"\(UserDefaults.standard.object(forKey: "cID") as! String)",
                                       "ProgramName":A2FormObject["ProgramName"].stringValue, "PermitDCID":A2FormObject["PermitDCID"].stringValue, "Date":A2FormObject["Date"].stringValue, "AlienRegistration":registrationNumber.text!,"DOB":dobTF.text!, "FirstName":firstNameTF.text!,"LastName":lastNameTF.text!,
                                       "SSN":securityNumberTF.text!,
                                       "MiddleName":middleNameTF.text!,
                                       "AppVersion":"IOS,\(Constants.APP_VERSION)"]
        //  print(params)
        Constants.A2insertParams = paramss
        
        //        let signView = Bundle.main.loadNibNamed("SignView", owner: nil, options: nil)![0] as! SignView
        //        signView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height)
        //        signView.setUp()
        //        signView.object = object
        //        signView.signDelegate = self
        //        self.view.addSubview(signView)
        //        self.view.bringSubview(toFront:signView)
        
        let window = UIApplication.shared.keyWindow!
        let formView = Bundle.main.loadNibNamed("A1SignView", owner: nil, options: nil)![0] as! A1SignView
        formView.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
        formView.setUp()
        formView.object = object
        formView.signDelegate = self
        window.makeKeyAndVisible()
        UIApplication.getTopMostViewController()!.view.addSubview(formView)
        UIApplication.getTopMostViewController()!.view.bringSubview(toFront:formView)
    }
    
    //MARK:- TextField Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == securityNumberTF
        {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = formattedNumber(number: newString)
            
            return false
        }
        else if textField == firstNameTF || textField == middleNameTF || textField == lastNameTF{
            let components = string.components(separatedBy: allowedCharacters)
            let filtered = components.joined(separator: "")
            
            if string == filtered {
                
                return true
                
            } else {
                
                return false
            }
        }
        else {
            
            return true
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == dobTF {
            self.view.endEditing(true)
            textField.resignFirstResponder()
            self.showCalender(type: 0, HeadingText: "Select Date of Birth", dateToSelect: dobTF.text!)
            return false
        }
        else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func formattedNumber(number: String) -> String
    {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "XXX-XX-XXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    func selectedDate(date: String, type: Int) {
        dobTF.text = date
    }
    //MARK:- Show Calendar
    func showCalender(type: Int, HeadingText: String, dateToSelect:String) {
        
        let window = UIApplication.shared.keyWindow!
        
        let formView = Bundle.main.loadNibNamed("DateSelection", owner: nil, options: nil)![0] as! DateSelection
        
        formView.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
        formView.topLabelText = HeadingText
        formView.type = type
        formView.toCOntroller = self
        formView.dateDelegate = self
        formView.selectedDate = dateToSelect
        formView.loadDateView()
        window.addSubview(formView)
        window.bringSubview(toFront: formView)
        delayWithSeconds(0.2) {
            self.view.endEditing(true)
            self.dobTF.resignFirstResponder()
        }
        
    }
    
    func getPrintFormData()
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:self.view)
            
            let params =
                ["CandID" : UserDefaults.standard.object(forKey: "cID") as! String,"FormCode":"A2_SeriesPDF"]  as [String : Any]
            print(params)
            ServerService.GeneratePrintPDF(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.getPrintFormDataObject(response:))
            
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            
        }
        
    }
    // response from the server
    func getPrintFormDataObject(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        let printObject = response as! JSON
        print("****** PDF Data is ************\n",printObject)
        if printObject["PDFFileName"].stringValue.count > 5  {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let privacyViewController = mainStoryboard.instantiateViewController(withIdentifier: "pVC") as! PrivacyPolicyViewController
            privacyViewController.link = printObject["PDFFileName"].stringValue
            privacyViewController.headerText = object["FormName"].stringValue
            privacyViewController.isPush = true
            Constants.iSFormOkRequired = false
            self.navigationController?.pushViewController(privacyViewController, animated: true)
        }
            else {
                var messagee = String()
                if printObject["Message"].stringValue.count > 0 {
                    messagee = printObject["Message"].stringValue
                }
                else {
                    messagee = "Something is not right here try again later"
                }
                ServerService.ShowAlertMessage(ErrorMessage:"", title: messagee, view:self)
            }
    }
    
    @IBAction func printClicked(_ sender: UIButton) {
        
        self.getPrintFormData()
    }
    
}
extension A2FormController:a1signatureDelagte
{
    func signatureStatus(success: Bool) {
        print("success")
        if fromSideMenu == true {
            self.getFormData()
        }
        else if Constants.Menu == "DashBoard" {
            let vc = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"message") as? MessagesViewController)!
            let navi = BaseNaviViewController(rootViewController:vc)
            navi.navigationBar.tintColor = .white
            navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"message")
            
        }
        else {
            let identifier = Constants.Menu
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateVC(withIdentifier: identifier) {
                let navi = BaseNaviViewController(rootViewController:viewController)
                navi.navigationBar.tintColor = .white
                navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                sideMenuController?.embed(centerViewController:navi, cacheIdentifier:identifier)
            }
        }
    }
}
