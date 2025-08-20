//
//  ApplyJobViewController.swift
//  EMA
//
//  Created by NFC India on 15/01/19.
//  Copyright © 2019 sample. All rights reserved.
//

import UIKit
import MobileCoreServices
import SwiftyJSON

class ApplyJobViewController: UIViewController,UIDocumentPickerDelegate {
    
    
    //reference's from storyboard
    @IBOutlet weak var emailtextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var resumeTextView: UITextView!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNametextField: UITextField!
    @IBOutlet weak var uploadFilesButton: UIButton!
    @IBOutlet weak var documentNameLabel: UILabel!
    
    
    // picked file data
    var fileData = Data()
    var fileBytes = String()
    var fileName = String()
    var fileExt = String()
    var referedJob = ReferAFriend.init(title:"", jobType:"", categoryType:"", orderId:"", imageUrl:"", address:"",jobId:"")
    var submitResponse:JSON = JSON.null
    var jobDetails:JSON = JSON.null
    var orderId = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.title = referedJob.title
        
        configure_TextView()
        configue_UploadButton()
        
        resumeTextView.placeholder = "Resume (Copy & Paste)"
    }
    
    // methos is used to configure the textview adding border to textView
    func configure_TextView()
    {
        
        resumeTextView.layer.borderWidth = 1
        resumeTextView.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    func configue_UploadButton()
    {
        uploadFilesButton.layer.cornerRadius = 5
        uploadFilesButton.layer.masksToBounds = true
        uploadFilesButton.layer.borderWidth = 1
        uploadFilesButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    // called when submit button is clicked
    @IBAction func submitAction(_ sender: Any) {
        
        if firstNametextField.text!.count>0&&lastNameTextField.text!.count>0&&emailtextField.text!.count>0
        {
            
            if emailtextField.text!.isValidEmail() {
                if ConnectionCheck.isConnectedToNetwork()
                {
                    ServerService.showActivityIndicatory(uiView:self.view)
                    
                    let params:[String:Any] =
                        ["FirstName":firstNametextField.text!,"LastName":lastNameTextField.text!,
                         "Email":emailtextField.text!,
                         "RefUrl":jobDetails["JobUrl"].stringValue,
                         "JobId":referedJob.jobId!,
                         "Resume":resumeTextView.text,
                         "AppId":"",
                         "Phone":phoneTextField.text!,
                         "DivId":UserDefaults.standard.value(forKey:"dID") as! String,
                         "DivisionName":"",
                         "RefId":jobDetails["ReferralId"].stringValue,
                         "sourceid": jobDetails["SourceId"].stringValue,
                         "OrderId":orderId,
                         "CompanyName":jobDetails["CompanyName"].stringValue,
                         "LocationCity":jobDetails["City"].stringValue,
                         "LocationState":jobDetails["State"].stringValue,
                         "JobType":      referedJob.jobType!,
                         "JobTitle":     referedJob.title!,
                         "JobCategory": referedJob.categoryType!,
                         "Attachments":[[
                            "FileContent":fileBytes,
                            "FileName":fileName,
                            "FileExt":fileExt
                            ]]
                    ]
                    
                    print("********Params For Apply******",params)
                    ServerService.applyJob(self, params:params,method:"POST", accessToken:Constants.Token, acces:false, callBack:self.getresponseForSubmitJob(response:))
                }
                else
                {
                    ServerService.hideProgressView()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection",view:self)
                }
            }
            else
            {
                
                ServerService.ShowAlertMessage(ErrorMessage:"Please enter valid email address", title: "", view:self)
            }
            
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage:"Required fields cannot be empty", title: "", view:self)
        }
    }
    
    
    func getresponseForSubmitJob(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        print(response)
        submitResponse = response as! JSON
        
        //        "Message": "Success",
        //        "MessageStatus": 1
        if submitResponse["MessageStatus"].intValue == 1
        {
            // Create the alert controller
            let alertController = UIAlertController(title: "", message: submitResponse["Message"].stringValue, preferredStyle: .alert)
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                for aViewController in viewControllers {
                    if aViewController is JobsViewController {
                        self.navigationController!.popToViewController(aViewController, animated: true)
                    }
                }
            }
            // Add the actions
            alertController.addAction(okAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            
            var messgae = String()
            if submitResponse["Message"].stringValue.count>0
            {
                messgae = submitResponse["Message"].stringValue
            }
            else
            {
                messgae = "Something went wrong please try again later"
            }
            ServerService.ShowAlertMessage(ErrorMessage:messgae, title: "", view:self)
        }
        
    }
    
    
    //called when attachements action is tapped
    @IBAction func attachmentsAction(_ sender: Any) {
        
        uploadpickFileClicked()
        
    }
    
    
    // upload action
    @objc func uploadpickFileClicked() {
        
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes:[String(kUTTypeContent)], in: UIDocumentPickerMode.import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(documentPicker, animated: true, completion: nil)
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        if controller.documentPickerMode == UIDocumentPickerMode.import {
            // This is what it should be
            let urlPath = url as URL
            print("The Url is",urlPath)
            fileData = try! Data(contentsOf:urlPath)
            fileBytes = fileData.base64EncodedString()
            fileName =  urlPath.lastPathComponent
            fileExt =   "."+url.lastPathComponent.components(separatedBy:".")[1]
            documentNameLabel.text = fileName
        }
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
    
}
