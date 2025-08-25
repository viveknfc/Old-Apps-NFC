//
//  Applicant.swift
//  CWA
//
//  Created by NFC Solutionsusa on 03/04/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class Applicant: NSObject,NSCoding {
    
    var CandidateId: String?
    var ApplicantId: String?
    var isSelected: String?
    var Name: String?
    var ConsultantType: String?
    var Email: String?
    var Address: String?
    var City: String?
    var State: String?
    var Zip: String?
    var appliType: String?
    var SSN: String?
    var ApplicationId: String?
    var NewApplicant: String?
    var extraCandId: String?
 
    init( CandidateId: String?, ApplicantId: String?, Name: String?, ConsultantType: String?, Email: String?, Address: String?, City: String?, State: String?, Zip: String?,SSN: String?, isSelected: String?,appliType: String?,ApplicationId: String?,NewApplicant: String?,extraCandId: String?){
        
        self.CandidateId = CandidateId
        self.ApplicantId = ApplicantId
        self.isSelected = isSelected
        self.Name = Name
        self.ConsultantType = ConsultantType
        self.Email = Email
        self.Address = Address
        self.City = City
        self.State = State
        self.Zip = Zip
        self.SSN = SSN
        self.appliType = appliType
        self.ApplicationId = ApplicationId
        self.NewApplicant = NewApplicant
        self.extraCandId = extraCandId
        
        
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let CandidateId = aDecoder.decodeObject(forKey: "CandidateId")
        let ApplicantId = aDecoder.decodeObject(forKey: "ApplicantId") as! String
        let Name = aDecoder.decodeObject(forKey: "Name") as! String
        let ConsultantType = aDecoder.decodeObject(forKey: "ConsultantType") as! String
        let Email = aDecoder.decodeObject(forKey: "Email") as! String
        let Address = aDecoder.decodeObject(forKey: "Address") as! String
        let City = aDecoder.decodeObject(forKey: "City") as! String
        let State = aDecoder.decodeObject(forKey: "State") as! String
        let Zip = aDecoder.decodeObject(forKey: "Zip") as! String
        let isSelected = aDecoder.decodeObject(forKey: "isSelected") as! String
        let SSN = aDecoder.decodeObject(forKey: "SSN") as! String
        let appliType = aDecoder.decodeObject(forKey: "appliType") as! String
        let ApplicationId = aDecoder.decodeObject(forKey: "ApplicationId") as! String
        let NewApplicant = aDecoder.decodeObject(forKey: "NewApplicant") as! String
        let extraCandId = aDecoder.decodeObject(forKey: "extraCandId") as! String
        self.init(CandidateId: CandidateId as? String, ApplicantId: ApplicantId, Name: Name, ConsultantType: ConsultantType, Email: Email, Address: Address, City: City, State: State, Zip: Zip,SSN: SSN, isSelected: isSelected,appliType:appliType,ApplicationId: ApplicationId,NewApplicant: NewApplicant,extraCandId:extraCandId)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(CandidateId, forKey: "CandidateId")
        aCoder.encode(ApplicantId, forKey: "ApplicantId")
        aCoder.encode(Name, forKey: "Name")
        aCoder.encode(ConsultantType, forKey: "ConsultantType")
        aCoder.encode(Email, forKey: "Email")
        aCoder.encode(Address, forKey: "Address")
        aCoder.encode(City, forKey: "City")
        aCoder.encode(State, forKey: "State")
        aCoder.encode(Zip, forKey: "Zip")
        aCoder.encode(isSelected, forKey: "isSelected")
        aCoder.encode(SSN, forKey: "SSN")
        aCoder.encode(appliType,  forKey: "appliType")
        aCoder.encode(ApplicationId, forKey: "ApplicationId")
        aCoder.encode(NewApplicant, forKey: "NewApplicant")
        aCoder.encode(extraCandId, forKey: "extraCandId")

    }
    
    //
}
/*
 https://stackoverflow.com/questions/29986957/save-custom-objects-into-nsuserdefaults
 "CandidateId": 0,
 "ApplicantId": 181443,
 "GtId": 0,
 "SSN": "",
 "Name": "Consultant, Test",
 "ConsultantType": 2,
 "Email": "test@test.com",
 "Address": "Test",
 "City": "test",
 "State": "NY",
 "Zip": "10710"
 
 */
