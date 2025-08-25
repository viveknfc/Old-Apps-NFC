//
//  SegmentTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 24/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class SegmentTableViewCell: UITableViewCell {
    @IBOutlet var optionSegmentControl: UISegmentedControl!
    @IBOutlet var betterSegmentControl: BetterSegmentedControl!
    @IBOutlet var segDropDownView: UIView!
    @IBOutlet var segTableView: UITableView!
    @IBOutlet weak var optionSegmentControlHeightConstraint: NSLayoutConstraint!
    @IBOutlet var clickHereLbl: UILabel!
    @IBOutlet var clickHereBtn: UIButton!
    @IBOutlet var lblTimeDiff: UILabel!
     @IBOutlet var timePlaceHolderView: UIView!
    @IBOutlet var includeWeekendBtn: UIButton!
    @IBOutlet weak var SegmentControlViewTopConstraint: NSLayoutConstraint!

    
    @IBOutlet var DayPlaceHolderLbl: UILabel!
    @IBOutlet var StartTimePlaceHolderLbl: UILabel!
    @IBOutlet var EndTimePlaceHolderLbl: UILabel!
    @IBOutlet var MealbreakPlaceHolderLbl: UILabel!
    @IBOutlet var borderView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
