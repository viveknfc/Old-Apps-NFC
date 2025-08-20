//
//  CustomSideMenuController.swift
//  Example
//
//  Created by Teodor Patras on 16/06/16.
//  Copyright © 2016 teodorpatras. All rights reserved.
//

import Foundation
import SideMenuController

class CustomSideMenuController: SideMenuController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //if user is naviagted from the push notifications then landing the user onto the respective screen
        if UserDefaults.standard.object(forKey: "token") != nil
        {
            self.updateNavigationBarColor()
        }
        
        if Constants.naviLiteral.count>0
        {
            //eTimeClock
            print("NnaviLiteral is \(Constants.naviLiteral)")
            if Constants.naviLiteral == "eTIMECLOCK"{
                UserDefaults.standard.set("1", forKey: "eTimeClock")
            }
            let vc:UIViewController = (self.storyboard?.instantiateViewController(withIdentifier:Constants.naviLiteral))!
            let navi = BaseNaviViewController(rootViewController:vc)
            navi.navigationBar.tintColor = .white
            navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            print("viv loading side menu from here 41")
            performSegue(withIdentifier:"containSideMenu", sender: nil) //loading the sidemenu
            embed(centerViewController:navi, cacheIdentifier:Constants.naviLiteral) // embeding the center controller
            if Constants.naviLiteral == "eTIMECLOCK" {
                
            }
            else {
                Constants.naviLiteral = "" // clearing the constant which is the storyboardID
            }
        }
        else
        {
            print("viv loading side menu from here 53")
            //loading the side menu and centermenu which is dashboard in general case
            performSegue(withIdentifier: "dashBoard", sender: nil)
            performSegue(withIdentifier: "containSideMenu", sender: nil)
        }
    }
    
}

extension UIViewController {
    func tempAlertWithText(textt: String) {
        // the alert view
        let alert = UIAlertController(title: "", message: textt, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
        }
    }
}
