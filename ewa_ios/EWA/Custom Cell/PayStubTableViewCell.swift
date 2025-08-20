//
//  PayStubTableViewCell.swift
//  EWA
//
//  Created by NFC India on 24/09/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class PayStubTableViewCell: UITableViewCell {

    
    @IBOutlet weak var checkNumberLabel: UILabel!
    @IBOutlet weak var divisionLabel: UILabel!
    @IBOutlet weak var checkDate: UILabel!
    @IBOutlet weak var nteWages: UILabel!
    @IBOutlet weak var grossWages: UILabel!
    @IBOutlet weak var grossYTD: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
