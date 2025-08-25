//
//  ClientInvoice.swift
//  CWA
//
//  Created by NFC Solutionsusa on 09/08/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class ClientInvoice: NSObject {
    var StartDate: String?
    var EndDate: String?
    var UnPaid: String?
    var OrigInvoiceNumber: String?
    var InvoiceNumber: String?
    var InvoiceType: String?
    var BillDate: String?
    var Total: Double?
    var Balance: Double?
    var Paid: String?
    var Expense: String?
    var OrderStatus: Double?

    
    init( StartDate: String?, EndDate: String?, UnPaid: String?, OrigInvoiceNumber: String?, InvoiceNumber: String?, InvoiceType: String?, BillDate: String?, Total: Double?, Balance: Double?,Paid: String?, Expense: String?,OrderStatus: Double?){
        
        self.StartDate = StartDate
        self.EndDate = EndDate
        self.UnPaid = UnPaid
        self.OrigInvoiceNumber = OrigInvoiceNumber
        self.InvoiceNumber = InvoiceNumber
        self.InvoiceType = InvoiceType
        self.BillDate = BillDate
        self.Total = Total
        self.Balance = Balance
        self.Paid = Paid
        self.Expense = Expense
        self.OrderStatus = OrderStatus
 
    }
}
