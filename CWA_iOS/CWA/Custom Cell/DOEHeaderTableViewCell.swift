//
//  DOEHeaderTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 02/04/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class DOEHeaderTableViewCell: UITableViewCell {
    @IBOutlet var clickHereBtn: UIButton!
    @IBOutlet var lblHeader: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
