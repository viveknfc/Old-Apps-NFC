//
//  OrderListTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 02/08/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class OrderListTableViewCell: UITableViewCell {
    @IBOutlet weak var lblOrder: UILabel!
    @IBOutlet weak var lblDept: UILabel!
    @IBOutlet weak var lblPoNum: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var lblReportTo: UILabel!
    @IBOutlet weak var lblTotalNumTemps: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var locationDetailsBtn: UIButton!

    @IBOutlet weak var BtnCopyOrder: UIButton!
    @IBOutlet weak var BtnEditOrder: UIButton!
    @IBOutlet weak var editBtnTrailingConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
