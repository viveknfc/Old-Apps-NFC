//
//  eAssignments.swift
//  EWA
//
//  Created by NFC India on 21/12/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class eAssignments: NSObject {

    var eId = String()
    var eName = String()
    var eDesc = String()
    var ePosition = String()
    var eClient_Id = String()
    var eCand_Id = String()
    var isETCcheck = Int()
    var IsMultipleLunch = String()
    
    
    init(eId:String,eName:String,eDesc:String,ePosition:String,eClient_Id:String,eCand_Id:String,isETCcheck:Int,IsMultipleLunch:String)
    {
        
        self.eId = eId
        self.eName = eName
        self.eDesc = eDesc
        self.ePosition = ePosition
        self.eClient_Id = eClient_Id
        self.eCand_Id = eCand_Id
        self.isETCcheck = isETCcheck
        self.IsMultipleLunch = IsMultipleLunch
    }
    
    
}
