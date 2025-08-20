//
//  ReferalBonus.swift
//  EWA
//
//  Created by NFC India on 13/08/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class ReferalBonus: NSObject {
    
    var position:String?
    var requiredHours:String?
    var commission:Int?
    var applicationReceivedDate:String?
    var currentHours:String?
    init(position:String?,requiredHours:String?,commission:Int?,applicationReceivedDate:String?,currentHours:String?)  {
        
        self.position = position
        self.requiredHours = requiredHours
        self.commission = commission
        self.applicationReceivedDate = applicationReceivedDate
        self.currentHours = currentHours
        
    }
}
