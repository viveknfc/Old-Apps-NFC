//
//  ChangePasswordViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 15/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChangePasswordViewController: BaseViewController,UITextFieldDelegate {
    
    var isFromSigninPage = false
    var divisionCount = -1
    
    @IBOutlet var fscrollView: UIScrollView!
    var activeField: UITextField?
    
    @IBOutlet var oldPWTextField: NiceTextField!
    @IBOutlet var newPWTextField: NiceTextField!
    @IBOutlet var confirmPWTextField: NiceTextField!
    @IBOutlet weak var whiteBGSuperViewHeightConstraint: NSLayoutConstraint!
    
    var isSuccessMessage = false
    var isErrorMessage = false
    
    @IBOutlet var whiteBGView: UIView!
    @IBOutlet var topColorBGView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titlelbl.text = "Change Password"
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.title = "Change Password"
        //        self.titlelbl.text = "Change Password"
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChangePasswordViewController.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChangePasswordViewController.keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.automaticallyAdjustsScrollViewInsets = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.whiteBGViewTapGesture))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(keyboardDoneBtnTapped))]
        toolBar.sizeToFit()
        
        oldPWTextField.inputAccessoryView = toolBar
        newPWTextField.inputAccessoryView = toolBar
        confirmPWTextField.inputAccessoryView = toolBar
        if self.isPortrait() == true{}else{
            DispatchQueue.main.async(execute: { () -> Void in
                self.fscrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height + 300)
                self.whiteBGSuperViewHeightConstraint.constant = UIScreen.main.bounds.size.height + 200
                self.view.layoutIfNeeded()
            })
        }
        if UserDefaults.standard.string(forKey: "ColorCode") != nil {
            topColorBGView.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
            
        }else{
            topColorBGView.backgroundColor = UIColor(hexString:"#004E91")
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardDoneBtnTapped(sender: UIButton)  {
        self.view.endEditing(true)
    }
    @objc func whiteBGViewTapGesture(sender: UITapGestureRecognizer?) {
        
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
     {"Username" : "jmedina@schoolprofessionals.com", "NewPassword" : "jmedina420", "OldPassword" : "mxDAxO13h2v5YH" }
     
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
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
        //        self.fscrollView.isScrollEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
        //        if self.isPortrait() == false{
        //            self.fscrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height + 300)
        //            self.whiteBGSuperViewHeightConstraint.constant = UIScreen.main.bounds.size.height + 200
        //
        //        self.fscrollView.isScrollEnabled = true
        //
        //                      self.fscrollView.scrollRectToVisible(textField.frame, animated: true)
        //
        //        }
    }
    
    
    @IBAction func submitAction(_ sender: Any)
    {
        
        let userName = UserDefaults.standard.string(forKey: "UserName")
        
        //        oldPWTextField.text = "test123"
        //        confirmPWTextField.text = "test234"
        //        newPWTextField.text = "test234"
        
        if ((oldPWTextField.text?.count)! == 0) ||  ((confirmPWTextField.text?.count)! == 0) || ((newPWTextField.text?.count)! == 0){
            
            isSuccessMessage = false
            isErrorMessage = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message:  "Please fill all the details", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }else{
            
            if  confirmPWTextField.text == newPWTextField.text{

                    let isInternetAvailable = self.isInternetAvailable()
                    
                    if isInternetAvailable {
                        JustHUD.shared.showInView(view: view)
                        
                        let params:[String:String] = ["Username":userName!,"NewPassword":newPWTextField.text!,"OldPassword":oldPWTextField.text!,"OSSource": "iOS"]
                        print(params)
                        RestAPI.changePassword(self,params: params, method: "POST", callBack:getresponse(response:))
                    }else{
                        
                        isSuccessMessage = false
                        isErrorMessage = false
                        self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message:  InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                        
                    }
                
            }else{
                
                isSuccessMessage = false
                isErrorMessage = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message:  "New password and Confirm password should be same", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }
        
        
    }
    
    //aftergettingResponseFrom the server
    func getresponse(response:AnyObject)->()
    {
        print(response)
        JustHUD.shared.hide()
        
        if response is String{
            var message = response as! String
            if message.count == 0 {
                
                message = "There is some error while geeting data"
                
            }
            //            let alert = UIAlertController(title:"", message: message, preferredStyle: UIAlertControllerStyle.alert)
            //            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:  {(alert) in
            //                //pop to dashboard page
            //                self.navigationController?.popViewController(animated: true)
            //            }))
            //            self.present(alert, animated: true, completion: nil)
            isSuccessMessage = true
            isErrorMessage = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }else {
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                //                let alertController = UIAlertController(title:"", message:object["Message"].stringValue, preferredStyle:UIAlertControllerStyle.alert)
                //
                //                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                //                { action -> Void in
                //                    self.navigationController?.popViewController(animated: true)
                //                    self.dismiss(animated: true, completion: nil)
                //                })
                //                self.present(alertController, animated: true, completion: nil)
                isSuccessMessage = true
                isErrorMessage = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                
            }
            else
            {
                let message =  object["Message"].stringValue
                isSuccessMessage = false
                isErrorMessage = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
            
        }
    }
    @IBAction override func okButtonTapped(_ sender: Any) {
        self.alertController.dismiss(animated: true, completion: nil)
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
        if isSuccessMessage == true{
            if isFromSigninPage == true{
                //push to divisionList Page
                if self.divisionCount == 1 {
                    self.getDivisionListCall()
                }else{
                    self.pushToDivisionListPage()
                }
            }else{
                
                self.navigationController?.popViewController(animated: true)
            }
            //            self.dismiss(animated: true, completion: nil)
        }
        
    }
    func pushToDivisionListPage() {
        
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DivisionListViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DivisionListSegue") as! DivisionListViewController
            nextViewController.isFromSignin = true
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    //called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool     {
        textField.resignFirstResponder()
        return true;
    }
    
    // MARK: - SERVER CALL
    
    
    func getDivisionListCall() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            let defaults = UserDefaults.standard
            
            let username = defaults.string(forKey: "UserName")
            let clientID = String(format:"%d", defaults.integer(forKey: "User_ClientID"))
            let DivisionId = String(format:"%d", defaults.integer(forKey: "User_DivisionId"))
            
            //userid as String
            let params :[String:String] = ["UserName":username!,"ClientID":clientID,"DivisionId":DivisionId,"OSSource": "iOS"]
            print(params)
            RestAPI.getListOfDivisions(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getDivisionResponse(response:))
            
        }else{
            
            //            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
            isSuccessMessage = false
            isErrorMessage = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message:  InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    
    func getDivisionResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            
            //            self.ShowAlertMessage(message: response as! String, title: "")
            isSuccessMessage = false
            isErrorMessage = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
                
                let dataArray = object["DivisionList"].array
                
                
                
                for dict in dataArray! {
                    
                    let div = Division.init(Div_ID: dict["Div_ID"].intValue, client_name: dict["client_name"].stringValue, district: dict["district"].stringValue, City:  dict["City"].stringValue, location_code: dict["location_code"].stringValue, State: dict["State"].stringValue, CodeZip: dict["CodeZip"].stringValue, Phone: dict["Phone"].stringValue, client_id: dict["client_id"].intValue, contact_id: dict["contact_id"].intValue, pending_ts: dict["pending_ts"].intValue,division: dict["division"].stringValue,comp_name: dict["comp_name"].stringValue,LogoPath: dict["LogoPath"].stringValue,ColorCode: dict["ColorCode"].stringValue,SmallLogoPath: dict["APISmallLogoPath"].stringValue)
                    
                    let ColorCode = div.ColorCode
                    let logoPath = div.LogoPath
                    let clientID = String(format:"%d",div.client_id!)
                    let contactID = String(format:"%d",div.contact_id!)
                    let divisionId = String(format:"%d",div.Div_ID!)
                    
                    let DivisionId = div.Div_ID
                    let clientName =   div.client_name
                    let comp_name =   div.comp_name
                    
                    var divName = ""
                    
                    if DivisionId == 102 {
                        
                        divName = comp_name!
                        if comp_name?.count == 0{
                            divName = clientName!
                            
                        } else{
                            divName = comp_name!
                            
                        }
                    }else{
                        if clientName?.count == 0{
                            divName = comp_name!
                            
                        } else{
                            divName = clientName!
                            
                        }
                    }
                    
                    UserDefaults.standard.set(ColorCode, forKey: "ColorCode")
                    UserDefaults.standard.set(logoPath, forKey: "LogoPath")
                    UserDefaults.standard.set(clientID, forKey: "ClientID")
                    UserDefaults.standard.set(contactID, forKey: "ContactId")
                    UserDefaults.standard.set(divisionId, forKey: "DivisionId")
                    UserDefaults.standard.set(divName, forKey: "DivisionName")
                    
                    UserDefaults.standard.synchronize()
                    if #available(iOS 13.0, *) {
                        let appearance = UINavigationBarAppearance()
                        appearance.configureWithDefaultBackground()
                        appearance.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
                        navigationController?.navigationBar.prefersLargeTitles = false
                        navigationController?.navigationBar.standardAppearance = appearance
                        navigationController?.navigationBar.scrollEdgeAppearance = appearance
                    }
                    else {
                        self.navigationController?.navigationBar.barTintColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
                    }
                    self.pushToDashboardPage()
                    break
                }
                
            }else{
                
                var message = object["message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                isSuccessMessage = false
                isErrorMessage = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
                //                self.ShowAlertMessage(message: message, title: "")
                //            RestAPI.ShowAlertMessage(ErrorMessage: message, titleMessage: " ", view: self)
            }
        }
    }
    func pushToDashboardPage() {
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DashboardViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DashboardSegue") as! DashboardViewController
            nextViewController.isFromDivisionPage = false
            self.navigationController?.pushViewController(nextViewController, animated: false)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        
        if self.isPortrait() == true{}else{
            DispatchQueue.main.async(execute: { () -> Void in
                self.fscrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height + 300)
                self.whiteBGSuperViewHeightConstraint.constant = UIScreen.main.bounds.size.height + 200
            })
        }
        
        
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            self.addDivisionNameOnTop()
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.fscrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
                self.whiteBGSuperViewHeightConstraint.constant = UIScreen.main.bounds.size.height
                
            })
        case .portraitUpsideDown:
            text="PortraitUpsideDown"
        case .landscapeLeft:
            text="LandscapeLeft"
            self.addDivisionNameOnTop()
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.fscrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height + 300)
                self.whiteBGSuperViewHeightConstraint.constant = UIScreen.main.bounds.size.height + 200
            })
        case .landscapeRight:
            text="LandscapeRight"
            self.addDivisionNameOnTop()
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.fscrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height + 300 )
                self.whiteBGSuperViewHeightConstraint.constant = UIScreen.main.bounds.size.height + 200
            })
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let maxLength = 20
            let currentString = textField.text ?? ""
            let newString = (currentString as NSString).replacingCharacters(in: range, with: string)
            return newString.count <= maxLength
        }
}
