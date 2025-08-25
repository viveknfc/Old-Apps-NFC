//
//  SearchTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 04/12/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit
import FloatRatingView

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var lblNameValue: UILabel!
    @IBOutlet weak var lblNamePlaceholder: UILabel!
    @IBOutlet weak var lblDateValue: UILabel!
    @IBOutlet weak var lblDatePlaceholder: UILabel!
    @IBOutlet weak var lblSubjectValue: UILabel!
    @IBOutlet weak var lblSubjectPlaceholder: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var lblEval: UILabel!
    @IBOutlet weak var lblEvalPlaceHolder: UILabel!
    @IBOutlet weak var lblYTDHRPlaceholder: UILabel!
    @IBOutlet weak var lblYTDHRValue: UILabel!
    @IBOutlet weak var lblPositionPlaceholder: UILabel!
    @IBOutlet weak var lblPositionvalue: UILabel!
    @IBOutlet weak var searchHistoryButton: UIButton!

    @IBOutlet weak var floatRatingView: FloatRatingView!

    @IBOutlet weak var userImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
