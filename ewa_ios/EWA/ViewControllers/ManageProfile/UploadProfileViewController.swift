//
//  UploadProfileViewController.swift
//  EWA
//
//  Created by NFC India on 13/12/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON

class UploadProfileViewController: BaseViewController,WKUIDelegate, WKNavigationDelegate {
    
    
    @IBOutlet weak var webView: WKWebView!
    var profileLinkData:JSON = JSON.null
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Update Employee Profile"
        
        
      //calling the api to get the data
        getProfile()
        
    }
    
    // getProfile server call method
    func getProfile()
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            
            ServerService.showActivityIndicatory(uiView:self.view)
            let params = ["cand_id":UserDefaults.standard.object(forKey:"cID") as! String] as [String : Any]
            ServerService.getUploadProfile(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.getProfileData(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            
        }
    }
    
    // response from the server for getPhotoList()
    func getProfileData(response:AnyObject)->()
    {
        //ServerService.hideProgressView()
        profileLinkData = response as! JSON
        print("****** profileLinkData data is ************\n",profileLinkData)
        
        if profileLinkData["MessageStatus"].intValue == 1
        {
            let url = URL(string:profileLinkData["UpdateEmployeeProfileUrl"].stringValue.replace(target:"\\", withString:""))
            let request = URLRequest(url: url!)
            webView.uiDelegate = self
            webView.navigationDelegate = self
            webView.load(request)
        }
        else
        {
            ServerService.hideProgressView()
        ServerService.ShowAlertMessage(ErrorMessage:profileLinkData["Message"].stringValue, title:"", view:self)
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
//END OF CLASS
