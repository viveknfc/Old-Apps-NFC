//
//  TrackEmpLocCell.swift
//  CWA
//
//  Created by NFC User on 1/28/19.
//  Copyright © 2019 NFC Solutionsusa. All rights reserved.
//

import UIKit

class TrackEmpLocCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblNum: UILabel!

    @IBOutlet weak var publicLabel: UILabel!
    @IBOutlet weak var walklabel: UILabel!
    @IBOutlet weak var vehicleLabel: UILabel!
    
    @IBOutlet weak var busImageView: UIImageView!
    
    @IBOutlet weak var carImageView: UIImageView!
    
    @IBOutlet weak var walkImageView: UIImageView!
    
    @IBOutlet weak var getDirectionsButton: UIButton!
    
    let yourAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13),
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let attributeString = NSMutableAttributedString(string: "Get Directions",
                                                          attributes: yourAttributes)
          getDirectionsButton.setAttributedTitle(attributeString, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
