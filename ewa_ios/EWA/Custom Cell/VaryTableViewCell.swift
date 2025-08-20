//
//  VaryTableViewCell.swift
//  EWA
//
//  Created by NFC Solutions on 08/03/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class VaryTableViewCell: UITableViewCell {

    @IBOutlet var mondayLabel: PaddingLabel!
    @IBOutlet var tuesdayLabel: PaddingLabel!
    @IBOutlet var wednesdayLabel: PaddingLabel!
    @IBOutlet var thursdayLabel: PaddingLabel!
    @IBOutlet var fridayLabel: PaddingLabel!
    @IBOutlet var saturdayLabel: PaddingLabel!
    @IBOutlet var sundayLabel: PaddingLabel!
    
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
