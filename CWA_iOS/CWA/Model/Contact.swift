//
//  Contact.swift
//  CWA
//
//  Created by NFC Solutionsusa on 01/03/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class Contact: NSObject {
    var Text: String?
    var Value: String?
    var isSelected: String?
    
    init(Value: String?,Text: String?,isSelected: String? ){
        self.Value = Value
        self.Text = Text
        self.isSelected = isSelected
    }
}
