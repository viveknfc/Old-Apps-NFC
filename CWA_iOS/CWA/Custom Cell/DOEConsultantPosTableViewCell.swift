//
//  DOEConsultantPosTableViewCell.swift
//  CWA
//
//  Created by Jayaprada on 01/04/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class DOEConsultantPosTableViewCell: UITableViewCell {
    
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var editAddressBtn: UIButton!
    @IBOutlet var searchTxtField: UITextField!
    @IBOutlet var addressLabl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
