//
//  AddHouseHoldMember.swift
//  EWA
//
//  Created by NFC User on 8/6/21.
//  Copyright © 2021 NFC. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import DropDown
import SwiftyJSON

class AddHouseHoldMember: UIView, UITextFieldDelegate, popDateDelegate {
    
    @IBOutlet weak var chooseGenderButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var viewHeight: NSLayoutConstraint! // 460
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var dobTF: SkyFloatingLabelTextField!
    @IBOutlet weak var relationshipTF: SkyFloatingLabelTextField!
    @IBOutlet weak var firstNameTF: SkyFloatingLabelTextField!
    @IBOutlet weak var sexTF: SkyFloatingLabelTextField!
    let allowedCharacters = CharacterSet(charactersIn:"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ").inverted
    
    let onlyAlphabets = CharacterSet(charactersIn:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ").inverted
    
    let onlyNumbers = CharacterSet(charactersIn:"0123456789").inverted
    @IBOutlet weak var lastNameTF: SkyFloatingLabelTextField!
    let dropDown = DropDown() //2
    var isEdit = Bool()
    var dataObject:JSON = JSON.null
    
    func loadView(){
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.orientationChanged(notification:)),
            name: NSNotification.Name.UIDeviceOrientationDidChange,
            object: nil
        )
        
        topLabel.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        relationshipTF.delegate = self
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        dobTF.delegate = self
        sexTF.delegate = self
        
        switch UIDevice.current.orientation{
        case .portrait:
            viewHeight.constant = 460
        case .landscapeLeft:
            viewHeight.constant = self.bounds.size.height - 30
        case .landscapeRight:
            viewHeight.constant = self.bounds.size.height - 30
        default:
            print("Default")
        }
        
        DispatchQueue.main.async {
            if self.isEdit {
                self.addButton.setTitle("Submit", for: .normal)
                self.topLabel.text = "Edit Household Member"
                self.relationshipTF.text = self.dataObject["AplRelationship"].stringValue
                self.firstNameTF.text = self.dataObject["AplFname"].stringValue
                self.lastNameTF.text = self.dataObject["AplLname"].stringValue
                self.dobTF.text = self.dataObject["AplDOB"].stringValue
                self.sexTF.text = self.dataObject["AplSex"].stringValue
            }
            else {
                self.addButton.setTitle("Add", for: .normal)
                self.topLabel.text = "Add Household Member"
                self.relationshipTF.text = ""
                self.firstNameTF.text = ""
                self.lastNameTF.text = ""
                self.dobTF.text = ""
                self.sexTF.text = ""
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
            viewHeight.constant = 460
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
    @IBAction func chooseSex(_ sender: UIButton) {
        dropDown.dataSource = [" ", "M", "F"]//4
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        dropDown.backgroundColor = .white
        dropDown.show() //7
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal) //9
            self!.sexTF.text = item
        }
    }
    @IBAction func addClicked(_ sender: UIButton) {
        //AddHouseHoldMember
        self.endEditing(true)
        if !relationshipTF.isEmpty && !lastNameTF.isEmpty && !firstNameTF.isEmpty && !sexTF.isEmpty && !dobTF.isEmpty
        {
            if ConnectionCheck.isConnectedToNetwork()
            {
                ServerService.showActivityIndicatory(uiView:(UIApplication.getTopMostViewController()?.view)!)
                
                var params =
                    ["CandId" : UserDefaults.standard.object(forKey: "cID") as! String,"ApplicantId":"","AplRelationship":relationshipTF.text!,"AplLname":lastNameTF.text!,"AplFname":firstNameTF.text!,"AplSex":sexTF.text!,"AplDOB":dobTF.text!,"AplDobMon":"","AplDobDay":"","AplDobYear":"","Status":"","Message":""]  as [String : Any]
                
                
                if isEdit{
                    
                     params["Id"] = dataObject["Id"].stringValue
                    print(params)
                    ServerService.UpdateHouseHoldMember((UIApplication.getTopMostViewController())!, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.houseHoldDataObject(response:))
                }
                else {
                    print(params)
                    ServerService.AddHouseHoldMember((UIApplication.getTopMostViewController())!, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.houseHoldDataObject(response:))
                }
            }
            else
            {
                ServerService.hideProgressView()
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:(UIApplication.getTopMostViewController())!)
                
            }
        }
        else{
            ServerService.ShowAlertMessage(ErrorMessage:"", title:"Please fill all the details", view:(UIApplication.getTopMostViewController())!)
        }        
       
    }
    
    
    func houseHoldDataObject(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        let responseObject = response as! JSON
        print("****** Add/Edit HouseHold Member Response is *******\n",responseObject)
        if responseObject["Status"].intValue == 1 {
            let alert = UIAlertController(title:responseObject["Message"].stringValue, message: "", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "Ok",
                                   style: .default) { (action: UIAlertAction!) -> Void in
                self.removePickerViewFromSuperView()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:"ReloadSCRConsent"), object:nil)
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
    
    
    @IBAction func closeClicked(_ sender: UIButton) {
        self.removePickerViewFromSuperView()
    }
    
    //MARK:- TextField Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if textField == lastNameTF || textField == firstNameTF || textField == relationshipTF {
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
        if textField == dobTF {
            self.endEditing(true)
            textField.resignFirstResponder()
            self.showCalender(type: 0, HeadingText: "Select Date of Birth", dateToSelect: dobTF.text!)
            return false
        }
        else if textField == sexTF {
            self.endEditing(true)
            textField.resignFirstResponder()
            delayWithSeconds(0.2) {
                self.endEditing(true)
                self.sexTF.resignFirstResponder()
            }
            chooseGenderButton.sendActions(for: .touchUpInside)
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
            self.dobTF.resignFirstResponder()
        }
        
    }
    
    func selectedDate(date: String, type: Int) {
        dobTF.text = date
    }
}
