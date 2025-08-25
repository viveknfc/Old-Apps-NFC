//
//  WebViewController.swift
//  CWA
//
//  Created by NFC User on 3/19/20.
//  Copyright © 2020 NFC Solutionsusa. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: BaseViewController,WKNavigationDelegate {
    
    var link = String()
    @IBOutlet weak var webViewpage: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
       // self.titlelbl.text = "Candidate Location Details"
        webViewpage.uiDelegate = self
        webViewpage.navigationDelegate = self
        let isInternetAvailable = self.isInternetAvailable()
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            let url = URL (string:link.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!)
            let requestObj = URLRequest(url: url!)
            webViewpage.load(requestObj)
            
        }
        else
        {
            JustHUD.shared.hide()
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
        if #available(iOS 11.0, *) {
            webViewpage.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           
           self.titlelbl.text = "Candidate Location Details"
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
        JustHUD.shared.hide()
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        JustHUD.shared.hide()
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        JustHUD.shared.hide()
        print("finish")
    }
    
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        }
    }
    
}
