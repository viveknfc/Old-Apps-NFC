//
//  Employee.swift
//  CWA
//
//  Created by NFC Solutionsusa on 04/12/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class Employee: NSObject {
    var CandidateId: Int?
    var Name: String?
    var Position: String?
    var isCheckedInRoaster: String?
    var isSelected: String?
    var Photo:String?
    var Evaluation: Double?
    var WeeklyHours: String?
    var YTDHours: String?
 
    /*
     "Position": "HasQuietArea",
     "WeeklyHours": "13.50",
     "YTDHours": "8.00",
     "LastOrderDate": "03/05/2018",
     "Evaluation": 0,
     "ClientId": 70829

     */
    var Function: String?
    var StartDate: String?
    var EndDate: String?
    var ReportTo: String?
    var OrderId: Int?
    var MaxOrderId: Int?
    var MaxStartDate: String?
    //
    init(CandidateId: Int?,Name: String?, Position: String?, Function: String?,StartDate: String?, EndDate: String?, ReportTo: String?, OrderId: Int?, MaxOrderId: Int?, MaxStartDate: String?,isCheckedInRoaster: String?,isSelected : String? ){
        
        self.CandidateId = CandidateId
        self.Position = Position
        self.Function = Function
        self.Name = Name
        self.StartDate = StartDate
        self.EndDate = EndDate
        self.ReportTo = ReportTo
        self.OrderId = OrderId
        self.MaxOrderId = MaxOrderId
        self.MaxStartDate = MaxStartDate
        self.isCheckedInRoaster = isCheckedInRoaster
        self.isSelected = isSelected
    }
    
}

class NewEmployee: NSObject {
    var CandidateId: Int?
    var Name: String?
    var lastDate: String?
    var Weekly_Hours: String?
    var positions: String?
    var Eval: String?
    var YTD_Hours: String?
    var isCheckedInRoaster: String?
    var isSelected: String?
    var Photo:String?
    var DummyImagePath:String?
    var Evaluation: Double?
    var ShowOT : String?
     var OTNote : String?
    var IsSpreadOfHour : String?
    var MessageSpreadofHours : String?
    var isfavourite:Int?
    var favColor:String?
    
    //
    init(CandidateId: Int?,Name: String?, lastDate: String?, Weekly_Hours: String?,positions: String?, Eval: String?, YTD_Hours: String?,isCheckedInRoaster: String?,isSelected : String?,Photo:String?,Evaluation: Double?,DummyImagePath:String?,isfavourite:Int?,favColor:String?){
        
        self.DummyImagePath = DummyImagePath
        self.CandidateId = CandidateId
        self.positions = positions
         self.Name = Name
        self.Weekly_Hours = Weekly_Hours
        self.lastDate = lastDate
        self.Eval = Eval
        self.YTD_Hours = YTD_Hours
         self.isCheckedInRoaster = isCheckedInRoaster
        self.isSelected = isSelected
        self.Photo = Photo
        self.Evaluation = Evaluation
        self.isfavourite = isfavourite
    }
    init(CandidateId: Int?,Name: String?, lastDate: String?, Weekly_Hours: String?,positions: String?, Eval: String?, YTD_Hours: String?,isCheckedInRoaster: String?,isSelected : String?,Photo:String?,Evaluation: Double?,DummyImagePath:String?,ShowOT : String? ,OTNote : String?, IsSpreadOfHour : String?,MessageSpreadofHours : String?,isfavourite:Int?,favColor:String?){
        
        self.DummyImagePath = DummyImagePath
        self.CandidateId = CandidateId
        self.positions = positions
        self.Name = Name
        self.Weekly_Hours = Weekly_Hours
        self.lastDate = lastDate
        self.Eval = Eval
        self.YTD_Hours = YTD_Hours
        self.isCheckedInRoaster = isCheckedInRoaster
        self.isSelected = isSelected
        self.Photo = Photo
        self.Evaluation = Evaluation
        self.ShowOT = ShowOT
         self.OTNote = OTNote
        self.IsSpreadOfHour = IsSpreadOfHour
        self.MessageSpreadofHours = MessageSpreadofHours
        self.isfavourite = isfavourite
    }
}
