//
//  State.swift
//  CWA
//
//  Created by NFC Solutionsusa on 02/04/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class State: NSObject {
    var StateId: String?
    var StateName: String?
    var StateCode : String?
    var isSelected : String?

    
    init( StateId: String?,StateName:String?,StateCode : String?,isSelected  : String? ){
        
         self.StateId = StateId
        self.StateName = StateName
        self.StateCode = StateCode
        self.isSelected = isSelected

    }
}
