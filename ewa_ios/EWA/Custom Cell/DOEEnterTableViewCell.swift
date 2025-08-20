//
//  DOEEnterTableViewCell.swift
//  EWA
//
//  Created by NFC Solutions on 20/11/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit

class DOEEnterTableViewCell: UITableViewCell {

    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var endTimeField: UITextField!
    @IBOutlet var startTimeTextField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
