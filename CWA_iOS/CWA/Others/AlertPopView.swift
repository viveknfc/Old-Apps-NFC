//
//  AlertPopView.swift
//  EWA
//
//  Created by NFC User on 4/17/20.
//  Copyright © 2020 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import SystemConfiguration

protocol popAlertDelegate: class {
    func formStatus(success:Bool)
}
protocol popAlertDashDelegate: class {
    func formStatuss(success:Bool)
}

class AlertPopView: UIView {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var dataTextView: UITextView!
    
    @IBOutlet weak var okButton: UIButton!
     weak var popAlertDelegate: popAlertDelegate?
     weak var popAlertDashDelegate: popAlertDashDelegate?
    var clrStatus = Int()
       var toCOntroller = UIViewController()
       var container: UIView = UIView()
       var actInd = UIActivityIndicatorView()
       var apiCallrequired = Bool()
       var viewStatus = Int()
       var messageText = String()
       var popKeyToSend = String()
       
    func removePickerViewFromSuperView(){
        
        self.frame = CGRect(x:0,y:UIScreen.main.bounds.size.height,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
        
        UIView.animate(withDuration: 2.8, animations:  {
            
            self.removeFromSuperview()
            
        }) { (animationComplete) in
        }
    }
    
    func loadForm () {
        
        clrStatus = viewStatus
        
        dataTextView.layer.borderWidth = 1.0
        dataTextView.layer.cornerRadius = 3.0
        outerView.layer.cornerRadius = 5.0
        self.dataTextView.text = messageText
        
         let length = Constants.calculateHeight(inString:messageText,width:self.bounds.size.width) + 90
        
        if length > self.frame.size.height {
            viewHeight.constant = self.frame.size.height - 80
        }
        else {
            viewHeight.constant = length + 30
        }
        
        
        if clrStatus == 1 {
            
            dataTextView.textColor = UIColor(hexString:Constants.success_Color)
            dataTextView.backgroundColor = UIColor(hexString:Constants.success_background_Color)
            dataTextView.layer.borderColor = UIColor(hexString:Constants.success_border_Color).cgColor
            
        }
        else if clrStatus == 2 {
            dataTextView.textColor = UIColor(hexString:Constants.warning_Color)
            dataTextView.backgroundColor = UIColor(hexString:Constants.warning_background_Color)
            dataTextView.layer.borderColor = UIColor(hexString:Constants.warning_border_Color).cgColor
            
            
        }
        else if clrStatus == 3 {
            dataTextView.textColor = UIColor(hexString:Constants.danger_Color)
            dataTextView.backgroundColor = UIColor(hexString:Constants.danger_background_Color)
            dataTextView.layer.borderColor = UIColor(hexString:Constants.danger_border_Color).cgColor
            
            
        }
        else if clrStatus == 4 {
            dataTextView.textColor = UIColor(hexString:Constants.info_Color)
            dataTextView.backgroundColor = UIColor(hexString:Constants.info_background_Color)
            dataTextView.layer.borderColor = UIColor(hexString:Constants.info_border_Color).cgColor
            
        }
       
    }
    
    //MARK:- Ok Action
    @IBAction func okClicked(_ sender: UIButton) {
        
        
        if apiCallrequired == false {
            if viewStatus == 3 {
                
            }
            else {
                removePickerViewFromSuperView()
                popAlertDelegate?.formStatus(success: true)
                popAlertDashDelegate?.formStatuss(success: true)
            }
        }
        else {
            
           
            let isInternetAvailable = self.isInternetAvailable()
            if isInternetAvailable {
                self.showActivityIndicatory(uiView: self)

                   let ContactId = UserDefaults.standard.object(forKey:"ContactId") as! String
               
                
                //userid as String
                let params :[String:String] = ["ContactId":ContactId,
                "PopupKey": popKeyToSend]
                print(params)
                RestAPI.formOkClickSubmit(UIApplication.getTopMostViewController()!, params: params, method: "POST", accessToken: "", acces: true, callBack: getOkClickResponse(response:))
            }else{
                self.hideProgressView()
                self.showAlertOnWindow("No Internet Connection", messageStr: "Please connect to an active network and try again", okButtonName: "OK")
            }
            
        }
        
    }
    
    func getOkClickResponse(response:AnyObject)->()
       {
           
           self.hideProgressView()
           let object = response as! JSON
           print(object)
           
           var formRespObject: JSON = JSON.null
           formRespObject = response as! JSON
           print(formRespObject)
           
           if formRespObject["MessageStatus"].intValue == 1 {
               removePickerViewFromSuperView()
               popAlertDelegate?.formStatus(success: true)
            popAlertDashDelegate?.formStatuss(success: true)
           }
           else {
                self.showAlertOnWindow("", messageStr: formRespObject["Message"].stringValue, okButtonName: "OK")
           }
           
           
           
       }
    //activity indicator method
        func showActivityIndicatory(uiView: UIView) {
           
           
           container.frame = uiView.frame
           container.center = uiView.center
           container.backgroundColor = UIColor.uicolorFromHex(0xffffff, alpha: 0.1)
           
           let loadingView: UIView = UIView()
           loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
           loadingView.center = uiView.center
           loadingView.backgroundColor = UIColor.black
           loadingView.clipsToBounds = true
           loadingView.layer.cornerRadius = 10
           loadingView.tag = 1001
           
           //let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
           actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            actInd.style =
            UIActivityIndicatorView.Style.whiteLarge
           actInd.center = CGPoint(x: loadingView.frame.size.width/2, y: loadingView.frame.size.height/2);
           loadingView.addSubview(actInd)
           container.addSubview(loadingView)
           //let window = UIApplication.shared.keyWindow!
           self.addSubview(loadingView)
           //uiView.addSubview(container)
           actInd.startAnimating()
           UIApplication.shared.beginIgnoringInteractionEvents()
       }
       
    //removing the activity indicator
        func hideProgressView() {
           container.removeFromSuperview()
           self.viewWithTag(1001)?.removeFromSuperview()
           UIApplication.shared.endIgnoringInteractionEvents()
       }
       
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func showAlertOnWindow(_ titleStr: String, messageStr: String, okButtonName: String){
        
        //let window = UIApplication.shared.keyWindow
        let alertcntrl = UIAlertController.init(title: titleStr, message: messageStr, preferredStyle: .alert)
        
       
        alertcntrl.addAction(UIAlertAction(title: okButtonName,style:UIAlertAction.Style.default,handler: nil))
        self.window?.rootViewController?.present(alertcntrl, animated: true, completion: nil)
        
    }
}

extension UIColor
{
    class func uicolorFromHex(_ rgbValue:UInt32, alpha : CGFloat)->UIColor
    {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0xFF) / 255.0
        return UIColor(red:red, green:green, blue:blue, alpha: alpha)
    }
}
