//
//  CAllHeadingCell.swift
//  CWA
//
//  Created by NFC User on 03/10/23.
//  Copyright © 2023 NFC Solutionsusa. All rights reserved.
//

import UIKit

class CAllHeadingCell: UITableViewCell {

    
    @IBOutlet weak var FName: UILabel!
    @IBOutlet weak var PName: UILabel!
    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var TotalHours: UILabel!
    @IBOutlet weak var BMinutesLabel: UILabel!
    @IBOutlet weak var checkInTF: UITextField!
    @IBOutlet weak var checkOutTF: UITextField!
    @IBOutlet weak var ReasonTF: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var reasonView: UIView!
    
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var saveReason: UIButton!
    
    @IBOutlet weak var selectImageIcon: UIImageView!
    @IBOutlet weak var cellInfoColor: UIView!
    
    @IBOutlet weak var checkOutImg: UIImageView!
    
    @IBOutlet weak var ratingStackView: RatingController!
    @IBOutlet weak var ratingCommentsInfo: UIButton!
    
    
    @IBOutlet weak var othersInfo: UIButton!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()

        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        let placeholderText1 = NSAttributedString(string: "Reason for Irregular Hours", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1515013874, green: 0.1768231988, blue: 0.4189088941, alpha: 1)])
        ReasonTF.attributedPlaceholder = placeholderText1
        
        outerView.layer.cornerRadius = 8.0
        outerView.layer.masksToBounds = false
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        outerView.layer.shadowOpacity = 0.3
        outerView.layer.shadowRadius = 3.0
        
        cellInfoColor.layer.cornerRadius = 5
//        cellInfoColor.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        
       // checkInTF.isEnabled = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            selectImageIcon.image = UIImage(named: "check_box_filled")
        } else {
            selectImageIcon.image = UIImage(named: "check_box")
        }
       
    }
    
    

}
