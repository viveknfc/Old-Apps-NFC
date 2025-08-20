//
//  InformationCellTableViewCell.swift
//  EWA
//
//  Created by NFC Solutions on 21/12/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit

class InformationCellTableViewCell: UITableViewCell {

    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
