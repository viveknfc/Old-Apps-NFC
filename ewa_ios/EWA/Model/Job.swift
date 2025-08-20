//
//  Job.swift
//  EWA
//
//  Created by NFC Solutions on 10/01/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class Job: NSObject {

    var title: String?
    var clientName: String?
    var address: String?
    var date : String?
    var color: String?
    var orderId: String?
    var rate: String?
    var detailStatus:String?
    var sort: Int?
    var declineDate:String?
    var scheduleTime:String?
    
    init(title: String?,clientName: String?,address: String?,rate: String?,color:String?,orderId:String?,date:String?,detailStatus:String?,sort:Int?,declineDate:String?,scheduleTime:String){
        self.clientName = clientName
        self.address = address
        self.title = title
        self.color = color
        self.orderId = orderId
        self.rate = rate
        self.date = date
        self.detailStatus = detailStatus
        self.sort = sort
        self.declineDate = declineDate
        self.scheduleTime = scheduleTime
    }
    
    
}
