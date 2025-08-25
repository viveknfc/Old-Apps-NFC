//
//  DOEEditWorkOrderTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 25/04/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class DOEEditWorkOrderTableViewCell: UITableViewCell {
  
    @IBOutlet var totalBillingTextField: UITextField!
    @IBOutlet var totalHoursTextField: UITextField!
    @IBOutlet var lblNote: UILabel!
    @IBOutlet var lblTotalBilling: UILabel!
    @IBOutlet var lblTotalHour: UILabel!

    @IBOutlet var SunBtn: UIButton!
    @IBOutlet var FriBtn: UIButton!
    @IBOutlet var ThuBtn: UIButton!
    @IBOutlet var WedBtn: UIButton!
    @IBOutlet var TueBtn: UIButton!
    @IBOutlet var MonBtn: UIButton!
    @IBOutlet var SatBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
