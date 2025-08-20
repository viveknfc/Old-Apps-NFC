//
//  ReferalApplicantListTableViewCell.swift
//  EWA
//
//  Created by NFC India on 13/08/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class ReferalApplicantListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var referalDateLabel: UILabel!
    @IBOutlet weak var receivedDate: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
