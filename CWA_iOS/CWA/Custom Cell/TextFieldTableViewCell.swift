//
//  TextFieldTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 24/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var entryTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var btnBGView: UIView!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var lblDollar: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var lblNote: UILabel!

    @IBOutlet weak var lessonTextView: UITextView!
    @IBOutlet weak var dStpper: UIStepper!
    @IBOutlet weak var noMatterBtn: UIButton!

    @IBOutlet weak var txtFieldTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblHeaderTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bgViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var addNewBtnTrailingConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
