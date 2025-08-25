//
//  eTimeClockEmpTotalHour.swift
//  CWA
//
//  Created by NFC Solutionsusa on 27/11/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class eTimeClockEmpTotalHour: NSObject {
    var his_Wdate: String?
    var his_Login: String?
    var his_LunchOut: String?
    var his_LunchIn: String?

    var his_LogOut: String?
    var his_Name: String?
    
    init(  his_Wdate: String?, his_Login: String? , his_LunchOut: String?, his_LunchIn: String?, his_LogOut: String?, his_Name: String?)
    {
        self.his_Wdate = his_Wdate
        self.his_Login = his_Login
        self.his_LunchOut = his_LunchOut
        self.his_LogOut = his_LogOut
        self.his_Name = his_Name
        self.his_LunchIn = his_LunchIn
        
        
    }
}
