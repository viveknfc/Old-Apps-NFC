//
//  ForgotPassWordViewController.swift
//  EWA
//
//  Created by NFC Solutions on 13/10/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON

class ForgotPassWordViewController: UIViewController {

    @IBOutlet var fscrollView: UIScrollView!
     var object: JSON = JSON.null
    var activeField: UITextField?
    var grayIndiacator = UIActivityIndicatorView()
    let container: UIView = UIView()

    
    @IBOutlet var userNameTextField: NiceTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(ForgotPassWordViewController.keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ForgotPassWordViewController.keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.automaticallyAdjustsScrollViewInsets = false
        
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        
    }
    
    @objc func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.fscrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
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
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
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


    @IBAction func getAction(_ sender: Any)
    {
        
        if ((userNameTextField.text?.count)!>0)
        {
            if (userNameTextField.text!.isValidEmail())
            {
            if ConnectionCheck.isConnectedToNetwork()
            {
                ServerService.showActivityIndicatory(uiView:self.view)
                let params:[String:String] = ["username":userNameTextField.text!]
                print(params)
                ServerService.forgotPassword(self,params: params, method: "POST", callBack:getresponse(response:))
            }
            else
            {
                ServerService.hideProgressView()
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
               ServerService.hideProgressView()
            })
        
            }
            else
            {
                ServerService.ShowAlertMessage(ErrorMessage:"Enter valid email id and try again", title: "", view: self)
            }
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage: "Enter email id and try again", title: "", view: self)
        }
    }
    
    //aftergettingResponseFrom the server
    func getresponse(response:AnyObject)->()
    {
        print(response)
        var object = response as! JSON
        ServerService.hideProgressView()
        if object.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if object["MessageStatus"].intValue == 1
        {
            let alertController = UIAlertController(title:"Success", message:object["Message"].stringValue, preferredStyle:UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            { action -> Void in
                self.dismiss(animated: true, completion: nil)
            })
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage:"", title: object["Message"].stringValue , view: self)
        }
    }
    //called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool     {
        textField.resignFirstResponder()
        return true;
    }
    func showActivityIndicatory(uiView: UIView) {
        
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor.uicolorFromHex(0xffffff, alpha: 0.1)
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor.uicolorFromHex(0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        actInd.center = CGPoint(x:loadingView.frame.size.width/2,
                                y:loadingView.frame.size.height/2);
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        actInd.startAnimating()
    }
    func hideProgressView() {
        grayIndiacator.stopAnimating()
        container.removeFromSuperview()
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}



