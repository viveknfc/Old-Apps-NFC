//
//  AddAddress.swift
//  EWA
//
//  Created by NFC User on 7/20/21.
//  Copyright © 2021 NFC. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyJSON

class AddAddress: UIView, popDateDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var warningMessageLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var addressTF: SkyFloatingLabelTextField!
    @IBOutlet weak var aptTF: SkyFloatingLabelTextField!
    @IBOutlet weak var cityTF: SkyFloatingLabelTextField!
    @IBOutlet weak var stateTF: SkyFloatingLabelTextField!
    @IBOutlet weak var zipTF: SkyFloatingLabelTextField!
    @IBOutlet weak var fromDateTF: SkyFloatingLabelTextField!
    @IBOutlet weak var toDateTF: SkyFloatingLabelTextField!
    @IBOutlet var addTextFields: [SkyFloatingLabelTextField]!
    var warningMessageText = String()
    var responseObject:JSON = JSON.null
    @IBOutlet weak var topLabel: UILabel!
    var activeTF = UITextField()
    var isEdit = Bool()
    var dataObject:JSON = JSON.null
    let alphaNumeric = CharacterSet(charactersIn:"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ").inverted
    let onlyAlphabets = CharacterSet(charactersIn:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ").inverted
    var isFromSCRConsent = Bool()
    func loadView(){
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.orientationChanged(notification:)),
            name: NSNotification.Name.UIDeviceOrientationDidChange,
            object: nil
        )
        topLabel.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        addressTF.delegate = self
        aptTF.delegate = self
        cityTF.delegate = self
        stateTF.delegate = self
        zipTF.delegate = self
        fromDateTF.delegate = self
        toDateTF.delegate = self
        
        switch UIDevice.current.orientation{
        case .portrait:
            if UIScreen.main.bounds.height < 500 {
                viewHeight.constant = 450
            }
            else {
                viewHeight.constant = 580
            }
        case .landscapeLeft:
            viewHeight.constant = self.bounds.size.height - 30
        case .landscapeRight:
            viewHeight.constant = self.bounds.size.height - 30
        default:
            print("Default")
        }
        /*
         "AplCity" : "New York",
         "Timestamp" : "0001-01-01T00:00:00",
         "ApplicantId" : 181955,
         "AplZip" : "10007",
         "RequestedFromDashboard" : 0,
         "AplCountryCode" : "",
         "AplCSAddress" : "New York, NY, USA",
         "AplTo2" : "2021-08-12T00:00:00",
         "AplState" : "NY",
         "AplApt" : "4D2",
         "Id" : 38533,
         "AplCountry" : "",
         "AplFrom" : "2021-03-12T00:00:00",
         "AplTo" : "2021-08-12T00:00:00"
         }
         */
        
        self.addressTF.isEnabled = true
        self.aptTF.isEnabled = true
        self.cityTF.isEnabled = true
        self.stateTF.isEnabled = true
        self.zipTF.isEnabled = true
        self.fromDateTF.isEnabled = true
        self.toDateTF.isEnabled = true
        
        DispatchQueue.main.async {
            if self.isEdit {
                self.warningMessageLabel.text = ""
                self.addButton.setTitle("Submit", for: .normal)
                self.topLabel.text = "Edit Address"
                if self.isFromSCRConsent {
                    self.addressTF.isEnabled = false
                    self.aptTF.isEnabled = false
                    self.cityTF.isEnabled = false
                    self.stateTF.isEnabled = false
                    self.zipTF.isEnabled = false
                    self.fromDateTF.isEnabled = false
                    self.toDateTF.isEnabled = true
                    
                    self.addressTF.text = self.dataObject["AplCSAddress"].stringValue
                    self.aptTF.text = self.dataObject["AplApt"].stringValue
                    self.cityTF.text = self.dataObject["AplCity"].stringValue
                    self.stateTF.text = self.dataObject["AplState"].stringValue
                    self.zipTF.text = self.dataObject["AplZip"].stringValue
                    self.fromDateTF.text = self.dataObject["AplFrom"].stringValue
                    self.toDateTF.text = self.dataObject["AplTo"].stringValue
                }
                else {
                    self.addressTF.text = self.dataObject["Address"].stringValue
                    self.aptTF.text = self.dataObject["APT"].stringValue
                    self.cityTF.text = self.dataObject["City"].stringValue
                    self.stateTF.text = self.dataObject["State"].stringValue
                    self.zipTF.text = self.dataObject["Zip"].stringValue
                    self.fromDateTF.text = self.dataObject["FromDate"].stringValue
                    self.toDateTF.text = self.dataObject["ToDate"].stringValue
                }
                
                
            }
            else {
                if self.isFromSCRConsent {
                    self.warningMessageLabel.text = self.warningMessageText
                }
                else {
                    self.warningMessageLabel.text = ""
                }
                self.addButton.setTitle("Add", for: .normal)
                self.topLabel.text = "Add Address"
                self.addressTF.text = ""
                self.aptTF.text = ""
                self.cityTF.text = ""
                self.stateTF.text = ""
                self.zipTF.text = ""
                self.fromDateTF.text = ""
                self.toDateTF.text = ""
            }
        }
    }
    func removePickerViewFromSuperView(){
        
        self.frame = CGRect(x:0,y:UIScreen.main.bounds.size.height,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
        
        UIView.animate(withDuration: 1.5, animations:  {
            
            self.removeFromSuperview()
            
        }) { (animationComplete) in
        }
    }
    
    @objc func orientationChanged(notification: Notification) {
        // handle rotation here
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            if UIScreen.main.bounds.height < 500 {
                viewHeight.constant = 450
            }
            else {
                viewHeight.constant = 580
            }
            
        case .landscapeLeft:
            text="LandscapeLeft"
            viewHeight.constant = self.bounds.size.height - 30
            
        case .landscapeRight:
            text="LandscapeRight"
            viewHeight.constant = self.bounds.size.height - 30
            
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
    }
    @IBAction func closeClicked(_ sender: UIButton) {
        
        self.removePickerViewFromSuperView()
    }
    
    @IBAction func addClicked(_ sender: UIButton) {
        var isvalid = true
        /*
         for v in 0..<addTextFields.count
         {
         if (addTextFields[v].text?.replacingOccurrences(of: " ", with: "").count)!>0
         {
         isvalid = true
         }
         else
         {
         isvalid = false
         break
         }
         }
         */
        
        if (addressTF.text?.replacingOccurrences(of: " ", with: "").count)!>0 && (cityTF.text?.replacingOccurrences(of: " ", with: "").count)!>0 && (stateTF.text?.replacingOccurrences(of: " ", with: "").count)!>0 && (zipTF.text?.replacingOccurrences(of: " ", with: "").count)!>0 &&
            (fromDateTF.text?.replacingOccurrences(of: " ", with: "").count)!>0 && (toDateTF.text?.replacingOccurrences(of: " ", with: "").count)!>0  {
            isvalid = true
        }
        else
        {
            isvalid = false
            
        }
        
        if isvalid
        {
            let formatter = DateFormatter()
            formatter.locale = Locale.preferredLocale()
            formatter.dateFormat = "MM/dd/yyyy"
            
            let fromDaate = formatter.date(from: fromDateTF.text!)
            let toDaate = formatter.date(from: toDateTF.text!)
            
            if toDaate! < fromDaate! || toDaate! == fromDaate!{
                ServerService.ShowAlertMessage(ErrorMessage:"", title:"To date should be greater than From date", view:(UIApplication.getTopMostViewController())!)
            }
            else {
                if isFromSCRConsent{
                    addSCRConsentAddress()
                }
                else {
                    add_address()
                }
            }
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage:"", title:"Please fill all the details", view:(UIApplication.getTopMostViewController())!)
        }
    }
    func add_address(){
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:(UIApplication.getTopMostViewController()?.view)!)
            var params =
            ["CandidateId" : UserDefaults.standard.object(forKey: "cID") as! String,"Name":"","FirstName":"","LastName":"","Address":addressTF.text!,"APT":aptTF.text!,"Floor":"","City":cityTF.text!,"State":stateTF.text!,"Zip":zipTF.text!,"Phone":"","Email":"","DOB":"","FromDate":fromDateTF.text!,"ToDate":toDateTF.text!,"Status":"","Message":""]  as [String : Any]
            
            
            if isEdit{
                
                params["AddressId"] = dataObject["AddressId"].stringValue
                print(params)
                ServerService.EditA1Address((UIApplication.getTopMostViewController())!, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.addressInsertDataObject(response:))
            }
            else {
                print(params)
                ServerService.InsertA1Address((UIApplication.getTopMostViewController())!, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.addressInsertDataObject(response:))
            }
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:(UIApplication.getTopMostViewController())!)
            
        }
    }
    
    
    func addSCRConsentAddress(){
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:(UIApplication.getTopMostViewController()?.view)!)
            var params =
            ["CandId" : UserDefaults.standard.object(forKey: "cID") as! String,"ApplicantId":"","AplCSAddress":addressTF.text!,"AplApt":aptTF.text!,"AplCity":cityTF.text!,"AplState":stateTF.text!,"AplZip":zipTF.text!,"AplFrom":fromDateTF.text!,"AplTo":toDateTF.text!,"Status":"","Message":"","Timestamp":"","AplCountry":"","AplTo2":"","AplCountryCode":"","RequestedFromDashboard":""]  as [String : Any]
            
            
            if isEdit{
                
                params["Id"] = dataObject["Id"].stringValue
                print(params)
                ServerService.SCREditAddress((UIApplication.getTopMostViewController())!, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.addressInsertDataObject(response:))
            }
            else {
                print(params)
                ServerService.AddSCRAddress((UIApplication.getTopMostViewController())!, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.addressInsertDataObject(response:))
            }
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:(UIApplication.getTopMostViewController())!)
            
        }
    }
    // response from the server
    func addressInsertDataObject(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        responseObject = response as! JSON
        print("****** Add/Edit Address Response is ************\n",responseObject)
        if responseObject["Status"].intValue == 1 {
            let alert = UIAlertController(title:responseObject["Message"].stringValue, message: "", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "Ok",
                                   style: .default) { [self] (action: UIAlertAction!) -> Void in
                self.removePickerViewFromSuperView()
                if self.isFromSCRConsent {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue:"ReloadSCRConsent"), object:nil)
                }
                else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue:"ReloadAddress"), object:nil)
                }
            }
            alert.addAction(ok)
            (UIApplication.getTopMostViewController())!.present(alert, animated:true, completion:nil)
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
        
        if textField == aptTF {
            let components = string.components(separatedBy: alphaNumeric)
            let filtered = components.joined(separator: "")
            
            if string == filtered {
                
                return true
                
            } else {
                
                return false
            }
        }
        else if textField == stateTF {
            let components = string.components(separatedBy: onlyAlphabets)
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
        if textField == fromDateTF {
            activeTF = fromDateTF
            self.endEditing(true)
            textField.resignFirstResponder()
            self.showCalender(type: 0, HeadingText: "Select From Date", dateToSelect: fromDateTF.text!)
            return false
        }
        if textField == toDateTF {
            activeTF = toDateTF
            self.endEditing(true)
            textField.resignFirstResponder()
            self.showCalender(type: 0, HeadingText: "Select To Date", dateToSelect: toDateTF.text!)
            return false
        }
        else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
        
    }
    
    //MARK:- Show Calendar
    func showCalender(type: Int, HeadingText: String, dateToSelect:String) {
        
        let window = UIApplication.shared.keyWindow!
        
        let formView = Bundle.main.loadNibNamed("DateSelection", owner: nil, options: nil)![0] as! DateSelection
        
        formView.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
        formView.topLabelText = HeadingText
        formView.type = type
        formView.toCOntroller = (UIApplication.getTopMostViewController())!
        formView.dateDelegate = self
        formView.selectedDate = dateToSelect
        formView.loadDateView()
        window.addSubview(formView)
        window.bringSubview(toFront: formView)
        delayWithSeconds(0.2) {
            self.endEditing(true)
            self.fromDateTF.resignFirstResponder()
            self.toDateTF.resignFirstResponder()
        }
        
    }
    
    func selectedDate(date: String, type: Int) {
        if activeTF == fromDateTF {
            fromDateTF.text = date
        }
        else {
            toDateTF.text = date
        }
    }
    
}
