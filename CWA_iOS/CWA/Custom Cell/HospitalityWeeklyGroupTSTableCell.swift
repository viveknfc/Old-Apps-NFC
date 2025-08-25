//
//  HospitalityWeeklyGroupTSTableCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 19/07/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import FloatRatingView

class HospitalityWeeklyGroupTSTableCell: UITableViewCell {

    @IBOutlet weak var lblMon: UILabel!
    @IBOutlet weak var lblTue: UILabel!
    @IBOutlet weak var lblWed: UILabel!
    @IBOutlet weak var lblThu: UILabel!
    @IBOutlet weak var lblFri: UILabel!
    @IBOutlet weak var lblSat: UILabel!
    @IBOutlet weak var lblSun: UILabel!
    @IBOutlet weak var lblReg: UILabel!
    @IBOutlet weak var lblOT: UILabel!
    @IBOutlet weak var lblTotalBreak: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTaxifare: UILabel!
    @IBOutlet weak var lblEval: UILabel!
    @IBOutlet weak var lblRatingValue: UILabel!

    @IBOutlet weak var payForBreakBtn: UIButton!
    @IBOutlet weak var addCommentBtn: UIButton!

    @IBOutlet weak var moreLessBtn: UIButton!
    @IBOutlet weak var approveBtn: UIButton!
    @IBOutlet weak var lblWeekend: UILabel!
    @IBOutlet weak var lblPO: UILabel!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var downBGView: UIView!
 
    @IBOutlet weak var floatRatingView: FloatRatingView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
