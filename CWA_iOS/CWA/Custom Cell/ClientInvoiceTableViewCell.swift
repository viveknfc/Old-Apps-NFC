//
//  ClientInvoiceTableViewCell.swift
//  CWA
//
//  Created by NFC Solutionsusa on 09/08/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class ClientInvoiceTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblInvoiceType: UILabel!
    @IBOutlet weak var lblBillDate: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblPaid: UILabel!

    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var btnInvoiceNum: UIButton!
    @IBOutlet weak var btnViewTS: UIButton!
    
    @IBOutlet weak var btnInvoiceName: UIButton!
    @IBOutlet weak var bgView: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
