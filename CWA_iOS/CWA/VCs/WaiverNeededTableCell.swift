//
//  WaiverNeededTableCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 02/05/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class WaiverNeededTableCell: UITableViewCell {
   
    @IBOutlet weak var topHeadingLabel: UILabel!
    @IBOutlet var dailyCompensationValueLabel: UILabel!

    @IBOutlet weak var DailyCompensationTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
