//
//  LogisticsGroupTSTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 20/08/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class LogisticsGroupTSTableViewCell: HospitalityGroupTSTableViewCell {
    
    @IBOutlet weak var TypeTxtField: UITextField!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var removeDataBtn: UIButton!
    @IBOutlet weak var BtnViewTopToTaxiFareConstraint: NSLayoutConstraint!
    @IBOutlet weak var BtnView: UIView!
    @IBOutlet weak var typeBgView: UIView!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
