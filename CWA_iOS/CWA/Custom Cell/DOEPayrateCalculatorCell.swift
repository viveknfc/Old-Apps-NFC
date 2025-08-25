//
//  DOEPayrateCalculatorCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 16/04/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class DOEPayrateCalculatorCell: UITableViewCell {

    @IBOutlet var DailyRateBtn: UIButton!
    @IBOutlet var AnnualRateBtn: UIButton!
    @IBOutlet var DailyRateTxtField: UITextField!
    @IBOutlet var HoursTxtField: UITextField!
    @IBOutlet var MinuteTxtField: UITextField!
    @IBOutlet var PayRateHeaderLbl: UILabel!
    @IBOutlet var infoLbl: UILabel!
    @IBOutlet var HoursTxtFieldBGView: UIView!
    @IBOutlet var MinuteTxtFieldBGView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
