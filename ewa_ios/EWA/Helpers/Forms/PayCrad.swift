//
//  PayCrad.swift
//  EWA
//
//  Created by NFC India on 04/10/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import ActiveLabel

protocol payCardDelegate: class {
    func payCardStatus(success:Bool)
}



class PayCrad: UIView {

    @IBOutlet weak var payGuradLabel: ActiveLabel!
    var payStubDetails:JSON = JSON.null
    var signedObjectResponse:JSON = JSON.null
    weak var payCardDelegate: payCardDelegate?
    
    func setUp()
    {
        let customType = ActiveType.custom(pattern: "\\sHere\\b")
        payGuradLabel.enabledTypes.append(customType)
        payGuradLabel.customize { label in
            label.text = "Please click Here to acknowledge the change to the new Bank of America Money Network Pay Service"
            label.numberOfLines = 0
            label.lineSpacing = 4
            label.textColor = UIColor.black
            
            //Custom types
            label.customColor[customType] = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
            label.handleCustomTap(for: customType) { self.alert("Custom type", message: $0) }
            
        }
    }
    
    func alert(_ title: String, message: String) {
        print("tapped")
        //ANLoader.showLoading("", disableUI:false)
        ServerService.showActivityIndicatory(uiView:self)
        let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "cID") as! String,"Name":UserDefaults.standard.object(forKey:"CandName") as! String,"CandSignName":UserDefaults.standard.object(forKey:"CandName") as! String,"FormName":payStubDetails["FormName"].stringValue]
        print(params)
        ServerService.formsAndDocumentsInsertFormsAndDocumentsDetails(UIApplication.getTopMostViewController()!, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
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
                
                payCardDelegate?.payCardStatus(success:true)
                removePickerViewFromSuperView()
            }
            else
            {
                
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:UIApplication.getTopMostViewController()!)
            }
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage:signedObjectResponse["Message"].stringValue, title:"", view:UIApplication.getTopMostViewController()!)
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
