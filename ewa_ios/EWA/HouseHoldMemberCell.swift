//
//  HouseHoldMemberCell.swift
//  EWA
//
//  Created by NFC User on 7/23/21.
//  Copyright © 2021 NFC. All rights reserved.
//

import UIKit

class HouseHoldMemberCell: UITableViewCell {
    @IBOutlet weak var backView: UIView!{
        didSet {
            backView.layer.borderColor = UIColor.lightGray.cgColor
            backView.layer.borderWidth = 0.6
            backView.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var relationshipLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
