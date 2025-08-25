//
//  EnterTimeSlipDetailViewController.swift
//  CWA
//
//  Created by NFC Solutions on 03/01/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON
import DropDown

enum UIUserInterfaceIdiom : Int {
    case unspecified
    case phone // iPhone and iPod touch style UI
    case pad // iPad style UI
}


class EnterTimeSlipDetailViewController: BaseViewController,UITextFieldDelegate,UITextViewDelegate {
    @IBOutlet var clientNameLabel: UILabel!
    @IBOutlet var orderIdLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var noteTextView: UITextView!
    var orderDetailObject:JSON = JSON.null
    var insertData:JSON = JSON.null
    var weekdays = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
    var activeTextField: UITextField?
    var actfield:UITextField?
    var starTimes = NSMutableArray()
    var endTimes   = NSMutableArray()
    var lunchHours  = NSMutableArray()
    var totalHours = NSMutableArray()
    var taxAmount = NSMutableArray()
    var dates = NSMutableArray()
    var weekEnd = String()
    var cleared = Bool()
    var isTotalNegative = Bool()
    var selectedData:JSON = JSON.null
    var cIndex = Int()
    
    @IBOutlet var timeSlipForLabel: UILabel!
    @IBOutlet var dropDownButton: PKButton!
    @IBOutlet var weekEndLabel: UILabel!
    var activeKBTextView = UITextView()
    
    let chooseArticleDropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.chooseArticleDropDown
        ]
    }()
    
    @IBOutlet var enterTimeSlipdetailTableView: UITableView!
    var defaults = UserDefaults()
    var ContactId = String()
    var clientID = String()
    var DivisionId = String()
    @IBOutlet var conformationView: UIView!
    @IBOutlet var conformationHeaderLabel: UILabel!
    @IBOutlet var conformationWeekdaysLabels: [UILabel]!
    @IBOutlet var conformationHoursLabels: [UILabel]!
    @IBOutlet var conformationTotalLabel: UILabel!
    var blurEffect = UIBlurEffect()
    var blurEffectView = UIVisualEffectView()
    
    @IBOutlet var orderconformationView: UIView!
    @IBOutlet var confirmationScrollView: UIScrollView!
    @IBOutlet weak var confirmationHeightConstraint: NSLayoutConstraint!

    @IBOutlet var orderConformationLabel: UILabel!
    @IBOutlet var wouldYouLikeButton: UIButton!
    var menuName = String()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titlelbl.text = menuName
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        noteTextView.layer.borderWidth = 0.5
        noteTextView.layer.borderColor = borderColor.cgColor
        
        self.registerForKeyboardNotifications()
        
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(keyboardDoneBtnTapped))]
        toolBar.sizeToFit()
        
        noteTextView.inputAccessoryView = toolBar
        
 
        //        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        
        
        //        if self.view.bounds.height <= 568
        //        {
        //            let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font:UIFont.systemFont(ofSize:13)]
        //            self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        //        }
        //        else
        //        {
        //            let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font:UIFont.systemFont(ofSize:17)]
        //            self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        //        }
        defaults = UserDefaults.standard
        ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
        clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
        DivisionId = String(format:"%d", defaults.integer(forKey: "DivisionId"))
        
        self.getTimeSilpDetailsData()
        
        starTimes = ["","","","","","",""]
        endTimes = ["","","","","","",""]
        lunchHours = ["","","","","","",""]
        totalHours = ["","","","","","",""]
        taxAmount = ["","","","","","",""]
        
        for c in 0..<conformationWeekdaysLabels.count
        {
            conformationWeekdaysLabels[c].backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
            conformationHoursLabels[c].textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        }
        conformationHeaderLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
        wouldYouLikeButton.titleLabel?.textAlignment = .center
        wouldYouLikeButton.titleLabel?.numberOfLines = 0
        
    }
    @objc func keyboardDoneBtnTapped(sender: UIButton)  {
        self.view.endEditing(true)
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(EnterTimeSlipDetailViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EnterTimeSlipDetailViewController.keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(EnterTimeSlipDetailViewController.keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        
    }
    
    @objc func keyboardDidShow(aNotification: NSNotification) {
        //        self.enterTimeSlipdetailTableView.isScrollEnabled = false
        
        var info = aNotification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        //247792
        //9885696616
        self.enterTimeSlipdetailTableView.contentInset = contentInsets
        self.enterTimeSlipdetailTableView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = self.view.frame
        aRect.size.height -= (keyboardSize?.height)!
        //        if let activeField = self.activeTextView {
        if (!aRect.contains(self.activeKBTextView.frame.origin)){
            self.enterTimeSlipdetailTableView.scrollRectToVisible(self.activeKBTextView.frame, animated: true)
        }
        //        }
        
    }
    @objc func keyboardWillShow(aNotification: NSNotification) {
        
        //        self.enterTimeSlipdetailTableView.isScrollEnabled = false
        
        
    }
    
    @objc func keyboardWillBeHidden(aNotification: NSNotification) {
        self.enterTimeSlipdetailTableView.isScrollEnabled = true
        
        let contentInsets : UIEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.enterTimeSlipdetailTableView.contentInset = contentInsets
        self.enterTimeSlipdetailTableView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
    }
    
    
    func getTimeSilpDetailsData()
    {
        
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            
            
            JustHUD.shared.showInView(view: view)
            
            //TestData
            //let params:[String:Any] = ["ContactID" : 194848, "DivisionId" : 50, "CandId" : 233443, "orderId" : 903544, "ClientId" : 70830, "weekendDate" : "12/31/2017"]
            
            let params:[String:Any] = ["ContactID" : ContactId, "DivisionId" : DivisionId, "CandId" : selectedData["CandId"].stringValue, "orderId" : selectedData["OrderId"].stringValue, "ClientId" : clientID, "weekendDate" : weekEnd,"OSSource": "iOS"]
            
            RestAPI.TimeSlipEnterEmployeeeTimeslips(self, params: params, method:"POST", accessToken:"", acces: true, callBack:  getresponseForTimeSlipOrderDetail(response:))
            
        }else{
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    //getresponseForTimeSlipOrderDetail
    func getresponseForTimeSlipOrderDetail(response:AnyObject)->()
    {
        JustHUD.shared.hide()
        orderDetailObject = response as! JSON
        print(orderDetailObject)
        if orderDetailObject["MessageStatus"].intValue == 0
        {
            
            for date in 0..<orderDetailObject["WeekDays"].count
            {
                dates.insert(orderDetailObject["WeekDays"][date].stringValue.substring(to: 10),at:date)
            }
            
            orderIdLabel.text = orderDetailObject["OrderId"].stringValue
            clientNameLabel.text = orderDetailObject["CompanyName"].stringValue
            weekEndLabel.text = orderDetailObject["WeekendDate"].stringValue.left(10)
            self.weekEnd = orderDetailObject["WeekendDate"].stringValue.left(10)
            self.dropDownButton.setTitle(orderDetailObject["TimeSlipsForListFor"][0]["TimeslipsFor"].stringValue, for: .normal)
            self.dropDownButton.titleLabel?.textAlignment = .left
            timeSlipForLabel.text = "Time Slip For: "+orderDetailObject["TimeSlipsForListFor"][0]["TimeslipsFor"].stringValue
        }
        enterTimeSlipdetailTableView.reloadData()
    }
    //DropDown action
    
    func setupChooseArticleDropDown(anchorView:UIButton,items:[String]) {
        chooseArticleDropDown.anchorView = anchorView
        chooseArticleDropDown.bottomOffset = CGPoint(x: 0, y: anchorView.bounds.height)
        chooseArticleDropDown.backgroundColor = .white
        chooseArticleDropDown.dataSource =  items
        chooseArticleDropDown.selectionAction = { [unowned self] (index,item) in
            print(self.index)
            print(item)
            self.dropDownButton.setTitle(item, for: .normal)
            self.dropDownButton.titleLabel?.textAlignment = .left
            self.timeSlipForLabel.text = "Time Slip For:"+item
            self.cIndex = items.index(of: item)!
            
        }
        
    }
    @IBAction func dropDownAction(_ sender: PKButton) {
        
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        
        let itemsDrop:[String] = orderDetailObject["TimeSlipsForListFor"].arrayValue.map({$0["TimeslipsFor"].stringValue})
        setupChooseArticleDropDown(anchorView:sender,items:itemsDrop)
        chooseArticleDropDown.show()
    }
    
    
    
    
    
    
    
    
    
    
    //TimePickerControl
    func showPicker(ampm:Bool,selectedDate: Date)
    {
        let min = selectedDate.addingTimeInterval(-60 * 60 * 24 * 4) //4 days -
        let max = selectedDate.addingTimeInterval(60 * 60 * 24 * 4)//4 days +
        let picker = DateTimePicker.show(selected: selectedDate, minimumDate: min, maximumDate: max)
        
        //let step = orderDetailObject["BindActivityMinutesList"][1].intValue-orderDetailObject["BindActivityMinutesList"][0].intValue
        
        let ClientID = String(format:"%d", UserDefaults.standard.integer(forKey: "ClientID"))
        var step = 15
        if ClientID == "76121"{
            step = 1
        }
        if step == 15
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.fifteen
        }
        else if step == 6
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.six
        }
        else if step == 1
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.default
        }
        picker.highlightColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = "Done"
        picker.doneBackgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        picker.locale = Locale(identifier: "en_GB")
        //picker.isDefault = true
        picker.todayButtonTitle = ""
        picker.isAmPm = ampm
        if ampm{
            picker.is12HourFormat = false
            picker.dateFormat = "hh:mm"
        }
        else
        {
            picker.is12HourFormat = true
            picker.dateFormat = "hh:mm aa"
        }
        picker.isTimePickerOnly = true
        //picker.isDatePickerOnly = true
        picker.includeMonth = false // if true the month shows at top
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.locale = Locale.preferredLocale()
            if ampm{
                formatter.dateFormat = "hh:mm"
            }
            else
            {
                formatter.dateFormat = "hh:mm aa"
            }
            if (self.activeTextField!.tag>7)&&(self.activeTextField!.tag)<16
            {
                self.activeTextField?.text = formatter.string(from: date)
                self.starTimes.replaceObject(at:(self.activeTextField?.tag)!-8, with:formatter.string(from: date))
            }
            else if (self.activeTextField!.tag>96)&&(self.activeTextField!.tag)<104
            {
                self.activeTextField?.text = formatter.string(from: date)
                self.endTimes.replaceObject(at: (self.activeTextField?.tag)!-97, with:formatter.string(from: date))
                
            }
            self.enterTimeSlipdetailTableView.reloadData()
        }
        picker.delegate = self
        NotificationCenter.default.post(name: Notification.Name("Time"), object: nil)
    }
    
    //TextField Delegate Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField.tag>7&&textField.tag<16)||(textField.tag>96&&textField.tag<104)
        {
            activeTextField = textField
            self.view.endEditing(true)
            if cleared
            {
                cleared = false
                
            }
            else
            {
                if textField.text?.count == 0{
                self.showPicker(ampm:false,selectedDate: Date())
                }else{
                     let TimeValue = textField.text
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
                    let time = date+" "+TimeValue!//
                    let sDate = dateFormatter1.date(from: time)
                    self.showPicker(ampm:false,selectedDate: sDate!)
                }
            }
            return false
            
        }
            
        else
        {
            
            return true
            
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField.tag>128&&textField.tag<135
        {
            textField.perform(
                #selector(becomeFirstResponder),
                with: nil,
                afterDelay: 0.1
            )
            //actfield = nil
        }
        else if textField.tag>102&&textField.tag<113
        {
            textField.perform(
                #selector(becomeFirstResponder),
                with: nil,
                afterDelay: 0.1
            )
            // actfield = nil
        }
        //        if cleared
        //        {
        //            cleared = false
        //            textField.endEditing(true)
        //        }
        //        else
        //        {
        //
        //        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.tag>7&&textField.tag<16)
        {
            starTimes.replaceObject(at:textField.tag-8, with:textField.text!)
            enterTimeSlipdetailTableView.reloadData()
            
        }
        else if (textField.tag>96&&textField.tag<104)
        {
            endTimes.replaceObject(at:textField.tag-97, with:textField.text!)
            enterTimeSlipdetailTableView.reloadData()
        }
        else if textField.tag>128&&textField.tag<136
        {
            lunchHours.replaceObject(at:textField.tag-129, with:textField.text!)
            enterTimeSlipdetailTableView.reloadData()
            //actfield = nil
        }
        else if textField.tag>112&&textField.tag<119
        {
            taxAmount.replaceObject(at:textField.tag-113, with:textField.text!)
            enterTimeSlipdetailTableView.reloadData()
            //actfield = nil
        }
    }
    public func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        if (textField.tag>7&&textField.tag<16)
        {
            starTimes.replaceObject(at:textField.tag-8, with:"")
            enterTimeSlipdetailTableView.reloadData()
            
        }
        else if (textField.tag>96&&textField.tag<104)
        {
            endTimes.replaceObject(at:textField.tag-97, with:"")
            enterTimeSlipdetailTableView.reloadData()
        }
        else if textField.tag>128&&textField.tag<136
        {
            
            lunchHours.replaceObject(at:textField.tag-129, with:"")
            enterTimeSlipdetailTableView.reloadData()
            
        }
        else if textField.tag>112&&textField.tag<119
        {
            taxAmount.replaceObject(at:textField.tag-113, with:"")
            enterTimeSlipdetailTableView.reloadData()
        }
        cleared = true
        return true
    }
    
    
    
    //TimeCalculations
    func convertDate(date:String,min:Bool) -> String
    {
        let tt = date
        let dateFormatterf = DateFormatter()
        dateFormatterf.locale = Locale.preferredLocale()
        if min
        {
            dateFormatterf.dateFormat = "h:mm"
        }
        else
        {
            dateFormatterf.dateFormat = "h:mm a"
        }
        
        let dateee = dateFormatterf.date(from: tt)
        dateFormatterf.dateFormat = "HH:mm"
        
        let Date24 = dateFormatterf.string(from: dateee!)
        print("24 hour formatted Date:",Date24)
        return Date24
    }
    func addTimes(start:String,end:String,min:Bool) -> Int
    {
        let startDate = start
        let endDate = end
        
        let startArray = startDate.components(separatedBy: (":"))
        let endArray = endDate.components(separatedBy: (":"))
        
        let startHours = Int(startArray[0])! * 60
        let startMinutes = Int(startArray[1])! + startHours
        
        let endHours = Int(endArray[0])! * 60
        let endMinutes = Int(endArray[1])! + endHours
        
        var timeDifference = 0
        if min
        {
            timeDifference = startMinutes - endMinutes
        }
        else
        {
            timeDifference = endMinutes - startMinutes
        }
        let day = 24 * 60
        
        if timeDifference < 0 {
            timeDifference += day
        }
        print(timeDifference)
        return timeDifference
    }
    func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
    func getHours(start:String,end:String,i:Int,min:Bool)
    {
        let tuple = minutesToHoursMinutes(minutes: self.addTimes(start:self.convertDate(date:start,min:min), end: self.convertDate(date:end,min:min),min:min))
        
        
        var totalTimeConversionArray = Double()
        let hours = String(format:"%d:%d",tuple.hours,tuple.leftMinutes)
        let fileArray = hours.components(separatedBy:":")
        var hoursToMin:Double = Double()
        if fileArray.count>0
        {
            hoursToMin = Double(fileArray[0])!
        }
        var mins:Double = Double()
        if fileArray.count == 2
        {
            mins = Double(fileArray[1])!
        }
        totalTimeConversionArray = hoursToMin+mins/60
        if hours.hasPrefix("-")
        {
            totalHours.replaceObject(at:i-1, with:String(format:"-%.2f",totalTimeConversionArray))
        }
        else{
            totalHours.replaceObject(at:i-1, with:String(format:"%.2f",totalTimeConversionArray))
        }
        self.addTotal()
        
        
    }
    
    func addTotal()
    {
        var toatHours = Double()
        for i in 0..<7
        {
            var hours = Double()
            if totalHours[i] as! String != ""
            {
                hours = Double(totalHours[i] as! String)!
                toatHours += hours
            }
            else
            {
                
            }
        }
        totalLabel.text = String(format:"%.2f",toatHours)
    }
    func total()
    {
        var totalIsNull = Bool()
        for total in 0..<totalHours.count
        {
            if (starTimes[total] as! String).count>0&&(endTimes[total] as! String).count>0
            {
                totalIsNull = false
                break
            }
            else
            {
                totalIsNull = true
            }
        }
        if totalIsNull
        {
            totalLabel.text = "0"
        }
        else
        {
            
        }
    }
    
    @IBAction func resetAction(_ sender: ShadowButton)
    {
        let confromAlert = UIAlertController(title: "Would you like to clear entered timeslips for the following weekend \(weekEnd)", message:"", preferredStyle: UIAlertController.Style.alert)
        confromAlert.addAction(UIAlertAction(title: "NO", style: .destructive) { (action:UIAlertAction!) in
            
            
        })
        confromAlert.addAction(UIAlertAction(title: "YES", style: .default) { (action:UIAlertAction!) in
            
            self.starTimes = ["","","","","","",""]
            self.endTimes = ["","","","","","",""]
            self.lunchHours = ["","","","","","",""]
            self.totalHours = ["","","","","","",""]
            self.taxAmount = ["","","","","","",""]
            self.isTotalNegative = false
            self.enterTimeSlipdetailTableView.scrollToRow(at:IndexPath(item: 0, section: 0), at:.top, animated:true)
            for row in 0..<8
            {
                let indexPath = IndexPath(item: row, section: 0)
                self.enterTimeSlipdetailTableView.reloadRows(at: [indexPath], with: .fade)
            }
            self.navigationController?.view.makeToast("Schedule has been cleared for this \(self.weekEnd) weekend", duration: 3.0, position: .bottom, title: "", image: nil)
        })
        
        self.present(confromAlert, animated: true)
        confromAlert.view.tintColor = UIColor(hexString: "#449D44")
        
        
    }
    
    
    @IBAction func submitAction(_ sender: ShadowButton)
    {
        let totalHoursLabel:Double = Double(totalLabel.text!)!
        
        isTotalNegative = false
        for i in 0..<7
        {
            let hours = totalHours[i] as! String
            if hours.hasPrefix("-")
            {
                isTotalNegative = true
                break
            }
            if ((starTimes[i] as! String).count>0)||((endTimes[i] as! String).count>0)
            {
                if self.totalHours[i] as! String == ""
                {
                    isTotalNegative = true
                    break
                }
                else
                {
                    let totalHours:Double = Double(self.totalHours[i] as! String)!
                    if totalHours == 0
                    {
                        isTotalNegative = true
                        break
                    }
                }
            }
            
        }
        
        if isTotalNegative
        {
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Please make sure total hours should not be zero or less than zero.", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            //            self.ShowAlertMessage(message: "", title: "Please make sure total hours should not be less than zero or zero.")
        }
        else if totalHoursLabel == 0
        {
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Timeslip Total hour should not be zero.", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
            //             self.ShowAlertMessage(message: "", title:"Timeslip Total should not be zero.")
        }
        else if totalHoursLabel < 0.5
        {
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Timeslip Total hour should be greater than 0.5 hour.", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
            //            self.ShowAlertMessage(message: "", title:"Timeslip Total should be greater than 0.5 hour.")
        }
        else
        {
            
            //            let confromAlert = UIAlertController(title: "Have you entered correct information?", message:"", preferredStyle: UIAlertControllerStyle.alert)
            //
            //            confromAlert.addAction(UIAlertAction(title: "NO", style: .destructive) { (action:UIAlertAction!) in
            //
            //
            //            })
            //            confromAlert.addAction(UIAlertAction(title: "YES", style: .default) { (action:UIAlertAction!) in
            if orderDetailObject["WeekDays"].arrayValue.count>0
            {
                for t in 0..<conformationHoursLabels.count
                {
                    let day = Constants.getFormattedDateIn(string:orderDetailObject["WeekDays"][t].stringValue).uppercased()
                    print(day)
                    conformationWeekdaysLabels[t].text = Constants.getFormattedDateIn(string:orderDetailObject["WeekDays"][t].stringValue).uppercased()
                    conformationHoursLabels[t].text = totalHours[t] as? String
                }
                
                    confirmationScrollView.frame = CGRect(x: 10, y:self.view.bounds.size.height/2-240, width:self.view.bounds.size.width-20, height:480)

                 
                if #available(iOS 11.0, *) {
                    if self.isPortrait() == false {
                        if ((UIApplication.shared.keyWindow?.safeAreaInsets.bottom)! > CGFloat(0.0)) {
                            confirmationScrollView.frame = CGRect(x: 10, y:100, width:self.view.bounds.size.width-80, height:480)
                        }
                    }
                }

                let totalHoursLabel:Double = Double(totalLabel.text!)!
                conformationTotalLabel.text = "Total Hours:"+String(format:"%.2f",totalHoursLabel)
                blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
                blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.frame = view.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                blurEffectView.contentView.addSubview(confirmationScrollView)
                view.addSubview(blurEffectView)
//                self.navigationController?.view.addSubview(blurEffectView)
                
                //  })
                //            self.present(confromAlert, animated: true)
                //            confromAlert.view.tintColor = UIColor(hexString: "#449D44")
            }
        }
    }
    //getresponseForInsertTimeSlip
    func getresponseForInsertTimeSlip(response:AnyObject)->()
    {
        JustHUD.shared.hide()
        insertData = response as! JSON
        print(insertData)
        if insertData["MessageStatus"].stringValue == "0"
        {
            if insertData["ConfictTimeSlip"].intValue == 1
            {
//                let attributedString = NSAttributedString(string:insertData["Message"].stringValue.removeHtmlFromString(inPutString: insertData["Message"].stringValue), attributes: [
//                    NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), //your font here
//                    NSAttributedStringKey.foregroundColor : UIColor.red
//                    ])
                //                let alert = UIAlertController(title: "", message: "",  preferredStyle: .alert)
                //                alert.setValue(attributedString, forKey: "attributedTitle")
                //                let ok = UIAlertAction(title: "Ok",
                //                                           style: .destructive) { (action: UIAlertAction!) -> Void in
                //
                //                }
                //                alert.addAction(ok)
                //                present(alert,animated: true,completion: nil)
                //
                let message = insertData["Message"].stringValue
                let htmlString = "<html>" + message
                
                let messageText = htmlString.htmlToAttributedString
                
                self.showCustomAlert(Title: "", attMessage: messageText!, message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: true)
            }
            else
            {
                
                //            self.ShowAlertMessage(message:insertData["Message"].stringValue.removeHtmlFromString(inPutString: insertData["Message"].stringValue), title:"")
                
                let message = insertData["Message"].stringValue
                let htmlString = "<html>" + message
                
                let messageText = htmlString.htmlToAttributedString
                
                self.showCustomAlert(Title: "", attMessage: messageText!, message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: true)
                
            }
        }
        else if insertData["Status"].boolValue == true
        {
            orderconformationView.frame = CGRect(x: 10, y:self.view.bounds.size.height/2-120, width:self.view.bounds.size.width-20, height:240)
            
            orderConformationLabel.text = "Timeslip(s) Entered Sucessfully.\nYour confirmation number is \(insertData["ConfirmationNo"].stringValue)."
            blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.contentView.addSubview(orderconformationView)
            view.addSubview(blurEffectView)
            
        }
        
    }
    
    @IBAction func correctAction(_ sender: UIButton) {
        
        blurEffectView.removeFromSuperview()
        var times = Array<[String:Any]>()
        for i in 0..<7
        {
            let time = [ "Day" : i+1,
                         "StartTime" : self.starTimes[i],
                         "EndTime" : self.endTimes[i],
                         "LunchTime" : self.lunchHours[i],
                         "TaxiTime" : self.taxAmount[i],
                         "TotalTime": self.totalHours[i],
                         "CurrentDate" : self.dates[i],
                         ]
            times.append(time)
            print(times)
        }
        
        let insertPendingParams:[String:Any] = ["CandId":self.orderDetailObject["TimeSlipsForListFor"][self.cIndex]["CandId"].stringValue,
                                                "ClientId" : self.clientID,
                                                "ContactID" : self.ContactId,
                                                "DivisionId" : self.DivisionId,
                                                "Notes" : self.noteTextView.text,
                                                "OrderId" : self.orderDetailObject["OrderId"].stringValue,
                                                "TimeslipsFor" : self.orderDetailObject["TimeSlipsForListFor"][self.cIndex]["TimeslipsFor"].stringValue,
                                                "WeekendDate" : self.weekEnd,
                                                "LegalDivision":self.orderDetailObject["LegalDivision"].intValue,
                                                "MaxPay":self.orderDetailObject["TimeSlipsForListFor"][self.cIndex]["MaxPay"].intValue,
                                                "TimeSlipTotal":self.totalLabel.text!,
                                                "LunchTimeMonday":self.lunchHours[0],
                                                "LunchTimeTuesday":self.lunchHours[1],
                                                "LunchTimeWednesday":self.lunchHours[2],
                                                "LunchTimeThursday":self.lunchHours[3],
                                                "LunchTimeFriday":self.lunchHours[4],
                                                "LunchTimeSaturday":self.lunchHours[5],
                                                "LunchTimeSunday":self.lunchHours[6],
                                                "TotalTimeMonday":self.totalHours[0],
                                                "TotalTimeTuesday":self.totalHours[1],
                                                "TotalTimeWednesday":self.totalHours[2],
                                                "TotalTimeThursday":self.totalHours[3],
                                                "TotalTimeFriday":self.totalHours[4],
                                                "TotalTimeSaturday":self.totalHours[5],
                                                "TotalTimeSunday":self.totalHours[6],
                                                "PendingTimeList":times,
                                                "OSSource": "iOS"]
        
        print(insertPendingParams)
        JustHUD.shared.showInView(view: self.view)
        RestAPI.TimeSlipInsertPendingTimeSlip(self, params:insertPendingParams, method:"POST", accessToken:"", acces: true, callBack:  self.getresponseForInsertTimeSlip(response:))
        
        
        
    }
    
    @IBAction func inCorrectAction(_ sender: Any) {
        
        blurEffectView.removeFromSuperview()
    }
    @IBAction func EnterAnotherTimeSlip(_ sender: UIButton) {
        
        blurEffectView.removeFromSuperview()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func orderConformationCancelAction(_ sender: UIButton) {
        blurEffectView.removeFromSuperview()
        //pop to dashboard
        self.popToDasboardPage()
    }
    
    func popToDasboardPage(){
        
        
        //check if LaunchViewController is there on stack or not ,if present pop else push
        
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
    //MARK: UITEXTVIEW DELEGATE
    public func textViewDidBeginEditing(_ textView: UITextView)
    {
        //        self.activeKBTextView = textView
    }
    public func textViewDidEndEditing(_ textView: UITextView)
    {
        //        self.activeKBTextView = UITextView()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.orderconformationView.frame = CGRect(x: 10, y:self.view.bounds.size.height/2-120, width:self.view.bounds.size.width-20, height:240)
             self.blurEffectView.frame = self.view.bounds
            self.blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            if self.isPortrait() == true{
                self.confirmationScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: 480)
                    self.confirmationHeightConstraint.constant = 480
                
                self.confirmationScrollView.frame = CGRect(x: 10, y:self.view.bounds.size.height/2-240, width:self.view.bounds.size.width-20, height:480)

            }else{
                let modelName = UIDevice.current.modelName
                if modelName.contains("iPad") {
                    self.confirmationScrollView.frame = CGRect(x: 10, y:100, width:self.view.bounds.size.width-20, height:480)

                }else{
                    self.confirmationScrollView.frame = CGRect(x: 10, y:70, width:self.view.bounds.size.width-20, height:480)

                }
                if #available(iOS 11.0, *) {
                    if self.isPortrait() == false {
                        if ((UIApplication.shared.keyWindow?.safeAreaInsets.bottom)! > CGFloat(0.0)) {
                            self.confirmationScrollView.frame = CGRect(x: 10, y:80, width:self.view.bounds.size.width-80, height:480)
                        }
                    }
                }
                self.confirmationScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: 620)
                self.confirmationHeightConstraint.constant = 620

            }
            self.conformationView.layoutIfNeeded()

        })

        
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            DispatchQueue.main.async(execute: { () -> Void in
                self.addDivisionNameOnTop()
             })
        case .portraitUpsideDown:
            text="PortraitUpsideDown"
        case .landscapeLeft:
            text="LandscapeLeft"
            DispatchQueue.main.async(execute: { () -> Void in
                self.addDivisionNameOnTop()
                
             })
        case .landscapeRight:
            text="LandscapeRight"
            DispatchQueue.main.async(execute: { () -> Void in
                self.addDivisionNameOnTop()
                
             })
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
        
    }
}
extension EnterTimeSlipDetailViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 8
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row==0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:"hCell", for: indexPath) as! THTableViewCell
            cell.selectionStyle = .none
            cell.startTimeLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
            cell.endLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
            cell.lunchLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
            cell.totalLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
            cell.dateLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "etdCell") as! EnterTimeSlipDetailTableViewCell
            cell.startTimeTextField.tag = 7+indexPath.row
            cell.endTimeTextField.tag   = 96+indexPath.row
            cell.lunchTimeTextField.tag =  128+indexPath.row
            cell.taxFareTextField.tag = 112+indexPath.row
            cell.dateLabel.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
            
            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
            toolBar.barStyle = UIBarStyle.default
            toolBar.items = [
                UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(keyboardDoneBtnTapped))]
            toolBar.sizeToFit()
            
            cell.lunchTimeTextField.inputAccessoryView = toolBar
            cell.taxFareTextField.inputAccessoryView = toolBar

            if orderDetailObject.count>0
            {
                if orderDetailObject["WeekDays"].arrayValue.count>0
                {
                    //dates.insert(orderDetailObject["WeekDays"][indexPath.row-1].stringValue.left(10), at: indexPath.row-1)
                    cell.dateLabel.text = Constants.getFormattedDate(string:orderDetailObject["WeekDays"][indexPath.row-1].stringValue).uppercased()
                }
            }
            if orderDetailObject["\(weekdays[indexPath.row-1])"].intValue == 0
            {
                cell.startTimeTextField.isEnabled = false
                cell.endTimeTextField.isEnabled = false
                cell.lunchTimeTextField.isEnabled = false
                cell.taxFareTextField.isEnabled = false
                cell.startTimeTextField.backgroundColor = UIColor(hexString:"#EEEEEE")
                cell.endTimeTextField.backgroundColor =     UIColor(hexString:"#EEEEEE")
                cell.lunchTimeTextField.backgroundColor = UIColor(hexString:"#EEEEEE")
                cell.taxFareTextField.backgroundColor = UIColor(hexString:"#EEEEEE")
                cell.startTimeTextField.leftView?.isHidden = true
                cell.endTimeTextField.leftView?.isHidden = true
            }
            else
            {
                cell.startTimeTextField.isEnabled = true
                cell.endTimeTextField.isEnabled = true
                cell.lunchTimeTextField.isEnabled = true
                cell.taxFareTextField.isEnabled = true
                cell.startTimeTextField.backgroundColor = .white
                cell.endTimeTextField.backgroundColor = .white
                cell.lunchTimeTextField.backgroundColor = .white
                cell.taxFareTextField.backgroundColor = .white
                cell.startTimeTextField.leftView?.isHidden = false
                cell.endTimeTextField.leftView?.isHidden = false
            }
            if UIDevice.current.userInterfaceIdiom == .pad
            {
                cell.startTimeTextField.font = UIFont.systemFont(ofSize:15)
                cell.endTimeTextField.font = UIFont.systemFont(ofSize:15)
                
            }
            else if UIDevice.current.userInterfaceIdiom == .phone
            {
                if self.view.bounds.size.height <= 568
                {
                    cell.startTimeTextField.font = UIFont.systemFont(ofSize:7)
                    cell.endTimeTextField.font = UIFont.systemFont(ofSize:7)
                    cell.taxFareTextField.font = UIFont.systemFont(ofSize:9)
                    
                    
                }
                else
                {
                    cell.startTimeTextField.font = UIFont.systemFont(ofSize:12)
                    cell.endTimeTextField.font = UIFont.systemFont(ofSize:12)
                    cell.taxFareTextField.font = UIFont.systemFont(ofSize:14)
                    
                }
            }
            if orderDetailObject["TaxiOk"].intValue == 0
            {
                cell.taxFareTextField.isHidden = true
                cell.amountHeight.constant = 0
            }
            else
            {
                cell.taxFareTextField.isHidden = false
                cell.amountHeight.constant = 50
            }
            
            
            
            
            cell.startTimeTextField.text = starTimes[indexPath.row-1] as? String
            cell.endTimeTextField.text = endTimes[indexPath.row-1] as? String
            cell.lunchTimeTextField.text = lunchHours[indexPath.row-1] as? String
            cell.taxFareTextField.text = taxAmount[indexPath.row-1] as? String
            
            if (cell.startTimeTextField.text!.count>0)&&(cell.endTimeTextField.text?.count)!>0
            {
                self.getHours(start:cell.startTimeTextField.text!, end:cell.endTimeTextField.text!, i:indexPath.row,min:false)
                cell.totalHoursLabel.text = totalHours[indexPath.row-1] as? String
            }
            else
            {
                cell.totalHoursLabel.text = ""
                totalHours.replaceObject(at: indexPath.row-1, with:"")
                self.total()
            }
            if (cell.lunchTimeTextField.text!.count>0)&&(cell.startTimeTextField.text!.count>0)&&(cell.endTimeTextField.text?.count)!>0
            {
                let timeInTotal = Double(totalHours[indexPath.row-1] as! String)!
                let lunchTime = Double((cell.lunchTimeTextField.text)!)!
                totalHours.replaceObject(at:indexPath.row-1, with:String(format:"%.2f",timeInTotal-lunchTime/60))
                cell.totalHoursLabel.text = totalHours[indexPath.row-1] as? String
                self.addTotal()
            }
            else
            {
                lunchHours.replaceObject(at:indexPath.row-1, with:cell.lunchTimeTextField.text!)
                self.total()
            }
            
            cell.selectionStyle = .none
            return cell
        }
    }
}
extension EnterTimeSlipDetailViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0
        {
            return 35
        }
        else
        {
            if orderDetailObject["TaxiOk"].intValue == 0
            {
                return 52
            }
            else
            {
                return 106
            }
        }
    }
}
extension EnterTimeSlipDetailViewController:DateTimePickerDelegate
{
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        
        print(picker.selectedDateString)
    }
}
extension String {
    
    func left(_ to: Int) -> String {
        return "\(self[..<self.index(startIndex, offsetBy: to)])"
    }
    
    func right(_ from: Int) -> String {
        return "\(self[self.index(startIndex, offsetBy: self.count-from)...])"
    }
    func mid(_ from: Int, amount: Int) -> String {
        let x = "\(self[self.index(startIndex, offsetBy: from)...])"
        return x.left(amount)
    }
}
extension String{
    
    func removeHtmlFromString(inPutString: String) -> String{
        
        return inPutString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
public enum Model : String {
    case simulator     = "simulator/sandbox",
    iPod1              = "iPod 1",
    iPod2              = "iPod 2",
    iPod3              = "iPod 3",
    iPod4              = "iPod 4",
    iPod5              = "iPod 5",
    iPad2              = "iPad 2",
    iPad3              = "iPad 3",
    iPad4              = "iPad 4",
    iPad5              = "iPad 5",
    iPhone4            = "iPhone 4",
    iPhone4S           = "iPhone 4S",
    iPhone5            = "iPhone 5",
    iPhone5S           = "iPhone 5S",
    iPhone5C           = "iPhone 5C",
    iPadMini1          = "iPad Mini 1",
    iPadMini2          = "iPad Mini 2",
    iPadMini3          = "iPad Mini 3",
    iPadAir1           = "iPad Air 1",
    iPadAir2           = "iPad Air 2",
    iPadPro9_7         = "iPad Pro 9.7\"",
    iPadPro9_7_cell    = "iPad Pro 9.7\" cellular",
    iPadPro12_9        = "iPad Pro 12.9\"",
    iPadPro12_9_cell   = "iPad Pro 12.9\" cellular",
    iPadPro2_12_9      = "iPad Pro 2 12.9\"",
    iPadPro2_12_9_cell = "iPad Pro 2 12.9\" cellular",
    iPhone6            = "iPhone 6",
    iPhone6plus        = "iPhone 6 Plus",
    iPhone6S           = "iPhone 6S",
    iPhone6Splus       = "iPhone 6S Plus",
    iPhoneSE           = "iPhone SE",
    iPhone7            = "iPhone 7",
    iPhone7plus        = "iPhone 7 Plus",
    iPhone8            = "iPhone 8",
    iPhone8plus        = "iPhone 8 Plus",
    iPhoneX            = "iPhone X",
    unrecognized       = "?unrecognized?"
}

// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
//MARK: UIDevice extensions
// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#

public extension UIDevice {
    public var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
                
            }
        }
        var modelMap : [ String : Model ] = [
            "i386"      : .simulator,
            "x86_64"    : .simulator,
            "iPod1,1"   : .iPod1,
            "iPod2,1"   : .iPod2,
            "iPod3,1"   : .iPod3,
            "iPod4,1"   : .iPod4,
            "iPod5,1"   : .iPod5,
            "iPad2,1"   : .iPad2,
            "iPad2,2"   : .iPad2,
            "iPad2,3"   : .iPad2,
            "iPad2,4"   : .iPad2,
            "iPad2,5"   : .iPadMini1,
            "iPad2,6"   : .iPadMini1,
            "iPad2,7"   : .iPadMini1,
            "iPhone3,1" : .iPhone4,
            "iPhone3,2" : .iPhone4,
            "iPhone3,3" : .iPhone4,
            "iPhone4,1" : .iPhone4S,
            "iPhone5,1" : .iPhone5,
            "iPhone5,2" : .iPhone5,
            "iPhone5,3" : .iPhone5C,
            "iPhone5,4" : .iPhone5C,
            "iPad3,1"   : .iPad3,
            "iPad3,2"   : .iPad3,
            "iPad3,3"   : .iPad3,
            "iPad3,4"   : .iPad4,
            "iPad3,5"   : .iPad4,
            "iPad3,6"   : .iPad4,
            "iPhone6,1" : .iPhone5S,
            "iPhone6,2" : .iPhone5S,
            "iPad4,2"   : .iPadAir1,
            "iPad5,4"   : .iPadAir2,
            "iPad4,4"   : .iPadMini2,
            "iPad4,5"   : .iPadMini2,
            "iPad4,6"   : .iPadMini2,
            "iPad4,7"   : .iPadMini3,
            "iPad4,8"   : .iPadMini3,
            "iPad4,9"   : .iPadMini3,
            "iPad6,3"   : .iPadPro9_7,
            "iPad6,4"   : .iPadPro9_7_cell,
            "iPad6,12"  : .iPad5,
            "iPad6,7"   : .iPadPro12_9,
            "iPad6,8"   : .iPadPro12_9_cell,
            "iPad7,1"   : .iPadPro2_12_9,
            "iPad7,2"   : .iPadPro2_12_9_cell,
            "iPhone7,1" : .iPhone6plus,
            "iPhone7,2" : .iPhone6,
            "iPhone8,1" : .iPhone6S,
            "iPhone8,2" : .iPhone6Splus,
            "iPhone8,4" : .iPhoneSE,
            "iPhone9,1" : .iPhone7,
            "iPhone9,2" : .iPhone7plus,
            "iPhone9,3" : .iPhone7,
            "iPhone9,4" : .iPhone7plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,4" : .iPhone8,
            "iPhone10,5" : .iPhone8plus
        ]
        
        if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
            if model == .simulator {
                if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                    if let simModel = modelMap[String.init(validatingUTF8: simModelCode)!] {
                        return simModel
                    }
                }
            }
            return model
        }
        return Model.unrecognized
    }
}
