//
//  UploadResumeViewController.swift
//  EWA
//
//  Created by NFC India on 30/11/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import MobileCoreServices


class UploadResumeViewController: BaseViewController,UIDocumentPickerDelegate {
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var resumeTableView: UITableView!
    var resumes = [Resume]()
    var resumeObject:JSON = JSON.null
    var uploadResumeObject:JSON = JSON.null
    var uploadButton = UIButton()
    
    // picked file data
    var fileData = Data()
    var fileBytes = String()
    var fileName = String()
    var fileExt = String()
    
    @IBOutlet weak var noRecordsLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.title = "Upload Resume"
        
        getResumeList() // calling the getResumeListApi
        
        
        //floating button
       uploadButton = UIButton(frame:CGRect(x: self.view.bounds.size.width-70, y: self.view.bounds.size.height-70, width: 50, height: 50))
        uploadButton.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        uploadButton.setImage(UIImage(named:"ic_upload.png"), for:.normal)
        uploadButton.imageView?.contentMode = .scaleAspectFit
        uploadButton.addTarget(self, action:#selector(self.uploadClicked), for: .touchUpInside)
        uploadButton.titleLabel?.textColor = .white
        uploadButton.titleLabel?.font = UIFont.boldSystemFont(ofSize:25)
        uploadButton.layer.cornerRadius = 25
        uploadButton.layer.masksToBounds = true
        self.view.addSubview(uploadButton)
        self.view.bringSubview(toFront:uploadButton)
        
        
        
    }
    
    //floating button action
    @objc func uploadClicked() {
        
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes:[String(kUTTypeContent)], in: UIDocumentPickerMode.import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(documentPicker, animated: true, completion: nil)
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        if controller.documentPickerMode == UIDocumentPickerMode.import {
            // This is what it should be
            let extensionsArray = [".docx",".doc",".pdf",".rtf",".txt"]
            let urlPath = url as URL
            print("The Url is",urlPath)
            fileData = try! Data(contentsOf:urlPath)
            fileBytes = fileData.base64EncodedString()
            fileName =  urlPath.lastPathComponent
            fileExt =   "."+url.lastPathComponent.components(separatedBy:".")[1]
            
            if extensionsArray.contains(fileExt)
            {
            alertMessage()
            }
            else
            {
                ServerService.ShowAlertMessage(ErrorMessage:"", title:"Only you can enter(.docx,.doc,.pdf,.rtf,.txt)", view:self)
            }
        }
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
 
    //conformationPopUp
    func alertMessage()
    {
        let alert = UIAlertController(title:"", message: "Upload \(fileName) ?", preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "Ok",
                               style: .default) { (action: UIAlertAction!) -> Void in
                                self.uploadResume()
                                
        }
        let cancel = UIAlertAction(title: "Cancel",
                               style: .default) { (action: UIAlertAction!) -> Void in
                                
                                
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated:true, completion:nil)
    }
    
    
    
    
    // getResumeList server call method
    func getResumeList()
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            
            ServerService.showActivityIndicatory(uiView:self.view)
            let params = ["Cand_id":UserDefaults.standard.object(forKey:"cID") as! String,"ResumeId":""] as [String : Any]
            ServerService.resumeList(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.getResumeList(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            
        }
    }
    
    // response from the server
    func getResumeList(response:AnyObject)->()
    {
        resumes.removeAll()
        ServerService.hideProgressView()
        resumeObject = response as! JSON
        print("****** resumes data is ************\n",resumeObject)
        noRecordsLbl.text = resumeObject["Message"].stringValue
        
        noteLabel.attributedText = resumeObject["HeaderMessage"].stringValue.htmlToAttributedString
        noteLabel.textColor = UIColor(hexString:"3A87AD")
        
        if resumeObject["MessageStatus"].intValue == 1
        {
            if resumeObject["UploadResumeList"].arrayValue.count>0
            {
                for r in 0..<resumeObject["UploadResumeList"].arrayValue.count
                {
                    let resume_obj = Resume.init(resumeId:resumeObject["UploadResumeList"][r]["Id"].stringValue,resumeName:resumeObject["UploadResumeList"][r]["Res_Desc"].stringValue, resumeExtension:resumeObject["UploadResumeList"][r]["Res_Extn"].stringValue, resumeUpdateddate:resumeObject["UploadResumeList"][r]["Time_Stamp"].stringValue)
                    resumes.append(resume_obj)
                }
            }
            resumeTableView.backgroundColor = .groupTableViewBackground
            
            if resumes.count>0
            {
                noRecordsLbl.text = ""
            }
            else
            {
                noRecordsLbl.text = "No records to display"
            }
        }
        else
        {
            resumeTableView.backgroundColor = .clear
        }
        resumeTableView.reloadData() // reloading the tableview
    }
    
    
    //api for upload resume
    func uploadResume()  {
        if ConnectionCheck.isConnectedToNetwork()
        {
            
            ServerService.showActivityIndicatory(uiView:self.view)
            let params = ["Cand_id":UserDefaults.standard.object(forKey:"cID") as! String,"filename":fileName,"Res_Extn":fileExt,"Resume_img":"\(fileBytes)"] as [String : Any]
            ServerService.uploadResume(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.getUploadResume(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            
        }

    }
    // response from the server
    func getUploadResume(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        uploadResumeObject = response as! JSON
        print("****** uploadResumeObject data is ************\n",uploadResumeObject)
        if uploadResumeObject["MessageStatus"].intValue == 1
        {
            //after success updating the list
            getResumeList()
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage:uploadResumeObject["Message"].stringValue, title:"", view:self)
            
        }
        
    }
    
    
    //catching the device orentation
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            uploadButton.frame = CGRect(x: self.view.bounds.size.width-70, y: self.view.bounds.size.height-70, width: 50, height: 50)
        case .landscapeLeft:
            text="LandscapeLeft"
            uploadButton.frame = CGRect(x: self.view.bounds.size.width-70, y: self.view.bounds.size.height-70, width: 50, height: 50)
        case .landscapeRight:
            text="LandscapeRight"
            uploadButton.frame = CGRect(x: self.view.bounds.size.width-70, y: self.view.bounds.size.height-70, width: 50, height: 50)
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
    }
    
    
    
}

//END OF CLASS




extension UploadResumeViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resumes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"uCell") as! UploadResumeTableViewCell
        cell.extensionLabel.text = resumes[indexPath.row].resumeExtension
        cell.resumeLabel.text = resumes[indexPath.row].resumeName
        cell.dateTimeLabel.text =  Constants.convertDate(string:resumes[indexPath.row].resumeUpdateddate)
        cell.selectionStyle = .none
        return cell
        
    }
    
    
    //tableView delegate methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
}
