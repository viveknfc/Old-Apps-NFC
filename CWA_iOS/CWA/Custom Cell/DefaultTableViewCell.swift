//
//  DefaultTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 28/12/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class DefaultTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDataText: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblSubDataText: UILabel!
  
    required init(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)!
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
