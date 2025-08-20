//
//  ReferalApplicantList.swift
//  EWA
//
//  Created by NFC India on 13/08/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class ReferalApplicantList: NSObject {

    var name:String?
    var email:String?
    var referalDate:String?
    var applicationReceivedDate:String?
    var status:String?
    
    
    init(name:String?,email:String?,referalDate:String?,applicationReceivedDate:String?,status:String?)  {
        
        self.name = name
        self.email = email
        self.referalDate = referalDate
        self.applicationReceivedDate = applicationReceivedDate
        self.status = status
    
    }
}
