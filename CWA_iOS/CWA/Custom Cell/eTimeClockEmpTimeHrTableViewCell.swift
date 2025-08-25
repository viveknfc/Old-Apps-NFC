//
//  eTimeClockEmpTimeHrTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 27/11/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class eTimeClockEmpTimeHrTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblLoginStart: UILabel!
    @IBOutlet weak var lblLunchOut: UILabel!
    @IBOutlet weak var lblLunchReturn: UILabel!
    @IBOutlet weak var lblLogoutFinish: UILabel!
    @IBOutlet weak var lblChangedBy: UILabel!
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
