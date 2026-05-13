//
//  RestAPI.swift
//  CWA
//
//  Created by NFC Solutionsusa on 02/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//
/*
 21930
 
 */
import UIKit
import SwiftyJSON

class RestAPI: NSObject {
    static let shared = RestAPI()
    private override init() {
        
    }
    static var json: JSON = JSON.null
    
    //    let REQUEST_TIME_OUT = 45
        
    static var ProductionURL = "https://apps.tempositions.com/TempositionsCWA_API/CWAAPI/"
    static var DevelopmentURL = "http://tempositionsdev.com/TemPositionsCMAAPIDEV/CWAAPI/"
    static var StagingURL = "https://apps.tempositions.com/TemPositionsCMAAPIUAT/CWAAPI/"
    
    //https://apps.tempositions.com/TemPositionsCMAAPIDEV/CWAAPI/ - old Dev URL
 
    static var BaseUrl = ProductionURL
    
    static var ProductionAppVersion = "\(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)"
    static var DevelopmentAppVersion = "1.0.55"
    
    static var displayVersion: String {
        if RestAPI.BaseUrl == RestAPI.ProductionURL {
            return RestAPI.ProductionAppVersion
        }
         else {
            return RestAPI.DevelopmentAppVersion
        }
    }
    
    static let Login =                                 "Account/Login"
    static let ChangePassword =                        "Account/ChangePassword"
    static var Forgotpassword =                        "Account/ForgotPassword"
    static let ListOfDivisions =                       "Account/Divisions"
    static let MenuListURL =                           "Account/MenuLinks"
    static let ActiveOrdersURL =                       "ActiveOrders/ActiveOrdersReport"
    static let historicOrder =                         "RapidOrderSystem/DoeOrdersGrid"
    static let historicOrderDetailsURL =               "RapidOrderSystem/DoeConfirmOrder"
    static let getWeeklyStaffingSchduleURL =           "WeeklyStaffing/GetScheduleSchool"
    static let weeklyStaffingOrderDetailsURL =         "WeeklyStaffing/ScheduleDetails"
    static let GetTimeSheetTimeSlipURL =               "ApproveTimeSheet/GetTimeslips"
    static let GetEvaluateEmployeeURL =                "ApproveTimeSheet/GetEvaluateEmployee"
    static let ApproveTimeSheetDetailsURL =            "ApproveTimeSheet/ApproveTimeSheetDetails"
    static let EmpWithNoTimeSlipURL =                  "ApproveTimeSheet/RetNoTimeSlipList"
    static let InsertEmployeeURL =                     "ApproveTimeSheet/InsertEvaluateEmployee"
    static let approvePendingTSURL =                   "ApproveTimeSheet/ApproveTimeSheet"
    static let AgreementSignURL =                      "TimeSlip/AgreementSign"
    static let approveEmpUsageAgreementURL =           "TimeSlip/Agreement"
    static let approveTSViewAttorneyURL =              "ApproveTimeSheet/ViewAttorney"
    static let approveTSAttonerySubmitURL =            "ApproveTimeSheet/AttonerySubmit"
    static let viewApproveTSPDFURL =                   "ApproveTimeSheet/DOHTimeCardPDF"
    static let TimeSlipOrderSelect =                   "TimeSlip/OrderSelect"
    static let TimeSlipEnterEmployeeeTimeslips =       "TimeSlip/EnterEmployeeeTimeslips"
    static let getWeeklyStaffingSchdulePDFURL =        "WeeklyStaffing/GetSchedule"
    static let TimeSlipInsertPendingTimeSlip =         "TimeSlip/InsertPendingTimeSlip"
    static let GetApprovedList_URL =                  "ViewApprovedTimeSheet/GetApprovedList"
    static let GetApproved_Details_URL =              "ViewApprovedTimeSheet/ViewDetails"
    
    //SCHOOL PROFESSIONAL URLs
    static let ROSSchoolProfessionalValidationURL =   "RosSchoolProfessionals/RosSchoolValidation"
    static let getROSSchoolProfesOrdersURL =          "RosSchoolProfessionals/GetOrder"
    static let getSearchedEmpROSSchoolProfesURL =     "RosSchoolProfessionals/GetSearchEmployeeWithImage"
    static let getEmpHistoryROSSchoolProfesURL =      "RosSchoolProfessionals/GetEmployeeHistory"
    static let addContactForReportToURL =             "RosSchoolProfessionals/InsertClientContacts"
    static let createOrderForSchoolProfessionalURL =  "RosSchoolProfessionals/CreateOrder"
    
    //HOSPITALITY URLs
    static let getROSHospitalityURL =                 "HospitalityController/GetOrder"
    static let HospitalitySearchEmployeeURL =         "HospitalityController/SearchEmployeeWithImage"
    static let ROSHospitalityCreateOrderURL =         "HospitalityController/CreateOrder"
    static let GetROSHospitalityEmpCOmmentURL =       "HospitalityController/GetComments"
    static let ROSHospitalityValidateCreateOrderURL = "HospitalityController/CreateOrderValidations"
    static let HospitalityEmpDetails =                "HospitalityController/ShowEmployeeHistory"
    static let addReportToLocationForHospitalityURL = "HospitalityController/AddReportToLocation"
    static let addReportToContactForHospitalityURL =  "HospitalityController/ManageClientContacts"
    
    //Time Sheet URLs
    static let EditTimeSheet =                        "EditTimeSheet/EditTimeSheet"
    static let AddTimeSheet =                         "EditTimeSheet/AddTimeSheet"
    static let UpdateTimeSheet =                      "EditTimeSheet/UpdateTimeSlipDetails"
    static let RejectTimeSheet =                      "EditTimeSheet/RejectTimeSheet"
    static let DeleteTimeSheet =                      "EditTimeSheet/DeleteTimeSlipDetails"
    static let ApproveTimeSlip =                      "EditTimeSheet/ApproveTime"
    static let GetEmpEvaluation =                     "ApproveTimeSheet/GetEvaluation"
    static let SaveEmpEvaluation =                    "ApproveTimeSheet/SaveEvaluation"
    
    //OFFICE URLs
    static let getROSOfficeOrderDataURL =              "RosOfficeController/OfficeGetOrder"
    static let addReportToLocationForOfficeURL =       "RosOfficeController/AddReportToLocation"
    static let addReportToForOfficeURL =               "RosOfficeController/AddNewReportTo"
    static let OfficeCreateOrderValidationURL =        "RosOfficeController/CreateOrderValidation"
    static let OfficeSearchEmployeeURL =               "RosOfficeController/SearchEmployeesNew"
    static let OfficeEmpDetails =                      "RosOfficeController/GetSearchOfficeDetails"
    static let ROSOfficleCreateOrderURL =              "RosOfficeController/CreateOrder"
    static let ROSOfficleProfileCommentsURL =          "RosOfficeController/ProfileComments"
    
    //OCC URLs
    static let getROSOCCOrdersURL =                    "OCCController/OnCallCounsel"
    static let OCC_AddReportToURL =                    "OCCController/ReportTo"
    static let OCCGetEmp =                             "OCCController/SearchAlreadyAssignedCounsel"
    static let OCCCreateOrderValidationURL =           "OCCController/OccValidations"
    static let OCCCreateOrderURL =                     "OCCController/OCCCreateOrder"
    static let OCCGetEmpDetails =                      "OCCController/SearchEmployeeWorkHistory"
    
    //HEALTH CARE URLs
    static  let getROSHealthCareURL =                  "RosHealthCareController/GetOrder"
    static  let HC_getROSSearchEmployeeURL =           "RosHealthCareController/GetPreviousEmployees"
    static  let HC_addReportToURL =                    "RosHealthCareController/InsertReportTo"
    static  let HC_PreconfirmOrderURL =                "RosHealthCareController/PreConfirmOrder"
    static  let HC_CreateOrderURL =                    "RosHealthCareController/ManageConfirmOrder"
    
    //loginapi
    static  let getAppCurrentVersionURL =              "Account/GetAPiVersion"
    
    //DOE URLs
    static let DOE_GetROSURL =                         "Doe/Getorder"
    static let DOE_GetSearchLocationURL =              "Doe/GetLocationDetails"
    static let DOE_GetEditAddressURL =                 "Doe/GetAddressDetails"
    static let DOE_Edit_Address_URL =                  "Doe/EditLocationDetails"
    static let DOE_SearchforReturningConsultant_URL =  "DoeReferAConsultant/SearchforReturningConsultant"
    static let DOE_Choose_ReportTo_URL =               "Doe/FillDropDowns"
    static let DOE_Existing_Applicant_List_URL =       "DoeReferAConsultant/ExistingConsultantsList"
    static let DOE_AddEdit_ApplicantFromList_URL =     "Doe/AddEditClientContact"
    static let DOE_AddDuplicateApplicant_URL =         "DoeReferAConsultant/InsertDuplicateApplicant"
    static let DOE_AddApplicant_URL =                  "DoeReferAConsultant/InsertApplicant"
    static let DOE_Get_State_List_URL =                "DoeReferAConsultant/AddApplicant"
    static let DOE_Get_Schdule_URL =                   "Doe/DoeSchedule"
    static let DOE_Ceate_Order_Validation_URL =        "Doe/CreateOrderValidations"
    static let DOE_Get_Payrate_URL =                   "Doe/DoePayRate"
    static let DOE_Validate_Payrate_URL =              "Doe/ValidateDoePayRate"
    static let DOE_Validate_Schdule_URL =              "Doe/DoeScheduleValidate"
    static let DOE_Waiver_Form_URL =                   "Doe/DoeWaiverform"
    static let DOE_Validate_Waiver_URL =               "Doe/DoeWaiverformValidate"
    static let DOE_GetAcaBilling_URL =                 "Doe/DoeAcaBilling"
    static let DOE_SaveOrder_URL =                     "Doe/DoeSaveOrder"
    static let DOE_Get_Edit_WorkOrder_URL =            "Doe/DoeEditWorkOrder"
    static let DOE_Submit_Changes_Edit_WorkOrder_URL = "Doe/SaveChangesDoeEditWorkOrder"
    static let DOE_Validate_Recruit_URL =              "Doe/ValidateRecruit"
    
    static let Privacy_Policy_URL =                    "Account/PrivacyPolicy"
    
    //Hospitality_Group Timesheet
    static let Get_HOS_Group_Timesheet_URL =          "GroupTimeSheetController/Getgrouptimesheet"
    static let HOS_GroupTS_Generate_Invoice_URL =     "GroupTimeSheetController/GenerateInvoice"
    static let HOS_GroupTS_Save_Comments_URL =        "GroupTimeSheetController/SaveComments"
    static let HOS_GroupTS_Save_TS_URL =              "GroupTimeSheetController/SaveGroupTimeSheet"
    static let HOS_GroupTS_GetNonTSStaff_URL =            "GroupTimeSheetController/GetNonTSStaff"
    static let HOS_GroupTS_InsertNonTSStaff_URL =            "GroupTimeSheetController/InsertNonTSStaff"
    static let HOS_GroupTS_Preview_URL = "GroupTimeSheetController/GetPreviewTipAmount"
    static let HOS_GroupTS_Submit_Tip = "GroupTimeSheetController/InsertDayWiseTips"
    
    //CLIENT INVOICE
    static let GetClientInvoice_URL =                "ClientInvoiceController/GetClientInvoice"
    static let GetClientInvoiceReport_URL =          "ClientInvoiceController/InvoiceReport"
    static let GetClientInvoiceApprovalReport_URL =  "ClientInvoiceController/InvoiceApprovalReport"
    
    //Order List
    static let GetOrderList_URL =                    "OrderListController/OrderList"
    static let Edit_Order_URL =                      "OrdersListController/EditOrder"
    static let Save_Edit_Order_URL =                 "OrdersListController/SaveEditOrder"
    static let Hos_Copy_Order_URL =                      "OrdersListController/CopyOrder"
    static let SP_Copy_Order_URL =                      "RosSchoolProfessionals/Copyorder"
    
    //Logistics Group Timesheet
    static let Get_Logistics_Group_TS_URL =           "GroupTimeSheetController/Getgrouptimesheet"
    static let Remove_Logistics_Group_TS_URL =        "GroupTimeSheetController/RemovePendingTimeSheet"
    static let Save_Multiple_Logistics_Group_TS_URL = "GroupTimeSheetController/SaveMultipleTimesheets"
    static let Approve_Logistics_Group_TS_URL =       "GroupTimeSheetController/SaveGroupTimeSheet"
    
    // SCRClearance
    static let SCRClearance_GetSCRClearance =           "SCRClearance/GetSCRClearance"
    static let SCRClearance_ApproveDeny =           "SCRClearance/ApproveSCRClearance"
    
    //eTime Clock
    static let Get_eTime_Clock_Data_URL =           "ETimeClockEntries/GetETimeClockEntries"
    static let eTime_Clock_Generate_Invoice_Data_URL =           "ETimeClockEntries/GenerateETimeClockInvoice"
    static let Update_eTime_Clock_Data_URL =           "ETimeClockEntries/UpdateETimeclock"
    static let Approve_eTime_Clock_Data_URL =           "ETimeClockEntries/ApproveEtimeClock"
    static let Get_eTime_Clock_EmpHours_Data_URL =           "ETimeClockEntries/GetEmployeeHours"
    static let Enter_eTime_Clock_Data_URL =           "ETimeClockEntries/EnterNewETimeclock"
    
    
    static let Get_Candidate_Location_Details =           "OrderListController/GetCandidatesByOrder"
    
    
    //fav/unfavCandidate
    static let Fav_UnFav_Candidate = "RosSchoolProfessionals/FavoriteClient"
    
    
    //GlobalFormOkSubmit
    
    static let GlobalFormSubmit = "Account/InsertCoronaPopUpDetails"
    
    // New EUA Forms
    
    static let GetSafetyGuidlines = "TimeSlip/SafetyGuideline"
    static let SubmitSafetyGuideline = "TimeSlip/InsertSafetyGuidelineSign"
    
    //Cash Application
    static let PaymentDetails = "ClientInvoiceController/PaymentDetails"
    static let PaymentInsert = "ClientInvoiceController/PaymentInsert"

    //Update Client Location
    static let UpdateClientLocation = "ETimeClockEntries/UpdateClientLocation"
    
    //E-Register
    static let ERegisterGetDivision = "eCheckIn/GetClientsList"
    static let ECheckInData = "eCheckIn/GetCheckInDetails"
    static let ECheckInButton = "eCheckIn/CheckIn"
    static let ECheckOutData = "eCheckIn/GetCheckOutDetails"
    static let ECheckOutButton = "eCheckIn/CheckOut"
    static let EBreakMinData = "eCheckIn/GetBreakMinuteDetails"
    static let EBreakMinSave = "eCheckIn/SaveBreakMinutes"
    static let EAllData = "eCheckIn/GetAllDetails"
    static let EAllSave = "eCheckIn/SaveCheckinCheckOut"
    static let ESaveReason = "eCheckIn/SubmitReason"
    static let EDelete = "eCheckIn/DeleteCheckinCheckOut"
    static let EAddTime = "eCheckIn/AddAdjustmenthours"
    static let ESubmitAll = "eCheckIn/SubmitAllDetails"
    
    //Rating
    static let Rating = "echeckin/SubmitRating"

    //PaymentDetails
    
    static func getPaymentDetails(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.PaymentDetails
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    
    //PaymentInsert
    
    static func PaymentInsert(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.PaymentInsert
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    
    //GetSafetyGuidlines
    static func GetSafetyGuidlines(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.GetSafetyGuidlines
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    
    //SubmitSafetyGuideline
 
    static func SubmitSafetyGuideline(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.SubmitSafetyGuideline
        RestAPI.GetDivListRequestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    
    
    
    //Login API
    static func loginByMobileNumber(_ view:UIViewController,params:[String:String],method:String,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.Login
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method:method, accessToken: "", acces: false, callback: callBack)
    }
    
    //changePassword
    static func changePassword(_ view:UIViewController,params:[String:String],method:String,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.ChangePassword
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:"", acces: true, callback: callBack)
        
    }
    //ForgotPassword
    static func forgotPassword(_ view:UIViewController,params:[String:String],method:String,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.Forgotpassword
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken: "", acces: false, callback: callBack)
    }
    //getListOfDivisions
    static func getListOfDivisions(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.ListOfDivisions
        RestAPI.GetDivListRequestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    
    //E-CheckIn Divisions
    static func getListOfERegisterDivisions(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.ERegisterGetDivision

        RestAPI.GetE_CheckInRequestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    
    //E-CheckIn CheckIn Tab Go Button
    static func getListOfECheckInDatas(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.ECheckInData

        RestAPI.GetE_CheckInRequestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    
    //E-CheckIn CheckIn Tab CheckIn Button
    static func getECheckInTime(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.ECheckInButton

        RestAPI.GetDivListRequestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)

    }
    
    //E-CheckIn CheckOut Tab Go Button
    static func getListOfECheckOutDatas(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.ECheckOutData

        RestAPI.GetE_CheckInRequestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    
    //E-CheckIn CheckOut Tab CheckOut Button
    static func getECheckOutTime(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.ECheckOutButton

        RestAPI.GetDivListRequestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)

    }
    
    //E-CheckIn BreakMin Tab Go Button
    static func getListOfBreakMinDatas(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.EBreakMinData

        RestAPI.GetE_CheckInRequestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    
    //E-CheckIn BreakMin Tab Save Button
    static func getBreakMinTimeSave(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.EBreakMinSave

        RestAPI.GetDivListRequestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)

    }
    
    //E-CheckIn All Tab Go Button
    static func getListOfAllDatas(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.EAllData

        RestAPI.GetE_CheckInRequestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    
    //E-CheckIn All Tab Save Button
    static func getAllTimeSave(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.EAllSave

        RestAPI.GetDivListRequestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)

    }
    
    //E-CheckIn All Tab Save Reason Button
    static func saveReasonApi(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.ESaveReason

        RestAPI.GetDivListRequestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)

    }
    
    //E-CheckIn All Tab Delete Button
    static func deleteApi(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.EDelete

        RestAPI.GetDivListRequestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)

    }
    
    //E-CheckIn Additional Time
    static func addTimeApi(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.EAddTime

        RestAPI.GetDivListRequestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)

    }
    
    //E-CheckIn Overall Submit All
    static func submitAllApi(_ view:UIViewController,params:[[String:Any]],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.ESubmitAll

        RestAPI.GetE_CheckInOverallRequest(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)

    }
    
    //E-CheckIn Rating API
    static func getsaveRating(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.Rating

        RestAPI.GetE_CheckInRequestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    

    //getCandidateLocationDetails
    static func getCandidateLocationDetails(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.Get_Candidate_Location_Details
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    
    //Privacy Policy
    static func getPrivacyPolicy(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.Privacy_Policy_URL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //    getAppCurrentVersionURL
    
    static func getAppCurrentVersion(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.getAppCurrentVersionURL
        RestAPI.GetDivListRequestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:false, callback: callBack)
    }
    //getListOfMenus
    static func getListOfMenus(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.MenuListURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //get getROSSchoolProfesOrders
    static func getROSSchoolProfesOrders(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.getROSSchoolProfesOrdersURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //get getROS Health Care
    static func getROSHealthCare(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.getROSHealthCareURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //get getROS DOE
    static func getROSDOE(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.DOE_GetROSURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    static func getROSDOEAcaBillingData(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.DOE_GetAcaBilling_URL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    static func getDOESearchLocationCodeDetailsData(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.DOE_GetSearchLocationURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    static func getDOEEditAddressDetailsServerCall(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.DOE_GetEditAddressURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    static func getDOEChooseReportToServerCall(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.DOE_Choose_ReportTo_URL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    
    //get getROS OCC
    static func getROSOCCOrders(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.getROSOCCOrdersURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //getROSHospitalityEmpComments
    
    static func getROSHospitalityEmpComments(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.GetROSHospitalityEmpCOmmentURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //get getROSHospitality
    static func getROSHospitality(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.getROSHospitalityURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //get get Copy Order Hospitality
    static func getCopyOrderForHospitality(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.Hos_Copy_Order_URL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    static func getCopyOrderForSchoolProfessional(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.SP_Copy_Order_URL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //SP_Copy_Order_URL
    //get getROSOffice
    static func getROSOfficeOrderData(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.getROSOfficeOrderDataURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //get SearchedROSSchoolProfes
    
    static func getSearchedEmpROSSchoolProfes(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.getSearchedEmpROSSchoolProfesURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    static func getSearchedEmpROSHospitality(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.HospitalitySearchEmployeeURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //get Emp History  ROSSchoolProfes
    
    static func getEmpHistoryROSSchoolProfes(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.getEmpHistoryROSSchoolProfesURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //HospitalityEmpDetails
    static func getEmpHistoryOffice(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.OfficeEmpDetails
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //HospitalityEmpDetails
    static func getEmpHistoryOCC(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.OCCGetEmpDetails
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    static func getSearchEmpOCC(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.OCCGetEmp
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    static func getSearchEmpHealthCare(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.HC_getROSSearchEmployeeURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    
    //HospitalityEmpDetails
    static func getEmpHistoryHospitality(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.HospitalityEmpDetails
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //get Active Orders
    static func getActiveOrders(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.ActiveOrdersURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //get  Orders List
    static func getOrdersList(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.GetOrderList_URL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //get  eTimeclock List
    static func geteTimeClockData(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.Get_eTime_Clock_Data_URL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //get  eTimeclock List
    static func geteTimeClockEmployeeHoursData(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.Get_eTime_Clock_EmpHours_Data_URL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    
    //    static let eTime_Clock_Generate_Invoice_Data_URL =           "ETimeClockEntries/GenerateETimeClockInvoice"
    //    static let Update_eTime_Clock_Data_URL =           "ETimeClockEntries/UpdateETimeclock"
    //    static let Approve_eTime_Clock_Data_URL =           "ETimeClockEntries/ApproveEtimeClock"
    
    //   eTimeclock Generate Invoice
    static func generateInvoiceForeTimeClockData(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.eTime_Clock_Generate_Invoice_Data_URL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    
    //Approve   eTimeclock List
    static func ApproveeTimeClockData(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.Approve_eTime_Clock_Data_URL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    
    //Edit Order
    static func EditOrders(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.Edit_Order_URL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //historicOrder
    static func getHistoricOrders(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.historicOrder
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //historic Order Details
    static func getHistoricOrderDetails(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.historicOrderDetailsURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //get weekly staffing schdule
    static func getWeeklyStaffingSchdule(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.getWeeklyStaffingSchduleURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //getWeeklyStaffingSchdulePDFURL
    static func getWeeklyStaffingSchdulePDF(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.getWeeklyStaffingSchdulePDFURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //weeklyStaffingOrderDetailsURL
    static func getWeeklyStaffingSchduleDetails(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.weeklyStaffingOrderDetailsURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //Add report To Person
    static func addReportToContact(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.addContactForReportToURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //Add report To Hospitality Location Person
    static func addReportToLocationForHospitality(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.addReportToLocationForHospitalityURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //Add report To Office Location Person
    static func addReportToLocationForOffice(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.addReportToLocationForOfficeURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //OCC_AddReportToURL
    static func addReportToForOCC(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.OCC_AddReportToURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //HC_AddReportToURL
    static func addReportToForHC(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.HC_addReportToURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    static func DOE_EditAddress_Call(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.DOE_Edit_Address_URL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    static func DOE_AddApplicant_Call(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.DOE_AddApplicant_URL
        
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    static func DOE_AddDuplicateApplicant_Call(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.DOE_AddDuplicateApplicant_URL
        
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    static func DOE_AddEdit_ApplicantFrom_List_Call(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.DOE_AddEdit_ApplicantFromList_URL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    static func DOE_getStateListCall(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()){
        
        let urlString = RestAPI.BaseUrl+RestAPI.DOE_Get_State_List_URL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    
    static func DOE_CreateOrderValidationCall(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()){
        
        let urlString = RestAPI.BaseUrl+RestAPI.DOE_Ceate_Order_Validation_URL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    static func DOE_WaiverValidationCall(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()){
        
        let urlString = RestAPI.BaseUrl+RestAPI.DOE_Validate_Waiver_URL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //
    
    static func getDoeSchduleData(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.DOE_Get_Schdule_URL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    static func getDoePayrateData(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.DOE_Get_Payrate_URL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //    static func ValidateDoePayrateData(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
    //
    //        let urlString = RestAPI.BaseUrl+RestAPI.DOE_Validate_Payrate_URL
    //        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    //    }
    static func ValidateDoeSchdule(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->())
    {
        //DOE_Validate_Schdule_URL
        let urlString = RestAPI.BaseUrl+RestAPI.DOE_Validate_Schdule_URL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
        
    }
    static func SearchForReturningConsultant_Call(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.DOE_SearchforReturningConsultant_URL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    static func SearchForExistingConsultant_Call(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.DOE_Existing_Applicant_List_URL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //
    //
    static func addReportToContactForHospitality(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.addReportToContactForHospitalityURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    static func addReportToContactForOffice(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.addReportToForOfficeURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //
    static func HospitalityGetSearchEmployee(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.HospitalitySearchEmployeeURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    static func OfficeGetSearchEmployee(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.OfficeSearchEmployeeURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    static func OfficeGetProfileComments(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.ROSOfficleProfileCommentsURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    static func getApproveTimeSheetTimeSlips(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.GetTimeSheetTimeSlipURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //New
    static func getTimeSlipsYouHaveApproved(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.GetApprovedList_URL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    static func getTimeSlipDetailsYouHaveApproved(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.GetApproved_Details_URL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //GetEvaluateEmployee
    static func GetEvaluateEmployee(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.GetEmpEvaluation
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //GetTimeSheetDetails
    static func ApproveTimeSheetDetails(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.ApproveTimeSheetDetailsURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //EmpWithNoTimeSlipURL
    //GetTimeSheetDetails
    static func getEmployeesWithNoTimeSlip(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.EmpWithNoTimeSlipURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //9491817926
    //1100
    static func checkEmpAgreement(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.AgreementSignURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //approveTSViewAttorney for Law dept
    static func approveTSViewAttorney(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.approveTSViewAttorneyURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //approveTSAttonerySubmit for Law dept
    static func approveTSAttonerySubmit(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.approveTSAttonerySubmitURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //viewApproveTSPDFURL
    static func viewApproveTSPDF(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.viewApproveTSPDFURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //getListOfDivisions
    static func approveEmpAgreement(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.approveEmpUsageAgreementURL
        RestAPI.GetDivListRequestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //InsertEmployeeURL
    static func InsertEmployeesWithEvaluation(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.InsertEmployeeURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    static func saveEmpEvaluationWithComment(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.SaveEmpEvaluation
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //Approve timeslips
    static func approvePendingTimeslip(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.approvePendingTSURL
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //TimeSlipOrderSelect TimeSlip/EnterEmployeeeTimeslips
    static func TimeSlipOrderSelect(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.TimeSlipOrderSelect
        // let urlString = "https://apps.tempositions.com/tempositionscwaapi/api/TimeSlip/OrderSelect"
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //TimeSlipEnterEmployeeeTimeslips
    static func TimeSlipEnterEmployeeeTimeslips(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+TimeSlipEnterEmployeeeTimeslips
        //let urlString = "https://apps.tempositions.com/tempositionscwaapi/api/TimeSlip/EnterEmployeeeTimeslips"
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //TimeSlipInsertPendingTimeSlip
    static func TimeSlipInsertPendingTimeSlip(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+TimeSlipInsertPendingTimeSlip
        //let urlString = "https://apps.tempositions.com/tempositionscwaapi/api/TimeSlip/InsertPendingTimeSlip"
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //EditTimeSheet
    static func EditTimeSheet(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+EditTimeSheet
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //addTimeSheet
    static func addTimeSheet(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+AddTimeSheet
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //updateTimeSheet
    static func updateTimeSheet(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+UpdateTimeSheet
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //rejectTimeSheet
    static func rejectTimeSheet(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RejectTimeSheet
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //deleteTimeSheet
    static func deleteTimeSheet(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+DeleteTimeSheet
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //approveTimeSlip
    static func approveTimeSlip(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+ApproveTimeSlip
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    
    //SCRClearance_GetSCRClearance
    static func scrclearancegetSCRClearance(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+SCRClearance_GetSCRClearance
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //SCRClearance_Approve Deny
    static func approveDenySCRClearance(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+SCRClearance_ApproveDeny
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    //Fav/Unfav candidate
    
    
    //FormSubmit API
    static func formOkClickSubmit(_ view:UIViewController,params:[String:Any],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+GlobalFormSubmit
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    
    //get getROS DOE
    static func updateLocationOfClient(_ view:UIViewController,params:[String:String],method:String,accessToken:String, acces:Bool,callBack:@escaping (AnyObject)->()) {
        
        let urlString = RestAPI.BaseUrl+RestAPI.UpdateClientLocation
        RestAPI.requestWithToken(viewController:view, urlString: urlString, params: params, method: method, accessToken:accessToken, acces:acces, callback: callBack)
    }
    
    
    
    //MARK: - GET METHOD
    static func GetDivListRequestWithToken(viewController:UIViewController,urlString:String,params:[String:Any],method:String,accessToken:String,acces:Bool,callback:@escaping (AnyObject)->())
    { // params was [string:string] viv changed
        
        print(urlString)
        
        DispatchQueue.global(qos:.userInitiated).async {
            
            let urlString = urlString

            var request = URLRequest(url: URL(string:urlString)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 45 )
            
            request.httpMethod = method
            
            if acces
            {
                
                let acToken = String(format:"%@",UserDefaults.standard.string(forKey: "Token")!)
                let UserName = String(format:"%@", UserDefaults.standard.string(forKey: "UserName")!)
                let acsToken = String(format:"Basic %@:%@",UserName,acToken)
                print("The access token for e-checin from Rest API line 841 is", acsToken)
                request.setValue(acsToken, forHTTPHeaderField: "Authorization")
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
            
            URLSession.shared.dataTask(with:request) { (data, response, error) in
                if error != nil
                {
                    print("error is ",error!)
                    print((error! as NSError).userInfo)
                    let errorUserInfo = (error! as NSError).userInfo
                    let mesg = errorUserInfo["NSLocalizedDescription"] != nil ?  errorUserInfo["NSLocalizedDescription"] : ""
                    print(mesg!)
                    OperationQueue.main.addOperation
                        {
                            callback(mesg as AnyObject)
                    }
                }
                else
                {
                    self.json = JSON(data!)
                    OperationQueue.main.addOperation
                        {
                            print(  self.json["Message"])
                            if self.json["Message"].stringValue == "Authorization has been denied for this request."{
                                callback(self.json["Message"].stringValue as AnyObject)
                                
                            }else{
                                callback(self.json as AnyObject)
                                
                            }
                    }
                }
                
            }.resume()
        }
        
    }
    static func requestWithToken(viewController:UIViewController,urlString:String,params:[String:Any],method:String,accessToken:String,acces:Bool,callback:@escaping (AnyObject)->())
    {
        print(urlString)
        self.getRequestWithToken(viewController: viewController, urlString: urlString, params: params, method: method, accessToken: accessToken, acces: acces, timeOut: 45, callback: callback)
        
    }
    
    
    static func postRequestWithToken(urlString:String,params:Any,callback:@escaping (AnyObject)->())
    {
        print(urlString)
        
        DispatchQueue.global(qos:.userInitiated).async {
            //            var request = URLRequest(url: URL(string:urlString)!)
            var request = URLRequest(url: URL(string:urlString)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 45 )
            
            request.httpMethod = "POST"
            
            let acToken = String(format:"%@",UserDefaults.standard.string(forKey: "Token")!)
            let UserName = String(format:"%@", UserDefaults.standard.string(forKey: "UserName")!)
            let acsToken = String(format:"Basic %@:%@",UserName,acToken)
            request.setValue(acsToken, forHTTPHeaderField: "Authorization")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
                
            } catch let error {
                print(error.localizedDescription)
            }
            
            //HTTP Headers
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            if let bodyString = String(data: request.httpBody!, encoding: .utf8) {
                print("Vivek Request body: \(bodyString)")
            }
            
            URLSession.shared.dataTask(with:request) { (data, response, error) in
                if error != nil
                {
                    print("error is ",error!)
                    print((error! as NSError).userInfo)
                    let errorUserInfo = (error! as NSError).userInfo
                    let mesg = errorUserInfo["NSLocalizedDescription"]
                    print(mesg!)
                    OperationQueue.main.addOperation{
                        
                        print(mesg!)
                        callback(mesg as AnyObject)
                    }
                }else{
                    self.json = JSON(data!)
                    OperationQueue.main.addOperation
                        {
                            callback(self.json as AnyObject)
                    }
                }
            }.resume()
        }
        
    }
    
    static func HC_postRequestWithToken(urlString:String,params:Any,callback:@escaping (AnyObject,NSDictionary)->())
    {
        print(urlString)
        
        DispatchQueue.global(qos:.userInitiated).async {
            //            var request = URLRequest(url: URL(string:urlString)!)
            var request = URLRequest(url: URL(string:urlString)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 45 )
            
            request.httpMethod = "POST"
            
            let acToken = String(format:"%@",UserDefaults.standard.string(forKey: "Token")!)
            let UserName = String(format:"%@", UserDefaults.standard.string(forKey: "UserName")!)
            let acsToken = String(format:"Basic %@:%@",UserName,acToken)
            request.setValue(acsToken, forHTTPHeaderField: "Authorization")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
                
            } catch let error {
                print(error.localizedDescription)
            }
            
            //HTTP Headers
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            URLSession.shared.dataTask(with:request) { (data, response, error) in
                if error != nil
                {
                    print("error is ",error!)
                    print((error! as NSError).userInfo)
                    let errorUserInfo = (error! as NSError).userInfo
                    let mesg = errorUserInfo["NSLocalizedDescription"]
                    print(mesg!)
                    OperationQueue.main.addOperation{
                        
                        print(mesg!)
                        callback(mesg as AnyObject,NSDictionary())
                    }
                }else{
                    self.json = JSON(data!)
                    OperationQueue.main.addOperation
                        {
                            //                           let returnData = String(data: data!, encoding: .utf8)
                            //                            let dictionary:NSDictionary? = NSKeyedUnarchiver.unarchiveObject(with: data!) as? NSDictionary
                            //                            let userCourseDictionary: NSDictionary = JSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                            do {
                                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                                let userCourseDictionary: NSDictionary = json as NSDictionary
                                callback(self.json as AnyObject, userCourseDictionary)
                                
                            } catch let error as NSError {
                                print("Failed to load: \(error.localizedDescription)")
                            }
                    }
                }
            }.resume()
        }
        
    }
    static func getRequestWithToken(viewController:UIViewController,urlString:String,params:[String:Any],method:String,accessToken:String,acces:Bool,timeOut: NSInteger,callback:@escaping (AnyObject)->())
    {
        print(urlString)
        DispatchQueue.global(qos:.userInitiated).async {
            let urlString = urlString
            //            var request = URLRequest(url: URL(string:urlString)!)
            var request = URLRequest(url: URL(string:urlString)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: TimeInterval(timeOut) )
            
            request.httpMethod = method
            
            if acces
            {//  "Token" : "ZdGnvK9AMXM=",
                
                let acToken = String(format:"%@",UserDefaults.standard.string(forKey: "Token")!)
                let UserName = String(format:"%@", UserDefaults.standard.string(forKey: "UserName")!)
                let acsToken = String(format:"Basic %@:%@",UserName,acToken)
                print("The access token from api response from 1025 is",acsToken)
                request.setValue(acsToken, forHTTPHeaderField: "Authorization")
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
            URLSession.shared.dataTask(with:request) { (data, response, error) in
                if error != nil
                {
                    print("error is ",error!)
                    print((error! as NSError).userInfo)
                    let errorUserInfo = (error! as NSError).userInfo
                    let mesg = errorUserInfo["NSLocalizedDescription"]
                    print(mesg!)
                    OperationQueue.main.addOperation
                        {
                            callback(mesg as AnyObject)
                    }
                }
                else
                {
                    self.json = JSON(data!)
                    OperationQueue.main.addOperation
                        {
                            if self.json["Message"].stringValue == "Authorization has been denied for this request."{
                                print(self.json["Message"])
                                callback(self.json["Message"].stringValue as AnyObject)
                                
                            }else{
                                print(self.json)
                                
                                callback(self.json as AnyObject)
                                
                            }
                    }
                }
                
            }.resume()
        }
        
    }
    
    static func generateInvoicePostRequestWithToken(urlString:String,params:Any,callback:@escaping (AnyObject)->())
    {
        print(urlString)
        
        DispatchQueue.global(qos:.userInitiated).async {
            //            var request = URLRequest(url: URL(string:urlString)!)
            var request = URLRequest(url: URL(string:urlString)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60 )
            
            request.httpMethod = "POST"
            
            let acToken = String(format:"%@",UserDefaults.standard.string(forKey: "Token")!)
            let UserName = String(format:"%@", UserDefaults.standard.string(forKey: "UserName")!)
            let acsToken = String(format:"Basic %@:%@",UserName,acToken)
            request.setValue(acsToken, forHTTPHeaderField: "Authorization")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
                
            } catch let error {
                print(error.localizedDescription)
            }
            
            //HTTP Headers
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            URLSession.shared.dataTask(with:request) { (data, response, error) in
                if error != nil
                {
                    print("error is ",error!)
                    print((error! as NSError).userInfo)
                    let errorUserInfo = (error! as NSError).userInfo
                    let mesg = errorUserInfo["NSLocalizedDescription"]
                    print(mesg!)
                    OperationQueue.main.addOperation{
                        
                        print(mesg!)
                        callback(mesg as AnyObject)
                    }
                }else{
                    self.json = JSON(data!)
                    OperationQueue.main.addOperation
                        {
                            callback(self.json as AnyObject)
                    }
                }
            }.resume()
        }
        
    }
    
    //E-checin API Parsing
    
    static func GetE_CheckInRequestWithToken(viewController:UIViewController,urlString:String,params:[String:String],method:String,accessToken:String,acces:Bool,callback:@escaping (AnyObject)->())
    {
        
        print(urlString)
        
        DispatchQueue.global(qos:.userInitiated).async {
            
            func createRequest(baseURL: String, parameters: [String: String]) -> URLRequest? {
                var urlComponents = URLComponents(string: baseURL)
                
                // Create an array of URLQueryItem objects from the parameters
                let queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
                
                // Add the query items to the URL components
                urlComponents?.queryItems = queryItems
                
                guard let url = urlComponents?.url else {
                    return nil
                }
                
                return URLRequest(url: url)
            }

            
            let postString:[String:String] = params
            
            let urlString = urlString
            print("the URL in API PArse is", urlString)
                
            var request = createRequest(baseURL: urlString, parameters: postString)
                
            print("the request of full fprm is", request!)
            
            request?.httpMethod = method
            
            if acces
            {
                
                let acToken = String(format:"%@",UserDefaults.standard.string(forKey: "Token")!)
                let UserName = String(format:"%@", UserDefaults.standard.string(forKey: "UserName")!)
                let acsToken = String(format:"Basic %@:%@",UserName,acToken)
                print("The access token for e-checin from Rest API line 841 is", acsToken)
                request?.setValue(acsToken, forHTTPHeaderField: "Authorization")
            }
            
            
            do {
                request?.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
                
            } catch let error {
                print(error.localizedDescription)
            }
            
            //HTTP Headers
            request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request?.addValue("application/json", forHTTPHeaderField: "Accept")
            URLSession.shared.dataTask(with:request!) { (data, response, error) in
                if error != nil
                {
                    print("error is ",error!)
                    print((error! as NSError).userInfo)
                    let errorUserInfo = (error! as NSError).userInfo
                    let mesg = errorUserInfo["NSLocalizedDescription"] != nil ?  errorUserInfo["NSLocalizedDescription"] : ""
                    print(mesg!)
                    OperationQueue.main.addOperation
                        {
                            callback(mesg as AnyObject)
                    }
                }
                else
                {
                    self.json = JSON(data!)
                    OperationQueue.main.addOperation
                        {
                            print(  self.json["Message"])
                            if self.json["Message"].stringValue == "Authorization has been denied for this request."{
                                callback(self.json["Message"].stringValue as AnyObject)
                                
                            }else{
                                callback(self.json as AnyObject)
                                
                            }
                    }
                }
                
            }.resume()
        }
    }
    
    //MARK: - Overall E-Checkin SUbmit API Parsing
    
    static func GetE_CheckInOverallRequest(viewController:UIViewController,urlString:String,params:[[String:Any]],method:String,accessToken:String,acces:Bool,callback:@escaping (AnyObject)->())
    {
        
        print(urlString)
        
        DispatchQueue.global(qos:.userInitiated).async {
            
            func createRequest(baseURL: String, parameters: [[String: Any]]) -> URLRequest? {
                var urlComponents = URLComponents(string: baseURL)
                
                // Create an array of URLQueryItem objects from the parameters
                let queryItems = parameters.flatMap { dict in
                    dict.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                }
                
                // Add the query items to the URL components
                urlComponents?.queryItems = queryItems
                
                guard let url = urlComponents?.url else {
                    return nil
                }
                
                return URLRequest(url: url)
            }

            
            let postString:[[String:Any]] = params
            
            let urlString = urlString
            print("the URL in API PArse is", urlString)
                
            var request = createRequest(baseURL: urlString, parameters: postString)
                
            print("the request of full fprm is", request!)
            
            request?.httpMethod = method
            
            if acces
            {
                
                let acToken = String(format:"%@",UserDefaults.standard.string(forKey: "Token")!)
                let UserName = String(format:"%@", UserDefaults.standard.string(forKey: "UserName")!)
                let acsToken = String(format:"Basic %@:%@",UserName,acToken)
                print("The access token for e-checin from Rest API line 841 is", acsToken)
                request?.setValue(acsToken, forHTTPHeaderField: "Authorization")
            }
            
            
            do {
                request?.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
                
            } catch let error {
                print(error.localizedDescription)
            }
            
            //HTTP Headers
            request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request?.addValue("application/json", forHTTPHeaderField: "Accept")
            URLSession.shared.dataTask(with:request!) { (data, response, error) in
                if error != nil
                {
                    print("error is ",error!)
                    print((error! as NSError).userInfo)
                    let errorUserInfo = (error! as NSError).userInfo
                    let mesg = errorUserInfo["NSLocalizedDescription"] != nil ?  errorUserInfo["NSLocalizedDescription"] : ""
                    print(mesg!)
                    OperationQueue.main.addOperation
                        {
                            callback(mesg as AnyObject)
                    }
                }
                else
                {
                    self.json = JSON(data!)
                    OperationQueue.main.addOperation
                        {
                            print(  self.json["Message"])
                            if self.json["Message"].stringValue == "Authorization has been denied for this request."{
                                callback(self.json["Message"].stringValue as AnyObject)
                                
                            }else{
                                callback(self.json as AnyObject)
                                
                            }
                    }
                }
                
            }.resume()
        }
    }
    
}
