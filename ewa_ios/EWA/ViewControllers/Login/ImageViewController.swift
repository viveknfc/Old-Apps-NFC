////
//  ImageViewController.swift
//  EWA
//
//  Created by NFC Solutions on 09/01/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import MobileCoreServices


//below is the sample location tracking code

//import CoreLocation
//,CLLocationManagerDelegate
//locationManager.delegate = self
//
//locationManager.requestWhenInUseAuthorization()
//
//locationManager.desiredAccuracy = kCLLocationAccuracyBest
//
//locationManager.startUpdatingLocation()
//
//locationManager.startMonitoringSignificantLocationChanges()
//
//// Here you can check whether you have allowed the permission or not.
//
//if CLLocationManager.locationServicesEnabled()
//{
//    switch(CLLocationManager.authorizationStatus())
//    {
//
//    case .authorizedAlways, .authorizedWhenInUse:
//
//        print("Authorize.")
//
//        break
//
//    case .notDetermined:
//
//        print("Not determined.")
//
//        break
//
//    case .restricted:
//
//        print("Restricted.")
//
//        break
//
//    case .denied:
//
//        print("Denied.")
//    }
//}
//if let bundleId = Bundle.main.bundleIdentifier,
//    let url = URL(string: "\(UIApplicationOpenSettingsURLString)&path=LOCATION/\(bundleId)") {
//    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//}




class ImageViewController: UIViewController {
    
    //variable declarations
    var appVesrion: JSON = JSON.null
    
    @IBOutlet weak var versionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if ConnectionCheck.isConnectedToNetwork()
        {
            let params = ["EWAMobileOSType":"IOS","EWAAppVersion": Constants.APP_VERSION] as [String:Any] //Constants.APP_VERSION
            print("***VIV - the Image VC Parameters are /n\(params)")
            ServerService.getAccountGetAPiVersion(self, params: params, method: "POST", accessToken:"",acces:false, callBack:getresponseForVersion(response:))
        }
        else
        {
            
            ServerService.ShowAlertMessageforSplash(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      versionLabel.text = "v.\(Constants.APP_VERSION)"
    }
    
    //aftergettingResponseFrom the server
    func getresponseForVersion(response:AnyObject)->()
    {
        ServerService.splash = true
        appVesrion = response as! JSON
        print("***VIV the response from ImageVC is \(appVesrion)***")
        Constants.ApiTimeOut = appVesrion["APISessionTimeout"].intValue*60
        UserDefaults.standard.set(appVesrion["isTimeOut"].boolValue, forKey:"timeout")
        if appVesrion["App_Link"].stringValue.count>0
        {
            UserDefaults.standard.set(appVesrion["App_Link"].stringValue, forKey:"AppLink")
        }
        else
        {
            UserDefaults.standard.set("https://itunes.apple.com/us/app/employee-mobile-access/id1327851235?ls=1&mt=8", forKey:"AppLink")
        }
        if appVesrion.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessageforSplash(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if (appVesrion["IsInAppStore"].boolValue  || (!appVesrion["IsInAppStore"].boolValue && ServerService.BaseUrl == ServerService.DevelopmentURL) || appVesrion["IsInAppStore"].boolValue || (!appVesrion["IsInAppStore"].boolValue && ServerService.BaseUrl == ServerService.StagingURL))
        {
            takeToWebLink()
        }
        else
        {
            
            if appVesrion["MessageStatus"].exists()
            {
            if appVesrion["MessageStatus"].intValue == 0
            {
                Constants.version = false
                ServerService.ShowAlertMessageForUpdate(ErrorMessage:"New version of the app is available in the app store please update", title: "Update Available", view:self)
            }
            else
            {
                print("***VIV - messagestatus exists enters and in else clause***")
                takeToWebLink()
            }
            }
            else
            {
                
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    func takeToWebLink() {
        
        print("***VIV taketoweblink called***")

            Constants.version = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.performSegue(withIdentifier:"splashSegue", sender:nil)
            }
    }
    
    
    
    

    
// //sample document picker code
//    
//    
//    @IBAction func chck(_ sender: Any) {
//
//
//        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes:[String(kUTTypeContent)], in: UIDocumentPickerMode.import)
//        documentPicker.delegate = self
//        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
//        self.present(documentPicker, animated: true, completion: nil)
//
//    }
//
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
//        if controller.documentPickerMode == UIDocumentPickerMode.import {
//            // This is what it should be
//        }
//    }
//    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
//
//    }
    
}
