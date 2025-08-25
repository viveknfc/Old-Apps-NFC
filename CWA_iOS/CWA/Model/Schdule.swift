//
//  Schdule.swift
//  CWA
//
//  Created by NFC Solutionsusa on 15/12/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class Schdule: NSObject {
    var OrderId: Int?
    var ClientMaster: String?
    var Candname: String?
     var CandId: Int?
    var dayArray: NSMutableArray?

    init(OrderId: Int?,ClientMaster: String?, Candname: String?, CandId: Int?,dayArray: NSMutableArray?){
        
        self.OrderId = OrderId
        self.ClientMaster = ClientMaster
        self.Candname = Candname
        self.CandId = CandId
        self.dayArray = dayArray
     }
}
