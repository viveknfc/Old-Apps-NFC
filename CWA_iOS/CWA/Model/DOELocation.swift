//
//  DOELocation.swift
//  CWA
//
//  Created by NFC Solutionsusa on 10/04/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class DOELocation: NSObject {
    var LocationId: String?
    var City: String?
    var State: String?
    var Zip: String?
    var LocationDescription: String?
    var StreetAddress: String?
    var isJson: String?
    var LocationCode: String?
    
    init(LocationId: String?,City: String?, State: String?, Zip: String?, LocationDescription: String?,StreetAddress: String?, isJson: String?, LocationCode: String?){
        
        self.LocationId = LocationId
        self.City = City
        self.State = State
        self.Zip = Zip
        self.StreetAddress = StreetAddress
        self.LocationDescription = LocationDescription
        self.LocationCode = LocationCode
        self.isJson = isJson
    }
}
/*
 "LocationId" : 10291,
 "City" : "New York",
 "State" : "NY",
 "Zip" : "12321",
 "LocationDescription" : "Test Location",
 "StreetAddress" : "102 Main St",
 "isJson" : 0,
 "LocationCode" : "11TEST"
 */
