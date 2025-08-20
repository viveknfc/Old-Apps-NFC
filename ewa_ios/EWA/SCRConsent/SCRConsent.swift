//
//  SCRConsent.swift
//  EWA
//
//  Created by NFC User on 7/21/21.
//  Copyright © 2021 NFC. All rights reserved.
//

import UIKit
import DropDown
import SwiftyJSON

class SCRConsent: BaseViewController, UITableViewDelegate, UITableViewDataSource, popDateDelegate, UITextFieldDelegate,popAlertDelegate {
    @IBOutlet weak var printView: UIView!
    @IBOutlet weak var pressToSignBottom: NSLayoutConstraint! // 20 to 70
    @IBOutlet weak var authorizeTextLabel2: UILabel!
    @IBOutlet weak var authorizeTextLabel1: UILabel!
    @IBOutlet weak var coverView: UIView!
    var SCRInfoObject: JSON = JSON.null
    
    @IBOutlet weak var submitButtonTrailing: NSLayoutConstraint!// 70 to 8
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var printButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dobTF2: UITextField!
    @IBOutlet weak var dobTF1: UITextField!
    @IBOutlet weak var agencyNameLabel: UILabel!
    @IBOutlet weak var signatureLabel1: UILabel!
    @IBOutlet weak var signatureLabel2: UILabel!
    @IBOutlet weak var signDateLabel1: UILabel!
    @IBOutlet weak var signDateLabel2: UILabel!
    
    @IBOutlet weak var gender2TF: UITextField!
    @IBOutlet weak var gender1TF: UITextField!
    @IBOutlet weak var gender1Button: UIButton!
    @IBOutlet weak var pressToSignButton2: UIButton!
    @IBOutlet weak var pressToSignButton1: UIButton!
    
    @IBOutlet weak var lastNameTF1: UITextField!
    @IBOutlet weak var lastNameTF2: UITextField!
    @IBOutlet weak var firstNameTF1: UITextField!
    @IBOutlet weak var firstNameTF2: UITextField!
    
    
    @IBOutlet weak var registeredProviderLabel: UILabel!
    
    @IBOutlet weak var gender2Button: UIButton!
    @IBOutlet weak var mainHeadingLabel: UILabel!
    
    @IBOutlet weak var addressTableHeight: NSLayoutConstraint!
    @IBOutlet weak var addressTable: UITableView!
    @IBOutlet weak var houseHoldTableHeight: NSLayoutConstraint!
    
    var sendingHouseHoldArray: [[String:String]] = []
    var sendingAddressArray: [[String:String]] = []
    
    var calledForListUpdate = Bool()
    
    var object: JSON = JSON.null
    var fromSideMenu = Bool()
    let dropDown = DropDown() //2
    @IBOutlet weak var houseHoldTableView: UITableView!
    var activeTF = UITextField()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        coverView.isHidden = false
        lastNameTF1.delegate = self
        lastNameTF2.delegate = self
        firstNameTF1.delegate = self
        firstNameTF2.delegate = self
        gender1TF.delegate = self
        gender2TF.delegate = self
        dobTF1.delegate = self
        dobTF2.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAllData),name: NSNotification.Name(rawValue:"ReloadSCRConsent"), object: nil)
        
        houseHoldTableView.register(UINib(nibName: "HouseHoldMemberCell", bundle: nil), forCellReuseIdentifier: "HouseHoldMemberCell")
        houseHoldTableView.delegate = self
        houseHoldTableView.dataSource = self
        houseHoldTableView.reloadData()
        
        addressTable.register(UINib(nibName: "A1Form2AddessCell", bundle: nil), forCellReuseIdentifier: "A1Form2AddessCell")
        addressTable.delegate = self
        addressTable.dataSource = self
        addressTable.reloadData()
        
        
    }
    
    @objc func reloadAllData(){
        calledForListUpdate = true
        self.getFormData()
    }
    
    //MARK:- Get Form Data
    func getFormData()
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:self.view)
            
            print("***VIV SCRConsent Clicked***")
            
            let params =
                ["CandId" : UserDefaults.standard.object(forKey: "cID") as! String]  as [String : Any]
            print(params)
            ServerService.GetSCRConsentForm(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.getSCRDataObject(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            
        }
        
    }
    
    // response from the server
    func getSCRDataObject(response:AnyObject)->()
    {
        
        ServerService.hideProgressView()
        self.SCRInfoObject = response as! JSON
        print("****** SCR Info Data is ************\n",SCRInfoObject)
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let privacyViewController = mainStoryboard.instantiateViewController(withIdentifier: "pVC") as! PrivacyPolicyViewController
        privacyViewController.link = SCRInfoObject["LinkURL"].string ?? ""
        privacyViewController.headerText = "SCR Consent Form"
        Constants.iSFormOkRequired = false
        privacyViewController.isPush = true
        
        let navi = BaseNaviViewController(rootViewController:privacyViewController)
                        navi.navigationBar.tintColor = .white
                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"SCR Consent Form")
        
        //viv - hided below
        
//        ServerService.hideProgressView()
//        self.SCRInfoObject = response as! JSON
//        print("****** SCR Info Data is ************\n",SCRInfoObject)
//        if SCRInfoObject["Status"].intValue == 1 {
//            coverView.isHidden = true
//            mainHeadingLabel.text = SCRInfoObject["MainHeading"].stringValue
//
//            registeredProviderLabel.text = SCRInfoObject["RegisteredProvider"].stringValue
//            agencyNameLabel.text = SCRInfoObject["AgencyName"].stringValue
//
//            var heightsArray = [String]()
//            heightsArray.removeAll()
//            for i in 0..<SCRInfoObject["ScrAddressList"].arrayValue.count
//            {
//                let isEdit = self.SCRInfoObject["ScrAddressList"][i]["ISAllowEdit"].stringValue
//                let isDelete = self.SCRInfoObject["ScrAddressList"][i]["ISAllowDelete"].stringValue
//                if isEdit == "0" && isDelete == "0"{
//                    heightsArray.append("1")
//                }
//            }
//
//            let finalAvailableHeights = SCRInfoObject["ScrAddressList"].arrayValue.count - heightsArray.count
//
//            houseHoldTableHeight.constant = CGFloat(10 + (170*SCRInfoObject["HouseHoldMemberList"].arrayValue.count))
//            addressTableHeight.constant = CGFloat(10 + ((176*finalAvailableHeights) + (136*heightsArray.count)))
//
//            if calledForListUpdate == false {
//                firstNameTF1.text = SCRInfoObject["ApplicantAreaInfo"]["AplFname"].stringValue
//                firstNameTF2.text = SCRInfoObject["ApplicantAreaInfo"]["AplMFname"].stringValue
//                lastNameTF1.text = SCRInfoObject["ApplicantAreaInfo"]["AplLname"].stringValue
//                lastNameTF2.text = SCRInfoObject["ApplicantAreaInfo"]["AplMLname"].stringValue
//                gender1TF.text =
//                    SCRInfoObject["ApplicantAreaInfo"]["AplSex"].stringValue
//                gender2TF.text = SCRInfoObject["ApplicantAreaInfo"]["AplMSex"].stringValue
//                dobTF1.text = SCRInfoObject["ApplicantAreaInfo"]["AplDOB"].stringValue
//                dobTF2.text = SCRInfoObject["ApplicantAreaInfo"]["AplMDOB"].stringValue
//
//                authorizeTextLabel1.text = self.SCRInfoObject["AuthorizeText1"].stringValue
//                authorizeTextLabel2.text = self.SCRInfoObject["AuthorizeText2"].stringValue
//            }
//            printButton.isHidden = false
//            if self.SCRInfoObject["DontAllowEdit"].boolValue {
//                //Signed Form
//                submitButtonTrailing.constant = 70
//                printView.isHidden = false
//                pressToSignBottom.constant = 70
//                pressToSignButton1.isHidden = true
//                pressToSignButton2.isHidden = true
//
//                signDateLabel1.text = "\(self.SCRInfoObject["EmployeeSigDate"].stringValue)\nDate (month/day/year)"
//                signDateLabel2.text = "\(self.SCRInfoObject["EmployeeSigDate"].stringValue)\nDate (month/day/year)"
//                signatureLabel1.text = "\(self.SCRInfoObject["EmployeeSigName"].stringValue)\nApplicant’s Signature"
//                signatureLabel2.text = "\(self.SCRInfoObject["EmployeeSigName"].stringValue)\nApplicant’s Signature"
//            }
//            else {
//
//
//                printView.isHidden = false
//                pressToSignBottom.constant = 70
//                pressToSignButton1.isHidden = false
//                pressToSignButton2.isHidden = false
//                printButton.isHidden = true
//                submitButtonTrailing.constant = 8
//                if Constants.sign1.count > 0 && Constants.signDate1.count > 0 {
//                    pressToSignButton1.isHidden = true
//                }
//                else {
//                    pressToSignButton1.isHidden = false
//                }
//                if Constants.sign2.count > 0 && Constants.signDate2.count > 0 {
//                    pressToSignButton2.isHidden = true
//                }
//                else {
//                    pressToSignButton2.isHidden = false
//                }
//
//                if Constants.sign1.count > 0 {signatureLabel1.text = "\(Constants.sign1)\nApplicant’s Signature"}
//                else {signatureLabel1.text = "Signature"}
//
//                if Constants.signDate1.count > 0 {signDateLabel1.text = "\(Constants.signDate1)\nDate (month/day/year)"}
//                else {signDateLabel1.text = "Date"}
//
//                if Constants.sign2.count > 0 {signatureLabel2.text = "\(Constants.sign2)\nApplicant’s Signature"}
//                else {signatureLabel2.text = "Signature"}
//
//                if Constants.signDate2.count > 0 {signDateLabel2.text = "\(Constants.signDate2)\nDate (month/day/year)"}
//                else {signDateLabel2.text = "Date"}
//            }
//            houseHoldTableView.reloadData()
//            addressTable.reloadData()
//        }
//        else {
//            var messagee = String()
//            if SCRInfoObject["Message"].stringValue.count > 0 {
//                messagee = SCRInfoObject["Message"].stringValue
//            }
//            else {
//                messagee = "Something is not right here try again later"
//            }
//            ServerService.ShowAlertMessage(ErrorMessage:"", title: messagee, view:self)
//        }
        
    }
    
    func loadAlertPopupWithObject(_ viewStatus: Int, messageText: String, attrbtedText: NSAttributedString, popKeyToSend: String, apiCallrequired: Bool)
    {
        let window = UIApplication.shared.keyWindow!
        
        let formView = Bundle.main.loadNibNamed("AlertPopView", owner: nil, options: nil)![0] as! AlertPopView
        
        formView.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
        formView.viewStatus = viewStatus
        formView.popKeyToSend = popKeyToSend
        formView.attrbtedText = attrbtedText
        formView.messageText = messageText
        formView.loadForm()
        formView.toCOntroller = UIApplication.getTopMostViewController()!
        formView.popAlertDelegate = self
        formView.apiCallrequired = apiCallrequired
        window.addSubview(formView)
        window.bringSubview(toFront:formView)
    }
    
    func changeNavigationTitle(_ titleStr: String) {
        let tlabel = UILabel()
        tlabel.text = titleStr
        tlabel.textColor = UIColor.white
        tlabel.font = UIFont.systemFont(ofSize:17)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.textAlignment = .center
        tlabel.numberOfLines = 0
        tlabel.minimumScaleFactor = 0.5
        self.navigationItem.titleView = tlabel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = object["FormName"].stringValue
        Constants.sign1 = ""
        Constants.signDate1 = ""
        Constants.sign2 = ""
        Constants.signDate2 = ""
        self.calledForListUpdate = false
        delayWithSeconds(0.5) {
            self.getFormData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.title = ""
        Constants.sign1 = ""
        Constants.signDate1 = ""
        Constants.sign2 = ""
        Constants.signDate2 = ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == houseHoldTableView {
            return SCRInfoObject["HouseHoldMemberList"].arrayValue.count
        }
        else {
            return SCRInfoObject["ScrAddressList"].arrayValue.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == houseHoldTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HouseHoldMemberCell") as! HouseHoldMemberCell
            cell.selectionStyle = .none
            cell.editButton.tag = indexPath.row
            cell.deleteButton.tag = indexPath.row
            cell.editButton.addTarget(self, action: #selector(editHouseHold(_:)), for: .touchUpInside)
            cell.deleteButton.addTarget(self, action: #selector(deleteHouseHold(_:)), for: .touchUpInside)
            if SCRInfoObject["HouseHoldMemberList"].arrayValue.count > 0 {
                let obj = SCRInfoObject["HouseHoldMemberList"][indexPath.row]
                cell.relationshipLabel.text = obj["AplRelationship"].stringValue
                cell.lastNameLabel.text = obj["AplLname"].stringValue
                cell.firstNameLabel.text = obj["AplFname"].stringValue
                cell.sexLabel.text = obj["AplSex"].stringValue
                cell.dobLabel.text = obj["AplDOB"].stringValue
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "A1Form2AddessCell") as! A1Form2AddessCell
            cell.selectionStyle = .none
            if SCRInfoObject["ScrAddressList"].arrayValue.count > 0 {
                cell.addressTitleLabel.text = "Current Street Address"
                cell.editButton.tag = indexPath.row
                cell.deleteButton.tag  = indexPath.row
                if self.SCRInfoObject["DontAllowEdit"].boolValue {
                    cell.editButton.isHidden = true
                    cell.deleteButton.isHidden = true
                }
                else {
                    cell.editButton.isHidden = false
                    cell.deleteButton.isHidden = false
                }
                cell.editButton.addTarget(self, action: #selector(self.editAddress(_:)), for: .touchUpInside)
                cell.deleteButton.addTarget(self, action: #selector(self.deleteAddress(_:)), for: .touchUpInside)
                
                //75//8
                let isEdit = self.SCRInfoObject["ScrAddressList"][indexPath.row]["ISAllowEdit"].stringValue
                let isDelete = self.SCRInfoObject["ScrAddressList"][indexPath.row]["ISAllowDelete"].stringValue
                
                if isEdit == "0" && isDelete == "0"{
                    cell.editButton.isHidden = true
                    cell.deleteButton.isHidden = true
                }
                else if isEdit == "1" && isDelete == "1"{
                    cell.editButton.isHidden = false
                    cell.deleteButton.isHidden = false
                }
                else if isEdit == "0" && isDelete == "1"{
                    cell.editButton.isHidden = true
                    cell.deleteButton.isHidden = false
                    cell.editTrailing.constant = 75
                }
                else if isEdit == "1" && isDelete == "0"{
                    cell.editButton.isHidden = false
                    cell.deleteButton.isHidden = true
                    cell.editTrailing.constant = 8
                }
                
                cell.addressLabel.text = self.SCRInfoObject["ScrAddressList"][indexPath.row]["AplCSAddress"].stringValue
                cell.aptLabel.text = self.SCRInfoObject["ScrAddressList"][indexPath.row]["AplApt"].stringValue
                cell.cityLabel.text = self.SCRInfoObject["ScrAddressList"][indexPath.row]["AplCity"].stringValue
                cell.stateLabel.text = self.SCRInfoObject["ScrAddressList"][indexPath.row]["AplState"].stringValue
                cell.zipLabel.text = self.SCRInfoObject["ScrAddressList"][indexPath.row]["AplZip"].stringValue
                cell.fromLabel.text = self.SCRInfoObject["ScrAddressList"][indexPath.row]["AplFrom"].stringValue
                cell.toLabel.text = self.SCRInfoObject["ScrAddressList"][indexPath.row]["AplTo"].stringValue
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == houseHoldTableView {
            return 175
        }
        else {
            if SCRInfoObject["ScrAddressList"].arrayValue.count > 0 {
                let isEdit = self.SCRInfoObject["ScrAddressList"][indexPath.row]["ISAllowEdit"].stringValue
                let isDelete = self.SCRInfoObject["ScrAddressList"][indexPath.row]["ISAllowDelete"].stringValue
                if isEdit == "0" && isDelete == "0"{
                    return 135
                }
                else {
                    return 175
                }
            }
            else {
                return 0
            }
        }
    }
    
    @IBAction func sexClicked(_ sender: UIButton) {
        dropDown.dataSource = [" ", "M", "F"]//4
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        dropDown.backgroundColor = .white
        dropDown.show() //7
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal) //9
            self!.gender1TF.text = item
        }
    }
    
    
    @IBAction func sex1Clicked(_ sender: UIButton) {
        
        dropDown.dataSource = [" ", "M", "F"]//4
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        dropDown.backgroundColor = .white
        dropDown.show() //7
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal) //9
            self!.gender2TF.text = item
        }
    }
    
    //MARK:- Show Calendar
    func showCalender(type: Int, HeadingText: String, dateToSelect:String) {
        
        let window = UIApplication.shared.keyWindow!
        
        let formView = Bundle.main.loadNibNamed("DateSelection", owner: nil, options: nil)![0] as! DateSelection
        
        formView.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
        formView.topLabelText = HeadingText
        formView.type = type
        formView.toCOntroller = self
        formView.dateDelegate = self
        formView.selectedDate = dateToSelect
        formView.loadDateView()
        window.addSubview(formView)
        window.bringSubview(toFront: formView)
        delayWithSeconds(0.2) {
            self.view.endEditing(true)
            self.dobTF1.resignFirstResponder()
            self.dobTF2.resignFirstResponder()
        }
        
    }
    
    //MARK:- Info Buttons Actions
    @IBAction func mainInfoButtonClicking(_ sender: UIButton) {
        
        self.loadAlertPopupWithObject(4, messageText: "", attrbtedText: self.SCRInfoObject["MainInfoText"].stringValue.htmlToAttributedString!, popKeyToSend: "", apiCallrequired: false)
    }
    
    @IBAction func applicantAreaInfoButtonClicked(_ sender: UIButton) {
        self.loadAlertPopupWithObject(4, messageText: "", attrbtedText: self.SCRInfoObject["ApplicantAreaText"].stringValue.htmlToAttributedString!, popKeyToSend: "", apiCallrequired: false)
    }
    
    @IBAction func houseHoldMemberAreaInfoClicked(_ sender: UIButton) {
        self.loadAlertPopupWithObject(4, messageText: "", attrbtedText: self.SCRInfoObject["HouseHoldMemberAreaText"].stringValue.htmlToAttributedString!, popKeyToSend: "", apiCallrequired: false)
    }
    
    @IBAction func addressAreaInfoClicked(_ sender: UIButton) {
        self.loadAlertPopupWithObject(4, messageText: "", attrbtedText: self.SCRInfoObject["AddressAreaInfo"].stringValue.htmlToAttributedString!, popKeyToSend: "", apiCallrequired: false)
    }
    
    //MARK:- HouseHold Actions
    @IBAction func addHouseHoldMemberClicked(_ sender: UIButton) {
        
        let window = UIApplication.shared.keyWindow!
        let formView = Bundle.main.loadNibNamed("AddHouseHoldMember", owner: nil, options: nil)![0] as! AddHouseHoldMember
        formView.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
        formView.isEdit = false
        formView.loadView()
        window.makeKeyAndVisible()
        UIApplication.getTopMostViewController()!.view.addSubview(formView)
        UIApplication.getTopMostViewController()!.view.bringSubview(toFront:formView)
    }
    
    @objc func editHouseHold(_ sender: UIButton) {
        let window = UIApplication.shared.keyWindow!
        let formView = Bundle.main.loadNibNamed("AddHouseHoldMember", owner: nil, options: nil)![0] as! AddHouseHoldMember
        formView.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
        formView.dataObject = SCRInfoObject["HouseHoldMemberList"][sender.tag]
        formView.isEdit = true
        formView.loadView()
        window.makeKeyAndVisible()
        UIApplication.getTopMostViewController()!.view.addSubview(formView)
        UIApplication.getTopMostViewController()!.view.bringSubview(toFront:formView)
    }
    @objc func deleteHouseHold(_ sender: UIButton) {
        
        let ID = SCRInfoObject["HouseHoldMemberList"][sender.tag]["Id"].stringValue
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:self.view)
            
            let params =
                ["CandId" : UserDefaults.standard.object(forKey: "cID") as! String,
                 "Id": ID]  as [String : Any]
            print(params)
            ServerService.DeleteHouseHoldMemeber(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.DeleteHouseHoldMemeberResponseObject(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
    }
    
    func DeleteHouseHoldMemeberResponseObject(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        let responseObject = response as! JSON
        print("****** DeleteHouseHoldMemeber Response is ******\n",responseObject)
        if responseObject["Status"].intValue == 1 {
            calledForListUpdate = true
            self.getFormData()
        }
        else {
            var messagee = String()
            if responseObject["Message"].stringValue.count > 0 {
                messagee = responseObject["Message"].stringValue
            }
            else {
                messagee = "Something is not right here try again later"
            }
            ServerService.ShowAlertMessage(ErrorMessage:"", title: messagee, view:(UIApplication.getTopMostViewController())!)
        }
    }
    
    //MARK:- Address Actions
    @IBAction func addAddressClicked(_ sender: UIButton) {
        let window = UIApplication.shared.keyWindow!
        let formView = Bundle.main.loadNibNamed("AddAddress", owner: nil, options: nil)![0] as! AddAddress
        formView.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
        formView.isEdit = false
        formView.isFromSCRConsent = true
        formView.warningMessageText = "Please make sure you need to re-sign the document if you change address"
        formView.loadView()
        //        window.addSubview(formView)
        //        window.bringSubview(toFront:formView)
        window.makeKeyAndVisible()
        UIApplication.getTopMostViewController()!.view.addSubview(formView)
        UIApplication.getTopMostViewController()!.view.bringSubview(toFront:formView)
    }
    
    //MARK:- Edit/Delete Address
    @objc func editAddress(_ sender: UIButton) {
        let window = UIApplication.shared.keyWindow!
        let formView = Bundle.main.loadNibNamed("AddAddress", owner: nil, options: nil)![0] as! AddAddress
        formView.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
        formView.dataObject = SCRInfoObject["ScrAddressList"][sender.tag]
        formView.isEdit = true
        formView.isFromSCRConsent = true
        formView.warningMessageText = ""
        formView.loadView()
        //        window.addSubview(formView)
        //        window.bringSubview(toFront:formView)
        window.makeKeyAndVisible()
        UIApplication.getTopMostViewController()!.view.addSubview(formView)
        UIApplication.getTopMostViewController()!.view.bringSubview(toFront:formView)
        
    }
    
    @objc func deleteAddress(_ sender: UIButton) {
        let addressID = SCRInfoObject["ScrAddressList"][sender.tag]["Id"].stringValue
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:self.view)
            
            let params =
                ["Id": addressID]  as [String : Any]
            print(params)
            ServerService.DeleteAddress(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.DeleteSCRAddressResponseObject(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
    }
    
    func DeleteSCRAddressResponseObject(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        let responseObject = response as! JSON
        print("****** DeleteSCRAddressResponseObject is ************\n",responseObject)
        if responseObject["Status"].intValue == 1 {
            calledForListUpdate = true
            self.getFormData()
        }
        else {
            var messagee = String()
            if responseObject["Message"].stringValue.count > 0 {
                messagee = responseObject["Message"].stringValue
            }
            else {
                messagee = "Something is not right here try again later"
            }
            ServerService.ShowAlertMessage(ErrorMessage:"", title: messagee, view:(UIApplication.getTopMostViewController())!)
        }
    }
    
    
    //MARK:- PressToSign Actions
    @IBAction func pressToSIgn1Clicked(_ sender: UIButton) {
        if self.validateData() {
            self.showSignView(0)
        }
    }
    
    @IBAction func pressToSIgn2Clicked(_ sender: UIButton) {
        if self.validateData() {
            self.showSignView(1)
        }
    }
    
    func validateData() -> Bool {
        var isValid : Bool = false
        self.view.endEditing(true)
        if lastNameTF1.isEmpty{
            scrollView.setContentOffset(.zero, animated: true)
            ServerService.ShowAlertMessage(ErrorMessage:"", title: "Last Name should not be empty in (Applicant Area)", view:self)
        }
        else if firstNameTF1.isEmpty {
            scrollView.setContentOffset(.zero, animated: true)
            ServerService.ShowAlertMessage(ErrorMessage:"", title: "First Name should not be empty in (Applicant Area)", view:self)
        }
        else if gender1TF.isEmpty {
            scrollView.setContentOffset(.zero, animated: true)
            ServerService.ShowAlertMessage(ErrorMessage:"", title: "Please select the gender in (Applicant Area)", view:self)
        }
        else if dobTF1.isEmpty {
            scrollView.setContentOffset(.zero, animated: true)
            ServerService.ShowAlertMessage(ErrorMessage:"", title: "Date of birth should not be empty", view:self)
        }
        else if SCRInfoObject["HouseHoldMemberList"].arrayValue.count == 0{
            ServerService.ShowAlertMessage(ErrorMessage:"", title: #"Please enter "NONE" in "HOUSEHOLD MEMBER AREA" if there are no other household members"#, view:self)
        }
        
        else if SCRInfoObject["ScrAddressList"].arrayValue.count == 0{
            ServerService.ShowAlertMessage(ErrorMessage:"", title: "Please enter at least one address", view:self)
        }
        else {
            isValid = true
        }
        return isValid
    }
    
    
    
    func getParams() -> [String:Any]{
        sendingHouseHoldArray.removeAll()
        sendingAddressArray.removeAll()
        
        let ApplicantAreaInfo:[String:String] = ["AplMFname" : firstNameTF2.text!,
                                                 "AplSex" : gender1TF.text!,
                                                 "Id" : "",
                                                 "AplMLname" : lastNameTF2.text!,
                                                 "flag" : "",
                                                 "ApplicantId" : self.SCRInfoObject["ApplicantId"].stringValue,
                                                 "AplMSex" : gender2TF.text!,
                                                 "AplLname" : lastNameTF1.text!,
                                                 "AplFname" : firstNameTF1.text!,
                                                 "AplDOB" : dobTF1.text!,
                                                 "AplMDOB" : dobTF2.text!]
        
        for i in 0..<SCRInfoObject["HouseHoldMemberList"].arrayValue.count {
            let obj:[String:String] = [
                
                "Message" : SCRInfoObject["HouseHoldMemberList"][i]["Message"].stringValue,
                "AplDOB" : SCRInfoObject["HouseHoldMemberList"][i]["AplDOB"].stringValue,
                "AplRelationship" : SCRInfoObject["HouseHoldMemberList"][i]["AplRelationship"].stringValue,
                "AplLname" : SCRInfoObject["HouseHoldMemberList"][i]["AplLname"].stringValue,
                "Status" : SCRInfoObject["HouseHoldMemberList"][i]["Status"].stringValue,
                "AplFname" : SCRInfoObject["HouseHoldMemberList"][i]["AplFname"].stringValue,
                "ApplicantId" : SCRInfoObject["HouseHoldMemberList"][i]["ApplicantId"].stringValue,
                "AplDobMon" : SCRInfoObject["HouseHoldMemberList"][i]["AplDobMon"].stringValue,
                "AplDobYear" : SCRInfoObject["HouseHoldMemberList"][i]["AplDobYear"].stringValue,
                "CandId" : SCRInfoObject["HouseHoldMemberList"][i]["CandId"].stringValue,
                "AplDobDay" : SCRInfoObject["HouseHoldMemberList"][i]["AplDobDay"].stringValue,
                "Id" : SCRInfoObject["HouseHoldMemberList"][i]["Id"].stringValue,
                "AplSex" : SCRInfoObject["HouseHoldMemberList"][i]["AplSex"].stringValue]
            sendingHouseHoldArray.append(obj)
        }
        
        for i in 0..<SCRInfoObject["ScrAddressList"].arrayValue.count {
            let obj:[String:String] = [
                "AplState" : SCRInfoObject["ScrAddressList"][i]["AplState"].stringValue,
                "Message" : SCRInfoObject["ScrAddressList"][i]["Message"].stringValue,
                "AplTo2" : SCRInfoObject["ScrAddressList"][i]["AplTo2"].stringValue,
                "AplFrom" : SCRInfoObject["ScrAddressList"][i]["AplFrom"].stringValue,
                "AplCountry" : SCRInfoObject["ScrAddressList"][i]["AplCountry"].stringValue,
                "AplTo" : SCRInfoObject["ScrAddressList"][i]["AplTo"].stringValue,
                "AplCountryCode" : SCRInfoObject["ScrAddressList"][i]["AplCountryCode"].stringValue,
                "AplCSAddress" : SCRInfoObject["ScrAddressList"][i]["AplCSAddress"].stringValue,
                "AplZip" : SCRInfoObject["ScrAddressList"][i]["AplZip"].stringValue,
                "CandId" : SCRInfoObject["ScrAddressList"][i]["CandId"].stringValue,
                "AplApt" : SCRInfoObject["ScrAddressList"][i]["AplApt"].stringValue,
                "RequestedFromDashboard" : SCRInfoObject["ScrAddressList"][i]["RequestedFromDashboard"].stringValue,
                "Status" : SCRInfoObject["ScrAddressList"][i]["Status"].stringValue,
                "AplCity" : SCRInfoObject["ScrAddressList"][i]["AplCity"].stringValue,
                "Timestamp" : SCRInfoObject["ScrAddressList"][i]["Timestamp"].stringValue,
                "ApplicantId" : SCRInfoObject["ScrAddressList"][i]["ApplicantId"].stringValue,
                "Id" : SCRInfoObject["ScrAddressList"][i]["Id"].stringValue,
                "ISAllowDelete" : SCRInfoObject["ScrAddressList"][i]["ISAllowDelete"].stringValue,
                "ISAllowEdit" : SCRInfoObject["ScrAddressList"][i]["ISAllowEdit"].stringValue]
            sendingAddressArray.append(obj)
        }
        
        
        let params:[String:Any] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,
                                   "ApplicantAreaInfo": ApplicantAreaInfo,
                                   "AplRelationship" : SCRInfoObject["AplRelationship"].stringValue,
                                   "RegisteredProvider" : SCRInfoObject["RegisteredProvider"].stringValue,
                                   "MyProperty" : SCRInfoObject["MyProperty"].stringValue,
                                   "AplDOB" : SCRInfoObject["AplDOB"].stringValue,
                                   "AddressAreaList" : SCRInfoObject["AddressAreaList"].stringValue,
                                   "EmployeeSigTimestamp" : SCRInfoObject["EmployeeSigTimestamp"].stringValue,
                                   "Message" : SCRInfoObject["Message"].stringValue,
                                   "AplLname" : SCRInfoObject["AplLname"].stringValue,
                                   "Status" : SCRInfoObject["Status"].stringValue,
                                   "MainHeading" : SCRInfoObject["MainHeading"].stringValue,
                                   "ApplicantId" : SCRInfoObject["ApplicantId"].stringValue,
                                   "AplSex" : SCRInfoObject["AplSex"].stringValue,
                                   "HouseHoldMemberAreaInfo" : SCRInfoObject["HouseHoldMemberAreaInfo"].stringValue,
                                   "EmployeeSigTimestampSCR" : SCRInfoObject["EmployeeSigTimestampSCR"].stringValue,
                                   "AgencyName" : SCRInfoObject["AgencyName"].stringValue,
                                   "AplFname" : SCRInfoObject["AplFname"].stringValue,
                                   "ScrAddressList": sendingAddressArray,
                                   "HouseHoldMemberList": sendingHouseHoldArray,
                                   "AppVersion":"IOS,\(Constants.APP_VERSION)"]
        return params
    }
    
    func showSignView(_ signType: Int) {
        
        
        let window = UIApplication.shared.keyWindow!
        let formView = Bundle.main.loadNibNamed("A1SignView", owner: nil, options: nil)![0] as! A1SignView
        formView.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
        formView.setUp()
        if signType == 0 {
            formView.object = JSON(["FormName":Constants.SCRSign1])
        }
        else {
            formView.object = JSON(["FormName":Constants.SCRSign2]) 
        }
        formView.signDelegate = self
        window.makeKeyAndVisible()
        UIApplication.getTopMostViewController()!.view.addSubview(formView)
        UIApplication.getTopMostViewController()!.view.bringSubview(toFront:formView)
    }
    
    //MARK:- TextField Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == dobTF1 {
            activeTF = dobTF1
            self.view.endEditing(true)
            textField.resignFirstResponder()
            self.showCalender(type: 0, HeadingText: "Select Date of Birth", dateToSelect: dobTF1.text!)
            return false
        }
        else  if textField == dobTF2 {
            activeTF = dobTF2
            self.view.endEditing(true)
            textField.resignFirstResponder()
            self.showCalender(type: 0, HeadingText: "Select Date of Birth", dateToSelect: dobTF2.text!)
            return false
        }
        else if textField == gender1TF {
            self.view.endEditing(true)
            textField.resignFirstResponder()
            delayWithSeconds(0.2) {
                self.view.endEditing(true)
                self.gender1TF.resignFirstResponder()
            }
            gender1Button.sendActions(for: .touchUpInside)
            return false
        }
        else if textField == gender2TF {
            self.view.endEditing(true)
            textField.resignFirstResponder()
            delayWithSeconds(0.2) {
                self.view.endEditing(true)
                self.gender2TF.resignFirstResponder()
            }
            gender2Button.sendActions(for: .touchUpInside)
            return false
        }
        else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
        
    }
    
    //MARK:- Date Selection Delegate
    
    func selectedDate(date: String, type: Int) {
        if activeTF == dobTF1 {
            dobTF1.text = date
        }
        else {
            dobTF2.text = date
        }
        
    }
    
    //MARK:- Pop Alert Delegate Method
    func formStatus(success: Bool) {
        
    }
    
    func getPrintFormData()
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:self.view)
            
            let params =
                ["CandID" : UserDefaults.standard.object(forKey: "cID") as! String,"FormCode":"SCRFormPDF"]  as [String : Any]
            print(params)
            ServerService.GeneratePrintPDF(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.getPrintFormDataObject(response:))
            
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            
        }
        
    }
    // response from the server
    func getPrintFormDataObject(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        let printObject = response as! JSON
        print("****** PDF Data is ************\n",printObject)
        if printObject["PDFFileName"].stringValue.count > 5  {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let privacyViewController = mainStoryboard.instantiateViewController(withIdentifier: "pVC") as! PrivacyPolicyViewController
            privacyViewController.link = printObject["PDFFileName"].stringValue
            privacyViewController.headerText = object["FormName"].stringValue
            privacyViewController.isPush = true
            Constants.iSFormOkRequired = false
            self.navigationController?.pushViewController(privacyViewController, animated: true)
        }
        else {
            var messagee = String()
            if printObject["Message"].stringValue.count > 0 {
                messagee = printObject["Message"].stringValue
            }
            else {
                messagee = "Something is not right here try again later"
            }
            ServerService.ShowAlertMessage(ErrorMessage:"", title: messagee, view:self)
        }
    }
    
    //MARK:- Print Action
    
    @IBAction func printClicked(_ sender: UIButton) {
        self.getPrintFormData()
    }
    
    
    @IBAction func submitClicked(_ sender: UIButton) {
        if self.validateData() {
            if self.SCRInfoObject["DontAllowEdit"].boolValue {
                
                Constants.SCRConsentInsertParams = self.getParams()
                let date = Date()
                let formatter = DateFormatter()
                formatter.locale = Locale.preferredLocale()
                formatter.dateFormat = "MM/dd/yyyy hh:mm aa"
                let result = formatter.string(from: date)
                
                Constants.SCRConsentInsertParams["EmployeeSigDate"] = result
                Constants.SCRConsentInsertParams["EmployeeSigName"] = self.SCRInfoObject["EmployeeSigName"].stringValue
                Constants.SCRConsentInsertParams["EmployeeSigDateSCR"] = result
                Constants.SCRConsentInsertParams["EmployeeSigNameSCR"] = self.SCRInfoObject["EmployeeSigName"].stringValue
                
                continueToSubmit()
            }
            else {
                
                if Constants.sign1.count > 0 && Constants.sign2.count > 0 && Constants.signDate1.count > 0 && Constants.signDate2.count > 0{
                    Constants.SCRConsentInsertParams = self.getParams()
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.locale = Locale.preferredLocale()
                    formatter.dateFormat = "MM/dd/yyyy hh:mm aa"
                    let result = formatter.string(from: date)
                    
                    Constants.SCRConsentInsertParams["EmployeeSigDate"] = result
                    Constants.SCRConsentInsertParams["EmployeeSigName"] = Constants.sign1
                    Constants.SCRConsentInsertParams["EmployeeSigDateSCR"] = result
                    Constants.SCRConsentInsertParams["EmployeeSigNameSCR"] = Constants.sign2
                    
                    print(Constants.SCRConsentInsertParams)
                    continueToSubmit()
                }
                else {
                    
                    ServerService.ShowAlertMessage(ErrorMessage:"", title: "Please sign the SCR form", view:UIApplication.getTopMostViewController()!)
                }
            }
        }
    }
    
    func continueToSubmit(){
        ServerService.showActivityIndicatory(uiView:self.view)
        let params =  Constants.SCRConsentInsertParams
        print(params)
        ServerService.SubmitSCRFormData(UIApplication.getTopMostViewController()!, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponseFormResponse(response:))
    }
    func getresponseFormResponse(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        let signedObjectResponse = response as! JSON
        print(signedObjectResponse)
        if signedObjectResponse["Status"].stringValue == "Success"
        {
            if ConnectionCheck.isConnectedToNetwork()
            {
                if fromSideMenu {
                calledForListUpdate = false
                self.getFormData()
                }
                else if Constants.Menu == "DashBoard" {
                    let vc = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"message") as? MessagesViewController)!
                    let navi = BaseNaviViewController(rootViewController:vc)
                    navi.navigationBar.tintColor = .white
                    navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                    sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"message")
                    
                }
                else {
                    let identifier = Constants.Menu
                    if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateVC(withIdentifier: identifier) {
                        let navi = BaseNaviViewController(rootViewController:viewController)
                        navi.navigationBar.tintColor = .white
                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:identifier)
                    }
                }
            }
            else
            {
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:UIApplication.getTopMostViewController()!)
            }
        }
        else
        {
            
            var messagee = String()
            if signedObjectResponse["Message"].stringValue.count > 0 {
                messagee = signedObjectResponse["Message"].stringValue
            }
            else {
                messagee = "Something is not right here try again later"
            }
            ServerService.ShowAlertMessage(ErrorMessage:"", title: messagee, view:(UIApplication.getTopMostViewController())!)
        }
    }
    
}
extension SCRConsent: a1signatureDelagte {
    func signatureStatus(success: Bool) {
        calledForListUpdate = true
        self.getFormData()
    }
}
extension UIViewController {
    open override func awakeFromNib() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

extension UITextField {
    var isEmpty: Bool {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
    }
}
