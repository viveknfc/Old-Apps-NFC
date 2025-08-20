//
//  CAMultiBreakCollectionCell.swift
//  EWA
//
//  Created by NFC User on 4/29/21.
//  Copyright © 2021 NFC. All rights reserved.
//

import UIKit

class CAMultiBreakCollectionCell: UICollectionViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startTimeTF: BorderTextField!
    
    @IBOutlet weak var mealOut1TF: BorderTextField!
    @IBOutlet weak var mealReturn1TF: BorderTextField!
    
    @IBOutlet weak var mealOut2TF: BorderTextField!
    
    @IBOutlet weak var mealReturn2TF: BorderTextField!
    
    @IBOutlet weak var endTimeTF: BorderTextField!
    @IBOutlet weak var endTimeTop: NSLayoutConstraint! // 96 to 2
    
    @IBOutlet weak var lunchMinTF: BorderTextField!
    @IBOutlet weak var totalTF: BorderTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
