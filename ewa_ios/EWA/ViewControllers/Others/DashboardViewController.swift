//
//  DashboardViewController.swift
//  EWA
//
//  Created by NFC Solutions on 27/12/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit
import SideMenuController
import SwiftyJSON
import SDWebImage
import CropViewController
import ANLoader
import WebKit

class DashboardViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CropViewControllerDelegate {
    
    var picUploadData:JSON = JSON.null
    var dashBoardObject:JSON = JSON.null
    var headerTitles = [String]()
    var menuTitles = [[String]]()
    var menuImages = [[String]]()
    
    @IBOutlet var headerImageView: UIImageView!
    
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    var menuObject: JSON = JSON.null
    
    @IBOutlet weak var formPopUpOkButton: UIButton!
    @IBOutlet weak var pressToSignView: UIView!
    @IBOutlet weak var formNameLabel: UILabel!
    @IBOutlet var formPopUpView: UIView!
    @IBOutlet weak var formWebView: WKWebView!
    
    @IBOutlet weak var employeeNameTextField: UITextField!
    
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet var signitureView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    var signedObjectResponse:JSON = JSON.null
    var blurEffect = UIBlurEffect()
    var blurEffectView = UIVisualEffectView()
    var checked = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
if #available(iOS 11.0, *) {
            
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        // self.title = "Dashboard"
        self.changeNavigationTitle("Dashboard")
        
        print("*** VIV the screen name is \(className)***")
        
        // for demo candidates
        headerTitles = Constants.menuHeaders
        print("*** VIV the headerTitles is \(headerTitles)***")
        headerTitles = headerTitles.filter{$0 != "Demo Candidates"}
        headerTitles = headerTitles.filter{$0 != "Notifications"}
        print("*** VIV the headerTitles is now is \(headerTitles)***")
        
        //viv adding e-check in
        
//        headerTitles += ["E-Check In"]
        
        //viv end
        
        menuTitles = Constants.menuSections
        print("*** VIV the menuTitles is \(menuTitles)***")
        menuTitles = Constants.menuSections.filter{$0.count > 0}
        //
        menuImages = Constants.menuSectionLogos
        menuImages = Constants.menuSectionLogos.filter{$0.count > 0}
        
        headerImageView.sd_setImage(with: URL(string: UserDefaults.standard.object(forKey:"logo")as! String), placeholderImage: UIImage(named: "placeholder.png"))
        
        
        //Checking if global alert and form available
        if Constants.globalPopupStatus == 1 { // Show Alert
            //check status and hit API 1,2,4
            //Here Again check for the alert type
            if  Constants.globalAlertStatus == 1 || Constants.globalAlertStatus == 2 || Constants.globalAlertStatus == 4{
                self.loadAlertPopupWithObject(Constants.globalAlertStatus, messageText: Constants.globalPopupMessage, popKeyToSend: Constants.globalPopupKey, apiCallrequired: true)
            }
            if Constants.globalAlertStatus == 3  {
                self.loadAlertPopupWithObject(Constants.globalAlertStatus, messageText: Constants.globalPopupMessage, popKeyToSend: Constants.globalPopupKey, apiCallrequired: false)
            }
        }
        else if Constants.globalPopupStatus == 2 { //Show Form
            self.pressToSignView.isHidden = true
            if Constants.ShowStandAloneFromDashBoard {
                
            }
            else {
                self.showFormToUser()
                return
            }
        }
        
        //Checking SCR
        if Constants.isScrSigned == 0
        {
            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "scrView") as! SCRViewController
            navigationController?.pushViewController(VC1, animated:true)
        }
        else if Constants.isScrSigned == 2
        {
            print("showing alert when isScrSigned = 2")
            ServerService.ShowAlertMessage(ErrorMessage:Constants.isScrMessage, title:"", view:self)
        }
        else if Constants.globalMessageKey == 0 && Constants.globalMessgae.count != 0 //viv newly added to remove empty popup
        {
            print("showing alert when globalMessageKey = 0")
            ServerService.ShowAlertMessage(ErrorMessage:Constants.globalMessgae, title:"", view:self)
        }
        
        self.checkNotificationAccess()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushToStandAlone(notification:)), name: Notification.Name("StandAlone"), object: nil)
        
        print("*** VIV the constant.dash is \(Constants.dashObject)***")
        
        if let ipAddress = getIPv4Address() {
            print("IP Address: \(ipAddress)")
        } else {
            print("Unable to retrieve IP address")
        }
        
    }
    
    //this is called updateImage notififcation gets called
    @objc func pushToStandAlone(notification: Notification)
    {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let privacyViewController = mainStoryboard.instantiateViewController(withIdentifier: "pVC") as! PrivacyPolicyViewController
        privacyViewController.link = (notification.userInfo?["LinkUrl"] as? String)!
        privacyViewController.headerText = (notification.userInfo?["LinkText"] as? String)!
        privacyViewController.isPush = false
        privacyViewController.modalPresentationStyle = .fullScreen
        
        let navigationController = UINavigationController(rootViewController: privacyViewController)
        if #available(iOS 13.0, *) {
            navigationController.modalPresentationStyle = .fullScreen;
        } else {
        }
        UIApplication.getTopMostViewController()?.present(navigationController, animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateNavigationBarColor()
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]

    }
    
    func changeNavigationTitle(_ titleStr: String) {
        let tlabel = UILabel()
        tlabel.text = titleStr
        tlabel.textColor = UIColor.white
        tlabel.font = UIFont.systemFont(ofSize:17)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.textAlignment = .center
        tlabel.numberOfLines = 0
        tlabel.minimumScaleFactor = 0.5
        self.navigationItem.titleView = tlabel
    }
    
    //MARK: - Get IP Address
    
    func getIPv4Address() -> String? {
        
        /*
        
        var address: String?

        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                let interface = ptr!.pointee
                let addrFamily = interface.ifa_addr.pointee.sa_family

                if addrFamily == UInt8(AF_INET) { // IPv4
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                        address = String(cString: hostname)
                        break
                    }
                }
            }
            freeifaddrs(ifaddr)
        }

        return address
         
         */
        
        var address: String?

        // Get list of all interfaces on the local machine
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        defer { freeifaddrs(ifaddr) }

        // Loop through linked list of interfaces
        for ifptr in sequence(first: ifaddr, next: { $0?.pointee.ifa_next }) {
            let interface = ifptr?.pointee

            // Check for IPv4 or IPv6 interface
            let addrFamily = interface?.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                // Convert interface address to a human-readable string
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                if (getnameinfo(interface?.ifa_addr, socklen_t(interface?.ifa_addr.pointee.sa_len ?? 126),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                    address = String(cString: hostname)
                }
            }
        }

        return address
    }
    
    //MARK:- ImagePickerController
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
            UserDefaults.standard.set(picUploadData["ImageFile"].stringValue,forKey: "ImageFile")
            NotificationCenter.default.post(name: Notification.Name("updateImage"), object: nil)
            ServerService.ShowAlertMessage(ErrorMessage:Constants.imageMessage, title:"", view:self)
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage:picUploadData["Message"].stringValue, title:"", view:self)
        }
    }
    
    
    @IBAction func handleNavgationBarButtonTap(_ sender: UIBarButtonItem, event: UIEvent)
    
    {
        Constants.showUp(event:event,viewController:self)
        
    }
    
    //MARK:- Check Permissions Access
    func checkNotificationAccess(){
        
        print("checking notification access")
        
        //LocPermission
        if UserDefaults.standard.contains(key:"LocPermission")
        {
            if UserDefaults.standard.object(forKey:"LocPermission") as! Bool {
                
            }
            else {
                print("checking location permission from 314")
                if checkLocationPermission(){
                    self.showAlertForAppSettingLocation()
                }
                else {
                    
                    self.showAlertForMainLocation()
                    
                }
            }
        }
        else {
            print("checking location permission from 326")
            if checkLocationPermission(){
                self.showAlertForAppSettingLocation()
            }
            else {
                
                self.showAlertForMainLocation()
                
            }
        }
        
        
        // Notification Permission
        (UIApplication.shared.delegate as?AppDelegate)?.checkPushNotification(checkNotificationStatus: { (access) in
            if access {
                if Constants.PushNotificationPopup == 1 {
                    self.showAlertForAppSettingNotifications()
                }
            }
            else {
                if UserDefaults.standard.bool(forKey: "GlobalNotification") ==  false {
                    self.showAlertForMainNotificationAccess()
                }
            }
        })
    }
    
    //MARK:- Location&Notifications Alerts
    func showAlertForMainLocation(){
        let alertController = UIAlertController(title: "", message: Constants.locationAllowMessage, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("Cancel Pressed")
            
        }
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            if let bundleId = Bundle.main.bundleIdentifier,
               let url = URL(string: "\(UIApplicationOpenSettingsURLString)&path=LOCATION/\(bundleId)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        // Add the actions
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        // Present the controller
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
            
            UserDefaults.standard.set(true, forKey: "LocPermission")
        }
    }
    
    func showAlertForAppSettingLocation()
    {
        if UserDefaults.standard.contains(key:"ShareLocation")
        {
            if UserDefaults.standard.object(forKey:"ShareLocation") as! Bool {
                
            }
            else {
                
                
                let alert = UIAlertController(title:"", message:  Constants.locationAllowMessage, preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "Ok",
                                       style: .default) { (action: UIAlertAction!) -> Void in
                    
                    //Redirect to TGC Mobile App Settings page
                    let identifier = "Settings"
                    if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateVC(withIdentifier: identifier) {
                        let navi = BaseNaviViewController(rootViewController:viewController)
                        navi.navigationBar.tintColor = .white
                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                        self.navigationController?.pushViewController(viewController, animated: true)
                        //sideMenuController?.embed(centerViewController:navi, cacheIdentifier:identifier)
                    }
                    else {
                        
                        // ServerService.ShowAlertMessage(ErrorMessage: "No controller Available", title: "Oops . . . !", view: self)
                    }
                }
                let cancel = UIAlertAction(title: "Cancel",
                                           style: .default) { (action: UIAlertAction!) -> Void in
                    
                    
                }
                
                alert.addAction(cancel)
                alert.addAction(ok)
                DispatchQueue.main.async {
                    self.present(alert, animated:true, completion:nil)
                    UserDefaults.standard.set(true, forKey: "LocPermission")
                }
                
            }
        }
    }
    
    func showAlertForAppSettingNotifications()
    {
        let alert = UIAlertController(title:"", message: Constants.PushNotificationMessage, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "Ok",
                               style: .default) { (action: UIAlertAction!) -> Void in
            
            //Redirect to TGC Mobile App Settings page
            let identifier = "Settings"
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateVC(withIdentifier: identifier) {
                let navi = BaseNaviViewController(rootViewController:viewController)
                navi.navigationBar.tintColor = .white
                navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                self.navigationController?.pushViewController(viewController, animated: true)
                //sideMenuController?.embed(centerViewController:navi, cacheIdentifier:identifier)
            }
            else {
                
                // ServerService.ShowAlertMessage(ErrorMessage: "No controller Available", title: "Oops . . . !", view: self)
            }
        }
        let cancel = UIAlertAction(title: "Cancel",
                                   style: .default) { (action: UIAlertAction!) -> Void in
            
            
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated:true, completion:nil)
            
        }
    }
    
    func showAlertForMainNotificationAccess()
    {
        
        let alert = UIAlertController(title:"", message: Constants.PushNotificationMessage, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "Ok",
                               style: .default) { (action: UIAlertAction!) -> Void in
            
            if let bundleId = Bundle.main.bundleIdentifier,
               let url = URL(string: "\(UIApplicationOpenSettingsURLString)&path=LOCATION/\(bundleId)") {
                DispatchQueue.main.async {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            
        }
        let cancel = UIAlertAction(title: "Cancel",
                                   style: .default) { (action: UIAlertAction!) -> Void in
            
            
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        DispatchQueue.main.async {
            UserDefaults.standard.set(true, forKey: "GlobalNotification")
            self.present(alert, animated:true, completion:nil)
        }
        
    }
    
    //MARK:- FormViewActions
    
    func showFormToUser(){
        
        Constants.LinkUrl = Constants.globalPopupFormLink.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:"")
        Constants.LinkText = Constants.globalPopupFormName
        if Constants.globalLinkType == "1" {
            Constants.iSFormOkRequired = false
        }
        else {
            Constants.iSFormOkRequired = true
        }
        if !Constants.ShowStandAlone {
            self.pushToStandAloneFromDashBoard()
        }
    }
    func showPopUp() {
        checked = false
        employeeNameTextField.text = ""
        errorLabel.text = ""
        checkBoxButton.setImage(UIImage(named: "unchecked.png"), for:.normal)
        blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        signitureView.frame = CGRect(x:10, y:100, width:self.view.bounds.width-20, height:280)
        blurEffectView.contentView.addSubview(signitureView)
        view.addSubview(blurEffectView)
    }
    
    @IBAction func pressToSignClicked(_ sender: UIButton) {
        self.showPopUp()
    }
    
    @IBAction func okClicked(_ sender: UIButton) {
        //  self.title = "Dashboard"
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView: self.view)
            let paramsMenu:[String:Any] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,
                                           "PopupKey": Constants.globalPopupKey]
            print(paramsMenu)
            ServerService.submitglobalForm(self, params: paramsMenu, method:"POST", accessToken:Constants.Token, acces:true, callBack: getFormOkResponse(response:))
            //        self.changeNavigationTitle("Dashboard")
            //        formPopUpView.removeFromSuperview()
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
    }
    
    //MARK:- OkCLickResponse
    func getFormOkResponse(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        var formRespObject: JSON = JSON.null
        formRespObject = response as! JSON
        print(formRespObject)
        
        if formRespObject["MessageStatus"].intValue == 1 {
            self.changeNavigationTitle("Dashboard")
            formPopUpView.removeFromSuperview()
            self.getMenuLinks()
        }
        else {
            ServerService.ShowAlertMessage(ErrorMessage:formRespObject["Message"].stringValue, title: "", view:self)
        }
    }
    
    
    
    
    @IBAction func checkBoxClicked(_ sender: UIButton) {
        
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
    
    
    @IBAction func closeClicked(_ sender: UIButton) {
        blurEffectView.removeFromSuperview()
    }
    
    @IBAction func submitSignitureClicked(_ sender: UIButton)
    
    
    {
        //This API is not in use 
        
        if ConnectionCheck.isConnectedToNetwork()
        {
            //if object["FormName"].stringValue == "HandBook"
            if "123" == "123"
            {
                if checked
                {
                    if employeeNameTextField.text!.count>0
                    {
                        self.view.endEditing(true)
                        /*
                         ServerService.showActivityIndicatory(uiView:self.view)
                         let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextField.text!,"AgreementId":object["AgreementId"].stringValue,"FormName":object["FormName"].stringValue]
                         print(params)
                         ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                         */
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
        if signedObjectResponse["Status"].stringValue == "Success"
        {
            
            ANLoader.hide()
            blurEffectView.removeFromSuperview()
            
            
        }
        else
        {
            errorLabel.text = signedObjectResponse["Message"].stringValue
            //ServerService.ShowAlertMessage(ErrorMessage:signedObjectResponse["Message"].stringValue, title: "", view:self)
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
        
        window.addSubview(formView)
        window.bringSubview(toFront:formView)
    }
}

extension DashboardViewController: popAlertDelegate {
    func formStatus(success: Bool) {
        print("success")
        self.getMenuLinks()
    }
}
extension DashboardViewController:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        var identifier = String()
        identifier = menuTitles[indexPath.section][indexPath.row]
        Constants.Menu = identifier
        
        let mon =  Constants.dashObject["List"].arrayValue.filter { $0["LinkText"].stringValue == identifier && $0["ParentMenuId"].intValue > 0} as [JSON]
        
        if mon.count > 0 && mon[0]["LinkType"].intValue == 1{
            Constants.LinkUrl = mon[0]["LinkUrl"].stringValue
            Constants.LinkText = mon[0]["LinkText"].stringValue
            Constants.iSFormOkRequired = false
            print("going from here")
            self.pushToStandAlone()
        }
        else {
            if identifier == "eTimeClock"
            {
                print("clicked etimeclock from dashboard")
                identifier = "eTimeClock History"
                UserDefaults.standard.set("0", forKey: "eTimeClock")
            }
            
            else if  identifier == "eTimeClock History" {
                print("clicked etimeclock history from dashboard")
                identifier = "eTimeClock History"
                UserDefaults.standard.set("1", forKey: "eTimeClock")
            }
            else if identifier == "Manage Text Message" {
                let VC = ManageTextMessages(nibName: "ManageTextMessages", bundle: nil)
                let navi = BaseNaviViewController(rootViewController:VC)
                navi.navigationBar.tintColor = .white
                navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                sideMenuController?.embed(centerViewController:navi, cacheIdentifier:identifier)
            }
            else if identifier == Constants.A1Form {
                
                print("*********VIVEK Clicked A1 Form Here**********")
                
                //viv start
                
                if ConnectionCheck.isConnectedToNetwork()
                {
                    ServerService.showActivityIndicatory(uiView:self.view)
                    
                    let params =
                        ["candId":UserDefaults.standard.object(forKey: "cID") as! String]  as [String : Any]
                    print(params)
                    ServerService.getA1FormData(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: getA1FormDataObject(response:))
                    
                }
                else
                {
                    ServerService.hideProgressView()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                    
                }
                
                func getA1FormDataObject(response:AnyObject)->() {

                    ServerService.hideProgressView()
                    let A1FormObject = response as! JSON
                    print(A1FormObject)
                    
                    if A1FormObject["LinkURL"] == nil {
                        print("***VIV the link count id \(A1FormObject["LinkURL"])")
                        print("***VIV the link count is \(String(describing: A1FormObject["LinkURL"].string?.count)) ***")
                    }
                    
                    else {
                        print("*** VIV A1 else clause Entered here***")
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let privacyViewController = mainStoryboard.instantiateViewController(withIdentifier: "pVC") as! PrivacyPolicyViewController
                        //                    privacyViewController.link = "https://apps.tempositions.com/EWAAPITest/api/Forms/A1Series"
                        privacyViewController.link = A1FormObject["LinkURL"].string ?? ""
                        privacyViewController.headerText = A1FormObject["LinkName"].string ?? ""
                        Constants.iSFormOkRequired = false
                        privacyViewController.isPush = true

                        let navi = BaseNaviViewController(rootViewController:privacyViewController)
                        navi.navigationBar.tintColor = .white
                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"A1FormController")
                    }
                    
                }
                
                
                //viv end
                
                
                

                
//                let VC = A1FormController(nibName: "A1FormController", bundle: nil)
//                let object = JSON(["FormName":identifier])
//                VC.object = object
//                VC.fromSideMenu = true
//                let navi = BaseNaviViewController(rootViewController:VC)
//                navi.navigationBar.tintColor = .white
//                navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
//                sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"A1FormController")
            }
            else if identifier == Constants.A2Form {
                
                print("*********VIVEK Clicked A2 Form Here**********")
                
                //viv start
                
                if ConnectionCheck.isConnectedToNetwork()
                {
                    ServerService.showActivityIndicatory(uiView:self.view)
                    
                    let params =
                        ["candId":UserDefaults.standard.object(forKey: "cID") as! String]  as [String : Any]
                    print(params)
                    ServerService.getA2FormData(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: getA2FormDataObject(response:))
                    
                }
                else
                {
                    ServerService.hideProgressView()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                    
                }
                
                func getA2FormDataObject(response:AnyObject)->() {

                    ServerService.hideProgressView()
                    let A2FormObject = response as! JSON
                    print(A2FormObject)
                    
                    if A2FormObject["LinkURL"] == nil {
                        print("***VIV the link count id \(A2FormObject["LinkURL"])")
                        print("***VIV the link count is \(String(describing: A2FormObject["LinkURL"].string?.count)) ***")
                    }
                    
                    else {
                        print("*** VIV A2 else clause Entered here***")
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let privacyViewController = mainStoryboard.instantiateViewController(withIdentifier: "pVC") as! PrivacyPolicyViewController
    //                    privacyViewController.link = "https://apps.tempositions.com/EWAAPITest/api/Forms/A1Series"
                        privacyViewController.link = A2FormObject["LinkURL"].string ?? ""
                        privacyViewController.headerText = A2FormObject["LinkName"].string ?? ""
                        Constants.iSFormOkRequired = false
                        privacyViewController.isPush = true
                        
                        let navi = BaseNaviViewController(rootViewController:privacyViewController)
                                        navi.navigationBar.tintColor = .white
                                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"A2FormController")
                        
                    }
                    
                 
                    
                }
                
                
                //viv end
                
//                let VC = A2FormController(nibName: "A2FormController", bundle: nil)
//                let object = JSON(["FormName":identifier])
//                VC.object = object
//                VC.fromSideMenu = true
//                let navi = BaseNaviViewController(rootViewController:VC)
//                navi.navigationBar.tintColor = .white
//                navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
//                sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"A2FormController")
                
            }
            
            else if identifier == Constants.A3Form {
                
                print("*********A3 Form clicked VIVEK*********/n")
                
                //viv start
                
                if ConnectionCheck.isConnectedToNetwork()
                {
                    ServerService.showActivityIndicatory(uiView:self.view)
                    
                    let params =
                        ["candId":UserDefaults.standard.object(forKey: "cID") as! String]  as [String : Any]
                    print(params)
                    ServerService.getA3FormData(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: getA3FormDataObject(response:))
                    
                }
                else
                {
                    ServerService.hideProgressView()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                    
                }
                
                func getA3FormDataObject(response:AnyObject)->() {

                    ServerService.hideProgressView()
                    var A3FormObject = response as! JSON
                    print(A3FormObject)
                    
                    if A3FormObject["LinkURL"] == nil {
                        print("***VIV the link count id \(A3FormObject["LinkURL"])")
                        print("***VIV the link count is \(String(describing: A3FormObject["LinkURL"].string?.count)) ***")
                    }
                    
                    else {
                        
                        print("*** VIV A3 else clause Entered here***")
                        
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let privacyViewController = mainStoryboard.instantiateViewController(withIdentifier: "pVC") as! PrivacyPolicyViewController
                        //                    privacyViewController.link = "https://apps.tempositions.com/EWAAPITest/api/Forms/A1Series"
                        privacyViewController.link = A3FormObject["LinkURL"].string ?? ""
                        privacyViewController.headerText = A3FormObject["LinkName"].string ?? ""
                        Constants.iSFormOkRequired = false
                        privacyViewController.isPush = true

                        let navi = BaseNaviViewController(rootViewController:privacyViewController)
                        navi.navigationBar.tintColor = .white
                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"A1FormController")
                        
                    }
                    
                        
                    
                }
                
                
                //viv end

            }
            
            else if identifier == Constants.PoliciesAndProcedures {
                
                print("*********PoliciesAndProcedures clicked VIVEK*********")
                
                //viv start
                
                if ConnectionCheck.isConnectedToNetwork()
                {
                    ServerService.showActivityIndicatory(uiView:self.view)
                    
                    let params =
                        ["candId":UserDefaults.standard.object(forKey: "cID") as! String]  as [String : Any]
                    print(params)
                    ServerService.getFormsPoliciesAndProcedures(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: getFormsPoliciesAndProceduresObject(response:))
                    
                }
                else
                {
                    ServerService.hideProgressView()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                    
                }
                
                func getFormsPoliciesAndProceduresObject(response:AnyObject)->() {

                    ServerService.hideProgressView()
                    var FormsPoliciesAndProceduresObject = response as! JSON
                    print(FormsPoliciesAndProceduresObject)
                    
                    if FormsPoliciesAndProceduresObject["LinkURL"] == nil {
                        print("***VIV the link count id \(FormsPoliciesAndProceduresObject["LinkURL"])")
                        print("***VIV the link count is \(String(describing: FormsPoliciesAndProceduresObject["LinkURL"].string?.count)) ***")
                    }
                    
                    else {
                        
                        print("*** VIV FormsPoliciesAndProceduresObject else clause Entered here***")
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let privacyViewController = mainStoryboard.instantiateViewController(withIdentifier: "pVC") as! PrivacyPolicyViewController
    //                    privacyViewController.link = "https://apps.tempositions.com/EWAAPITest/api/Forms/A1Series"
                        privacyViewController.link = FormsPoliciesAndProceduresObject["LinkURL"].string ?? ""
                        privacyViewController.headerText = FormsPoliciesAndProceduresObject["LinkName"].string ?? ""
                        Constants.iSFormOkRequired = false
                        privacyViewController.isPush = true
                        
                        let navi = BaseNaviViewController(rootViewController:privacyViewController)
                                        navi.navigationBar.tintColor = .white
                                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"PoliciesAndProcedures")
                    }
  
                }
                
                
                //viv end

            }
            
            else if identifier == Constants.DisclosureConsentForm {
                
                print("*********Disclosure Form clicked VIVEK*********")
                
                //viv start
                
                if ConnectionCheck.isConnectedToNetwork()
                {
                    ServerService.showActivityIndicatory(uiView:self.view)
                    
                    let params =
                        ["candId":UserDefaults.standard.object(forKey: "cID") as! String]  as [String : Any]
                    print(params)
                    ServerService.getFormsDisclosureContent(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: getFormsDisclosureContentObject(response:))
                    
                }
                else
                {
                    ServerService.hideProgressView()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                    
                }
                
                func getFormsDisclosureContentObject(response:AnyObject)->() {

                    ServerService.hideProgressView()
                    var FormsDisclosureContentObject = response as! JSON
                    print(FormsDisclosureContentObject)
                    
                    if FormsDisclosureContentObject["LinkURL"] == nil {
                        print("***VIV the link count id \(FormsDisclosureContentObject["LinkURL"])")
                        print("***VIV the link count is \(String(describing: FormsDisclosureContentObject["LinkURL"].string?.count)) ***")
                    }
                    
                    else {
                        
                        print("*** VIV FormsDisclosureContentObject else clause Entered here***")
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let privacyViewController = mainStoryboard.instantiateViewController(withIdentifier: "pVC") as! PrivacyPolicyViewController
    //                    privacyViewController.link = "https://apps.tempositions.com/EWAAPITest/api/Forms/A1Series"
                        privacyViewController.link = FormsDisclosureContentObject["LinkURL"].string ?? ""
                        privacyViewController.headerText = FormsDisclosureContentObject["LinkName"].string ?? ""
                        Constants.iSFormOkRequired = false
                        privacyViewController.isPush = true
                        
                        let navi = BaseNaviViewController(rootViewController:privacyViewController)
                                        navi.navigationBar.tintColor = .white
                                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"DisclosureForm")
                        
                    }

                }
                
                
                //viv end

            }
            
            else if identifier == Constants.OCCConfidentiality {
                
                print("*********OCCConfidentiality clicked VIVEK*********")
                
                //viv start
                
                if ConnectionCheck.isConnectedToNetwork()
                {
                    ServerService.showActivityIndicatory(uiView:self.view)
                    
                    let params =
                        ["candId":UserDefaults.standard.object(forKey: "cID") as! String]  as [String : Any]
                    print(params)
                    ServerService.getFormsOCCConfidentiality(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: getFormsOCCConfidentialityObject(response:))
                    
                }
                else
                {
                    ServerService.hideProgressView()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                    
                }
                
                func getFormsOCCConfidentialityObject(response:AnyObject)->() {

                    ServerService.hideProgressView()
                    var FormsOCCConfidentialityObject = response as! JSON
                    print(FormsOCCConfidentialityObject)
                    
                    if FormsOCCConfidentialityObject["LinkURL"] == nil {
                        print("***VIV the link count id \(FormsOCCConfidentialityObject["LinkURL"])")
                        print("***VIV the link count is \(String(describing: FormsOCCConfidentialityObject["LinkURL"].string?.count)) ***")
                    }
                    
                    else {
                        
                        print("*** VIV FormsOCCConfidentialityObject else clause Entered here***")
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let privacyViewController = mainStoryboard.instantiateViewController(withIdentifier: "pVC") as! PrivacyPolicyViewController
    //                    privacyViewController.link = "https://apps.tempositions.com/EWAAPITest/api/Forms/A1Series"
                        privacyViewController.link = FormsOCCConfidentialityObject["LinkURL"].string ?? ""
                        privacyViewController.headerText = FormsOCCConfidentialityObject["LinkName"].string ?? ""
                        Constants.iSFormOkRequired = false
                        privacyViewController.isPush = true
                        
                        let navi = BaseNaviViewController(rootViewController:privacyViewController)
                                        navi.navigationBar.tintColor = .white
                                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"OCCConfidentialityForm")
                    }
                }
                
                
                //viv end

            }
            
            else if identifier == Constants.SCRName {
                //viv stars here
                
                print("***VIVEK SCRConsentInfoController Clicked From Dashboard***")
                
                if ConnectionCheck.isConnectedToNetwork()
                {
                    ServerService.showActivityIndicatory(uiView:self.view)
                    
                    let params =
                        ["CandId" : UserDefaults.standard.object(forKey: "cID") as! String]  as [String : Any]
                    print(params)
                    ServerService.GetSCRForm(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: getSCRDataObject(response:))
                }
                else
                {
                    ServerService.hideProgressView()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                    
                }
                
                // response from the server
                func getSCRDataObject(response:AnyObject)->()
                {
                    ServerService.hideProgressView()
                    var SCRInfoObject = response as! JSON
                    print("****** SCR Info Data from Dashboard is ************\n",SCRInfoObject)
                    
                    if SCRInfoObject["LinkURL"] == nil {
                        print("***VIV the link count id \(SCRInfoObject["LinkURL"])")
                        print("***VIV the link count is \(String(describing: SCRInfoObject["LinkURL"].string?.count)) ***")
                    }
                    
                    else {
                        
                        print("*** VIV SCRInfoObject of SCRName else clause Entered here***")
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let privacyViewController = mainStoryboard.instantiateViewController(withIdentifier: "pVC") as! PrivacyPolicyViewController
                        privacyViewController.link = SCRInfoObject["LinkURL"].string ?? ""
                        privacyViewController.headerText = SCRInfoObject["ScrFormName"].string ?? ""
                        Constants.iSFormOkRequired = false
                        privacyViewController.isPush = true
                        
                        let navi = BaseNaviViewController(rootViewController:privacyViewController)
                                        navi.navigationBar.tintColor = .white
                                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"SCR Consent")
                        
                    }
                }
                
                //viv ends
                
                
//                let VC = SCRConsentInfoController(nibName: "SCRConsentInfoController", bundle: nil)
//                let object = JSON(["FormName":identifier])
//                VC.object = object
//                VC.fromSideMenu = true
//                let navi = BaseNaviViewController(rootViewController:VC)
//                navi.navigationBar.tintColor = .white
//                navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
//                sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"SCRConsentInfoController")
                
            }
            
            else if identifier == Constants.SCRConsent {
                
                if ConnectionCheck.isConnectedToNetwork()
                {
                    ServerService.showActivityIndicatory(uiView:self.view)
                    
                    print("***VIV SCRConsent Clicked From Dashboard***")
                    
                    let params =
                    ["CandId" : UserDefaults.standard.object(forKey: "cID") as! String]  as [String : Any]
                    print(params)
                    ServerService.GetSCRConsentForm(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: getSCRDataObject(response:))
                }
                else
                {
                    ServerService.hideProgressView()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                    
                }
                
                
                // response from the server
                func getSCRDataObject(response:AnyObject)->()
                {
                    
                    ServerService.hideProgressView()
                    var SCRInfoObject = response as! JSON
                    print("****** SCR Info Data from Dashboard is ************\n",SCRInfoObject)
                    
                    if SCRInfoObject["LinkURL"] == nil {
                        print("***VIV the link count id \(SCRInfoObject["LinkURL"])")
                        print("***VIV the link count is \(String(describing: SCRInfoObject["LinkURL"].string?.count)) ***")
                    }
                    
                    else {
                        print("*** VIV SCRInfoObject SCRConsent else clause Entered here***")
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let privacyViewController = mainStoryboard.instantiateViewController(withIdentifier: "pVC") as! PrivacyPolicyViewController
                        privacyViewController.link = SCRInfoObject["LinkURL"].string ?? ""
                        privacyViewController.headerText = SCRInfoObject["ScrFormName"].string ?? ""
                        Constants.iSFormOkRequired = false
                        privacyViewController.isPush = true
                        
                        let navi = BaseNaviViewController(rootViewController:privacyViewController)
                        navi.navigationBar.tintColor = .white
                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"SCR Consent Form")
                        
                    } 
                }
            }
        
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateVC(withIdentifier: identifier) {
                let navi = BaseNaviViewController(rootViewController:viewController)
                navi.navigationBar.tintColor = .white
                navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                sideMenuController?.embed(centerViewController:navi, cacheIdentifier:identifier)
                
                
            }
            else {
                
                // ServerService.ShowAlertMessage(ErrorMessage: "No controller Available", title: "Oops . . . !", view: self)
            }
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0 //40
    }
    /*
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     let headerView = UIView()
     headerView.frame = CGRect(x:0, y: 0, width: self.view.bounds.size.width, height:40)
     headerView.backgroundColor = .clear
     let headerLabel = UILabel()
     headerLabel.frame = CGRect(x:10, y: 0, width: self.view.bounds.size.width, height:40)
     headerLabel.backgroundColor = .clear
     headerLabel.text = headerTitles[section]
     headerLabel.textAlignment = .left
     headerView.addSubview(headerLabel)
     return headerView
     }
     */
    
}
extension DashboardViewController:UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return headerTitles.count
        return menuTitles.count // viv hided above and added this
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return menuTitles[section].count
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"dCell") as! DasboardTableViewCell
        cell.selectionStyle = .none
        
        
        if  menuTitles[indexPath.section][indexPath.row] == "OnCall Counsel Timeslips"
        {
            cell.nameLabel?.text = "Enter TimeSlips"
            cell.iconImageView.sd_setImage(with:URL(string: menuImages[indexPath.section][indexPath.row].replace(target:"\\", withString:"//")), placeholderImage: UIImage(named:"placeholder.png"))
        }
        else
        {
            cell.nameLabel?.text = menuTitles[indexPath.section][indexPath.row]
            cell.iconImageView.sd_setImage(with:URL(string: menuImages[indexPath.section][indexPath.row].replace(target:"\\", withString:"//")), placeholderImage: UIImage(named:"placeholder.png"))
        }
        
        return cell
    }
}

extension UIViewController {
    @objc func getMenuLinks() {
        let paramsMenu:[String:Any] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"emptype":UserDefaults.standard.object(forKey:"EmployeeType") as! Int]
        print("MENULINKS_PARAMS \(paramsMenu)")
        
        ServerService.getAccountEWAMenuLinks(self, params: paramsMenu, method:"POST", accessToken:Constants.Token, acces:true, callBack: getMenuresponseFor(response:))
    }
    
    //aftergettingResponseFrom the server
    func getMenuresponseFor(response:AnyObject)->()
    {
        var menuObject: JSON = JSON.null
        menuObject = response as! JSON
        print("***VIV the menu objects is here \(menuObject)***")
        if menuObject.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if menuObject["Message"].stringValue == "Authorization has been denied for this request."
        {
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ewaLogin") as! LoginViewController
            UIApplication.shared.keyWindow?.rootViewController = viewController
        }
        else if menuObject.count == 0
        {
            ServerService.ShowAlertMessage(ErrorMessage:"", title:"An error has occured", view:self)
        }
        
        else
        {
            
            Constants.dashObject = JSON.null
            if (menuObject["IsPopupRequired"] != nil){
                Constants.isScrSigned = menuObject["IsPopupRequired"].intValue
            }
            else{
                Constants.isScrSigned = -1
            }
            Constants.isScrMessage =  menuObject["SCRMessage"].stringValue
            
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
            
            Constants.locationAllowMessage = menuObject["LocationMessage"].stringValue
            Constants.dashObject = menuObject
        }
    }
}

extension UIViewController {
    
    func pushToStandAloneFromDashBoard(){
        Constants.ShowStandAloneFromDashBoard = true
        pushToStandAlone()
    }
    func pushToStandAlone() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let privacyViewController = mainStoryboard.instantiateViewController(withIdentifier: "pVC") as! PrivacyPolicyViewController
        privacyViewController.link = Constants.LinkUrl
        privacyViewController.headerText = Constants.LinkText
        privacyViewController.isPush = false
        privacyViewController.modalPresentationStyle = .fullScreen
        
        let navigationController = UINavigationController(rootViewController: privacyViewController)
        if #available(iOS 13.0, *) {
            navigationController.modalPresentationStyle = .fullScreen;
        } else {
        }
        self.present(navigationController, animated: false, completion: nil)
    }
}
