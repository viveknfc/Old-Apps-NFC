//
//  ManageTextMessages.swift
//  EWA
//
//  Created by NFC User on 4/3/21.
//  Copyright © 2021 NFC. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import SwiftyJSON

class ManageTextMessages: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var AcknowledgementTextLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var mobileNumderTF: JVFloatLabeledTextField!
    @IBOutlet weak var firstNameTF: JVFloatLabeledTextField!
    @IBOutlet weak var lastNameTF: JVFloatLabeledTextField!
    var OptedforSms = String()
    var formRespObject: JSON = JSON.null
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getUserDetails()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = "Manage Text Message"
        
        configure_TextFieldS(textField: firstNameTF)
        configure_TextFieldS(textField: lastNameTF)
        configure_TextFieldS(textField: mobileNumderTF)
        mobileNumderTF.delegate = self
        checkButton.setImage(UIImage(named: "unchecked.png"), for:.normal)
    }
    
    func getUserDetails () {
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView: self.view)
            let paramsMenu:[String:Any] = ["cand_Id":UserDefaults.standard.object(forKey: "cID") as! String]
            print(paramsMenu)
            ServerService.GetcandidateSmsDetails(self, params: paramsMenu, method:"POST", accessToken:Constants.Token, acces:true, callBack: getUserResponse(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:UIApplication.getTopMostViewController()!)
        }
    }
    
    //MARK:- UserDetailsResponse
    func getUserResponse(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        var getRespObject: JSON = JSON.null
        getRespObject = response as! JSON
        print(getRespObject)
        
        if getRespObject["messegeStatus"].intValue == 1 {
            
            firstNameTF.text = getRespObject["FirstName"].stringValue
            lastNameTF.text = getRespObject["LastName"].stringValue
            if getRespObject["MobileNumber"].stringValue.count > 10 {
            mobileNumderTF.text = getRespObject["MobileNumber"].stringValue
            }
            else {
                mobileNumderTF.text = ""
            }
            if getRespObject["OptedforSms"].stringValue == "0" {
                checkButton.setImage(UIImage(named: "unchecked.png"), for:.normal)
                OptedforSms = "0"
            }
            else {
                checkButton.setImage(UIImage(named: "check.png"), for:.normal)
                OptedforSms = "1"
            }
            AcknowledgementTextLabel.text = getRespObject["AcknowledgementText"].stringValue
        }
        else {
            if getRespObject["Message"].stringValue.count > 0 {
                ServerService.ShowAlertMessage(ErrorMessage:getRespObject["Message"].stringValue, title: "", view:UIApplication.getTopMostViewController()!)
            }
            else {
                ServerService.ShowAlertMessage(ErrorMessage:Constants.ErrorMessage, title: "", view:UIApplication.getTopMostViewController()!)
            }
            
        }
    }
    //MARK:- Configurations
    func configure_TextFieldS(textField:UITextField)
    {
        
        //constants which stores values which will be assigned to respective fields
        let width = CGFloat(1)
        let color = UIColor.black.cgColor
        
        //creating layer for the border of the view
        let border = CALayer()
        border.frame = CGRect(x:0, y:textField.frame.height-1, width:textField.frame.width, height:width)
        border.borderColor = color
        border.borderWidth = width
        textField.layer.masksToBounds = true
        textField.layer.addSublayer(border)
    }
    
    //MARK:- Check box Action
    @IBAction func checkBoxClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if checkButton.currentImage == UIImage.init(named: "unchecked.png") {
            checkButton.setImage(UIImage(named: "check.png"), for:.normal)
            OptedforSms = "1"
        }
        else {
            checkButton.setImage(UIImage(named: "unchecked.png"), for:.normal)
            OptedforSms = "0"
        }
    }
    
    //MARK:- Update Button Action
    @IBAction func updateClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if firstNameTF.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            ServerService.ShowAlertMessage(ErrorMessage:"", title: "First name is required", view:UIApplication.getTopMostViewController()!)
        }
        else if lastNameTF.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            ServerService.ShowAlertMessage(ErrorMessage:"", title: "Last name is required", view:UIApplication.getTopMostViewController()!)
        }
        else if mobileNumderTF.text!.count == 0 {
            ServerService.ShowAlertMessage(ErrorMessage:"", title: "Mobile number is required", view:UIApplication.getTopMostViewController()!)
        }
        else if mobileNumderTF.text!.count != 14 {
            ServerService.ShowAlertMessage(ErrorMessage:"", title: "Enter valid mobile number", view:UIApplication.getTopMostViewController()!)
        }
        else {
            
            //Submit values to API
            self.updateValuesToServer()
        }
    }
    func updateValuesToServer() {
        let firstname = firstNameTF.text!
        let lastname = lastNameTF.text!
        let mobileNumber = mobileNumderTF.text!
        print("FirstName = \(firstname)\nLastName = \(lastname)\nMobileNumber = \(mobileNumber)")
        
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView: self.view)
            let paramsMenu:[String:Any] = ["cand_Id":UserDefaults.standard.object(forKey: "cID") as! String,
                                           "FirstName": firstname,
                                           "LastName": lastname,
                                           "MobileNumber":mobileNumber,
                                           "OptedforSms":OptedforSms]
            print(paramsMenu)
            ServerService.EditSmsDetails(self, params: paramsMenu, method:"POST", accessToken:Constants.Token, acces:true, callBack: getFormOkResponse(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:UIApplication.getTopMostViewController()!)
        }
    }
    
    //MARK:- OkCLickResponse
    func getFormOkResponse(response:AnyObject)->()
    {
        ServerService.hideProgressView()
       
        formRespObject = response as! JSON
        print(formRespObject)
    
         //   ServerService.ShowAlertMessage(ErrorMessage:formRespObject["Messege"].stringValue, title: "", view:UIApplication.getTopMostViewController()!)
        let alert = UIAlertController.init(title: formRespObject["Messege"].stringValue, message: "", preferredStyle: .alert)
        
        let action1 = UIAlertAction.init(title: "Ok", style: .default) { (action) in
            
           
        }
        alert.addAction(action1)
        self.present(alert, animated: true, completion: nil)
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
        
        if textField == mobileNumderTF
        {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = formattedNumber(number: newString)
            return false
        }
        return true
    }
}
