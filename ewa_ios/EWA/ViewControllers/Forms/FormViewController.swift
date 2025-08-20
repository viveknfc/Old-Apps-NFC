//
//  FormViewController.swift
//  EWA
//
//  Created by NFC India on 20/12/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import WebKit

class FormViewController: BaseViewController,WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    var formData:JSON = JSON.null
    var push = PushNotification.init(pushId:"", candidateId:"", subject:"", messageBody:"", messageType:0, dateTime:"",actionType:"")
    var fromUploadCred = Bool()
    var pdfurlstring = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        if fromUploadCred == true {
            self.navigationItem.rightBarButtonItems = nil
            self.title = "Upload Credintials"
            webView.uiDelegate = self
            webView.navigationDelegate = self
            loadPDF()
        }
        else {
            //if coming from notification showing the link url
            if push.messageBody.count>0
            {
                if push.actionType == "MSG"
                {
                    self.title = "Message"
                }
                else
                {
                    self.title = push.actionType
                }
                let urlString = push.messageBody.replace(target:"\\", withString:"")
                let url = URL(string:urlString.replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
                let request = URLRequest(url: url!)
                webView.uiDelegate = self
                webView.navigationDelegate = self
                webView.load(request)
            }
            else //loading the check
            {
                self.title = "Transit Check"
                webView.uiDelegate = self
                webView.navigationDelegate = self
                // getting the forms by calling the api
                getForm()
            }
        }
        
        
    }
    
    //MARK:- Loading PDF
    func loadPDF() {
        // let url = URL(string:formData["File"].stringValue.replace(target:"\\", withString:""))
         ServerService.showActivityIndicatory(uiView:self.view)
        let url = URL(string:pdfurlstring)
       
       //  let url = URL(string:pdfurlstring.replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
        let request = URLRequest(url: url!)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.load(request)
    }
    
    // getForm server call method
    func getForm()
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            
            ServerService.showActivityIndicatory(uiView:self.view)
            let params = ["Type":"5"] as [String : Any]
            ServerService.getDisplayFromsAndDocuments(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.getProfileData(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            
        }
    }
    
    // response from the server for getForm()
    func getProfileData(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        formData = response as! JSON
        print("****** formData data is ************\n",formData)
        
        if formData["MessageStatus"].intValue == 1
        {
            let url = URL(string:formData["File"].stringValue.replace(target:"\\", withString:""))
            let request = URLRequest(url: url!)
            webView.uiDelegate = self
            webView.navigationDelegate = self
            webView.load(request)
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:formData["Message"].stringValue, title:"", view:self)
        }
        
    }
    
    //webView Delgate Methods
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("************statred***********")
        //ServerService.showActivityIndicatory(uiView:self.view)
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
        ServerService.hideProgressView()
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ServerService.hideProgressView()
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ServerService.hideProgressView()
        print("finish")
    }
    
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        }
    }
    
    
    
    // clearing the catche
    override func viewWillDisappear(_ animated: Bool) {
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        
    }
    
    
    
}
extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}

//END OF CLASS
