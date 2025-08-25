//
//  WeeklyStaffingTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 14/12/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class WeeklyStaffingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblEmpName: UILabel!
    @IBOutlet weak var dayColView: UICollectionView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var colViewTrailingConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
