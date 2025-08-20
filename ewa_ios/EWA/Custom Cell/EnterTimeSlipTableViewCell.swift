//
//  EnterTimeSlipTableViewCell.swift
//  EWA
//
//  Created by NFC Solutions on 13/11/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit

class EnterTimeSlipTableViewCell: UITableViewCell {

    @IBOutlet var clientNameLabel: UILabel!
    @IBOutlet var referenceLabel: UILabel!
    @IBOutlet var postitionLabel: UILabel!
    @IBOutlet var scheduleLabel: UILabel!
    
    @IBOutlet var scheduleTimeLabel: UILabel!
    
    @IBOutlet var assignementTitle: UILabel!
    @IBOutlet var postitionTitle: UILabel!
    @IBOutlet var referenceTitle: UILabel!
    @IBOutlet var scheduleTitle: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
