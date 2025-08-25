//
//  E_RegisterTabVC.swift
//  CWA
//
//  Created by NFC User on 28/09/23.
//  Copyright © 2023 NFC Solutionsusa. All rights reserved.
//

import UIKit

class E_RegisterTabVC: UITabBarController {
   
    var selectedDivisionContactID = 0
    var selectedDivisionClientID = 0
    var isFromDivisionPage = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem.init(customView: self.backButton())
        self.navigationItem.leftBarButtonItem = backButton
        
        let rightButton = UIBarButtonItem.init(customView: self.rightBarButton())
        self.navigationItem.rightBarButtonItem = rightButton
        

    }
    
    //MARK: - Back Button
    
    func backButton() -> UIButton {
        let bBtn = UIButton()
        
        bBtn.frame = CGRect(x:0,y:0,width: 40,height:40)
        bBtn.setImage(UIImage.init(named: "Back.png"),for:.normal)
        
        bBtn.addTarget(self, action:#selector(self.goBack), for: .touchUpInside)
        
        return bBtn
        
    }
    
    @objc func goBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Right Bar Button
    
    func rightBarButton() -> UIButton {
        let bBtn = UIButton()
        
        bBtn.frame = CGRect(x:0,y:0,width: 40,height:40)
        bBtn.setImage(UIImage.init(named: "user_profile.png"),for:.normal)
        
        bBtn.addTarget(self, action:#selector(self.showOptionActionSheet), for: .touchUpInside)
        
        return bBtn
        
    }
    
    @objc func showOptionActionSheet(sender: UIButton){
        
        self.showActionSheet(senderBtn: sender)
    }
    
    func showActionSheet(senderBtn:UIButton) {
        
        let defaults = UserDefaults.standard
        let UserName = defaults.string(forKey: "CandName")
        
        var msg = ""
        if defaults.string(forKey: "DivisionName") == nil{
            
            msg = String(format:"%@",UserName!)
            
        }else{
            
            msg = String(format:"%@\n%@", UserName! ,defaults.string(forKey: "DivisionName")!)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            let alert = UIAlertController(title: msg, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            
            alert.addAction(UIAlertAction(title: "Change Password", style: UIAlertAction.Style.default, handler: {(alert) in
                self.PushToChangePassword()
            }))
            alert.addAction(UIAlertAction(title: "Logout", style: UIAlertAction.Style.default, handler: {(alert) in
                self.resetDefaults()
                self.navigationController?.popToRootViewController(animated: true)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {(alert) in
            }))
            
            //            alert.view.tintColor = UIColor.green
            
            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
            
            // 2. check the idiom
            switch (deviceIdiom) {
                
            case .pad:
                if let popoverController = alert.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = senderBtn.frame
                    popoverController.permittedArrowDirections = []
                    self.present(alert, animated: true, completion: nil)
                    
                }
                break
            case .phone:
                self.present(alert, animated: true, completion: nil)
                break
            case .tv:
                print("tvOS style UI")
            default:
                print("Unspecified UI idiom")
            }
            
            
        })
    }
    
//MARK: - Push to Change Password
    
    func PushToChangePassword(){
        
        
        //check if LaunchViewController is there on stack or not ,if present pop else push
        
        var isControllerExists = false
        
        var dashboardVC = UIViewController()
        
        if let viewControllers = self.navigationController?.viewControllers {
            
            for viewController in viewControllers {
                
                if viewController is ChangePasswordViewController {
                    print("Your controller exist")
                    dashboardVC = viewController
                    isControllerExists = true
                    break
                }
            }
            
        }
        
        if isControllerExists {
            
            self.navigationController?.popToViewController(dashboardVC, animated: true)
            
        }else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordSegue") as! ChangePasswordViewController
            nextViewController.isFromSigninPage = false
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
    }

//MARK: - Reset to Defaults
    
    func resetDefaults() {
        
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }
    
}

class DateManager {
    static let shared = DateManager()
    
    var selectedDate: Date?
}
