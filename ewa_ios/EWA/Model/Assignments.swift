//
//  Assignments.swift
//  EWA
//
//  Created by NFC Solutions on 10/01/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class Assignments: NSObject {
    
    
    var companyName: String?
    var address: String?
    var time : String?
    var color: String?
    var orderId: String?
    var division: String?
    
    init(companyName: String?,address: String?,time: String?,color:String?,orderId:String?,division:String?){
        self.companyName = companyName
        self.address = address
        self.time = time
        self.color = color
        self.orderId = orderId
        self.division = division
    }
}
