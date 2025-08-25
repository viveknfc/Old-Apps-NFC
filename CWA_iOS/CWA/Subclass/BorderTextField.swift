//
//  BorderTextField.swift
//  EWA
//
//  Created by NFC Solutions on 14/12/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit

class BorderTextField: UITextField {

    
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
    @IBInspectable var leftImage : UIImage?{
        didSet{
            
            
            var padding = Int()
            var size = Int()
            
            if UIDevice().type == Model.iPhone5 || UIDevice().type == Model.iPhone5S || UIDevice().type == Model.iPhone5C
            {
                padding = 2
                size = 10
            }
            else
            {
                padding = 2
                size = 15
            }
            
            let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding, height: size) )
            let iconView  = UIImageView(frame: CGRect(x: padding, y: 0, width: size, height: size))
            iconView.image = leftImage
            iconView.contentMode = .scaleAspectFit
            outerView.addSubview(iconView)
            
            self.leftView = outerView
            self.leftViewMode = .always
            
        }
    }
}


