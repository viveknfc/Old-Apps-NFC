//
//  PendingTimeSlipTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 01/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class PendingTimeSlipTableViewCell: UITableViewCell {

    @IBOutlet weak var approveButton: UIButton!
    @IBOutlet weak var viewEditButton: UIButton!
    @IBOutlet weak var lblWeekEndingDate: UILabel!
    @IBOutlet weak var lblEmployeeName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
