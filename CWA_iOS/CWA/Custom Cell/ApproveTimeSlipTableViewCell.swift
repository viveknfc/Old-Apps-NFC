//
//  ApproveTimeSlipTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 15/12/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class ApproveTimeSlipTableViewCell: UITableViewCell {

    @IBOutlet weak var lblEmpName: UILabel!
    @IBOutlet weak var lblHours: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblApprovedBy: UILabel!
    @IBOutlet weak var lblReference: UILabel!

    @IBOutlet weak var approveButton: UIButton!
    @IBOutlet weak var viewEditButton: UIButton!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var approveCheckButton: UIButton!

    @IBOutlet weak var evaluateButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var viewEditView: UIView!

    @IBOutlet weak var btnView: UIView!

    @IBOutlet weak var lblColon1: UILabel!
    @IBOutlet weak var lblColon2: UILabel!
    @IBOutlet weak var lblColon3: UILabel!
    @IBOutlet weak var lblColon4: UILabel!
    @IBOutlet weak var lblColon5: UILabel!

    
    @IBOutlet weak var lblEmpNameTitle: UILabel!
    @IBOutlet weak var lblHoursTitle: UILabel!
    @IBOutlet weak var lblDateTitle: UILabel!
    @IBOutlet weak var lblApprovedByTitle: UILabel!
    @IBOutlet weak var lblReferenceTitle: UILabel!

    @IBOutlet weak var lblEmpLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblHoursLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblDateLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblApprovedByLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblReferenceLeadingConstraint: NSLayoutConstraint!
    


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
