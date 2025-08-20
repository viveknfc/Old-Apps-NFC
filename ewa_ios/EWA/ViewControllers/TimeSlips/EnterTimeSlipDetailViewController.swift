//
//  EnterTimeSlipDetailViewController.swift
//  EWA
//
//  Created by NFC Solutions on 14/11/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toast_Swift
import MobileCoreServices
import SideMenuController
import ANLoader
import CropViewController
import SideMenuController

enum UIUserInterfaceIdiom : Int {
    case unspecified
    case phone // iPhone and iPod touch style UI
    case pad // iPad style UI
}


class EnterTimeSlipDetailViewController: UIViewController,UITextFieldDelegate,UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CropViewControllerDelegate {
    
    @IBOutlet weak var editDetailsButton: UIButton!
    @IBOutlet weak var orderdetailsBottom: NSLayoutConstraint! //10 - 45
    @IBOutlet weak var oredrDetailsView: UIView! //138 - 175
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var clientNameLabel: UILabel!
    var object: JSON = JSON.null
    var formObject: JSON = JSON.null
    var picUploadData:JSON = JSON.null
    @IBOutlet var orderIdLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var noteTextView: UITextView!
    @IBOutlet var timeSlipTableView: UITableView!
    var weekEnd = String()
    var orderId = String()
    var theme: SambagTheme = .light
    
    var index = Int()
    var activeTextField: UITextField?
    var actfield:UITextField?
    var starTimes = NSMutableArray()
    var endTimes   = NSMutableArray()
    var lunchHours  = NSMutableArray()
    var totalHours = NSMutableArray()
    var totalTimeInHours = NSMutableArray()
    var dates = NSMutableArray()
    var taxAmount = NSMutableArray()
    var documentsArray = NSMutableArray()
    var documetBytes = NSMutableArray()
    var fileExtensions = NSMutableArray()
    var listOfDocuments = Array<[String:Any]>()
    
    var TotalFiles = Array<Any>()
    
    var duplicateResponse: JSON = JSON.null
    var inserObject:JSON = JSON.null
    var  docDeleteObject:JSON = JSON.null
    
    var isTotalNegative = Bool()
    var insertTimes = Array<[String:Any]>()
    @IBOutlet var checkBoxAction: KGRadioButton!
    @IBOutlet var weekEndLabel: UILabel!
    var reset = Bool()
    var weekdays = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
    var cleared = Bool()
    var warningStatus = String()
    
    @IBOutlet var timeSlipTotalLabel: UILabel!
    @IBOutlet var documentsTableView: UITableView!
    
    @IBOutlet var uploadHeight: NSLayoutConstraint!
    @IBOutlet var documentsView: UIView!
    @IBOutlet var topView: UIView!
    
    @IBOutlet var uploadReceipts: ShadowButton!
    @IBOutlet var bottomViewTableView: UIView!
    @IBOutlet var notesHeight: NSLayoutConstraint!
    var blurEffect = UIBlurEffect()
    var blurEffectView = UIVisualEffectView()
    var fileData = Data()
    var fileBytes = String()
    var division = String()
    
    @IBOutlet var dohTableView: UITableView!
    @IBOutlet var dohForm: UIView!
    @IBOutlet var dohTotalLabel: UILabel!
    @IBOutlet var dohTotalTime: PaddingLabel!
    @IBOutlet var dohView: NSLayoutConstraint!
    @IBOutlet var dohViewForm: UIView!
    @IBOutlet var dohHeightContsrain: NSLayoutConstraint!
    
    var five = NSMutableArray()
    var ten = NSMutableArray()
    var six = NSMutableArray()
    var twelve = NSMutableArray()
    
    var fiveMin = NSMutableArray()
    var tenMin = NSMutableArray()
    var sixMin = NSMutableArray()
    var twelveMin = NSMutableArray()
    var totalForDoh = NSMutableArray()
    var coverageType = Int()
    @IBOutlet var infoHeaderView: UIView!
    @IBOutlet var infoView: UIView!
    @IBOutlet var informationTable: UITableView!
    
    @IBOutlet weak var topInfoView: UIView!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var infoViewHeight: NSLayoutConstraint!
    let Headers = ["SCHOOL HEALTH Nursing FUNCTIONS","Walk ins","Case Management","Health Education/Presentation","Special Initiatives","School Community","MISC."]
    let Codes = ["5","5","5","5","5","5","5","5","5","6","6","6","5","10","10","6","10","12","12","5","5","5","5","10"]
    
    let Titles = ["Processing of Medication Administration Forms (MAFs)","Processing of returned referral forms","Unscheduled walk in visits","Scheduled walk in visits","Administration of medications","Administration of procedures","Documentation of services provided","Consultation on Review of Medical Immunization Exemption Requests","Follow up of identified health problems","Telephone outreach to Parents","Communicable disease consults","Consultations with school physicians","Scheduling of MD sessions","Review Health issues with school staff/teacher /nurse conference","Quality assessment/Maintenance of Medical Room/Inventory","Parent/Teacher Conferences","Supervision of Support Staff (PH Advisor/PH Assistants)","Trainings (Epi-pen/ Glucagon/Open airways)","Health Education Presentations/Faculty presentations","CATCH Sessions","HOP","STARS","Wellness Council/committees/meetings","Lunch"]
    
    
    @IBOutlet var tableViewBottom: NSLayoutConstraint!
    
    
    @IBOutlet var conformationView: UIView!
    @IBOutlet var conformationHeaderLabel: UILabel!
    @IBOutlet var conformationWeekdaysLabels: [UILabel]!
    @IBOutlet var conformationHoursLabels: [UILabel]!
    @IBOutlet var conformationTotalLabel: UILabel!
    
    
    @IBOutlet var orderconformationView: UIView!
    
    @IBOutlet var orderConformationLabel: UILabel!
    @IBOutlet var wouldYouLikeButton: UIButton!
    var customPickerView = Picker()
    let hrs = ["00","01","02","03","04","05","06","07","08","09","10","11","12"]
    let mins = ["00","15","30","45","60"]
    var weekedays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    var weekIndex = -1
    
    
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("***VIV EnterTimeSlipDetailViewController***")
        // Do any additional setup after loading the view.
        //calling the api
        print(String(describing: EnterTimeSlipDetailViewController.self))
        
        nameLabel.text = "Timeslip For \(UserDefaults.standard.object(forKey:"CandName") as! String)"
        
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        self.navigationItem.title = "Enter Timeslips"
        
        //        let params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"WeekendDate":weekEnd,"OrderId":orderId,"Division":division]
        //        ServerService.getEnterTimeSlip(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponse(response:))
       // timeSlipTableView.register(UINib(nibName: "EnterTimeSlipHeaderCell", bundle: nil), forCellReuseIdentifier: "EnterTimeSlipHeaderCell")
        editDetailsButton.isHidden = true
        editDetailsButton.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        self.oredrDetailsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 138)
        self.orderdetailsBottom.constant = 10
        noteTextView.placeholder = ""
        
        noteTextView.layer.borderWidth = 1.5
        noteTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        orderIdLabel.text = orderId
        
        totalHours = ["00:00","00:00","00:00","00:00","00:00","00:00","00:00"]
        starTimes = ["","","","","","",""]
        endTimes = ["","","","","","",""]
        lunchHours = ["","","","","","",""]
        totalTimeInHours = ["","","","","","",""]
        taxAmount = ["","","","","","",""]
        fiveMin = ["","","","","","",""]
        five = ["","","","","","",""]
        ten = ["","","","","","",""]
        tenMin = ["","","","","","",""]
        six = ["","","","","","",""]
        sixMin = ["","","","","","",""]
        twelve = ["","","","","","",""]
        twelveMin = ["","","","","","",""]
        totalForDoh = ["","","","","","",""]
        
        weekEndLabel.text = weekEnd
        //timeSlipTotalLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        // totalLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        topView.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        infoHeaderView.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        
        if #available(iOS 11.0,*) {
            timeSlipTableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        
        //bottomViewTableView.frame = CGRect(x: 0, y: 0, width:self.view.bounds.size.width, height:1260)
        
        self.updateFrame()
        
        
        for c in 0..<conformationWeekdaysLabels.count
        {
            conformationWeekdaysLabels[c].backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
            conformationHoursLabels[c].textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        }
        conformationHeaderLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        wouldYouLikeButton.titleLabel?.textAlignment = .center
        wouldYouLikeButton.titleLabel?.numberOfLines = 0
        
        
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(self.handle(tap:)))
        view.addGestureRecognizer(tap)
        // object["info_message"].stringValue = "DO NOT SUBMIT TRAINING HOURS. TRAINING HOURS WILL BE SUBMITTED AUTOMATICALLY"
        
        self.infoLabel.font = infoLabel.font.withSize(14)
        self.infoLabel.numberOfLines = 0
        self.infoLabel.text = object["InfoMessage"].stringValue
        self.infoLabel.textColor = UIColor(hexString:Constants.warning_Color)
        self.infoView.backgroundColor = UIColor(hexString:Constants.warning_background_Color)
        self.infoView.layer.borderColor = UIColor(hexString:Constants.warning_border_Color).cgColor
        if object["InfoMessage"].stringValue.count > 0 {
            self.infoViewHeight.constant = Constants.calculateHeight(inString: object["InfoMessage"].stringValue, width: self.view.frame.size.width)+30
        }
        else {
            self.infoViewHeight.constant = 0
        }
    }
    @objc func handle(tap: UITapGestureRecognizer){
        view.endEditing(true)
    }
    var messStr: String = String()
    //aftergettingResponseFrom the server
    func updateFrame()
    {
        
        print(object)
        clientNameLabel.text = object["CompanyName"].stringValue
        
        
        for date in 0..<object["WeekDays"].count
        {
            dates.insert(object["WeekDays"][date].stringValue.substring(to: 10),at:date)
        }
        
        if object["TaxiOk"].intValue == 0
        {
            uploadReceipts.isHidden = true
            //notesHeight.constant = 10
            uploadReceipts.isHidden = true
            uploadHeight.constant = 0
            dohHeightContsrain.constant = 10
        }
        else
        {
            if object["ExpenseDocUploadForm"].boolValue == true
            {
                uploadReceipts.isHidden = false
                uploadReceipts.isHidden = false
                uploadHeight.constant = 35
                dohHeightContsrain.constant = 45
            }
            else
            {
                uploadReceipts.isHidden = true
                uploadReceipts.isHidden = true
                uploadHeight.constant = 0
                dohHeightContsrain.constant = 10
            }
        }
        if object["DohNurseForm"].boolValue == true
        {
            bottomViewTableView.frame = CGRect(x: 0, y: 0, width:self.view.bounds.size.width, height:1260)
            dohView.constant = 890
            dohForm.frame = CGRect(x: 0, y: 0, width:self.view.bounds.size.width, height:890)
            dohViewForm.addSubview(dohForm)
            self.dohTableView.reloadData()
            bottomViewTableView.updateConstraints()
            
        }
        else
        {
            bottomViewTableView.frame = CGRect(x: 0, y: 0, width:self.view.bounds.size.width, height:335)
        }
        
        
        self.timeSlipTableView.reloadData()
        
        if object["lstEtcOrderDetailsList"].arrayValue.count > 0 {
            
            if object["IsDohCandidate"].stringValue == "1" {
                if object["lstEtcOrderDetailsList"].arrayValue.count > 0 {
                self.updateWithETCData()
                }
            }
            else {
                
                if object["ETCMessage"].stringValue.count > 0 {
                    messStr = object["ETCMessage"].stringValue
                }
                else {
                    messStr = "You have eTimeClock entry data that are not submitted. Do you want to load that?"
                }
                
                let alert = UIAlertController.init(title: messStr, message: "", preferredStyle: .alert)
                
                let action1 = UIAlertAction.init(title: "Ok", style: .default) { (action) in
                    self.updateWithETCData()
                }
                let action2 = UIAlertAction.init(title: "Cancel", style: .default) { (action) in
                    
                    
                }
                alert.addAction(action1)
                alert.addAction(action2)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    func getCorrectTimeFormat(string: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "h:mma" // This formate is input formated .
        let formateDate = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "hh:mm a" // Output Formated
        return dateFormatter.string(from: formateDate)
    }
    
    //MARK:- For eTimeClock Only
    func updateWithETCData() {
        
        if object["isEditDetails"].stringValue == "1" {
            editDetailsButton.isHidden = false
            self.oredrDetailsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 175)
            self.orderdetailsBottom.constant = 45
        }
        else {
            editDetailsButton.isHidden = true
            self.oredrDetailsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 138)
            self.orderdetailsBottom.constant = 10
        }
        
        for etcObj in 0..<object["lstEtcOrderDetailsList"].count{
            // let etc = etcObj
            
            let strttime  =   object["lstEtcOrderDetailsList"][etcObj]["StartTime"].stringValue
            let enddtime =  object["lstEtcOrderDetailsList"][etcObj]["EndTime"].stringValue
            
            if object["lstEtcOrderDetailsList"][etcObj]["OrderDay"].stringValue == "Monday"{
                starTimes.replaceObject(at: 0, with: strttime)
                endTimes.replaceObject(at: 0, with: enddtime)
                if object["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue.count > 0 {
                let lunch = roundLunchTime(Double(object["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue)!)
                    lunchHours.replaceObject(at: 0, with: lunch)
                }
                else {
                    lunchHours.replaceObject(at: 0, with: "")
                }
               
            }
            else if object["lstEtcOrderDetailsList"][etcObj]["OrderDay"].stringValue == "Tuesday"{
                
                starTimes.replaceObject(at: 1, with: strttime)
                endTimes.replaceObject(at: 1, with: enddtime)
                if object["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue.count > 0 {
                let lunch = roundLunchTime(Double(object["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue)!)
                lunchHours.replaceObject(at: 1, with: lunch)
            }
            else {
                lunchHours.replaceObject(at: 0, with: "")
            }
            }
            else if object["lstEtcOrderDetailsList"][etcObj]["OrderDay"].stringValue == "Wednesday"{
               
                starTimes.replaceObject(at: 2, with: strttime)
                endTimes.replaceObject(at: 2, with: enddtime)
                if object["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue.count > 0 {
                let lunch = roundLunchTime(Double(object["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue)!)
                lunchHours.replaceObject(at: 2, with: lunch)
                }
                else {
                    lunchHours.replaceObject(at: 2, with: "")
                }
            }
            else if object["lstEtcOrderDetailsList"][etcObj]["OrderDay"].stringValue == "Thursday"{
               
                starTimes.replaceObject(at: 3, with: strttime)
                endTimes.replaceObject(at: 3, with: enddtime)
                if object["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue.count > 0 {
                let lunch = roundLunchTime(Double(object["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue)!)
                lunchHours.replaceObject(at: 3, with: lunch)
                }
                else {
                    lunchHours.replaceObject(at: 2, with: "")
                }
            }
            else if object["lstEtcOrderDetailsList"][etcObj]["OrderDay"].stringValue == "Friday"{
               
                starTimes.replaceObject(at: 4, with: strttime)
                endTimes.replaceObject(at: 4, with: enddtime)
                if object["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue.count > 0 {
                let lunch = roundLunchTime(Double(object["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue)!)
                lunchHours.replaceObject(at: 4, with: lunch)
            }
            else {
                lunchHours.replaceObject(at: 2, with: "")
            }
            }
            else if object["lstEtcOrderDetailsList"][etcObj]["OrderDay"].stringValue == "Saturday"{
               
                starTimes.replaceObject(at: 5, with: strttime)
                endTimes.replaceObject(at: 5, with: enddtime)
                if object["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue.count > 0 {
                let lunch = roundLunchTime(Double(object["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue)!)
                lunchHours.replaceObject(at: 5, with: lunch)
                }
                else {
                    lunchHours.replaceObject(at: 2, with: "")
                }
            }
            else if object["lstEtcOrderDetailsList"][etcObj]["OrderDay"].stringValue == "Sunday"{
              
                starTimes.replaceObject(at: 6, with: strttime)
                endTimes.replaceObject(at: 6, with: enddtime)
                if object["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue.count > 0 {
                let lunch = roundLunchTime(Double(object["lstEtcOrderDetailsList"][etcObj]["BreakTime"].stringValue)!)
                lunchHours.replaceObject(at: 6, with: lunch)
            }
            else {
                lunchHours.replaceObject(at: 2, with: "")
            }
            }
        }
        self.timeSlipTableView.reloadData()
    }
    
    
    //MARK:- UITextField Delegate Methods
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
                self.showPicker(ampm:false)
            }
            return false
        }
        else if  textField.tag>16&&textField.tag<96
        {
            activeTextField = textField
            if cleared
            {
                cleared = false
            }
            else
            {
                self.timePickerRH()
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
        
        
        //        if actfield != nil
        //        {
        //            if (textField.tag)>128&&(textField.tag)<136||(textField.tag)>102&&(textField.tag)<113||(textField.tag)>150&&(textField.tag)<158
        //            {
        //                actfield?.resignFirstResponder()
        //            }
        //            else if (actfield?.tag)!>150&&(actfield?.tag)!<158
        //            {
        //                actfield?.endEditing(true)
        //            }
        //        }
        
        activeTextField = textField
        if (textField.tag>7&&textField.tag<16)||(textField.tag>96&&textField.tag<104)
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
        
        else if  textField.tag>16&&textField.tag<96
        {
            textField.resignFirstResponder()
            
            if cleared
            {
                cleared = false
                textField.endEditing(true)
            }
            else
            {
                self.timePickerRH()
                
            }
            
        }
        else if textField.tag>128&&textField.tag<135
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
            //actfield = nil
        }
        else if textField.tag>150&&textField.tag<158
        {
            textField.perform(
                #selector(becomeFirstResponder),
                with: nil,
                afterDelay: 0.1
            )
            //actfield = nil
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
    
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        if (textField.tag>7&&textField.tag<16)
        {
            starTimes.replaceObject(at:textField.tag-8, with:"")
            timeSlipTableView.reloadData()
            
        }
        else if (textField.tag>96&&textField.tag<104)
        {
            endTimes.replaceObject(at:textField.tag-97, with:"")
            timeSlipTableView.reloadData()
        }
        else if textField.tag>128&&textField.tag<136
        {
            
            lunchHours.replaceObject(at:textField.tag-129, with:"")
            ten.replaceObject(at:textField.tag-129, with:"")
            tenMin.replaceObject(at:textField.tag-129, with:"")
            totalForDoh.replaceObject(at:textField.tag-129, with:"")
            timeSlipTableView.reloadData()
            dohTableView.reloadData()
            self.functionToCalculateTotalDoh()
            
            
        }
        else if textField.tag>112&&textField.tag<119
        {
            
            taxAmount.replaceObject(at:textField.tag-113, with:"")
            timeSlipTableView.reloadData()
            
        }
        else if (textField.tag)>150&&(textField.tag)<158
        {
            
        }
        else if textField.tag>16&&textField.tag<96
        {
            if (textField.tag>16)&&(textField.tag<24)
            {
                //                            if activeTextField!.text!.count>0
                //                            {
                //                                five.replaceObject(at:(activeTextField?.tag)!-17, with:activeTextField!.text!.substring(to: 2))
                //                                fiveMin.replaceObject(at:(activeTextField?.tag)!-17, with:activeTextField!.text!.substring(with: 3..<5))
                //                            }
                //                            else
                //                            {
                five.replaceObject(at:(textField.tag)-17, with:"")
                fiveMin.replaceObject(at:(textField.tag)-17, with:"")
                //}
            }
            else if (textField.tag>32)&&(textField.tag<40)
            {
                //                            if activeTextField!.text!.count>0
                //                            {
                //                                six.replaceObject(at:(activeTextField?.tag)!-33, with:activeTextField!.text!.substring(to: 2))
                //                                sixMin.replaceObject(at:(activeTextField?.tag)!-33,with:activeTextField!.text!.substring(with: 3..<5))
                //                            }
                //                            else
                //                            {
                six.replaceObject(at:(textField.tag)-33, with:"")
                sixMin.replaceObject(at:(textField.tag)-33,with:"")
                //}
            }
            else if (textField.tag>48)&&(textField.tag<56)
            {
                //                            if activeTextField!.text!.count>0
                //                            {
                //                                ten.replaceObject(at:(activeTextField?.tag)!-49, with:activeTextField!.text!.substring(to: 2))
                //                                tenMin.replaceObject(at:(activeTextField?.tag)!-49, with:activeTextField!.text!.substring(with: 3..<5))
                //                            }
                //                            else
                //                            {
                ten.replaceObject(at:(textField.tag)-49, with:"")
                tenMin.replaceObject(at:(textField.tag)-49, with:"")
                //}
            }
            else if (textField.tag>64)&&(textField.tag<72)
            {
                //                            if activeTextField!.text!.count>0
                //                            {
                //                                twelve.replaceObject(at:(activeTextField?.tag)!-65, with:activeTextField!.text!.substring(to: 2))
                //                                twelveMin.replaceObject(at:(activeTextField?.tag)!-65, with:activeTextField!.text!.substring(with: 3..<5))
                //                            }
                //                            else
                //                            {
                twelve.replaceObject(at:(textField.tag)-65, with:"")
                twelveMin.replaceObject(at:(textField.tag)-65, with:"")
                //}
            }
            totalForDoh.removeAllObjects()
            
            let hoursFive = five.map{($0 as AnyObject).integerValue}
            let hoursSix = six.map{($0 as AnyObject).integerValue}
            let hoursTen = ten.map{($0 as AnyObject).integerValue}
            let hoursTwe = twelve.map{($0 as AnyObject).integerValue}
            
            let hoursFiveMin = fiveMin.map{($0 as AnyObject).integerValue}
            let hoursSixMin = sixMin.map{($0 as AnyObject).integerValue}
            let hoursTenMin = tenMin.map{($0 as AnyObject).integerValue}
            let hoursTweMin = twelveMin.map{($0 as AnyObject).integerValue}
            
            
            
            for total in 0..<7
            {
                
                var totalTimeConversionArray = Double()
                var hoursToMin:Int = Int()
                hoursToMin = hoursFive[total]!+hoursSix[total]!+hoursTen[total]!+hoursTwe[total]!
                
                var mins:Int = Int()
                mins = hoursFiveMin[total]!+hoursSixMin[total]!+hoursTenMin[total]!+hoursTweMin[total]!
                
                let total:Double = (Double(hoursToMin*60+mins))
                
                totalTimeConversionArray = Double(total/60)
                totalForDoh.add(String(format:"%.2f",totalTimeConversionArray))
                
            }
            let totalTimeslip = totalForDoh.map{($0 as AnyObject).doubleValue}
            var n = 0.0
            for i in totalTimeslip {
                n += i!
            }
            
            print(n)
            dohTotalTime.text = String(format:"%.2f",n)
            dohTableView.reloadData()
        }
        cleared = true
        return true
    }
    
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (textField.tag>7&&textField.tag<16)
        {
            starTimes.replaceObject(at:textField.tag-8, with:textField.text!)
            timeSlipTableView.reloadData()
            
        }
        else if (textField.tag>96&&textField.tag<104)
        {
            endTimes.replaceObject(at:textField.tag-97, with:textField.text!)
            timeSlipTableView.reloadData()
        }
        else if textField.tag>128&&textField.tag<136
        {
            if textField.text!.count>0 {
                if object["DohNurseForm"].boolValue == true
                {
                    
                    let finalLunch = roundLunchTime(Double(textField.text!)! )
                    lunchHours.replaceObject(at:textField.tag-129, with: finalLunch)
                    let secns = Int(finalLunch)!
                    let time = secondsToHoursMinutesSeconds(seconds: secns*60)
                    print(time)
                    ten.replaceObject(at: textField.tag-129, with: time.0)
                    tenMin.replaceObject(at: textField.tag-129, with: time.1)
                }
                else{
                    let finalLunch = roundLunchTime(Double(textField.text!)! )
                    lunchHours.replaceObject(at:textField.tag-129, with: finalLunch)
                    let secns = Int(finalLunch)!
                    let time = secondsToHoursMinutesSeconds(seconds: secns*60)
                    print(time)
                    ten.replaceObject(at: textField.tag-129, with: time.0)
                    tenMin.replaceObject(at: textField.tag-129, with: time.1)
                }
            }
            else {
                
                
            }
            
            
            timeSlipTableView.reloadData()
            dohTableView.reloadData()
            //@@
            
        }
        else if textField.tag>112&&textField.tag<119
        {
            
            taxAmount.replaceObject(at:textField.tag-113, with:textField.text!)
            timeSlipTableView.reloadData()
            
            
        }
        else if (textField.tag)>150&&(textField.tag)<158
        {
            actfield = textField
        }
        
        else if textField.tag>16&&textField.tag<96
        {
            //            if (activeTextField!.tag>16)&&(activeTextField!.tag<24)
            //            {
            //                if activeTextField!.text!.count>0
            //                {
            //                    five.replaceObject(at:(activeTextField?.tag)!-17, with:activeTextField!.text!.substring(to: 2))
            //                    fiveMin.replaceObject(at:(activeTextField?.tag)!-17, with:activeTextField!.text!.substring(with: 3..<5))
            //                }
            //                else
            //                {
            //                    five.replaceObject(at:(activeTextField?.tag)!-17, with:activeTextField!.text!)
            //                    fiveMin.replaceObject(at:(activeTextField?.tag)!-17, with:activeTextField!.text!)
            //                }
            //            }
            //            else if (activeTextField!.tag>32)&&(activeTextField!.tag<37)
            //            {
            //                if activeTextField!.text!.count>0
            //                {
            //                    six.replaceObject(at:(activeTextField?.tag)!-33, with:activeTextField!.text!.substring(to: 2))
            //                    sixMin.replaceObject(at:(activeTextField?.tag)!-33,with:activeTextField!.text!.substring(with: 3..<5))
            //                }
            //                else
            //                {
            //                    six.replaceObject(at:(activeTextField?.tag)!-33, with:activeTextField!.text!)
            //                    sixMin.replaceObject(at:(activeTextField?.tag)!-33,with:activeTextField!.text!)
            //                }
            //            }
            //            else if (activeTextField!.tag>48)&&(activeTextField!.tag<56)
            //            {
            //                if activeTextField!.text!.count>0
            //                {
            //                    ten.replaceObject(at:(activeTextField?.tag)!-49, with:activeTextField!.text!.substring(to: 2))
            //                    tenMin.replaceObject(at:(activeTextField?.tag)!-49, with:activeTextField!.text!.substring(with: 3..<5))
            //                }
            //                else
            //                {
            //                    ten.replaceObject(at:(activeTextField?.tag)!-49, with:activeTextField!.text!)
            //                    tenMin.replaceObject(at:(activeTextField?.tag)!-49, with:activeTextField!.text!)
            //                }
            //            }
            //            else if (activeTextField!.tag>64)&&(activeTextField!.tag<72)
            //            {
            //                if activeTextField!.text!.count>0
            //                {
            //                    twelve.replaceObject(at:(activeTextField?.tag)!-65, with:activeTextField!.text!.substring(to: 2))
            //                    twelveMin.replaceObject(at:(activeTextField?.tag)!-65, with:activeTextField!.text!.substring(with: 3..<5))
            //                }
            //                else
            //                {
            //                    twelve.replaceObject(at:(activeTextField?.tag)!-65, with:activeTextField!.text!)
            //                    twelveMin.replaceObject(at:(activeTextField?.tag)!-65, with:activeTextField!.text!)
            //                }
            //            }
            //            totalForDoh.removeAllObjects()
            //
            //            let hoursFive = five.map{($0 as AnyObject).integerValue}
            //            let hoursSix = six.map{($0 as AnyObject).integerValue}
            //            let hoursTen = ten.map{($0 as AnyObject).integerValue}
            //            let hoursTwe = twelve.map{($0 as AnyObject).integerValue}
            //
            //            let hoursFiveMin = fiveMin.map{($0 as AnyObject).integerValue}
            //            let hoursSixMin = sixMin.map{($0 as AnyObject).integerValue}
            //            let hoursTenMin = tenMin.map{($0 as AnyObject).integerValue}
            //            let hoursTweMin = twelveMin.map{($0 as AnyObject).integerValue}
            //
            //
            //
            //            for total in 0..<7
            //            {
            //
            //                var totalTimeConversionArray = Double()
            //                var hoursToMin:Int = Int()
            //                hoursToMin = hoursFive[total]!+hoursSix[total]!+hoursTen[total]!+hoursTwe[total]!
            //
            //                var mins:Int = Int()
            //                mins = hoursFiveMin[total]!+hoursSixMin[total]!+hoursTenMin[total]!+hoursTweMin[total]!
            //
            //                let total:Double = (Double(hoursToMin*60+mins))
            //
            //                totalTimeConversionArray = Double(total/60)
            //                totalForDoh.add(String(format:"%.2f",totalTimeConversionArray))
            //
            //            }
            //            let totalTimeslip = totalForDoh.map{($0 as AnyObject).doubleValue}
            //            var n = 0.0
            //            for i in totalTimeslip {
            //                n += i!
            //            }
            //
            //            print(n)
            //            dohTotalTime.text = String(format:"%.2f",n)
            //            dohTableView.reloadData()
        }
        self.functionToCalculateTotalDoh()
        
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
            // self.activeTextField?.text = formatter.string(from: date)
            if (self.activeTextField!.tag>7)&&(self.activeTextField!.tag)<16
            {
                self.activeTextField?.text = formatter.string(from: date)
                //        if (activeTextField!.tag)>7
                //        {
                self.starTimes.replaceObject(at:(self.activeTextField?.tag)!-8, with:formatter.string(from: date))
                //}
                //        else if (activeTextField!.tag)>1
                //        {
                //            lunchHours.replaceObject(at: (activeTextField?.tag)!-17, with: cell.lunchTimeTextField.text!)
                //        }
            }
            else if (self.activeTextField!.tag>96)&&(self.activeTextField!.tag)<104
            {
                self.activeTextField?.text = formatter.string(from: date)
                self.endTimes.replaceObject(at: (self.activeTextField?.tag)!-97, with:formatter.string(from: date))
            }
            //        else if (activeTextField!.tag>112)&&(activeTextField!.tag)<119
            //        {
            //            taxAmount.replaceObject(at:indexPath.row-1, with:cell.taxFareTextField.text!)
            //        }
            
            if (self.activeTextField!.tag>16)&&(self.activeTextField!.tag<24)
            {
                self.five.replaceObject(at:(self.activeTextField?.tag)!-17, with:formatter.string(from: date).substring(to: 2))
                self.fiveMin.replaceObject(at:(self.activeTextField?.tag)!-17, with:formatter.string(from: date).substring(with: 3..<5))
            }
            else if (self.activeTextField!.tag>32)&&(self.activeTextField!.tag<40)
            {
                self.six.replaceObject(at:(self.activeTextField?.tag)!-33, with:formatter.string(from: date).substring(to: 2))
                self.sixMin.replaceObject(at:(self.activeTextField?.tag)!-33,with:formatter.string(from: date).substring(with: 3..<5))
            }
            else if (self.activeTextField!.tag>48)&&(self.activeTextField!.tag<56)
            {
                self.ten.replaceObject(at:(self.activeTextField?.tag)!-49, with:formatter.string(from: date).substring(to: 2))
                self.tenMin.replaceObject(at:(self.activeTextField?.tag)!-49, with:formatter.string(from: date).substring(with: 3..<5))
            }
            else if (self.activeTextField!.tag>64)&&(self.activeTextField!.tag<72)
            {
                self.twelve.replaceObject(at:(self.activeTextField?.tag)!-65, with:formatter.string(from: date).substring(to: 2))
                self.twelveMin.replaceObject(at:(self.activeTextField?.tag)!-65, with:formatter.string(from: date).substring(with: 3..<5))
            }
            
            self.totalForDoh.removeAllObjects()
            
            let hoursFive = self.five.map{($0 as AnyObject).integerValue}
            let hoursSix = self.six.map{($0 as AnyObject).integerValue}
            let hoursTen = self.ten.map{($0 as AnyObject).integerValue}
            let hoursTwe = self.twelve.map{($0 as AnyObject).integerValue}
            
            let hoursFiveMin = self.fiveMin.map{($0 as AnyObject).integerValue}
            let hoursSixMin = self.sixMin.map{($0 as AnyObject).integerValue}
            let hoursTenMin = self.tenMin.map{($0 as AnyObject).integerValue}
            let hoursTweMin = self.twelveMin.map{($0 as AnyObject).integerValue}
            
            for total in 0..<7
            {
                
                var totalTimeConversionArray = Double()
                var hoursToMin:Int = Int()
                hoursToMin = hoursFive[total]!+hoursSix[total]!+hoursTen[total]!+hoursTwe[total]!
                
                var mins:Int = Int()
                mins = hoursFiveMin[total]!+hoursSixMin[total]!+hoursTenMin[total]!+hoursTweMin[total]!
                
                let total:Double = (Double(hoursToMin*60+mins))
                
                totalTimeConversionArray = Double(total/60)
                self.totalForDoh.add(totalTimeConversionArray)
                
            }
            
            let totalTimeslip = self.totalForDoh.map{($0 as AnyObject).doubleValue}
            var n = 0.0
            for i in totalTimeslip {
                n += i!
            }
            
            print(n)
            self.dohTotalTime.text = String(format:"%.2f",n)
            self.timeSlipTableView.reloadData()
            self.dohTableView.reloadData()
            //self.title = formatter.string(from: date)
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
        //        if tuple.hours<10
        //        {
        //            if tuple.leftMinutes<10
        //            {
        //                totalHours.replaceObject(at: i-1, with: String(format:"0%d",tuple.hours)+":"+String(format:"0%d",tuple.leftMinutes))
        //            }
        //            else
        //            {
        //                totalHours.replaceObject(at: i-1, with: String(format:"0%d",tuple.hours)+":"+String(format:"%d",tuple.leftMinutes))
        //            }
        //        }
        //        else
        //        {
        //
        //            if tuple.leftMinutes<10
        //            {
        //                totalHours.replaceObject(at: i-1, with: String(format:"%d",tuple.hours)+":"+String(format:"0%d",tuple.leftMinutes))
        //            }
        //            else
        //            {
        //                totalHours.replaceObject(at: i-1, with: String(format:"%d",tuple.hours)+":"+String(format:"%d",tuple.leftMinutes))
        //        ==   }
        //        }
        
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
            totalTimeInHours.replaceObject(at:i-1, with:String(format:"-%.2f",totalTimeConversionArray))
        }
        else{
            totalTimeInHours.replaceObject(at:i-1, with:String(format:"%.2f",totalTimeConversionArray))
        }
        self.addTotal()
        
        
    }
    
    //MARK:- SubmitAction
    @IBAction func submitAction(_ sender: Any)
    {
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
                            conformationWeekdaysLabels[t].text = getFormattedDate(string:object["WeekDays"][t].stringValue).uppercased()
                            conformationHoursLabels[t].text = totalTimeInHours[t] as? String
                        }
                        
                        conformationView.frame = CGRect(x: 10, y:self.view.bounds.size.height/2-240, width:self.view.bounds.size.width-20, height:480)
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
                
                print("*** viv the params in method to submit is \(params)***")
                
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
                               "TotalActivityTimeSlip" : dohTotalTime.text!,
                               "NycLawEmployee" : object["NycLawEmployee"].intValue,
                               "ClientsNotApplicableForDoh" : object["ClientsNotApplicableForDoh"].intValue,
                               "WaiverType_30K_Order":duplicateResponse["WaiverType_30K_Order"].stringValue,"WaiverType":object["WaiverType"].stringValue,"WaiverApproved":object["WaiverApproved"].stringValue,"Source":"iOS"] as [String : Any]
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
                    ANLoader.hide()
                })
                if ConnectionCheck.isConnectedToNetwork()
                {
                    //ANLoader.showLoading("", disableUI:true)
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
            
            orderconformationView.frame = CGRect(x: 10, y:self.view.bounds.size.height/2-120, width:self.view.bounds.size.width-20, height:240)
            
            orderConformationLabel.text = "Timeslip(s) Entered Sucessfully Your confirmation number is \(inserObject["ConfirmationNo"].stringValue)"
            blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.contentView.addSubview(orderconformationView)
            view.addSubview(blurEffectView)
            
            //ServerService.ShowAlertMessage(ErrorMessage: "", title:"Time Slip(s) Entered Sucessfully Your confirmation number is \(inserObject["ConfirmationNo"].stringValue)", view: self)
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage: "", title:inserObject["ErrorMessage"].stringValue, view: self)
        }
        
    }
    
    
    //function to get date
    func getFormattedDate(string: String) -> String{
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
    
    //MARK:- CheckBox Action
    @IBAction func checkBoxAction(_ sender: Any)
    {
        if checkBoxAction.isSelected
        {
            checkBoxAction.isSelected = false
        }
        else
        {
            checkBoxAction.isSelected = true
        }
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
    
    //MARK:- HandleNavgationBarButtonTap
    @IBAction func handleNavgationBarButtonTap(_ sender: UIBarButtonItem,event:UIEvent)
    
    {
        Constants.showUp(event:event,viewController:self)
        
    }
    
    //MARK:- ResetAction
    @IBAction func resetAction(_ sender: UIButton)
    {
        
        
        let confromAlert = UIAlertController(title: "Would you like to clear Entered Timeslip for the following weekend \( weekEnd)?", message:"", preferredStyle: UIAlertControllerStyle.alert)
        confromAlert.addAction(UIAlertAction(title: "NO", style: .destructive) { (action:UIAlertAction!) in
            
            
        })
        confromAlert.addAction(UIAlertAction(title: "YES", style: .default) { (action:UIAlertAction!) in
            
            self.reset = true
            self.totalHours = ["00:00","00:00","00:00","00:00","00:00","00:00","00:00"]
            self.starTimes = ["","","","","","",""]
            self.endTimes = ["","","","","","",""]
            self.lunchHours = ["","","","","","",""]
            self.totalTimeInHours = ["","","","","","",""]
            self.taxAmount = ["","","","","","",""]
            self.totalLabel.text = "0"
            self.timeSlipTableView.scrollToRow(at:IndexPath(item: 0, section: 0), at:.top, animated:true)
            self.isTotalNegative = false
            for row in 0..<8
            {
                let indexPath = IndexPath(item: row, section: 0)
                self.timeSlipTableView.reloadRows(at: [indexPath], with: .fade)
            }
            self.navigationController?.view.makeToast("Schedule has been cleared for this \(self.weekEnd) weekend.", duration: 3.0, position: .bottom, title: "", image: nil)
        })
        
        self.present(confromAlert, animated: true)
        confromAlert.view.tintColor = UIColor(hexString: "#449D44")
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
    
    //MARK:- ChooseFileAction
    @IBAction func chooseFileAction(_ sender: Any)
    {
        showMenu()
    }
    
    //MARK:- Delete Action
    @IBAction func deleteAction(_ sender: Any) {
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: self.documentsTableView)
        let indexPath = self.documentsTableView.indexPathForRow(at:buttonPosition)
        
        if (indexPath?.section)!<formObject["objCandidateExpenseDocUploadList"].arrayValue.count
        {
            TotalFiles.remove(at: (indexPath?.section)!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
                ANLoader.hide()
            })
            if ConnectionCheck.isConnectedToNetwork()
            {
                ServerService.showActivityIndicatory(uiView:self.view)
                //ANLoader.showLoading("", disableUI:true)
                let params:[String:String] = ["ExpenseId":formObject["objCandidateExpenseDocUploadList"][(indexPath?.section)!]["Id"].stringValue]
                ServerService.getTimeSlipDeleteUploadedFiles(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseDeletedFile(response:))
            }
            else
            {
                ANLoader.hide()
                ServerService.hideProgressView()
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            }
            
        }
        else
        {
            TotalFiles.remove(at:(indexPath?.section)!)
            documentsArray.removeObject(at:(indexPath?.section)!)
            documetBytes.removeObject(at:(indexPath?.section)!)
            fileExtensions.removeObject(at:(indexPath?.section)!)
        }
        
        documentsTableView.reloadData()
    }
    
    //MARK:- getresponseDeletedFile response
    func getresponseDeletedFile(response:AnyObject)->()
    {
        ANLoader.hide()
        ServerService.hideProgressView()
        docDeleteObject = response as! JSON
        print("delted Form Response",docDeleteObject)
        DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
            ANLoader.hide()
        })
        if ConnectionCheck.isConnectedToNetwork()
        {
            //ANLoader.showLoading("", disableUI:true)
            ServerService.showActivityIndicatory(uiView:self.view)
            let params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"WeekendDate":weekEnd,"OrderId":orderId,"Division":division]
            print(params)
            ServerService.getEnterTimeSlip(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getFormresponse(response:))
        }
        else
        {
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
        
    }
    func getFormresponse(response:AnyObject)->()
    {
        ANLoader.hide()
        ServerService.hideProgressView()
        formObject = response as! JSON
    }
    
    
    //MARK:- UploadAction
    @IBAction func uploadAction(_ sender: Any)
    {
        blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        documentsView.frame = CGRect(x:10,y:20,width: self.view.bounds.width-20,height:self.view.bounds.size.height-40)
        blurEffectView.contentView.addSubview(documentsView)
        view.addSubview(blurEffectView)
        
        if formObject["objCandidateExpenseDocUploadList"].count>0
        {
            TotalFiles = formObject["objCandidateExpenseDocUploadList"].arrayValue.map({$0["FileName"].stringValue})
            documentsTableView.reloadData()
            documentsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at:.top, animated:true)
        }
        documentsTableView.reloadData()
        
    }
    //MARK:- DismissAction
    @IBAction func dismissAction(_ sender: Any)
    {
        blurEffectView.removeFromSuperview()
    }
    
    
    //MARK:- File Picker Methods
    
    @available(iOS 8.0, *)
    public func documentPicker(_ controller:UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        let urlPath = url as URL
        print("The Url is",urlPath)
        
        fileData = try! Data(contentsOf:urlPath)
        fileBytes = fileData.base64EncodedString()
        documentsArray.add(urlPath.lastPathComponent)
        documetBytes.add(fileBytes)
        fileExtensions.add(urlPath.lastPathComponent)
        TotalFiles.append(urlPath.lastPathComponent)
        documentsTableView.reloadData()
    }
    
    
    @available(iOS 8.0, *)
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController)
    {
        documentPicker.delegate = self
        if #available(iOS 11.0, *) {
            documentPicker.allowsMultipleSelection = true
        } else {
            // Fallback on earlier versions
        }
        present(documentPicker, animated: true, completion: nil)
        
    }
    func documentPickerWasCancelled(_ controller:UIDocumentPickerViewController) {
        print("we cancelled")
        //dismiss(animated: true, completion: nil)
        
    }
    
    //MARK:- ShowMenu Action
    func showMenu(){
        
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypeContent)], in: .import)
        importMenu.delegate = self
        if #available(iOS 13.0, *) {
            importMenu.modalPresentationStyle = .fullScreen;
        } else {
            // Fallback on earlier versions
        }
        self.present(importMenu, animated: true, completion: nil)
    }
    
    //MARK:- InfoWindow View Actions
    @IBAction func infoCloseAction(_ sender: UIButton)
    {
        blurEffectView.removeFromSuperview()
    }
    @IBAction func infoAction(_ sender: UIButton)
    {
        blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        infoView.frame = CGRect(x:10,y:20,width: self.view.bounds.width-20,height:self.view.bounds.size.height-40)
        blurEffectView.contentView.addSubview(infoView)
        view.addSubview(blurEffectView)
        informationTable.scrollToRow(at: IndexPath(row: 0, section: 0), at:.top, animated:true)
        informationTable.reloadData()
    }
    
    //MARK:- CorrectButton Action
    @IBAction func correctAction(_ sender: UIButton) {
        
        //        var totalTimeConversionArray = Array<Double>()
        //
        //        for time in 0..<7
        //        {
        //
        //            let hours = self.totalHours[time] as! String
        //            let fileArray = hours.components(separatedBy: ":")
        //            var hoursToMin:Double = Double()
        //            if fileArray.count>0
        //            {
        //                hoursToMin = Double(fileArray[0])!
        //            }
        //            var mins:Double = Double()
        //            if fileArray.count == 2
        //            {
        //                mins = Double(fileArray[1])!
        //            }
        //            totalTimeConversionArray.append(hoursToMin+mins/60)
        //
        //        }
        
        
        blurEffectView.removeFromSuperview()
        var times = Array<[String:Any]>()
        for i in 0..<7
        {
            if((self.starTimes[i] as! String).count>0)&&((self.endTimes[i]as! String).count>0)
            {
                let time = [ "Day" : i+1,
                             "StartTime" : self.starTimes[i],
                             "EndTime" : self.endTimes[i],
                             "LunchTime" : self.lunchHours[i],
                             "TaxiTime" : self.taxAmount[i],
                             "TotalTime": self.totalTimeInHours[i],
                             "CurrentDate" : self.dates[i],
                             
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
                             "CurrentDate" : self.dates[i]
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
    
    //MARK:- IncorrectButtonAction
    @IBAction func inCorrectAction(_ sender: Any) {
        
        blurEffectView.removeFromSuperview()
    }
    
    //MARK:- TimePickerActions
    @IBAction func EnterAnotherTimeSlip(_ sender: UIButton) {
        
        blurEffectView.removeFromSuperview()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func orderConformationCancelAction(_ sender: UIButton) {
        blurEffectView.removeFromSuperview()
        let vc1:UIViewController = (self.storyboard?.instantiateViewController(withIdentifier:"dash"))!
        let nc1:UINavigationController = self.storyboard?.instantiateViewController(withIdentifier:"dashNavi") as! UINavigationController
        nc1.viewControllers = [vc1]
        sideMenuController?.embed(centerViewController:nc1)
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
    //MARK:- ImagePickerController Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = (info[UIImagePickerControllerOriginalImage] as? UIImage) else { return }
        
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.delegate = self
        
        // Uncomment this if you wish to provide extra instructions via a title label
        //cropController.title = "Crop Image"
        
        // -- Uncomment these if you want to test out restoring to a previous crop setting --
        //cropController.angle = 90 // The initial angle in which the image will be rotated
        //cropController.imageCropFrame = CGRect(x: 0, y: 0, width: 2848, height: 4288) //The initial frame that the crop controller will have visible.
        
        // -- Uncomment the following lines of code to test out the aspect ratio features --
        cropController.aspectRatioPreset = .presetSquare; //Set the initial aspect ratio as a square
        cropController.aspectRatioLockEnabled = true // The crop box is locked to the aspect ratio and can't be resized away from it
        cropController.resetAspectRatioEnabled = false // When tapping 'reset', the aspect ratio will NOT be reset back to default
        cropController.aspectRatioPickerButtonHidden = true
        
        // -- Uncomment this line of code to place the toolbar at the top of the view controller --
        //cropController.toolbarPosition = .top
        
        cropController.rotateButtonsHidden = true
        cropController.rotateClockwiseButtonHidden = true
        
        //cropController.doneButtonTitle = "Title"
        //cropController.cancelButtonTitle = "Title"
        
        self.image = image
        
        
        //If profile picture, push onto the same navigation stack
        if croppingStyle == .circular {
            picker.pushViewController(cropController, animated: true)
        }
        else { //otherwise dismiss, and then present from the main controller
            picker.dismiss(animated: true, completion: {
                if #available(iOS 13.0, *) {
                    cropController.modalPresentationStyle = .fullScreen;
                } else {
                    // Fallback on earlier versions
                }
                self.present(cropController, animated: true, completion: nil)
                //self.navigationController!.pushViewController(cropController, animated: true)
            })
        }
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        cropViewController.dismiss(animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            ServerService.showActivityIndicatory(uiView:self.view)
            //ANLoader.showLoading("", disableUI:true)
            let selectedImage:UIImage = image.resize(withWidth:200)!
            let base64String = selectedImage.toBase64()
            let params = ["CandId":UserDefaults.standard.object(forKey:"cID") as! String,"ImageFile":base64String!] as [String:Any]
            print(params)
            ServerService.AccountInsertProfilePicture(self, params: params, method: "POST", accessToken:Constants.Token,acces:true, callBack:self.getresponseForPic(response:))
        })
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    //MARK:- AfterGettingResponseFrom the server
    func getresponseForPic(response:AnyObject)->()
    {
        print(response)
        ANLoader.hide()
        ServerService.hideProgressView()
        picUploadData = response as! JSON
        if picUploadData.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if picUploadData["MessageStatus"].intValue == 1
        {
            UserDefaults.standard.set(picUploadData["ImageFile"].stringValue, forKey: "ImageFile")
            NotificationCenter.default.post(name: Notification.Name("updateImage"), object: nil)
            ServerService.ShowAlertMessage(ErrorMessage:Constants.imageMessage, title:"", view:self)
            
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage:picUploadData["Message"].stringValue, title:"", view:self)
        }
    }
    
    //MARK:- Catching the device orentation
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            conformationView.frame = CGRect(x: 10, y:self.view.bounds.size.height/2-240, width:self.view.bounds.size.width-20, height:480)
            orderconformationView.frame = CGRect(x: 10, y:self.view.bounds.size.height/2-120, width:self.view.bounds.size.width-20, height:240)
        case .landscapeLeft:
            text="LandscapeLeft"
            conformationView.frame = CGRect(x: 10, y:20, width:self.view.bounds.size.width-20, height:self.view.bounds.size.height-40)
            orderconformationView.frame = CGRect(x: 10, y:self.view.bounds.size.height/2-120, width:self.view.bounds.size.width-20, height:240)
        case .landscapeRight:
            text="LandscapeRight"
            conformationView.frame = CGRect(x: 10, y:20, width:self.view.bounds.size.width-20, height:self.view.bounds.size.height-40)
            orderconformationView.frame = CGRect(x: 10, y:self.view.bounds.size.height/2-120, width:self.view.bounds.size.width-20, height:240)
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
    }
    
    //MARK:- Func To Calculate TotalDoh
    func functionToCalculateTotalDoh(){
        totalForDoh.removeAllObjects()
        
        let hoursFive = five.map{($0 as AnyObject).integerValue}
        let hoursSix = six.map{($0 as AnyObject).integerValue}
        let hoursTen = ten.map{($0 as AnyObject).integerValue}
        let hoursTwe = twelve.map{($0 as AnyObject).integerValue}
        
        let hoursFiveMin = fiveMin.map{($0 as AnyObject).integerValue}
        let hoursSixMin = sixMin.map{($0 as AnyObject).integerValue}
        let hoursTenMin = tenMin.map{($0 as AnyObject).integerValue}
        let hoursTweMin = twelveMin.map{($0 as AnyObject).integerValue}
        
        
        
        for total in 0..<7
        {
            
            var totalTimeConversionArray = Double()
            var hoursToMin:Int = Int()
            hoursToMin = hoursFive[total]!+hoursSix[total]!+hoursTen[total]!+hoursTwe[total]!
            
            var mins:Int = Int()
            mins = hoursFiveMin[total]!+hoursSixMin[total]!+hoursTenMin[total]!+hoursTweMin[total]!
            
            let total:Double = (Double(hoursToMin*60+mins))
            
            totalTimeConversionArray = Double(total/60)
            totalForDoh.add(totalTimeConversionArray)
            
        }
        
        let totalTimeslip = totalForDoh.map{($0 as AnyObject).doubleValue}
        var n = 0.0
        for i in totalTimeslip {
            n += i!
        }
        
        print("Total is \(n)")
        dohTotalTime.text = String(format:"%.2f",n)
        timeSlipTableView.reloadData()
        dohTableView.reloadData()
    }
    
    //MARK:- Edit Button Action
    @IBAction func editDetailsButtonClicked(_ sender: UIButton) {
        
        for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: ETimeClockMainViewController.self) {
                    _ =  self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
                else {
                    let screen = self.storyboard?.instantiateViewController(withIdentifier: "eTimeClock History") as! ETimeClockMainViewController
                    let navi = BaseNaviViewController(rootViewController:screen)
                    navi.navigationBar.tintColor = .white
                    navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                    sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"eTimeClock History")
                }
            }
    }
}

//END OF CLASS




//MARK:- Extensions
extension EnterTimeSlipDetailViewController: UITextViewDelegate
{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            view.endEditing(true)
            return false
        }
        else
        {
            return true
        }
    }
}

extension EnterTimeSlipDetailViewController: UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == documentsTableView
        {
            return 50
        }
        else if tableView == dohTableView
        {
            if indexPath.row == 0
            {
                return 35
            }
            else
            {
                return 106
            }
        }
        else if tableView == informationTable
        {
            return 40
            
        }
        else{
            
            if indexPath.row == 0
            {
                return 35
            }
            else
            {
                if indexPath.row == 7
                {
                    if object["TaxiOk"].intValue == 0
                    {
                        return 54
                    }
                    else
                    {
                        return 106
                    }
                    
                }
                else
                {
                    if object["TaxiOk"].intValue == 0
                    {
                        return 52
                    }
                    else
                    {
                        return 104
                    }
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == documentsTableView
        {
            return 5
        }
        else if tableView == informationTable
        {
            return 40
        }
        else
        {
            return 0.01
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == informationTable
        {
            let headerView = UIView()
            headerView.frame = CGRect(x:0, y: 0, width:self.view.bounds.size.width-20, height:40)
            headerView.backgroundColor = UIColor(hexString:"#EEEEEE")
            let headerLabel = UILabel()
            headerLabel.frame = CGRect(x:10, y: 0, width:self.view.bounds.size.width-100,height:40)
            headerLabel.text = Headers[section]
            headerLabel.numberOfLines = 0
            headerLabel.font = UIFont.systemFont(ofSize:14)
            let codeLabel = UILabel()
            codeLabel.frame = CGRect(x:self.view.bounds.size.width-100, y: 0, width:70, height:40)
            if section == 0
            {
                codeLabel.text = "Activity Codes"
                codeLabel.numberOfLines = 0
                codeLabel.font = UIFont.systemFont(ofSize:14)
                headerView.addSubview(codeLabel)
            }
            headerView.addSubview(headerLabel)
            
            return headerView
            
        }
        else
        {
            return nil
        }
    }
    
    
}
extension EnterTimeSlipDetailViewController: UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == documentsTableView
        {
            return TotalFiles.count
        }
        else if tableView == informationTable
        {
            return Headers.count
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == documentsTableView
        {
            return 1
        }
        else if tableView == informationTable
        {
            if section == 0
            {
                return 2
            }
            else if section == 1
            {
                return 5
            }
            else if section == 2
            {
                return 10
            }
            else if section == 3
            {
                return 2
            }
            else if section == 4
            {
                return 3
            }
            else
            {
                return 1
            }
        }
        else
        {
            return 8
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == documentsTableView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:"docCell") as! DocumentTableViewCell
            cell.documentLabel.text = TotalFiles[indexPath.section] as? String
            cell.selectionStyle = .none
            return cell
            
        }
        else if tableView == dohTableView
        {
            if indexPath.row==0
            {
                let cell = tableView.dequeueReusableCell(withIdentifier:"hCell", for: indexPath) as! THTableViewCell
                cell.selectionStyle = .none
                cell.startTimeLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
                cell.endLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
                cell.lunchLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
                cell.totalLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
                cell.dateLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
                cell.selectionStyle = .none
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier:"dohCell") as! DOHTableViewCell
                
                if self.view.bounds.size.height <= 568
                {
                    cell.firstTextField.font = UIFont.systemFont(ofSize:9)
                    cell.secondTextField.font = UIFont.systemFont(ofSize: 9)
                    cell.thirdTextField.font = UIFont.systemFont(ofSize:9)
                    cell.fourthTextField.font = UIFont.systemFont(ofSize: 9)
                }
                else
                {
                    cell.firstTextField.font = UIFont.systemFont(ofSize:15)
                    cell.secondTextField.font = UIFont.systemFont(ofSize:15)
                    cell.thirdTextField.font = UIFont.systemFont(ofSize:15)
                    cell.fourthTextField.font = UIFont.systemFont(ofSize:15)
                }
                if object["\(weekdays[indexPath.row-1])"].intValue == 0
                {
                    cell.firstTextField.isEnabled = false
                    cell.secondTextField.isEnabled = false
                    cell.thirdTextField.isEnabled = false
                    cell.fourthTextField.isEnabled = false
                    cell.firstTextField.backgroundColor = UIColor(hexString:"#EEEEEE")
                    cell.secondTextField.backgroundColor =     UIColor(hexString:"#EEEEEE")
                    cell.thirdTextField.backgroundColor = UIColor(hexString:"#EEEEEE")
                    cell.fourthTextField.backgroundColor = UIColor(hexString:"#EEEEEE")
                }
                else
                {
                    cell.firstTextField.isEnabled = true
                    cell.secondTextField.isEnabled = true
                    cell.thirdTextField.isEnabled = true
                    cell.fourthTextField.isEnabled = true
                    cell.firstTextField.backgroundColor = .white
                    cell.secondTextField.backgroundColor = .white
                    cell.thirdTextField.backgroundColor = .white
                    cell.fourthTextField.backgroundColor = .white
                }
                
                // //TODO:- @@ Debug Here
                if object["DohNurseForm"].boolValue == true
                {
                    if object["\(weekdays[indexPath.row-1])"].intValue == 0
                    {
                        
                    }
                    else{
                        cell.thirdTextField.isEnabled = false
                        cell.thirdTextField.backgroundColor = UIColor(hexString:"#EEEEEE")
                    }
                    
                    
                }
                
                
                cell.firstTextField.tag = 16+indexPath.row
                cell.secondTextField.tag   = 32+indexPath.row
                cell.thirdTextField.tag = 48+indexPath.row
                cell.fourthTextField.tag = 64+indexPath.row
                cell.totalTextField.tag = 80+indexPath.row
                cell.dateLabel.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
                if object.count>0
                {
                    if object["WeekDays"].arrayValue.count>0
                    {
                        cell.dateLabel.text = getFormattedDate(string:object["WeekDays"][indexPath.row-1].stringValue).uppercased()
                    }
                }
                
                if (five[indexPath.row-1] as? String)!.count>0 && (fiveMin[indexPath.row-1] as? String)!.count>0
                {
                    cell.firstTextField.text = (five[indexPath.row-1] as? String)!+":"+(fiveMin[indexPath.row-1] as? String)!
                }
                else {
                    cell.firstTextField.text = ""
                }
                if (six[indexPath.row-1] as? String)!.count>0 && (sixMin[indexPath.row-1] as? String)!.count>0
                {
                    cell.secondTextField.text = (six[indexPath.row-1] as? String)!+":"+(sixMin[indexPath.row-1] as? String)!
                    
                }
                else {
                    cell.secondTextField.text = ""
                }
                if (ten[indexPath.row-1] as? String)!.count>0 && (tenMin[indexPath.row-1] as? String)!.count>0
                {
                    cell.thirdTextField.text = (ten[indexPath.row-1] as? String)!+":"+(tenMin[indexPath.row-1] as? String)!
                    
                }
                else{
                    cell.thirdTextField.text = ""
                }
                if (twelve[indexPath.row-1] as? String)!.count>0 && (twelveMin[indexPath.row-1] as? String)!.count>0
                {
                    cell.fourthTextField.text = (twelve[indexPath.row-1] as? String)!+":"+(twelveMin[indexPath.row-1] as? String)!
                    
                }
                else {
                    cell.fourthTextField.text = ""
                }
                
                if totalForDoh[indexPath.row-1] as? Int == 0
                {
                    cell.totalTextField.text = ""
                }
                else
                {
                    cell.totalTextField.text = String(format:"%@",totalForDoh[indexPath.row-1] as! CVarArg)
                }
                cell.selectionStyle = .none
                
                return cell
            }
        }
        else if tableView == informationTable
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:"iCell") as! InformationCellTableViewCell
            if indexPath.section == 0
            {
                cell.titleLabel.text = Titles[indexPath.row]
                cell.numberLabel.text = Codes[indexPath.row]
                
            }
            else if indexPath.section == 1
            {
                cell.titleLabel.text = Titles[2+indexPath.row]
                cell.numberLabel.text = Codes[2+indexPath.row]
                
            }
            else if indexPath.section == 2
            {
                cell.titleLabel.text = Titles[7+indexPath.row]
                cell.numberLabel.text = Codes[7+indexPath.row]
                
            }
            else if indexPath.section == 3
            {
                cell.titleLabel.text = Titles[17+indexPath.row]
                cell.numberLabel.text = Codes[17+indexPath.row]
                
            }
            else if indexPath.section == 4
            {
                cell.titleLabel.text = Titles[19+indexPath.row]
                cell.numberLabel.text = Codes[19+indexPath.row]
                
            }
            else if indexPath.section == 5
            {
                cell.titleLabel.text = Titles[22+indexPath.row]
                cell.numberLabel.text = Codes[22+indexPath.row]
            }
            else
            {
                cell.titleLabel.text = Titles[23+indexPath.row]
                cell.numberLabel.text = Codes[23+indexPath.row]
            }
            cell.selectionStyle = .none
            return cell
        }
        
        else
        {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "EnterTimeSlipHeaderCell") as! EnterTimeSlipHeaderCell
//            return cell
          
            if indexPath.row==0
            {
                let cell = tableView.dequeueReusableCell(withIdentifier:"hCell", for: indexPath) as! THTableViewCell
                cell.selectionStyle = .none
                cell.startTimeLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
                cell.endLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
                cell.lunchLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
                cell.totalLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
                cell.dateLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
                return cell
            }
            else
            {
                
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "etdCell") as! EnterTimeSlipDetailTableViewCell
                
                cell.startTimeTextField.tag = 7+indexPath.row
                cell.endTimeTextField.tag   = 96+indexPath.row
                cell.lunchTimeTextField.tag =  128+indexPath.row
                cell.taxFareTextField.tag = 112+indexPath.row
                cell.expensesDescriptionField.tag = 150+indexPath.row
                
                if object["TaxiOk"].intValue == 0
                {
                    cell.taxFareTextField.isHidden = true
                    cell.expensesDescriptionField.isHidden = true
                    cell.amountHeight.constant = 0
                    cell.expenseheight.constant = 0
                }
                else
                {
                    if object["ExpenseDocUploadForm"].boolValue == true
                    {
                        cell.taxFareTextField.isHidden = false
                        cell.expensesDescriptionField.isHidden = false
                        cell.amountHeight.constant = 2
                        cell.expenseheight.constant = 2
                    }
                    else
                    {
                        cell.taxFareTextField.isHidden = false
                        cell.expensesDescriptionField.isHidden = true
                        cell.amountHeight.constant = 2
                        cell.expenseheight.constant = 2
                    }
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
                        cell.taxFareTextField.font = UIFont.systemFont(ofSize:11)
                        cell.expensesDescriptionField.font = UIFont.systemFont(ofSize:11)
                        
                        
                    }
                    else
                    {
                        cell.startTimeTextField.font = UIFont.systemFont(ofSize:12)
                        cell.endTimeTextField.font = UIFont.systemFont(ofSize:12)
                        cell.taxFareTextField.font = UIFont.systemFont(ofSize:14)
                        cell.expensesDescriptionField.font = UIFont.systemFont(ofSize:14)
                        
                    }
                }
                
                
                
                cell.dateLabel.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
                if object.count>0
                {
                    if object["WeekDays"].arrayValue.count>0
                    {
                        if object["WeekDays"][indexPath.row-1].stringValue.count>10
                        {
                            
                            cell.dateLabel.text = getFormattedDate(string:object["WeekDays"][indexPath.row-1].stringValue).uppercased()
                        }
                        else
                        {
                            cell.dateLabel.text = ""
                        }
                    }
                }
                if reset
                {
                    cell.startTimeTextField.text! = starTimes[indexPath.row-1] as! String
                    cell.endTimeTextField.text! = endTimes[indexPath.row-1] as! String
                    cell.lunchTimeTextField.text = lunchHours[indexPath.row-1] as? String
                    cell.totalHoursLabel.text = ""
                    if object["\(weekdays[indexPath.row-1])"].intValue == 0
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
                    if indexPath.row == 7
                    {
                        reset = false
                    }
                    else
                    {
                        
                    }
                    return cell
                }
                else
                {
                    
                    if object["\(weekdays[indexPath.row-1])"].intValue == 0
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
                    
                    //TODO:- @@ Debug Here
                    /* //Old Code Before SchoolRN
                     if object["DohNurseForm"].boolValue == true
                     {
                     cell.lunchTimeTextField.isEnabled = false
                     cell.lunchTimeTextField.backgroundColor = UIColor(hexString:"#EEEEEE")
                     
                     }
                     */
                    
                    if object["DohNurseForm"].boolValue == true
                    {
                        if object["\(weekdays[indexPath.row-1])"].intValue == 0
                        {
                            cell.lunchTimeTextField.isEnabled = false
                            cell.lunchTimeTextField.backgroundColor = UIColor(hexString:"#EEEEEE")
                        }
                        else{
                            cell.lunchTimeTextField.isEnabled = true
                            cell.lunchTimeTextField.backgroundColor =  .white
                        }
                    }
                    
                    
                    cell.startTimeTextField.text = starTimes[indexPath.row-1] as? String
                    cell.endTimeTextField.text = endTimes[indexPath.row-1] as? String
                    cell.lunchTimeTextField.text = lunchHours[indexPath.row-1] as? String
                    cell.taxFareTextField.text = taxAmount[indexPath.row-1] as? String
                    
                    
                    
                    
                    //                    if cell.taxFareTextField.text!.count>0
                    //                    {
                    //                        taxAmount.replaceObject(at:indexPath.row-1, with:cell.taxFareTextField.text!)
                    //                        // cell.taxFareTextField.text = taxAmount[indexPath.row-1] as? String
                    //                    }
                    //                    else
                    //                    {
                    //                        taxAmount.replaceObject(at:indexPath.row-1, with:"")
                    //                        //cell.taxFareTextField.text = taxAmount[indexPath.row-1] as? String
                    //                    }
                    
                    if (cell.startTimeTextField.text!.count>0)&&(cell.endTimeTextField.text?.count)!>0
                    {
                        starTimes.replaceObject(at: indexPath.row-1, with: cell.startTimeTextField.text!)
                        endTimes.replaceObject(at: indexPath.row-1, with: cell.endTimeTextField.text!)
                        self.getHours(start:cell.startTimeTextField.text!, end:cell.endTimeTextField.text!, i:indexPath.row,min:false)
                    }
                    //                    if (cell.startTimeTextField.text!.count>=0)
                    //                    {
                    //                        starTimes.replaceObject(at: indexPath.row-1, with: cell.startTimeTextField.text!)
                    //                        //cell.startTimeTextField.text = starTimes[indexPath.row-1] as? String
                    //                    }
                    //                    else
                    //                    {
                    //                        //cell.startTimeTextField.text = starTimes[indexPath.row-1] as? String
                    //                    }
                    //                    if (cell.endTimeTextField.text?.count)!>=0
                    //                    {
                    //                        endTimes.replaceObject(at: indexPath.row-1, with: cell.endTimeTextField.text!)
                    //                        //cell.endTimeTextField.text = endTimes[indexPath.row-1] as? String
                    //                    }
                    //                    else
                    //                    {
                    //                        //cell.endTimeTextField.text = endTimes[indexPath.row-1] as? String
                    //                    }
                    if (cell.lunchTimeTextField.text!.count>0)&&(cell.startTimeTextField.text!.count>0)&&(cell.endTimeTextField.text?.count)!>0
                    {
                        //lunchHours.replaceObject(at: indexPath.row-1, with: cell.lunchTimeTextField.text!)
                        //                        let hours = totalHours[indexPath.row-1] as! String
                        //                        let fileArray = hours.components(separatedBy: ":")
                        //                        let hoursToMin = Int(fileArray[0])!*60
                        //                        let mins = Int(fileArray[1])!
                        //                        let timeDiff = hoursToMin+mins-Int((cell.lunchTimeTextField.text)!)!
                        //                        let timeInTotal = Double(totalTimeInHours[indexPath.row-1] as! String)!
                        //                        let lunchTime = Double((cell.lunchTimeTextField.text)!)!
                        //                        totalTimeInHours.replaceObject(at:indexPath.row-1, with:String(format:"%.2f",timeInTotal-lunchTime/60))
                        
                        
                        let timeInTotal = Double(totalTimeInHours[indexPath.row-1] as! String)!
                        let lunchTime = Double((cell.lunchTimeTextField.text)!)!
                        if object["DohNurseForm"].boolValue == true
                        {
                            totalTimeInHours.replaceObject(at:indexPath.row-1, with:String(format:"%.2f",timeInTotal))
                        }
                        else{
                            totalTimeInHours.replaceObject(at:indexPath.row-1, with:String(format:"%.2f",timeInTotal-lunchTime/60))
                        }
                        
                        cell.totalHoursLabel.text = totalTimeInHours[indexPath.row-1] as? String
                        self.addTotal()
                        
                        //                        let calculatedTime =  self.minutesToHoursMinutes(minutes: timeDiff)
                        //                        if calculatedTime.leftMinutes<10
                        //                        {
                        //                            if calculatedTime.leftMinutes<0
                        //                            {
                        //                                let time = String(format:"%d",Swift.abs(calculatedTime.leftMinutes))
                        //                                if time.count==1
                        //                                {
                        //                                    if calculatedTime.hours  == 0
                        //                                    {
                        //                                        totalHours.replaceObject(at: indexPath.row-1, with: String(format:"-%d",calculatedTime.hours)+":"+String(format:"0%d",Swift.abs(calculatedTime.leftMinutes)))
                        //                                    }
                        //                                    else
                        //                                    {
                        //                                        totalHours.replaceObject(at: indexPath.row-1, with: String(format:"%d",calculatedTime.hours)+":"+String(format:"0%d",Swift.abs(calculatedTime.leftMinutes)))
                        //                                    }
                        //                                }
                        //                                else
                        //                                {
                        //                                    if calculatedTime.hours  == 0
                        //                                    {
                        //                                        totalHours.replaceObject(at: indexPath.row-1, with: String(format:"-%d",calculatedTime.hours)+":"+String(format:"%d",Swift.abs(calculatedTime.leftMinutes)))
                        //                                    }
                        //                                    else
                        //                                    {
                        //                                        totalHours.replaceObject(at: indexPath.row-1, with: String(format:"%d",calculatedTime.hours)+":"+String(format:"%d",Swift.abs(calculatedTime.leftMinutes)))
                        //                                    }
                        //                                }
                        //                            }
                        //                            else
                        //                            {
                        //                                totalHours.replaceObject(at: indexPath.row-1, with: String(format:"%d",calculatedTime.hours)+":"+String(format:"0%d",calculatedTime.leftMinutes))
                        //                            }
                        //                        }
                        //                        else
                        //                        {
                        //                            totalHours.replaceObject(at: indexPath.row-1, with: String(format:"%d",calculatedTime.hours)+":"+String(format:"%d",calculatedTime.leftMinutes))
                        //                        }
                        self.addTotal()
                    }
                    else
                    {
                        lunchHours.replaceObject(at:indexPath.row-1, with:cell.lunchTimeTextField.text!)
                        //cell.lunchTimeTextField.text = lunchHours[indexPath.row-1] as? String
                        self.total()
                    }
                    if (cell.startTimeTextField.text!.count>0)&&(cell.endTimeTextField.text?.count)!>0
                    {
                        
                        cell.totalHoursLabel.text = totalTimeInHours[indexPath.row-1] as? String
                    }
                    else
                    {
                        cell.totalHoursLabel.text = ""
                        totalTimeInHours.replaceObject(at:indexPath.row-1, with:"")
                        //totalHours.replaceObject(at: indexPath.row-1, with:"00:00")
                    }
                    cell.selectionStyle = .none
                    return cell
                }
            }
        }
    }
    
    //MARK:- Method to round the lunch timings
    func roundLunchTime(_ value: Double) -> String
    {
        
        let toNearest = object["lunchIntervel"].doubleValue //15.0
        if toNearest>0 {
            return String(format: "%.0f", round(value / toNearest) * toNearest)
        }
        else {
            return String(format: "%.0f",value)
        }
        
    }
    
    func timeFormatted(totalSeconds: Int) -> String
    {
        let minutes: Int = (totalSeconds / 60) % 60
        let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (String,String) {
        print("\(seconds / 3600):\((seconds % 3600) / 60)")
        return ("\(seconds / 3600)","\((seconds % 3600) / 60)")
    }
}



extension EnterTimeSlipDetailViewController: SambagTimePickerViewControllerDelegate {
    
    func sambagTimePickerDidSet(_ viewController: SambagTimePickerViewController, result: SambagTimePickerResult)
    {
        if (activeTextField!.tag>7)&&(activeTextField!.tag)<16
        {
            activeTextField?.text = String(describing: result)
            //        if (activeTextField!.tag)>7
            //        {
            starTimes.replaceObject(at: (activeTextField?.tag)!-8, with:String(describing: result))
            //}
            //        else if (activeTextField!.tag)>1
            //        {
            //            lunchHours.replaceObject(at: (activeTextField?.tag)!-17, with: cell.lunchTimeTextField.text!)
            //        }
        }
        else if (activeTextField!.tag>96)&&(activeTextField!.tag)<104
        {
            activeTextField?.text = String(describing: result)
            endTimes.replaceObject(at: (activeTextField?.tag)!-97, with:String(describing: result))
        }
        //        else if (activeTextField!.tag>112)&&(activeTextField!.tag)<119
        //        {
        //            taxAmount.replaceObject(at:indexPath.row-1, with:cell.taxFareTextField.text!)
        //        }
        
        if (activeTextField!.tag>16)&&(activeTextField!.tag<24)
        {
            five.replaceObject(at:(activeTextField?.tag)!-17, with:String(describing: result).substring(to: 2))
            fiveMin.replaceObject(at:(activeTextField?.tag)!-17, with:String(describing: result).substring(with: 3..<5))
        }
        else if (activeTextField!.tag>32)&&(activeTextField!.tag<40)
        {
            six.replaceObject(at:(activeTextField?.tag)!-33, with:String(describing: result).substring(to: 2))
            sixMin.replaceObject(at:(activeTextField?.tag)!-33,with:String(describing: result).substring(with: 3..<5))
        }
        else if (activeTextField!.tag>48)&&(activeTextField!.tag<56)
        {
            ten.replaceObject(at:(activeTextField?.tag)!-49, with:String(describing: result).substring(to: 2))
            tenMin.replaceObject(at:(activeTextField?.tag)!-49, with:String(describing:result).substring(with: 3..<5))
        }
        else if (activeTextField!.tag>64)&&(activeTextField!.tag<72)
        {
            twelve.replaceObject(at:(activeTextField?.tag)!-65, with:String(describing: result).substring(to: 2))
            twelveMin.replaceObject(at:(activeTextField?.tag)!-65, with:String(describing: result).substring(with: 3..<5))
        }
        
        totalForDoh.removeAllObjects()
        
        let hoursFive = five.map{($0 as AnyObject).integerValue}
        let hoursSix = six.map{($0 as AnyObject).integerValue}
        let hoursTen = ten.map{($0 as AnyObject).integerValue}
        let hoursTwe = twelve.map{($0 as AnyObject).integerValue}
        
        let hoursFiveMin = fiveMin.map{($0 as AnyObject).integerValue}
        let hoursSixMin = sixMin.map{($0 as AnyObject).integerValue}
        let hoursTenMin = tenMin.map{($0 as AnyObject).integerValue}
        let hoursTweMin = twelveMin.map{($0 as AnyObject).integerValue}
        
        
        
        for total in 0..<7
        {
            
            var totalTimeConversionArray = Double()
            var hoursToMin:Int = Int()
            hoursToMin = hoursFive[total]!+hoursSix[total]!+hoursTen[total]!+hoursTwe[total]!
            
            var mins:Int = Int()
            mins = hoursFiveMin[total]!+hoursSixMin[total]!+hoursTenMin[total]!+hoursTweMin[total]!
            
            let total:Double = (Double(hoursToMin*60+mins))
            
            totalTimeConversionArray = Double(total/60)
            totalForDoh.add(totalTimeConversionArray)
            
        }
        
        let totalTimeslip = totalForDoh.map{($0 as AnyObject).doubleValue}
        var n = 0.0
        for i in totalTimeslip {
            n += i!
        }
        
        print(n)
        dohTotalTime.text = String(format:"%.2f",n)
        timeSlipTableView.reloadData()
        dohTableView.reloadData()
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func sambagTimePickerDidCancel(_ viewController: SambagTimePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

extension EnterTimeSlipDetailViewController:DateTimePickerDelegate
{
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        print(picker.selectedDateString)
    }
}
extension EnterTimeSlipDetailViewController:pickerDelegate
{
    func selected(time:String) {
        print(time)
        activeTextField?.text = time
        if (self.activeTextField!.tag>16)&&(self.activeTextField!.tag<24)
        {
            self.five.replaceObject(at:(self.activeTextField?.tag)!-17, with:time.substring(to: 2))
            self.fiveMin.replaceObject(at:(self.activeTextField?.tag)!-17, with:time.substring(with: 3..<5))
        }
        else if (self.activeTextField!.tag>32)&&(self.activeTextField!.tag<40)
        {
            self.six.replaceObject(at:(self.activeTextField?.tag)!-33, with:time.substring(to: 2))
            self.sixMin.replaceObject(at:(self.activeTextField?.tag)!-33,with:time.substring(with: 3..<5))
        }
        else if (self.activeTextField!.tag>48)&&(self.activeTextField!.tag<56)
        {
            self.ten.replaceObject(at:(self.activeTextField?.tag)!-49, with:time.substring(to: 2))
            self.tenMin.replaceObject(at:(self.activeTextField?.tag)!-49, with:time.substring(with: 3..<5))
        }
        else if (self.activeTextField!.tag>64)&&(self.activeTextField!.tag<72)
        {
            self.twelve.replaceObject(at:(self.activeTextField?.tag)!-65, with:time.substring(to: 2))
            self.twelveMin.replaceObject(at:(self.activeTextField?.tag)!-65, with:time.substring(with: 3..<5))
        }
        
        self.totalForDoh.removeAllObjects()
        
        let hoursFive = self.five.map{($0 as AnyObject).integerValue}
        let hoursSix = self.six.map{($0 as AnyObject).integerValue}
        let hoursTen = self.ten.map{($0 as AnyObject).integerValue}
        let hoursTwe = self.twelve.map{($0 as AnyObject).integerValue}
        
        let hoursFiveMin = self.fiveMin.map{($0 as AnyObject).integerValue}
        let hoursSixMin = self.sixMin.map{($0 as AnyObject).integerValue}
        let hoursTenMin = self.tenMin.map{($0 as AnyObject).integerValue}
        let hoursTweMin = self.twelveMin.map{($0 as AnyObject).integerValue}
        
        
        
        for total in 0..<7
        {
            
            var totalTimeConversionArray = Double()
            var hoursToMin:Int = Int()
            hoursToMin = hoursFive[total]!+hoursSix[total]!+hoursTen[total]!+hoursTwe[total]!
            
            var mins:Int = Int()
            mins = hoursFiveMin[total]!+hoursSixMin[total]!+hoursTenMin[total]!+hoursTweMin[total]!
            
            let total:Double = (Double(hoursToMin*60+mins))
            
            totalTimeConversionArray = Double(total/60)
            self.totalForDoh.add(String(format:"%.2f",totalTimeConversionArray))
            
        }
        
        let totalTimeslip = self.totalForDoh.map{($0 as AnyObject).doubleValue}
        var n = 0.0
        for i in totalTimeslip {
            n += i!
        }
        
        print(n)
        self.dohTotalTime.text = String(format:"%.2f",n)
        self.timeSlipTableView.reloadData()
        self.dohTableView.reloadData()
    }
    
}
extension EnterTimeSlipDetailViewController: UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
}
extension EnterTimeSlipDetailViewController: UIPickerViewDataSource
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


