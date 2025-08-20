//
//  OtherNameEditView.swift
//  EWA
//
//  Created by NFC User on 7/30/21.
//  Copyright © 2021 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON

class OtherNameEditView: UIView, UITextFieldDelegate {
    @IBOutlet weak var topLabel: UILabel!
    var dataObject:JSON = JSON.null
    @IBOutlet weak var nameTF: UITextField!
    let allowedCharacters = CharacterSet(charactersIn:"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ").inverted
    func loadView(){
        nameTF.delegate = self
        topLabel.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        
        DispatchQueue.main.async {
            self.nameTF.text = self.dataObject["Name"].stringValue
        }
    }
    func removePickerViewFromSuperView(){
        
        self.frame = CGRect(x:0,y:UIScreen.main.bounds.size.height,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
        
        UIView.animate(withDuration: 1.5, animations:  {
            
            self.removeFromSuperview()
            
        }) { (animationComplete) in
        }
    }
    
    @IBAction func closeClicked(_ sender: UIButton) {
        self.removePickerViewFromSuperView()
    }
    @IBAction func submitClicked(_ sender: UIButton) {
        self.endEditing(true)
        if ConnectionCheck.isConnectedToNetwork()
        {
            if (nameTF.text?.replacingOccurrences(of: " ", with: "").count)! > 0 {
                ServerService.showActivityIndicatory(uiView:(UIApplication.getTopMostViewController()?.view)!)
                let params =
                    ["CandId" : UserDefaults.standard.object(forKey: "cID") as! String,
                     "Name": nameTF.text!,
                     "NameId":self.dataObject["NameId"].stringValue]  as [String : Any]
                
                print(params)
                ServerService.AliasNameEdit((UIApplication.getTopMostViewController())!, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.AliasNameEditDataObject(response:))
            }
            else {
                ServerService.ShowAlertMessage(ErrorMessage:"", title: "Please enter alias name", view:(UIApplication.getTopMostViewController())!)
            }
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:(UIApplication.getTopMostViewController())!)
            
        }
    }
    func AliasNameEditDataObject(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        let responseObject = response as! JSON
        print("****** AliasNameEdit Response is ************\n",responseObject)
        if responseObject["Status"].intValue == 1 {
            self.removePickerViewFromSuperView()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"ReloadOtherName"), object:nil)
        }
        else {
            var messagee = String()
            if responseObject["Message"].stringValue.count > 0 {
                messagee = responseObject["Message"].stringValue
            }
            else {
                messagee = "Something is not right here try again later"
            }
            ServerService.ShowAlertMessage(ErrorMessage:"", title: messagee, view:(UIApplication.getTopMostViewController())!)
        }
    }
    
    //MARK:- TextField Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == nameTF {
            let components = string.components(separatedBy: allowedCharacters)
            let filtered = components.joined(separator: "")
            
            if string == filtered {
                
                return true
                
            } else {
                
                return false
            }
        }
        else {
            
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
