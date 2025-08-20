//
//  EnterAvailabilityViewController.swift
//  EWA
//
//  Created by NFC Solutions on 23/10/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toast_Swift
import DropDown
import ANLoader
import CropViewController



class EnterAvailabilityViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate{
    var object: JSON = JSON.null
    var object2: JSON = JSON.null
    var submitObject:JSON = JSON.null
    var picUploadData:JSON = JSON.null
    var clearScheduleData:JSON = JSON.null
    var activeField: UITextField?
    var todaysDate = String()
    var theme: SambagTheme = .light
    var tag = Int()
    var selectedWeekEnd = String()
    var activeTextField: UITextField?
    
    
    
    @IBOutlet var firstLabel: UILabel!
    @IBOutlet var thirdLabel: UILabel!
    @IBOutlet var secondLabel: UILabel!
    @IBOutlet var seventhLabel: UILabel!
    @IBOutlet var sixthLabel: UILabel!
    @IBOutlet var fifthLabel: UILabel!
    @IBOutlet var fourthLabel: UILabel!
    
    
    @IBOutlet var mStextField: UITextField!
    @IBOutlet var tStextField: UITextField!
    @IBOutlet var wStextField: UITextField!
    @IBOutlet var thStextField: UITextField!
    @IBOutlet var suStextField: UITextField!
    @IBOutlet var sStextField: UITextField!
    @IBOutlet var fStextField: UITextField!
    
    
    @IBOutlet var mEtextField: UITextField!
    @IBOutlet var suEtextField: UITextField!
    @IBOutlet var sEtextField: UITextField!
    @IBOutlet var fEtextField: UITextField!
    @IBOutlet var thEtextField: UITextField!
    @IBOutlet var wEtextField: UITextField!
    @IBOutlet var tEtextField: UITextField!
    
    @IBOutlet var mTotalLabel: UILabel!
    @IBOutlet var tTotalLabel: UILabel!
    @IBOutlet var wTotalLabel: UILabel!
    @IBOutlet var thTotalLabel: UILabel!
    @IBOutlet var fTotalLabel: UILabel!
    @IBOutlet var sTotalLabel: UILabel!
    @IBOutlet var suTotalLabel: UILabel!
    
    @IBOutlet var cmtwButton: UIButton!
    @IBOutlet var cmtweButton: UIButton!
    @IBOutlet var submitButton: UIButton!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var sTextFields: [UITextField]!
    
    @IBOutlet var eTextFields: [UITextField]!
    
    @IBOutlet var tLabels: [UILabel]!
    
    @IBOutlet var dayLabels: [UILabel]!
    
    var weekedays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    var indexWeek = Int()
    var isZero = Bool()
    var isTotalNegative = Bool()
    var empty = NSMutableArray()
    var cleared = Bool()
    var ASHTSkipStatus = Int()
    @IBOutlet var dateHeaderLabel: UILabel!
    @IBOutlet var endHeaderLabel: UILabel!
    @IBOutlet var startHeaderLabel: UILabel!
    @IBOutlet var totalHeaderLabel: UILabel!
    var totalTimeInHours = NSMutableArray()
    var totalHours = NSMutableArray()
    
    let chooseArticleDropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.chooseArticleDropDown
        ]
    }()
    @IBOutlet var selectWeekButton: PKButton!
    var selectedIndex = 0
    
    @IBOutlet var infoView: UIView!
    var blurEffect = UIBlurEffect()
    var blurEffectView = UIVisualEffectView()
    @IBOutlet var nameLabel: PaddingLabel!
    var WeekEndIndex = 0
    
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.updateNavigationBarColor()
        
        //calling the api
        DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
            ANLoader.hide()
        })
        if ConnectionCheck.isConnectedToNetwork()
        {
            //                ANLoader.showLoading("", disableUI:false)
            ServerService.showActivityIndicatory(uiView:self.view)
            let params:[String:String] = ["UserName":UserDefaults.standard.object(forKey: "username") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"CandId":UserDefaults.standard.object(forKey: "cID") as! String, "ASHTSkipStatus":"0"]
            print(params)
            ServerService.getAvailability(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponse(response:))
        }
        else
        {
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
        //ANLoader.showLoading("", disableUI:true)
        
        
        for i in 0..<7
        {
            dayLabels[i].backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        }
        
        
        
        //getting Today's Date
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        todaysDate = result
        
        dateHeaderLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        startHeaderLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        endHeaderLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        totalHeaderLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        
        totalTimeInHours = ["0","0","0","0","0","0","0"]
        totalHours = ["","","","","","",""]
        
        
        nameLabel.text = UserDefaults.standard.object(forKey:"CandName") as? String
        
        
        let tapGesture = UITapGestureRecognizer(target:self, action: #selector(self.myviewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tapGesture)
        
    }
    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
        ANLoader.hide()
    }
    
    func getAvailabilityFromServer(){
        //calling the api
        DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
            ANLoader.hide()
        })
        if ConnectionCheck.isConnectedToNetwork()
        {
            //                ANLoader.showLoading("", disableUI:false)
            ServerService.showActivityIndicatory(uiView:self.view)
            let params:[String:String] = ["UserName":UserDefaults.standard.object(forKey: "username") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String,"CandId":UserDefaults.standard.object(forKey: "cID") as! String,"ASHTSkipStatus":"\(ASHTSkipStatus)"]
            print(params)
            ServerService.getAvailability(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponse(response:))
        }
        else
        {
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
    }
    
    //dropDownSetUp
    func setupChooseArticleDropDown(anchorView:UIButton,items:[String]) {
        chooseArticleDropDown.anchorView = anchorView
        chooseArticleDropDown.bottomOffset = CGPoint(x: 0, y: anchorView.bounds.height)
        chooseArticleDropDown.backgroundColor = .white
        chooseArticleDropDown.dataSource =  items
        chooseArticleDropDown.selectionAction = { [unowned self] (index,item) in
            print(self.index)
            print(item)
            //calling the getAvailabilityapi
            DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
                ANLoader.hide()
            })
            if ConnectionCheck.isConnectedToNetwork()
            {
                //ANLoader.showLoading("", disableUI:false)
                ServerService.showActivityIndicatory(uiView:self.view)
                let paramsForGetAvailability:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"WeekendDateTimeSlips":item]
                print(paramsForGetAvailability)
                ServerService.getTimeDetailsAvailability(self, params: paramsForGetAvailability, method:"POST", accessToken:Constants.Token, acces:true, callBack:self.getresponsegetAvailabilityapi(response:))
            }
            else
            {
                ANLoader.hide()
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                
            }
            
            self.selectedWeekEnd = item
            self.selectWeekButton.setTitle(item, for:.normal)
            
            var itemsDrop:[String] = []
            for weekEndDate in 0..<self.object["AvailabilityWeekEnds"].arrayValue.count {
                
                if self.object["AvailabilityWeekEnds"][weekEndDate].stringValue.count>=10
                {
                    itemsDrop.append(Constants.getFormattedDateForPersonalJob(string:self.object["AvailabilityWeekEnds"][weekEndDate].stringValue.substring(to:10)))
                }
            }
            let index = itemsDrop.index(of:item)
            self.WeekEndIndex = index!
            self.selectedIndex = index!
            //            if index == self.object["AvailabilityWeekEnds"].arrayValue.count-1
            //            {
            //                self.selectedIndex = 0
            //            }
            //            else if index == 0
            //            {
            //                self.selectedIndex = 2
            //            }
            //
            //            else
            //            {
            //                self.selectedIndex = 2-index!
            //            }
            
        }
    }
    
    
    
    //aftergettingResponseFrom the server
    func getresponse(response:AnyObject)->()
    {
        //ANLoader.hide()
        self.changeNavigationTitle("Enter Availability")
        ServerService.hideProgressView()
        object = response as! JSON
        print(object)
        if object.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else
        {
            
            if  object["Status"].stringValue == "Fail" {
                
                self.checkFormsToDisplay(object["FormName"].stringValue)
            }
            else {
                // WeekEndIndex = object["AvailabilityWeekEnds"].arrayValue.count-1
                if  object["AvailabilityWeekEnds"][0].stringValue.count>=10
                {
                    ASHTSkipStatus = 0
                    self.selectWeekButton.setTitle(Constants.getFormattedDateForPersonalJob(string:object["AvailabilityWeekEnds"][0].stringValue.substring(to: 10)), for:.normal)
                    //calling the getAvailabilityapi
                    //ANLoader.showLoading("", disableUI:false)
                    ServerService.showActivityIndicatory(uiView:self.view)
                    let paramsForGetAvailability:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"WeekendDateTimeSlips":Constants.getFormattedDateForPersonalJob(string:object["AvailabilityWeekEnds"][0].stringValue.substring(to: 10)),"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String]
                    print(paramsForGetAvailability)
                    ServerService.getTimeDetailsAvailability(self, params: paramsForGetAvailability, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponsegetAvailabilityapi(response:))
                    selectedWeekEnd = self.getFormattedDateCosmatic(string:object["AvailabilityWeekEnds"][0].stringValue.substring(to: 10))
                    
                }
            }
        }
    }
    //aftergettinggetAvailabilityapiResponseFrom the server
    func getresponsegetAvailabilityapi(response:AnyObject)->()
    {
        //ANLoader.hide()
        ServerService.hideProgressView()
        empty = [0,0,0,0,0,0,0]
        object2 = response as! JSON
        print("getAvailability",object2)
        if object2.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else
        {
            for i in 0..<7
            {
                if object2["WeekDays"][i].stringValue.count>0
                {
                    dayLabels[i].text = getFormattedDate(string:object2["WeekDays"][i].stringValue).uppercased()
                }
                else
                {
                    dayLabels[i].text = ""
                }
            }
            for i in 0..<object2["WeekDays"].arrayValue.count
            {
                if object2["AvailabilityWeeks"][i]["StartTime"].stringValue == ""
                {
                    sTextFields[i].text = ""
                }
                else
                {
                    sTextFields[i].text = object2["AvailabilityWeeks"][i]["StartTime"].stringValue
                }
                if object2["AvailabilityWeeks"][i]["EndTime"].stringValue == ""
                {
                    eTextFields[i].text = ""
                }
                else
                {
                    eTextFields[i].text = object2["AvailabilityWeeks"][i]["EndTime"].stringValue
                }
                //            if object2["AvailabilityWeeks"][i]["Locked"].intValue == 0
                //            {
                //                sTextFields[i].isEnabled = true
                //                eTextFields[i].isEnabled = true
                //                sTextFields[i].backgroundColor = .white
                //                eTextFields[i].backgroundColor = .white
                //            }
                //            else
                //            {
                //                sTextFields[i].isEnabled = false
                //                eTextFields[i].isEnabled = false
                //                sTextFields[i].backgroundColor = .lightGray
                //                eTextFields[i].backgroundColor = .lightGray
                //
                //            }
            }
            
            for i in 0..<object2["WeekDays"].arrayValue.count
            {
                
                if object2["AvailabilityWeeks"][i]["Locked"].intValue == 1
                {
                    sTextFields[i].isEnabled = false
                    eTextFields[i].isEnabled = false
                    sTextFields[i].backgroundColor = UIColor(hexString:"#EEEEEE")
                    eTextFields[i].backgroundColor = UIColor(hexString:"#EEEEEE")
                    sTextFields[i].leftView?.isHidden = true
                    eTextFields[i].leftView?.isHidden = true
                    sTextFields[i].clearButtonMode = .never
                    eTextFields[i].clearButtonMode = .never
                }
                else
                {
                    
                    if object2["NoOfDays"].intValue>0
                    {
                        let enabledFields = object2["NoOfDays"].intValue-1
                        
                        if i<enabledFields
                        {
                            sTextFields[i].isEnabled = false
                            eTextFields[i].isEnabled = false
                            sTextFields[i].backgroundColor = UIColor(hexString:"#EEEEEE")
                            eTextFields[i].backgroundColor = UIColor(hexString:"#EEEEEE")
                            sTextFields[i].leftView?.isHidden = true
                            eTextFields[i].leftView?.isHidden = true
                            sTextFields[i].clearButtonMode = .never
                            eTextFields[i].clearButtonMode = .never
                        }
                        else
                        {
                            sTextFields[i].isEnabled = true
                            eTextFields[i].isEnabled = true
                            sTextFields[i].backgroundColor = .white
                            eTextFields[i].backgroundColor = .white
                            sTextFields[i].clearButtonMode = .unlessEditing
                            eTextFields[i].clearButtonMode = .unlessEditing
                            sTextFields[i].leftView?.isHidden = false
                            eTextFields[i].leftView?.isHidden = false
                        }
                    }
                    else
                    {
                        sTextFields[i].isEnabled = true
                        eTextFields[i].isEnabled = true
                        sTextFields[i].backgroundColor = .white
                        eTextFields[i].backgroundColor = .white
                        sTextFields[i].clearButtonMode = .unlessEditing
                        eTextFields[i].clearButtonMode = .unlessEditing
                        sTextFields[i].leftView?.isHidden = false
                        eTextFields[i].leftView?.isHidden = false
                    }
                }
            }
            
            
            
            
            //        if object2["NoOfDays"].intValue>0
            //        {
            //            let enabledFields = object2["NoOfDays"].intValue-1
            //            for i in 0..<enabledFields
            //            {
            //                sTextFields[i].isEnabled = false
            //                eTextFields[i].isEnabled = false
            //                sTextFields[i].backgroundColor = UIColor(hexString:"#EEEEEE")
            //                eTextFields[i].backgroundColor = UIColor(hexString:"#EEEEEE")
            //                sTextFields[i].leftView?.isHidden = true
            //                eTextFields[i].leftView?.isHidden = true
            //            }
            //            for j in enabledFields..<7
            //            {
            //                sTextFields[j].isEnabled = true
            //                sTextFields[j].backgroundColor = .white
            //                eTextFields[j].backgroundColor = .white
            //                sTextFields[j].clearButtonMode = .unlessEditing
            //                eTextFields[j].clearButtonMode = .unlessEditing
            //                sTextFields[j].leftView?.isHidden = false
            //                eTextFields[j].leftView?.isHidden = false
            //            }
            //        }
            //        else
            //        {
            //            for i in 0..<7
            //            {
            //                sTextFields[i].isEnabled = true
            //                eTextFields[i].isEnabled = true
            //                sTextFields[i].backgroundColor = .white
            //                eTextFields[i].backgroundColor = .white
            //                sTextFields[i].clearButtonMode = .unlessEditing
            //                eTextFields[i].clearButtonMode = .unlessEditing
            //                sTextFields[i].leftView?.isHidden = false
            //                eTextFields[i].leftView?.isHidden = false
            //            }
            //        }
            //
            
            
            for total in 0..<7
            {
                if sTextFields[total].text!.count>1 && eTextFields[total].text!.count>1
                {
                    print("the start and end TF is, \(String(describing: sTextFields[total].text)), \(String(describing: eTextFields[total].text))")
                    self.getHours(start:(sTextFields[total].text)!,end:(eTextFields[total].text)!, i: total,space:true)
                }
                else
                {
                    tLabels[total].text = ""
                }
            }
        }
    }
    
    
    
    
    
    
    //function to get date
    func getFormattedDate(string: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // This formate is input formated .
        let formateDate = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "dd  EEE" // Output Formated
        return dateFormatter.string(from: formateDate)
    }
    
    //function to convert date
    func convertDate(string: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // This formate is input formated .
        let formateDate = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "yyyy-MM-dd" // Output Formated
        return dateFormatter.string(from: formateDate)
    }
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0,keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        activeField = textField
        activeTextField = textField
        textField.resignFirstResponder()
        
        
        if cleared
        {
            cleared = false
            textField.endEditing(true)
        }
        else
        {
            
            self.showPicker()
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
        self.total()
    }
    public func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        cleared = true
        return true
    }
    func total()
    {
        
        for total in 0..<7
        {
            if sTextFields[total].text!.count>0&&eTextFields[total].text!.count>0
            {
                
            }
            else
            {
                tLabels[total].text = ""
                totalHours[total] = ""
                totalTimeInHours[total] = "0"
            }
        }
        
    }
    @IBAction func previousAction(_ sender: Any)
    {
        
        
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        
        
        var itemsDrop:[String] = []
        for weekEndDate in 0..<object["AvailabilityWeekEnds"].arrayValue.count {
            
            
            itemsDrop.append(Constants.getFormattedDateForPersonalJob(string:object["AvailabilityWeekEnds"][weekEndDate].stringValue.substring(to:10)))
        }
        
        setupChooseArticleDropDown(anchorView:sender as! UIButton,items:itemsDrop)
        chooseArticleDropDown.show()
        
    }
    
    
    @IBAction func copyMondayToWeekDaysAction(_ sender: Any)
    {
        //        if mStextField.isEnabled
        //        {
        for j in 1..<5
        {
            sTextFields[j].text = mStextField.text
            eTextFields[j].text = mEtextField.text
            tLabels[j].text = tLabels[0].text
            totalTimeInHours[j] = tLabels[0].text!
        }
        
        //}
    }
    
    @IBAction func copyMondayToWeekEndAction(_ sender: Any)
    {
        //        if mStextField.isEnabled
        //        {
        for j in 5..<7
        {
            sTextFields[j].text = mStextField.text
            eTextFields[j].text = mEtextField.text
            tLabels[j].text = tLabels[0].text
            totalTimeInHours[j] = tLabels[0].text!
        }
        //}
        
    }
    
    @IBAction func submitAction(_ sender: Any)
    {
        isTotalNegative = false
        isZero = false
        
        for data in 0..<7
        {
            if sTextFields[data].text!.count>0 && eTextFields[data].text!.count>0
            {
                //                if sTextFields[data].isEnabled && eTextFields[data].isEnabled
                //                {
                empty.replaceObject(at:data, with:1)
                //}
            }
        }
        
        if empty.contains(1)
        {
            isTotalNegative = false
            for i in 0..<7
            {
                let hours = totalTimeInHours[i] as? String
                if (hours?.hasPrefix("-"))!
                {
                    isTotalNegative = true
                    break
                }
                if (sTextFields[i].text!.count>0)&&(eTextFields[i].text!.count>0)
                {
                    if sTextFields[i].isEnabled && eTextFields[i].isEnabled
                    {
                        let totalHours:Double = Double(totalTimeInHours[i] as! String)!
                        if totalHours == 0
                        {
                            isZero = true
                            indexWeek = i
                            break
                        }
                    }
                }
            }
            if isTotalNegative
            {
                ServerService.ShowAlertMessage(ErrorMessage: "", title:"Please make sure total hours should not be zero or less than zero.", view: self)
                isTotalNegative = false
                
            }
            else if isZero
            {
                ServerService.ShowAlertMessage(ErrorMessage: "", title: "Please make sure \(weekedays[indexWeek]) total hours should not be zero or less than zero.", view: self)
                //                 ServerService.ShowAlertMessage(ErrorMessage: "", title: "Please make sure (\(weekedays[indexWeek]) total hours should not be zero or less than zero.   Please make sure Start and End Time cannot be same on (\(weekedays[indexWeek])   No availability schedule was selected. Please enter your schedule and submit again.", view: self)
                //self.navigationController?.view.makeToast("Start and End Time cannot be same on (\(weekedays[indexWeek]))", duration: 3.0, position: .bottom, title: "", image: nil)
                isZero = false
            }
            else
            {
                
                
                var title = String()
                if WeekEndIndex<object["AvailabilityWeekEnds"].arrayValue.count-1
                {
                    
                    
                    title = "Would you also like to save this availability for the following week(s):\(self.selectedWeekEnd) to \(self.getFormattedDateCosmatic(string:object["AvailabilityWeekEnds"][(object["AvailabilityWeekEnds"].arrayValue.count-1)].stringValue.substring(to:10)))"
                    
                }
                
                else
                {
                    title = "Would you like to submit the data for the following weekend \(self.selectedWeekEnd)"
                }
                
                
                
                let confromAlert = UIAlertController(title:title, message:"", preferredStyle: UIAlertControllerStyle.alert)
                confromAlert.addAction(UIAlertAction(title: "NO", style: .destructive) { (action:UIAlertAction!) in
                    
                    if title == "Would you like to submit the data for the following weekend \(self.selectedWeekEnd)"
                    {
                        
                    }
                    else
                    {
                        self.selectedIndex = 0
                        self.subitMethod()
                    }
                    
                })
                confromAlert.addAction(UIAlertAction(title: "YES", style: .default) { (action:UIAlertAction!) in
                    
                    if self.selectedIndex<self.object["AvailabilityWeekEnds"].arrayValue.count-1
                    {
                        self.selectedIndex = ((self.object["AvailabilityWeekEnds"].arrayValue.count-1)-self.selectedIndex)
                    }
                    else
                    {
                        self.selectedIndex = 0
                    }
                    
                    self.subitMethod()
                })
                if title.count>0
                {
                    self.present(confromAlert, animated: true)
                    confromAlert.view.tintColor = UIColor(hexString: "#449D44")
                }
                
            }
        }
        else
        {
            
            let attributedString = NSAttributedString(string:"No availability schedule was selected. Please enter your schedule and submit again.", attributes: [
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
            alert.view.tintColor = UIColor(hexString: "#449D44")
        }
    }
    
    
    func subitMethod()
    {
        var times = Array<[String:Any]>()
        
        
        for i in 0..<7
        {
            if(self.sTextFields[i].text!.count>0)&&(self.eTextFields[i].text!.count>0)&&((self.totalTimeInHours[i] as! String).count>0)
            {
                
                let time =  ["StartTime":self.sTextFields[i].text!,"EndTime":self.eTextFields[i].text!,"TotalHours":"\(totalTimeInHours[i])"] as [String : Any]
                times.append(time)
            }
            else
            {
                let total = ""
                let time =  ["StartTime":"","EndTime":"","TotalHours":total] as [String : String]
                times.append(time)
            }
        }
        if times.count==7
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
                ANLoader.hide()
            })
            if ConnectionCheck.isConnectedToNetwork()
            {
                //ANLoader.showLoading("", disableUI:true)
                ServerService.showActivityIndicatory(uiView:self.view)
                let submitParams = ["CandId" :(UserDefaults.standard.object(forKey: "cID") as! String),"WeekEndDate" :self.selectedWeekEnd,"TimeDetails":times,"NoofIndex":self.selectedIndex] as [String : Any]
                print(submitParams)
                ServerService.submitAvailability(self, params:submitParams, method: "POST", accessToken:Constants.Token, acces:true, callBack: self.getSubmitRecords(response:))
            }
            else
            {
                ANLoader.hide()
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            }
            
        }
    }
    
    
    func getSubmitRecords(response:AnyObject)->()
    {
        //ANLoader.hide()
        ServerService.hideProgressView()
        submitObject = response as! JSON
        if submitObject.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else
        {
            
            var itemsDrop:[String] = []
            for weekEndDate in 0..<self.object["AvailabilityWeekEnds"].arrayValue.count {
                
                if self.object["AvailabilityWeekEnds"][weekEndDate].stringValue.count>=10
                {
                    itemsDrop.append(Constants.getFormattedDateForPersonalJob(string:self.object["AvailabilityWeekEnds"][weekEndDate].stringValue.substring(to:10)))
                }
            }
            let index = itemsDrop.index(of:selectedWeekEnd)
            self.WeekEndIndex = index!
            self.selectedIndex = index!
            print("submit response",submitObject)
            if submitObject["HttpRequestStatus"].intValue == 200
            {
                
                if selectedIndex == 0
                {
                    ServerService.ShowAlertMessage(ErrorMessage: "", title:submitObject["Status"].stringValue, view: self)
                }
                else
                {
                    ServerService.ShowAlertMessage(ErrorMessage: "", title:submitObject["Status"].stringValue, view: self)
                }
            }
            else if submitObject["Status"].stringValue.count>0
            {
                ServerService.ShowAlertMessage(ErrorMessage: "", title:submitObject["Status"].stringValue, view: self)
            }
            else
            {
                ServerService.ShowAlertMessage(ErrorMessage: "", title:"Failed to submit", view: self)
            }
        }
    }
    
    
    
    //called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    
    func convertDateForTotal(date:String,space:Bool) -> String
    {
        let tt = date
        let dateFormatterf = DateFormatter()
        dateFormatterf.locale = Locale.preferredLocale()
        dateFormatterf.dateFormat = "h:mmaa"
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
    
    
    
    func convertDate(date:String,space:Bool) -> String
    {
        let tt = date
        let dateFormatterf = DateFormatter()
        dateFormatterf.locale = Locale.preferredLocale()
        dateFormatterf.dateFormat = "h:mmaa" //TODO:- Removed Space before "h:mm aa"
        let dateee = dateFormatterf.date(from:tt)
        dateFormatterf.dateFormat = "HH:mm"
        if (dateee != nil)
        {
            let Date24 = dateFormatterf.string(from:dateee!)
            print("24 hour formatted Date:",Date24)
            return Date24
        }
        else
        {
            return ""
        }
    }
    func addTimes(start:String,end:String) -> Int
    {
        
        print(start)
        print(end)
        let startDate = start
        let endDate = end
        
        let startArray = startDate.components(separatedBy:(":"))
        let endArray = endDate.components(separatedBy: (":"))
        
        //let startHours:Int? = Int(startArray[0])! * 60
        print("the start array of 0 is ", startArray[0])
        print("the start array of 1 is ", startArray[1])
        let startHours:Int? = startArray[0].integerValue * 60
        //let startMinutes:Int? = Int(startArray[1])! + startHours!
        let startMinutes:Int? = startArray[1].integerValue + startHours!
        
        let endHours:Int? = endArray[0].integerValue * 60
        print("the end array of 0 is ", endArray[0])
        print("the end array of 1 is ", endArray[1])
        let endMinutes:Int? = endArray[1].integerValue + endHours!
        
        var timeDifference = endMinutes! - startMinutes!
        
        let day = 24 * 60
        
        if timeDifference < 0 {
            timeDifference += day
        }
        print("the time difference is ",timeDifference)
        return timeDifference
    }
    func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    func getHours(start:String,end:String,i:Int,space:Bool)
    {
        if space
        {
            let tuple = minutesToHoursMinutes(minutes: self.addTimes(start:self.convertDateForTotal(date:start,space:space), end: self.convertDateForTotal(date:end,space:space)))
            
            //            if tuple.hours<10
            //            {
            //                if tuple.leftMinutes<10
            //                {
            //                    totalHours.replaceObject(at:i, with: String(format:"0%d",tuple.hours)+":"+String(format:"0%d",tuple.leftMinutes))
            //                }
            //                else
            //                {
            //                    totalHours.replaceObject(at:i, with: String(format:"0%d",tuple.hours)+":"+String(format:"%d",tuple.leftMinutes))
            //                }
            //            }
            //            else
            //            {
            //                if tuple.leftMinutes<10
            //                {
            //                    totalHours.replaceObject(at:i, with: String(format:"%d",tuple.hours)+":"+String(format:"0%d",tuple.leftMinutes))
            //                }
            //                else
            //                {
            //                    totalHours.replaceObject(at:i, with: String(format:"%d",tuple.hours)+":"+String(format:"%d",tuple.leftMinutes))
            //                }
            //            }
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
            tLabels[i].text = totalTimeInHours[i] as? String
            
        }
        else
        {
            let tuple = minutesToHoursMinutes(minutes: self.addTimes(start:self.convertDate(date:start,space:space), end: self.convertDate(date:end,space:space)))
            //            if tuple.hours<10
            //            {
            //                if tuple.leftMinutes<10
            //                {
            //                    totalHours.replaceObject(at:i, with: String(format:"0%d",tuple.hours)+":"+String(format:"0%d",tuple.leftMinutes))
            //                }
            //                else
            //                {
            //                    totalHours.replaceObject(at:i, with: String(format:"0%d",tuple.hours)+":"+String(format:"%d",tuple.leftMinutes))
            //                }
            //            }
            //            else
            //            {
            //                if tuple.leftMinutes<10
            //                {
            //                    totalHours.replaceObject(at:i, with: String(format:"%d",tuple.hours)+":"+String(format:"0%d",tuple.leftMinutes))
            //                }
            //                else
            //                {
            //                    totalHours.replaceObject(at:i, with: String(format:"%d",tuple.hours)+":"+String(format:"%d",tuple.leftMinutes))
            //                }
            //            }
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
            tLabels[i].text = totalTimeInHours[i] as? String
            
            
        }
    }
    
    @IBAction func clearaction(_ sender: Any)
    {
        
        let confromAlert = UIAlertController(title: "Would you like to clear availability for the following week: \( selectedWeekEnd)", message:"", preferredStyle: UIAlertControllerStyle.alert)
        confromAlert.addAction(UIAlertAction(title: "NO", style: .destructive) { (action:UIAlertAction!) in
            
            
        })
        confromAlert.addAction(UIAlertAction(title: "YES", style: .default) { (action:UIAlertAction!) in
            
            if ConnectionCheck.isConnectedToNetwork()
            {
                //ANLoader.showLoading("", disableUI:false)
                ServerService.showActivityIndicatory(uiView:self.view)
                let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"WeekEndDate":self.selectedWeekEnd]
                print("clear schedule params",params)
                ServerService.clearSchedule(self, params:params, method:"POST", accessToken:Constants.Token, acces:true, callBack:self.getresponseForClearSchedule(response:))
            }
            else
            {
                ANLoader.hide()
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                
            }
            
        })
        
        self.present(confromAlert, animated: true)
        confromAlert.view.tintColor = UIColor(hexString: "#449D44")
    }
    
    //ClearSchedule Response
    func getresponseForClearSchedule(response:AnyObject)->()
    {
        //ANLoader.hide()
        ServerService.hideProgressView()
        clearScheduleData = response as! JSON
        print(clearScheduleData)
        
        if clearScheduleData.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else
        {
            if clearScheduleData["Status"].stringValue == "1"
            {
                for i in 0..<7
                {
                    self.sTextFields[i].text = ""
                    self.tLabels[i].text = ""
                    self.eTextFields[i].text = ""
                    
                }
                
                self.totalHours = ["","","","","","",""]
                var itemsDrop:[String] = []
                for weekEndDate in 0..<self.object["AvailabilityWeekEnds"].arrayValue.count {
                    
                    if self.object["AvailabilityWeekEnds"][weekEndDate].stringValue.count>=10
                    {
                        itemsDrop.append(Constants.getFormattedDateForPersonalJob(string:self.object["AvailabilityWeekEnds"][weekEndDate].stringValue.substring(to:10)))
                    }
                }
                let index = itemsDrop.index(of:self.selectedWeekEnd)
                self.WeekEndIndex = index!
                self.selectedIndex = index!
                self.totalTimeInHours = ["0","0","0","0","0","0","0"]
                
                self.navigationController?.view.makeToast(clearScheduleData["Message"].stringValue, duration: 3.0, position: .bottom, title: "", image: nil)
            }
            else
            {
                self.navigationController?.view.makeToast(clearScheduleData["Message"].stringValue, duration: 3.0, position: .bottom, title: "", image: nil)
            }
        }
    }
    
    
    
    //MARK:- function to get date
    func getFormattedDateCosmatic(string: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd" // This formate is input formated .
        let formateDate = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "MM/dd/yyyy" // Output Formated
        return dateFormatter.string(from: formateDate)
    }
    
    @IBAction func handleNavgationBarButtonTap(_ sender: UIBarButtonItem, event: UIEvent)
    
    {
        Constants.showUp(event:event,viewController:self)
        
    }
    
    func showPicker()
    {
        
        
        let min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
        let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
        let picker = DateTimePicker.show(selected: Date(), minimumDate: min, maximumDate: max)
        
        if object2["stepping"].intValue == 30
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.thirty
        }
        else if object2["stepping"].intValue == 15
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.fifteen
        }
        else if object2["stepping"].intValue == 10
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.ten
        }
        else if object2["stepping"].intValue == 5
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.five
        }
        else if object2["stepping"].intValue == 6
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.six
        }
        else if object2["stepping"].intValue == 1
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
        picker.locale = Locale.preferredLocale() //Locale(identifier: "en_GB")
        
        picker.todayButtonTitle = ""
        picker.is12HourFormat = true
        picker.dateFormat = "hh:mmaa" //TODO:- Removed Space before "hh:mm aa"
        picker.isTimePickerOnly = true
        //picker.isDatePickerOnly = true
        picker.includeMonth = false // if true the month shows at top
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.locale = Locale.preferredLocale()
            formatter.dateFormat = "hh:mmaa" //TODO:- Removed Space before "hh:mm aa"
            self.activeTextField?.text = formatter.string(from: date)
            if self.activeTextField?.tag==1||self.activeTextField?.tag==8
            {
                if (self.mStextField.text!.count>0)&&(self.mEtextField.text?.count)!>0
                {
                    self.getHours(start:self.mStextField.text!, end:self.mEtextField.text!, i: 0,space:false)
                }
            }
            else if self.activeTextField?.tag==2||self.activeTextField?.tag==9
            {
                if (self.tStextField.text!.count>0)&&(self.tEtextField.text?.count)!>0
                {
                    self.getHours(start: self.tStextField.text!, end:self.tEtextField.text!, i: 1,space:false)
                }
            }
            else if self.activeTextField?.tag==3||self.activeTextField?.tag==10
            {
                if (self.wStextField.text!.count>0)&&(self.wEtextField.text?.count)!>0
                {
                    self.getHours(start: self.wStextField.text!, end:self.wEtextField.text!, i: 2,space:false)
                }
            }
            else if self.activeTextField?.tag==4||self.activeTextField?.tag==11
            {
                if (self.thStextField.text!.count>0)&&(self.thEtextField.text?.count)!>0
                {
                    self.getHours(start:self.thStextField.text!, end:self.thEtextField.text!, i: 3,space:false)
                }
            }
            else if self.activeTextField?.tag==5||self.activeTextField?.tag==12
            {
                if (self.fStextField.text!.count>0)&&(self.fEtextField.text?.count)!>0
                {
                    self.getHours(start: self.fStextField.text!, end:self.fEtextField.text!, i: 4,space:false)
                }
            }
            else if self.activeTextField?.tag==6||self.activeTextField?.tag==13
            {
                if (self.sStextField.text!.count>0)&&(self.self.sEtextField.text?.count)!>0
                {
                    self.getHours(start: self.sStextField.text!, end:self.sEtextField.text!, i: 5,space:false)
                }
            }
            else if self.activeTextField?.tag==7||self.activeTextField?.tag==14
            {
                if (self.suStextField.text!.count>0)&&(self.suEtextField.text?.count)!>0
                {
                    self.getHours(start: self.suStextField.text!, end:self.suEtextField.text!, i: 6,space:false)
                }
            }
            self.activeTextField?.endEditing(true)
            
            
            
            //self.title = formatter.string(from: date)
        }
        picker.delegate = self
        NotificationCenter.default.post(name: Notification.Name("Time"), object: nil)
    }
    
    @IBAction func infoAction(_ sender: UIButton) {
        infoView.frame = CGRect(x:10,y:80, width:self.view.bounds.width-20, height:360)
        blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.contentView.addSubview(infoView)
        view.addSubview(blurEffectView)
    }
    
    @IBAction func okAction(_ sender: UIButton) {
        blurEffectView.removeFromSuperview()
    }
    
    //imagePicker
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
            ANLoader.showLoading("", disableUI:true)
            let selectedImage:UIImage = image.resize(withWidth:200)!
            let base64String = selectedImage.toBase64()
            let params = ["CandId":UserDefaults.standard.object(forKey:"cID") as! String,"ImageFile":base64String!] as [String:Any]
            ServerService.AccountInsertProfilePicture(self, params: params, method: "POST", accessToken:Constants.Token,acces:true, callBack:self.getresponseForPic(response:))
        })
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    //aftergettingResponseFrom the server
    func getresponseForPic(response:AnyObject)->()
    {
        ANLoader.hide()
        print(response)
        picUploadData = response as! JSON
        if picUploadData.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else
        {
            if picUploadData["MessageStatus"].intValue == 1
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
    }
    
    
    //catching the device orentation
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            infoView.frame = CGRect(x:10,y:80, width:self.view.bounds.width-20, height:360)
        case .landscapeLeft:
            text="LandscapeLeft"
            infoView.frame = CGRect(x:10,y:80, width:self.view.bounds.width-20, height:360)
        case .landscapeRight:
            text="LandscapeRight"
            infoView.frame = CGRect(x:10,y:80, width:self.view.bounds.width-20, height:360)
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
    }
    
    //MARK:- CheckingFormsToDisplay
    func checkFormsToDisplay(_ formName: String){
        
        if formName.count > 0 {
            let tlabel = UILabel()
            tlabel.text = object["Title"].stringValue
            tlabel.textColor = UIColor.white
            tlabel.font = UIFont.systemFont(ofSize:17)
            tlabel.backgroundColor = UIColor.clear
            tlabel.adjustsFontSizeToFitWidth = true
            tlabel.textAlignment = .left
            tlabel.numberOfLines = 0
            tlabel.minimumScaleFactor = 0.5
            self.navigationItem.titleView = tlabel
            if object["LynkType"].intValue > 0 && object["File"].stringValue.count > 5{
                Constants.LinkUrl = object["File"].stringValue
                Constants.LinkText = object["FormName"].stringValue
                Constants.iSFormOkRequired = false
                Constants.ShowStandAlone = true
                self.pushToStandAlone()
            }
            else {
                if object["FormName"].stringValue == "ACA1095CConsent"
                {
                    let formView = Bundle.main.loadNibNamed("ACAConsent", owner: nil, options: nil)![0] as! ACAConsent
                    formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height)
                    formView.payStubDetails = object
                    formView.loadForm()
                    formView.setUp()
                    formView.acaDelegate = self
                    self.view.addSubview(formView)
                    self.view.bringSubview(toFront:formView)
                }
                else if object["FormName"].stringValue == "ACA1095CConsent"
                {
                    
                    let formView = Bundle.main.loadNibNamed("ACAElectronicDelivery", owner: nil, options: nil)![0] as! ACAElectronicDelivery
                    formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height)
                    formView.payStubDetails = object
                    formView.loadForm()
                    formView.acaDelegate = self
                    self.view.addSubview(formView)
                    self.view.bringSubview(toFront:formView)
                    
                }
                else if object["FormName"].stringValue == "PayCardChangeAcknowledgementForm"
                {
                    
                    let formView = Bundle.main.loadNibNamed("PayCard", owner: nil, options: nil)![0] as! PayCrad
                    formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height)
                    formView.payStubDetails = object
                    formView.payCardDelegate = self
                    self.view.addSubview(formView)
                    self.view.bringSubview(toFront:formView)
                    
                }
                else if object["FormName"].stringValue == "WageRateForm"
                {
                    let formView = Bundle.main.loadNibNamed("WageRate", owner: nil, options: nil)![0] as! WageRate
                    formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height)
                    formView.object = object
                    formView.setUp()
                    formView.wagRateDelegate = self
                    self.view.addSubview(formView)
                    self.view.bringSubview(toFront:formView)
                }
                else if object["FormName"].stringValue == "CaliforniaWageRateForm"
                {
                    let formView = Bundle.main.loadNibNamed("CAWageRate", owner: nil, options: nil)![0] as! CAWageRate
                    formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height)
                    formView.object = object
                    formView.setUp()
                    formView.caWageRateDelegate = self
                    self.view.addSubview(formView)
                    self.view.bringSubview(toFront:formView)
                }
                else if object["FormName"].stringValue == Constants.A1Form {
                    let VC = A1FormController(nibName: "A1FormController", bundle: nil)
                    VC.object = object
                    let navi = BaseNaviViewController(rootViewController:VC)
                    navi.navigationBar.tintColor = .white
                    navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                    sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"A1FormController")
                }
                else if object["FormName"].stringValue == Constants.A2Form {
                    let VC = A2FormController(nibName: "A2FormController", bundle: nil)
                    VC.object = object
                    let navi = BaseNaviViewController(rootViewController:VC)
                    navi.navigationBar.tintColor = .white
                    navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                    sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"A2FormController")
                }
                else if object["FormName"].stringValue == Constants.SCRConsent {
                    let VC = SCRConsent(nibName: "SCRConsent", bundle: nil)
                    VC.object = JSON(["FormName":Constants.SCRName])
                    VC.fromSideMenu = false
                    let navi = BaseNaviViewController(rootViewController:VC)
                    navi.navigationBar.tintColor = .white
                    navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                    sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"SCRConsent")
                    
                }
                else if object["FormName"].stringValue == Constants.SCRForm{
                    let VC = SCRConsentInfoController(nibName: "SCRConsentInfoController", bundle: nil)
                    VC.object = JSON(["FormName":Constants.SCRName])
                    VC.fromSideMenu = false
                    let navi = BaseNaviViewController(rootViewController:VC)
                    navi.navigationBar.tintColor = .white
                    navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                    sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"SCRConsentInfoController")
                }
                else
                {
                    let formView = Bundle.main.loadNibNamed("FormView", owner: nil, options: nil)![0] as! FormView
                    formView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height)
                    formView.formsObject = object
                    formView.loadForm()
                    formView.formDelegate = self
                    self.view.addSubview(formView)
                    self.view.bringSubview(toFront:formView)
                }
            }
        }
        else {
            if (object["Message"].stringValue.count>0){
                ServerService.ShowAlertMessage(ErrorMessage:object["Message"].stringValue, title:"", view:self)
            }
        }
    }
    func changeNavigationTitle(_ titleStr: String) {
        let tlabel = UILabel()
        tlabel.text = titleStr
        tlabel.textColor = UIColor.white
        tlabel.font = UIFont.systemFont(ofSize:17)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.textAlignment = .left
        tlabel.numberOfLines = 0
        tlabel.minimumScaleFactor = 0.5
        self.navigationItem.titleView = tlabel
    }
    
}
extension EnterAvailabilityViewController:DateTimePickerDelegate
{
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        
        print(picker.selectedDateString)
    }
}

extension EnterAvailabilityViewController:formDelegate
{
    func formStatus(success: Bool, skipStatus: Int) {
        print("success")
        ASHTSkipStatus = skipStatus
        
        getAvailabilityFromServer()
    }
    
}
extension EnterAvailabilityViewController:aCAConsent
{
    func acaStatus(success: Bool) {
        print("success")
        ASHTSkipStatus = 0
        getAvailabilityFromServer()
    }
    
}

extension EnterAvailabilityViewController:acaConsentDelivery
{
    func acaElectronicDeliveryStatus(success: Bool) {
        print("success")
        ASHTSkipStatus = 0
        getAvailabilityFromServer()
    }
    
}

extension EnterAvailabilityViewController:payCardDelegate
{
    func payCardStatus(success: Bool) {
        print("success")
        ASHTSkipStatus = 0
        getAvailabilityFromServer()
    }
    
}

extension EnterAvailabilityViewController:wageRateDelegate
{
    func wageRateStatus(success: Bool) {
        print("success")
        ASHTSkipStatus = 0
        getAvailabilityFromServer()
    }
    
    
}
extension EnterAvailabilityViewController:caWageRateDelegate
{
    func caWageRateStatus(success: Bool) {
        print("success")
        ASHTSkipStatus = 0
        getAvailabilityFromServer()
    }
    
    
}
