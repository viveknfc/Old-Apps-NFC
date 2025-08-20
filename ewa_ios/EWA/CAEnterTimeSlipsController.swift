//
//  CAEnterTimeSlipsController.swift
//  EWA
//
//  Created by NFC User on 4/27/21.
//  Copyright © 2021 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toast_Swift
import MobileCoreServices
import SideMenuController
import ANLoader
import CropViewController
import SideMenuController

class CAEnterTimeSlipsController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var wouldYouLikeButton: UIButton!
    @IBOutlet weak var orderConformationLabel: UILabel!
    @IBOutlet var orderconformationView: UIView!
    @IBOutlet weak var innerDisplayView: UIView!
    
    @IBOutlet weak var innerDisplayHeight: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeSlipTotalLabel: UILabel!
    @IBOutlet weak var totalLabel: PaddingLabel!
    @IBOutlet weak var weekEndLabel: UILabel!
    @IBOutlet weak var bottomViewTableView: NSLayoutConstraint!
    
    @IBOutlet weak var dohViewForm: UIView!
    @IBOutlet weak var checkBoxAction: KGRadioButton!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var uploadHeight: NSLayoutConstraint!
    @IBOutlet weak var uploadReceipts: ShadowButton!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var clientNameLabel: UILabel!
    @IBOutlet weak var displayTableView: UITableView!
    @IBOutlet weak var mainDisplayView: UIView!
    var dataScrollview: UIScrollView!
    var dataCollectionView: UICollectionView!
    var dates = NSMutableArray()
    var weekEnd = String()
    var orderId = String()
    var division = String()
    var object: JSON = JSON.null
    var weekdays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    var disWeekdays = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
    var cleared = Bool()
    @IBOutlet weak var conformationTotalLabel: UILabel!
    @IBOutlet var conformationHoursLabels: [UILabel]!
    @IBOutlet var conformationWeekdaysLabels: [UILabel]!
    
    @IBOutlet weak var conformationHeaderLabel: UILabel!
    @IBOutlet var conformationView: UIView!
    var totalForDoh = NSMutableArray()
    var days = ["","Start Time","Meal Out 1","Meal Return 1","Meal Out 2","Meal Return 2","End Time","Lunch (Min)","Total"]
    var reset = Bool()
    var customPickerView = Picker()
    let hrs = ["00","01","02","03","04","05","06","07","08","09","10","11","12"]
    let mins = ["00","15","30","45","60"]
    var weekedays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    var weekIndex = -1
    
    var index = Int()
    var activeTextField: UITextField?
    var actfield:UITextField?
    var starTimes = NSMutableArray()
    var endTimes   = NSMutableArray()
    var lunch1  = NSMutableArray()
    var lunch2  = NSMutableArray()
    var lunchHours  = NSMutableArray()
    var totalHours = NSMutableArray()
    var totalTimeInHours = NSMutableArray()
    var mealOut1 = NSMutableArray()
    var mealreturn1   = NSMutableArray()
    var mealOut2  = NSMutableArray()
    var mealReturn2 = NSMutableArray()
    var taxAmount = NSMutableArray()
    var documentsArray = NSMutableArray()
    var documetBytes = NSMutableArray()
    var fileExtensions = NSMutableArray()
    var listOfDocuments = Array<[String:Any]>()
    
    var TotalFiles = Array<Any>()
    var MealBreakCount = String()
    var duplicateResponse: JSON = JSON.null
    var inserObject:JSON = JSON.null
    var  docDeleteObject:JSON = JSON.null
    
    var isTotalNegative = Bool()
    var insertTimes = Array<[String:Any]>()
    var blurEffect = UIBlurEffect()
    var blurEffectView = UIVisualEffectView()
    var warningStatus = String()
    var coverageType = Int()
    
    var five = NSMutableArray()
    var ten = NSMutableArray()
    var six = NSMutableArray()
    var twelve = NSMutableArray()
    
    var fiveMin = NSMutableArray()
    var tenMin = NSMutableArray()
    var sixMin = NSMutableArray()
    var twelveMin = NSMutableArray()
    var extraSpace = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = "Timeslip For \(UserDefaults.standard.object(forKey:"CandName") as! String)"
        
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        self.navigationItem.title = "Enter Timeslips"
        noteTextView.placeholder = ""
        noteTextView.layer.borderWidth = 1.5
        noteTextView.layer.borderColor = UIColor.lightGray.cgColor
        weekEndLabel.text = weekEnd
        orderIdLabel.text = orderId
        
        totalHours = ["00:00","00:00","00:00","00:00","00:00","00:00","00:00"]
        starTimes = ["","","","","","",""]
        endTimes = ["","","","","","",""]
        lunch1 = ["","","","","","",""]
        lunch2 = ["","","","","","",""]
        lunchHours = ["","","","","","",""]
        totalTimeInHours = ["","","","","","",""]
        taxAmount = ["","","","","","",""]
        mealOut1 = ["","","","","","",""]
        mealreturn1  = ["","","","","","",""]
        mealOut2  = ["","","","","","",""]
        mealReturn2 = ["","","","","","",""]
        totalForDoh = ["","","","","","",""]
        
        fiveMin = ["","","","","","",""]
        five = ["","","","","","",""]
        ten = ["","","","","","",""]
        tenMin = ["","","","","","",""]
        six = ["","","","","","",""]
        sixMin = ["","","","","","",""]
        twelve = ["","","","","","",""]
        twelveMin = ["","","","","","",""]
        updateFrame()
        
        for c in 0..<conformationWeekdaysLabels.count
        {
            conformationWeekdaysLabels[c].backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
            conformationHoursLabels[c].textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        }
        conformationHeaderLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        wouldYouLikeButton.titleLabel?.textAlignment = .center
        wouldYouLikeButton.titleLabel?.numberOfLines = 0
        
    }
    func updateFrame()
    {
        extraSpace = 28
        if MealBreakCount == "1"{ // count changes 8 to 6
            days.remove(at: 4)
            days.remove(at: 5)
            extraSpace = 24
        }
        
        print(days.count)
        print(days)
        let heightt = CGFloat((45*days.count)+extraSpace)
        innerDisplayHeight.constant = heightt
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 115, height: heightt)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        dataCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: heightt ), collectionViewLayout: layout)
        dataCollectionView.register(UINib(nibName: "CACollectionHeaderCell", bundle: nil), forCellWithReuseIdentifier: "CACollectionHeaderCell")
        dataCollectionView.register(UINib(nibName: "CAMultiBreakCollectionCell", bundle: nil), forCellWithReuseIdentifier: "CAMultiBreakCollectionCell")
        
        dataCollectionView.delegate = self
        dataCollectionView.dataSource = self
        dataCollectionView.backgroundColor = UIColor.white
        innerDisplayView.addSubview(dataCollectionView)
        dataCollectionView.reloadData()
        displayTableView.reloadData()
        print(object)
        clientNameLabel.text = object["CompanyName"].stringValue
        
        for date in 0..<object["WeekDays"].count
        {
            dates.insert(object["WeekDays"][date].stringValue.substring(to: 10),at:date)
        }
        
        if object["TaxiOk"].intValue == 0
        {
            uploadReceipts.isHidden = true
            uploadReceipts.isHidden = true
            uploadHeight.constant = 0
            // dohHeightContsrain.constant = 10
        }
        else
        {
            if object["ExpenseDocUploadForm"].boolValue == true
            {
                uploadReceipts.isHidden = false
                uploadReceipts.isHidden = false
                uploadHeight.constant = 35
                //  dohHeightContsrain.constant = 45
            }
            else
            {
                uploadReceipts.isHidden = true
                uploadReceipts.isHidden = true
                uploadHeight.constant = 0
                // dohHeightContsrain.constant = 10
            }
        }
        if object["DohNurseForm"].boolValue == true
        {
            //            bottomViewTableView.constant = 1260
            //            dohView.constant = 890
            //            dohForm.frame = CGRect(x: 0, y: 0, width:self.view.bounds.size.width, height:890)
            //            dohViewForm.addSubview(dohForm)
            //            self.dohTableView.reloadData()
            //            bottomViewTableView.updateConstraints()
        }
        else
        {
            bottomViewTableView.constant = 325
        }
        
        //  self.timeSlipTableView.reloadData()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        var text=""
        let heightt = CGFloat((45*days.count)+extraSpace)
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            dataCollectionView.frame =  CGRect.init(x: 0, y: 0, width: innerDisplayView.frame.size.width , height: heightt)
            conformationView.frame = CGRect(x: 10, y:self.view.bounds.size.height/2-240, width:self.view.bounds.size.width-20, height:480)
            orderconformationView.frame = CGRect(x: 10, y:self.view.bounds.size.height/2-120, width:self.view.bounds.size.width-20, height:240)
        case .landscapeLeft:
            text="LandscapeLeft"
            dataCollectionView.frame =  CGRect.init(x: 0, y: 0, width: self.innerDisplayView.frame.size.width , height: heightt)
            conformationView.frame = CGRect(x: 10, y:20, width:self.view.bounds.size.width-20, height:self.view.bounds.size.height-40)
            orderconformationView.frame = CGRect(x: 10, y:self.view.bounds.size.height/2-120, width:self.view.bounds.size.width-20, height:240)
        case .landscapeRight:
            text="LandscapeRight"
            dataCollectionView.frame =  CGRect.init(x: 0, y: 0, width: self.innerDisplayView.frame.size.width , height: heightt)
            conformationView.frame = CGRect(x: 10, y:20, width:self.view.bounds.size.width-20, height:self.view.bounds.size.height-40)
            orderconformationView.frame = CGRect(x: 10, y:self.view.bounds.size.height/2-120, width:self.view.bounds.size.width-20, height:240)
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
    }
    
    
    @IBAction func uploadAction(_ sender: ShadowButton) {
    }
    
    @IBAction func checkBoxAction(_ sender: Any) {
        if checkBoxAction.isSelected
        {
            checkBoxAction.isSelected = false
        }
        else
        {
            checkBoxAction.isSelected = true
        }
    }
    @IBAction func resetAction(_ sender: ShadowButton) {
        
        let confromAlert = UIAlertController(title: "Would you like to clear Entered Timeslip for the following weekend \( weekEnd)?", message:"", preferredStyle: UIAlertControllerStyle.alert)
        confromAlert.addAction(UIAlertAction(title: "NO", style: .destructive) { (action:UIAlertAction!) in
            
        })
        confromAlert.addAction(UIAlertAction(title: "YES", style: .default) { (action:UIAlertAction!) in
            
            self.reset = true
            self.totalHours = ["00:00","00:00","00:00","00:00","00:00","00:00","00:00"]
            self.starTimes = ["","","","","","",""]
            self.endTimes = ["","","","","","",""]
            self.lunch1 = ["","","","","","",""]
            self.lunch2 = ["","","","","","",""]
            self.lunchHours = ["","","","","","",""]
            self.totalTimeInHours = ["","","","","","",""]
            self.taxAmount = ["","","","","","",""]
            self.mealOut1 = ["","","","","","",""]
            self.mealreturn1  = ["","","","","","",""]
            self.mealOut2  = ["","","","","","",""]
            self.mealReturn2 = ["","","","","","",""]
            self.totalForDoh = ["","","","","","",""]
            self.totalLabel.text = "0"
            self.isTotalNegative = false
            self.dataCollectionView.reloadData()
            self.navigationController?.view.makeToast("Schedule has been cleared for this \(self.weekEnd) weekend.", duration: 3.0, position: .bottom, title: "", image: nil)
        })
        
        self.present(confromAlert, animated: true)
        confromAlert.view.tintColor = UIColor(hexString: "#449D44")
    }
    @IBAction func submitAction(_ sender: ShadowButton) {
        isTotalNegative = false
        for i in 0..<7
        {
            let hours = totalTimeInHours[i] as! String
            if hours.hasPrefix("-")
            {
                self.weekIndex = i
                isTotalNegative = true
                break
            }
            if ((starTimes[i] as! String).count>0)||((endTimes[i] as! String).count>0)
            {
                if totalTimeInHours[i] as! String == ""
                {
                    self.weekIndex = i
                    isTotalNegative = true
                    break
                }
                else
                {
                    let totalHours:Double = Double(totalTimeInHours[i] as! String)!
                    if totalHours == 0
                    {
                        self.weekIndex = i
                        isTotalNegative = true
                        break
                    }
                }
            }
            
        }
        
        if isTotalNegative
        {
            ServerService.ShowAlertMessage(ErrorMessage: "", title: "Please make sure \(weekedays[weekIndex]) total hours should not be less than zero or zero.", view: self)
            isTotalNegative = false
        }
        else
        {
            if checkBoxAction.isSelected
            {
                let totalHoursLabel:Double = Double(totalLabel.text!)!
                if totalHoursLabel == 0
                {
                    ServerService.ShowAlertMessage(ErrorMessage: "", title:"Timeslip Total hour should not be zero.", view: self)
                }
                else if totalHoursLabel<0.5
                {
                    ServerService.ShowAlertMessage(ErrorMessage: "", title:"Timeslip Total hour should be greater than 0.5 hour.", view: self)
                }
                else
                {
                    if object["WeekDays"].arrayValue.count>0
                    {
                        for t in 0..<conformationHoursLabels.count
                        {
                            conformationWeekdaysLabels[t].text = getFormattedDateToPopUp(string:object["WeekDays"][t].stringValue).uppercased()
                            conformationHoursLabels[t].text = totalTimeInHours[t] as? String
                        }
                        
                        if UIDevice.current.orientation == .portrait {
                            conformationView.frame = CGRect(x: 10, y:self.view.bounds.size.height/2-240, width:self.view.bounds.size.width-20, height:480)
                        }
                        else if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
                            
                            conformationView.frame = CGRect(x: 10, y:20, width:self.view.bounds.size.width-20, height:self.view.bounds.size.height-40)
                        }
                        
                        //  conformationView.frame = CGRect(x: 10, y:self.view.bounds.size.height/2-240, width:self.view.bounds.size.width-20, height:480)
                        let totalHoursLabel:Double = Double(totalLabel.text!)!
                        conformationTotalLabel.text = "Total Hours:"+String(format:"%.2f",totalHoursLabel)
                        blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
                        blurEffectView = UIVisualEffectView(effect: blurEffect)
                        blurEffectView.frame = view.bounds
                        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                        blurEffectView.contentView.addSubview(conformationView)
                        view.addSubview(blurEffectView)
                        
                    }
                }
            }
            else
            {
                
                let attributedString = NSAttributedString(string: "If you do not agree to the statement below, you can't submit your hours through this system. Contact your personal representative to discuss this further.", attributes: [
                    NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), //your font here
                    NSAttributedStringKey.foregroundColor : UIColor.red
                ])
                let alert = UIAlertController(title: "", message: "",  preferredStyle: .alert)
                alert.setValue(attributedString, forKey: "attributedTitle")
                let ok = UIAlertAction(title: "Ok",
                                       style: .default) { (action: UIAlertAction!) -> Void in
                }
                alert.addAction(ok)
                present(alert,animated: true,completion: nil)
                
            }
        }
    }
    
    @IBAction func correctAction(_ sender: UIButton) {
        
        
        blurEffectView.removeFromSuperview()
        var times = Array<[String:Any]>()
        for i in 0..<7
        {
            /*
             public string BreakStart1 { get; set; }
             public string BreakEnd1 { get; set; }
             public string BreakStart2 { get; set; }
             public string BreakEnd2 { get; set; }
             public Decimal MinuteBreak1 { get; set; }
             public Decimal MinuteBreak2 { get; set; }
             */
            
            if((self.starTimes[i] as! String).count>0)&&((self.endTimes[i]as! String).count>0)
            {
                let time = [ "Day" : i+1,
                             "StartTime" : self.starTimes[i],
                             "EndTime" : self.endTimes[i],
                             "LunchTime" : self.lunchHours[i],
                             "TaxiTime" : self.taxAmount[i],
                             "TotalTime": self.totalTimeInHours[i],
                             "CurrentDate" : self.dates[i],
                             "BreakStart1": self.mealOut1[i],
                             "BreakEnd1": self.mealreturn1[i],
                             "BreakStart2": self.mealOut2[i],
                             "BreakEnd2": self.mealReturn2[i]
                ]
                times.append(time)
            }
            else
            {
                let time = [ "Day" : i+1,
                             "StartTime" : "",
                             "EndTime" : "",
                             "LunchTime" : "",
                             "TaxiTime" : "",
                             "TotalTime": "",
                             "CurrentDate" : self.dates[i],
                             "BreakStart1": self.mealOut1[i],
                             "BreakEnd1": self.mealreturn1[i],
                             "BreakStart2": self.mealOut2[i],
                             "BreakEnd2": self.mealReturn2[i]
                ]
                times.append(time)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
            ANLoader.hide()
        })
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:self.view)
            //ANLoader.showLoading("", disableUI:true)
            let submitParams = ["CandidateId" :(UserDefaults.standard.object(forKey: "cID") as! String),"WeekEndDate" :self.weekEnd,"Times":times,"HolidayWorkStatus":0,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"Division":self.division,"MaxPay":self.object["MaxPay"].stringValue,"WaiverType_30K_Order":self.object["WaiverType_30K_Order"].stringValue] as [String : Any]
            self.insertTimes = times
            print(submitParams)
            ServerService.getDuplicateTimeSlips(self, params:submitParams, method: "POST", accessToken:Constants.Token, acces:true, callBack: self.getresponseFoDuplicate(response:))
        }
        else
        {
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
        
        
    }
    
    //aftergettingResponseFrom the server
    func getresponseFoDuplicate(response:AnyObject)->()
    {
        
        ANLoader.hide()
        ServerService.hideProgressView()
        print(response)
        duplicateResponse = response as! JSON
        warningStatus = duplicateResponse["IsWarningConfirmed"].stringValue
        if duplicateResponse["ConfictTimeSlip"].intValue == 0
        {
            self.methodToSubmit()
            
        }
        
        else if duplicateResponse["ErrorMessage"].stringValue.contains("holiday")
        {
            
            let words = duplicateResponse["ErrorMessage"].stringValue.components(separatedBy: " ")
            var result = String()
            
            for char in 0..<words.count {
                if char == 7 || char == 8
                {
                }
                else {
                    result += " "+words[char]
                }
            }
            
            
            let attributedString = NSAttributedString(string:result, attributes: [
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), //your font here
                NSAttributedStringKey.foregroundColor : UIColor.red
            ])
            let alert = UIAlertController(title: "", message: "",  preferredStyle: .alert)
            alert.setValue(attributedString, forKey: "attributedTitle")
            let ok = UIAlertAction(title: "YES",
                                   style: .default) { (action: UIAlertAction!) -> Void in
                DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
                    ANLoader.hide()
                })
                if ConnectionCheck.isConnectedToNetwork()
                {
                    
                    ServerService.showActivityIndicatory(uiView:self.view)
                    //ANLoader.showLoading("", disableUI:true)
                    let submitParams = ["CandidateId" :(UserDefaults.standard.object(forKey: "cID") as! String),"WeekEndDate" :self.weekEnd,"Times": self.insertTimes,"HolidayWorkStatus":1,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String] as [String : Any]
                    print(submitParams)
                    ServerService.getDuplicateTimeSlips(self, params:submitParams, method: "POST", accessToken:Constants.Token, acces:true, callBack: self.getresponseFoDuplicate(response:))
                }
                else
                {
                    ANLoader.hide()
                    ServerService.hideProgressView()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                }
                
                
            }
            let cancel = UIAlertAction(title: "NO",
                                       style: .destructive) { (action: UIAlertAction!) -> Void in
                
            }
            alert.addAction(cancel)
            alert.addAction(ok)
            present(alert,animated: true,completion: nil)
        }
        else
        {
            ServerService.hideProgressView()
            let attributedString = NSAttributedString(string:duplicateResponse["ErrorMessage"].stringValue, attributes: [
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), //your font here
                NSAttributedStringKey.foregroundColor : UIColor.red
            ])
            let alert = UIAlertController(title: "", message: "",  preferredStyle: .alert)
            alert.setValue(attributedString, forKey: "attributedTitle")
            let ok = UIAlertAction(title: "Ok",
                                   style: .default) { (action: UIAlertAction!) -> Void in
            }
            alert.addAction(ok)
            present(alert,animated: true,completion: nil)
        }
    }
    
    func methodToSubmit()
    {
        if documentsArray.count>0
        {
            for doc in 0..<documentsArray.count
            {
                let docs = [ "DocFile" : documetBytes[doc],
                             "FileName" : self.documentsArray[doc],
                             "DocExtension" : self.fileExtensions[doc],
                             "DocDescription" : self.documentsArray[doc]]
                listOfDocuments.append(docs)
            }
        }
        
        let totalHoursLabel:Double = Double(totalLabel.text!)!
        if totalHoursLabel == 0
        {
            ServerService.ShowAlertMessage(ErrorMessage: "", title:"Timeslip Total hour should not be zero.", view: self)
        }
        else
        {
            if totalHoursLabel < 0.5
            {
                ServerService.ShowAlertMessage(ErrorMessage: "", title:"Timeslip Total hour should be greater than 0.5 hour", view: self)
            }
            else
            {
                let params = ["CandidateId" : (UserDefaults.standard.object(forKey: "cID") as! String),
                              "ClientId" : object["ClientId"].intValue,
                              "OrderId" : orderId,
                              "DivisionId" : (UserDefaults.standard.object(forKey: "dID") as! String),
                              "CompanyName" :clientNameLabel.text!,
                              "ConfictTimeSlip" : 0,
                              "TimeId" : object["TimeId"].intValue,
                              "IsChecked" : "true",
                              "Notes" : noteTextView.text!,
                              "LegalDivision" : 0,
                              "LunchTimeMonday" : lunchHours[0],
                              "LunchTimeTuesday" : lunchHours[1],
                              "LunchTimeWednesday": lunchHours[2],
                              "LunchTimeThursday" : lunchHours[3],
                              "LunchTimeFriday" : lunchHours[4],
                              "LunchTimeSaturday" : lunchHours[5],
                              "LunchTimeSunday" : lunchHours[6],
                              "MaxPay" :object["MaxPay"].intValue,
                              "TimeSlipTotal": totalHoursLabel,
                              "TotalTimeMonday" : self.totalTimeInHours[0],
                              "TotalTimeTuesday" : self.totalTimeInHours[1],
                              "TotalTimeWednesday" : self.totalTimeInHours[2],
                              "TotalTimeThursday" : self.totalTimeInHours[3],
                              "TotalTimeFriday" : self.totalTimeInHours[4],
                              "TotalTimeSaturday" :self.totalTimeInHours[5],
                              "TotalTimeSunday" :self.totalTimeInHours[6],
                              "WeekendDate" : weekEnd,
                              "Times" : insertTimes,
                              "CalendarTotalYtdPay" : object["CalendarTotalYtdPay"].stringValue,
                              "FiscalTotalYtdPay" : object["FiscalTotalYtdPay"].stringValue,
                              "HoursLeft" : object["HoursLeft"].stringValue,
                              "POCertifier" : object["POCertifier"].stringValue,
                              "HcCodeFormSigned":object["HcCodeFormSigned"].stringValue,
                              "HolidayExists":object["HolidayExists"].stringValue,
                              "WageRateFormSigned":object["WageRateFormSigned"].stringValue,
                              "IsWarningConfirmed":warningStatus,
                              "TaxiOk":object["TaxiOk"].intValue,
                              "UplIds":object["UplIds"].stringValue,
                              "TaxiFareMonday":taxAmount[0],
                              "TaxiFareTuesday":taxAmount[1],
                              "TaxiFareWednesday":taxAmount[2],
                              "TaxiFareThursday":taxAmount[3],
                              "TaxiFareFriday":taxAmount[4],
                              "TaxiFareSaturday":taxAmount[5],
                              "TaxiFareSunday":taxAmount[6],
                              "listCandidateExpenseDocUpload":self.listOfDocuments,
                              "Division":division,
                ] as [String : Any]
                
                
                var ActivityTimeFiveMonday = ""
                var ActivityTimeFiveTuesday = ""
                var ActivityTimeFiveWednesday = ""
                var ActivityTimeFiveThursday = ""
                var  ActivityTimeFiveFriday = ""
                var ActivityTimeFiveSaturday = ""
                var ActivityTimeFiveSunday = ""
                var    ActivityTimeSixMonday = ""
                var ActivityTimeSixTuesday = ""
                var  ActivityTimeSixWednesday = ""
                var ActivityTimeSixThursday = ""
                var ActivityTimeSixFriday = ""
                var ActivityTimeSixSaturday = ""
                var ActivityTimeSixSunday = ""
                var ActivityTimeTenMonday = ""
                var ActivityTimeTenTuesday = ""
                var ActivityTimeTenWednesday = ""
                var ActivityTimeTenThursday = ""
                var ActivityTimeTenFriday = ""
                var ActivityTimeTenSaturday = ""
                var ActivityTimeTenSunday = ""
                var ActivityTimeTwelveMonday = ""
                var ActivityTimeTwelveTuesday = ""
                var ActivityTimeTwelveWednesday = ""
                var ActivityTimeTwelveThursday = ""
                var ActivityTimeTwelveFriday = ""
                var ActivityTimeTwelveSaturday = ""
                var ActivityTimeTwelveSunday = ""
                
                if (five[0] as! String).count>0 && (fiveMin[0] as! String).count>0
                {
                    ActivityTimeFiveMonday = "\(five[0]).\(fiveMin[0])"
                }
                if (five[1] as! String).count>0 && (fiveMin[1] as! String).count>0
                {
                    ActivityTimeFiveTuesday = "\(five[1]).\(fiveMin[1])"
                }
                if (five[2] as! String).count>0 && (fiveMin[2] as! String).count>0
                {
                    ActivityTimeFiveWednesday = "\(five[2]).\(fiveMin[2])"
                }
                if (five[3] as! String).count>0 && (fiveMin[3] as! String).count>0
                {
                    ActivityTimeFiveThursday = "\(five[3]).\(fiveMin[3])"
                }
                if (five[4] as! String).count>0 && (fiveMin[4] as! String).count>0
                {
                    ActivityTimeFiveFriday = "\(five[4]).\(fiveMin[4])"
                }
                if (five[5] as! String).count>0 && (fiveMin[5] as! String).count>0
                {
                    ActivityTimeFiveSaturday = "\(five[5]).\(fiveMin[5])"
                }
                if (five[6] as! String).count>0 && (fiveMin[6] as! String).count>0
                {
                    ActivityTimeFiveSunday = "\(five[6]).\(fiveMin[6])"
                }
                if (six[0] as! String).count>0 && (sixMin[0] as! String).count>0
                {
                    ActivityTimeSixMonday = "\(six[0]).\(sixMin[0])"
                }
                if (six[1] as! String).count>0 && (sixMin[1] as! String).count>0
                {
                    ActivityTimeSixTuesday = "\(six[1]).\(sixMin[1])"
                }
                if (six[2] as! String).count>0 && (sixMin[2] as! String).count>0
                {
                    ActivityTimeSixWednesday = "\(six[2]).\(sixMin[2])"
                }
                if (six[3] as! String).count>0 && (sixMin[3] as! String).count>0
                {
                    ActivityTimeSixThursday = "\(six[3]).\(sixMin[3])"
                }
                if (six[4] as! String).count>0 && (sixMin[4] as! String).count>0
                {
                    ActivityTimeSixFriday = "\(six[4]).\(sixMin[4])"
                }
                if (six[5] as! String).count>0 && (sixMin[5] as! String).count>0
                {
                    ActivityTimeSixSaturday = "\(six[5]).\(sixMin[5])"
                }
                if (six[6] as! String).count>0 && (sixMin[6] as! String).count>0
                {
                    ActivityTimeSixSunday = "\(six[6]).\(sixMin[6])"
                }
                if (ten[0] as! String).count>0 && (tenMin[0] as! String).count>0
                {
                    ActivityTimeTenMonday = "\(ten[0]).\(tenMin[0])"
                }
                if (ten[1] as! String).count>0 && (tenMin[1] as! String).count>0
                {
                    ActivityTimeTenTuesday = "\(ten[1]).\(tenMin[1])"
                }
                if (ten[2] as! String).count>0 && (tenMin[2] as! String).count>0
                {
                    ActivityTimeTenWednesday = "\(ten[2]).\(tenMin[2])"
                }
                if (ten[3] as! String).count>0 && (tenMin[3] as! String).count>0
                {
                    ActivityTimeTenThursday = "\(ten[3]).\(tenMin[3])"
                }
                if (ten[4] as! String).count>0 && (tenMin[4] as! String).count>0
                {
                    ActivityTimeTenFriday = "\(ten[4]).\(tenMin[4])"
                }
                if (ten[5] as! String).count>0 && (tenMin[5] as! String).count>0
                {
                    ActivityTimeTenSaturday = "\(ten[5]).\(tenMin[5])"
                }
                if (ten[6] as! String).count>0 && (tenMin[6] as! String).count>0
                {
                    ActivityTimeTenSunday = "\(ten[6]).\(tenMin[6])"
                }
                if (twelve[0] as! String).count>0 && (twelveMin[0] as! String).count>0
                {
                    ActivityTimeTwelveMonday = "\(twelve[0]).\(twelveMin[0])"
                }
                if (twelve[1] as! String).count>0 && (twelveMin[1] as! String).count>0
                {
                    ActivityTimeTwelveTuesday = "\(twelve[1]).\(twelveMin[1])"
                }
                if (twelve[2] as! String).count>0 && (twelveMin[2] as! String).count>0
                {
                    ActivityTimeTwelveWednesday = "\(twelve[2]).\(twelveMin[2])"
                }
                if (twelve[3] as! String).count>0 && (twelveMin[3] as! String).count>0
                {
                    ActivityTimeTwelveThursday = "\(twelve[3]).\(twelveMin[3])"
                }
                if (twelve[4] as! String).count>0 && (twelveMin[4] as! String).count>0
                {
                    ActivityTimeTwelveFriday = "\(twelve[4]).\(twelveMin[4])"
                }
                if (twelve[5] as! String).count>0 && (twelveMin[5] as! String).count>0
                {
                    ActivityTimeTwelveSaturday = "\(twelve[5]).\(twelveMin[5])"
                }
                if (twelve[6] as! String).count>0 && (twelveMin[6] as! String).count>0
                {
                    ActivityTimeTwelveSunday = "\(twelve[6]).\(twelveMin[6])"
                }
                
                /*
                 if DohNurseForm = true  , coverage_type =0
                 if DohNurseForm = false  , coverage_type =1
                 */
                
                if object["DohNurseForm"].boolValue == true
                {
                    coverageType = 0
                }
                else{
                    coverageType = 1
                }
                
                
                let params2 = ["coverage_type":coverageType,
                               "CandEmail" : object["CandEmail"].stringValue,
                               "DohNurse" : object["DohNurse"].intValue,
                               "activitytimemodel": object["activitytimemodel"].intValue,
                               "ActivityTimeFiveMonday" : ActivityTimeFiveMonday,
                               "ActivityTimeFiveTuesday" :ActivityTimeFiveTuesday ,
                               "ActivityTimeFiveWednesday" : ActivityTimeFiveWednesday,
                               "ActivityTimeFiveThursday" : ActivityTimeFiveThursday,
                               "ActivityTimeFiveFriday" : ActivityTimeFiveFriday,
                               "ActivityTimeFiveSaturday" : ActivityTimeFiveSaturday,
                               "ActivityTimeFiveSunday" : ActivityTimeFiveSunday,
                               "ActivityTimeSixMonday" : ActivityTimeSixMonday,
                               "ActivityTimeSixTuesday" : ActivityTimeSixTuesday,
                               "ActivityTimeSixWednesday" : ActivityTimeSixWednesday,
                               "ActivityTimeSixThursday" : ActivityTimeSixThursday,
                               "ActivityTimeSixFriday" : ActivityTimeSixFriday,
                               "ActivityTimeSixSaturday" : ActivityTimeSixSaturday,
                               "ActivityTimeSixSunday" : ActivityTimeSixSunday,
                               "ActivityTimeTenMonday" : ActivityTimeTenMonday,
                               "ActivityTimeTenTuesday" : ActivityTimeTenTuesday,
                               "ActivityTimeTenWednesday" : ActivityTimeTenWednesday,
                               "ActivityTimeTenThursday" : ActivityTimeTenThursday,
                               "ActivityTimeTenFriday" : ActivityTimeTenFriday,
                               "ActivityTimeTenSaturday" : ActivityTimeTenSaturday,
                               "ActivityTimeTenSunday" : ActivityTimeTenSunday,
                               "ActivityTimeTwelveMonday" : ActivityTimeTwelveMonday,
                               "ActivityTimeTwelveTuesday" : ActivityTimeTwelveTuesday,
                               "ActivityTimeTwelveWednesday" : ActivityTimeTwelveWednesday,
                               "ActivityTimeTwelveThursday" : ActivityTimeTwelveThursday,
                               "ActivityTimeTwelveFriday" : ActivityTimeTwelveFriday,
                               "ActivityTimeTwelveSaturday" : ActivityTimeTwelveSaturday,
                               "ActivityTimeTwelveSunday" : ActivityTimeTwelveSunday,
                               "TotalActivityTimeMonday" : totalForDoh[0],
                               "TotalActivityTimeTuesday" : totalForDoh[1],
                               "TotalActivityTimeWednesday" : totalForDoh[2],
                               "TotalActivityTimeThursday" : totalForDoh[3],
                               "TotalActivityTimeFriday" : totalForDoh[4],
                               "TotalActivityTimeSaturday" : totalForDoh[5],
                               "TotalActivityTimeSunday" : totalForDoh[6],
                               "TotalActivityTimeSlip" : "",
                               "NycLawEmployee" : object["NycLawEmployee"].intValue,
                               "ClientsNotApplicableForDoh" : object["ClientsNotApplicableForDoh"].intValue,
                               "WaiverType_30K_Order":duplicateResponse["WaiverType_30K_Order"].stringValue,"WaiverType":object["WaiverType"].stringValue,"WaiverApproved":object["WaiverApproved"].stringValue,"Source":"iOS"] as [String : Any]
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
                    ANLoader.hide()
                })
                if ConnectionCheck.isConnectedToNetwork()
                {
                    ServerService.showActivityIndicatory(uiView:self.view)
                    let paramTotal = params.merged(with:params2)
                    print(paramTotal)
                    ServerService.getInsertPendingTimeSlip(self, params:paramTotal, method: "POST", accessToken:Constants.Token, acces:true, callBack: getresponseForInsert(response:))
                }
                else
                {
                    ANLoader.hide()
                    ServerService.hideProgressView()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                }
            }
        }
    }
    
    //aftergettingResponseFrom the server
    func getresponseForInsert(response:AnyObject)->()
    {
        ANLoader.hide()
        ServerService.hideProgressView()
        print(response)
        inserObject = response as! JSON
        
        if inserObject["warningmessage"].stringValue == "true"
        {
            let attributedString = NSAttributedString(string:inserObject["ErrorMessage"].stringValue, attributes: [
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), //your font here
                NSAttributedStringKey.foregroundColor : UIColor.red
            ])
            let alert = UIAlertController(title: "", message: "",  preferredStyle: .alert)
            alert.setValue(attributedString, forKey: "attributedTitle")
            let ok = UIAlertAction(title: "YES",
                                   style: .default) { (action: UIAlertAction!) -> Void in
                OperationQueue.main.addOperation({
                    self.warningStatus = "true"
                    self.methodToSubmit()
                })
            }
            let cancel = UIAlertAction(title: "NO",
                                       style: .destructive) { (action: UIAlertAction!) -> Void in
            }
            alert.addAction(cancel)
            alert.addAction(ok)
            present(alert,animated: true,completion: nil)
        }
        else if inserObject["Status"].stringValue == "true"
        {
            
            if UIDevice.current.orientation == .portrait {
                orderconformationView.frame = CGRect(x: 10, y:self.view.bounds.size.height/2-120, width:self.view.bounds.size.width-20, height:240)
            }
            else if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
                orderconformationView.frame = CGRect(x: 10, y:self.view.bounds.size.height/2-120, width:self.view.bounds.size.width-20, height:240)
            }
            //   orderconformationView.frame = CGRect(x: 10, y:self.view.bounds.size.height/2-120, width:self.view.bounds.size.width-20, height:240)
            orderConformationLabel.text = "Timeslip(s) Entered Sucessfully Your confirmation number is \(inserObject["ConfirmationNo"].stringValue)"
            blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.contentView.addSubview(orderconformationView)
            view.addSubview(blurEffectView)
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage: "", title:inserObject["ErrorMessage"].stringValue, view: self)
        }
        
    }
    
    
    
    @IBAction func inCorrectAction(_ sender: UIButton) {
        
        blurEffectView.removeFromSuperview()
    }
    
    @IBAction func EnterAnotherTimeSlip(_ sender: UIButton) {
        blurEffectView.removeFromSuperview()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func orderConformationCancelAction(_ sender: Any) {
        blurEffectView.removeFromSuperview()
        //        let vc1:UIViewController = (self.storyboard?.instantiateViewController(withIdentifier:"dash"))!
        //        let nc1:UINavigationController = self.storyboard?.instantiateViewController(withIdentifier:"dashNavi") as! UINavigationController
        //        nc1.viewControllers = [vc1]
        //        sideMenuController?.embed(centerViewController:nc1)
        
        self.reset = true
        self.totalHours = ["00:00","00:00","00:00","00:00","00:00","00:00","00:00"]
        self.starTimes = ["","","","","","",""]
        self.endTimes = ["","","","","","",""]
        self.lunch1 = ["","","","","","",""]
        self.lunch2 = ["","","","","","",""]
        self.lunchHours = ["","","","","","",""]
        self.totalTimeInHours = ["","","","","","",""]
        self.taxAmount = ["","","","","","",""]
        self.mealOut1 = ["","","","","","",""]
        self.mealreturn1  = ["","","","","","",""]
        self.mealOut2  = ["","","","","","",""]
        self.mealReturn2 = ["","","","","","",""]
        self.totalForDoh = ["","","","","","",""]
        self.totalLabel.text = "0"
        self.isTotalNegative = false
        self.dataCollectionView.scrollToItem(at:IndexPath(item: 0, section: 0), at: .right, animated: false)
        self.dataCollectionView.reloadData()
    }
    
    //function to get date
    func getFormattedDate(string: String) -> String{
        if string.count>10
        {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // This formate is input formated .
        let formateDate = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "EEEE MM/dd/yyyy" // Output Formated
            return dateFormatter.string(from: formateDate)
        }
        else
        {
            return ""
        }
    }
    
    //function to get date for popup
    func getFormattedDateToPopUp(string: String) -> String{
        if string.count>10
        {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.preferredLocale()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // This formate is input formated .
            let formateDate = dateFormatter.date(from: string)!
            dateFormatter.dateFormat = "dd  EEE" // Output Formated
            return dateFormatter.string(from: formateDate)
        }
        else
        {
            return ""
        }
    }
    
    //MARK:- UITextField Delegate Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField.tag>7&&textField.tag<67)
        {
            activeTextField = textField
            activeTextField?.tag = textField.tag
            self.view.endEditing(true)
            if cleared
            {
                cleared = false
            }
            else
            {
                self.showPicker(ampm:false)
            }
            return false
        }
        else
        {
            return true
        }
    }
    
    
    //MARK:- UITextfieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        activeTextField = textField
        activeTextField?.tag = textField.tag
        if (textField.tag>7&&textField.tag<67)
        {
            
            textField.resignFirstResponder()
            index = textField.tag
            
            if cleared
            {
                cleared = false
                textField.endEditing(true)
            }
            else
            {
                self.showPicker(ampm:false)
                
            }
        }
    }
    
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        if (textField.tag>7&&textField.tag<17)
        {
            starTimes.replaceObject(at:textField.tag-8, with:"")
            dataCollectionView.reloadData()
            
        }
        else if (textField.tag>17&&textField.tag<27)
        {
            mealOut1.replaceObject(at:textField.tag-18, with:"")
            lunch1.replaceObject(at:textField.tag-18, with:String(format:""))
            let totalLUnch = (lunch1[textField.tag-18] as! NSString).integerValue + (lunch2[textField.tag-18] as! NSString).integerValue
            lunchHours.replaceObject(at: textField.tag-18, with: String(format:"\(totalLUnch)"))
            self.calculateTheHours(textField.tag-18)
            self.dataCollectionView.reloadData()
            
        }
        else if (textField.tag>27&&textField.tag<37)
        {
            mealreturn1.replaceObject(at:textField.tag-28, with:"")
            lunch1.replaceObject(at:textField.tag-28, with:String(format:""))
            let totalLUnch = (lunch1[textField.tag-28] as! NSString).integerValue + (lunch2[textField.tag-28] as! NSString).integerValue
            lunchHours.replaceObject(at: textField.tag-28, with: String(format:"\(totalLUnch)"))
            self.calculateTheHours(textField.tag-28)
            self.dataCollectionView.reloadData()
        }
        else if (textField.tag>37&&textField.tag<47)
        {
            mealOut2.replaceObject(at:textField.tag-38, with:"")
            lunch2.replaceObject(at:textField.tag-38, with:String(format:""))
            let totalLUnch = (lunch1[textField.tag-38] as! NSString).integerValue + (lunch2[textField.tag-38] as! NSString).integerValue
            lunchHours.replaceObject(at: textField.tag-38, with: String(format:"\(totalLUnch)"))
            self.calculateTheHours(textField.tag-38)
            self.dataCollectionView.reloadData()
        }
        else if (textField.tag>47&&textField.tag<57)
        {
            mealReturn2.replaceObject(at:textField.tag-48, with:"")
            lunch2.replaceObject(at:textField.tag-48, with:String(format:""))
            let totalLUnch = (lunch1[textField.tag-48] as! NSString).integerValue + (lunch2[textField.tag-48] as! NSString).integerValue
            lunchHours.replaceObject(at: textField.tag-48, with: String(format:"\(totalLUnch)"))
            self.calculateTheHours(textField.tag-48)
            self.dataCollectionView.reloadData()
        }
        else if (textField.tag>57)
        {
            endTimes.replaceObject(at:textField.tag-58, with:"")
            dataCollectionView.reloadData()
        }
        
        
        cleared = true
        return true
    }
    
    func calculateTheHours(_ i: Int) {
        if ((self.starTimes[i] as! String).count > 0 && (self.endTimes[i] as! String).count > 0){
            self.getHours(start:self.starTimes[i] as! String, end:self.endTimes[i] as! String, i:i,min:false)
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (textField.tag>7&&textField.tag<17)
        {
            starTimes.replaceObject(at:textField.tag-8, with:textField.text!)
            dataCollectionView.reloadData()
        }
        else if (textField.tag>17&&textField.tag<27)
        {
            mealOut1.replaceObject(at:textField.tag-18, with:textField.text!)
            dataCollectionView.reloadData()
        }
        else if (textField.tag>27&&textField.tag<37)
        {
            mealreturn1.replaceObject(at:textField.tag-28, with:textField.text!)
            dataCollectionView.reloadData()
        }
        else if (textField.tag>37&&textField.tag<47)
        {
            mealOut2.replaceObject(at:textField.tag-38, with:textField.text!)
            dataCollectionView.reloadData()
        }
        else if (textField.tag>47&&textField.tag<57)
        {
            mealReturn2.replaceObject(at:textField.tag-48, with:textField.text!)
            dataCollectionView.reloadData()
        }
        else if (textField.tag>57)
        {
            endTimes.replaceObject(at:textField.tag-58, with:textField.text!)
            dataCollectionView.reloadData()
        }
    }
    
    
    //MARK:- ShowPicker
    func showPicker(ampm:Bool)
    {
        
        let min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
        let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
        let picker = DateTimePicker.show(selected:Date(), minimumDate: min, maximumDate: max)
        let step = object["BindActivityMinutesList"][1].intValue-object["BindActivityMinutesList"][0].intValue
        if step == 30
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.thirty
        }
        else if step == 15
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.fifteen
        }
        else if step == 10
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.ten
        }
        else if step == 5
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.five
        }
        
        else if step == 6
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.six
        }
        else if step == 1
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.default
        }
        else{
            picker.timeInterval = DateTimePicker.MinuteInterval.default
        }
        picker.highlightColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = "Select"
        picker.doneBackgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        picker.locale = Locale.preferredLocale()
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
            
            if (self.activeTextField!.tag>7&&self.activeTextField!.tag<17)
            {
                self.activeTextField?.text = formatter.string(from: date)
                self.starTimes.replaceObject(at:(self.activeTextField?.tag)!-8, with:formatter.string(from: date))
                if (self.endTimes[(self.activeTextField?.tag)!-8] as! String).count > 0 {
                    //  self.getHours(start:self.starTimes[(self.activeTextField?.tag)!-8] as! String, end:self.endTimes[(self.activeTextField?.tag)!-8] as! String, i:(self.activeTextField?.tag)!-8,min:false)
                    self.getAllTheHoursCalculated(i: (self.activeTextField?.tag)!-8, MealType: 0)
                }
            }
            else if (self.activeTextField!.tag>17&&self.activeTextField!.tag<27)
            {
                self.activeTextField?.text = formatter.string(from: date)
                self.mealOut1.replaceObject(at:(self.activeTextField?.tag)!-18, with:formatter.string(from: date))
                if (self.mealreturn1[(self.activeTextField?.tag)!-18] as! String).count > 0 {
                    // self.getHoursForLunch(start: self.mealOut1[(self.activeTextField?.tag)!-18] as! String, end: self.mealreturn1[(self.activeTextField?.tag)!-18] as! String, i: (self.activeTextField?.tag)!-18, min: false, MealType: 1)
                    self.getAllTheHoursCalculated(i: (self.activeTextField?.tag)!-18, MealType: 1)
                }
                
            }
            else if (self.activeTextField!.tag>27&&self.activeTextField!.tag<37)
            {
                self.activeTextField?.text = formatter.string(from: date)
                self.mealreturn1.replaceObject(at:(self.activeTextField?.tag)!-28, with:formatter.string(from: date))
                if (self.mealOut1[(self.activeTextField?.tag)!-28] as! String).count > 0 {
                    // self.getHoursForLunch(start: self.mealOut1[(self.activeTextField?.tag)!-28] as! String, end: self.mealreturn1[(self.activeTextField?.tag)!-28] as! String, i: (self.activeTextField?.tag)!-28, min: false, MealType: 1)
                    self.getAllTheHoursCalculated(i: (self.activeTextField?.tag)!-28, MealType: 1)
                }
            }
            else if (self.activeTextField!.tag>37&&self.activeTextField!.tag<47)
            {
                self.activeTextField?.text = formatter.string(from: date)
                self.mealOut2.replaceObject(at:(self.activeTextField?.tag)!-38, with:formatter.string(from: date))
                if (self.mealReturn2[(self.activeTextField?.tag)!-38] as! String).count > 0 {
                    //  self.getHoursForLunch(start: self.mealOut2[(self.activeTextField?.tag)!-38] as! String, end: self.mealReturn2[(self.activeTextField?.tag)!-38] as! String, i: (self.activeTextField?.tag)!-38, min: false, MealType: 2)
                    self.getAllTheHoursCalculated(i: (self.activeTextField?.tag)!-38, MealType: 2)
                }
            }
            else if (self.activeTextField!.tag>47&&self.activeTextField!.tag<57)
            {
                self.activeTextField?.text = formatter.string(from: date)
                self.mealReturn2.replaceObject(at:(self.activeTextField?.tag)!-48, with:formatter.string(from: date))
                if (self.mealOut2[(self.activeTextField?.tag)!-48] as! String).count > 0 {
                    // self.getHoursForLunch(start: self.mealOut2[(self.activeTextField?.tag)!-48] as! String, end: self.mealReturn2[(self.activeTextField?.tag)!-48] as! String, i: (self.activeTextField?.tag)!-48, min: false, MealType: 2)
                    self.getAllTheHoursCalculated(i: (self.activeTextField?.tag)!-48, MealType: 2)
                }
            }
            else if (self.activeTextField!.tag>57)
            {
                self.activeTextField?.text = formatter.string(from: date)
                self.endTimes.replaceObject(at:(self.activeTextField?.tag)!-58, with:formatter.string(from: date))
                if (self.starTimes[(self.activeTextField?.tag)!-58] as! String).count > 0 {
                    // self.getHours(start:self.starTimes[(self.activeTextField?.tag)!-58] as! String, end:self.endTimes[(self.activeTextField?.tag)!-58] as! String, i:(self.activeTextField?.tag)!-58,min:false)
                    self.getAllTheHoursCalculated(i: (self.activeTextField?.tag)!-58, MealType: 0)
                }
            }
            self.dataCollectionView.reloadData()
        }
        picker.delegate = self
        NotificationCenter.default.post(name: Notification.Name("Time"), object: nil)
    }
    
    //MARK:- Time Calculations
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
            dateFormatterf.dateFormat = "h:mm aa"
        }
        
        let dateee = dateFormatterf.date(from: tt)
        dateFormatterf.dateFormat = "HH:mm"
        if (dateee != nil)
        {
            let Date24 = dateFormatterf.string(from: dateee!)
            print("24 hour formatted Date:",Date24)
            return Date24
        }
        else
        {
            return ""
        }
    }
    func addTimes(start:String,end:String,min:Bool) -> Int
    {
        let startDate = start
        let endDate = end
        
        let startArray = startDate.components(separatedBy: (":"))
        let endArray = endDate.components(separatedBy: (":"))
        
        let startHours = startArray[0].integerValue * 60
        let startMinutes = startArray[1].integerValue + startHours
        
        let endHours = endArray[0].integerValue * 60
        let endMinutes = endArray[1].integerValue + endHours
        
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
            totalTimeInHours.replaceObject(at:i, with:String(format:"-%.2f",totalTimeConversionArray))
        }
        else{
            totalTimeInHours.replaceObject(at:i, with:String(format:"%.2f",totalTimeConversionArray))
        }
        
        if (lunchHours[i] as! NSString) != "" && (lunchHours[i] as! NSString).doubleValue > 0 {
            let lunchTime = (lunchHours[i] as! NSString).doubleValue
            let timeInTotal = (totalTimeInHours[i] as! NSString).doubleValue
            totalTimeInHours.replaceObject(at:i, with:String(format:"%.2f",timeInTotal-lunchTime/60))
        }
        self.dataCollectionView.reloadData()
        self.addTotal()
    }
    
    
    func getHoursForLunch(start:String,end:String,i:Int,min:Bool,MealType:Int)
    {
        
        //  print("\(self.findDateDiff(time1Str: start, time2Str: end))")
        //        let finalLunchMinutes = self.addTimes(start:self.convertDate(date:start,min:min), end: self.convertDate(date:end,min:min),min:min)
        
        let finalLunchMinutes = self.findDateDiff(time1Str: start, time2Str: end)
        print(finalLunchMinutes)
        if MealType == 1 {
            lunch1.replaceObject(at:i, with:String(format:"\(finalLunchMinutes)"))
        }
        else {
            lunch2.replaceObject(at:i, with:String(format:"\(finalLunchMinutes)"))
        }
        let totalLUnch = (lunch1[i] as! NSString).integerValue + (lunch2[i] as! NSString).integerValue
        lunchHours.replaceObject(at: i, with: String(format:"\(totalLUnch)"))
        
        if (totalTimeInHours[i] as! NSString) != "" && (totalTimeInHours[i] as! NSString).doubleValue > 0 {
            let lunchTime = (lunchHours[i] as! NSString).doubleValue
            let timeInTotal = (totalTimeInHours[i] as! NSString).doubleValue
            totalTimeInHours.replaceObject(at:i, with:String(format:"%.2f",timeInTotal-lunchTime/60))
        }
        self.dataCollectionView.reloadData()
        self.addTotal()
        
    }
    
    func getAllTheHoursCalculated(i:Int,MealType:Int)
    {
        if (starTimes[i] as! String).count > 0 && (endTimes[i] as! String).count > 0{
            let tuple = minutesToHoursMinutes(minutes: self.addTimes(start:self.convertDate(date:starTimes[i] as! String,min:false), end: self.convertDate(date:endTimes[i] as! String,min:false),min:false))
            
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
                totalTimeInHours.replaceObject(at:i, with:String(format:"-%.2f",totalTimeConversionArray))
            }
            else{
                totalTimeInHours.replaceObject(at:i, with:String(format:"%.2f",totalTimeConversionArray))
            }
        }
        if MealType == 1 {
            if (mealOut1[i] as! String).count > 0 && (mealreturn1[i] as! String).count > 0{
                let finalLunchMinutes = self.findDateDiff(time1Str: mealOut1[i] as! String, time2Str: mealreturn1[i] as! String)
                lunch1.replaceObject(at:i, with:String(format:"\(finalLunchMinutes)"))
            }
        }
        if MealType == 2 {
            if (mealOut2[i] as! String).count > 0 && (mealReturn2[i] as! String).count > 0{
                let finalLunchMinutes = self.findDateDiff(time1Str: mealOut2[i] as! String, time2Str: mealReturn2[i] as! String)
                lunch2.replaceObject(at:i, with:String(format:"\(finalLunchMinutes)"))
            }
        }
        
        let totalLUnch = (lunch1[i] as! NSString).integerValue + (lunch2[i] as! NSString).integerValue
        lunchHours.replaceObject(at: i, with: String(format:"\(totalLUnch)"))
        
        if (totalTimeInHours[i] as! NSString) != "" && (totalTimeInHours[i] as! NSString).doubleValue > 0 {
            let lunchTime = (lunchHours[i] as! NSString).doubleValue
            let timeInTotal = (totalTimeInHours[i] as! NSString).doubleValue
            totalTimeInHours.replaceObject(at:i, with:String(format:"%.2f",timeInTotal-lunchTime/60))
        }
        self.dataCollectionView.reloadData()
        self.addTotal()
        
    }
    
    
    //MARK:- TimePickerRH
    func timePickerRH()
    {
        customPickerView = Bundle.main.loadNibNamed("PickerView", owner: self, options: nil)?[0] as! Picker
        customPickerView.frame = CGRect(x: 0,y:0,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
        
        customPickerView.pickerView.delegate = self
        customPickerView.pickerView.dataSource = self
        customPickerView.minPickerView.delegate = self
        customPickerView.minPickerView.dataSource = self
        customPickerView.showPickerViewOnSuperView(superView:(self.navigationController?.view)!)
        customPickerView.pickerDelegate = self
    }
    
    //MARK:- AddTotal
    func addTotal()
    {
        var toatHours = Double()
        for i in 0..<7
        {
            var hours = Double()
            if totalTimeInHours[i] as! String != ""
            {
                hours = Double(totalTimeInHours[i] as! String)!
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
        for total in 0..<totalTimeInHours.count
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
    
    func findDateDiff(time1Str: String, time2Str: String) -> String {
        let timeformatter = DateFormatter()
        timeformatter.locale = Locale.preferredLocale()
        timeformatter.dateFormat = "hh:mm aa"
        
        guard let time1 = timeformatter.date(from: time1Str),
              let time2 = timeformatter.date(from: time2Str) else { return "" }
        
        //You can directly use from here if you have two dates
        
        let interval = time2.timeIntervalSince(time1)
        let hour = interval / 3600;
        //let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
        let intervalInt = Int(interval)
        return "\(Int(hour*60))" //returning minutes
        // return "\(intervalInt < 0 ? "-" : "") \(Int(hour*60)) Minutes"
    }
}


extension CAEnterTimeSlipsController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CACollectionHeaderCell", for: indexPath) as! CACollectionHeaderCell
            if days.count == 7 {
                cell.mealOut2Label.isHidden = true
                cell.mealReturn2Label.isHidden = true
                cell.endTimeTop.constant = 2
            }
            else {
                cell.mealOut2Label.isHidden = false
                cell.mealReturn2Label.isHidden = false
                cell.endTimeTop.constant = 96
            }
            /*
             cell.startTimeLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
             cell.endTimeLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
             cell.lunchMinLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
             cell.totalLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
             cell.mealOut1Label.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
             cell.mealReturn1Label.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
             cell.mealOut2Label.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
             cell.mealReturn2Label.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
             */
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CAMultiBreakCollectionCell", for: indexPath) as! CAMultiBreakCollectionCell
            cell.dateLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
            cell.dateLabel.text =  getFormattedDate(string:object["WeekDays"][indexPath.row-1].stringValue).capitalizingFirstLetter()
            
            cell.startTimeTF.delegate = self
            cell.mealOut1TF.delegate   = self
            cell.mealReturn1TF.delegate = self
            cell.mealOut2TF.delegate   = self
            cell.mealReturn2TF.delegate = self
            cell.endTimeTF.delegate = self
            
            cell.startTimeTF.tag = 7+indexPath.item
            cell.mealOut1TF.tag   = 17+indexPath.item
            cell.mealReturn1TF.tag =  27+indexPath.item
            cell.mealOut2TF.tag   = 37+indexPath.item
            cell.mealReturn2TF.tag =  47+indexPath.item
            cell.endTimeTF.tag = 57+indexPath.item
            
            if days.count == 7 {
                cell.mealOut2TF.isHidden = true
                cell.mealReturn2TF.isHidden = true
                cell.endTimeTop.constant = 2
            }
            else {
                cell.mealOut2TF.isHidden = false
                cell.mealReturn2TF.isHidden = false
                cell.endTimeTop.constant = 96
            }
            if object["\(disWeekdays[indexPath.row-1])"].intValue == 0
            {
                cell.startTimeTF.isEnabled = false
                cell.mealOut1TF.isEnabled = false
                cell.mealReturn1TF.isEnabled = false
                cell.mealOut2TF.isEnabled = false
                cell.mealReturn2TF.isEnabled = false
                cell.endTimeTF.isEnabled = false
                cell.startTimeTF.backgroundColor = UIColor(hexString:"#EEEEEE")
                cell.mealOut1TF.backgroundColor =     UIColor(hexString:"#EEEEEE")
                cell.mealReturn1TF.backgroundColor = UIColor(hexString:"#EEEEEE")
                cell.mealOut2TF.backgroundColor = UIColor(hexString:"#EEEEEE")
                cell.mealReturn2TF.backgroundColor = UIColor(hexString:"#EEEEEE")
                cell.endTimeTF.backgroundColor = UIColor(hexString:"#EEEEEE")
                cell.startTimeTF.leftView?.isHidden = true
                cell.mealOut1TF.leftView?.isHidden = true
                cell.mealReturn1TF.leftView?.isHidden = true
                cell.mealOut2TF.leftView?.isHidden = true
                cell.mealReturn2TF.leftView?.isHidden = true
                cell.endTimeTF.leftView?.isHidden = true
            }
            else
            {
                cell.startTimeTF.isEnabled = true
                cell.mealOut1TF.isEnabled = true
                cell.mealReturn1TF.isEnabled = true
                cell.mealOut2TF.isEnabled = true
                cell.mealReturn2TF.isEnabled = true
                cell.endTimeTF.isEnabled = true
                cell.startTimeTF.backgroundColor = .white
                cell.mealOut1TF.backgroundColor =  .white
                cell.mealReturn1TF.backgroundColor = .white
                cell.mealOut2TF.backgroundColor = .white
                cell.mealReturn2TF.backgroundColor = .white
                cell.endTimeTF.backgroundColor = .white
                cell.startTimeTF.leftView?.isHidden = false
                cell.mealOut1TF.leftView?.isHidden = false
                cell.mealReturn1TF.leftView?.isHidden = false
                cell.mealOut2TF.leftView?.isHidden = false
                cell.mealReturn2TF.leftView?.isHidden = false
                cell.endTimeTF.leftView?.isHidden = false
            }
            cell.startTimeTF.text = starTimes[indexPath.item-1] as? String
            cell.mealOut1TF.text = mealOut1[indexPath.item-1] as? String
            cell.mealReturn1TF.text = mealreturn1[indexPath.item-1] as? String
            cell.mealOut2TF.text = mealOut2[indexPath.item-1] as? String
            cell.mealReturn2TF.text = mealReturn2[indexPath.item-1] as? String
            cell.lunchMinTF.text = lunchHours[indexPath.item-1] as? String
            cell.endTimeTF.text = endTimes[indexPath.item-1] as? String
            
            if (cell.startTimeTF.text!.count>0)&&(cell.endTimeTF.text?.count)!>0
            {
                cell.totalTF.text = totalTimeInHours[indexPath.row-1] as? String
            }
            else
            {
                cell.totalTF.text = ""
                totalTimeInHours.replaceObject(at:indexPath.row-1, with:"")
                total()
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    
}

/*
 extension CAEnterTimeSlipsController: UICollectionViewDelegateFlowLayout {
 
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
 return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
 }
 
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
 return CGSize(width: 115, height: 417)
 }
 
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
 return 0.0
 }
 
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
 return 0.0
 }
 }
 */
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
extension CAEnterTimeSlipsController: UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
}
extension CAEnterTimeSlipsController: UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView == customPickerView.minPickerView
        {
            return 5
        }
        return 13
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == customPickerView.minPickerView
        {
            
            return mins[row]
        }
        else
        {
            return hrs[row]
        }
    }
}

extension CAEnterTimeSlipsController:DateTimePickerDelegate
{
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        print(picker.selectedDateString)
    }
}

extension CAEnterTimeSlipsController:pickerDelegate
{
    func selected(time:String) {
        print(time)
        activeTextField?.text = time
    }
    
}

extension UIViewController {
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
}

extension UIView {
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
}
