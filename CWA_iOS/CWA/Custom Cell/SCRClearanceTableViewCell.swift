//
//  SCRClearanceTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 02/11/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class SCRClearanceTableViewCell: UITableViewCell {

    @IBOutlet weak var scrView: UIView!
    @IBOutlet var applicantIdLbl: UILabel!
    @IBOutlet var firstNameLbl: UILabel!
    @IBOutlet var lastNameLbl: UILabel!
    @IBOutlet var dobLbl: UILabel!
    @IBOutlet var scrSubmissionDateLbl: UILabel!
    @IBOutlet var scrApprovalStatusLbl: UILabel!
    @IBOutlet var deniedByLbl: UILabel!
    @IBOutlet var deniedDateLbl: UILabel!
    
    @IBOutlet var approveBtnOutlet: UIButton!
    @IBOutlet var denyBtnOutlet: UIButton!
    @IBOutlet var colorView: UIView!
    
    @IBOutlet var sAppLbl: UILabel!
    @IBOutlet var sFirstLbl: UILabel!
    @IBOutlet var sLastLbl: UILabel!
    @IBOutlet var sDobLbl: UILabel!
    @IBOutlet var sSubmissionDate: UILabel!
    @IBOutlet var sApproveStatus: UILabel!
    @IBOutlet var sDeniedBy: UILabel!
    @IBOutlet var sDeniedDate: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//    scrView.layer.borderWidth = 1
//    scrView.layer.borderColor = UIColor.gray.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
