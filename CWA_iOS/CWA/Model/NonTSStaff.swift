//
//  NonTSStaff.swift
//  CWA
//
//  Created by NFC User on 3/28/19.
//  Copyright © 2019 NFC Solutionsusa. All rights reserved.
//

import UIKit

class NonTSStaff: NSObject {
    
    var Name: String?
    var Hour: Double?
    var CandidateId:Double?
    var TimpAmount:Double?
    
    init(Name: String?,Hour: Double?,CandidateId: Double?,TimpAmount:Double?)
    {
        self.Name = Name
        self.Hour = Hour
        self.CandidateId = CandidateId
        self.TimpAmount = TimpAmount
    }
    
}

