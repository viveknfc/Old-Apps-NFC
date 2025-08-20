//
//  MessageDetailViewController.swift
//  EWA
//
//  Created by NFC Solutions on 20/10/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON

class MessageDetailViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet var contentView: UIView!
    var message = String()
    var name = String()
    var level = String()
    var messageId = String()
    var respond = String()
    var email = String()
    var object: JSON = JSON.null
    @IBOutlet weak var heightConstrain: NSLayoutConstraint!
    @IBOutlet var respondButton: UIButton!
    @IBOutlet var respondTextView: UITextView!
    @IBOutlet var aScrollView: UIScrollView!
    @IBOutlet var messageLabel: UILabel!
    var activeField:UITextView?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        messageLabel.text = message.removeHtmlFromString(inPutString: message)
        self.navigationItem.title = name
        
        let labelTextSize = self.messageLabel.text?.boundingRect(with: CGSize(width: CGFloat(self.messageLabel.frame.size.width), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: self.messageLabel.font], context: nil).size
        
        
        if (labelTextSize?.height)! > self.view.bounds.size.height-65
        {
            if respond == "1"
            {
                self.heightConstrain.constant += ((labelTextSize?.height)!+150)-self.view.bounds.size.height+140
                respondTextView.isHidden = false
                respondButton.isHidden = false
            }
            else
            {
                self.heightConstrain.constant += ((labelTextSize?.height)!+150)-self.view.bounds.size.height
                respondTextView.isHidden = true
                respondButton.isHidden = true
            }
            aScrollView.isScrollEnabled = true
        }
        else
        {
            if respond == "1"
            {
                respondTextView.isHidden = false
                respondButton.isHidden = false
            }
            else
            {
                respondTextView.isHidden = true
                respondButton.isHidden = true
            }
            aScrollView.isScrollEnabled = true
            
        }
        
        respondTextView.placeholder = "Response Comments"
        respondTextView.textColor = UIColor.black
        respondTextView.layer.borderWidth = 1.5
        respondTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        //NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        
        
    }
    
    func keyboardNotification(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    //textViewDelegateMethod
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            view.endEditing(true)
            return false
        }
        else
        {
            return true
        }
    }
    
    //deleteMessageAction
    @IBAction func deleteAction(_ sender: Any)
    {
        //calling the api
        
        let alertController = UIAlertController(title:"Are you sure you want to delete this message?",message:"", preferredStyle:UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default)
        { action -> Void in
            
        })
        alertController.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.default)
        { action -> Void in
            let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"Level":self.level,"MessageId":self.messageId]
            ServerService.deleteMessage(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: self.getresponse(response:))
        })
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //aftergettingResponseFrom the server
    func getresponse(response:AnyObject)->()
    {
        object = response as! JSON
        print(object)
        if object.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if object["Status"].stringValue == "Success"
        {
//            let alertController = UIAlertController(title:object["Message"].stringValue,message:"", preferredStyle:UIAlertControllerStyle.alert)
//
//            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
//            { action -> Void in
                _ = self.navigationController?.popViewController(animated: true)
//            })
//            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage: object["Message"].stringValue, title: "" , view: self)
        }
    }
    
    @IBAction func respondAction(_ sender: Any)
    {
        if respondTextView.text.count>0
        {
            self.view.endEditing(true)
            let params = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"Level":level,"MessageId":messageId,"Email":email,"Name":name,"Message":message.removeHtmlFromString(inPutString:message),"Comments":respondTextView.text] as [String : Any]
            ServerService.respondToMessage(self, params:params, method: "POST", accessToken:Constants.Token, acces:true, callBack: getresponseForComment(response:))
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage:"Please enter message to submit", title: "" , view: self)
        }
    }
    
    //aftergettingResponseFrom the server
    func getresponseForComment(response:AnyObject)->()
    {
        object = response as! JSON
        print("message details",object)
        if object.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if object["Status"].stringValue == "Success"
        {
            self.navigationController?.view.makeToast(object["MessageStaus"].stringValue, duration: 1.0, position: .bottom, title: "", image: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                _ = self.navigationController?.popViewController(animated: true)
            })
            
        }
    }
    
    
    
    //catching the device orentation
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            contentView.layoutIfNeeded()
        case .landscapeLeft:
            text="LandscapeLeft"
            contentView.layoutIfNeeded()
        case .landscapeRight:
            text="LandscapeRight"
            contentView.layoutIfNeeded()
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
    }
}

