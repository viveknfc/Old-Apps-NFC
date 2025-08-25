//
//  HealthCareEmployee.swift
//  CWA
//
//  Created by NFC Solutionsusa on 14/03/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class HealthCareEmployee: NSObject {
    var CandidateId: Int?
    var Name: String?
    var LastPosition: String?
    var WeeklyHours: String?
    var ERating: String?
    var isCheckedInRoaster: String?
    var isSelected: String?
    var LastPayRate: String?
    var BookedColour: String?

    //
    init(CandidateId: Int?,Name: String?, LastPosition: String? ,WeeklyHours: String?, ERating: String?, LastPayRate: String?,BookedColour : String?,isCheckedInRoaster: String?,isSelected : String? ){
        
        self.CandidateId = CandidateId
        self.LastPosition = LastPosition
        self.Name = Name
        self.WeeklyHours = WeeklyHours
        self.ERating = ERating
        self.isCheckedInRoaster = isCheckedInRoaster
        self.isSelected = isSelected
        self.LastPayRate = LastPayRate
         self.BookedColour = BookedColour
    }
}
/*
 "CandidateId": 184541,
 "Name": "bouey, cheryl",
 "LastPosition": "",
 "WeeklyHours": 8,
 "ERating": "Excellent",
 "LastPayRate": 13,
 "Booked": 2,
 "BookedColour": "#87CEFA

 */
