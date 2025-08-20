//
//  UserInfoPOpup.swift
//  EWA
//
//  Created by NFC User on 4/2/21.
//  Copyright © 2021 NFC. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import SwiftyJSON

protocol updateUserDetailsDelegate: class {
    func updateStatus(success:Bool)
}

class UserInfoPOpup: UIView, UITextFieldDelegate{
    @IBOutlet weak var labelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var popViewHeight: NSLayoutConstraint!
    @IBOutlet weak var AcknowledgementTextLabel: UILabel!
    weak var userDelegate: updateUserDetailsDelegate?
    var toCOntroller = UIViewController()
    var container: UIView = UIView()
    var object: JSON = JSON.null
    var OptedforSms = String()
    @IBOutlet weak var updateButton: UIButton! {
        didSet {
           // updateButton.layer.cornerRadius = 6
            OptedforSms = "0"
        }
    }
    var actInd = UIActivityIndicatorView()
    @IBOutlet weak var topView: UILabel!
    
    @IBOutlet weak var firstNameTF: JVFloatLabeledTextField!
    
    @IBOutlet weak var lastNameTF: JVFloatLabeledTextField!
    
    @IBOutlet weak var phoneNumberTF: JVFloatLabeledTextField!
    
    @IBOutlet weak var checkBoxButton: UIButton!
    
    
    func removePickerViewFromSuperView(){
        
        self.frame = CGRect(x:0,y:UIScreen.main.bounds.size.height,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
        
        UIView.animate(withDuration: 2.8, animations:  {
            
            self.removeFromSuperview()
            
        }) { (animationComplete) in
        }
    }
    
    //MARK:- Configurations
    func configure_TextFieldS(textField:UITextField)
    {
        
        //constants which stores values which will be assigned to respective fields
        let width = CGFloat(1)
        let color = UIColor.darkGray.cgColor
        
        //creating layer for the border of the view
        let border = CALayer()
        border.frame = CGRect(x:0, y:textField.frame.height-1, width:textField.frame.width, height:width)
        border.borderColor = color
        border.borderWidth = width
        textField.layer.masksToBounds = true
        textField.layer.addSublayer(border)
        
    }
    
    //MARK:- Load Form
    func loadForm() {
        checkBoxButton.setImage(UIImage.init(named: "unchecked.png"), for: .normal)
        configure_TextFieldS(textField: firstNameTF)
        configure_TextFieldS(textField: lastNameTF)
        configure_TextFieldS(textField: phoneNumberTF)
        phoneNumberTF.delegate = self
        topView.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        firstNameTF.text = self.object["First_Name"].stringValue
        lastNameTF.text = self.object["Last_Name"].stringValue
        if self.object["MobileNumber"].stringValue.count >= 10 {
            phoneNumberTF.text = self.object["MobileNumber"].stringValue
        }
        else {
            phoneNumberTF.text = ""
        }
        
        AcknowledgementTextLabel.text = self.object["AcknowledgementText"].stringValue
        popViewHeight.constant = Constants.calculateHeightWithFont(inString: self.object["AcknowledgementText"].stringValue, width: UIApplication.getTopMostViewController()!.view.bounds.size.width-20, font: UIFont.systemFont(ofSize: 15)) + 350 // labelHeight.constant + 350
       
    }
    //MARK:- CHECKBOX ACTION
    @IBAction func checkBoxClicked(_ sender: UIButton) {
        self.endEditing(true)
        if checkBoxButton.currentImage == UIImage.init(named: "unchecked.png") {
            checkBoxButton.setImage(UIImage(named: "check.png"), for:.normal)
            OptedforSms = "1"
        }
        else {
            checkBoxButton.setImage(UIImage(named: "unchecked.png"), for:.normal)
            OptedforSms = "0"
        }
        
    }
    
    //MARK:- UPDATE BUTTON ACTION
    @IBAction func updateButtonClicked(_ sender: UIButton) {
        self.endEditing(true)
        if firstNameTF.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            ServerService.ShowAlertMessage(ErrorMessage:"", title: "First name is required", view:UIApplication.getTopMostViewController()!)
        }
        else if lastNameTF.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            ServerService.ShowAlertMessage(ErrorMessage:"", title: "Last name is required", view:UIApplication.getTopMostViewController()!)
        }
        else if phoneNumberTF.text!.count == 0 {
            ServerService.ShowAlertMessage(ErrorMessage:"", title: "Mobile number is required", view:UIApplication.getTopMostViewController()!)
        }
        else if phoneNumberTF.text!.count != 14 {
            ServerService.ShowAlertMessage(ErrorMessage:"", title: "Enter valid mobile number", view:UIApplication.getTopMostViewController()!)
        }
        else {
            
            //Submit values to API
            updateValuesToServer()
        }
    }
    
    
    func updateValuesToServer() {
        let firstname = firstNameTF.text!
        let lastname = lastNameTF.text!
        let mobileNumber = phoneNumberTF.text!
        print("FirstName = \(firstname)\nLastName = \(lastname)\nMobileNumber = \(mobileNumber)")
        
        if ConnectionCheck.isConnectedToNetwork()
        {
            showActivityIndicator(uiView: self, container: container, actInd: actInd)
            let paramsMenu:[String:Any] = ["cand_Id":UserDefaults.standard.object(forKey: "cID") as! String,
                                           "FirstName": firstname,
                                           "LastName": lastname,
                                           "MobileNumber":mobileNumber,
                                           "OptedforSms":OptedforSms]
            print(paramsMenu)
            ServerService.EditSmsDetails(toCOntroller, params: paramsMenu, method:"POST", accessToken:Constants.Token, acces:true, callBack: getFormOkResponse(response:))
        }
        else
        {
            self.hideActivityIndicator(container: self.container)
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:UIApplication.getTopMostViewController()!)
        }
    }
    
    //MARK:- OkCLickResponse
    func getFormOkResponse(response:AnyObject)->()
    {
        self.hideActivityIndicator(container: self.container)
        var formRespObject: JSON = JSON.null
        formRespObject = response as! JSON
        print(formRespObject)
        
        if formRespObject["messegeStatus"].intValue == 1 {
            self.hideActivityIndicator(container: self.container)
            self.removePickerViewFromSuperView()
            self.userDelegate?.updateStatus(success: true)
        }
        else {
            ServerService.ShowAlertMessage(ErrorMessage:formRespObject["Messege"].stringValue, title: "", view:UIApplication.getTopMostViewController()!)
        }
    }
    
    //MARK:- UITextField Delgate & Format
    func formattedNumber(number: String) -> String
    {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "(XXX)-XXX-XXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if textField == phoneNumberTF
        {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = formattedNumber(number: newString)
            return false
        }
        return true
    }
}
