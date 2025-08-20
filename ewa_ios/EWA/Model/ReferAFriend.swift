//
//  ReferAFriend.swift
//  EWA
//
//  Created by NFC India on 08/08/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class ReferAFriend: NSObject {
    
    var title:String?
    var jobType:String?
    var categoryType:String?
    var orderId:String?
    var imageUrl:String?
    var address:String?
    var jobId:String?
    
    init(title:String?,jobType:String?,categoryType:String?,orderId:String?,imageUrl:String?,address:String?,jobId:String?)  {
        
        
        
        self.title = title
        self.jobType = jobType
        self.categoryType = categoryType
        self.orderId = orderId
        self.imageUrl = imageUrl
        self.address = address
        self.jobId = jobId
        
        
    }
}
