//
//  ButtonTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 24/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {
    @IBOutlet weak var dButton: UIButton!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblYes: UILabel!
    @IBOutlet weak var dropDownTxtField: UITextField!
    @IBOutlet weak var lblHeader: UILabel!
    
@IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var returnToConfirmOrderButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
