//
//  HealthCareShiftTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 06/03/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class HealthCareShiftTableViewCell: UITableViewCell {
    
    @IBOutlet var centerView: UIView!

    @IBOutlet var headerView: UIView!
    
    @IBOutlet var daySelectionBtn: UIButton!
    
    @IBOutlet var addShiftBtn: UIButton!
    
    @IBOutlet var clearBtn: UIButton!
    
    @IBOutlet var searchEmpBtn: UIButton!
    
    @IBOutlet var reqstedEmpBtn: UIButton!
    
    @IBOutlet weak var reqstedEmpBtnLeftConstraint: NSLayoutConstraint!

    @IBOutlet var removeBtn: UIButton!
    
    @IBOutlet var profileView: UIView!
    
    @IBOutlet var daySelectionView: UIView!

    @IBOutlet var shiftView: UIView!
    
    @IBOutlet var profileTxtField: UITextField!
    
    @IBOutlet var shiftTxtField: UITextField!
    
    @IBOutlet var startView: UIView!
    
    @IBOutlet var endView: UIView!
    
    @IBOutlet var  startTextField: UITextField!
    
    @IBOutlet var endTextField: UITextField!
    
    @IBOutlet var  empNumTextField: UITextField!
    @IBOutlet var  lblDay: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
