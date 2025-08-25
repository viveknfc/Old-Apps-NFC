//
//  DOEOrderTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 28/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class DOEOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var lblProjPoBalance: UILabel!
    @IBOutlet weak var lblUnbilledTSRevenue: UILabel!
    @IBOutlet weak var lblCurrentAmtInvoiced: UILabel!
    @IBOutlet weak var lblOutSTandingPOBalance: UILabel!
    @IBOutlet weak var lblTotalOrderPOAmt: UILabel!
    @IBOutlet weak var lblPay: UILabel!
    @IBOutlet weak var lblBill: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var lblDateEntered: UILabel!
    @IBOutlet weak var lblPONum: UILabel!
    @IBOutlet weak var lblStartEndDate: UILabel!
    @IBOutlet weak var lblOrderNum: UILabel!
    @IBOutlet weak var arrowImgView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgSubView: UIView!
    @IBOutlet weak var showMoreButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
