//
//  ScheduleTableViewCell.swift
//  EWA
//
//  Created by NFC Solutions on 08/03/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    @IBOutlet var daysLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var cLabelConstrain: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
