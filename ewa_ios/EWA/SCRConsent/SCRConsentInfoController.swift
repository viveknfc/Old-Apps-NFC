//
//  SCRConsentInfoController.swift
//  EWA
//
//  Created by NFC User on 8/2/21.
//  Copyright © 2021 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON

class SCRConsentInfoController: BaseViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var mainHeadingLabel: UILabel!
    @IBOutlet weak var signDateLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var signatureLabel: UILabel!
    @IBOutlet weak var infoTextLabel: UILabel!
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var pressToSignButton: UIButton!
    @IBOutlet weak var hereByText: UILabel!
    @IBOutlet weak var pressToSignBottom: NSLayoutConstraint! // 20 to 80
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    var object: JSON = JSON.null
    var SCRInfoObject: JSON = JSON.null
    var fromSideMenu = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coverView.isHidden = false
        
        delayWithSeconds(0.5) {
            self.getFormData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = object["FormName"].stringValue
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.title = ""
    }
    
    //MARK:- Get Form Data
    func getFormData()
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:self.view)
            print("***VIV SCRConsentInfoController Clicked***")
            let params =
                ["CandId" : UserDefaults.standard.object(forKey: "cID") as! String]  as [String : Any]
            print(params)
            ServerService.GetSCRForm(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.getSCRDataObject(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            
        }
        
    }
    
    // response from the server
    func getSCRDataObject(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        self.SCRInfoObject = response as! JSON
        print("****** SCR Info Data is ************\n",SCRInfoObject)
        
        //viv hiding started here
        
//        if SCRInfoObject["Status"].intValue == 1 {
//            coverView.isHidden = true
//            mainHeadingLabel.text = SCRInfoObject["MainHeading"].stringValue
//            headingLabel.text = SCRInfoObject["SubHeading"].stringValue
//
//            infoTextLabel.attributedText =  SCRInfoObject["Content"].stringValue.htmlToAttributedString!
//            confirmationLabel.attributedText = SCRInfoObject["ConformationInfo"].stringValue.htmlToAttributedString!
//            hereByText.attributedText = SCRInfoObject["HereByText"].stringValue.htmlToAttributedString!
//            nameTF.text = SCRInfoObject["ScrFormName"].stringValue
//            addressTF.text = SCRInfoObject["ScrFormAddress"].stringValue
//            infoTextLabel.font = UIFont.systemFont(ofSize: 14)
//            confirmationLabel.font = UIFont.systemFont(ofSize: 14)
//            hereByText.font = UIFont.systemFont(ofSize: 14)
//            //  self.SCRInfoObject["DontAllowEdit"].boolValue = true
//            if self.SCRInfoObject["DontAllowEdit"].boolValue {
//                //Signed Form
//                pressToSignBottom.constant = 80
//                submitButton.isHidden = false
//                nextButton.isHidden = false
//
//                nameTF.isEnabled = false
//                addressTF.isEnabled = false
//                pressToSignButton.isHidden = true
//                signDateLabel.text = "\(self.SCRInfoObject["ScrFormConsentSigDate"].stringValue)\nDate (month/day/year)"
//                signatureLabel.text = "\(self.SCRInfoObject["ScrFormConsentSigName"].stringValue)\nApplicant’s Signature"
//            }
//            else {
//                pressToSignBottom.constant = 20
//                submitButton.isHidden = true
//                nextButton.isHidden = true
//
//                nameTF.isEnabled = true
//                addressTF.isEnabled = true
//                pressToSignButton.isHidden = false
//                signDateLabel.text = "Date"
//                signatureLabel.text = "Signature"
//            }
//        }
//        else {
//            var messagee = String()
//            if SCRInfoObject["Message"].stringValue.count > 0 {
//                messagee = SCRInfoObject["Message"].stringValue
//            }
//            else {
//                messagee = "Something is not right here try again later"
//            }
//            ServerService.ShowAlertMessage(ErrorMessage:"", title: messagee, view:self)
//        }
        
        //viv - hiding stops here
        
        // viv - for SCR form added newly below
        
//        ServerService.hideProgressView()
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let privacyViewController = mainStoryboard.instantiateViewController(withIdentifier: "pVC") as! PrivacyPolicyViewController
        privacyViewController.link = SCRInfoObject["LinkURL"].string ?? ""
        privacyViewController.headerText = "SCR Form"
        Constants.iSFormOkRequired = false
        privacyViewController.isPush = true
        
        let navi = BaseNaviViewController(rootViewController:privacyViewController)
                        navi.navigationBar.tintColor = .white
                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"SCR Consent")
        
    }
    //MARK:- PressToSignClicked
    @IBAction func pressToSignClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,
                                      "LastName":SCRInfoObject["LastName"].stringValue,
                                      "ScrFormConsentSigName":SCRInfoObject["ScrFormConsentSigName"].stringValue,
                                      "ScrFormConsentSigDate":SCRInfoObject["ScrFormConsentSigDate"].stringValue,
                                      "ScrFormName":nameTF.text!,
                                      "FullName":SCRInfoObject["FullName"].stringValue,
                                      "FirstName":SCRInfoObject["FirstName"].stringValue,
                                      "Middle":SCRInfoObject["Middle"].stringValue,
                                      "Address":SCRInfoObject["Address"].stringValue,
                                      "ApplicantID":SCRInfoObject["ApplicantID"].stringValue,
                                      "ScrFormAddress":addressTF.text!,
                                      "AppVersion":"IOS,\(Constants.APP_VERSION)"]
        //  print(params)
        Constants.SCRConsentInfoInsertParams = params
        
        let window = UIApplication.shared.keyWindow!
        let formView = Bundle.main.loadNibNamed("A1SignView", owner: nil, options: nil)![0] as! A1SignView
        formView.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
        formView.setUp()
        formView.object = object
        formView.signDelegate = self
        window.makeKeyAndVisible()
        UIApplication.getTopMostViewController()!.view.addSubview(formView)
        UIApplication.getTopMostViewController()!.view.bringSubview(toFront:formView)
    }
    
    //MARK:- Submit&Next Button Actions
    
    @IBAction func submitClicked(_ sender: UIButton) {
        
        if ConnectionCheck.isConnectedToNetwork()
        {
            
            ServerService.showActivityIndicatory(uiView:self.view)
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.locale = Locale.preferredLocale()
            formatter.dateFormat = "MM/dd/yyyy hh:mm aa"
            let result = formatter.string(from: date)
            
            let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,
                                          "LastName":SCRInfoObject["LastName"].stringValue,
                                          "ScrFormConsentSigName":SCRInfoObject["ScrFormConsentSigName"].stringValue,
                                          "ScrFormConsentSigDate":result,
                                          "ScrFormName":nameTF.text!,
                                          "FullName":SCRInfoObject["FullName"].stringValue,
                                          "FirstName":SCRInfoObject["FirstName"].stringValue,
                                          "Middle":SCRInfoObject["Middle"].stringValue,
                                          "Address":SCRInfoObject["Address"].stringValue,
                                          "ApplicantID":SCRInfoObject["ApplicantID"].stringValue,
                                          "ScrFormAddress":addressTF.text!,
                                          "AppVersion":"IOS,\(Constants.APP_VERSION)"]
            print(params)
            ServerService.SubmitSCRForm(UIApplication.getTopMostViewController()!, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:UIApplication.getTopMostViewController()!)
        }
    }
    func getresponseFormResponse(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        let signedObjectResponse = response as! JSON
        print(signedObjectResponse)
        if signedObjectResponse["Status"].stringValue == "Success"
        {
            if ConnectionCheck.isConnectedToNetwork()
            {
                self.getFormData()
            }
            else
            {
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:UIApplication.getTopMostViewController()!)
            }
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage:"", title: signedObjectResponse["Message"].stringValue, view:UIApplication.getTopMostViewController()!)
        }
    }
    @IBAction func nextClicked(_ sender: UIButton) {
        
        let VC = SCRConsent(nibName: "SCRConsent", bundle: nil)
        VC.object = object
        VC.fromSideMenu = fromSideMenu
        self.navigationController?.pushViewController(VC, animated: true)
    }
}


extension SCRConsentInfoController:a1signatureDelagte
{
    func signatureStatus(success: Bool) {
        print("success")
        if fromSideMenu == true {
            self.getFormData()
        }
        else if Constants.Menu == "DashBoard" {
            let vc = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"message") as? MessagesViewController)!
            let navi = BaseNaviViewController(rootViewController:vc)
            navi.navigationBar.tintColor = .white
            navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"message")
            
        }
        else {
            let identifier = Constants.Menu
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateVC(withIdentifier: identifier) {
                let navi = BaseNaviViewController(rootViewController:viewController)
                navi.navigationBar.tintColor = .white
                navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                sideMenuController?.embed(centerViewController:navi, cacheIdentifier:identifier)
            }
        }
    }
    
}
