//
//  PositionType.swift
//  CWA
//
//  Created by NFC Solutionsusa on 27/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class PositionType: NSObject {
    var PositionId: Int?
    var PositionName: String?
    var isSelected: String?
     init(PositionId: Int?,PositionName: String?,isSelected: String? ){
        self.PositionId = PositionId
        self.PositionName = PositionName
        self.isSelected = isSelected

    }
}
class HOSPositionType: NSObject {
    var PositionName: String?
    var isSelected: String?
    var KeyValue: String?
    init(KeyValue: String?,PositionName: String?,isSelected: String? ){
        self.KeyValue = KeyValue
        self.PositionName = PositionName
        self.isSelected = isSelected
        
    }
}
