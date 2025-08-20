//
//  BorderLabel.swift
//  EWA
//
//  Created by NFC Solutions on 14/12/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit

@IBDesignable
class BorderLabel: UILabel {

    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

}
