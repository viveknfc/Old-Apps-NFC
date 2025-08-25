//
//  WeeklyStaffingViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 14/12/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON
import FSCalendar
import WebKit

class WeeklyStaffingViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource, WKNavigationDelegate {
    
    @IBAction func DateBtnTapped(_ sender: UIButton){
         self.showCalendar()
    }
    @IBOutlet weak var DateButton: UIButton!

    @IBOutlet weak var selectdateTxtxField: UITextField!
    @IBOutlet weak var calendarButton: UIButton!
    var webView: WKWebView!
    var fileName = ""
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var infoBtn: UIButton!
//    @IBOutlet weak var SuperViewHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var baseScrollView: UIScrollView!
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var DateView: UIView!
     @IBOutlet weak var webBGView: UIView!

    var  dataArray = NSMutableArray()
    var  dayArray = NSMutableArray()
    var customCalendarView = CalendarView()
var WeeklyStaffing = ""
//    @IBOutlet weak var calendar: FSCalendar!
     var resultDate = String()
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter
    }()
    
    @objc override func appWillEnterForeground(){
        print("appWillEnterForeground Division")
 
        if self.WeeklyStaffing == "Grid"{
            if dataArray.count == 0{
                self.getTodaysSchdule()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarButton.isSelected = true
 
        DateView.layer.borderColor = UIColor.lightGray.cgColor
        DateView.layer.borderWidth = 1
    
        DateView.backgroundColor = UIColor.white
      //  let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
        
//        var headerFrame = TableHeaderView.frame
//        headerFrame.size.height = 657 + 80 + 400
//        TableHeaderView.frame = headerFrame
//        tableview.tableHeaderView = TableHeaderView
//        tableview.reloadData()

        var hFrame = self.HeaderView.frame
        
        if  self.WeeklyStaffing == "Grid"{
             self.getTodaysSchdule()
            hFrame.size.height = 120
        }else{
            self.getTodaysSchdule()
            
             self.addWKWebView()
            hFrame.size.height = UIScreen.main.bounds.size.height - 60

        }
        self.HeaderView.frame = hFrame
         listTableView.tableHeaderView = self.HeaderView
        noDataView.isHidden = true
        noDataView.backgroundColor = UIColor(hexString:danger_background_Color)
        lblNoData.textColor = UIColor(hexString:danger_Color)
        self.setupCalendarView()

        
    }
    func updateHeaderviewWithHeight(height: CGFloat){
        var hFrame = self.HeaderView.frame
        hFrame.size.height = height
        self.HeaderView.frame = hFrame
        listTableView.tableHeaderView = self.HeaderView

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titlelbl.text = "Weekly Staffing Schedule"
        
    }
    func setupCalendarView(){
        customCalendarView = Bundle.main.loadNibNamed("CalendarView", owner: self, options: nil)?[0] as! CalendarView
        customCalendarView.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
        customCalendarView.setupCalendar()
        customCalendarView.calendar.delegate = self
        customCalendarView.calendar.dataSource = self
        
    }
    @IBAction func infoBtnAction(_ sender: Any)
    {
        let attStr = NSAttributedString()
        
        self.showCustomAlert(Title: "Note", attMessage: attStr , message: "If you would like  to see Weekly Staffing Schedule for a different week, please select the week ending date." , okBtnTitle: "OK", cancelBtnTitle: "", type: info_Text,isAttributed: false)
        
    }
    
    //MARK:  WEBVIEW METHODS
    
    func addWKWebView(){
        
 
        webView = WKWebView()
        
        webView.frame = CGRect(x:0,y:0,width:webBGView.frame.size.width,height:webBGView.frame.size.height)
        
        webView.navigationDelegate = self
        
        webBGView.addSubview(webView)
        
        setupWKWebViewConstraints()
        
     }
    func setupWKWebViewConstraints() {
        
        let paddingConstant:CGFloat = 5.0
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        webView.topAnchor.constraint(equalTo: webBGView.topAnchor, constant: paddingConstant).isActive = true
        webView.bottomAnchor.constraint(equalTo: webBGView.bottomAnchor, constant: -paddingConstant).isActive = true
        webView.leadingAnchor.constraint(equalTo: webBGView.leadingAnchor, constant: paddingConstant).isActive = true
        webView.trailingAnchor.constraint(equalTo: webBGView.trailingAnchor, constant: -paddingConstant).isActive = true
    }
    func loadWebContentView(){
         JustHUD.shared.showInView(view: (self.view)!)
        if fileName.count == 0{
            
        }else{
            let urlString:String = fileName
            let url:URL = URL(string: urlString)!
            let urlRequest:URLRequest = URLRequest(url: url)
            webView.load(urlRequest)
            
        }
        
    }
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let _ = object as? WKWebView else { return }
        guard let keyPath = keyPath else { return }
        guard let change = change else { return }
        
        switch keyPath {
        case "loading":
            if let val = change[NSKeyValueChangeKey.newKey] as? Bool {
                //do something!
                if val ==  true{
                    print("true")
                }else{
                    print("false")
                    
                }
            }
        default:
            break
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        print("didFinish")
        JustHUD.shared.hide()
     }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        JustHUD.shared.hide()
        print("didFail")
        
         print(error.localizedDescription)
    }
    
    //MARK: END OF WEBVIEW
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Calendar View
    
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
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
//        self.calendarHeightConstraint.constant = bounds.height
//        self.view.layoutIfNeeded()
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
        
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        
        let todayDate = date
        let todayString = formatter.string(from: todayDate)
        let todaysDay = self.getDayOfWeek(today: todayString)
        
        if todaysDay == "Sunday" {
            dataArray.removeAllObjects()
            resultDate = self.dateFormatter.string(from: date)
            selectdateTxtxField.text = String(format:" %@",resultDate)
            
 
            if self.WeeklyStaffing == "Grid"{ //DivisionId == "50" ||  DivisionId == "117" {
                self.getDataOnDate(date: resultDate,isPDF: false)
                listTableView.reloadData()
                
            }else{
                self.getDataOnDate(date: resultDate,isPDF: true)
//                 self.loadWebContentView()
            }
        }else{
            //            self.navigationController?.view.makeToast("Please select weekend", duration: 1.5, position: .bottom, title: "", image: nil)
        }
        self.hideCalendar()
        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        //        resultDate = self.dateFormatter.string(from: calendar.currentPage)
        ////        self.calendar.select(calendar.currentPage)
        //        resultDate = self.dateFormatter.string(from: calendar.currentPage)
        //         selectdateTxtxField.text = String(format:" %@",resultDate)
        
        //        self.getActiveOrdersOnDate(date: self.dateFormatter.string(from: calendar.currentPage))
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    
    
    
    deinit {
        print("\(#function)")
       
        
    }
    
    func getTodaysSchdule(){
        
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = dateFormat
        
        var result = ""
        
        let todayDate = Date()
        let todayString = formatter.string(from: todayDate)
        let todaysDay = self.getDayOfWeek(today: todayString)
        
        if todaysDay == "Sunday" {
            result = formatter.string(from: todayDate)
        }else{
            let languageCode = Locale.current.languageCode
            if languageCode == "en"{
                let date = Date().endOfWeek
                let  endOfWeekString = formatter.string(from: date)
                result =  endOfWeekString
            }else{
                let date = Date().sundayOfWeek
                let  endOfWeekString = formatter.string(from: date)
                result =  endOfWeekString//self.getNextSunday(dateString: endOfWeekString)
                
            }
            
        }
//        let date = self.convertDateStringToDefaultDate(dateString: result, formatString: dateFormat)
//        calendar.select(date)
        
 
        if self.WeeklyStaffing == "Grid"{ //DivisionId == "50" ||  DivisionId == "117" {
            self.getDataOnDate(date: "",isPDF: false)
         
        }else{
            self.getDataOnDate(date: "",isPDF: true)
            
        }
        selectdateTxtxField.text = ""//String(format:" %@",result)
        
        
    }
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
//    {
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM/dd/yyyy"
//        let pickedDateString   = self.ConvertDateToRequiredString(date: date)
//        print("did select date \(self.dateFormatter.string(from: date))")
//        //        let result = self.dateFormatter.string(from: date)
//
//         formatter.dateFormat = dateFormat
//
//        let todayDate = date
//        let todayString = formatter.string(from: todayDate)
//        let todaysDay = self.getDayOfWeek(today: todayString)
//
//        if todaysDay == "Sunday" {
//            dataArray.removeAllObjects()
//            resultDate = self.dateFormatter.string(from: date)
//            selectdateTxtxField.text = String(format:" %@",resultDate)
//
//            let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
//
//            if DivisionId == "50" ||  DivisionId == "117" {
//                self.getDataOnDate(date: resultDate,isPDF: false)
//                listTableView.reloadData()
//
//            }else{
//                self.getDataOnDate(date: resultDate,isPDF: true)
//                listTableView.isHidden = true
//                self.loadWebContentView()
//            }
//        }else{
//            //            self.navigationController?.view.makeToast("Please select weekend", duration: 1.5, position: .bottom, title: "", image: nil)
//        }
//
//        customCalendarView.removePickerViewFromSuperView()
//
//
//    }
    @IBAction func calendarBtnAction(_ sender: UIButton)
    {
        self.showCalendar()
    }
    //MARK: TableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count //dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:WeeklyStaffingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeeklyStaffingTableViewCellIdentifier") as! WeeklyStaffingTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let s = dataArray[indexPath.row]
        let  oObj:Schdule = s as! Schdule
        let empName =   oObj.Candname
        dayArray = oObj.dayArray!
        cell.lblEmpName.text = empName
        cell.dayColView.dataSource = self
        cell.dayColView.delegate = self
        
        if UIScreen.main.bounds.size.width <= 320{
            
            cell.colViewTrailingConstraint.constant = 129
            cell.layoutIfNeeded()
        }else if UIScreen.main.bounds.size.width <= 375{
            
            cell.colViewTrailingConstraint.constant = 177
            
            cell.layoutIfNeeded()
            
        }
        
        cell.dayColView.reloadData()
        cell.bgView.layer.borderColor = UIColor.lightGray.cgColor
        cell.bgView.layer.borderWidth = 1
        
        return cell
        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let s = dataArray[indexPath.row]
        let  oObj:Schdule = s as! Schdule
        let days = oObj.dayArray!
        
        
        let modelName = UIDevice.current.modelName
        if modelName.contains("iPad") {
            //
            
            if days.count > 4{
                
                return max(100 , CGFloat( 40 + (days.count * 40)/2))
                
            }
            return  CGFloat(100)
            
        }
        //left alligned and will show in single line
        let screenWidth = UIScreen.main.bounds.size.width
        //        let screenheight = UIScreen.main.bounds.size.height
        
        if screenWidth <= 375{
            
            
            return CGFloat( 25 + ((days.count + 1) * 38))
            
            
        }else{
            
            
            if self.view.bounds.height <= 568{
                
                return CGFloat( 25 + ((days.count + 1) * 38))
            }
            if screenWidth >= 414{
                if days.count > 4{
                    if days.count/2 == 0{
                        return CGFloat( 25 + ((days.count + 1) * 40)) - 120
                    }else if days.count == 7{
                        return CGFloat( 25 + ((days.count + 1) * 40)) - 100
                    }
                    return CGFloat( 25 + ((days.count + 1) * 40)) - 90
                }else if days.count == 4{
                    return CGFloat( 25 + ((days.count + 1) * 40)) - 80
                }
            }
            if days.count > 4{
                return CGFloat( 25 + ((days.count + 1) * 38)) - 125
            }
            return CGFloat( 25 + ((days.count + 1) * 38))
        }
        
        
        
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let s = dataArray[indexPath.row]
        let  oObj:Schdule = s as! Schdule
        let orderID = String(format:"%d",oObj.OrderId!)
        let candID = String(format:"%d",oObj.CandId!)
        
        if  oObj.OrderId  == 0{
        }else{
            self.pushToDetailsPage(orderid: orderID, candID: candID)
        }
    }
    // MARK: - SERVER CALL
    
    
    func getDataOnDate(date:String,isPDF: Bool) {
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            let defaults = UserDefaults.standard
            
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let DivisionId = String(format:"%d", defaults.integer(forKey: "DivisionId"))
            
            //userid as String
            let params :[String:String] = ["ContactId":ContactId,"ClientID":clientID,"DivisionId":DivisionId,"WeekEnding":date]
            print(params)
            
            if isPDF{
                RestAPI.getWeeklyStaffingSchdulePDF(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getPDFResponse(response:))
                
            }else{
                
                RestAPI.getWeeklyStaffingSchdule(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
                
            }
        }else{
            
            //            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
        
    }
    func hideCalendar(){
         self.customCalendarView.removePickerViewFromSuperView()
    }
    func getPDFResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        dataArray.removeAllObjects()
         self.view.layoutIfNeeded()
        
        print(response)
        if response is String{
             noDataView.isHidden = false
            //            self.ShowAlertMessage(message: response as! String, title: "")
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            if object["WeekEnding"].null == nil  {
                
                let startDate = object["WeekEnding"].stringValue
                if selectdateTxtxField.text?.count == 0  {
                    resultDate = startDate
                    selectdateTxtxField.text = startDate
                }
            }
            
            if object["MessageStatus"].intValue == 1
            {
                
              
                
                fileName = object["FilePath"].stringValue
                
                if fileName.count == 0{
                    var msg  = object["Message"].stringValue
                    if msg.count == 0{
                        msg = "No records found"
                    }
                    lblNoData.text = msg
                    webView.isHidden = true
                    noDataView.isHidden = false
                    
                }else{
                    noDataView.isHidden = true
                    webView.isHidden = false

                    self.loadWebContentView()
                }
            }else{
                webView.isHidden = true
                
                noDataView.isHidden = false
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                if message == "No Record Found"{
                    
                }else{
                    lblNoData.text = message
                    //                    self.ShowAlertMessage(message: message, title: "")
                }
            }
        }
    }
    func getResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        dataArray.removeAllObjects()
//        self.calendarHeightConstraint.constant = 0
//        self.calendar.isHidden = true
//        self.view.layoutIfNeeded()
        
        print(response)
        if response is String{
            lblNoData.text = response as? String
            noDataView.isHidden = false
            
            //            self.ShowAlertMessage(message: response as! String, title: "")
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            if object["WeekEnding"].null == nil  {
                
                let startDate = object["WeekEnding"].stringValue
                if selectdateTxtxField.text?.count == 0  {
                    resultDate = startDate
                    selectdateTxtxField.text = startDate
                }
            }
            
            if object["MessageStatus"].intValue == 1
            {
                
                let datas = object["WeeklyStaffingList"].array
                
                
                
                
                for dict in datas! {
                    let days = NSMutableArray()
                    days.removeAllObjects()
                    if dict["Monday"].stringValue.count > 0{
                        
                        let monDict = ["day":"MON","time":dict["Monday"].stringValue]
                        if days.contains(monDict){}else{
                            days.add(monDict)}
                    }
                    if dict["Tuesday"].stringValue.count > 0{
                        
                        let tuesDict = ["day":"TUE","time":dict["Tuesday"].stringValue]
                        if days.contains(tuesDict){}else{
                            days.add(tuesDict)}
                        
                    }
                    if dict["Wednesday"].stringValue.count > 0{
                        
                        let wednesDict = ["day":"WED","time":dict["Wednesday"].stringValue]
                        if days.contains(wednesDict){}else{
                            days.add(wednesDict)}
                        
                    }
                    if dict["Thursday"].stringValue.count > 0{
                        
                        let thursDict = ["day":"THU","time":dict["Thursday"].stringValue]
                        if days.contains(thursDict){}else{
                            days.add(thursDict)}
                    }
                    if dict["Friday"].stringValue.count > 0{
                        
                        let friDict = ["day":"FRI","time":dict["Friday"].stringValue]
                        if days.contains(friDict){}else{
                            days.add(friDict)}
                    }
                    if dict["Saturday"].stringValue.count > 0{
                        
                        let satDict = ["day":"SAT","time":dict["Saturday"].stringValue]
                        if days.contains(satDict){}else{
                            days.add(satDict)}
                    }
                    if dict["Sunday"].stringValue.count > 0{
                        
                        let sunDict = ["day":"SUN","time":dict["Sunday"].stringValue]
                        if days.contains(sunDict){}else{
                            days.add(sunDict)}
                    }
                    
                    let schdule = Schdule.init(OrderId:  dict["OrderId"].intValue, ClientMaster: dict["ClientMaster"].stringValue, Candname: dict["Candname"].stringValue, CandId: dict["CandId"].intValue, dayArray: days)
                    
                    dataArray.add(schdule)
                    listTableView.reloadData()
                }
                if dataArray.count == 0 {
                    lblNoData.text = object["Message"].stringValue
                    noDataView.isHidden = false
                    
                }else{
                    noDataView.isHidden = true
                }
                
                
            }else{
                noDataView.isHidden = false
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                if message == "No Record Found"{
                    
                }else{
                    lblNoData.text = message
                    
                    //                    self.ShowAlertMessage(message: message, title: "")
                }
            }
        }
    }
    func showCalendar(){
        let date = self.convertDateStringToDefaultDate(dateString: selectdateTxtxField.text!, formatString: dateFormat)
        DispatchQueue.main.async(execute: { () -> Void in
            self.customCalendarView.calendar.setCurrentPage(date, animated: true)
            self.customCalendarView.calendar.select(date, scrollToDate: true)
            
        })
        
        self.customCalendarView.showPickerViewOnSuperView(superView: (self.navigationController?.view)!, isPortrait: true)
    }
    //MARK: TEXTFIELD DELEGATE
    //called when 'return' key pressed. return NO to ignore.
     
    public func textFieldDidBeginEditing(_ textField: UITextField){
        textField.resignFirstResponder()
        if (textField.text?.count)! > 0{
            self.showCalendar()
        }else{
             if self.WeeklyStaffing == "Grid"{ //DivisionId == "50" ||  DivisionId == "117" {
                self.getTodaysSchdule()
            }else{
                self.getTodaysSchdule()
            }
        }
        
        
    }
    
    
    //MARK: -UICOLLECTIONVIEW DELEGATE & DATASOURCE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return dayArray.count
        
        return dayArray.count
        
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SchduleCollectionViewCellIdentifier", for: indexPath) as! SchduleCollectionViewCell
        
        cell.backgroundColor = UIColor.white//(red:0.15, green:0.39, blue:0.55, alpha:1.0)
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1.5
        if dayArray.count > indexPath.row{
            let dict = dayArray[indexPath.row] as! NSDictionary
            cell.lblDay.text = dict["day"] as? String
            cell.lblTime.text = dict["time"] as? String
            
        }
        cell.lblDay.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: 167, height: 40)
        
    }
    //Use for interspacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
    }
    
    func pushToDetailsPage(orderid: String, candID: String){
        
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is WeeklyStaffingOrderDetailsViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "WeeklyStaffingOrderDetailsSegue") as! WeeklyStaffingOrderDetailsViewController
            
            nextViewController.OrderID = orderid
            nextViewController.CandId = candID
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
}
