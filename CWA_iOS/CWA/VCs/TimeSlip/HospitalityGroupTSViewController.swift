//
//  HospitalityGroupTSViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 17/07/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import FloatRatingView
import SwiftyJSON
import FSCalendar

class HospitalityGroupTSViewController: BaseViewController {
    
    let Logistics_Division_ID = 130
    var isGenerateInvoice = false
    var isRemoveLogisticsTimeSheet = false
    var isLogisticsTimeSheetRemoved = false
    var ShowBottomSave = true
    static let Monday = 0
    static let Tuesday = 1
    static let Wednesday = 2
    static let Thursday = 3
    static let Friday = 4
    static let Saturday = 5
    static let Sunday = 6
    static let Weekly = 7
    let Error_Tbl_Tag = 1002
    let Legend_Tbl_Tag = 1001
    let Position_Type_Tbl_Tag = 1003
    var weekendDate = ""
    var isFromSafety = false
 
     @IBOutlet weak var tipCalBtn: UIButton!
    @IBOutlet weak var tipCalBtnWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var tsTableView: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var noDataView: UIView!
    
    @IBOutlet weak var DayDateColView: UICollectionView!
    
    @IBOutlet weak var clickHereBtn: UIButton!
    @IBOutlet weak var generateInvoiceBtn: UIButton!
    
    @IBOutlet  var DateTxtField: UITextField!
    @IBOutlet weak var ShowOriginalSchduleBtn: UIButton!
    @IBOutlet weak var selectAllBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var approveTSBtn: UIButton!
    @IBOutlet weak var dateBGView: UIView!
    @IBOutlet weak var noteBGView: UIView!
    @IBOutlet weak var lblNote: UILabel!
    
    var commentPopupView = EvaluateEmpCommentView()
    var customPickerView = JPPickerView()
    var colorLegendArray = NSMutableArray()
    var FailureMessageArray = NSMutableArray()
    var PositionArray = NSMutableArray()
    var tipDayArray = NSMutableArray()
    var nonTSStaffArray = NSMutableArray()

    var weekDayArray = NSMutableArray()
    var daysDict = NSMutableDictionary()
    var FilePath = ""
    var weekDayInput = ""
    var weekdayDateFormat = ""
    var ShowScheduledHours = false
    var showingPopupIndexPath = -1
    var firstResponderIndexPath = -1
    var ContactIsApproverYesNo = false
    var removeGTSIndexPath = NSIndexPath()
    let DateTextField_TAG = 101
    let Start_Time_TextField_TAG = "1001"
    let End_Time_TextField_TAG = "1002"
    let Type_TextField_TAG = "1003"
    var IsTipEnabled = false
    var firstResponderTxtFieldTag = 0
    var stepping = 0
    var IsTipExsists = false
    var IsTimeSheetNotApproved = false
    var IsShowNonTemPostionsStaffEnabled = false
    var isSubmitted = false
    var isTippPressed = false
    var RatePerHour = Double(0)
    var Cash = Double(0)
    var Credit = Double(0)
    var pendingErrorText = String()
    var tipexsistsText = String()
    var isInvoiced = Int()
    var submittedFileName = String()
    
    //MARK: Variables
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var bgCalendarView: UIView!
    @IBOutlet weak var showOriginalTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarBGHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var SuperViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var baseScrollView: UIScrollView!
    
    var resultDate = String()
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        return formatter
    }()
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    
    
    var selectedDayIndex = 0
    
    
    //    func updateScrollviewForScreenOrientation(){
    //        self.tsTableView.isScrollEnabled = true
    //        if self.isPortrait() == true{
    //            self.baseScrollView.isScrollEnabled = false
    //        }else{
    //            let  screenWidth =  UIScreen.main.bounds.size.width
    //
    //            let  screenHeight =  UIScreen.main.bounds.size.height
    //            print(screenWidth,screenHeight)
    //            DispatchQueue.main.async(execute: { () -> Void in
    //                self.baseScrollView.isScrollEnabled = true
    //                let height1 = CGFloat(300 + (260 * self.GetDayData().count))
    //                self.SuperViewHeightConstraint.constant = height1
    //                self.tsTableView.setContentOffset(.zero, animated: true)
    //                self.tsTableView.isScrollEnabled = false
    //                self.baseScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: height1)
    //
    //            })
    //        }
    //    }
    func updateScrollviewForScreenOrientation(){
        self.tsTableView.isScrollEnabled = true
        if self.isPortrait() == true{
            self.baseScrollView.isScrollEnabled = false
            self.tsTableView.isScrollEnabled = true
            self.baseScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: 0)
            self.SuperViewHeightConstraint.constant = 0
            
            self.view.layoutIfNeeded()
        }else{
            let  screenWidth =  UIScreen.main.bounds.size.width
            let  screenHeight =  UIScreen.main.bounds.size.height
            print(screenWidth,screenHeight)
            DispatchQueue.main.async(execute: { () -> Void in
                self.baseScrollView.isScrollEnabled = true
                self.tsTableView.isScrollEnabled = false
                let height1 = CGFloat(300 + (260 * self.GetDayData().count))
                self.SuperViewHeightConstraint.constant = height1
                self.tsTableView.setContentOffset(.zero, animated: true)
                self.baseScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: height1)
            })
        }
    }
    func showTipCalculator(){
        if IsTipEnabled
        {
        if self.tipCalBtn != nil{
            let btnWidth = UIScreen.main.bounds.width/3
            self.tipCalBtnWidthConstraint.constant = btnWidth - 30
            self.view.layoutIfNeeded()
            if self.tipCalBtn != nil{
                self.tipCalBtn.isHidden = false
                self.tipCalBtn.backgroundColor = UIColor.init(hexString:"5CB85C")
        }
        }
        }
        else
        {
            self.tipCalBtnWidthConstraint.constant = 0.1
            self.view.layoutIfNeeded()
            self.tipCalBtn.isHidden = true
        }
     }
    
    //MARK: METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let DivisionId = UserDefaults.standard.integer(forKey: "DivisionId")
        if DivisionId == Logistics_Division_ID{
            clickHereBtn.isHidden = true
        }
        self.showTipCalculator()
        self.view.layoutIfNeeded()
        noDataView.backgroundColor = UIColor(hexString:danger_background_Color)
        lblNoData.textColor = UIColor(hexString:danger_Color)
        noDataView.isHidden = true
        DispatchQueue.main.async(execute: { () -> Void in
            self.showOriginalTopConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
        
        approveTSBtn.setTitle("Approve Monday Timesheet", for: .normal)
        ShowOriginalSchduleBtn.isSelected = true
        tsTableView.tableFooterView = UIView()
        DateTxtField.tag = DateTextField_TAG
        self.calendarSetup()
        //        self.removeCalendar()
        self.setupUIMethods()
        self.setupCommentPopupView()
        self.setupPickerView()
        weekDayInput = "Monday"
        ShowScheduledHours = true
        daysDict = ["MON":NSMutableArray(),"TUE":NSMutableArray(),"WED":NSMutableArray(),"THU":NSMutableArray(),"FRI":NSMutableArray(),"SAT":NSMutableArray(),"SUN":NSMutableArray(),"WEEKLY":NSMutableArray()]
        self.updateScrollviewForScreenOrientation()
        self.getGroupTimeSheetData()
        
    }
    @objc override func appWillEnterForeground(){
        print("appWillEnterForeground Division")
        let days = self.GetDayData()
        
        if days.count == 0{
            self.getGroupTimeSheetData()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titlelbl.text = "Group Time Sheet"
    }
    func calendarSetup(){
        self.calendar.delegate = self
        //        self.calendar.select(Date())
        self.calendar.scope = .month
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        
        self.calendar.layer.borderColor = borderColor.cgColor
        self.calendar.layer.borderWidth = 1
        //        self.calendar.appearance.todayColor = UIColor.clear//bg circle
        //        self.calendar.appearance.titleTodayColor = UIColor.black
        self.calendar.select(self.calendar.currentPage)
        
        self.calendar.accessibilityIdentifier = "calendar"
        self.calendar.appearance.selectionColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        self.calendar.appearance.weekdayTextColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        self.calendar.appearance.headerTitleColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        self.calendar.appearance.todayColor =  UIColor.clear
        
        //self.showCalendar()
    }
    func setupPickerView(){
        customPickerView = Bundle.main.loadNibNamed("JPPickerView", owner: self, options: nil)?[0] as! JPPickerView
        
        customPickerView.setupUI()
        customPickerView.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
        customPickerView.doneButton.addTarget(self, action:#selector(self.timeButtonTapped), for:.touchUpInside)
        
        customPickerView.dtPickerView.addTarget(self, action:#selector(self.datePickerValueChanged), for:.valueChanged)
        customPickerView.dtPickerView.setValue(UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String), forKey: "textColor")
        customPickerView.dtPickerView.backgroundColor = UIColor.white
        
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
    func setupUIMethods(){
        dateBGView.backgroundColor = UIColor.white
        dateBGView.layer.borderColor = borderColor.cgColor
        dateBGView.layer.borderWidth = 1
        
        DayDateColView.layer.borderColor = borderColor.cgColor
        DayDateColView.layer.borderWidth = 1
    }
    func setupCommentPopupView(){
        
        commentPopupView = Bundle.main.loadNibNamed("EvaluateEmpCommentView", owner: self, options: nil)?[0] as! EvaluateEmpCommentView
        commentPopupView.setupUI(divColor: UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String))
        commentPopupView.commentTextView.delegate = self
        commentPopupView.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
        
        commentPopupView.closeButton.addTarget(self, action:#selector(self.closeCommentBtnTapped), for:.touchUpInside)
        
        commentPopupView.saveButton.addTarget(self, action:#selector(self.saveCommentBtnTapped), for:.touchUpInside)
        //         hoursSegment.tintColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
    }
    func ShowTablePopup(TableViewTag: NSInteger,Message: String){
        
        var msg = ""
        var rectHeight = 0
        
        if TableViewTag == Legend_Tbl_Tag || TableViewTag == Position_Type_Tbl_Tag {
            msg = "\n\n\n\n\n\n\n\n\n\n"
            rectHeight = 200
        }else if TableViewTag == Error_Tbl_Tag{
            msg = "\n\n\n\n\n\n\n\n"
            rectHeight = 170
            
        }
        var alrController = UIAlertController()
        if  TableViewTag == Position_Type_Tbl_Tag {
            alrController = UIAlertController(title: Message, message: msg, preferredStyle: UIAlertController.Style.actionSheet)
            
        }else{
            alrController = UIAlertController(title: Message, message: msg, preferredStyle: UIAlertController.Style.alert)
            
        }
        
        
        let originY = 10
        var width = 255
        let margin:CGFloat = 8.0
        if  TableViewTag == Position_Type_Tbl_Tag {
            width = 330
        }
        let rect = CGRect(x: Int(margin), y: originY, width: width, height: rectHeight)
        
        let tableView = UITableView(frame: rect)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tag = TableViewTag
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
        alrController.view.addSubview(tableView)
        
        
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: {(alert: UIAlertAction!) in print("OK")
            alrController.dismiss(animated: true, completion: nil)
        })
        
        alrController.addAction(cancelAction)
        let modelName = UIDevice.current.modelName

        if modelName.contains("iPad") {
            alrController.modalPresentationStyle = .popover
            
            if let popoverController = alrController.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
                popoverController.permittedArrowDirections = []
                self.present(alrController, animated: true, completion: nil)
                
            }
        }else{
//            let height:NSLayoutConstraint = NSLayoutConstraint(item: alrController.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(alertHeight))
//            alrController.view.addConstraint(height);
//            self.present(alrController, animated: true, completion:{})
            self.present(alrController, animated: true, completion: {})
        }
        
        
        
        //        self.presentViewController(alrController, animated: true, completion:{})
        
    }
    func GetDayName() -> String{
        var dayname = ""
        if selectedDayIndex == HospitalityGroupTSViewController.Monday {
            dayname = "MonGroupTimeSheet"
        }else if selectedDayIndex == HospitalityGroupTSViewController.Tuesday {
            dayname = "TueGroupTimeSheet"
        }else if selectedDayIndex == HospitalityGroupTSViewController.Wednesday {
            dayname = "WedGroupTimeSheet"
        }else if selectedDayIndex == HospitalityGroupTSViewController.Thursday {
            dayname = "ThuGroupTimeSheet"
        }else if selectedDayIndex == HospitalityGroupTSViewController.Friday {
            dayname = "FriGroupTimeSheet"
        }else if selectedDayIndex == HospitalityGroupTSViewController.Saturday {
            dayname = "SatGroupTimeSheet"
        }else if selectedDayIndex == HospitalityGroupTSViewController.Sunday {
            dayname = "SunGroupTimeSheet"
        }else if selectedDayIndex == HospitalityGroupTSViewController.Weekly {
            dayname = "WeekGroupTimeSheet"
        }
        return dayname
    }
    
    func getTimeDifference(date1: String, date2: String) -> Double
    {
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
            if hours < 0 && minutes < 0 {
                minutes = 60 + minutes
                hours = 24 + hours // 24 + (-2)
                hours =  hours - 1 // 24 + (-2)
            }else if hours < 0 {
                hours = 24 + hours // 24 + (-2)
            }else if minutes < 0 && hours == 0 {
                minutes = 60 + minutes
                hours = 23
            }else if minutes < 0 {
                minutes = 60 + minutes
            }
            
            if abs(minutes) == 30{
                minutes = 50
            }else if  abs(minutes) == 15{
                minutes = 25
            }else if  abs(minutes) == 45{
                minutes = 75
            }
            let timeString = String(format: "%02d.%02d", hours, abs(minutes))
            
            let time = Double(timeString)
            var timeDiff = Double(0)
            ////
            
            timeDiff =  time!
            
            return timeDiff
            
        }
        return Double(0)
    }
    
    func getTimeDifferenceWithBreakValue(time: Double,breakValue: String,isBreakValueChecked: Bool) -> Double{
        
        var timeDiff = Double(0)
        
        if Double(time) < Double(4){
            return abs(time)
            
        }else{
            
            if isBreakValueChecked == false{
                
                var md:Double = Double(0)
                if breakValue == "00" || breakValue == "0"{
                    md = 0.00
                }else if breakValue == "15"{
                    md = 0.25
                }
                else if breakValue == "30"{
                    md = 0.50
                }
                else if breakValue == "45"{
                    md = 0.75
                }
                else if breakValue == "60"{
                    md = 1.00
                }
                else if breakValue == "75"{
                    md = 1.25
                }
                else if breakValue == "90"{
                    md = 1.50
                }
                else if breakValue == "105"{
                    md = 1.75
                }
                else if breakValue == "120"{
                    md = 2.00
                }
                timeDiff = Double(time) - md
                return abs(timeDiff)
                
                ///////////////////////
            }else{
                return  time
                
            }
        }
        return Double(0)
        
    }
    func reloadTableViewRow(RowNum: NSInteger){
        
        let indPath = IndexPath(row: RowNum, section: 0)
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.tsTableView.reloadRows(at: [indPath], with: .none)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Navigation Methods
    
    func pushToViewPDFPage(){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is LoadWebContentViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoadWebContentSegue") as! LoadWebContentViewController
            nextViewController.fileName = FilePath
            nextViewController.PageTitle = "Instructions"
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    func pushToTipCalVC(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let TipCalVC = storyBoard.instantiateViewController(withIdentifier: "TipCalViewController") as! TipCalViewController
        TipCalVC.tempositionsList = self.GetDayData()
        TipCalVC.nonTempositionsList = self.nonTSStaffArray
        TipCalVC.dayList = tipDayArray
        TipCalVC.selectedDateDay = weekdayDateFormat+" "+weekDayInput
        TipCalVC.ShowScheduledHours = self.ShowScheduledHours
        TipCalVC.isTipSubmitted = IsTipExsists
        TipCalVC.IsTimeSheetNotApprove = IsTimeSheetNotApproved
        TipCalVC.IsShowNonTemPostionsStaffEnable = IsShowNonTemPostionsStaffEnabled
        TipCalVC.weekEnd = weekendDate
        TipCalVC.eachTip = RatePerHour
        TipCalVC.delegate = self
        TipCalVC.cash = Cash
        TipCalVC.credit = Credit
        TipCalVC.pendingText = pendingErrorText
        TipCalVC.tipExistsText = tipexsistsText
        TipCalVC.invoiced = isInvoiced
        TipCalVC.fileName = submittedFileName
        TipCalVC.selectedDayRow = selectedDayIndex
        self.navigationController?.pushViewController(TipCalVC, animated: true)

    }
    func ClearDayData() {
        
        if daysDict.object(forKey: "MON") != nil{
            let  dataA =  daysDict["MON"] as! NSMutableArray
            dataA.removeAllObjects()
        }
        if daysDict.object(forKey: "TUE") != nil{
            let dataA =  daysDict["TUE"] as! NSMutableArray
            dataA.removeAllObjects()
        }
        if daysDict.object(forKey: "WED") != nil{
            let  dataA =  daysDict["WED"] as! NSMutableArray
            dataA.removeAllObjects()
        }
        if daysDict.object(forKey: "THU") != nil{
            let  dataA =  daysDict["THU"] as! NSMutableArray
            dataA.removeAllObjects()
        }
        if daysDict.object(forKey: "FRI") != nil{
            let  dataA =  daysDict["FRI"] as! NSMutableArray
            dataA.removeAllObjects()
        }
        if daysDict.object(forKey: "SAT") != nil{
            let  dataA =  daysDict["SAT"] as! NSMutableArray
            dataA.removeAllObjects()
        }
        if daysDict.object(forKey: "SUN") != nil{
            let  dataA =  daysDict["SUN"] as! NSMutableArray
            dataA.removeAllObjects()
        }
        if daysDict.object(forKey: "WEEKLY") != nil{
            let  dataA =  daysDict["WEEKLY"] as! NSMutableArray
            dataA.removeAllObjects()
        }
        
    }
    func GetDayData() -> NSMutableArray{
        
        var dataA = NSMutableArray()
        
        if selectedDayIndex == HospitalityGroupTSViewController.Monday {
            
            if daysDict.object(forKey: "MON") != nil{
                
                dataA =  daysDict["MON"] as! NSMutableArray
            }
        }else if selectedDayIndex == HospitalityGroupTSViewController.Tuesday {
            if daysDict.object(forKey: "TUE") != nil{
                dataA =  daysDict["TUE"] as! NSMutableArray
            }
        }else if selectedDayIndex == HospitalityGroupTSViewController.Wednesday {
            if daysDict.object(forKey: "WED") != nil{
                dataA =  daysDict["WED"] as! NSMutableArray
            }
        }else if selectedDayIndex == HospitalityGroupTSViewController.Thursday {
            if daysDict.object(forKey: "THU") != nil{
                dataA =  daysDict["THU"] as! NSMutableArray
            }
        }else if selectedDayIndex == HospitalityGroupTSViewController.Friday {
            if daysDict.object(forKey: "FRI") != nil{
                dataA =  daysDict["FRI"] as! NSMutableArray
            }
        }else if selectedDayIndex == HospitalityGroupTSViewController.Saturday {
            if daysDict.object(forKey: "SAT") != nil{
                dataA =  daysDict["SAT"] as! NSMutableArray
            }
        }else if selectedDayIndex == HospitalityGroupTSViewController.Sunday {
            if daysDict.object(forKey: "SUN") != nil{
                dataA =  daysDict["SUN"] as! NSMutableArray
            }
        }else if selectedDayIndex == HospitalityGroupTSViewController.Weekly {
            if daysDict.object(forKey: "WEEKLY") != nil{
                dataA =  daysDict["WEEKLY"] as! NSMutableArray
            }
        }
        return dataA
        
    }
    //MARK: Custom Cell
    func weeklyGroupTSCell(indexPath: IndexPath) ->HospitalityWeeklyGroupTSTableCell{
        let divColorCode = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
        let cell:HospitalityWeeklyGroupTSTableCell = tsTableView.dequeueReusableCell(withIdentifier: "HospitalityWeeklyGroupTSTableCellIdentifier") as! HospitalityWeeklyGroupTSTableCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        
        cell.floatRatingView.delegate = self
        cell.floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        cell.floatRatingView.type = .wholeRatings
        cell.floatRatingView.backgroundColor = UIColor.clear
        
        
        let days = self.GetDayData()
        if days.count == 0{}else{
            
            let  emp = days[indexPath.row] as! HosGroupTS
            let  empObj:HosGroupTS = emp as HosGroupTS
            let bgColor = UIColor(hexString:empObj.BackGroundColorCode!)
            cell.backgroundColor = bgColor
            cell.approveBtn.isSelected = empObj.IsApproved!
            
            cell.lblName.text = String(format:"Name %@",empObj.CandidateName!)
            cell.lblPosition.text = String(format:"Position %@",empObj.Position!)
            cell.lblPO.text = String(format:"PO %@",empObj.PONumber!)
            cell.lblTotalBreak.text = String(format:"Total Break\n%.2f",empObj.TotalBreak!)
            cell.lblTotal.text = String(format:"Total %.2f",empObj.TotalHours!)
            //            cell.lblTaxifare.text = String(format:"Taxi Fare: %@",empObj.Taxi!)
            cell.lblMon.text = String(format:"Mon\n%.2f",empObj.MondayHours!)
            cell.lblTue.text = String(format:"Tue\n%.2f",empObj.TuesdayHours!)
            cell.lblWed.text = String(format:"Wed\n%.2f",empObj.WednesdayHours!)
            cell.lblThu.text = String(format:"Thu\n%.2f",empObj.ThursdayHours!)
            cell.lblFri.text = String(format:"Fri\n%.2f",empObj.FridayHours!)
            cell.lblSat.text = String(format:"Sat\n%.2f",empObj.SaturdayHours!)
            cell.lblSun.text = String(format:"Sun\n%.2f",empObj.SundayHours!)
            cell.lblOT.text = String(format:"OT\n%.2f",empObj.OTHours!)
            cell.lblReg.text = String(format:"Reg\n%.2f",empObj.RegHours!)
            cell.lblOrderID.text = String(format:"Order ID %.0f",empObj.OrderId!)
            if empObj.TaxiVisible == true{
                cell.lblTaxifare.text = String(format:"Taxi Fare %@",empObj.Taxi!)
            }else{
                cell.lblTaxifare.text = String(format:"Taxi Fare %@","$N/A")
            }
            
            if empObj.EvalVisible == true && ContactIsApproverYesNo == true{
                cell.approveBtn.isUserInteractionEnabled = true
                cell.payForBreakBtn.isUserInteractionEnabled = true
            }else{
                cell.approveBtn.isUserInteractionEnabled = false
                cell.payForBreakBtn.isUserInteractionEnabled = false
                cell.floatRatingView.isUserInteractionEnabled = false
            }
            cell.payForBreakBtn.isSelected = empObj.PayForBreak!
            cell.floatRatingView.rating = Double(empObj.Eval!)
            cell.lblRatingValue.text = String(format: "(%.f of 5 stars)",Double(empObj.Eval!))

            if empObj.IsEvalDone == false{
                cell.floatRatingView.isUserInteractionEnabled = true
                
            }else{
                cell.floatRatingView.isUserInteractionEnabled = false
                
            }
            
           
            
        }
        
        
        cell.addCommentBtn.removeTarget(self, action:#selector(self.addCommentBtnTapped), for: .touchUpInside)
        cell.addCommentBtn.addTarget(self, action:#selector(self.addCommentBtnTapped), for: .touchUpInside)
        
        cell.approveBtn.removeTarget(self, action:#selector(self.approveCheckBtnTapped), for: .touchUpInside)
        cell.approveBtn.addTarget(self, action:#selector(self.approveCheckBtnTapped), for: .touchUpInside)
        cell.payForBreakBtn.removeTarget(self, action:#selector(self.payForBreakBtnTapped), for: .touchUpInside)
        cell.payForBreakBtn.addTarget(self, action:#selector(self.payForBreakBtnTapped), for: .touchUpInside)
        
        cell.lblName.halfTextMakeToBold(fullText: cell.lblName.text!, changeText: "Name", textColor: divColorCode)
        cell.lblPosition.halfTextMakeToBold(fullText: cell.lblPosition.text!, changeText: "Position", textColor: divColorCode)
        cell.lblPO.halfTextMakeToBold(fullText: cell.lblPO.text!, changeText: "PO", textColor: divColorCode)
        cell.lblOrderID.halfTextMakeToBold(fullText: cell.lblOrderID.text!, changeText: "Order ID", textColor: divColorCode)
        cell.lblTotal.halfTextMakeToBold(fullText: cell.lblTotal.text!, changeText: "Total", textColor: divColorCode)
        cell.lblReg.halfTextMakeToBold(fullText: cell.lblReg.text!, changeText: "Reg", textColor: divColorCode)
        cell.lblOT.halfTextMakeToBold(fullText: cell.lblOT.text!, changeText: "OT", textColor: divColorCode)
        cell.lblTaxifare.halfTextMakeToBold(fullText: cell.lblTaxifare.text!, changeText: "Taxi Fare", textColor: divColorCode)
        cell.lblTotalBreak.halfTextMakeToBold(fullText: cell.lblTotalBreak.text!, changeText: "Total Break", textColor: divColorCode)
        
        cell.lblMon.halfTextMakeToBold(fullText: cell.lblMon.text!, changeText: "Mon", textColor: divColorCode)
        cell.lblTue.halfTextMakeToBold(fullText: cell.lblTue.text!, changeText: "Tue", textColor: divColorCode)
        cell.lblWed.halfTextMakeToBold(fullText: cell.lblWed.text!, changeText: "Wed", textColor: divColorCode)
        cell.lblThu.halfTextMakeToBold(fullText: cell.lblThu.text!, changeText: "Thu", textColor: divColorCode)
        cell.lblFri.halfTextMakeToBold(fullText: cell.lblFri.text!, changeText: "Fri", textColor: divColorCode)
        cell.lblSat.halfTextMakeToBold(fullText: cell.lblSat.text!, changeText: "Sat", textColor: divColorCode)
        cell.lblSun.halfTextMakeToBold(fullText: cell.lblSun.text!, changeText: "Sun", textColor: divColorCode)
        cell.lblEval.halfTextMakeToBold(fullText: cell.lblEval.text!, changeText: "Eval", textColor: divColorCode)
        
        cell.payForBreakBtn.setTitleColor(divColorCode, for: .normal)
        cell.approveBtn.setTitleColor(divColorCode, for: .normal)
        
        
        return cell
    }
    func HospitalityWeekDayGroupTSCell(indexPath: IndexPath) ->HospitalityGroupTSTableViewCell{
        
        let divColorCode = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
        let cell:HospitalityGroupTSTableViewCell = tsTableView.dequeueReusableCell(withIdentifier: "HospitalityGroupTSTableViewCellIdentifier") as! HospitalityGroupTSTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let days = self.GetDayData()
        if days.count == 0{}else{
            
            let  emp = days[indexPath.row] as! HosGroupTS
            let  empObj:HosGroupTS = emp as HosGroupTS
            
            let bgColor = UIColor(hexString:empObj.BackGroundColorCode!)
            cell.backgroundColor = bgColor
            
            cell.lblName.text = String(format:"Name   %@",empObj.CandidateName!)
            cell.lblPosition.text = String(format:"Position   %@",empObj.Position!)
            cell.lblPO.text = String(format:"PO   %@",empObj.PONumber!)
            cell.lblBreak.text = String(format:"Break   %@",empObj.BreakValue!)
            cell.lblTotal.text = String(format:"Total   %.2f",empObj.TotalHours!)
            
            cell.lblTotal.halfTextMakeToBold(fullText: cell.lblTotal.text!, changeText: "Total", textColor: divColorCode)
            cell.lblBreak.halfTextMakeToBold(fullText: cell.lblBreak.text!, changeText: "Break", textColor: divColorCode)
            cell.lblPO.halfTextMakeToBold(fullText: cell.lblPO.text!, changeText: "PO", textColor: divColorCode)
            cell.lblPosition.halfTextMakeToBold(fullText: cell.lblPosition.text!, changeText: "Position", textColor: divColorCode)
            cell.lblName.halfTextMakeToBold(fullText: cell.lblName.text!, changeText: "Name", textColor: divColorCode)

            cell.floatRatingView.rating = Double(empObj.Eval!)
            cell.lblRatingValue.text = String(format: "(%.f of 5 stars)",Double(empObj.Eval!))
            self.addBorderToView(vView: cell.startTimeBgView)
            self.addBorderToView(vView: cell.endTimeBgView)
            
            cell.timeView.isHidden = true
            cell.approveBtn.isSelected = empObj.IsApproved!
            cell.payForBreakBtn.isSelected = empObj.PayForBreak!
            if empObj.TipAmount!>0
            {
                cell.tipAmountLabel.text = "Tip $ \(empObj.TipAmount!)"
                cell.tipAmountLabel.halfTextMakeToBold(fullText: cell.tipAmountLabel.text!, changeText: "Tip", textColor: divColorCode)
            }
            else
            {
                cell.tipAmountLabel.text = ""
            }
            if empObj.TaxiVisible == true{
                cell.lblTaxiFare.text = String(format:"Taxi Fare   %@",empObj.Taxi!)
            }else{
                cell.lblTaxiFare.text = String(format:"Taxi Fare   %@","$N/A")
            }
            cell.lblTaxiFare.halfTextMakeToBold(fullText: cell.lblTaxiFare.text!, changeText: "Taxi Fare", textColor: divColorCode)

            
            if empObj.EvalVisible == true && ContactIsApproverYesNo == true{
                cell.approveBtn.isUserInteractionEnabled = true
                cell.payForBreakBtn.isUserInteractionEnabled = true
                cell.timeView.isHidden = false
                cell.lblTime.isHidden = true
                
                self.addRightImageToTextField(textField: cell.startTimeTxtField,imageName: "Timeslips")
                self.addRightImageToTextField(textField: cell.endTimeTxtField,imageName: "Timeslips")
                cell.startTimeTxtField.delegate = self
                cell.endTimeTxtField.delegate = self
                cell.startTimeTxtField.tag = Int(empObj.StartTimeTxtFieldTag!)!
                cell.endTimeTxtField.tag = Int(empObj.EndTimeTxtFieldTag!)!
                cell.startTimeTxtField.text = empObj.StartTime
                cell.endTimeTxtField.text = empObj.EndTime
                cell.timeViewLabel.halfTextMakeToBold(fullText: cell.timeViewLabel.text!, changeText: "Time", textColor: divColorCode)
                
                let screenWidth = UIScreen.main.bounds.size.width
                if self.isPortrait() == true{
                    if screenWidth > 375{
                        cell.saveDataBtnTopConstraint.constant = -30
                    }else{
                        cell.saveDataBtnTopConstraint.constant = 0
                    }
                }else{
                    cell.saveDataBtnTopConstraint.constant = -30
                }
                
                cell.layoutIfNeeded()
                if empObj.ShowSave == true{
                    cell.saveDataBtn.isHidden = false
                    cell.saveDataBtn.removeTarget(self, action:#selector(self.saveDataFromCellBtnAction), for: .touchUpInside)
                    cell.saveDataBtn.addTarget(self, action:#selector(self.saveDataFromCellBtnAction), for: .touchUpInside)
                    
                }else{
                    cell.saveDataBtn.isHidden = true
                }
            }else{
                cell.startTimeTxtField.text = ""
                cell.endTimeTxtField.text = ""
                cell.saveDataBtn.isHidden = true
                cell.approveBtn.isUserInteractionEnabled = false
                cell.payForBreakBtn.isUserInteractionEnabled = false
                cell.lblTime.isHidden = false
                cell.lblTime.text = String(format: "Time   %@ - %@",empObj.StartTime!,empObj.EndTime!)
                cell.timeView.isHidden = true
                cell.lblTime.halfTextMakeToBold(fullText: cell.lblTime.text!, changeText: "Time", textColor: divColorCode)

                
            }
            if empObj.IsEvalDone == false{
                cell.floatRatingView.isUserInteractionEnabled = true
                
            }else{
                cell.floatRatingView.isUserInteractionEnabled = false
                
            }
        }
        cell.floatRatingView.delegate = self
        cell.floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        cell.floatRatingView.type = .wholeRatings
        cell.floatRatingView.backgroundColor = UIColor.clear
        
        cell.approveBtn.removeTarget(self, action:#selector(self.approveCheckBtnTapped), for: .touchUpInside)
        cell.payForBreakBtn.removeTarget(self, action:#selector(self.payForBreakBtnTapped), for: .touchUpInside)
        cell.addCommentBtn.removeTarget(self, action:#selector(self.addCommentBtnTapped), for: .touchUpInside)
        
        
        cell.approveBtn.addTarget(self, action:#selector(self.approveCheckBtnTapped), for: .touchUpInside)
        cell.payForBreakBtn.addTarget(self, action:#selector(self.payForBreakBtnTapped), for: .touchUpInside)
        cell.addCommentBtn.addTarget(self, action:#selector(self.addCommentBtnTapped), for: .touchUpInside)
        
        
        self.makeTextTitleColorful(cell: cell)
        
        cell.payForBreakBtn.setTitleColor(divColorCode, for: .normal)
        cell.approveBtn.setTitleColor(divColorCode, for: .normal)
        
        
        return cell
    }
    func addBorderToView(vView: UIView){
        vView.layer.borderWidth = 1
        vView.layer.borderColor = borderColor.cgColor
        
    }
    func LogisticsWeekDayGroupTSCell(indexPath: IndexPath) ->HospitalityGroupTSTableViewCell{
        
        let divColorCode = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
        let cell:LogisticsGroupTSTableViewCell = tsTableView.dequeueReusableCell(withIdentifier: "LogisticsGroupTSTableViewCellIdentifier") as! LogisticsGroupTSTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let days = self.GetDayData()
        if days.count == 0{}else{
            
            let  emp = days[indexPath.row] as! HosGroupTS
            let  empObj:HosGroupTS = emp as HosGroupTS
            
            let bgColor = UIColor(hexString:empObj.BackGroundColorCode!)
            cell.backgroundColor = bgColor
            
            cell.lblName.text = String(format:"Name  %@",empObj.CandidateName!)
            cell.lblPosition.text = String(format:"Position  %@",empObj.Position!)
            cell.lblPO.text = String(format:"PO  %@",empObj.PONumber!)
            cell.lblBreak.text = String(format:"Break  %@",empObj.BreakValue!)
            cell.lblTotal.text = String(format:"Total  %.2f",empObj.TotalHours!)
            cell.floatRatingView.rating = Double(empObj.Eval!)
            cell.lblRatingValue.text = String(format: "(%.f of 5 stars)",Double(empObj.Eval!))

            cell.TypeTxtField.tag = Int(Type_TextField_TAG)!
            cell.TypeTxtField.isUserInteractionEnabled = true
            cell.typeBgView.backgroundColor = UIColor.white
            cell.TypeTxtField.delegate = self
            cell.TypeTxtField.text = empObj.selectedPosTypeName
            
            cell.timeView.isHidden = true
            
            cell.approveBtn.isSelected = empObj.IsApproved!
            cell.payForBreakBtn.isSelected = empObj.PayForBreak!
            self.addBorderToView(vView: cell.typeBgView)
            self.addBorderToView(vView: cell.startTimeBgView)
            self.addBorderToView(vView: cell.endTimeBgView)
            if empObj.TaxiVisible == true{
                cell.lblTaxiFare.text = String(format:"Taxi Fare  %@",empObj.Taxi!)
            }else{
                cell.lblTaxiFare.text = String(format:"Taxi Fare  %@","$N/A")
            }
            if empObj.EvalVisible == true && ContactIsApproverYesNo == true{
                cell.approveBtn.isUserInteractionEnabled = true
                cell.payForBreakBtn.isUserInteractionEnabled = true
                cell.timeView.isHidden = false
                cell.lblTime.isHidden = true
                
                self.addRightImageToTextField(textField: cell.TypeTxtField, imageName: "expand-arrow")
                self.addRightImageToTextField(textField: cell.startTimeTxtField,imageName: "Timeslips")
                self.addRightImageToTextField(textField: cell.endTimeTxtField,imageName: "Timeslips")
                
                cell.startTimeTxtField.delegate = self
                cell.endTimeTxtField.delegate = self
                cell.timeViewLabel.halfTextMakeToBold(fullText: cell.timeViewLabel.text!, changeText: "Time", textColor: divColorCode)
                cell.startTimeTxtField.text = empObj.StartTime
                cell.endTimeTxtField.text = empObj.EndTime
                
                cell.startTimeTxtField.tag = Int(empObj.StartTimeTxtFieldTag!)!
                cell.endTimeTxtField.tag = Int(empObj.EndTimeTxtFieldTag!)!
                cell.TypeTxtField.placeholder = "Please select"
            }else{
                cell.startTimeTxtField.text = ""
                cell.endTimeTxtField.text = ""
                cell.saveDataBtn.isHidden = true
                cell.approveBtn.isUserInteractionEnabled = false
                cell.payForBreakBtn.isUserInteractionEnabled = false
                cell.lblTime.isHidden = false
                cell.lblTime.text = String(format: "Time  %@ - %@",empObj.StartTime!,empObj.EndTime!)
                cell.timeView.isHidden = true
                cell.TypeTxtField.isUserInteractionEnabled = false
                cell.typeBgView.backgroundColor = UIColor.clear
                cell.TypeTxtField.backgroundColor = UIColor.clear
                cell.typeBgView.layer.borderColor = UIColor.clear.cgColor
                cell.TypeTxtField.placeholder = ""
                cell.typeBgView.layer.borderColor = UIColor.clear.cgColor
                cell.TypeTxtField.rightView = UIView()
            }
            let screenWidth = UIScreen.main.bounds.size.width
            cell.BtnViewTopToTaxiFareConstraint.constant = 40
            
            if empObj.RecCode == "S" || empObj.RecCode == "C" {
                //show both remove and save
                cell.BtnView.isHidden = false
                cell.removeDataBtn.isHidden = false
                cell.saveDataBtn.isHidden = false
                
                cell.saveDataBtn.removeTarget(self, action:#selector(self.saveDataFromCellBtnAction), for: .touchUpInside)
                cell.removeDataBtn.removeTarget(self, action:#selector(self.removeDataFromCellBtnAction), for: .touchUpInside)
                
                cell.saveDataBtn.addTarget(self, action:#selector(self.saveDataFromCellBtnAction), for: .touchUpInside)
                cell.removeDataBtn.addTarget(self, action:#selector(self.removeDataFromCellBtnAction), for: .touchUpInside)
                let screenWidth = UIScreen.main.bounds.size.width
                if screenWidth > 414{
                    cell.BtnViewTopToTaxiFareConstraint.constant = 5
                }
            }else if empObj.RecCode == "P"{
                //Show  only save
                cell.BtnView.isHidden = false
                cell.removeDataBtn.isHidden = true
                cell.saveDataBtn.isHidden = false
                cell.saveDataBtn.removeTarget(self, action:#selector(self.saveDataFromCellBtnAction), for: .touchUpInside)
                cell.saveDataBtn.addTarget(self, action:#selector(self.saveDataFromCellBtnAction), for: .touchUpInside)
                if screenWidth >= 414{
                    cell.BtnViewTopToTaxiFareConstraint.constant = 5
                    
                }
            }else{
                //hide both remove and save
                cell.BtnView.isHidden = true
            }
            cell.layoutIfNeeded()
            //            if Double(empObj.Eval!) == 0{
            if empObj.IsEvalDone == false{
                cell.floatRatingView.isUserInteractionEnabled = true
                
            }else{
                cell.floatRatingView.isUserInteractionEnabled = false
                
            }
        }
        cell.floatRatingView.delegate = self
        cell.floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        cell.floatRatingView.type = .wholeRatings
        cell.floatRatingView.backgroundColor = UIColor.clear
        
        cell.approveBtn.removeTarget(self, action:#selector(self.approveCheckBtnTapped), for: .touchUpInside)
        cell.payForBreakBtn.removeTarget(self, action:#selector(self.payForBreakBtnTapped), for: .touchUpInside)
        cell.addCommentBtn.removeTarget(self, action:#selector(self.addCommentBtnTapped), for: .touchUpInside)
        
        cell.approveBtn.addTarget(self, action:#selector(self.approveCheckBtnTapped), for: .touchUpInside)
        cell.payForBreakBtn.addTarget(self, action:#selector(self.payForBreakBtnTapped), for: .touchUpInside)
        cell.addCommentBtn.addTarget(self, action:#selector(self.addCommentBtnTapped), for: .touchUpInside)
        cell.lblType.halfTextMakeToBold(fullText: cell.lblType.text!, changeText: "Type :", textColor: divColorCode)
        
        self.makeTextTitleColorful(cell: cell)
        
        return cell
    }
    func makeTextTitleColorful(cell: HospitalityGroupTSTableViewCell){
        
        let divColorCode = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
        
        cell.lblName.halfTextMakeToBold(fullText: cell.lblName.text!, changeText: "Name", textColor: divColorCode)
        cell.lblPosition.halfTextMakeToBold(fullText: cell.lblPosition.text!, changeText: "Position", textColor: divColorCode)
        cell.lblPO.halfTextMakeToBold(fullText: cell.lblPO.text!, changeText: "PO", textColor: divColorCode)
        cell.lblBreak.halfTextMakeToBold(fullText: cell.lblBreak.text!, changeText: "Break", textColor: divColorCode)
        cell.lblTotal.halfTextMakeToBold(fullText: cell.lblTotal.text!, changeText: "Total", textColor: divColorCode)
        cell.lblTaxiFare.halfTextMakeToBold(fullText: cell.lblTaxiFare.text!, changeText: "Taxi Fare", textColor: divColorCode)
        cell.lblTime.halfTextMakeToBold(fullText: cell.lblTime.text!, changeText: "Time", textColor: divColorCode)
        cell.lblEval.halfTextMakeToBold(fullText: cell.lblEval.text!, changeText: "Eval", textColor: divColorCode)
        
        cell.payForBreakBtn.setTitleColor(divColorCode, for: .normal)
        cell.approveBtn.setTitleColor(divColorCode, for: .normal)
    }
 //
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView.tag == Legend_Tbl_Tag{
//            return colorLegendArray.count
//        }else if tableView.tag == Error_Tbl_Tag{
//            return FailureMessageArray.count
//        }else if tableView.tag == Position_Type_Tbl_Tag{
//            return PositionArray.count
//        }
//        return self.GetDayData().count
//
//    }
//    /*
//     {
//     "StatusMessage": "Check ProcessStatus List for more details ",
//     "MessageStatus": "0",
//     "Message": "Failure",
//     "ErrModel": null,
//     "ProcessStatus": [
//     {
//     "ProcessMessage": " Time conflicts for Work Date: 07/20/2018 Start Time: 08:00 AM and End Time: 08:00 PM",
//     "TimeID": 1056877
//     },
//     {
//     "ProcessMessage": "Note: Total hours zero will not be processed ",
//     "TimeID": 0
//     },
//     {
//     "ProcessMessage": " Time conflicts for Work Date: 07/20/2018 Start Time: 08:00 AM and End Time: 04:00 PM",
//     "TimeID": 1056878
//     }
//     ]
//     }
//     */
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if tableView.tag == Error_Tbl_Tag || tableView.tag == Legend_Tbl_Tag ||  tableView.tag == Position_Type_Tbl_Tag{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell") ?? UITableViewCell(style: .default, reuseIdentifier: "timeCell")
//            cell.selectionStyle = UITableViewCell.SelectionStyle.none
//
//            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
//            cell.textLabel?.numberOfLines = 0
//
//            cell.imageView?.image = nil
//            if  tableView.tag == Legend_Tbl_Tag{
//                let colorDict = colorLegendArray[indexPath.row] as! NSDictionary
//                let text = colorDict["Text"] as? String
//                let bgColor = colorDict["Color"] as? String
//
//                cell.backgroundColor = UIColor(hexString:bgColor!)
//                cell.textLabel?.textColor = UIColor.black
//                cell.textLabel?.textAlignment = .center
//
//
//                cell.textLabel?.text = text?.replace(target: "<br/>", withString: "\n")
//
//            }else if  tableView.tag == Position_Type_Tbl_Tag{
//                let  pos = PositionArray[indexPath.row] as! PositionType
//                let  posObj:PositionType = pos as PositionType
//
//                cell.textLabel?.textColor = UIColor.black
//                cell.textLabel?.textAlignment = .left
//
//                cell.textLabel?.text = posObj.PositionName
//                if posObj.isSelected == "1"{
//                    cell.accessoryType = .checkmark
//                }else{
//                    cell.accessoryType = .none
//                }
//            }else{
//                cell.textLabel?.textAlignment = .left
//                let colorDict = FailureMessageArray[indexPath.row] as! NSDictionary
//                let text = colorDict["Text"] as? String
//                let status = colorDict["Status"] as? Int
//                if status == 0{
//                    cell.backgroundColor = UIColor(hexString:danger_background_Color)
//                    cell.textLabel?.textColor = UIColor(hexString:danger_Color)
//                }else if status == 1{
//                    cell.backgroundColor = UIColor(hexString:success_background_Color)
//                    cell.textLabel?.textColor = UIColor(hexString:success_Color)
//
//                }
//                cell.textLabel?.text = text
//            }
//            return cell
//        }
//
//        if selectedDayIndex == HospitalityGroupTSViewController.Weekly{
//            return self.weeklyGroupTSCell(indexPath: indexPath)
//        }
//
//        let DivisionId =  UserDefaults.standard.integer(forKey: "DivisionId")
//        if DivisionId == Logistics_Division_ID{
//            return self.LogisticsWeekDayGroupTSCell(indexPath: indexPath)
//
//        }else{
//            return self.HospitalityWeekDayGroupTSCell(indexPath: indexPath)
//        }
//
//
//    }
//    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView.tag == Legend_Tbl_Tag{
//            let colorDict = colorLegendArray[indexPath.row] as! NSDictionary
//            let bgColor = colorDict["Color"] as? String
//            if bgColor?.count == 0{
//                return 115
//
//            }
//            return 40
//        }else if tableView.tag == Error_Tbl_Tag{
//            let dict = FailureMessageArray[indexPath.row] as! NSDictionary
//            let text = dict["Text"] as? String
//
//            let height =  (text?.heightWithConstrainedWidth(width: 255, font: UIFont.boldSystemFont(ofSize: CGFloat(15))))! + CGFloat(20) //self.sizeOfString(string: message!, constrainedToHeight: Double.greatestFiniteMagnitude).height + 10
//            return max(height,70)
//        }else if tableView.tag == Position_Type_Tbl_Tag{
//            return 40
//        }
//        let DivisionId =  UserDefaults.standard.integer(forKey: "DivisionId")
//        let screenWidth = UIScreen.main.bounds.size.width
//        let days = self.GetDayData()
//        if days.count == 0{}else{
//            if selectedDayIndex == HospitalityGroupTSViewController.Weekly{
//                return 260
//            }
//            //            if screenWidth > 375{
//            //                if DivisionId == Logistics_Division_ID{
//            //                    return 270
//            //                }
//            //                return 222
//            //            }
//            //check if approved or not
//            if DivisionId == Logistics_Division_ID{
//                if days.count == 0{}else{
//                    let  emp = days[(indexPath.row)] as! HosGroupTS
//                    let  empObj:HosGroupTS = emp as HosGroupTS
//                    if empObj.RecCode == "S" || empObj.RecCode == "C" {
//                        //show both remove and save
//                        return 295
//                    }else if empObj.RecCode == "P"{
//                        //Show  only save
//                        if screenWidth > 375{
//                            return 255
//                        }
//                        return 295
//                    }else{
//                        //hide both remove and save
//                        if screenWidth > 375{
//                            return 255
//                        }
//                        return 265
//                    }
//                }
//                return 295
//            }else{
//                if days.count == 0{}else{
//                    let  emp = days[(indexPath.row)] as! HosGroupTS
//                    let  empObj:HosGroupTS = emp as HosGroupTS
//                    if empObj.EvalVisible == true{//not approved
//                        return 255
//                    }
//                }
//                return 220
//            }
//        }
//        return 0
//    }
//
//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
//        if tableView.tag == Position_Type_Tbl_Tag{
//
//            let obj = PositionArray[indexPath.row]
//
//            let  o:PositionType = obj as! PositionType
//
//            for obj in PositionArray{
//                let posObj:PositionType = obj as! PositionType
//                posObj.isSelected = "0"
//            }
//            let days = self.GetDayData()
//            if days.count == 0{}else{
//                let  emp = days[firstResponderIndexPath] as! HosGroupTS
//                let  empObj:HosGroupTS = emp as HosGroupTS
//                empObj.selectedPosTypeID = o.PositionId
//                empObj.selectedPosTypeName = o.PositionName
//                if o.PositionId == empObj.selectedPosTypeID
//                {
//                    o.isSelected = "1"
//                    PositionArray.replaceObject(at: (indexPath.row), with: o)
//                }
//                days.replaceObject(at: (firstResponderIndexPath), with: empObj)
//            }
//            tableView.reloadData()
//            tsTableView.reloadData()
//        }
//    }
    
    //MARK:- GoBack
      override func goBack() {
          if isFromSafety {
              popToDasboardPageDirectly()
          }
          else {
              self.navigationController?.popViewController(animated: true)
          }
      }
    
    func pushToClientInvoicePage(){
        
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is ClientInvoiceViewController {
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ClientInvoiceSegue") as! ClientInvoiceViewController
            nextViewController.MessageParam = "Approve"
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    //MARK: Button Action
    @IBAction func tipCalButtonTapped(_ sender: UIButton) {
        //self.pushToTipCalVC()
        isTippPressed = true
        getHospitalityGroupTimeSheetData()
       
    }
    
    @IBAction override func okButtonTapped(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        if isGenerateInvoice == true{
            self.pushToClientInvoicePage()
        }else if isRemoveLogisticsTimeSheet == true {
            self.removeTimesheetServerCall()
        }else if isLogisticsTimeSheetRemoved == true{
            let days = self.GetDayData()
            if days.count  > 0 {
                tsTableView.beginUpdates()
                days.removeObject(at: (removeGTSIndexPath.row))
                tsTableView.deleteRows(at: [removeGTSIndexPath as IndexPath ], with: .left)
                tsTableView.endUpdates()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // Your code with delay
                self.navigationController?.view.makeToast("Please wait...", duration: 4.0, position: .bottom, title: "", image: nil)
            }
            self.getGroupTimeSheetData()
            
        }
    }
    @objc func timeButtonTapped(sender:UIButton) {
        
        customPickerView.removePickerViewFromSuperView()
        
    }
    @objc func datePickerValueChanged(sender: UIDatePicker){
        let changedDate = sender.date
        //▿ 2017-10-29 11:20:00 +0000
        sender.locale = NSLocale(localeIdentifier: "en_US") as Locale
        
        let formatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        var  pickedDateString = formatter.string(from: changedDate as Date)
        
        if  firstResponderTxtFieldTag == Int(Start_Time_TextField_TAG) || firstResponderTxtFieldTag == Int(End_Time_TextField_TAG){
            formatter.dateFormat = "MM/dd/yyyy hh:mm a"
            pickedDateString = formatter.string(from: changedDate as Date)
            
            let   stringArray = pickedDateString.components(separatedBy: " ")
            if stringArray.count>2{
                pickedDateString = String(format:"%@ %@",stringArray[1],stringArray[2])
                
                let days = self.GetDayData()
                if days.count == 0{}else{
                    if firstResponderIndexPath >= 0{
                        let  emp = days[(firstResponderIndexPath)] as! HosGroupTS
                        let  empObj:HosGroupTS = emp as HosGroupTS
                        if firstResponderTxtFieldTag == Int(Start_Time_TextField_TAG){
                            empObj.StartTime = pickedDateString
                        }else{
                            empObj.EndTime = pickedDateString
                        }
                        let timeDiff = self.getTimeDifference(date1: empObj.StartTime!, date2: empObj.EndTime!)
                        if empObj.PayForBreak == false{
                            let time = self.getTimeDifferenceWithBreakValue(time: timeDiff, breakValue: empObj.OriginalBreakValue!, isBreakValueChecked: empObj.PayForBreak!)
                            empObj.TotalHours =   time
                        }else{
                            empObj.TotalHours =   timeDiff
                        }
                        
                        if timeDiff < 4 {
                            empObj.BreakValue = "0"
                        }else{
                            empObj.BreakValue = empObj.OriginalBreakValue
                        }
                        days.replaceObject(at: (firstResponderIndexPath), with: empObj)
                        self.reloadTableViewRow(RowNum: firstResponderIndexPath)
                    }
                }
            }
        }
        
    }
    
    
    @IBAction func SelectAllBtnTapped(_ sender: UIButton) {
        if  ContactIsApproverYesNo == true{
            if sender.isSelected == true{
                sender.isSelected = false
            }else{
                sender.isSelected = true
                
            }
            
            let days = self.GetDayData()
            var Index = -1
            if days.count == 0{}else{
                for dict in days{
                    let  empObj:HosGroupTS = dict as! HosGroupTS
                    Index = days.index(of: empObj)
                    //Enabled
                    if empObj.EvalVisible == true && ContactIsApproverYesNo == true{
                        
                        if sender.isSelected == false {
                            empObj.IsApproved = false
                        }else{
                            empObj.IsApproved = true
                        }
                        days.replaceObject(at: Index, with: empObj)
                    }
                }
            }
            tsTableView.reloadData()
        }
        
        
    }
    @IBAction func infoBtnAction(_ sender: Any) {
        self.ShowTablePopup(TableViewTag: Legend_Tbl_Tag,Message:"")
    }
    @IBAction func approveTSBtnAction(_ sender: Any) {
        if  ContactIsApproverYesNo == true{
            let DivisionId =  UserDefaults.standard.integer(forKey: "DivisionId")
            if DivisionId == Logistics_Division_ID{
                self.ApproveLogisticsGroupTimeSheetServerCall()
            }else{
                self.approveGroupTimeSheetData(isForSaving: false)
            }
        }
    }
    @IBAction func saveTSBtnAction(_ sender: Any) {
        if  ContactIsApproverYesNo == true{
            let DivisionId =  UserDefaults.standard.integer(forKey: "DivisionId")
            if DivisionId == Logistics_Division_ID{
                if self.objectArrayForSavingLogisticsTS().count == 0{
                    isGenerateInvoice = false
                    isRemoveLogisticsTimeSheet = false
                    isLogisticsTimeSheetRemoved = false
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "There are no timesheets to save", okBtnTitle: "OK", cancelBtnTitle: "", type: Warning_Text, isAttributed: false)
                }else{
                    self.SaveLogisticsTimesheetServerCall(PendingList: self.objectArrayForSavingLogisticsTS())}
            }else{
                self.approveGroupTimeSheetData(isForSaving: true)
            }
        }
    }
    @IBAction func removeDataFromCellBtnAction (_ sender: UIButton){
        
        let senderPosition  = sender.convert(CGPoint.zero, to: tsTableView)
        let indexPath =  tsTableView.indexPathForRow(at:senderPosition)
        removeGTSIndexPath = indexPath! as NSIndexPath
        //Show alert with yes and cancel button
        isGenerateInvoice  = false
        isRemoveLogisticsTimeSheet = true
        isLogisticsTimeSheetRemoved = false
        self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Are you sure you want to delete this Time Sheet", okBtnTitle: "Yes", cancelBtnTitle: "No", type: Warning_Text, isAttributed: false)
        
    }
    
    @IBAction func saveDataFromCellBtnAction(_ sender: UIButton) {
        
        if  ContactIsApproverYesNo == true{
            let senderPosition  = sender.convert(CGPoint.zero, to: tsTableView)
            let indexPath =  tsTableView.indexPathForRow(at:senderPosition)
            let DivisionId =  UserDefaults.standard.integer(forKey: "DivisionId")
            let days = self.GetDayData()
            if days.count == 0{}else{
                let  emp = days[(indexPath?.row)!] as! HosGroupTS
                let  empObj:HosGroupTS = emp as HosGroupTS
                let isInternetAvailable =  self.isInternetAvailable()
                if isInternetAvailable {
                    let approveObjs = NSMutableArray()
                    let CandidateId:Double = Double(empObj.CandidateId!)
                    let TimeId:Double = Double(empObj.TimeId!)
                    let DetailId:Double = Double(empObj.DetailId!)
                    let OrderId:Double = Double(empObj.OrderId!)
                    let Approver:Double = Double(empObj.Approver!)
                    let EvalDB:Double = Double(empObj.EvalDB!)
                    let Eval:Double = Double(empObj.Eval!)
                    let recCode = String(format:"%@",empObj.RecCode!)
                    let CandidateName = String(format:"%@",empObj.CandidateName!)
                    let StTime = String(format:"%@",empObj.StartTime!)
                    let EdTime = String(format:"%@",empObj.EndTime!)
                    let BreakValue = String(format:"%@",empObj.BreakValue!)
                    let StartDate = String(format:"%@",empObj.StartDate!)
                    let StartTimeDB = String(format:"%@",empObj.StartTimeDB!)
                    let EndTimeDB = String(format:"%@",empObj.EndTimeDB!)
                    let Taxi = String(format:"%@",empObj.Taxi!)
                    if DivisionId == Logistics_Division_ID{
                        let PositionTypeId:Double = Double(empObj.selectedPosTypeID!)
                        
                        let obj = ["CandidateId":CandidateId,
                                   "PositionTypeId":PositionTypeId,
                                   "CandidateName":CandidateName,
                                   "TimeID":TimeId,
                                   "DetailsID":DetailId,
                                   "OrderId":OrderId,
                                   "WeekEnd": DateTxtField.text!,
                                   "StartTime":StTime,
                                   "EndTime":EdTime,
                                   "BreakTime":BreakValue,
                                   "RecCode":recCode,
                                   "Approver":Approver,
                                   "IsApproved":empObj.IsApproved!,
                                   "Eval":Eval,
                                   "Date":StartDate,
                                   "PayForBreak":empObj.PayForBreak!,
                                   "Taxi":Taxi,
                                   "EvalDB":EvalDB,
                                   "StartTimeDB":StartTimeDB ,
                                   "EndTimeDB":EndTimeDB,
                                   "IsApproveEnabled":empObj.IsApproveEnabled!] as [String : Any]
                        if !approveObjs.contains(obj){
                            approveObjs.add(obj)
                        }
                        self.SaveLogisticsTimesheetServerCall(PendingList: approveObjs)
                        
                    }else{
                        let TotalHours:Double = Double(empObj.TotalHours!)
                        let AssignmentComplete:Double = Double(empObj.AssignmentComplete!)
                        
                        let obj = ["CandidateId":CandidateId,
                                   "CandidateName":CandidateName,
                                   "TimeId":TimeId,
                                   "DetailId":DetailId,
                                   "OrderId":OrderId,
                                   "AssignmentComplete":AssignmentComplete,
                                   "StartTime":StTime,
                                   "EndTime":EdTime,
                                   "BreakValue":BreakValue,
                                   "TotalHours":TotalHours,
                                   "RecCode":recCode,
                                   "Approver":Approver,
                                   "IsApproved":empObj.IsApproved as Any,
                                   "Eval":Eval,
                                   "StartDate":StartDate,
                                   "PayForBreak":empObj.PayForBreak!,
                                   "TaxiOk":empObj.TaxiOk!,
                                   "Taxi":Taxi,
                                   "EvalVisible":empObj.EvalVisible!,
                                   "EvalDesc":String(format:"%@",empObj.EvalDesc!),
                                   "EvalDB":EvalDB,
                                   "StartTimeDB":StartTimeDB,
                                   "EndTimeDB":EndTimeDB,
                                   "IsApproveEnabled":empObj.IsApproveEnabled!,
                                   "TaxiVisible":empObj.TaxiVisible!,
                                   "WeekEnd": DateTxtField.text!] as [String : Any]
                        if !approveObjs.contains(obj){
                            approveObjs.add(obj)
                        }
                        self.saveApproveTimeSheetServerCall(approveObjs: approveObjs,BtnSource: "Save")
                    }
                }else{
                    isGenerateInvoice = false
                    isRemoveLogisticsTimeSheet = false
                    isLogisticsTimeSheetRemoved = false
                    self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                }
            }
        }else{
        }
    }
    @IBAction func GetTimeSheetBtnAction(_ sender: Any) {
        self.getGroupTimeSheetData()
        
    }
    @IBAction func GenerateBtnAction(_ sender: Any) {
        self.generateInvoiceServerCall()
    }
    @IBAction func clickHereBtnAction(_ sender: Any) {
        self.pushToViewPDFPage()
        
    }
    @IBAction func ShowOriginalSchduleBtnAction(_ sender: UIButton) {
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
        ShowScheduledHours = sender.isSelected
 
           self.ClearDayData()
         self.getGroupTimeSheetData()
    }
    
    @IBAction func approveCheckBtnTapped(_ sender: UIButton){
        let senderPosition  = sender.convert(CGPoint.zero, to: tsTableView)
        
        let indexPath =  tsTableView.indexPathForRow(at:senderPosition)
        let days = self.GetDayData()
        
        if days.count == 0{}else{
            
            let  emp = days[(indexPath?.row)!] as! HosGroupTS
            let  empObj:HosGroupTS = emp as HosGroupTS
            
            if empObj.IsApproved == false {
                empObj.IsApproved = true
            }else{
                empObj.IsApproved = false
                selectAllBtn.isSelected = false
            }
            days.replaceObject(at: (indexPath?.row)!, with: empObj)
            self.reloadTableViewRow(RowNum: (indexPath?.row)!)
            
        }
        
        //        tsTableView.reloadData()
    }
    
    
    
    @IBAction func payForBreakBtnTapped(_ sender: UIButton){
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
        let senderPosition  = sender.convert(CGPoint.zero, to: tsTableView)
        let indexPath =  tsTableView.indexPathForRow(at:senderPosition)
        let days = self.GetDayData()
        if days.count == 0{}else{
            
            let  emp = days[(indexPath?.row)!] as! HosGroupTS
            let  empObj:HosGroupTS = emp as HosGroupTS
            
            if empObj.PayForBreak == true{
                empObj.PayForBreak = false
            }else{
                empObj.PayForBreak = true
            }
            if selectedDayIndex == HospitalityGroupTSViewController.Weekly{
                if empObj.PayForBreak == true{
                    empObj.TotalHours = empObj.DBTotalHours!
                }else{
                    let timeDiff =   empObj.DBTotalHours! - empObj.TotalBreak!
                    empObj.TotalHours = timeDiff
                }
                
            }else{
                let timeDiff = self.getTimeDifference(date1: empObj.StartTime!, date2: empObj.EndTime!)
                if empObj.PayForBreak == false{
                    let time = self.getTimeDifferenceWithBreakValue(time: timeDiff, breakValue: empObj.OriginalBreakValue!, isBreakValueChecked: empObj.PayForBreak!)
                    empObj.TotalHours =   time
                }else{
                    empObj.TotalHours =   timeDiff
                }
                if timeDiff < 4 {
                    empObj.BreakValue = "0"
                }else{
                    empObj.BreakValue = empObj.OriginalBreakValue
                }
                
            }
            
            days.replaceObject(at: (indexPath?.row)!, with: empObj)
            self.reloadTableViewRow(RowNum: (indexPath?.row)!)
            
        }
        //        tsTableView.reloadData()
        
    }
    
    @IBAction func addCommentBtnTapped(_ sender: UIButton){
        
        
        let senderPosition  = sender.convert(CGPoint.zero, to: tsTableView)
        let indexPath =  tsTableView.indexPathForRow(at:senderPosition)
        showingPopupIndexPath = (indexPath?.row)!
        self.ShowCommentPopup()
        
    }
    func ShowCommentPopup(){
        commentPopupView.ShowPopup(superView: (self.navigationController?.view)!)
        
        let days = self.GetDayData()
        if days.count == 0{}else{
            let  emp = days[showingPopupIndexPath] as! HosGroupTS
            let  empObj:HosGroupTS = emp as HosGroupTS
            commentPopupView.commentTextView.text = empObj.Comments
            //            if Double(empObj.Eval!) == 0{
            if empObj.IsEvalDone == false{
                commentPopupView.commentTextView.becomeFirstResponder()
                
                commentPopupView.saveButton.isUserInteractionEnabled = true
                commentPopupView.commentTextView.isUserInteractionEnabled = true
                commentPopupView.saveButton.backgroundColor = UIColor(hexString:"#5CB85C")
            }else{
                commentPopupView.commentTextView.isUserInteractionEnabled = false
                commentPopupView.saveButton.isUserInteractionEnabled = false
                commentPopupView.saveButton.backgroundColor = UIColor(hexString:"#8CC19D")
                
            }
        }
        
        
    }
    @IBAction func closeCommentBtnTapped(_ sender: UIButton){
        commentPopupView.removeCommentPopupViewFromSuperView()
        let days = self.GetDayData()
        if days.count == 0{}else{
            if showingPopupIndexPath >= 0{
                let  emp = days[(showingPopupIndexPath)] as! HosGroupTS
                let  empObj:HosGroupTS = emp as HosGroupTS
                //                if Double(empObj.Eval!) == 0{
                if empObj.IsEvalDone == false{
                    empObj.Comments = empObj.OriginalComments
                    days.replaceObject(at: (showingPopupIndexPath), with: empObj)
                    tsTableView.reloadData()
                }
            }
        }
    }
    
    
    @IBAction func saveCommentBtnTapped(_ sender: UIButton){
        commentPopupView.removeCommentPopupViewFromSuperView()
        self.saveCommentServerCall()
    }
    
  
    

    
    deinit {
        print("\(#function)")
    }
    func removeCalendar(){
        self.calendarHeightConstraint.constant = 0
        self.calendarBGHeightConstraint.constant = 0
        
        self.calendar.isHidden = true
        self.bgCalendarView.isHidden = true
        self.view.layoutIfNeeded()
        
    }
    func showCalendar(){
        self.calendarHeightConstraint.constant = 267
        self.calendarBGHeightConstraint.constant = UIScreen.main.bounds.size.height - 197
        self.calendar.select(self.calendar.currentPage)
        if (DateTxtField.text?.count)! > 0 {
            let selDate = self.convertStringToDate(dateString: DateTxtField.text!)
            self.calendar.select(selDate)
        }
        self.calendar.isHidden = false
        self.bgCalendarView.isHidden = false
        self.view.layoutIfNeeded()
        
        
        
    }
    //MARk: Construct Param
    func objectArrayForApprovingTS()-> NSMutableArray{
        
        let approveObjs = NSMutableArray()
        
        for dict in self.GetDayData(){
            let  empObj:HosGroupTS = dict as! HosGroupTS
            
            if empObj.EvalVisible == true  && empObj.IsApproved == true {
                if selectedDayIndex == HospitalityGroupTSViewController.Weekly{
                    
                    let obj = ["Approver":empObj.Approver!,
                               "OrderId":empObj.OrderId!,
                               "CandidateId":empObj.CandidateId!,
                               "TimeId":empObj.TimeId!,
                               "MondayHours":empObj.MondayHours!,
                               "TuesdayHours":empObj.TuesdayHours!,
                               "WednesdayHours":empObj.WednesdayHours!,
                               "ThursdayHours":empObj.ThursdayHours!,
                               "FridayHours":empObj.FridayHours!,
                               "SaturdayHours":empObj.SaturdayHours!,
                               "SundayHours":empObj.SundayHours!,
                               "RegHours":empObj.RegHours!,
                               "OTHours":empObj.OTHours!,
                               "TotalHours":empObj.TotalHours!,
                               "DBTotalHours":empObj.DBTotalHours!,
                               "RecCode":empObj.RecCode!,
                               "Eval":empObj.Eval!,
                               "TotalBreak":empObj.TotalBreak!,
                               "DBTotalBreak":empObj.DBTotalBreak!,
                               "PayForBreak":empObj.PayForBreak!,
                               "TaxiOk":empObj.TaxiOk!,
                               "Taxi":empObj.Taxi!,
                               "EvalVisible":empObj.EvalVisible!,
                               "EvalDesc":empObj.EvalDesc!,
                               "EvalDB":empObj.EvalDB!,
                               "IsApproved":empObj.IsApproved!,
                               "TaxiVisible":empObj.TaxiVisible!,
                               "WeekEnd": DateTxtField.text!] as [String : Any]
                    if !approveObjs.contains(obj){
                        approveObjs.add(obj)
                    }
                    
                }else{
                    let DivisionId =  UserDefaults.standard.integer(forKey: "DivisionId")
                    var paramDict = NSMutableDictionary()
                    paramDict = ["CandidateId":empObj.CandidateId ?? Double(),
                                 "CandidateName":empObj.CandidateName!,
                                 "TimeId":empObj.TimeId!,
                                 "DetailId":empObj.DetailId!,
                                 "OrderId":empObj.OrderId!,
                                 "AssignmentComplete":empObj.AssignmentComplete!,
                                 "StartTime":empObj.StartTime!,
                                 "EndTime":empObj.EndTime!,
                                 "BreakValue":empObj.BreakValue!,
                                 "TotalHours":empObj.TotalHours!,
                                 "RecCode":empObj.RecCode!,
                                 "Approver":empObj.Approver!,
                                 "IsApproved":empObj.IsApproved!,
                                 "Eval":empObj.Eval!,
                                 "StartDate":empObj.StartDate!,
                                 "PayForBreak":empObj.PayForBreak!,
                                 "TaxiOk":empObj.TaxiOk!,
                                 "Taxi":empObj.Taxi!,
                                 "EvalVisible":empObj.EvalVisible!,
                                 "EvalDesc":empObj.EvalDesc!,
                                 "EvalDB":empObj.EvalDB!,
                                 "StartTimeDB":empObj.StartTimeDB!,
                                 "EndTimeDB":empObj.EndTimeDB!,
                                 "IsApproveEnabled":empObj.IsApproveEnabled!,
                                 "TaxiVisible":empObj.TaxiVisible!,
                                 "WeekEnd": DateTxtField.text!]
                    if DivisionId == Logistics_Division_ID{
                        paramDict["PositionTypeId"] = empObj.selectedPosTypeID
                    }
                    if !approveObjs.contains(paramDict){
                        approveObjs.add(paramDict)
                    }
                }
            }
        }
        
        
        return approveObjs
    }
    func objectArrayForSavingTS()-> NSMutableArray{
        
        let approveObjs = NSMutableArray()
        
        for dict in self.GetDayData(){
            let  empObj:HosGroupTS = dict as! HosGroupTS
            if empObj.EvalVisible == true  {
                if selectedDayIndex == HospitalityGroupTSViewController.Weekly{
                    
                    let obj = ["Approver":empObj.Approver!,
                               "OrderId":empObj.OrderId!,
                               "CandidateId":empObj.CandidateId!,
                               "TimeId":empObj.TimeId!,
                               "MondayHours":empObj.MondayHours!,
                               "TuesdayHours":empObj.TuesdayHours!,
                               "WednesdayHours":empObj.WednesdayHours!,
                               "ThursdayHours":empObj.ThursdayHours!,
                               "FridayHours":empObj.FridayHours!,
                               "SaturdayHours":empObj.SaturdayHours!,
                               "SundayHours":empObj.SundayHours!,
                               "RegHours":empObj.RegHours!,
                               "OTHours":empObj.OTHours!,
                               "TotalHours":empObj.TotalHours!,
                               "DBTotalHours":empObj.DBTotalHours!,
                               "RecCode":empObj.RecCode!,
                               "Eval":empObj.Eval!,
                               "TotalBreak":empObj.TotalBreak!,
                               "DBTotalBreak":empObj.DBTotalBreak!,
                               "PayForBreak":empObj.PayForBreak!,
                               "TaxiOk":empObj.TaxiOk!,
                               "Taxi":empObj.Taxi!,
                               "EvalVisible":empObj.EvalVisible!,
                               "EvalDesc":empObj.EvalDesc!,
                               "EvalDB":empObj.EvalDB!,
                               "IsApproved":empObj.IsApproved!,
                               "TaxiVisible":empObj.TaxiVisible!,
                               "WeekEnd": DateTxtField.text!] as [String : Any]
                    if !approveObjs.contains(obj){
                        approveObjs.add(obj)
                    }
                }else{
                    let obj = ["CandidateId":empObj.CandidateId! ?? Double(),
                               "CandidateName":empObj.CandidateName!,
                               "TimeId":empObj.TimeId!,
                               "DetailId":empObj.DetailId!,
                               "OrderId":empObj.OrderId!,
                               "AssignmentComplete":empObj.AssignmentComplete!,
                               "StartTime":empObj.StartTime!,
                               "EndTime":empObj.EndTime!,
                               "BreakValue":empObj.BreakValue!,
                               "TotalHours":empObj.TotalHours!,
                               "RecCode":empObj.RecCode!,
                               "Approver":empObj.Approver!,
                               "IsApproved":empObj.IsApproved!,
                               "Eval":empObj.Eval!,
                               "StartDate":empObj.StartDate!,
                               "PayForBreak":empObj.PayForBreak!,
                               "TaxiOk":empObj.TaxiOk!,
                               "Taxi":empObj.Taxi!,
                               "EvalVisible":empObj.EvalVisible!,
                               "EvalDesc":empObj.EvalDesc!,
                               "EvalDB":empObj.EvalDB!,
                               "StartTimeDB":empObj.StartTimeDB!,
                               "EndTimeDB":empObj.EndTimeDB!,
                               "IsApproveEnabled":empObj.IsApproveEnabled!,
                               "TaxiVisible":empObj.TaxiVisible!,
                               "WeekEnd": DateTxtField.text!] as [String : Any]
                    
                    if !approveObjs.contains(obj){
                        approveObjs.add(obj)
                    }
                }
            }
        }
        
        
        return approveObjs
    }
    func objectArrayForSavingLogisticsTS()-> NSMutableArray{
        
        let approveObjs = NSMutableArray()
        
        for dict in self.GetDayData(){
            let  empObj:HosGroupTS = dict as! HosGroupTS
            if empObj.EvalVisible == true  {
                var obj = ["CandidateId":empObj.CandidateId! ?? Double(),
                           "PositionTypeId":empObj.selectedPosTypeID!,
                           "CandidateName":empObj.CandidateName!,
                           "TimeId":empObj.TimeId!,
                           "DetailsId":empObj.DetailId!,
                           "OrderId":empObj.OrderId!,
                           "WeekEnd": DateTxtField.text!,
                           "StartTime":empObj.StartTime!,
                           "EndTime":empObj.EndTime!,
                           "BreakTime":empObj.BreakValue!,
                           "RecCode":empObj.RecCode!,
                           "Approver":empObj.Approver!,
                           "IsApproved":empObj.IsApproved!,
                           "Eval":empObj.Eval!,
                           "Date":empObj.StartDate!,
                           "PayForBreak":empObj.PayForBreak!,
                           "Taxi":empObj.Taxi!,
                           "EvalDB":empObj.EvalDB!,
                           "StartTimeDB":empObj.StartTimeDB!,
                           "EndTimeDB":empObj.EndTimeDB!,
                           "IsApproveEnabled":empObj.IsApproveEnabled!] as [String : Any]
                if !approveObjs.contains(obj){
                    approveObjs.add(obj)
                }
            }
        }
        return approveObjs
    }
    func approveGroupTimeSheetData(isForSaving: Bool) {
        let isInternetAvailable =  self.isInternetAvailable()
        //
        if isInternetAvailable {
            
            var approveObjs = NSMutableArray()
            var BtnSource = ""
            if isForSaving == true{
                approveObjs = self.objectArrayForSavingTS()
                BtnSource = "Save"
            }else{
                approveObjs = self.objectArrayForApprovingTS()
                BtnSource = "Approve"
            }
            
            if approveObjs.count == 0{
                if isForSaving == false{
                    self.navigationController?.view.makeToast("You must check at least one Time Slip to be Approved", duration: 3.0, position: .bottom, title: "", image: nil)
                }
            }else{
                if approveObjs.count == 0{
                    
                    isGenerateInvoice = false
                    isRemoveLogisticsTimeSheet = false
                    isLogisticsTimeSheetRemoved = false
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "There are no timesheets to save", okBtnTitle: "OK", cancelBtnTitle: "", type: Warning_Text, isAttributed: false)
                    
                }else{
                    self.saveApproveTimeSheetServerCall(approveObjs: approveObjs,BtnSource: BtnSource)
                    
                }
                
            }
        }else{
            isGenerateInvoice = false
            isRemoveLogisticsTimeSheet = false
            isLogisticsTimeSheetRemoved = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
        
    }

    //MARK: Server Call
    //this method gets the non TS staff array for the particular day
    func getNonTS(){
        
        let isInternetAvailable =  self.isInternetAvailable()
        //
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
             let params   = ["Clientid":clientID,
                            "Contactid":ContactId,
                            "WeekEnd":weekendDate,
                            "weekDayInput":weekdayDateFormat] as [String : Any] as NSDictionary
            
            print(params)
            let urlString = RestAPI.BaseUrl+RestAPI.HOS_GroupTS_GetNonTSStaff_URL
            RestAPI.postRequestWithToken(urlString: urlString, params: params, callback: getNonTSResponse(response:))
            
        }else{
            isGenerateInvoice = false
            isRemoveLogisticsTimeSheet = false
            isLogisticsTimeSheetRemoved = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
    }
    //Getgrouptimesheet
    func getGroupTimeSheetData() {
        
        let DivisionId =  UserDefaults.standard.integer(forKey: "DivisionId")
        if DivisionId == Logistics_Division_ID{
            self.getLogisticsGroupTimeSheetData()
        }else{
            self.getHospitalityGroupTimeSheetData()
        }
        
    }
    
    //getOverallData for specific keys this is the duplicate method of the original one
    //func getGroupTSResponse(response:AnyObject)->()
     func getGroupTSResponseDuplicate(response:AnyObject)->()
     {
        isTippPressed = false
        JustHUD.shared.hide()
        //        self.hideLoading()
        self.navigationController?.view.hideAllToasts()
        
        print(response)
        if response is String{
            isGenerateInvoice = false
            isRemoveLogisticsTimeSheet = false
            isLogisticsTimeSheetRemoved = false
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            if object["MessageStatus"].intValue == 1
            {
                PositionArray.removeAllObjects()
                colorLegendArray.removeAllObjects()
                
                if object["IsTipEnabled"].null == nil{
                    IsTipEnabled = object["IsTipEnabled"].boolValue
                }
                if object["IsTipsExists"].null == nil{
                    IsTipExsists = object["IsTipsExists"].boolValue
                }
                if object["IsTimeSheetNotApproved"].null == nil
                {
                    IsTimeSheetNotApproved = object["IsTimeSheetNotApproved"].boolValue
                }
                if object["IsShowNonTemPostionsStaffEnabled"].null == nil
                {
                    IsShowNonTemPostionsStaffEnabled = object["IsShowNonTemPostionsStaffEnabled"].boolValue
                }
                if object["RatePerHour"].null == nil
                {
                    RatePerHour = object["RatePerHour"].doubleValue
                }
                if object["CashAmount"].null == nil
                {
                    Cash = object["CashAmount"].doubleValue
                }
                if object["CreditAmount"].null == nil
                {
                    Credit = object["CreditAmount"].doubleValue
                }
                if object["IsInvoiceExists"].null == nil
                {
                    isInvoiced =  object["IsInvoiceExists"].intValue
                }
                if object["FileName"].null == nil
                {
                    submittedFileName = object["FileName"].stringValue
                }
                
                 self.getNonTS()
            }
            
        }
        isTippPressed = false
    }
    
    
    
    func getHospitalityGroupTimeSheetData() {
        //HospitalityGroupTSSegue
        let isInternetAvailable =  self.isInternetAvailable()
        //
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let DivisionId = String(format:"%d", defaults.integer(forKey: "DivisionId"))
            let UserName = String(format:"%@", defaults.string(forKey: "UserName")!)
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            
            let params   = ["Clientid":clientID,
                            "DivisionId":DivisionId,
                            "Contactid":ContactId,
                            "UserName":UserName,
                            "WeekEnd":weekendDate,
                            "weekDayInput":weekDayInput,
                            "ShowScheduledHours":ShowScheduledHours] as [String : Any] as NSDictionary
            
            print(params)
            let urlString = RestAPI.BaseUrl+RestAPI.Get_HOS_Group_Timesheet_URL
            if isTippPressed
            {
             RestAPI.postRequestWithToken(urlString: urlString, params: params, callback: getGroupTSResponseDuplicate(response:))
            }
            else
            {
            RestAPI.postRequestWithToken(urlString: urlString, params: params, callback: getGroupTSResponse(response:))
            }
            
        }else{
            isGenerateInvoice = false
            isRemoveLogisticsTimeSheet = false
            isLogisticsTimeSheetRemoved = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
        
    }
    
    func saveApproveTimeSheetServerCall(approveObjs: NSMutableArray,BtnSource: String){
        JustHUD.shared.showInView(view: view)
        
        let defaults = UserDefaults.standard
        
        let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
        let DivisionId = String(format:"%d", defaults.integer(forKey: "DivisionId"))
        let UserName = String(format:"%@", defaults.string(forKey: "UserName")!)
        let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
        
        let paramDict = ["Clientid":clientID,
                         "DivisionId":DivisionId,
                         "Contactid":ContactId,
                         "UserName":UserName,
                         "BtnSource": BtnSource,
                         "WeekEnd":DateTxtField.text!,
                         "weekDayInput":weekDayInput,
                         "ShowScheduledHours":ShowScheduledHours,
                         "ContactIsApproverYesNo":ContactIsApproverYesNo,
                         "IsValidLogistics":false,
                         "OSSource":"iOS",
                         self.GetDayName():approveObjs] as [String : Any] as NSDictionary
        
        //entering Order without Position
        //
        print(paramDict)
        let urlString = RestAPI.BaseUrl+RestAPI.HOS_GroupTS_Save_TS_URL
        
        RestAPI.postRequestWithToken(urlString: urlString, params: paramDict, callback: getApproveResponse(response:))
        
    }
    func generateInvoiceServerCall() {
        let isInternetAvailable =  self.isInternetAvailable()
        //
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let UserName = String(format:"%@", defaults.string(forKey: "UserName")!)
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            /*"PreviousDate" : "07/22/2018",
             "ClientId" :70829,
             "ContactId":194847,
             "Type":1*/
            let params   = ["Clientid":clientID,
                            "PreviousDate":DateTxtField.text!,
                            "Contactid":ContactId,
                            "OSSource": "iOS",
                            "Type":UserName] as [String : Any] as NSDictionary
            
            print(params)
            let urlString = RestAPI.BaseUrl+RestAPI.HOS_GroupTS_Generate_Invoice_URL
            
            RestAPI.generateInvoicePostRequestWithToken(urlString: urlString, params: params, callback: getGenerateInvoiceResponse(response:))
            
        }else{
            isGenerateInvoice = false
            isRemoveLogisticsTimeSheet = false
            isLogisticsTimeSheetRemoved = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
        
    }
    func saveCommentServerCall() {
        let isInternetAvailable =  self.isInternetAvailable()
        //
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            
            var RatingComments = ""
            var EmployeeEvaluation = Double(0)
            var CandidateId = Double(0)
            var OrderId = Double(0)
            
            let days = self.GetDayData()
            if days.count == 0{}else{
                let  emp = days[showingPopupIndexPath] as! HosGroupTS
                let  empObj:HosGroupTS = emp as HosGroupTS
                commentPopupView.commentTextView.text = empObj.Comments
                EmployeeEvaluation = empObj.Eval!
                RatingComments = empObj.Comments!
                CandidateId = empObj.CandidateId!
                OrderId = empObj.OrderId!
            }
            
            let params   = ["OrderId":OrderId,
                            "Contactid":ContactId,
                            "Clientid":clientID,
                            "OSSource": "iOS",
                            "CandidateId":CandidateId,
                            "RatingComments":RatingComments,
                            "EmployeeEvaluation":EmployeeEvaluation] as [String : Any] as NSDictionary
            
            print(params)
            let urlString = RestAPI.BaseUrl+RestAPI.HOS_GroupTS_Save_Comments_URL
            
            RestAPI.postRequestWithToken(urlString: urlString, params: params, callback: getSaveCommentResponse(response:))
            
        }else{
            isGenerateInvoice = false
            isRemoveLogisticsTimeSheet = false
            isLogisticsTimeSheetRemoved = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
        
    }
    func getSaveCommentResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        //        self.hideLoading()
        
        print(response)
        if response is String{
            isGenerateInvoice = false
            isRemoveLogisticsTimeSheet = false
            isLogisticsTimeSheetRemoved = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
                let days = self.GetDayData()
                if days.count == 0{}else{
                    if showingPopupIndexPath >= 0{
                        let  emp = days[(showingPopupIndexPath)] as! HosGroupTS
                        let  empObj:HosGroupTS = emp as HosGroupTS
                        empObj.OriginalComments = empObj.Comments
                        days.replaceObject(at: (showingPopupIndexPath), with: empObj)
                    }
                }
                isGenerateInvoice = false
                isRemoveLogisticsTimeSheet = false
                isLogisticsTimeSheetRemoved = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    message = Error_Message
                }
                isGenerateInvoice = false
                isRemoveLogisticsTimeSheet = false
                isLogisticsTimeSheetRemoved = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
    }
    func getGenerateInvoiceResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        //        self.hideLoading()
        
        print(response)
        if response is String{
            isGenerateInvoice = false
            isRemoveLogisticsTimeSheet = false
            isLogisticsTimeSheetRemoved = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
                self.navigationController?.view.makeToast("Please wait...", duration: 3.0, position: .bottom, title: "", image: nil)
                self.getGroupTimeSheetData()
                isGenerateInvoice = true
                isRemoveLogisticsTimeSheet = false
                isLogisticsTimeSheetRemoved = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    message = Error_Message
                }
                isGenerateInvoice = false
                isRemoveLogisticsTimeSheet = false
                isLogisticsTimeSheetRemoved = false
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
    }
    func getApproveResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        //        self.hideLoading()
        
        print(response)
        if response is String{
            isGenerateInvoice = false
            isRemoveLogisticsTimeSheet = false
            isLogisticsTimeSheetRemoved = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = "Submitted Successfully"
                    
                }
                isGenerateInvoice = false
                isRemoveLogisticsTimeSheet = false
                isLogisticsTimeSheetRemoved = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                self.navigationController?.view.makeToast("Please wait...", duration: 3.0, position: .bottom, title: "", image: nil)
                self.getGroupTimeSheetData()
            }else{
                var error = ""
                var msg = ""
                let DivisionId = UserDefaults.standard.integer(forKey: "DivisionId")
                if DivisionId == Logistics_Division_ID{
                    msg = "ErrorMessage"
                    error = "ErrModel"
                }else{
                    msg = "ProcessMessage"
                    error = "ProcessStatus"
                }
                if object[error] != nil{
                    let ProcessStatusArray = object[error].arrayValue
                    var message = object["Message"].stringValue
                    if ProcessStatusArray.count == 0{
                        
                        if message.count == 0 {
                            message = Error_Message
                        }
                        isGenerateInvoice = false
                        isRemoveLogisticsTimeSheet = false
                        isLogisticsTimeSheetRemoved = false
                        self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                    }else{
                        isGenerateInvoice = false
                        isRemoveLogisticsTimeSheet = false
                        isLogisticsTimeSheetRemoved = false
                        if ProcessStatusArray.count == 1{
                            //for one message , we can show in alert
                            let messageDict = ProcessStatusArray[0].dictionaryValue
                            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: (messageDict[msg]?.stringValue)!, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                            
                        }else{
                            //for multiple add to array
                            FailureMessageArray.removeAllObjects()
                            var StatusArray = NSMutableArray()
                            
                            for dict in ProcessStatusArray {
                                StatusArray.add(dict["Status"].stringValue)
                                FailureMessageArray.add(["Text":dict[msg].stringValue,"Color":"","Status": dict["Status"].intValue])
                            }
                            if StatusArray.contains("1"){
                                self.navigationController?.view.makeToast("Please wait...", duration: 3.0, position: .bottom, title: "", image: nil)
                                self.getGroupTimeSheetData()
                            }
                            self.ShowTablePopup(TableViewTag: Error_Tbl_Tag,Message: object["StatusMessage"].stringValue)
                        }
                    }
                }
            }
        }
    }
    func getLogisticsSaveResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        //        self.hideLoading()
        
        print(response)
        if response is String{
            isGenerateInvoice = false
            isRemoveLogisticsTimeSheet = false
            isLogisticsTimeSheetRemoved = false
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = "Submitted Successfully"
                    
                }
                isGenerateInvoice = false
                isRemoveLogisticsTimeSheet = false
                isLogisticsTimeSheetRemoved = false
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                self.navigationController?.view.makeToast("Please wait...", duration: 3.0, position: .bottom, title: "", image: nil)
                self.getGroupTimeSheetData()
            }else{
                
                if object["ErrModel"].null == nil{
                    let ProcessStatusArray = object["ErrModel"].arrayValue
                    var message = object["Message"].stringValue
                    if ProcessStatusArray.count == 0{
                        
                        if message.count == 0 {
                            message = Error_Message
                        }
                        isGenerateInvoice = false
                        isRemoveLogisticsTimeSheet = false
                        isLogisticsTimeSheetRemoved = false
                        
                        self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                    }else{
                        isGenerateInvoice = false
                        isRemoveLogisticsTimeSheet = false
                        isLogisticsTimeSheetRemoved = false
                        if ProcessStatusArray.count == 1{
                            //for one message , we can show in alert
                            let messageDict = ProcessStatusArray[0].dictionaryValue
                            
                            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: (messageDict["ErrorMessage"]?.stringValue)!, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                            
                        }else{
                            //for multiple add to array
                            FailureMessageArray.removeAllObjects()
                            let StatusArray = NSMutableArray()
                            
                            for dict in ProcessStatusArray {
                                StatusArray.add(dict["Status"].stringValue)
                                FailureMessageArray.add(["Text":dict["ErrorMessage"].stringValue,"Color":"","Status": dict["Status"].intValue])
                            }
                            if StatusArray.contains("1"){
                                self.navigationController?.view.makeToast("Please wait...", duration: 3.0, position: .bottom, title: "", image: nil)
                                self.getGroupTimeSheetData()
                            }
                            self.ShowTablePopup(TableViewTag: Error_Tbl_Tag,Message: object["StatusMessage"].stringValue)
                        }
                    }
                }
            }
        }
    }
    func getNonTSResponse(response:AnyObject)->()
    {
        JustHUD.shared.hide()
        self.navigationController?.view.hideAllToasts()
        
        print(response)
        if response is String{
            isGenerateInvoice = false
            isRemoveLogisticsTimeSheet = false
            isLogisticsTimeSheetRemoved = false
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            var object = response as! JSON
            
            nonTSStaffArray.removeAllObjects()
            if object["MessageStatus"].intValue == 1
            {
                if object["GetNonTsStaffList"].null == nil{
                    let list = object["GetNonTsStaffList"].arrayValue
                    
                    for dict in list {
                        let staff = NonTSStaff.init(Name: dict["CandidateName"].stringValue, Hour: dict["TotalHours"].doubleValue, CandidateId: dict["NonTSId"].doubleValue,TimpAmount:dict["TipAmount"].doubleValue)
                        
                        nonTSStaffArray.add(staff)
                    }
                }
            }
            self.pushToTipCalVC()
        }
    }
    func getGroupTSResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        //        self.hideLoading()
        self.navigationController?.view.hideAllToasts()
        
        print(response)
        if response is String{
            isGenerateInvoice = false
            isRemoveLogisticsTimeSheet = false
            isLogisticsTimeSheetRemoved = false
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            let defaults = UserDefaults.standard
            
            let DivisionId = defaults.integer(forKey: "DivisionId")
            
            var object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
                PositionArray.removeAllObjects()
                colorLegendArray.removeAllObjects()
                
                if  object["filePath"].null == nil{
                    if object["filePath"].stringValue.count == 0{}else{
                        FilePath = object["filePath"].stringValue}
                }
                if object["ContactIsApproverYesNo"].null == nil{
                    ContactIsApproverYesNo = object["ContactIsApproverYesNo"].boolValue
                }
                if DateTxtField != nil{
                    if DateTxtField.text?.count == 0{
                        DateTxtField.text = object["WeekEndDate"].stringValue
                    }
                }
               weekendDate = object["WeekEndDate"].stringValue
                if object["IsTipEnabled"].null == nil{
                    IsTipEnabled = object["IsTipEnabled"].boolValue
                }
                if object["IsTipsExists"].null == nil{
                    IsTipExsists = object["IsTipsExists"].boolValue
                }
                if object["IsTimeSheetNotApproved"].null == nil
                {
                    IsTimeSheetNotApproved = object["IsTimeSheetNotApproved"].boolValue
                }
                if object["IsShowNonTemPostionsStaffEnabled"].null == nil
                {
                    IsShowNonTemPostionsStaffEnabled = object["IsShowNonTemPostionsStaffEnabled"].boolValue
                }
                if object["RatePerHour"].null == nil
                {
                    RatePerHour = object["RatePerHour"].doubleValue
                }
                
                if object["CashAmount"].null == nil
                {
                    Cash = object["CashAmount"].doubleValue
                }
                if object["CreditAmount"].null == nil
                {
                    Credit = object["CreditAmount"].doubleValue
                }
                if object["IsInvoiceExists"].null == nil
                {
                    isInvoiced =  object["IsInvoiceExists"].intValue
                }
                if object["FileName"].null == nil
                {
                    submittedFileName = object["FileName"].stringValue
                }
                
                
                if self.navigationController?.viewControllers.last is TipCalViewController{
                }
                else
                {
                if object["IsGenerateInvoice"].null == nil
                {
                    if object["IsGenerateInvoice"].boolValue == false
                    {
                        generateInvoiceBtn.isHidden = true
                    }
                }
                }
                pendingErrorText = object["PendingText"].stringValue
                tipexsistsText = object["TipExistsText"].stringValue
                nonTSStaffArray.removeAllObjects()
                if object["GetNonTsStaffList"].null == nil{
                    let list = object["GetNonTsStaffList"].arrayValue
                    
                    for dict in list {
                        let staff = NonTSStaff.init(Name: dict["CandidateName"].stringValue, Hour: dict["TotalHours"].doubleValue, CandidateId: dict["NonTSId"].doubleValue,TimpAmount:dict["TipAmount"].doubleValue)
                        
                        nonTSStaffArray.add(staff)
                    }
                }
                
                self.showTipCalculator()
                let OldPendingWeekEnds = object["OldPendingWeekEnds"].stringValue
                
                if object["stepping"].null == nil{
                    stepping = object["stepping"].intValue
                }
                //color array
                if  object["colourText"].null == nil{
                    let colourTextArray = object["colourText"].array // as! NSMutableArray
                    
                    for dict in colourTextArray! {
                        colorLegendArray.add(["Text":dict["Text"].stringValue,"Color":dict["Color"].stringValue])
                    }
                }
                // Weekdays Array
                
                if object["WeekDays2"].null == nil{
                    let WeekDays2 = object["WeekDays2"].array // as! NSMutableArray
                    weekDayArray.removeAllObjects()
                    tipDayArray.removeAllObjects()
                    for dict in WeekDays2! {
                        let day =  dict["Day"].stringValue
                        if day.count > 3{
                           tipDayArray.add(["date":dict["Date"].stringValue,"count":dict["Count"].stringValue,"day":day])
                            weekDayArray.add(["date":dict["Date"].stringValue,"count":dict["Count"].stringValue,"day":day.prefix(3).uppercased()])
                        }
                    }
                }
                //getting the date item in dateformat
                if weekdayDateFormat.count == 0
                {
                let weekdayDict = tipDayArray.object(at:0) as! Dictionary<String,String>
                weekdayDateFormat = weekdayDict["date"] ?? ""
                }
                let weeklyDict = ["date":"","count":object["weeklyCount"].stringValue,"day":"Weekly"]
                weekDayArray.add(weeklyDict)
                if DivisionId == Logistics_Division_ID{
                    if object["PositionTypeList"].arrayValue != nil{
                        let posArray = object["PositionTypeList"].arrayValue
                        for dict in posArray {
                            let posObj = PositionType.init(PositionId: dict["PositionId"].intValue, PositionName: dict["PositionName"].stringValue, isSelected: "0")
                            PositionArray.add(posObj)
                        }
                    }
                }else{
                    
                    ShowBottomSave = object["ShowSave"].boolValue
                }
                
                // Days Array
                if object[self.GetDayName()].null == nil{
                    let TaskDataArray = object[self.GetDayName()].array // as! NSMutableArray
                    let dataA = NSMutableArray()
                    for dict in TaskDataArray! {
                        if self.GetDayName() == "WeekGroupTimeSheet" {
                            let taskObj = HosGroupTS.init(CandidateName: dict["CandidateName"].stringValue,
                                                          WeekEnd: dict["WeekEnd"].stringValue,
                                                          PONumber: dict["PONumber"].stringValue,
                                                          BreakValue: dict["TotalBreak"].stringValue,
                                                          TotalHours: dict["TotalHours"].doubleValue,
                                                          Position: dict["Position"].stringValue,
                                                          PayForBreak: dict["PayForBreak"].boolValue,
                                                          isSelected: "0",
                                                          BackGroundColorCode: dict["BackGroundColorCode"].stringValue,
                                                          EvalDB: dict["EvalDB"].doubleValue,
                                                          TaxiVisible: dict["TaxiVisible"].boolValue,
                                                          EvalDesc: dict["EvalDesc"].stringValue,
                                                          IsApproveEnabled: dict["IsApproved"].boolValue,
                                                          Taxi: dict["Taxi"].stringValue,
                                                          SaturdayHours: dict["SaturdayHours"].doubleValue,
                                                          TuesdayHours: dict["TuesdayHours"].doubleValue,
                                                          ThursdayHours: dict["ThursdayHours"].doubleValue,
                                                          FridayHours: dict["FridayHours"].doubleValue,
                                                          MondayHours: dict["MondayHours"].doubleValue,
                                                          SundayHours: dict["SundayHours"].doubleValue,
                                                          WednesdayHours: dict["WednesdayHours"].doubleValue,
                                                          OrderId: dict["OrderId"].doubleValue,
                                                          RegHours: dict["RegHours"].doubleValue,
                                                          OTHours: dict["OTHours"].doubleValue,
                                                          TotalBreak: dict["TotalBreak"].doubleValue,
                                                          EvalVisible: dict["EvalVisible"].boolValue,
                                                          CandidateId: dict["CandidateId"].doubleValue,
                                                          willShow:"0",
                                                          Eval:dict["Eval"].doubleValue,
                                                          DBTotalBreak: dict["DBTotalBreak"].doubleValue,
                                                          IsApproved: dict["IsApproved"].boolValue,
                                                          DBTotalHours: dict["DBTotalHours"].doubleValue,
                                                          Approver: dict["Approver"].doubleValue,
                                                          TimeId: dict["TimeId"].doubleValue,
                                                          RecCode: dict["RecCode"].stringValue,
                                                          TaxiOk: dict["TaxiOk"].boolValue,
                                                          Comments: dict["Comments"].stringValue,
                                                          OriginalComments: dict["Comments"].stringValue,
                                                          ShowSave: dict["ShowSave"].boolValue,
                                                          IsEvalDone: dict["IsEvalDone"].boolValue)
                            dataA.add(taskObj)
                            
                        }else{
                            if DivisionId == Logistics_Division_ID{
                                var posName = ""
                                //Get the selected Position Name
                                for obj in PositionArray{
                                    let posObj:PositionType = obj as! PositionType
                                    if posObj.PositionId == dict["PositionTypeId"].intValue{
                                        posName = posObj.PositionName!
                                        break
                                    }
                                }
                                
                                let taskObj = HosGroupTS.init(CandidateName: dict["CandidateName"].stringValue,
                                                              WeekEnd: dict["WeekEnd"].stringValue,
                                                              PONumber: dict["PONumber"].stringValue,
                                                              StartTime: dict["StartTime"].stringValue,
                                                              EndTime: dict["EndTime"].stringValue,
                                                              BreakValue: dict["BreakValue"].stringValue,
                                                              TotalHours: dict["TotalHours"].doubleValue,
                                                              Position: dict["Position"].stringValue,
                                                              StartDate: dict["StartDate"].stringValue,
                                                              PayForBreak: dict["PayForBreak"].boolValue,
                                                              isSelected: "0",
                                                              BackGroundColorCode: dict["BackGroundColorCode"].stringValue,
                                                              EvalDB: dict["EvalDB"].doubleValue,
                                                              TaxiVisible: dict["TaxiVisible"].boolValue,
                                                              EvalDesc: dict["EvalDesc"].stringValue,
                                                              IsApproveEnabled: dict["IsApproveEnabled"].boolValue,
                                                              Taxi: dict["Taxi"].stringValue,
                                                              EvalVisible: dict["EvalVisible"].boolValue,
                                                              CandidateId: dict["CandidateId"].doubleValue,
                                                              OrderId: dict["OrderId"].doubleValue,
                                                              StartTimeTxtFieldTag: Start_Time_TextField_TAG,
                                                              EndTimeTxtFieldTag: End_Time_TextField_TAG,
                                                              willShow:"0",
                                                              Eval: dict["Eval"].doubleValue,
                                                              StartTimeDB: dict["StartTimeDB"].stringValue,
                                                              EndTimeDB: dict["EndTimeDB"].stringValue,
                                                              RecCode: dict["RecCode"].stringValue,
                                                              Approver: dict["Approver"].doubleValue,
                                                              IsApproved: dict["IsApproved"].boolValue,
                                                              TaxiOk: dict["TaxiOk"].boolValue,
                                                              TimeId: dict["TimeId"].doubleValue,
                                                              DetailId: dict["DetailId"].doubleValue,
                                                              AssignmentComplete: dict["AssignmentComplete"].doubleValue,
                                                              Comments: dict["Comments"].stringValue,
                                                              OriginalBreakValue: dict["BreakValue"].stringValue,
                                                              OriginalComments: dict["Comments"].stringValue,
                                                              selectedPosTypeName: posName,
                                                              selectedPosTypeID:dict["PositionTypeId"].intValue,
                                                              IsEvalDone: dict["IsEvalDone"].boolValue)
                                dataA.add(taskObj)
                            }else{
                                let taskObj = HosGroupTS.init(CandidateName: dict["CandidateName"].stringValue,
                                                              WeekEnd: dict["WeekEnd"].stringValue,
                                                              PONumber: dict["PONumber"].stringValue,
                                                              StartTime: dict["StartTime"].stringValue,
                                                              EndTime: dict["EndTime"].stringValue,
                                                              BreakValue: dict["BreakValue"].stringValue,
                                                              TotalHours: dict["TotalHours"].doubleValue,
                                                              Position: dict["Position"].stringValue,
                                                              StartDate: dict["StartDate"].stringValue,
                                                              PayForBreak: dict["PayForBreak"].boolValue,
                                                              isSelected: "0",
                                                              BackGroundColorCode: dict["BackGroundColorCode"].stringValue,
                                                              EvalDB: dict["EvalDB"].doubleValue,
                                                              TaxiVisible: dict["TaxiVisible"].boolValue,
                                                              EvalDesc: dict["EvalDesc"].stringValue,
                                                              IsApproveEnabled: dict["IsApproveEnabled"].boolValue,
                                                              Taxi: dict["Taxi"].stringValue,
                                                              EvalVisible: dict["EvalVisible"].boolValue,
                                                              CandidateId: dict["CandidateId"].doubleValue,
                                                              OrderId: dict["OrderId"].doubleValue,
                                                              StartTimeTxtFieldTag: Start_Time_TextField_TAG,
                                                              EndTimeTxtFieldTag: End_Time_TextField_TAG,
                                                              willShow:"0",
                                                              Eval: dict["Eval"].doubleValue,
                                                              StartTimeDB: dict["StartTimeDB"].stringValue,
                                                              EndTimeDB: dict["EndTimeDB"].stringValue,
                                                              RecCode: dict["RecCode"].stringValue,
                                                              Approver: dict["Approver"].doubleValue,
                                                              IsApproved: dict["IsApproved"].boolValue,
                                                              TaxiOk: dict["TaxiOk"].boolValue,
                                                              TimeId: dict["TimeId"].doubleValue,
                                                              DetailId: dict["DetailId"].doubleValue,
                                                              AssignmentComplete: dict["AssignmentComplete"].doubleValue,
                                                              Comments: dict["Comments"].stringValue,
                                                              OriginalBreakValue: dict["BreakValue"].stringValue,
                                                              OriginalComments: dict["Comments"].stringValue,
                                                              ShowSave: dict["ShowSave"].boolValue,
                                                              IsEvalDone: dict["IsEvalDone"].boolValue,TipAmount:dict["TipAmount"].doubleValue)
                                dataA.add(taskObj)
                            }
                        }
                    }
                    
                    if selectedDayIndex == HospitalityGroupTSViewController.Monday {
                        daysDict["MON"] =  dataA
                    }else if selectedDayIndex == HospitalityGroupTSViewController.Tuesday {
                        daysDict ["TUE"] =  dataA
                    }else if selectedDayIndex == HospitalityGroupTSViewController.Wednesday {
                        daysDict ["WED"] =  dataA
                    }else if selectedDayIndex == HospitalityGroupTSViewController.Thursday {
                        daysDict  ["THU"] =  dataA
                    }else if selectedDayIndex == HospitalityGroupTSViewController.Friday {
                        daysDict  ["FRI"] =  dataA
                    }else if selectedDayIndex == HospitalityGroupTSViewController.Saturday {
                        daysDict ["SAT"] =  dataA
                    }else if selectedDayIndex == HospitalityGroupTSViewController.Sunday {
                        daysDict ["SUN"] =  dataA
                    }else if selectedDayIndex == HospitalityGroupTSViewController.Weekly {
                        daysDict["WEEKLY"] = dataA
                    }
 
                    
                    if self.navigationController?.viewControllers.last is TipCalViewController{
                        let tipcalVC: TipCalViewController = self.navigationController?.viewControllers.last as! TipCalViewController
                        //tipcalVC.tempositionsList.removeAllObjects()
                        //tipcalVC.nonTempositionsList.removeAllObjects()
                        tipcalVC.tempositionsList = self.GetDayData()
                        tipcalVC.nonTempositionsList = nonTSStaffArray
                        tipcalVC.selectedDateDay = weekdayDateFormat+" "+weekDayInput
                        tipcalVC.ShowScheduledHours = self.ShowScheduledHours
                        tipcalVC.isTipSubmitted = IsTipExsists
                        tipcalVC.IsTimeSheetNotApprove = IsTimeSheetNotApproved
                        tipcalVC.IsShowNonTemPostionsStaffEnable = IsShowNonTemPostionsStaffEnabled
                        tipcalVC.eachTip = RatePerHour
                        tipcalVC.weekEnd = weekendDate
                        tipcalVC.tempData = daysDict
                        tipcalVC.cash = Cash
                        tipcalVC.credit = Credit
                        tipcalVC.tempDayArray = dataA
                        tipcalVC.tempOldWeekEnds = OldPendingWeekEnds
                        tipcalVC.pendingText = object["PendingText"].stringValue
                        tipcalVC.tipExistsText = object["TipExistsText"].stringValue
                        tipcalVC.invoiced = isInvoiced
                        tipcalVC.fileName = submittedFileName
                        tipcalVC.setupUIForPreview()
                        
                    }else{
                        self.updateHospitalityData(dataA: dataA, OldPendingWeekEnds: OldPendingWeekEnds)
                    }
 
                }
                
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                isGenerateInvoice = false
                isRemoveLogisticsTimeSheet = false
                isLogisticsTimeSheetRemoved = false
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
    }
    func updateHospitalityData(dataA: NSMutableArray,OldPendingWeekEnds: String){
        
        let DivisionId = UserDefaults.standard.integer(forKey: "DivisionId")

        if dataA.count == 0{
            noDataView.isHidden = false
            lblNoData.text = "No records found."
            saveBtn.isHidden = true
            selectAllBtn.isHidden = true
            approveTSBtn.isHidden = true
            generateInvoiceBtn.isEnabled = false
            generateInvoiceBtn.backgroundColor = UIColor.lightGray
            
        }else{
            selectAllBtn.isSelected = false
            generateInvoiceBtn.backgroundColor = UIColor(hexString:"#5CB85C")//true
            generateInvoiceBtn.isEnabled = true
            
            if selectedDayIndex == HospitalityGroupTSViewController.Weekly{
                saveBtn.isHidden = true
            }else{
                if DivisionId == Logistics_Division_ID{
                    saveBtn.isHidden = false
                }else{
                    saveBtn.isHidden = !ShowBottomSave
                }
                
            }
            noDataView.isHidden = true
            selectAllBtn.isHidden = false
            approveTSBtn.isHidden = false
            
        }
        if ContactIsApproverYesNo == false{
            selectAllBtn.isHidden = true
            approveTSBtn.isHidden = true
            saveBtn.isHidden = true
        }
        self.updateScrollviewForScreenOrientation()
        print(daysDict)
        DispatchQueue.main.async(execute: { () -> Void in
            if OldPendingWeekEnds.count == 0{
                self.noteBGView.backgroundColor = UIColor.clear
                self.showOriginalTopConstraint.constant = 5
                self.lblNote.text = ""
                self.view.layoutIfNeeded()
                
            }else{
                self.noteBGView.backgroundColor = UIColor(hexString:self.info_background_Color)
                self.lblNote.textColor = UIColor(hexString:self.info_Color)
                self.lblNote.text = OldPendingWeekEnds.replace(target: "<br/>", withString: "\n")
                self.showOriginalTopConstraint.constant = 55
                self.view.layoutIfNeeded()
                
            }
            
            self.tsTableView.reloadData()
            self.DayDateColView.reloadData()
            self.scrolltableViewToTheTop()
        })
    }
    
    //MARK: Logistics Server Call
    func getLogisticsGroupTimeSheetData() {
        //HospitalityGroupTSSegue
        let isInternetAvailable =  self.isInternetAvailable()
        //
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            
            let defaults = UserDefaults.standard
            
            let DivisionId = String(format:"%d", defaults.integer(forKey: "DivisionId"))
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let UserName = String(format:"%@", defaults.string(forKey: "UserName")!)
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            
            let params   = ["Clientid":clientID,
                            "DivisionId":DivisionId,
                            "Contactid":ContactId,
                            "UserName":UserName,
                            "WeekEnd":DateTxtField.text!,
                            "weekDayInput":weekDayInput,
                            "ShowScheduledHours":ShowScheduledHours] as [String : Any] as NSDictionary
            
            print(params)
            let urlString = RestAPI.BaseUrl+RestAPI.Get_Logistics_Group_TS_URL
            
            RestAPI.postRequestWithToken(urlString: urlString, params: params, callback: getGroupTSResponse(response:))
            
        }else{
            isGenerateInvoice = false
            isRemoveLogisticsTimeSheet = false
            isLogisticsTimeSheetRemoved = false
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
        
    }
    func removeTimesheetServerCall(){
        let isInternetAvailable =  self.isInternetAvailable()
        
        if isInternetAvailable {
            
            JustHUD.shared.showInView(view: view)
            
            let days = self.GetDayData()
            if days.count == 0{}else{
                
                let  emp = days[removeGTSIndexPath.row] as! HosGroupTS
                let  empObj:HosGroupTS = emp as HosGroupTS
                let params   = ["OrderId":empObj.OrderId!,
                                "CandidateId":empObj.CandidateId!,
                                "WeekEnd":empObj.WeekEnd!,
                                "Date":empObj.StartDate!,
                                "StartTime":empObj.StartTime!,
                                "OSSource": "iOS",
                                "EndTime":empObj.EndTime!] as [String : Any] as NSDictionary
                
                print(params)
                let urlString = RestAPI.BaseUrl+RestAPI.Remove_Logistics_Group_TS_URL
                RestAPI.postRequestWithToken(urlString: urlString, params: params, callback: getRemoveGroupTSResponse(response:))
                
            }
        }else{
            isGenerateInvoice = false
            isRemoveLogisticsTimeSheet = false
            isLogisticsTimeSheetRemoved = false
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
        
    }
    func getRemoveGroupTSResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        self.navigationController?.view.hideAllToasts()
        
        print(response)
        if response is String{
            isGenerateInvoice = false
            isRemoveLogisticsTimeSheet = false
            isLogisticsTimeSheetRemoved = false
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }else{
            var object = response as! JSON
            if object["MessageStatus"].intValue == 1
            {
                var message = object["Message"].stringValue
                if message.count == 0 {
                    message = "Time sheet removed successfully"
                }
                isLogisticsTimeSheetRemoved = true
                isGenerateInvoice = false
                isRemoveLogisticsTimeSheet = false
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                
            }else{
                var message = object["Message"].stringValue
                if message.count == 0 {
                    message = Error_Message
                }
                isGenerateInvoice = false
                isRemoveLogisticsTimeSheet = false
                isLogisticsTimeSheetRemoved = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
    }
    func SaveLogisticsTimesheetServerCall(PendingList: NSMutableArray){
        let isInternetAvailable =  self.isInternetAvailable()
        
        if isInternetAvailable {
            
            JustHUD.shared.showInView(view: view)
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let DivisionId = String(format:"%d", defaults.integer(forKey: "DivisionId"))
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            
            let paramDict = ["Clientid":clientID,
                             "DivisionId":DivisionId,
                             "Contactid":ContactId,
                             "OSSource":"iOS",
                             "PendingList":PendingList] as [String : Any] as NSDictionary
            print(paramDict)
            let urlString = RestAPI.BaseUrl+RestAPI.Save_Multiple_Logistics_Group_TS_URL
            RestAPI.postRequestWithToken(urlString: urlString, params: paramDict, callback: getLogisticsSaveResponse(response:))
            
        }else{
            isGenerateInvoice = false
            isRemoveLogisticsTimeSheet = false
            isLogisticsTimeSheetRemoved = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
        
    }
    func ApproveLogisticsGroupTimeSheetServerCall(){
        
        if self.objectArrayForApprovingTS().count == 0{
            self.navigationController?.view.makeToast("You must check at least one Time Slip to be Approved", duration: 3.0, position: .bottom, title: "", image: nil)
        } else{
            let isInternetAvailable =  self.isInternetAvailable()
            
            if isInternetAvailable {
                JustHUD.shared.showInView(view: view)
                
                let defaults = UserDefaults.standard
                
                let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
                let DivisionId = String(format:"%d", defaults.integer(forKey: "DivisionId"))
                let UserName = String(format:"%@", defaults.string(forKey: "UserName")!)
                let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
                
                let paramDict = ["Clientid":clientID,
                                 "DivisionId":DivisionId,
                                 "Contactid":ContactId,
                                 "UserName":UserName,
                                 "BtnSource":"Approve",
                                 "WeekEnd":DateTxtField.text!,
                                 "weekDayInput":weekDayInput,
                                 "ShowScheduledHours":ShowScheduledHours,
                                 "ContactIsApproverYesNo":ContactIsApproverYesNo,
                                 "OSSource":"iOS",
                                 self.GetDayName():self.objectArrayForApprovingTS()] as [String : Any] as NSDictionary
                
                //entering Order without Position
                
                print(paramDict)
                let urlString = RestAPI.BaseUrl+RestAPI.Approve_Logistics_Group_TS_URL
                
                RestAPI.postRequestWithToken(urlString: urlString, params: paramDict, callback: getApproveResponse(response:))
            }else{
                isGenerateInvoice = false
                isRemoveLogisticsTimeSheet = false
                isLogisticsTimeSheetRemoved = false
                self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
            
        }
        
        
    }
    //MARK:
    
    func scrolltableViewToTheTop(){
        DispatchQueue.main.async(execute: { () -> Void in
            
            let count = self.GetDayData().count
            if count > 0{
                let pathToTopRow = IndexPath.init(row: 0, section: 0)
                self.tsTableView.scrollToRow(at: pathToTopRow, at: .top, animated: false)
            }
        })
        
    }
    func scrollDaysCollectionViewToIndex()
    {
         let pathToTopRow = IndexPath.init(item:selectedDayIndex, section:0)
        self.DayDateColView.scrollToItem(at:pathToTopRow, at:.centeredHorizontally, animated:true)
    }
    
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        
        
        var text=""
        self.tsTableView.isScrollEnabled = true
        self.scrolltableViewToTheTop()
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            DispatchQueue.main.async(execute: { () -> Void in
                self.addDivisionNameOnTop()
                self.updateScrollviewForScreenOrientation()
            })
        case .portraitUpsideDown:
            text="PortraitUpsideDown"
        case .landscapeLeft:
            text="LandscapeLeft"
            DispatchQueue.main.async(execute: { () -> Void in
                self.addDivisionNameOnTop()
                
                self.updateScrollviewForScreenOrientation()
            })
        case .landscapeRight:
            text="LandscapeRight"
            DispatchQueue.main.async(execute: { () -> Void in
                self.addDivisionNameOnTop()
                
                self.updateScrollviewForScreenOrientation()
            })
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
        DispatchQueue.main.async(execute: { () -> Void in
            self.tsTableView.reloadData()
        })
        
    }
    
}
extension HospitalityGroupTSViewController:UITextFieldDelegate{
    //MARK: UITEXTFIELD DELEGATE
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
     
        if self.navigationController?.viewControllers.last is TipCalViewController{
        return true
        }else if self.navigationController?.viewControllers.last is HospitalityGroupTSViewController{
            if textField.tag == DateTextField_TAG{
                if self.calendar.isHidden == true{
                    self.showCalendar()
                }else{
                    self.removeCalendar()
                }
            }else if textField.tag == Int(Type_TextField_TAG){
                
                let senderPosition  = textField.convert(CGPoint.zero, to: tsTableView)
                
                let indexPath =  tsTableView.indexPathForRow(at:senderPosition)
                firstResponderIndexPath = (indexPath?.row)!
                firstResponderTxtFieldTag = textField.tag
                
                self.ShowTablePopup(TableViewTag: Position_Type_Tbl_Tag,Message: "")
                
            }else {
                
                if tsTableView != nil{
                    
                    let senderPosition  = textField.convert(CGPoint.zero, to: tsTableView)
                    
                    let indexPath =  tsTableView.indexPathForRow(at:senderPosition)
                    var TimeValue = ""
                    let days = self.GetDayData()
                    if days.count == 0{}else{
                        firstResponderIndexPath = (indexPath?.row)!
                        firstResponderTxtFieldTag = textField.tag
                        let  emp = days[(indexPath?.row)!] as! HosGroupTS
                        let  empObj:HosGroupTS = emp as HosGroupTS
                        if textField.tag == Int(empObj.StartTimeTxtFieldTag!)!{
                            TimeValue = empObj.StartTime!
                        }else if textField.tag == Int(empObj.EndTimeTxtFieldTag!)!{
                            TimeValue = empObj.EndTime!
                        }
                    }
                    let dateFormatter1 = DateFormatter()
                    dateFormatter1.locale = Locale.preferredLocale()
                    dateFormatter1.dateFormat = "MM/dd/yyyy hh:mm a"
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale.preferredLocale()
                    dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
                    let myString = dateFormatter.string(from: Date())//"07/26/2018 01:28 PM"
                    let yourDate = dateFormatter.date(from: myString)//2018-07-26 07:58:00 +0000
                    
                    dateFormatter.dateFormat = dateFormat
                    // again convert your date to string
                    let date = dateFormatter.string(from: yourDate!)
                    let time = String(format:"%@ %@",date,TimeValue)
                    let sTime = dateFormatter1.date(from: time)
                    
                    
                    customPickerView.dtPickerView.datePickerMode = UIDatePicker.Mode.time
                    
                    if sTime != nil{
                        customPickerView.dtPickerView.date = sTime!
                    }
                    customPickerView.showPickerViewOnSuperView(superView: (self.navigationController?.view)!, isDatePicker: true,minuteInterval: stepping,isPortrait: self.isPortrait())
                    textField.resignFirstResponder()
                }
            }
            
            
        }
       
        return true
        
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField){
        if self.navigationController?.viewControllers.last is TipCalViewController{
         }else if self.navigationController?.viewControllers.last is HospitalityGroupTSViewController{
             textField.resignFirstResponder()
         }
        
    }
    public func textFieldDidEndEditing(_ textField: UITextField){
    }
    
}
extension HospitalityGroupTSViewController: UITextViewDelegate{
    
    //MARK:UITextView Delegate Methods
    
    func textView(_ textView: UITextView, shouldChangeTextIn: NSRange, replacementText: String) -> Bool
    {
        let days = self.GetDayData()
        if days.count == 0{}else{
            if showingPopupIndexPath >= 0{
                let  emp = days[(showingPopupIndexPath)] as! HosGroupTS
                let  empObj:HosGroupTS = emp as HosGroupTS
                empObj.Comments = textView.text+replacementText
                days.replaceObject(at: (showingPopupIndexPath), with: empObj)
            }
            
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView)
    {
        view.endEditing(true)
        
        //        let days = self.GetDayData()
        //        if days.count == 0{}else{
        //            if showingPopupIndexPath >= 0{
        //                let  emp = days[(showingPopupIndexPath)] as! HosGroupTS
        //                let  empObj:HosGroupTS = emp as HosGroupTS
        //                empObj.Comments = textView.text
        //                days.replaceObject(at: (showingPopupIndexPath), with: empObj)
        //            }
        //
        //        }
    }
}
extension HospitalityGroupTSViewController: FloatRatingViewDelegate{
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        //        String(format: "%.2f", ratingView.rating)
        //        print(String(format: "%.2f", ratingView.rating))
        
        
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        //        String(format: "%.2f", ratingView.rating)
        let senderPosition  = ratingView.convert(CGPoint.zero, to: tsTableView)
        
        let indexPath =  tsTableView.indexPathForRow(at:senderPosition)
        showingPopupIndexPath = (indexPath?.row)!
        let days = self.GetDayData()
        if days.count == 0{}else{
            if showingPopupIndexPath >= 0{
                let  emp = days[(showingPopupIndexPath)] as! HosGroupTS
                let  empObj:HosGroupTS = emp as HosGroupTS
                empObj.Eval = rating
                days.replaceObject(at: (showingPopupIndexPath), with: empObj)
            }
        }
        self.tsTableView.reloadData()
        self.saveCommentServerCall()
        
    }
}
extension HospitalityGroupTSViewController: FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance{
    
    //MARK: Calendar Methods
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int
    {
        
        //        let eventDate = self.dateFormatter.string(from: date)
        //        if self.datesWithMultipleEvents.contains(eventDate)
        //        {
        //
        //            return self.datesWithMultipleEvents.filter{$0 == eventDate}.count
        //        }
        return 0
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        //        let key = self.dateFormatter.string(from: date)
        
        return nil
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        
        let todayDate = date
        let todayString = formatter.string(from: todayDate)
        let todaysDay = self.getDayOfWeek(today: todayString)
        
        if todaysDay == "Sunday" {
            return UIColor.black
            
        }else{
            return UIColor.lightGray
            
        }
        
        
    }
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        
        let todayDate = date
        let todayString = formatter.string(from: todayDate)
        let todaysDay = self.getDayOfWeek(today: todayString)
        
        if todaysDay == "Sunday" {
            return true
            
        }else{
            return false
            
        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    private func calendar(calendar: FSCalendar, appearance: FSCalendarAppearance, selectionColorForDate date: Date) -> UIColor? {
        
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        
        let todayDate = date
        let todayString = formatter.string(from: todayDate as Date)
        let todaysDay = self.getDayOfWeek(today: todayString)
        
        if todaysDay == "Sunday" {
            return UIColor.red
            
        }else{
            return UIColor.clear
            
        }
        
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        
        print("did select date \(self.dateFormatter.string(from: date))")
        
        //        let result = self.dateFormatter.string(from: date)
        resultDate = self.dateFormatter.string(from: date)
        
        
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        
        
        let todayDate = date
        let todayString = formatter.string(from: todayDate)
        let todaysDay = self.getDayOfWeek(today: todayString)
        
        if todaysDay == "Sunday" {
            self.removeCalendar()
            DateTxtField.text = resultDate
            weekendDate =   resultDate
            weekdayDateFormat = ""
            weekDayInput = "Monday"
            DispatchQueue.main.async(execute: { () -> Void in
                
                if self.weekDayArray.count > 0{
                    self.DayDateColView?.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                      at: .top,
                                                      animated: true)
                }
            })
            approveTSBtn.setTitle("Approve Monday Timesheet", for: .normal)
            
            selectedDayIndex = HospitalityGroupTSViewController.Monday
             daysDict.removeAllObjects()
            daysDict = ["MON":NSMutableArray(),"TUE":NSMutableArray(),"WED":NSMutableArray(),"THU":NSMutableArray(),"FRI":NSMutableArray(),"SAT":NSMutableArray(),"SUN":NSMutableArray(),"WEEKLY":NSMutableArray()]
            
            self.getGroupTimeSheetData()
            tsTableView.reloadData()

        }else{
            self.navigationController?.view.makeToast("Please select weekend", duration: 3.0, position: .bottom, title: "", image: nil)
        }
        
        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        //        resultDate = self.dateFormatter.string(from: calendar.currentPage)
        //        self.calendar.select(calendar.currentPage)
        //        resultDate = self.dateFormatter.string(from: calendar.currentPage)
        //        DateTxtField.text = resultDate
        //
        //        //        self.getActiveOrdersOnDate(date: self.dateFormatter.string(from: calendar.currentPage))
        //        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    
    
}
extension HospitalityGroupTSViewController: UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90 , height: 40)
    }

    
}
extension HospitalityGroupTSViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    //MARK: UICollectionview Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekDayArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        selectedDayIndex = indexPath.row
        
        if selectedDayIndex == HospitalityGroupTSViewController.Monday {
            weekDayInput = "Monday"
            approveTSBtn.setTitle("Approve Monday Timesheet", for: .normal)
            
        }else if selectedDayIndex == HospitalityGroupTSViewController.Tuesday {
            weekDayInput = "Tuesday"
            approveTSBtn.setTitle("Approve Tuesday Timesheet", for: .normal)
            
        }else if selectedDayIndex == HospitalityGroupTSViewController.Wednesday {
            weekDayInput = "Wednesday"
            approveTSBtn.setTitle("Approve Wednesday Timesheet", for: .normal)
            
        }else if selectedDayIndex == HospitalityGroupTSViewController.Thursday {
            weekDayInput = "Thursday"
            approveTSBtn.setTitle("Approve Thursday Timesheet", for: .normal)
            
        }else if selectedDayIndex == HospitalityGroupTSViewController.Friday {
            weekDayInput = "Friday"
            approveTSBtn.setTitle("Approve Friday Timesheet", for: .normal)
            
        }else if selectedDayIndex == HospitalityGroupTSViewController.Saturday {
            weekDayInput = "Saturday"
            approveTSBtn.setTitle("Approve Saturday Timesheet", for: .normal)
            
        }else if selectedDayIndex == HospitalityGroupTSViewController.Sunday {
            weekDayInput = "Sunday"
            approveTSBtn.setTitle("Approve Sunday Timesheet", for: .normal)
            
        }else if selectedDayIndex == HospitalityGroupTSViewController.Weekly {
            weekDayInput = "Weekly"
            approveTSBtn.setTitle("Approve Weekly Timesheet", for: .normal)
            
        }
        //getting the date item in dateformat
        if weekDayInput != "Weekly"
        {
        let weekdayDict = tipDayArray.object(at:indexPath.item) as! Dictionary<String,String>
        print(tipDayArray)
        weekdayDateFormat = weekdayDict["date"] ?? ""
        }
        
        let days = self.GetDayData()
        selectAllBtn.isSelected = false
        let DivisionId =  UserDefaults.standard.integer(forKey: "DivisionId")
        
        if days.count == 0{
            saveBtn.isHidden = true
            selectAllBtn.isHidden = true
            approveTSBtn.isHidden = true
            self.getGroupTimeSheetData()
            
            generateInvoiceBtn.isEnabled = false
            //8CC19D
            generateInvoiceBtn.backgroundColor = UIColor.lightGray
            
        }else{
            self.scrolltableViewToTheTop()
            generateInvoiceBtn.backgroundColor = UIColor(hexString:"#5CB85C")//true
            generateInvoiceBtn.isEnabled = true
            if  selectedDayIndex == HospitalityGroupTSViewController.Weekly{
                selectAllBtn.isHidden = true
                saveBtn.isHidden = true
                
            }else{
                selectAllBtn.isHidden = false
                //                saveBtn.isHidden = false
                if DivisionId == Logistics_Division_ID{
                    saveBtn.isHidden = false
                }else{
                    saveBtn.isHidden = !ShowBottomSave
                }
            }
            noDataView.isHidden = true
            approveTSBtn.isHidden = false
            
        }
        if  ContactIsApproverYesNo == false{
            approveTSBtn.isHidden = true
            selectAllBtn.isHidden = true
            saveBtn.isHidden = true
        }
        
        DayDateColView.reloadData()
        tsTableView.reloadData()
        //        tsTableView.setContentOffset(.zero, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dCellIdentifier", for: indexPath) as! HospitalityGroupTSCollectionViewCell
        if selectedDayIndex == indexPath.row {
            cell.backgroundColor = borderColor
            cell.lblDay.textColor = UIColor.black
        }else{
            cell.backgroundColor = UIColor.clear
            cell.lblDay.textColor = UIColor.blue
        }
        let dayDict = weekDayArray[indexPath.row] as! NSDictionary
        cell.lblDay.text = String(format:"%@(%@)\n%@",(dayDict["day"] as? String)!,(dayDict["count"] as? String)!,(dayDict["date"] as? String)!)
        return cell
    }
}
extension HospitalityGroupTSViewController: UITableViewDelegate,UITableViewDataSource{
    
    //MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == Legend_Tbl_Tag{
            return colorLegendArray.count
        }else if tableView.tag == Error_Tbl_Tag{
            return FailureMessageArray.count
        }else if tableView.tag == Position_Type_Tbl_Tag{
            return PositionArray.count
        }
        return self.GetDayData().count
        
    }
    /*
     {
     "StatusMessage": "Check ProcessStatus List for more details ",
     "MessageStatus": "0",
     "Message": "Failure",
     "ErrModel": null,
     "ProcessStatus": [
     {
     "ProcessMessage": " Time conflicts for Work Date: 07/20/2018 Start Time: 08:00 AM and End Time: 08:00 PM",
     "TimeID": 1056877
     },
     {
     "ProcessMessage": "Note: Total hours zero will not be processed ",
     "TimeID": 0
     },
     {
     "ProcessMessage": " Time conflicts for Work Date: 07/20/2018 Start Time: 08:00 AM and End Time: 04:00 PM",
     "TimeID": 1056878
     }
     ]
     }
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == Error_Tbl_Tag || tableView.tag == Legend_Tbl_Tag ||  tableView.tag == Position_Type_Tbl_Tag{
            let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell") ?? UITableViewCell(style: .default, reuseIdentifier: "timeCell")
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.numberOfLines = 0
            
            cell.imageView?.image = nil
            if  tableView.tag == Legend_Tbl_Tag{
                let colorDict = colorLegendArray[indexPath.row] as! NSDictionary
                let text = colorDict["Text"] as? String
                let bgColor = colorDict["Color"] as? String
                
                cell.backgroundColor = UIColor(hexString:bgColor!)
                cell.textLabel?.textColor = UIColor.black
                cell.textLabel?.textAlignment = .center
                
                
                cell.textLabel?.text = text?.replace(target: "<br/>", withString: "\n")
                
            }else if  tableView.tag == Position_Type_Tbl_Tag{
                let  pos = PositionArray[indexPath.row] as! PositionType
                let  posObj:PositionType = pos as PositionType
                
                cell.textLabel?.textColor = UIColor.black
                cell.textLabel?.textAlignment = .left
                
                cell.textLabel?.text = posObj.PositionName
                if posObj.isSelected == "1"{
                    cell.accessoryType = .checkmark
                }else{
                    cell.accessoryType = .none
                }
            }else{
                cell.textLabel?.textAlignment = .left
                let colorDict = FailureMessageArray[indexPath.row] as! NSDictionary
                let text = colorDict["Text"] as? String
                let status = colorDict["Status"] as? Int
                if status == 0{
                    cell.backgroundColor = UIColor(hexString:danger_background_Color)
                    cell.textLabel?.textColor = UIColor(hexString:danger_Color)
                }else if status == 1{
                    cell.backgroundColor = UIColor(hexString:success_background_Color)
                    cell.textLabel?.textColor = UIColor(hexString:success_Color)
                    
                }
                cell.textLabel?.text = text
            }
            return cell
        }
        
        if selectedDayIndex == HospitalityGroupTSViewController.Weekly{
            return self.weeklyGroupTSCell(indexPath: indexPath)
        }
        
        let DivisionId =  UserDefaults.standard.integer(forKey: "DivisionId")
        if DivisionId == Logistics_Division_ID{
            return self.LogisticsWeekDayGroupTSCell(indexPath: indexPath)
            
        }else{
            return self.HospitalityWeekDayGroupTSCell(indexPath: indexPath)
        }
        
        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == Legend_Tbl_Tag{
            let colorDict = colorLegendArray[indexPath.row] as! NSDictionary
            let bgColor = colorDict["Color"] as? String
            if bgColor?.count == 0{
                return 115
                
            }
            return 40
        }else if tableView.tag == Error_Tbl_Tag{
            let dict = FailureMessageArray[indexPath.row] as! NSDictionary
            let text = dict["Text"] as? String
            
            let height =  (text?.heightWithConstrainedWidth(width: 255, font: UIFont.boldSystemFont(ofSize: CGFloat(15))))! + CGFloat(20) //self.sizeOfString(string: message!, constrainedToHeight: Double.greatestFiniteMagnitude).height + 10
            return max(height,70)
        }else if tableView.tag == Position_Type_Tbl_Tag{
            return 40
        }
        let DivisionId =  UserDefaults.standard.integer(forKey: "DivisionId")
        let screenWidth = UIScreen.main.bounds.size.width
        let days = self.GetDayData()
        if days.count == 0{}else{
            if selectedDayIndex == HospitalityGroupTSViewController.Weekly{
                return 280
            }
            //            if screenWidth > 375{
            //                if DivisionId == Logistics_Division_ID{
            //                    return 270
            //                }
            //                return 222
            //            }
            //check if approved or not
            if DivisionId == Logistics_Division_ID{
                if days.count == 0{}else{
                    let  emp = days[(indexPath.row)] as! HosGroupTS
                    let  empObj:HosGroupTS = emp as HosGroupTS
                    if empObj.RecCode == "S" || empObj.RecCode == "C" {
                        //show both remove and save
                        return 295
                    }else if empObj.RecCode == "P"{
                        //Show  only save
                        if screenWidth > 375{
                            return 255
                        }
                        return 295
                    }else{
                        //hide both remove and save
                        if screenWidth > 375{
                            return 255
                        }
                        return 265
                    }
                }
                return 295
            }else{
                if days.count == 0{}else{
                    let  emp = days[(indexPath.row)] as! HosGroupTS
                    let  empObj:HosGroupTS = emp as HosGroupTS
                    if empObj.EvalVisible == true{//not approved
                        return 255
                    }
                }
                return 220
            }
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if tableView.tag == Position_Type_Tbl_Tag{
            
            let obj = PositionArray[indexPath.row]
            
            let  o:PositionType = obj as! PositionType
            
            for obj in PositionArray{
                let posObj:PositionType = obj as! PositionType
                posObj.isSelected = "0"
            }
            let days = self.GetDayData()
            if days.count == 0{}else{
                let  emp = days[firstResponderIndexPath] as! HosGroupTS
                let  empObj:HosGroupTS = emp as HosGroupTS
                empObj.selectedPosTypeID = o.PositionId
                empObj.selectedPosTypeName = o.PositionName
                if o.PositionId == empObj.selectedPosTypeID
                {
                    o.isSelected = "1"
                    PositionArray.replaceObject(at: (indexPath.row), with: o)
                }
                days.replaceObject(at: (firstResponderIndexPath), with: empObj)
            }
            tableView.reloadData()
            tsTableView.reloadData()
        }
    }
    
    
}




extension HospitalityGroupTSViewController:DataChagedDelegate
{
    
    
    func userSubmittedSuccessFully(submitted: Bool, selectedDayIndex: Int, weekEnd: String,weekDayInput: String) {

        self.isSubmitted = submitted
        self.selectedDayIndex = selectedDayIndex
        weekendDate = weekEnd
        self.weekDayInput = weekDayInput
        self.getHospitalityGroupTimeSheetData()
        scrollDaysCollectionViewToIndex()
    }
    

    func userChangedInformation(changed: Bool, tempData:NSMutableDictionary, tempOldWeek: String,tempDayArray:NSMutableArray,selectedDayIndex:Int,weekDayInput:String ,weekdayDateFormat:String) {
        
        if isSubmitted == false
        {
        if changed
        {
            
            self.weekdayDateFormat = weekdayDateFormat
            self.weekDayInput = weekDayInput
            self.selectedDayIndex = selectedDayIndex
            daysDict = tempData
            self.updateHospitalityData(dataA:tempDayArray,OldPendingWeekEnds:tempOldWeek)
            scrollDaysCollectionViewToIndex()
        }
        }
    }
}
