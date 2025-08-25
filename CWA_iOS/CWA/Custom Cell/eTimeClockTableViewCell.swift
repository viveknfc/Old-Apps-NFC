//
//  eTimeClockTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 31/10/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class eTimeClockTableViewCell: UITableViewCell {
    //Details Cell 
    @IBOutlet weak var lblEmpName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblBreak: UILabel!
    @IBOutlet weak var lblHours: UILabel!

    @IBOutlet weak var SendBtn: UIButton!
    @IBOutlet weak var ApproveBtn: UIButton!
    @IBOutlet weak var EditBtn: UIButton!
    @IBOutlet weak var NoteBtn: UIButton!
    @IBOutlet weak var DateBtn: UIButton!
    @IBOutlet weak var generateInvoiceBtn: UIButton!

    @IBOutlet weak var tipView: TooltipView!

    //Summary Cell
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblWeekHours: UILabel!

    @IBOutlet weak var cellBGView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
