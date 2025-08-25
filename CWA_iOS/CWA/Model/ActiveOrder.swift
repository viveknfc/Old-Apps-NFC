//
//  ActiveOrder.swift
//  CWA
//
//  Created by NFC Solutionsusa on 23/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class ActiveOrder: NSObject {
    var EstimatedBilling: String?
    var StartDate: String?
    var EndDate: String?
    var EmployeeName : String?
    var Position : String?
    
    init(EstimatedBilling: String?,StartDate: String?,EndDate: String?,EmployeeName: String?,Position: String?){
        
        self.EstimatedBilling = EstimatedBilling
        self.StartDate = StartDate
        self.EndDate = EndDate
        self.EmployeeName = EmployeeName
        self.Position = Position
    }
}
