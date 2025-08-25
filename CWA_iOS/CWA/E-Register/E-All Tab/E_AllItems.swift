//
//  E_AllItems.swift
//  CWA
//
//  Created by NFC User on 11/10/23.
//  Copyright © 2023 NFC Solutionsusa. All rights reserved.
//

import Foundation
import UIKit

class AllItems: NSObject {
    
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
    var breakMinutes: Int?
    var Id: Int?
    var Status: Int?
    var TxnType: Int?
    var IsSubmitted: Int?
    var ReasonId: Int?
    
    var Rating: Int?
    var RatingComments: String?
    var PositionLabelColor: String?
    var OtherReason: String?
    
    init(Name: String? = nil, Position: String? = nil, StartTime: String? = nil, EndTime: String? = nil, OrderId: Int? = nil, WeekEnd: String? = nil, ISAdminUser: Int? = nil, CheckOut: String? = nil, BillDate: String? = nil, PayforBreak: Bool? = nil, RecCode: String? = nil, CandId: Int? = nil, CheckIn: String? = nil, breakMinutes: Int? = nil, Id: Int? = nil, Status: Int? = nil, TxnType: Int? = nil, IsSubmitted: Int? = nil, ReasonId: Int? = nil, Rating: Int? = nil, RatingComments: String? = nil, PositionLabelColor: String? = nil, OtherReason: String? = nil) {
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
        self.breakMinutes = breakMinutes
        self.Id = Id
        self.Status = Status
        self.TxnType = TxnType
        self.IsSubmitted = IsSubmitted
        self.ReasonId = ReasonId
        self.Rating = Rating
        self.RatingComments = RatingComments
        self.PositionLabelColor = PositionLabelColor
        self.OtherReason = OtherReason
    }
 
}
