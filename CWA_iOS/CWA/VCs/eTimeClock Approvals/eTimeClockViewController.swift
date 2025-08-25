//
//  eTimeClockViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 31/10/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import FSCalendar
import SwiftyJSON

class eTimeClockViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance,UITextFieldDelegate {
    
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!
    let VIEW_DETAILS_SEGMENT_TAG = 0
    let VIEW_SUMMARY_SEGMENT_TAG = 1
    let ToolTip_View_Tag = 1008
    let Generate_Invoice_Command = "Generate Invoice"
    let View_Detail_Command = ""
    let View_Summary_Command = "View Summary"
    @IBOutlet weak var TableHeaderView: UIView!
    @IBOutlet weak var HeaderTitleLbl: UILabel!

    let Data_Approved_Status = Double(1)
    
    let View_Detail_Cell_Height = 175
    var Reason =  ""
    var LoginDate = ""
    var LunchInDate = ""
    var LunchOutDate = ""
    var LogOutDate = ""
    var LoginTime = ""
    var LunchInTime = ""
    var LunchOutTime = ""
    var LogOutTime = ""
    
    var menuTitle = ""
    //Array
    var isFromSafety = false
    var viewDetailArray = NSMutableArray()
    var viewSummaryArray = NSMutableArray()
    var GenerateInvoiceArray = NSMutableArray()
    
    var colorLegendArray = NSMutableArray()
    var empArray = NSMutableArray()
    var UpdatedTimeArray = NSMutableArray()
    
    let Legend_Tbl_Tag = 1001
    let EmpTimeHr_Tbl_Tag = 1002
    let Main_Generate_Invoice_Tbl_Tag = 1003
    let Main_Tbl_Tag = 1004
    
    @IBOutlet var dataTableView: UITableView!
    @IBOutlet var EmpTimeHrTableView: UITableView!
    
    @IBOutlet var weekendTextField: UITextField!
    @IBOutlet var weekendTFBGView: UIView!
    @IBOutlet var infoBtn: UIButton!
    @IBOutlet var checkAllBtn: UIButton!
    @IBOutlet var noDataView: UIView!
    @IBOutlet var footerView: UIView!
    @IBOutlet var EmpTimeHrView: UIView!
    @IBOutlet var EmpTimeHrTitleView: UIView!
    @IBOutlet var EmpTimeHrBGView: UIView!

    @IBOutlet var lblNoData: UILabel!
    @IBOutlet var approveBtn: ShadowButton!
    @IBOutlet var GenerateInvoiceBtn: ShadowButton!
    @IBOutlet var EnterNewDay: ShadowButton!
    @IBOutlet var GenerateInvoiceForAllBtn: ShadowButton!
    
    @IBOutlet var viewSegment: UISegmentedControl!
    @IBOutlet weak var viewSegmentHeightConstraint: NSLayoutConstraint!
    
    var customCalendarView = CalendarView()
    var selectedeTimeClockObjs = NSMutableArray()
    var approvedDataType  =  ""
var isApproveDataServerCall = false
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    var resultDate = String()
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        return formatter
    }()
    
    @objc override func appWillEnterForeground(){
        print("appWillEnterForeground Division")
        
        self.GetDataServerCall(command:"")    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titlelbl.text = "eTimeClock Manager Approval Screen"
        self.GetDataServerCall(command:"")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCalendarView()
        self.updateUI()
        dataTableView.tag = Main_Tbl_Tag
        TableHeaderView.backgroundColor = UIColor(hexString:danger_background_Color)
        HeaderTitleLbl.textColor = UIColor(hexString:danger_Color)
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(eTimeClockViewController.panGesture))
        EmpTimeHrBGView.addGestureRecognizer(gesture)

        // Do any additional setup after loading the view.
    }
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let fullView: CGFloat = 100
        let partialView: CGFloat = UIScreen.main.bounds.height - 200

        let y = self.view.frame.minY
        if (y + translation.y >= fullView) && (y + translation.y <= partialView) {
//            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
//            recognizer.setTranslation(CGPoint.zero, in: self.view)
            print("dqsa")
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.viewTopConstraint.constant = UIScreen.main.bounds.size.height
                    self.view.layoutIfNeeded()
                  } else {
                     self.viewTopConstraint.constant = fullView
                    self.view.layoutIfNeeded()

                 }
                
            }, completion: { [weak self] _ in
                print("completion")

                if  velocity.y >= 0 {
                    self!.EmpTimeHrView.removeFromSuperview()
                }
             })
        }
    }
    //MARK: UIButton Action
    @IBAction func EmpTimeHrCloseBtnTapped(_ sender: UIButton){
        self.removeEmpTimeHrPopupView()
    }
    
    @IBAction func editBtnTappedFromCell(sender: UIButton){
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.dataTableView)
        let indexPath = self.dataTableView.indexPathForRow(at: buttonPosition)
        
        if viewSegment.selectedSegmentIndex == VIEW_DETAILS_SEGMENT_TAG{
            self.pushToEnterUpdateTimeClockPage(isForEnterTimeClock: false,eTimeClockObj:viewDetailArray[(indexPath?.row)!] as! eTimeClock)
        }else{
            self.pushToEnterUpdateTimeClockPage(isForEnterTimeClock: false,eTimeClockObj:viewSummaryArray[(indexPath?.row)!] as! eTimeClock)
        }
    }
    @IBAction func DateBtnTappedFromCell(sender: UIButton){
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.dataTableView)
        let indexPath = self.dataTableView.indexPathForRow(at: buttonPosition)
        let  tsObj:eTimeClock = viewDetailArray[indexPath?.row ?? 0] as! eTimeClock
        
        self.GetEmpHoursDataServerCall(TimeId: tsObj.TimeId!)
    }
    @IBAction func ApproveBtnTappedFromCell(sender: UIButton){
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.dataTableView)
        let indexPath = self.dataTableView.indexPathForRow(at: buttonPosition)
        let  tsObj:eTimeClock = viewDetailArray[indexPath?.row ?? 0] as! eTimeClock
        tsObj.isSelected = "1"
        
        if viewSegment.selectedSegmentIndex == VIEW_DETAILS_SEGMENT_TAG{
            
            self.viewDetailArray.replaceObject(at: (indexPath?.row)!, with: tsObj)
//            self.ApproveDataServerCall(Type: "Details",dArray: viewDetailArray )
            selectedeTimeClockObjs = viewDetailArray
            approvedDataType = "Details"

        }else{
            self.viewSummaryArray.replaceObject(at: (indexPath?.row)!, with: tsObj)
//            self.ApproveDataServerCall(Type: "Summary",dArray: viewSummaryArray)
            selectedeTimeClockObjs = viewSummaryArray
approvedDataType = "Summary"
        }
        isApproveDataServerCall = true
        self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Are you sure to approve the eTimeClock", okBtnTitle: "Approve", cancelBtnTitle: "Cancel", type: info_Text, isAttributed: false)
        self.dataTableView.reloadData()
    }
    @IBAction func NoteBtnTappedFromCell(sender: UIButton){
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.dataTableView)
        let indexPath = self.dataTableView.indexPathForRow(at: buttonPosition)
        let  tsObj:eTimeClock = viewDetailArray[indexPath?.row ?? 0] as! eTimeClock
        
        
        //show popup with text
        let comments = tsObj.Comments
        if comments?.count == 0{
            self.navigationController?.view.makeToast("No note found", duration: 1.5, position: .bottom, title: "", image: nil)
        }else{
            for i in viewDetailArray{
                let obj:eTimeClock =  i as! eTimeClock
                obj.isShowNote = "0"
            }
            
            if tsObj.isShowNote == "0"{
               tsObj.isShowNote = "1"
            }else{
               tsObj.isShowNote = "0"
            }
            viewDetailArray.replaceObject(at: (indexPath?.row)!, with: tsObj)
            self.dataTableView.reloadData()
        }
        
    }
    
    @IBAction func detailSendBtnTappedFromCell(sender: UIButton){
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.dataTableView)
        let indexPath = self.dataTableView.indexPathForRow(at: buttonPosition)
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
        
        let  tsObj:eTimeClock =  viewDetailArray[(indexPath?.row)!] as! eTimeClock
        if sender.isSelected == true{
            tsObj.isSelected = "1"
        }else{
            tsObj.isSelected = "0"
        }
        viewDetailArray.replaceObject(at: (indexPath?.row)!, with: tsObj)
        self.dataTableView.reloadData()
    }
    
    @IBAction func generateInvoiceBtnTappedFromCell(sender: UIButton){
        
        
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.dataTableView)
        let indexPath = self.dataTableView.indexPathForRow(at: buttonPosition)
        let  tsObj:eTimeClock = GenerateInvoiceArray[indexPath?.row ?? 0] as! eTimeClock
        tsObj.isSelected = "1"
        self.GenerateInvoiceServerCall()
        self.dataTableView.reloadData()
        
    }
    @IBAction func GESendBtnTappedFromCell(sender: UIButton){
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.dataTableView)
        let indexPath = self.dataTableView.indexPathForRow(at: buttonPosition)
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
        
        let  tsObj:eTimeClock =  GenerateInvoiceArray[(indexPath?.row)!] as! eTimeClock
        if sender.isSelected == true{
            tsObj.isSelected = "1"
        }else{
            tsObj.isSelected = "0"
        }
        GenerateInvoiceArray.replaceObject(at: (indexPath?.row)!, with: tsObj)
        self.dataTableView.reloadData()
    }
    @IBAction func summarySendBtnTappedFromCell(sender: UIButton){
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.dataTableView)
        let indexPath = self.dataTableView.indexPathForRow(at: buttonPosition)
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
        
        let  tsObj:eTimeClock =  viewSummaryArray[(indexPath?.row)!] as! eTimeClock
        if sender.isSelected == true{
            tsObj.isSelected = "1"
        }else{
            tsObj.isSelected = "0"
        }
        viewSummaryArray.replaceObject(at: (indexPath?.row)!, with: tsObj)
        self.dataTableView.reloadData()
    }
    @IBAction func CheckAllBtnTapped(_ sender: UIButton)
    {
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
        var tempArray = NSMutableArray()
        
        if dataTableView.tag == Main_Generate_Invoice_Tbl_Tag{
            tempArray = GenerateInvoiceArray
        }else if dataTableView.tag == Main_Tbl_Tag{
            if viewSegment.selectedSegmentIndex == VIEW_DETAILS_SEGMENT_TAG{
                tempArray = viewDetailArray
            }else{
                tempArray = viewSummaryArray
            }
        }
        let dArray = NSMutableArray()
        for dict in tempArray{
            let  tsObj:eTimeClock = dict as! eTimeClock
            if sender.isSelected == true{
                tsObj.isSelected = "1"
            }else{
                tsObj.isSelected = "0"
            }
            dArray.add(tsObj)
        }
        if dataTableView.tag == Main_Generate_Invoice_Tbl_Tag{
            GenerateInvoiceArray = dArray
        }else if dataTableView.tag == Main_Tbl_Tag{
            if viewSegment.selectedSegmentIndex == VIEW_DETAILS_SEGMENT_TAG{
                viewDetailArray = dArray
            }else{
                viewSummaryArray = dArray
            }
        }
        
        dataTableView.reloadData()
    }
    @IBAction func infoBtnTapped(_ sender: UIButton)
    {
        self.ShowTablePopup(Message:"")
        
    }
    @IBAction func ApproveBtnTapped(_ sender: UIButton)
    {
        var dArray = NSMutableArray()
        if dataTableView.tag == Main_Tbl_Tag{
            if viewSegment.selectedSegmentIndex == VIEW_DETAILS_SEGMENT_TAG{
                dArray = viewDetailArray
            }else{
                dArray = viewSummaryArray
            }
        }
        let tempArray = NSMutableArray()
        
        for dict in dArray{
            let  tsObj:eTimeClock = dict as! eTimeClock
            if tsObj.isSelected == "1"{
                tempArray.add(tsObj)
            } 
        }
        if tempArray.count == 0{
            self.navigationController?.view.makeToast("Please select record to approve", duration: 1.5, position: .bottom, title: "", image: nil)
            
        }else{
            if viewSegment.selectedSegmentIndex == VIEW_DETAILS_SEGMENT_TAG{
                
//                self.ApproveDataServerCall(Type: "Details",dArray: tempArray )
                approvedDataType = "Details"
                selectedeTimeClockObjs = tempArray
                isApproveDataServerCall = true
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Are you sure to approve the eTimeClock?", okBtnTitle: "Approve", cancelBtnTitle: "Cancel", type: info_Text, isAttributed: false)

            }else{
//                self.ApproveDataServerCall(Type: "Summary",dArray: tempArray)
                approvedDataType = "Summary"
                selectedeTimeClockObjs = tempArray
                isApproveDataServerCall = true
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Are you sure to approve the eTimeClock?", okBtnTitle: "Approve", cancelBtnTitle: "Cancel", type: info_Text, isAttributed: false)

            }
            
            
            
        }
    }
    @IBAction func EnterNewEtimeClockBtnTapped(_ sender: UIButton)
    {
        self.pushToEnterUpdateTimeClockPage(isForEnterTimeClock: true,eTimeClockObj: eTimeClock.init(TimeId: "0", Name: "", Comments: "", Edit: 0, Date: "", TotalHours: "", LunchInTime: "", LunchOutTime: "", LogInTime: "", LogOutTime: "", break_minutes: "", NewId: 0, Sent: 0, Reason: "", changeFound: 0, Color: "", LunchInDate: "", LunchOutDate: "", LogInDate: "", LogOutDate: "",CandId: "", isSelected: "",isShowNote:"0"))
        
    }
    @IBAction func GenerateInvoiceBtnTapped(_ sender: UIButton)
    {
        dataTableView.tag = Main_Generate_Invoice_Tbl_Tag
        GenerateInvoiceForAllBtn.isHidden = false
        self.approveBtn.isHidden = true
        self.GenerateInvoiceBtn.isHidden = true
        
        self.GetDataServerCall(command:Generate_Invoice_Command)
        
    }
    @IBAction func GenerateInvoiceForAllBtnTapped(_ sender: UIButton)
    {
        
        self.approveBtn.isHidden = true
        self.GenerateInvoiceBtn.isHidden = true
        
        self.GenerateInvoiceServerCall()
        
    }
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl)
    {
        dataTableView.tag = Main_Tbl_Tag
        GenerateInvoiceForAllBtn.isHidden = true
        self.approveBtn.isHidden = false
        self.GenerateInvoiceBtn.isHidden = false
        
        self.checkAllBtn.isSelected = false
        self.GetDataServerCall(command:"")
        dataTableView.reloadData()
    }
    @IBAction override func okButtonTapped(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        if isApproveDataServerCall == true{
            
            self.ApproveDataServerCall(Type: self.approvedDataType, dArray: selectedeTimeClockObjs)
        }
    }
    func clearAllArray(){
        GenerateInvoiceArray.removeAllObjects()
        viewDetailArray.removeAllObjects()
        viewSummaryArray.removeAllObjects()
    }
    //MARK: UITABLEVIEW METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  tableView.tag == Legend_Tbl_Tag{
            return colorLegendArray.count
        }else if tableView.tag == EmpTimeHr_Tbl_Tag {
            return UpdatedTimeArray.count
        }
        else if tableView.tag == Main_Generate_Invoice_Tbl_Tag {
            return GenerateInvoiceArray.count
        }
        if viewSegment.selectedSegmentIndex == VIEW_DETAILS_SEGMENT_TAG{
            
            return viewDetailArray.count
        }
        return viewSummaryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let divColorCode = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
        if  tableView.tag == Legend_Tbl_Tag{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell") ?? UITableViewCell(style: .default, reuseIdentifier: "timeCell")
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.numberOfLines = 0
            
            let colorDict = colorLegendArray[indexPath.row] as! NSDictionary
            let text = colorDict["Text"] as? String
            let bgColor = colorDict["Color"] as? String
            
            cell.backgroundColor = UIColor(hexString:bgColor!)
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.textAlignment = .center
            
            cell.textLabel?.text = text
            
            return cell
            
        }else if tableView.tag == EmpTimeHr_Tbl_Tag {
            let cell:eTimeClockEmpTimeHrTableViewCell = tableView.dequeueReusableCell(withIdentifier: "eTimeClockEmpTimeHrTableViewCellIdentifier") as! eTimeClockEmpTimeHrTableViewCell
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            let   s = UpdatedTimeArray[indexPath.row] as! eTimeClockEmpTotalHour
            
            cell.lblDate.text = "Date                    "+s.his_Wdate!
            cell.lblLoginStart.text =   "Login Start        "+s.his_Login!
            cell.lblLogoutFinish.text = "Logout Finish    "+s.his_LogOut!
            cell.lblLunchOut.text =     "Lunch Out         "+s.his_LunchOut!
            cell.lblLunchReturn.text =  "Lunch Return    "+s.his_LunchIn!
            cell.lblChangedBy.text =    "Changed By       "+s.his_Name!
            
            cell.lblDate.halfTextMakeToBold(fullText: cell.lblDate.text!, changeText: "Date", textColor: divColorCode)
            cell.lblLoginStart.halfTextMakeToBold(fullText: cell.lblLoginStart.text!, changeText: "Login Start", textColor: divColorCode)
            cell.lblLogoutFinish.halfTextMakeToBold(fullText: cell.lblLogoutFinish.text!, changeText: "Logout Finish", textColor: divColorCode)
            cell.lblLunchOut.halfTextMakeToBold(fullText: cell.lblLunchOut.text!, changeText: "Lunch Out", textColor: divColorCode)
            cell.lblLunchReturn.halfTextMakeToBold(fullText: cell.lblLunchReturn.text!, changeText: "Lunch Return", textColor: divColorCode)
            cell.lblChangedBy.halfTextMakeToBold(fullText: cell.lblChangedBy.text!, changeText: "Changed By", textColor: divColorCode)
            
            return cell
        }else if tableView.tag == Main_Generate_Invoice_Tbl_Tag{
            
            return self.generateInvoiceCellForIndexPath(indexPath: indexPath as NSIndexPath)
        }
        
        if viewSegment.selectedSegmentIndex == VIEW_DETAILS_SEGMENT_TAG {
            let cell:eTimeClockTableViewCell = tableView.dequeueReusableCell(withIdentifier: "eTimeClockDetailsCellIdentifier") as! eTimeClockTableViewCell
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            
            cell.NoteBtn.removeTarget(self, action: #selector(NoteBtnTappedFromCell), for: .touchUpInside)
            cell.NoteBtn.addTarget(self, action: #selector(NoteBtnTappedFromCell), for: .touchUpInside)
            
            let   s = viewDetailArray[indexPath.row] as! eTimeClock
            cell.lblEmpName.text = s.Name
            //            cell.lblDate.text =  "Date"
            cell.lblTime.text = "Time"+"  "+s.LogInTime!+" - "+s.LogOutTime!//String(format:"Time  %@ - %@",s.LogInTime ?? "",s.LogOutTime ?? "")
            cell.lblBreak.text = "Break  "+s.break_minutes!
            cell.lblHours.text = "Hours  "+s.TotalHours!
            
            //            cell.lblDate.halfTextMakeToBold(fullText: cell.lblDate.text!, changeText: "Date", textColor: divColorCode)
            cell.lblTime.halfTextMakeToBold(fullText: cell.lblTime.text!, changeText: "Time", textColor: divColorCode)
            cell.lblBreak.halfTextMakeToBold(fullText: cell.lblBreak.text!, changeText: "Break", textColor: divColorCode)
            cell.lblHours.halfTextMakeToBold(fullText: cell.lblHours.text!, changeText: "Hours", textColor: divColorCode)
            if  s.isShowNote == "0"{
              cell.tipView.isHidden = true
            }else{
              cell.tipView.isHidden = false
            }
             cell.tipView.lblText.text = s.Comments
            if s.Color?.count ?? 0 > 0 {
                cell.cellBGView.backgroundColor = UIColor(hexString:s.Color!)
            }
            cell.EditBtn.isHidden = false
            cell.ApproveBtn.isHidden = false
            
            if s.Sent == Data_Approved_Status{
                cell.EditBtn.isHidden = true
                cell.ApproveBtn.isHidden = true
                let image = UIImage.init(named: "check_box")
                cell.SendBtn.setImage(image?.maskWithColor(color: UIColor.lightGray), for: .normal)
            }else{
                if s.isSelected == "1"{
                    let image = UIImage.init(named: "check_box_filled")
                    cell.SendBtn.setImage(image?.maskWithColor(color: UIColor.black), for: .normal)
                    
                }else{
                    let image = UIImage.init(named: "check_box")
                    cell.SendBtn.setImage(image?.maskWithColor(color: UIColor.black), for: .normal)
                    
                }
                cell.SendBtn.removeTarget(self, action: #selector(detailSendBtnTappedFromCell), for: .touchUpInside)
                cell.SendBtn.addTarget(self, action: #selector(detailSendBtnTappedFromCell), for: .touchUpInside)
                
                cell.EditBtn.removeTarget(self, action: #selector(editBtnTappedFromCell), for: .touchUpInside)
                cell.EditBtn.addTarget(self, action: #selector(editBtnTappedFromCell), for: .touchUpInside)
                
                cell.ApproveBtn.removeTarget(self, action: #selector(ApproveBtnTappedFromCell), for: .touchUpInside)
                cell.ApproveBtn.addTarget(self, action: #selector(ApproveBtnTappedFromCell), for: .touchUpInside)
                
            }
            let DateValue = String(format:"Date   %@",s.Date ?? "")
            
            let strNumber: NSString = DateValue as NSString
            let range = (strNumber).range(of: s.Date!)
            let range12 = (strNumber).range(of: "Date")
            let attribute = NSMutableAttributedString.init(string: DateValue)
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: divColorCode , range: range12)
            
            
            if s.changeFound == 0 {
                attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: range)
                //                attribute.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range)
                attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: CGFloat(14)) , range: range)
                attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: CGFloat(14)) , range: range12)
                
                cell.DateBtn.setAttributedTitle(attribute, for: .normal)
                //                 cell.DateBtn.setTitle(DateValue, for: .normal)
                
            }else{
                attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue , range: range)
                attribute.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range)
                attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: CGFloat(14)) , range: range)
                attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: CGFloat(14)) , range: range12)
                
                cell.DateBtn.setAttributedTitle(attribute, for: .normal)
                cell.DateBtn.removeTarget(self, action: #selector(DateBtnTappedFromCell), for: .touchUpInside)
                cell.DateBtn.addTarget(self, action: #selector(DateBtnTappedFromCell), for: .touchUpInside)
            }
            return cell
        }
        
        let cell:eTimeClockTableViewCell = tableView.dequeueReusableCell(withIdentifier: "eTimeClockSummaryCellIdentifier") as! eTimeClockTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.SendBtn.removeTarget(self, action: #selector(summarySendBtnTappedFromCell), for: .touchUpInside)
        cell.SendBtn.addTarget(self, action: #selector(summarySendBtnTappedFromCell), for: .touchUpInside)
        let   s = viewSummaryArray[indexPath.row] as! eTimeClock
        
        cell.lblEmpName.text = s.Name
        cell.lblDay.text = "Days  "+s.Days!//String(format:"Days  %@",s.Days ?? "")
        cell.lblWeekHours.text = "Weekly hours "+s.Weekhours!//String(format:"Weekly hours %@",s.Weekhours!)
        
        cell.lblDay.halfTextMakeToBold(fullText: cell.lblDay.text!, changeText: "Days", textColor: divColorCode)
        cell.lblWeekHours.halfTextMakeToBold(fullText: cell.lblWeekHours.text!, changeText: "Weekly hours", textColor: divColorCode)
        
        if s.Color?.count ?? 0 > 0 {
            cell.cellBGView.backgroundColor = UIColor(hexString:s.Color!)
        }
        if s.isSend == Data_Approved_Status
        {
            let image = UIImage.init(named: "check_box")
            cell.SendBtn.setImage(image?.maskWithColor(color: UIColor.lightGray), for: .normal)
            
        }else{
 
            if s.isSelected == "1"{
                let image = UIImage.init(named: "check_box_filled")
                cell.SendBtn.setImage(image?.maskWithColor(color: UIColor.black), for: .normal)
                
            }else{
                let image = UIImage.init(named: "check_box")
                cell.SendBtn.setImage(image?.maskWithColor(color: UIColor.black), for: .normal)
                
            }
            
        }
        return cell
        
    }
    func generateInvoiceCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell{
        
        let divColorCode = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
        let cell:eTimeClockTableViewCell = dataTableView.dequeueReusableCell(withIdentifier: "generateInvoiceCellIdentifier") as! eTimeClockTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.SendBtn.removeTarget(self, action: #selector(GESendBtnTappedFromCell), for: .touchUpInside)
        cell.SendBtn.addTarget(self, action: #selector(GESendBtnTappedFromCell), for: .touchUpInside)

        cell.generateInvoiceBtn.removeTarget(self, action: #selector(generateInvoiceBtnTappedFromCell), for: .touchUpInside)
        cell.generateInvoiceBtn.addTarget(self, action: #selector(generateInvoiceBtnTappedFromCell), for: .touchUpInside)

        let   s = GenerateInvoiceArray[indexPath.row] as! eTimeClock
        
        cell.lblEmpName.text = s.Name
        cell.lblDay.text = "Work Date  "+s.Date!//String(format:"Work Date  %@",s.Date ?? "")
        cell.lblWeekHours.text = "Hours "+s.TotalHours!//String(format:"Hours %@",s.TotalHours!)
        
        cell.lblDay.halfTextMakeToBold(fullText: cell.lblDay.text!, changeText: "Work Date", textColor: divColorCode)
        cell.lblWeekHours.halfTextMakeToBold(fullText: cell.lblWeekHours.text!, changeText: "Hours", textColor: divColorCode)
        if s.RowColor?.count ?? 0 > 0 {
            cell.cellBGView.backgroundColor = UIColor(hexString:s.RowColor!)
        }
        
        if s.isSelected == "1"
        {
            cell.SendBtn.isSelected = true
        }else{
            cell.SendBtn.isSelected = false
        }
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  tableView.tag == Legend_Tbl_Tag{
            return 38
        } else if tableView.tag == EmpTimeHr_Tbl_Tag {
            return 165
        }else if tableView.tag == Main_Generate_Invoice_Tbl_Tag {
            return 155
        }
        if viewSegment.selectedSegmentIndex == VIEW_DETAILS_SEGMENT_TAG {
            return CGFloat(View_Detail_Cell_Height)
        }
        return 115
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
//        for tsObj in viewDetailArray {
//            var obj:eTimeClock = tsObj as! eTimeClock
//            obj.isShowNote = "0"
//        }
        
        
//        let cell = self.dataTableView.dequeueReusableCell(withIdentifier: "eTimeClockDetailsCellIdentifier") as! eTimeClockTableViewCell
//        cell.tipView.isHidden = true
        
//        self.dataTableView.reloadData()
        //        for v in sViews{
        //            if v.isDescendant(of:  eTimeClockTableViewCell){
        //                let vCell:eTimeClockTableViewCell = v as! eTimeClockTableViewCell
        //                  vCell.tipView.removeFromSuperview()
        //            }
        //        }
        //
        //        for v in sViews!{
        //            if v.tag == ToolTip_View_Tag{
        //                v.removeFromSuperview()
        //            }
        //        }
//    }
    //MARK: Calendar Methods
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int
    {
        return 0
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
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
        
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        
        let todayDate = date
        let todayString = formatter.string(from: todayDate)
        let todaysDay = self.getDayOfWeek(today: todayString)
        
        if todaysDay == "Sunday" {
            //Clear Array
            
            self.clearAllArray()
            resultDate = self.dateFormatter.string(from: date)
            weekendTextField.text = resultDate//String(format:"%@",resultDate)
            //Call API and reload Table View
            customCalendarView.removePickerViewFromSuperView()
            
//            dataTableView.tag = Main_Generate_Invoice_Tbl_Tag
//            GenerateInvoiceForAllBtn.isHidden = false
//            self.approveBtn.isHidden = true
//            self.GenerateInvoiceBtn.isHidden = true
//
            if dataTableView.tag == Main_Generate_Invoice_Tbl_Tag{
                self.GetDataServerCall(command:Generate_Invoice_Command)
            }else{
               self.GetDataServerCall(command:"")
            }
            dataTableView.reloadData()
        }else{
            self.navigationController?.view.makeToast("Please select weekend", duration: 1.5, position: .bottom, title: "", image: nil)
        }
        
        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    //MARK: Private Methods
    func setupCalendarView(){
        customCalendarView = Bundle.main.loadNibNamed("CalendarView", owner: self, options: nil)?[0] as! CalendarView
        customCalendarView.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
        customCalendarView.setupCalendar()
        customCalendarView.calendar.delegate = self
        customCalendarView.calendar.dataSource = self
        
    }
    
    func updateUI(){
        weekendTFBGView.layer.borderColor = borderColor.cgColor
        weekendTFBGView.layer.borderWidth = 1
        
        let imageView = UIImageView.init(frame: CGRect(x:0,y:0,width:30,height:30));
        let image = UIImage(named: "calendar_icon.png");
        imageView.image = image;
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        weekendTextField.rightView = imageView;
        weekendTextField.rightViewMode = UITextField.ViewMode.always
        weekendTextField.rightViewMode = .always
        
        
        viewSegment.selectedSegmentIndex = 0
        viewSegmentHeightConstraint.constant = 40
        viewSegment.layer.cornerRadius = 0
        viewSegment.layer.cornerRadius = 0
        viewSegment.layer.borderColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String).cgColor
        viewSegment.layer.borderWidth = 1
        viewSegment.layer.masksToBounds = true
        viewSegment.layoutIfNeeded()
        viewSegment.tintColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
//        footerView.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:0)
        noDataView.backgroundColor = UIColor(hexString:danger_background_Color)
        lblNoData.textColor = UIColor(hexString:danger_Color)
        EmpTimeHrTitleView.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        EmpTimeHrTableView.tableFooterView = UIView()
        
        dataTableView.tableFooterView = UIView()
        
    }
    func showEmpTimeHrPopupView(){
        DispatchQueue.main.async(execute:{() -> Void in
            self.EmpTimeHrView.frame = UIScreen.main.bounds// CGRect(x:0,y:100,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height - 200) //UIScreen.main.bounds
            let window = UIApplication.shared.keyWindow
            self.EmpTimeHrTableView.reloadData()
            window?.addSubview(self.EmpTimeHrView)
            self.viewTopConstraint.constant = UIScreen.main.bounds.size.height
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 2.8, animations:  {
                self.viewTopConstraint.constant = 50
                self.view.layoutIfNeeded()
                
            }) { (animationComplete) in
            }
        })
    }
    
    func removeEmpTimeHrPopupView(){
        
        DispatchQueue.main.async(execute: {()-> Void in
            self.EmpTimeHrView.removeFromSuperview()
        })
        
    }
    func ShowTablePopup(Message: String){
        
        let msg = "\n\n\n\n\n"
        var alrController = UIAlertController()
        alrController = UIAlertController(title: Message, message: msg, preferredStyle: UIAlertController.Style.alert)
        
        let originY = 10
        let width = 255
        let margin:CGFloat = 8.0
        
        let rect = CGRect(x: Int(margin), y: originY, width: width, height: 120)
        let tableView = UITableView(frame: rect)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tag = Legend_Tbl_Tag
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
        alrController.view.addSubview(tableView)
        
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: {(alert: UIAlertAction!) in print("OK")
            alrController.dismiss(animated: true, completion: nil)
        })
        
        alrController.addAction(cancelAction)
        self.present(alrController, animated: true, completion: {})
        
        
    }
    //MARK: Text Field Methods
    
    
    public func textFieldDidBeginEditing(_ textField: UITextField){
        weekendTextField.resignFirstResponder()
        if weekendTextField.text?.count == 0{}else{
            
            let date = self.convertDateStringToDefaultDate(dateString: weekendTextField.text ?? "", formatString: dateFormat)
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.customCalendarView.calendar.setCurrentPage(date, animated: true)
                self.customCalendarView.calendar.select(date, scrollToDate: true)
                
            })
        }
        customCalendarView.showPickerViewOnSuperView(superView: (self.navigationController?.view)!, isPortrait: self.isPortrait())
        
    }
    //MARK: Screen Orientation
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        self.customCalendarView.showPickerViewInOrientation(superView: (self.navigationController?.view)!, isPortrait: self.isPortrait())
        self.addDivisionNameOnTop()
        
    }
    
    //MARK:- GoBack
    override func goBack() {
        if isFromSafety {
            popToDasboardPageDirectly()
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    //MARK: Server Call
    
    func GetDataServerCall(command: String){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
             JustHUD.shared.showInView(view: (self.view)!)
            
            let defaults = UserDefaults.standard
            let clientID =  "\(defaults.integer(forKey: "ClientID"))"
            //String(format:"%d", defaults.integer(forKey: "ClientID"))
            
            if command == Generate_Invoice_Command{
                
                self.clearAllArray()
                
                let params :[String:String] = [ "ClientID":clientID,"command":Generate_Invoice_Command,"WeekEnd":weekendTextField.text ?? "" ]
                print(params)
                RestAPI.geteTimeClockData(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getGenerateInvoiceResponse(response:))
            }else{
                if viewSegment.selectedSegmentIndex == VIEW_DETAILS_SEGMENT_TAG{
                    self.clearAllArray()
                    let params :[String:String] = [ "ClientID":clientID,"WeekEnd":weekendTextField.text ?? "" ]
                    print(params)
                    RestAPI.geteTimeClockData(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
                }else if viewSegment.selectedSegmentIndex == VIEW_SUMMARY_SEGMENT_TAG{
                    self.clearAllArray()
                    let params :[String:String] = [ "ClientID":clientID,"command":View_Summary_Command,"WeekEnd":weekendTextField.text ?? "" ]
                    print(params)
                    RestAPI.geteTimeClockData(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
                }
            }
        }else{
            isApproveDataServerCall = false

            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    func getGenerateInvoiceResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        self.navigationController?.view.hideAllToasts()
        
        print(response)
        if response is String{
            isApproveDataServerCall = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
                HeaderTitleLbl.text = object["Note"].stringValue
                if HeaderTitleLbl.text!.count == 0{
                    HeaderTitleLbl.text = "Entries with \"Note\" indicate records have beeen modified by employees. Tap on  \"Note\" button to see reason why adjustments are made."
                    
                }
                 let dArray = object["ETimeClockInvioceList"].array
                self.clearAllArray()
                for dict in dArray! {
                    
                    let eTimeObj = eTimeClock.init(TimeId: dict["TimeId"].stringValue,
                                                   Name: dict["Name"].stringValue,
                                                   Date: dict["Date"].stringValue,
                                                   TotalHours: dict["TotalHours"].stringValue,
                                                   CandId:dict["CandId"].stringValue,
                                                   OrderId:dict["OrderId"].stringValue,
                                                   ContactId:dict["ContactId"].stringValue,
                                                   ClientId:dict["ClientId"].stringValue,
                                                   isSelected:"0",
                                                   RowColor:dict["RowColor"].stringValue)
                    GenerateInvoiceArray .add(eTimeObj)
                }
                dataTableView.reloadData()
                if GenerateInvoiceArray.count == 0{
                    var message = object["Message"].stringValue
                    if message.count == 0 {
                        message = Error_Message
                    }
                    footerView.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:120)
                    lblNoData.text = message
                    dataTableView.tableFooterView = footerView
                }else{
                    dataTableView.tableFooterView = UIView()
                }
            }else{
                
                var message = object["Message"].stringValue
                if message.count == 0 {
                    message = Error_Message
                }
                footerView.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:120)
                lblNoData.text = message
                dataTableView.tableFooterView = footerView

            }
        }
    }
    func getResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        self.navigationController?.view.hideAllToasts()
        
        print(response)
        if response is String{
            isApproveDataServerCall = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
                
                HeaderTitleLbl.text = object["Note"].stringValue
                if HeaderTitleLbl.text!.count == 0{
                   HeaderTitleLbl.text = "Entries with \"Note\" indicate records have beeen modified by employees. Tap on  \"Note\" button to see reason why adjustments are made."

                }
                if viewSegment.selectedSegmentIndex == VIEW_DETAILS_SEGMENT_TAG{
                    self.AssigningValuesFromServer(object: object)
                    let dArray = object["ETimeClockApprovalList"].array
                    self.clearAllArray()
                    for dict in dArray! {
                        var coments = dict["Comments"].stringValue
                        if coments.contains("\r") || coments.contains("\n") || coments.contains("\t"){
//                            coments  = String(coments.filter { !" \n\t\r".contains($0) })
                            coments = coments.replace(target: "\r", withString: " ")
                        }
                         let eTimeObj = eTimeClock.init(TimeId: dict["TimeId"].stringValue,
                                                       Name: dict["Name"].stringValue,
                                                       Comments: coments,
                                                       Edit: dict["Edit"].doubleValue,
                                                       Date: dict["Wdate"].stringValue,
                                                       TotalHours: dict["TotalHours"].stringValue,
                                                       LunchInTime: dict["LunchInTime"].stringValue,
                                                       LunchOutTime: dict["LunchOutTime"].stringValue,
                                                       LogInTime: dict["LogInTime"].stringValue,
                                                       LogOutTime: dict["LogOutTime"].stringValue,
                                                       break_minutes: dict["break_minutes"].stringValue,
                                                       NewId: dict["NewId"].doubleValue,
                                                       Sent: dict["Sent"].doubleValue,
                                                       Reason: dict["Reason"].stringValue,
                                                       changeFound: dict["changeFound"].doubleValue,
                                                       Color: dict["RowColor"].stringValue,
                                                       LunchInDate: dict["LunchIn"].stringValue,
                                                       LunchOutDate: dict["LunchOut"].stringValue,
                                                       LogInDate: dict["Login"].stringValue,
                                                       LogOutDate:dict["LogOut"].stringValue,
                                                       CandId:dict["CandId"].stringValue,
                                                       isSelected:"0",
                                                       isShowNote:"0")
                        viewDetailArray .add(eTimeObj)
                    }
                    if viewDetailArray.count == 0 {
                        footerView.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:120)
                        lblNoData.text = object["Message"].stringValue
                        dataTableView.tableFooterView = footerView

                    }else{
                        dataTableView.tableFooterView = UIView()
                    }
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.dataTableView.reloadData()
                    })
                    
                }else{
                    if object["Summary"].null == nil{
                        let dArray = object["Summary"].array
                        self.clearAllArray()
                        for dict in dArray! {
                            let eTimeObj = eTimeClock.init(Weekend: dict["Weekend"].stringValue,
                                                           Name: dict["Name"].stringValue,
                                                           Days: dict["Days"].stringValue,
                                                           Weekhours: dict["Weekhours"].stringValue,
                                                           isSend: dict["isSend"].doubleValue,
                                                           Color: dict["Color"].stringValue)
                            viewSummaryArray .add(eTimeObj)
                        }
                    }
                    if viewSummaryArray.count == 0 {
                        footerView.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:120)
                        lblNoData.text = object["Message"].stringValue
                        dataTableView.tableFooterView = footerView

                    }else {
                        dataTableView.tableFooterView = UIView()
                    }
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.dataTableView.reloadData()
                    })
                }
                
            }else{
                
                var message = object["Message"].stringValue
                if message.count == 0 {
                    message = Error_Message
                }
                footerView.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:120)
                lblNoData.text = message
                dataTableView.tableFooterView = footerView

                
            }
        }
    }
    func GenerateInvoiceServerCall(){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            
            
            let tempArray = NSMutableArray()
            for obj in GenerateInvoiceArray{
                let eObj:eTimeClock = obj as! eTimeClock
                if eObj.isSelected == "1"{
                    let dataDict = ["WeekEnd":self.weekendTextField.text as Any,
                                    "CandId":eObj.CandId!,
                                    "ClientId":eObj.ClientId!,
                                    "OrderId":eObj.OrderId!,
                                    "ContactId":eObj.ContactId!,
                                    "TimeId":eObj.TimeId!,
                                    "OSSource":"iOS",
                                    "Date":eObj.Date!] as [String : Any]
                    tempArray.add(dataDict)
                }
            }
            
            let params :[String:Any] = ["ETimeClockInvioceList":tempArray,
                                        ]
            
            print(params)
            let urlString = RestAPI.BaseUrl+RestAPI.eTime_Clock_Generate_Invoice_Data_URL
            
            RestAPI.generateInvoicePostRequestWithToken(urlString: urlString, params: params, callback: getInvoiceResponse(response:))
            
        }else{
            isApproveDataServerCall = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
    }
    func ApproveDataServerCall(Type: String,dArray: NSMutableArray){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            
            let defaults = UserDefaults.standard
            let clientID = "\(defaults.integer(forKey: "ClientID"))" //String(format:"%d", defaults.integer(forKey: "ClientID"))
            //            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            let  DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
            
            let tempArray = NSMutableArray()
            for obj in dArray{
                let eObj:eTimeClock = obj as! eTimeClock
                if eObj.isSelected == "1"{
                    let dataDict = ["WeekEnd":self.weekendTextField.text as Any,
                                    "CandId":eObj.CandId!,
                                    "TimeId":eObj.TimeId!,
                                    "TotalHours":eObj.TotalHours!,
                                    "Div_id":DivisionId,
                                    "break_minutes":eObj.break_minutes!,
                                    "Wdate":eObj.Date!,
                                    "Login":eObj.LogInTime!,
                                    "LogOut":eObj.LogOutTime!] as [String : Any]
                    tempArray.add(dataDict)
                }
            }
            
            let params :[String:Any] = ["ETimeClockApprovalList":tempArray,
                                        "ClientId":clientID,
                                        "OSSource":"iOS",
                                        "Type":Type]
            
            print(params)
            let urlString = RestAPI.BaseUrl+RestAPI.Approve_eTime_Clock_Data_URL
            
            RestAPI.postRequestWithToken(urlString: urlString, params: params, callback: getApproveResponse(response:))
            
            //            RestAPI.ApproveeTimeClockData(self, params: params as! [String : String], method: "POST", accessToken: "", acces: true, callBack: getInvoiceResponse(response:))
        }else{
            isApproveDataServerCall = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
    }
    func getInvoiceResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            isApproveDataServerCall = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }else{
            isApproveDataServerCall = false
            var object = response as! JSON
            if object["MessageStatus"].intValue == 1{
                var message = object["Message"].stringValue
                if message.count == 0 {
                    message = "Invoice Generated Successfully"
                }
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
            }else{
                var message = object["Message"].stringValue
                if message.count == 0 {
                    message = Error_Message
                }
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
    }
    func getApproveResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        isApproveDataServerCall = false
        if response is String{
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }else{
            
            var object = response as! JSON
            if object["MessageStatus"].intValue == 1{
                var message = object["Message"].stringValue
                if message.count == 0 {
                    message = "Approved Successfully"
                }
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                self.navigationController?.view.makeToast("Please wait...", duration: 3.0, position: .bottom, title: "", image: nil)
                self.GetDataServerCall(command:"")
                
            }else{
                
                var message = object["Message"].stringValue
                if message.count == 0 {
                    message = Error_Message
                }
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }
    }
    func GetEmpHoursDataServerCall(TimeId: String){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            
            UpdatedTimeArray .removeAllObjects()
            let params :[String:String] = [ "TimeId":TimeId]
            print(params)
            RestAPI.geteTimeClockEmployeeHoursData(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getEmpHoursResponse(response:))
        }else{
            isApproveDataServerCall = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    
    func getEmpHoursResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        self.navigationController?.view.hideAllToasts()
        
        print(response)
        if response is String{
            isApproveDataServerCall = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            
            //            if object["MessageStatus"].intValue == 1
            //            {
            let dArray = object["employeeTotalHours"].array
            UpdatedTimeArray .removeAllObjects()
            for dict in dArray! {
                
                let eTimeEmpHrObj = eTimeClockEmpTotalHour.init(his_Wdate: dict["his_Wdate"].stringValue,
                                                                his_Login: dict["his_Login"].stringValue,
                                                                his_LunchOut: dict["his_LunchOut"].stringValue,
                                                                his_LunchIn: dict["his_LunchIn"].stringValue,
                                                                his_LogOut: dict["his_LogOut"].stringValue,
                                                                his_Name: dict["his_Name"].stringValue)
                UpdatedTimeArray .add(eTimeEmpHrObj)
            }
            if UpdatedTimeArray.count == 0 {
                
            }else{
                self.showEmpTimeHrPopupView()
            }
            
        }
        
    }
    //
    func AssigningValuesFromServer(object:JSON){
        
        Reason = object["ETimeClockApprovalModel"]["Reason"].stringValue
        LoginDate = object["ETimeClockApprovalModel"]["Login"].stringValue
        LunchInDate = object["ETimeClockApprovalModel"]["LunchIn"].stringValue
        LunchOutDate = object["ETimeClockApprovalModel"]["LunchOut"].stringValue
        LogOutDate = object["ETimeClockApprovalModel"]["LogOut"].stringValue
        
        LoginTime = object["ETimeClockApprovalModel"]["LogInTime"].stringValue
        LunchInTime = object["ETimeClockApprovalModel"]["LunchInTime"].stringValue
        LunchOutTime = object["ETimeClockApprovalModel"]["LunchOutTime"].stringValue
        LogOutTime = object["ETimeClockApprovalModel"]["LogOutTime"].stringValue
        
        
        let employees = object["ETimeClockApprovalModel"]["ActiveOrders"].arrayValue
        empArray.removeAllObjects()
        for dic in employees{
            let empObj = MealBreakMin.init(Text: dic["Name"].stringValue, Value: dic["Caand_id"].stringValue, isSelected: "0")
            if empArray.contains(empObj){}else{
                empArray.add(empObj)}
        }
        
        if  object["colourText"].null == nil{
            let colourTextArray = object["colourText"].array // as! NSMutableArray
            colorLegendArray.removeAllObjects()
            
            for dict in colourTextArray! {
                let dictObj = ["Text":dict["Text"].stringValue,"Color":dict["Color"].stringValue]
                if colorLegendArray.contains(dictObj){}else{
                    colorLegendArray.add(dictObj)}
            }
        }
        
        if object["WeekEnd"].null == nil{
            weekendTextField.text = object["WeekEnd"].stringValue
        }
    }
    //MARK: Navigation Methods
    func pushToEnterUpdateTimeClockPage(isForEnterTimeClock: Bool,eTimeClockObj: eTimeClock){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is eTimeClockEnterUpdateViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "eTimeClockEnterUpdateSegue") as! eTimeClockEnterUpdateViewController
            nextViewController.isForEnterTimeClock = isForEnterTimeClock
            nextViewController.WeekEnd = self.weekendTextField.text!
            if isForEnterTimeClock == false{
                
                nextViewController.selectedTimeClockObj = eTimeClockObj
                
                nextViewController.LoginDate = eTimeClockObj.LogInDate!
                nextViewController.LunchReturnDate = eTimeClockObj.LunchInDate!
                nextViewController.LunchOutDate = eTimeClockObj.LunchOutDate!
                nextViewController.LogOutDate = eTimeClockObj.LogOutDate!
                nextViewController.LoginTime = eTimeClockObj.LogInTime!
                nextViewController.LunchReturnTime = eTimeClockObj.LunchInTime!
                nextViewController.LunchOutTime = eTimeClockObj.LunchOutTime!
                nextViewController.LogOutTime = eTimeClockObj.LogOutTime!
            }else
            {
                nextViewController.EmpDataArray = self.empArray
                nextViewController.old_Reason =  self.Reason
                nextViewController.old_LoginDate = self.LoginDate
                nextViewController.old_LunchReturnDate = self.LunchInDate
                nextViewController.old_LunchOutDate = self.LunchOutDate
                nextViewController.old_LogOutDate = self.LogOutDate
                nextViewController.old_LoginTime = self.LoginTime
                nextViewController.old_LogOutTime = self.LogOutTime
                nextViewController.old_LunchOutTime = self.LunchOutTime
                nextViewController.old_LunchReturnTime = self.LunchInTime
                
                //                LoginTime = object["ETimeClockApprovalModel"]["LogInTime"].stringValue
                //                LunchInTime = object["ETimeClockApprovalModel"]["LunchInTime"].stringValue
                //                LunchOutTime = object["ETimeClockApprovalModel"]["LunchOutTime"].stringValue
                //                LogOutTime = object["ETimeClockApprovalModel"]["LogOutTime"].stringValue
                
                
            }
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}


