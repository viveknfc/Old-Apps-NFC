//
//  PayStubCodeTableViewCell.swift
//  EWA
//
//  Created by NFC India on 01/10/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class PayStubCodeTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var clientAddress: UILabel!
    @IBOutlet weak var clientPhone: UILabel!
    @IBOutlet weak var regRate: UILabel!
    @IBOutlet weak var otRate: UILabel!
    @IBOutlet weak var doubleTime: UILabel!
    @IBOutlet weak var totalHours: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
