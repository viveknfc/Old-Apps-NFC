//
//  ReportTo.swift
//  CWA
//
//  Created by NFC Solutionsusa on 27/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class ReportTo: NSObject {
    var ContactId: Int?
    var Name: String?
    var isSelected: String?

    init(ContactId: Int?,Name: String?,isSelected: String? ){
        self.ContactId = ContactId
        self.Name = Name
        self.isSelected = isSelected
    }
    
}
class ReportToLocation: NSObject {
    var ReportToLocation: String?
    var Split_Add: String?
    var isSelected: String?
    var ReportId: String?
    
    init(ReportToLocation: String?,Split_Add: String?,isSelected: String?,ReportId: String?  ){
        self.ReportToLocation = ReportToLocation
        self.Split_Add = Split_Add
        self.isSelected = isSelected
        self.ReportId = ReportId

    }
    
}
class OfficeReportToLocation: NSObject {
    var ReportToName: String?
    var ReportId: String?
    var isSelected: String?

    init(ReportToName: String?,ReportId: String?,isSelected: String?  ){
        self.ReportToName = ReportToName
        self.ReportId = ReportId
        self.isSelected = isSelected

    }
    
}

class OCCReportToExp: NSObject {
    var Value: String?
    var Text: String?
    var isSelected: String?
    
    init(Value: String?,Text: String?,isSelected: String? ){
        self.Value = Value
        self.Text = Text
        self.isSelected = isSelected
    }
    
}
class DOEReportTo: NSObject,NSCoding {
    var Value: String?
    var Text: String?
    var ContAddr: String?
    var State: String?
    var Phone: String?
    var City: String?
    var Zip: String?
    var AddETo: String?
    var isSelected: String?
    var ClientId: String?
    var ContactId: String?
 
    init(Value: String?,Text: String?,ContAddr: String?,State: String?,Phone: String?,City: String?,Zip: String?,AddETo: String?,isSelected: String?,ClientId: String?,ContactId: String? ){
        self.Value = Value
        self.Text = Text
        self.ContAddr = ContAddr
        self.State = State
        self.Phone = Phone
        self.City = City
        self.Zip = Zip
        self.isSelected = isSelected
        self.AddETo = AddETo
        self.ClientId = ClientId
        self.ContactId = ContactId
    }
    required convenience init(coder aDecoder: NSCoder) {
        let Value = aDecoder.decodeObject(forKey: "Value")
        let Text = aDecoder.decodeObject(forKey: "Text") as! String
        let ContAddr = aDecoder.decodeObject(forKey: "ContAddr") as! String
        let State = aDecoder.decodeObject(forKey: "State") as! String
        let Phone = aDecoder.decodeObject(forKey: "Phone") as! String
         let City = aDecoder.decodeObject(forKey: "City") as! String
        let AddETo = aDecoder.decodeObject(forKey: "AddETo") as! String
        let Zip = aDecoder.decodeObject(forKey: "Zip") as! String
        let isSelected = aDecoder.decodeObject(forKey: "isSelected") as! String
        let ClientId = aDecoder.decodeObject(forKey: "ClientId") as! String
        let ContactId = aDecoder.decodeObject(forKey: "ContactId") as! String

        self.init(Value: (Value as! String),Text: Text,ContAddr: ContAddr,State: State,Phone: Phone,City: City,Zip: Zip,AddETo: AddETo,isSelected: isSelected,ClientId: ClientId,ContactId: ContactId)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(Value, forKey: "Value")
        aCoder.encode(Text, forKey: "Text")
        aCoder.encode(ContAddr, forKey: "ContAddr")
        aCoder.encode(State, forKey: "State")
        aCoder.encode(Phone, forKey: "Phone")
        aCoder.encode(City, forKey: "City")
        aCoder.encode(AddETo, forKey: "AddETo")
        aCoder.encode(Zip, forKey: "Zip")
        aCoder.encode(ClientId, forKey: "ClientId")
        aCoder.encode(isSelected, forKey: "isSelected")
        aCoder.encode(ContactId, forKey: "ContactId")
    }
    
    /*
     {
     "WebPass" : null,
     "SelectedContactFieldPrefix" : null,
     "ContAddr" : "8 Henry Street",
     "State" : "NY",
     "AddETo" : "pkadrikar@tempositions.com",
     "Zip" : "10038",
     "ContactId" : 0,
     "Value" : "211932",
     "Phone" : "(212) 916-0831",
     "City" : "New",
     "Name" : "Prasad Kadrikar",
     "SelectedContactId" : 0,
     "Text" : "Prasad Kadrikar",
     "ClientId" : 0,
     "DisplayDiv" : "block"
     }
     */
}
