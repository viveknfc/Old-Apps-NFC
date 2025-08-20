//
//  HistoryTableViewCell.swift
//  EWA
//
//  Created by NFC India on 26/12/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var noteButtonRight: NSLayoutConstraint! //110 - 9
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var loginStart: UILabel!
    @IBOutlet weak var lunchReturnLabel: UILabel!
    @IBOutlet weak var luncOutLabl: UILabel!
    @IBOutlet weak var logoutFinishLabel: UILabel!
    @IBOutlet weak var notesButton: UIButton!
    @IBOutlet weak var editButton: UIButton!

    @IBOutlet weak var loginNameLabel: UILabel!
    @IBOutlet weak var lunchOutNameLabel: UILabel!
    @IBOutlet weak var lunchInNameLabel: UILabel!
    @IBOutlet weak var logoutNameLabel: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    
    @IBOutlet weak var lunchOutLabel2: UILabel!
    @IBOutlet weak var lunchReturnNameLabel2: UILabel!
    @IBOutlet weak var lunchOutNameLabel2: UILabel!
    @IBOutlet weak var errorLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lunchReturnLabel2: UILabel!
    @IBOutlet weak var shadowView: ShadowView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        shadowView.layer.borderColor = UIColor.lightGray.cgColor
        shadowView.layer.borderWidth = 0.4
        
    }

}
