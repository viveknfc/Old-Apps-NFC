//
//  Resume.swift
//  EWA
//
//  Created by NFC India on 30/11/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit



class Resume: NSObject {
    
    var resumeId = String()
    var resumeName = String()
    var resumeExtension = String()
    var resumeUpdateddate = String()
    
    
    init(resumeId:String,resumeName:String,resumeExtension:String,resumeUpdateddate:String)
    {
        self.resumeId = resumeId
        self.resumeName = resumeName
        self.resumeExtension = resumeExtension
        self.resumeUpdateddate = resumeUpdateddate
        
    }
    
}
