//
//  A1SignView.swift
//  EWA
//
//  Created by NFC India on 04/10/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON


protocol a1signatureDelagte: class {
    func signatureStatus(success:Bool)
}



class A1SignView: UIView, UITextFieldDelegate {
    
    @IBOutlet weak var topVieww: UIView!
    @IBOutlet weak var signatureTextFieldd: UITextField!
    @IBOutlet weak var checkBoxx: UIButton!
    
    @IBOutlet weak var errorLabell: UILabel!
    
    weak var signDelegate: a1signatureDelagte?
    
    var checked = Bool()
    var acaRequire = Bool()
    var aca1905cRequire = Bool()
    var object:JSON = JSON.null
    var signedObjectResponse:JSON = JSON.null
    
    
    func setUp()  {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.orientationChanged(notification:)),
            name: NSNotification.Name.UIDeviceOrientationDidChange,
            object: nil
        )
        signatureTextFieldd.delegate = self
        topVieww.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        let window = UIApplication.shared.keyWindow!
        switch UIDevice.current.orientation{
        case .portrait:
            if UIScreen.main.bounds.height < 500 {
                self.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
            }
            else {
                self.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
            }
        case .landscapeLeft:
            self.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
        case .landscapeRight:
            self.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
        default:
            print("Default")
        }
    }
    
    @objc func orientationChanged(notification: Notification) {
        // handle rotation here
        let window = UIApplication.shared.keyWindow!
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            
            
            
            if UIScreen.main.bounds.height < 500 {
                self.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
            }
            else {
                self.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
            }
            
        case .landscapeLeft:
            text="LandscapeLeft"
            self.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
            
        case .landscapeRight:
            text="LandscapeRight"
            self.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
            
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
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
        self.signatureTextFieldd.resignFirstResponder()
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
                    if signatureTextFieldd.text!.count>0
                    {
                        ServerService.showActivityIndicatory(uiView:self)
                        let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextFieldd.text!,"AgreementId":object["AgreementId"].stringValue,"FormName":object["FormName"].stringValue]
                        print(params)
                        ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(UIApplication.getTopMostViewController()!, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                    }
                    else
                    {
                        errorLabell.text = "Signature Should Match to Your FirstName and LastName"
                    }
                    
                }
                else
                {
                    errorLabell.text = "Please check the checkbox before submitting signature"
                }
            }
            else if object["FormName"].stringValue == "ACAElectronicDeliveryConsent"
            {
                if checked
                {
                    if signatureTextFieldd.text!.count>0
                    {
                        //                        ANLoader.showLoading("", disableUI:false)
                        ServerService.showActivityIndicatory(uiView:self)
                        if acaRequire
                        {
                            let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextFieldd.text!,"FormName":object["FormName"].stringValue,"ACADecline":"","AcaDeclineSignName":""]
                            print(params)
                            ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(UIApplication.getTopMostViewController()!, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                        }
                        else
                        {
                            let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":"","FormName":object["FormName"].stringValue,"ACADecline":"1","AcaDeclineSignName":signatureTextFieldd.text!]
                            print(params)
                            ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(UIApplication.getTopMostViewController()!, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                        }
                    }
                    else
                    {
                        errorLabell.text = "Signature Should Match to Your FirstName and LastName"
                    }
                    
                }
                else
                {
                    errorLabell.text = "Please check the checkbox before submitting signature"
                }
                
            }
            
            else if object["FormName"].stringValue == "ACA1095CConsent"
            {
                if checked
                {
                    if signatureTextFieldd.text!.count>0
                    {
                        //ANLoader.showLoading("", disableUI:false)
                        ServerService.showActivityIndicatory(uiView:self)
                        if aca1905cRequire
                        {
                            let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextFieldd.text!,"FormName":object["FormName"].stringValue,"ACADecline":""]
                            print(params)
                            ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(UIApplication.getTopMostViewController()!, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                        }
                        else
                        {
                            let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextFieldd.text!,"FormName":object["FormName"].stringValue,"ACADecline":"1"]
                            print(params)
                            ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(UIApplication.getTopMostViewController()!, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                        }
                    }
                    else
                    {
                        errorLabell.text = "Signature Should Match to Your FirstName and LastName"
                    }
                }
                else
                {
                    errorLabell.text = "Please check the checkbox before submitting signature"
                }
                
            }
            else if object["FormName"].stringValue == "WageRateForm"
            {
                if checked
                {
                    if signatureTextFieldd.text!.count>0
                    {
                        let date = Date()
                        let formatter = DateFormatter()
                        formatter.locale = Locale.preferredLocale()
                        formatter.dateFormat = "MM/dd/yyyy"
                        let result = formatter.string(from: date)
                        
                        //ANLoader.showLoading("", disableUI:false)
                        ServerService.showActivityIndicatory(uiView:self)
                        let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextFieldd.text!,"FormName":object["FormName"].stringValue,"OrderId":object["OrderId"].stringValue,"CompanyName":object["CompanyName"].stringValue,"DbaName":object["DbaName"].stringValue,"PreparerName":object["PreparerName"].stringValue,"CompAddress":object["CompAddress"].stringValue,"CompCity":object["CompCity"].stringValue,"CompState":object["CompState"].stringValue,"CompZip":object["CompZip"].stringValue,"CompPhone":object["CompPhone"].stringValue,"SignedDate":result,"prepSignDate":object["prepSignDate"].stringValue,"WageRateFullText":object["WageRateFullText"].stringValue]
                        print(params)
                        ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(UIApplication.getTopMostViewController()!, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                    }
                    else
                    {
                        errorLabell.text = "Signature Should Match to Your FirstName and LastName"
                    }
                }
                else
                {
                    errorLabell.text = "Please check the checkbox before submitting signature"
                }
            }
            
            else if object["FormName"].stringValue == "CaliforniaWageRateForm"
            {
                if checked
                {
                    if signatureTextFieldd.text!.count>0
                    {
                        let date = Date()
                        let formatter = DateFormatter()
                        formatter.locale = Locale.preferredLocale()
                        formatter.dateFormat = "MM/dd/yyyy"
                        let result = formatter.string(from: date)
                        
                        
                        //ANLoader.showLoading("", disableUI:false)
                        ServerService.showActivityIndicatory(uiView:self)
                        let params:[String:String] = ["CandID":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextFieldd.text!,"FormName":object["FormName"].stringValue,"OrderId":object["OrderId"].stringValue,"CompanyName":object["CompanyName"].stringValue,"PreparerName":object["PreparerName"].stringValue,"CompAddress":object["CompAddress"].stringValue,"CompCity":object["CompCity"].stringValue,"CompState":object["CompState"].stringValue,"CompZip":object["CompZip"].stringValue,"CompPhone":object["CompPhone"].stringValue,"ApplicantSignDateTime":result,"Hiredate":object["Hiredate"].stringValue,"WageRateFullText":object["WageRateFullText"].stringValue,"DesignatedPayDay":object["DesignatedPayDay"].stringValue,"ApplicantSignature":signatureTextFieldd.text!]
                        print(params)
                        ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(UIApplication.getTopMostViewController()!, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                    }
                    else
                    {
                        errorLabell.text = "Signature Should Match to Your FirstName and LastName"
                    }
                }
                else
                {
                    errorLabell.text = "Please check the checkbox before submitting signature"
                }
            }
            else if object["FormName"].stringValue == Constants.A1Form {
                if checked
                {
                    if signatureTextFieldd.text!.count>0
                    {
                        ServerService.showActivityIndicatory(uiView:self)
                        let date = Date()
                        let formatter = DateFormatter()
                        formatter.locale = Locale.preferredLocale()
                        formatter.dateFormat = "MM/dd/yyyy hh:mm aa"
                        let result = formatter.string(from: date)
                        
                        Constants.A1insertParams["SignDate"] = result
                        Constants.A1insertParams["Signature"] = signatureTextFieldd.text!
                        let params =  Constants.A1insertParams
                        print(params)
                        ServerService.InsertA1Series(UIApplication.getTopMostViewController()!, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                    }
                    else
                    {
                        errorLabell.text = "Signature Should Match to Your FirstName and LastName"
                    }
                }
                else
                {
                    errorLabell.text = "Please check the checkbox before submitting signature"
                }
                
            }
            else if object["FormName"].stringValue == Constants.A2Form {
                if checked
                {
                    if signatureTextFieldd.text!.count>0
                    {
                        ServerService.showActivityIndicatory(uiView:self)
                        let date = Date()
                        let formatter = DateFormatter()
                        formatter.locale = Locale.preferredLocale()
                        formatter.dateFormat = "MM/dd/yyyy hh:mm aa"
                        let result = formatter.string(from: date)
                        
                        Constants.A2insertParams["SignDate"] = result
                        Constants.A2insertParams["Signature"] = signatureTextFieldd.text!
                        let params =  Constants.A2insertParams
                        print(params)
                        ServerService.InsertUPKA2Detail(UIApplication.getTopMostViewController()!, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                    }
                    else
                    {
                        errorLabell.text = "Signature Should Match to Your FirstName and LastName"
                    }
                }
                else
                {
                    errorLabell.text = "Please check the checkbox before submitting signature"
                }
                
            }
            else if object["FormName"].stringValue == Constants.SCRForm {
                if checked
                {
                    if signatureTextFieldd.text!.count>0
                    {
                        ServerService.showActivityIndicatory(uiView:self)
                        let date = Date()
                        let formatter = DateFormatter()
                        formatter.locale = Locale.preferredLocale()
                        formatter.dateFormat = "MM/dd/yyyy hh:mm aa"
                        let result = formatter.string(from: date)
                        
                        Constants.SCRConsentInfoInsertParams["ScrFormConsentSigDate"] = result
                        Constants.SCRConsentInfoInsertParams["ScrFormConsentSigName"] = signatureTextFieldd.text!
                        let params =  Constants.SCRConsentInfoInsertParams
                        print(params)
                        ServerService.SubmitSCRForm(UIApplication.getTopMostViewController()!, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                    }
                    else
                    {
                        errorLabell.text = "Signature Should Match to Your FirstName and LastName"
                    }
                }
                else
                {
                    errorLabell.text = "Please check the checkbox before submitting signature"
                }
                
            }
            else if object["FormName"].stringValue == Constants.SCRSign1 || object["FormName"].stringValue == Constants.SCRSign2 {
                    if checked
                    {
                        if signatureTextFieldd.text!.count>0
                        {
                            ServerService.showActivityIndicatory(uiView:self)
                            
                            let params:[String:String] = ["CandID":UserDefaults.standard.object(forKey: "cID") as! String,"CandName":signatureTextFieldd.text!]
                            print(params)
                            ServerService.GetSCRValidate(UIApplication.getTopMostViewController()!, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseForNameValidate(response:))
                        }
                        else
                        {
                            errorLabell.text = "Signature Should Match to Your FirstName and LastName"
                        }
                    }
                
                else
                {
                    errorLabell.text = "Please check the checkbox before submitting signature"
                }
                
            }
            else
            {
                if checked
                {
                    if signatureTextFieldd.text!.count>0
                    {
                        ServerService.showActivityIndicatory(uiView:self)
                        let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":signatureTextFieldd.text!,"FormName":object["FormName"].stringValue]
                        print(params)
                        ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(UIApplication.getTopMostViewController()!, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
                    }
                    else
                    {
                        errorLabell.text = "Signature Should Match to Your FirstName and LastName"
                    }
                }
                else
                {
                    errorLabell.text = "Please check the checkbox before submitting signature"
                }
                
            }
            
            
        }
        
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:UIApplication.getTopMostViewController()!)
        }
        
    }
        func getresponseForNameValidate(response:AnyObject)->()
        {
            ServerService.hideProgressView()
            signedObjectResponse = response as! JSON
            print(signedObjectResponse)
            if signedObjectResponse["Status"].stringValue == "Success"
            {
                if ConnectionCheck.isConnectedToNetwork()
                {
                    if object["FormName"].stringValue == Constants.SCRSign1 {
                        Constants.sign1 = signatureTextFieldd.text!
                        Constants.signDate1 = signedObjectResponse["ServerTime"].stringValue
                    }
                    else {
                        Constants.sign2 = signatureTextFieldd.text!
                        Constants.signDate2 = signedObjectResponse["ServerTime"].stringValue
                    }
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
                errorLabell.text = signedObjectResponse["Message"].stringValue
                
            }
        }
        
        
        
    func getresponseFormResponse(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        signedObjectResponse = response as! JSON
        print(signedObjectResponse)
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
            errorLabell.text = signedObjectResponse["Message"].stringValue
            
        }
    }
    
    
    @IBAction func checkBoxAction(_ sender: Any) {
        if checked
        {
            checkBoxx.setImage(UIImage(named: "unchecked.png"), for:.normal)
            checked = false
        }
        else
        {
            checkBoxx.setImage(UIImage(named:"check.png"), for:.normal)
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
