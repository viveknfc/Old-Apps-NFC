//
//  AppDelegate.swift
//  EWA
//
//  Created by NFC Solutions on 09/10/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit
import SideMenuController
import IQKeyboardManagerSwift
//import Fabric
//import Crashlytics
import FacebookCore
import Firebase
import UserNotifications
import SwiftyJSON
import CoreLocation
import FirebaseMessaging
//import APScheduledLocationManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate,CLLocationManagerDelegate,APScheduledLocationManagerDelegate {
    
    var window: UIWindow?
    var TRACK_TIME = 90.0 // in seconds
    //varaiable declarations
    var locationManager = CLLocationManager()
    var json2: JSON = JSON.null
    var locationData:JSON = JSON.null
    private var manager: APScheduledLocationManager!
    
    // storyboardID literals shortcut
    var navigationLiterals = [["PJB":"Personal Job Bank"],["TIMESLIP":"Enter Timeslips"],["MSG":"Notifications"],["ASSM":"Assignments"],["ETC":"eTimeClock History"], ["eTIMECLOCK":"eTIMECLOCK"]]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        manager = APScheduledLocationManager(delegate: self)
        FirebaseApp.configure()
        // Fabric.with([Crashlytics.self])
        configureSideMenu_KeyBoard()
        configure_navigation()
        startMonitoringLocationManager()
        // enableBackgroundAppRefreshFor(application)
        if UserDefaults.standard.object(forKey: "significant") != nil {
            startMonitoringLocationManager()
        }
        else {
            APSlocation_Set_up()
        }
        
        if UserDefaults.standard.object(forKey: "token") != nil
        {
            if #available(iOS 13.0, *) {
                let barBackgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
                let appearance = UINavigationBarAppearance()
                appearance.configureWithDefaultBackground()
                appearance.backgroundColor = barBackgroundColor
                appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            } else {
                // Fallback on earlier versions
            }
        }
        
        configure_pushNotifications(application)
        
        print(UIDevice.current.name)
        
        UserDefaults.standard.set(1, forKey:"update")
        
        UIViewController.swizzle()
        
        return true
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("resignACTIVE")
        rest_timer()
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("applicationDidEnterBackground")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("applicationDidBecomeActive")
        restart_timer()
        //this will post the notification to update the location toggle in side menu controller
        NotificationCenter.default.post(name: Notification.Name("updateToggleButton"), object: nil)
        
        //storing default value as 1 to hit the api once when everytime app loads first
        //will make to zero when we don't to track the location
        UserDefaults.standard.set(1, forKey:"update")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        //locationManager.stopUpdatingLocation()
        //locationManager.startMonitoringSignificantLocationChanges()
        if UserDefaults.standard.object(forKey: "significant") != nil {
            startMonitoringLocationManager()
        }
        else {
            APSlocation_Set_up()
        }
        // startMonitoringLocationManager()
    }
    
    
    //facebook integration methods
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    func enableBackgroundAppRefreshFor(_ app: UIApplication){
        
        if (UIApplication.shared.backgroundRefreshStatus == .denied){
            
            //  ServerService.ShowAlertMessage(ErrorMessage: "", title: "", view: self)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                
                let alert = UIAlertController(title: "", message: "The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh", preferredStyle: .alert)
                let cancelButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(cancelButton)
                UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
            }
            
        }
        else if (UIApplication.shared.backgroundRefreshStatus == .restricted){
            let alert = UIAlertController(title: "", message: "The functions of this app are limited because the Background App Refresh is disable.To turn it on, go to Settings > General > Background App Refresh", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(cancelButton)
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
            
        }
        else {
            print("Background App Refresh is enabled")
        }
    }
    
    //this method will configure the sideMenu and keyborads
    func configureSideMenu_KeyBoard()
    {
        print("viv enters configureSideMenu_KeyBoard")
        // sideMenu and IQKeyboard configurations
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named:"menu")
        SideMenuController.preferences.drawing.sidePanelPosition = .overCenterPanelLeft
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        SideMenuController.preferences.drawing.sidePanelWidth = width/2+100
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .showUnderlay//.horizontalPan - viv changed for statusbar issue
        //SideMenuController.preferences.animating.transitionAnimator = FadeAnimator.self // viv hided this for statusbar issue
        SideMenuController.preferences.interaction.swipingEnabled = false
        IQKeyboardManager.shared.enable = true
        
        
    }
    
    //this method is used to check if the candidate is already logged in or not and will navigate to respective screens
    func configure_navigation()
    {
        if UserDefaults.standard.bool(forKey:"remember")
        {
            if UserDefaults.standard.object(forKey: "token") != nil
            {
                let cID = UserDefaults.standard.object(forKey: "cID") as! String+":"
                let Token = UserDefaults.standard.object(forKey: "token") as! String
                Constants.Token = cID+Token
                
                print("from app delegate we are navigating")
                
                // use below code
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier:"splash")
                Constants.menuOptionNameArray = [UserDefaults.standard.object(forKey:"CandName") as! String,"Change Password","Change Profile Picture","Privacy Policy","Logout"]
                self.window?.rootViewController = rootViewController
                
                //viv addded for test
                
//                if let ordersDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "eTIMECLOCK") as? OrderDetailViewController {
//                    
//                    // Create a navigation controller and set OrdersDetailViewController as its root view controller
//                    let navigationController = BaseNaviViewController(rootViewController: ordersDetailVC)
//                               
//                    // Make the navigation bar visible
//                    navigationController.isNavigationBarHidden = false
//                    navigationController.navigationBar.tintColor = .white
//                    navigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
//                    let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
//                    ordersDetailVC.navigationItem.leftBarButtonItem = backButton
//                    
//                    self.window?.rootViewController = navigationController
//
//                }
                
                //end

            }
        }
        else
        {
            
        }
        
    }
    
//    @objc func backButtonTapped() {
//        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier:"splash")
//        self.window?.rootViewController = rootViewController
//        }
    
    //push notifications methods
    //this method will configure the push notifications
    
    func configure_pushNotifications(_ application:UIApplication)
    {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        Constants.FCMToken = token!
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        let deviceTokenString = deviceToken.reduce("",{$0 + String(format:"%02X", $1)})
        print(deviceTokenString)
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("i am not available in simulator \(error)")
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("User Info === \(notification.request.content.userInfo)")
        print("viv the push notification trigerring from here")
        // Handle code here.
        //    let notificationData = notification.request.content.userInfo
        //               let message = notificationData["alert"]["body"]
        //  print(notificationData)
        completionHandler([UNNotificationPresentationOptions.sound , UNNotificationPresentationOptions.alert , UNNotificationPresentationOptions.badge])
        
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let json = JSON(userInfo)
        print("viv the json is printin frpm app delegate",json)
        update_notification_seen_status(notifcationId:json["notificationId"].intValue)
        let cID = UserDefaults.standard.object(forKey: "cID") as! String+":"
        let Token = UserDefaults.standard.object(forKey: "token") as! String
        Constants.Token = cID+Token
        
        Constants.menuOptionNameArray = [UserDefaults.standard.object(forKey:"CandName") as! String,"Change Password","Change Profile Picture","Privacy Policy","Logout"]
        
        if json["type"].stringValue == "ASSM" {
            print("OLD:::: type is ASSM")
            UserDefaults.standard.set("ASSM", forKey: "significant")
            UserDefaults.standard.synchronize()
            startMonitoringLocationManager()
        }
        
        else{
            
            print("OLD:::: type is \(json["type"].stringValue)")
            
            if let result = navigationLiterals.compactMap({$0[json["type"].stringValue]}).first {
                print(result) //->title of the other
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc1:SplashViewController = (storyboard.instantiateViewController(withIdentifier:"splash")) as! SplashViewController
                Constants.naviLiteral = result
                print("the constants.naviliteral is 337 ",result)
                Constants.PushData = json
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window!.rootViewController = vc1
            } else {
                print("no result")
            }
        }
        
    }    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void)  {
        // pull out the buried userInfo dictionary
        let userInfo = response.notification.request.content.userInfo
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        print(userInfo)
        
        let state =  UIApplication.shared.applicationState
        if state == UIApplicationState.inactive || state == UIApplicationState.background{
            print("Recived Background mode: \(userInfo)")
        }else if state == UIApplicationState.active {
            print("Recived Fore Ground: \(userInfo)")
        }else{
    
        }
        
        let json = JSON(userInfo)
        print("userNotificationCenter Called JSON",json)
        update_notification_seen_status(notifcationId:json["notificationId"].intValue)
        if (UserDefaults.standard.object(forKey: "cID") != nil) && (UserDefaults.standard.object(forKey: "token") != nil) {
            let cID = UserDefaults.standard.object(forKey: "cID") as! String+":"
            let Token = UserDefaults.standard.object(forKey: "token") as! String
            Constants.Token = cID+Token
            Constants.menuOptionNameArray = [UserDefaults.standard.object(forKey:"CandName") as! String,"Change Password","Change Profile Picture","Privacy Policy","Logout"]
        }
        if json["type"].stringValue == "ASSM" {
            print("NEW::::type is ASSM")
            UserDefaults.standard.set("ASSM", forKey: "significant")
            UserDefaults.standard.synchronize()
            startMonitoringLocationManager()
        } 
//        else if json["type"].stringValue == "eTIMECLOCK" {
//            // Navigate to ordersdetail page
//            print("NEW:::: type is eTIMECLOCK from 366")
//            
//            if let ordersDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "eTIMECLOCK") as? OrderDetailViewController {
//                Constants.naviLiteral = "ordersdetail"
//                Constants.PushData = json
//                
//                // Create a navigation controller and set OrdersDetailViewController as its root view controller
//                let navigationController = BaseNaviViewController(rootViewController: ordersDetailVC)
//                           
//                // Make the navigation bar visible
//                navigationController.isNavigationBarHidden = false
//                navigationController.navigationBar.tintColor = .white
//                navigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
//                
////                sideMenuController?.embed(centerViewController:navigationController, cacheIdentifier:"detailPage")
//                
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                appDelegate.window?.rootViewController = navigationController//ordersDetailVC
//
//            } else {
//                print("Failed to instantiate ordersdetail view controller")
//            }
//            
//            
//        }
        else {
            
            print("NEW::::type is \(json["type"].stringValue)")
            if let result = navigationLiterals.compactMap({$0[json["type"].stringValue]}).first {
                print("The result showing for navigation literals is ",result) //->title of the other
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc1:SplashViewController = (storyboard.instantiateViewController(withIdentifier:"splash")) as! SplashViewController
                Constants.naviLiteral = result
                print("the constants.naviliteral is",result)
                Constants.PushData = json
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window!.rootViewController = vc1
            } else {
                print("no result")
            }
            
        }
        
        // you must call the completion handler when you're done
        completionHandler()
    }
    
    //MARK:- Timer Methods
    //this method will reset th time when app enters the background
    
    func rest_timer()
    {
        if UserDefaults.standard.bool(forKey:"remember")
        {
            
        }
        else
        {
            if UserDefaults.standard.bool(forKey:"timeout")
            {
                if Constants.Token.count>0
                {
                    let date = Date()
                    UserDefaults.standard.set(date,forKey:"DateTimer")
                    TimeOutClass.sharedInstance.resetTimer()
                }
            }
        }
    }
    
    
    //this method will restart the timer again once entered into foreground
    
    func restart_timer()
    {
        if UserDefaults.standard.bool(forKey:"remember")
        {
            
        }
        else
        {
            if UserDefaults.standard.bool(forKey:"timeout")
            {
                if Constants.Token.count>0
                {
                    if let persistedDate = UserDefaults.standard.object(forKey: "DateTimer") as? Date {
                        let difference = Calendar.current.dateComponents([.second], from: persistedDate, to: Date())
                        let differenceSeconds = difference.second
                        print(differenceSeconds!)
                        if differenceSeconds! >= Constants.ApiTimeOut
                        {
                            Constants.Token = ""
                        }
                        else
                        {
                            TimeOutClass.sharedInstance.runTimer()
                        }
                    }
                }
            }
        }
    }
    
    
    
    //MARK:- Location Permissions
    //checks for location permission
    func checkLocationPermission() -> Bool
    {
        var access = Bool()
            
            if CLLocationManager.locationServicesEnabled()
            {
                switch(CLLocationManager.authorizationStatus())
                {
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Authorize.")
                    access = true
                    break
                case .notDetermined:
                    print("Not determined.")
                    access = false
                    break
                case .restricted:
                    print("Restricted.")
                    access = false
                    break
                case .denied:
                    print("Denied.")
                    access = false
                }
            }
        return access
    }
    
    
    //updates candidte location along with deviceid
    func updateLocation(lati:Double,longi:Double)
    {
        
        let params =
        ["CandidateId" : UserDefaults.standard.object(forKey: "cID") as! String,
         "latitude" : lati,
         "longitude" : longi,
         "Status" : 1,"DeviceId":"\(UIDevice.current.identifierForVendor!.uuidString.stripped)"] as [String : Any]
        print("This params from app delegate\(params)")
        getRequestWithToken(urlString:ServerService.BaseUrl+ServerService.UpdateLocation, params:params, method:"POST", accessToken:Constants.Token, acces:false, callback:self.getresponseForLocation(response:))
    }
    
    func getRequestWithToken(urlString:String,params:[String:Any],method:String,accessToken:String,acces:Bool,callback:@escaping(AnyObject)->())
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            
            if Constants.version
            {
                DispatchQueue.global(qos:.background).async {
                    
                    let config = URLSessionConfiguration.default
                    config.timeoutIntervalForRequest = TimeInterval(30)
                    config.timeoutIntervalForResource = TimeInterval(30)
                    let urlSession = Foundation.URLSession(configuration: config)
                    
                    
                    let urlString = urlString
                    var request = URLRequest(url: URL(string:urlString)!)
                    request.httpMethod = method
                    request.timeoutInterval = 30 
                    
                    if acces
                    {
                        request.setValue("Basic \(accessToken)", forHTTPHeaderField: "Authorization")
                    }
                    
                    let postString:[String:Any] = params
                    do {
                        request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
                        
                    } catch let error {
                        print(error.localizedDescription)
                    }
                    
                    //HTTP Headers
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("application/json", forHTTPHeaderField: "Accept")
                    
                    urlSession.dataTask(with:request) { (data, response, error) in
                        
                        if error != nil
                        {
                            
                            print("error is ",error!)
                            if error?._code ==  NSURLErrorTimedOut {
                                print("Time Out")
                                DispatchQueue.main.async {
                                    self.json2 = JSON.null
                                    callback(self.json2 as AnyObject)
                                }
                            }
                            else
                            {
                                DispatchQueue.main.async {
                                    self.json2 = JSON.null
                                    callback(self.json2 as AnyObject)
                                }
                            }
                            print("error is ",error!.localizedDescription)
                            
                        }
                        else
                        {
                            print(response!)
                            let httpResponse = response as? HTTPURLResponse
                            print("statusCode: \(httpResponse!.statusCode)")
                            if httpResponse!.statusCode == 417
                            {
                                DispatchQueue.main.async {
                                    self.json2 = JSON.null
                                }
                            }
                            else
                            {
                                self.json2 = JSON(data!)
                                print(self.json2)
                                OperationQueue.main.addOperation
                                {
                                    
                                    if self.json2["Message"].stringValue == "Authorization has been denied for this request."
                                    {
                                        DispatchQueue.main.async(execute: { () -> Void in
                                        })
                                    }
                                    else
                                    {
                                        callback(self.json2 as AnyObject)
                                    }
                                }
                            }
                        }
                    }.resume()
                    urlSession.finishTasksAndInvalidate()
                }
            }
            else
            {
                DispatchQueue.main.async {
                    self.json2 = JSON.null
                    callback(self.json2 as AnyObject)
                }
            }
        }
        else
        {
            DispatchQueue.main.async {
                self.json2 = JSON.null
                callback(self.json2 as AnyObject)
            }
        }
    }
    
    
    //getresponseForLocation Response
    func getresponseForLocation(response:AnyObject)->()
    {
        print(response)
        var locationResponse :JSON = JSON.null
        locationResponse = response as! JSON
        if locationResponse["MessageStatus"].intValue == 2
        {
            //if MessageStatus = 2 will make update to 0 we don't need to track the location
            UserDefaults.standard.set(0, forKey:"update")
            UserDefaults.standard.removeObject(forKey: "significant")
            UserDefaults.standard.synchronize()
            stopMonitoringLocationManager()
            
        }
        else {
            UserDefaults.standard.set("ASSM", forKey: "significant")
            UserDefaults.standard.synchronize()
            if CLLocationManager.significantLocationChangeMonitoringAvailable() {
                manager.startMonitoringSignificantLocationChanges()
            }
        }
    }
    
    //MARK:- Notification Handling
    //update candidate notification seen status
    func update_notification_seen_status(notifcationId:Int)
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            if (UserDefaults.standard.object(forKey: "cID") != nil) && notifcationId > 0 && (UserDefaults.standard.object(forKey:"CandName") != nil) {
                let params:[String:Any] = [
                    "CandId":UserDefaults.standard.object(forKey: "cID") as! String,
                    "PushnotificationsLogId":notifcationId,
                    "CandName":UserDefaults.standard.object(forKey:"CandName") as! String,
                    "Status":1,
                    "DeviceName":"\(deviceName())"+","+"\(UIDevice.current.name)",
                    "Source":"iOS"
                ]
                getRequestWithToken(urlString:ServerService.BaseUrl+ServerService.PushClicked, params:params, method:"POST",accessToken:"", acces:false, callback:getresponseForNotificationSeen(response:))
            }
        }
        else
        {
            
        }
    }
    
    func getresponseForNotificationSeen(response:AnyObject)->()
    {
        print("******* Response for the push notification seen *******",response)
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
    
    
    
    
    //MARK: LOCATION SERVICES CODE
    func APSlocation_Set_up()
    {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            manager.startUpdatingLocation(interval:TimeInterval(TRACK_TIME), acceptableLocationAccuracy: 100)
        }else{
            
            manager.requestAlwaysAuthorization()
            manager.startUpdatingLocation(interval:TimeInterval(TRACK_TIME), acceptableLocationAccuracy: 100)
        }
    }
    
    // This Method will help to get user location when app is not in use i.e Suspended/Terminated state
    // To Start the Significant Location Changes
    func startMonitoringLocationManager(){
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            manager.startUpdatingLocation(interval:TimeInterval(TRACK_TIME), acceptableLocationAccuracy: 100)
        }else{
            
            manager.requestAlwaysAuthorization()
            manager.startUpdatingLocation(interval:TimeInterval(TRACK_TIME), acceptableLocationAccuracy: 100)
        }
        
        if CLLocationManager.significantLocationChangeMonitoringAvailable() {
            manager.startMonitoringSignificantLocationChanges()
        }
    }
    
    // To Stop the Significant Location Changes
    func stopMonitoringLocationManager(){
        
        if CLLocationManager.significantLocationChangeMonitoringAvailable() {
            manager.stopMonitoringSignificantLocationChanges()
        }
    }
    
    func scheduledLocationManager(_ manager: APScheduledLocationManager, didFailWithError error: Error) {
        
    }
    
    func scheduledLocationManager(_ manager: APScheduledLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let l = locations.first!
        print("VIV from APP Delegate Launched",l)
        let access = checkLocationPermission()
        var Enable = Bool()
        var updateStatus = Int()
        if UserDefaults.standard.contains(key:"ShareLocation")
        {
            
        }
        else
        {
            UserDefaults.standard.set(true, forKey:"ShareLocation")
        }
        if UserDefaults.standard.contains(key:"update")
        {
            updateStatus = UserDefaults.standard.object(forKey:"update") as! Int
        }
        Enable = UserDefaults.standard.object(forKey:"ShareLocation") as! Bool
        if (UserDefaults.standard.object(forKey:"token") != nil&&access&&Enable&&updateStatus==1)
        {
            updateLocation(lati:l.coordinate.latitude,longi:l.coordinate.longitude)
        }
        else {
            if UserDefaults.standard.object(forKey: "significant") != nil {
                UserDefaults.standard.removeObject(forKey: "significant")
                UserDefaults.standard.synchronize()
                stopMonitoringLocationManager()
                
            }
            
        }
        let currentLocationObj = ["latitude": l.coordinate.latitude,
                                  "longitude": l.coordinate.longitude]
        
        UserDefaults.standard.set(currentLocationObj, forKey: "CurrentLocation")
        UserDefaults.standard.synchronize()
    }
    
    func scheduledLocationManager(_ manager: APScheduledLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    func getCurrentDateAndTime() -> String{
        let date111 = Date()
        let formatter111 = DateFormatter()
        formatter111.locale = Locale.preferredLocale()
        formatter111.dateFormat = "MM/dd/yyyy, hh:mm:ss aa"//"dd/MM/yyyy HH:mm:ss"
        let finalddd = formatter111.string(from: date111)
        return finalddd
    }
    
    //MARK:- Notifications checking
    
    func checkPushNotification(checkNotificationStatus isEnable : ((Bool)->())? = nil){
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                // Notifications are allowed
                isEnable?(true)
            }
            else {
                // Either denied or notDetermined
                isEnable?(false)
            }
        }
        
    }
    
    func askNotificationsPermission(){
        
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        
        Messaging.messaging().delegate = self
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    } }




