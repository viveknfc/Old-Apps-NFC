//
//  HouseHoldMember.swift
//  EWA
//
//  Created by NFC User on 8/12/21.
//  Copyright © 2021 NFC. All rights reserved.
//

import Foundation
class HouseHoldMember: NSObject {
    
    
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
