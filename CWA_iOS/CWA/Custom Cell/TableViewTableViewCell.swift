//
//  TableViewTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 24/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class TableViewTableViewCell: UITableViewCell {
    @IBOutlet weak var dataCellTblView: UITableView!
    @IBOutlet weak var clearAllBtn: UIButton!
    @IBOutlet weak var clearEntryBtn: UIButton!
    @IBOutlet weak var moveUPBtn: UIButton!
    @IBOutlet weak var moveDownBtn: UIButton!
    @IBOutlet weak var TblBGView: UIView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
