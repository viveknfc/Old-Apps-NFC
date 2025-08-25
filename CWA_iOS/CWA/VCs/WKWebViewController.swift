//
//  WKWebViewController.swift
//  CWA
//
//  Created by NFC User on 20/07/23.
//  Copyright © 2023 NFC Solutionsusa. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: BaseViewController {
    
    @IBOutlet weak var webViewForm: WKWebView!
    var URLstring = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viv entered wkwebview controller")
        self.changeNavigationTitle("Enter a New Job")
        let url = URL(string: URLstring)
        
        print("the updated url is",url as Any)
        let request = URLRequest(url: url!)
        webViewForm.load(request)

    }
    
    func changeNavigationTitle(_ titleStr: String) {
        let tlabel = UILabel()
        tlabel.text = titleStr
        tlabel.textColor = UIColor.white
        tlabel.font = UIFont.systemFont(ofSize:17)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.textAlignment = .left
        tlabel.numberOfLines = 0
        tlabel.minimumScaleFactor = 0.5
        self.navigationItem.titleView = tlabel
    }
    


}

