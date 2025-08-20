//
//  PushNotification.swift
//  EWA
//
//  Created by NFC India on 12/04/19.
//  Copyright © 2019 NFC. All rights reserved.
//

import UIKit

class PushNotification: NSObject {

    
    var pushId = String()
    var candidateId = String()
    var subject = String()
    var messageBody = String()
    var messageType = Int()
    var dateTime = String()
    var actionType = String()
   
    init(pushId:String,candidateId:String,subject:String,messageBody:String,messageType:Int,dateTime:String,actionType:String)
    {
        
        self.pushId = pushId
        self.candidateId = candidateId
        self.subject = subject
        self.messageBody = messageBody
        self.messageType = messageType
        self.dateTime = dateTime
        self.actionType = actionType
    }
    
    
    
    
}
