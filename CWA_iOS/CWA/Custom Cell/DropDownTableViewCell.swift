//
//  DropDownTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 12/12/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class DropDownTableViewCell: UITableViewCell {

    @IBOutlet weak var dropDownTextFiled: UITextField!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var dropDownButton: UIButton!
     @IBOutlet weak var dropDownTblView: UITableView!
    @IBOutlet weak var addreportToButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var dropDownViewView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
