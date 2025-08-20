//
//  FormView.swift
//  EWA
//
//  Created by NFC India on 10/05/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON


protocol formDelegate: class {
    func formStatus(success:Bool, skipStatus:Int)
}

class FormView: UIView {
    
    @IBOutlet weak var signatureButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var signitureLabel: UILabel!
    @IBOutlet weak var formWeb: WKWebView!
    
    var formsObject:JSON = JSON.null
    weak var formDelegate: formDelegate?
    var ASHTSkip = String()
    
    func loadForm()
    {
        if formsObject["ASHTSkip"].stringValue == "1" {
            signatureButton.setTitle("Skip", for: .normal)
            signatureButton.isHidden = false
            signitureLabel.isHidden = true
            dateLabel.isHidden = true
        }
        else if formsObject["ASHTSkip"].stringValue == "2"{
            signatureButton.setTitle("Press To Sign", for: .normal)
            signatureButton.isHidden = true
            signitureLabel.isHidden = true
            dateLabel.isHidden = true
        }
        else {
            signatureButton.setTitle("Press To Sign", for: .normal)
            signatureButton.isHidden = false
            signitureLabel.isHidden = false
            dateLabel.isHidden = false
        }
//        formsObject["File"] = "https://docs.google.com/viewer?embedded=true&url=https://apps.tempositions.com/eWA/Handbooks/SupplementHandbooks/TemPositions - New York.pdf"

        if formsObject["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:"").count > 0 {

            let url = URL(string: formsObject["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
            print("the url is coming as", url as Any)
            let request = URLRequest(url: url!)

            formWeb.load(request)
        }
       
    }
    
    @IBAction func formAction(_ sender: Any)
    {
        
        if formsObject["ASHTSkip"].stringValue == "1" {
            ServerService.showActivityIndicatory(uiView:self)
            let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":"","FormName":formsObject["FormName"].stringValue]
            print("viv line 63 form view \(params)***")
            ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(UIApplication.getTopMostViewController()!, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
        }
        else {
            print("*********** viv Forms in formView is *********",formsObject)
            
            let signView = Bundle.main.loadNibNamed("SignView", owner: nil, options: nil)![0] as! SignView
            signView.frame = CGRect(x:0,y:0, width:self.bounds.width, height:self.bounds.height)
            signView.setUp()
            signView.object = formsObject
            signView.signDelegate = self
            self.addSubview(signView)
            self.bringSubview(toFront:signView)
        }
    }
    
    func getresponseFormResponse(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        let signedObjectResponse = response as! JSON
        print(signedObjectResponse)
        if signedObjectResponse["Status"].stringValue == "Success"
        {
            if ConnectionCheck.isConnectedToNetwork()
            {
                
                self.signatureStatus(success:true)
                removePickerViewFromSuperView()
            }
            else
            {
                
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:UIApplication.getTopMostViewController()!)
            }
        }
        else
        {
            
            ServerService.ShowAlertMessage(ErrorMessage:signedObjectResponse["Message"].stringValue, title: "", view:UIApplication.getTopMostViewController()!)
        }
    }
    
    
    // function to remove from superView
    func removePickerViewFromSuperView(){
        
        self.frame = CGRect(x:0,y:UIScreen.main.bounds.size.height,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
        
        UIView.animate(withDuration: 2.8, animations:  {
            
            self.removeFromSuperview()
            
        }) { (animationComplete) in
        }
    }
}


extension FormView:signatureDelagte
{
    func signatureStatus(success: Bool) {
        print("success")
        removePickerViewFromSuperView()
        if formsObject["ASHTSkip"].stringValue == "1" {
            formDelegate?.formStatus(success:true, skipStatus: 1)
        }
        else {
            formDelegate?.formStatus(success:true, skipStatus: 0)
        }
    }
    
}
