//
//  DOEOrder.swift
//  CWA
//
//  Created by NFC Solutionsusa on 28/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class DOEOrder: NSObject {

    var Orderid: Int?
    var Entered: String?
    var PONumber: String?
    var Position: String?
    var Name: String?
    var StartDate: String?
    var EndDate: String?
    var Bill: String?
    var Pay: String?
    var TotalOrderPoAmount: String?
    var CurrentAmountInvoiced: String?
    var OutStandingPOBalance: String?
    var UnbilledTsRevenue: String?
    var ProjPoBalance: String?
    var willShow: String?

    init(Orderid: Int?,Entered: String?, PONumber: String?, Position: String?, Name: String?,StartDate: String?, EndDate: String?, Bill: String?, Pay: String?, TotalOrderPoAmount: String?, CurrentAmountInvoiced: String?, OutStandingPOBalance: String?, UnbilledTsRevenue: String?,ProjPoBalance: String? ,willShow: String?){
        
        self.Orderid = Orderid
        self.Entered = Entered
        self.PONumber = PONumber
        self.Position = Position
        self.Name = Name
        self.StartDate = StartDate
        self.EndDate = EndDate
        self.Bill = Bill
        self.Pay = Pay
        self.TotalOrderPoAmount = TotalOrderPoAmount
        self.CurrentAmountInvoiced = CurrentAmountInvoiced
        self.OutStandingPOBalance = OutStandingPOBalance
        self.UnbilledTsRevenue = UnbilledTsRevenue
        self.ProjPoBalance = ProjPoBalance
        self.willShow = willShow
        
    }
    /*
     "Orderid": 896945,
     "Entered": "2017-11-22T00:00:00",
     "PONumber": "",
     "Position": "09p875",
     "Name": "",
     "StartDate": "2017-11-27T00:00:00",
     "EndDate": "2017-11-28T00:00:00",
     "Bill": "$0.00",
     "Pay": "$0.00",
     "TotalOrderPoAmount": "$0.00",
     "CurrentAmountInvoiced": "$0.00",
     "OutStandingPOBalance": "$0.00",
     "UnbilledTsRevenue": "$0.00",
     "ProjPoBalance": "$0.00"

     */
}
