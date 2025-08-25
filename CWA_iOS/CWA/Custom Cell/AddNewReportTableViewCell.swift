//
//  AddNewReportTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 05/12/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class AddNewReportTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var dataTextField: UITextField!
    @IBOutlet weak var TextFieldBGView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
