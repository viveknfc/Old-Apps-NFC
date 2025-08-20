//
//  AlertWithOkViewController.swift
//  EWA
//
//  Created by NFC User on 22/05/24.
//  Copyright © 2024 NFC. All rights reserved.
//

import UIKit

class AlertWithOkViewController: UIViewController {
    
    @IBOutlet weak var alertTitleBg: UIView!
    @IBOutlet weak var alertOk: UIButton!
    @IBOutlet weak var alertTitle: UITextView!
    @IBOutlet weak var alertOkBgView: UIView!
    
    var alertMessage: String?
    var alertMessageColor: UIColor?
    var alertMessageBackgroundColor: UIColor?
    var alertActionTitle: String?
    var alertButtonBackgroundColor: UIColor?
    var alertButtonTitleColor: UIColor?
    var actionHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the properties
        alertTitle.text = alertMessage
           if let messageColor = alertMessageColor {
               alertTitle.textColor = messageColor
           }
           if let messageBackgroundColor = alertMessageBackgroundColor {
               alertTitleBg.backgroundColor = messageBackgroundColor
               alertTitle.backgroundColor = messageBackgroundColor
           }
        alertOk.setTitle(alertActionTitle, for: .normal)
           if let buttonBackgroundColor = alertButtonBackgroundColor {
               alertOk.backgroundColor = buttonBackgroundColor
               alertOk.tintColor = buttonBackgroundColor
           }
           if let buttonTitleColor = alertButtonTitleColor {
               alertOk.setTitleColor(buttonTitleColor, for: .normal)
           }
        
        alertTitleBg.layer.cornerRadius = 5
        alertTitleBg.layer.masksToBounds = true
        
        alertOk.layer.cornerRadius = 5
        alertOk.clipsToBounds = true
        
        alertOkBgView.layer.cornerRadius = 5
        alertOkBgView.layer.masksToBounds = true
        
        alertTitle.isEditable = false
        
    }
    
    
    @IBAction func alertOkButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: actionHandler)
    }
    

}
