//
//  SCRClearance.swift
//  CWA
//
//  Created by NFC Solutions on 08/11/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import Foundation
import UIKit

class SCRClearance: NSObject
{
    var ApplicantId: String?
    var FirstName: String?
    var LastName: String?
    var DateOfBirth: String?
    var ScrSubmissionDate: String?
    var ApprovedOrDeniedBy: String?
    var ScrApprovalStatus: Int?
    var ApprovalOrDenialDate: String?
    var ScrFormSentDate: String?
    var AplDOB: String?
    var ScrFormStatus: String?
    var ScrFormAprvDate: String?
    var ScrFormDnyDate: String?
    var ScrFormAprvDenialBy: String?
    var ScrColor: String?
    

init(ApplicantId: String?,FirstName: String?,LastName: String?,DateOfBirth: String?,ScrSubmissionDate: String?,ApprovedOrDeniedBy: String?,ScrApprovalStatus: Int?,ApprovalOrDenialDate: String?,ScrFormSentDate: String?,AplDOB: String?,ScrFormStatus: String?,ScrFormAprvDate: String?,ScrFormDnyDate: String?,ScrFormAprvDenialBy: String?,ScrColor: String?)
 {
    self.ApplicantId = ApplicantId
    self.FirstName = FirstName
    self.LastName = LastName
    self.DateOfBirth = DateOfBirth
    self.ScrSubmissionDate = ScrSubmissionDate
    self.ApprovedOrDeniedBy = ApprovedOrDeniedBy
    self.ScrApprovalStatus = ScrApprovalStatus
    self.ApprovalOrDenialDate = ApprovalOrDenialDate
    self.ScrFormSentDate = ScrFormSentDate
    self.AplDOB = AplDOB
    self.ScrFormStatus = ScrFormStatus
    self.ScrFormAprvDate = ScrFormAprvDate
    self.ScrFormDnyDate = ScrFormDnyDate
    self.ScrFormAprvDenialBy = ScrFormAprvDenialBy
    self.ScrColor = ScrColor
 }
}

/*
 
 "ApplicantId": 105676,
 "FirstName": "william",
 "LastName": "abaidoo",
 "DateOfBirth": "0001-01-01T00:00:00",
 "ScrSubmissionDate": "0001-01-01T00:00:00",
 "ScrApprovalStatus": 0,
 "ApprovedOrDeniedBy": null,
 "ApprovalOrDenialDate": "0001-01-01T00:00:00",
 "ScrFormSentDate": "08/29/2014   1:39PM",
 "AplDOB": "1964-11-22T00:00:00",
 "ScrFormStatus": "Denied",
 "ScrFormAprvDate": "0001-01-01T00:00:00",
 "ScrFormDnyDate": "10/30/2018   2:30AM",
 "ScrFormAprvDenialBy": "James Morriss",
 "ScrColor": "#A52A2A"

*/
