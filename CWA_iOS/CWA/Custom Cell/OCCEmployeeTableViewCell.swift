//
//  OCCEmployeeTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 01/03/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class OCCEmployeeTableViewCell: UITableViewCell {
    
    @IBOutlet var searchEmpBtn: UIButton!
    @IBOutlet var findAttorneyBtn: UIButton!
    @IBOutlet var occToRecruitBtn: UIButton!

    @IBOutlet var moveUpBtn: UIButton!
    @IBOutlet var moveDownBtn: UIButton!
    @IBOutlet var deleteBtn: UIButton!
    @IBOutlet var empTableView: UITableView!
    @IBOutlet var TblBGView: UIView!

    @IBOutlet var attorneyTxtField: UITextField!
    @IBOutlet var occToRecruitLbl: UILabel!
    @IBOutlet var headerLbl: UILabel!
    @IBOutlet var toRecruitView: UIView!
    @IBOutlet weak var toRecruitViewTopConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
