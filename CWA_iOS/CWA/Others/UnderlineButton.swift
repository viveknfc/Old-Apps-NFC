//
//  UnderlineButton.swift
//  BOW-Barber
//
//  Created by NFC Solutionsusa on 07/09/17.
//  Copyright © 2017 nfcsolutionsusa. All rights reserved.
//

import UIKit

class UnderlineButton: UIButton {

     // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let layer = CALayer()
        let borderWidth = 1
        layer.borderWidth = CGFloat(borderWidth)
        layer.borderColor =  UIColor.init(red: 67/255, green: 139/255, blue: 202/255, alpha: 1).cgColor
        layer.frame = CGRect(x:0,
                             y:self.frame.size.height - 1,
                             width:self.frame.size.width,
                             height:self.frame.size.height)
        
        self.layer .addSublayer(layer)
        self.layer.masksToBounds = true
    }
 
}
