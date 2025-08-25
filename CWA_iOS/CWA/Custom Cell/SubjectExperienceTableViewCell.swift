//
//  SubjectExperienceTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 06/12/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class SubjectExperienceTableViewCell: UITableViewCell {
    @IBOutlet weak var subjectBtn: UIButton!
    @IBOutlet weak var expReqdBtn: UIButton!
    @IBOutlet weak var lblHeader: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
