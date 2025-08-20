//
//  DemoCandidatesViewController.swift
//  EWA
//
//  Created by NFC India on 01/11/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage


class DemoCandidatesViewController: UIViewController {
    
    @IBOutlet weak var demoCandidatesTableView: UITableView!
    
    var canidateListData:JSON = JSON.null
    var object:JSON = JSON.null
    var menuObject: JSON = JSON.null
    var canidateList = [DemoCandidates]()
    var signedObjectResponse:JSON = JSON.null
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("***VIV the screen name is \(className)***")
        // Do any additional setup after loading the view.
        
        self.title = UserDefaults.standard.object(forKey:"demoCname") as? String
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // get call paystubs
        getAllDemoCandidate()
    }
    
    
    //method fot getting all the democandidate List
    func getAllDemoCandidate()
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            
            ServerService.showActivityIndicatory(uiView:self.view)
            let params = ["GetDemoList":"1"] as [String : Any]
            print("***VIV the demo candidate params is \(params)***")
            ServerService.gemoCandidateList(self, params:params, method:"POST", accessToken:Constants.Token, acces: false, callBack: self.getDemocandidateList(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            
        }
    }
    
    
    // response from the server
    func getDemocandidateList(response:AnyObject)->()
    {
        canidateList.removeAll()
        ServerService.hideProgressView()
        canidateListData = response as! JSON
        print("****** candidate data is ************\n",canidateListData)
        
        if canidateListData["MessageStatus"].intValue == 1
        {
            for cand in 0..<canidateListData["Candlist"].arrayValue.count
            {
                let candidate = DemoCandidates.init(candidateName: canidateListData["Candlist"][cand]["CandidateName"].stringValue, candidateId: canidateListData["Candlist"][cand]["CandId"].stringValue, divisionName: canidateListData["Candlist"][cand]["DivisionName"].stringValue, divisionLogo: canidateListData["Candlist"][cand]["Logo"].stringValue, password: canidateListData["Candlist"][cand]["Password"].stringValue, userName: canidateListData["Candlist"][cand]["Login"].stringValue)
                canidateList.append(candidate)
            }
            
        }
        else
        {
            
        }
        print("***VIV the candidate list count us \(canidateList.count)***")
        demoCandidatesTableView.reloadData()
        
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
    
    
    //aftergettingResponseFrom the server for login
    func getresponse(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        object = response as! JSON
        print("***VIV the object response is \(object)***")
        
        if object.isEmpty
        {
            print("empty")
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if object["MessageStatus"].intValue == 1
        {
            
            //accessToken
            let cID = object["CandId"].stringValue+":"
            let Token = object["Token"].stringValue
            Constants.Token = cID+Token
            //server call
            ServerService.showActivityIndicatory(uiView:self.view)
            let paramsMenu:[String:String] = ["CandidateId":object["CandId"].stringValue,"DivisionId":object["DivisionId"].stringValue,"emptype":object["EmployeeType"].stringValue]
            print("***VIV the MENULINKS_PARAMS \(paramsMenu)***")
            ServerService.getAccountEWAMenuLinks(self, params: paramsMenu, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseForMenu(response:))
            
        }
        else
        {
            ServerService.hideProgressView()
            if Constants.version == false
            {
                ServerService.ShowAlertMessage(ErrorMessage:"New version of the app is available in the app store please update", title: "Update Available", view:self)
            }
            else
            {
                print("the alert is trigerring from 144")
                ServerService.ShowAlertMessage(ErrorMessage:"", title:object["Message"].stringValue , view: self)
            }
        }
        
        
    }
    
    
    //aftergettingResponseFrom the server
    func getresponseForMenu(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        //clearing all the menu objects
        Constants.menuHeaders.removeAll()
        Constants.menuSectionLogos.removeAll()
        Constants.menuSections.removeAll()
        Constants.menuObjj.removeAll()
        Constants.dashObject = JSON.null
        
        menuObject = response as! JSON
        print("***VIV the menu obeject is \(menuObject)***")
        if menuObject.isEmpty
        {
            print("empty")
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else
        {
            if (menuObject["IsPopupRequired"] != nil){
                Constants.isScrSigned = menuObject["IsPopupRequired"].intValue
            }
            else{
                Constants.isScrSigned = -1
            }
            Constants.isScrMessage =  menuObject["SCRMessage"].stringValue
            Constants.globalMessgae =   menuObject["PopUpMessage"].stringValue
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
            

            if (menuObject["Popup"] != nil){
                Constants.globalMessageKey =  menuObject["Popup"].intValue
            }
            else{
                Constants.globalMessageKey = -1
            }
            
            Constants.locationAllowMessage = menuObject["LocationMessage"].stringValue
            
            ServerService.hideProgressView()
            Constants.titleImages.removeAll()
            print(menuObject)
            for menu in 0..<menuObject["List"].arrayValue.count
            {
                if menuObject["List"][menu]["ParentMenuId"].intValue == 0
                {
                    Constants.menuHeaders.append(menuObject["List"][menu]["LinkText"].stringValue)
                    Constants.titleImages.append(menuObject["List"][menu]["LogoPath"].stringValue)
                }
            }
            for menuection in 0..<Constants.menuHeaders.count
            {
                
                var menuNames = [String]()
                var menuLogos = [String]()
                for menu in 0..<menuObject["List"].arrayValue.count
                {
                    if menuObject["List"][menu]["ParentMenuId"].intValue == menuection+1 // +1 was there viv
                    {
                        menuNames.append(menuObject["List"][menu]["LinkText"].stringValue)
                        menuLogos.append(menuObject["List"][menu]["LogoPath"].stringValue)
                    }
                    
                }
                Constants.menuSections.append(menuNames)
                print("***VIV the menutitles from democandidatevc is \(Constants.menuSections)***")
                Constants.menuSectionLogos.append(menuLogos)
                
            }
            Constants.dashObject = menuObject
            
            
            UserDefaults.standard.set(object["Token"].stringValue, forKey: "token")
            UserDefaults.standard.set(object["ColorCode"].stringValue, forKey: "color")
            UserDefaults.standard.set(object["LogoPath"].stringValue, forKey: "logo")
            UserDefaults.standard.set(object["CandId"].stringValue, forKey: "cID")
            UserDefaults.standard.set(object["DivisionId"].stringValue, forKey: "dID")
            UserDefaults.standard.set(object["CandName"].stringValue, forKey:"CandName")
            UserDefaults.standard.set(object["ImageFile"].stringValue, forKey: "ImageFile")
            UserDefaults.standard.set(object["EmployeeType"].intValue, forKey: "EmployeeType")
            
            Constants.menuOptionNameArray = [UserDefaults.standard.object(forKey:"CandName") as! String,"Change Password","Change Profile Picture","Privacy Policy","Logout"]
            
            self.performSegue(withIdentifier: "homeSegue", sender: nil)
            
        }
        
    }
    
    
    
    @IBAction func handleNavgationBarButtonTap(_ sender: UIBarButtonItem, event: UIEvent)
        
    {
        self.showUp(event:event,viewController:self)
        
    }
    
    func showUp(event: UIEvent,viewController:UIViewController)
    {
        let config = FTConfiguration.shared
        config.textColor = UIColor.black
        config.backgoundTintColor = UIColor.white
        config.borderColor = UIColor.lightGray
        config.menuWidth = 200
        config.menuSeparatorColor = UIColor.lightGray
        config.textAlignment = .left
        config.textFont = UIFont.systemFont(ofSize: 14)
        config.menuRowHeight = 40
        config.cornerRadius = 6
        config.menuSeparatorInset = UIEdgeInsetsMake(0,0,0,0)
        FTPopOverMenu.showForEvent(event: event, with:["Logout"], done: { (selectedIndex) -> () in
            print(selectedIndex)
            if selectedIndex == 0 {
                
                Constants.menuHeaders.removeAll()
                Constants.menuSectionLogos.removeAll()
                Constants.menuSections.removeAll()
                Constants.titleImages.removeAll()
                Constants.dashObject = JSON.null
                TimeOutClass.sharedInstance.resetTimer()
                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                let defaults = UserDefaults.standard
                let dictionary = defaults.dictionaryRepresentation()
                dictionary.keys.forEach { key in
                    defaults.removeObject(forKey: key)
                }
                (UIApplication.shared.delegate as? AppDelegate)?.APSlocation_Set_up()
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ewaLogin") as! LoginViewController
                UIApplication.shared.keyWindow?.rootViewController = viewController         }
            
        },cancel: {
            
        })
    }
    
    
}




//tableview extensions Datasource and delegate methods
extension DemoCandidatesViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return canidateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"dCell") as! DemoTableViewCell
        cell.candidateName.text = canidateList[indexPath.row].candidateName
        cell.divisionName.text = canidateList[indexPath.row].divisionName
        cell.divisionLogo.sd_setImage(with: URL(string:canidateList[indexPath.row].divisionLogo), placeholderImage: UIImage(named: "placeholder.png"))
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ServerService.showActivityIndicatory(uiView:self.view)
        UserDefaults.standard.set(canidateList[indexPath.row].userName, forKey:"username")
        let params :[String:String] = ["username":canidateList[indexPath.row].userName,"password":canidateList[indexPath.row].password,"mobileappversion":"iOS","APPVersion":Constants.APP_VERSION,"MobileOSVersion":"\(getOSInfo())","PhoneType":"\(deviceName())", "DeviceId":"\(UIDevice.current.identifierForVendor!.uuidString)"]
        print("***VIV the params for did select from democandidatevc is \(params)***")
        ServerService.loginByMobileNumber(self, params: params, method: "POST", callBack:getresponse(response:))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
