//
//  DOHTableViewCell.swift
//  EWA
//
//  Created by NFC Solutions on 18/12/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit

class DOHTableViewCell: UITableViewCell {

    @IBOutlet weak var totalTextField: BorderTextField!
    @IBOutlet weak var lunchTextField: BorderTextField!
    @IBOutlet weak var fourthTextField: BorderTextField!
    @IBOutlet weak var thirdTextField: BorderTextField!
    @IBOutlet weak var secondTextField: BorderTextField!
    @IBOutlet weak var firstTextField: BorderTextField!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
