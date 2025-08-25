//
//  DivisionListTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 08/05/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class DivisionListTableViewCell: UITableViewCell {

    @IBOutlet var TextLabel: UILabel!
    @IBOutlet var DetailTextLabel: UILabel!
    @IBOutlet var ImageView: UIImageView!
    @IBOutlet var TextLabelHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
