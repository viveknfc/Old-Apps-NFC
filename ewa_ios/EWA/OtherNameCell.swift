//
//  OtherNameCell.swift
//  EWA
//
//  Created by NFC User on 7/29/21.
//  Copyright © 2021 NFC. All rights reserved.
//

import UIKit

class OtherNameCell: UITableViewCell {
    @IBOutlet weak var backView: UIView!
    {
        didSet {
            backView.layer.borderWidth = 0.6
            backView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var nameTFTrailing: NSLayoutConstraint! // 8 to 140
    
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var nameTF: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
