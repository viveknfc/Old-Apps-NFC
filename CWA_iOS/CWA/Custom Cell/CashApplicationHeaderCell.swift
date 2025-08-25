//
//  CashApplicationHeaderCell.swift
//  CWA
//
//  Created by NFC User on 6/17/20.
//  Copyright © 2020 NFC Solutionsusa. All rights reserved.
//

import UIKit

class CashApplicationHeaderCell: UITableViewCell {
    @IBOutlet weak var headerOpenButton: UIButton!
    @IBOutlet weak var headerBackView: UIView!
    
    @IBOutlet weak var headerNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
