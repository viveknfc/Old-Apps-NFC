//
//  MultiBreakTableCell.swift
//  EWA
//
//  Created by NFC User on 4/15/21.
//  Copyright © 2021 NFC. All rights reserved.
//

import UIKit

class MultiBreakTableCell: UITableViewCell {
    @IBOutlet weak var startTimeTF: UITextField!
    
    @IBOutlet weak var endTimeTF: UITextField!
    @IBOutlet weak var totalTimeTF: UITextField!
    
    @IBOutlet weak var breakStart1TF: UITextField!
    
    @IBOutlet weak var breakEnd1TF: UITextField!
    
    @IBOutlet weak var breakTotalTF: UITextField!
    
    @IBOutlet weak var breakStart2TF: UITextField!
    
    @IBOutlet weak var breakEnd2TF: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
