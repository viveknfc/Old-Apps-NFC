//
//  ShadowButton.swift
//  EWA
//
//  Created by NFC Solutions on 11/12/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit

class ShadowButton: UIButton {

    override func draw(_ rect: CGRect) {
        updateLayerProperties()
    }
    
    func updateLayerProperties() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5.0
        self.layer.masksToBounds = false
    }


}
