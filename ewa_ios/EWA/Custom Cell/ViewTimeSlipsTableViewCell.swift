//
//  ViewTimeSlipsTableViewCell.swift
//  EWA
//
//  Created by NFC Solutions on 01/11/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit

class ViewTimeSlipsTableViewCell: UITableViewCell {

    @IBOutlet var clientConstrain: NSLayoutConstraint!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var clientName: UILabel!
    @IBOutlet var titleConstrain: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
