//
//  ReferalBonusTableViewCell.swift
//  EWA
//
//  Created by NFC India on 13/08/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class ReferalBonusTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var requiredHours: UILabel!
    @IBOutlet weak var comissionLabel: UILabel!
    @IBOutlet weak var currentHours: UILabel!
    @IBOutlet weak var applicationReceivedDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
