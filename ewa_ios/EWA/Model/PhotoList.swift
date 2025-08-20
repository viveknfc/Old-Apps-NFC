//
//  PhotoList.swift
//  EWA
//
//  Created by NFC India on 05/12/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class PhotoList: NSObject {

    var photoId = String()
    var photoLink = String()
    var photoUpdatedDate = String()
    
    
    init(photoId:String,photoLink:String,photoUpdatedDate:String)
    {
        self.photoId = photoId
        self.photoLink = photoLink
        self.photoUpdatedDate = photoUpdatedDate
        
    }
    
    
    
}
