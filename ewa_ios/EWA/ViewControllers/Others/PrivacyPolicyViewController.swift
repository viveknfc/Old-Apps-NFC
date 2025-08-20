//
//  PrivacyPolicyViewController.swift
//  EWA
//
//  Created by NFC India on 15/06/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import WebKit
import CropViewController
import SwiftyJSON

class PrivacyPolicyViewController: UIViewController,WKUIDelegate, WKNavigationDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, CropViewControllerDelegate{
    @IBOutlet weak var webViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var okView: UIView!
    
    @IBOutlet weak var formView: WKWebView!
    var link = String()
    var headerText = String()
    var isPush = Bool()
    var isPreviouslyLoaded = Bool()
    var imagePickerController = UIImagePickerController()
    var previousIPDelegate: UIImagePickerControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //  PrivacyPolicyViewController.doOnce
        self.isPreviouslyLoaded = false
        let url = URL(string:link)
        let request = URLRequest(url: url!)
        formView.uiDelegate = self
        formView.navigationDelegate = self
        formView.load(request)
        
        if Constants.iSFormOkRequired {
            webViewBottom.constant = 42
            okView.isHidden = false
        }
        else {
            webViewBottom.constant = 0
            okView.isHidden = true
        }
        self.title = headerText
        if UserDefaults.standard.object(forKey:"color") != nil
        {
            self.updateNavigationBarColor()
        }
        else
        {
            
        }
        
        
        let titleDict: NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedString.Key : Any]
        if !isPush {
            
            let newbackButton = UIBarButtonItem.init(customView: self.baackButton())
            self.navigationItem.leftBarButtonItems = [newbackButton]
            
        }
    }
    
    func baackButton() -> UIButton {
        let bBtn = UIButton()
        bBtn.frame = CGRect(x:0,y:0,width: 25,height:25)
        bBtn.setImage(UIImage.init(named: "backwhite.png"),for:.normal)
        bBtn.addTarget(self, action:#selector(self.baackClick), for: .touchUpInside)
        return bBtn
    }
    @objc func baackClick()
    {
        
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    func photoFromLibrary() {
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        formView?.evaluateJavaScript("window.settings.setImageBase64FromiOS()") { (result, error) in
            if error != nil {
                print("failure")
            } else {
                self.photoFromLibrary()
            }
        }
    }
    private func imagePickerController(_ picker: UIImagePickerController,
                                       didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let thumb = chosenImage//.resized(toWidth: 72.0)
        let imageData:NSData = UIImagePNGRepresentation(thumb)! as NSData
        let dataImage = imageData.base64EncodedString(options: .lineLength64Characters)
        print(dataImage)
        dismiss(animated:true, completion: nil) //5
        
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("************statred***********")
        //ServerService.showActivityIndicatory(uiView:self.view)
        ServerService.showActivityIndicatory(uiView:self.view)
        print(String(describing: webView.url))
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if (navigationAction.navigationType == .linkActivated){
            decisionHandler(.allow)
        } else {
            decisionHandler(.allow)
        }
    }
    
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ServerService.hideProgressView()
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ServerService.hideProgressView()
        print("finish")
        /*
         webView.evaluateJavaScript("document.body.innerText") { result, error in
         if let resultString = result as? String,
         resultString.contains("login") || resultString.contains("Login") {
         //site contains the text "Age"
         
         let alert = UIAlertController(title:"", message: "You have reached end please click ok to continue to app", preferredStyle: UIAlertControllerStyle.alert)
         let ok = UIAlertAction(title: "Ok",
         style: .default) { (action: UIAlertAction!) -> Void in
         if self.isPush {
         self.navigationController?.popViewController(animated: true)
         }
         else {
         self.dismiss(animated: true, completion: nil)
         }
         }
         alert.addAction(ok)
         (UIApplication.getTopMostViewController())!.present(alert, animated:true, completion:nil)
         }
         }
         */
    }
    
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        Constants.ShowStandAlone = true
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        
    }
    
    @IBAction func okClicked(_ sender: UIButton) {
        
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView: self.view)
            let paramsMenu:[String:Any] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,
                                           "PopupKey": Constants.globalPopupKey]
            print(paramsMenu)
            ServerService.submitglobalForm(self, params: paramsMenu, method:"POST", accessToken:Constants.Token, acces:true, callBack: getFormOkResponse(response:))
            
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
    }
    
    //MARK:- OkCLickResponse
    func getFormOkResponse(response:AnyObject)->()
    {
        
        var formRespObject: JSON = JSON.null
        formRespObject = response as! JSON
        print(formRespObject)
        
        if formRespObject["MessageStatus"].intValue == 1 {
            self.getMenuLinks()
            delayWithSeconds(3.2) {
                ServerService.hideProgressView()
                if self.isPush {
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        else {
            ServerService.hideProgressView()
            var messagee = String()
            if formRespObject["Message"].stringValue.count > 0 {
                messagee = formRespObject["Message"].stringValue
            }
            else {
                messagee = "Something is not right here try again later"
            }
            ServerService.ShowAlertMessage(ErrorMessage:"", title: messagee, view:self)
        }
    }
}
