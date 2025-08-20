//
//  SignView.swift
//  EWA
//
//  Created by NFC India on 04/10/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON


protocol signatureDelagte: class {
    func signatureStatus(success:Bool)
}



class SignView: UIView, UITextFieldDelegate {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var signatureTextField: UITextField!
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    weak var signDelegate: signatureDelagte?
    
     var checked = Bool()
    var acaRequire = Bool()
    var aca1905cRequire = Bool()
    var object:JSON = JSON.null
     var signedObjectResponse:JSON = JSON.null
    
    
    
    func setUp()  {
        
        signatureTextField.delegate = self
        topView.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
            return true
      
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.endeditingField()
        removePickerViewFromSuperView()
    }
    
    @IBAction func removeAction(_ sender: Any) {
        self.endeditingField()
        removePickerViewFromSuperView()
    }
    
    func endeditingField() {
                    self.endEditing(true)
                    self.signatureTextField.resignFirstResponder()
        (UIApplication.getTopMostViewController())!.view.endEditing(true)
    }
    @IBAction func submitAction(_ sender: Any) {
        self.endeditingField()
        if ConnectionCheck.isConnectedToNetwork()
        {
            if object["FormName"].stringValue == "HandBook"
            {
                if checked
                {
                    if signatureTextField.text!.count>0
                    {
                        ServerService.showActivityIndicatory(uiView:self)
                        let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextField.text!,"AgreementId":object["AgreementId"].stringValue,"FormName":object["FormName"].stringValue]
                        print(params)
                        ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(UIApplication.getTopMostViewController()!, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                    }
                    else
                    {
                        errorLabel.text = "Signature Should Match to Your FirstName and LastName"
                    }

                }
                else
                {
                    errorLabel.text = "Please check the checkbox before submitting signature"
                }
            }
            else if object["FormName"].stringValue == "ACAElectronicDeliveryConsent"
            {
                if checked
                {
                    if signatureTextField.text!.count>0
                    {
                        //                        ANLoader.showLoading("", disableUI:false)
                        ServerService.showActivityIndicatory(uiView:self)
                        if acaRequire
                        {
                            let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextField.text!,"FormName":object["FormName"].stringValue,"ACADecline":"","AcaDeclineSignName":""]
                            print(params)
                            ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(UIApplication.getTopMostViewController()!, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                        }
                        else
                        {
                            let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":"","FormName":object["FormName"].stringValue,"ACADecline":"1","AcaDeclineSignName":signatureTextField.text!]
                            print(params)
                            ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(UIApplication.getTopMostViewController()!, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                        }
                    }
                    else
                    {
                        errorLabel.text = "Signature Should Match to Your FirstName and LastName"
                    }

                }
                else
                {
                    errorLabel.text = "Please check the checkbox before submitting signature"
                }

            }

            else if object["FormName"].stringValue == "ACA1095CConsent"
            {
                if checked
                {
                    if signatureTextField.text!.count>0
                    {
                        //ANLoader.showLoading("", disableUI:false)
                        ServerService.showActivityIndicatory(uiView:self)
                        if aca1905cRequire
                        {
                            let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextField.text!,"FormName":object["FormName"].stringValue,"ACADecline":""]
                            print(params)
                            ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(UIApplication.getTopMostViewController()!, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                        }
                        else
                        {
                            let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextField.text!,"FormName":object["FormName"].stringValue,"ACADecline":"1"]
                            print(params)
                            ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(UIApplication.getTopMostViewController()!, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                        }
                    }
                    else
                    {
                        errorLabel.text = "Signature Should Match to Your FirstName and LastName"
                    }
                }
                else
                {
                    errorLabel.text = "Please check the checkbox before submitting signature"
                }

            }
            else if object["FormName"].stringValue == "WageRateForm"
            {
                if checked
                {
                    if signatureTextField.text!.count>0
                    {
                        let date = Date()
                        let formatter = DateFormatter()
                        formatter.locale = Locale.preferredLocale()
                        formatter.dateFormat = "MM/dd/yyyy"
                        let result = formatter.string(from: date)

                        //ANLoader.showLoading("", disableUI:false)
                        ServerService.showActivityIndicatory(uiView:self)
                        let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextField.text!,"FormName":object["FormName"].stringValue,"OrderId":object["OrderId"].stringValue,"CompanyName":object["CompanyName"].stringValue,"DbaName":object["DbaName"].stringValue,"PreparerName":object["PreparerName"].stringValue,"CompAddress":object["CompAddress"].stringValue,"CompCity":object["CompCity"].stringValue,"CompState":object["CompState"].stringValue,"CompZip":object["CompZip"].stringValue,"CompPhone":object["CompPhone"].stringValue,"SignedDate":result,"prepSignDate":object["prepSignDate"].stringValue,"WageRateFullText":object["WageRateFullText"].stringValue]
                        print(params)
                        ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(UIApplication.getTopMostViewController()!, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                    }
                    else
                    {
                        errorLabel.text = "Signature Should Match to Your FirstName and LastName"
                    }
                }
                else
                {
                    errorLabel.text = "Please check the checkbox before submitting signature"
                }
            }

            else if object["FormName"].stringValue == "CaliforniaWageRateForm"
            {
                if checked
                {
                    if signatureTextField.text!.count>0
                    {
                        let date = Date()
                        let formatter = DateFormatter()
                        formatter.locale = Locale.preferredLocale()
                        formatter.dateFormat = "MM/dd/yyyy"
                        let result = formatter.string(from: date)


                        //ANLoader.showLoading("", disableUI:false)
                        ServerService.showActivityIndicatory(uiView:self)
                        let params:[String:String] = ["CandID":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextField.text!,"FormName":object["FormName"].stringValue,"OrderId":object["OrderId"].stringValue,"CompanyName":object["CompanyName"].stringValue,"PreparerName":object["PreparerName"].stringValue,"CompAddress":object["CompAddress"].stringValue,"CompCity":object["CompCity"].stringValue,"CompState":object["CompState"].stringValue,"CompZip":object["CompZip"].stringValue,"CompPhone":object["CompPhone"].stringValue,"ApplicantSignDateTime":result,"Hiredate":object["Hiredate"].stringValue,"WageRateFullText":object["WageRateFullText"].stringValue,"DesignatedPayDay":object["DesignatedPayDay"].stringValue,"ApplicantSignature":signatureTextField.text!]
                        print(params)
                        ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(UIApplication.getTopMostViewController()!, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                    }
                    else
                    {
                        errorLabel.text = "Signature Should Match to Your FirstName and LastName"
                    }
                }
                else
                {
                    errorLabel.text = "Please check the checkbox before submitting signature"
                }
            }
            else if object["FormName"].stringValue == Constants.A1Form {
                if checked
                {
                    if signatureTextField.text!.count>0
                    {
                        ServerService.showActivityIndicatory(uiView:self)
                        let date = Date()
                        let formatter = DateFormatter()
                        formatter.locale = Locale.preferredLocale()
                        formatter.dateFormat = "MM/dd/yyyy hh:mm aa"
                        let result = formatter.string(from: date)
                        
                        Constants.A1insertParams["SignDate"] = result
                        Constants.A1insertParams["Signature"] = signatureTextField.text!
                        let params =  Constants.A1insertParams
                        print(params)
                        ServerService.InsertA1Series(UIApplication.getTopMostViewController()!, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                    }
                    else
                    {
                        errorLabel.text = "Signature Should Match to Your FirstName and LastName"
                    }
                }
                else
                {
                    errorLabel.text = "Please check the checkbox before submitting signature"
                }

            }
            else if object["FormName"].stringValue == Constants.A2Form {
                if checked
                {
                    if signatureTextField.text!.count>0
                    {
                        ServerService.showActivityIndicatory(uiView:self)
                        let date = Date()
                        let formatter = DateFormatter()
                        formatter.locale = Locale.preferredLocale()
                        formatter.dateFormat = "MM/dd/yyyy hh:mm aa"
                        let result = formatter.string(from: date)
                        
                        Constants.A2insertParams["SignDate"] = result
                        Constants.A2insertParams["Signature"] = signatureTextField.text!
                        let params =  Constants.A2insertParams
                        print(params)
                        ServerService.InsertUPKA2Detail(UIApplication.getTopMostViewController()!, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                    }
                    else
                    {
                        errorLabel.text = "Signature Should Match to Your FirstName and LastName"
                    }
                }
                else
                {
                    errorLabel.text = "Please check the checkbox before submitting signature"
                }

            }
            else
            {
                if checked
                {
                    if signatureTextField.text!.count>0
                    {
                        ServerService.showActivityIndicatory(uiView:self)
                        let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextField.text!,"FormName":object["FormName"].stringValue]
                        print("viv in 280 \(params)***")
                        ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(UIApplication.getTopMostViewController()!, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                    }
                    else
                    {
                        errorLabel.text = "Signature Should Match to Your FirstName and LastName"
                    }
                }
                else
                {
                    errorLabel.text = "Please check the checkbox before submitting signature"
                }

            }


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
        signedObjectResponse = response as! JSON
        print("viv the response from 310 is \(signedObjectResponse)***")
        if signedObjectResponse["Status"].stringValue == "Success"
        {
            if ConnectionCheck.isConnectedToNetwork()
            {
                
              signDelegate?.signatureStatus(success:true)
              removePickerViewFromSuperView()
            }
            else
            {
               
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:UIApplication.getTopMostViewController()!)
            }
        }
        else
        {
            errorLabel.text = signedObjectResponse["Message"].stringValue

        }
    }
    
    
    @IBAction func checkBoxAction(_ sender: Any) {
        if checked
        {
            checkBox.setImage(UIImage(named: "unchecked.png"), for:.normal)
            checked = false
        }
        else
        {
            checkBox.setImage(UIImage(named:"check.png"), for:.normal)
            checked = true
        }
    }
    
    // function to remove from superView
    func removePickerViewFromSuperView(){
        
        self.frame = CGRect(x:0,y:UIScreen.main.bounds.size.height,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
        
        UIView.animate(withDuration: 1.5, animations:  {
            
            self.removeFromSuperview()
            
        }) { (animationComplete) in
        }
    }
}
