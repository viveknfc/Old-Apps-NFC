//
//  ServerService.swift
//  
//
//  Created by NFC Solutions on 06/09/17.
//  Copyright © 2017 NFC. All rights reserved.
//


import UIKit
import SwiftyJSON
import ANLoader
import SystemConfiguration
import Foundation
    
class ServerService {
    
    static var json: JSON = JSON.null
    static var json2: JSON = JSON.null
    static var myIndicator=UIActivityIndicatorView()
    static var container: UIView = UIView()
    static var actInd = UIActivityIndicatorView()
    
    static var ProductionURL = "https://apps.tempositions.com/tempositionsewaapi/api/"
    static var DevelopmentURL = "https://tempositionsdev.com/TemPositionsEMAAPIDEV/api/"
    static var StagingURL = "https://apps.tempositions.com/TemPositionsEMAAPIUAT/api/"
    
    static var BaseUrl = ProductionURL
    
    static var ProductionAppVersion = "\(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)"
//    static var ProductionAppVersion = "5.9.9"
    static var DevelopmentAppVersion = "1.0.55"
    
    static var displayVersion: String {
        if ServerService.BaseUrl == ServerService.ProductionURL {
            return ServerService.ProductionAppVersion
        }
        else {
            return ServerService.DevelopmentAppVersion
        }
    }
    
    static  let Login = "Account/Login"
    static  let ChangePassword = "Account/ChangePassword"
    static  var Forgotpassword = "Account/ForgotPassword"
    //static  let ListOfAssignments = "Assignments/GetAssignments" //old
    static  let ListOfAssignments = "Assignments/GetAssignmentsNew"
    static  let GetMessages = "Messages/GetMessages"
    static  let DeleteMessage = "Messages/DeleteMessages"
    static  var AssignmentDetail = "Assignments/GetOrderDetails"
    static  let GetAvailability = "Avalability/GetAvalability"
    static  var RespondToMessage = "Messages/ManageRespond"
    static  let SubmitAvailability = "Avalability/ManageAvalability"
    static  var GetTimeDetailsAvailability = "Avalability/GetTimeDetailsAvailability"
    static  let ViewTimeSlips = "TimeSlip/ViewTimeSlips"
    static  var GetTimeSlipReport = "TimeSlip/ViewTimeSlipReport"
    static  let PersonalJobBank = "PersonalJobBank/ShowListOfJobsAvailable"
    static  var GetEnterTimeSlipDates = "TimeSlip/BindWeekEnding"
    static  var GetTimeSlipAssignments = "TimeSlip/GetTimeSlipAssignments"
    static  var EnterTimeSlip = "TimeSlip/EnterTimeSlip"
    static  var DuplicateTimeSlips = "TimeSlip/DuplicateTimeSlips"
    static  var InsertPendingTimeSlip = "TimeSlip/InsertPendingTimeSlip"
    static  var OncallcounselWeekEnding = "TimeSlip/OncallcounselWeekEnding"
    static  var OncallcounselWeekEndTimeEntry = "TimeSlip/OncallcounselWeekEndTimeEntry"
    static  var OncallcounselSaveTimeList = "TimeSlip/OncallcounselSaveTimeList"
    static  var OnCallcounselDeleteTimeSlip = "TimeSlip/OnCallcounselDeleteTimeSlip"
    static  var OnCallcounselSaveWeeklyTime = "TimeSlip/OnCallcounselSaveWeeklyTime"
    static  var EnterTimeSlipDOEEnterTimeSlip = "EnterTimeSlip/DOEEnterTimeSlip"
    static  var DoeEnterTimeSlipSubmitDOEEnterTimeSlip = "DoeEnterTimeSlip/SubmitDOEEnterTimeSlip"
    static  var AccountEWAMenuLinks = "Account/EWAMenuLinks"
    static  var RejectJob = "PersonalJobBank/DeclineJob"
    static  var AcceptJob = "PersonalJobBank/AcceptJob"
    static  var PersonalJobBankJobDetails = "PersonalJobBank/JobDetails"
    static  var PersonalJobBankManageDeclineJob = "PersonalJobBank/ManageDeclineJob"
    static  var PersonalJobBankManageWaitList = "PersonalJobBank/ManageWaitList"
    static  var PersonalJobBankManageReAccept = "PersonalJobBank/ManageReAccept"
    static  var TimeSlipOncallcounselSaveExpenses = "TimeSlip/OncallcounselSaveExpenses"
    static  var TimeSlipDeleteUploadedFiles = "TimeSlip/DeleteUploadedFiles"
    static  var AccountGetAPiVersion = "Account/GetAPiVersion"
    static  var AccountInsertProfilePicture = "Account/InsertProfilePicture"
    static  var AssignmentsVaryOrderSchedule = "Assignments/VaryOrderSchedule"
    static  var PersonalJobBankVaryOrderSchedule = "PersonalJobBank/VaryOrderSchedule"
    static  var FormsAndDocumentsInsertFormsAndDocumentsDetails = "FormsAndDocuments/InsertFormsAndDocumentsDetails"
    static  var TimeSlipNext = "TimeSlip/EnterTimeSlipNext"
    static  var ClearSchedule = "Avalability/ClearAvailability"
    //refer an job/friend
    static  var ReferalGetJobCategoryList  = "Referal/GetJobCategoryList"
    static  var ReferalGetJobType   = "Referal/GetJobType"
    static  var ReferalGetJobDetails  = "Referal/GetJobDetails"
    static  var GetReferalApplicantList = "Referal/GetReferalApplicantList"
    static  var ReferalShowComissions = "Referal/ShowComissions"
    static  var SendEmail = "Referal/SentMail"
    static  var ApplyJob = "Account/PostEmployeeInfo"
    //paystubs
    static  var GetAllPayStubs = "Paystubs/GetAllPaystubs"
    static  var GetPayStubs = "Paystubs/GetPaystubs"
    static  var PrintPayStub = "Paystubs/PrintPayStubs"
    
    //demo candidates
    static  var DemoCandidateList = "Account/DemoCandidatesList"
    
    //manage profile
    static var GetResumeList =  "UploadResume/UploadResume"
    static var UploadResume =   "UploadResume/UploadResumeFile"
    static var UploadPhoto =    "GetPhotos"
    static var UploadProfile = "DisplayUpdateEmployeeProfile"
    static var UploadCredsList = "GetCredentials"
    static var UploadCred = "UploadCredentials"
    static var DeleteCred = "DeleteCredentialsDocument"
    static var DisplayFromsAndDocuments = "DisplayFromsAndDocuments"
    
    //eTimeClock
    static var GetAssignments = "ETimeClock/CandOrderByLogInTime"
    static var ViewHistory    = "ETimeClock/ViewHistory"
    static var EnterNewDay    = "ETimeClock/InsertNewDay"
    static var EditDay        = "ETimeClock/UpdateDay"
    static var UpdateAssignment = "ETimeClock/EtimeClockCandLogTimes"
    static var GetETCDetails  = "ETimeClock/GetETCDetails"
    static var EtimeClockEnterTimeSlips = "ETimeClock/EnterTimeSlip"
    static var ETimeClockSubmitTimeSlip = "ETimeClock/SubmitTimeSlip"
    static var ETimeClockGetETCNewDay = "ETimeClock/GetETCNewDay"
    static var GetParticularDayDetails = "ETimeClock/EditTimeSheet"
    
    //UPK A-Series Forms
    //A1 Form
//    static var GetA1Series        = "UPKASeries/GetA1Series"
    static var GetA1Series        = "Forms/A1Series" // viv - newly added
    static var GetA2Series        = "Forms/A2Series" // viv - newly added
    static var GetA3Series        = "Forms/A3Series" // viv - newly added
    
    //Additional Forms Viv
    
    static var GetDocForm         = "AdditionalForms/DocGoConsent" // viv - newly added
    static var FCRAAuth           = "AdditionalForms/FCRAAuthForm" // viv - newly added
    static var FCRANYForm         = "AdditionalForms/FCRANYForm" // viv - newly added
    static var WorkRefForm        = "AdditionalForms/WorkReferences" // viv - newly added
    static var FairChanceForm     = "AdditionalForms/FairChanceActNotice" // viv - newly added
    static var eVerifyForm        = "AdditionalForms/eVerify" // viv - newly added
    static var I9Form             = "AdditionalForms/I9Form" // viv - newly added
    static var BGClForm           = "AdditionalForms/BackgroundClearance" // viv - newly added
    static var ConInfoForm        = "AdditionalForms/ConfidentialInfo" // viv - newly added
    static var DrugTestForm       = "AdditionalForms/DrugTesting" // viv - newly added
    static var HepBForm           = "AdditionalForms/HepB"// viv - newly added
    static var StateTaxForm       = "AdditionalForms/StateTax" // viv - newly added
    static var TaxInfoW4Form      = "AdditionalForms/TaxInfoW4" // viv - newly added
    static var CredentialsForm    = "AdditionalForms/Credentials" // viv - newly added
    static var CEForm             = "AdditionalForms/ClinicalExperience" // viv - newly added
    static var FLIForm            = "AdditionalForms/FLI" // viv - newly added
    static var CEPAForm           = "AdditionalForms/CEPA" // viv - newly added
    static var FDForm             = "AdditionalForms/FCRAForm" // viv - newly added
    static var FCDForm            = "AdditionalForms/FCRACAForm" // viv - newly added
    
    
    static var FormsPoliciesAndProcedures        = "Forms/PoliciesAndProcedures" // viv - newly added
    static var FormsDisclosureContent        = "Forms/DisclosureContent" // viv - newly added
    static var FormsOCCConfidentiality        = "Forms/OCCConfidentiality" // viv - newly added
    static var InsertA1Address    = "UPKASeries/InsertA1Address"
    static var DeleteA1Address = "UPKASeries/DeleteA1Address"
    static var EditA1Address = "UPKASeries/EditA1Address"
    static var AlaisNameInsert = "UPKASeries/AlaisNameInsert"
    static var AliasNameEdit = "UPKASeries/AliasNameEdit"
    static var AliasNameDelete = "UPKASeries/AliasNameDelete"
    static var InsertA1Series = "UPKASeries/InsertA1Series"
    
    //A2 Form
    static var GetUPKA2Detail = "UPKASeries/GetUPKA2Detail"
    static var InsertUPKA2Detail = "UPKASeries/InsertUPKA2Detail"
    
    //SCR ConsentForm
    static var GetSCRForm = "SCRConsent/GetSCRForm"
    static var SubmitSCRForm = "SCRConsent/SubmitSCRForm"
    static var GetSCRConsentForm = "SCRConsent/GetSCRConsentForm"
    static var AddHouseHoldMember = "SCRConsent/AddHouseHoldMember"
    static var UpdateHouseHoldMember = "SCRConsent/UpdateHouseHoldMember"
    static var DeleteHouseHoldMemeber = "SCRConsent/DeleteHouseHoldMemeber"
    static var AddSCRAddress = "SCRConsent/AddSCRAddress"
    static var SCREditAddress = "SCRConsent/SCREditAddress"
    static var DeleteAddress = "SCRConsent/DeleteAddress"
    static var SubmitSCRFormData = "SCRConsent/SubmitSCRFormData"
    static var GeneratePrintPDF = "GeneratePDF/GeneratePrintPDF"
    static var GetSCRValidate = "SCRConsent/GetSCRValidate"
    
    //locationServices
    static var UpdateLocation = "Account/InsertCandidateLocationTracking"
    static var ChangeLocationStatus = "Account/updatecandidatedeviceActiveinfo"
    
    //update cand device
    static var UpdateCandDevice = "Account/UpdateCandidatedeviceInfo"
    
    //update PushNotifications
    static var UpdateNotificationsStatus = "Account/InsertPushNotificationdetails"
    
    //getListOfPush
    static var GetListOfPush    = "Account/GetAutosendPushnotificationByCandidate"
    static var PushClicked      = "Account/updateCandidatePushNotificationSeenInfo"
    
    
    //scrpopup
    static var SCRpopupdetails = "Account/ShowPopUpDetails"
    static var ScrAddAddress = "Account/AddAddressDetails"
    static var SubmitSCR = "Account/UpdateCandidateDate"
    
    //GlobalPopupFormOkCLick
    static var GlobalFormSubmit = "Account/InsertCoronaPopUpDetails"
    
    // UpdateUserDetailsToServer
    static var EditSmsDetails = "Account/EditSmsDetails"
    static var GetcandidateSmsDetails = "Account/GetcandidateSmsDetails"
    
    //Color
    static var alertRed = #colorLiteral(red: 0.853351295, green: 0.3270158172, blue: 0.3127526641, alpha: 1)
    static var alertRedBg = #colorLiteral(red: 0.9495584369, green: 0.8718144298, blue: 0.8732326627, alpha: 1)
    
    static var alertGreen = #colorLiteral(red: 0.2352941176, green: 0.462745098, blue: 0.2392156863, alpha: 1)
    static var alertGreenBg = #colorLiteral(red: 0.8745098039, green: 0.9411764706, blue: 0.8470588235, alpha: 1)
    
    //splash pass
    static var splash = false
    
    //loginapi
    static func loginByMobileNumber(_ view:UIViewController,params:[String:String],method:String,callBack:@escaping (AnyObject)->()) {
        
        let urlString = ServerService.BaseUrl+ServerService.Login
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: "", acces: false, callback: callBack)
    }
    //changePassword
    static func changePassword(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->())  {
        
        let urlString = ServerService.BaseUrl+ServerService.ChangePassword
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: acces, callback: callBack)
    }
    //ForgotPassword
    static func forgotPassword(_ view:UIViewController,params:[String:String],method:String,callBack:@escaping (AnyObject)->()) {
        
        let urlString = ServerService.BaseUrl+ServerService.Forgotpassword
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken: "", acces: false, callback: callBack)
    }
    //getListOfAssignments
    static func getListOfAssignments(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = ServerService.BaseUrl+ServerService.ListOfAssignments
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
    }
    //getMessages
    static func getMessages(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = ServerService.BaseUrl+ServerService.GetMessages
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: acces, callback: callBack)
    }
    //deleteMessage
    static func deleteMessage(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = ServerService.BaseUrl+ServerService.DeleteMessage
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: acces, callback: callBack)
    }
    //getOrderDetails
    static func getOrderDetails(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = ServerService.BaseUrl+ServerService.AssignmentDetail
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
    }
    //getAvailability
    static func getAvailability(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = ServerService.BaseUrl+ServerService.GetAvailability
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
    }
    //respondToMessage
    static func respondToMessage(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = ServerService.BaseUrl+ServerService.RespondToMessage
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
    }
    //submitAvailability
    static func submitAvailability(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = ServerService.BaseUrl+ServerService.SubmitAvailability
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
    }
    
    //getTimeDetailsAvailability
    static func getTimeDetailsAvailability(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = ServerService.BaseUrl+ServerService.GetTimeDetailsAvailability
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
    }
    //viewTimeSlip
    static func viewTimeSlip(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = ServerService.BaseUrl+ServerService.ViewTimeSlips
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
    }
    //getTimeSlipReport
    static func getTimeSlipReport(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.GetTimeSlipReport
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
    }
    //getpersonalJobBank
    static func getpersonalJobBank(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.PersonalJobBank
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
    }
    //getEnterTimeSlipWeekEnds
    static func getEnterTimeSlipWeekEnds(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.GetEnterTimeSlipDates
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
    }
    //getTimeSlipAssignments
    static func getTimeSlipAssignments(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.GetTimeSlipAssignments
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
        
    }
    //getEnterTimeSlip
    static func getEnterTimeSlip(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.EnterTimeSlip
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
        
    }
    //getDuplicateTimeSlips
    static func getDuplicateTimeSlips(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.DuplicateTimeSlips
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
        
    }
    //getInsertPendingTimeSlip
    static func getInsertPendingTimeSlip(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.InsertPendingTimeSlip
        //ANLoader.hide()
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
        
    }
    //getOncallcounselWeekEnding
    static func getOncallcounselWeekEnding(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.OncallcounselWeekEnding
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
    }
    //getOncallcounselWeekEndTimeEntry
    static func getOncallcounselWeekEndTimeEntry(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.OncallcounselWeekEndTimeEntry
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
    }
    //getOncallcounselSaveTimeList
    static func getOncallcounselSaveTimeList(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.OncallcounselSaveTimeList
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
    }
    //getOncallcounselSaveTimeList
    static func getOnCallcounselDeleteTimeSlip(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.OnCallcounselDeleteTimeSlip
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
    }
    
    
    //getOnCallcounselSaveWeeklyTime
    static func getOnCallcounselSaveWeeklyTime(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.OnCallcounselSaveWeeklyTime
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: acces, callback: callBack)
    }
    
    //getEnterTimeSlipDOEEnterTimeSlip
    static func getEnterTimeSlipDOEEnterTimeSlip(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.EnterTimeSlipDOEEnterTimeSlip
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: acces, callback: callBack)
    }
    
    //getDoeEnterTimeSlipSubmitDOEEnterTimeSlip
    static func getDoeEnterTimeSlipSubmitDOEEnterTimeSlip(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.DoeEnterTimeSlipSubmitDOEEnterTimeSlip
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: acces, callback: callBack)
    }
    
    //getAccountEWAMenuLinks
    static func getAccountEWAMenuLinks(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.AccountEWAMenuLinks
        ServerService.getRequest(viewController:view, urlString: urlString, params: params,method:method, accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //getRejectJob
    static func getRejectJob(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.RejectJob
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
    }
    //getAcceptJob
    static func getAcceptJob(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.AcceptJob
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
    }
    //getPersonalJobBankJobDetails
    static func getPersonalJobBankJobDetails(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.PersonalJobBankJobDetails
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
    }
    //getPersonalJobBankManageDeclineJob
    static func getPersonalJobBankManageDeclineJob(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.PersonalJobBankManageDeclineJob
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
    }
    //getPersonalJobBankManageWaitList
    static func getPersonalJobBankManageWaitList(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.PersonalJobBankManageWaitList
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
    }
    //getPersonalJobBankManageReAccept
    static func getPersonalJobBankManageReAccept(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.PersonalJobBankManageReAccept
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
    }
    //getTimeSlipOncallcounselSaveExpenses
    static func getTimeSlipOncallcounselSaveExpenses(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.TimeSlipOncallcounselSaveExpenses
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
    }
    //getTimeSlipDeleteUploadedFiles
    static func getTimeSlipDeleteUploadedFiles(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.TimeSlipDeleteUploadedFiles
        //ANLoader.showLoading("", disableUI: true)
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
    }
    //getAccountGetAPiVersion
    static func getAccountGetAPiVersion(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.AccountGetAPiVersion
        ServerService.getRequest(viewController:view, urlString: urlString, params: params, method:method,accessToken:"",acces:false,callback: callBack)
    }
    
    //AccountInsertProfilePicture
    static func AccountInsertProfilePicture(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        var parameters = params
        parameters["UploadSource"] = "2"
        let urlString = ServerService.BaseUrl+ServerService.AccountInsertProfilePicture
        ServerService.getRequest(viewController:view, urlString: urlString, params: parameters, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    //AssignmentsVaryOrderSchedule
    static func assignmentsVaryOrderSchedule(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.AssignmentsVaryOrderSchedule
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    //PersonalJobBankVaryOrderSchedule
    static func personalJobBankVaryOrderSchedule(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.PersonalJobBankVaryOrderSchedule
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    //FormsAndDocumentsInsertFormsAndDocumentsDetails
    static func formsAndDocumentsInsertFormsAndDocumentsDetails(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.FormsAndDocumentsInsertFormsAndDocumentsDetails
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    //timeSlipNext
    static func timeSlipNext(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.TimeSlipNext
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    //clearSchedule
    static func clearSchedule(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.ClearSchedule
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    //referalGetJobCategoryList
    static func referalGetJobCategoryList(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.ReferalGetJobCategoryList
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    //ReferalGetJobType
    static func referalGetJobType(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.ReferalGetJobType
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    //ReferalGetJobDetails
    static func referalGetJobDetails(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.ReferalGetJobDetails
        print("***VIVEK \(urlString)*****")
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    //ReferalShowComissions
    static func referalShowComissions(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.ReferalShowComissions
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    //GetReferalApplicantList
    static func getReferalApplicantList(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.GetReferalApplicantList
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    //SendEmail
    static func sendEmail(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.SendEmail
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //GetAllPayStubs
    static func getAllPayStubs(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.GetAllPayStubs
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //GetAllPayStubs
    static func getPayStubs(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.GetPayStubs
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //PrintPayStub
    static func printPayStub(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.PrintPayStub
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //DemoCandidateList
    static func gemoCandidateList(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.DemoCandidateList
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    
    //manage Profile
    
    //upload resume list
    static func resumeList(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.GetResumeList
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //upload resume
    static func uploadResume(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.UploadResume
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    
    //upload photo list
    static func getPhotoList(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.UploadPhoto
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //upload profile
    static func getUploadProfile(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.UploadProfile
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //UploadCreds
    static func getUploadCreds(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.UploadCredsList
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //uploadCred
    static func uploadCred(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.UploadCred
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    //deleteCred
    static func deleteCred(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.DeleteCred
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    
    //DisplayFromsAndDocuments
    static func getDisplayFromsAndDocuments(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.DisplayFromsAndDocuments
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    
    
    //eTimeClock
    
    //getAssignments
    static func getAssignments(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.GetAssignments
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    //viewHistory
    static func getViewHistory(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.ViewHistory
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //EnterNewDay
    static func enterNewDay(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.EnterNewDay
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //editDay
    static func editDay(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.EditDay
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    
    //EtimeClockEnterTimeSlips
    static func EtimeClockEnterTimeSlips(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.EtimeClockEnterTimeSlips
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
        
    }
    
    //ETimeClockSubmitTimeSlip
    static func ETimeClockSubmitTimeSlip(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()){
        let urlString = ServerService.BaseUrl+ServerService.ETimeClockSubmitTimeSlip
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: accessToken, acces: true, callback: callBack)
    }
    
    //UpdateAssignment
    static func updateAssignment(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.UpdateAssignment
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //GetETCDetails
    static func GetETCDetails(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.GetETCDetails
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //GetParticularDayDetails
    static func getParticularDayData(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.GetParticularDayDetails
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //ETimeClockGetETCNewDay
    static func ETimeClockGetETCNewDay(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.ETimeClockGetETCNewDay
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    //ApplyJob
    static func applyJob(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.ApplyJob
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    //UpdateLocation
    static func updateLocation(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        let urlString = ServerService.BaseUrl+ServerService.UpdateLocation
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //ChangeLocationStatus
    static func changeLocationStatus(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        let urlString = ServerService.BaseUrl+ServerService.ChangeLocationStatus
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //UpdateDevice
    static func updateDeviceId(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        let urlString = ServerService.BaseUrl+ServerService.UpdateCandDevice
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:false,callback: callBack)
    }
    
    //Update NotificationsStatus
    
    static func updateNotificationStatus(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        let urlString = ServerService.BaseUrl+ServerService.UpdateNotificationsStatus
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //GetListOfPush
    static func getListOfPush(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        let urlString = ServerService.BaseUrl+ServerService.GetListOfPush
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:false,callback: callBack)
    }
    //Update Notififcation Seen
    static func updateNotificationSeen(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        let urlString = ServerService.BaseUrl+ServerService.PushClicked
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:false,callback: callBack)
    }
    //SCR Form
    static func scrDetails(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        let urlString = ServerService.BaseUrl+ServerService.SCRpopupdetails
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    static func scrAddAddress(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        let urlString = ServerService.BaseUrl+ServerService.ScrAddAddress
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    static func submitSCR(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        let urlString = ServerService.BaseUrl+ServerService.SubmitSCR
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    
    //GlobalFormSubmitOkClick
    static func submitglobalForm(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        let urlString = ServerService.BaseUrl+ServerService.GlobalFormSubmit
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //EditSmsDetails
    static func EditSmsDetails(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        let urlString = ServerService.BaseUrl+ServerService.EditSmsDetails
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //GetcandidateSmsDetails
    static func GetcandidateSmsDetails(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        let urlString = ServerService.BaseUrl+ServerService.GetcandidateSmsDetails
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //UPK A1SeriesForms
    static func getA1FormData(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.GetA1Series
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //UPK A2SeriesForms
    static func getA2FormData(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.GetA2Series
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //UPK A3SeriesForms
    static func getA3FormData(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.GetA3Series
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //UPK DocGoConsentForms - Additional Form
    static func getDocGoConsentFormData(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.GetDocForm
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //FCRA Authorization Form - Additional Form
    static func getFCRAAuthForm(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.FCRAAuth
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //FCRA NY Disclosure Form - Additional Form
    static func getFCRANYDisclosureForm(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.FCRANYForm
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //Work Reference Form - Additional Form
    static func getWorkReferenceForm(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.WorkRefForm
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //Fair Chance Form - Additional Form
    static func getFairChanceForm(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.FairChanceForm
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //eVerify Form - Additional Form
    static func geteVerifyForm(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.eVerifyForm
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //I9 Form - Additional Form
    static func getI9Form(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.I9Form
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //BGC Form - Additional Form
    static func getBGCForm(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.BGClForm
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //CI Form - Additional Form
    static func getCIForm(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.ConInfoForm
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //DT Form - Additional Form
    static func getDTForm(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.DrugTestForm
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //HepB Form - Additional Form
    static func getHepBForm(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.HepBForm
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //State Tax Form - Additional Form
    static func getStateTaxForm(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.StateTaxForm
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //Tax Info W4 Form - Additional Form
    static func getTaxInfoW4Form(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.TaxInfoW4Form
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //Credentials Form - Additional Form
    static func getCredentialsForm(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.CredentialsForm
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //CE Form - Additional Form
    static func getCEForm(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.CEForm
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //FLI Form - Additional Form
    static func getFLIForm(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.FLIForm
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //CEPA Form - Additional Form
    static func getCEPAForm(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.CEPAForm
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //FCRA Disclosure Form - Additional Form
    static func getFCRADisclosureForm(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.FDForm
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //FCRA CA Disclosure Form - Additional Form
    static func getFCRACADisclosureForm(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.FCDForm
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //UPK FormsPoliciesAndProcedures
    static func getFormsPoliciesAndProcedures(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.FormsPoliciesAndProcedures
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //UPK FormsDisclosureContent
    static func getFormsDisclosureContent(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.FormsDisclosureContent
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //UPK FormsOCCConfidentiality
    static func getFormsOCCConfidentiality(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.FormsOCCConfidentiality
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    
    static func InsertA1Address(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.InsertA1Address
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    
    static func EditA1Address(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.EditA1Address
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    static func DeleteA1Address(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.DeleteA1Address
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    static func InsertA1Series(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.InsertA1Series
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    static func AliasNameEdit(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.AliasNameEdit
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    static func AliasNameDelete(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.AliasNameDelete
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    static func AlaisNameInsert(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.AlaisNameInsert
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //A2 Form
    
    static func GetUPKA2Detail(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.GetUPKA2Detail
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    static func InsertUPKA2Detail(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.InsertUPKA2Detail
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    // SCR Form
    static func GetSCRForm(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.GetSCRForm
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    static func SubmitSCRForm(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.SubmitSCRForm
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    
    static func GetSCRConsentForm(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.GetSCRConsentForm
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    
    static func AddHouseHoldMember(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.AddHouseHoldMember
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    //
    static func UpdateHouseHoldMember(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.UpdateHouseHoldMember
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    static func DeleteHouseHoldMemeber(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.DeleteHouseHoldMemeber
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    static func AddSCRAddress(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.AddSCRAddress
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    static func SCREditAddress(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.SCREditAddress
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    static func DeleteAddress(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.DeleteAddress
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    //
    
    static func SubmitSCRFormData(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.SubmitSCRFormData
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    static func GeneratePrintPDF(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.GeneratePrintPDF
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    
    static func GetSCRValidate(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping(AnyObject)->()){
        
        let urlString = ServerService.BaseUrl+ServerService.GetSCRValidate
        ServerService.getRequestWithToken(viewController:view, urlString: urlString, params: params, method:method,accessToken:accessToken,acces:acces,callback: callBack)
    }
    
    //requestApi
    static func getRequest(viewController:UIViewController,urlString:String,params:[String:Any],method:String,accessToken:String,acces:Bool,callback:@escaping (AnyObject)->())
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            DispatchQueue.global(qos:.userInitiated).async {
                
                if urlString == ServerService.BaseUrl+ServerService.AccountGetAPiVersion
                {
                    
                }
                else
                {
                    OperationQueue.main.addOperation
                    {
                        if UserDefaults.standard.bool(forKey:"remember")
                        {
                            
                        }
                        else
                        {
                            if UserDefaults.standard.bool(forKey:"timeout")
                            {
                                TimeOutClass.sharedInstance.resetTimer()
                            }
                        }
                    }
                }
                
                let config = URLSessionConfiguration.default
                config.timeoutIntervalForRequest = TimeInterval(60)
                config.timeoutIntervalForResource = TimeInterval(60)
                let urlSession = Foundation.URLSession(configuration: config)
                
                let urlString = urlString
                var request = URLRequest(url: URL(string:urlString)!)
                request.httpMethod = method
                request.timeoutInterval = 60 
                if acces
                {
                    request.setValue("Basic \(accessToken)", forHTTPHeaderField: "Authorization")
                }
                let postString:[String:Any] = params
                
                //HTTP Headers
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
                    
                } catch let error {
                    print(error.localizedDescription)
                }
                
                urlSession.dataTask(with:request) { (data, response, error) in
                    if error != nil
                    {
                        
                        print("error is ",error!)
                        if error?._code ==  NSURLErrorTimedOut {
                            print("Time Out")
                            debugPrint("timeOut")
                            print("Time Out")
                            DispatchQueue.main.async {
                                self.json = JSON.null
                                callback(self.json as AnyObject)

                                    ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:viewController)

                            
                            }
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                self.json = JSON.null
                                callback(self.json as AnyObject)
                            }
                        }
                    }
                    else
                    {
                        print(response!)
                        let httpResponse = response as? HTTPURLResponse
                        print("statusCode: \(httpResponse!.statusCode)")
                        if httpResponse!.statusCode == 417
                        {
                            DispatchQueue.main.async {
                                self.json = JSON.null
                                callback(self.json as AnyObject)
                                ServerService.LogOut(message:"Session Expired", viewController:viewController)
                            }
                        }
                        else
                        {
                            self.json = JSON(data!)
                            OperationQueue.main.addOperation
                            {
                                callback(self.json as AnyObject)
                                if urlString == ServerService.BaseUrl+ServerService.AccountGetAPiVersion
                                {
                                    
                                }
                                else
                                {
                                    if UserDefaults.standard.bool(forKey:"remember")
                                    {
                                        
                                    }
                                    else
                                    {
                                        if UserDefaults.standard.bool(forKey:"timeout")
                                        {
                                            TimeOutClass.sharedInstance.runTimer()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }.resume()
                urlSession.finishTasksAndInvalidate()
            }
        }
        else
        {
            DispatchQueue.main.async {
                self.json = JSON.null
                callback(self.json as AnyObject)
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:viewController)
            }
        }
    }
    
    
    //requestApiForOrder
    static func getRequestWithToken(viewController:UIViewController,urlString:String,params:[String:Any],method:String,accessToken:String,acces:Bool,callback:@escaping(AnyObject)->())
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            if Constants.version
            {
                OperationQueue.main.addOperation
                {
                    if UserDefaults.standard.bool(forKey:"remember")
                    {
                        
                    }
                    else
                    {
                        if UserDefaults.standard.bool(forKey:"timeout")
                        {
                            TimeOutClass.sharedInstance.resetTimer()
                        }
                    }
                }
                //ANLoader.showLoading("", disableUI: true)
                DispatchQueue.global(qos:.background).async {
                    
                    let config = URLSessionConfiguration.default
                    config.timeoutIntervalForRequest = TimeInterval(60)
                    config.timeoutIntervalForResource = TimeInterval(60)
                    let urlSession = Foundation.URLSession(configuration: config)
                    
                    
                    let urlString = urlString
                    var request = URLRequest(url: URL(string:urlString)!)
                    request.httpMethod = method
                    request.timeoutInterval = 60
                    
                    if acces
                    {
                        print("Basic \(accessToken)")
                        request.setValue("Basic \(accessToken)", forHTTPHeaderField: "Authorization")
                    }
                    
                    let postString:[String:Any] = params
                    do {
                        request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
                        
                    } catch let error {
                        print(error.localizedDescription)
                    }
                    
                    //HTTP Headers
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("application/json", forHTTPHeaderField: "Accept")
                    
                    urlSession.dataTask(with:request) { (data, response, error) in
                        if error != nil
                        {
                            
                            print("error is ",error!)
                            if error?._code ==  NSURLErrorTimedOut {
                                print("Time Out from 1282")
                                DispatchQueue.main.async {
                                    self.json2 = JSON.null
                                    callback(self.json2 as AnyObject)
                                    ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:viewController)
                                }
                            }
                            else
                            {
                                DispatchQueue.main.async {
                                    self.json2 = JSON.null
                                    callback(self.json2 as AnyObject)
                                }
                            }
                            print("error is ",error!.localizedDescription)
                            
                        }
                        else
                        {
                            print(response!)
                            let httpResponse = response as? HTTPURLResponse
                            print("statusCode: \(httpResponse!.statusCode)")
                            if httpResponse!.statusCode == 417
                            {
                                
                                DispatchQueue.main.async {
                                    self.json2 = JSON.null
                                    callback(self.json2 as AnyObject)
                                    ServerService.LogOut(message:"Session Expired", viewController:viewController)
                                    
                                }
                            }
                            else
                            {
                                self.json2 = JSON(data!)
                                OperationQueue.main.addOperation
                                {
                                    
                                    if self.json2["Message"].stringValue == "Authorization has been denied for this request."
                                    {
                                        DispatchQueue.main.async(execute: { () -> Void in
                                            ServerService.LogOut(message:"You cannot access this app at this time.", viewController:viewController)
                                        })
                                    }
                                    else
                                    {
                                        if UserDefaults.standard.bool(forKey:"remember")
                                        {
                                            
                                        }
                                        else
                                        {
                                            if UserDefaults.standard.bool(forKey:"timeout")
                                            {
                                                TimeOutClass.sharedInstance.runTimer()
                                            }
                                        }
                                        callback(self.json2 as AnyObject)
                                    }
                                }
                            }
                        }
                    }.resume()
                    urlSession.finishTasksAndInvalidate()
                }
            }
            else
            {
                DispatchQueue.main.async {
                    self.json2 = JSON.null
                    callback(self.json2 as AnyObject)
                    ServerService.ShowAlertMessageForUpdate(ErrorMessage:"New version of the app is available in the app store please update", title: "Update Available", view:viewController)
                }
            }
        }
        else
        {
            DispatchQueue.main.async {
                self.json2 = JSON.null
                callback(self.json2 as AnyObject)
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:viewController)
            }
        }
    }
    
    
    static func LogOut(message:String,viewController:UIViewController)
    {
        let alert = UIAlertController(title:message, message: "", preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "Ok",
                               style: .default) { (action: UIAlertAction!) -> Void in
            
            Constants.menuHeaders.removeAll()
            Constants.menuSectionLogos.removeAll()
            Constants.menuSections.removeAll()
            Constants.menuObjj.removeAll()
            Constants.titleImages.removeAll()
            Constants.dashObject = JSON.null
            TimeOutClass.sharedInstance.resetTimer()
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            (UIApplication.shared.delegate as? AppDelegate)?.APSlocation_Set_up()
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ewaLogin") as! LoginViewController
            UIApplication.shared.keyWindow?.rootViewController = viewController
            
        }
        alert.addAction(ok)
        viewController.present(alert, animated:true, completion:nil)
    }
    
    
    
    
    
    //AlertView
    static func ShowAlertMessage(ErrorMessage : String,title:String,view:UIViewController){
        DispatchQueue.main.async(execute: { () -> Void in
            
            let alert = UIAlertController(title:title, message: ErrorMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            view.present(alert, animated: true, completion: nil)
            
        })
        
    }
    
    static func ShowAlertMessageforSplash(ErrorMessage: String, title: String, view: UIViewController) {
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: title, message: ErrorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ImageVC") as! ImageViewController
                
                // Update the window's rootViewController for iOS 13 and later
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.rootViewController = viewController
                    window.makeKeyAndVisible()
                }
            }))
            view.present(alert, animated: true, completion: nil)
        }
    }

    
    //AlertView
    static func ShowAlertMessageForUpdate(ErrorMessage : String,title:String,view:UIViewController){
        DispatchQueue.main.async(execute: { () -> Void in
            
            let alert = UIAlertController(title:title, message: ErrorMessage, preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            let updateButton = UIAlertAction(title:"Update", style: .default) { (action:UIAlertAction) in
                print("Call API");
                print("No update")
                guard let url = URL(string:UserDefaults.standard.object(forKey:"AppLink") as! String) else {
                    return
                }
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
                Constants.menuHeaders.removeAll()
                Constants.menuSectionLogos.removeAll()
                Constants.menuSections.removeAll()
                Constants.titleImages.removeAll()
                Constants.menuObjj.removeAll()
                Constants.dashObject = JSON.null
                TimeOutClass.sharedInstance.resetTimer()
                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                (UIApplication.shared.delegate as? AppDelegate)?.APSlocation_Set_up()
            }
            alert.addAction(updateButton)
            view.present(alert, animated: true, completion: nil)
            
        })
        
    }
    
    
    
    //Spinner
    static func spinner(view:UIViewController)
    {
        
        ServerService.myIndicator=UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        ServerService.myIndicator.center = view.view.center
        ServerService.myIndicator.startAnimating()
        ServerService.myIndicator.hidesWhenStopped=true
        view.view.addSubview(ServerService.myIndicator)
    }
    
    
    
    //activity indicator method
    static func showActivityIndicatory(uiView: UIView) {
        
        
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor.uicolorFromHex(0xffffff, alpha: 0.1)
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor.black
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        loadingView.tag = 1001
        
        //let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        actInd.center = CGPoint(x: loadingView.frame.size.width/2, y: loadingView.frame.size.height/2);
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        let window = UIApplication.shared.keyWindow!
        window.addSubview(loadingView)
        //uiView.addSubview(container)
        actInd.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    //removing the activity indicator
    static func hideProgressView() {
        ServerService.myIndicator.stopAnimating()
        ServerService.myIndicator.stopAnimating()
        container.removeFromSuperview()
        let window = UIApplication.shared.keyWindow!
        window.viewWithTag(1001)?.removeFromSuperview()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    //activity indicator method
    static func showActivityIndicatoryOnView(uiView: UIView) {
        
        
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor.uicolorFromHex(0xffffff, alpha: 0.1)
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor.black
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        loadingView.tag = 1001
        
        //let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorView.Style.whiteLarge
        actInd.center = CGPoint(x: loadingView.frame.size.width/2, y: loadingView.frame.size.height/2);
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        //        let window = UIApplication.shared.keyWindow!
        //        window.addSubview(loadingView)
        //        window.bringSubviewToFront(loadingView)
        uiView.addSubview(container)
        actInd.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    
    
    
}



// use to check if internet connection is there or not
public class ConnectionCheck {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}

extension UIViewController {
    @objc dynamic func _tracked_viewWillAppear(_ animated: Bool) {
        //  NSLog("Enter screen: \(type(of: self))")
        print("ScreenName:--> "+String(describing: type(of: self)))
        _tracked_viewWillAppear(animated)
    }
    
    static func swizzle() {
        //Make sure This isn't a subclass of UIViewController,
        // So that It applies to all UIViewController childs
        if self != UIViewController.self {
            return
        }
        let _: () = {
            let originalSelector =
                #selector(UIViewController.viewWillAppear(_:))
            let swizzledSelector =
                #selector(UIViewController._tracked_viewWillAppear(_:))
            let originalMethod =
                class_getInstanceMethod(self, originalSelector)
            let swizzledMethod =
                class_getInstanceMethod(self, swizzledSelector)
            method_exchangeImplementations(originalMethod!, swizzledMethod!);
        }()
    }
}



