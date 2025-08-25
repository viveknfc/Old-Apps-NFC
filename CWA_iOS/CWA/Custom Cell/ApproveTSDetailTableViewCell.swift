//
//  ApproveTSDetailTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 19/12/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class ApproveTSDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDateValue: UILabel!
    @IBOutlet weak var lblTimeValue: UILabel!
    @IBOutlet weak var lblHrValue: UILabel!
    @IBOutlet weak var lblLunchValue: UILabel!
    @IBOutlet weak var lblTaxifareValue: UILabel!
    @IBOutlet weak var lblTimeTitle: UILabel!
    @IBOutlet weak var lblHrTitle: UILabel!
    @IBOutlet weak var lblLunchTitle: UILabel!
    @IBOutlet weak var lblTaxifareTitle: UILabel!

    @IBOutlet weak var lblTimeColon: UILabel!
    @IBOutlet weak var lblHrColon: UILabel!
    @IBOutlet weak var lblLunchColon: UILabel!
    @IBOutlet weak var lblTaxifareColon: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
