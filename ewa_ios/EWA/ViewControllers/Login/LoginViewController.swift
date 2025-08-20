//
//  LoginViewController.swift
//  EWA
//
//  Created by NFC Solutions on 09/10/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreTelephony
import ANLoader
//import Crashlytics
//import Fabric
import WebKit

class LoginViewController: UIViewController {
    
    //variable declarations
    var menuObject: JSON = JSON.null
    var appVesrion: JSON = JSON.null
    var signedObjectResponse:JSON = JSON.null
    var object: JSON = JSON.null
    var deviceIdObj:JSON = JSON.null
    var activeField: UITextField?
    var blurEffect = UIBlurEffect()
    var blurEffectView = UIVisualEffectView()
    var checked = Bool()
    var userName = String()
    var show = Bool()
    var rememberMe = Bool()
    
    @IBOutlet weak var versionLabel: UILabel!
    //storyboard reference's
    @IBOutlet var eyeImageView: UIImageView!
    @IBOutlet var passwordTextField: NiceTextField!
    @IBOutlet var usernameTextField: NiceTextField!
    
    
    //formView
    @IBOutlet var formView: UIView!
    @IBOutlet weak var formWebView: WKWebView!
    
    //signatureView
    @IBOutlet var signatureView: UIView!
    @IBOutlet var signatureTextField: UITextField!
    @IBOutlet var checkBoxButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signatureHeaderView: UIView!
    
    @IBOutlet weak var checkBoxImage: UIImageView!
    
    @IBOutlet weak var scrollContentHeight: NSLayoutConstraint!
    var scrollContentHeightCnst = Int()
    @IBOutlet weak var contentView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.remember(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        checkBoxImage.addGestureRecognizer(tapGesture)
        
        print(getOSInfo())
        print(deviceName())
        print("*********class name is *********",className)
        if UserDefaults.standard.object(forKey: "significant") != nil {
        }
        else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.stopMonitoringLocationManager()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        versionLabel.text = "v.\(Constants.APP_VERSION)"
        
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
    
    
    //remeber me check box action
    @objc func remember(_ sender: UITapGestureRecognizer) {

        print("***VIV the remeber me option is \(rememberMe)***")
        
        if rememberMe {
            print("***VIV remember me clicked***")
            checkBoxImage.image = UIImage(named:"wuncheck.png")
            rememberMe = false
            UserDefaults.standard.set(rememberMe, forKey:"remember")
        } else{
            checkBoxImage.image = UIImage(named:"wcheck.png")
            rememberMe = true
            UserDefaults.standard.set(rememberMe, forKey:"remember")
        }
    }
    
    
    
    // password show and hide function
    @IBAction func eyeTapped(_ sender: UITapGestureRecognizer) {
        if show
        {
            passwordTextField.isSecureTextEntry = true
            eyeImageView.image = UIImage(named:"eyeVisible.png")
            show = false
        }
        else
        {
            passwordTextField.isSecureTextEntry = false
            eyeImageView.image = UIImage(named:"eyeOutline.png")
            show = true
        }
        
    }
    
    
    
    
    
    //clearing the catche and ending the ignorance
    override func viewWillDisappear(_ animated: Bool) {
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
    }
    
    
    
    
    //textfield delegate methos
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
    
    
    @IBAction func loginAction(_ sender: Any)
    {
        
        self.view.endEditing(true)
        
        if ((usernameTextField.text?.count)!>0)&&(passwordTextField.text?.count)!>0
        {
            if ConnectionCheck.isConnectedToNetwork()
            {
                //ANLoader.showLoading("", disableUI:true)
                ServerService.showActivityIndicatory(uiView:self.view)
                userName = usernameTextField.text!
                UserDefaults.standard.set(usernameTextField.text!, forKey:"username")
                let params :[String:String] = ["username":usernameTextField.text!,"password":passwordTextField.text!,"mobileappversion":"iOS","APPVersion":Constants.APP_VERSION,"MobileOSVersion":"\(getOSInfo())","PhoneType":"\(deviceName())","DeviceId":"\(UIDevice.current.identifierForVendor!.uuidString.stripped)","Deviceusername":"\(UIDevice.current.name)"]
                print(params)
                ServerService.loginByMobileNumber(self, params: params, method: "POST", callBack:getresponse(response:))
                
                
            }
            else
            {
                ANLoader.hide()
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
                ANLoader.hide()
            })
            
        }
        else if (usernameTextField.text?.count)! == 0&&(passwordTextField.text?.count)! == 0
        {
            ServerService.ShowAlertMessage(ErrorMessage: "Enter valid username and password", title: "", view: self)
        }
        else if (usernameTextField.text?.count)! == 0
        {
            ServerService.ShowAlertMessage(ErrorMessage: "Enter username", title: "", view: self)
        }
        else if (passwordTextField.text?.count)! == 0
        {
            ServerService.ShowAlertMessage(ErrorMessage: "Enter password", title: "", view: self)
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage: "Enter valid username and password", title: "", view: self)
        }
    }
    
    
    //aftergettingResponseFrom the server
    func getresponse(response:AnyObject)->()
    {
        print(response)
        object = response as! JSON
        
        if object.isEmpty
        {
            print("empty")
            removeAll()
            ANLoader.hide()
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if object["MessageStatus"].intValue == 1
        {
            
            //accessToken
            removeAll()
            let cID = object["CandId"].stringValue+":"
            let Token = object["Token"].stringValue
            Constants.Token = cID+Token
            //server call
            
            let paramsMenu:[String:String] = ["CandidateId":object["CandId"].stringValue,"DivisionId":object["DivisionId"].stringValue,"emptype":object["EmployeeType"].stringValue,"DeviceToken":Constants.FCMToken,"DeviceUserName":"\(UIDevice.current.name)",
                                              "DeviceType": "iOS",
                                              "IsActive" :"1",
                                              "Device" :"\(UIDevice.current.model)"]
            print("MENULINKS_PARAMS \(paramsMenu)")
            ServerService.getAccountEWAMenuLinks(self, params: paramsMenu, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseForMenu(response:))
            
        }
        else if object["MessageStatus"].intValue == 2
        {
            ANLoader.hide()
            ServerService.hideProgressView()
            formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height)
            self.view.addSubview(formView)
            self.view.bringSubview(toFront:formView)
            
            print(object["File"].stringValue.replace(target:"\\", withString:""))
            let url = URL(string:object["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
            let request = URLRequest(url: url!)
            formWebView.load(request)
        }
        else if object["MessageStatus"].intValue == 3
        {
            UserDefaults.standard.set(object["Title"].stringValue, forKey:"demoCname")
            self.performSegue(withIdentifier: "demoSegue", sender: nil)
        }
        else
        {
            removeAll()
            ANLoader.hide()
            ServerService.hideProgressView()
            if Constants.version == false
            {
                ServerService.ShowAlertMessage(ErrorMessage:"New version of the app is available in the app store please update", title: "Update Available", view:self)
            }
            else
            {
                ServerService.ShowAlertMessage(ErrorMessage:"", title:object["Message"].stringValue , view: self)
            }
        }
    }
    
    
    
    //aftergettingResponseFrom the server
    func getresponseForMenu(response:AnyObject)->()
    {
        Constants.menuHeaders.removeAll()
        Constants.menuSectionLogos.removeAll()
        Constants.menuSections.removeAll()
        Constants.dashObject = JSON.null
        Constants.menuObjj.removeAll()
        menuObject = response as! JSON
        if menuObject.isEmpty
        {
            print("empty")
            ANLoader.hide()
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else
        {
            
            print(menuObject)
            if (menuObject["IsPopupRequired"] != nil){
                Constants.isScrSigned = menuObject["IsPopupRequired"].intValue
            }
            else{
                Constants.isScrSigned = -1
            }
            Constants.isScrMessage =  menuObject["SCRMessage"].stringValue
            Constants.globalMessgae =   menuObject["PopUpMessage"].stringValue
            if (menuObject["Popup"] != nil){
                Constants.globalMessageKey =  menuObject["Popup"].intValue
            }
            else{
                Constants.globalMessageKey = -1
            }
            
            Constants.isETCCheck = menuObject["ETCcheck"].stringValue
            
            Constants.PushNotificationStatus = menuObject["Pushnotification"]["PushNotificationStatus"].intValue
            Constants.PushNotificationMessage = menuObject["Pushnotification"]["PushNotificationMessage"].stringValue
            Constants.PushNotificationPopup = menuObject["Pushnotification"]["PushNotificationPopup"].intValue
            
            //For Any GLobal Alert and Global Form
            
            Constants.globalPopupStatus = menuObject["GlobalPopup"]["popupStatus"].intValue
            Constants.globalPopupMessage = menuObject["GlobalPopup"]["PopupMessage"].stringValue
            Constants.globalPopupFormName = menuObject["GlobalPopup"]["FormName"].stringValue
            Constants.globalPopupFormLink = menuObject["GlobalPopup"]["FormLink"].stringValue
            Constants.globalPopupKey = menuObject["GlobalPopup"]["PopupKey"].stringValue
            Constants.globalAlertStatus = menuObject["GlobalPopup"]["Status"].intValue
            Constants.globalLinkType = menuObject["GlobalPopup"]["LynkType"].stringValue
            
            Constants.locationAllowMessage = menuObject["LocationMessage"].stringValue //LocationMessage
            
            store_all_menus()
            store_all_the_userdata()
            navigate_desired_screen()
            
            print("the value of candName is ", UserDefaults.standard.object(forKey:"CandName") as? String ?? "UNKNOWN")
            
            //creating the top menu array // viv- Right top menu items
            Constants.menuOptionNameArray = [UserDefaults.standard.object(forKey:"CandName") as! String,"Change Password","Change Profile Picture","Privacy Policy","Logout"]
        }
    }
    
    
    //getting and storing all the menu headers and titles
    func store_all_menus()
    {
        Constants.menuParentMenuIDs.removeAll()
        Constants.titleImages.removeAll()
        Constants.menuSections.removeAll()
        Constants.menuObjj.removeAll()
        Constants.menuSectionLogos.removeAll()
        
        //getting the main headers if the menu
        for menu in 0..<menuObject["List"].arrayValue.count
        {
            if menuObject["List"][menu]["ParentMenuId"].intValue == 0
            {
                Constants.menuHeaders.append(menuObject["List"][menu]["LinkText"].stringValue)
                Constants.titleImages.append(menuObject["List"][menu]["LogoPath"].stringValue)
                Constants.menuParentMenuIDs.append(menuObject["List"][menu]["MenuId"].intValue)
                Constants.menuObjj.append(menuObject["List"][menu])
                
            }
        }
        
        //getting the sub headers for the menu
        
        for menuection in 0..<Constants.menuHeaders.count
        {
            var menuNames = [String]()
            var menuLogos = [String]()
            for menu in 0..<menuObject["List"].arrayValue.count
            {
                if Constants.menuParentMenuIDs[menuection] == menuObject["List"][menu]["ParentMenuId"].intValue && !menuNames.contains(menuObject["List"][menu]["LinkText"].stringValue)
                {
                    menuNames.append(menuObject["List"][menu]["LinkText"].stringValue)
                    menuLogos.append(menuObject["List"][menu]["LogoPath"].stringValue)
                    
                }
            }
            
            if Constants.menuObjj[menuection]["ParentMenuId"].intValue == 0 && Constants.menuObjj[menuection]["MenuId"].intValue == 7 && !menuNames.contains(Constants.menuObjj[menuection]["LinkText"].stringValue){
                menuNames.append(Constants.menuObjj[menuection]["LinkText"].stringValue)
                menuLogos.append(Constants.menuObjj[menuection]["LogoPath"].stringValue)
            }
            
            Constants.menuSections.append(menuNames)
            Constants.menuSectionLogos.append(menuLogos)
        }
        
        Constants.dashObject = menuObject
        
        
    }
    
    //this function is used to store all the user data for furthur usage
    func store_all_the_userdata()
    {
        
        UserDefaults.standard.set(object["Token"].stringValue, forKey: "token")
        UserDefaults.standard.set(object["ColorCode"].stringValue, forKey: "color")
        UserDefaults.standard.set(object["LogoPath"].stringValue, forKey: "logo")
        UserDefaults.standard.set(object["CandId"].stringValue, forKey: "cID")
        UserDefaults.standard.set(object["DivisionId"].stringValue, forKey: "dID")
        UserDefaults.standard.set(object["CandName"].stringValue, forKey: "CandName")
        UserDefaults.standard.set(object["ImageFile"].stringValue, forKey: "ImageFile")
        UserDefaults.standard.set(object["EmployeeType"].intValue, forKey: "EmployeeType")
        UserDefaults.standard.set(object["Email"].stringValue, forKey:"Email")
    }
    
    
    //navigating to permanent employee screen if employee is permanent employee
    func navigate_permanent_employee()
    {
        //if selected remember me storing data else clearing the token
        if rememberMe
        {
            //viv added
//            print("***VIV remeber me if clause is working***")
//            store_all_the_userdata()
//            self.performSegue(withIdentifier:"permanentSegue", sender: nil)

        }
        else
        {
            UserDefaults.standard.set("", forKey:"token")
        }
        
        UserDefaults.standard.set(object["EmployeeTypMessage"].stringValue, forKey: "EmployeeTypMessage")
        self.performSegue(withIdentifier:"permanentSegue", sender: nil)
        
    }
    
    
    //this function is used to navigate to the proper screen after user login in successfully based on the condition
    func navigate_desired_screen()
    {
        //EmployeeType == 1 permanent employee for which we have to other screen's
        //is change password is taking user to update his password
        if object["IsChangePassword"].boolValue == true
        {
            if object["EmployeeType"].intValue == 1
            {
                navigate_permanent_employee()
            }
            else
            {
                self.performSegue(withIdentifier: "changeSegue", sender: nil)
            }
        }
        else
        {
            if object["EmployeeType"].intValue == 1
            {
                navigate_permanent_employee()
            }
            else
            {
                //if device id doesn't match asking for update or usage the same
                if object["DeviceStatus"].intValue == 0
                {
                    ServerService.hideProgressView()
                    ShowAlertMessage(ErrorMessage:object["DeviceMessage"].stringValue, title:"", view:self)
                }
                else
                {
                    //taking user to the dashboard
                    ServerService.hideProgressView()
                    self.loadAlertPopupWithObject()
                }
            }
        }
        
    }
    
    
    
    
    
    //overiding prepare for segue action
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeSegue"
        {
            let dvc = segue.destination as! ChangePasswordViewController
            dvc.fromString = "Login" 
        }
    }
    
    
    
    
    //called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool     {
        textField.resignFirstResponder()
        return true;
    }
    
    //remoview the blureffectview
    @IBAction func closeAction(_ sender: UIButton) {
        blurEffectView.removeFromSuperview()
    }
    //closes or removes the blureffectview
    @IBAction func closePopUpAction(_ sender: UIButton) {
        blurEffectView.removeFromSuperview()
    }
    //is called for the checkbox action
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
    
    
    //removing all the form view
    func removeAll()  {
        formView.removeFromSuperview()
    }
    //called sign is called
    @IBAction func formSignAction(_ sender: UIButton) {
        showPopUp()
    }
    
    //this is to configure and add form view
    func showPopUp() {
        checked = false
        signatureTextField.text = ""
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
    
    
    @IBAction func submitSignature(_ sender: UIButton) {
        
        if ConnectionCheck.isConnectedToNetwork()
        {
            if checked
            {
                if signatureTextField.text!.count>0
                {
                    //ANLoader.showLoading("", disableUI:false)
                    self.view.endEditing(true)
                    ServerService.showActivityIndicatory(uiView:self.view)
                    let cID = object["CandId"].stringValue+":"
                    let Token = object["Token"].stringValue
                    Constants.Token = cID+Token
                    let params:[String:String] = ["CandId":object["CandId"].stringValue,"DivisionId":object["DivisionId"].stringValue,"Name":object["CandName"].stringValue,"CandSignName":signatureTextField.text!,"FormName":object["FormName"].stringValue]
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
        if signedObjectResponse["Status"].stringValue == "Success"
        {
            if ConnectionCheck.isConnectedToNetwork()
            {
                blurEffectView.removeFromSuperview()
                //ANLoader.showLoading("", disableUI:false)
                ServerService.showActivityIndicatory(uiView:self.view)
                let params :[String:String] = ["username":usernameTextField.text!,"password":passwordTextField.text!,"mobileappversion":"iOS","APPVersion":Constants.APP_VERSION,"MobileOSVersion":"\(getOSInfo())","PhoneType":"\(deviceName())","DeviceId":"\(UIDevice.current.identifierForVendor!.uuidString)"]
                print(params)
                ServerService.loginByMobileNumber(self, params: params, method: "POST", callBack:getresponse(response:))
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
    
    
    
    
    //catching the device orentation
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            scrollContentHeight.constant = 0
            contentView.layoutIfNeeded()
        case .landscapeLeft:
            text="LandscapeLeft"
            scrollContentHeight.constant = 0
            scrollContentHeight.constant = self.view.bounds.size.height
            contentView.layoutIfNeeded()
        case .landscapeRight:
            text="LandscapeRight"
            scrollContentHeight.constant = 0
            scrollContentHeight.constant = self.view.bounds.size.height
            contentView.layoutIfNeeded()
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
    }
    
    
    
    
    // method gets executed when apply job is clicked
    @IBAction func applyJob(_ sender: Any) {
        
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        
        UserDefaults.standard.set("0", forKey:"cID")
        UserDefaults.standard.set("0", forKey:"dID")
        UserDefaults.standard.synchronize()
        
        self.performSegue(withIdentifier:"jobsSegue", sender:nil)
        
    }
    
    
    //to shoe alert to update the deviceID
    func ShowAlertMessage(ErrorMessage : String,title:String,view:UIViewController){
        DispatchQueue.main.async(execute: { () -> Void in
            
            let alert = UIAlertController(title:title, message: ErrorMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler:{ action in
                self.loadAlertPopupWithObject()
                // self.performSegue(withIdentifier:"homeSegue", sender:nil)
            }))
            alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler:{ action in
                if ConnectionCheck.isConnectedToNetwork()
                {
                    self.view.endEditing(true)
                    ServerService.showActivityIndicatory(uiView:self.view)
                    let params :[String:String] = ["CandidateId":"\(self.object["CandId"].stringValue)","DeviceId":"\(UIDevice.current.identifierForVendor!.uuidString.stripped)"]
                    print(params)
                    ServerService.updateDeviceId(self, params: params, method: "POST", accessToken:"", acces:false,callBack:self.getresponseCandLocation(response:))
                }
                else
                {
                    ServerService.hideProgressView()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                }
            }))
            view.present(alert, animated: true, completion: nil)
            
        })
        
    }
    
    //aftergettingResponseFrom the server
    func getresponseCandLocation(response:AnyObject)->()
    {
        print(response)
        ServerService.hideProgressView()
        deviceIdObj = response as! JSON
        if deviceIdObj["MessageStatus"].intValue == 1
        {
            self.loadAlertPopupWithObject()
            //self.performSegue(withIdentifier:"homeSegue", sender:nil)
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage:deviceIdObj["Message"].stringValue, title: "", view:self)
        }
    }
    
    
    //MARK: Load user details popview
    
    func loadAlertPopupWithObject()
    {
        
        if object["ShowUserInfoPopup"].stringValue == "1" {
            let window = UIApplication.shared.keyWindow!
            
            let formView = Bundle.main.loadNibNamed("UserInfoPOpup", owner: nil, options: nil)![0] as! UserInfoPOpup
            
            formView.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
            formView.toCOntroller = self
            formView.userDelegate = self
            formView.object = self.object
            formView.loadForm()
            UIApplication.getTopMostViewController()!.view.addSubview(formView)
            UIApplication.getTopMostViewController()!.view.bringSubview(toFront:formView) 
        }
        else {
            self.performSegue(withIdentifier: "homeSegue", sender: nil)
        }
    }
    
}

extension LoginViewController : updateUserDetailsDelegate {
    func updateStatus(success: Bool) {
        self.performSegue(withIdentifier: "homeSegue", sender: nil)
    }
}
