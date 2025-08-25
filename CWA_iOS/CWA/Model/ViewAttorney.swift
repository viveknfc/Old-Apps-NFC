//
//  ViewAttorney.swift
//  CWA
//
//  Created by NFC Solutionsusa on 28/12/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class ViewAttorney: NSObject {
    
    var DetailId: Int?
    var AttorneyWork_Performed: String?
    var Day: String?
    var AttorneyMatter: String?
    var AttorneyEndTime: String?
    var AttorneyStartTime: String?
    var Hours: String?
    var TimeId: Int?
    var Attorneydate: String?
    var ClientId: Int?
    var AttorneyIsApproved: Int?
    
    init(DetailId: Int?,AttorneyWork_Performed: String?,Day: String?,AttorneyMatter: String?,AttorneyEndTime: String?,AttorneyStartTime: String?,Hours: String?,TimeId: Int?,Attorneydate: String?,ClientId: Int?,AttorneyIsApproved: Int?){
        
        self.DetailId = DetailId
        self.AttorneyWork_Performed = AttorneyWork_Performed
        self.Day = Day
        self.AttorneyMatter = AttorneyMatter
        self.AttorneyEndTime = AttorneyEndTime
        self.AttorneyStartTime = AttorneyStartTime
        self.Hours = Hours
        self.TimeId = TimeId
        self.Attorneydate = Attorneydate
        self.ClientId = ClientId
        self.AttorneyIsApproved = AttorneyIsApproved
    }
}
