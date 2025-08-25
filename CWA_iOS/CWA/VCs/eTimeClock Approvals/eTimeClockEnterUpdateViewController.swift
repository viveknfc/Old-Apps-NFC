//
//  eTimeClockEnterUpdateViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 01/11/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import FSCalendar
import SwiftyJSON

class eTimeClockEnterUpdateViewController: BaseViewController,FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance {
    
    var selectedTimeClockObj = eTimeClock.init(TimeId: "", Name: "", Comments: "", Edit: 0, Date: "", TotalHours: "", LunchInTime: "", LunchOutTime: "", LogInTime: "", LogOutTime: "", break_minutes: "", NewId: 0, Sent: 0, Reason: "", changeFound: 0, Color: "", LunchInDate: "", LunchOutDate: "", LogInDate: "", LogOutDate: "",CandId: "", isSelected: "",isShowNote: "0")
    
    @IBOutlet var dataTableView: UITableView!
    @IBOutlet var TableHeaderView: UIView!
    var firstResponderTxtFieldTag = 0

    //Enter eTimeclock Outlets
    @IBOutlet var EnterHeaderView: UIView!
    @IBOutlet var EmpTFbgView: UIView!
    @IBOutlet var ReasonTFbgView: UIView!
    @IBOutlet var ReasonTexField: UITextField!
    @IBOutlet var EmpTexField: UITextField!
    
    
    //Update eTimeclock Outlets
    @IBOutlet var UpdateHeaderView: UIView!
    @IBOutlet var lblEmpName: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblSelectEmpPlaceHolder: UILabel!
    @IBOutlet var lblResonPlaceHolder: UILabel!

    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var saveBtn: UIButton!
    var isWarningStatus = false
    
    
    let EmpTableView_Tag = 101
    
    //MARK: Textfiled Tags
    let LoginStartDateTxtFieldTag = "10001"
    let LoginStartTimeTxtFieldTag = "10002"
    
    let LunchOutDateTxtFieldTag = "10003"
    let LunchOutTimeTxtFieldTag = "10004"
    
    let LunchReturnDateTxtFieldTag = "10005"
    let LunchReturnTimeTxtFieldTag = "10006"
    
    let LogoutFinishDateTxtFieldTag = "10007"
    let LogoutFinishTimeTxtFieldTag = "10008"
    
    let SelectEmpTxtFieldTag = "10009"
    let ReasonTxtFieldTag = "10000"
    
    let  LoginStartDatePlaceHolder = "Login  Start Date"
    let LoginStartTimePlaceHolder = "Login  Start Time *"
    
    let LunchOutDatePlaceHolder = "Lunch Out Date "
    let LunchOutTimePlaceHolder = "Lunch Out Time *"
    
    let LunchReturnDatePlaceHolder = "Lunch Return Date "
    let LunchReturnTimePlaceHolder = "Lunch Return Time *"
    
    let LogoutFinishDatePlaceHolder = "Logout  Finish Date"
    let LogoutFinishTimePlaceHolder = "Logout  Finish Time *"
    
    let ReasonPlaceHolder = "Reason *"
    let  EmployeePlaceHolder = "Select Employee *"
    

    var alrtController = UIAlertController()
    
    //MARK: Variable
    var minuteInterval = 0
    var isForEnterTimeClock = false
    var customCalendarView = CalendarView()
    var customTimePickerView = JPPickerView()
    var TableDataArray = NSMutableArray()
    var EmpDataArray = NSMutableArray()
    var selectedEmp = MealBreakMin.init(Text: "", Value: "", isSelected: "")
    
    var isValidLoginStartTime = true
    var isValidLunchOutTime = true
    var isValidLunchReturnTime = true
    var isValidLogoutFinishTime = true
    var isValidLoginStartDate = true
    var isValidLunchOutDate = true
    var isValidLunchReturnDate = true
    var isValidLogoutFinishDate = true
     var isValidReason = true
    var isValidEmp = true

    var old_Reason =  ""
    var old_LoginDate = ""
    var old_LunchReturnDate = ""
    var old_LunchOutDate = ""
    var old_LogOutDate = ""
    
    var old_LoginTime = ""
    var old_LunchReturnTime = ""
    var old_LunchOutTime = ""
    var old_LogOutTime = ""
    
    
    var Reason =  ""
    var LoginDate = ""
    var LunchReturnDate = ""
    var LunchOutDate = ""
    var LogOutDate = ""
    
    var LoginTime = ""
    var LunchReturnTime = ""
    var LunchOutTime = ""
    var LogOutTime = ""
    var WeekEnd = ""

    //MARK: View methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        EmpTexField.tag = Int(SelectEmpTxtFieldTag) ?? 0
        ReasonTexField.tag = Int(ReasonTxtFieldTag)  ?? 0
        
        self.UpdateUIForTableHeader()
        self.setupCalendarView()
        self.setupTimePickerView()
        formDataArrayForTableview()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isForEnterTimeClock == true{
            self.titlelbl.text = "Enter eTimeClock"
        }else{
            self.titlelbl.text = "Update eTimeClock"
            
        }
    }
    //MARK: Local Methods
    func showDropDownWithTag( placeHolder: String){
        let modelName = UIDevice.current.modelName
        
        
        let  alertTableView = UITableView()
        alertTableView.tableFooterView = UIView()
        
        alertTableView.delegate = self
        alertTableView.dataSource = self
        alertTableView.tag = EmpTableView_Tag
        alertTableView.backgroundColor = UIColor.clear
        alrtController.view.clipsToBounds = true
        alrtController.view.addSubview(alertTableView)
        alertTableView.reloadData()
        
        
        if modelName.contains("iPad") //||  modelName.contains("Simulator")
        {
            DispatchQueue.main.async(execute: { () -> Void in
                let vc = UIViewController()
                vc.view.isUserInteractionEnabled = true
                vc.preferredContentSize = CGSize(width: 250,height: 240)
                let margin = 8
                let rect = CGRect(x: margin, y: 0, width: 240, height: 230)
                alertTableView.frame = rect
                vc.view.addSubview(alertTableView)
                
                self.alrtController = UIAlertController(title:placeHolder, message: nil, preferredStyle:
                    UIAlertController.Style.alert)
                self.alrtController.setValue(vc, forKey: "contentViewController")
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: {
                    (alert: UIAlertAction!) in
                    print("OK")
                    self.dataTableView.reloadData()
                    self.alrtController.dismiss(animated: true, completion: nil)

                })
                self.alrtController.addAction(okAction)
                
                self.present(self.alrtController, animated: true, completion: nil)
            })
            
        }else{
            alrtController = UIAlertController(title: placeHolder, message: "", preferredStyle: UIAlertController.Style.actionSheet)
            let alertHeight =  300 //self.view.frame.height * 0.80
            let margin = 8
            let rect = CGRect(x: margin, y: 50, width: Int(alrtController.view.bounds.size.width - 35), height: alertHeight  - 120)
            alertTableView.frame = rect
            alrtController.view.clipsToBounds = true
            alrtController.view.addSubview(alertTableView)
            alertTableView.reloadData()
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: {
                (alert: UIAlertAction!) in
                print("OK")
                self.dataTableView.reloadData()
            })
            
            alrtController.addAction(okAction)
            let modelName = UIDevice.current.modelName
            
            if modelName.contains("iPad") {
                alrtController.modalPresentationStyle = .popover
                
                if let popoverController = alrtController.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
                    popoverController.permittedArrowDirections = []
                    self.present(alrtController, animated: true, completion: nil)
                    
                }
            }else{
            let height:NSLayoutConstraint = NSLayoutConstraint(item: alrtController.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(alertHeight))
            alrtController.view.addConstraint(height);
                self.present(alrtController, animated: true, completion:{})
                
            }
        }
        
    }
    func UpdateUIForTableHeader(){
        if isForEnterTimeClock == true{
            EnterHeaderView.isHidden = false
            UpdateHeaderView.isHidden = true
            self.titlelbl.text = "Enter eTimeClock"
            saveBtn.setTitle("Submit", for: .normal)
            lblResonPlaceHolder.halfTextColorChange(fullText: ReasonPlaceHolder, changeText: "*", textColor: UIColor.clear)
            lblSelectEmpPlaceHolder.halfTextColorChange(fullText: EmployeePlaceHolder, changeText: "*", textColor: UIColor.clear)
            TableHeaderView.frame = CGRect(x:0, y:0 ,width: UIScreen.main.bounds.size.width, height: 194)
            ReasonTexField.text = Reason
            self.addBorderToView(dView: ReasonTFbgView,isValid: true )
            self.addBorderToView(dView: EmpTFbgView,isValid: true)
            self.addRightImageViewToTextField(txtField: EmpTexField, imgName: "expand-arrow")

        }else{
            let divColorCode = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)

            self.titlelbl.text = "Update eTimeClock"
            saveBtn.setTitle("Update", for: .normal)
            EnterHeaderView.isHidden = true
            UpdateHeaderView.isHidden = false
            TableHeaderView.frame = CGRect(x:0, y:0 ,width: UIScreen.main.bounds.size.width, height: 75)
            self.lblEmpName.text = String(format:"Employee Name    %@",selectedTimeClockObj.Name!)
            self.lblDate.text =    String(format:"Date             %@",selectedTimeClockObj.Date!)
            self.lblEmpName.halfTextMakeToBold(fullText: self.lblEmpName.text!, changeText: "Employee Name", textColor: divColorCode)
            self.lblDate.halfTextMakeToBold(fullText: self.lblDate.text!, changeText: "Date", textColor: divColorCode)

        }
        
    }
    func validateEnterNewDayData() -> Bool{
     let isVaildUpdateData =   self.validateUpdateData()
        if Reason.count == 0{
            isValidReason = false
            lblResonPlaceHolder.halfTextColorChange(fullText: ReasonPlaceHolder, changeText: "*", textColor: UIColor.red)
            
        }else{
            isValidReason = true
            lblResonPlaceHolder.halfTextColorChange(fullText: ReasonPlaceHolder, changeText: "*", textColor: UIColor.clear)
        }
        if selectedEmp.Text!.count == 0{
            isValidEmp = false
            lblSelectEmpPlaceHolder.halfTextColorChange(fullText: EmployeePlaceHolder, changeText: "*", textColor: UIColor.red)
        }else{
            isValidEmp = true
            lblSelectEmpPlaceHolder.halfTextColorChange(fullText: EmployeePlaceHolder, changeText: "*", textColor: UIColor.clear)
        }
        self.addBorderToView(dView: EmpTFbgView,isValid: isValidEmp)
        self.addBorderToView(dView: ReasonTFbgView,isValid: isValidReason )
        dataTableView.reloadData()

        if isVaildUpdateData && isValidReason && isValidEmp {
            return true

        }
        return false
    }
    func validateUpdateData()-> Bool{
        if LoginTime.count == 0{
            isValidLoginStartTime = false
        }else{
            isValidLoginStartTime = true
        }
        
        if LunchReturnTime.count == 0{
            isValidLunchReturnTime = false
        }else{
            isValidLunchReturnTime = true
        }
        if LunchOutTime.count == 0{
            isValidLunchOutTime = false
        }else{
            isValidLunchOutTime = true
        }
        if LogOutTime.count == 0{
            isValidLogoutFinishTime = false
        }else{
            isValidLogoutFinishTime = true
        }
        dataTableView.reloadData()

        if isValidLoginStartTime && isValidLogoutFinishTime && isValidLoginStartDate && isValidLogoutFinishDate &&  isValidLunchReturnTime && isValidLunchOutTime{
            return true
        }
        return false
    }
    func formDataArrayForTableview(){
        if isForEnterTimeClock == true{
            let LoginDict = ["DateHeader":LoginStartDatePlaceHolder,"TimeHeader":LoginStartTimePlaceHolder,"DateTag":LoginStartDateTxtFieldTag,"TimeTag":LoginStartTimeTxtFieldTag,"DateValue":old_LoginDate,"TimeValue":old_LoginTime]
            
            let LunchOutDict = ["DateHeader":LunchOutDatePlaceHolder,"TimeHeader":LunchOutTimePlaceHolder,"DateTag":LunchOutDateTxtFieldTag,"TimeTag":LunchOutTimeTxtFieldTag,"DateValue":old_LunchOutDate,"TimeValue":old_LunchOutTime]
            
            let LunchReturnDict = ["DateHeader":LunchReturnDatePlaceHolder,"TimeHeader":LunchReturnTimePlaceHolder,"DateTag":LunchReturnDateTxtFieldTag,"TimeTag":LunchReturnTimeTxtFieldTag,"DateValue":old_LunchReturnDate,"TimeValue":old_LunchReturnTime]
            
            let LogoutDict = ["DateHeader":LogoutFinishDatePlaceHolder,"TimeHeader":LogoutFinishTimePlaceHolder,"DateTag":LogoutFinishDateTxtFieldTag,"TimeTag":LogoutFinishTimeTxtFieldTag,"DateValue":old_LogOutDate,"TimeValue":old_LogOutTime]
            
            
            TableDataArray = [LoginDict,LunchOutDict,LunchReturnDict,LogoutDict]
        }else{
            let LoginDict = ["DateHeader":LoginStartDatePlaceHolder,"TimeHeader":LoginStartTimePlaceHolder,"DateTag":LoginStartDateTxtFieldTag,"TimeTag":LoginStartTimeTxtFieldTag,"DateValue":LoginDate,"TimeValue":LoginTime]
            
            let LunchOutDict = ["DateHeader":LunchOutDatePlaceHolder,"TimeHeader":LunchOutTimePlaceHolder,"DateTag":LunchOutDateTxtFieldTag,"TimeTag":LunchOutTimeTxtFieldTag,"DateValue":LunchOutDate,"TimeValue":LunchOutTime]
            
            let LunchReturnDict = ["DateHeader":LunchReturnDatePlaceHolder,"TimeHeader":LunchReturnTimePlaceHolder,"DateTag":LunchReturnDateTxtFieldTag,"TimeTag":LunchReturnTimeTxtFieldTag,"DateValue":LunchReturnDate,"TimeValue":LunchReturnTime]
            
            let LogoutDict = ["DateHeader":LogoutFinishDatePlaceHolder,"TimeHeader":LogoutFinishTimePlaceHolder,"DateTag":LogoutFinishDateTxtFieldTag,"TimeTag":LogoutFinishTimeTxtFieldTag,"DateValue":LogOutDate,"TimeValue":LogOutTime]
            
            
            TableDataArray = [LoginDict,LunchOutDict,LunchReturnDict,LogoutDict]
        }
        
       
        self.dataTableView.reloadData()
        
    }
    func setupCalendarView(){
        customCalendarView = Bundle.main.loadNibNamed("CalendarView", owner: self, options: nil)?[0] as! CalendarView
        customCalendarView.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
        customCalendarView.setupCalendar()
        customCalendarView.calendar.delegate = self
        customCalendarView.calendar.dataSource = self
        
    }
    func setupTimePickerView(){
        customTimePickerView = Bundle.main.loadNibNamed("JPPickerView", owner: self, options: nil)?[0] as! JPPickerView
        
        customTimePickerView.setupUI()
        customTimePickerView.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
        customTimePickerView.doneButton.addTarget(self, action:#selector(self.timeButtonTapped), for:.touchUpInside)
        customTimePickerView.dtPickerView.addTarget(self, action:#selector(self.datePickerValueChanged), for:.valueChanged)
        customTimePickerView.dtPickerView.setValue(UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String), forKey: "textColor")
        customTimePickerView.dtPickerView.backgroundColor = UIColor.white
        
    }
    func addRightImageViewToTextField(txtField: UITextField, imgName: String ){
        let imageView = UIImageView.init(frame: CGRect(x:0,y:0,width:15,height:15));
        let image = UIImage(named: imgName);
        imageView.image = image;
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        txtField.rightView = imageView;
        txtField.rightViewMode = UITextField.ViewMode.always
        txtField.rightViewMode = .always
        
    }
    
    func addBorderToView(dView: UIView,isValid:Bool){
        if isValid == true{
            dView.layer.borderColor = borderColor.cgColor

        }else{
            dView.layer.borderColor = UIColor.red.cgColor

        }
        dView.layer.borderWidth = CGFloat(1)
        
    }
    
    //MARK: Screen Orientation
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        DispatchQueue.main.async(execute: { () -> Void in
            self.addDivisionNameOnTop()
            self.customTimePickerView.showPickerViewInOrientation(superView: (self.navigationController?.view)!, isPortrait: self.isPortrait())
            self.customCalendarView.showPickerViewInOrientation(superView: (self.navigationController?.view)!, isPortrait: self.isPortrait())
        })
        
    }
    func setDatePickerValue(changedDate: Date){
      
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        var  pickedDateString = formatter.string(from: changedDate as Date)
        formatter.dateFormat = "MM/dd/yyyy hh:mm a"
        pickedDateString = formatter.string(from: changedDate as Date)
        
        let   stringArray = pickedDateString.components(separatedBy: " ")
        if stringArray.count>2{
            pickedDateString = String(format:"%@ %@",stringArray[1],stringArray[2])
            let timeArray = stringArray[1].components(separatedBy: ":")
            let minute = timeArray[1]
            let hour = timeArray[0]
            let ampm = stringArray[2]
            print( hour,minute,ampm)
            pickedDateString =  String(format:"%@:%@ %@",hour,minute,ampm)
        }
//        self.validateEnterNewDayData()

        self.setDateTimeTextFieldWithValue(Value: pickedDateString,TagKey: "TimeTag",ValueKey: "TimeValue")
    }
    
    func setDateTimeTextFieldWithValue(Value: String,TagKey:String,ValueKey:String){
        var indexOfObj = -1
        
        for dict in TableDataArray{
            
            let   dictObj : NSDictionary = dict as! NSDictionary
            let TimeTag = dictObj[TagKey] as! String
            
            if firstResponderTxtFieldTag == Int(TimeTag) {
                indexOfObj = TableDataArray.index(of: dictObj)
                break
            }
        }
        
        if indexOfObj >= 0{
            let   dictObj : NSDictionary = TableDataArray[indexOfObj] as! NSDictionary
            let mutableDictObj: NSMutableDictionary = NSMutableDictionary(dictionary: dictObj)
            let TimeTag = Int(mutableDictObj[TagKey] as! String)
            if TimeTag == firstResponderTxtFieldTag {
                mutableDictObj[ValueKey] = Value
                TableDataArray.replaceObject(at: indexOfObj, with: mutableDictObj)
                
            }
        }

        self.dataTableView.reloadData()
    }
    //MARK: UIButton Action
    
    @objc func datePickerValueChanged(sender: UIDatePicker){
        
        sender.locale = NSLocale(localeIdentifier: "en_US") as Locale
        //▿ 2017-10-29 11:20:00 +0000
        let changedDate = sender.date
        self.setDatePickerValue(changedDate: changedDate)
      
    }
    @objc func timeButtonTapped(sender:UIButton) {
        
        customTimePickerView.removePickerViewFromSuperView()
        
        if firstResponderTxtFieldTag == Int(LoginStartTimeTxtFieldTag) || firstResponderTxtFieldTag == Int(LunchOutTimeTxtFieldTag) ||  firstResponderTxtFieldTag == Int(LunchReturnTimeTxtFieldTag) || firstResponderTxtFieldTag == Int(LogoutFinishTimeTxtFieldTag){
            
            //Show the  previuosly  selected Time else show current date
            customTimePickerView.dtPickerView.locale = NSLocale(localeIdentifier: "en_US") as Locale
            let changedDate = customTimePickerView.dtPickerView.date
            self.setDatePickerValue(changedDate: changedDate)
        }
    }
    @IBAction func CancelButtonTapped(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func SaveButtonTapped(_ sender: UIButton){
        
        if isForEnterTimeClock == true{
          let isValid =  self.validateEnterNewDayData()
            if isValid == true{
                self.EntereTimeClockDataServerCall()
            }
       
        }else{
            let isValid = self.validateUpdateData()
            if isValid == true{
                self.UpdateeTimeClockDataServerCall(WarningStatus: 0)
            }
        }
        
    }
    
    
    func dateViewCell(tableView: UITableView,indexPath: NSIndexPath,placeHolder: String) -> DateTableViewCell {
        
        let cell:DateTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DateTableViewCellIdentifier") as! DateTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        let dict  = TableDataArray[indexPath.row] as! NSDictionary
        
        
        let DatePlaceholder = dict["DateHeader"] as! String
        let TimePlaceholder =  dict["TimeHeader"] as! String
        let DateTag = dict["DateTag"] as! String
        let TimeTag = dict["TimeTag"] as! String
        let DateValue = dict["DateValue"] as! String
        let TimeValue = dict["TimeValue"] as! String
        
        
        
        
        cell.textFStart.text = DateValue
        cell.textFEnd.text = TimeValue
        
        self.addRightImageViewToTextField(txtField: cell.textFStart, imgName: "calendar_icon.png")
        self.addRightImageViewToTextField(txtField: cell.textFEnd, imgName: "Timeslips")
        self.addBorderToView(dView: cell.startTimeView,isValid: true)
        self.addBorderToView(dView: cell.endTimeView,isValid: true)
        cell.textFStart.tag = Int(DateTag) ?? 0
        cell.textFEnd.tag = Int(TimeTag) ?? 0
        cell.lblStart.text = DatePlaceholder
        cell.lblEnd.text = TimePlaceholder
        cell.textFStart.delegate = self
        cell.textFEnd.delegate = self
        
        
         
        
        if DateTag ==  LoginStartDateTxtFieldTag{
            LoginDate = cell.textFStart.text!
        }else if DateTag ==  LunchOutDateTxtFieldTag{
            LunchOutDate = cell.textFStart.text!
        }else if DateTag ==  LunchReturnDateTxtFieldTag{
            LunchReturnDate = cell.textFStart.text!
        }else if DateTag ==  LogoutFinishDateTxtFieldTag{
            LogOutDate = cell.textFStart.text!
        }
 
        if TimeTag ==  LoginStartTimeTxtFieldTag{
            LoginTime = cell.textFEnd.text!
            if isValidLoginStartTime == false{
                cell.endTimeView.layer.borderColor = UIColor.red.cgColor
                cell.lblEnd.halfTextColorChange(fullText: TimePlaceholder, changeText: "*", textColor: UIColor.red)
            }else{
                cell.endTimeView.layer.borderColor = borderColor.cgColor
                cell.lblEnd.halfTextColorChange(fullText: TimePlaceholder, changeText: "*", textColor: UIColor.clear)
            }
        }else  if TimeTag == LunchOutTimeTxtFieldTag{
            LunchOutTime = cell.textFEnd.text!
            if isValidLunchOutTime == false{
                cell.endTimeView.layer.borderColor = UIColor.red.cgColor
                cell.lblEnd.halfTextColorChange(fullText: TimePlaceholder, changeText: "*", textColor: UIColor.red)
            }else{
                cell.endTimeView.layer.borderColor = borderColor.cgColor
                cell.lblEnd.halfTextColorChange(fullText: TimePlaceholder, changeText: "*", textColor: UIColor.clear)
            }
        }else  if TimeTag == LunchReturnTimeTxtFieldTag{
            LunchReturnTime = cell.textFEnd.text!
            if isValidLunchReturnTime == false{
                cell.endTimeView.layer.borderColor = UIColor.red.cgColor
                cell.lblEnd.halfTextColorChange(fullText: TimePlaceholder, changeText: "*", textColor: UIColor.red)
            }else{
                cell.endTimeView.layer.borderColor = borderColor.cgColor
                cell.lblEnd.halfTextColorChange(fullText: TimePlaceholder, changeText: "*", textColor: UIColor.clear)
            }
        }else  if TimeTag == LogoutFinishTimeTxtFieldTag{
            LogOutTime = cell.textFEnd.text!
            if isValidLogoutFinishTime == false{
                cell.endTimeView.layer.borderColor = UIColor.red.cgColor
                cell.lblEnd.halfTextColorChange(fullText: TimePlaceholder, changeText: "*", textColor: UIColor.red)
            }else{
                cell.endTimeView.layer.borderColor = borderColor.cgColor
                cell.lblEnd.halfTextColorChange(fullText: TimePlaceholder, changeText: "*", textColor: UIColor.clear)
            }
        }
        
        
        return cell
    }
   
    //MARK: Calendar
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = "MM/dd/yyyy"
         let pickedDateString   = self.ConvertDateToRequiredString(date: date)
         self.setDateTimeTextFieldWithValue(Value: pickedDateString,TagKey: "DateTag",ValueKey: "DateValue")

        customCalendarView.removePickerViewFromSuperView()
        
        
    }
    
    //MARK: Server Call
    //
    func EntereTimeClockDataServerCall(){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            //9348984571
            let defaults = UserDefaults.standard
            
            let ContactId = String(format: "%d", defaults.integer(forKey: "ContactId"))
            
//            let NewDayLogin = String(format:"%@ %@",LoginDate,LoginTime)
//            let NewDayLogOut = String(format:"%@ %@",LogOutDate,LogOutTime)
//            let NewDayLunchIn = String(format:"%@ %@",LunchReturnDate,LunchReturnTime)
//            let NewDayLunchOut = String(format:"%@ %@",LunchOutDate,LunchOutTime)
            let params :[String:Any] =   [
                "Reason":self.ReasonTexField.text!,
                "CandId":selectedEmp.Value!,//selelc
                "OSSource":"iOS",
                "ContactId":ContactId,
                "NewDayLogin":LoginDate,
                "NewDayLogOut":LogOutDate,
                "NewDayLunchIn":LunchOutDate,//exchanged value as per API team
                "NewDayLunchOut":LunchReturnDate,
                "LogInTime":LoginTime,
                "LogOutTime":LogOutTime,
                "LunchInTime":LunchOutTime,//exchanged value as per API team
                "LunchOutTime":LunchReturnTime,
                "WeekEnd": WeekEnd]
            
            print(params)
            //   eTimeclock Update
            
            let urlString = RestAPI.BaseUrl+RestAPI.Enter_eTime_Clock_Data_URL
            RestAPI.postRequestWithToken(urlString: urlString, params: params, callback: getEnterNewDayResponse(response:))
            
        }else{
            isWarningStatus = false

            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    func getUpdateResponse(response: AnyObject)
    {
        JustHUD.shared.hide()
        print(response)
        if response is String {
            isWarningStatus = false

            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
        else
        {
            let  object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                var message = object["Message"].stringValue
                let WarningMessage = object["WarningMessage"].null == nil ? object["WarningMessage"].stringValue  : ""

                if WarningMessage == "true"{
                    isWarningStatus = true
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "Cancel", type: Warning_Text, isAttributed: false)

                }else{
                    
                    if message.count == 0 {
                        
                        message = "Submitted Successfully"
                        
                    }
                    isWarningStatus = false
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                }
            }else{
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    message = Error_Message
                }
                isWarningStatus = false

                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }
    }
    func UpdateeTimeClockDataServerCall(WarningStatus: Int){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
             JustHUD.shared.showInView(view: (self.view)!)
            //9348984571
            let defaults = UserDefaults.standard
            
            let ContactId = String(format: "%d", defaults.integer(forKey: "ContactId"))
            let ClientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let  DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
             
            
            let params :[String:Any] = ["WeekEnd":self.WeekEnd,
                                        "OSSource":"iOS",
                                        "CandId":selectedTimeClockObj.CandId!,
                                        "ClientId": ClientID,
                                        "ContactId":ContactId,
                                         "TimeId":selectedTimeClockObj.TimeId!,
                                        "Login":LoginDate,
                                        "LunchIn": LunchOutDate, //selectedTimeClockObj.LunchInDate!,
                                        "LunchOut":LunchReturnDate,//selectedTimeClockObj.LunchOutDate!,
                                        "LogOut":LogOutDate,//selectedTimeClockObj.LogOutDate!,
                                        "Comments":selectedTimeClockObj.Comments!,
                                        "LunchInTime":LunchOutTime,//selectedTimeClockObj.LunchInTime!,
                                        "LunchOutTime":LunchReturnTime,//selectedTimeClockObj.LunchOutTime!,
                                        "LogInTime":LoginTime,//selectedTimeClockObj.LogInTime!,
                                        "LogOutTime":LogOutTime,//selectedTimeClockObj.LogOutTime!,
                                        "TotalHours":selectedTimeClockObj.TotalHours!,
                                        "Div_id":DivisionId,
                                        "WarningStatus": WarningStatus,
                                        "break_minutes":selectedTimeClockObj.break_minutes!,
                                        "Wdate":selectedTimeClockObj.Date!]//Divid
            print(params)
            //   eTimeclock Update
 
                let urlString = RestAPI.BaseUrl+RestAPI.Update_eTime_Clock_Data_URL
             RestAPI.postRequestWithToken(urlString: urlString, params: params, callback: getUpdateResponse(response:))

        }else{
            isWarningStatus = false

            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    func getEnterNewDayResponse(response: AnyObject)
    {
        JustHUD.shared.hide()
        print(response)
        if response is String {
            isWarningStatus = false

            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
        else
        {
            let  object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = "Submitted Successfully"
                    
                }
                isWarningStatus = false

                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
             }else{
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    message = Error_Message
                }
                isWarningStatus = false

                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }
    }
    
    @IBAction override func okButtonTapped(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        if isWarningStatus == true{
            self.UpdateeTimeClockDataServerCall(WarningStatus: 1)
         }
    }
    /*
     Update Param:
     {"WeekEnd":"09/09/2018","CandId":233453,"ClientId":22201,"ContactId":0,"TimeId":108872,"Login":"09/03/2018","LunchIn":"09:30 pm","LunchOut":"10:00 pm","LogOut":"09/03/2018","Comments":null,"LunchInTime":"3:30 AM","LunchOutTime":"3:00 AM","LogInTime":"2:00 AM","LogOutTime":"10:00 AM","TotalHours":0,"Div_id":5,"break_minutes":30,"Wdate":"09/03/2018","OSSource":"Android"}

     */
}
extension eTimeClockEnterUpdateViewController:UITableViewDelegate,UITableViewDataSource{
    //MARK: UITableView Methods
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == EmpTableView_Tag{
            return EmpDataArray.count
        }
        return TableDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == EmpTableView_Tag{
            var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?
            if !(cell != nil) {
                cell = UITableViewCell(style:.subtitle, reuseIdentifier: "CELL")
            }
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            
            
            let empObj = EmpDataArray[indexPath.row] as! MealBreakMin
            
            if empObj.isSelected == "1"{
                cell?.accessoryType = .checkmark
            }else{
                cell?.accessoryType = .none
            }
            
            cell?.textLabel?.text = empObj.Text
            
            //MealBreakMin.init(Text: dic["Name"].stringValue, Value: dic["Caand_id"].stringValue, isSelected: "0")
            
            return cell ?? UITableViewCell()
        }
        return self.dateViewCell(tableView: tableView, indexPath: indexPath as NSIndexPath, placeHolder: "")
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if tableView.tag == EmpTableView_Tag{
            
            let obj = EmpDataArray[indexPath.row]
            
            let  o:MealBreakMin = obj as! MealBreakMin
            selectedEmp = o
            for obj in EmpDataArray{
                let reportObj:MealBreakMin = obj as! MealBreakMin
                reportObj.isSelected = "0"
            }
            selectedEmp.isSelected = "1"
            EmpTexField.text = selectedEmp.Text
            self.alrtController.dismiss(animated: true, completion: nil)
            if selectedEmp.Text!.count == 0{
                isValidEmp = false
                lblSelectEmpPlaceHolder.halfTextColorChange(fullText: EmployeePlaceHolder, changeText: "*", textColor: UIColor.red)
            }else{
                isValidEmp = true
                lblSelectEmpPlaceHolder.halfTextColorChange(fullText: EmployeePlaceHolder, changeText: "*", textColor: UIColor.clear)
            }
            self.addBorderToView(dView: EmpTFbgView,isValid: isValidEmp)
            
            tableView.reloadData()
        }
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == EmpTableView_Tag{
            return 45
        }
        return 80
        
    }
}
extension eTimeClockEnterUpdateViewController:UITextFieldDelegate{
    //MARK: Text Field Methods
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.tag == Int(ReasonTxtFieldTag)){
            ReasonTexField.text = textField.text
            Reason = textField.text!
            if Reason.count == 0{
                isValidReason = false
                lblResonPlaceHolder.halfTextColorChange(fullText: ReasonPlaceHolder, changeText: "*", textColor: UIColor.red)
                
            }else{
                isValidReason = true
                lblResonPlaceHolder.halfTextColorChange(fullText: ReasonPlaceHolder, changeText: "*", textColor: UIColor.clear)
            }
            self.addBorderToView(dView: ReasonTFbgView,isValid: isValidReason )
            
        }
    }
    public func textFieldDidBeginEditing(_ textField: UITextField){
        firstResponderTxtFieldTag = textField.tag
        if (textField.tag == Int(ReasonTxtFieldTag)){
            textField.becomeFirstResponder()
            
        }else{
            textField.resignFirstResponder()
            if (textField.tag == Int(LogoutFinishDateTxtFieldTag)
                || textField.tag == Int(LoginStartDateTxtFieldTag)
                || textField.tag == Int(LunchOutDateTxtFieldTag)
                || textField.tag == Int(LunchReturnDateTxtFieldTag)){
                
                //Show Calendar
                if textField.text?.count == 0{}else{
                    let date = self.convertDateStringToDefaultDate(dateString:  textField.text ?? "", formatString: dateFormat)
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.customCalendarView.calendar.setCurrentPage(date, animated: true)
                        self.customCalendarView.calendar.select(date, scrollToDate: true)
                    })
                }
                
                customCalendarView.showPickerViewOnSuperView(superView: (self.navigationController?.view)!, isPortrait: self.isPortrait())
                
            }else if (textField.tag == Int(LogoutFinishTimeTxtFieldTag)
                || textField.tag == Int(LoginStartTimeTxtFieldTag)
                || textField.tag == Int(LunchOutTimeTxtFieldTag)
                || textField.tag == Int(LunchReturnTimeTxtFieldTag)){
                //Show Selected value of time
                let buttonPosition:CGPoint = textField.convert(CGPoint.zero, to:self.dataTableView)
                let indexPath = self.dataTableView.indexPathForRow(at: buttonPosition)
                let   dictObj : NSDictionary = TableDataArray[ (indexPath?.row)!]as! NSDictionary
                
                let TimeValue = dictObj["TimeValue"] as! String
                let DateValue = dictObj["DateValue"] as! String
                
                if TimeValue.count == 0 {
                    customTimePickerView.dtPickerView.date = Date()

                }else{
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale.preferredLocale()
                    dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
                    let time = String(format:"%@ %@",DateValue,TimeValue)
                    
                    let eTime = dateFormatter.date(from: time)
                    if eTime != nil{
                        customTimePickerView.dtPickerView.date = eTime!
                    }
                    
                }
                
                //Show Time Picker
                customTimePickerView.dtPickerView.datePickerMode = UIDatePicker.Mode.time
                customTimePickerView.showPickerViewOnSuperView(superView: (self.navigationController?.view)!, isDatePicker: true,minuteInterval: minuteInterval,isPortrait: self.isPortrait())
                
            }else if (textField.tag == Int(SelectEmpTxtFieldTag)){
                //SHow Dropdown Actionsheet
                self.showDropDownWithTag(placeHolder: "Select Employee")
                
            }
        }
    }
    
}
