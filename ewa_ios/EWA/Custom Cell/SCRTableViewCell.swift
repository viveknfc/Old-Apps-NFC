//
//  SCRTableViewCell.swift
//  EWA
//
//  Created by NFCIndia on 16/09/19.
//  Copyright © 2019 NFC. All rights reserved.
//

import UIKit

class SCRTableViewCell: UITableViewCell {

    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var aptLabel: UILabel!
    
    @IBOutlet weak var fromLabel: UILabel!
    
    @IBOutlet weak var toLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet weak var zipCodeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
