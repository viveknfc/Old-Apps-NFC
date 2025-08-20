//
//  CAMultiBreakCell.swift
//  EWA
//
//  Created by NFC User on 4/27/21.
//  Copyright © 2021 NFC. All rights reserved.
//

import UIKit

class CAMultiBreakCell: UITableViewCell {

    @IBOutlet weak var typeTextField: BorderTextField!
    
    @IBOutlet weak var mondayTF: BorderTextField!
    @IBOutlet weak var tuesdayTF: BorderTextField!
    @IBOutlet weak var wednesdayTF: BorderTextField!
    @IBOutlet weak var thursdayTF: BorderTextField!
    @IBOutlet weak var fridayTF: BorderTextField!
    @IBOutlet weak var saturdatTF: BorderTextField!
    @IBOutlet weak var sundayTF: BorderTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
