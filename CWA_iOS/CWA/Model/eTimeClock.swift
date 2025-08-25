//
//  eTimeClock.swift
//  CWA
//
//  Created by NFC Solutionsusa on 06/11/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class eTimeClock: NSObject {
    
    var Color: String?
    var TimeId: String?
    var Name: String?
    var Comments: String?
    var Edit: Double?
    var Date: String?
     var break_minutes: String?
    var TotalHours: String?
    var LunchInTime: String?
    var LunchOutTime: String?
    var LogInTime: String?
    var LogOutTime: String?
    var NewId: Double?
     var Sent: Double?
     var changeFound: Double?
    
    var Weekend : String?
    var Days : String?
    var isSend: Double?
    var Weekhours: String?
    var isSelected: String?
    
    var LunchInDate: String?
    var LunchOutDate: String?
    var LogInDate: String?
    var LogOutDate: String?
    var CandId:  String?
var OrderId:  String?
    var ClientId:  String?
    var ContactId:  String?
    var RowColor: String?
    var isShowNote: String?


    init( TimeId: String?, Name: String?, Comments: String?, Edit: Double?, Date: String?,TotalHours: String?,LunchInTime: String?, LunchOutTime: String?,LogInTime: String?,LogOutTime: String?,break_minutes: String?,NewId: Double?,Sent: Double?,Reason: String?,changeFound: Double?,Color:String?,LunchInDate: String?,LunchOutDate: String?,LogInDate: String?,LogOutDate: String?,CandId:  String?,isSelected: String?,isShowNote: String?){
        
        self.TimeId = TimeId
        self.Name = Name
        self.Comments = Comments
        self.Edit = Edit
        self.Date = Date
        self.break_minutes = break_minutes
        self.TotalHours = TotalHours
        self.LunchInTime = LunchInTime
        self.LunchOutTime = LunchOutTime
        self.LogInTime = LogInTime
        self.LogOutTime = LogOutTime
        self.NewId = NewId
         self.Sent = Sent
         self.changeFound = changeFound
        self.isSelected = isSelected
        self.Color = Color
        self.LunchInDate = LunchInDate
        self.LunchOutDate = LunchOutDate
        self.LogInDate = LogInDate
        self.LogOutDate = LogOutDate
        self.CandId = CandId
        self.isShowNote = isShowNote
        
    }
    /*
     "Weekend": "09/09/2018",
     "Name": "test2, test ",
     "Days": "Mon,Mon,",
     "Weekhours": 23,
     "isSend": 0

     */


    init( Weekend: String?, Name: String?, Days: String?, Weekhours: String?, isSend: Double?,Color:String?){

        self.Weekend = Weekend
        self.Name = Name
        self.Days = Days
        self.Weekhours = Weekhours
        self.Sent = isSend
        self.Color = Color

    }
    init(TimeId: String,Name: String,Date: String,TotalHours: String,CandId: String,OrderId: String,ContactId:  String?,ClientId:  String?,isSelected: String,RowColor: String?){
        
        self.TimeId = TimeId
        self.Name = Name
        self.Date = Date
        self.TotalHours = TotalHours
        self.CandId = CandId
        self.isSelected = isSelected
        self.OrderId = OrderId
        self.ContactId = ContactId
        self.ClientId = ClientId
        self.RowColor = RowColor
    }
//    TimeId: dict["TimeId"].stringValue,
//    Name: dict["Name"].stringValue,
//    Date: dict["Wdate"].stringValue,
//    TotalHours: dict["TotalHours"].stringValue,
//    CandId:dict["CandId"].stringValue,
//    isSelected:"0"
}
