//
//  HospitalityGroupTSTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 17/07/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import FloatRatingView

class HospitalityGroupTSTableViewCell: UITableViewCell {

    @IBOutlet weak var approveBtn: UIButton!
    @IBOutlet weak var moreLessBtn: UIButton!
    @IBOutlet weak var payForBreakBtn: UIButton!
    @IBOutlet weak var addCommentBtn: UIButton!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var endTimeTxtField: UITextField!
    @IBOutlet weak var startTimeTxtField: UITextField!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeViewLabel: UILabel!
    @IBOutlet weak var lblTaxiFare: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblPayForBreak: UILabel!
    @IBOutlet weak var lblBreak: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPO: UILabel!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var lblEval: UILabel!
    @IBOutlet weak var lblRatingValue: UILabel!

    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var downBGView: UIView!
    @IBOutlet weak var saveDataBtn: UIButton!
    @IBOutlet weak var saveDataBtnTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var startTimeBgView: UIView!
    @IBOutlet weak var endTimeBgView: UIView!
    
    @IBOutlet weak var tipAmountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
