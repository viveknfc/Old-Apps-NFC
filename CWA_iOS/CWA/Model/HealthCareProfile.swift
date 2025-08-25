//
//  HealthCareProfile.swift
//  CWA
//
//  Created by NFC Solutionsusa on 09/03/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class HealthCareProfile: NSObject {
  
    var ProfileId: Int?
    var ClientId: Int?
    var isSelected: String?
    var Description: String?
    
    init(ProfileId: Int?,ClientId: Int?,isSelected: String?,Description: String? ){
        self.ProfileId = ProfileId
        self.ClientId = ClientId
        self.isSelected = isSelected
        self.Description = Description
    }
}
