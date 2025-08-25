//
//  DOESchduleViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 12/04/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON

class DOESchduleViewController: BaseTableViewController,UITextFieldDelegate {
    var EditOrderDataArray = NSMutableArray()
    var EditOrderMultiDataArray = NSMutableArray()
    
    var dataArray = NSMutableArray()
    var customPickerView = JPPickerView()
    var weekDayArray = NSMutableArray()
    var multiDayDataArray = NSMutableArray()
    var firstResponderTxtFieldTag = 0
    var selectedSementTag = 0
    var sameDayHour = "0"
    var multiDayHour = "0"
    var TotalWorkOrderHoursForMultiDay = "0"
    var TotalWorkOrderHoursForSameDay = "0"
    
    var StartCalenderDate = Date()
    var EndCalenderDate = Date()
    
    var segHeader = ""
    var timeSegment = UISegmentedControl()
    var isFromSummaryPage = false
    
    var IsWarningConfirmed1 = ""
    var WarningConfirm2 = ""
    var AlertContinueMessageConfirm = ""
    var isFromHistoricOrder = false
    
    //TEXTFIELD TAG
    
    let MonStartTxtFieldTag = "10001"
    let MonEndTxtFieldTag = "10002"
    let MonBreakTxtFieldTag = "110002"
    
    let TueStartTxtFieldTag = "10003"
    let TueEndTxtFieldTag = "10004"
    let TueBreakTxtFieldTag = "110005"
    
    let WedStartTxtFieldTag = "10005"
    let WedEndTxtFieldTag = "10006"
    let WedBreakTxtFieldTag = "110007"
    
    let ThuStartTxtFieldTag = "10007"
    let ThuEndTxtFieldTag = "10008"
    let ThuBreakTxtFieldTag = "110009"
    
    let FriStartTxtFieldTag = "10009"
    let FriEndTxtFieldTag = "100010"
    let FriBreakTxtFieldTag = "1100011"
    
    let SatStartTxtFieldTag = "100011"
    let SatEndTxtFieldTag = "100012"
    let SatBreakTxtFieldTag = "110013"
    
    let SunStartTxtFieldTag = "100013"
    let SunEndTxtFieldTag = "100014"
    let SunBreakTxtFieldTag = "110014"
    
    let StartDateTxtFieldTag = "100015"
    let EndDateTxtFieldTag = "100016"
    
    let StartTimeTxtFieldTag = "100017"
    let EndTimeTxtFieldTag = "100018"
    let BreakTimeTxtFieldTag = "1100018"
    
    let StartDatePlaceHolder = "Start Date"
    let EndDatePlaceHolder = "End Date"
    
    let StartTimePlaceHolder = "Start Time"
    let EndTimePlaceHolder = "End Time"
    
    let sameDayTimePlaceHolder = "Click here  if your consultant will work on Saturday or Sunday, or at different times on different days during the week; otherwise enter times below"
    let multiDayTimePlaceHolder = "Click here if you require the same time on all days."
    var  HeaderName  = "if you require the same time on all days"
    var SelectedHeaderName = "if your employees will work on Saturday or Sunday, or at different times different days during the week; otherwise enter times below"
    
    var WednesdayStartTime = ""
    var WednesdayEndTime = ""
    var WednesdayBreakTime = ""
    
    var MondayStartTime = ""
    var MondayEndTime = ""
    var MondayBreakTime = ""
    
    var TuesdayStartTime = ""
    var TuesdayEndTime = ""
    var TuesdayBreakTime = ""
    
    var ThursdayStartTime = ""
    var ThursdayEndTime = ""
    var ThursdayBreakTime = ""
    
    var FridayStartTime = ""
    var FridayEndTime = ""
    var FridayBreakTime = ""
    
    var SaturdayStartTime = ""
    var SaturdayEndTime = ""
    var SaturdayBreakTime = ""
    
    var SundayStartTime = ""
    var SundayEndTime = ""
    var SundayBreakTime = ""
    
    
    
    
    var isWednesdayChecked = "0"
    var isMondayChecked = "0"
    var isTuesdayChecked = "0"
    var isThursdayChecked = "0"
    var isFridayChecked = "0"
    var isSaturdayChecked = "0"
    var isSundayChecked = "0"
    
    var StartDate = ""
    var EndDate = ""
    var StartTime = ""
    var EndTime = ""
    var BreakInterval = ""
    var DailyHours = ""
    var TotalHours = ""
    
    
    //save Original Value for Undo Function
    var Original_WednesdayStartTime = ""
    var Original_WednesdayEndTime = ""
    var Original_WednesdayBreakTime = ""
    
    var Original_MondayStartTime = ""
    var Original_MondayEndTime = ""
    var Original_MondayBreakTime = ""
    
    var Original_TuesdayStartTime = ""
    var Original_TuesdayEndTime = ""
    var Original_TuesdayBreakTime = ""
    
    var Original_ThursdayStartTime = ""
    var Original_ThursdayEndTime = ""
    var Original_ThursdayBreakTime = ""
    
    var Original_FridayStartTime = ""
    var Original_FridayEndTime = ""
    var Original_FridayBreakTime = ""
    
    var Original_SaturdayStartTime = ""
    var Original_SaturdayEndTime = ""
    var Original_SaturdayBreakTime = ""
    
    var Original_SundayStartTime = ""
    var Original_SundayEndTime = ""
    var Original_SundayBreakTime = ""
    
    var Original_StartDate = ""
    var Original_EndDate = ""
    var Original_StartTime = ""
    var Original_EndTime = ""
    var Original_BreakInterval = "0"
    var Original_DailyHours = ""
    var Original_TotalHours = ""
    
    //Edit Order
    var orderID = ""
    var WaiverNecessary = false
    let Edit_Order_MonTxtFieldTag = "1001"
    let Edit_Order_TueTxtFieldTag = "1002"
    let Edit_Order_WedTxtFieldTag = "1003"
    let Edit_Order_ThuTxtFieldTag = "1004"
    let Edit_Order_FriTxtFieldTag = "1005"
    let Edit_Order_SatTxtFieldTag = "1006"
    let Edit_Order_SunTxtFieldTag = "1007"
    let TotalBillingTextField_Tag = "1008"
    let TotalHoursTextField_Tag = "1009"
    var IsDailyHoursandPayRateSelected = false
    var IsTotalHoursandChooseDaysSelected = false
    
    var totalBilling = ""
    var totalHours = ""
    
    var  MondayChecked = false
    var  TuesdayChecked = false
    var  WednesdayChecked = false
    var  ThursdayChecked = false
    var  FridayChecked = false
    var  SaturdayChecked = false
    var  SundayChecked = false
    
    var  MondayHours = ""
    var  TuesdayHours = ""
    var  WednesdayHours = ""
    var  ThursdayHours = ""
    var  FridayHours = ""
    var  SaturdayHours = ""
    var  SundayHours = ""
    var CurrentTotalOrderBilling = ""
    var OrderHours = ""
    var WarningConfirm = false
    var SuccessAlert = false
    
    var firstTimePopUp = false
    var SecondTimePopUp = false
    var ThirdTimePopUp = false
    var  selectedApplicant = Applicant.init(CandidateId: "0", ApplicantId: "", Name: "", ConsultantType: "", Email: "", Address: "", City: "", State: "", Zip: "", SSN: "", isSelected: "",appliType: "",ApplicationId:  "0",NewApplicant:  "",extraCandId: "0")
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: "DoeApplicantModel") != nil{
            let decoded  = defaults.object(forKey: "DoeApplicantModel") as! Data
            let decodedApplicant = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Applicant
            selectedApplicant = decodedApplicant
        }
        
        //
        IsDailyHoursandPayRateSelected = false
        IsTotalHoursandChooseDaysSelected = true
        
        if isFromSummaryPage == true{
            self.methodOfReceivedNotification()
        }
        if self.orderID.count > 0 && Int(self.orderID)! > 0{
            self.titlelbl.text = "DOE Edit Work Order"
        }else{
            self.titlelbl.text = "DOE Schedule"
        }
        
    }
    @objc override func appWillEnterForeground(){
        print("appWillEnterForeground Division")
        
        let defaults = UserDefaults.standard
        
        if defaults.dictionary(forKey: "DoeScheduleModel") == nil{
            
            if self.orderID.count > 0 && Int(self.orderID)! > 0{
                IsTotalHoursandChooseDaysSelected = true
                if EditOrderDataArray.count == 0{
                    self.getSchduleFromOrderIDCall()
                }
            }else{
                selectedSementTag = 0
                self.formMultiDayArray()
                if EditOrderDataArray.count == 0{
                    
                    self.getSchduleCall()
                }
            }
        }else{
            self.updateDataDetails()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPickerView()
        let defaults = UserDefaults.standard
        
        if defaults.dictionary(forKey: "DoeScheduleModel") == nil{
            
            if self.orderID.count > 0 && Int(self.orderID)! > 0{
                IsTotalHoursandChooseDaysSelected = true
                self.getSchduleFromOrderIDCall()
            }else{
                selectedSementTag = 0
                self.formMultiDayArray()
                self.getSchduleCall()
                
            }
        }else{
            self.updateDataDetails()
        }
        
        
    }
    
    func updateDataDetails(){
        let defaults = UserDefaults.standard
        
        let DoeScheduleModel =  defaults.dictionary(forKey: "DoeScheduleModel")
        let  Schedule = DoeScheduleModel!["Schedule"] as! String
        var WeekdayDict = NSDictionary()
        var SaturdayDict = NSDictionary()
        var SundayDict = NSDictionary()
        var MondaydayDict = NSDictionary()
        var TuesdayDict = NSDictionary()
        var WednesdayDict = NSDictionary()
        var ThursdayDict = NSDictionary()
        var FridayDict = NSDictionary()
        
        StartDate = DoeScheduleModel!["StartDate"] as! String
        EndDate = DoeScheduleModel!["EndDate"] as! String
        StartCalenderDate = self.ConvertStringToDate(DateString: StartDate)
        EndCalenderDate = self.ConvertStringToDate(DateString: EndDate)
        
        TotalHours  = DoeScheduleModel!["TotalHours"] as! String
        if DoeScheduleModel!["WeekDay"] != nil{
            WeekdayDict = DoeScheduleModel!["WeekDay"] as! NSDictionary
            EndTime = WeekdayDict["EndTime"] as! String
            StartTime = WeekdayDict["StartTime"] as! String
            BreakInterval = WeekdayDict["MealBreak"] as! String
            
        }
        if DoeScheduleModel!["Sunday"] != nil{
            SundayDict = DoeScheduleModel!["Sunday"] as! NSDictionary
            SundayEndTime = SundayDict["EndTime"] as! String
            SundayStartTime = SundayDict["StartTime"] as! String
            SundayBreakTime = SundayDict["MealBreak"] as! String
            isSundayChecked = SundayDict["IsSchedule"] as! Bool == true ? "1" : "0"
        }
        if DoeScheduleModel!["Saturday"] != nil{
            SaturdayDict = DoeScheduleModel!["Saturday"] as! NSDictionary
            SaturdayEndTime = SaturdayDict["EndTime"] as! String
            SaturdayStartTime = SaturdayDict["StartTime"] as! String
            SaturdayBreakTime = SaturdayDict["MealBreak"] as! String
            isSaturdayChecked = SaturdayDict["IsSchedule"] as! Bool == true ? "1" : "0"
            
        }
        if DoeScheduleModel!["Friday"] != nil{
            FridayDict = DoeScheduleModel!["Friday"] as! NSDictionary
            FridayEndTime = FridayDict["EndTime"] as! String
            FridayStartTime = FridayDict["StartTime"] as! String
            FridayBreakTime = FridayDict["MealBreak"] as! String
            isFridayChecked = FridayDict["IsSchedule"] as! Bool == true ? "1" : "0"
            
        }
        if DoeScheduleModel!["Thursday"] != nil{
            ThursdayDict = DoeScheduleModel!["Thursday"] as! NSDictionary
            ThursdayEndTime = ThursdayDict["EndTime"] as! String
            ThursdayStartTime = ThursdayDict["StartTime"] as! String
            ThursdayBreakTime = ThursdayDict["MealBreak"] as! String
            isThursdayChecked = ThursdayDict["IsSchedule"] as! Bool == true ? "1" : "0"
            
        }
        if DoeScheduleModel!["Wednesday"] != nil{
            WednesdayDict = DoeScheduleModel!["Wednesday"] as! NSDictionary
            WednesdayEndTime = WednesdayDict["EndTime"] as! String
            WednesdayStartTime = WednesdayDict["StartTime"] as! String
            WednesdayBreakTime = WednesdayDict["MealBreak"] as! String
            isWednesdayChecked = WednesdayDict["IsSchedule"] as! Bool == true ? "1" : "0"
            
        }
        if DoeScheduleModel!["Tuesday"] != nil{
            TuesdayDict = DoeScheduleModel!["Tuesday"] as! NSDictionary
            TuesdayEndTime = TuesdayDict["EndTime"] as! String
            TuesdayStartTime = TuesdayDict["StartTime"] as! String
            TuesdayBreakTime = TuesdayDict["MealBreak"] as! String
            isTuesdayChecked = TuesdayDict["IsSchedule"] as! Bool == true ? "1" : "0"
            
        }
        if DoeScheduleModel!["Monday"] != nil{
            MondaydayDict = DoeScheduleModel!["Monday"] as! NSDictionary
            MondayEndTime = MondaydayDict["EndTime"] as! String
            MondayStartTime = MondaydayDict["StartTime"] as! String
            MondayBreakTime = MondaydayDict["MealBreak"] as! String
            isMondayChecked = MondaydayDict["IsSchedule"] as! Bool == true ? "1" : "0"
            
        }
        if Schedule == "s"{
            selectedSementTag = 0
        }else{
            selectedSementTag = 1
        }
        
        self.formMultiDayArray()
        
        self.formDataArrayForTableview()
        self.formMultiDayDataArray()
        if StartTime.count > 0 && EndTime.count > 0{
            let diff = self.getTimeDifference(date1: StartTime, date2: EndTime,breakValue: BreakInterval)
            //                dailyHour = diff
            sameDayHour = diff
            
        }
        self.updateTimeDiff()
    }
    @objc func methodOfReceivedNotification(){
        
        
        if Int(self.orderID)! > 0{
            IsTotalHoursandChooseDaysSelected = true
            self.getSchduleFromOrderIDCall()
        }else{
            
            self.updateDataDetails()
        }
        
        self.tableView.reloadData()
    }
    
    
    @objc override func goBack()
    {
        
        if isFromSummaryPage == true{
            isFromSummaryPage = false
            self.pushToSummaryPage()
            NotificationCenter.default.removeObserver(self)
            
        }else{
            isFromSummaryPage = false
            
            if self.orderID.count > 0 && Int(self.orderID)! > 0{
                //pop to details page
                self.pushToSummaryPage()
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    func formDataArrayForTableview(){
        let workOrderDict = ["header":"Work Order"]
        let ÐateDict = ["header":StartDatePlaceHolder,"subHeader":EndDatePlaceHolder,"StartTag":StartDateTxtFieldTag,"EndTag":EndDateTxtFieldTag,"StartValue":StartDate,"EndValue":EndDate]
        let selectDateDict = ["header":"Segment"]
        let timeDict = ["header":StartTimePlaceHolder,"subHeader":EndTimePlaceHolder,"StartTag":StartTimeTxtFieldTag,"EndTag":EndTimeTxtFieldTag,"StartValue":StartTime,"EndValue":EndTime,"breakTag":TueBreakTxtFieldTag]
        let nextBtnDict = ["header":"Next"]
        dataArray.removeAllObjects()
        dataArray = [workOrderDict,ÐateDict,selectDateDict,timeDict,nextBtnDict]
    }
    
    
    func SaveTheValuesForUndoFunctionality(){
        
        Original_WednesdayStartTime = WednesdayStartTime
        Original_WednesdayEndTime = WednesdayEndTime
        Original_WednesdayBreakTime = WednesdayBreakTime
        
        Original_MondayStartTime = MondayStartTime
        Original_MondayEndTime = MondayEndTime
        Original_MondayBreakTime = MondayBreakTime
        
        Original_TuesdayStartTime = TuesdayStartTime
        Original_TuesdayEndTime = TuesdayEndTime
        Original_TuesdayBreakTime = TuesdayBreakTime
        
        Original_ThursdayStartTime = ThursdayStartTime
        Original_ThursdayEndTime = ThursdayEndTime
        Original_ThursdayBreakTime = ThursdayBreakTime
        
        Original_FridayStartTime = FridayStartTime
        Original_FridayEndTime = FridayEndTime
        Original_FridayBreakTime = FridayBreakTime
        
        Original_SaturdayStartTime = SaturdayStartTime
        Original_SaturdayEndTime = SaturdayEndTime
        Original_SaturdayBreakTime = SaturdayBreakTime
        
        Original_SundayStartTime = SundayStartTime
        Original_SundayEndTime = SundayEndTime
        Original_SundayBreakTime = SundayBreakTime
        
        Original_StartDate = StartDate
        Original_EndDate = EndDate
        Original_StartTime = StartTime
        Original_EndTime = EndTime
        Original_BreakInterval = BreakInterval
        Original_DailyHours = DailyHours
        Original_TotalHours = TotalHours
        
        
    }
    func setupPickerView(){
        customPickerView = Bundle.main.loadNibNamed("JPPickerView", owner: self, options: nil)?[0] as! JPPickerView
        
        customPickerView.setupUI()
        customPickerView.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
        customPickerView.doneButton.addTarget(self, action:#selector(self.timeButtonTapped), for:.touchUpInside)
        customPickerView.dtPickerView.addTarget(self, action:#selector(self.datePickerValueChanged), for:.valueChanged)
        //         hoursSegment.tintColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        customPickerView.dtPickerView.setValue(UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String), forKey: "textColor")
        customPickerView.dtPickerView.backgroundColor = UIColor.white
        
    }
    func formMultiDayArray(){
        
        let startTimePlaceHolder = "Start Time"
        let endTimePlaceHolder = "End Time"
        weekDayArray.removeAllObjects()
        
        let monDict = ["day":"MON","header":startTimePlaceHolder,"showDropDown":"0","StartTag":MonStartTxtFieldTag,"EndTag":MonEndTxtFieldTag,"StartValue":MondayStartTime,"EndValue":MondayEndTime,"subHeader":endTimePlaceHolder,"breakTag":MonBreakTxtFieldTag,"BreakValue":MondayBreakTime,"isSelected":isMondayChecked]
        
        let tuesDict = ["day":"TUE","header":startTimePlaceHolder,"showDropDown":"0","StartTag":TueStartTxtFieldTag,"EndTag":TueEndTxtFieldTag,"StartValue":TuesdayStartTime,"EndValue":TuesdayEndTime,"subHeader":endTimePlaceHolder,"breakTag":TueBreakTxtFieldTag,"BreakValue":TuesdayBreakTime,"isSelected":isTuesdayChecked]
        let wedDict = ["day":"WED","header":startTimePlaceHolder,"showDropDown":"0","StartTag":WedStartTxtFieldTag,"EndTag":WedEndTxtFieldTag,"StartValue":WednesdayStartTime,"EndValue":WednesdayEndTime,"subHeader":endTimePlaceHolder,"breakTag":WedBreakTxtFieldTag,"BreakValue":WednesdayBreakTime,"isSelected":isWednesdayChecked]
        let thurDict = ["day":"THU","header":startTimePlaceHolder,"showDropDown":"0","StartTag":ThuStartTxtFieldTag,"EndTag":ThuEndTxtFieldTag,"StartValue":ThursdayStartTime,"EndValue":ThursdayEndTime,"subHeader":endTimePlaceHolder,"breakTag":ThuBreakTxtFieldTag,"BreakValue":ThursdayBreakTime,"isSelected":isThursdayChecked]
        let friDict = ["day":"FRI","header":startTimePlaceHolder,"showDropDown":"0","StartTag":FriStartTxtFieldTag,"EndTag":FriEndTxtFieldTag,"StartValue":FridayStartTime,"EndValue":FridayEndTime,"subHeader":endTimePlaceHolder,"breakTag":FriBreakTxtFieldTag,"BreakValue":FridayBreakTime,"isSelected":isFridayChecked]
        let satDict = ["day":"SAT","header":startTimePlaceHolder,"showDropDown":"0","StartTag":SatStartTxtFieldTag,"EndTag":SatEndTxtFieldTag,"StartValue":SaturdayStartTime,"EndValue":SaturdayEndTime,"subHeader":endTimePlaceHolder,"breakTag":SatBreakTxtFieldTag,"BreakValue": SaturdayBreakTime,"isSelected":isSaturdayChecked]
        let sunDict = ["day":"SUN","header":startTimePlaceHolder,"showDropDown":"0","StartTag":SunStartTxtFieldTag,"EndTag":SunEndTxtFieldTag,"StartValue":SundayStartTime,"EndValue":SundayEndTime,"subHeader":endTimePlaceHolder,"breakTag":SunBreakTxtFieldTag,"BreakValue": SundayBreakTime,"isSelected":isSundayChecked]
        
        weekDayArray = [sunDict,monDict,tuesDict,wedDict,thurDict,friDict,satDict]
        
    }
    @objc func timeButtonTapped(sender:UIButton) {
        
        customPickerView.removePickerViewFromSuperView()
        
    }
    @objc func datePickerValueChanged(sender: UIDatePicker){
        
        let changedDate = sender.date
        //▿ 2017-10-29 11:20:00 +0000
        sender.locale = NSLocale(localeIdentifier: "en_US") as Locale
        
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        var  pickedDateString = formatter.string(from: changedDate as Date).lowercased()
        
        if firstResponderTxtFieldTag == Int(StartDateTxtFieldTag)  || firstResponderTxtFieldTag ==
            Int(EndDateTxtFieldTag){
            
            if firstResponderTxtFieldTag == Int(StartDateTxtFieldTag) {
                StartCalenderDate = sender.date
                EndCalenderDate = sender.date
                StartDate = pickedDateString
                EndDate  = pickedDateString
            }else if firstResponderTxtFieldTag ==  Int(EndDateTxtFieldTag){
                EndCalenderDate = sender.date
                EndDate  = pickedDateString
            }
            var indexOfObj = -1
            var forArr = NSMutableArray()
            if self.orderID.count > 0 && Int(self.orderID)! > 0{
                if IsTotalHoursandChooseDaysSelected == true{
                    forArr =  EditOrderDataArray
                }else{
                    forArr = EditOrderMultiDataArray
                }
            }else{
                if selectedSementTag == 1{
                    forArr = multiDayDataArray
                }else{
                    forArr = dataArray
                }
            }
            let placeholderheader = StartDatePlaceHolder
            
            for dict in forArr{
                
                let   dictObj : NSDictionary = dict as! NSDictionary
                let headerValue = dictObj["header"] as! String
                
                if placeholderheader.count>0 && headerValue == placeholderheader {
                    indexOfObj = forArr.index(of: dictObj)
                    break
                }
            }
            if indexOfObj >= 0{
                
                let dict =  forArr[indexOfObj] as! NSDictionary
                let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dict)
                mutableDictObj["StartValue"] = StartDate
                mutableDictObj["EndValue"] = EndDate
                forArr.replaceObject(at: indexOfObj, with: mutableDictObj)
            }
            self.updateTimeDiff()
            self.tableView.reloadData()
        }else if  firstResponderTxtFieldTag == Int(StartTimeTxtFieldTag) || firstResponderTxtFieldTag == Int(EndTimeTxtFieldTag){
            
            if selectedSementTag == 0{
                if  firstResponderTxtFieldTag == Int(StartTimeTxtFieldTag) || firstResponderTxtFieldTag == Int(EndTimeTxtFieldTag){
                    formatter.dateFormat = "MM/dd/yyyy hh:mm a"
                    pickedDateString = formatter.string(from: changedDate as Date).lowercased()
                    
                    let   stringArray = pickedDateString.components(separatedBy: " ")
                    if stringArray.count>2{
                        pickedDateString = String(format:"%@ %@",stringArray[1],stringArray[2]).lowercased()
                        
                    }
                }
                if self.orderID.count > 0 && Int(self.orderID)! > 0{
                    if IsTotalHoursandChooseDaysSelected == true{
                        self.updateDatesFromPicker(dateString: pickedDateString, forArray: EditOrderDataArray)
                    }else{
                        self.updateDatesFromPicker(dateString: pickedDateString, forArray: EditOrderMultiDataArray)
                    }
                }else{
                    
                    self.updateDatesFromPicker(dateString: pickedDateString, forArray: dataArray)
                }
                
            }else{
                if self.orderID.count > 0 && Int(self.orderID)! > 0{
                    if IsTotalHoursandChooseDaysSelected == true{
                        self.updateDatesFromPicker(dateString: pickedDateString, forArray: EditOrderDataArray)
                        
                    }else{
                        self.updateDatesFromPicker(dateString: pickedDateString, forArray: EditOrderMultiDataArray)
                    }
                }else{
                    self.updateDatesFromPicker(dateString: pickedDateString, forArray: multiDayDataArray)
                }
            }
            //Position TableView
        }else {
            formatter.dateFormat = "MM/dd/yyyy hh:mm a"
            pickedDateString = formatter.string(from: changedDate as Date).lowercased()
            
            let   stringArray = pickedDateString.components(separatedBy: " ")
            if stringArray.count>2{
                pickedDateString = String(format:"%@ %@",stringArray[1],stringArray[2])
            }
            if self.orderID.count > 0 && Int(self.orderID)! > 0{
                if IsTotalHoursandChooseDaysSelected == true{
                    self.updateDatesFromPicker(dateString: pickedDateString, forArray: EditOrderDataArray)
                }else{
                    self.updateDatesFromPicker(dateString: pickedDateString, forArray: EditOrderMultiDataArray)
                }
            }else{
                //Time
                if selectedSementTag == 1{
                    self.updateDatesFromPicker(dateString: pickedDateString, forArray: multiDayDataArray)
                    //multi schdule array
                }else{
                    //schdule array
                    self.updateDatesFromPicker(dateString: pickedDateString, forArray: dataArray)
                }
            }
        }
        self.tableView.reloadData()
    }
    func updateDatesFromPicker(dateString: String,forArray: NSMutableArray){
        var indexOfObj = -1
        var placeholderheader = ""
        
        //get the index of the object to replace
        if firstResponderTxtFieldTag == Int(StartDateTxtFieldTag) || firstResponderTxtFieldTag == Int(EndDateTxtFieldTag) {
            placeholderheader = StartDatePlaceHolder
        }
        if  selectedSementTag == 0{
            //Date
            
            if  firstResponderTxtFieldTag == Int(StartTimeTxtFieldTag) || firstResponderTxtFieldTag == Int(EndTimeTxtFieldTag){
                
                placeholderheader = StartTimePlaceHolder
            }
            
            for dict in forArray{
                
                let   dictObj : NSDictionary = dict as! NSDictionary
                let headerValue = dictObj["header"] as! String
                
                if placeholderheader.count>0 && headerValue == placeholderheader {
                    indexOfObj = forArray.index(of: dictObj)
                    break
                }
            }
            var isMatches = false
            if indexOfObj >= 0{
                let   dictObj : NSDictionary = forArray[indexOfObj] as! NSDictionary
                let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dictObj)
                
                let startTag = Int(mutableDictObj["StartTag"] as! String)
                let endTag = Int(mutableDictObj["EndTag"] as! String)
                
                if startTag == firstResponderTxtFieldTag {
                    //once start date is changed ,end date should change change accordingly
                    mutableDictObj["StartValue"] = dateString
                    if selectedSementTag == 0{
                        mutableDictObj["EndValue"] = dateString
                    }
                    isMatches = true
                    
                }
                if endTag == firstResponderTxtFieldTag {
                    mutableDictObj["EndValue"] = dateString
                    isMatches = true
                }
                if isMatches ==  true {
                    let sValue = mutableDictObj["StartValue"] as! String
                    let eValue = mutableDictObj["EndValue"] as! String
                    var breakValue = ""
                    if mutableDictObj["BreakValue"]  != nil{
                        
                        breakValue = mutableDictObj["BreakValue"] as! String
                    }
                    if firstResponderTxtFieldTag == Int(MonStartTxtFieldTag) || firstResponderTxtFieldTag == Int(MonEndTxtFieldTag){
                        MondayStartTime = sValue
                        MondayEndTime = eValue
                        self.updateTimeDiff()
                    }
                    
                    forArray.replaceObject(at: indexOfObj, with: mutableDictObj)
                }else{
                    //                print("Did not matched")
                    //Again Check with the tag
                    self.updateWeeklyTimePickerValue(forArray: forArray, dateString: dateString)
                }
                
            }
        }else if selectedSementTag == 1{
            
            placeholderheader = "Start Time"
            self.updateWeeklyTimePickerValue(forArray: forArray, dateString: dateString)
            
        }
        
        self.tableView.reloadData()
        
        
        //let diffInDays = Calendar.current.dateComponents([.day], from: dateA, to: dateB).day
        
    }
    func updateWeeklyTimePickerValue(forArray: NSMutableArray,dateString: String){
        
        var indexOfObj = -1
        
        for d in forArray{
            let   dObj : NSDictionary = d as! NSDictionary
            
            if dObj["StartTag"] != nil || dObj["EndTag"] != nil{
                let txtFStartTag = Int(dObj["StartTag"] as! String)
                let txtFEndTag = Int(dObj["EndTag"] as! String)
                
                if txtFStartTag == firstResponderTxtFieldTag {
                    indexOfObj = forArray.index(of: dObj)
                    break
                }
                if txtFEndTag == firstResponderTxtFieldTag {
                    indexOfObj = forArray.index(of: dObj)
                    break
                }
            }else{}
        }
        if indexOfObj >= 0{
            
            let   d1 : NSDictionary = forArray[indexOfObj] as! NSDictionary
            
            let mutableDObj: NSMutableDictionary = NSMutableDictionary(dictionary: d1)
            
            let startTag = Int(mutableDObj["StartTag"] as! String)
            let endTag = Int(mutableDObj["EndTag"] as! String)
            //            let breakTag = Int(mutableDObj["breakTag"] as! String)!
            
            if startTag == firstResponderTxtFieldTag {
                mutableDObj["StartValue"] = dateString
                if firstResponderTxtFieldTag == Int(SunStartTxtFieldTag){
                    SundayStartTime = dateString
                }else if firstResponderTxtFieldTag == Int(MonStartTxtFieldTag){
                    MondayStartTime = dateString
                }else if firstResponderTxtFieldTag == Int(TueStartTxtFieldTag){
                    TuesdayStartTime = dateString
                }else if firstResponderTxtFieldTag == Int(WedStartTxtFieldTag){
                    WednesdayStartTime = dateString
                }else if firstResponderTxtFieldTag == Int(ThuStartTxtFieldTag){
                    ThursdayStartTime = dateString
                }else if firstResponderTxtFieldTag == Int(FriStartTxtFieldTag){
                    FridayStartTime = dateString
                }else if firstResponderTxtFieldTag == Int(SatStartTxtFieldTag){
                    SaturdayStartTime = dateString
                }
            }
            if endTag == firstResponderTxtFieldTag {
                mutableDObj["EndValue"] = dateString
                if firstResponderTxtFieldTag == Int(SunEndTxtFieldTag){
                    SundayEndTime = dateString
                }else if firstResponderTxtFieldTag == Int(MonEndTxtFieldTag){
                    MondayEndTime = dateString
                }else if firstResponderTxtFieldTag == Int(TueEndTxtFieldTag){
                    TuesdayEndTime = dateString
                }else if firstResponderTxtFieldTag == Int(WedEndTxtFieldTag){
                    WednesdayEndTime = dateString
                }else if firstResponderTxtFieldTag == Int(ThuEndTxtFieldTag){
                    ThursdayEndTime = dateString
                }else if firstResponderTxtFieldTag == Int(FriEndTxtFieldTag){
                    FridayEndTime = dateString
                }else if firstResponderTxtFieldTag == Int(SatEndTxtFieldTag){
                    SaturdayEndTime = dateString
                }
            }
            if startTag == Int(StartDateTxtFieldTag) || endTag == Int(EndDateTxtFieldTag){
            }else{
                let sValue = mutableDObj["StartValue"] as! String
                let eValue = mutableDObj["EndValue"] as! String
                var breakValue = ""
                
                if mutableDObj["BreakValue"] != nil{
                    breakValue = mutableDObj["BreakValue"] as! String
                }
                var timeDiff = "0"
                if sValue.count > 0 &&  eValue.count > 0{
                    let diff = self.getTimeDifference(date1: sValue, date2: eValue,breakValue:breakValue )
                    timeDiff = diff
                }
                if selectedSementTag == 0{
                    sameDayHour = timeDiff
                }else{
                    multiDayHour = timeDiff
                }
                
                self.updateTimeDiff()
            }
            if indexOfObj >= 0{
                forArray.replaceObject(at: indexOfObj, with: mutableDObj)
            }
        }
        
    }
    
    func getTimeDifference(date1: String, date2: String,breakValue: String) -> String{
        if date1.count > 0 && date2.count > 0 {
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.preferredLocale()
            dateFormatter.dateFormat = "hh:mm a"
            let date3 = dateFormatter.date(from: date1)
            let date4 = dateFormatter.date(from: date2)
            
            let interval1 = date4?.timeIntervalSince(date3!)
            let interval = Int(interval1!)
            //        print(interval)
            var minutes = (interval / 60) % 60
            var hours = (interval / 3600)
            if hours < 0 {
                hours = 24 + hours // 24 + (-2)
            }
            if minutes == 30{
                minutes = 50
            }
            let timeString = String(format: "%02d.%02d", hours, abs(minutes))
            
            var time = Double(timeString)
            var timeDiff = ""
            
            
            if breakValue == "00"{
                time = time! - 00
            }else if breakValue == "30"{
                if minutes > 0 || hours > 0{
                    time = time! - 0.50
                }
            }else if breakValue == "45"{
                if minutes > 30 || hours > 0{
                    time = time! - 0.75
                }
            }else if breakValue == "60"{
                if minutes > 45 || hours > 0{
                    time = time! - 1.00
                }
            }else{
                let  MinFloat = 60/Double(breakValue)!
                let MinuteFloat = 1/MinFloat
                time = time! - MinuteFloat
                
            }
            
            timeDiff = String(format:"%.2f", time!)
            
            return timeDiff
            
        }
        return ""
    }
    func getDaysCountWithinDates(Day: String) -> Int{
        
        let days = self.GetDaysBetweenTwoDates(mStartDate: StartCalenderDate, mEndDate:
            EndCalenderDate)
        
        let dayArray = NSMutableArray()
        for day in days{
            if day as! String == Day{
                dayArray.add(day)
            }
        }
        return dayArray.count
    }
    
    func updateTimeDiff(){
        
        var sundayDailyHrDiff:Float = Float(0)
        var mondayDailyHrDiff:Float = Float(0)
        var tuesdayDailyHrDiff:Float = Float(0)
        var wednesdayDailyHrDiff:Float = Float(0)
        var thursdayDailyHrDiff:Float = Float(0)
        var fridayDailyHrDiff:Float = Float(0)
        var saturdayDailyHrDiff:Float = Float(0)
        
        var sundayHrDiff:Float = Float(0)
        var mondayHrDiff:Float = Float(0)
        var tuesdayHrDiff:Float = Float(0)
        var wednesdayHrDiff:Float = Float(0)
        var thursdayHrDiff:Float = Float(0)
        var fridayHrDiff:Float = Float(0)
        var saturdayHrDiff:Float = Float(0)
        
        
        var sundayDailyHr = ""
        var mondayDailyHr = ""
        var tuesdayDailyHr = ""
        var wednesdayDailyHr = ""
        var thursdayDailyHr = ""
        var fridayDailyHr = ""
        var saturdayDailyHr = ""
        
        if selectedSementTag == 1{
            
            for dict in multiDayDataArray{
                let dictObj: NSDictionary = dict as! NSDictionary
                //            let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dictObj)
                //            let header = dictObj["header"] as! String
                if dictObj["isSelected"] != nil && dictObj["day"] != nil{
                    
                    
                    let isDaySelected = dictObj["isSelected"] as! String
                    let Day = dictObj["day"] as! String
                    if SundayStartTime.count > 0 &&  SundayEndTime.count > 0  && isDaySelected == "1" && Day == "SUN"{
                        
                        sundayDailyHrDiff = Float(self.getTimeDifference(date1: SundayStartTime, date2: SundayEndTime,breakValue: SundayBreakTime))!
                        sundayDailyHr = String(format:"Sun: %.2f",sundayDailyHrDiff)
                        sundayHrDiff = sundayDailyHrDiff
                        let DaysFloat = Float(self.getDaysCountWithinDates(Day: "Sunday"))
                        if DaysFloat > 0{
                            let tHrs:Float = (DaysFloat * sundayDailyHrDiff)
                            sundayHrDiff = tHrs
                        }
                    }
                        
                    else if MondayStartTime.count > 0 &&  MondayEndTime.count > 0  && isDaySelected == "1" && Day == "MON"{
                        mondayDailyHrDiff = Float(self.getTimeDifference(date1: MondayStartTime, date2: MondayEndTime,breakValue: MondayBreakTime))!
                        mondayDailyHr = String(format:"Mon: %.2f",mondayDailyHrDiff)
                        mondayHrDiff = mondayDailyHrDiff
                        
                        let DaysFloat = Float(self.getDaysCountWithinDates(Day: "Monday"))
                        if DaysFloat > 0{
                            let tHrs:Float = (DaysFloat * mondayDailyHrDiff)
                            mondayHrDiff = tHrs
                        }
                    }
                        
                    else if TuesdayStartTime.count > 0 &&  TuesdayEndTime.count > 0  && isDaySelected == "1" && Day == "TUE"{
                        tuesdayDailyHrDiff = Float(self.getTimeDifference(date1: TuesdayStartTime, date2: TuesdayEndTime,breakValue: TuesdayBreakTime))!
                        tuesdayDailyHr = String(format:"Tue: %.2f",tuesdayDailyHrDiff)
                        
                        let DaysFloat = Float(self.getDaysCountWithinDates(Day: "Tuesday"))
                        
                        tuesdayHrDiff = tuesdayDailyHrDiff
                        if DaysFloat > 0{
                            let tHrs:Float = (DaysFloat * tuesdayDailyHrDiff)
                            tuesdayHrDiff = tHrs
                        }
                        
                        
                        
                    }
                    else if WednesdayStartTime.count > 0 &&  WednesdayEndTime.count > 0  && isDaySelected == "1" && Day == "WED" {
                        wednesdayDailyHrDiff = Float(self.getTimeDifference(date1: WednesdayStartTime, date2: WednesdayEndTime,breakValue: WednesdayBreakTime))!
                        wednesdayDailyHr = String(format:"Wed: %.2f",wednesdayDailyHrDiff)
                        
                        let DaysFloat = Float(self.getDaysCountWithinDates(Day: "Wednesday"))
                        
                        wednesdayHrDiff = wednesdayDailyHrDiff
                        
                        if DaysFloat > 0{
                            let tHrs:Float = (DaysFloat * wednesdayDailyHrDiff)
                            wednesdayHrDiff = tHrs
                        }
                        
                        
                        
                    }
                    else if ThursdayStartTime.count > 0 &&  ThursdayEndTime.count > 0  && isDaySelected == "1" && Day == "THU"{
                        thursdayDailyHrDiff = Float(self.getTimeDifference(date1: ThursdayStartTime, date2: ThursdayEndTime,breakValue: ThursdayBreakTime))!
                        let DaysFloat = Float(self.getDaysCountWithinDates(Day: "Thursday"))
                        
                        
                        thursdayHrDiff = thursdayDailyHrDiff
                        
                        if DaysFloat > 0{
                            let tHrs:Float = (DaysFloat * thursdayDailyHrDiff)
                            thursdayHrDiff = tHrs
                            
                        }
                        
                        
                        thursdayDailyHr = String(format:"Thu: %.2f",thursdayDailyHrDiff)
                        
                    }
                    else if FridayStartTime.count > 0 &&  FridayEndTime.count > 0  && isDaySelected == "1" && Day == "FRI"{
                        fridayDailyHrDiff = Float(self.getTimeDifference(date1: FridayStartTime, date2: FridayEndTime,breakValue: FridayBreakTime))!
                        let DaysFloat = Float(self.getDaysCountWithinDates(Day: "Friday"))
                        fridayHrDiff = fridayDailyHrDiff
                        
                        if DaysFloat > 0{
                            let tHrs:Float = (DaysFloat * fridayDailyHrDiff)
                            fridayHrDiff = tHrs
                        }
                        
                        fridayDailyHr = String(format:"Fri: %.2f",fridayDailyHrDiff)
                        
                    }
                    else if SaturdayEndTime.count > 0 &&  SaturdayStartTime.count > 0  && isDaySelected == "1" && Day == "SAT"{
                        saturdayDailyHrDiff = Float(self.getTimeDifference(date1: SaturdayStartTime, date2: SaturdayEndTime,breakValue: SaturdayBreakTime))!
                        saturdayDailyHr = String(format:"Sat: %.2f",saturdayDailyHrDiff)
                        
                        let DaysFloat = Float(self.getDaysCountWithinDates(Day: "Saturday"))
                        saturdayHrDiff = saturdayDailyHrDiff
                        
                        if DaysFloat > 0{
                            let tHrs:Float = (DaysFloat * saturdayDailyHrDiff)
                            saturdayHrDiff = tHrs
                        }
                    }
                }
            }
        }
        
        
        let days = self.GetDaysBetweenTwoDates(mStartDate: StartCalenderDate, mEndDate: EndCalenderDate)
        
        //get the selected Days list
        
        if days.contains("Sunday"){
        }else{
            sundayHrDiff = 0
        }
        if days.contains("Monday"){
        }else{
            mondayHrDiff = 0
        }
        if days.contains("Tuesday"){
        }else{
            tuesdayHrDiff = 0
        }
        if days.contains("Wednesday"){
        }else{
            wednesdayHrDiff = 0
        }
        if days.contains("Thursday"){
        }else{
            thursdayHrDiff = 0
        }
        if days.contains("Friday"){
        }else{
            fridayHrDiff = 0
        }
        if days.contains("Saturday"){
        }else{
            saturdayHrDiff = 0
        }
        
        let totalDiffHrs = (sundayHrDiff + mondayHrDiff + tuesdayHrDiff + wednesdayHrDiff + thursdayHrDiff + fridayHrDiff + saturdayHrDiff)
        
        let timeDiff = String(format:"%.2f",totalDiffHrs)
        TotalWorkOrderHoursForMultiDay = timeDiff
        if selectedSementTag == 0{
        }else{
            multiDayHour = String(format:"%@ %@ %@ %@ %@ %@ %@",sundayDailyHr,mondayDailyHr,tuesdayDailyHr,wednesdayDailyHr,thursdayDailyHr,fridayDailyHr,saturdayDailyHr)
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Custom Cell
    func TextFieldCell( indexPath: NSIndexPath) -> TextFieldTableViewCell {
        
        let cell:TextFieldTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCellIdentifier") as! TextFieldTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(keyboardDoneBtnTapped))]
        toolBar.sizeToFit()
        cell.entryTextField.inputAccessoryView = toolBar
        cell.entryTextField.delegate = self
        
        let dict = EditOrderMultiDataArray[indexPath.row] as! NSDictionary
        let Header = dict["header"] as! String
        cell.lblHeader.text = Header
        cell.entryTextField.text = dict["Value"] as? String
        cell.entryTextField.tag = Int((dict["Tag"] as? String)!)!
        
        return cell
    }
    
    func DOEEditWorkOrderTableViewCell(indexPath: NSIndexPath) -> DOEEditWorkOrderTableViewCell {
        
        let cell:DOEEditWorkOrderTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "DOEEditWorkOrderTableViewCellIdentifier") as! DOEEditWorkOrderTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        let dict = EditOrderDataArray[indexPath.row] as! NSDictionary
        totalBilling = dict["totalBilling"] as! String
        totalHours = dict["totalHours"] as! String
        let Note = String(format:"Note: %@",dict["Note"] as! String)
        
        MondayChecked = dict["MondayChecked"] as! Bool
        TuesdayChecked = dict["TuesdayChecked"] as! Bool
        WednesdayChecked = dict["WednesdayChecked"] as! Bool
        ThursdayChecked = dict["ThursdayChecked"] as! Bool
        FridayChecked = dict["FridayChecked"] as! Bool
        SaturdayChecked = dict["SaturdayChecked"] as! Bool
        SundayChecked = dict["SundayChecked"] as! Bool
        
        cell.totalBillingTextField.text = totalBilling
        cell.totalHoursTextField.text = totalHours
        cell.totalBillingTextField.tag = Int(TotalBillingTextField_Tag)!
        cell.totalHoursTextField.tag = Int(TotalHoursTextField_Tag)!
        let TotalHourFullText = String(format:"Total Hours (Currently: %@)",OrderHours)
        let TotalHourBoldText = String(format:"(Currently: %@)",OrderHours)
        let TotalBillingFullText = String(format:"Total Billing (Currently: $%@)",CurrentTotalOrderBilling)
        let TotalBillingBoldText = String(format:"(Currently: $%@)",CurrentTotalOrderBilling)
        
        cell.lblTotalHour.halfTextMakeToBold(fullText: TotalHourFullText, changeText: TotalHourBoldText, textColor: UIColor.black)
        
        cell.lblTotalBilling.halfTextMakeToBold(fullText: TotalBillingFullText, changeText: TotalBillingBoldText, textColor: UIColor.black)
        
        cell.lblNote.halfTextMakeToBold(fullText: Note, changeText: "Note", textColor: UIColor(hexString:danger_Color))
        cell.totalBillingTextField.delegate = self
        cell.totalHoursTextField.delegate = self
        
        cell.SunBtn.isSelected = SundayChecked
        cell.FriBtn.isSelected = FridayChecked
        cell.ThuBtn.isSelected = ThursdayChecked
        cell.WedBtn.isSelected = WednesdayChecked
        cell.TueBtn.isSelected = TuesdayChecked
        cell.MonBtn.isSelected = MondayChecked
        cell.SatBtn.isSelected = SaturdayChecked
        
        cell.SunBtn.removeTarget(self, action:#selector(self.SunBtnTapped), for: .touchUpInside)
        cell.FriBtn.removeTarget(self, action:#selector(self.FriBtnTapped), for: .touchUpInside)
        cell.ThuBtn.removeTarget(self, action:#selector(self.ThuBtnTapped), for: .touchUpInside)
        cell.WedBtn.removeTarget(self, action:#selector(self.WedBtnTapped), for: .touchUpInside)
        cell.TueBtn.removeTarget(self, action:#selector(self.TueBtnTapped), for: .touchUpInside)
        cell.MonBtn.removeTarget(self, action:#selector(self.MonBtnTapped), for: .touchUpInside)
        cell.SatBtn.removeTarget(self, action:#selector(self.SatBtnTapped), for: .touchUpInside)
        
        
        cell.SunBtn.addTarget(self, action:#selector(self.SunBtnTapped), for: .touchUpInside)
        cell.FriBtn.addTarget(self, action:#selector(self.FriBtnTapped), for: .touchUpInside)
        cell.ThuBtn.addTarget(self, action:#selector(self.ThuBtnTapped), for: .touchUpInside)
        cell.WedBtn.addTarget(self, action:#selector(self.WedBtnTapped), for: .touchUpInside)
        cell.TueBtn.addTarget(self, action:#selector(self.TueBtnTapped), for: .touchUpInside)
        cell.MonBtn.addTarget(self, action:#selector(self.MonBtnTapped), for: .touchUpInside)
        cell.SatBtn.addTarget(self, action:#selector(self.SatBtnTapped), for: .touchUpInside)
        
        return cell
        
    }
    func DOEEditWorkOrderHeaderTableViewCell(indexPath: NSIndexPath) -> DOEEditWorkOrderHeaderTableViewCell {
        
        let cell:DOEEditWorkOrderHeaderTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "DOEEditWorkOrderHeaderTableViewCellIdentifier") as! DOEEditWorkOrderHeaderTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        cell.clickHereBtn.removeTarget(self, action: #selector(EditOrderClickHereBtnTapped), for: .touchUpInside)
        cell.clickHereBtn.addTarget(self, action: #selector(EditOrderClickHereBtnTapped), for: .touchUpInside)
        let selectedText = "Click Here to Enter Total Hours and Choose Days For Schedule"
        let  defultText = "Click Here to Enter Daily Hours and Pay Rate"
        
        if IsTotalHoursandChooseDaysSelected == true{
            
            let strNumber: NSString = defultText as NSString
            let range = (strNumber).range(of: defultText)
            let attribute = NSMutableAttributedString.init(string: defultText)
            attribute.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range)
            let colorCode = UserDefaults.standard.object(forKey:"ColorCode")as! String
            
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: colorCode) , range: range)
            
            cell.clickHereBtn.setAttributedTitle(attribute, for: .normal)
            
        }else{
            let strNumber: NSString = selectedText as NSString
            let range = (strNumber).range(of: selectedText)
            let attribute = NSMutableAttributedString.init(string: selectedText)
            attribute.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range)
            let colorCode = UserDefaults.standard.object(forKey:"ColorCode")as! String
            
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: colorCode) , range: range)
            
            cell.clickHereBtn.setAttributedTitle(attribute, for: .normal)
        }
        
        let fullText = String(format:"Order #%@ - Edit Work Order",self.orderID)
        
        cell.LblOrderId.halfTextMakeToBold(fullText: fullText, changeText: self.orderID, textColor: UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String))
        return cell
        
    }
    func DOEWorkOrderTableViewCell(indexPath: NSIndexPath) -> DOEWorkOrderTableViewCell {
        
        let cell:DOEWorkOrderTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "DOEWorkOrderTableViewCellIdentifier") as! DOEWorkOrderTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        
        if selectedSementTag == 0{
            let days = self.GetDaysBetweenTwoDates(mStartDate: StartCalenderDate, mEndDate: EndCalenderDate)
            
            let sameDayFloat = (sameDayHour as NSString).floatValue
            let DaysFloat = Float(days.count)
            
            let tHrs:Float = (DaysFloat * sameDayFloat)
            //            if days.count > 0{
            TotalWorkOrderHoursForSameDay = String(format:"%.2f",tHrs)
            //            }else{
            //                TotalWorkOrderHoursForSameDay = sameDayHour
            //
            //            }
            let fullText = String(format:"Daily Hours: %@",sameDayHour)
            let fullTextForHours = String(format:"Total Hours for Work Order/PO: %@",TotalWorkOrderHoursForSameDay)
            
            cell.lblDailyHoursValue.halfTextMakeToBold(fullText: fullText, changeText: sameDayHour, textColor: UIColor.black)
            cell.lblWorkOrderValue.halfTextMakeToBold(fullText: fullTextForHours, changeText: TotalWorkOrderHoursForSameDay, textColor: UIColor.black)
            
        }else{
            let fullText = String(format:"Daily Hours: %@",multiDayHour)
            let fullTextForHours = String(format:"Total Hours for Work Order/PO: %@",TotalWorkOrderHoursForMultiDay)
            
            cell.lblDailyHoursValue.halfTextMakeToBold(fullText: fullText, changeText: multiDayHour, textColor: UIColor.black)
            cell.lblWorkOrderValue.halfTextMakeToBold(fullText: fullTextForHours, changeText: TotalWorkOrderHoursForMultiDay, textColor: UIColor.black)
        }
        return cell
        
    }
    func dateViewCell(tableView: UITableView,indexPath: NSIndexPath,placeHolder: String) -> DateTableViewCell {
        
        let cell:DateTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DateTableViewCellIdentifier") as! DateTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        var startTag = 0
        var endTag = 0
        var startValue = ""
        var endValue = ""
        var header = ""
        
        cell.startTimeView.layer.borderColor = borderColor.cgColor
        cell.endTimeView.layer.borderColor = borderColor.cgColor
        cell.endTimeView.layer.borderWidth = CGFloat(1)
        cell.startTimeView.layer.borderWidth = CGFloat(1)
        var dict = NSDictionary()
        
        if self.orderID.count > 0 && Int(self.orderID)! > 0{
            if IsTotalHoursandChooseDaysSelected == true{
                dict =  EditOrderDataArray[indexPath.row] as! NSDictionary
            }else{
                dict = EditOrderMultiDataArray[indexPath.row] as! NSDictionary
            }
        }else{
            if selectedSementTag == 1{
                
                dict = multiDayDataArray[indexPath.row] as! NSDictionary
            }else{
                dict = dataArray[indexPath.row] as! NSDictionary
            }
            
        }
        
        startTag = Int(dict["StartTag"] as! String)!
        endTag = Int(dict["EndTag"] as! String)!
        startValue = dict["StartValue"] as! String
        endValue = dict["EndValue"] as! String
        header = dict["header"] as! String
        
        cell.startTimeView.layer.borderColor = borderColor.cgColor
        cell.endTimeView.layer.borderColor = borderColor.cgColor
        
        cell.textFStart.tag = startTag
        cell.textFEnd.tag = endTag
        cell.textFStart.delegate = self
        cell.textFEnd.delegate = self
        if header.contains("Time"){
            StartTime = startValue
            EndTime = endValue
            self.addRightImageToTextField(textField: cell.textFStart,imageName: "calendar_icon.png")
            self.addRightImageToTextField(textField: cell.textFEnd,imageName: "calendar_icon.png")
            
        }else if header.contains("Date"){
            if self.orderID.count > 0 && Int(self.orderID)! > 0{
                
                cell.lblEnd.text = "Order End Date"
                cell.lblStart.text = "Order Start Date"
            }else{
                cell.lblEnd.text = "End Date"
                cell.lblStart.text = "Start Date"
                
            }
            StartDate = startValue
            EndDate = endValue
            //             self.addRightImageToTextField(textField: cell.textFStart,imageName: "calendar_Bw")
            //            self.addRightImageToTextField(textField: cell.textFEnd,imageName: "calendar_Bw")
            
        }
        cell.textFStart.text = startValue
        cell.textFEnd.text = endValue
        return cell
        
    }
    func weekTimeViewCell(tableView: UITableView,indexPath: NSIndexPath) -> EnterTimeTableViewCell {
        
        let cell:EnterTimeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EnterWeeklyTimeTableViewCellIdentifier") as! EnterTimeTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        var startTag = 0
        var endTag = 0
        var startValue = ""
        var endValue = ""
        var breakTag = 0
        var breakValue = "00"
        
        cell.startTimeView.layer.borderColor = borderColor.cgColor
        cell.endTimeView.layer.borderColor = borderColor.cgColor
        cell.endTimeView.layer.borderWidth = CGFloat(1)
        cell.startTimeView.layer.borderWidth = CGFloat(1)
        
        cell.mealBreakTimeView.layer.borderWidth = CGFloat(1)
        cell.mealBreakTimeView.layer.borderColor = borderColor.cgColor
        
        cell.clearEndTimeBtn.addTarget(self, action:#selector(self.clearEndTimeBtnTapped), for: .touchUpInside)
        cell.clearStartTimeBtn.addTarget(self, action:#selector(self.clearStartTimeBtnTapped), for: .touchUpInside)
        
        let dict = multiDayDataArray[indexPath.row] as! NSDictionary
        let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dict)
        
        //        mutableDictObj["BreakValue"] = MealBreakTime
        
        multiDayDataArray.replaceObject(at: indexPath.row, with: mutableDictObj)
        
        let day = dict["day"] as! String
        
        cell.lblDay.text = day
        cell.dayView.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        customPickerView.dtPickerView.minuteInterval = Int(Original_BreakInterval)!
        
        startTag = Int(dict["StartTag"] as! String)!
        endTag = Int(dict["EndTag"] as! String)!
        startValue = dict["StartValue"] as! String
        endValue = dict["EndValue"] as! String
        breakTag = Int(dict["breakTag"] as! String)!
        breakValue = dict["BreakValue"] as! String
        
        cell.clearEndTimeBtn.tag = Int(dict["EndTag"] as! String)!
        cell.clearStartTimeBtn.tag = Int(dict["StartTag"] as! String)!
        
        cell.startTimeTxtField.tag = startTag
        cell.endTimeTxtField.tag = endTag
        cell.mealBreakTimeTxtField.tag = breakTag
        
        cell.startTimeTxtField.delegate = self
        cell.endTimeTxtField.delegate = self
        cell.mealBreakTimeTxtField.delegate = self
        cell.startTimeTxtField.text = startValue
        cell.endTimeTxtField.text = endValue
        cell.mealBreakTimeTxtField.text = breakValue
        
        self.addLeftImageToTextField(textField: cell.startTimeTxtField)
        self.addLeftImageToTextField(textField: cell.endTimeTxtField)
        
        let isSelected = dict["isSelected"] as! String
        if isSelected == "0"{
            cell.selectDayBtn.isSelected = false
        }
        else{
            cell.selectDayBtn.isSelected = true
        }
        cell.selectDayBtn.removeTarget(self, action: #selector(daySelectionBtnTapped), for: .touchUpInside)
        cell.selectDayBtn.addTarget(self, action: #selector(daySelectionBtnTapped), for: .touchUpInside)
        return cell
        
        
    }
    func TimeViewCell(tableView: UITableView,indexPath: NSIndexPath,placeHolder: String) -> EnterTimeTableViewCell {
        
        let cell:EnterTimeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EnterTimeTableViewCellIdentifier") as! EnterTimeTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        var placeholder = ""
        var subplaceholder =  ""
        var startTag = 0
        var endTag = 0
        var startValue = ""
        var endValue = ""
        var breakValue = ""
        var breakTag = 0
        
        cell.startTimeView.layer.borderColor = borderColor.cgColor
        cell.endTimeView.layer.borderColor = borderColor.cgColor
        cell.endTimeView.layer.borderWidth = CGFloat(1)
        cell.startTimeView.layer.borderWidth = CGFloat(1)
        cell.mealBreakTimeView.layer.borderWidth = CGFloat(1)
        cell.mealBreakTimeView.layer.borderColor = borderColor.cgColor
        
        
        if placeHolder.count > 0 {
            placeholder = StartTimePlaceHolder
            subplaceholder = EndTimePlaceHolder
            
        }else{
            var dict = dataArray[indexPath.row] as! NSDictionary
            
            placeholder = dict["header"] as! String
            subplaceholder = dict["subHeader"] as! String
        }
        
        
        let dict = dataArray[indexPath.row] as! NSDictionary
        let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dict)
        
        if mutableDictObj["BreakValue"] != nil{
            
            mutableDictObj["BreakValue"] = BreakInterval
        }
        
        dataArray.replaceObject(at: indexPath.row, with: mutableDictObj)
        
        startTag = Int(dict["StartTag"] as! String)!
        endTag = Int(dict["EndTag"] as! String)!
        startValue = dict["StartValue"] as! String
        endValue = dict["EndValue"] as! String
        if dict["breakTag"] != nil{
            
            breakTag = Int(dict["breakTag"] as! String)!
        }
        
        breakValue = BreakInterval
        StartTime = startValue
        EndTime = endValue
        //calculate difference
        if StartTime.count > 0 && EndTime.count > 0{
            let diff = self.getTimeDifference(date1: StartTime, date2: EndTime,breakValue: breakValue)
            //                dailyHour = diff
            sameDayHour = diff
            let indPath = IndexPath(row: 0, section: 0)
            print("StartTime")
            
            DispatchQueue.main.async(execute: { () -> Void in
                print("DispatchQueue")
                
                self.tableView.reloadRows(at: [indPath], with: .none)
            })
        }
        //
        
        cell.startTimeTxtField.tag = startTag
        cell.endTimeTxtField.tag = endTag
        cell.mealBreakTimeTxtField.tag = Int(BreakTimeTxtFieldTag)!
        
        cell.startTimeTxtField.delegate = self
        cell.endTimeTxtField.delegate = self
        cell.mealBreakTimeTxtField.delegate = self
        
        cell.startTimeTxtField.text = startValue
        cell.endTimeTxtField.text = endValue
        cell.mealBreakTimeTxtField.text = breakValue
        
        cell.endTimeView.layer.borderColor = borderColor.cgColor
        
        cell.startTimeView.layer.borderColor = borderColor.cgColor
        
        self.addLeftImageToTextField(textField: cell.startTimeTxtField)
        self.addLeftImageToTextField(textField: cell.endTimeTxtField)
        
        return cell
        
    }
    func segmentTableViewCell(tableView: UITableView) -> SegmentTableViewCell {
        
        let cell:SegmentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SegmentTableViewCellIdentifier") as! SegmentTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.white
        cell.backgroundColor = UIColor.white
        
        cell.optionSegmentControl.removeTarget(self, action:#selector(self.segmentValueChanged), for: .valueChanged)
        
        cell.optionSegmentControl.addTarget(self, action:#selector(self.segmentValueChanged), for: .valueChanged)
        cell.optionSegmentControl.tintColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        self.timeSegment = cell.optionSegmentControl
        cell.optionSegmentControlHeightConstraint.constant = 40
        cell.optionSegmentControl.layer.cornerRadius = 0
        cell.optionSegmentControl.layer.borderColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String).cgColor
        cell.optionSegmentControl.layer.borderWidth = 1
        cell.optionSegmentControl.layer.masksToBounds = true
        cell.clickHereBtn.removeTarget(self, action:#selector(self.clickHereSegBtnTapped), for: .touchUpInside)
        
        
        cell.clickHereBtn.addTarget(self, action:#selector(self.clickHereSegBtnTapped), for: .touchUpInside)
        
        let colorCode = UserDefaults.standard.object(forKey:"ColorCode")as! String
        
        if selectedSementTag == 0{
            cell.optionSegmentControl.selectedSegmentIndex = 0
            cell.SegmentControlViewTopConstraint.constant = 45
            
            //            cell.clickHereLbl.halfTextColorChange(fullText: sameDayTimePlaceHolder, changeText: "Click here", textColor: UIColor.blue)
            
            
            cell.clickHereLbl.BoldAndUnderline(fullText: sameDayTimePlaceHolder, changeText: "Click here", textColor: UIColor(hexString: colorCode), fontSize: 15)
            cell.timePlaceHolderView.isHidden = true
        }else{
            cell.SegmentControlViewTopConstraint.constant = 5
            cell.optionSegmentControl.selectedSegmentIndex = 1
            //            cell.clickHereLbl.halfTextColorChange(fullText: multiDayTimePlaceHolder, changeText: "Click here", textColor: UIColor.blue)
            cell.clickHereLbl.BoldAndUnderline(fullText: multiDayTimePlaceHolder, changeText: "Click here", textColor: UIColor(hexString: colorCode), fontSize: 15)
            
            cell.timePlaceHolderView.isHidden = false
        }
        
        cell.optionSegmentControl.layoutIfNeeded()
        
        return cell
        
    }
    func ButtonTableCell(tableView: UITableView,indexPath: NSIndexPath,identifier: String) -> ButtonTableViewCell {
        
        let cell:ButtonTableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier) as! ButtonTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        var dict = NSDictionary()
        if identifier == "EDITORDERButtonTableViewCellIdentifier"{
            cell.nextButton.removeTarget(self, action:#selector(self.SubmitChangesButtonTapped), for: .touchUpInside)
            cell.backButton.removeTarget(self, action:#selector(self.backButtonTapped), for: .touchUpInside)
            
            cell.nextButton.addTarget(self, action:#selector(self.SubmitChangesButtonTapped), for: .touchUpInside)
            cell.backButton.addTarget(self, action:#selector(self.backButtonTapped), for: .touchUpInside)
            
        }else{
            if selectedSementTag == 0{
                dict = dataArray[indexPath.row] as! NSDictionary
                
            }else{
                dict = multiDayDataArray[indexPath.row] as! NSDictionary
                
            }
            let placeholder = dict["header"] as! String
            cell.nextButton.removeTarget(self, action:#selector(self.nextButtonTapped), for: .touchUpInside)
            cell.backButton.removeTarget(self, action:#selector(self.backButtonTapped), for: .touchUpInside)
            cell.undoButton.removeTarget(self, action:#selector(self.undoButtonTapped), for: .touchUpInside)
            
            cell.nextButton.addTarget(self, action:#selector(self.nextButtonTapped), for: .touchUpInside)
            cell.backButton.addTarget(self, action:#selector(self.backButtonTapped), for: .touchUpInside)
            cell.undoButton.addTarget(self, action:#selector(self.undoButtonTapped), for: .touchUpInside)
            
            if isFromSummaryPage == true{
                cell.returnToConfirmOrderButton.removeTarget(self, action:#selector(self.returnToConfirmOrderButtonTapped), for: .touchUpInside)
                cell.returnToConfirmOrderButton.addTarget(self, action:#selector(self.returnToConfirmOrderButtonTapped), for: .touchUpInside)
                
                cell.returnToConfirmOrderButton.isHidden = false
                cell.nextButton.isHidden = true
                cell.backButton.isHidden = true
                cell.undoButton.isHidden = true
                
            }else{
                cell.returnToConfirmOrderButton.isHidden = true
                cell.nextButton.isHidden = false
                cell.backButton.isHidden = false
                cell.undoButton.isHidden = false
            }
        }
        
        return cell
        
    }
    //MARK: button action
    
    @objc func keyboardDoneBtnTapped(sender: UIButton){
        self.view.endEditing(true)
    }
    @objc func EditOrderClickHereBtnTapped(sender: UIButton){
        
        if sender.isSelected == true{
            sender.isSelected = false
            IsDailyHoursandPayRateSelected = true
            IsTotalHoursandChooseDaysSelected = false
            
        }else{
            sender.isSelected = true
            IsDailyHoursandPayRateSelected = false
            IsTotalHoursandChooseDaysSelected = true
            
        }
        self.tableView.reloadData()
    }
    
    @objc func SunBtnTapped(sender: UIButton){
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
        SundayChecked = sender.isSelected
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        
        var dict =  NSDictionary()
        if IsTotalHoursandChooseDaysSelected == true{
            dict = EditOrderDataArray[(indexPath?.row)!] as! NSDictionary
        }else{
            dict = EditOrderMultiDataArray[(indexPath?.row)!] as! NSDictionary
        }
        let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dict)
        mutableDictObj["SundayChecked"]  = SundayChecked
        if IsTotalHoursandChooseDaysSelected == true{
            EditOrderDataArray.replaceObject(at: (indexPath?.row)!, with: mutableDictObj)
            
        }else{
            EditOrderMultiDataArray.replaceObject(at: (indexPath?.row)!, with: mutableDictObj)
        }
        self.tableView.reloadData()
    }
    @objc func FriBtnTapped(sender: UIButton){
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
        FridayChecked = sender.isSelected
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        
        var dict =  NSDictionary()
        if IsTotalHoursandChooseDaysSelected == true{
            dict = EditOrderDataArray[(indexPath?.row)!] as! NSDictionary
        }else{
            dict = EditOrderMultiDataArray[(indexPath?.row)!] as! NSDictionary
        }
        let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dict)
        mutableDictObj["FridayChecked"]  = FridayChecked
        if IsTotalHoursandChooseDaysSelected == true{
            EditOrderDataArray.replaceObject(at: (indexPath?.row)!, with: mutableDictObj)
            
        }else{
            EditOrderMultiDataArray.replaceObject(at: (indexPath?.row)!, with: mutableDictObj)
        }
        self.tableView.reloadData()
    }
    @objc func ThuBtnTapped(sender: UIButton){
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
        ThursdayChecked = sender.isSelected
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        
        var dict =  NSDictionary()
        if IsTotalHoursandChooseDaysSelected == true{
            dict = EditOrderDataArray[(indexPath?.row)!] as! NSDictionary
        }else{
            dict = EditOrderMultiDataArray[(indexPath?.row)!] as! NSDictionary
        }
        let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dict)
        mutableDictObj["ThursdayChecked"]  = ThursdayChecked
        if IsTotalHoursandChooseDaysSelected == true{
            EditOrderDataArray.replaceObject(at: (indexPath?.row)!, with: mutableDictObj)
            
        }else{
            EditOrderMultiDataArray.replaceObject(at: (indexPath?.row)!, with: mutableDictObj)
        }
        self.tableView.reloadData()
    }
    @objc func WedBtnTapped(sender: UIButton){
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
        WednesdayChecked = sender.isSelected
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        
        var dict =  NSDictionary()
        if IsTotalHoursandChooseDaysSelected == true{
            dict = EditOrderDataArray[(indexPath?.row)!] as! NSDictionary
        }else{
            dict = EditOrderMultiDataArray[(indexPath?.row)!] as! NSDictionary
        }
        let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dict)
        mutableDictObj["WednesdayChecked"]  = WednesdayChecked
        if IsTotalHoursandChooseDaysSelected == true{
            EditOrderDataArray.replaceObject(at: (indexPath?.row)!, with: mutableDictObj)
            
        }else{
            EditOrderMultiDataArray.replaceObject(at: (indexPath?.row)!, with: mutableDictObj)
        }
        self.tableView.reloadData()
    }
    @objc func TueBtnTapped(sender: UIButton){
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
        TuesdayChecked = sender.isSelected
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        
        var dict =  NSDictionary()
        if IsTotalHoursandChooseDaysSelected == true{
            dict = EditOrderDataArray[(indexPath?.row)!] as! NSDictionary
        }else{
            dict = EditOrderMultiDataArray[(indexPath?.row)!] as! NSDictionary
        }
        let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dict)
        mutableDictObj["TuesdayChecked"]  = TuesdayChecked
        if IsTotalHoursandChooseDaysSelected == true{
            EditOrderDataArray.replaceObject(at: (indexPath?.row)!, with: mutableDictObj)
            
        }else{
            EditOrderMultiDataArray.replaceObject(at: (indexPath?.row)!, with: mutableDictObj)
        }
        self.tableView.reloadData()
    }
    @objc func MonBtnTapped(sender: UIButton){
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
        MondayChecked = sender.isSelected
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        
        var dict =  NSDictionary()
        if IsTotalHoursandChooseDaysSelected == true{
            dict = EditOrderDataArray[(indexPath?.row)!] as! NSDictionary
        }else{
            dict = EditOrderMultiDataArray[(indexPath?.row)!] as! NSDictionary
        }
        let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dict)
        mutableDictObj["MondayChecked"]  = MondayChecked
        if IsTotalHoursandChooseDaysSelected == true{
            EditOrderDataArray.replaceObject(at: (indexPath?.row)!, with: mutableDictObj)
            
        }else{
            EditOrderMultiDataArray.replaceObject(at: (indexPath?.row)!, with: mutableDictObj)
        }
        self.tableView.reloadData()
    }
    @objc func SatBtnTapped(sender: UIButton){
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
        SaturdayChecked = sender.isSelected
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        
        var dict =  NSDictionary()
        if IsTotalHoursandChooseDaysSelected == true{
            dict = EditOrderDataArray[(indexPath?.row)!] as! NSDictionary
        }else{
            dict = EditOrderMultiDataArray[(indexPath?.row)!] as! NSDictionary
        }
        let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dict)
        mutableDictObj["SaturdayChecked"]  = SaturdayChecked
        if IsTotalHoursandChooseDaysSelected == true{
            EditOrderDataArray.replaceObject(at: (indexPath?.row)!, with: mutableDictObj)
            
        }else{
            EditOrderMultiDataArray.replaceObject(at: (indexPath?.row)!, with: mutableDictObj)
        }
        self.tableView.reloadData()
    }
    
    
    
    func addRightImageToTextField(textField: UITextField,imageName: String ){
        
        let imageView = UIImageView.init(frame: CGRect(x:0,y:0,width:20,height:20));
        let image = UIImage(named: imageName);
        imageView.image = image;
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        textField.rightView = imageView;
        textField.rightViewMode = UITextField.ViewMode.always
        textField.rightViewMode = .always
        
    }
    func addLeftImageToTextField(textField: UITextField){
        let imageView = UIImageView.init(frame: CGRect(x:0,y:0,width:20,height:20));
        let image = UIImage(named: "Timeslips");
        imageView.image = image;
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        textField.leftView = imageView;
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftViewMode = .always
        
    }
    //MARK: Button Action
    @objc func returnToConfirmOrderButtonTapped(sender: UIButton){
        self.ValidateSchduleCall()
    }
    @objc func nextButtonTapped(_ sender: UIButton){
        
        var TotalWorkOrderHours = ""
        if selectedSementTag == 0{
            TotalWorkOrderHours = TotalWorkOrderHoursForSameDay
        }else{
            TotalWorkOrderHours = TotalWorkOrderHoursForMultiDay
        }
        let tWO = Double(TotalWorkOrderHours)
        
        if (tWO?.isEqual(to: 0))! {
            WarningConfirm = false
            SuccessAlert = false
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Invalid worked hours. Hours can't be zero", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            self.ValidateSchduleCall()
        }
        
        
    }
    
    @objc func backButtonTapped(_ sender: UIButton){
        if self.orderID.count > 0 && Int(self.orderID)! > 0{
            self.pushToSummaryPage()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc func SubmitChangesButtonTapped(_ sender: UIButton){
        
        //call the API for
        self.SubmitEditOrderChangesCall()
    }
    
    @objc func undoButtonTapped(_ sender: UIButton){
        
        WednesdayStartTime =   Original_WednesdayStartTime
        WednesdayEndTime = Original_WednesdayEndTime
        WednesdayBreakTime = Original_WednesdayBreakTime
        
        
        MondayStartTime = Original_MondayStartTime
        MondayEndTime =  Original_MondayEndTime
        MondayBreakTime =  Original_MondayBreakTime
        
        TuesdayStartTime =  Original_TuesdayStartTime
        TuesdayEndTime = Original_TuesdayEndTime
        TuesdayBreakTime = Original_TuesdayBreakTime
        
        ThursdayStartTime = Original_ThursdayStartTime
        ThursdayEndTime = Original_ThursdayEndTime
        ThursdayBreakTime = Original_ThursdayBreakTime
        
        FridayStartTime = Original_FridayStartTime
        FridayEndTime =  Original_FridayEndTime
        FridayBreakTime =   Original_FridayBreakTime
        
        SaturdayStartTime = Original_SaturdayStartTime
        SaturdayEndTime = Original_SaturdayEndTime
        SaturdayBreakTime =  Original_SaturdayBreakTime
        
        SundayStartTime = Original_SundayStartTime
        SundayEndTime =  Original_SundayEndTime
        SundayBreakTime = Original_SundayBreakTime
        
        StartDate = Original_StartDate
        EndDate = Original_EndDate
        StartTime =  Original_StartTime
        EndTime = Original_EndTime
        BreakInterval = Original_BreakInterval
        DailyHours = Original_DailyHours
        TotalHours = Original_TotalHours
        StartCalenderDate = self.ConvertStringToDate(DateString: StartDate)
        EndCalenderDate = self.ConvertStringToDate(DateString: EndDate)
        
        self.formMultiDayArray()
        
        self.formDataArrayForTableview()
        self.formMultiDayDataArray()
        if StartTime.count > 0 && EndTime.count > 0{
            let diff = self.getTimeDifference(date1: StartTime, date2: EndTime,breakValue: BreakInterval)
            //                dailyHour = diff
            sameDayHour = diff
            
        }
        self.tableView.reloadData()
    }
    @objc func daySelectionBtnTapped(sender: UIButton){
        
        if sender.isSelected == true {
            
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        
        if selectedSementTag == 1{
            //
            let dict = multiDayDataArray[(indexPath?.row)!] as! NSDictionary
            let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dict)
            
            let isSelected = dict["isSelected"] as! String
            if isSelected == "0"{
                mutableDictObj["isSelected"] = "1"
            }else{
                mutableDictObj["isSelected"] = "0"
            }
            multiDayDataArray.replaceObject(at: (indexPath?.row)!, with: mutableDictObj)
        }
        self.updateTimeDiff()
        self.tableView.reloadData()
        
        
        //        "isSelected"
    }
    @objc func clearStartTimeBtnTapped(sender: UIButton){
        
        firstResponderTxtFieldTag = sender.tag
        
        //Time
        if selectedSementTag == 1{
            self.updateDatesFromPicker(dateString: "", forArray: multiDayDataArray)
            //multi schdule array
        }else{
            //schdule array
            self.updateDatesFromPicker(dateString: "", forArray: dataArray)
            
        }
        self.tableView.reloadData()
        //        self.reloadTableViewRow(sender: sender)
    }
    @objc func clearEndTimeBtnTapped(sender: UIButton){
        
        firstResponderTxtFieldTag = sender.tag
        //Time
        if selectedSementTag == 1{
            self.updateDatesFromPicker(dateString: "", forArray: multiDayDataArray)
            //multi schdule array
        }else{
            //schdule array
            self.updateDatesFromPicker(dateString: "", forArray: dataArray)
            
        }
        
        self.tableView.reloadData()
        
    }
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0{
            selectedSementTag = 0
            segHeader = HeaderName
        }else{
            selectedSementTag = 1
            segHeader = SelectedHeaderName
            
        }
        self.tableView.reloadData()
    }
    @objc func clickHereSegBtnTapped(_ sender: UIButton) {
        
        if self.timeSegment .selectedSegmentIndex == 0{
            self.timeSegment.selectedSegmentIndex = 1
            selectedSementTag = 1
        }else{
            selectedSementTag = 0
            self.timeSegment.selectedSegmentIndex = 0
        }
        self.tableView.reloadData()
    }
    @IBAction override func okButtonTapped(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        if firstTimePopUp == true{
            WarningConfirm = true
        }
        if SecondTimePopUp == true{
            AlertContinueMessageConfirm = "yes"
        }
        if WarningConfirm == true && SuccessAlert == false{
            self.SubmitEditOrderChangesCall()
        }else if SuccessAlert == true{
            //push to order details page
            self.pushToSummaryPage()
        }
    }
    @IBAction override func cancelBtnTapped(_ sender: Any) {
        
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        if firstTimePopUp == true{
            WarningConfirm = false
            firstTimePopUp = false
            SecondTimePopUp = false
            AlertContinueMessageConfirm  = ""
        }else if SecondTimePopUp == true{
            firstTimePopUp = false
            SecondTimePopUp = false
            AlertContinueMessageConfirm  = ""
        }
    }
    //MARK:Server Call
    func ValidateSchduleCall(){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            //            JustHUD.shared.showInView(view: view)
            self.showLoading()
            let defaults = UserDefaults.standard
            
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            let ClientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let UserName = String(format:"%@", UserDefaults.standard.string(forKey: "UserName")!)
            
            
            /////
            
            var param = NSMutableDictionary()
            var schdule = ""
            var isSingleDaySchdule = false
            
            var TotalWorkOrderHours = ""
            if selectedSementTag == 0{
                TotalWorkOrderHours = TotalWorkOrderHoursForSameDay
            }else{
                TotalWorkOrderHours = TotalWorkOrderHoursForMultiDay
            }
            
            param = ["EndDate":EndDate,"StartDate":StartDate,"TotalHours":TotalWorkOrderHours,"ContactId":ContactId,"ClientID":ClientID,"UserName":UserName,"CandidateId":selectedApplicant.CandidateId]
            
            for dict in multiDayDataArray{
                let dictObj: NSDictionary = dict as! NSDictionary
                if dictObj["isSelected"] != nil && dictObj["day"] != nil{
                    
                    let isDaySelected = dictObj["isSelected"] as! String
                    let Day = dictObj["day"] as! String
                    if SundayStartTime.count > 0 &&  SundayEndTime.count > 0    && Day == "SUN"{
                        var IsSchedule = isDaySelected == "1" ? true : false
                        if selectedSementTag == 0{
                            IsSchedule = false
                        }
                        let  SundayDict = ["EndTime":SundayEndTime.lowercased(),"MealBreak":SundayBreakTime.lowercased(),"StartTime":SundayStartTime.lowercased(),"IsSchedule":IsSchedule] as [String : Any]
                        param["Sunday"] = SundayDict
                    }
                    else if MondayStartTime.count > 0 &&  MondayEndTime.count > 0    && Day == "MON"{
                        var IsSchedule = isDaySelected == "1" ? true : false
                        if selectedSementTag == 0{
                            IsSchedule = false
                        }
                        let  MondayDict = ["EndTime":MondayEndTime.lowercased(),"MealBreak":MondayBreakTime.lowercased(),"StartTime":MondayStartTime.lowercased(),"IsSchedule":IsSchedule] as [String : Any]
                        param["Monday"] = MondayDict
                    }
                    else if TuesdayStartTime.count > 0 &&  TuesdayEndTime.count > 0   && Day == "TUE"{
                        var IsSchedule = isDaySelected == "1" ? true : false
                        if selectedSementTag == 0{
                            IsSchedule = false
                        }
                        
                        let  TuesdayDict = ["EndTime":TuesdayEndTime.lowercased(),"MealBreak":TuesdayBreakTime.lowercased(),"StartTime":TuesdayStartTime.lowercased(),"IsSchedule":IsSchedule] as [String : Any]
                        param["Tuesday"] = TuesdayDict
                    }
                    else if WednesdayStartTime.count > 0 &&  WednesdayEndTime.count > 0    && Day == "WED" {
                        var IsSchedule = isDaySelected == "1" ? true : false
                        if selectedSementTag == 0{
                            IsSchedule = false
                        }
                        
                        let  WednesayDict = ["EndTime":WednesdayEndTime.lowercased(),"MealBreak":WednesdayBreakTime.lowercased(),"StartTime":WednesdayStartTime.lowercased(),"IsSchedule":IsSchedule] as [String : Any]
                        param["Wednesday"] = WednesayDict
                    }
                    else if ThursdayStartTime.count > 0 &&  ThursdayEndTime.count > 0 && Day == "THU"{
                        var IsSchedule = isDaySelected == "1" ? true : false
                        if selectedSementTag == 0{
                            IsSchedule = false
                        }
                        
                        let  ThursdayDict = ["EndTime":ThursdayEndTime.lowercased(),"MealBreak":ThursdayBreakTime.lowercased(),"StartTime":ThursdayStartTime.lowercased(),"IsSchedule":IsSchedule] as [String : Any]
                        param["Thursday"] = ThursdayDict
                    }
                    else if FridayStartTime.count > 0 &&  FridayEndTime.count > 0   && Day == "FRI"{
                        var IsSchedule = isDaySelected == "1" ? true : false
                        if selectedSementTag == 0{
                            IsSchedule = false
                        }
                        
                        let  FridayDict = ["EndTime":FridayEndTime.lowercased(),"MealBreak":FridayBreakTime.lowercased(),"StartTime":FridayStartTime.lowercased(),"IsSchedule":IsSchedule] as [String : Any]
                        param["Friday"] = FridayDict
                    }
                    else if SaturdayEndTime.count > 0 &&  SaturdayStartTime.count > 0  && Day == "SAT"{
                        var IsSchedule = isDaySelected == "1" ? true : false
                        if selectedSementTag == 0{
                            IsSchedule = false
                        }
                        
                        let   SaturdayDict = ["EndTime":SaturdayEndTime.lowercased(),"MealBreak":SaturdayBreakTime.lowercased(),"StartTime":SaturdayStartTime.lowercased(),"IsSchedule":IsSchedule] as [String : Any]
                        param["Saturday"] = SaturdayDict
                    }
                }
            }
            if selectedSementTag == 1{
                schdule = "n"
                isSingleDaySchdule = false
                
            }
            else if selectedSementTag == 0{
                schdule = "s"
                isSingleDaySchdule = true
            }
            
            let   weekdayDict = ["EndTime":EndTime,"MealBreak":BreakInterval,"StartTime":StartTime,"IsSchedule":isSingleDaySchdule] as [String : Any]
            param["WeekDay"] = weekdayDict
            param["Schedule"] = schdule
            
            
            print(param)
            
            ///
            let urlString = RestAPI.BaseUrl+RestAPI.DOE_Validate_Schdule_URL
            
            RestAPI.postRequestWithToken(urlString: urlString, params: param, callback: getValidationResponse(response:))
            
            //            RestAPI.ValidateDoeSchdule(self, params: param as! [String : String], method: "POST", accessToken: "", acces: true, callBack: getValidationResponse(response:))
        }else{
            WarningConfirm = false
            SuccessAlert = false
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    func saveTheValuesInUserdefaults(){
        let defaults = UserDefaults.standard
        
        
        /////
        
        var param = NSMutableDictionary()
        var schdule = ""
        var isSingleDaySchdule = false
        
        var TotalWorkOrderHours = ""
        if selectedSementTag == 0{
            TotalWorkOrderHours = TotalWorkOrderHoursForSameDay
        }else{
            TotalWorkOrderHours = TotalWorkOrderHoursForMultiDay
        }
        
        param = ["EndDate":EndDate,"StartDate":StartDate,"TotalHours":TotalWorkOrderHours]
        
        for dict in multiDayDataArray{
            let dictObj: NSDictionary = dict as! NSDictionary
            if dictObj["isSelected"] != nil && dictObj["day"] != nil{
                
                let isDaySelected = dictObj["isSelected"] as! String
                let Day = dictObj["day"] as! String
                if SundayStartTime.count > 0 &&  SundayEndTime.count > 0    && Day == "SUN"{
                    var IsSchedule = isDaySelected == "1" ? true : false
                    if selectedSementTag == 0{
                        IsSchedule = false
                    }
                    let  SundayDict = ["EndTime":SundayEndTime.lowercased(),"MealBreak":SundayBreakTime.lowercased(),"StartTime":SundayStartTime.lowercased(),"IsSchedule":IsSchedule] as [String : Any]
                    param["Sunday"] = SundayDict
                }
                else if MondayStartTime.count > 0 &&  MondayEndTime.count > 0    && Day == "MON"{
                    var IsSchedule = isDaySelected == "1" ? true : false
                    if selectedSementTag == 0{
                        IsSchedule = false
                    }
                    let  MondayDict = ["EndTime":MondayEndTime.lowercased(),"MealBreak":MondayBreakTime.lowercased(),"StartTime":MondayStartTime.lowercased(),"IsSchedule":IsSchedule] as [String : Any]
                    param["Monday"] = MondayDict
                }
                else if TuesdayStartTime.count > 0 &&  TuesdayEndTime.count > 0   && Day == "TUE"{
                    var IsSchedule = isDaySelected == "1" ? true : false
                    if selectedSementTag == 0{
                        IsSchedule = false
                    }
                    
                    let  TuesdayDict = ["EndTime":TuesdayEndTime.lowercased(),"MealBreak":TuesdayBreakTime.lowercased(),"StartTime":TuesdayStartTime.lowercased(),"IsSchedule":IsSchedule] as [String : Any]
                    param["Tuesday"] = TuesdayDict
                }
                else if WednesdayStartTime.count > 0 &&  WednesdayEndTime.count > 0    && Day == "WED" {
                    var IsSchedule = isDaySelected == "1" ? true : false
                    if selectedSementTag == 0{
                        IsSchedule = false
                    }
                    
                    let  WednesayDict = ["EndTime":WednesdayEndTime.lowercased(),"MealBreak":WednesdayBreakTime.lowercased(),"StartTime":WednesdayStartTime.lowercased(),"IsSchedule":IsSchedule] as [String : Any]
                    param["Wednesday"] = WednesayDict
                }
                else if ThursdayStartTime.count > 0 &&  ThursdayEndTime.count > 0 && Day == "THU"{
                    var IsSchedule = isDaySelected == "1" ? true : false
                    if selectedSementTag == 0{
                        IsSchedule = false
                    }
                    
                    let  ThursdayDict = ["EndTime":ThursdayEndTime.lowercased(),"MealBreak":ThursdayBreakTime.lowercased(),"StartTime":ThursdayStartTime.lowercased(),"IsSchedule":IsSchedule] as [String : Any]
                    param["Thursday"] = ThursdayDict
                }
                else if FridayStartTime.count > 0 &&  FridayEndTime.count > 0   && Day == "FRI"{
                    var IsSchedule = isDaySelected == "1" ? true : false
                    if selectedSementTag == 0{
                        IsSchedule = false
                    }
                    
                    let  FridayDict = ["EndTime":FridayEndTime.lowercased(),"MealBreak":FridayBreakTime.lowercased(),"StartTime":FridayStartTime.lowercased(),"IsSchedule":IsSchedule] as [String : Any]
                    param["Friday"] = FridayDict
                }
                else if SaturdayEndTime.count > 0 &&  SaturdayStartTime.count > 0  && Day == "SAT"{
                    var IsSchedule = isDaySelected == "1" ? true : false
                    if selectedSementTag == 0{
                        IsSchedule = false
                    }
                    
                    let   SaturdayDict = ["EndTime":SaturdayEndTime.lowercased(),"MealBreak":SaturdayBreakTime.lowercased(),"StartTime":SaturdayStartTime.lowercased(),"IsSchedule":IsSchedule] as [String : Any]
                    param["Saturday"] = SaturdayDict
                }
            }
        }
        if selectedSementTag == 1{
            schdule = "n"
            isSingleDaySchdule = false
            
        }
        else if selectedSementTag == 0{
            schdule = "s"
            isSingleDaySchdule = true
        }
        
        let   weekdayDict = ["EndTime":EndTime,"MealBreak":BreakInterval,"StartTime":StartTime,"IsSchedule":isSingleDaySchdule] as [String : Any]
        param["WeekDay"] = weekdayDict
        param["Schedule"] = schdule
        
        defaults.set(param, forKey: "DoeScheduleModel")
        defaults.synchronize()
        
    }
    func getSchduleFromOrderIDCall(){
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            //            JustHUD.shared.showInView(view: view)
            self.showLoading()
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let DoeEditWorkOrderModel = ["Name":defaults.value(forKey: "CandName")]
            
            let param = ["DoeEditWorkOrderModel": DoeEditWorkOrderModel,
                         "ClientID":clientID,
                         "orderid":self.orderID,
                         "caller":"1",
                         "isWaiverform": "false"
                ] as [String : Any]
            print(param)
            let urlString = RestAPI.BaseUrl+RestAPI.DOE_Get_Edit_WorkOrder_URL
            
            RestAPI.postRequestWithToken(urlString: urlString, params: param, callback: getSchduleOrderResponse(response:))
            
        }else{
            WarningConfirm = false
            SuccessAlert = false
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    func getSchduleCall(){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            //            JustHUD.shared.showInView(view: view)
            self.showLoading()
            let defaults = UserDefaults.standard
            
            
            
            
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let UserName = String(format:"%@", UserDefaults.standard.string(forKey: "UserName")!)
            
            let params :[String:String] = ["ContactId":ContactId,"ClientID":clientID,"UserName": UserName,"CandidateId": selectedApplicant.CandidateId!]
            
            print(params)
            RestAPI.getDoeSchduleData(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getSchduleResponse(response:))
        }else{
            WarningConfirm = false
            SuccessAlert = false
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    func getSchduleOrderResponse(response:AnyObject)->()
    {
        self.hideLoading()
        print(response)
        if response is String{
            
            var message = response as! String
            if message.count == 0 {
                message = Error_Message
            }
            WarningConfirm = false
            SuccessAlert = false
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }else{
            
            var object = response as! JSON
            if object["MessageStatus"].intValue == 1
            {
                EditOrderDataArray.removeAllObjects()
                StartDate = object["StartDate"].stringValue
                EndDate = object["EndDate"].stringValue
                CurrentTotalOrderBilling = object["CurrentTotalOrderBilling"].stringValue
                OrderHours = object["OrderHours"].stringValue
                MondayChecked = object["MondayChecked"].boolValue
                TuesdayChecked = object["TuesdayChecked"].boolValue
                WednesdayChecked = object["WednesdayChecked"].boolValue
                ThursdayChecked = object["ThursdayChecked"].boolValue
                FridayChecked = object["FridayChecked"].boolValue
                SaturdayChecked = object["SaturdayChecked"].boolValue
                SundayChecked = object["SundayChecked"].boolValue
                StartCalenderDate = self.ConvertStringToDate(DateString: StartDate)
                EndCalenderDate = self.ConvertStringToDate(DateString: EndDate)
                
                
                let workOrderDict = ["header":"Work Order"]
                
                let ÐateDict = ["header":StartDatePlaceHolder,"subHeader":EndDatePlaceHolder,"StartTag":StartDateTxtFieldTag,"EndTag":EndDateTxtFieldTag,"StartValue":StartDate,"EndValue":EndDate]
                
                let valueDict = ["header":"Enter Total Value",
                                 "totalBilling":object["Total_Billing"].stringValue,
                                 "totalHours":object["Total_Hours"].stringValue,
                                 "Note":object["Note"].stringValue,
                                 "MondayChecked": MondayChecked,
                                 "TuesdayChecked":  TuesdayChecked ,
                                 "WednesdayChecked":  WednesdayChecked ,
                                 "ThursdayChecked":  ThursdayChecked ,
                                 "FridayChecked":  FridayChecked ,
                                 "SaturdayChecked":  SaturdayChecked ,
                                 "SundayChecked":  SundayChecked ] as [String : Any]
                let MondayDict = ["header":"Monday Hours","Tag":Edit_Order_MonTxtFieldTag,"Value": object["MondayHours"].stringValue]
                let TuesdayDict = ["header":"Tuesday Hours","Tag":Edit_Order_TueTxtFieldTag,"Value": object["TuesdayHours"].stringValue]
                let WednesdayDict = ["header":"Wednesday Hours","Tag":Edit_Order_WedTxtFieldTag,"Value": object["WednesdayHours"].stringValue]
                let ThursdayDict = ["header":"Thursday Hours","Tag":Edit_Order_ThuTxtFieldTag,"Value": object["ThursdayHours"].stringValue]
                let FridayDict = ["header":"Friday Hours","Tag":Edit_Order_FriTxtFieldTag,"Value": object["FridayHours"].stringValue]
                let SaturdayDict = ["header":"Saturday Hours","Tag":Edit_Order_SatTxtFieldTag,"Value": object["SaturdayHours"].stringValue]
                let SundayDict = ["header":"Sunday Hours","Tag":Edit_Order_SunTxtFieldTag,"Value": object["SundayHours"].stringValue]
                
                let nextBtnDict = ["header":"Next"]
                
                EditOrderDataArray = [workOrderDict,ÐateDict,valueDict,nextBtnDict]
                EditOrderMultiDataArray = [workOrderDict,ÐateDict,MondayDict,TuesdayDict,WednesdayDict,ThursdayDict,FridayDict,SaturdayDict,SundayDict,nextBtnDict]
                self.tableView.reloadData()
                
            }else{
                WarningConfirm = false
                SuccessAlert = false
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }
    }
    
    func getValidationResponse(response:AnyObject)->()
    {
        self.hideLoading()
        print(response)
        if response is String{
            //            lblNoData.isHidden = false
            var message = response as! String
            if message.count == 0 {
                message = Error_Message
            }
            WarningConfirm = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }else{
            
            var object = response as! JSON
            if object["MessageStatus"].intValue == 1
            {
                
                ///
                
                let defaults = UserDefaults.standard
                
                var param = NSMutableDictionary()
                let ScheduleValue = object["Schedule"].stringValue
                
                param = ["EndDate":object["EndDate"].stringValue,"StartDate":object["StartDate"].stringValue,"TotalHours":object["TotalHours"].stringValue]
                
                if ScheduleValue == "s"{
                    let   weekdayDict = ["EndTime":object["EndTime"].stringValue,"MealBreak":object["MealBreak"].stringValue,"StartTime":object["StartTime"].stringValue,"IsSchedule":object["IsSchedule"].boolValue] as [String : Any]
                    param["WeekDay"] = weekdayDict
                    
                }else{
                    if object["Saturday"] != nil{
                        //                        let isSchdule = object["IsSchedule"].boolValue
                        //                        if isSchdule == true{
                        let  SaturdayDict = ["EndTime":object["EndTime"].stringValue,"MealBreak":object["MealBreak"].stringValue,"StartTime":object["StartTime"].stringValue,"IsSchedule":object["IsSchedule"].boolValue] as [String : Any]
                        param["Saturday"] = SaturdayDict
                        //                        }
                    }
                    if object["Sunday"] != nil{
                        //                        let isSchdule = object["IsSchedule"].boolValue
                        //                        if isSchdule == true{
                        let  SundayDict = ["EndTime":object["EndTime"].stringValue,"MealBreak":object["MealBreak"].stringValue,"StartTime":object["StartTime"].stringValue,"IsSchedule":object["IsSchedule"].boolValue] as [String : Any]
                        param["Sunday"] = SundayDict
                        //                        }
                    }
                    if object["Monday"] != nil{
                        //                        let isSchdule = object["IsSchedule"].boolValue
                        //                        if isSchdule == true{
                        let  MondayDict = ["EndTime":object["EndTime"].stringValue,"MealBreak":object["MealBreak"].stringValue,"StartTime":object["StartTime"].stringValue,"IsSchedule":object["IsSchedule"].boolValue] as [String : Any]
                        param["Monday"] = MondayDict
                        //                        }
                    }
                    if object["Tuesday"] != nil{
                        //                        let isSchdule = object["IsSchedule"].boolValue
                        //                        if isSchdule == true{
                        let  TuesdayDict = ["EndTime":object["EndTime"].stringValue,"MealBreak":object["MealBreak"].stringValue,"StartTime":object["StartTime"].stringValue,"IsSchedule":object["IsSchedule"].boolValue] as [String : Any]
                        param["Tuesday"] = TuesdayDict
                        //                        }
                    }
                    if object["Wednesday"] != nil{
                        //                        let isSchdule = object["IsSchedule"].boolValue
                        //                        if isSchdule == true{
                        let  WednesdayDict = ["EndTime":object["EndTime"].stringValue,"MealBreak":object["MealBreak"].stringValue,"StartTime":object["StartTime"].stringValue,"IsSchedule":object["IsSchedule"].boolValue] as [String : Any]
                        param["Wednesday"] = WednesdayDict
                        //                        }
                    }
                    if object["Thursday"] != nil{
                        //                        let isSchdule = object["IsSchedule"].boolValue
                        //                        if isSchdule == true{
                        let  ThursdayDict = ["EndTime":object["EndTime"].stringValue,"MealBreak":object["MealBreak"].stringValue,"StartTime":object["StartTime"].stringValue,"IsSchedule":object["IsSchedule"].boolValue] as [String : Any]
                        param["Thursday"] = ThursdayDict
                        //                        }
                    }
                    if object["Friday"] != nil{
                        //                        let isSchdule = object["IsSchedule"].boolValue
                        //                        if isSchdule == true{
                        let  FridayDict = ["EndTime":object["EndTime"].stringValue,"MealBreak":object["MealBreak"].stringValue,"StartTime":object["StartTime"].stringValue,"IsSchedule":object["IsSchedule"].boolValue] as [String : Any]
                        param["Friday"] = FridayDict
                        //                        }
                    }
                }
                
                param["Schedule"] = ScheduleValue
                //                defaults.set(param, forKey: "DoeScheduleModel")
                //                defaults.synchronize()
                self.saveTheValuesInUserdefaults()
                ////
                var selectedApplicant = Applicant.init(CandidateId: "0", ApplicantId: "", Name: "", ConsultantType: "", Email: "", Address: "", City: "", State: "", Zip: "", SSN: "", isSelected: "",appliType: "",ApplicationId:  "0",NewApplicant:  "",extraCandId: "0")
                
                if defaults.object(forKey: "DoeApplicantModel") != nil{
                    let decoded  = defaults.object(forKey: "DoeApplicantModel") as! Data
                    let decodedApplicant = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Applicant
                    selectedApplicant = decodedApplicant
                }
                //if selected candidate is there,
                //else summary
                if Int(selectedApplicant.CandidateId!)! == 0 && Int(selectedApplicant.ApplicationId!)! == 0 && Int(selectedApplicant.extraCandId!)! == 0 {
                    self.pushToSummaryPage()
                }else{
                    if isFromSummaryPage == true{
                        self.pushToSummaryPage()
                    }else{
                        self.pushToDOEPayratepage()
                    }
                }
                
            }else{
                WarningConfirm = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }
    }
    
    func getSchduleResponse(response:AnyObject)->()
    {
        
        //        JustHUD.shared.hide()
        
        self.hideLoading()
        print(response)
        if response is String{
            //            lblNoData.isHidden = false
            var message = response as! String
            if message.count == 0 {
                message = Error_Message
            }
            WarningConfirm = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                let orderDataArray = NSMutableArray()
                orderDataArray .removeAllObjects()
                
                
                if object["Wednesday"] != nil{
                    let dayDict = object["Wednesday"].dictionary
                    WednesdayStartTime = (dayDict!["StartTime"]?.stringValue)!.lowercased()
                    WednesdayEndTime = (dayDict!["EndTime"]?.stringValue)!.lowercased()
                    WednesdayBreakTime = (dayDict!["MealBreak"]?.stringValue)!.lowercased()
                    
                }
                if object["Monday"] != nil{
                    let dayDict = object["Monday"].dictionary
                    MondayStartTime = (dayDict!["StartTime"]?.stringValue)!.lowercased()
                    MondayEndTime = (dayDict!["EndTime"]?.stringValue)!.lowercased()
                    MondayBreakTime = (dayDict!["MealBreak"]?.stringValue)!.lowercased()
                }
                if object["Tuesday"] != nil{
                    let dayDict = object["Tuesday"].dictionary
                    TuesdayStartTime = (dayDict!["StartTime"]?.stringValue)!.lowercased()
                    TuesdayEndTime = (dayDict!["EndTime"]?.stringValue)!.lowercased()
                    TuesdayBreakTime = (dayDict!["MealBreak"]?.stringValue)!.lowercased()
                }
                if object["Thursday"] != nil{
                    let dayDict = object["Thursday"].dictionary
                    ThursdayStartTime = (dayDict!["StartTime"]?.stringValue)!.lowercased()
                    ThursdayEndTime = (dayDict!["EndTime"]?.stringValue)!.lowercased()
                    ThursdayBreakTime = (dayDict!["MealBreak"]?.stringValue)!.lowercased()
                }
                if object["Friday"] != nil{
                    let dayDict = object["Friday"].dictionary
                    FridayStartTime = (dayDict!["StartTime"]?.stringValue)!
                    FridayEndTime = (dayDict!["EndTime"]?.stringValue)!
                    FridayBreakTime = (dayDict!["MealBreak"]?.stringValue)!
                }
                if object["Saturday"] != nil{
                    let dayDict = object["Saturday"].dictionary
                    SaturdayStartTime = (dayDict!["StartTime"]?.stringValue)!.lowercased()
                    SaturdayEndTime = (dayDict!["EndTime"]?.stringValue)!.lowercased()
                    SaturdayBreakTime = (dayDict!["MealBreak"]?.stringValue)!.lowercased()
                }
                if object["Sunday"] != nil{
                    let dayDict = object["Sunday"].dictionary
                    SundayStartTime = (dayDict!["StartTime"]?.stringValue)!.lowercased()
                    SundayEndTime = (dayDict!["EndTime"]?.stringValue)!.lowercased()
                    SundayBreakTime = (dayDict!["MealBreak"]?.stringValue)!.lowercased()
                }
                if object["WeekDay"] != nil{
                    let dayDict = object["WeekDay"].dictionary
                    StartTime =  (dayDict!["StartTime"]?.stringValue)!.lowercased()
                    EndTime = (dayDict!["EndTime"]?.stringValue)!.lowercased()
                    BreakInterval = (dayDict!["MealBreak"]?.stringValue)!.lowercased()
                }
                DailyHours = object["DailyHours"].stringValue.lowercased()
                TotalHours = object["TotalHours"].stringValue.lowercased()
                
                StartDate = object["StartDate"].stringValue
                EndDate = object["EndDate"].stringValue
                StartCalenderDate = self.ConvertStringToDate(DateString: StartDate)
                EndCalenderDate = self.ConvertStringToDate(DateString: EndDate)
                self.SaveTheValuesForUndoFunctionality()
                
                self.formMultiDayArray()
                
                self.formDataArrayForTableview()
                self.formMultiDayDataArray()
                if StartTime.count > 0 && EndTime.count > 0{
                    let diff = self.getTimeDifference(date1: StartTime, date2: EndTime,breakValue: BreakInterval)
                    //                dailyHour = diff
                    sameDayHour = diff
                    
                }
                self.tableView.reloadData()
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                WarningConfirm = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }
    }
    
    
    /*"Caller":"1",//hc
     "ClientId":    44886,
     "CurrentTotalOrderBilling":    423.220,//get res
     "OrderHours":7,///get res
     "StartDate":"04/17/2018",
     "EndDate":"04/17/2018",
     "JustDatesChanged":    0,//hc
     "Name":"pkadrikar",
     "OrderId":906412,
     "Total_Billing":null,//Total Billing(Currently:$0.00)
     "Total_Hours":null,//Total Hours(Currently:7)
     "MondayChecked":true,
     "MondayHours":    7,
     "TuesdayChecked":true,
     "TuesdayHours":    7,
     "WednesdayChecked":    true,
     "WednesdayHours":7,
     "ThursdayChecked":    true,
     "ThursdayHours":7,
     "FridayChecked":true,
     "FridayHours":7,
     "SaturdayChecked":false,
     "SaturdayHours":0,
     "SundayChecked":false,
     "SundayHours":    0,
     "Mode":1//1st selected,2=weekly
     */
    
    func SubmitEditOrderChangesCall(){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            //            JustHUD.shared.showInView(view: view)
            self.showLoading()
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let UserName = String(format:"%@", defaults.string(forKey: "CandName")!)
            var Mode = "1"
            if IsTotalHoursandChooseDaysSelected == true{
                Mode = "1"
            }else{
                Mode = "2"
            }
            
            
            var param = ["Caller":"1",//hc
                "ClientId":    clientID,
                "CurrentTotalOrderBilling":CurrentTotalOrderBilling,//get res
                "OrderHours":OrderHours,///get res
                "StartDate":StartDate,
                "EndDate": EndDate,
                "Name": UserName,
                "OrderId":self.orderID,
                "Total_Billing":totalBilling,//Total Billing(Currently:$0.00)
                "Total_Hours":totalHours,//Total Hours(Currently:7)
                "MondayChecked": MondayChecked,
                "MondayHours": MondayHours,
                "TuesdayChecked": TuesdayChecked,
                "TuesdayHours": TuesdayHours,
                "WednesdayChecked": WednesdayChecked,
                "WednesdayHours": WednesdayHours,
                "ThursdayChecked": ThursdayChecked,
                "ThursdayHours": ThursdayHours,
                "FridayChecked": FridayChecked,
                "FridayHours": FridayHours,
                "SaturdayChecked": SaturdayChecked,
                "SaturdayHours": SaturdayHours,
                "SundayChecked": SundayChecked,
                "SundayHours":    SundayHours,
                "Mode": Mode] as [String : Any]
            
            if WarningConfirm ==  true{
                param.updateValue("true", forKey:"IsWarningConfirmed")
                param.updateValue("yes", forKey:"WarningConfirm2")
            }
            if AlertContinueMessageConfirm == "yes"{
                param.updateValue("yes", forKey:"AlertContinueMessageConfirm")
            }
            print(param)
            let urlString = RestAPI.BaseUrl+RestAPI.DOE_Submit_Changes_Edit_WorkOrder_URL
            
            RestAPI.postRequestWithToken(urlString: urlString, params: param, callback: SubmitEditOrderChangesResponse(response:))
        }else{
            WarningConfirm = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    func SubmitEditOrderChangesResponse(response:AnyObject)->()
    {
        self.hideLoading()
        print(response)
        if response is String{
            
            var message = response as! String
            if message.count == 0 {
                message = Error_Message
            }
            WarningConfirm = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }else{
            
            var object = response as! JSON
            if object["MessageStatus"].intValue == 1
            {
                
                if object["WarningConfirm2"] != nil{
                    WarningConfirm2 = object["WarningConfirm2"].stringValue
                    
                }else{
                    WarningConfirm2 = ""
                }
                if object["IsWarningConfirmed1"] != nil{
                    
                    IsWarningConfirmed1 = object["IsWarningConfirmed1"].stringValue
                }else{
                    IsWarningConfirmed1 = ""
                }
                if object["AlertContinueMessageConfirm"] != nil{
                    
                    AlertContinueMessageConfirm = object["AlertContinueMessageConfirm"].stringValue
                }else{
                    AlertContinueMessageConfirm = ""
                }
                let message = object["Message"].stringValue
                
                if WarningConfirm2.count == 0  && IsWarningConfirmed1.count == 0  && AlertContinueMessageConfirm.count == 0
                {
                    SuccessAlert = true
                    WarningConfirm = false
                    firstTimePopUp = false
                    SecondTimePopUp = false
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                    
                }else{
                    
                    if object["IsWarningConfirmed1"] != nil{
                        
                        let IsWarningConfirmed1 = object["IsWarningConfirmed1"].stringValue
                        
                        if IsWarningConfirmed1 == "1" &&  WarningConfirm2 == "1"{
                            AlertContinueMessageConfirm = "yes"
                            WarningConfirm = true
                            SuccessAlert = false
                            SecondTimePopUp = true
                            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "Yes", cancelBtnTitle: "No", type: Warning_Text, isAttributed: false)
                        }else  if WarningConfirm2 == "1" && IsWarningConfirmed1.count == 0{
                            firstTimePopUp = true
                            SuccessAlert = false
                            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "Yes", cancelBtnTitle: "No", type: Warning_Text, isAttributed: false)
                        }else{
                            SuccessAlert = true
                            WarningConfirm = false
                            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                        }
                    }else{
                        if WarningConfirm2 == "1" && IsWarningConfirmed1.count == 0{
                            firstTimePopUp = true
                            SuccessAlert = false
                            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "Yes", cancelBtnTitle: "No", type: Warning_Text, isAttributed: false)
                        }else{
                            SuccessAlert = true
                            WarningConfirm = false
                            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                        }
                    }
                }
                
                self.tableView.reloadData()
                
            }else{
                WarningConfirm = false
                SuccessAlert = false
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }
    }
    
    //MARK: Navigation
    func pushToSummaryPage(){
        var isControllerExists = false
        var vc = UIViewController()
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOEOrderDetailsViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    vc = viewController
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOEOrderDetailsSegue") as! DOEOrderDetailsViewController
            nextViewController.isFromROSDOE = true
            if self.orderID.count > 0 && Int(self.orderID)! > 0{
                nextViewController.OrderID = Int(self.orderID)!
            }else{
                nextViewController.OrderID = 0
            }
            nextViewController.isFromHistoricalOrder = isFromHistoricOrder
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            let vc1:DOEOrderDetailsViewController = vc as! DOEOrderDetailsViewController
            vc1.isFromROSDOE = true
            vc1.isFromHistoricalOrder = isFromHistoricOrder
            if self.orderID.count > 0 && Int(self.orderID)! > 0{
                vc1.OrderID = Int(self.orderID)!
            }else{
                vc1.OrderID = 0
                
            }
            self.navigationController?.popToViewController(vc1, animated: true)
            
        }
    }
    func pushToDOEPayratepage(){
        
        
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOEPayrateViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOEPayrateViewControllerSegue") as! DOEPayrateViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
        }
    }
    func formMultiDayDataArray(){
        
        multiDayDataArray.removeAllObjects()
        
        let tempDataArray = NSMutableArray()
        //First element is being removed from original array
        for dict in dataArray{
            let  dictObj = dict as! NSDictionary
            tempDataArray.add(dictObj)
        }
        
        var indexOfObj = -1
        
        let placeholderheader = StartTimePlaceHolder
        
        for dict in tempDataArray{
            
            let   dictObj : NSDictionary = dict as! NSDictionary
            let headerValue = dictObj["header"] as! String
            
            if  headerValue .contains(placeholderheader) {
                
                indexOfObj = tempDataArray.index(of: dictObj)
                
                break
            }
        }
        for dict in tempDataArray{
            
            let  dictObj:NSDictionary = dict as! NSDictionary
            multiDayDataArray.add(dictObj)
        }
        multiDayDataArray.removeObject(at: indexOfObj)
        for dict in weekDayArray{
            let  dictObj:NSDictionary = dict as! NSDictionary
            multiDayDataArray.insert(dictObj, at: indexOfObj)
            //                        multiDayDataArray.add(dictObj)
            indexOfObj += 1
            
        }
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    //MARK: TableView Methods
    override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.orderID.count > 0 && Int(self.orderID)! > 0{
            if IsTotalHoursandChooseDaysSelected == true{
                return EditOrderDataArray.count
            }else{
                return EditOrderMultiDataArray.count
            }
        }else{
            if selectedSementTag == 1{
                //            if multiDayDataArray.count > 0{
                //                return multiDayDataArray.count
                //
                //            }else{
                return multiDayDataArray.count
                //            }
            }else{
                //                print(scheduleArray.count)
                return dataArray.count
            }
            
        }
    }
    override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var dict = NSDictionary()
        if self.orderID.count > 0 && Int(self.orderID)! > 0{
            if IsTotalHoursandChooseDaysSelected == true{
                dict =  EditOrderDataArray[indexPath.row] as! NSDictionary
            }else{
                dict =  EditOrderMultiDataArray[indexPath.row] as! NSDictionary
            }
        }else{
            if selectedSementTag == 0{
                dict = dataArray[indexPath.row] as! NSDictionary
                
            }else{
                dict = multiDayDataArray[indexPath.row] as! NSDictionary
                
            }
            
        }
        
        let placeholder = dict["header"] as! String
        
        if placeholder == "Work Order"{
            if self.orderID.count > 0 && Int(self.orderID)! > 0{
                return self.DOEEditWorkOrderHeaderTableViewCell(indexPath: indexPath as NSIndexPath)
            }else{
                return self.DOEWorkOrderTableViewCell(indexPath: indexPath as NSIndexPath)
            }
        }else if placeholder == StartDatePlaceHolder || placeholder == EndDatePlaceHolder {
            
            return self.dateViewCell(tableView: tableView,indexPath: indexPath as NSIndexPath,placeHolder: "" )
            
        }
        else if placeholder == "Segment"{
            
            return segmentTableViewCell(tableView: tableView)
            
        }else if placeholder.contains("Time") {
            if selectedSementTag == 0{
                //                return self.dateViewCell(tableView: tableView,indexPath: indexPath as NSIndexPath,placeHolder: "" )
                return self.TimeViewCell(tableView: tableView,indexPath: indexPath as NSIndexPath, placeHolder: placeholder)
                
            }else{
                return self.weekTimeViewCell(tableView: tableView, indexPath: indexPath as NSIndexPath)
            }
        }else if placeholder == "Next"{
            if self.orderID.count > 0 && Int(self.orderID)! > 0{
                
                return self.ButtonTableCell(tableView: tableView,indexPath: indexPath as NSIndexPath,identifier: "EDITORDERButtonTableViewCellIdentifier" )
                
            }else{
                
                return self.ButtonTableCell(tableView: tableView,indexPath: indexPath as NSIndexPath,identifier: "ButtonTableViewCellIdentifier" )
            }
        }else if placeholder == "Enter Total Value"{
            return self.DOEEditWorkOrderTableViewCell(indexPath: indexPath as NSIndexPath)
        }else if placeholder == "Monday Hours" ||
            placeholder == "Tuesday Hours" ||
            placeholder == "Wednesday Hours" ||
            placeholder == "Thursday Hours" ||
            placeholder == "Friday Hours" ||
            placeholder == "Saturday Hours" ||
            placeholder == "Sunday Hours"{
            return self.TextFieldCell(indexPath: indexPath as NSIndexPath)
        }
        return UITableViewCell()
    }
    override    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var dict = NSDictionary()
        if self.orderID.count > 0 && Int(self.orderID)! > 0{
            if IsTotalHoursandChooseDaysSelected == true{
                dict = EditOrderDataArray[indexPath.row] as! NSDictionary
            }else{
                dict = EditOrderMultiDataArray[indexPath.row] as! NSDictionary
            }
        }
        else{
            if selectedSementTag == 0{
                dict = dataArray[indexPath.row] as! NSDictionary
                
            }else{
                dict = multiDayDataArray[indexPath.row] as! NSDictionary
                
            }
        }
        let placeholder = dict["header"] as! String
        
        if placeholder == "Work Order"{
            if self.orderID.count > 0 && Int(self.orderID)! > 0{
                return 235
                
            }
            return 160
            
        }else if placeholder == StartDatePlaceHolder || placeholder == EndDatePlaceHolder {
            
            return 76
            
        } else if placeholder == "Segment"{
            
            if selectedSementTag == 0 {
                return 180
            }else{
                return 215
            }
        }else if placeholder.contains("Time") {
            if selectedSementTag == 0{
                return 50
            }else{
                return 50
            }
        }else if placeholder == "Next"{
            
            return 60
            
        }else if placeholder == "Enter Total Value"{
            
            return 356
        }else if placeholder.contains("Hours"){
            
            return 70
        }
        
        return 40
    }
    
    //MARK: UITextField Methods
    public  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        
        if (textField.tag == Int(MonBreakTxtFieldTag) ||
            textField.tag == Int(TueBreakTxtFieldTag) ||
            textField.tag == Int(WedBreakTxtFieldTag) ||
            textField.tag == Int(ThuBreakTxtFieldTag) ||
            textField.tag == Int(FriBreakTxtFieldTag) ||
            textField.tag == Int(SatBreakTxtFieldTag) ||
            textField.tag == Int(SunBreakTxtFieldTag) ||
            textField.tag == Int(BreakTimeTxtFieldTag) )  {
            let charsLimit = 2
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace =  range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace
            
            return newLength <= charsLimit
        }else if textField.tag == Int(TotalBillingTextField_Tag)   {
            
            let charsLimit = 6
            
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            let isAllNumbers = allowedCharacters.isSuperset(of: characterSet)
            if isAllNumbers == true{
                
                let startingLength = textField.text?.count ?? 0
                let lengthToAdd = string.count
                let lengthToReplace =  range.length
                let newLength = startingLength + lengthToAdd - lengthToReplace
                
                return newLength <= charsLimit
            }else{
                return false
            }
            
        }else if textField.tag == Int(TotalHoursTextField_Tag)  {
            
            let charsLimit = 3
            
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            let isAllNumbers = allowedCharacters.isSuperset(of: characterSet)
            if isAllNumbers == true{
                
                let startingLength = textField.text?.count ?? 0
                let lengthToAdd = string.count
                let lengthToReplace =  range.length
                let newLength = startingLength + lengthToAdd - lengthToReplace
                
                return newLength <= charsLimit
            }else{
                return false
            }
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField.tag == Int(MonBreakTxtFieldTag) ||
            textField.tag == Int(TueBreakTxtFieldTag) ||
            textField.tag == Int(WedBreakTxtFieldTag) ||
            textField.tag == Int(ThuBreakTxtFieldTag) ||
            textField.tag == Int(FriBreakTxtFieldTag) ||
            textField.tag == Int(SatBreakTxtFieldTag) ||
            textField.tag == Int(SunBreakTxtFieldTag) ||
            textField.tag == Int(BreakTimeTxtFieldTag) )  {
        }
        else {
            self.view.endEditing(true)
            textField.resignFirstResponder()
            
        }
        return true
        
    }
    public func textFieldDidBeginEditing(_ textField: UITextField){
        
        if (textField.tag == Int(MonBreakTxtFieldTag) ||
            textField.tag == Int(TueBreakTxtFieldTag) ||
            textField.tag == Int(WedBreakTxtFieldTag) ||
            textField.tag == Int(ThuBreakTxtFieldTag) ||
            textField.tag == Int(FriBreakTxtFieldTag) ||
            textField.tag == Int(SatBreakTxtFieldTag) ||
            textField.tag == Int(SunBreakTxtFieldTag) ||
            textField.tag == Int(BreakTimeTxtFieldTag) ||
            textField.tag == Int(Edit_Order_MonTxtFieldTag) ||
            textField.tag == Int(Edit_Order_TueTxtFieldTag) ||
            textField.tag == Int(Edit_Order_WedTxtFieldTag) ||
            textField.tag == Int(Edit_Order_ThuTxtFieldTag) ||
            textField.tag == Int(Edit_Order_FriTxtFieldTag) ||
            textField.tag == Int(Edit_Order_SatTxtFieldTag) ||
            textField.tag == Int(Edit_Order_SunTxtFieldTag) ||
            textField.tag == Int(TotalBillingTextField_Tag) ||
            textField.tag == Int(TotalHoursTextField_Tag) ) {
            
            textField.becomeFirstResponder()
            
        }else{
            
            if textField.tag == Int(StartDateTxtFieldTag)! {
                textField.resignFirstResponder()
                
                let minDate = self.convertDateStringToDefaultDate(dateString: "01/01/1800", formatString: dateFormat)
                customPickerView.dtPickerView.minimumDate = minDate
                
                if StartDate.count == 0{
                }else{
                    let date = self.convertDateStringToDefaultDate(dateString: StartDate, formatString: dateFormat)
                    customPickerView.dtPickerView.date = date
                    
                }
                
            }else if textField.tag == Int(EndDateTxtFieldTag)! {
                textField.resignFirstResponder()
                if StartDate.count == 0 {}else{
                    let minDate = self.convertDateStringToDefaultDate(dateString: StartDate, formatString: dateFormat)
                    customPickerView.dtPickerView.minimumDate = minDate
                }
                if EndDate.count == 0 {}else{
                    let date = self.convertDateStringToDefaultDate(dateString: EndDate, formatString: dateFormat)
                    customPickerView.dtPickerView.date = date
                }
                
            }
            if textField.tag == Int(EndDateTxtFieldTag)! || textField.tag == Int(StartDateTxtFieldTag)!{
                customPickerView.dtPickerView.datePickerMode = UIDatePicker.Mode.date
            }else{
                //Show the  previuosly  selected Time else show current date
                let senderPosition  = textField.convert(CGPoint.zero, to: self.tableView)
                
                let indexPath =  self.tableView.indexPathForRow(at:senderPosition)
                print(indexPath?.row)
                if indexPath != nil{
                    self.showSelectedValueInTextFieldWithIndexPath(indexPath: indexPath! as NSIndexPath, textField: textField)
                }
                textField.resignFirstResponder()
                
                view.endEditing(true)
                customPickerView.dtPickerView.datePickerMode = UIDatePicker.Mode.time
            }
            customPickerView.showPickerViewOnSuperView(superView: (self.navigationController?.view)!, isDatePicker: true,minuteInterval: Int(Original_BreakInterval)!,isPortrait: self.isPortrait())
            firstResponderTxtFieldTag = textField.tag
            
            
        }
    }
    func showSelectedValueInTextFieldWithIndexPath(indexPath: NSIndexPath,textField: UITextField){
        
        var dict = NSDictionary()
        
        if selectedSementTag == 0{
            dict = dataArray[(indexPath.row)] as! NSDictionary
        }else{
            dict = multiDayDataArray[(indexPath.row)] as! NSDictionary
        }
        let placeholder = dict["header"] as! String
        
        if placeholder.contains("Time") {
            let startTag = Int(dict["StartTag"] as! String)!
            let endTag = Int(dict["EndTag"] as! String)!
            let startValue = dict["StartValue"] as! String
            let endValue = dict["EndValue"] as! String
            if textField.tag == startTag{
                if startValue.count == 0 {
                    customPickerView.dtPickerView.date = Date()

                }else{
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale.preferredLocale()
                    dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
                    let time = String(format:"%@ %@",StartDate,startValue)
                    let sTime = dateFormatter.date(from: time)
                    if sTime != nil{
                        
                        customPickerView.dtPickerView.date = sTime!
                    }
                }
            }else  if textField.tag == endTag{
                if endValue.count == 0 {
                    customPickerView.dtPickerView.date = Date()

                }else{
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale.preferredLocale()
                    dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
                    let time = String(format:"%@ %@",EndDate,endValue)
                    
                    let eTime = dateFormatter.date(from: time)
                    if eTime != nil{
                        customPickerView.dtPickerView.date = eTime!
                    }
                }
            }}
    }
    public func textFieldDidEndEditing(_ textField: UITextField){
        
        textField.resignFirstResponder()
        
        let buttonPosition:CGPoint = textField.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        
        if self.orderID.count > 0 && Int(self.orderID)! > 0{
            if IsTotalHoursandChooseDaysSelected == true{
                let dict = EditOrderDataArray[(indexPath?.row)!] as! NSDictionary
                let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dict)
                
                if textField.tag == Int(TotalBillingTextField_Tag){
                    mutableDictObj["totalBilling"] = textField.text
                }
                else if textField.tag == Int(TotalHoursTextField_Tag){
                    mutableDictObj["totalHours"] = textField.text
                    
                }
                EditOrderDataArray.replaceObject(at: (indexPath?.row)!, with: mutableDictObj)
            }else{
                
                let dict = EditOrderMultiDataArray[(indexPath?.row)!] as! NSDictionary
                let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dict)
                mutableDictObj["Value"] = textField.text
                EditOrderMultiDataArray.replaceObject(at: (indexPath?.row)!, with: mutableDictObj)
                
                if textField.tag == Int(Edit_Order_MonTxtFieldTag){
                    MondayHours = (textField.text?.count)! > 0 ?  textField.text! : ""
                }else if textField.tag == Int(Edit_Order_WedTxtFieldTag){
                    WednesdayHours = (textField.text?.count)! > 0 ?  textField.text! : ""
                }else if textField.tag == Int(Edit_Order_ThuTxtFieldTag){
                    ThursdayHours = (textField.text?.count)! > 0 ?  textField.text! : ""
                }else if textField.tag == Int(Edit_Order_FriTxtFieldTag){
                    FridayHours = (textField.text?.count)! > 0 ?  textField.text! : ""
                }else if textField.tag == Int(Edit_Order_SatTxtFieldTag){
                    SaturdayHours = (textField.text?.count)! > 0 ?  textField.text! : ""
                }else if textField.tag == Int(Edit_Order_SunTxtFieldTag){
                    SundayHours = (textField.text?.count)! > 0 ?  textField.text! : ""
                }else if textField.tag == Int(Edit_Order_TueTxtFieldTag){
                    TuesdayHours = (textField.text?.count)! > 0 ?  textField.text! : ""
                }
            }
        }else{
            
            if selectedSementTag == 1{
                
                let dict = multiDayDataArray[(indexPath?.row)!] as! NSDictionary
                let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dict)
                
                if textField.tag == Int(MonBreakTxtFieldTag){
                    if textField.text?.isNumeric == true{
                        MondayBreakTime = textField.text!
                        mutableDictObj["BreakValue"] = MondayBreakTime
                    }
                    
                }
                else if textField.tag == Int(TueBreakTxtFieldTag) {
                    if textField.text?.isNumeric == true{
                        TuesdayBreakTime = textField.text!
                        mutableDictObj["BreakValue"] = TuesdayBreakTime
                    }
                }
                else if textField.tag == Int(WedBreakTxtFieldTag) {
                    if textField.text?.isNumeric == true{
                        WednesdayBreakTime = textField.text!
                        mutableDictObj["BreakValue"] = WednesdayBreakTime
                    }
                }
                else if textField.tag == Int(ThuBreakTxtFieldTag) {
                    if textField.text?.isNumeric == true{
                        ThursdayBreakTime = textField.text!
                        mutableDictObj["BreakValue"] = ThursdayBreakTime
                    }
                }
                else if textField.tag == Int(FriBreakTxtFieldTag) {
                    if textField.text?.isNumeric == true{
                        FridayBreakTime = textField.text!
                        mutableDictObj["BreakValue"] = FridayBreakTime
                        
                    }
                }
                else if textField.tag == Int(SatBreakTxtFieldTag) {
                    if textField.text?.isNumeric == true{
                        SaturdayBreakTime = textField.text!
                        mutableDictObj["BreakValue"] = SaturdayBreakTime
                    }
                }
                else if textField.tag == Int(SunBreakTxtFieldTag) {
                    if textField.text?.isNumeric == true{
                        SundayBreakTime = textField.text!
                        mutableDictObj["BreakValue"] = SundayBreakTime
                    }
                }
                multiDayDataArray.replaceObject(at: (indexPath?.row)!, with: mutableDictObj)
                self.updateTimeDiff()
            }else if selectedSementTag == 0{
                let dict = dataArray[(indexPath?.row)!] as! NSDictionary
                let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dict)
                if textField.tag == Int(BreakTimeTxtFieldTag) {
                    if textField.text?.isNumeric == true{
                        BreakInterval = textField.text!
                        mutableDictObj["BreakValue"] = BreakInterval
                    }
                    if StartTime.count > 0 && EndTime.count > 0{
                        let diff = self.getTimeDifference(date1: StartTime, date2: EndTime,breakValue: BreakInterval)
                        sameDayHour = diff
                    }
                }
                
            }
            
        }
        if textField.text?.count == 0{
            textField.text = ""
        }
        self.tableView.reloadData()
    }
    
    func GetDaysBetweenTwoDates(mStartDate: Date, mEndDate: Date) -> NSMutableArray {
        
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        var newDate = mStartDate
        let    daysListArray = NSMutableArray()
        let    dateListArray = NSMutableArray()
        
        while newDate <= mEndDate {
            formatter.dateFormat = dateFormat
            let day = self.getDayOfWeek(today: formatter.string(from: newDate))
            if selectedSementTag == 0{
                //For single day selection,dont add saturday and sunday
                if day == "Saturday" || day == "Sunday"{
                }else{
                    daysListArray.add(day)
                }
            }else{
                //add all days for multi day selection
                daysListArray.add(day)
            }
            dateListArray.add(formatter.string(from: newDate))
            newDate = calendar.date(byAdding: .day, value: 1, to: newDate)!
        }
        return daysListArray
    }
    
    
    
    func ConvertStringToDate(DateString: String) -> Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        let date = dateFormatter.date(from: DateString)!
        return date
    }
    
}

