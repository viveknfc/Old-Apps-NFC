//
//  PayStubsViewController.swift
//  EWA
//
//  Created by NFC India on 24/09/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import FSCalendar


class PayStubsViewController: BaseViewController {
    
    @IBOutlet weak var fromTextField: BorderPaddingTextField!
    @IBOutlet weak var toTextField: BorderPaddingTextField!
    @IBOutlet weak var viewYTBButton: UIButton!
    @IBOutlet weak var payStubsTableView: UITableView!
    
    let formatter = DateFormatter()
    var viewYTD = Bool()
    let date = Date()
    var payStubsObject:JSON = JSON.null
    var payStubs = [PayStub]()
    var totals = Total.init(totalNetWages:0.00, totalGrossWages: 0.00, totalGrossYTD: 0.00)
    var activeTextField: UITextField?
    
    @IBOutlet weak var calenderView: FSCalendar!
    @IBOutlet weak var calenderHeight: NSLayoutConstraint!
    @IBOutlet weak var viewConstant: NSLayoutConstraint!
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
    
    
    
    @IBOutlet weak var cView: UIView! // view on which calender is placed
    @IBOutlet weak var messageButton: UIBarButtonItem!
    @IBOutlet weak var userButton: UIBarButtonItem!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateNavigationBarColor()
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        self.title = "Pay Stub List"
        
        formatter.dateFormat = "MM/dd/yyyy"
        
        //getting  month date
        let weekEnd = Calendar.current.date(byAdding: .day, value: 1, to: date.endOfWeek(weekday: 1))
        print(weekEnd!)
        let thisMonth = formatter.string(from:weekEnd!)
        print(thisMonth)
        toTextField.text = thisMonth
        
        //three months ago date
        let thirdMonth = Calendar.current.date(byAdding: .month, value:-3, to: weekEnd!)
        print(thirdMonth!)
        let thirdMonthDate = formatter.string(from:thirdMonth!)
        print(thirdMonthDate)
        fromTextField.text = thirdMonthDate
        
        //calling the api
        getAllPayStubs()
        
        //calender initialization
        self.calenderView.delegate = self
        self.calenderView.select(weekEnd)
        self.calenderView.scope = .month
        // For UITest
        self.calenderView.accessibilityIdentifier = "calendar"
        self.calenderView.appearance.weekdayTextColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        self.calenderView.appearance.headerTitleColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        self.calenderView.appearance.selectionColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        self.calenderView.appearance.todayColor =  UIColor(hexString:"#c4c0cb")
        
        // hiding calenderView
        calenderHeight.constant = 250
        viewConstant.constant = 190
        cView.isHidden = true
        
        if UserDefaults.standard.integer(forKey:"EmployeeType") == 1
        {
            navigationItem.deleteFromRightBar(item: messageButton)
            // navigationItem.deleteFromRightBar(item: userButton)
        }
    }
    
    //method fot getting all the payStubs
    func getAllPayStubs()
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            var command = ""
            if viewYTD
            {
                command = "ViewYTD"
            }
            else
            {
                command = "HideYTD"
            }
            ServerService.showActivityIndicatory(uiView:self.view)
            let params = ["CandidateId":UserDefaults.standard.object(forKey:"cID") as! String, "EmployeeName":UserDefaults.standard.object(forKey:"CandName") as! String,"DivisionId":UserDefaults.standard.object(forKey:"dID") as! String,"EmployeeType":UserDefaults.standard.object(forKey:"EmployeeType") as! Int ,"StartDate":fromTextField.text!,"EndDate":toTextField.text!,"Command":command] as [String : Any]
            print(params)
            ServerService.getAllPayStubs(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.getPayStubList(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
    }
    //getting allPayStubsList
    func getPayStubList(response:AnyObject)->()
    {
        payStubs.removeAll()
        ServerService.hideProgressView()
        payStubsObject = response as! JSON
        print(payStubsObject)
        errorMessageLabel.text = payStubsObject["Message"].stringValue
        
        if payStubsObject["CheckList"].arrayValue.count>0
        {
            
            for dict in payStubsObject["CheckList"].arrayValue
            {
                
                
                let payStub = PayStub.init(checkNumber:dict["CheckNumber"].stringValue, division:dict["DivisionName"].stringValue, checkDate:dict["CheckDateAPI"].stringValue, netWages: String(format:"%.2f",dict["NetWages"].doubleValue), grossWages:String(format:"%.2f",dict["GrossWages"].doubleValue), ytd:String(format:"%.2f",dict["GrossYtd"].doubleValue),company:dict["Company"].stringValue)
                payStubs.append(payStub)
                
            }
            
            totals.totalNetWages = payStubsObject["TotalNetwages"].doubleValue
            totals.totalGrossWages = payStubsObject["TotalGrosswages"].doubleValue
            totals.totalGrossYTD = payStubsObject["TotalYTDwages"].doubleValue
        }
        else
        {
            payStubsTableView.backgroundColor = .clear
            if errorMessageLabel.text?.count == 0
            {
                errorMessageLabel.text = "No Records Found"
            }
        }
        payStubsTableView.reloadData()
    }
    
    //MARK:- Change Navigation Title
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
    
    @IBAction func goAction(_ sender: Any)
    {
        viewYTD = false
        viewYTBButton.setTitle("View YTD", for:.normal)
        getAllPayStubs()
    }
    
    @IBAction func viewYTB(_ sender: Any)
    {
        if viewYTD
        {
            //getting  month date
            let weekEnd = Calendar.current.date(byAdding: .day, value: 1, to: date.endOfWeek(weekday: 1))
            print(weekEnd!)
            let thisMonth = formatter.string(from:weekEnd!)
            print(thisMonth)
            toTextField.text = thisMonth
            
            //three months ago date
            let thirdMonth = Calendar.current.date(byAdding: .month, value:-3, to: weekEnd!)
            print(thirdMonth!)
            let thirdMonthDate = formatter.string(from:thirdMonth!)
            print(thirdMonthDate)
            fromTextField.text = thirdMonthDate
            viewYTBButton.setTitle("View YTD", for:.normal)
            viewYTD = false
        }
        else
        {
            //three months ago date
            let components = Calendar.current.dateComponents([.year], from: Date())
            let thirdMonth = Calendar.current.date(from: components)
            print(thirdMonth!.endOfMonth())
            let thirdMonthDate = formatter.string(from: thirdMonth!)
            print(thirdMonthDate)
            fromTextField.text = thirdMonthDate
            //getting  month date
            let weekEnd = Calendar.current.date(byAdding: .day, value: 1, to: date.endOfWeek(weekday: 1))
            print(weekEnd!)
            let thisMonth = formatter.string(from:weekEnd!)
            print(thisMonth)
            toTextField.text = thisMonth
            viewYTBButton.setTitle("Hide YTD", for:.normal)
            viewYTD = true
        }
        getAllPayStubs()
    }
    
    
    
    @IBAction func messagesAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"message") as? MessagesViewController
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func handleNavgationBarButtonTap(_ sender: UIBarButtonItem, event: UIEvent)
    
    {
        Constants.showUp(event:event,viewController:self)
        
    }
    
}





//UITableView DataSource and Delegate Methods

extension PayStubsViewController:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if payStubs.count>0
        {
            return payStubs.count+1
        }
        else
        {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if indexPath.row == payStubs.count
        {
            var identifier = ""
            if viewYTD
            {
                identifier = "tyCell"    //if need to show YTD
            }
            else
            {
                identifier = "tCell"
            }
            let cell = tableView.dequeueReusableCell(withIdentifier:identifier) as! TotalTableViewCell
            cell.totalNetWags.text = String(format:" $%.2f",totals.totalNetWages)
            cell.totalGross.text =  String(format:" $%.2f",totals.totalGrossWages)
            if viewYTD
            {
                cell.grossYTD.text =  String(format:" $%.2f",totals.totalGrossYTD)
            }
            cell.selectionStyle = .none
            return cell
        }
        else
        {
            
            var identifier = ""
            if viewYTD
            {
                identifier = "ytdCell"    //if need to show YTD
            }
            else
            {
                identifier = "payCell"
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier:identifier) as! PayStubTableViewCell
            
            cell.divisionLabel.text = " "+payStubs[indexPath.row].division!
            cell.checkDate.text = " "+payStubs[indexPath.row].checkDate!
            cell.checkNumberLabel.text = " "+payStubs[indexPath.row].checkNumber!
            cell.grossWages.text = " $"+payStubs[indexPath.row].grossWages!
            cell.nteWages.text = " $"+payStubs[indexPath.row].netWages!
            if viewYTD
            {
                cell.grossYTD.text = " $"+payStubs[indexPath.row].ytd!
            }
            cell.selectionStyle = .none
            return cell
        }
    }
}

extension PayStubsViewController:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == payStubs.count
        {
            if viewYTD
            {
                return 100
            }
            else
            {
                return 80
            }
        }
        else
        {
            if viewYTD
            {
                return 200  //if need to show YTD
            }
            else
            {
                return 180
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"View Pay Stubs") as? ViewPayStubViewController
        //        vc?.checkNumber = payStubs[indexPath.row].checkNumber!
        //        vc?.companyId = Int(payStubs[indexPath.row].company!) ?? 0
        //let backItem = UIBarButtonItem()
        //        backItem.title = "Back"
        //        navigationItem.backBarButtonItem = backItem
        //        self.navigationController?.pushViewController(vc!, animated: true)
        if indexPath.row == payStubs.count
        {
            
        }
        else
        {
            let inFo = ["checkNumber":payStubs[indexPath.row].checkNumber!,"companyID":Int(payStubs[indexPath.row].company!) ?? 0] as [String : Any]
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name("viewPayStub"), object:nil,userInfo:inFo)
            self.navigationController?.popViewController(animated:true)
        }
        
    }
}

//Extension UITextFieldDelegate
extension PayStubsViewController:UITextFieldDelegate
{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeTextField = textField
        textField.resignFirstResponder()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from:textField.text!)
        self.calenderView.select(date) // assigning the calender selected date
        
        // showing calender when textfield is selected
        calenderHeight.constant = 250
        viewConstant.constant = 440
        cView.isHidden = false
        return false
    }
}



//extension for fscalender delegate

extension PayStubsViewController :FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance
{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = "MM/dd/yyyy"
        if self.activeTextField?.tag == 1
        {
            self.fromTextField.text = formatter.string(from:date)
            
        }
        else
        {
            self.toTextField.text = formatter.string(from: date)
        }
        calenderHeight.constant = 0
        viewConstant.constant = 190
        cView.isHidden = true
    }
    
    
}
