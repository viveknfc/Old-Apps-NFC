//
//  EmpHistoryTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 04/12/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit
import FloatRatingView

class EmpHistoryTableViewCell: UITableViewCell {
  
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSubjects: UILabel!
    @IBOutlet weak var lblSubjectTitle: UILabel!
    @IBOutlet weak var lblDateTitle: UILabel!
    @IBOutlet weak var lblColon1: UILabel!
    @IBOutlet weak var lblEval: UILabel!
    @IBOutlet weak var floatRatingView: FloatRatingView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
