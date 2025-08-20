//
//  PayStub.swift
//  EWA
//
//  Created by NFC India on 25/09/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class PayStub: NSObject {

    
    var checkNumber:String?
    var division:String?
    var checkDate:String?
    var netWages:String?
    var grossWages:String?
    var ytd:String?
    var company:String?
    
    init(checkNumber:String?,division:String?,checkDate:String?,netWages:String?,grossWages:String?,ytd:String?,company:String)  {
        
        self.checkNumber = checkNumber
        self.division = division
        self.checkDate = checkDate
        self.netWages = netWages
        self.grossWages = grossWages
        self.ytd = ytd
        self.company = company
    }
    
    
}


class Total
{
    var totalNetWages   = Double()
    var totalGrossWages = Double()
    var totalGrossYTD   = Double()
    
    init(totalNetWages:Double,totalGrossWages:Double,totalGrossYTD:Double) {
        self.totalNetWages = totalNetWages
        self.totalGrossWages = totalGrossWages
        self.totalGrossYTD = totalGrossYTD
    }
    
}
