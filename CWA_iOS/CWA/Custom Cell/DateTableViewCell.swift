//
//  DateTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 24/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class DateTableViewCell: UITableViewCell {
    @IBOutlet weak var lblStart: UILabel!
    @IBOutlet weak var lblEnd: UILabel!
    @IBOutlet weak var lblMealBreak: UILabel!

    @IBOutlet weak var textFStart: UITextField!
    @IBOutlet weak var textFEnd: UITextField!
    @IBOutlet weak var textFMealBreak: UITextField!

    @IBOutlet weak var startTimeView: UIView!
    @IBOutlet weak var endTimeView: UIView!
    @IBOutlet weak var clearStartTimeBtn: UIButton!
    @IBOutlet weak var clearEndTimeBtn: UIButton!
    @IBOutlet weak var mealBreakTimeView: UIView!


    @IBOutlet weak var EndDateImageView: UIImageView!
    @IBOutlet weak var StartDateImageView: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
