//
//  PaddingLabel.swift
//  EWA
//
//  Created by NFC Solutions on 13/12/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {
    
        
        @IBInspectable var topInset: CGFloat = 5.0
        @IBInspectable var bottomInset: CGFloat = 5.0
        @IBInspectable var leftInset: CGFloat = 5.0
        @IBInspectable var rightInset: CGFloat = 5.0
        
        override func drawText(in rect: CGRect) {
            let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
            super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        }
        
        override var intrinsicContentSize: CGSize {
            get {
                var contentSize = super.intrinsicContentSize
                contentSize.height += topInset + bottomInset
                contentSize.width += leftInset + rightInset
                return contentSize
            }
        }
}
