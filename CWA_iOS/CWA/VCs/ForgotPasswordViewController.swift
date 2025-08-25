//
//  ForgotPasswordViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 02/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON

class ForgotPasswordViewController: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet var fscrollView: UIScrollView!
    
    @IBOutlet weak var captchaLabel: UILabel!
    @IBOutlet weak var captchaRefresh: UIButton!
    @IBOutlet weak var enterCaptcha: UITextField!
    
    var generatedCaptcha = ""
    
    var object: JSON = JSON.null
    var isSuccessMessage = false
    var isErrorMessage = false
    @IBOutlet weak var whiteBGSuperViewHeightConstraint: NSLayoutConstraint!
    
    var activeField: UITextField?
    @IBOutlet var userNameTextField: NiceTextField!
    @IBOutlet var whiteBGView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titlelbl.text = "Forgot Password"
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = UIColor.init(red: 0/255, green: 78/255, blue: 145/255, alpha: 1)
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        else {
            self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0/255, green: 78/255, blue: 145/255, alpha: 1)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.title = "Forgot Password"
        NotificationCenter.default.addObserver(self, selector: #selector(ForgotPasswordViewController.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ForgotPasswordViewController.keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.automaticallyAdjustsScrollViewInsets = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.whiteBGViewTapGesture))
        tap.delegate = self
        whiteBGView.addGestureRecognizer(tap)
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = UIColor.init(red: 0/255, green: 78/255, blue: 145/255, alpha: 1)
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        else {
            self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0/255, green: 78/255, blue: 145/255, alpha: 1)
        }
        let backButton = UIBarButtonItem.init(customView: self.backButton())
        self.navigationItem.leftBarButtonItem = backButton
        
        // viv for captcha
        
        //refreshCaptcha()
        
        //end
    }
    
    override  func goBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    override   func backButton() -> UIButton {
        let bBtn = UIButton()
        
        bBtn.frame = CGRect(x:0,y:0,width: 40,height:40)
        bBtn.setImage(UIImage.init(named: "Back.png"),for:.normal)
        
        bBtn.addTarget(self, action:#selector(self.goBack), for: .touchUpInside)
        
        return bBtn
        
    }
    @objc func whiteBGViewTapGesture(sender: UITapGestureRecognizer?) {
        
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.fscrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        
        self.fscrollView.contentInset = contentInsets
        self.fscrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.fscrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
        self.fscrollView.contentInset = contentInsets
        self.fscrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.fscrollView.isScrollEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        return true
    }
    //called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool     {
        textField.resignFirstResponder()
        activeField?.resignFirstResponder()
        self.view.endEditing(true)
        return true;
    }
    @IBAction func submitAction(_ sender: Any)
    {
        
                //userNameTextField.text = "abc@abc.com"
        if ((userNameTextField.text?.count)! == 0)
        {
            isSuccessMessage = false
            isErrorMessage = false
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Please enter Email address", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
//        else if let userInput = enterCaptcha.text, userInput == generatedCaptcha {
//            
//            let isInternetAvailable = self.isInternetAvailable()
//            
//            if isInternetAvailable {
//                JustHUD.shared.showInView(view: view)
//                
//                let params:[String:String] = ["UserName":userNameTextField.text!,"OSSource": "iOS"]
//                RestAPI.forgotPassword(self,params: params, method: "POST", callBack:getresponse(response:))
//            }else{
//                isSuccessMessage = false
//                isErrorMessage = false
//                self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
//                
//            }
//            
//        }
        else
        {
            
//            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Entered Captcha doesn't match", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
            let isInternetAvailable = self.isInternetAvailable()
            
            if isInternetAvailable {
                JustHUD.shared.showInView(view: view)
                
                let params:[String:String] = ["UserName":userNameTextField.text!,"OSSource": "iOS"]
                RestAPI.forgotPassword(self,params: params, method: "POST", callBack:getresponse(response:))
            }else{
                isSuccessMessage = false
                isErrorMessage = false
                self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }

    }
    
    //aftergettingResponseFrom the server
    func getresponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            //            lblNoData.isHidden = false
            var message = response as! String
            if message.count == 0 {
                
                message = Error_Message
                
            }
            //            let alert = UIAlertController(title:"", message: message, preferredStyle: UIAlertControllerStyle.alert)
            //            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:  {(alert) in
            //                 self.navigationController?.popViewController(animated: true)
            //            }))
            //            self.present(alert, animated: true, completion: nil)
            isSuccessMessage = false
            isErrorMessage = true
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            var object = response as! JSON
            if object["MessageStatus"].intValue == 1
            {
                //                let alertController = UIAlertController(title:"Success", message:object["Message"].stringValue, preferredStyle:UIAlertControllerStyle.alert)
                //
                //                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                //                { action -> Void in
                //                })
                //                self.present(alertController, animated: true, completion: nil)
                //
                isSuccessMessage = true
                isErrorMessage = false
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                
                
            }
            else
            {
                let message = object["Message"].stringValue
                isSuccessMessage = false
                isErrorMessage = false
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
            
        }
    }
    
    @IBAction override func okButtonTapped(_ sender: Any) {
        //        print("signoutButtonTapped")
        alertController.dismiss(animated: true, completion: nil)
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
        if isSuccessMessage == true{
            self.navigationController?.popViewController(animated: true)
        }else if isErrorMessage == true{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        
        
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            DispatchQueue.main.async(execute: { () -> Void in
                self.fscrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
                self.whiteBGSuperViewHeightConstraint.constant = UIScreen.main.bounds.size.height
                
            })
        case .portraitUpsideDown:
            text="PortraitUpsideDown"
        case .landscapeLeft:
            text="LandscapeLeft"
            DispatchQueue.main.async(execute: { () -> Void in
                self.fscrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height + 300)
                self.whiteBGSuperViewHeightConstraint.constant = UIScreen.main.bounds.size.height + 200
            })
        case .landscapeRight:
            text="LandscapeRight"
            DispatchQueue.main.async(execute: { () -> Void in
                self.fscrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height + 300 )
                self.whiteBGSuperViewHeightConstraint.constant = UIScreen.main.bounds.size.height + 200
            })
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
        
    }
    
    //for captcha
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        refreshCaptcha()
    }
    
    func refreshCaptcha() {
        generatedCaptcha = generateRandomString(length: 6)
        captchaLabel.text = generatedCaptcha
        enterCaptcha.text = ""
    }
    
    func generateRandomString(length: Int) -> String {
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map{ _ in characters.randomElement()! })
        }
    
    
}
