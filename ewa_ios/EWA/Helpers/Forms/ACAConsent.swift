//
//  ACAConsent.swift
//  EWA
//
//  Created by NFC India on 04/10/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON


protocol aCAConsent: class {
    func acaStatus(success:Bool)
}



class ACAConsent: UIView {

    //ACA Consent Form 1095-C
   
    @IBOutlet weak var aca1905Label: UILabel!
    @IBOutlet weak var aca1095WebView: WKWebView!
    
    var payStubDetails:JSON = JSON.null
    weak var acaDelegate: aCAConsent?
    
    
    func loadForm()
    {
        let url = URL(string:payStubDetails["File"].stringValue.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
        let request = URLRequest(url: url!)
        aca1095WebView.load(request)
    }
    
    
    func setUp()
    {
        let formattedStrings = NSMutableAttributedString()
        formattedStrings
            .normal("To indicate you would prefer")
            .bold("NOT")
            .normal("to receive the ACA form electronically, We will ask you to sign this form electronically by clicking the “Press to Sign” box to the right.")
        formattedStrings.addAttribute(NSAttributedStringKey.foregroundColor, value:UIColor.black, range: NSRange(location:0,length:formattedStrings.length))
        aca1905Label.attributedText = formattedStrings
        aca1905Label.font = UIFont.systemFont(ofSize:15)
    }
    
    //aca1905c
    @IBAction func aca1095cSignReceive(_ sender: Any) {
        print("*********** Forms in formView is *********",payStubDetails)
        
        let signView = Bundle.main.loadNibNamed("SignView", owner: nil, options: nil)![0] as! SignView
        signView.frame = CGRect(x:0,y:0, width:self.bounds.width, height:self.bounds.height)
        signView.setUp()
        signView.object = payStubDetails
        signView.signDelegate = self
         signView.aca1905cRequire = true
        self.addSubview(signView)
        self.bringSubview(toFront:signView)
    }
    
    @IBAction func aca1095cSignDontReceive(_ sender: Any) {
        
        print("*********** Forms in formView is *********",payStubDetails)
        
        let signView = Bundle.main.loadNibNamed("SignView", owner: nil, options: nil)![0] as! SignView
        signView.frame = CGRect(x:0,y:0, width:self.bounds.width, height:self.bounds.height)
        signView.setUp()
        signView.object = payStubDetails
        signView.signDelegate = self
        signView.aca1905cRequire = false
        self.addSubview(signView)
        self.bringSubview(toFront:signView)
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

extension ACAConsent:signatureDelagte
{
    func signatureStatus(success: Bool) {
        print("success")
        removePickerViewFromSuperView()
        acaDelegate?.acaStatus(success:true)
    }
    
}
