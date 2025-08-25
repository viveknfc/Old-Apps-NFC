//
//  GetApproveTimeSlip.swift
//  CWA
//
//  Created by NFC Solutionsusa on 18/12/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class GetApproveTimeSlip: NSObject {

    var TypeValue: Int?
    var WeekEnding: String?
    var CandId: Int?
    var Name: String?
    var Hours: String?
    var referenceBy: String?
    var approvedBy: String?
    var Approved: Int?
    var TimeId: Int?
    var isApproveSelected: Int?
    var OrderId: Int?
    var BillDate: String?
    var PrevBillDate: String?
    var ShowOT: String?
    init(TypeValue: Int?,WeekEnding: String?,CandId: Int?,Name: String?,Hours: String?,approvedBy: String?,referenceBy: String?,Approved: Int?,TimeId: Int?,OrderId: Int?,BillDate: String?,PrevBillDate: String?,ShowOT: String?){
        
        self.WeekEnding = WeekEnding
        self.TypeValue = TypeValue
        self.CandId = CandId
        self.Name = Name
        self.Hours = Hours
        self.approvedBy = approvedBy
        self.referenceBy = referenceBy
        self.Approved = Approved
        self.TimeId = TimeId
        self.OrderId = OrderId
        self.BillDate = BillDate
        self.PrevBillDate = PrevBillDate
        self.ShowOT = ShowOT
     }
    init(TypeValue: Int?,WeekEnding: String?,CandId: Int?,Name: String?,Hours: String?,approvedBy: String?,referenceBy: String?,Approved: Int?,TimeId: Int?,isApproveSelected: Int?,OrderId: Int?,BillDate: String?,PrevBillDate: String?,ShowOT: String?){
        
        self.WeekEnding = WeekEnding
        self.TypeValue = TypeValue
        self.CandId = CandId
        self.Name = Name
        self.Hours = Hours
        self.approvedBy = approvedBy
        self.referenceBy = referenceBy
        self.Approved = Approved
        self.TimeId = TimeId
        self.isApproveSelected = isApproveSelected
        self.OrderId = OrderId
        self.BillDate = BillDate
        self.PrevBillDate = PrevBillDate
        self.ShowOT = ShowOT

    }
}
