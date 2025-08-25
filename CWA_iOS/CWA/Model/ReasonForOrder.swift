//
//  ReasonForOrder.swift
//  CWA
//
//  Created by NFC Solutionsusa on 27/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class ReasonForOrder: NSObject {
    var ReasonId: Int?
    var ReasonDescription: String?
 var isSelected: String?
    init(ReasonId: Int?,ReasonDescription: String?,isSelected: String? ){
         self.ReasonId = ReasonId
        self.ReasonDescription = ReasonDescription
        self.isSelected = isSelected
    }
}
