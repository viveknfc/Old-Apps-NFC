//
//  AssignmentDetailTableViewCell.swift
//  EWA
//
//  Created by NFC Solutions on 20/10/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit

class AssignmentDetailTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!

    @IBOutlet var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
