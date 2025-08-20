//
//  EnterTimeSlip.swift
//  EWA
//
//  Created by NFC Solutions on 10/01/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class EnterTimeSlip: NSObject {

    var orderId: String?
    var clientName: String?
    var position : String?
    var reference: String?
    var schedule: [String]
    var division: String?
    
    init(orderId: String?,clientName: String?,position: String?,reference: String?,schedule:[String],division:String?){
        self.orderId = orderId
        self.clientName = clientName
        self.position = position
        self.reference = reference
        self.schedule = schedule
        self.division = division
        
    }
}
