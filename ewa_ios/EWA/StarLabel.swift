//
//  StarLabel.swift
//
//
//  Created by NFC Solutions on 03/08/21.
//  Copyright © 2021 NFC. All rights reserved.
//

import UIKit

class StarLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    required init(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)!
           self.commonInit()

       }

       override init(frame: CGRect) {
           super.init(frame: frame)
           self.commonInit()
       }
       func commonInit(){
           let range = NSString(string: self.text!).range(of: "*")
                  let attributedString = NSMutableAttributedString(string:text!)
                  attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range as NSRange)

                      //Apply to the label
                      self.attributedText = attributedString;
       }
    
}
