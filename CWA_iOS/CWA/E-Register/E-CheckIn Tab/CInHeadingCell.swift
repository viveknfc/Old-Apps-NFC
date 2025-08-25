//
//  CInHeadingCell.swift
//  CWA
//
//  Created by NFC User on 30/09/23.
//  Copyright © 2023 NFC Solutionsusa. All rights reserved.
//

import UIKit

class CInHeadingCell: UITableViewCell {
    
    @IBOutlet weak var FName: UILabel!
    @IBOutlet weak var PName: UILabel!
    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var checkInTF: UITextField!
    @IBOutlet weak var checkInSubmit: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        let placeholderText = NSAttributedString(string: "Enter Time In", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1515013874, green: 0.1768231988, blue: 0.4189088941, alpha: 1)])
        checkInTF.attributedPlaceholder = placeholderText
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
