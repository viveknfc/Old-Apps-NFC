//
//  EnterTableViewCell.swift
//  CWA
//
//  Created by NFC Solutions on 03/01/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class EnterTableViewCell: UITableViewCell {
    @IBOutlet var orderId: UILabel!
    @IBOutlet var candidateNameLabel: UILabel!
    @IBOutlet var assignmentLabel: UILabel!
    @IBOutlet var referenceLabel: UILabel!
    @IBOutlet var scheduleLabel: UILabel!
    @IBOutlet var scheduleDays: UILabel!
    @IBOutlet var orderHeight: NSLayoutConstraint!
    @IBOutlet var candidateHeight: NSLayoutConstraint!
    @IBOutlet var assignmentHeight: NSLayoutConstraint!
    @IBOutlet var referenceHeight: NSLayoutConstraint!
    
    
    @IBOutlet var assignementTitle: UILabel!
    @IBOutlet var orderIdTitle: UILabel!
    @IBOutlet var referenceTitle: UILabel!
    @IBOutlet var scheduleTitle: UILabel!
    @IBOutlet var candidateNameTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
