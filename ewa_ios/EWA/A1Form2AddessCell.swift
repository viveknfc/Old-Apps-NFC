//
//  A1Form2AddessCell.swift
//  EWA
//
//  Created by NFC User on 7/16/21.
//  Copyright © 2021 NFC. All rights reserved.
//

import UIKit

class A1Form2AddessCell: UITableViewCell {
    @IBOutlet weak var editTrailing: NSLayoutConstraint!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var aptLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var backView: UIView!{
        didSet {
            backView.layer.borderColor = UIColor.lightGray.cgColor
            backView.layer.borderWidth = 0.6
            backView.layer.cornerRadius = 5
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
