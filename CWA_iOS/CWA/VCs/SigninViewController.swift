//
//  SigninViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 01/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit
import CoreTelephony
import SwiftyJSON

class SigninViewController: BaseViewController {
    
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var showPasswordBtn: UIButton!
    @IBOutlet var versionLbl: UILabel!
    
    var activeField: UITextField?
    var paramsDict = [String: AnyObject]()
    @IBOutlet var aScrollView: UIScrollView!
    var object: JSON = JSON.null
    @IBOutlet var whiteBGView: UIView!
    @IBOutlet var whiteBGSuperView: UIView!
    @IBOutlet weak var whiteBGSuperViewHeightConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        passwordTextField.text = ""
        usernameTextField.text = ""
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            //        if let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            //             versionLbl.text =  String(format: "v.%@",version)
            //         }
            versionLbl.text = "v.\(RestAPI.displayVersion)"
            usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!,
                                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            
            passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!,
                                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(SigninViewController.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(SigninViewController.keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
            self.automaticallyAdjustsScrollViewInsets = false
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.whiteBGViewTapGesture)) //viv- This explained below for keyboard to end editing
            tap.delegate = self
            self.view.addGestureRecognizer(tap)
            
            let defaults = UserDefaults.standard
            let clientID = defaults.string(forKey: "ClientID")
            if clientID != nil {
                
                self.pushToDashboardPage()
                
            }else{
                
            }
            
            
            // Do any additional setup after loading the view.
        }
    @objc func whiteBGViewTapGesture(sender: UITapGestureRecognizer?) {
        
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /////
    
    @objc func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.aScrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        
        self.aScrollView.contentInset = contentInsets
        self.aScrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.aScrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
        self.aScrollView.contentInset = contentInsets
        self.aScrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.aScrollView.isScrollEnabled = false
    }
    
    //MARK: TEXTFIELD DELEGATES
    
    
    @IBAction func forgotPasswordAction(_ sender: Any)
    {
        self.pushToForgotPasswordPage()
    }
    @IBAction func showHidePasswordBtnAction(_ sender: UIButton)
    {
        if passwordTextField.isSecureTextEntry{
            passwordTextField.isSecureTextEntry = false
            
        }else{
            passwordTextField.isSecureTextEntry = true
        }
        
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
    }
    
    
    @IBAction func loginActionTest(_ sender: Any)
    {
        
        //        self.showCustomAlert(Title: "Note", message: "my message my message my message my message my message my message my message my message my message my message my message my message my message my message my message my message 12", okBtnTitle: "OK",cancelBtnTitle:"", type: Warning_Text)
    }
    @IBAction func loginAction(_ sender: Any)
        {
            // Setup the Network Info and create a CTCarrier object
            //                let networkInfo = CTTelephonyNetworkInfo()
            //                let carrier = networkInfo.subscriberCellularProvider
            //
            //        // Get carrier name
            //          let carrierName:String = (carrier?.carrierName)!
            //
//                    usernameTextField.text = "pkadrikar@tempositions.com"//"supriyan@nfcsolutionsusa.com" //"chaitanyak@nfcsolutionsusa.com" //"GouthamG@nfcsolutionsusa.com"//"pkadrikar@tempositions.com"//"nciappet@law.nyc.gov"//"lbeightol@tempositions.com"//"gouthamG@nfcsolutionsusa.com"//"jmedina@schoolprofessionals.com"
//                    passwordTextField.text = "P@ssw0rd1209"//"test123"//"P@ssw0rd0"//"test123"//gnytataxi"
            //"pkadrikar@tempositions.com"//"Vscuder@schools.nyc.gov"
            //nciappet@law.nyc.gov,gnytataxi//one division
//                    passwordTextField.text = "testing"//"lbeightol85"//"test123"//testing
            
            let username = usernameTextField.text
            let password = passwordTextField.text
            
            
            switch (username!.filter { $0 != " " }, password!.filter { $0 != " " }) {
            case ("", ""):
                print("Please enter all the details")
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Please enter all the details", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            case ("", _):
                print("Please Enter Email Address")
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Please Enter Email Address", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            case (_, ""):
                print("Please Enter Password")
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Please Enter Password", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            case (_, _):
                print("SigninServerCall.")
                self.SigninServerCall() //viv- From here it goes to validation
                
            }
            
            
            //        let isEmptyUserName = usernameTextField.text?.isEmpty
            //        let isEmptyPassword = passwordTextField.text?.isEmpty
            
            //        if isEmptyUserName == false && isEmptyPassword == false {
            //
            //
            //
            //            self.SigninServerCall()
            //
            //
            //        } else{
            //            var message = "Please enter all the details"
            //            if isEmptyUserName == true{
            //                message = "Please Enter Email Address"
            //            }else if isEmptyPassword == true{
            //                message = "Please Enter Password"
            //            }
            ////            self.ShowAlertMessage(message: message, title: "")
            //            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            //
            //        }
        }
    
    //aftergettingResponseFrom the server
    func getresponse(response:AnyObject)->()
    {
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            
            //            self.ShowAlertMessage(message: response as! String, title: "")
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            if object["MessageStatus"].intValue == 1
            {
                UserDefaults.standard.set(object["Token"].stringValue, forKey: "Token")
                UserDefaults.standard.set(object["DivisionId"].stringValue, forKey: "User_DivisionId")
                UserDefaults.standard.set(object["Password"].stringValue, forKey: "Password")
                UserDefaults.standard.set(object["UserName"].stringValue, forKey: "UserName")
                UserDefaults.standard.set(object["ContactId"].stringValue, forKey: "User_ContactId")
                UserDefaults.standard.set(object["CandName"].stringValue, forKey: "CandName")
                UserDefaults.standard.set(object["Email"].stringValue, forKey: "Email")
                UserDefaults.standard.set(object["DivCount"].intValue, forKey: "DivCount")
                UserDefaults.standard.set(object["ClientID"].intValue, forKey: "User_ClientID")
                UserDefaults.standard.set(object["ColorCode"].stringValue, forKey: "User_ColorCode")
                //20e5d5
                let defaults = UserDefaults.standard
                let divCount = defaults.integer(forKey: "DivCount")
                
                let isPasswordChanged = object["passwordchanged"].boolValue
                let  PasswordFromServer = object["Password"].stringValue
                
                self.logUser()
                
                if isPasswordChanged == true || (PasswordFromServer.caseInsensitiveCompare("test") == ComparisonResult.orderedSame) {
                    
                    self.pushToChangePasswordPage(divCount: divCount)
                }else{
                    
                    if divCount > 1{
                        self.pushToDivisionListPage()
                    }else{
                        //call division API to get details about division
                        self.getDivisionListCall()
                    }
                }
                UserDefaults.standard.synchronize()
                
            }else{
                var message = object["Message"].stringValue
                if message.count == 0{
                    message = Error_Message
                    
                }
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }
    }
    func logUser() {
        //userid as String
        let UserName = String(format:"%@", UserDefaults.standard.string(forKey: "CandName")!)
        
        let Email = String(format:"%@", UserDefaults.standard.string(forKey: "Email")!)
        
        let User_ContactId = String(format:"%@", UserDefaults.standard.string(forKey: "User_ContactId")!)
        
        // TODO: Use the current user's information
        // You can call any combination of these three methods
    }
    
    ////
    func pushToDivisionListPage() {
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DivisionListViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DivisionListSegue") as! DivisionListViewController
            nextViewController.isFromSignin = true
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    func pushToForgotPasswordPage() {
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is ForgotPasswordViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ForgotPasswordSegue") as! ForgotPasswordViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    func pushToDashboardPage() {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DashboardSegue") as! DashboardViewController
        nextViewController.isFromDivisionPage = false
        self.navigationController?.pushViewController(nextViewController, animated: false)
        
    }
    func pushToChangePasswordPage(divCount: NSInteger) {
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is ChangePasswordViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordSegue") as! ChangePasswordViewController
            nextViewController.isFromSigninPage = true
            nextViewController.divisionCount = divCount
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    //getting os version
    func getOSInfo()->String {
        let os = ProcessInfo().operatingSystemVersion
        return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
    }
    //getting device name
    func deviceName() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let str = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
            return String(cString: ptr)
        }
        return str
    }
    
    // MARK: - SERVER CALL
    /*
     "username":"pkadrikar@tempositions.com",
     "password":"test123",
     "Source":"Android",
     "APPVersion":"1.0.22",
     "MobileOSVersion":"Redmi Note 4",
     "PhoneType":"7.0"
     */
    func SigninServerCall(){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            
            JustHUD.shared.showInView(view: view)
            //if let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            
            let params :[String:String] = ["username":usernameTextField.text!,"password":passwordTextField.text!,"MobileOSVersion":"\(getOSInfo())","Source":"iOS","PhoneType":"\(deviceName())","APPVersion":RestAPI.displayVersion] //version
            print(params)
            RestAPI.loginByMobileNumber(self, params: params, method: "POST", callBack:getresponse(response:))
            //            }else{
            //                let params :[String:String] = ["UserName":usernameTextField.text!,"Password":passwordTextField.text!,"MobileAppVersion":"iOS","MobileCarrier":"AIRTEL"]
            //                print(params)
            //                RestAPI.loginByMobileNumber(self, params: params, method: "POST", callBack:getresponse(response:))
            //
            //            }
        }else{
            
            //                self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    func getDivisionListCall() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            let defaults = UserDefaults.standard
            
            let username = defaults.string(forKey: "UserName")
            let clientID = String(format:"%d", defaults.integer(forKey: "User_ClientID"))
            let DivisionId = String(format:"%d", defaults.integer(forKey: "User_DivisionId"))
            
            //userid as String
            let params :[String:String] = ["UserName":username!,"ClientID":clientID,"DivisionId":DivisionId]
            print("viv the params from line 414 is \(params)***")
            RestAPI.getListOfDivisions(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getDivisionResponse(response:))
            
        }else{
            
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    
    func getDivisionResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            
            //            self.ShowAlertMessage(message: response as! String, title: "")
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
                
                let dataArray = object["DivisionList"].array
                
                
                
                for dict in dataArray! {
                    
                    let div = Division.init(Div_ID: dict["Div_ID"].intValue, client_name: dict["client_name"].stringValue, district: dict["district"].stringValue, City:  dict["City"].stringValue, location_code: dict["location_code"].stringValue, State: dict["State"].stringValue, CodeZip: dict["CodeZip"].stringValue, Phone: dict["Phone"].stringValue, client_id: dict["client_id"].intValue, contact_id: dict["contact_id"].intValue, pending_ts: dict["pending_ts"].intValue,division: dict["division"].stringValue,comp_name: dict["comp_name"].stringValue,LogoPath: dict["LogoPath"].stringValue,ColorCode: dict["ColorCode"].stringValue,SmallLogoPath: dict["APISmallLogoPath"].stringValue)
                    
                    let ColorCode = div.ColorCode
                    let logoPath = div.LogoPath
                    let clientID = String(format:"%d",div.client_id!)
                    let contactID = String(format:"%d",div.contact_id!)
                    let divisionId = String(format:"%d",div.Div_ID!)
                    
                    let DivisionId = div.Div_ID
                    let clientName =   div.client_name
                    let comp_name =   div.comp_name
                    
                    var divName = ""
                    
                    if DivisionId == 102 {
                        
                        divName = comp_name!
                        if comp_name?.count == 0{
                            divName = clientName!
                            
                        } else{
                            divName = comp_name!
                            
                        }
                    }else{
                        if clientName?.count == 0{
                            divName = comp_name!
                            
                        } else{
                            divName = clientName!
                            
                        }
                    }
                    
                    UserDefaults.standard.set(ColorCode, forKey: "ColorCode")
                    UserDefaults.standard.set(logoPath, forKey: "LogoPath")
                    UserDefaults.standard.set(clientID, forKey: "ClientID")
                    UserDefaults.standard.set(contactID, forKey: "ContactId")
                    UserDefaults.standard.set(divisionId, forKey: "DivisionId")
                    UserDefaults.standard.set(divName, forKey: "DivisionName")
                    
                    UserDefaults.standard.synchronize()
                    if #available(iOS 13.0, *) {
                        let appearance = UINavigationBarAppearance()
                        appearance.configureWithDefaultBackground()
                        appearance.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
                        navigationController?.navigationBar.prefersLargeTitles = false
                        navigationController?.navigationBar.standardAppearance = appearance
                        navigationController?.navigationBar.scrollEdgeAppearance = appearance
                    }
                    else {
                        self.navigationController?.navigationBar.barTintColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
                    }
                    self.pushToDashboardPage()
                    break
                }
                
            }else{
                
                var message = object["message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message 
                    
                }
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
                //                self.ShowAlertMessage(message: message, title: "")
                //            RestAPI.ShowAlertMessage(ErrorMessage: message, titleMessage: " ", view: self)
            }
        }
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        
        
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            self.aScrollView.isScrollEnabled = false
            DispatchQueue.main.async(execute: { () -> Void in
                self.aScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
                self.whiteBGSuperViewHeightConstraint.constant = UIScreen.main.bounds.size.height
                self.view.layoutIfNeeded()
            })
        case .portraitUpsideDown:
            text="PortraitUpsideDown"
        case .landscapeLeft:
            text="LandscapeLeft"
            self.aScrollView.isScrollEnabled = true
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.aScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height + 300)
                self.whiteBGSuperViewHeightConstraint.constant = UIScreen.main.bounds.size.height + 200
                self.view.layoutIfNeeded()
            })
        case .landscapeRight:
            text="LandscapeRight"
            self.aScrollView.isScrollEnabled = true
            DispatchQueue.main.async(execute: { () -> Void in
                self.aScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height + 300 )
                self.whiteBGSuperViewHeightConstraint.constant = UIScreen.main.bounds.size.height + 200
                self.view.layoutIfNeeded()
            })
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
        
    }
}
/*
 SIGNIN RESPONSE
 "MessageStatus" : 1,
 "Email" : "pkadrikar@tempositions.com",
 "UserName" : "pkadrikar@tempositions.com",
 "Message" : "Success",
 "passwordchanged" : false,
 "ContactId" : 214451,
 "DivisionId" : 102,
 "MobileAppVersion" : "iOS",
 "DivCount" : 52,
 "ColorCode" : "#002763",
 "MobileCarrier" : "AIRTEL",
 "Token" : "VUAvrDfCjhTn+gkeRo4o\/MTbN9eVibBHDWRFUDjEJL4=",
 "ValidDate" : "2018-04-28T01:05:32.7189096-04:00",
 "CandName" : "Prasad Kadrikar",
 "ClientID" : 44886
 */
extension SigninViewController:UITextFieldDelegate{
    
    //called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool     {
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        //        activeField = textField
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
        if self.isPortrait() == false{
            self.aScrollView.isScrollEnabled = true
        }
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        return true
    }
}
