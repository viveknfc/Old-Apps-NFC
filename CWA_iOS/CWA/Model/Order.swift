//
//  Order.swift
//  CWA
//
//  Created by NFC Solutionsusa on 09/08/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class Order: NSObject {
//    "OrderId": 955283,
//    "Department": "",
//    "PoNumber": "",
//    "StartDate": "08/06/2018",
//    "EndDate": "08/08/2018",
//    "StartTime": "2:00PM",
//    "EndTime": "9:00PM",
//    "Position": "HasDog",
//    "ReportTo": "Justin Campbell",
//    "TotalNumberTemps": "1 of 1",
//    "Cancelled": 0,
//    "IsEditOrder": 0
    var OrderId: String?
    var Department: String?
    var PoNumber: String?
    var StartDate: String?
    var EndDate: String?
    var StartTime: String?
    var EndTime: String?
    var Position: String?
    var ReportTo: String?
    var TotalNumberTemps: String?
    var Cancelled: Int?
    var IsEditOrder: Int?
    var IsTrackLink: Int?
    var IsCopyOrder: Int?
    var CopyOrderType: String?
    var EditOrderType: String?
    
    
    init( OrderId: String?, Department: String?, PoNumber: String?, StartDate: String?, EndDate: String?, StartTime: String?, EndTime: String?, Position: String?, ReportTo: String?,TotalNumberTemps: String?, Cancelled: Int?,IsEditOrder: Int?,IsTrackLink: Int?, IsCopyOrder: Int?, CopyOrderType: String?, EditOrderType: String?){
        
        self.OrderId = OrderId
        self.Department = Department
        self.PoNumber = PoNumber
        self.StartDate = StartDate
        self.EndDate = EndDate
        self.StartTime = StartTime
        self.EndTime = EndTime
        self.ReportTo = ReportTo
        self.Position = Position
        self.TotalNumberTemps = TotalNumberTemps
        self.Cancelled = Cancelled
        self.IsEditOrder = IsEditOrder
        self.IsTrackLink = IsTrackLink
        self.IsCopyOrder = IsCopyOrder
        self.CopyOrderType = CopyOrderType
        self.EditOrderType = EditOrderType
 
    }


}
