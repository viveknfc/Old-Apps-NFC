//
//  EnterTimeSlip.swift
//  CWA
//
//  Created by NFC Solutions on 03/01/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class EnterTimeSlip: NSObject {
    var OrderId: Int?
    var CandidateName: String?
    var Assignment: String?
    var Reference: String?
    var Schedule: [String]
   
    init(OrderId: Int?,CandidateName: String?,Assignment: String?,Reference: String?,Schedule: [String]){
        self.OrderId = OrderId
        self.CandidateName = CandidateName
        self.Assignment = Assignment
        self.Reference = Reference
        self.Schedule = Schedule
    }
    
}
