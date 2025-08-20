//
//  UploadResumeTableViewCell.swift
//  EWA
//
//  Created by NFC India on 30/11/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class UploadResumeTableViewCell: UITableViewCell {

    @IBOutlet weak var resumeLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var extensionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
