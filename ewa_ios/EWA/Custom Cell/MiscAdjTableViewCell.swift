//
//  MiscAdjTableViewCell.swift
//  EWA
//
//  Created by NFC India on 27/09/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class MiscAdjTableViewCell: UITableViewCell {

    @IBOutlet weak var descriLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
