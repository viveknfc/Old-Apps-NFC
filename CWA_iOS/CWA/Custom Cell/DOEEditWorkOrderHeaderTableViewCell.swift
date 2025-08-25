//
//  DOEEditWorkOrderHeaderTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 27/04/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class DOEEditWorkOrderHeaderTableViewCell: UITableViewCell {
  
    @IBOutlet var LblOrderId: UILabel!
    @IBOutlet var clickHereBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
