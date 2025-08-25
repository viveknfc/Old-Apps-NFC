//
//  LoadWebContentViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 28/12/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON

class LoadWebContentViewController: BaseViewController,WKNavigationDelegate {
    
    var TimeID = ""
    var fileName = ""
    var isForPrivacyPolicy = false
    var PageTitle  = ""
    
    @IBOutlet weak var webBGView: UIView!
    var isSuccessMessage = false
    
    var webView: WKWebView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isForPrivacyPolicy == true{
            self.titlelbl.text = "Privacy Policy"
        }else{
            self.titlelbl.text = PageTitle
            
        }
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
         webView = WKWebView()
        
        webView.frame = CGRect(x:0,y:0,width:webBGView.frame.size.width,height:webBGView.frame.size.height)
        
        webView.navigationDelegate = self
        
        webBGView.addSubview(webView)
        
        setupWKWebViewConstraints()
        if TimeID.count > 0{
            self.getApproveTSPDFData()
        }else if isForPrivacyPolicy == true{
            self.getPrivacyPolicy()
        }
        if fileName.count > 0 {
            self.loadWebContentView()
        }
    }
    
    func setupWKWebViewConstraints() {
        
        let paddingConstant:CGFloat = 5.0
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        webView.topAnchor.constraint(equalTo: webBGView.topAnchor, constant: paddingConstant).isActive = true
        webView.bottomAnchor.constraint(equalTo: webBGView.bottomAnchor, constant: -paddingConstant).isActive = true
        webView.leadingAnchor.constraint(equalTo: webBGView.leadingAnchor, constant: paddingConstant).isActive = true
        webView.trailingAnchor.constraint(equalTo: webBGView.trailingAnchor, constant: -paddingConstant).isActive = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( animated )
        
        //        self.loadWebContentView()
    }
    func loadWebContentView(){
        //        JustHUD.shared.showInView(view: (self.navigationController?.view)!)
        if fileName.count > 0   {
            
            let urlString:String = fileName
            
//            let url:URL = URL(string: urlString.replace(target: " ", withString: ""))!
            let url:URL = URL(string: urlString)!

            let urlRequest:URLRequest = URLRequest(url: url)
            JustHUD.shared.showInView(view: self.view )
            
            webView.load(urlRequest)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        print("didFinish")
        JustHUD.shared.hide()
        
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        JustHUD.shared.hide()
        
        print(error.localizedDescription)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func getApproveTSPDFData() {
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            
            //userid as String
            let params :[String:String] = ["TimeCardID":TimeID]
            print(params)
            RestAPI.viewApproveTSPDF(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
        }else{
            
            //            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
            isSuccessMessage = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message:
                InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
        
    }
    func getPrivacyPolicy() {
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            
            //userid as String
           let ContactId = UserDefaults.standard.object(forKey:"ContactId") as! String

            let params :[String:String] = ["ContactId":ContactId]
            print(params)
             RestAPI.getPrivacyPolicy(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))

            
            
            ///////////////////////
            
        }else{
            
            //            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
            isSuccessMessage = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message:
                InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
        
    }
    
    func getResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            //            self.ShowAlertMessage(message: response as! String, title: "")
            isSuccessMessage = false
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
                
                fileName = object["FileName"].stringValue
                if fileName.count == 0{
                    
                    //                     let alert = UIAlertController(title:"", message: object["Message"].stringValue, preferredStyle: UIAlertControllerStyle.alert)
                    //                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:  {(alert) in
                    //
                    //                        self.navigationController?.popViewController(animated: true)
                    //                    }))
                    //                    self.present(alert, animated: true, completion: nil)
                    
                    isSuccessMessage = true
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                    
                    
                }else{
                    
                    self.loadWebContentView()
                }
                
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                if message == "No Record Found"{
                    
                }else{
                   
                    isSuccessMessage = false
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                    
                    
                }
            }
        }
    }
    @IBAction override func okButtonTapped(_ sender: Any) {
        //    self.alertController.dismiss(animated: true, completion: nil)
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
        if isSuccessMessage == true{
            self.navigationController?.popViewController(animated: true)
        }
    }
}
