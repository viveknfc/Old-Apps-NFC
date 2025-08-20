//
//  ACAElectronicDelivery.swift
//  EWA
//
//  Created by NFC India on 04/10/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON

protocol acaConsentDelivery: class {
    func acaElectronicDeliveryStatus(success:Bool)
}



class ACAElectronicDelivery: UIView {

  @IBOutlet weak var acaWebView: WKWebView!
    var payStubDetails:JSON = JSON.null
    weak var acaDelegate: acaConsentDelivery?
    
    func loadForm()
    {
        let url = URL(string:payStubDetails["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
        let request = URLRequest(url: url!)
        acaWebView.load(request)
    }
    
    
    // function to remove from superView
    func removePickerViewFromSuperView(){
        
        self.frame = CGRect(x:0,y:UIScreen.main.bounds.size.height,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
        
        UIView.animate(withDuration: 2.8, animations:  {
            
            self.removeFromSuperview()
            
        }) { (animationComplete) in
        }
    }
    
    ////acaConsentView
    @IBAction func acaReceiveElectronically(_ sender: Any) {
       
        print("*********** Forms in formView is *********",payStubDetails)
        
        let signView = Bundle.main.loadNibNamed("SignView", owner: nil, options: nil)![0] as! SignView
        signView.frame = CGRect(x:0,y:0, width:self.bounds.width, height:self.bounds.height)
        signView.setUp()
        signView.object = payStubDetails
        signView.signDelegate = self
        signView.acaRequire = false
        self.addSubview(signView)
        self.bringSubview(toFront:signView)
    }
    
    @IBAction func acaDontReceive(_ sender: UIButton) {
       
        print("*********** Forms in formView is *********",payStubDetails)
        
        let signView = Bundle.main.loadNibNamed("SignView", owner: nil, options: nil)![0] as! SignView
        signView.frame = CGRect(x:0,y:0, width:self.bounds.width, height:self.bounds.height)
        signView.setUp()
        signView.object = payStubDetails
        signView.signDelegate = self
        signView.acaRequire = false
        self.addSubview(signView)
        self.bringSubview(toFront:signView)
    }
    
}

extension ACAElectronicDelivery:signatureDelagte
{
    func signatureStatus(success: Bool) {
        print("success")
        removePickerViewFromSuperView()
        acaDelegate?.acaElectronicDeliveryStatus(success:true)
    }
    
}
