//
//  BorderPaddingTextField.swift
//  EWA
//
//  Created by NFC Solutions on 20/12/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit

class BorderPaddingTextField: UITextField {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setBorderColor()
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.setBorderColor()
    }
    func setBorderColor(){
        self.layer.borderColor = UIColor(hexString:"#D8D8D8").cgColor
        self.layer.borderWidth = 0.8
        // code which is common for all text fields
    }
    
    @IBInspectable var insetX: CGFloat = 5
    @IBInspectable var insetY: CGFloat = 0
    
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
}
