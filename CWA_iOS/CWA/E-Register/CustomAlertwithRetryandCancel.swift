//
//  CustomAlertwithRetryandCancel.swift
//  CWA
//
//  Created by NFC User on 18/11/24.
//  Copyright © 2024 NFC Solutionsusa. All rights reserved.
//

import Foundation
import UIKit

class CustomAlertwithRetryandCancel: UIViewController {
    
    @IBOutlet weak var alertTitleBgView: UIView!
    @IBOutlet weak var alertTitle: UITextView!
    @IBOutlet weak var alertActionBgView: UIView!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
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
               alertTitleBgView.backgroundColor = messageBackgroundColor
               alertTitle.backgroundColor = messageBackgroundColor
           }
        retryButton.setTitle(secondaryActionTitle, for: .normal)
        cancelButton.setTitle(alertActionTitle, for: .normal)
           if let primaryButtonBackgroundColor = alertButtonBackgroundColor {
               cancelButton.backgroundColor = primaryButtonBackgroundColor
               cancelButton.tintColor = primaryButtonBackgroundColor
           }
        if let secondaryButtonBackgroundColor = secondaryButtonBackgroundColor {
            retryButton.backgroundColor = secondaryButtonBackgroundColor
            retryButton.tintColor = secondaryButtonBackgroundColor
        }
           if let primaryButtonTitleColor = alertButtonTitleColor {
               cancelButton.setTitleColor(primaryButtonTitleColor, for: .normal)
           }
        if let secondaryButtonTitleColor = secondaryButtonTitleColor {
            retryButton.setTitleColor(secondaryButtonTitleColor, for: .normal)
        }
        
        alertTitleBgView.layer.cornerRadius = 5
        alertTitleBgView.layer.masksToBounds = true
        
        retryButton.layer.cornerRadius = 5
        retryButton.clipsToBounds = true
        
        cancelButton.layer.cornerRadius = 5
        cancelButton.clipsToBounds = true
        
        alertActionBgView.layer.cornerRadius = 5
        alertActionBgView.layer.masksToBounds = true
        
        alertTitle.isEditable = false
    }
    
    
    @IBAction func retryButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: secondaryActionHandler)
    }
    

    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: actionHandler)
    }
    
}
