//
//  EmailViewController.swift
//  EWA
//
//  Created by NFC India on 13/08/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON

class EmailViewController: UIViewController,UITextViewDelegate {
    
    
    @IBOutlet weak var fromLabel: UILabel!
    var jobDetails:JSON = JSON.null
    var emailResponse:JSON = JSON.null
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var textViewHeigh: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    
    @IBOutlet weak var urlLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewHeight.constant -= 150
        fromLabel.text = jobDetails["FromMail"].stringValue
        urlLabel.text = jobDetails["GmailJobUrl"].stringValue.replace(target:"%26", withString:"&")+"11"
        
        let barButtonItem = UIBarButtonItem(image: UIImage(named:"send"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(menuButtonTapped))
        
        self.navigationItem.rightBarButtonItem = barButtonItem
        self.title = "E-mail"
    }
    @objc fileprivate func menuButtonTapped() {
        
        if bodyTextView.text!.count>0&&subjectTextField.text!.count>0&&toTextField.text!.count>0
        {
            if ConnectionCheck.isConnectedToNetwork()
            {
                
                //                "FromMail":"vunjilideepak415@gmail.com",
                //                "ToMail":"priyadarshinib@nfcsolutionsusa.com",
                //                "MailSubject":"Refer A Friend",
                //                "MailBody":"Testing",
                //                "JobUrl":"http://www.tempositions.com/job/substitute-art-teacher-nyc?refid=1000%26sourceid=3",
                //                "ReferralId":1000,
                //                "OrderId":773270
                
                if fromLabel.text!.isValidEmail()&&toTextField.text!.isValidEmail()
                {
                    ServerService.showActivityIndicatory(uiView:self.view)
                    let params:[String:Any] = ["FromMail":fromLabel.text!,"ToMail":toTextField.text!,"MailSubject":subjectTextField.text!,"JobUrl":urlLabel.text!,"ReferralId":"\(jobDetails["ReferralId"].stringValue)","JobId":"\(jobDetails["OrderId"].stringValue)","MailBody":bodyTextView.text!,"Source":"2","SourceId":"11"]
                    print("********Params For Email******",params)
                    ServerService.sendEmail(self, params:params,method:"POST", accessToken:Constants.Token, acces:true, callBack:self.getresponseForSendEmail(response:))
                }
                else
                {
                    ServerService.ShowAlertMessage(ErrorMessage:"",title:"Please enter valid email", view:self)
                }
            }
            else
            {
                ServerService.hideProgressView()
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection",view:self)
            }
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage:"Enter all the fields", title: "",view:self)
        }
    }
    
    //getresponseForJobsDetails Response
    func getresponseForSendEmail(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        print(response)
        emailResponse = response as! JSON
        if emailResponse["MessageStatus"].intValue == 1
        {
            let alertController = UIAlertController(title:"",message:emailResponse["Message"].stringValue, preferredStyle:UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            { action -> Void in
                self.navigationController?.popViewController(animated:true)
            })
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage:emailResponse["Message"].stringValue, title: "",view:self)
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let sizeToFitIn = CGSize(width:textView.bounds.size.width,height:CGFloat(MAXFLOAT))
        let newSize = textView.sizeThatFits(sizeToFitIn)
        self.textViewHeigh.constant = newSize.height
        if newSize.height<(viewHeight.constant-160)
        {
            
        }
        else
        {
            viewHeight.constant = newSize.height+160
        }
        
    }
    
}



