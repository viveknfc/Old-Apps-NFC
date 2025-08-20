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
            self.layer.borderColor = UIColor(hexString:"#EEEEEE").cgColor
            self.layer.borderWidth = 0.5
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
            
            //self.leftView = UIImageView(image: leftImage)
            // select mode -> .never .whileEditing .unlessEditing .always
            //self.leftViewMode = .always
        }
    }
//    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
//        var superRect = super.leftViewRect(forBounds: bounds)
//        superRect.origin.x = 0
//        return superRect
//    }
//    override func textRect(forBounds bounds: CGRect) -> CGRect {
//        var rect = super.textRect(forBounds: bounds)
//        rect.origin.x = 0
//        return rect
//    }
//
//    //
//    override func editingRect(forBounds bounds: CGRect) -> CGRect {
//        var rect = super.editingRect(forBounds: bounds)
//        rect.origin.x = 0
//        return rect
//    }
//
//    //
//    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//        var rect = super.placeholderRect(forBounds: bounds)
//        rect.origin.x = 0
//        return rect
//    }
    
}


