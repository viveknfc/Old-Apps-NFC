//
//  UploadCredList.swift
//  EWA
//
//  Created by NFC India on 14/12/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class UploadCredList: NSObject {
    
    
    
    var credId = String()
    var credName = String()
    var credDesc = String()
    var credDeleteBtn = Int()
    var credPdfLink = String()
    
    
    init(credId:String,credName:String,credDesc:String, credDeleteBtn:Int, credPdfLink: String)
    {
        self.credId = credId
        self.credName = credName
        self.credDesc = credDesc
        self.credDeleteBtn = credDeleteBtn
        self.credPdfLink = credPdfLink
        
    }
    

}
