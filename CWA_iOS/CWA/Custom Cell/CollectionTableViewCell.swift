//
//  CollectionTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 24/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var dataColView: UICollectionView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var colViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var dropDownViewView: UIView!
    @IBOutlet weak var dropDownTblView: UITableView!
    @IBOutlet weak var addreportToButton: UIButton!
    @IBOutlet weak var colBgView: UIView!
    @IBOutlet weak var referenceNoteBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
