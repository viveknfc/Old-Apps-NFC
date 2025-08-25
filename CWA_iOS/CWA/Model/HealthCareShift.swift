//
//  HealthCareShift.swift
//  CWA
//
//  Created by NFC Solutionsusa on 09/03/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class HealthCareShift: NSObject {
     var EndTime: String?
    var Name: String?
    var startTime: String?
    var isSelected: String?
    
    init(EndTime: String?,Name: String?,startTime: String?,isSelected: String? ){
        self.EndTime = EndTime
        self.Name = Name
        self.startTime = startTime
        self.isSelected = isSelected
    }
}
