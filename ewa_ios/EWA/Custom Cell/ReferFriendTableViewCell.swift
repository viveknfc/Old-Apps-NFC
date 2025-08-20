//
//  ReferFriendTableViewCell.swift
//  EWA
//
//  Created by NFC India on 08/08/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class ReferFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var jobImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryType: UILabel!
    @IBOutlet weak var jobTypeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
