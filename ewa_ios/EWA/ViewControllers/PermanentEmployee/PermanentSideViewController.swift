//
//  PermanentSideViewController.swift
//  EWA
//
//  Created by NFC India on 04/10/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import SideMenuController

class PermanentSideViewController: SideMenuController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if UserDefaults.standard.object(forKey: "token") != nil
        {
            self.updateNavigationBarColor()
        }
        performSegue(withIdentifier: "center", sender: nil)
        performSegue(withIdentifier: "containSideMenu", sender: nil)
    }

}
