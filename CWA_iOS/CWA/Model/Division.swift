//
//  Division.swift
//  CWA
//
//  Created by NFC Solutionsusa on 14/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//
// iphone pw: 260542
import UIKit

class Division: NSObject {
    var Div_ID: Int?
    var client_name: String?
    var district: String?
    var City : String?
    var location_code : String?
    var client_id : Int?
    var contact_id : Int?
    var State : String?
    var CodeZip : String?
    var   Phone : String?
    var pending_ts : Int?
    var division : String?
    var comp_name: String?
    var LogoPath: String?
    var ColorCode: String?
    var SmallLogoPath: String?
    init(Div_ID: Int?,client_name: String?,district: String?,City: String?,location_code: String?, State:String?, CodeZip:String?, Phone:String?, client_id:Int?,contact_id: Int?,pending_ts: Int?,division: String?,comp_name: String?,LogoPath: String?,ColorCode: String?,SmallLogoPath: String?){
        
        self.Div_ID = Div_ID
        self.client_name = client_name
        self.district = district
        self.City = City
        self.location_code = location_code
        self.State = State
        self.CodeZip = CodeZip
        self.Phone = Phone
        self.client_id = client_id
        self.contact_id = contact_id
        self.pending_ts = pending_ts
        self.division = division
        self.comp_name = comp_name
        self.LogoPath = LogoPath
        self.ColorCode = ColorCode
        self.SmallLogoPath = SmallLogoPath
        
    }
}
