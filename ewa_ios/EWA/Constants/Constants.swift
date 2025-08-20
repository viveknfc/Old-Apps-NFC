//
//  Constants.swift
//  EWA
//
//  Created by NFC Solutions on 20/11/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON

class Constants {
    
    static var menuOptionNameArray : [String] = [String]()
    static let menuOptionImageNameArray : [String] = []
    static var dashObject:JSON = JSON.null
    static var menuObjj = [JSON]()
    static var menuHeaders = [String]() //
    static var titleImages = [String]() //
    static var menuParentMenuIDs = [Int]()
    static let APP_VERSION = ServerService.displayVersion
    static var version:Bool = true
    static var imagePicker = UIImagePickerController()
    static var imageMessage = "Picture uploaded successfully"
    static var menuSections = [[String]]() //
    static var menuSectionLogos = [[String]]() //
    static var naviLiteral = String()
    static var Token = String()
    static var ApiTimeOut = Int()
    static var Menu = String()
    static var FCMToken = String()
    static var PushData:JSON = JSON.null
    static var PushDataFromNotification = [String]()
    static var isScrSigned = -1
    static var isScrMessage = String()
    static var globalMessgae = String()
    static var globalMessageKey = -1
    static var isETCCheck = String()
    static var PushNotificationStatus = -1
    static var PushNotificationMessage = String()
    static var PushNotificationPopup = -1
    
    static var globalPopupMessage = String()
    static var globalPopupStatus = -1
    static var globalPopupFormName = String()
    static var globalPopupFormLink = String()
    static var globalPopupKey = String()
    static var globalAlertStatus = -1
    static var globalLinkType = String()
    static var ErrorMessage = "Something is not right here, please try again later"
    static var locationAllowMessage = String()
    
    static var LinkText = String()
    static var LinkUrl = String()
    static var iSFormOkRequired = Bool()
    
    //UploadCredentialsData
    static var uploadCredsData:JSON = JSON.null
    static var credsList = [UploadCredList]()
    static var formList = [UploadCredList]()
    static var ASHTSkipStatus = Int()
    
    //eTimeClock
    static var eTimeClockOrderID = String()
    static var ETCcheck = String()
    static var ETCSelectedWeekend = String()
    static var ETCIsMultipleLunch = String()
    
    //A Series Names
    static var A1Form = "A1 Series"
    static var A2Form = "A2 Series"
    static var A3Form = "A3 Series"
    static var SCRName = "SCR Consent"
    
    static var PoliciesAndProcedures = "Policies and Procedures"
    static var DisclosureConsentForm = "Disclosure Consent Form"
    
    static var OCCConfidentiality = "OCC Confidentiality"
    
    static var SCRForm = "SCR Consent" //SCRConsent Form 1
    static var SCRConsent = "SCR" // SCRConsent Form 2
    
    //Additional Form
    static var DocGoConsent = "DocGo Consent" // viv newly added
    static var FCRACAForm = "FCRA CA Disclosure" // viv newly added
    static var FCRADisclosure = "FCRA Disclosure" // viv newly added
    static var FCRAAuthorization = "FCRA Authorization" // viv newly added
    static var FCRANYDisclosure = "FCRA NY Disclosure" // viv newly added
    static var WorkReference = "Work References" // viv newly added
    static var FairChanceForm = "Fair Chance Act Notice" // viv newly added
    static var eVerifyForm = "e Verify" // viv newly added
    static var I9Form = "I9 Form" // viv newly added
    static var BGCForm = "Background Clearance" // viv newly added
    static var CIForm = "Confidential Info" // viv newly added
    static var DTForm = "Drug Testing" // viv newly added
    static var HepBForm = "Hep B" // viv newly added
    static var StateTaxForm = "State Tax" // viv newly added
    static var TaxInfoW4Form = "Tax Info W4" // viv newly added
    static var CredentialsForm = "Credentials" // viv newly added
    static var ClinicalExperienceForm = "Clinical Experience" // viv newly added
    static var FLIForm = "FLI" // viv newly added
    static var CEPAForm = "CEPA" // viv newly added
    
    
    static var sign1 = String()
    static var signDate1 = String()
    
    static var sign2 = String()
    static var signDate2 = String()
    
    static var SCRSign1 = "SCRSign1"
    static var SCRSign2 = "SCRSign2"
    
    static var ShowStandAlone = Bool()
    static var ShowStandAloneFromDashBoard = Bool()
    // Color Codes
    static var info_Text = "Info"
       static var Warning_Text = "Warning"
       static var Success_Text = "Success"
       static var Danger_Text = "Danger"
       
       static var success_Color = "#3c763d"
       static var success_background_Color = "#dff0d8"
       static var success_border_Color = "#d6e9c6"
       
       static var info_Color = "#31708f"
       static var info_background_Color = "#d9edf7"
       static var info_border_Color = "#bce8f1"
       
       static var warning_Color = "#8a6d3b"
       static var warning_background_Color = "#fcf8e3"
       static var warning_border_Color = "#faebcc"
       
       static var danger_Color = "#a94442"
       static var danger_background_Color = "#f2dede"
       static var danger_border_Color = "#ebccd1"
    
    static var A1insertParams = [String:Any]()
    static var A2insertParams = [String:String]()
    static var SCRConsentInfoInsertParams = [String:String]()
    static var SCRConsentInsertParams = [String:Any]()
    
    static func showUp(event: UIEvent,viewController:UIViewController)
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
        FTPopOverMenu.showForEvent(event: event, with:Constants.menuOptionNameArray, done: { (selectedIndex) -> () in
            print(selectedIndex)
            if selectedIndex == 1 {
                
                viewController.performSegue(withIdentifier:"passwordSegue", sender: nil)
            }
            else if selectedIndex == 3
            {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let privacyViewController = mainStoryboard.instantiateViewController(withIdentifier: "pVC") as! PrivacyPolicyViewController
                privacyViewController.link = "https://apps.tempositions.com/TempositionsEWAAPI/Forms/PrivacyPolicy.pdf"
                privacyViewController.headerText = "Privacy Policy"
                Constants.iSFormOkRequired = false
                privacyViewController.isPush = true
                viewController.navigationController?.pushViewController(privacyViewController, animated: true)
                
            }
                
            else if selectedIndex == 4
            {
                Constants.menuHeaders.removeAll()
                Constants.menuSectionLogos.removeAll()
                Constants.menuSections.removeAll()
                Constants.menuObjj.removeAll()
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
                UIApplication.shared.keyWindow?.rootViewController = viewController
                
            }
            else if selectedIndex == 2
            {
                let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                    self.openCamera(viewController:viewController)
                }))
                
                alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                    self.openGallary(viewController:viewController)
                }))
                
                alert.addAction(UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil))
                
                viewController.present(alert, animated: true, completion: nil)
            }
        },cancel: {
            
        })
    }
    
    
    static func openCamera(viewController:UIViewController)
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            imagePicker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.modalPresentationStyle = .fullScreen
            viewController.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    static func openGallary(viewController:UIViewController)
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.modalPresentationStyle = .fullScreen
        viewController.present(imagePicker, animated: true, completion: nil)
    }
    
    // date conversion methods
    //function to get date
    static func getFormattedDate(string: String) -> String{
        if string.count>10
        {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.preferredLocale()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // This formate is input formated .
            let formateDate = dateFormatter.date(from: string)!
            dateFormatter.dateFormat = "MM/dd/yyyy" // Output Formated
            return dateFormatter.string(from: formateDate)
        }
        else
        {
            return string
        }
    }
    //function to get date
    static func getFormattedDateForPicker(string: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "MMM d, yyyy" // This formate is input formated .
        let formateDate = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "MM/dd/yyyy" // Output Formated
        return dateFormatter.string(from: formateDate)
    }
    //function to get date
    static func getFormattedDateForTimeSlips(string: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "MM/dd/yyyy" // This formate is input formated .
        let formateDate = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "dd  EEE" // Output Formated
        return dateFormatter.string(from: formateDate)
    }
    static func getFormattedDateForPersonalJob(string: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd" // This formate is input formated .
        let formateDate = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "MM/dd/yyyy" // Output Formated
        return dateFormatter.string(from: formateDate)
    }
    static func getFormattedDateForSearch(string: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "MM/dd/yyyy" // This formate is input formated .
        if dateFormatter.date(from:string) != nil
        {
            let formateDate = dateFormatter.date(from: string)!
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // Output Formated
            return dateFormatter.string(from: formateDate)
        }
        else
        {
            return string
        }
    }
    
    
    static func convertDate(string: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS" //input format
        if dateFormatter.date(from:string) != nil
        {
            let formateDate = dateFormatter.date(from: string)!
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss a" // Output Formated
            return dateFormatter.string(from: formateDate)
        }
        else
        {
            return string
        }
    }
    
    
    static func convertDateForPhoto(string: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS" //input format
        if dateFormatter.date(from:string) != nil
        {
            let formateDate = dateFormatter.date(from: string)!
            dateFormatter.dateFormat = "MM/dd/yyyy" // Output Formated
            return dateFormatter.string(from: formateDate)
        }
        else
        {
            return string
        }
    }
    
    
    
    
    
    
    
    static  func calculateHeight(inString:String,width:CGFloat) -> CGFloat {
        let messageString = inString
        let attributes : [NSAttributedStringKey : Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont.systemFont(ofSize:14.0)]
        
        let attributedString : NSAttributedString = NSAttributedString(string: messageString, attributes: attributes)
        
        let rect : CGRect = attributedString.boundingRect(with: CGSize(width:width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        let requredSize:CGRect = rect
        return requredSize.height
    }
    static  func calculateHeightWithFont(inString:String,width:CGFloat,font:UIFont) -> CGFloat {
        let messageString = inString
        let attributes : [NSAttributedStringKey : Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) :font]
        
        let attributedString : NSAttributedString = NSAttributedString(string: messageString, attributes: attributes)
        
        let rect : CGRect = attributedString.boundingRect(with: CGSize(width:width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        let requredSize:CGRect = rect
        return requredSize.height
    }
    
}
