//
//  AssignmentsTableViewCell.swift
//  EWA
//
//  Created by NFC Solutions on 09/10/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit

class AssignmentsTableViewCell: UITableViewCell {

    @IBOutlet var addressHeight: NSLayoutConstraint!
    @IBOutlet var titleHeight: NSLayoutConstraint!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var officeName: UILabel!
    @IBOutlet var jobTitle: UILabel!
    @IBOutlet var cView: UIView!
    
    
    @IBOutlet var timeImageView: UIImageView!
    @IBOutlet var locationImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
