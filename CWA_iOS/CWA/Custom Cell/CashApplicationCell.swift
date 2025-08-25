//
//  CashApplicationCell.swift
//  CWA
//
//  Created by NFC User on 6/17/20.
//  Copyright © 2020 NFC Solutionsusa. All rights reserved.
//

import UIKit

class CashApplicationCell: UITableViewCell {

    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var cellBackView: UIView!
    
    @IBOutlet weak var inVoiceButton: UIButton!
    
    
    @IBOutlet weak var invoiceTotalLabel: UILabel!
    @IBOutlet weak var commentsTF: UITextView!
    @IBOutlet weak var achNumberTF: UITextField!
    @IBOutlet weak var balanceTF: UITextField!
    @IBOutlet weak var viewTimeSlips: UIButton!
    @IBOutlet weak var discountLabel: UILabel!
    
    @IBOutlet weak var billDateLabel: UILabel!
    
    @IBOutlet weak var lateFeeLabel: UILabel!
    @IBOutlet weak var lateFeeCheckBox: UIButton!
    
    @IBOutlet weak var titleInvoiceLabel: UILabel!
    @IBOutlet weak var titleBillDateLabel: UILabel!
    @IBOutlet weak var titleDiscountLabel: UILabel!
    @IBOutlet weak var titleInvoiceTotalLabel: UILabel!
    @IBOutlet weak var titleLateFeeLabel: UILabel!
    @IBOutlet weak var titleBalanceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellBackView.dropShadowToIT()
        commentsTF.dropCornerRadius(UIColor.lightGray)
         let divColorCode = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        titleInvoiceLabel.textColor = divColorCode
        titleBillDateLabel.textColor = divColorCode
        titleDiscountLabel.textColor = divColorCode
        titleInvoiceTotalLabel.textColor = divColorCode
        titleLateFeeLabel.textColor = divColorCode
        titleBalanceLabel.textColor = divColorCode
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension UIView {
func dropShadowToIT() {
    layer.cornerRadius = 4
    layer.borderColor = UIColor.lightGray.cgColor
    layer.borderWidth = 1
    layer.shadowColor = UIColor.darkGray.cgColor
    layer.shadowOffset = CGSize(width: 2, height: 2)
    layer.masksToBounds = false
    layer.shadowOpacity = 0.3
    layer.shadowRadius = 3
    layer.rasterizationScale = UIScreen.main.scale
    layer.shouldRasterize = true
}
    func dropCornerRadius(_ color: UIColor) {
        layer.cornerRadius = 4
        layer.borderColor = color.cgColor
        layer.borderWidth = 1
//        layer.shadowColor = UIColor.darkGray.cgColor
//        layer.shadowOffset = CGSize(width: 2, height: 2)
//        layer.masksToBounds = false
//        layer.shadowOpacity = 0.3
//        layer.shadowRadius = 3
//        layer.rasterizationScale = UIScreen.main.scale
//        layer.shouldRasterize = true
    }
}
