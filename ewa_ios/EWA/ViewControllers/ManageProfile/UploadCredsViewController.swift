//
//  UploadCredsViewController.swift
//  EWA
//
//  Created by NFC India on 14/12/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON

class UploadCredsViewController: BaseViewController {
    
    
    // object reference's from SB
    @IBOutlet weak var uploadCredTablevIew: UITableView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var noRecordsLabel: UILabel!
    @IBOutlet var infoView: UIView!
    
    var uploadCredsData:JSON = JSON.null
    var deleteObject:JSON = JSON.null
    var credsList = [UploadCredList]()
    var formList = [UploadCredList]()
    var selecteCred = UploadCredList.init(credId:"", credName:"", credDesc:"",credDeleteBtn: 0, credPdfLink: "")
    var blurEffect = UIBlurEffect()
    var blurEffectView = UIVisualEffectView()
    var uploadButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectIndex(_:)), name: Notification.Name(rawValue: "uploadCredIndexChanged"), object: nil)
        
    }
    
    @objc func didSelectIndex(_ notification: Notification) {
        if ((notification.object) != nil){
            print("Selected Index : \(notification.object as! Int)")
            let indd = notification.object as! Int
            if indd == 1 {
                
            }
            self.formList = Constants.formList
            self.uploadCredsData = Constants.uploadCredsData
            self.credsList = Constants.credsList
            if uploadCredsData["listfileCredentials"].count==0
            {
                noRecordsLabel.isHidden = false
                uploadCredTablevIew.backgroundColor = .clear
            }
            else {
                
                headerLabel.text = uploadCredsData["DisplayText"].stringValue.replace(target:"computer", withString:"device")
                headerLabel.textColor = UIColor(hexString:"3A87AD")
                
            }
            uploadCredTablevIew.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Credentials"
        
        noRecordsLabel.isHidden = true
        self.navigationItem.rightBarButtonItems = nil
        
        
        
        
    }
    @objc func reloadTheList(notification: Notification) {
        //getCredList()
    }
    
    
    /*
     //floating button action
     @objc func uploadClicked() {
     // Changed from *uploadCred* to *Upload Credentials*
     let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"Upload Credentials") as? UploadCredViewController
     vc?.formsList = formList
     vc?.uploadCredList = uploadCredsData
     self.navigationController?.pushViewController(vc!, animated: true)
     
     }
     
     
     
     // getCredList server call method
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
     
     ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
     
     }
     }
     
     // response from the server for getgetCredListData()
     func getCredListData(response:AnyObject)->()
     {
     credsList.removeAll()
     ServerService.hideProgressView()
     uploadCredsData = response as! JSON
     print("****** uploadCredsData data is ************\n",uploadCredsData)
     headerLabel.text = uploadCredsData["DisplayText"].stringValue.replace(target:"computer", withString:"device")
     headerLabel.textColor = UIColor(hexString:"3A87AD")
     //noRecordsLabel.text = uploadCredsData["Message"].stringValue
     if uploadCredsData["MessageStatus"].intValue == 1
     {
     
     for c in 0..<uploadCredsData["listfileCredentials"].count
     {
     
     let cred = UploadCredList.init(credId:uploadCredsData["listfileCredentials"][c]["id"].stringValue, credName:uploadCredsData["listfileCredentials"][c]["FileName"].stringValue, credDesc:uploadCredsData["listfileCredentials"][c]["ConcatenatedCredentialNames"].stringValue,credDeleteBtn: uploadCredList["listfileCredentials"][c]["showDelete"].intValue,
     credPdfLink:uploadCredList["listfileCredentials"][c]["PdfPath"].stringValue)
     credsList.append(cred)
     }
     
     }
     else
     {
     ServerService.hideProgressView()
     if  uploadCredsData["Message"].stringValue.count>0
     {
     ServerService.ShowAlertMessage(ErrorMessage:uploadCredsData["Message"].stringValue, title:"", view:self)
     }
     }
     
     if uploadCredsData["listfileCredentials"].count==0
     {
     noRecordsLabel.isHidden = false
     uploadCredTablevIew.backgroundColor = .clear
     }
     
     uploadCredTablevIew.reloadData()
     
     // storing form data will carried to next screen
     for c in 0..<uploadCredsData["listUploadCredentials"].count
     {
     for f in 0..<3
     {
     if uploadCredsData["listUploadCredentials"][c]["Description\(f+1)"].stringValue.count>0 // adding only names with text
     {
     let cred = UploadCredList.init(credId:uploadCredsData["listUploadCredentials"][c]["Id\(f+1)"].stringValue, credName:uploadCredsData["listUploadCredentials"][c]["Description\(f+1)"].stringValue, credDesc:"",credDeleteBtn: uploadCredList["listfileCredentials"][c]["showDelete"].intValue,
     credPdfLink:uploadCredList["listfileCredentials"][c]["PdfPath"].stringValue)
     formList.append(cred)
     }
     }
     
     
     }
     
     }
     */
    
    //MARK:- Delete Button Action
    @IBAction func deleteFormAction(_ sender: Any) {
        let buttonPosition:CGPoint = (sender as AnyObject).convert(CGPoint.zero, to:self.uploadCredTablevIew)
        let indexPath = self.uploadCredTablevIew.indexPathForRow(at: buttonPosition)
        print(indexPath!.row)
        selecteCred = credsList[(indexPath?.row)!]
        deleteTheCred(credId:selecteCred.credId)
        
    }
    
    // delete Cred api
    func deleteTheCred(credId:String)
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            
            ServerService.showActivityIndicatory(uiView:self.view)
            let params = ["CandidateId":UserDefaults.standard.object(forKey:"cID") as! String,"DivisionId":UserDefaults.standard.object(forKey:"dID") as! String,"AppId":uploadCredsData["AppId"].stringValue,"Id":credId] as [String : Any]
            ServerService.deleteCred(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.getDeleteCred(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            
        }
    }
    
    // response from the server for getDeleteCred()
    func getDeleteCred(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        deleteObject = response as! JSON
        print("****** DeleteCred data is ************\n",deleteObject)
        if deleteObject["MessageStatus"].intValue == 1
        {
            credsList.remove(object:selecteCred)
            uploadCredTablevIew.reloadData()
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:deleteObject["Message"].stringValue, title:"", view:self)
        }
    }
    
    
    //MARK:- this the action for info button
    @IBAction func infoButtonClicked(_ sender: Any) {
        
        infoView.frame = CGRect(x:10, y:self.view.bounds.height/2-125, width: self.view.bounds.width-20, height:230)
        blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.contentView.addSubview(infoView)
        view.addSubview(blurEffectView)
        
    }
    
    //MARK:- catching the device orentation
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            infoView.frame = CGRect(x:10, y:self.view.bounds.height/2-125, width: self.view.bounds.width-20, height:230)
            uploadButton.frame = CGRect(x: self.view.bounds.size.width-70, y: self.view.bounds.size.height-70, width: 50, height: 50)
        case .landscapeLeft:
            text="LandscapeLeft"
            infoView.frame = CGRect(x:10, y:self.view.bounds.height/2-125, width: self.view.bounds.width-20, height:230)
            uploadButton.frame = CGRect(x: self.view.bounds.size.width-70, y: self.view.bounds.size.height-70, width: 50, height: 50)
        case .landscapeRight:
            text="LandscapeRight"
            infoView.frame = CGRect(x:10, y:self.view.bounds.height/2-125, width: self.view.bounds.width-20, height:230)
            uploadButton.frame = CGRect(x: self.view.bounds.size.width-70, y: self.view.bounds.size.height-70, width: 50, height: 50)
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
    }
    
    //MARK:- DismissPopView
    @IBAction func dismissAction(_ sender: Any) {
        //closing the popup
        blurEffectView.removeFromSuperview()
    }
    
}

//END OF CLASS




//EXTENSIONS
extension UploadCredsViewController:UITableViewDelegate,UITableViewDataSource
{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return credsList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"ucCell") as! UploadCredListTableViewCell
        cell.fileName.text = credsList[indexPath.row].credName
        cell.fileCreds.text = credsList[indexPath.row].credDesc
        let height = Constants.calculateHeightWithFont(inString:credsList[indexPath.row].credDesc, width:self.view.bounds.size.width-100, font: UIFont.systemFont(ofSize:15))
        print(height)
        let fileNmehht = Constants.calculateHeightWithFont(inString:credsList[indexPath.row].credName, width:self.view.bounds.size.width-100, font: UIFont.systemFont(ofSize:15))
        cell.fileNameHeight.constant = fileNmehht
        cell.discText.constant = height
        cell.selectionStyle = .none
        if credsList[indexPath.row].credDeleteBtn == 0 {
            cell.deleteButton.isHidden = true
        }
        else {
            cell.deleteButton.isHidden = false
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = Constants.calculateHeightWithFont(inString:credsList[indexPath.row].credDesc, width:self.view.bounds.size.width-100, font: UIFont.systemFont(ofSize:15))
        print(height)
        let fileNmehht = Constants.calculateHeightWithFont(inString:credsList[indexPath.row].credName, width:self.view.bounds.size.width-100, font: UIFont.systemFont(ofSize:15))
        return height+70+fileNmehht
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let path = credsList[indexPath.row].credPdfLink
        print(credsList[indexPath.row].credPdfLink)
        var vvalid = Bool()
        //let url = URL(string: path.replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))!
        if let url = URL(string: path.replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:"")) {
            print(url)
            vvalid = true
            
        }
        else {
            vvalid = false
        }
        if path != nil && path.count > 0 && path.replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:"").isValidURL && vvalid == true {
            let screen = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"Transit Check") as! FormViewController
            screen.fromUploadCred = true
            screen.pdfurlstring = credsList[indexPath.row].credPdfLink
            self.navigationController?.pushViewController(screen, animated: false)
        }
    }
}
