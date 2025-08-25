//
//  ApproveTimeSheetDetailsViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 18/12/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON
@objc protocol ApproveTimeSheetDetailsDelegate: class{
    
    func isTSAppoved(_ isApproved: Bool)
}
class ApproveTimeSheetDetailsViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var dataDictArray = NSMutableArray()
    var dayArray = NSMutableArray()
    var lawDeptDayArray = NSMutableArray()
    let sectionNumberArray = NSMutableArray()
    var isSuccessMessage = false
    var isApproveWarningMessage = false
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    //MARK: LWA DEPT
    
    let datas = NSMutableArray()
    
    let mondayArray = NSMutableArray()
    let tuesdayArray = NSMutableArray()
    let wednesdayArray = NSMutableArray()
    let thursdayArray = NSMutableArray()
    let fridayArray = NSMutableArray()
    let saturdayArray = NSMutableArray()
    let sundayArray = NSMutableArray()
    var prevDate = String()
    var AssignedApprover = ""
    var ApprovedBy = ""
    var TimeApproved = ""
    var weekending = ""
    
    //MARK: LAW DEPT PARAMS
    var CandId  = ""
    var OrderId  = ""
    var WeekEnding = ""
    var TimeId = ""
    let footerHeight = CGFloat(50)
    let headerHeight = CGFloat(40)
    
    var mondayTotalHrs = ""
    var tuesdayTotalHrs = ""
    var wednesdayTotalHrs = ""
    var thursdayTotalHrs = ""
    var fridayTotalHrs = ""
    var saturdayTotalHrs = ""
    var sundayTotalHrs = ""
    
    var mondayDate = ""
    var tuesdayDate = ""
    var wednesdayDate = ""
    var thursdayDate = ""
    var fridayDate = ""
    var saturdayDate = ""
    var sundayDate = ""
    
    var MondaySection = 0
    var TuesdaySection = 1
    var WednesdaySection = 2
    var ThursdaySection = 3
    var FridaySection = 4
    var SaturdaySection = 5
    var SundaySection = 6
    
    var isFromApprovedList = false
    weak var delegate: ApproveTimeSheetDetailsDelegate? = nil
    var showOnlyView = false
    var isFromTSYouHvApprovedList = false

    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var approveBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var noDataView: UIView!

    var getApproveTSObj = GetApproveTimeSlip.init(TypeValue: 0,WeekEnding: "",CandId: 0,Name: "",Hours: "",approvedBy: "",referenceBy: "",Approved: 0,TimeId: 0,OrderId: 0,BillDate: "",PrevBillDate:"",ShowOT: "")
    @objc override func appWillEnterForeground(){
        print("appWillEnterForeground Division")
        let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
        if DivisionId == "6" && showOnlyView == true{ // Law dept
            //            self.title = "Weekly Work Time"
            if datas.count == 0{
                self.getLawDeptTSAttorneyDetails()}
            
        }else{
            if isFromTSYouHvApprovedList == true{
                if dataDictArray.count == 0{
                    self.getTimeSlipDetailsYouHaveApproved()
                }
            }else{
                if dataDictArray.count == 0{
                    self.getApproveTimeSheetDetails()}
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        noDataView.isHidden = true
        noDataView.backgroundColor = UIColor(hexString:danger_background_Color)
        lblNoData.textColor = UIColor(hexString:danger_Color)

        listTableView.tableFooterView = UIView()
        
//        let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
//
//        if DivisionId == "6" && showOnlyView == true{ // Law dept
//            //            self.title = "Weekly Work Time"
//            self.titlelbl.text = "Weekly Work Time"
//
//            editBtn.isHidden = true
//            rejectBtn.isHidden = false
//            if isFromApprovedList{
//                approveBtn.isHidden = true
//                rejectBtn.isHidden = true
//                editBtn.isHidden = true
//                tableViewBottomConstraint.constant = 0
//                listTableView.updateConstraints()
//            }
//            self.getLawDeptTSAttorneyDetails()
//
//        }else{
//            if isFromTSYouHvApprovedList == true{
//                self.getTimeSlipDetailsYouHaveApproved()
//                editBtn.isHidden = true
//                rejectBtn.isHidden = true
//                approveBtn.isHidden = true
//            }else{
//
//                self.getApproveTimeSheetDetails()
//
//                //            self.title = "View"
//
//                editBtn.isHidden = false
//                rejectBtn.isHidden = true
//            }
//            self.titlelbl.text = "View"
//        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let  DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
//
//        if DivisionId == "6" && showOnlyView == true{ // Law dept
//            self.titlelbl.text = "Weekly Work Time"
//
//        }else{
//            self.titlelbl.text = "View"
//        }
        
        let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
        if DivisionId == "6" && showOnlyView == true{ // Law dept
            //            self.title = "Weekly Work Time"
            self.titlelbl.text = "Weekly Work Time"
            
            editBtn.isHidden = true
            rejectBtn.isHidden = false
            if isFromApprovedList{
                approveBtn.isHidden = true
                rejectBtn.isHidden = true
                editBtn.isHidden = true
                tableViewBottomConstraint.constant = 0
                listTableView.updateConstraints()
            }
            self.getLawDeptTSAttorneyDetails()
            
        }else{
            if isFromTSYouHvApprovedList == true{
                self.getTimeSlipDetailsYouHaveApproved()
                editBtn.isHidden = true
                rejectBtn.isHidden = true
                approveBtn.isHidden = true
            }else{
                
                self.getApproveTimeSheetDetails()
                
                //            self.title = "View"
                
                editBtn.isHidden = false
                rejectBtn.isHidden = true
            }
            self.titlelbl.text = "View"
        }
    }
    //MARK: Button Action
    
    @IBAction func editButtonTapped(_ sender: UIButton){
        
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is EditTimeSlipViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier:"EditTimeSheetSegue") as! EditTimeSlipViewController
         nextViewController.getApproveTSObj = getApproveTSObj
        nextViewController.prevDate = prevDate
        self.navigationController?.pushViewController(nextViewController, animated: true)
      
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        //self.ShowAlertMessage(message: "Under Development", title: "")
    }
    
    
    
    
    @IBAction func approveButtonTapped(_ sender: UIButton){
        
        let  DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
        if DivisionId == "6" && showOnlyView == true{ // Law dept
            self.approveRejectLawDeptPendingTS(command: "Approve")
        }else{
            self.approvePendingTimeSlip(ApproveKey: "0")
        }
    }
    @IBAction func rejectButtonTapped(_ sender: UIButton){
        let  DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
        if DivisionId == "6" && showOnlyView == true{ // Law dept
            self.approveRejectLawDeptPendingTS(command: "Reject")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func formDataDict(){
        
        let empNameDict = ["name":"Employee Name","value":""]
        let weekEndingDict = ["name":"Week Ending","value":""]
        let totalHrsDict = ["name":"Total hours","value":""]
        let idDict = ["name":"ID","value":""]
        let dayDict = ["name":"Day","value":""]
        let dateDict = ["name":"Date","value":""]
        
        let startTimeDict = ["name":"Start Time","value":""]
        
        let endTimeDict = ["name":"End Time","value":""]
        let lunchDict = ["name":"Lunch","value":""]
        let hoursDict = ["name":"Hours","value":""]
        let taxiFareDict = ["name":"Taxi Fare $","value":""]
        let assignedApproverDict = ["name":"Assigned Approver","value":""]
        let approvedByDict = ["name":"Approved By","value":""]
        let timeApprovedDict = ["name":"Time Approved","value":""]
        
        dataDictArray = [empNameDict,weekEndingDict,totalHrsDict,idDict,dayDict,dateDict,startTimeDict,endTimeDict,lunchDict,hoursDict,taxiFareDict,assignedApproverDict,approvedByDict,timeApprovedDict]
    }
    //MARK:-  TABLEVIEW DATA SOURCE METHOD
    public func numberOfSections(in tableView: UITableView) -> Int // Default is 1 if not implemented
    {
        let  DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
        if DivisionId == "6" && showOnlyView == true{ // Law dept
            
            return 7
            
        }
        return 1
        
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let  DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
        if DivisionId == "6" && showOnlyView == true{ // Law dept
            if section == MondaySection{
                return mondayArray.count
            }else if section == TuesdaySection{
                return tuesdayArray.count
            }else if section == WednesdaySection{
                return wednesdayArray.count
            }else if section == ThursdaySection{
                return thursdayArray.count
            }else if section == FridaySection{
                return fridayArray.count
            }else if section == SaturdaySection{
                return saturdayArray.count
            }else if section == SundaySection{
                return sundayArray.count
            }
        }
        
        return dataDictArray.count//dayArray.count + 1 + 3 // 1- for top emp details 3- assigned approver etc
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let  DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
        if DivisionId == "6" && showOnlyView == true{ // Law dept
            
            let cell:ApproveTSDetailTableViewCell = listTableView.dequeueReusableCell(withIdentifier: "ApproveTSDetailTableViewCellLawIdentifier") as! ApproveTSDetailTableViewCell
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.contentView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            
            var dataArray = NSMutableArray()
            
            if indexPath.section == MondaySection{
                dataArray =  mondayArray
                
            }else if indexPath.section == TuesdaySection{
                dataArray = tuesdayArray
            }else if indexPath.section == WednesdaySection{
                dataArray =  wednesdayArray
            }else if indexPath.section == ThursdaySection{
                dataArray =  thursdayArray
            }else if indexPath.section == FridaySection{
                dataArray = fridayArray
            }else if indexPath.section == SaturdaySection{
                dataArray =   saturdayArray
            }else if indexPath.section == SundaySection{
                dataArray =   sundayArray
            }
            let  vat:ViewAttorney = dataArray[indexPath.row] as! ViewAttorney
            
            cell.lblTimeValue.text = String(format:"%@ - %@",vat.AttorneyStartTime!,vat.AttorneyEndTime!)
            cell.lblHrValue.text = vat.AttorneyWork_Performed
            cell.lblLunchValue.text = vat.AttorneyMatter
            cell.lblTaxifareValue.text =  vat.Hours
            if isFromApprovedList == true{
                if vat.AttorneyIsApproved == 0{
                    cell.backgroundColor = UIColor.white
                    
                }else{
                    cell.backgroundColor = UIColor(hexString:"#99FF99")
                    
                }
            }else{
                cell.backgroundColor = UIColor.white
                
            }
            return cell
        }
        
        let dict = dataDictArray[indexPath.row] as! NSDictionary
        
        let type = dict["type"] as! String
        
        
        if type == "bottom"{
            return self.bottomDetailsCell( indexPath: indexPath as NSIndexPath)
        }else if type == "emp"{
            return self.empDetailsCell( indexPath: indexPath  as NSIndexPath)
        }else if type == "day"{
            return self.daysCell( indexPath: indexPath  as NSIndexPath)
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell!
        if !(cell != nil) {
            cell = UITableViewCell(style:.subtitle, reuseIdentifier: "CELL")
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let  DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
        if DivisionId == "6" && showOnlyView == true{ // Law dept
            return 120
        }
        let dict = dataDictArray[indexPath.row] as! NSDictionary
        
        let type = dict["type"] as! String
        
        
        if type == "bottom"{
            return 45
        }else if type == "emp"{
            return 110
        }else if type == "day"{
            return 95
        }
        return 45
        
        
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let  DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
        var headerText = ""
        
        if DivisionId == "6" && showOnlyView == true{ // Law dept
            if  section == MondaySection{
                if  mondayArray.count > 0{
                    headerText = String(format:"Monday:%@",mondayDate)
                }
                
            }else if  section == TuesdaySection{
                if  tuesdayArray.count > 0{
                    headerText = String(format:"Tuesday:%@",tuesdayDate)
                    
                }
            }else if  section == WednesdaySection{
                if  wednesdayArray.count > 0{
                    headerText = String(format:"Wednesday:%@",wednesdayDate)
                    
                }
            }else if  section == ThursdaySection{
                if  thursdayArray.count > 0{
                    headerText = String(format:"Thursday:%@",thursdayDate)
                    
                }
            }else if  section == FridaySection{
                if  fridayArray.count > 0{
                    headerText = String(format:"Friday:%@",fridayDate)
                    
                }
            }else if  section == SaturdaySection{
                if  saturdayArray.count > 0{
                    headerText = String(format:"Saturday:%@",saturdayDate)
                    
                }
            }else if  section == SundaySection{
                if  sundayArray.count > 0{
                    headerText = String(format:"Sunday:%@",sundayDate)
                    
                }
            }
            if headerText.count > 0{
                
                return self.createViewWithText(header: headerText,isForHeader: true )
            }else{
                return UIView()
            }
        }
        
        return UIView()
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let  DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
        var headerText = ""
        
        if DivisionId == "6" && showOnlyView == true{ // Law dept
            if  section == MondaySection{
                if  mondayArray.count > 0{
                    headerText = mondayTotalHrs
                }
                
            }else if  section == TuesdaySection{
                if  tuesdayArray.count > 0{
                    headerText = tuesdayTotalHrs
                    
                }
            }else if  section == WednesdaySection{
                if  wednesdayArray.count > 0{
                    headerText = wednesdayTotalHrs
                    
                }
            }else if  section == ThursdaySection{
                if  thursdayArray.count > 0{
                    headerText = thursdayTotalHrs
                    
                }
            }else if  section == FridaySection{
                if  fridayArray.count > 0{
                    headerText = fridayTotalHrs
                    
                }
            }else if  section == SaturdaySection{
                if  saturdayArray.count > 0{
                    headerText = saturdayTotalHrs
                    
                }
            }else if  section == SundaySection{
                if  sundayArray.count > 0{
                    headerText = sundayTotalHrs
                    
                }
            }
            if headerText.count > 0{
                
                return self.createViewWithText(header: headerText,isForHeader: false )
            }else{
                return UIView()
            }
        }
        return UIView()
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        let  DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
        
        if DivisionId == "6" && showOnlyView == true{ // Law dept
            if  section == MondaySection{
                if  mondayArray.count > 0{
                    return headerHeight
                }
                
            }else if  section == TuesdaySection{
                if  tuesdayArray.count > 0{
                    return headerHeight
                    
                }
            }else if  section == WednesdaySection{
                if  wednesdayArray.count > 0{
                    return headerHeight
                    
                }
            }else if  section == ThursdaySection{
                if  thursdayArray.count > 0{
                    return headerHeight
                    
                }
            }else if  section == FridaySection{
                if  fridayArray.count > 0{
                    return headerHeight
                    
                }
            }else if  section == SaturdaySection{
                if  saturdayArray.count > 0{
                    return headerHeight
                    
                }
            }else if  section == SundaySection{
                if  sundayArray.count > 0{
                    return headerHeight
                    
                }
            }
            return 0
            
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        let  DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
        
        if DivisionId == "6" && showOnlyView == true{ // Law dept
            if  section == MondaySection{
                if  mondayArray.count > 0{
                    return footerHeight
                }
                
            }else if  section == TuesdaySection{
                if  tuesdayArray.count > 0{
                    return footerHeight
                    
                }
            }else if  section == WednesdaySection{
                if  wednesdayArray.count > 0{
                    return footerHeight
                    
                }
            }else if  section == ThursdaySection{
                if  thursdayArray.count > 0{
                    return footerHeight
                    
                }
            }else if  section == FridaySection{
                if  fridayArray.count > 0{
                    return footerHeight
                    
                }
            }else if  section == SaturdaySection{
                if  saturdayArray.count > 0{
                    return footerHeight
                    
                }
            }else if  section == SundaySection{
                if  sundayArray.count > 0{
                    return footerHeight
                    
                }
            }
            return 0
            
        }
        return 0
    }
    
    func createViewWithText(header: String,isForHeader : Bool) -> UIView {
        
        let dview = UIView.init(frame: CGRect(x:0 , y:0 ,width: UIScreen.main.bounds.size.width,height: 50))
        
        let label = UILabel.init(frame: CGRect(x:10 , y:2 ,width: UIScreen.main.bounds.size.width - 20,height: 48))
        label.text = header
    
        if isForHeader == true{
            dview.backgroundColor = UIColor.init(red: 216/258, green: 216/258 , blue: 216/258, alpha: 1)
            label.textAlignment = .left
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        }else{
            dview.backgroundColor = UIColor.white
            label.textAlignment = .right
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = UIColor.black
            let topLineview = UIView.init(frame: CGRect(x:0 , y:0 ,width: dview.bounds.size.width,height: 1))
            let bottomLineview = UIView.init(frame: CGRect(x:0 , y:49 ,width: dview.bounds.size.width,height: 1))
            topLineview.backgroundColor = UIColor.lightGray
            bottomLineview.backgroundColor = UIColor.lightGray
            dview.addSubview(topLineview)
            dview.addSubview(bottomLineview)
        }
        dview.addSubview(label)
        
        return dview
    }
    
    
    //MARK: Custom Cell
    
    func bottomDetailsCell(indexPath: NSIndexPath) -> EmpHistoryTableViewCell {
        
        let cell:EmpHistoryTableViewCell = listTableView.dequeueReusableCell(withIdentifier: "EmpHistoryTableViewCellIdentifier") as! EmpHistoryTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        let dict = dataDictArray[indexPath.row] as! NSDictionary
        
        let title = dict["title"] as! String
        let value = dict["value"] as! String
        
        cell.lblSubjectTitle.text = title
        cell.lblSubjects.text = value
        cell.lblSubjectTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        return cell
        
    }
    func empDetailsCell(indexPath: NSIndexPath) -> ApproveTimeSlipTableViewCell {
        
        let cell:ApproveTimeSlipTableViewCell = listTableView.dequeueReusableCell(withIdentifier: "ApproveTimeSlipTableViewCellIdentifier") as! ApproveTimeSlipTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        cell.lblEmpName.text = getApproveTSObj.Name
        cell.lblDate.text = getApproveTSObj.WeekEnding
        cell.lblHours.text = getApproveTSObj.Hours
        cell.lblReference.text = String(format:"%d",getApproveTSObj.TimeId!)
        let divColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
        cell.lblEmpNameTitle.textColor = divColor
        cell.lblHoursTitle.textColor = divColor
        cell.lblDateTitle.textColor = divColor
        cell.lblReferenceTitle.textColor = divColor
        return cell
        
    }
    func daysCell(indexPath: NSIndexPath) -> ApproveTSDetailTableViewCell {
        
        let cell:ApproveTSDetailTableViewCell = listTableView.dequeueReusableCell(withIdentifier: "ApproveTSDetailTableViewCellIdentifier") as! ApproveTSDetailTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        
        //                            let dictObj = ["day":day,"date":date,"startTime":startTime,"endTime":endTime,"lunch":lunch,"hours":hours,"taxifare":taxifare,"type":"day"]
        
        let dict = dataDictArray[indexPath.row] as! NSDictionary
        
        let time = String(format:"%@ - %@",dict["startTime"] as! String,dict["endTime"] as! String)
        let dayDate = String(format:"%@\n%@",dict["day"] as! String,dict["date"] as! String)
        
        cell.lblDateValue.text = dayDate
        cell.lblTimeValue.text = time
        cell.lblHrValue.text = dict["hours"] as? String
        cell.lblLunchValue.text = dict["lunch"] as? String
        if isFromTSYouHvApprovedList == true{
            cell.lblTaxifareValue.isHidden = true
            cell.lblTaxifareTitle.isHidden = true
         }else{
            cell.lblTaxifareValue.text = dict["taxifare"] as? String
            cell.lblTaxifareTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
            cell.lblTaxifareValue.isHidden = false
            cell.lblTaxifareTitle.isHidden = false
         }
        
        cell.lblTimeTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.lblHrTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.lblLunchTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
        cell.lblDateValue.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
        return cell
        
    }
    // MARK: - SERVER CALL
    
    func getLawDeptTSAttorneyDetails() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            
            let params :[String:String] = ["CandId":CandId,"OrderId":OrderId,"WeekEnding":WeekEnding,"TimeId":TimeId]
            
            print(params)
            RestAPI.approveTSViewAttorney(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getLawDeptResponse(response:))
            
        }else{
            isSuccessMessage = false
            isApproveWarningMessage = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

//            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )

        }
    }
    func approveRejectLawDeptPendingTS(command: String) {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            let ContactId = String(format:"%d", UserDefaults.standard.integer(forKey: "ContactId"))
            let ClientID = String(format:"%d", UserDefaults.standard.integer(forKey: "ClientID"))
            
            let params :[String:String] =  ["ContactId":ContactId,"ClientId":ClientID,"TimeId":TimeId,"OrderId":OrderId,"CandId":CandId,"WeekEnding":WeekEnding,"Command":command,
                "OSSource": "iOS"]
            print(params)
            if command == "Approve"{
                RestAPI.approveTSAttonerySubmit(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getApproveResponse(response:))
            }else{
            RestAPI.approveTSAttonerySubmit(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getRejectResponse(response:))
            }
        }else{
            
             isSuccessMessage = false
            isApproveWarningMessage = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

        }
    }
    func approvePendingTimeSlip(ApproveKey: String){
        
        
        let defaults = UserDefaults.standard
        
        let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
        let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
        let ApproveList = NSMutableArray()
        
//        let tsObj = ["Hours":getApproveTSObj.Hours,
//                     "BillDate":getApproveTSObj.BillDate,
//                     "Name":getApproveTSObj.Name,
//                     "timeId":String(format:"%d",getApproveTSObj.TimeId!),
//                     "IsApprove":"true",
//                     "Weekending":getApproveTSObj.WeekEnding,
//                     "Previousdate":"",//ts.BillDate,
//            "New":"0",
//            "ApproveKey": ApproveKey
//        ]
//        ApproveList.add(tsObj)
        //busha 3/2
//
//        let param = ["ContactId": ContactId,
//                     "ClientId": clientID,
//                     "ApproveConfirmation":"0",
//                     "Weekending":getApproveTSObj.WeekEnding!,
//                     "Name":getApproveTSObj.Name,
//                     "ApproveList":ApproveList] as [String : Any]  as NSDictionary
//
        
        let param = ["ContactId": ContactId,
                     "ClientId": clientID,
                     "Hours":getApproveTSObj.Hours!,
                     "Name":getApproveTSObj.Name!,
                     "Weekending":getApproveTSObj.WeekEnding!,
                     "ApproveKey": ApproveKey,
                     "OSSource": "iOS",
                     "TimeId":String(format:"%d",getApproveTSObj.TimeId!)] as [String : Any]  as NSDictionary

        print(param)
        
        let urlString = RestAPI.BaseUrl+RestAPI.ApproveTimeSlip
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            
            RestAPI.postRequestWithToken(urlString: urlString, params: param, callback: getApproveResponse(response:))
            
        }else{
            
//            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
           isSuccessMessage = false
            isApproveWarningMessage = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

        }
        
        
        
    }
    
    func getApproveTimeSheetDetails() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            
            let timeID = String(format:"%d", getApproveTSObj.TimeId!)
            let Type = String(format:"%d", getApproveTSObj.TypeValue!)
            let Hours = getApproveTSObj.Hours!
            let EmployeeName = String(format:"%@", getApproveTSObj.Name!)
            let WeekEnding = String(format:"%@", getApproveTSObj.WeekEnding!)
            
            //userid as String
            let params :[String:String] = ["TimeId":timeID,"Type":Type,"EmployeeName":EmployeeName,"Hours":Hours,"WeekEnding":WeekEnding,"ShowEdit":"true"]
            print(params)
            RestAPI.ApproveTimeSheetDetails(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
            
        }else{
            
//            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
            isSuccessMessage = false
isApproveWarningMessage = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

        }
    }
    func getApproveResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            noDataView.isHidden = false

//            self.ShowAlertMessage(message: response as! String, title: "")
            isSuccessMessage = false
            isApproveWarningMessage = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

        }else{
            
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                let message = object["Message"].stringValue
                if (message.caseInsensitiveCompare("Approved successfully") == ComparisonResult.orderedSame) || (message.caseInsensitiveCompare("rejected successfully") == ComparisonResult.orderedSame){
                    
                    
                    isSuccessMessage = true
                    isApproveWarningMessage  = false
                    
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                    
                    noDataView.isHidden = true
                    
                }else{
                    
                    isSuccessMessage = false
                    isApproveWarningMessage = true
                    let htmlString = "<html>" + message
                    
                    let messageText = htmlString.htmlToAttributedString
                    self.showCustomAlert(Title: "", attMessage: messageText! , message: message , okBtnTitle: "OK", cancelBtnTitle: "Cancel", type: Warning_Text,isAttributed: true)
                }
                
                
//
//                isSuccessMessage = true
//                isApproveWarningMessage = false
//                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
//
//                noDataView.isHidden = true

            }else{
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = "There is some error"
                    
                }
                noDataView.isHidden = true
                lblNoData.text = message
isSuccessMessage = false
                isApproveWarningMessage = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

            }
        }
        
    }
    func getRejectResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            noDataView.isHidden = false
            
            //            self.ShowAlertMessage(message: response as! String, title: "")
            isSuccessMessage = false
            isApproveWarningMessage = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
 
                    
                    isSuccessMessage = true
                    isApproveWarningMessage  = false
                    
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                    
                    noDataView.isHidden = true
                 
             }else{
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message //"There is some error"
                    
                }
                noDataView.isHidden = true
                lblNoData.text = message
                isSuccessMessage = false
                isApproveWarningMessage = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }
        
    }
    @IBAction override func okButtonTapped(_ sender: Any) {
        //    self.alertController.dismiss(animated: true, completion: nil)
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
        if isSuccessMessage == true{
            self.delegate?.isTSAppoved(true)
            
            self.navigationController?.popViewController(animated: true)
        }else if isApproveWarningMessage == true {
            self.approvePendingTimeSlip(ApproveKey: "1")
        }
    }
    func getLawDeptResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        
        if response is String{
            
//            self.ShowAlertMessage(message: response as! String, title: "")
            isSuccessMessage = false
            isApproveWarningMessage = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

        }else{
            
            var object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
                let dictArray = object["viewAttorneyList"].array
                //                lawDeptDayArray
                
                mondayTotalHrs = String(format:"Monday Total work hours %@",object["MonTotalHours"].stringValue)
                tuesdayTotalHrs = String(format:"Tuesday Total work hours %@",object["TueTotalHours"].stringValue)
                wednesdayTotalHrs = String(format:"Wednesday Total work hours %@",object["WedTotalHours"].stringValue)
                thursdayTotalHrs = String(format:"Thursday Total work hours %@",object["ThuTotalHours"].stringValue)
                fridayTotalHrs = String(format:"Friday Total work hours %@",object["FriTotalHours"].stringValue)
                saturdayTotalHrs = String(format:"Saturday Total work hours %@",object["SatTotalHours"].stringValue)
                sundayTotalHrs = String(format:"Sunday Total work hours %@",object["SunTotalHours"].stringValue)
                
                for dict in dictArray! {
                    
                    let Attorneydate = self.getFormattedDate(string: (dict["Attorneydate"].stringValue))
                    
                    let div = ViewAttorney.init(DetailId: dict["DetailId"].intValue, AttorneyWork_Performed: dict["AttorneyWork_Performed"].stringValue, Day: dict["Day"].stringValue, AttorneyMatter: dict["AttorneyMatter"].stringValue, AttorneyEndTime: dict["AttorneyEndTime"].stringValue, AttorneyStartTime: dict["AttorneyStartTime"].stringValue, Hours: dict["Hours"].stringValue, TimeId: dict["TimeId"].intValue, Attorneydate: Attorneydate, ClientId: dict["Type"].intValue, AttorneyIsApproved: dict["AttorneyIsApproved"].intValue)
                    
                    if div.Day == "Monday"{
                        mondayArray.add(div)
                        mondayDate = div.Attorneydate!
                        
                        if sectionNumberArray.contains("Mon"){
                        }else{
                            sectionNumberArray.add("Mon")
                        }
                    }else if div.Day == "Tuesday"{
                        tuesdayArray.add(div)
                        tuesdayDate = div.Attorneydate!
                        
                        if sectionNumberArray.contains("Tue"){
                        }else{
                            sectionNumberArray.add("Tue")}
                        
                    }else if div.Day == "Wednesday"{
                        wednesdayArray.add(div)
                        wednesdayDate = div.Attorneydate!
                        
                        if sectionNumberArray.contains("Wed"){
                        }else{
                            sectionNumberArray.add("Wed")}
                        
                    }else if div.Day == "Thursday"{
                        thursdayArray.add(div)
                        thursdayDate = div.Attorneydate!
                        
                        if sectionNumberArray.contains("Thu"){
                        }else{
                            sectionNumberArray.add("Thu")}
                        
                    }else if div.Day == "Friday"{
                        fridayArray.add(div)
                        fridayDate = div.Attorneydate!
                        
                        if sectionNumberArray.contains("Fri"){
                        }else{
                            sectionNumberArray.add("Fri")}
                        
                    }else if div.Day == "Saturday"{
                        saturdayArray.add(div)
                        saturdayDate = div.Attorneydate!
                        
                        if sectionNumberArray.contains("Sat"){
                        }else{
                            sectionNumberArray.add("Sat")}
                        
                    }else if div.Day == "Sunday"{
                        sundayArray.add(div)
                        sundayDate = div.Attorneydate!
                        
                        if sectionNumberArray.contains("Sun"){
                        }else{
                            sectionNumberArray.add("Sun")}
                        
                    }
                    datas.add(div)
                }
                
                if datas.count == 0 {
                    var message = object["Message"].stringValue
                    
                    if message.count == 0 {
                        message = "No data found"
                    }
                    self.lblNoData.text = message
                    self.noDataView.isHidden = false
                 }else{
                    self.noDataView.isHidden = true
                }
                listTableView.reloadData()
                
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                isSuccessMessage = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
    }
    func getResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            
//            self.ShowAlertMessage(message: response as! String, title: "")
            isSuccessMessage = false
            isApproveWarningMessage = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

        }else{
            
            var object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
                dataDictArray.removeAllObjects()
                let dictArray = object["CandidateTimeSlipDetail"].array
                let totalHrs = getApproveTSObj.Hours
                let id = String(format:"%.2f",getApproveTSObj.TimeId!)
                
                let empDetailsDict = ["Employee Name":getApproveTSObj.Name,"Week Ending":getApproveTSObj.WeekEnding,"Total hours":totalHrs,"ID":id,"type":"emp"]
                
                
                dataDictArray.add(empDetailsDict)
                
                for dict in dictArray!{
                    //y925261,kumbha 24/  ,8249963153
                    
                    let day = dict["day"].stringValue
                    let date = self.getFormattedDate(string: (dict["date"].stringValue))
                    let startTime = dict["start_time"].stringValue
                    let endTime = dict["end_time"].stringValue
                    let lunch = dict["break_minutes"].stringValue
                    let hours = String(format:"%.2f",dict["Hours"].doubleValue)
                    let taxifare = String(format:"%.2f",dict["taxi"].doubleValue)//dict["taxi"].stringValue
                    
                    let dictObj = ["day":day,"date":date,"startTime":startTime,"endTime":endTime,"lunch":lunch,"hours":hours,"taxifare":taxifare,"type":"day"]
                    
                    //                    dayArray.add(dictObj)
                    dataDictArray.add(dictObj)
                    
                }
                //                dataDictArray.add(dayArray)
                
                //
                let dictAssigned = ["title":"Assigned Approver","value":"","type":"bottom"]
                let dictApprovedBy = ["title":"Approved By","value":"","type":"bottom"]
                let dictTimeApproved = ["title":"Time Approved","value":"","type":"bottom"]
                dataDictArray.add(dictAssigned)
                dataDictArray.add(dictApprovedBy)
                dataDictArray.add(dictTimeApproved)
                
                listTableView.reloadData()
                
            }else{
                
                var message = object["message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                isSuccessMessage = false
                isApproveWarningMessage = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
    }
    func getTimeSlipDetailsYouHaveApproved() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            
            let timeID = String(format:"%d", getApproveTSObj.TimeId!)
            let Type = String(format:"%d", getApproveTSObj.TypeValue!)
            let Hours = getApproveTSObj.Hours!
            let EmployeeName = String(format:"%@", getApproveTSObj.Name!)
            let WeekEnding = String(format:"%@", getApproveTSObj.WeekEnding!)
            
            //userid as String
            let params :[String:String] = ["MainTimeId":timeID,"Type":"1","EmployeeName":EmployeeName,"TotalHours":Hours,"WeekEnding":WeekEnding,"ShowEdit":"false"]
            print(params)

            RestAPI.getTimeSlipDetailsYouHaveApproved(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getTimeSlipDetailsYouHaveApprovedResponse(response:))
            
        }else{
            
            //            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
            isSuccessMessage = false
            isApproveWarningMessage = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    func getTimeSlipDetailsYouHaveApprovedResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            
            //            self.ShowAlertMessage(message: response as! String, title: "")
             self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
                dataDictArray.removeAllObjects()
                
                let dictArray = object["ViewDetailList"].array
                let ApproverArray = object["ApproverList"].array

                let totalHrs = getApproveTSObj.Hours
                let id = String(format:"%d",getApproveTSObj.TimeId!)
                
                let empDetailsDict = ["Employee Name":getApproveTSObj.Name,"Week Ending":getApproveTSObj.WeekEnding,"Total hours":totalHrs,"ID":id,"type":"emp"]
                
                
                dataDictArray.add(empDetailsDict)
                
                for dict in dictArray!{
                    //y925261,kumbha 24/  ,8249963153
                    
                    let day = dict["Day"].stringValue
                    let date =  dict["Date"].stringValue
                    let startTime = dict["StartTime"].stringValue
                    let endTime = dict["EndTime"].stringValue
                    let lunch = dict["Lunch"].stringValue
                    let hours = String(format:"%.2f",dict["Hour"].doubleValue)
 
                    let dictObj = ["day":day,"date":date,"startTime":startTime,"endTime":endTime,"lunch":lunch,"hours":hours,"taxifare":"","type":"day"]
                    
                    //                    dayArray.add(dictObj)
                    dataDictArray.add(dictObj)
                    
                }
               
                var  Assigned = ""
                var    ApprovedBy = ""
                var  TimeApproved = ""
                for dict in ApproverArray!{
                    Assigned = dict["AssignedName"].stringValue
                    ApprovedBy = dict["ApprovedName"].stringValue
                    TimeApproved = dict["TimeApproved"].stringValue
                    break
                }
                let dictAssigned = ["title":"Assigned Approver","value":Assigned,"type":"bottom"]
                let dictApprovedBy = ["title":"Approved By","value":ApprovedBy,"type":"bottom"]
                let dictTimeApproved = ["title":"Time Approved","value":TimeApproved,"type":"bottom"]
                dataDictArray.add(dictAssigned)
                dataDictArray.add(dictApprovedBy)
                dataDictArray.add(dictTimeApproved)
                
                listTableView.reloadData()
                
            }else{
                
                var message = object["message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                isSuccessMessage = false
                isApproveWarningMessage = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
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
    
}
