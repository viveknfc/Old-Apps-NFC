//
//  HistoricOrderViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 28/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON
import FSCalendar

class HistoricOrderViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance,UISearchBarDelegate {
    
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var noDataView: UIView!

    @IBOutlet weak var POSearchBar: UISearchBar!
    var isSearching = false
var fileName = ""
    
    @IBOutlet weak var orderListTableView: UITableView!
    @IBOutlet weak var fromDateView: UIView!
    @IBOutlet weak var fromDateArrowImg: UIImageView!
    @IBOutlet weak var toDateArrowImg: UIImageView!
    @IBOutlet weak var calendarBGView: UIView!
    
 
    @IBOutlet weak var toButton: UIButton!
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var toDateView: UIView!
    var orderDataArray = NSMutableArray()
    var filteredDataArray = NSMutableArray()

    @IBOutlet weak var refreshListButton: UIButton!
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    var resultFromDate = String()
    var resultToDate = String()
    var selecetdFromDate = Date()
    var selecetdToDate = Date()
    
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titlelbl.text = "View Existing and Historical Orders"

    }
    override func goBack() {
        //pop to dashboard
        self.popToDasboardPage()
    }
    func popToDasboardPage(){
        
        
        
        var isControllerExists = false
        
        var dashboardVC = UIViewController()
        
        if let viewControllers = self.navigationController?.viewControllers {
            
            for viewController in viewControllers {
                
                if viewController is DashboardViewController {
                    print("Your controller exist")
                    dashboardVC = viewController
                    
                    isControllerExists = true
                    break
                }
            }
            
        }
        
        if isControllerExists {
            
            self.navigationController?.popToViewController(dashboardVC, animated: true)
            
        }else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DashboardSegue") as! DashboardViewController
            nextViewController.isFromDivisionPage = false
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
    }
    @objc override func appWillEnterForeground(){
        print("appWillEnterForeground Division")
        if orderDataArray.count == 0{
            if resultFromDate.count > 0 && resultToDate.count > 0{
                self.getHistoricOrdersOnDate(StartDate:resultFromDate, EndDate: resultToDate)
            }else{
                self.getHistoricOrdersOnDate(StartDate:"", EndDate:"")
                
            }
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "View Existing and Historical Orders"
        toButton.isSelected = true
        fromButton.isSelected = true
        self.calendar.layer.borderWidth = 2
        self.calendar.layer.borderColor = borderColor.cgColor
        
        self.fromDateView.layer.borderWidth = 1.5
        self.fromDateView.layer.borderColor = borderColor.cgColor
        
        self.toDateView.layer.borderWidth = 1.5
        self.toDateView.layer.borderColor = borderColor.cgColor
        
        self.toDateView.layer.cornerRadius = 2
        self.fromDateView.layer.cornerRadius = 2
        
        self.calendar.select(Date())
//        self.view.addGestureRecognizer(self.scopeGesture)
        self.calendar.scope = .month
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        self.calendar.appearance.selectionColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        self.calendar.appearance.weekdayTextColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        self.calendar.appearance.headerTitleColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        self.calendar.appearance.todayColor =  UIColor.clear

        
        self.getHistoricOrdersOnDate(StartDate:"", EndDate:"")
        self.calendar.layer.borderColor = UIColor.lightGray.cgColor
        self.calendar.layer.borderWidth = 1
        noDataView.isHidden = true
        noDataView.backgroundColor = UIColor(hexString:danger_background_Color)
        lblNoData.textColor = UIColor(hexString:danger_Color)
        POSearchBar.barTintColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        let textFieldInsideUISearchBar = POSearchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.borderStyle = .none
        textFieldInsideUISearchBar?.backgroundColor = UIColor.white

        // Do any additional setup after loading the view.
    }
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
        
        nextViewController.fileName = fileName
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func workOrderInstructionButtonTapped(_ sender: UIButton)
    {
        if fileName.count > 0 {
            
            self.pushToViewPDFPage()
        }
    }
    @IBAction func refreshListButtonTapped(_ sender: UIButton)
    {
        self.calendarBGView.isHidden = true
        self.calendarHeightConstraint.constant = 0
        
        let compare = describeComparison(date1: selecetdFromDate, date2: selecetdToDate)
        print(compare)
        if compare ==  "date1 > date2"{
            self.navigationController?.view.makeToast("Start date should be less than end date", duration: 1.5, position: .bottom, title: "", image: nil)

//            self.ShowAlertMessage(message: "Start date should be less than end date", title: "")
        }else{
            if resultFromDate.count > 0 && resultToDate.count > 0{
                self.getHistoricOrdersOnDate(StartDate:resultFromDate, EndDate: resultToDate)
                
            }
        }
    }
    
    @IBAction func fromButtonTapped(_ sender: UIButton) {
        toDateArrowImg.isHidden = true
        fromDateArrowImg.isHidden = false
        toButton.isSelected = false
        fromButton.isSelected = true

        if self.calendarHeightConstraint.constant == 0 {
            self.calendarHeightConstraint.constant = 300
            self.calendarBGView.isHidden = false
            noDataView.isHidden = true
        }else{
            self.calendarHeightConstraint.constant = 0
            self.calendarBGView.isHidden = true
            
        }
    }
    @IBAction func toBtnTapped(_ sender: UIButton) {
        toDateArrowImg.isHidden = false
        fromDateArrowImg.isHidden = true
        fromButton.isSelected = false
        toButton.isSelected = true

        if self.calendarHeightConstraint.constant == 0 {
            self.calendarHeightConstraint.constant = 300
            self.calendarBGView.isHidden = false
            noDataView.isHidden = true
//            self.calendar.minimumDate = selecetdFromDate
        }else{
            
            self.calendarHeightConstraint.constant = 0
            self.calendarBGView.isHidden = true
            
        }
    }
    @IBAction func moreButtonTapped(_ sender: UIButton){
        
        let senderPosition  = sender.convert(CGPoint.zero, to: orderListTableView)
        
        let indexPath =  orderListTableView.indexPathForRow(at:senderPosition)
        
        var s = DOEOrder.init(Orderid: 0,Entered: "", PONumber: "", Position: "", Name: "",StartDate: "", EndDate: "", Bill: "", Pay: "", TotalOrderPoAmount: "", CurrentAmountInvoiced: "", OutStandingPOBalance: "", UnbilledTsRevenue: "",ProjPoBalance: "" ,willShow: "")
        
        if isSearching == true{
            s = filteredDataArray[(indexPath?.row)!] as! DOEOrder
        }else{
            s = orderDataArray[(indexPath?.row)!] as! DOEOrder

        }
        
        let  oObj:DOEOrder = s
        
        let willShow = oObj.willShow
        if willShow == "0" {
            oObj.willShow = "1"
        }else{
            oObj.willShow = "0"
        }
        if isSearching == true{
            filteredDataArray.replaceObject(at: (indexPath?.row)!, with: oObj)
        }else{
            orderDataArray.replaceObject(at: (indexPath?.row)!, with: oObj)

        }
         orderListTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Calendar Methods
      
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int
    {
        
        //        let eventDate = self.dateFormatter.string(from: date)
        return 0
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        
        //        let key = self.dateFormatter.string(from: date)
        
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        self.calendarHeightConstraint.constant = 0
        self.calendarBGView.isHidden = true
        self.view.layoutIfNeeded()
        
        print("did select date \(self.dateFormatter.string(from: date))")
        orderDataArray.removeAllObjects()
        filteredDataArray.removeAllObjects()
        if fromButton.isSelected {
            selecetdFromDate = date
            resultFromDate = self.dateFormatter.string(from: date)
            fromButton.setTitle(resultFromDate, for: .normal)
            fromButton.isSelected = false
            resultToDate = ""
        }else if toButton.isSelected{
            selecetdToDate = date
            resultToDate = self.dateFormatter.string(from: date)
            toButton.isSelected = false
        }
        toButton.setTitle(resultToDate, for: .normal)
       
        let compare = describeComparison(date1: selecetdFromDate, date2: selecetdToDate)
        print(compare)
        if compare ==  "date1 > date2"{
            if resultToDate.count == 0{
                
            }else{
                
                self.navigationController?.view.makeToast("Start date should be less than end date", duration: 1.5, position: .bottom, title: "", image: nil)
            }
         }else{
            if resultFromDate.count > 0 && resultToDate.count > 0{
                self.getHistoricOrdersOnDate(StartDate:resultFromDate, EndDate: resultToDate)
                
            }
         }

        
//        if resultFromDate.count > 0 && resultToDate.count > 0{
//            self.getHistoricOrdersOnDate(StartDate:resultFromDate, EndDate: resultToDate)
//        }
        
        orderListTableView.reloadData()
        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
//        if fromButton.isSelected {
//
//            resultFromDate = self.dateFormatter.string(from: calendar.currentPage)
//
//        }else{
//
//            resultToDate = self.dateFormatter.string(from: calendar.currentPage)
//
//        }
//        self.calendar.select(calendar.currentPage)
//        //        self.getHistoricOrdersOnDate(StartDate: resultFromDate, EndDate: resultToDate)
//        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    //    public func maximumDate(for calendar: FSCalendar) -> Date {
    //        if fromButton.isSelected {
    //            return selecetdFromDate
    //        }
    //        return Date()
    //
    //    }
    
    //function to get date
//    func getFormattedDate(string: String) -> String{
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // This formate is input formated .
//        let formateDate = dateFormatter.date(from: string)!
//        dateFormatter.dateFormat = dateFormat // Output Formated
//        return dateFormatter.string(from: formateDate)
//    }
//
    
    
    deinit {
        print("\(#function)")
    }
    
    //MARK: TABLEVIEW DELEGATE & DATASOURCE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        if isSearching == true{
           return filteredDataArray.count
        }
        

        return orderDataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:DOEOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DOEOrderTableViewCellIdentifier") as! DOEOrderTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        var s = DOEOrder.init(Orderid: 0,Entered: "", PONumber: "", Position: "", Name: "",StartDate: "", EndDate: "", Bill: "", Pay: "", TotalOrderPoAmount: "", CurrentAmountInvoiced: "", OutStandingPOBalance: "", UnbilledTsRevenue: "",ProjPoBalance: "" ,willShow: "")
        
        if isSearching == true{
            s = filteredDataArray[(indexPath.row)] as! DOEOrder
        }else{
            s = orderDataArray[(indexPath.row)] as! DOEOrder
            
        }
        
        let  oObj:DOEOrder = s
        
        let startEndDate =  self.getFormattedDate(string: oObj.StartDate!)+" - "+self.getFormattedDate(string: oObj.EndDate!)
        
        cell.lblOrderNum.text =  "Order#: "+"\(oObj.Orderid!)"
        cell.lblStartEndDate.text = startEndDate
        cell.lblPay.text = oObj.Pay
        cell.lblBill.text = oObj.Bill
        cell.lblDateEntered.text = self.getFormattedDate(string: oObj.Entered!)
        cell.lblName.text = oObj.Name
        cell.lblPONum.text = oObj.PONumber
        cell.lblProjPoBalance.text = oObj.ProjPoBalance
        cell.lblUnbilledTSRevenue.text = oObj.UnbilledTsRevenue
        cell.lblCurrentAmtInvoiced.text = oObj.CurrentAmountInvoiced
        cell.lblOutSTandingPOBalance.text = oObj.OutStandingPOBalance
        cell.lblTotalOrderPOAmt.text = oObj.TotalOrderPoAmount
        cell.lblPosition.text = oObj.Position
        cell.lblOrderNum.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.showMoreButton.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
        let willShow = oObj.willShow
        
        if willShow == "0" {
            cell.bgSubView.isHidden = true
            cell.showMoreButton.setTitle("More", for: .normal)
            
        }else{
            cell.bgSubView.isHidden = false
            cell.showMoreButton.setTitle("Less", for: .normal)
            
        }
        
        cell.showMoreButton.addTarget(self, action:#selector(self.moreButtonTapped), for: .touchUpInside)
        
        cell.bgView.layer.borderColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1).cgColor
        cell.bgView.layer.borderWidth = CGFloat(1)
        cell.bgView.layer.cornerRadius = CGFloat(2)
        
        return cell
        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
   
        var s = DOEOrder.init(Orderid: 0,Entered: "", PONumber: "", Position: "", Name: "",StartDate: "", EndDate: "", Bill: "", Pay: "", TotalOrderPoAmount: "", CurrentAmountInvoiced: "", OutStandingPOBalance: "", UnbilledTsRevenue: "",ProjPoBalance: "" ,willShow: "")
        
        if isSearching == true{
            s = filteredDataArray[(indexPath.row)] as! DOEOrder
        }else{
            s = orderDataArray[(indexPath.row)] as! DOEOrder
            
        }
        
        let  oObj:DOEOrder = s
        
        let willShow = oObj.willShow
        if willShow == "0" {
            return 90
            
        }
        return 360
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        var s = DOEOrder.init(Orderid: 0,Entered: "", PONumber: "", Position: "", Name: "",StartDate: "", EndDate: "", Bill: "", Pay: "", TotalOrderPoAmount: "", CurrentAmountInvoiced: "", OutStandingPOBalance: "", UnbilledTsRevenue: "",ProjPoBalance: "" ,willShow: "")
        
        if isSearching == true{
            s = filteredDataArray[(indexPath.row)] as! DOEOrder
        }else{
            s = orderDataArray[(indexPath.row)] as! DOEOrder
            
        }
        let  oObj:DOEOrder = s
        
        let orderid = oObj.Orderid
        if orderid == 0{
//            self.ShowAlertMessage(message: "No Details Found", title: "")
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message:  "No Details Found", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

        }else{
            self.pushToDetailsPage(Orderid: orderid!)
        }
    }
    func pushToDetailsPage(Orderid : Int){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOEOrderDetailsViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOEOrderDetailsSegue") as! DOEOrderDetailsViewController
        nextViewController.OrderID = Orderid
            nextViewController.isFromHistoricalOrder = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        //
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func getHistoricOrdersOnDate(StartDate:String, EndDate:String) {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            
            //userid as String
            let params :[String:String] = ["EndDate":EndDate,"ClientID":clientID,"PONumber":"","StartDate":StartDate,"Command" : "Refresh"]
            print(params)
            RestAPI.getHistoricOrders(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
        }else{
            
             self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

        }
        
    }
    
    func getResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            noDataView.isHidden = false
            lblNoData.text = response as? String
//            self.ShowAlertMessage(message: response as! String, title: "")
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

        }else{
            
            var object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
                
                let dataArray = object["DoeOrderGridList"].array
                orderDataArray .removeAllObjects()
                filteredDataArray.removeAllObjects()
                fileName = object["PdfPath"].stringValue
                
                if dataArray != nil{
                    
                    for dict in dataArray! {
                        
                        resultFromDate = self.getFormattedDate(string: object["StartDate"].stringValue)
                        resultToDate = self.getFormattedDate(string: object["EndDate"].stringValue)
                        fromButton.setTitle(resultFromDate, for: .normal)
                        toButton.setTitle(resultToDate, for: .normal)
                        let order = DOEOrder.init(Orderid: dict["Orderid"].intValue,
                                                  Entered: dict["Entered"].stringValue,
                                                  PONumber: dict["PONumber"].stringValue, Position:dict["Position"].stringValue, Name:dict["Name"].stringValue,
                                                  StartDate:dict["StartDate"].stringValue, EndDate:dict["EndDate"].stringValue,
                                                  Bill:dict["Bill"].stringValue,
                                                  Pay:dict["Pay"].stringValue, TotalOrderPoAmount:dict["TotalOrderPoAmount"].stringValue, CurrentAmountInvoiced:dict["CurrentAmountInvoiced"].stringValue, OutStandingPOBalance:dict["OutStandingPOBalance"].stringValue, UnbilledTsRevenue:dict["UnbilledTsRevenue"].stringValue,
                                                  ProjPoBalance: dict["ProjPoBalance"].stringValue,
                                                  willShow: "0")
                        
                        orderDataArray.add(order)
                        orderListTableView.reloadData()
                    }
                    
                }else{
                    orderListTableView.reloadData()
                    
                }
                if orderDataArray.count == 0 {
                    noDataView.isHidden = false
                    var message = object["Message"].stringValue
                    
                    if message.count == 0 {
                        
                        message = "No record found"
                        
                    }
                    lblNoData.text = message
                    
                    resultFromDate = self.getFormattedDate(string: object["StartDate"].stringValue)
                    resultToDate = self.getFormattedDate(string: object["EndDate"].stringValue)
                    fromButton.setTitle(resultFromDate, for: .normal)
                    toButton.setTitle(resultToDate, for: .normal)

                }else{
                    noDataView.isHidden = true
                }
 
                
            }else{
                lblNoData.isHidden = false
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
    }
    //MARK: - UISEARCHBAR DELEGATE METHODS
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        //        isSearching = false
        
        searchBar.endEditing(false)
        
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) // called when text changes (including clear)
    {
        isSearching = true
        
        //////////////////**********************SEARCH**********///////////////
        
        filteredDataArray.removeAllObjects()
        if searchText.count > 0
        {
            var found = false
            
            
            for s in orderDataArray{
                
                let  oObj:DOEOrder = s as! DOEOrder

                let poNum =   oObj.PONumber?.lowercased()
                    
                    let searchString = searchText.lowercased()
                    
                found = (poNum?.contains(searchString))! || (poNum?.caseInsensitiveCompare(searchString) == ComparisonResult.orderedSame)
                    
                    if found {
                        filteredDataArray.add(oObj)
                    }
                
                
            }
        }
        else
        {
            isSearching = false
            searchBar.endEditing(true)
            
        }
        orderListTableView.reloadData()
        
        /////////////////////******** END OF SEARCH *********//////
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) // called when cancel button pressed
    {
        isSearching = false
        searchBar.endEditing(true)
        
    }
}
