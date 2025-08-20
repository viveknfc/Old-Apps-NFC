//
//  DemoCandidates.swift
//  EWA
//
//  Created by NFC India on 01/11/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class DemoCandidates: NSObject {

    var candidateName = String()
    var candidateId = String()
    var divisionName = String()
    var divisionLogo = String()
    var password = String()
    var userName = String()
    init(candidateName:String,candidateId:String,divisionName:String,divisionLogo:String,password:String,userName:String)
    {
        self.candidateId = candidateId
        self.candidateName = candidateName
        self.divisionName = divisionName
        self.divisionLogo = divisionLogo
        self.password = password
        self.userName = userName
    }
    
    
    
}
