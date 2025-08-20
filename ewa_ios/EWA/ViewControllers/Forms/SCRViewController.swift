//
//  SCRViewController.swift
//  EWA
//
//  Created by NFCIndia on 16/09/19.
//  Copyright © 2019 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import FSCalendar
import SkyFloatingLabelTextField

class SCRViewController: UIViewController,FSCalendarDataSource,FSCalendarDelegate {
    
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var scrLabel: PaddingLabel!
    @IBOutlet weak var scrTableView: UITableView!
    
    @IBOutlet weak var currentAddress: SkyFloatingLabelTextField!
    @IBOutlet weak var aptTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var cityTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var stateTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var zipCodeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var fromTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var toTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet var addPopUp: UIView!
    @IBOutlet var addTextFields: [SkyFloatingLabelTextField]!
    private weak var calendar: FSCalendar!
    
    
    var checked = false
    var scrPopUpDetails:JSON = JSON.null
    var addAddress:JSON = JSON.null
    var scrSubmitData:JSON = JSON.null
    var addressList = [ScrPopUp]()
    var blurEffect = UIBlurEffect()
    var blurEffectView = UIVisualEffectView()
    var calenderBlurView = UIVisualEffectView()
    var selectedDate = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.updateNavigationBarColor()
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        headerView.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        //getting the scr details
        get_scrdetails()
        //  addButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = "SCR Form"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.title = ""
    }
    
    //adding the float button
    func addButton()
    {
        let addButton = UIButton()
        addButton.frame = CGRect(x:self.view.bounds.width-70, y:self.view.bounds.height-100, width:60, height:60)
        
        addButton.layer.cornerRadius = 30
        addButton.layer.masksToBounds = true
        addButton.setTitle("Add", for:.normal)
        addButton.backgroundColor = UIColor(hexString:"#449D44")
        addButton.addTarget(self, action: #selector(addTapped(_:)), for:.touchUpInside)
        view.addSubview(addButton)
    }
    
    @objc func addTapped(_ button: UIButton) {
        add_addressPopUp()
        
        //        let VC = SCRConsent(nibName: "SCRConsent", bundle: nil)
        //     let object = JSON(["FormName":"SCR Consent"])
        //        VC.object = object
        //        VC.fromSideMenu = true
        //        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    
    //method to get scrpopupdetails
    func get_scrdetails()
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            
            ServerService.showActivityIndicatory(uiView:self.view)
            //let params = ["CandidateId":"186279","DivisionId":"117"]
            let params = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String,"DivisionId":UserDefaults.standard.object(forKey: "dID") as! String] as [String : Any]
            print(params)
            ServerService.scrDetails(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.getSCRData(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
    }
    
    // response from the server for get_scrdetails()
    func getSCRData(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        scrPopUpDetails = response as! JSON
        print(scrPopUpDetails)
        scrLabel.text = scrPopUpDetails["PopUpMessage"].stringValue
        if scrPopUpDetails["Addresslist"].count>0
        {
            for s in 0..<scrPopUpDetails["Addresslist"].count
            {
                let scrPopUp = ScrPopUp.init(address:scrPopUpDetails["Addresslist"][s]["AplCSAddress"].stringValue, apt:scrPopUpDetails["Addresslist"][s]["AplApt"].stringValue, from:scrPopUpDetails["Addresslist"][s]["AplFrom"].stringValue, to:scrPopUpDetails["Addresslist"][s]["AplTo"].stringValue, city:scrPopUpDetails["Addresslist"][s]["AplCity"].stringValue, state:scrPopUpDetails["Addresslist"][s]["AplState"].stringValue, zipcode:scrPopUpDetails["Addresslist"][s]["AplZip"].stringValue,id:scrPopUpDetails["Addresslist"][s]["Id"].stringValue)
                addressList.append(scrPopUp)
            }
            
            scrTableView.reloadData()
        }
        else {
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    @IBAction func addAddressClicked(_ sender: UIButton) {
        
        let VC = SCRConsent(nibName: "SCRConsent", bundle: nil)
        let object = JSON(["FormName":"SCR Consent"])
        VC.object = object
        VC.fromSideMenu = true
        self.navigationController?.pushViewController(VC, animated: true)
    }
    @IBAction func updateClicked(_ sender: UIButton) {
        self.submitSignature()
    }
    func add_addressPopUp()
    {
        //add address popup frame
        blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addPopUp.frame = CGRect(x:15, y:self.navigationController!.navigationBar.frame.maxY+20, width:self.view.bounds.size.width-30, height:self.view.bounds.size.height*0.75)
        blurEffectView.contentView.addSubview(addPopUp)
        self.view.addSubview(blurEffectView)
        
        //To textField to today's date
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = "MM/dd/yyyy"
        toTextField.text = formatter.string(from:Date())
        if addressList.count > 0 {
            let nextDay = Calendar.current.date(byAdding: .day, value:1, to:formatter.date(from:addressList[0].to)!)
            fromTextField.text = formatter.string(from:nextDay!)
        }
    }
    
    //api call for adding address
    func add_address()
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            
            ServerService.showActivityIndicatory(uiView:self.view)
            let params = ["Candidateid":UserDefaults.standard.object(forKey: "cID") as! String,
                          "AplCSAddress":currentAddress.text!,
                          "AplApt":aptTextField.text!,
                          "AplCity":cityTextField.text!,
                          "AplState":stateTextField.text!,
                          "AplZip":zipCodeTextField.text!,
                          "AplFrom":fromTextField.text!,
                          "AplTo":toTextField.text!]
            print(params)
            ServerService.scrAddAddress(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.getAddAddressData(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            
        }
    }
    
    // response from the server for getAddAddressData()
    func getAddAddressData(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        addAddress = response as! JSON
        print(addAddress)
        if addAddress["Status"].intValue  == 1
        {
            self.navigationController?.view.makeToast(addAddress["NotifyMessage"].stringValue, duration: 3.0, position: .bottom, title: "", image: nil)
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        else
        {
            
            var messagee = String()
            if addAddress["NotifyMessage"].stringValue.count > 0 {
                messagee = addAddress["NotifyMessage"].stringValue
            }
            else {
                messagee = "Something is not right here try again later"
            }
            ServerService.ShowAlertMessage(ErrorMessage:"", title: messagee, view:self)
        }
        
    }
    
    
    //add address action
    @IBAction func addAddressAction(_ sender: Any)
    {
        var isvalid = true
        for v in 0..<addTextFields.count
        {
            if addTextFields[v].text!.count>0
            {
                isvalid = true
            }
            else
            {
                isvalid = false
                break
            }
        }
        
        if isvalid
        {
            add_address()
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage:"", title:"Please fill all the details", view:self)
        }
        
        
    }
    
    //close action for add address popup
    @IBAction func closeAction(_ sender: Any)
    {
        blurEffectView.removeFromSuperview()
        for t in 0..<addTextFields.count
        {
            addTextFields[t].text = ""
        }
        
    }
    
    
    
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    
    //update checkbox action
    @IBAction func checkBoxAction(_ sender: Any) {
        
        if checked
        {
            checkBoxButton.setImage(UIImage(named:"uncheck.png"), for:.normal)
            checked = false
        }
        else
        {
            checkBoxButton.setImage(UIImage(named:"check.png"), for:.normal)
            checked = true
            submitSignature()
        }
    }
    //api call for submit signature
    func submitSignature()
    {
        if addressList.count > 0 {
            if ConnectionCheck.isConnectedToNetwork()
            {
                let formatter = DateFormatter()
                formatter.locale = Locale.preferredLocale()
                formatter.dateFormat = "MM/dd/yyyy"
                ServerService.showActivityIndicatory(uiView:self.view)
                let params = ["Candidateid":UserDefaults.standard.object(forKey: "cID") as! String,
                              "AplCSAddress":addressList[0].address,
                              "AplApt":addressList[0].apt,
                              "AplCity":addressList[0].city,
                              "AplState":addressList[0].state,
                              "AplZip":addressList[0].zipcode,
                              "AplFrom":addressList[0].to,
                              "AplTo":formatter.string(from:Date()),
                              "Id":addressList[0].id]
                print(params)
                ServerService.submitSCR(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.getUpdateData(response:))
            }
            else
            {
                ServerService.hideProgressView()
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                
            }
        }
    }
    
    // response from the server for getAddAddressData()
    func getUpdateData(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        scrSubmitData = response as! JSON
        print(scrSubmitData)
        if scrSubmitData["Status"].intValue  == 1
        {
            self.getMenuLinks()
            self.navigationController?.view.makeToast(scrSubmitData["NotifyMessage"].stringValue, duration: 3.0, position: .bottom, title: "", image: nil)
            _ = self.navigationController?.popToRootViewController(animated: true)
            Constants.isScrSigned = 5
        }
        else
        {
            var messagee = String()
            if scrSubmitData["NotifyMessage"].stringValue.count > 0 {
                messagee = scrSubmitData["NotifyMessage"].stringValue
            }
            else {
                messagee = "Something is not right here try again later"
            }
            ServerService.ShowAlertMessage(ErrorMessage:"", title: messagee, view:self)
        }
        
    }
    
    func loadCalenderView() {
        
        blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        calenderBlurView = UIVisualEffectView(effect: blurEffect)
        calenderBlurView.frame = view.bounds
        calenderBlurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let height: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 400 : 300
        let calendar = FSCalendar(frame: CGRect(x: 10, y:self.view.bounds.size.height/2-height/2, width: self.view.bounds.width-20, height: height))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.select(selectedDate)
        calendar.backgroundColor = UIColor.white
        calenderBlurView.contentView.addSubview(calendar)
        self.view.addSubview(calenderBlurView)
        self.calendar = calendar
        
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        print(date)
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = "MM/dd/yyyy"
        fromTextField.text = formatter.string(from:date)
        calenderBlurView.removeFromSuperview()
    }
    
}


extension SCRViewController:UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"scrCell") as! SCRTableViewCell
        if addressList.count > 0 {
            cell.addressLabel.text = addressList[indexPath.row].address
            cell.aptLabel.attributedText = attributedText(withString: String(format: "APT# %@",addressList[indexPath.row].apt), boldString: "APT#", font: cell.aptLabel.font)
            cell.fromLabel.attributedText = attributedText(withString: String(format: "From %@",addressList[indexPath.row].from), boldString: "From", font: cell.fromLabel.font)
            cell.toLabel.attributedText = attributedText(withString: String(format: "To %@",addressList[indexPath.row].to), boldString: "To", font: cell.toLabel.font)
            cell.cityLabel.attributedText = attributedText(withString: String(format: "City %@",addressList[indexPath.row].city), boldString: "City", font: cell.cityLabel.font)
            cell.stateLabel.attributedText = attributedText(withString: String(format: "State %@",addressList[indexPath.row].state), boldString:"State", font: cell.stateLabel.font)
            cell.zipCodeLabel.attributedText = attributedText(withString: String(format: "Zip %@",addressList[indexPath.row].zipcode), boldString:"Zip", font: cell.zipCodeLabel.font)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if addressList.count > 0 {
            let ht = Constants.calculateHeight(inString:addressList[indexPath.row].address, width:self.view.bounds.width-20)
            return 70+ht
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
    
    //UITextField Delegate methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 5
        {
            textField.resignFirstResponder()
            //datePickerTapped()
            loadCalenderView()
            return false
        }
        else
        {
            return true
        }
    }
    
    
    
}
