//
//  ETimeClockMainViewController.swift
//  EWA
//
//  Created by NFC India on 26/12/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit


class ETimeClockMainViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = (UserDefaults.standard.object(forKey:"CandName") as! String)
        EMALocationManager.shared.requestLocationAtOnce()
    }
    
    //MARK:- Activity Indicator Methods for sub classes
     func showLoader(){
        ServerService.showActivityIndicatory(uiView:self.view)
    }
     func hideLoader(){
         ServerService.hideProgressView()
    }
    
   
    //MARK:- ViewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.title = ""
    }
    
}
