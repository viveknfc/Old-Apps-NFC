//
//  PKButton.swift
//  Basok
//
//  Created by DsquareTechLabs on 23/12/16.
//  Copyright © 2016 DsquareTechLabs. All rights reserved.
//

import UIKit

class PKButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let view = UIView()
//        view.backgroundColor = UIColor.black
//
//        view.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(view)
//
//        view.addConstraint(NSLayoutConstraint(
//            item: view,
//            attribute: .height,
//            relatedBy: .equal,
//            toItem: nil,
//            attribute: .height,
//            multiplier: 1,
//            constant: 1
//            )
//        )
//
//        addConstraint(NSLayoutConstraint(
//            item: view,
//            attribute: .left,
//            relatedBy: .equal,
//            toItem: self,
//            attribute: .left,
//            multiplier: 1,
//            constant: 0
//            )
//        )
//
//        addConstraint(NSLayoutConstraint(
//            item: view,
//            attribute: .right,
//            relatedBy: .equal,
//            toItem: self,
//            attribute: .right,
//            multiplier: 1,
//            constant: 0
//            )
//        )
//
//        addConstraint(NSLayoutConstraint(
//            item: view,
//            attribute: .bottom,
//            relatedBy: .equal,
//            toItem: self,
//            attribute: .bottom,
//            multiplier: 1,
//            constant: 0
//            )
//        )
//    }
        
}

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 5.0
        clipsToBounds = true
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        setTitleColor(.black, for: .normal)
        setTitleColor(.black, for: .highlighted)
        
}
}
