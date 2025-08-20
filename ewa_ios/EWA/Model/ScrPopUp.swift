//
//  ScrPopUp.swift
//  EWA
//
//  Created by NFCIndia on 16/09/19.
//  Copyright © 2019 NFC. All rights reserved.
//

import UIKit

class ScrPopUp: NSObject {

    
    var address = String()
    var apt = String()
    var from = String()
    var to = String()
    var city = String()
    var state = String()
    var zipcode = String()
    var id = String()
    
    init(address:String,apt:String,from:String,to:String,city:String,state:String,zipcode:String,id:String)
    {
        
        self.address = address
        self.apt = apt
        self.from = from
        self.to = to
        self.city = city
        self.state = state
        self.zipcode = zipcode
        self.id = id
    }
}
