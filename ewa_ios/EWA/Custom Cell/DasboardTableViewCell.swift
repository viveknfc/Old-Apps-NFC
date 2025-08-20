//
//  DasboardTableViewCell.swift
//  EWA
//
//  Created by NFC Solutions on 27/12/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit

class DasboardTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
