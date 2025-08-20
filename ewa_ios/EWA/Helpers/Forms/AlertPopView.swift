//
//  AlertPopView.swift
//  EWA
//
//  Created by NFC User on 4/17/20.
//  Copyright © 2020 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol popAlertDelegate: class {
    func formStatus(success:Bool)
}

class AlertPopView: UIView {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var dataTextView: UITextView!
    
    @IBOutlet weak var okButton: UIButton!
    weak var popAlertDelegate: popAlertDelegate?
    var clrStatus = Int()
    var toCOntroller = UIViewController()
    var container: UIView = UIView()
    var actInd = UIActivityIndicatorView()
    var apiCallrequired = Bool()
    var viewStatus = Int()
    var messageText = String()
    var popKeyToSend = String()
    var removeHard = Bool()
    var attrbtedText = NSAttributedString()
    
    func removePickerViewFromSuperView(){
        
        self.frame = CGRect(x:0,y:UIScreen.main.bounds.size.height,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
        
        UIView.animate(withDuration: 2.8, animations:  {
            
            self.removeFromSuperview()
            
        }) { (animationComplete) in
        }
    }
    
    func loadForm () {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.orientationChanged(notification:)),
            name: NSNotification.Name.UIDeviceOrientationDidChange,
            object: nil
        )

        self.loadUI()
        let hheightt = viewHeight.constant
        
        switch UIDevice.current.orientation{
        case .portrait:
            if hheightt >= UIScreen.main.bounds.height  {
                viewHeight.constant = hheightt - 40
            }
            else {
                viewHeight.constant = hheightt
            }
        case .landscapeLeft:
            if hheightt >= self.bounds.size.height {
                viewHeight.constant = self.bounds.size.height - 30
            }
            else {
                viewHeight.constant = hheightt
            }
        case .landscapeRight:
            if hheightt >= self.bounds.size.height {
                viewHeight.constant = self.bounds.size.height - 30
            }
            else {
                viewHeight.constant = hheightt
            }
        default:
            print("Default")
        }
        print(viewHeight.constant)
        
    }
    
    func loadUI() {
        clrStatus = viewStatus
        dataTextView.layer.borderWidth = 1.0
        dataTextView.layer.cornerRadius = 3.0
        outerView.layer.cornerRadius = 5.0
        if messageText.count > 0 {
            self.dataTextView.text = messageText
            
            let length = Constants.calculateHeight(inString:messageText,width:self.bounds.size.width) + 90
            
            if length > self.frame.size.height {
                viewHeight.constant = self.frame.size.height - 80
            }
            else {
                viewHeight.constant = length + 30
            }
        }
        else {
            self.dataTextView.attributedText = attrbtedText
            dataTextView.font = UIFont.systemFont(ofSize: 14)
            let length = attrbtedText.height(containerWidth: self.bounds.size.width) + 135
            
            if length > self.frame.size.height {
                viewHeight.constant = self.frame.size.height - 80
            }
            else {
                viewHeight.constant = length + 30
            }
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
    @objc func orientationChanged(notification: Notification) {
        // handle rotation here
        self.loadUI()
        var text=""
        let hheightt = viewHeight.constant
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            if hheightt >= UIScreen.main.bounds.height  {
                viewHeight.constant = hheightt - 40
            }
            else {
                viewHeight.constant = hheightt
            }


        case .landscapeLeft:
            text="LandscapeLeft"
            if hheightt >= self.bounds.size.height {
                viewHeight.constant = self.bounds.size.height - 30
            }
            else {
                viewHeight.constant = hheightt
            }

        case .landscapeRight:
            text="LandscapeRight"
            if hheightt >= self.bounds.size.height {
                viewHeight.constant = self.bounds.size.height - 30
            }
            else {
                viewHeight.constant = hheightt
            }

        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
    }
    //MARK:- Ok Action
    @IBAction func okClicked(_ sender: UIButton) {
        
        
        if apiCallrequired == false {
            if viewStatus == 3 {
                if removeHard == true {
                    removePickerViewFromSuperView()
                    popAlertDelegate?.formStatus(success: true)
                }
            }
            else {
                removePickerViewFromSuperView()
                popAlertDelegate?.formStatus(success: true)
            }
        }
        else {
            
            if ConnectionCheck.isConnectedToNetwork()
            {
                showActivityIndicatory(uiView:self)
                let paramsMenu:[String:Any] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"PopupKey": popKeyToSend]
                print(paramsMenu)
                ServerService.submitglobalForm(UIApplication.getTopMostViewController()!, params: paramsMenu, method:"POST", accessToken:Constants.Token, acces:true, callBack: getFormOkResponse(response:))
                
            }
            else
            {
                self.hideProgressView()
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:UIApplication.getTopMostViewController()!)
                
            }
        }
        
    }
    
    //MARK:- OkCLickResponse
    func getFormOkResponse(response:AnyObject)->()
    {
        self.hideProgressView()
        var formRespObject: JSON = JSON.null
        formRespObject = response as! JSON
        print(formRespObject)
        
        if formRespObject["MessageStatus"].intValue == 1 {
            removePickerViewFromSuperView()
            popAlertDelegate?.formStatus(success: true)
        }
        else {
            ServerService.ShowAlertMessage(ErrorMessage:formRespObject["Message"].stringValue, title: "", view:UIApplication.getTopMostViewController()!)
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
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
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
    
    
}
extension UIView {
    //activity indicator method
    func showActivityIndicator(uiView: UIView, container: UIView, actInd: UIActivityIndicatorView) {
        
        
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
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
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
    func hideActivityIndicator(container: UIView) {
        
        container.removeFromSuperview()
        self.viewWithTag(1001)?.removeFromSuperview()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
extension NSAttributedString {

    func height(containerWidth: CGFloat) -> CGFloat {

        let rect = self.boundingRect(with: CGSize.init(width: containerWidth-50, height: CGFloat.greatestFiniteMagnitude),
                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                     context: nil)
        return ceil(rect.size.height)
    }

    func width(containerHeight: CGFloat) -> CGFloat {

        let rect = self.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: containerHeight),
                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                     context: nil)
        return ceil(rect.size.width)
    }
}
