//
//  OrdersViewController.swift
//  EWA
//
//  Created by NFC India on 12/12/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import FSCalendar
import CoreLocation


class OrdersViewController: UIViewController {
    
    
    //reference's of objects
    @IBOutlet weak var ordersTableView: UITableView!
    var assignmentListData:JSON = JSON.null
    var assignmentsList = [eAssignments]()
    var blurEffect = UIBlurEffect()
    var blurEffectView = UIVisualEffectView()
    let dateFormat = "MM/dd/yyyy"
    var timeObject:JSON = JSON.null
    var order_ID  = String()
    var loginTime = String();var lunchOutTime = String();var lunchInTime = String();var logoutTime = String();var lunchOutTime2 = String();var lunchInTime2 = String()
    var latt = String()
    var logn = String()
    var ETCcheck = String()
    var typeOfAction = String()
    var addressToSend = String()
    var isFrom = String()
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if isFrom == "NewDay" {
//            self.navigationItem.setHidesBackButton(true, animated: false)
//
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // configure_Calender()
        self.title = "Orders"
        self.getAssignmentsApiListData()
    }
    
    
    // response from the server for getAssignmentsApiListData()
    func getAssignmentsApiListData()
    {
        
        print("****** assignmentListData data is ************\n",assignmentListData)
        
        if assignmentListData["LstETimeClockCandOrders"].arrayValue.count>0
        {//48,49,53
            ordersTableView.backgroundColor = UIColor.init(hexString: "F8F9FD")
            for assin in 0..<assignmentListData["LstETimeClockCandOrders"].arrayValue.count
            {
                let eAss = eAssignments.init(eId:assignmentListData["LstETimeClockCandOrders"][assin]["Order_id"].stringValue, eName:assignmentListData["LstETimeClockCandOrders"][assin]["Company_name"].stringValue, eDesc:assignmentListData["LstETimeClockCandOrders"][assin]["OrderSchedule"].stringValue, ePosition:assignmentListData["LstETimeClockCandOrders"][assin]["position"].stringValue,
                                             eClient_Id:assignmentListData["LstETimeClockCandOrders"][assin]["Client_id"].stringValue,
                                             eCand_Id:assignmentListData["LstETimeClockCandOrders"][assin]["cand_id"].stringValue,isETCcheck:assignmentListData["LstETimeClockCandOrders"][assin]["isETCcheck"].intValue, IsMultipleLunch: assignmentListData["LstETimeClockCandOrders"][assin]["IsMultipleLunch"].stringValue)
                assignmentsList.append(eAss)
            }
        }
        else
        {
            ordersTableView.backgroundColor = .clear
        }
        
        ordersTableView.reloadData()
    }
    
    func convertDateStringToDefaultDate(dateString: String,formatString: String) -> Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = formatString//"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        let date = dateFormatter.date (from: dateString)
        return date!
    }
    
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    func addBoldText(fullString: NSString, boldPartsOfString: Array<NSString>, font: UIFont!, boldFont: UIFont!) -> NSAttributedString {
        let nonBoldFontAttribute = [NSAttributedString.Key.font:font!]
        let boldFontAttribute = [NSAttributedString.Key.font:boldFont!]
        let boldString = NSMutableAttributedString(string: fullString as String, attributes:nonBoldFontAttribute)
        for i in 0 ..< boldPartsOfString.count {
            boldString.addAttributes(boldFontAttribute, range: fullString.range(of: boldPartsOfString[i] as String))
        }
        return boldString
    }
    
    //MARK:- Update Assignment
    func updateAssignment()
    {
        
        if ConnectionCheck.isConnectedToNetwork()
        {
            if checkLocationPermission() {
                getLocationDetails()
                ServerService.showActivityIndicatory(uiView:self.view)
                if loginTime.count>0 {
                    loginTime = currentDateNTime()
                }
                if lunchOutTime.count>0{
                    lunchOutTime = currentDateNTime()
                }
                if lunchInTime.count>0 {
                    lunchInTime = currentDateNTime()
                }
                if logoutTime.count>0{
                    logoutTime = currentDateNTime()
                }
                if ETCcheck == "0" {
                    latt = ""
                    logn = ""
                }
                let params = [
                    "CandidateId" : UserDefaults.standard.object(forKey:"cID") as! String,
                    "OrderId" : order_ID,
                    "latitude":latt,
                    "longitude":logn,
                    "entereddate":getToday(),
                    "Mode" : typeOfAction,
                    "Log_in": loginTime,
                    "Lunch_out":lunchOutTime,
                    "Lunch_in":lunchInTime,
                    "Log_out":logoutTime,
                    "ETCcheck" : ETCcheck,
                    "Address": self.addressToSend,
                    "Lunch_out2":lunchOutTime2,
                    "Lunch_in2":lunchInTime2, "DeviceId": "\(UIDevice.current.identifierForVendor!.uuidString.stripped)"] as [String : Any]
                print(params)
                
                ServerService.updateAssignment(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.getTimeUpdatedData(response:))
            }
            else {
                askPermission()
            }
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            
        }
        
        
    }
    
    
    //MARK:- Getting User Location Co-ordinates
    func getLocationDetails(){
        EMALocationManager.shared.requestLocationAtOnce()
        if UserDefaults.standard.value(forKey: "CurrentLocation") != nil {
        let currentLocationCoordi = UserDefaults.standard.value(forKey: "CurrentLocation") as! [String: CLLocationDegrees]
        print("Latitude \(String(describing: currentLocationCoordi["latitude"]!))")
        print("Longitude \(String(describing: currentLocationCoordi["longitude"]!))")
        latt = String(describing: currentLocationCoordi["latitude"]!)
        logn = String(describing: currentLocationCoordi["longitude"]!)
        // print(getAddressFromLatLon(pdblLatitude: String(describing: currentLocationCoordi["latitude"]!), withLongitude: String(describing: currentLocationCoordi["longitude"]!)))
    }
    else {
        EMALocationManager.shared.requestLocationAtOnce()
        if let recentLocation = EMALocationManager.shared.currentLocation?.coordinate, EMALocationManager.shared.currentLocation?.horizontalAccuracy ?? -1 >= 0 {
            latt = String(describing: recentLocation.latitude)
            logn = String(describing: recentLocation.longitude)
        }
       
    }
    }
    func getToday()-> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = "MM/dd/yyyy"
        let result = formatter.string(from: date)
        return result
    }
   
    
    // response from the server
    func getTimeUpdatedData(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        timeObject = response as! JSON
        print("****** timeObject data is ************\n",timeObject)
        
        if timeObject["Status"].intValue == 1 {
            
            if timeObject["SuccessStatus"].intValue == 1 {
                
                let title = timeObject["Message"].stringValue
                let titleColor = ServerService.alertGreen
                let titleBg = ServerService.alertGreenBg
                let buttonBg = ServerService.alertGreen
                let buttonTitleColor = UIColor.white
                
                self.showCustomAlertWithOkButton(title: title, titleColor: titleColor, titleBackgroundColor: titleBg, buttonBackgroundColor: buttonBg, buttonTitleColor: buttonTitleColor, targetViewControllerIdentifier: nil) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            if timeObject["SuccessStatus"].intValue == 0 {
                
                let title = timeObject["Message"].stringValue
                let titleColor = ServerService.alertRed
                let titleBg = ServerService.alertRedBg
                let buttonBg = ServerService.alertRed
                let buttonTitleColor = UIColor.white
                
                self.showCustomAlertWithOkButton(title: title, titleColor: titleColor, titleBackgroundColor: titleBg, buttonBackgroundColor: buttonBg, buttonTitleColor: buttonTitleColor, targetViewControllerIdentifier: nil) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
//            let alert = UIAlertController.init(title: timeObject["Message"].stringValue, message: "", preferredStyle: .alert)
//            
//            let action1 = UIAlertAction.init(title: "Ok", style: .default) { (action) in
//                
//                self.navigationController?.popViewController(animated: true)
//            }
//            alert.addAction(action1)
//            self.present(alert, animated: true, completion: nil)
        }
        else {
            ServerService.ShowAlertMessage(ErrorMessage:"", title: timeObject["Message"].stringValue, view:self)
        }
    }
}

//END OF CLASS



//EXTENSIONS

extension OrdersViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return assignmentsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"orderCell") as! OdersTableViewCell
        if assignmentsList.count > 0 {
        cell.orderIdLabel.text = assignmentsList[indexPath.row].eId
        cell.divNameLabel.text = assignmentsList[indexPath.row].eName
        cell.positionLabel.text = assignmentsList[indexPath.row].ePosition
        let desc = assignmentsList[indexPath.row].eDesc
        let finalstr = desc.replacingOccurrences(of: ",", with: "\n")
        let normalFont = UIFont.systemFont(ofSize: 12)
        let boldSearchFont = UIFont.boldSystemFont(ofSize: 12)
        cell.scheduleLabel.attributedText = addBoldText(fullString: finalstr as NSString, boldPartsOfString: ["Mon", "Tue", "Wed", "Thu","Fri","Sat","Sun","Mon", "Tue", "Wed", "Thu","Fri","Sat","Sun","Mon", "Tue", "Wed", "Thu","Fri","Sat","Sun","Mon", "Tue", "Wed", "Thu","Fri","Sat","Sun","Mon", "Tue", "Wed", "Thu","Fri","Sat","Sun","Mon", "Tue", "Wed", "Thu","Fri","Sat","Sun"], font: normalFont, boldFont: boldSearchFont)
        cell.scheduleLabel.attributedText = addBoldText(fullString: finalstr as NSString, boldPartsOfString: ["Mon", "Tue", "Wed", "Thu","Fri","Sat","Sun","Mon", "Tue", "Wed", "Thu","Fri","Sat","Sun","Mon", "Tue", "Wed", "Thu","Fri","Sat","Sun","Mon", "Tue", "Wed", "Thu","Fri","Sat","Sun","Mon", "Tue", "Wed", "Thu","Fri","Sat","Sun","Mon", "Tue", "Wed", "Thu","Fri","Sat","Sun"], font: normalFont, boldFont: boldSearchFont)
        }
        // cell.scheduleLabel.text = assignmentsList[indexPath.row].eDesc
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if assignmentsList.count > 0{
        let desc = assignmentsList[indexPath.row].eDesc
        let cellHeight =  Constants.calculateHeight(inString:desc.replacingOccurrences(of: ",", with: "\n"), width:self.view.bounds.size.width-30)
        return 125+cellHeight
        }else {
            return 0
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3.0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFrom == "NewDay" {
            
          
            NotificationCenter.default.post(name: Notification.Name("updatePopView"), object: nil)
            Constants.eTimeClockOrderID = assignmentsList[indexPath.row].eId
            Constants.ETCcheck = "\(assignmentsList[indexPath.row].isETCcheck)"
            Constants.ETCIsMultipleLunch = "\(assignmentsList[indexPath.row].IsMultipleLunch)"
            self.navigationController?.popViewController(animated: true)
        }
        else {
        self.order_ID = assignmentsList[indexPath.row].eId
        self.ETCcheck = "\(assignmentsList[indexPath.row].isETCcheck)"
        updateAssignment()
        }
    }
    
    
}

/*
 
 //Calender Extension
 extension OrdersViewController:FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance
 {
 
 func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
 
 //chnaging the dateFormat
 let date = date
 let formatter = DateFormatter()
 formatter.dateFormat = "MM/dd/yyyy"
 let result = formatter.string(from: date)
 //dateLabel.text = result
 blurEffectView.removeFromSuperview()
 
 }
 func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int
 {
 
 return 0
 }
 func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
 
 return nil
 }
 func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, selectionColorFor date: Date) -> UIColor? {
 
 let formatter = DateFormatter()
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
 
 
 func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
 
 let formatter = DateFormatter()
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
 func getDayOfWeek(today:String)->String {
 
 let formatter  = DateFormatter()
 formatter.dateFormat = dateFormat
 let todayDate = formatter.date(from: today)!
 let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
 let myComponents = myCalendar.components(.weekday, from: todayDate)
 let weekDay = myComponents.weekday
 var day = ""
 switch weekDay {
 case 1?:
 day = "Sunday"
 case 2?:
 day = "Monday"
 case 3?:
 day = "Tuesday"
 case 4?:
 day = "Wednesday"
 case 5?:
 day = "Thursday"
 case 6?:
 day = "Friday"
 case 7?:
 day = "Saturday"
 default:
 day = ""
 }
 return day
 }
 }
 */
