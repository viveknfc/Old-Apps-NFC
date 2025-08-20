//
//  EarningsTableViewCell.swift
//  EWA
//
//  Created by NFC India on 27/09/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class EarningsTableViewCell: UITableViewCell {

    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var division: UILabel!
    @IBOutlet weak var descri: UILabel!
    @IBOutlet weak var unit: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var earnings: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
