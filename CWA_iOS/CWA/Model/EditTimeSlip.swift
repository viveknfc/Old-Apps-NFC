//
//  EditTimeSlip.swift
//  CWA
//
//  Created by NFC Solutions on 02/02/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class EditTimeSlip: NSObject {


    var day:String?
    var divisionId:String?
    var detailId:String?
    var date:String?
    var nexDate:String?
    var startTime:String?
    var endTime:String?
    var breakMin:String?
    var hours:String?
    var taxiFare:String?
    
init(day:String?,divisionId:String?,detailId:String?,date:String?,nexDate:String?,startTime:String?,endTime:String?,breakMin:String?,hours:String?,taxiFare:String?) {
        
        self.day = day
        self.divisionId = divisionId
        self.detailId = detailId
        self.date = date
        self.nexDate = nexDate
        self.startTime = startTime
        self.endTime = endTime
        self.breakMin = breakMin
        self.hours = hours
        self.taxiFare = taxiFare
    }
    
    

}
