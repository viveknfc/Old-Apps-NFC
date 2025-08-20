//
//  OdersTableViewCell.swift
//  EWA
//
//  Created by NFC India on 12/12/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class OdersTableViewCell: UITableViewCell {

    
    @IBOutlet weak var divNameLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
