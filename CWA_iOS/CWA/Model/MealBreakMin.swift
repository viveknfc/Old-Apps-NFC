//
//  MealBreakMin.swift
//  CWA
//
//  Created by NFC Solutionsusa on 06/02/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class MealBreakMin: NSObject {
     var Text: String?
    var Value: String?
    var isSelected: String?

    init(Text: String?, Value: String?,isSelected: String?){
        
        self.Text = Text
        self.Value = Value
        self.isSelected = isSelected
    }
}
