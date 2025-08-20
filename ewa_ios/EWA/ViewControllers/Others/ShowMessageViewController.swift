//
//  ShowMessageViewController.swift
//  EWA
//
//  Created by NFCIndia on 09/10/19.
//  Copyright © 2019 NFC. All rights reserved.
//

import UIKit
import WebKit


class ShowMessageViewController: UIViewController,WKUIDelegate, WKNavigationDelegate  {
    
    
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var wkwebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  if Constants.globalMessgae.count > 0 {
            messageTextView.text = Constants.globalMessgae
            messageTextView.isHidden = false
            wkwebView.isHidden = true
//        }
//        else {
//            messageTextView.isHidden = true
//            wkwebView.isHidden = false
//            wkwebView.uiDelegate = self
//            wkwebView.navigationDelegate = self
//            loadPDF()
//        }
        
        
    }
    
    //MARK:- Loading PDF
    func loadPDF() {
        // let url = URL(string:formData["File"].stringValue.replace(target:"\\", withString:""))
        ServerService.showActivityIndicatory(uiView:self.view)
        let url = URL(string:"https://www.google.co.in")
        
        //  let url = URL(string:pdfurlstring.replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
        let request = URLRequest(url: url!)
        wkwebView.uiDelegate = self
        wkwebView.navigationDelegate = self
        wkwebView.load(request)
    }
    
    //MARK:- webView Delgate Methods
    
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
    
    
    //MARK:-  clearing the catche
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
