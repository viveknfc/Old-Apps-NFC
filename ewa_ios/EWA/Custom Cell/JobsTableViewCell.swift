//
//  JobsTableViewCell.swift
//  EWA
//
//  Created by NFC Solutions on 07/11/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit

class JobsTableViewCell: UITableViewCell {

    @IBOutlet var declineDateLable: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var clientNameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var payLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var declineButton: UIButton!
    @IBOutlet var acceptButton: UIButton!
    @IBOutlet weak var acceptButtonTrailingConstraint: NSLayoutConstraint!
        @IBOutlet var bgView: UIView!
    @IBOutlet var statusLabel: UILabel!
    
    
    @IBOutlet var dateConstrain: NSLayoutConstraint!
    @IBOutlet var locationConstrain: NSLayoutConstraint!
    @IBOutlet var companyNameConstrain: NSLayoutConstraint!
    @IBOutlet var titleConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var scheduleImageView: UIImageView!
    @IBOutlet weak var scheduleTimeConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scheduleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
