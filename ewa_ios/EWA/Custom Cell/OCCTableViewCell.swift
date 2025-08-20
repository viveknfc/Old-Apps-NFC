//
//  OCCTableViewCell.swift
//  EWA
//
//  Created by NFC Solutions on 21/11/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit

class OCCTableViewCell: UITableViewCell {

    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var workPerformed: UILabel!
    @IBOutlet var startTimeLabel: UILabel!
    @IBOutlet var endTimeLabel: UILabel!
    @IBOutlet var matterlabel: UILabel!
    
    @IBOutlet var cView: UIView!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var totalTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
