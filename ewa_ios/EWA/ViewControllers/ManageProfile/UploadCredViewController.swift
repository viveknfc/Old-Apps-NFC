//
//  UploadCredViewController.swift
//  EWA
//
//  Created by NFC India on 18/12/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import MobileCoreServices



class UploadCredViewController: BaseViewController,UIDocumentPickerDelegate {
    
    @IBOutlet weak var formListTableView: UITableView!
    @IBOutlet weak var selectFileNameLabel: UILabel!
    
    @IBOutlet weak var noRecordsLabel: UILabel!
    var formsList = [UploadCredList]()
    var selectedINDEX = [Int]()
    
    var uploadCredList:JSON = JSON.null
    var uploadCredObject:JSON = JSON.null
    var deleteObject:JSON = JSON.null
    var credsList = [UploadCredList]()
    
    // picked file data
    var fileData = Data()
    var fileBytes = String()
    var fileName = String()
    var fileExt = String()
    var fileSize = Double()
    var uploadButton = UIButton()
    
    
    @IBOutlet var infoView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    
    var blurEffect = UIBlurEffect()
    var blurEffectView = UIVisualEffectView()
    //MARK:- View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Credentials"
        //self.navigationItem.rightBarButtonItems = nil
        noRecordsLabel.isHidden = true
        getCredList()
    }
    
    func addListButton(){
        uploadButton = UIButton(frame:CGRect(x: self.view.bounds.size.width-65, y: self.view.bounds.size.height-110, width: 50, height: 50))
        uploadButton.backgroundColor = UIColor.init(red: 68/255.0, green: 157/255.0, blue: 67/255.0, alpha: 1.0) //UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        uploadButton.setImage(UIImage(named:"listimage"), for:.normal) // ic_upload.png
        uploadButton.imageView?.contentMode = .scaleAspectFit
        uploadButton.addTarget(self, action:#selector(self.listClicked), for: .touchUpInside)
        uploadButton.titleLabel?.textColor = .white
        uploadButton.titleLabel?.font = UIFont.boldSystemFont(ofSize:25)
        uploadButton.layer.cornerRadius = 25
        uploadButton.layer.masksToBounds = true
        self.view.addSubview(uploadButton)
        self.view.bringSubview(toFront:uploadButton)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    //MARK:- Floating-Button Action
    @objc func listClicked() {
        // Changed from *uploadCred* to *Upload Credentials*
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"uploadCred") as? UploadCredsViewController
        vc?.formList = formsList
        vc?.uploadCredsData = uploadCredList
        vc?.credsList = credsList
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    //MARK:- getCredList server call method
    func getCredList()
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            
            ServerService.showActivityIndicatory(uiView:self.view)
            let params = ["CandidateId":UserDefaults.standard.object(forKey:"cID") as! String,"DivisionId":UserDefaults.standard.object(forKey:"dID") as! String] as [String : Any]
            print(params)
            ServerService.getUploadCreds(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.getCredListData(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            
        }
    }
    // response from the server for getgetCredListData()
    func getCredListData(response:AnyObject)->()
    {
        credsList.removeAll()
        formsList.removeAll()
        ServerService.hideProgressView()
        uploadCredList = response as! JSON
        print("****** uploadCredsData data is ************\n",uploadCredList)
        
        
        if uploadCredList["MessageStatus"].intValue == 1
        {
            
            for c in 0..<uploadCredList["listfileCredentials"].count
            {
                
                let cred = UploadCredList.init(credId:uploadCredList["listfileCredentials"][c]["id"].stringValue, credName:uploadCredList["listfileCredentials"][c]["FileName"].stringValue, credDesc:uploadCredList["listfileCredentials"][c]["ConcatenatedCredentialNames"].stringValue,
                                               credDeleteBtn: uploadCredList["listfileCredentials"][c]["showDelete"].intValue,
                                               credPdfLink:uploadCredList["listfileCredentials"][c]["PdfPath"].stringValue)
                credsList.append(cred)
            }
            
            
        }
        else
        {
            ServerService.hideProgressView()
            if  uploadCredList["Message"].stringValue.count>0
            {
                //ServerService.ShowAlertMessage(ErrorMessage:uploadCredList["Message"].stringValue, title:"", view:self)
            }
        }
        
        if uploadCredList["listUploadCredentials"].count > 0 {
             noRecordsLabel.isHidden = true
            // storing form data will carried to next screen
            for c in 0..<uploadCredList["listUploadCredentials"].count
            {
                for f in 0..<3
                {
                    if uploadCredList["listUploadCredentials"][c]["Description\(f+1)"].stringValue.count>0 // adding only names with text
                    {
                        let cred = UploadCredList.init(credId:uploadCredList["listUploadCredentials"][c]["Id\(f+1)"].stringValue, credName:uploadCredList["listUploadCredentials"][c]["Description\(f+1)"].stringValue, credDesc:"",credDeleteBtn: uploadCredList["listfileCredentials"][c]["showDelete"].intValue,
                                                       credPdfLink:uploadCredList["listfileCredentials"][c]["PdfPath"].stringValue)
                        formsList.append(cred)
                    }
                }
                
                
            }
        }
        else {
            noRecordsLabel.isHidden = false
            formListTableView.backgroundColor = .clear
        }
        
        Constants.credsList = credsList
        Constants.formList = formsList
        Constants.uploadCredsData = uploadCredList
        headerLabel.text = uploadCredList["DisplayText"].stringValue.replace(target:"computer", withString:"device")
        headerLabel.textColor = UIColor(hexString:"3A87AD")
        formListTableView.reloadData()
        
    }
    
    @IBAction func chooseFileAction(_ sender: UIButton) {
        
        // let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes:[String(kUTTypeContent)], in: UIDocumentPickerMode.import)
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes:["com.microsoft.word.doc","org.openxmlformats.wordprocessingml.document","public.png","public.jpg","public.jpeg","public.PNG", String(kUTTypePDF)], in: UIDocumentPickerMode.import)
        //"com.microsoft.word.doc","org.openxmlformats.wordprocessingml.document", kUTTypePDF
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
            // fileExt =   "."+url.lastPathComponent.components(separatedBy:".")[1]
            fileExt = "."+url.pathExtension
            print("fileExt: .\(url.pathExtension)")
            fileSize = self.sizePerMB(url:url)
            selectFileNameLabel.text = fileName
            //  print(fileBytes)
            
        }
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
    
    
    //MARK:- UploadFileAction
    @IBAction func uploadFileActon(_ sender: UIButton) {
        
        if selectedINDEX.count>0
        {
            if fileBytes.count>0
            {
                if ConnectionCheck.isConnectedToNetwork()
                {
                    var credentialType = [String]()
                    
                    for c in 0..<selectedINDEX.count
                    {
                        credentialType.append(formsList[selectedINDEX[c]].credId)
                    }
                    
                    ServerService.showActivityIndicatory(uiView:self.view)
                    let params = ["CandidateId":UserDefaults.standard.object(forKey:"cID") as! String,"DivisionId":UserDefaults.standard.object(forKey:"dID") as! String,"ContentLength":fileSize,
                                  "FileName":fileName,
                                  //  "Photo":fileBytes,
                        "AppId":uploadCredList["AppId"].stringValue,
                        "FileExtn":fileExt,
                        "UploadSource":"1",
                        "ContentType":fileExt,
                        "credentialType":credentialType
                        ,"CredentialFile":fileBytes] as [String : Any]
                     print(params)
                    
                    let printableParams = ["CandidateId":UserDefaults.standard.object(forKey:"cID") as! String,"DivisionId":UserDefaults.standard.object(forKey:"dID") as! String,"ContentLength":fileSize,
                                           "FileName":fileName,
                                           // "Photo":"jkjbjdshbfhjbsdhbfhbdh",
                        "AppId":uploadCredList["AppId"].stringValue,
                        "FileExtn":fileExt,
                        "UploadSource":"1",
                        "ContentType":fileExt,
                        "credentialType":credentialType
                        ,"CredentialFile":"hkgjsdvsufuvduovfuovsdfiydsgfoygisoady"] as [String : Any]
                    
                    print(printableParams)
                    ServerService.uploadCred(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.getuploadCred(response:))
                }
                else
                {
                    ServerService.hideProgressView()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                }
            }
            else
            {
                ServerService.ShowAlertMessage(ErrorMessage:"", title: "Please select the credential file", view:self)
                
            }
            
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage:"", title: "Please select the credential type ", view:self)
            
        }
    }
    
    // response from the server for getgetData()
    func getuploadCred(response:AnyObject)->()
    {
        //selectedINDEX.removeAll()
        ServerService.hideProgressView()
        uploadCredObject = response as! JSON
        print("****** uploadCredObject data is ************\n",uploadCredObject)
        if uploadCredObject["MessageStatus"].intValue == 1
        {
            self.navigationController?.view.makeToast(uploadCredObject["Message"].stringValue, duration: 3.0, position: .bottom, title: "", image: nil)
            selectFileNameLabel.text = ""
            selectedINDEX.removeAll()
            formListTableView.reloadData()
            self.getCredList()
            
            //            NotificationCenter.default.post(name: Notification.Name("reloadTheList"), object: nil)
            //            self.navigationController?.popViewController(animated:true)
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage:uploadCredObject["Message"].stringValue, title:"", view:self)
        }
        
    }
    
    
    //MARK:- MethodToCalculateTheFileSize
    func sizePerMB(url: URL?) -> Double {
        guard let filePath = url?.path else {
            return 0.0
        }
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: filePath)
            if let size = attribute[FileAttributeKey.size] as? NSNumber {
                return size.doubleValue / 1000000.0
            }
        } catch {
            print("Error: \(error)")
        }
        return 0.0
    }
    
    //MARK:- InfoButtonAction
    @IBAction func infoButtonClicked(_ sender: UIButton) {
        infoView.frame = CGRect(x:10, y:self.view.bounds.height/2-125, width: self.view.bounds.width-20, height:230)
        blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.contentView.addSubview(infoView)
        view.addSubview(blurEffectView)
    }
    
    @IBAction func dismissInfoPopView(_ sender: UIButton) {
        blurEffectView.removeFromSuperview()
    }
    
    
}

//END OF CLASS

extension UploadCredViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"uploadCred") as! UploadCredTableViewCell
        cell.formNameLabel.text = formsList[indexPath.row].credName
        if selectedINDEX.contains(indexPath.row)
        {
            cell.checkImage?.image = UIImage(named:"checked.png")
        }
        else
        {
            cell.checkImage?.image = UIImage(named:"uncheck.png")
        }
        
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedINDEX.contains(indexPath.row)
        {
            selectedINDEX.remove(object:indexPath.row)
        }
        else
        {
            selectedINDEX.append(indexPath.row)
        }
        formListTableView.reloadData()
    }
    
}
