//
//  EnterTimeSlipDetailTableViewCell.swift
//  EWA
//
//  Created by NFC Solutions on 14/11/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit

class EnterTimeSlipDetailTableViewCell: UITableViewCell {

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var startTimeTextField: UITextField!
    @IBOutlet var endTimeTextField: UITextField!
    @IBOutlet var totalHoursLabel: UILabel!
    @IBOutlet var lunchTimeTextField: UITextField!
    @IBOutlet var taxFareTextField: UITextField!

    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var deleteConstarin: NSLayoutConstraint!
    @IBOutlet var amountHeight: NSLayoutConstraint!
    @IBOutlet var expenseheight: NSLayoutConstraint!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
