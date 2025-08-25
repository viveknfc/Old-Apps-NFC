//
//  TipCalTableCell.swift
//  CWA
//
//  Created by NFC User on 3/25/19.
//  Copyright © 2019 NFC Solutionsusa. All rights reserved.
//

import UIKit

class TipCalTableCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var hoursLbl: UILabel!
    @IBOutlet weak var tipLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
