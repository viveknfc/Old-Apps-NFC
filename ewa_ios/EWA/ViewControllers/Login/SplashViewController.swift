//
//  SplashViewController.swift
//  EWA
//
//  Created by NFC Solutionsusa on 30/11/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import  SideMenuController
import ANLoader

class SplashViewController: UIViewController {
    
    var alertController = UIAlertController()
    
    var webAlertController = UIAlertController()
    
    let greenColor = UIColor.init(red: 92/255, green: 184/255, blue: 92/255, alpha: 1)
    let borderColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
    
    let info_Text = "Info"
    let Warning_Text = "Warning"
    let Success_Text = "Success"
    let Danger_Text = "Danger"
    
    let success_Color = "#3c763d"
    let success_background_Color = "#dff0d8"
    let success_border_Color = "#d6e9c6"
    
    let info_Color = "#31708f"
    let info_background_Color = "#d9edf7"
    let info_border_Color = "#bce8f1"
    
    let warning_Color = "#8a6d3b"
    let warning_background_Color = "#fcf8e3"
    let warning_border_Color = "#faebcc"
    
    let danger_Color = "#a94442"
    let danger_background_Color = "#f2dede"
    let danger_border_Color = "#ebccd1"
    
    
    @IBOutlet weak var versionLabel: UILabel!
    var menuObject: JSON = JSON.null
    var appVesrion: JSON = JSON.null
    var navigateLiteral = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        versionLabel.text = "v.\(Constants.APP_VERSION)"
        print("******VIVEK SPlash screen came******")
        if ConnectionCheck.isConnectedToNetwork()
        {
            let params = [ "EWAMobileOSType":"IOS", "EWAAppVersion":Constants.APP_VERSION] as [String:Any]
            print("***VIV - the parameters from splash screen is - \(params)***")
            ServerService.getAccountGetAPiVersion(self, params: params, method: "POST", accessToken:"",acces:false, callBack:getresponseForVersion(response:))
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
    }
    
    
    //aftergettingResponseFrom the server
    func getresponseForVersion(response:AnyObject)->()
    {
        appVesrion = response as! JSON
        print("***VIV - the response from splash screen is - \(appVesrion)")
        Constants.ApiTimeOut = appVesrion["APISessionTimeout"].intValue*60
        UserDefaults.standard.set(appVesrion["isTimeOut"].boolValue, forKey:"timeout")
        UserDefaults.standard.set(appVesrion["App_Link"].stringValue, forKey:"AppLink")
        if appVesrion.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
            
        // Viv - IsInAppStore - WHile we release new built version, for review time we need to make this response as truw by informing to back end team; so that the reviewer has no issue while review
        
        else if (appVesrion["IsInAppStore"].boolValue || (!appVesrion["IsInAppStore"].boolValue && ServerService.BaseUrl == ServerService.DevelopmentURL) || appVesrion["IsInAppStore"].boolValue || (!appVesrion["IsInAppStore"].boolValue && ServerService.BaseUrl == ServerService.StagingURL))
        {
            
            self.showAlertIfRequired(appVesrion)
            
        }
        else
        {
            if appVesrion["MessageStatus"].intValue == 0
            {
                
                Constants.version = false
                ServerService.ShowAlertMessageForUpdate(ErrorMessage:"New version of the app is available in the app store please update", title: "Update Available", view:self)
            }
            else
            {
                self.showAlertIfRequired(appVesrion)
                
            }
        }
        
    }
    
    func callMenuLinksAPI(){
        print("****VIVEK Call Menu Links API Called*****")
        Constants.version = true
        if UserDefaults.standard.object(forKey: "cID") != nil {
            let paramsMenu:[String:Any] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"emptype":UserDefaults.standard.object(forKey:"EmployeeType") as! Int,"DeviceToken":Constants.FCMToken,"DeviceUserName":"\(UIDevice.current.name)",
                "DeviceType": "iOS",
                "IsActive" :"1",
                "Device" :"\(UIDevice.current.model)"]
            print("MENULINKS_PARAMS \(paramsMenu)")
            print("***VIV the access token is \(Constants.Token)***")
            ServerService.getAccountEWAMenuLinks(self, params: paramsMenu, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseForMenu(response:))
        }
    }
    
    
    //aftergettingResponseFrom the server
    func getresponseForMenu(response:AnyObject)->()
    {
        menuObject = response as! JSON
        print(menuObject)
        if menuObject.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if menuObject["Message"].stringValue == "Authorization has been denied for this request."
        {
            Constants.menuHeaders.removeAll()
            Constants.menuSectionLogos.removeAll()
            Constants.menuSections.removeAll()
            Constants.menuObjj.removeAll()
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
            Constants.menuHeaders.removeAll()
            Constants.menuSectionLogos.removeAll()
            Constants.menuSections.removeAll()
            Constants.menuObjj.removeAll()
            Constants.titleImages.removeAll()
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
            Constants.menuParentMenuIDs.removeAll()
            Constants.menuObjj.removeAll()
            
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
            if UserDefaults.standard.integer(forKey:"EmployeeType") == 1 // getting from EWA menu links from login
            {
                self.performSegue(withIdentifier: "permanentSegue", sender: nil)
            }
            else
            {
              //  self.view.makeToast("Home Segue Called", duration: 3.0, position: .bottom, title: "", image: nil)
                    self.performSegue(withIdentifier: "home", sender: nil) // custom side menu vc
                
            }
        }
    }
    
    //MARK:- ShowAlertIfRequired
    func showAlertIfRequired(_ object: JSON){
        /*
         Status = 1 : Success -- dont show popup --> goto next screen
         Status = 2 : Warning -- show popup with Ok--> if we click ok goto next screen
         Status = 3 : Error   show popup with Ok--> close the app
         Status = 4 : Info -- show popup with Ok--> if we click ok goto next screen
         */
        if object["PopupMessage"]["Status"].intValue == 1 {
            
            self.callMenuLinksAPI()
        }
        else if object["PopupMessage"]["Status"].intValue == 2 {
            
            if UserDefaults.standard.object(forKey: "cID") != nil {
                self.loadAlertPopupWithObject(object["PopupMessage"]["Status"].intValue, messageText: object["PopupMessage"]["Message"].stringValue, popKeyToSend: object["PopupMessage"]["PopupKey"].stringValue, apiCallrequired: true)
            }
            else {
                self.callMenuLinksAPI()
            }
            
        }
        else if object["PopupMessage"]["Status"].intValue == 3 {
            if UserDefaults.standard.object(forKey: "cID") != nil {
                self.loadAlertPopupWithObject(object["PopupMessage"]["Status"].intValue, messageText: object["PopupMessage"]["Message"].stringValue, popKeyToSend: object["PopupMessage"]["PopupKey"].stringValue, apiCallrequired: false)
            }
            else {
                self.callMenuLinksAPI()
            }
            
        }
        else if object["PopupMessage"]["Status"].intValue == 4 {
            if UserDefaults.standard.object(forKey: "cID") != nil {
                self.loadAlertPopupWithObject(object["PopupMessage"]["Status"].intValue, messageText: object["PopupMessage"]["Message"].stringValue, popKeyToSend: object["PopupMessage"]["PopupKey"].stringValue, apiCallrequired: true)
            }
            else {
                self.callMenuLinksAPI()
            }
        }
        else {
            self.callMenuLinksAPI()
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
    

    @IBAction func webOKButtonTapped(_ sender: Any){
        webAlertController.dismiss(animated: true, completion: nil)
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
    }

    
    func isPortrait() -> Bool{
        
        let orientation = UIDevice.current.orientation
        switch orientation {
        case .portrait, .portraitUpsideDown:
            return true
        case .landscapeLeft, .landscapeRight:
            return false
        default: // unknown or faceUp or FaceDown
            return self.view.frame.width < self.view.frame.height
        }
    }
}
extension String {
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}
extension NSArray{
    //sorting- ascending
    func ascendingArrayWithKeyValue(key:String) -> NSArray{
        let ns = NSSortDescriptor.init(key: key, ascending: true)
        let aa = NSArray(object: ns)
        let arrResult = self.sortedArray(using: aa as! [NSSortDescriptor])
        return arrResult as NSArray
    }
    
    //sorting - descending
    func discendingArrayWithKeyValue(key:String) -> NSArray{
        let ns = NSSortDescriptor.init(key: key, ascending: false)
        let aa = NSArray(object: ns)
        let arrResult = self.sortedArray(using: aa as! [NSSortDescriptor])
        return arrResult as NSArray
    }
}

extension SplashViewController: popAlertDelegate {
    func formStatus(success: Bool) {
        print(success)
        self.callMenuLinksAPI()
    }
}
