//
//  TimeSlip.swift
//  EWA
//
//  Created by NFC Solutions on 10/01/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class TimeSlip: NSObject {

    var clientName: String?
    var date : String?
    var time: String?
    var timeId: String?
    var apistatus: String?
    
    init(clientName: String?,date: String?,time: String?,timeId:String?,apistatus:String?){
        self.clientName = clientName
        self.date = date
        self.time = time
        self.timeId = timeId
        self.apistatus = apistatus
       
    }
    
}
