//
//  HistoryObject.swift
//  EWA
//
//  Created by NFC India on 26/12/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class HistoryObject: NSObject {

    
    var orderID = String()
    var date = String()
    var loginStart = String()
    var lunchOut = String()
    var lunchReturn = String()
    var logoutFinish = String()
    var canID = String()
    var sent = String()
    var comments = String()
    var TimeId = String()
    var IsETCcheck = String()
    var isNote = String()
    var isEdit = String()
    var ETCLogId = String()
    var ColorCode = String()
    var IsSubmitted = String()
    var ErrorMessage = String()
    var IsvalidToSubmit = String()
    var ConflictMessage = String()
    var IsMultipleLunch = String()
    var lunchOut2 = String()
    var lunchReturn2 = String()
    
    init(orderID:String,date:String,loginStart:String,lunchOut:String,lunchReturn:String,logoutFinish:String,canID:String,sent:String,comments:String,timeID:String,isEtcCheck: String,isNote: String,isEdit: String,ETCLogId:String,ColorCode:String,IsSubmitted:String,ErrorMessage:String,IsvalidToSubmit:String,ConflictMessage:String,IsMultipleLunch:String,lunchOut2:String,lunchReturn2:String)
    {
        
        self.orderID = orderID
        self.date = date
        self.loginStart = loginStart
        self.lunchOut = lunchOut
        self.lunchReturn = lunchReturn
        self.logoutFinish = logoutFinish
        self.canID = canID
        self.sent = sent
        self.comments = comments
        self.TimeId = timeID
        self.IsETCcheck = isEtcCheck
        self.isNote = isNote
        self.isEdit = isEdit
        self.ETCLogId = ETCLogId
        self.ColorCode = ColorCode
        self.IsSubmitted = IsSubmitted
        self.ErrorMessage = ErrorMessage
        self.IsvalidToSubmit = IsvalidToSubmit
        self.ConflictMessage = ConflictMessage
        self.IsMultipleLunch = IsMultipleLunch
        self.lunchOut2 = lunchOut2
        self.lunchReturn2 = lunchReturn2
    }
    
}
