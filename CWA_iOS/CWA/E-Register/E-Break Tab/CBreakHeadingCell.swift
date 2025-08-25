//
//  CBreakHeadingCell.swift
//  CWA
//
//  Created by NFC User on 01/10/23.
//  Copyright © 2023 NFC Solutionsusa. All rights reserved.
//

import UIKit

class CBreakHeadingCell: UITableViewCell {
    
    @IBOutlet weak var FName: UILabel!
    @IBOutlet weak var PName: UILabel!
    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var BreakIn: UITextField!
    @IBOutlet weak var BreakOut: UITextField!
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var BreakMin: UITextField!
    @IBOutlet weak var dropDownImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let placeholderText1 = NSAttributedString(string: "Out Time", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1515013874, green: 0.1768231988, blue: 0.4189088941, alpha: 1)])
        BreakIn.attributedPlaceholder = placeholderText1
        
        let placeholderText2 = NSAttributedString(string: "In Time", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1515013874, green: 0.1768231988, blue: 0.4189088941, alpha: 1)])
        BreakOut.attributedPlaceholder = placeholderText2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
