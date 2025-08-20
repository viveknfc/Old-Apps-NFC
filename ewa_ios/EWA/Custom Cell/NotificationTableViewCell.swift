//
//  NotificationTableViewCell.swift
//  EWA
//
//  Created by NFC India on 12/04/19.
//  Copyright © 2019 NFC. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var detailcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var datetime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
