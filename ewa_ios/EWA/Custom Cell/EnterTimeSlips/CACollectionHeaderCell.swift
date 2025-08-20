//
//  CACollectionHeaderCell.swift
//  EWA
//
//  Created by NFC User on 4/29/21.
//  Copyright © 2021 NFC. All rights reserved.
//

import UIKit

class CACollectionHeaderCell: UICollectionViewCell {
    @IBOutlet weak var startTimeLabel: UILabel!
    
    @IBOutlet weak var mealOut1Label: UILabel!
    
    @IBOutlet weak var mealReturn1Label: UILabel!
    
    @IBOutlet weak var mealOut2Label: UILabel!
    
    @IBOutlet weak var mealReturn2Label: UILabel!
    
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var lunchMinLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var endTimeTop: NSLayoutConstraint! //96 to 2
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
