//
//  TextViewTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 24/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class TextViewTableViewCell: UITableViewCell {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var entryTextView: KMPlaceholderTextView!
    @IBOutlet weak var lblSubHeader: UILabel!
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var lblHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblSubHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTextCount: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      //  entryTextView.pl
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
