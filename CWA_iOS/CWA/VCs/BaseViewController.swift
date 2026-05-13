//
//  BaseViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 01/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//
/*
 This is the parent class used for common design
 */
import UIKit
import Foundation
import SystemConfiguration
import Toast_Swift
import SwiftyJSON
import WebKit
import Network
import CoreTelephony

class BaseViewController: UIViewController,UIGestureRecognizerDelegate, UINavigationControllerDelegate, WKUIDelegate {
    
    
    let HOS_Group_TS_Menu_Id = 30
    let Get_TS_YouHave_Approved_Menu_Id = 35
    let Enter_TS_Menu_Id = 31
    let EUA_Menu_Id = 11
    let Client_Invoice_Menu_Id = 9
    let Payment_Informatio_Id = 59
    let Division_View_TAG = 78987
    let SplashImageView_TAG = 18987
    
    let splashImageView = UIImageView()
    let splashView = UIView()
    
    
    var bgSideView = UIView()
    let dateFormat = "MM/dd/yyyy"
    let InternetConnectionTitle = "No Internet Connection"
    let InternetConnectionMessage = "Please connect to an active network and try again"
    let Authorizarion_Message = "Authorization has been denied for this request."
    let Error_Message = "Technical issue, please try again later"
    let greenColor = UIColor.init(red: 92/255, green: 184/255, blue: 92/255, alpha: 1)
    let borderColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
    
    var alertController = UIAlertController()
    
    var webAlertController = UIAlertController()
    
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
    
    var address = "" // for GeoReverse code location
    var addToSend: String?
    
    /*
     success {
     color: #3c763d;
     background-color: #dff0d8;
     border-color: #d6e9c6;
     }
     info {
     color: #31708f;
     background-color: #d9edf7;
     border-color: #bce8f1;
     }
     warning {
     color: #8a6d3b;
     background-color: #fcf8e3;
     border-color: #faebcc;
     }
     danger {
     color: #a94442;
     background-color: #f2dede;
     border-color: #ebccd1;
     }
     
     
     */
    
    ///****/////////
    
    
    ///////*****///////
    var titlelbl = UILabel()
    public func isInternetAvailable() -> Bool //viv- this same has been written in Base Table View Controller
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func showCustomAlert(Title:String,attMessage:NSAttributedString,message:String,okBtnTitle:String,cancelBtnTitle:String,type:String,isAttributed:Bool) {
        
        DispatchQueue.main.async(execute: { () -> Void in
            let vc = UIViewController()
            vc.view.isUserInteractionEnabled = true
            
            let message1  = String(format:"%@\n\n\n%@",Title,message)
            if self.isPortrait() == true{
                
            }
            else{
                
            }
            
            let height =  message1.heightWithConstrainedWidth(width: 250, font: UIFont.boldSystemFont(ofSize: CGFloat(14))) + CGFloat(4)
            if isAttributed == true    {
                if Title.count == 0{
                    if message.contains("employee must take a meal break of at least 30 minutes"){
                        
                        vc.preferredContentSize = CGSize(width: 250,height: height - 150)
                        
                    }else{
                        if height > 80{
                            vc.preferredContentSize = CGSize(width: 250,height: height - 20)
                        }else{
                            vc.preferredContentSize = CGSize(width: 250,height: height + 40)
                        }
                    }
                }else{
                    vc.preferredContentSize = CGSize(width: 250,height: height)
                }
            }else if Title.count == 0{
                
                vc.preferredContentSize = CGSize(width: 250,height: height + 50)
                
            }else{
                vc.preferredContentSize = CGSize(width: 250,height: height + 70)
                
            }
            vc.view.addSubview(self.showAlertOnSuperView(Title:Title,attMessage: attMessage , message: message,okBtn: okBtnTitle,cancelBtnTitle:cancelBtnTitle,alertType: type,isAttributed: isAttributed )) //viv- ShowAlertOnSuperView Explained below
            
            self.alertController = UIAlertController(title:nil, message: nil, preferredStyle:
                                                        UIAlertController.Style.alert)
            self.alertController.setValue(vc, forKey: "contentViewController")
            
            let backView = self.alertController.view.subviews.last?.subviews.last
            backView?.layer.cornerRadius = 20.0
            backView?.backgroundColor = UIColor.clear // UIColor(hexString:self.info_background_Color)
            self.present(self.alertController, animated: true, completion: nil)
        })
        
    }
    func showAlertOnSuperView(Title:String,attMessage:NSAttributedString,message:String,okBtn:String,cancelBtnTitle:String,alertType:String,isAttributed:Bool) -> UIView {
        
        var TotalMessage  = String(format:"%@\n\n\n%@",Title,message)
        if Title.count == 0{
            TotalMessage  =  message
        }
        
        var height =  TotalMessage.heightWithConstrainedWidth(width: 250, font: UIFont.boldSystemFont(ofSize: CGFloat(14))) + CGFloat(4)
        
        
        let superView = UIView() // viv- 1st Super view - lblSuperView - (lblTitle + lbl) - rightBtn
        superView.frame = CGRect(x:0,y:0,width:250,height:height + 160)
        superView.backgroundColor = UIColor.clear
        
        //this will be the area for text
        let lblSuperView = UIView()
        if isAttributed == true {
            if message.contains("The hours you have entered above conflict with a time slip"){
                height = height - 60
            }else if message.contains("employee must take a meal break of at least 30 minutes"){
                height = height - 200
            }else{
                if Title.count == 0{
                }else{
                    height = height - 70
                }
            }
        }
        if Title.count == 0 {
            height = height + 20
        }
        lblSuperView.frame = CGRect(x:0,y:5,width:250,height:height + 10)
        superView.addSubview(lblSuperView)
        
        
        let lblTitle = UILabel()
        lblTitle.frame = CGRect(x:10,y:5,width:superView.frame.size.width-20,height:50)
        lblTitle.text = Title
        lblTitle.backgroundColor = UIColor.clear
        lblTitle.numberOfLines = 0
        lblTitle.textAlignment = NSTextAlignment.center
        lblTitle.font = UIFont.boldSystemFont(ofSize: 14)
        lblSuperView.addSubview(lblTitle)
        
        
        var heightLbl =  message.heightWithConstrainedWidth(width: 250, font: UIFont.boldSystemFont(ofSize: CGFloat(14))) + CGFloat(4)
        if isAttributed == true {
            if message.contains("The hours you have entered above conflict with a time slip"){
                heightLbl = heightLbl - 40
            }else{
                if heightLbl > 80{
                    heightLbl = heightLbl - 70
                }
            }
        }
        let lbl = UILabel()
        if Title.count == 0{
            if message.contains("The hours you have entered above conflict with a time slip") {
                lbl.frame = CGRect(x:5,y:0,width:superView.frame.size.width-10,height:heightLbl)
            }else if message.contains("employee must take a meal break of at least 30 minutes"){
                lbl.frame = CGRect(x:0,y:0,width:superView.frame.size.width,height:heightLbl - 100)
                
            }else{
                lbl.frame = CGRect(x:5,y:15,width:superView.frame.size.width-10,height:heightLbl)
            }
        }else{
            lbl.frame = CGRect(x:5,y:45,width:superView.frame.size.width-10,height:heightLbl)
            
        }
        lbl.backgroundColor = UIColor.clear
        lbl.numberOfLines = 0
        lbl.textAlignment = NSTextAlignment.left
        lbl.font = UIFont.systemFont(ofSize: 14)
        lblSuperView.addSubview(lbl)
        //
        if isAttributed == true{
            lbl.attributedText = attMessage
        }else{
            lbl.text = message
        }
        
        let rightBtn = UIButton()
        rightBtn.frame = CGRect(x:75,y:lblSuperView.frame.size.height + lblSuperView.frame.origin.y + 15,width:100,height:35)
        rightBtn.setTitle(okBtn, for: UIControl.State.normal)
        rightBtn.addTarget(self, action:#selector(self.okButtonTapped), for: .touchUpInside)
        if okBtn.count > 0 {
            superView.addSubview(rightBtn)
        }
        
        lblSuperView.layer.borderWidth = 1
        
        
        if alertType == info_Text{
            lblSuperView.backgroundColor = UIColor(hexString:info_background_Color)
            lblSuperView.layer.borderColor = UIColor(hexString:info_border_Color).cgColor
            //            rightBtn.backgroundColor = UIColor(hexString:info_Color)
            lbl.textColor = UIColor(hexString:info_Color)
            lblTitle.textColor = UIColor(hexString:info_Color)
            
        }else if alertType == Warning_Text{
            lblSuperView.backgroundColor = UIColor(hexString:warning_background_Color)
            lblSuperView.layer.borderColor = UIColor(hexString:warning_border_Color).cgColor
            //            rightBtn.backgroundColor = UIColor(hexString:warning_Color)
            lbl.textColor = UIColor(hexString:warning_Color)
            lblTitle.textColor = UIColor(hexString:warning_Color)
            
        }else if alertType == Success_Text{
            lblSuperView.backgroundColor = UIColor(hexString:success_background_Color)
            lblSuperView.layer.borderColor = UIColor(hexString:success_border_Color).cgColor
            //            rightBtn.backgroundColor = UIColor(hexString:success_Color)
            lbl.textColor = UIColor(hexString:success_Color)
            lblTitle.textColor = UIColor(hexString:success_Color)
            
        }else if alertType == Danger_Text{
            lblSuperView.backgroundColor = UIColor(hexString:danger_background_Color)
            lblSuperView.layer.borderColor = UIColor(hexString:danger_border_Color).cgColor
            //            rightBtn.backgroundColor = UIColor(hexString:danger_Color)
            lbl.textColor = UIColor(hexString:danger_Color)
            lblTitle.textColor = UIColor(hexString:danger_Color)
            
        }
        rightBtn.backgroundColor = greenColor
        
        if cancelBtnTitle.count > 0 {
            
            rightBtn.frame = CGRect(x:130,y:lblSuperView.frame.size.height + lblSuperView.frame.origin.y  + 18,width:120,height:35)
            
            let cancelBtn = UIButton()
            cancelBtn.frame = CGRect(x:0,y:lblSuperView.frame.size.height + lblSuperView.frame.origin.y  + 18,width:120,height:35)
            cancelBtn.setTitle(cancelBtnTitle, for: UIControl.State.normal)
            cancelBtn.addTarget(self, action:#selector(self.cancelBtnTapped), for: .touchUpInside)
            cancelBtn.backgroundColor = UIColor.red
            superView.addSubview(cancelBtn)
        }
        return superView
    }
    
    //MARK: - Get IP Address
    
    func getIPv4Address() -> String? {
    
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) { // || addrFamily == UInt8(AF_INET6) {

                    // wifi = ["en0"]
                    // wired = ["en2", "en3", "en4"]
                    // cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]

                    let name: String = String(cString: (interface.ifa_name))
                    if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address ?? ""
        
    }
    
    
    //MARK:- AlertOkButtonClicked
    @IBAction func okButtonTapped(_ sender: Any) {
        
        alertController.dismiss(animated: true, completion: nil)
        if self.view.window!.rootViewController != nil{
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
            
        }
        
    }
    @IBAction func webOKButtonTapped(_ sender: Any){
        webAlertController.dismiss(animated: true, completion: nil)
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
    }
    @IBAction func cancelBtnTapped(_ sender: Any) {
        //        print("signoutButtonTapped")
        alertController.dismiss(animated: true, completion: nil)
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    func convertStringToDate(dateString: String) -> Date{
        if dateString.count == 0{}else{
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.preferredLocale()
            dateFormatter.dateFormat = dateFormat //viv- This has been explained as a string in top
            let selDate = dateFormatter.date(from: dateString)!
            return selDate
        }
        return Date()
    }
    func showWebAlertView(cancelBtnTitle: String,content : String){
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            let StringHeight = content.heightWithConstrainedWidth(width: 250, font: UIFont.boldSystemFont(ofSize: 12))
            let vc = UIViewController()
            vc.view.isUserInteractionEnabled = true
            vc.preferredContentSize = CGSize(width: 250,height: StringHeight + 20)
            vc.view.addSubview(self.showWebAlertOnSuperView(content: content, okBtn: "OK", cancelBtnTitle: cancelBtnTitle))
            
            self.webAlertController = UIAlertController(title:nil, message: nil, preferredStyle:
                                                            UIAlertController.Style.alert)
            self.webAlertController.setValue(vc, forKey: "contentViewController")
            let backView = self.webAlertController.view.subviews.last?.subviews.last
            backView?.layer.cornerRadius = 20.0
            backView?.backgroundColor = UIColor.clear // UIColor(hexString:self.info_background_Color)
            self.webAlertController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.present(self.webAlertController, animated: true, completion: nil)
        })
    }
    
    
    func showWebAlertOnSuperView(content:String,okBtn:String,cancelBtnTitle:String) -> UIView {
        
        let StringHeight = content.heightWithConstrainedWidth(width: 250, font: UIFont.boldSystemFont(ofSize: 12))
        
        let superView = UIView()
        superView.frame = CGRect(x:0,y:0,width:250,height:StringHeight + 100)
        superView.backgroundColor = UIColor.clear
        
        
        let web = WKWebView(frame: CGRect(x: 5, y: 10, width: 250  , height: StringHeight - 60))
        web.loadHTMLString(content, baseURL: nil)
        //  web.scrollView.scal = true
        
        superView.addSubview(web)
        web.backgroundColor = UIColor.clear
        
        let rightBtn = UIButton()
        rightBtn.frame = CGRect(x:75,y:web.frame.size.height + web.frame.origin.y + 15,width:100,height:35)
        rightBtn.setTitle(okBtn, for: UIControl.State.normal)
        rightBtn.addTarget(self, action:#selector(self.webOKButtonTapped), for: .touchUpInside)
        rightBtn.backgroundColor = self.greenColor
        superView.bringSubviewToFront(rightBtn)
        superView.addSubview(rightBtn)
        
        
        if cancelBtnTitle.count > 0 {
            
            rightBtn.frame = CGRect(x:130,y:web.frame.size.height + web.frame.origin.y  + 20,width:120,height:35)
            let cancelBtn = UIButton()
            cancelBtn.frame = CGRect(x:0,y:web.frame.size.height + web.frame.origin.y  + 20,width:120,height:35)
            cancelBtn.setTitle(cancelBtnTitle, for: UIControl.State.normal)
            cancelBtn.addTarget(self, action:#selector(self.cancelBtnTapped), for: .touchUpInside)
            cancelBtn.backgroundColor = UIColor.red
            superView.addSubview(cancelBtn)
            superView.bringSubviewToFront(cancelBtn)
        }
        
        return superView
        
        
    }
    func sizeOfString (string: String, constrainedToHeight height: Double) -> CGSize { //viv- Table row height, constarining it
        
        return NSString(string: string).boundingRect(with: CGSize(width: Double.greatestFiniteMagnitude, height: height),
                                                     options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                     attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)],
                                                     context: nil).size
    }
    
    func addDropDownShadowToView(shadowView: UIView) {
        
        
        // Shadow and Radius
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0.0,height: 3.0)
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowRadius = 4.0
        //        shadowView.layer.masksToBounds = false
        shadowView.layer.shouldRasterize = true
        shadowView.layer.rasterizationScale = UIScreen.main.scale
        
        
    }
    func ConvertDateToRequiredString(date: Date) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // This formate is input formated .
        let formateDate =  date
        dateFormatter.dateFormat = dateFormat // Output Formated
        return dateFormatter.string(from: formateDate)
    }
    func getFormattedDate(string: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // This formate is input formated .
        let formateDate = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = dateFormat // Output Formated
        return dateFormatter.string(from: formateDate)
    }
    
    func convertDateStringToDefaultDate(dateString: String,formatString: String) -> Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = formatString//"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        let date = dateFormatter.date (from: dateString)
        return date!
    }
    func getDayOfWeek(today:String)->String {
        
        let formatter  = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        let todayDate = formatter.date(from: today)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: todayDate) //viv- .weekday is default option which says the number from 1 to 7
        let weekDay = myComponents.weekday
        var day = ""
        switch weekDay {
        case 1?:
            day = "Sunday"
        case 2?:
            day = "Monday"
        case 3?:
            day = "Tuesday"
        case 4?:
            day = "Wednesday"
        case 5?:
            day = "Thursday"
        case 6?:
            day = "Friday"
        case 7?:
            day = "Saturday"
        default:
            day = ""
        }
        return day
    }
    //MARK: View Methods
    func rearrange(array: NSMutableArray, fromIndex: Int, toIndex: Int) -> NSMutableArray{
        let arr = array
        let element = arr.remove(fromIndex)
        arr.insert(element, at: toIndex)
        
        return arr
    }
    
    func checkIfAppIsUpdated(){
        
        splashImageView.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
        
        splashImageView.backgroundColor = UIColor.red
        splashImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        splashImageView.tag = SplashImageView_TAG
        splashImageView.contentMode = .scaleAspectFill // OR .scaleAspectFill
        splashImageView.clipsToBounds = true
        splashImageView.image = UIImage.init(named: "launchScreen.png")
        // launchScreen.png
        //  if let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
        let versionLbl = UILabel.init(frame: CGRect(x:0,y:UIScreen.main.bounds.size.height - 70,width:UIScreen.main.bounds.size.width - 80,height:40))
        versionLbl.text =  "v.\(RestAPI.displayVersion)"//String(format: "v.%@",version)
        versionLbl.font = UIFont.boldSystemFont(ofSize: 14)
        versionLbl.textAlignment = .right
        versionLbl.backgroundColor = UIColor.clear
        versionLbl.textColor = UIColor.white
        splashImageView.addSubview(versionLbl)
        // }
        self.navigationController?.view.addSubview(splashImageView)
        self.CheckAPPVersion()
    }
    @objc func appWillEnterForeground(){
        print(appWillEnterForeground)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        let string = " keep my left side "
        print(string.count)
        
        let cleansed = string.replacingOccurrences(of: "\\s+$",
                                                   with: "",
                                                   options: .regularExpression)
        
        print(cleansed.count)
        
        let delegate = UIApplication.shared.delegate  as! AppDelegate
        
        
        if delegate.isAPPVersionAPICalled == false{
            print("***VIV entered view did load in base vc")
            self.checkIfAppIsUpdated()
            
        }
        self.automaticallyAdjustsScrollViewInsets = false
        print(UIScreen.main.bounds.size.width)
        
        // Do any additional setup after loading the view.
        
        
        if defaults.string(forKey: "ColorCode") != nil {
            
            let backButton = UIBarButtonItem.init(customView: self.backButton())
            
            self.navigationItem.leftBarButtonItem = backButton
            _ = UserDefaults.standard.object(forKey:"ColorCode")as! String
            
            // self.navigationController?.navigationBar.barTintColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
            if #available(iOS 13.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithDefaultBackground()
                appearance.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
                navigationController?.navigationBar.prefersLargeTitles = false
                navigationController?.navigationBar.standardAppearance = appearance
                navigationController?.navigationBar.scrollEdgeAppearance = appearance
            }else {
                // Fallback on earlier versions
                self.navigationController?.navigationBar.barTintColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
            }
        }else{
            let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: navigationController, action: nil)
            navigationItem.leftBarButtonItem = backButton
            
            if defaults.string(forKey: "User_ColorCode") != nil {
                let User_ColorCode = UserDefaults.standard.object(forKey:"User_ColorCode")as! String
                //self.navigationController?.navigationBar.barTintColor = UIColor(hexString:User_ColorCode)
                if #available(iOS 13.0, *) {
                    let appearance = UINavigationBarAppearance()
                    appearance.configureWithDefaultBackground()
                    appearance.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"User_ColorCode")as! String)
                    navigationController?.navigationBar.prefersLargeTitles = false
                    navigationController?.navigationBar.standardAppearance = appearance
                    navigationController?.navigationBar.scrollEdgeAppearance = appearance
                } else {
                    // Fallback on earlier versions
                    self.navigationController?.navigationBar.barTintColor = UIColor(hexString:UserDefaults.standard.object(forKey:"User_ColorCode")as! String)
                }
                
            }else{
                // self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0/255, green: 78/255, blue: 145/255, alpha: 1)
                if #available(iOS 13.0, *) {
                    let appearance = UINavigationBarAppearance()
                    appearance.configureWithDefaultBackground()
                    appearance.backgroundColor = UIColor.init(red: 0/255, green: 78/255, blue: 145/255, alpha: 1)
                    navigationController?.navigationBar.prefersLargeTitles = false
                    navigationController?.navigationBar.standardAppearance = appearance
                    navigationController?.navigationBar.scrollEdgeAppearance = appearance
                }else {
                    // Fallback on earlier versions
                    self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0/255, green: 78/255, blue: 145/255, alpha: 1)
                }
            }
        }
        if UserDefaults.standard.string(forKey: "Token") == nil{
            //user is not logged in
        }else{
            let acToken = String(format:"%@",UserDefaults.standard.string(forKey: "Token")!)
            
            if acToken.count == 0 {
                //user is not logged in
            }else{
                let rightButton = UIBarButtonItem.init(customView: self.rightBarButton())
                self.navigationItem.rightBarButtonItem = rightButton
                
            }
        }
        
    }
    func rightBarButton() -> UIButton {
        let bBtn = UIButton()
        
        bBtn.frame = CGRect(x:0,y:0,width: 40,height:40)
        bBtn.setImage(UIImage.init(named: "user_profile.png"),for:.normal)
        
        bBtn.addTarget(self, action:#selector(self.showOptionActionSheet), for: .touchUpInside)
        
        return bBtn
        
    }
    @objc func showOptionActionSheet(sender: UIButton){
        
        self.showActionSheet(senderBtn: sender)
    }
    func showActionSheet(senderBtn:UIButton) {
        
        let defaults = UserDefaults.standard
        let UserName = defaults.string(forKey: "CandName")
        
        var msg = ""
        if defaults.string(forKey: "DivisionName") == nil{
            
            msg = String(format:"%@",UserName!)
            
        }else{
            
            msg = String(format:"%@\n%@", UserName! ,defaults.string(forKey: "DivisionName")!)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            let alert = UIAlertController(title: msg, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            
            alert.addAction(UIAlertAction(title: "Change Password", style: UIAlertAction.Style.default, handler: {(alert) in
                self.PushToChangePassword()
            }))
            alert.addAction(UIAlertAction(title: "Logout", style: UIAlertAction.Style.default, handler: {(alert) in
                self.resetDefaults()
                self.navigationController?.popToRootViewController(animated: true)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {(alert) in
            }))
            
            //            alert.view.tintColor = UIColor.green
            
            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
            
            // 2. check the idiom
            switch (deviceIdiom) {
                
            case .pad:
                if let popoverController = alert.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = senderBtn.frame
                    popoverController.permittedArrowDirections = []
                    self.present(alert, animated: true, completion: nil)
                    
                }
                break
            case .phone:
                self.present(alert, animated: true, completion: nil)
                break
            case .tv:
                print("tvOS style UI")
            default:
                print("Unspecified UI idiom")
            }
            
            
        })
    }
    //    func PushToChangePassword(){
    //        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    //
    //        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordSegue") as! ChangePasswordViewController
    //        self.navigationController?.pushViewController(nextViewController, animated: true)
    //
    //    }
    
    func PushToChangePassword(){
        
        
        //check if LaunchViewController is there on stack or not ,if present pop else push
        
        var isControllerExists = false
        
        var dashboardVC = UIViewController()
        
        if let viewControllers = self.navigationController?.viewControllers {
            
            for viewController in viewControllers {
                
                if viewController is ChangePasswordViewController {
                    print("Your controller exist")
                    dashboardVC = viewController
                    isControllerExists = true
                    break
                }
            }
            
        }
        
        if isControllerExists {
            
            self.navigationController?.popToViewController(dashboardVC, animated: true)
            
        }else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordSegue") as! ChangePasswordViewController
            nextViewController.isFromSigninPage = false
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
    }
    
    //    func PushToVC(segueIdentifier: String,vcTobePushed: UIViewController){
    //
    //
    //        //check if LaunchViewController is there on stack or not ,if present pop else push
    //
    //        var isControllerExists = false
    //
    //        var dashboardVC = UIViewController()
    //
    //        if let viewControllers = self.navigationController?.viewControllers {
    //
    //            for viewController in viewControllers {
    //
    //                if viewController is vcTobePushed {
    //                    print("Your controller exist")
    //                    dashboardVC = viewController
    //                    isControllerExists = true
    //                    break
    //                }
    //            }
    //
    //        }
    //
    //        if isControllerExists {
    //
    //            self.navigationController?.popToViewController(dashboardVC, animated: true)
    //
    //        }else{
    //            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    //
    //            let nextViewController = storyBoard.instantiateViewController(withIdentifier: segueIdentifier) as! vcTobePushed
    //
    //            self.navigationController?.pushViewController(nextViewController, animated: true)
    //
    //        }
    //    }
    
    @objc func goBack()
    {
        self.navigationController?.popViewController(animated: true)
        //TODO: WHile contineous tapping on back button,its going to sign in page
        //        var isControllerExists = false
        //
        //        var dashboardVC = UIViewController()
        //
        //        if let viewControllers = self.navigationController?.viewControllers {
        //
        //            for viewController in viewControllers {
        //
        //                if viewController is SigninViewController {
        //                    print("Your controller exist")
        //                    dashboardVC = viewController
        //                    isControllerExists = true
        //                    break
        //                }
        //            }
        //
        //        }
        //
        //        if isControllerExists {
        //
        ////            self.navigationController?.popToViewController(dashboardVC, animated: true)
        //
        //        }else{
        //            self.navigationController?.popViewController(animated: true)
        //
        //        }
    }
    @objc func goBack2()
    {
        
        var customPickerView = JPPickerView()
        customPickerView.removePickerViewFromSuperView()
        
        customPickerView = Bundle.main.loadNibNamed("JPPickerView", owner: self, options: nil)?[0] as! JPPickerView
        customPickerView.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
        customPickerView.showPickerViewOnSuperView(superView: (self.navigationController?.view)!, isDatePicker: true,minuteInterval: 0, isPortrait: self.isPortrait())
        
    }
    func popToDasboardPageDirectly(){
        
        
        
        var isControllerExists = false
        
        var dashboardVC = UIViewController()
        
        if let viewControllers = self.navigationController?.viewControllers {
            
            for viewController in viewControllers {
                
                if viewController is DashboardViewController {
                    print("Your controller exist")
                    dashboardVC = viewController
                    
                    isControllerExists = true
                    break
                }
            }
            
        }
        
        if isControllerExists {
            
            self.navigationController?.popToViewController(dashboardVC, animated: true)
            
        }else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DashboardSegue") as! DashboardViewController
            nextViewController.isFromDivisionPage = false
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
    }
    func backButton() -> UIButton {
        let bBtn = UIButton()
        
        bBtn.frame = CGRect(x:0,y:0,width: 40,height:40)
        bBtn.setImage(UIImage.init(named: "Back.png"),for:.normal)
        
        bBtn.addTarget(self, action:#selector(self.goBack), for: .touchUpInside)
        
        return bBtn
        
    }
    func menuBtn() -> UIButton {
        let bBtn = UIButton()
        
        bBtn.frame = CGRect(x:0,y:0,width: 40,height:40)
        bBtn.setImage(UIImage.init(named: "Menu"),for:.normal)
        
        bBtn.addTarget(self, action:#selector(self.goBack2), for: .touchUpInside)
        
        return bBtn
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        //        let modelName = UIDevice.current.modelName
        //        if modelName.contains("iPad") {
        //        }else{
        if let navigationBar = self.navigationController?.navigationBar {
            
            for lView in (navigationBar.subviews){
                
                if lView.tag == 100101{
                    lView.removeFromSuperview()
                }
            }
            titlelbl = UILabel.init(frame: CGRect(x: 55, y: 0, width: navigationBar.frame.width - 115, height: navigationBar.frame.height))
            titlelbl.text = ""
            titlelbl.textColor = UIColor.white
            titlelbl.textAlignment = .center
            titlelbl.backgroundColor = UIColor.clear
            titlelbl.numberOfLines = 0
            let modelName = UIDevice.current.modelName
            
            if modelName.contains("iPad") {
                titlelbl.font = UIFont.boldSystemFont(ofSize: 20)
                
            }else{
                titlelbl.font = UIFont.boldSystemFont(ofSize: 16)
                
            }
            titlelbl.tag = 100101
            navigationBar.addSubview(titlelbl)
            
            let sViews =  self.navigationController?.view.subviews
            
            if self is SigninViewController   || self is ForgotPasswordViewController || self is DivisionListViewController  {
                
                print("SigninViewController")
                for v in sViews!{
                    
                    if v.tag == Division_View_TAG{
                        v.removeFromSuperview()
                    }
                }
            }else{
                
                self.addDivisionNameOnTop()
            }
        }
        
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
    
    func addDivisionNameOnTop(){
        
        let defaults = UserDefaults.standard
        let sViews =  self.navigationController?.view.subviews
        
        if defaults.string(forKey: "DivisionName") == nil{
        }else{
            let msg  =  defaults.string(forKey: "DivisionName")
            var isSplashPresent = false
            
            for v in sViews!{
                //check if splashimage is there or not
                if v.tag == SplashImageView_TAG{
                    isSplashPresent = true
                    break
                }
            }//end of for loop
            if isSplashPresent == false{
                for v in sViews!{
                    
                    
                    if v.tag == Division_View_TAG{
                        v.removeFromSuperview()
                    }else{
                        var originY = Int((self.navigationController?.navigationBar.frame.size.height)!)
                        let orientation = UIDevice.current.orientation
                        
                        if self.isPortrait() == true{
                            originY = Int((self.navigationController?.navigationBar.frame.size.height)!) + 20
                            
                            if #available(iOS 11.0, *) {
                                if ((UIApplication.shared.keyWindow?.safeAreaInsets.top)! > CGFloat(0.0)) {
                                    originY = Int((self.navigationController?.navigationBar.frame.size.height)!) + Int((UIApplication.shared.keyWindow?.safeAreaInsets.top)!)
                                }
                            }
                            
                            
                            
                        }else{
                            let modelName = UIDevice.current.modelName
                            if modelName.contains("iPad") {
                                originY =  Int((self.navigationController?.navigationBar.frame.size.height)!) + 20
                            }else{
                                originY =  Int((self.navigationController?.navigationBar.frame.size.height)!)
                            }
                        }
                        switch orientation {
                        case .portrait, .portraitUpsideDown:
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.titlelbl.frame = CGRect(x: 55, y: 0, width: UIScreen.main.bounds.width - 115, height: 44)
                            })
                        case .landscapeLeft, .landscapeRight:
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.titlelbl.frame = CGRect(x: 55, y: 0, width: UIScreen.main.bounds.width - 115, height: 35)
                            })
                        default: break
                        }
                        
                        
                        let barView = UILabel.init(frame: CGRect(x:0,y:originY,width:Int(UIScreen.main.bounds.size.width),height:20))
                        barView.text = msg
                        barView.tag = Division_View_TAG
                        barView.textAlignment = .center
                        barView.font = UIFont.boldSystemFont(ofSize: 12)
                        let modelName = UIDevice.current.modelName
                        
                        if modelName.contains("iPad") {
                            barView.font = UIFont.boldSystemFont(ofSize: 16)
                        }
                        barView.textColor = UIColor.white
                        if defaults.string(forKey: "ColorCode") != nil {
                            barView.isHidden = false
                            barView.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
                        }else{
                            barView.isHidden = true
                        }
                        self.navigationController?.view.addSubview(barView)
                    }
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func imageWithImage(image:UIImage,scaledToSize newSize:CGSize)->UIImage{
        //viv- For Image size to alter
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysOriginal)
    }
    func addShadowToView(shadowView: UIView){
        
        shadowView.layer.shadowColor = UIColor.darkGray.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowRadius = 5.0
        shadowView.layer.masksToBounds = false
        shadowView.layer.shouldRasterize = true
        shadowView.layer.rasterizationScale = UIScreen.main.scale
        
        
        
        //
        
        //             // Shadow
        //            shadowView.layer.shadowColor = UIColor.black.cgColor
        //            shadowView.layer.shadowOpacity = 0.25
        //            shadowView.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        //            shadowView.layer.shadowRadius = 4.0
        //            shadowView.layer.shouldRasterize = true
        //            shadowView.layer.rasterizationScale = UIScreen.main.scale
        
        // Corner Radius
        //            shadowView.layer.cornerRadius = 10.0;
        //
    }
    func resetDefaults() {
        
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }
    func stringIsNilOrEmpty(aString: String) -> Bool { return (aString).isEmpty }
    //MARK: - SHOW ALERT
    public func ShowAlertMessage(message : String,title:String){
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(alert) in
                if message == self.Authorizarion_Message  || title == self.Authorizarion_Message{
                    self.resetDefaults()
                    self.navigationController?.popViewController(animated: true)
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
        })
        
    }
    
    //MARK: - ALert with Retry Button
    
    public func ShowAlertWithRetry(message : String,title:String){
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: {(alert) in
                self.CheckAPPVersion()
            }))
            
            self.present(alert, animated: true, completion: nil)
        })
        
    }
    
    func dateformatter(date: Double) -> String {
        
        let date1:Date = Date() // Same you did before with timeNow variable
        let date2: Date = Date(timeIntervalSince1970: date)
        
        let calender:Calendar = Calendar.current
        let components: DateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date1, to: date2)
        print(components)
        var returnString:String = ""
        if components.second! < 60 {
            returnString = "Just Now"
        }else if components.minute! >= 1{
            returnString = String(describing: components.minute) + " min ago"
        }else if components.hour! >= 1{
            returnString = String(describing: components.hour) + " hour ago"
        }else if components.day! >= 1{
            returnString = String(describing: components.day) + " days ago"
        }else if components.month! >= 1{
            returnString = String(describing: components.month)+" month ago"
        }else if components.year! >= 1 {
            returnString = String(describing: components.year)+" year ago"
        }
        return returnString
    }
    func getNextSunday(dateString : String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = dateFormat
        let myDate = dateFormatter.date(from: dateString)!
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: myDate)
        let sunDaydateString = dateFormatter.string(from: tomorrow!)
        print("your next Date is \(sunDaydateString)")
        return sunDaydateString
    }
    
    public func showToastWithMessage(message : String, duration: CGFloat)
    {
        
        self.navigationController?.view.makeToast(message, duration: TimeInterval(duration), position: .bottom, title: "", image: nil)
    }
    func describeComparison(date1: Date, date2: Date) -> String {
        
        //https://stackoverflow.com/questions/39018335/swift-3-comparing-date-objects
        
        var descriptionArray: [String] = []
        
        if date1 == date2 {
            descriptionArray.append("date1 == date2")
        }
        
        if date1 != date2 {
            
            if date1 < date2 {
                descriptionArray.append("date1 < date2")
            }
            
            if date1 > date2 {
                descriptionArray.append("date1 > date2")
            }
            
        }
        
        return descriptionArray.joined(separator: ",  ")
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: SERVER CALL
    
    func CheckAPPVersion() {
        
        print("***VIV Base VC is called***")
        
        let sViews =  self.navigationController?.view.subviews
        for v in sViews!{
            if v.tag == Division_View_TAG{
                v.removeFromSuperview()
            }
        }
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            
            let delegate = UIApplication.shared.delegate  as! AppDelegate
            
            delegate.isAPPVersionAPICalled = true
            
            JustHUD.shared.showInView(view: (self.view)!)
            
            //  if let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            //userid as String
            let versionnss = RestAPI.displayVersion
            let params :[String:String] = ["CWAAppVersion": versionnss,"CWAMobileOSType" : "IOS"]
            print("vivek the api version from basevc is ",params)
            RestAPI.getAppCurrentVersion(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getServerResponse(response:))
            
            //  }
        }else{
            
            self.ShowAlertWithRetry(message: InternetConnectionMessage, title: InternetConnectionTitle )
        }
    }
    
    func removeDivisionBarView(){
        let sViews =  self.navigationController?.view.subviews
        for v in sViews!{
            if v.tag == Division_View_TAG{
                v.removeFromSuperview()
            }
        }
    }
    
    func getServerResponse(response:AnyObject)->()
    {
        
        //First get the nsObject by defining as an optional anyObject
        // let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        
        //Then just cast the object as a String, but be careful, you may want to double check for nil
        let CurrentAppVersion = RestAPI.displayVersion//nsObject as! String
        print(CurrentAppVersion)
        
        
        JustHUD.shared.hide()
        self.removeDivisionBarView()
        print("viv the reponse from base vc is ",response)
        if response is String{
//            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OVK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            self.ShowAlertWithRetry(message: InternetConnectionMessage, title: InternetConnectionTitle )
            
        }else{
            
            let object = response as! JSON
            /*
             once it is approved in playstore i make it as 1 for IsInAppStore keymy side
             but you need to inform me once it is approved then i made it as 1
             
             */
            
            if object["IsInAppStore"].intValue == 1 || (object["IsInAppStore"].intValue == 0 && RestAPI.BaseUrl == RestAPI.DevelopmentURL){
                
                self.showAlertIfRequired(object)
                
                
            }
//            else if object["MessageStatus"].intValue == 0{
//                self.removeDivisionBarView()
//                
//                var message = object["Message"].stringValue
//                
//                if message.count == 0 {
//                    message = "New version of the app is available in the app store please update"//"There is some error"
//                }
//                
//                let alert = UIAlertController(title:"Update Available", message:message, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                    switch action.style{
//                    case .default:
//                        print("default")
//                        let url = URL(string: "https://apps.apple.com/us/app/client-mobile-access/id1349663964")
//                        if #available(iOS 10.0, *) {
//                            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
//                        } else {
//                            UIApplication.shared.openURL(url!)
//                        }
//                    case .cancel:
//                        print("cancel")
//                        
//                    case .destructive:
//                        print("destructive")
//                        
//                        
//                    }}))
//                self.present(alert, animated: true, completion: nil)
//                
//                
//                //self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
//                
//            }
            
//            else{
//
//                self.showAlertIfRequired(object)
//                
//                
//            }
            
        else if object["MessageStatus"].intValue == 0{
            self.removeDivisionBarView()
            
            var message = object["Message"].stringValue
            if message.count == 0 {
                message = "New version of the app is available in the app store please update"
            }
            
            let appStoreURL = object["App_Link"].stringValue  // ← FROM SERVER RESPONSE
            print("appURL:------- \(appStoreURL)")
            let alert = UIAlertController(title:"Update Available", message:message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    guard !appStoreURL.isEmpty, let url = URL(string: appStoreURL) else {
                        print("Invalid or missing AppStoreURL in response")
                        return
                    }
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                case .cancel:
                   print("cancel")

               case .destructive:
                   print("destructive")


               }}))
           self.present(alert, animated: true, completion: nil)


           //self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

       }
        else{

            self.showAlertIfRequired(object)


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
         "Popupmessage" : {
         "Status" : 1,
         "message" : "success"
         },
         */
        if UserDefaults.standard.object(forKey: "ContactId") != nil {
            //user is not logged in
            print("user is logged in")
        }else{
            print("user is not logged in")
        }
        if object["Popupmessage"]["Status"].intValue == 1 {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.splashImageView.removeFromSuperview()
                self.addDivisionNameOnTop()
            }
            
        }
        else if object["Popupmessage"]["Status"].intValue == 2 {
            
            
            if UserDefaults.standard.object(forKey: "ContactId") != nil {
                //user is  logged in
                self.loadAlertPopupWithObject1(object["PopupMessage"]["Status"].intValue, messageText: object["Popupmessage"]["message"].stringValue, popKeyToSend: object["Popupmessage"]["PopupKey"].stringValue, apiCallrequired: true)
            }else{
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.splashImageView.removeFromSuperview()
                    self.addDivisionNameOnTop()
                }
            }
            
            
            
        }
        else if object["Popupmessage"]["Status"].intValue == 3 {
            if UserDefaults.standard.object(forKey: "ContactId") != nil {
                //user is  logged in
                
                self.loadAlertPopupWithObject1(object["PopupMessage"]["Status"].intValue, messageText: object["Popupmessage"]["message"].stringValue, popKeyToSend: object["Popupmessage"]["PopupKey"].stringValue, apiCallrequired: false)
            }else{
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.splashImageView.removeFromSuperview()
                    self.addDivisionNameOnTop()
                }
            }
            
        }
        else if object["Popupmessage"]["Status"].intValue == 4 {
            if UserDefaults.standard.object(forKey: "ContactId") != nil {
                //user is  logged in
                self.loadAlertPopupWithObject1(object["PopupMessage"]["Status"].intValue, messageText: object["Popupmessage"]["message"].stringValue, popKeyToSend: object["Popupmessage"]["PopupKey"].stringValue, apiCallrequired: true)
            }else{
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.splashImageView.removeFromSuperview()
                    self.addDivisionNameOnTop()
                }
            }
        }
        else{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.splashImageView.removeFromSuperview()
                self.addDivisionNameOnTop()
            }
        }
        
    }
    
    func loadAlertPopupWithObject1(_ viewStatus: Int, messageText: String, popKeyToSend: String, apiCallrequired: Bool)
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
        window.bringSubviewToFront(formView)
    }
    
    
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        
        
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            DispatchQueue.main.async(execute: { () -> Void in
                self.addDivisionNameOnTop()
                self.titlelbl.frame = CGRect(x: 55, y: 0, width: UIScreen.main.bounds.width - 115, height: 44)
                
            })
        case .portraitUpsideDown:
            text="PortraitUpsideDown"
            self.titlelbl.frame = CGRect(x: 55, y: 0, width: UIScreen.main.bounds.width - 115, height: 44)
            
        case .landscapeLeft:
            text="LandscapeLeft"
            DispatchQueue.main.async(execute: { () -> Void in
                self.addDivisionNameOnTop()
                self.titlelbl.frame = CGRect(x: 55, y: 0, width: UIScreen.main.bounds.width - 115, height: 35)
            })
        case .landscapeRight:
            text="LandscapeRight"
            DispatchQueue.main.async(execute: { () -> Void in
                self.addDivisionNameOnTop()
                self.titlelbl.frame = CGRect(x: 55, y: 0, width: UIScreen.main.bounds.width - 115, height: 35)
                
            })
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
        
    }
    
    //MARK: - Reverse Geo code
    
    func reverseGeoCode(lat: Double, long: Double) -> String
    {
        
        
        DispatchQueue.global(qos:.userInitiated).async {
            
            let urlString = String(format:"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&key=AIzaSyD6xpmUz94TVR3hUjKYEuBSILJJJoP70HQ",lat,long)
            
            var request = URLRequest(url: URL(string:urlString)!)
            request.httpMethod = "POST"
            let postString: String = String(format:"")
            
            request.httpBody = postString.data(using: .utf8)
            
            URLSession.shared.dataTask(with:request) { (data, response, error) in
                if error != nil
                {
                    print("error is ",error!)
                }
                else
                {
                    let  json = JSON(data!)
                    //                    print("********Address********",json)
                    OperationQueue.main.addOperation
                    {
                        
                        if json["results"].null == nil{
                            let results = json["results"]
                            if results.count > 0{
                                self.address =  json["results"][0]["formatted_address"].stringValue
      
                                print("The address found with lat and long is",self.address)
                                self.addToSend = self.address
                            }
                        }
                    }
                }
            }.resume()
            
        }

        return address
    }

    
    //viv
    
    func reverseGeoCode1(lat: Double, long: Double, completion: @escaping (String?) -> Void)
    {
        
        
        DispatchQueue.global(qos:.userInitiated).async {
            
            let urlString = String(format:"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&key=AIzaSyD6xpmUz94TVR3hUjKYEuBSILJJJoP70HQ",lat,long)
            
            var request = URLRequest(url: URL(string:urlString)!)
            request.httpMethod = "POST"
            let postString: String = String(format:"")
            
            request.httpBody = postString.data(using: .utf8)
            
            URLSession.shared.dataTask(with:request) { (data, response, error) in
                if error != nil
                {
                    print("error is ",error!)
                }
                else
                {
                    let  json = JSON(data!)
                    //                    print("********Address********",json)
                    OperationQueue.main.addOperation
                    {
                        
                        if json["results"].null == nil{
                            let results = json["results"]
                            if results.count > 0{
                                self.address =  json["results"][0]["formatted_address"].stringValue
      
                                print("The address found with lat and long is",self.address)
                                completion(self.address)
                            }
                        }
                    }
                }
            }.resume()
            
        }
    }

    
    //end
    
    ///////////***************** SHOW SIDE MENU IN ALL PAGES ********************////////////////
    
    
    //    func showLeftSideMenu(){
    //
    //        let screenWidth = UIScreen.main.bounds.size.width
    //        let screenHeight = UIScreen.main.bounds.size.height
    //        bgSideView.frame = CGRect(x: 0,y:0,width:screenWidth,height:screenHeight)
    //
    //        let sideTableView = UITableView()
    //        sideTableView.frame = CGRect(x: 0,y:0,width:screenWidth - 200,height:screenHeight)
    //        bgSideView.backgroundColor = UIColor.red
    //        bgSideView.addSubview(sideTableView)
    //
    //
    //        let tap = UITapGestureRecognizer(target: self, action: #selector(self.sideMenuTapGestureRecognizer))
    //        tap.delegate = self
    //        bgSideView.addGestureRecognizer(tap)
    //
    //
    //
    //    }
    //    @objc func sideMenuTapGestureRecognizer(sender: UITapGestureRecognizer?) {
    //        if bgSideView.isHidden == true {
    //            bgSideView.isHidden = false
    //        }else if bgSideView.isHidden == false {
    //            bgSideView.isHidden = true
    //        }
    //    }
    
    ///////////***************** END OF  SIDE MENU IN ALL PAGES ********************////////////////
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
//MARK:  CLASS EXTENSION  /////////////////////////////////

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue:      CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
extension UIImageView {
    public func imageFromServerURL(urlString: String) { //viv- To use image from server
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}
extension Date {
    var startOfWeek: Date {
        let date = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        let dslTimeOffset = NSTimeZone.local.daylightSavingTimeOffset(for: date)
        return date.addingTimeInterval(dslTimeOffset)
    }
    
    var endOfWeek: Date {
        return Calendar.current.date(byAdding: .second, value: 604799, to: self.startOfWeek)!
    }
    var sundayOfWeek: Date {
        
        return Calendar.current.date(byAdding: .day, value: 1, to: self.endOfWeek)!
        
    }
}

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    /// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster).
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        
        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[substringStartIndex ..< substringEndIndex])
    }
}

extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}
extension UILabel {
    func halfTextColorChange (fullText : String , changeText : String,textColor: UIColor ) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor , range: range)
        self.attributedText = attribute
    }
    func halfTextMakeToBold (fullText : String , changeText : String,textColor: UIColor ) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor , range: range)
        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15) , range: range)
        
        self.attributedText = attribute
    }
    func BoldAndUnderline(fullText : String , changeText : String,textColor: UIColor,fontSize: Int ) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor , range: range)
        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: CGFloat(fontSize)) , range: range)
        attribute.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range)
        self.attributedText = attribute
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
extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
}


extension UIApplication {
    class func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopMostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopMostViewController(base: presented)
        }
        return base
    }
   
}

extension BaseViewController: popAlertDelegate {
    func formStatus(success: Bool) {
        print(success)
        self.addDivisionNameOnTop()
        splashImageView.removeFromSuperview()
    }
}
//extension NSDictionary {
//    public var isNull: Bool {
//        get {
//            return self.type == .Null;
//        }
//    }
//}
/*
 HOSPITALITY
 65 Eden Hospitality NJ
 66 Eden Hospitality In-House
 111 TemPositions Hospitality Coat Check
 112 TemPositions Eden Hospitality LI
 126 Hospitality - CA
 
 SCHOOL PROFESSIONAL
 
 OFFICE
 TemPositions Office Division = 2
 TemPositions Office Melville = 45
 TemPositions Office Westchester =67
 Health Homes - NYC Office = 121
 */

