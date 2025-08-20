//
//  ChangePasswordViewController.swift
//  EWA
//
//  Created by NFC Solutions on 13/10/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import ANLoader


class ChangePasswordViewController: BaseViewController {

    @IBOutlet var changeButton: UIButton!
    //var grayIndiacator = UIActivityIndicatorView()
    let container: UIView = UIView()
    var object: JSON = JSON.null
    @IBOutlet var aScrollView: UIScrollView!
    //var activeField: UITextField?
    @IBOutlet var conformPasswordTextField: NiceTextField!
    @IBOutlet var newPasswordTextField: NiceTextField!
    @IBOutlet var passwordTextField: NiceTextField!
    @IBOutlet var contentView: UIView!
    var fromString = String()
    var fromLoginUpdated = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        if #available(iOS 11.0, *) {
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
      fromLoginUpdated = false
        
        self.navigationItem.rightBarButtonItems = nil
        
    }
    
    

    
    @IBAction func changeAction(_ sender: Any)
    {
        
        if ((passwordTextField.text?.count)!>0)&&(newPasswordTextField.text?.count)!>0&&(conformPasswordTextField.text?.count)!>0
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
                ANLoader.hide()
            })
            if newPasswordTextField.text == conformPasswordTextField.text {
                if ConnectionCheck.isConnectedToNetwork()
                {
                    //ANLoader.showLoading("", disableUI:true)
                    ServerService.showActivityIndicatory(uiView:self.view)
                    let params:[String:String] = ["username":UserDefaults.standard.object(forKey: "username") as! String,"oldpassword":passwordTextField.text!,"newpassword":newPasswordTextField.text!]
                    print(params)
                    ServerService.changePassword(self, params: params, method: "POST",accessToken:Constants.Token, acces:true,callBack:getresponse(response:))
                }
                else
                {
                    ANLoader.hide()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                }
              
            }
            else
            {
                ServerService.ShowAlertMessage(ErrorMessage:"", title:"New password and confirm password does not match", view: self)
            }
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage: "", title: "Please fill all the details", view: self)
        }
    }
    
    //aftergettingResponseFrom the server
    func getresponse(response:AnyObject)->()
    {
        print(response)
        ANLoader.hide()
        ServerService.hideProgressView()
        var object = response as! JSON
        if object.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if object["MessageStatus"].intValue == 1
        {
            let alertController = UIAlertController(title:object["Message"].stringValue, message:"", preferredStyle:UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            { action -> Void in
                
                if Constants.Menu == "Change Password"
                {
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = mainStoryboard.instantiateViewController(withIdentifier: "center") as! CustomSideMenuController
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    Constants.Menu = ""
                    self.view.endEditing(false)
                }
                else
                {
                if self.fromString == "Login"
                {
                    self.fromLoginUpdated = true
                    if UserDefaults.standard.integer(forKey:"EmployeeType") == 1
                    {
                        self.performSegue(withIdentifier:"permanentSegue", sender: nil)
                    }
                    else
                    {
                    self.performSegue(withIdentifier:"homeSegue", sender: nil)
                    }
                }
                else
                {
                    self.navigationController?.popViewController(animated: true)
                }
                }
            })
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage: "", title: object["Message"].stringValue , view: self)
        }
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        if self.fromString == "Login"
        {
            if fromLoginUpdated == false
            {
                Constants.menuHeaders.removeAll()
                Constants.menuSectionLogos.removeAll()
                Constants.menuSections.removeAll()
                Constants.menuObjj.removeAll()
                Constants.titleImages.removeAll()
                Constants.dashObject = JSON.null
                TimeOutClass.sharedInstance.resetTimer()
                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                (UIApplication.shared.delegate as? AppDelegate)?.APSlocation_Set_up()
            }
        }
        self.fromString = ""
        fromLoginUpdated = false
    }
    
}







