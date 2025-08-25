//
//  SafteyGuidlinesController.swift
//  CWA
//
//  Created by NFC User on 6/16/20.
//  Copyright © 2020 NFC Solutionsusa. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON


class SafteyGuidlinesController: BaseViewController,WKNavigationDelegate {
    
    @IBOutlet weak var webBGView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var signedLabel: UILabel!
    
    @IBOutlet weak var agreementBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    var webView: WKWebView!
    var htmlStringToLoad = ""
    var EuaId = ""
    var checkAgreementMsg = ""
    var isSuccessMessage = false
    var selectedMenuId = -1
    var selectedMenuName = ""
    var Agrementfooter = ""
    var titleName = String()
    var showSkipButton = String()
    var isFromSafetey = Bool()
    
    var IsAgree = ""
    
    @IBOutlet weak var submitButtonCenter: NSLayoutConstraint! // -78 to 0
    
    @IBOutlet weak var skipButton: ShadowButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if showSkipButton == "1" {
            if isFromSafetey {
                skipButton.isHidden = true
                submitButtonCenter.constant = 0
                
            }
            else{
                skipButton.isHidden = false
                submitButtonCenter.constant = -78
            }
        }
        else{
            skipButton.isHidden = true
            submitButtonCenter.constant = 0
        }
        
        if IsAgree == "1"{
            
            self.AlreadyApprovedView(message: Agrementfooter)
        }else{
            agreementBtn.setTitle(Agrementfooter, for: .normal)
            signedLabel.text = ""
            signedLabel.backgroundColor = UIColor.clear
            bottomView.isHidden = false
            if Agrementfooter.count == 0{
                var agreementBtnText = "By checking this box, I certify that I accept these terms and conditions and am authorized to sign on behalf of my company"
                let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
                if DivisionId == "92" || DivisionId == "50" || DivisionId == "102"{
                    agreementBtnText = "By checking this box, I certify that I accept these terms and conditions and am authorized to sign on behalf of my school"
                }else if DivisionId == "132" {
                    agreementBtnText = "By checking this box I certify that I am duly authorized to sign on behalf of the CLIENT and accept these terms and conditions."
                }
                agreementBtn.setTitle(agreementBtnText, for: .normal)
            }
        }
        webView = WKWebView()
        
        webView.frame = CGRect(x:0,y:0,width:webBGView.frame.size.width,height:webBGView.frame.size.height)
        
        webView.navigationDelegate = self
        
        webBGView.addSubview(webView)
        
        setupWKWebViewConstraints()
        
        agreementBtn.isSelected = false
        
        
        
    }
    func AlreadyApprovedView(message: String){
        DispatchQueue.main.async(execute: { () -> Void in
            self.bottomView.isHidden = true
            let text = String(format:"%@  %@","\u{2713}",message)
            let strNumber: NSString = text as NSString
            let range = (strNumber).range(of: "\u{2713}")
            let attribute = NSMutableAttributedString.init(string: text)
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: self.success_Color) , range: range)
            attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 30) , range: range)
            self.signedLabel.attributedText = attribute
            self.signedLabel.textColor = UIColor(hexString: self.success_Color)
            self.signedLabel.backgroundColor = UIColor(hexString:self.success_background_Color)
            
        })
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titlelbl.text = titleName
        
        
    }
    func setupWKWebViewConstraints() {
        
        let paddingConstant:CGFloat = 5.0
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        webView.topAnchor.constraint(equalTo: webBGView.topAnchor, constant: paddingConstant).isActive = true
        webView.bottomAnchor.constraint(equalTo: webBGView.bottomAnchor, constant: -paddingConstant).isActive = true
        webView.leadingAnchor.constraint(equalTo: webBGView.leadingAnchor, constant: paddingConstant).isActive = true
        webView.trailingAnchor.constraint(equalTo: webBGView.trailingAnchor, constant: -paddingConstant).isActive = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( animated )
        
        if htmlStringToLoad.count == 0 {
            
        }else{
            JustHUD.shared.showInView(view: (self.view)!)
            
            webView.loadHTMLString(htmlStringToLoad, baseURL: nil)
        }
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func agreeButtonAction(_ sender: UIButton){
        
        if agreementBtn.isSelected == true{
            agreementBtn.isSelected = false
        }else{
            agreementBtn.isSelected = true
        }
    }
    //MARK:- Submit Button Action
    @IBAction func submitButtonAction(_ sender: UIButton){
        if agreementBtn.isSelected ==  true{
            
            self.approveSafteyGuidlines()
        }else{
            if checkAgreementMsg.count == 0{
                // checkAgreementMsg = " Please check the box below to sign \"Employee Usage Agreement\" "
                checkAgreementMsg = " Please check the box below to sign \"\(titleName)\" "
            }
            //            self.ShowAlertMessage(message: checkAgreementMsg, title: "")
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: checkAgreementMsg, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    
    //MARK:- Skip Button Action
    @IBAction func skipClicked(_ sender: ShadowButton) {
        
        // self.approveEmpAgreementCall()
        
        if selectedMenuId == Get_TS_YouHave_Approved_Menu_Id {
            //TS You have Approved
            
            self.pushToTSYouHaveApprovedPage()
        }else  if selectedMenuId == 32  || selectedMenuId == 33 || selectedMenuId == 34 {
            //approve time slips
            // 33 ==
            self.pushToApproveTimeSlipPage()
        }else  if selectedMenuId == Enter_TS_Menu_Id {
            //enter e timeslip
            self.pushToEnterTimeSlipPage()
            
        }else  if selectedMenuId == HOS_Group_TS_Menu_Id {
            
            self.pushToHospitalityGroupTSPage()
            
        }
        else  if selectedMenuId == Client_Invoice_Menu_Id {
            
            self.pushToClientInvoicePage()
            
        }
        else if selectedMenuId == 40 {
            //eTime Clock
            self.pushToeTimeClockPage()
        }
        else if selectedMenuId == Payment_Informatio_Id {
            self.pushToCashApplicationPage()
        }
    }
    
    func pushToCashApplicationPage(){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is ClientInvoiceViewController {
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CashApplicationController") as! CashApplicationController
             nextViewController.isFromSafety = true
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        //        let screen = self.storyboard?.instantiateViewController(withIdentifier: "CashApplicationController") as! CashApplicationController
        //        self.navigationController?.pushViewController(screen, animated: true)
    }
    func pushToClientInvoicePage(){
        
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is ClientInvoiceViewController {
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ClientInvoiceSegue") as! ClientInvoiceViewController
            nextViewController.isFromSafety = true
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    
    //MARK:- WebView Methods
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        print("didFinish")
        JustHUD.shared.hide()
        
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        JustHUD.shared.hide()
        
        print(error.localizedDescription)
    }
    func pushToApproveTimeSlipPage(){
        //        self.PushToEmpUsageAgreementPage()
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is ApproveTimeSlipViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ApproveTimeSlipSegue") as! ApproveTimeSlipViewController
            nextViewController.willShowNoteAlert = "1"
            nextViewController.isFromSafety = true
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func approveSafteyGuidlines() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            
            let defaults = UserDefaults.standard
            let  ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let DivisionId = String(format:"%d", defaults.integer(forKey: "DivisionId"))
            
            //userid as String
            
            //userid as String
            let params :[String:String] = ["ContactId":ContactId,"ClientID":clientID,"DivisionId":DivisionId,"EuaId":EuaId,
                                           "OSSource": "iOS"]
            
            RestAPI.SubmitSafetyGuideline(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
            
        }else{
            
            //            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
            isSuccessMessage = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    
    func getResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            
            //            self.ShowAlertMessage(message: response as! String, title: "")
            isSuccessMessage = false
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            let object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                
                let msg = object["Message"].stringValue
                
                //  if msg.count == 0{
                
                if selectedMenuId == Get_TS_YouHave_Approved_Menu_Id {
                    //TS You have Approved
                    
                    self.pushToTSYouHaveApprovedPage()
                }else  if selectedMenuId == 32  || selectedMenuId == 33 || selectedMenuId == 34 {
                    //approve time slips
                    // 33 ==
                    self.pushToApproveTimeSlipPage()
                }else  if selectedMenuId == Enter_TS_Menu_Id {
                    //enter e timeslip
                    self.pushToEnterTimeSlipPage()
                    
                }else  if selectedMenuId == HOS_Group_TS_Menu_Id {
                    
                    self.pushToHospitalityGroupTSPage()
                    
                }
                else  if selectedMenuId == Client_Invoice_Menu_Id {
                    
                    self.pushToClientInvoicePage()
                    
                }
                else if selectedMenuId == Payment_Informatio_Id {
                    self.pushToCashApplicationPage()
                }
                else if selectedMenuId == 40 {
                    //eTime Clock
                    self.pushToeTimeClockPage()
                }
                else {
                    isSuccessMessage = true
                    self.AlreadyApprovedView(message: msg)
                    
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: msg, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                }
                
                /* }else{
                 /*
                 {
                 "MessageStatus" : "1",
                 "Content" : null,
                 "DivisionId" : 100,
                 "ActionName" : null,
                 "IsAgree" : "1",
                 "EuaId" : 4,
                 "Message" : "We have recorded that you have accepted the above terms and conditions",
                 "ClientId" : 70956,
                 "ContactId" : 195308,
                 "AgreementText" : null
                 }
                 */
                 isSuccessMessage = true
                 self.AlreadyApprovedView(message: msg)
                 
                 self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: msg, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                 }*/
            }else{
                
                var message = object["message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                isSuccessMessage = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                //            RestAPI.ShowAlertMessage(ErrorMessage: message, titleMessage: " ", view: self)
            }
        }
    }
    @IBAction override func okButtonTapped(_ sender: Any) {
        //    self.alertController.dismiss(animated: true, completion: nil)
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
        if isSuccessMessage == true{
            if selectedMenuId == 35 {
                //TS You have Approved
                
                self.pushToTSYouHaveApprovedPage()
            }else  if selectedMenuId == 32  || selectedMenuId == 33 || selectedMenuId == 34 {
                //approve time slips
                self.pushToApproveTimeSlipPage()
            }else  if selectedMenuId == 31 {
                //enter e timeslip
                
                self.pushToEnterTimeSlipPage()
                
            }else  if selectedMenuId == HOS_Group_TS_Menu_Id {
                
                self.pushToHospitalityGroupTSPage()
                
            }
            else if selectedMenuId == 40 {
                //eTime Clock
                self.pushToeTimeClockPage()
            }
            else  if selectedMenuId == Client_Invoice_Menu_Id {
                
                self.pushToClientInvoicePage()
                
            }
            else if selectedMenuId == Payment_Informatio_Id {
                self.pushToCashApplicationPage()
            }
        }
    }
    
    
    func pushToeTimeClockPage(){
        
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is eTimeClockViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "eTimeClockViewSegue") as! eTimeClockViewController
            nextViewController.menuTitle = selectedMenuName
            nextViewController.isFromSafety = true
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        
    }
    func pushToEnterTimeSlipPage(){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is EnterTimeSlipViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Enter Timeslips") as! EnterTimeSlipViewController
            nextViewController.menuName = selectedMenuName
            nextViewController.isFromSafety = true
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    func pushToTSYouHaveApprovedPage(){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is ApprovedTSViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ApprovedTSSegue") as! ApprovedTSViewController
            nextViewController.menuTitle = selectedMenuName
            nextViewController.isFromSafety = true
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    func pushToHospitalityGroupTSPage(){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is HospitalityGroupTSViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HospitalityGroupTSSegue") as! HospitalityGroupTSViewController
            
            nextViewController.isFromSafety = true
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
        
        
    }
    
}

