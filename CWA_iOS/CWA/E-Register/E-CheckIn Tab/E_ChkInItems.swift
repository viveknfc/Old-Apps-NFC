//
//  E_ChkInItems.swift
//  CWA
//
//  Created by NFC User on 06/10/23.
//  Copyright © 2023 NFC Solutionsusa. All rights reserved.
//

import Foundation
import UIKit

class ChkInItems: NSObject {
    
    var Name: String?
    var Position: String?
    var StartTime: String?
    var EndTime: String?
    var OrderId: Int?
    var WeekEnd: String?
    var ISAdminUser: Int?
    var CheckOut: String?
    var BillDate: String?
    var PayforBreak: Bool?
    var RecCode: String?
    var CandId: Int?
    var CheckIn: String?
    var PositionLabelColor: String?
    var BreakMinutes: Int?
    var TimeIn: String?
    var TimeOut: String?
    
    init(Name: String? = nil, Position: String? = nil, StartTime: String? = nil, EndTime: String? = nil, OrderId: Int? = nil, WeekEnd: String? = nil, ISAdminUser: Int? = nil, CheckOut: String? = nil, BillDate: String? = nil, PayforBreak: Bool? = nil, RecCode: String? = nil, CandId: Int? = nil, CheckIn: String? = nil, PositionLabelColor: String? = nil, BreakMinutes: Int? = nil, TimeIn: String? = nil, TimeOut: String? = nil) {
        self.Name = Name
        self.Position = Position
        self.StartTime = StartTime
        self.EndTime = EndTime
        self.OrderId = OrderId
        self.WeekEnd = WeekEnd
        self.ISAdminUser = ISAdminUser
        self.CheckOut = CheckOut
        self.BillDate = BillDate
        self.PayforBreak = PayforBreak
        self.RecCode = RecCode
        self.CandId = CandId
        self.CheckIn = CheckIn
        self.PositionLabelColor = PositionLabelColor
        self.BreakMinutes = BreakMinutes
        self.TimeIn = TimeIn
        self.TimeOut = TimeOut
    }
    
}
