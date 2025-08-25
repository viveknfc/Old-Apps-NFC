//
//  ActiveOrderTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 23/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class ActiveOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDate: UILabel!

    @IBOutlet weak var lblPositionTitle: UILabel!
    @IBOutlet weak var lblNameTitle: UILabel!
    @IBOutlet weak var lblAmountTitle: UILabel!
    @IBOutlet weak var lblDateTitle: UILabel!
    @IBOutlet weak var bgView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
