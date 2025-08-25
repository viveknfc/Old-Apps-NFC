//
//  E_RegisterDivision.swift
//  CWA
//
//  Created by NFC User on 26/09/23.
//  Copyright © 2023 NFC Solutionsusa. All rights reserved.
//

import Foundation
import UIKit

class E_RegisterDivision: NSObject {
    
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
    var APISmallLogoPath: String?
    init(Div_ID: Int?,client_name: String?,district: String?,City: String?,location_code: String?, State:String?, CodeZip:String?, Phone:String?, client_id:Int?,contact_id: Int?,pending_ts: Int?,division: String?,comp_name: String?,LogoPath: String?,ColorCode: String?,APISmallLogoPath: String?){

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
        self.APISmallLogoPath = APISmallLogoPath
    }
}
