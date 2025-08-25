//
//  CustomAlertWithOkButtonViewController.swift
//  CWA
//
//  Created by NFC User on 22/05/24.
//  Copyright © 2024 NFC Solutionsusa. All rights reserved.
//

import UIKit

class CustomAlertWithOkButtonViewController: UIViewController {
    
    @IBOutlet weak var alertTitleBg: UIView!
    @IBOutlet weak var alertTitle: UITextView!
    @IBOutlet weak var alertOk: UIButton!
    @IBOutlet weak var alertOkBg: UIView!
    
    var alertMessage: String?
    var alertMessageColor: UIColor?
    var alertMessageBackgroundColor: UIColor?
    var alertActionTitle: String?
    var alertButtonBackgroundColor: UIColor?
    var alertButtonTitleColor: UIColor?
    var actionHandler: (() -> Void)?
    
    var secondaryActionTitle: String?
    var secondaryButtonBackgroundColor: UIColor?
    var secondaryButtonTitleColor: UIColor?
    var secondaryActionHandler: (() -> Void)?
    
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
        
        alertOkBg.layer.cornerRadius = 5
        alertOkBg.layer.masksToBounds = true
        
        alertTitle.isEditable = false
    }
    
    @IBAction func alertOkButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: actionHandler)
    }

}
