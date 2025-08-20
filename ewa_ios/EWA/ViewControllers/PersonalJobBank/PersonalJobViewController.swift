//
//  PersonalJobViewController.swift
//  EWA
//
//  Created by NFC Solutions on 07/11/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import DropDown
import ANLoader
import CropViewController
import FSCalendar


class PersonalJobViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate {
    
    @IBOutlet var userButton: UIBarButtonItem!
    @IBOutlet var mesageButton: UIBarButtonItem!
    @IBOutlet var personalJobTableView: UITableView!
    var object: JSON = JSON.null
    var acceptReject:JSON = JSON.null
    var popUpReasons:JSON = JSON.null
    var picUploadData:JSON = JSON.null
    @IBOutlet var searchButton: UIBarButtonItem!
    var theme: SambagTheme = .light
    var activeTextField: UITextField?
    var formDate = String()
    var toDate = String()
    var orderId = String()
    var detailStatus = String()
    var reasonId = String()
    var source = "13"
    var rejectSource = "5"
    
    @IBOutlet var radioButton: KGRadioButton!
    
    @IBOutlet var toTextField: UITextField!
    @IBOutlet var fromTextField: UITextField!
    @IBOutlet var noJobsLabel: UILabel!
    
    @IBOutlet var cancelHeaderView: UIView!
    @IBOutlet var cancelView: UIView!
    @IBOutlet var declineButton: PKButton!
    var blurEffect = UIBlurEffect()
    var blurEffectView = UIVisualEffectView()
    let chooseArticleDropDown = DropDown()
    var isReAccept = Bool()
    lazy var dropDowns: [DropDown] = {
        return [
            self.chooseArticleDropDown
        ]
    }()
    var delete = Bool()
    var waitList = Bool()
    @IBOutlet var reasonHeight: NSLayoutConstraint!
    @IBOutlet var otherReaspnHeight: NSLayoutConstraint!
    @IBOutlet var otherReasonLabel: UILabel!
    @IBOutlet var otherReasonTextView: UITextView!
    lazy var searchBar = UISearchBar(frame: CGRect.zero)
    var isFiltering = Bool()
    var FilertedArray = [Dictionary<String,Any>]()
    var rates = [String]()
    var jobs = [Job]()
    
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    
    @IBOutlet weak var calenderView: UIView!
    @IBOutlet weak var calenderViewHeightConstarin: NSLayoutConstraint!
    @IBOutlet weak var calender: FSCalendar!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.updateNavigationBarColor()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        
        //getting Today's Date
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = "MM/dd/yyyy"
        var result = formatter.string(from: date)
        print(result)
        
        // showing dates in the textfield as default dates
        
        let nextMonth = Calendar.current.date(byAdding: .month, value:6, to: Date())
        var sixMonth = formatter.string(from: nextMonth!)
        
        //if coming from push notification showing the job in selected date
        if Constants.PushData.count>0
        {
            source = "15"
            rejectSource = "15"
            if Constants.PushData["startDate"].stringValue.count>0
            {
                result = Constants.PushData["startDate"].stringValue
                sixMonth = Constants.PushData["endDate"].stringValue
            }
        }
        //if coming from push notification list showing the job in selected date
        if Constants.PushDataFromNotification.count>0
        {
            source = "15"
            rejectSource = "15"
            result = Constants.PushDataFromNotification[0]
            sixMonth = Constants.PushDataFromNotification[1]
        }
        
        
        //clearing the data
        Constants.PushData = JSON.null
        Constants.PushDataFromNotification.removeAll()
        
        
        fromTextField.text = result
        toTextField.text = sixMonth
        
        
        
        // getting the jobs
        if ConnectionCheck.isConnectedToNetwork()
        {
            //ANLoader.showLoading("", disableUI:false)
            ServerService.showActivityIndicatory(uiView:self.view)
            let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"StartDate":result,"EndDate":sixMonth]
            print(params)
            ServerService.getpersonalJobBank(self, params: params, method: "POST", accessToken:Constants.Token, acces:true, callBack:getresponse(response:))
        }
        else
        {
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
        
        
        
        // UI setup for reason textview
        otherReasonTextView.textColor = UIColor.lightGray
        otherReasonTextView.layer.borderWidth = 0.5
        otherReasonTextView.layer.borderColor = UIColor.lightGray.cgColor
        declineButton.titleLabel?.textAlignment = .left
        
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        
        
        //calender Initialization
        self.calender.delegate = self
        self.calender.scope = .month
        // For UITest
        self.calenderView.accessibilityIdentifier = "calendar"
        self.calender.appearance.weekdayTextColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        self.calender.appearance.headerTitleColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        self.calender.appearance.selectionColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        self.calender.appearance.todayColor =  UIColor(hexString:"#c4c0cb")
        
        
        // hiding calenderView initially
        calenderViewHeightConstarin.constant = 0
        calenderView.isHidden = true
        headerViewHeight.constant = 150
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    
    //aftergettingResponseFrom the server
    func getresponse(response:AnyObject)->()
    {
        ANLoader.hide()
        ServerService.hideProgressView()
        object = response as! JSON
        noJobsLabel.text = object["Message"].stringValue
        print(object)
        jobs.removeAll()
        if object.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if object["ApiStatus"] == "Success"
        {
            if object["AllJobs"].arrayValue.count>0
            {
                
                for rate in 0..<object["AllJobs"].arrayValue.count
                {
                    let job = Job.init(title:object["AllJobs"][rate]["JobTitle"].stringValue,clientName: object["AllJobs"][rate]["ClientName"].stringValue, address:object["AllJobs"][rate]["Address"].stringValue+","+object["AllJobs"][rate]["City"].stringValue+","+object["AllJobs"][rate]["State"].stringValue, rate:"$"+object["AllJobs"][rate]["Rate"].stringValue, color: object["AllJobs"][rate]["ColorCode"].stringValue, orderId: object["AllJobs"][rate]["OrderId"].stringValue,date: Constants.getFormattedDate(string:object["AllJobs"][rate]["StartDate"].stringValue)+" - "+Constants.getFormattedDate(string:object["AllJobs"][rate]["EndDate"].stringValue), detailStatus: object["AllJobs"][rate]["DetailsStatus"].stringValue,sort:object["AllJobs"][rate]["Sort"].intValue,declineDate:Constants.getFormattedDate(string:object["AllJobs"][rate]["DeclineDateNew"].stringValue), scheduleTime: object["AllJobs"][rate]["HCScheduleTime"].stringValue)
                    jobs.append(job)
                    rates.append(object["AllJobs"].arrayValue[rate]["Rate"].stringValue)
                }
                
                noJobsLabel.isHidden = true
                noJobsLabel.backgroundColor = .clear
            }
            else
            {
                noJobsLabel.isHidden = false
                noJobsLabel.backgroundColor = UIColor(hexString:"#f2dede")
                noJobsLabel.text = "No Records Found"
            }
            personalJobTableView.isScrollEnabled = true
            DispatchQueue.main.async {
                self.personalJobTableView.reloadData()
            }
        }
        else
        {
            noJobsLabel.isHidden = false
            noJobsLabel.backgroundColor = UIColor(hexString:"#f2dede")
            personalJobTableView.isScrollEnabled = false
            DispatchQueue.main.async {
                self.personalJobTableView.reloadData()
            }
            
        }
    }
    
    @objc
    func tapFunction(_ sender:UITapGestureRecognizer) {
        print("tap working")
        
        let orderriid = jobs[sender.view!.tag].orderId!
        self.pushToSchedulePage(orderriid)
    }
    
    func pushToSchedulePage(_ orderID: String){
        //orderId = jobs[indexPath.section].orderId!
        let dvc = self.storyboard?.instantiateVC(withIdentifier: "VaryOrderScheduleViewController") as! VaryOrderScheduleViewController
        dvc.from = "PJB"
        dvc.orderId = orderID
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    
    //MARK:- TableView DataSource and Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering
        {
            return FilertedArray.count
        }
        else
        {
            return object["AllJobs"].arrayValue.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    var heightAtIndexPath = [IndexPath: CGFloat]()
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightAtIndexPath[indexPath] ?? UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.heightAtIndexPath[indexPath] = cell.frame.size.height
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jCell", for: indexPath) as! JobsTableViewCell
        // let cell = tableView.dequeueReusableCell(withIdentifier: "jCell") as! JobsTableViewCell
        cell.selectionStyle = .none
        
        if object["AllJobs"].arrayValue.count>0
        {
            
            let sort = jobs[indexPath.section].sort
            
            
            cell.titleLabel.text = jobs[indexPath.section].title
            cell.clientNameLabel.text =  jobs[indexPath.section].clientName
            cell.addressLabel.text = jobs[indexPath.section].address
            cell.dateLabel.text =  jobs[indexPath.section].date
            cell.payLabel.text = jobs[indexPath.section].rate
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction(_ :)))
            
            cell.scheduleLabel.tag = indexPath.section
            let textt = self.jobs[indexPath.section].scheduleTime?.replacingOccurrences(of: "</br>", with: "\n")
            if  textt!.removeHtmlFromString(inPutString: textt!).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count > 0{
                if (jobs[indexPath.section].scheduleTime?.htmlToString.contains("Click here to view"))!
                    
                {
                    DispatchQueue.main.async {
                        cell.scheduleLabel.textColor = UIColor(hexString:"#337ab7")
                        cell.scheduleLabel.text = "Click here to view FULL schedule"
                        cell.scheduleLabel.isUserInteractionEnabled = true
                        cell.scheduleLabel.addGestureRecognizer(tap)
                        cell.scheduleLabel.underline()
                    }
                    
                    
                }
                else {
                    
                    DispatchQueue.main.async {
                        cell.scheduleLabel.textColor = UIColor(hexString:"#555555")
                        
                        cell.scheduleLabel.text = textt!.removeHtmlFromString(inPutString: textt!).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        cell.scheduleLabel.removeUnderLine()
                        cell.scheduleLabel.isUserInteractionEnabled = false
                    }
                }
                
                let heightForSchedule = Constants.calculateHeightWithFont(inString:textt!.removeHtmlFromString(inPutString: textt!).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),width:self.view.bounds.size.width-40,font:UIFont.systemFont(ofSize:14))
                cell.scheduleImageView.isHidden = false
                cell.scheduleTimeConstraint.constant = heightForSchedule+10
            }
            else {
                cell.scheduleImageView.isHidden = true
                cell.scheduleTimeConstraint.constant = 0
            }
            
            let heightForTitle = Constants.calculateHeightWithFont(inString:jobs[indexPath.section].title!,width:self.view.bounds.size.width-40,font:UIFont.systemFont(ofSize:18))
            cell.titleConstrain.constant = heightForTitle+10
            let heightForName = Constants.calculateHeightWithFont(inString:jobs[indexPath.section].clientName!,width:self.view.bounds.size.width-40,font:UIFont.systemFont(ofSize:14))
            cell.companyNameConstrain.constant = heightForName+10
            let heightForAddress = Constants.calculateHeightWithFont(inString:jobs[indexPath.section].address!,width:self.view.bounds.size.width-40,font:UIFont.systemFont(ofSize:14))
            cell.locationConstrain.constant = heightForAddress+10
            
            
            
            
            if sort == 1{
                cell.acceptButton.isHidden = false
                cell.declineButton.isHidden = false
                cell.acceptButton.setTitle("Accept", for:.normal)
                cell.acceptButton.backgroundColor = UIColor(hexString:"#449D44")
                cell.acceptButtonTrailingConstraint.constant = 122
                cell.statusLabel.text = "Available Job"
            }else if sort == 4{
                cell.acceptButton.isHidden = false
                cell.declineButton.isHidden = true
                cell.acceptButton.setTitle("Accept", for:.normal)
                cell.acceptButton.backgroundColor = UIColor(hexString:"#449D44")
                cell.acceptButtonTrailingConstraint.constant = 22
                cell.statusLabel.text = "Job Refused: "+jobs[indexPath.section].declineDate!
                //                cell.statusLabel.text = "Job Refused:"+Constants.getFormattedDateForPersonalJob(string: jobs[indexPath.section].declineDate!)
            }else if sort == 3{
                cell.acceptButton.isHidden = false
                cell.declineButton.isHidden = true
                cell.acceptButton.setTitle("Wait List", for:.normal)
                cell.acceptButton.backgroundColor = UIColor(hexString:"#50b8d9")
                cell.acceptButtonTrailingConstraint.constant = 22
                cell.statusLabel.text = "Accepted By Another Employee"
            }
            else if sort == 2{
                cell.acceptButton.isHidden = true
                cell.declineButton.isHidden = true
                cell.statusLabel.text = "Wait Listed"
            }
            
            let bgColorString =  jobs[indexPath.section].color!
            if bgColorString.count == 0{
                cell.bgView.backgroundColor = UIColor.white
                //cell.acceptButton.isHidden = true
                //cell.declineButton.isHidden = true
                cell.statusLabel.text = "Available Job"
            }else{
                
                cell.bgView.backgroundColor =  UIColor(hexString:bgColorString) as UIColor
            }
        }
        cell.declineDateLable.text = ""
        cell.acceptButton.layoutIfNeeded()
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        return cell
    }
    
    
    
    
    //UITableViewDelegate**********************
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let heightForTitle = Constants.calculateHeightWithFont(inString:jobs[indexPath.section].title!,width:self.view.bounds.size.width-40,font:UIFont.systemFont(ofSize:18))
        
        let heightForName = Constants.calculateHeightWithFont(inString:jobs[indexPath.section].clientName!,width:self.view.bounds.size.width-40,font:UIFont.systemFont(ofSize:14))
        
        let heightForAddress = Constants.calculateHeightWithFont(inString:jobs[indexPath.section].address!,width:self.view.bounds.size.width-40,font:UIFont.systemFont(ofSize:14))
        // let heightForSchedule = Constants.calculateHeightWithFont(inString:jobs[indexPath.section].scheduleTime!.htmlToString,width:self.view.bounds.size.width-40,font:UIFont.systemFont(ofSize:14))
        let textt = self.jobs[indexPath.section].scheduleTime?.replacingOccurrences(of: "</br>", with: "\n")
        let heightForSchedule = Constants.calculateHeightWithFont(inString:textt!.removeHtmlFromString(inPutString: textt!).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),width:self.view.bounds.size.width-40,font:UIFont.systemFont(ofSize:14))
        
        var final = Float()
        if textt!.removeHtmlFromString(inPutString: textt!).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count > 0{
            final = Float(heightForSchedule)
        }
        else {
            final = 0
        }
        if jobs[indexPath.section].sort == 2  //||jobs[indexPath.section].color!.count==0
        {
            return (150+heightForTitle+heightForName+heightForAddress+CGFloat(final))
        }
        else
        {
            return (180+heightForTitle+heightForName+heightForAddress+CGFloat(final))
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if isFiltering
        {
            orderId = String(format:"%@",FilertedArray[indexPath.section]["OrderId"] as! CVarArg)
            detailStatus = object["DetailsStatus"].stringValue
        }
        else
        {
            orderId = jobs[indexPath.section].orderId!
            detailStatus = jobs[indexPath.section].detailStatus!
        }
        self.performSegue(withIdentifier:"detailSegue", sender: nil)
    }
    
    //MARK:- Prepare For Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue"
        {
            let dvc = segue.destination as! PersonalJobDetailViewController
            dvc.orderId = orderId
            dvc.detailStatus = detailStatus
        }
        
    }
    
    
    // go button and action
    @IBOutlet var goAction: UIButton!
    
    @IBAction func goAction(_ sender: UIButton)
    {
        
        //hiding calenderView
        calenderViewHeightConstarin.constant = 0
        calenderView.isHidden = true
        headerViewHeight.constant = 150
        if radioButton.isSelected
        {
            if ConnectionCheck.isConnectedToNetwork()
            {
                //  ANLoader.showLoading("", disableUI:false)
                ServerService.showActivityIndicatory(uiView:self.view)
                let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String ,"StartDate":fromTextField.text!,"EndDate":toTextField.text!,"JobStatus":"True"]
                ServerService.getpersonalJobBank(self, params: params, method: "POST", accessToken:Constants.Token, acces:true, callBack:getresponse(response:))
                
            }
            else
            {
                ANLoader.hide()
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            }
            
        }
        else
        {
            if ConnectionCheck.isConnectedToNetwork()
            {
                //ANLoader.showLoading("", disableUI:false)
                ServerService.showActivityIndicatory(uiView:self.view)
                let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String ,"StartDate":fromTextField.text!,"EndDate":toTextField.text!]
                print(params)
                ServerService.getpersonalJobBank(self, params: params, method: "POST", accessToken:Constants.Token, acces:true, callBack:getresponse(response:))
            }
            else
            {
                ANLoader.hide()
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            }
            
            
        }
    }
    
    
    
    //UITextField Delegate methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeTextField = textField
        textField.resignFirstResponder()
        //datePickerTapped()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from:textField.text!)
        self.calender.select(date)
        
        //showing calender View
        calenderViewHeightConstarin.constant = 250
        calenderView.isHidden = false
        headerViewHeight.constant = 410
        return false
    }
    
    
    
    //function to get date
    func getFormattedDate(string: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "MMM d, yyyy" // This formate is input formated .
        let formateDate = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "dd/MM/yyyy" // Output Formated
        return dateFormatter.string(from: formateDate)
    }
    @IBAction func handleNavgationBarButtonTap(_ sender: UIBarButtonItem, event: UIEvent)
    
    {
        Constants.showUp(event:event,viewController:self)
        
    }
    @IBAction func AvailableAction(_ sender: UIButton)
    {
        if radioButton.isSelected
        {
            radioButton.setImage(UIImage(named:"uncheck.png"), for:.normal)
            radioButton.isSelected = false
        }
        else
        {
            radioButton.setImage(UIImage(named:"checked.png"), for:.normal)
            radioButton.isSelected = true
        }
    }
    //MARK:- Accept Job Action
    @IBAction func acceptJobAction(_ sender: UIButton)
    {
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: self.personalJobTableView)
        let indexPath = self.personalJobTableView.indexPathForRow(at:buttonPosition)
        
        print(sender.titleLabel?.text! ?? "")
        
        if sender.titleLabel?.text! == "Wait List"
        {
            let confromAlert = UIAlertController(title:"Are you sure you would like to be placed on the wait list?", message:"", preferredStyle: UIAlertControllerStyle.alert)
            confromAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { (action:UIAlertAction!) in
            })
            confromAlert.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
                    ANLoader.hide()
                })
                if ConnectionCheck.isConnectedToNetwork()
                {
                    //ANLoader.showLoading("", disableUI:true)
                    ServerService.showActivityIndicatory(uiView:self.view)
                    let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"OrderId":self.jobs[indexPath!.section].orderId!,"DivisionId":UserDefaults.standard.value(forKey:"dID") as! String]
                    print(params)
                    self.waitList = true
                    self.isReAccept = false
                    ServerService.getPersonalJobBankManageWaitList(self, params: params, method: "POST", accessToken:Constants.Token, acces:true, callBack:self.getresponseForObject(response:))
                }
                else
                {
                    ANLoader.hide()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                }
            })
            self.present(confromAlert, animated: true, completion: nil)
            confromAlert.view.tintColor = UIColor(hexString: "#449D44")
        }
        else if self.jobs[indexPath!.section].sort! == 4
        {
            let confromAlert = UIAlertController(title: "Are you sure you want to Accept the job?", message:"", preferredStyle: UIAlertControllerStyle.alert)
            confromAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { (action:UIAlertAction!) in
                
                
            })
            confromAlert.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
                    ANLoader.hide()
                })
                if ConnectionCheck.isConnectedToNetwork()
                {
                    //ANLoader.showLoading("", disableUI:true)
                    ServerService.showActivityIndicatory(uiView:self.view)
                    let params:[String:Any] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"OrderId": self.jobs[indexPath!.section].orderId!,"source":self.source,"DivisionId":UserDefaults.standard.value(forKey:"dID") as! String]
                    self.isReAccept = true
                    
                    print("re accept pjb params",params)
                    ServerService.getPersonalJobBankManageReAccept(self, params: params, method: "POST", accessToken:Constants.Token, acces:true, callBack:self.getresponseForObject(response:))
                }
                else
                {
                    ANLoader.hide()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                }
                
                
            })
            self.present(confromAlert, animated: true, completion: nil)
            confromAlert.view.tintColor = UIColor(hexString: "#449D44")
        }
        else
        {
            let confromAlert = UIAlertController(title: "Are you sure you want to Accept the job?", message:"", preferredStyle: UIAlertControllerStyle.alert)
            confromAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { (action:UIAlertAction!) in
                
                
            })
            confromAlert.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
                    ANLoader.hide()
                })
                if ConnectionCheck.isConnectedToNetwork()
                {
                    //ANLoader.showLoading("", disableUI:true)
                    ServerService.showActivityIndicatory(uiView:self.view)
                    let params:[String:Any] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"OrderId": self.jobs[indexPath!.section].orderId!,"source":self.source,"DivisionId":UserDefaults.standard.value(forKey:"dID") as! String]
                    print("accept job params are ",params)
                    self.isReAccept = false
                    ServerService.getAcceptJob(self, params: params, method: "POST", accessToken:Constants.Token, acces:true, callBack:self.getresponseForObject(response:))
                }
                else
                {
                    ANLoader.hide()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                }
                
                
            })
            self.present(confromAlert, animated: true, completion: nil)
            confromAlert.view.tintColor = UIColor(hexString: "#449D44")
        }
    }
    //MARK:- Decline Job Action
    @IBAction func declineJobAction(_ sender: UIButton) {
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: self.personalJobTableView)
        let indexPath = self.personalJobTableView.indexPathForRow(at:buttonPosition)
        DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
            ANLoader.hide()
        })
        if ConnectionCheck.isConnectedToNetwork()
        {
            //ANLoader.showLoading("", disableUI:true)
            ServerService.showActivityIndicatory(uiView:self.view)
            let params:[String:Any] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"OrderId": self.jobs[indexPath!.section].orderId!,"source":rejectSource]
            self.delete = true
            self.orderId = self.jobs[indexPath!.section].orderId!
            self.isReAccept = false
            ServerService.getRejectJob(self, params: params, method: "POST", accessToken:Constants.Token, acces:true, callBack:self.getresponseForObject(response:))
        }
        else
        {
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
        
        
        
    }
    
    func setupChooseArticleDropDown(anchorView:UIButton,items:[String]) {
        chooseArticleDropDown.anchorView = anchorView
        chooseArticleDropDown.bottomOffset = CGPoint(x: 0, y: anchorView.bounds.height)
        chooseArticleDropDown.backgroundColor = .white
        chooseArticleDropDown.dataSource =  items
        chooseArticleDropDown.selectionAction = { [unowned self] (index,item) in
            print(self.index)
            print(item)
            self.declineButton.setTitle(item, for:.normal)
            self.reasonId = self.acceptReject["Reasons"][index]["ReasonID"].stringValue
            if item == "Other"
            {
                self.cancelView.frame = CGRect(x:10,y:self.view.bounds.height/2-150,width: self.view.bounds.width-20,height:260)
                self.otherReaspnHeight.constant = 50
                self.reasonHeight.constant = 20
            }
            else
            {
                
                self.cancelView.frame = CGRect(x:10,y:self.view.bounds.height/2-150,width: self.view.bounds.width-20,height:200)
                self.otherReaspnHeight.constant = 0
                self.reasonHeight.constant = 0
            }
            
        }
    }
    
    @IBAction func cancelSearch(_ sender: Any)
    {
        radioButton.setImage(UIImage(named:"uncheck.png"), for:.normal)
        radioButton.isSelected = false
        //getting Today's Date
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = "MM/dd/yyyy"
        let result = formatter.string(from: date)
        print(result)
        
        let nextMonth = Calendar.current.date(byAdding: .month, value:6, to: Date())
        let sixMonth = formatter.string(from: nextMonth!)
        
        fromTextField.text = result
        toTextField.text = sixMonth
        
        //hiding calenderView
        calenderViewHeightConstarin.constant = 0
        calenderView.isHidden = true
        headerViewHeight.constant = 150
        
        
        if ConnectionCheck.isConnectedToNetwork()
        {
            //ANLoader.showLoading("", disableUI:true)
            ServerService.showActivityIndicatory(uiView:self.view)
            let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"StartDate":result,"EndDate":sixMonth]
            ServerService.getpersonalJobBank(self, params: params, method: "POST", accessToken:Constants.Token, acces:true, callBack:getresponse(response:))
        }
        else
        {
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
        
    }
    
    @IBAction func dismissAction(_ sender: UIButton)
    {
        delete = false
        blurEffectView.removeFromSuperview()
    }
    
    @IBAction func declineDropDownAction(_ sender: PKButton)
    {
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        setupChooseArticleDropDown(anchorView:sender,items:acceptReject["Reasons"].arrayValue.map({$0["ReasonDescription"].stringValue}))
        chooseArticleDropDown.show()
    }
    @IBAction func manageDeclineCancel(_ sender: Any)
    {
        delete = false
        blurEffectView.removeFromSuperview()
    }
    //MARK:- ManageDeclineAccept
    @IBAction func manageDeclineAccept(_ sender: UIButton)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
            ANLoader.hide()
        })
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:self.view)
            
            if  self.reasonId.count == 0 {
                
                for index in 0..<popUpReasons["Reasons"].arrayValue.count
                {
                    
                    let reasonstr = popUpReasons["Reasons"][index]["ReasonDescription"].stringValue
                    
                    if declineButton.currentTitle == reasonstr
                    {
                        self.reasonId = popUpReasons["Reasons"][index]["ReasonID"].stringValue
                        print(self.reasonId)
                    }
                }
                
                //  self.reasonId = popUpReasons["Reasons"][0]["ReasonID"].stringValue
            }
            
            let params:[String:Any] = ["OrderId":self.orderId,"CandId":UserDefaults.standard.object(forKey: "cID") as! String,"ReasonId":self.reasonId,"OtherReason":otherReasonTextView.text!,"source":rejectSource]
            print(params)
            self.delete = true
            ServerService.getPersonalJobBankManageDeclineJob(self, params: params, method: "POST", accessToken:Constants.Token, acces:true, callBack:getresponseForPopupdeclineSubmit(response:))
        }
        else
        {
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
        
    }
    
    
    //UITextView Delegate methods
    
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
    
    //MARK:- Decline Reason Submit Action
    func getresponseForPopupdeclineSubmit(response:AnyObject)->()
    {
        ANLoader.hide()
        ServerService.hideProgressView()
        acceptReject = response as! JSON
        
        print(acceptReject)
        if acceptReject.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if acceptReject["Status"].intValue == 0
        {
            let confromAlert = UIAlertController(title:acceptReject["Message"].stringValue, message:"", preferredStyle: UIAlertControllerStyle.alert)
            confromAlert.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                self.refershData()
                self.blurEffectView.removeFromSuperview()
            })
            self.present(confromAlert, animated: true, completion: nil)
            confromAlert.view.tintColor = UIColor(hexString: "#449D44")
            self.delete = false
            
        }
        else
        {
            
        }
        
    }
    
    
    //aftergettingResponseFrom the server
    func getresponseForObject(response:AnyObject)->()
    {
        ANLoader.hide()
        ServerService.hideProgressView()
        acceptReject = response as! JSON
        print(acceptReject)
        if acceptReject.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if acceptReject["Status"].intValue == 0
        {
            if delete == true
            {
                popUpReasons = response as! JSON
                self.refershData()
                blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
                blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.frame = view.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                cancelView.frame = CGRect(x:10,y:self.view.bounds.height/2-150,width: self.view.bounds.width-20,height:200)
                blurEffectView.contentView.addSubview(cancelView)
                declineButton.setTitle(acceptReject["Reasons"][0]["ReasonDescription"].stringValue, for:.normal)
                otherReaspnHeight.constant = 0
                reasonHeight.constant = 0
                view.addSubview(blurEffectView)
                
            }
            else if waitList
            {
                let confromAlert = UIAlertController(title:acceptReject["Message"].stringValue, message:"", preferredStyle: UIAlertControllerStyle.alert)
                confromAlert.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    self.refershData()
                })
                self.present(confromAlert, animated: true, completion: nil)
                confromAlert.view.tintColor = UIColor(hexString: "#449D44")
                waitList = false
            }
            else
            {
                self.refershData()
                self.blurEffectView.removeFromSuperview()
                if isReAccept || isReAccept == false {
                    if (acceptReject["IsSCRConsentSigned"] != nil){
                        if acceptReject["IsSCRConsentSigned"].intValue == 0
                        {
                            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "scrView") as! SCRViewController
                            navigationController?.pushViewController(VC1, animated:true)
                            
                        }
                        else
                        {
                            if acceptReject["Message"].stringValue.count > 0 {
                                ServerService.ShowAlertMessage(ErrorMessage:acceptReject["Message"].stringValue, title:"", view:self)
                            }
                            else {
                                if acceptReject["LynkType"].intValue > 0 && acceptReject["File"].stringValue.count > 5{
                                    Constants.LinkUrl = acceptReject["File"].stringValue
                                    Constants.LinkText = acceptReject["PendingFormName"].stringValue
                                    Constants.iSFormOkRequired = false
                                    Constants.ShowStandAlone = true
                                    self.pushToStandAlone()
                                }
                                else {
                                    
                                    if acceptReject["PendingFormName"].stringValue == Constants.A1Form {
                                        let VC = A1FormController(nibName: "A1FormController", bundle: nil)
                                        VC.object = JSON(["FormName":Constants.A1Form])
                                        let navi = BaseNaviViewController(rootViewController:VC)
                                        navi.navigationBar.tintColor = .white
                                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"A1FormController")
                                    }
                                    else if acceptReject["PendingFormName"].stringValue == Constants.A2Form {
                                        let VC = A2FormController(nibName: "A2FormController", bundle: nil)
                                        VC.object = JSON(["FormName":Constants.A2Form])
                                        let navi = BaseNaviViewController(rootViewController:VC)
                                        navi.navigationBar.tintColor = .white
                                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"A2FormController")
                                    }
                                    else if acceptReject["PendingFormName"].stringValue == Constants.SCRConsent {
                                        let VC = SCRConsent(nibName: "SCRConsent", bundle: nil)
                                        VC.object = JSON(["FormName":Constants.SCRName])
                                        VC.fromSideMenu = false
                                        let navi = BaseNaviViewController(rootViewController:VC)
                                        navi.navigationBar.tintColor = .white
                                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"SCRConsent")
                                        
                                    }
                                    else if acceptReject["PendingFormName"].stringValue == Constants.SCRForm{
                                        let VC = SCRConsentInfoController(nibName: "SCRConsentInfoController", bundle: nil)
                                        VC.object = JSON(["FormName":Constants.SCRName])
                                        VC.fromSideMenu = false
                                        let navi = BaseNaviViewController(rootViewController:VC)
                                        navi.navigationBar.tintColor = .white
                                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"SCRConsentInfoController")
                                    }
                                }
                            }
                            
                        }
                    }
                }
                else{
                    ServerService.ShowAlertMessage(ErrorMessage:acceptReject["Message"].stringValue, title:"", view:self)
                }
            }
            
        }
        else
        {
            
        }
        
    }
    
    func refershData()
    {
        radioButton.setImage(UIImage(named:"uncheck.png"), for:.normal)
        radioButton.isSelected = false
        //getting Today's Date
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = "MM/dd/yyyy"
        let result = formatter.string(from: date)
        print(result)
        
        let nextMonth = Calendar.current.date(byAdding: .month, value:6, to: Date())
        let sixMonth = formatter.string(from: nextMonth!)
        
        fromTextField.text = result
        toTextField.text = sixMonth
        ServerService.showActivityIndicatory(uiView:self.view)
        let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"StartDate":result,"EndDate":sixMonth]
        ServerService.getpersonalJobBank(self, params: params, method: "POST", accessToken:Constants.Token, acces:true, callBack:getresponse(response:))
    }
    
    
    // not in use
    @IBAction func searchAction(_ sender: UIBarButtonItem)
    {
        self.navigationItem.rightBarButtonItems = nil
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
    }
    
    //datePicker
    func datePickerTapped() {
        
        var dateComponents = DateComponents()
        dateComponents.month = 1000
        let twelveMonth = Calendar.current.date(byAdding:dateComponents, to: Date())
        
        
        
        let datePicker = DatePickerDialog(textColor: .black,
                                          buttonColor: UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String),
                                          font: UIFont.boldSystemFont(ofSize: 17),
                                          showCancelButton: true)
        datePicker.show("",
                        doneButtonTitle: "Done",
                        cancelButtonTitle: "Cancel",
                        minimumDate: Calendar.current.date(byAdding: .month, value:-1000, to:Date()),
                        maximumDate: twelveMonth,
                        datePickerMode: .date) { (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.locale = Locale.preferredLocale()
                formatter.dateFormat = "MM/dd/yyyy"
                if self.activeTextField?.tag == 1
                {
                    self.fromTextField.text = formatter.string(from: dt)
                    self.formDate = formatter.string(from: dt)
                    
                }
                else
                {
                    self.toTextField.text = formatter.string(from: dt)
                    self.toDate = formatter.string(from: dt)
                }
            }
        }
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
                cropController.modalPresentationStyle = .fullScreen;
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
    
    
    
}


// not in use
extension PersonalJobViewController: SambagDatePickerViewControllerDelegate {
    
    func sambagDatePickerDidSet(_ viewController: SambagDatePickerViewController, result: SambagDatePickerResult)
    {   print(result)
        if activeTextField?.tag == 1
        {
            fromTextField.text = self.getFormattedDate(string:String(describing: result))
            formDate = self.getFormattedDate(string:String(describing: result))
            
        }
        else
        {
            toTextField.text = self.getFormattedDate(string:String(describing: result))
            toDate = self.getFormattedDate(string:String(describing: result))
        }
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func sambagDatePickerDidCancel(_ viewController: SambagDatePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

// not in use
extension PersonalJobViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
        searchBar.text = nil
        searchBar.resignFirstResponder()
        //        navigationItem.titleView = nil
        //        navigationItem.title =  "Personal Job Bank"
        //        self.navigationItem.rightBarButtonItems = [userButton,mesageButton,searchButton]
        print("## search btn clicked : \(searchBar.text ?? "")")
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isFiltering = false
        }
        else
        {
            
            let allJobs = object["AllJobs"].arrayObject! as NSArray
            if allJobs.count>0
            {
                var titles = [Dictionary<String, Any>]()
                var startDate = [Dictionary<String, Any>]()
                var endDate = [Dictionary<String, Any>]()
                
                
                var searchPredicate = NSPredicate()
                searchPredicate = NSPredicate(format: "JobTitle CONTAINS[C] %@ OR ClientName CONTAINS[C] %@ OR Address CONTAINS[C] %@ OR City CONTAINS[C] %@ OR State CONTAINS[C] %@ OR Rate == \(searchText)",searchText,searchText,searchText,searchText,searchText)
                titles = (allJobs as NSArray).filtered(using:searchPredicate) as! [Dictionary<String, Any>]
                FilertedArray = titles
                
                if titles.count == 0
                {
                    searchPredicate = NSPredicate(format: "StartDate CONTAINS[C] %@",Constants.getFormattedDateForSearch(string:String(format:searchText)))
                    startDate = (allJobs as NSArray).filtered(using:searchPredicate) as! [Dictionary<String, Any>]
                    FilertedArray = (allJobs as NSArray).filtered(using:searchPredicate) as! [Dictionary<String, Any>]
                }
                if startDate.count == 0 && titles.count == 0
                {
                    searchPredicate = NSPredicate(format: "EndDate CONTAINS[C] %@",Constants.getFormattedDateForSearch(string:String(format:searchText)))
                    endDate = (allJobs as NSArray).filtered(using:searchPredicate) as! [Dictionary<String, Any>]
                    FilertedArray = endDate
                }
                print ("array = \(FilertedArray.count)")
                isFiltering = true
            }
        }
        if FilertedArray.count == 0
        {
            noJobsLabel.isHidden = false
            noJobsLabel.text = "No matching records found"
            noJobsLabel.textColor = .black
            noJobsLabel.backgroundColor = .clear
        }
        else
        {
            noJobsLabel.isHidden = true
            noJobsLabel.backgroundColor = .clear
        }
        
        DispatchQueue.main.async {
            self.personalJobTableView.reloadData()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text = nil
        navigationItem.titleView = nil
        navigationItem.title =  "Personal Job Bank"
        self.navigationItem.rightBarButtonItems = [userButton,mesageButton,searchButton]
        isFiltering = false
        DispatchQueue.main.async {
            self.personalJobTableView.reloadData()
        }
    }
}

//FSCalender view delegate and dataSource methods in extension
extension PersonalJobViewController:FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance
{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = "MM/dd/yyyy"
        if self.activeTextField?.tag == 1
        {
            self.fromTextField.text = formatter.string(from:date)
            self.formDate = formatter.string(from: date)
        }
        else
        {
            self.toTextField.text = formatter.string(from: date)
            self.toDate = formatter.string(from:date)
        }
        calenderViewHeightConstarin.constant = 0
        calenderView.isHidden = true
        headerViewHeight.constant = 150
    }
    
    
}
