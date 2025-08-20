//
//  OverTimeTableViewCell.swift
//  EWA
//
//  Created by NFC Solutions on 24/11/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit

class OverTimeTableViewCell: UITableViewCell {

    @IBOutlet var payRollPeriod: UILabel!
    @IBOutlet var otHoursAvailable: UILabel!
    @IBOutlet var otHoursUse: UILabel!
    @IBOutlet var otHoursAprroved: UILabel!
    @IBOutlet var payRollPeriodHours: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
