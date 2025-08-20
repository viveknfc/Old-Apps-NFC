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
        self.layer.borderColor = UIColor(hexString:"#EEEEEE").cgColor
        self.layer.borderWidth = 0.5
        // code which is common for all text fields
    }
    
    @IBInspectable var insetX: CGFloat = 25
    @IBInspectable var insetY: CGFloat = 0
    
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    @IBInspectable var rightImage : UIImage?{
        didSet{
            if (rightImage != nil)
            {
            let padding = 3
            let size = 20
            
            let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding, height: size) )
            let iconView  = UIImageView(frame: CGRect(x: padding, y: 0, width: size, height: size))
            iconView.image = rightImage
            outerView.addSubview(iconView)
            
            self.rightView = outerView
            self.rightViewMode = .always
            
            //self.leftView = UIImageView(image: leftImage)
            // select mode -> .never .whileEditing .unlessEditing .always
            //self.leftViewMode = .always
        }
        }
    }
    @IBInspectable var leftImage : UIImage?{
        didSet{
            
            if (leftImage != nil)
            {
            let padding = 3
            let size = 20
            
            let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding, height: size) )
            let iconView  = UIImageView(frame: CGRect(x: padding, y: 0, width: size, height: size))
            iconView.image = leftImage
            outerView.addSubview(iconView)
            
            self.leftView = outerView
            self.leftViewMode = .always
            
            //self.leftView = UIImageView(image: leftImage)
            // select mode -> .never .whileEditing .unlessEditing .always
            //self.leftViewMode = .always
        }
        }
    }
}
