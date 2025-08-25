//
//  WaiverFormTableCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 20/04/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class WaiverFormTableCell: UITableViewCell {

    @IBOutlet weak var ConsultantOver65TextLabel: UILabel!
    @IBOutlet weak var ConsultantPriortoMayTextLabel: UILabel!
    @IBOutlet weak var ConsultantPensionTextLabel: UILabel!
    @IBOutlet weak var FormatCurrYearCompensationOver30kTextLabel: UILabel!
    @IBOutlet weak var FormatYtdCompensationNextYearTextLabel: UILabel!
    @IBOutlet var crntYrCompIncludingEarninglLab: UILabel!
    @IBOutlet var crntYrComplLab: UILabel!
    
    @IBOutlet var RetireeReceivingPensionYesBtn: UIButton!
    @IBOutlet var RetireeReceivingPensionNoBtn: UIButton!

    @IBOutlet var ConsultantJoinPrior1973YesBtn: UIButton!
    @IBOutlet var ConsultantJoinPrior1973NoBtn: UIButton!

    @IBOutlet var Over65YesBtn: UIButton!
    @IBOutlet var Over65NoBtn: UIButton!
    
    @IBOutlet var Over65View: UIView!

    @IBOutlet var ConsultantJoinPrior1973View: UIView!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
