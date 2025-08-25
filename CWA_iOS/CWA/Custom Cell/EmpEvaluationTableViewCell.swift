//
//  EmpEvaluationTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 27/07/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import FloatRatingView

class EmpEvaluationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var lblPositionTitle: UILabel!
    @IBOutlet weak var lblYTDHrTitle: UILabel!
    @IBOutlet weak var lblWeeklyTotalTitle: UILabel!
    @IBOutlet weak var lblLastDateWorkedTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPositionValue: UILabel!
    @IBOutlet weak var lblYTDHrValue: UILabel!
    @IBOutlet weak var lblWeeklyTotalValue: UILabel!
    @IBOutlet weak var lblLastDateWorkedValue: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userImageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var borderView: UIView!


    @IBOutlet weak var btnShowHistory: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var favIcon: UIImageView!
    


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
