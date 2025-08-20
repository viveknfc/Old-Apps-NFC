//
//  PayStubDetails.swift
//  EWA
//
//  Created by NFC India on 27/09/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class PayStubDetails: NSObject {
    
    var legalName = String()
    var localOffice = String()
    var empName = String()
    var ssn = String()
    var payPeriod = String()
    var checkDate = String()
    var checkNumber = String()
    var grossPay = String()
    var fica = String()
    var medicare = String()
    var fit = String()
    var state = String()
    var city = String()
    var disabilityPaid = String()
    var forOneK = String()
    var code = String()
    var clientName = String()
    var clientAddress = String()
    var clientPhone = String()
    var regRate = String()
    var otRate = String()
    var doubleTimeRate = String()
    var totalHours = String()
    var earningArry = [Earnings]()
    var miscs = [MiscAdjustments]()
    var totalHour = String()
    var totalHourDA = String()
    var netPay = String()
    var grossPayYTD = String()
    var ficaYTD = String()
    var medicareYTD = String()
    var fitYTD = String()
    var stateYTD = String()
    var cityYTD = String()
    var disabilityPaidYTD = String()
    var forOneKYTD = String()
    var note = String()
    var ASTHFUIC = String() //    "AccruedSickTimeHoursForUseInCalifornia": 7.5,
    var ASTHFUIS = String() //    "AccruedSickTimeHoursForUseInSanFrancisco": 11.5,
    var ASTHFUIO = String()//    "AccruedSickTimeHoursForUseInOakland": 1,
    var ASTHFUIE = String()//    "AccruedSickTimeHoursForUseInEmeryville": 0,
    var STAFUIC = String() //    "SickTimeAvailableForUseInCalifornia": 2,
    var STAFUIS = String() //    "SickTimeAvailableForUseInSanFrancisco": 0,
    var STAFUIO = String() //    "SickTimeAvailableForUseInOakland": 1,
    var STAFUIE = String() //    "SickTimeAvailableForUseInEmeryville": 0
    var isCAEmpl = Bool()
    var clientDetails = [ClientDetails]()

    init(legalName:String,localOffice:String,empName:String,ssn:String,payPeriod:String,checkDate:String,checkNumber:String,grossPay:String,fica:String,medicare:String,fit:String,state:String,city:String,disabilityPaid:String,forOneK:String,earningArry:[Earnings],miscs:[MiscAdjustments],totalHour:String,totalHourDA:String,netPay:String,grossPayYTD:String,ficaYTD:String,medicareYTD:String,fitYTD:String,stateYTD:String,cityYTD:String,disabilityPaidYTD:String,forOneKYTD:String,note:String,ASTHFUIC:String,ASTHFUIS:String,ASTHFUIO:String,ASTHFUIE:String,STAFUIC:String,STAFUIS:String,STAFUIO:String,STAFUIE:String,isCAEmpl:Bool,clientDetails:[ClientDetails]) {
        self.legalName = legalName
        self.localOffice = localOffice
        self.empName = empName
        self.ssn = ssn
        self.payPeriod = payPeriod
        self.checkDate = checkDate
        self.checkNumber = checkNumber
        self.grossPay = grossPay
        self.fica = fica
        self.medicare = medicare
        self.fit = fit
        self.state = state
        self.city = city
        self.disabilityPaid = disabilityPaid
        self.forOneK = forOneK
        self.earningArry = earningArry
        self.miscs = miscs
        self.totalHour = totalHour
        self.totalHourDA = totalHourDA
        self.netPay = netPay
        self.grossPayYTD = grossPayYTD
        self.ficaYTD = ficaYTD
        self.fitYTD = fitYTD
        self.cityYTD = cityYTD
        self.stateYTD = stateYTD
        self.medicareYTD = medicareYTD
        self.disabilityPaidYTD = disabilityPaidYTD
        self.forOneKYTD = forOneKYTD
        self.note = note
        self.ASTHFUIC = ASTHFUIC
        self.ASTHFUIS = ASTHFUIS
        self.ASTHFUIO = ASTHFUIO
        self.ASTHFUIE = ASTHFUIE
        self.STAFUIC = STAFUIC
        self.STAFUIS = STAFUIS
        self.STAFUIO = STAFUIO
        self.STAFUIE = STAFUIE
        self.isCAEmpl = isCAEmpl
        self.clientDetails = clientDetails
    }
    

}

class Earnings
{
    var code = String()
    var division = String()
    var description = String()
    var units = String()
    var rate = String()
    var earnings = String()
    
    init(code:String,division:String,description:String,units:String,rate:String,earnings:String) {
        self.code = code
        self.division = division
        self.description = description
        self.units = units
        self.rate = rate
        self.earnings = earnings
    }
    
}

class MiscAdjustments
{
    var ytd = String()
    var adjustments = String()
    
    init(ytd:String,adjustments:String) {
        self.ytd = ytd
        self.adjustments = adjustments
        
    }
    
}


class ClientDetails
{
    var code = String()
    var clientName = String()
    var clientAddress = String()
    var clientPhone = String()
    var regRate = String()
    var otRate = String()
    var doubleTimeRate = String()
    var totalHours = String()
    
    init(code:String,clientName:String,clientAddress:String,clientPhone:String,regRate:String,otRate:String,doubleTimeRate:String,totalHours:String) {
        self.code = code
        self.clientName = clientName
        self.clientAddress = clientAddress
        self.clientPhone = clientPhone
        self.regRate = regRate
        self.otRate = otRate
        self.doubleTimeRate = doubleTimeRate
        self.totalHours = totalHours
    }
    
}
