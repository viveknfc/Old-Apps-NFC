//
//  AppDelegate.swift
//  CWA
//
//  Created by NFC Solutionsusa on 01/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//myProgrammaticView.translatesAutoresizingMaskIntoConstraints = NO;
//https://medium.freecodecamp.org/how-to-use-touch-id-for-a-quicker-easier-login-to-your-app-e22356c9ef9
//260542
/*
 <string>5H3X3V9Z4M.com.nfcsolutions.cwaapp</string>
 com.nfcsolutions.cwaapp - NFC ACCOUNT
 */

/*
 //com.tempositions.cwa - Kevin Account
 <string>9W2GMX4LS3.com.tempositions.cwa</string>
 //prasadkopanati
 */
import UIKit
import IQKeyboardManagerSwift
import Fabric
import GoogleMaps
import Firebase

  let Google_API_Key = "AIzaSyDR_Wes2kgp2NcA3wRtM3w8JhBYmjxjQ74"
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var isAPPVersionAPICalled = false
    
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        
        print("Call location from app delegate")
        CMALocationManager.shared.requestLocationAtOnce()
        
        GMSServices.provideAPIKey(Google_API_Key)
 
//        Fabric.with([Crashlytics.self])
        //IQKeyboardManager.shared.enable = true
        //        DispatchQueue.global().async {
        //            do {
        //                let update = try self.isUpdateAvailable()
        //                print(update)
        //            } catch {
        //                print(error)
        //            }
        //        }
        //        UINavigationBar.appearance().barTintColor = UIColor.orange
        
       
        FirebaseApp.configure()
        UIViewController.swizzle()

        return true
    }
    func setCrashException(){
        NSSetUncaughtExceptionHandler { exception in
            print("Error Handling: ", exception)
            print("Error Handling callStackSymbols: ", exception.callStackSymbols)
            
            UserDefaults.standard.set(exception.callStackSymbols, forKey: "ExceptionHandler")
            UserDefaults.standard.synchronize()
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
        print("applicationWillResignActive")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")

        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("applicationWillTerminate")
    }
    
  /*  func isUpdateAvailable() throws -> Bool {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
        }
        let data = try Data(contentsOf: url)
        guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
            throw VersionError.invalidResponse
        }
        if let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String {
            return version != currentVersion
        }
        throw VersionError.invalidResponse
    } */
    enum VersionError: Error {
        case invalidResponse, invalidBundleInfo
    }
    //    func application(application: UIApplication, willChangeStatusBarFrame newStatusBarFrame: CGRect) {
    //        let windows = UIApplication.sharedApplication().windows
    //
    //        for window in windows {
    //            window.removeConstraints(window.constraints)
    //        }
    //
    //    }
}

extension UIViewController {
    @objc dynamic func _tracked_viewWillAppear(_ animated: Bool) {
      //  NSLog("Enter screen: \(type(of: self))")
        print("CMA@ScreenName:--> "+String(describing: type(of: self)))
        _tracked_viewWillAppear(animated)
    }

    static func swizzle() {
        //Make sure This isn't a subclass of UIViewController,
        // So that It applies to all UIViewController childs
        if self != UIViewController.self {
            return
        }
        let _: () = {
            let originalSelector =
                #selector(UIViewController.viewWillAppear(_:))
            let swizzledSelector =
                #selector(UIViewController._tracked_viewWillAppear(_:))
            let originalMethod =
                class_getInstanceMethod(self, originalSelector)
            let swizzledMethod =
                class_getInstanceMethod(self, swizzledSelector)
            method_exchangeImplementations(originalMethod!, swizzledMethod!);
        }()
    }
}
