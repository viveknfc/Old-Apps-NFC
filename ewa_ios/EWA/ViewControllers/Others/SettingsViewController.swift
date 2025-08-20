//
//  SettingsViewController.swift
//  EWA
//
//  Created by NFC India on 18/02/19.
//  Copyright © 2019 NFC. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import SwiftyJSON

class SettingsViewController:BaseViewController  {
    
    //Outlet's from storyboard
    @IBOutlet weak var topView: UIView!
    @IBOutlet var proileImage: UIImageView!
    @IBOutlet weak var nameTextField: JVFloatLabeledTextField!
    @IBOutlet weak var emailTextField: JVFloatLabeledTextField!
    @IBOutlet weak var loactionToogle: UISwitch!
    
    @IBOutlet weak var notificationWidth: NSLayoutConstraint!
    @IBOutlet weak var locationWidth: NSLayoutConstraint!
    @IBOutlet weak var notificationToogle: UISwitch!
    var enablingNotifications = Bool()
    var enablingLocation = Bool()
    var isIgnorePush =  Bool()
    //variableDeclataions
    var cLResponse:JSON = JSON.null // cL=changeLocation
    
    //MARK:- View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        topView.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        
        if ((UserDefaults.standard.object(forKey:"ImageFile") as! String)).count>0
        {
            let decodedData = Data(base64Encoded:UserDefaults.standard.object(forKey:"ImageFile") as! String, options: .ignoreUnknownCharacters)
            let decodedimage = UIImage(data:decodedData!)
            print(decodedimage!)
            proileImage.image = decodedimage
        }
        
        configure_image()
        self.title = "Settings"
        
        nameTextField.text = UserDefaults.standard.object(forKey:"CandName") as? String
        emailTextField.text = UserDefaults.standard.object(forKey:"Email") as? String
        
        let widthv = self.view.frame.size.width
        
        if widthv <= 320 {
            locationWidth.constant = 160
            notificationWidth.constant = 160
        }
        else {
            locationWidth.constant = 255
            notificationWidth.constant = 255
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,selector: #selector(applicationDidBecomeActive),name: .UIApplicationDidBecomeActive, object: nil)
        // UIApplication.didBecomeActiveNotification for swift 4.2+
        
        self.checkLocationNotificationsStatus()
        
    }
    deinit {
        // UIApplication.didBecomeActiveNotification for swift 4.2+
        NotificationCenter.default.removeObserver(self,name: .UIApplicationDidBecomeActive, object: nil)
        
    }
    @objc func applicationDidBecomeActive() {
        self.checkLocationNotificationsStatus()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configure_TextFieldS(textField:nameTextField)
        configure_TextFieldS(textField:emailTextField)
    }
    
    //MARK:- Permissions Check
    func checkLocationNotificationsStatus(){
        if checkLocationPermission() { // Main Location Access is available
            if UserDefaults.standard.contains(key:"ShareLocation")
            {
                loactionToogle.isOn = UserDefaults.standard.object(forKey:"ShareLocation") as! Bool
            }
            else
            {
                loactionToogle.isOn = false
            }
        }
        else { // Main Location Access is not available
            loactionToogle.isOn = false
            UserDefaults.standard.removeObject(forKey: "ShareLocation")
            UserDefaults.standard.synchronize()
        }
        
        (UIApplication.shared.delegate as? AppDelegate)?.checkPushNotification(checkNotificationStatus: { (access) in
            if access {
                // Global Access is available Now check app access in API
                if Constants.PushNotificationStatus == 1 {
                    DispatchQueue.main.async {
                        self.notificationToogle.isOn = true
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.notificationToogle.isOn = false
                    }
                }
                
            }
            else {
                // Global Access is Not available Now check UserDefaults
                DispatchQueue.main.async {
                    if UserDefaults.standard.contains(key:"Notifications")
                    {
                        let valstatus = UserDefaults.standard.object(forKey:"Notifications") as! Bool
                        if valstatus == true {
                            self.enablingNotifications = false
                            self.notificationToogle.isOn = false
                            self.isIgnorePush = true
                            self.callAPIToUpdateNotificationSTatusWith(0)
                        }
                        else {
                            self.notificationToogle.isOn = false
                        }
                        
                    }
                    else {
                         self.enablingNotifications = false
                        self.notificationToogle.isOn = false
                        self.isIgnorePush = true
                        self.callAPIToUpdateNotificationSTatusWith(0)
                    }
                }
            }
        })
        
    }
    
    
    
    //MARK:- Configurations
    func configure_TextFieldS(textField:UITextField)
    {
        
        //constants which stores values which will be assigned to respective fields
        let width = CGFloat(1)
        let color = UIColor.darkGray.cgColor
        
        //creating layer for the border of the view
        let border = CALayer()
        border.frame = CGRect(x:0, y:textField.frame.height-1, width:textField.frame.width, height:width)
        border.borderColor = color
        border.borderWidth = width
        
        textField.layer.addSublayer(border)

    }
    
    
    func configure_image()
    {
        proileImage.layer.cornerRadius = 60
        proileImage.layer.masksToBounds = true
        
        proileImage.layer.borderWidth = 2
        proileImage.layer.borderColor = UIColor.white.cgColor
    }
    
    //MARK:- LocationSwitchChanged
    @IBAction func locationShareAction(_ sender: UISwitch)
    {
      
        var status = Int()
        print(sender.isOn)
        //using this value we will send/update the location to the server
        UserDefaults.standard.set(sender.isOn, forKey:"ShareLocation")
        if sender.isOn
        {
            status = 1
            enablingLocation = true
        }
        else
        {
            status = 0
            enablingLocation = false
        }
        
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:self.view)
            let params:[String:String] = ["DeviceId":"\(UIDevice.current.identifierForVendor!.uuidString.stripped)","IsActive":"\(status)"]
            print(params)
            ServerService.changeLocationStatus(self, params: params, method: "POST",accessToken:Constants.Token, acces:true,callBack:getLocationresponse(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
        
    }
    
    //aftergettingResponseFrom the server
    func getLocationresponse(response:AnyObject)->()
    {
        print(response)
        ServerService.hideProgressView()
        cLResponse = response as! JSON
        /*
         {
         "Message" : "Success",
         "MessageStatus" : 1
         }
         */
        if cLResponse["MessageStatus"].intValue == 1 {
            
            if checkLocationPermission() {
            }
            else {
                if self.enablingLocation == true {
                    if let bundleId = Bundle.main.bundleIdentifier,
                        let url = URL(string: "\(UIApplicationOpenSettingsURLString)&path=LOCATION/\(bundleId)") {
                        DispatchQueue.main.async {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
            
        }
        else {
            if self.enablingLocation == true {
                self.loactionToogle.isOn = false
                 UserDefaults.standard.set(false, forKey:"ShareLocation")
            }
            else {
                self.loactionToogle.isOn = true
                 UserDefaults.standard.set(true, forKey:"ShareLocation")
            }
        }        
    }
    
    //MARK:- NotificationsSwitchChanged
    @IBAction func notificationsSwitchChanged(_ sender: UISwitch) {
        var status = Int()
        if sender.isOn {
            status = 1
            enablingNotifications = true
        }
        else {
            status = 0
            enablingNotifications = false
        }
        self.isIgnorePush = false
        self.callAPIToUpdateNotificationSTatusWith(status)
        
    }
    
    func callAPIToUpdateNotificationSTatusWith(_ status: Int) {
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:self.view)
            let params:[String:String] =
                ["cand_id":UserDefaults.standard.object(forKey:"cID") as! String,
                 "push_notification":"\(status)",
                    "cand_name":UserDefaults.standard.object(forKey: "username") as! String]
            print(params)
            ServerService.updateNotificationStatus(self, params: params, method: "POST",accessToken:Constants.Token, acces:true,callBack:getNotificationresponse(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
    }
    
    
    
    
    
    //aftergettingResponseFrom the server
    func getNotificationresponse(response:AnyObject)->()
    {
        print(response)
        ServerService.hideProgressView()
        cLResponse = response as! JSON
        if cLResponse["MessageStatus"].intValue == 1 {
            
            self.getMenuLinks()
            
            (UIApplication.shared.delegate as? AppDelegate)?.checkPushNotification(checkNotificationStatus: { (access) in
                if access {
                    DispatchQueue.main.async {
                        // self.notificationToogle.isOn = true
                    }
                    
                }
                else {
                    if self.enablingNotifications == true {
                        if self.isIgnorePush == false { // isIgnorePush will decide whether we need take user to setting screen or not
                            if let bundleId = Bundle.main.bundleIdentifier,
                                let url = URL(string: "\(UIApplicationOpenSettingsURLString)&path=LOCATION/\(bundleId)") {
                                DispatchQueue.main.async {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                            }
                        }
                    }
                    
                }
            })
            if self.enablingNotifications == true {
                UserDefaults.standard.set(true, forKey: "Notifications")
            }
            else {
                UserDefaults.standard.set(false, forKey: "Notifications")
            }
        }
        else {
            if self.enablingNotifications == true {
                self.notificationToogle.isOn = false
                UserDefaults.standard.set(false, forKey: "Notifications")
            }
            else {
                self.notificationToogle.isOn = true
                 UserDefaults.standard.set(true, forKey: "Notifications")
            }
            ServerService.ShowAlertMessage(ErrorMessage:cLResponse["PushNotificationMessage"].stringValue, title: "", view:self)
        }
    }
}
