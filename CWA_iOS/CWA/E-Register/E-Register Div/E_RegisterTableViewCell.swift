//
//  E_RegisterTableViewCell.swift
//  CWA
//
//  Created by NFC User on 26/09/23.
//  Copyright © 2023 NFC Solutionsusa. All rights reserved.
//

import UIKit

class E_RegisterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var divisionLogo: UIImageView!
    @IBOutlet weak var divisionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
