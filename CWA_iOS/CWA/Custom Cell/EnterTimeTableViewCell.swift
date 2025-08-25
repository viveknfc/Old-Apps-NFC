//
//  EnterTimeTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 27/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class EnterTimeTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var startTimeTxtField: UITextField!
    @IBOutlet weak var endTimeTxtField: UITextField!
    @IBOutlet weak var mealBreakTimeTxtField: UITextField!
    
    @IBOutlet weak var startTimeView: UIView!
    @IBOutlet weak var endTimeView: UIView!
    @IBOutlet weak var mealBreakTimeView: UIView!
    @IBOutlet weak var dayView: UIView!

    @IBOutlet weak var clearStartTimeBtn: UIButton!
    @IBOutlet weak var clearEndTimeBtn: UIButton!
    @IBOutlet weak var clearMealBreakTimeBtn: UIButton!
    @IBOutlet weak var selectDayBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
