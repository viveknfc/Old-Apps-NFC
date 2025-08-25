//
//  PaddingTextfield.swift
//  CWA
//
//  Created by NFC Solutionsusa on 27/12/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class PaddingTextfield: UITextField {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 30, y: bounds.origin.y, width: bounds.width - 20, height: bounds.height)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 30, y: bounds.origin.y, width: bounds.width - 20, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 30, y: bounds.origin.y, width: bounds.width - 20, height: bounds.height)
    }
    
    //   override func textRect(forBounds bounds: CGRect) -> CGRect {
    //        return UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 15)
    //    }
    //
    //
    //    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    // return UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 15)    }
    //
    //    override func editingRect(forBounds bounds: CGRect) -> CGRect {
    // return UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 15)    }
}
