//
//  HosGroupTS.swift
//  CWA
//
//  Created by NFC Solutionsusa on 20/07/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class HosGroupTS: NSObject {
    
    var CandidateName: String?
    var WeekEnd: String?
    var isSelected: String?
    var PONumber: String?
    var StartTime: String?
    var EndTime: String?
    var StartTimeDB: String?
    var EndTimeDB: String?
    var TimeId: Double?
    var DetailId: Double?
    var AssignmentComplete: Double?
    var BreakValue: String?
    var OriginalBreakValue: String?
    var TotalHours: Double?
    var Position: String?
    var StartDate: String?
    var PayForBreak: Bool?
    var BackGroundColorCode: String?
    var EvalDB: Double?
    var Eval: Double?
    var RecCode: String?
    var TaxiVisible: Bool?
    var EvalDesc: String?
    var IsApproveEnabled: Bool?
    var Taxi: String?
    var willShow: String?
    var CandidateId: Double?
    //Weekly Object
    var SaturdayHours: Double?
    var TuesdayHours: Double?
    var ThursdayHours: Double?
    var FridayHours: Double?
    var MondayHours: Double?
    var SundayHours: Double?
    var WednesdayHours: Double?
    var OrderId: Double?
    var RegHours: Double?
    var OTHours: Double?
    var TotalBreak: Double?
    var EvalVisible: Bool?
    var StartTimeTxtFieldTag: String?
    var EndTimeTxtFieldTag: String?
    var Approver: Double?
    var IsApproved: Bool?
    var TaxiOk: Bool?
    var ContactIsApproverYesNo: Bool?
    var DBTotalBreak: Double?
    var DBTotalHours: Double?
    var Comments: String?
    var OriginalComments: String?
    var selectedPosTypeName: String?
    var selectedPosTypeID: Int?
    var ShowSave : Bool?
    var IsEvalDone : Bool?
    var TipAmount:Double?
   
    
    init( CandidateName: String?, WeekEnd: String?, PONumber: String?, StartTime: String?, EndTime: String?, BreakValue: String?, TotalHours: Double?, Position: String?, StartDate: String?,PayForBreak: Bool?, isSelected: String?,BackGroundColorCode: String?,EvalDB: Double?,TaxiVisible: Bool?,EvalDesc: String?,IsApproveEnabled: Bool?,Taxi: String?,EvalVisible: Bool?,CandidateId: Double?,OrderId: Double?,StartTimeTxtFieldTag: String?,EndTimeTxtFieldTag: String?, willShow: String?,Eval: Double?,StartTimeDB: String?,EndTimeDB: String?,RecCode: String?,Approver: Double?,IsApproved: Bool?,TaxiOk: Bool?, TimeId: Double?,DetailId: Double?,AssignmentComplete: Double?,Comments: String?,OriginalBreakValue: String?,OriginalComments: String?,ShowSave:Bool?,IsEvalDone : Bool?,TipAmount:Double?){
        
        self.Approver = Approver
        self.OriginalBreakValue = OriginalBreakValue
        self.RecCode = RecCode
        self.AssignmentComplete = AssignmentComplete
        self.TaxiOk = TaxiOk
        self.TimeId = TimeId
        self.DetailId = DetailId
        self.IsApproved = IsApproved
        self.StartTimeDB = StartTimeDB
        self.EndTimeDB = EndTimeDB
        self.Eval = Eval
        self.CandidateName = CandidateName
        self.WeekEnd = WeekEnd
        self.PONumber = PONumber
        self.StartTime = StartTime
        self.EndTime = EndTime
        self.BreakValue = BreakValue
        self.TotalHours = TotalHours
        self.Position = Position
        self.StartDate = StartDate
        self.PayForBreak = PayForBreak
        self.isSelected = isSelected
        self.BackGroundColorCode = BackGroundColorCode
        self.EvalDB = EvalDB
        self.TaxiVisible = TaxiVisible
        self.EvalDesc = EvalDesc
        self.IsApproveEnabled = IsApproveEnabled
        self.Taxi = Taxi
        self.willShow = willShow
        self.EvalVisible = EvalVisible
        self.CandidateId = CandidateId
        self.OrderId = OrderId
        self.StartTimeTxtFieldTag = StartTimeTxtFieldTag
        self.EndTimeTxtFieldTag = EndTimeTxtFieldTag
        self.Comments = Comments
        self.OriginalComments = OriginalComments
        self.ShowSave = ShowSave
        self.IsEvalDone = IsEvalDone
        self.TipAmount = TipAmount
        
    }
    init( CandidateName: String?, WeekEnd: String?, PONumber: String?, StartTime: String?, EndTime: String?, BreakValue: String?, TotalHours: Double?, Position: String?, StartDate: String?,PayForBreak: Bool?, isSelected: String?,BackGroundColorCode: String?,EvalDB: Double?,TaxiVisible: Bool?,EvalDesc: String?,IsApproveEnabled: Bool?,Taxi: String?,EvalVisible: Bool?,CandidateId: Double?,OrderId: Double?,StartTimeTxtFieldTag: String?,EndTimeTxtFieldTag: String?, willShow: String?,Eval: Double?,StartTimeDB: String?,EndTimeDB: String?,RecCode: String?,Approver: Double?,IsApproved: Bool?,TaxiOk: Bool?, TimeId: Double?,DetailId: Double?,AssignmentComplete: Double?,Comments: String?,OriginalBreakValue: String?,OriginalComments: String?,selectedPosTypeName: String?,selectedPosTypeID: Int?,IsEvalDone : Bool?){
        
        self.selectedPosTypeName = selectedPosTypeName
        self.selectedPosTypeID = selectedPosTypeID
        self.Approver = Approver
        self.OriginalBreakValue = OriginalBreakValue
        self.RecCode = RecCode
        self.AssignmentComplete = AssignmentComplete
        self.TaxiOk = TaxiOk
        self.TimeId = TimeId
        self.DetailId = DetailId
        self.IsApproved = IsApproved
        self.StartTimeDB = StartTimeDB
        self.EndTimeDB = EndTimeDB
        self.Eval = Eval
        self.CandidateName = CandidateName
        self.WeekEnd = WeekEnd
        self.PONumber = PONumber
        self.StartTime = StartTime
        self.EndTime = EndTime
        self.BreakValue = BreakValue
        self.TotalHours = TotalHours
        self.Position = Position
        self.StartDate = StartDate
        self.PayForBreak = PayForBreak
        self.isSelected = isSelected
        self.BackGroundColorCode = BackGroundColorCode
        self.EvalDB = EvalDB
        self.TaxiVisible = TaxiVisible
        self.EvalDesc = EvalDesc
        self.IsApproveEnabled = IsApproveEnabled
        self.Taxi = Taxi
        self.willShow = willShow
        self.EvalVisible = EvalVisible
        self.CandidateId = CandidateId
        self.OrderId = OrderId
        self.StartTimeTxtFieldTag = StartTimeTxtFieldTag
        self.EndTimeTxtFieldTag = EndTimeTxtFieldTag
        self.Comments = Comments
        self.OriginalComments = OriginalComments
        self.IsEvalDone = IsEvalDone
    }
    init( CandidateName: String?, WeekEnd: String?, PONumber: String?, BreakValue: String?, TotalHours: Double?, Position: String?,PayForBreak: Bool?, isSelected: String?,BackGroundColorCode: String?,EvalDB: Double?,TaxiVisible: Bool?,EvalDesc: String?,IsApproveEnabled: Bool?,Taxi: String?, SaturdayHours: Double?,TuesdayHours: Double?,ThursdayHours: Double?,FridayHours: Double?,MondayHours: Double?,SundayHours: Double?,WednesdayHours: Double?,OrderId: Double?,RegHours: Double?,OTHours: Double?,TotalBreak: Double?,EvalVisible: Bool?,CandidateId: Double?,willShow:String?,Eval: Double?,DBTotalBreak: Double?,IsApproved: Bool?,DBTotalHours: Double?,Approver: Double?,TimeId: Double?,RecCode: String?,TaxiOk: Bool?,Comments: String?,OriginalComments: String?,ShowSave:Bool?,IsEvalDone : Bool?){
        self.ShowSave = ShowSave
        self.CandidateName = CandidateName
        self.WeekEnd = WeekEnd
        self.Eval = Eval
        self.DBTotalBreak = DBTotalBreak
        self.PONumber = PONumber
        self.BreakValue = BreakValue
        self.TotalHours = TotalHours
        self.Position = Position
        self.PayForBreak = PayForBreak
        self.isSelected = isSelected
        self.BackGroundColorCode = BackGroundColorCode
        self.EvalDB = EvalDB
        self.TaxiVisible = TaxiVisible
        self.EvalDesc = EvalDesc
        self.IsApproveEnabled = IsApproveEnabled
        self.Taxi = Taxi
        self.willShow = willShow
        self.SaturdayHours = SaturdayHours
        self.TuesdayHours = TuesdayHours
        self.ThursdayHours = ThursdayHours
        self.FridayHours = FridayHours
        self.MondayHours = MondayHours
        self.SundayHours = SundayHours
        self.WednesdayHours = WednesdayHours
        self.OrderId  = OrderId
        self.RegHours = RegHours
        self.OTHours = OTHours
        self.TotalBreak = TotalBreak
        self.EvalVisible = EvalVisible
        self.CandidateId = CandidateId
        
        self.Approver = Approver
        self.TimeId = TimeId
        self.DBTotalHours = DBTotalHours
        self.RecCode = RecCode
        self.DBTotalBreak  = DBTotalBreak
        self.TaxiOk = TaxiOk
        self.IsApproved = IsApproved
        self.Comments = Comments
        self.OriginalComments = OriginalComments
        self.IsEvalDone = IsEvalDone
        
        
    }
    /*
     ["Approver":empObj.Approver,
     "OrderId":empObj.OrderId,
     "CandidateId":empObj.CandidateId,
     "TimeId":empObj.TimeId,
     "MondayHours":empObj.MondayHours,
     "TuesdayHours":empObj.TuesdayHours,
     "WednesdayHours":empObj.WednesdayHours,
     "ThursdayHours":empObj.ThursdayHours,
     "FridayHours":empObj.FridayHours,
     "SaturdayHours":empObj.SaturdayHours,
     "SundayHours":empObj.SundayHours,
     "RegHours":empObj.RegHours,
     "OTHours":empObj.OTHours,
     "TotalHours":empObj.TotalHours,
     "DBTotalHours":empObj.DBTotalHours,
     "RecCode":empObj.RecCode,
     "Eval":empObj.Eval,
     "TotalBreak":empObj.TotalBreak,
     "DBTotalBreak":empObj.DBTotalBreak,
     "PayForBreak":empObj.PayForBreak,
     "TaxiOk":empObj.TaxiOk,
     "Taxi":empObj.Taxi,
     "EvalVisible":empObj.EvalVisible,
     "EvalDesc":empObj.EvalDesc,
     "EvalDB":empObj.EvalDB,
     "IsApproved":empObj.IsApproved,
     "TaxiVisible":empObj.TaxiVisible
     */
}
