//
//  BorderPaddingText.swift
//  EWA
//
//  Created by NFC Solutions on 08/01/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class BorderPaddingText: UITextField {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setBorderColor()
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.setBorderColor()
    }
    func setBorderColor(){
        self.layer.borderColor = UIColor(hexString:"#EEEEEE").cgColor
        self.layer.borderWidth = 0.5
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
