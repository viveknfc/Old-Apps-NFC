//
//  A1FormController.swift
//  EWA
//
//  Created by NFC User on 7/22/21.
//  Copyright © 2021 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON

class A1FormController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, popDateDelegate {
    @IBOutlet weak var otherNameTableTop: NSLayoutConstraint! // 50 to 42
    @IBOutlet weak var printButton: UIButton!
    @IBOutlet weak var otherNameTableTrailing: NSLayoutConstraint! // 8 to 120
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var signatureLabel: UILabel!
    @IBOutlet weak var signdateLabel: UILabel!
    @IBOutlet weak var pressToSignButton: UIButton!
    @IBOutlet weak var addaliasNameButton: UIButton!
    @IBOutlet weak var addaddressButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var aliasNameTF: UITextField!{
        didSet {
            aliasNameTF.layer.borderColor = UIColor.lightGray.cgColor
            aliasNameTF.layer.borderWidth = 0.8
        }
    }
    var fromSideMenu = Bool()
    @IBOutlet weak var revisionLabel: UILabel!
    @IBOutlet weak var otherNameViewHeight: NSLayoutConstraint!
    @IBOutlet weak var otherNameView: UIView!
    @IBOutlet weak var mainHeadingLabel: UILabel!
    @IBOutlet weak var view1Height: NSLayoutConstraint!
    
    @IBOutlet weak var groupChildLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var doebutton: UIButton!
    @IBOutlet weak var identogo: UIButton!
    @IBOutlet weak var otherNameNo: UIButton!
    @IBOutlet weak var otherNameYes: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var livedYes: UIButton!
    @IBOutlet weak var livedNo: UIButton!
    @IBOutlet weak var addressViewHeight: NSLayoutConstraint!
    @IBOutlet weak var addressesView: UIView!
    @IBOutlet weak var addAddressButton: UIButton!
    @IBOutlet weak var addressesTableView: UITableView!
    var object:JSON = JSON.null
    var A1FormObject:JSON = JSON.null
    
    @IBOutlet weak var otherNameTable: UITableView!
    @IBOutlet weak var addressTextView: UITextView! {
        didSet {
            addressTextView.layer.cornerRadius = 5.0
            addressTextView.layer.borderWidth = 0.5
            addressTextView.layer.borderColor = UIColor.lightGray.cgColor //withAlphaComponent(0.80)
        }
    }
    @IBOutlet weak var view1: UIView! {
        didSet {
            view1.layer.cornerRadius = 5.0
            view1.layer.borderWidth = 1.0
            view1.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var view2: UIView!{
        didSet {
            view2.layer.cornerRadius = 5.0
            view2.layer.borderWidth = 1.0
            view2.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var ifYesAddressLabel: UILabel!
    //If Yes, list all known names (including maiden name, aliases, pseudonyms)
    //If Yes, add all out of state addresses where you lived in the past five years.
    @IBOutlet weak var ifYesOtherNamesLabels: UILabel!
    @IBOutlet weak var firstNameTF: UITextField!
    
    @IBOutlet weak var middleNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var aptTF: UITextField!
    
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var floorTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var zipTF: UITextField!
    
    @IBOutlet weak var phoneTF: UITextField!
    
    @IBOutlet weak var dobTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    var calledForAddressListUpdate = Bool()
    var fingerPrintType = String()
    var otherNameType = String()
    var livedOutSideNY = String()
    var otherNamesArray: [[String:String]] = []
    var addressArray: [[String:String]] = []
    let allowedCharacters = CharacterSet(charactersIn:"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ").inverted
    override func viewDidLoad() {
        super.viewDidLoad()
        coverView.isHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAllData),name: NSNotification.Name(rawValue:"ReloadAddress"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAllData),name: NSNotification.Name(rawValue:"ReloadOtherName"), object: nil)
        
        view1.isHidden = true
        view1Height.constant = 0
        groupChildLabel.isHidden = true
        addressesTableView.register(UINib(nibName: "A1Form2AddessCell", bundle: nil), forCellReuseIdentifier: "A1Form2AddessCell")
        addressesTableView.delegate = self
        addressesTableView.dataSource = self
        livedYes.setImage(UIImage(named: "uncheck.png"), for:.normal)
        livedNo.setImage(UIImage(named: "uncheck.png"), for:.normal)
        addressesView.isHidden = true
        addressViewHeight.constant = 0
        addressesTableView.reloadData()
        
        otherNameTable.register(UINib(nibName: "OtherNameCell", bundle: nil), forCellReuseIdentifier: "OtherNameCell")
        otherNameTable.delegate = self
        otherNameTable.dataSource = self
        otherNameView.isHidden = true
        otherNameViewHeight.constant = 0
        otherNameTable.reloadData()
        
        self.loadViewss()
        calledForAddressListUpdate = false
        
        fingerPrintType = ""
        otherNameType = ""
        livedOutSideNY = ""
        aliasNameTF.delegate = self
        delayWithSeconds(0.5) {
            self.getFormData()
        }
        
    }
    
    @objc func reloadAllData(){
        calledForAddressListUpdate = true
        self.getFormData()
    }
    func loadViewss(){
        firstNameTF.delegate = self
        middleNameTF.delegate = self
        lastNameTF.delegate = self
        addressTextView.delegate = self
        aptTF.delegate = self
        floorTF.delegate = self
        cityTF.delegate = self
        stateTF.delegate = self
        zipTF.delegate = self
        phoneTF.delegate = self
        emailTF.delegate = self
        dobTF.delegate = self
        self.changeNavigationTitle(object["FormName"].stringValue)
    }
    func getFormData()
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:self.view)
            
            let params =
                ["CandId" : UserDefaults.standard.object(forKey: "cID") as! String]  as [String : Any]
            print(params)
            ServerService.getA1FormData(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.getA1FormDataObject(response:))
            
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            
        }
        
    }
    
    // response from the server
    func getA1FormDataObject(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        self.A1FormObject = response as! JSON
        print("****** A1 Form Data is ************\n",A1FormObject)
        if A1FormObject["Status"].intValue == 1 {
            coverView.isHidden = true
            if calledForAddressListUpdate == true {
                if self.A1FormObject["A1SeriesAddressList"].arrayValue.count > 0 {
                    self.livedYes.setImage(UIImage(named: "check.png"), for:.normal)
                    self.livedNo.setImage(UIImage(named: "uncheck.png"), for:.normal)
                    self.addressesView.isHidden = false
                    self.addressViewHeight.constant = CGFloat(60 + (175 * self.A1FormObject["A1SeriesAddressList"].arrayValue.count))
                    self.addressesTableView.reloadData()
                    
                }
                else {
                    self.livedYes.setImage(UIImage(named: "uncheck.png"), for:.normal)
                    self.livedNo.setImage(UIImage(named: "uncheck.png"), for:.normal)
                    self.addressesView.isHidden = true
                    self.addressViewHeight.constant = 0
                    self.addressesTableView.reloadData()
                }
                
                if self.A1FormObject["OtherNameList"].arrayValue.count > 0 {
                    self.otherNameYes.setImage(UIImage(named: "check.png"), for:.normal)
                    self.otherNameNo.setImage(UIImage(named: "uncheck.png"), for:.normal)
                    otherNameView.isHidden = true
                    otherNameViewHeight.constant = CGFloat(60 + 40 + (50*self.A1FormObject["OtherNameList"].arrayValue.count))
                    self.otherNameTable.reloadData()
                }
                else {
                    self.otherNameYes.setImage(UIImage(named: "uncheck.png"), for:.normal)
                    self.otherNameNo.setImage(UIImage(named: "uncheck.png"), for:.normal)
                    otherNameView.isHidden = true
                    otherNameViewHeight.constant = 0
                    self.otherNameTable.reloadData()
                }
            }
            else {
                DispatchQueue.main.async {
                    self.revisionLabel.text = self.A1FormObject["VersionText"].stringValue
                    self.logoImageView.sd_setImage(with:URL(string:self.A1FormObject["ImagePath"].stringValue), placeholderImage: UIImage(named:"No_Image"))
                    self.mainHeadingLabel.text = self.A1FormObject["MainHeading"].stringValue
                    self.firstNameTF.text = self.A1FormObject["PersonalInfoDetail"]["FirstName"].stringValue
                    self.middleNameTF.text = self.A1FormObject["PersonalInfoDetail"]["Middle"].stringValue
                    self.lastNameTF.text = self.A1FormObject["PersonalInfoDetail"]["LastName"].stringValue
                    self.addressTextView.text = self.A1FormObject["PersonalInfoDetail"]["Address"].stringValue
                    self.aptTF.text = self.A1FormObject["PersonalInfoDetail"]["APT"].stringValue
                    self.floorTF.text = self.A1FormObject["PersonalInfoDetail"]["Floor"].stringValue
                    self.cityTF.text = self.A1FormObject["PersonalInfoDetail"]["City"].stringValue
                    self.stateTF.text = self.A1FormObject["PersonalInfoDetail"]["State"].stringValue
                    self.zipTF.text = self.A1FormObject["PersonalInfoDetail"]["Zip"].stringValue
                    self.phoneTF.text = self.A1FormObject["PersonalInfoDetail"]["Phone"].stringValue
                    self.emailTF.text = self.A1FormObject["PersonalInfoDetail"]["Email"].stringValue
                    self.dobTF.text = self.A1FormObject["PersonalInfoDetail"]["DOB"].stringValue
                    self.dateLabel.text = self.A1FormObject["Date"].stringValue
                }
            }
            // self.A1FormObject["DontAllowEdit"].boolValue = false
            
            if self.A1FormObject["DontAllowEdit"].boolValue {
                
                //Signed Form
                printButton.isHidden = false
                signdateLabel.text = "\(self.A1FormObject["SignDate"].stringValue)\nDate (month/day/year)"
                signatureLabel.text = "\(self.A1FormObject["Signature"].stringValue)\nApplicant’s Signature"
                pressToSignButton.isHidden = true
                firstNameTF.isEnabled = false
                middleNameTF.isEnabled = false
                lastNameTF.isEnabled = false
                addressTextView.isUserInteractionEnabled = false
                aptTF.isEnabled = false
                floorTF.isEnabled = false
                cityTF.isEnabled = false
                stateTF.isEnabled = false
                zipTF.isEnabled = false
                phoneTF.isEnabled = false
                emailTF.isEnabled = false
                dobTF.isEnabled = false
                self.livedYes.isEnabled = false
                self.livedNo.isEnabled = false
                self.otherNameYes.isEnabled = false
                self.otherNameNo.isEnabled = false
                self.identogo.isEnabled = false
                self.doebutton.isEnabled = false
                
                if self.A1FormObject["LeavedOutSideNY"].stringValue.count > 0 {
                    if self.A1FormObject["LeavedOutSideNY"].boolValue {
                        self.livedYes.setImage(UIImage(named: "check.png"), for:.normal)
                        self.livedNo.setImage(UIImage(named: "uncheck.png"), for:.normal)
                        if self.A1FormObject["A1SeriesAddressList"].arrayValue.count > 0 {
                            addAddressButton.isHidden = true
                            addaddressButtonHeight.constant = 0
                            self.addressesView.isHidden = false
                            self.addressViewHeight.constant = CGFloat(30 + (135 * self.A1FormObject["A1SeriesAddressList"].arrayValue.count))
                            self.addressesTableView.reloadData()
                        }
                        else {
                            self.addressesView.isHidden = true
                            self.addressViewHeight.constant = 0
                            self.addressesTableView.reloadData()
                        }
                    }
                    else {
                        self.addressesView.isHidden = true
                        self.addressViewHeight.constant = 0
                        self.addressesTableView.reloadData()
                        self.livedYes.setImage(UIImage(named: "uncheck.png"), for:.normal)
                        self.livedNo.setImage(UIImage(named: "check.png"), for:.normal)
                    }
                }
                else {
                    self.livedYes.setImage(UIImage(named: "uncheck.png"), for:.normal)
                    self.livedNo.setImage(UIImage(named: "uncheck.png"), for:.normal)
                }
                
                
                if self.A1FormObject["OtherName"].stringValue.count > 0 {
                    if self.A1FormObject["OtherName"].boolValue {
                        self.otherNameYes.setImage(UIImage(named: "check.png"), for:.normal)
                        self.otherNameNo.setImage(UIImage(named: "uncheck.png"), for:.normal)
                        if self.A1FormObject["OtherNameList"].arrayValue.count > 0 {
                            otherNameTableTrailing.constant = 120
                            otherNameTableTop.constant = 8
                            aliasNameTF.isHidden = true
                            addaliasNameButton.isHidden = true
                            otherNameView.isHidden = false
                            otherNameViewHeight.constant = CGFloat(20 + 40 + (50*self.A1FormObject["OtherNameList"].arrayValue.count))
                            self.otherNameTable.reloadData()
                        }
                        else {
                            otherNameTableTrailing.constant = 0
                            otherNameView.isHidden = true
                            otherNameViewHeight.constant = 0
                            self.otherNameTable.reloadData()
                        }
                    }
                    else {
                        otherNameTableTop.constant = 8
                        self.otherNameYes.setImage(UIImage(named: "uncheck.png"), for:.normal)
                        self.otherNameNo.setImage(UIImage(named: "check.png"), for:.normal)
                        otherNameView.isHidden = true
                        otherNameViewHeight.constant = 0
                        self.otherNameTable.reloadData()
                    }
                }
                
                else {
                    self.otherNameYes.setImage(UIImage(named: "uncheck.png"), for:.normal)
                    self.otherNameNo.setImage(UIImage(named: "uncheck.png"), for:.normal)
                }
                
                if self.A1FormObject["FingerPrintType"].stringValue.count > 0 {
                    if self.A1FormObject["FingerPrintType"].stringValue == "IdentoGo" {
                        self.identogo.setImage(UIImage(named: "check.png"), for:.normal)
                        self.doebutton.setImage(UIImage(named: "uncheck.png"), for:.normal)
                    }
                    else {
                        self.identogo.setImage(UIImage(named: "uncheck.png"), for:.normal)
                        self.doebutton.setImage(UIImage(named: "check.png"), for:.normal)
                    }
                }
                else {
                    self.identogo.setImage(UIImage(named: "uncheck.png"), for:.normal)
                    self.doebutton.setImage(UIImage(named: "uncheck.png"), for:.normal)
                }
                ifYesAddressLabel.text = ""
                ifYesOtherNamesLabels.text = ""
            }
            else {
                
                // NOt Signed Form
                
                //If Yes, list all known names (including maiden name, aliases, pseudonyms)
                //If Yes, add all out of state addresses where you lived in the past five years.
                printButton.isHidden = true
                ifYesAddressLabel.text = "If Yes, add all out of state addresses where you lived in the past five years"
                ifYesOtherNamesLabels.text = "If Yes, list all known names (including maiden name, aliases, pseudonyms)"
                signdateLabel.text = "Date"
                signatureLabel.text = "Signature"
                pressToSignButton.isHidden = false
                self.otherNameYes.setImage(UIImage(named: "uncheck.png"), for:.normal)
                self.otherNameNo.setImage(UIImage(named: "uncheck.png"), for:.normal)
                self.identogo.setImage(UIImage(named: "uncheck.png"), for:.normal)
                self.doebutton.setImage(UIImage(named: "uncheck.png"), for:.normal)
                firstNameTF.isEnabled = true
                middleNameTF.isEnabled = true
                lastNameTF.isEnabled = true
                addressTextView.isUserInteractionEnabled = true
                aptTF.isEnabled = true
                floorTF.isEnabled = true
                cityTF.isEnabled = true
                stateTF.isEnabled = true
                zipTF.isEnabled = true
                phoneTF.isEnabled = true
                emailTF.isEnabled = true
                dobTF.isEnabled = true
                self.livedYes.isEnabled = true
                self.livedNo.isEnabled = true
                self.otherNameYes.isEnabled = true
                self.otherNameNo.isEnabled = true
                self.identogo.isEnabled = true
                self.doebutton.isEnabled = true
                
                
                //Checking Lived OutSide
                if livedOutSideNY.count > 0 {
                    if livedOutSideNY == "1" {
                        self.livedYes.setImage(UIImage(named: "check.png"), for:.normal)
                        self.livedNo.setImage(UIImage(named: "uncheck.png"), for:.normal)
                        if self.A1FormObject["A1SeriesAddressList"].arrayValue.count > 0 {
                            self.addressesView.isHidden = false
                            self.addressViewHeight.constant = CGFloat(60 + (175 * self.A1FormObject["A1SeriesAddressList"].arrayValue.count))
                            self.addressesTableView.reloadData()
                        }
                        else {
                            self.addressesView.isHidden = false
                            self.addressViewHeight.constant = 60
                            self.addressesTableView.reloadData()
                        }
                    }
                    else {
                        self.livedYes.setImage(UIImage(named: "uncheck.png"), for:.normal)
                        self.livedNo.setImage(UIImage(named: "check.png"), for:.normal)
                        self.addressesView.isHidden = true
                        self.addressViewHeight.constant = 0
                        self.addressesTableView.reloadData()
                    }
                }
                else {
                    self.livedYes.setImage(UIImage(named: "uncheck.png"), for:.normal)
                    self.livedNo.setImage(UIImage(named: "uncheck.png"), for:.normal)
                    self.addressesView.isHidden = true
                    self.addressViewHeight.constant = 0
                    self.addressesTableView.reloadData()
                }
                //Checking Other Name
                if otherNameType.count > 0 {
                    if otherNameType == "1" {
                        self.otherNameYes.setImage(UIImage(named: "check.png"), for:.normal)
                        self.otherNameNo.setImage(UIImage(named: "uncheck.png"), for:.normal)
                        
                        if self.A1FormObject["OtherNameList"].arrayValue.count > 0 {
                            otherNameTableTrailing.constant = 8
                            otherNameView.isHidden = false
                            otherNameTableTop.constant = 50
                            aliasNameTF.isHidden = false
                            addaliasNameButton.isHidden = false
                            otherNameViewHeight.constant = CGFloat(60 + 40 + (50*self.A1FormObject["OtherNameList"].arrayValue.count))
                            self.otherNameTable.reloadData()
                        }
                        else {
                            otherNameTableTrailing.constant = 8
                            aliasNameTF.isHidden = false
                            otherNameView.isHidden = false
                            otherNameViewHeight.constant = 60
                            self.otherNameTable.reloadData()
                        }
                    }
                    else {
                        self.otherNameYes.setImage(UIImage(named: "uncheck.png"), for:.normal)
                        self.otherNameNo.setImage(UIImage(named: "check.png"), for:.normal)
                        otherNameView.isHidden = true
                        otherNameViewHeight.constant = 0
                        self.otherNameTable.reloadData()
                    }
                }
                else {
                    self.otherNameYes.setImage(UIImage(named: "uncheck.png"), for:.normal)
                    self.otherNameNo.setImage(UIImage(named: "uncheck.png"), for:.normal)
                    otherNameView.isHidden = true
                    otherNameViewHeight.constant = 0
                    self.otherNameTable.reloadData()
                }
                
                //Checking FingerPrint
                if fingerPrintType.count > 0 {
                    if fingerPrintType == "IdentoGo" {
                        self.identogo.setImage(UIImage(named: "check.png"), for:.normal)
                        self.doebutton.setImage(UIImage(named: "uncheck.png"), for:.normal)
                    }
                    else {
                        self.identogo.setImage(UIImage(named: "uncheck.png"), for:.normal)
                        self.doebutton.setImage(UIImage(named: "check.png"), for:.normal)
                    }
                }
                else {
                    self.identogo.setImage(UIImage(named: "uncheck.png"), for:.normal)
                    self.doebutton.setImage(UIImage(named: "uncheck.png"), for:.normal)
                }
            }
        }
        else {
            var messagee = String()
            if A1FormObject["Message"].stringValue.count > 0 {
                messagee = A1FormObject["Message"].stringValue
            }
            else {
                messagee = "Something is not right here try again later"
            }
            ServerService.ShowAlertMessage(ErrorMessage:"", title: messagee, view:self)
        }
        
    }
    //MARK:- CheckBox Actions
    @IBAction func yesLivedOutsideNY(_ sender: UIButton) {
        livedOutSideNY = "1"
        livedYes.setImage(UIImage(named: "check.png"), for:.normal)
        livedNo.setImage(UIImage(named: "uncheck.png"), for:.normal)
        addressesView.isHidden = false
        addressViewHeight.constant = CGFloat(60 + (175 * A1FormObject["A1SeriesAddressList"].arrayValue.count))
        addressesTableView.reloadData()
    }
    @IBAction func notLivedOutsideNY(_ sender: UIButton) {
        if A1FormObject["A1SeriesAddressList"].arrayValue.count > 0 {
            
            ServerService.ShowAlertMessage(ErrorMessage:"", title: "Outside of New York State in the past five years exists below, can you please delete first", view:self)
            
            livedOutSideNY = "0"
            livedYes.setImage(UIImage(named: "uncheck.png"), for:.normal)
            livedNo.setImage(UIImage(named: "check.png"), for:.normal)
            addressesView.isHidden = false
            addressViewHeight.constant = CGFloat(60 + (175 * A1FormObject["A1SeriesAddressList"].arrayValue.count))
            addressesTableView.reloadData()
        }
        else {
            livedOutSideNY = "0"
            livedYes.setImage(UIImage(named: "uncheck.png"), for:.normal)
            livedNo.setImage(UIImage(named: "check.png"), for:.normal)
            addressesView.isHidden = true
            addressViewHeight.constant = 0
        }
        
    }
    
    
    @IBAction func otherNameYesClicked(_ sender: UIButton) {
        otherNameType = "1"
        otherNameYes.setImage(UIImage(named: "check.png"), for:.normal)
        otherNameNo.setImage(UIImage(named: "uncheck.png"), for:.normal)
        otherNameView.isHidden = false
        if self.A1FormObject["OtherNameList"].arrayValue.count > 0 {
            otherNameViewHeight.constant = CGFloat(60 + 40 + (50*self.A1FormObject["OtherNameList"].arrayValue.count))
        }
        else {
            otherNameViewHeight.constant = 40
        }
        
    }
    
    @IBAction func otherNameNoClicked(_ sender: UIButton) {
        otherNameNo.setImage(UIImage(named: "check.png"), for:.normal)
        otherNameYes.setImage(UIImage(named: "uncheck.png"), for:.normal)
        otherNameView.isHidden = true
        otherNameViewHeight.constant = 0
        otherNameType = "0"
    }
    
    @IBAction func identogoClicked(_ sender: UIButton) {
        fingerPrintType = "IdentoGo"
        identogo.setImage(UIImage(named: "check.png"), for:.normal)
        doebutton.setImage(UIImage(named: "uncheck.png"), for:.normal)
    }
    
    @IBAction func doeClicked(_ sender: UIButton) {
        fingerPrintType = "DOE"
        doebutton.setImage(UIImage(named: "check.png"), for:.normal)
        identogo.setImage(UIImage(named: "uncheck.png"), for:.normal)
    }
    //MARK:- Add Address Clicked
    @IBAction  func addTapped(_ button: UIButton) {
        let window = UIApplication.shared.keyWindow!
        let formView = Bundle.main.loadNibNamed("AddAddress", owner: nil, options: nil)![0] as! AddAddress
        formView.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
        formView.isEdit = false
        formView.isFromSCRConsent = false
        formView.warningMessageText = ""
        formView.loadView()
        //        window.addSubview(formView)
        //        window.bringSubview(toFront:formView)
        window.makeKeyAndVisible()
        UIApplication.getTopMostViewController()!.view.addSubview(formView)
        UIApplication.getTopMostViewController()!.view.bringSubview(toFront:formView)
    }
    
    @IBAction func instructionsInfoClicked(_ sender: UIButton) {
        
        self.loadAlertPopupWithObject(4, messageText: self.A1FormObject["InfoText"].stringValue.htmlToAttributedString!.string, popKeyToSend: "", apiCallrequired: false)
    }
    
    
    func loadAlertPopupWithObject(_ viewStatus: Int, messageText: String, popKeyToSend: String, apiCallrequired: Bool)
    {
        let window = UIApplication.shared.keyWindow!
        
        let formView = Bundle.main.loadNibNamed("AlertPopView", owner: nil, options: nil)![0] as! AlertPopView
        
        formView.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
        formView.viewStatus = viewStatus
        formView.popKeyToSend = popKeyToSend
        formView.messageText = messageText
        formView.loadForm()
        formView.toCOntroller = UIApplication.getTopMostViewController()!
        //        formView.popAlertDelegate = self
        formView.apiCallrequired = apiCallrequired
        window.addSubview(formView)
        window.bringSubview(toFront:formView)
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
            self.dobTF.resignFirstResponder()
        }
        
    }
    
    func selectedDate(date: String, type: Int) {
        dobTF.text = date
    }
    
    //MARK:- UITableView Delegate & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == addressesTableView {
            return A1FormObject["A1SeriesAddressList"].arrayValue.count
        }
        else {
            return A1FormObject["OtherNameList"].arrayValue.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == addressesTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "A1Form2AddessCell", for: indexPath) as! A1Form2AddessCell
            cell.selectionStyle = .none
            if A1FormObject["A1SeriesAddressList"].arrayValue.count > 0 {
                DispatchQueue.main.async {
                    //cell.editButton.isHidden = true
                    cell.editButton.tag = indexPath.row
                    cell.deleteButton.tag  = indexPath.row
                    if self.A1FormObject["DontAllowEdit"].boolValue {
                        cell.editButton.isHidden = true
                        cell.deleteButton.isHidden = true
                    }
                    else {
                        cell.editButton.isHidden = false
                        cell.deleteButton.isHidden = false
                    }
                    cell.editButton.addTarget(self, action: #selector(self.editAddress(_:)), for: .touchUpInside)
                    cell.deleteButton.addTarget(self, action: #selector(self.deleteAddress(_:)), for: .touchUpInside)
                    cell.addressTitleLabel.text = "Previous Street Address :"
                    cell.addressLabel.text = self.A1FormObject["A1SeriesAddressList"][indexPath.row]["Address"].stringValue
                    cell.aptLabel.text = self.A1FormObject["A1SeriesAddressList"][indexPath.row]["APT"].stringValue
                    cell.cityLabel.text = self.A1FormObject["A1SeriesAddressList"][indexPath.row]["City"].stringValue
                    cell.stateLabel.text = self.A1FormObject["A1SeriesAddressList"][indexPath.row]["State"].stringValue
                    cell.zipLabel.text = self.A1FormObject["A1SeriesAddressList"][indexPath.row]["Zip"].stringValue
                    cell.fromLabel.text = self.A1FormObject["A1SeriesAddressList"][indexPath.row]["FromDate"].stringValue
                    cell.toLabel.text = self.A1FormObject["A1SeriesAddressList"][indexPath.row]["ToDate"].stringValue
                }
                
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OtherNameCell") as! OtherNameCell
            cell.selectionStyle = .none
            cell.editButton.tag = indexPath.row
            cell.deleteButton.tag = indexPath.row
            cell.editButton.addTarget(self, action: #selector(self.editOtherName(_:)), for: .touchUpInside)
            cell.deleteButton.addTarget(self, action: #selector(self.deleteOtherName(_:)), for: .touchUpInside)
            cell.nameTF.isEnabled = false
            cell.actionLabel.isHidden = true
            cell.editButton.isHidden = false
            cell.deleteButton.isHidden = false
            
            if A1FormObject["OtherNameList"].arrayValue.count > 0 {
                cell.nameTF.font = UIFont.systemFont(ofSize: 14)
                cell.nameTF.text = A1FormObject["OtherNameList"][indexPath.row]["Name"].stringValue
            }
            if self.A1FormObject["DontAllowEdit"].boolValue {
                cell.nameTF.textAlignment = .center
                cell.actionLabel.isHidden = true
                cell.editButton.isHidden = true
                cell.deleteButton.isHidden = true
                cell.centerLabel.isHidden = true
                cell.nameTFTrailing.constant = 8
            }
            else {
                cell.nameTF.textAlignment = .left
                cell.actionLabel.isHidden = true
                cell.editButton.isHidden = false
                cell.deleteButton.isHidden = false
                cell.centerLabel.isHidden = false
                cell.nameTFTrailing.constant = 140
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == addressesTableView {
            if self.A1FormObject["DontAllowEdit"].boolValue {
                //Signed Form
                return 135
            }
            else {
                return 175
            }
        }
        else {
            return 50
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == addressesTableView {
            return 0
        }
        else {
            if self.A1FormObject["OtherNameList"].arrayValue.count > 0 {
                return 40
            }
            else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OtherNameCell") as! OtherNameCell
        cell.selectionStyle = .none
        cell.nameTF.isEnabled = false
        cell.editButton.isHidden = true
        cell.deleteButton.isHidden = true
        cell.nameTF.text = "Name"
        cell.nameTF.font = UIFont.boldSystemFont(ofSize: 14)
        if self.A1FormObject["DontAllowEdit"].boolValue {
            cell.nameTF.textAlignment = .center
            cell.actionLabel.isHidden = true
            cell.editButton.isHidden = true
            cell.deleteButton.isHidden = true
            cell.centerLabel.isHidden = true
            cell.nameTFTrailing.constant = 8
        }
        else {
            cell.nameTF.textAlignment = .left
            cell.actionLabel.isHidden = false
            cell.editButton.isHidden = true
            cell.deleteButton.isHidden = true
            cell.centerLabel.isHidden = false
            cell.nameTFTrailing.constant = 140
        }
        return cell
    }
    
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    //MARK:- TextField Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == phoneTF
        {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = formattedNumber(number: newString)
            
            return false
        }
        else if textField == aliasNameTF {
            let components = string.components(separatedBy: allowedCharacters)
            let filtered = components.joined(separator: "")
            
            if string == filtered {
                
                return true
                
            } else {
                
                return false
            }
        }
        else {
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == dobTF {
            self.view.endEditing(true)
            textField.resignFirstResponder()
            self.showCalender(type: 0, HeadingText: "Select Date of Birth", dateToSelect: dobTF.text!)
            return false
        }
        else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == firstNameTF || textField == lastNameTF || textField == emailTF || textField == phoneTF || textField == dobTF {
            return true
        }
        else {
            return false
        }
    }
    
    func formattedNumber(number: String) -> String
    {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "(XXX) XXX-XXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    //MARK:- Edit/Delete Address
    @objc func editAddress(_ sender: UIButton) {
        let window = UIApplication.shared.keyWindow!
        let formView = Bundle.main.loadNibNamed("AddAddress", owner: nil, options: nil)![0] as! AddAddress
        formView.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
        formView.dataObject = A1FormObject["A1SeriesAddressList"][sender.tag]
        formView.isEdit = true
        formView.isFromSCRConsent = false
        formView.warningMessageText = ""
        formView.loadView()
        //        window.addSubview(formView)
        //        window.bringSubview(toFront:formView)
        window.makeKeyAndVisible()
        UIApplication.getTopMostViewController()!.view.addSubview(formView)
        UIApplication.getTopMostViewController()!.view.bringSubview(toFront:formView)
        
    }
    
    @objc func deleteAddress(_ sender: UIButton) {
        let addressID = A1FormObject["A1SeriesAddressList"][sender.tag]["AddressId"].stringValue
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:self.view)
            
            let params =
                ["CandId" : UserDefaults.standard.object(forKey: "cID") as! String,
                 "AddressId": addressID]  as [String : Any]
            print(params)
            ServerService.DeleteA1Address(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.DeleteA1AddressResponseObject(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
    }
    
    func DeleteA1AddressResponseObject(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        let responseObject = response as! JSON
        print("****** A1 Delete Address is ************\n",responseObject)
        if responseObject["Status"].intValue == 1 {
            //            let alert = UIAlertController(title:responseObject["Message"].stringValue, message: "", preferredStyle: UIAlertControllerStyle.alert)
            //            let ok = UIAlertAction(title: "Ok",
            //                                   style: .default) { (action: UIAlertAction!) -> Void in
            //                self.calledForAddressListUpdate = true
            //                self.getFormData()
            //            }
            //            alert.addAction(ok)
            //            (UIApplication.getTopMostViewController())!.present(alert, animated:true, completion:nil)
            self.calledForAddressListUpdate = true
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
    
    
    //MARK:- AddAlaisName
    
    @IBAction func addAlaisNameClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if ConnectionCheck.isConnectedToNetwork()
        {
            if (aliasNameTF.text?.replacingOccurrences(of: " ", with: "").count)! > 0 {
                ServerService.showActivityIndicatory(uiView:(UIApplication.getTopMostViewController()?.view)!)
                let params =
                    ["CandId" : UserDefaults.standard.object(forKey: "cID") as! String,"Name":aliasNameTF.text!]  as [String : Any]
                print(params)
                ServerService.AlaisNameInsert((UIApplication.getTopMostViewController())!, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.addAlaisNameObject(response:))
            }
            else {
                ServerService.ShowAlertMessage(ErrorMessage:"", title: "Please enter alias name", view:(UIApplication.getTopMostViewController())!)
            }
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:(UIApplication.getTopMostViewController())!)
        }
    }
    // response from the server
    func addAlaisNameObject(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        let responseObject = response as! JSON
        print("****** Add AlaisName Response is ************\n",responseObject)
        if responseObject["Status"].intValue == 1 {
            aliasNameTF.text = ""
            self.calledForAddressListUpdate = true
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
    
    @objc func editOtherName(_ sender: UIButton) {
        let window = UIApplication.shared.keyWindow!
        let formView = Bundle.main.loadNibNamed("OtherNameEditView", owner: nil, options: nil)![0] as! OtherNameEditView
        formView.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
        formView.dataObject = A1FormObject["OtherNameList"][sender.tag]
        formView.loadView()
        //        window.addSubview(formView)
        //        window.bringSubview(toFront:formView)
        window.makeKeyAndVisible()
        UIApplication.getTopMostViewController()!.view.addSubview(formView)
        UIApplication.getTopMostViewController()!.view.bringSubview(toFront:formView)
        
    }
    
    @objc func deleteOtherName(_ sender: UIButton) {
        let nameID = A1FormObject["OtherNameList"][sender.tag]["NameId"].stringValue
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:self.view)
            
            let params =
                ["CandId" : UserDefaults.standard.object(forKey: "cID") as! String,
                 "NameId": nameID]  as [String : Any]
            print(params)
            ServerService.AliasNameDelete(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.DeleteOtherNameResponseObject(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
    }
    
    func DeleteOtherNameResponseObject(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        let responseObject = response as! JSON
        print("****** A1 Delete Address is ************\n",responseObject)
        if responseObject["Status"].intValue == 1 {
            self.calledForAddressListUpdate = true
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
    
    //MARK:- Catching the device orentation
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            
        case .landscapeLeft:
            text="LandscapeLeft"
            
        case .landscapeRight:
            text="LandscapeRight"
            
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
    }
    
    func changeNavigationTitle(_ titleStr: String) {
        let tlabel = UILabel()
        tlabel.text = titleStr
        tlabel.textColor = UIColor.white
        tlabel.font = UIFont.systemFont(ofSize:15)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.textAlignment = .center
        tlabel.numberOfLines = 0
        tlabel.minimumScaleFactor = 0.5
        self.navigationItem.titleView = tlabel
    }
    //MARK:- Press To Sign Action
    @IBAction func pressToSignClicked(_ sender: UIButton) {
        if otherNameType.count == 0{
            ServerService.ShowAlertMessage(ErrorMessage:"", title: "Have you ever been known by any other name? Please confirm", view:self)
        }
        
        else if otherNameType == "1" && A1FormObject["OtherNameList"].count == 0 {
            ServerService.ShowAlertMessage(ErrorMessage:"", title: "Please list all known names (including maiden name, aliases, pseudonyms)", view:self)
        }
        else if livedOutSideNY.count == 0 {
            ServerService.ShowAlertMessage(ErrorMessage:"", title: "Have you ever lived outside of New York State in the past five years? Please Confirm", view:self)
        }
        else if livedOutSideNY == "1" && A1FormObject["A1SeriesAddressList"].count == 0 {
            ServerService.ShowAlertMessage(ErrorMessage:"", title: "Please list all out of state addresses where you lived in the past five years", view:self)
        }
       else if livedOutSideNY == "0" && A1FormObject["A1SeriesAddressList"].arrayValue.count > 0 {
            ServerService.ShowAlertMessage(ErrorMessage:"", title: "Outside of New York State in the past five years exists below, can you please delete first", view:self)
        }
        else {
            self.callFinalService()
        }
    }
    
    func callFinalService() {
        otherNamesArray.removeAll()
        addressArray.removeAll()
        
        let personalObject:[String:String] = [ "Message" : "",
                                               "Floor" : floorTF.text!,
                                               "LastName" : lastNameTF.text!,
                                               "State" : stateTF.text!,
                                               "Zip" : zipTF.text!,
                                               "Status" : "",
                                               "Email" : emailTF.text!,
                                               "Name" : A1FormObject["PersonalInfoDetail"]["Name"].stringValue,
                                               "City" : cityTF.text!,
                                               "Phone" : phoneTF.text!,
                                               "ToDate" : "",
                                               "Address" : addressTextView.text!,
                                               "CandidateId" : UserDefaults.standard.object(forKey: "cID") as! String,
                                               "APT" : aptTF.text!,
                                               "FirstName" : firstNameTF.text!,
                                               "DOB" : dobTF.text!,
                                               "FromDate" : "",
                                               "Middle":middleNameTF.text!]
        
        let GroupChildCare:[String:String] = [ "AssistantTeacher" : "",
                                               "Owner" : "",
                                               "BoardMember" : "",
                                               "VolunteerStudent" : "",
                                               "Other" : "",
                                               "EducationDirector" : "",
                                               "GroupTeacher" : "",
                                               "MedicalStaff" : "",
                                               "OtherText" : ""]
        
        for i in 0..<A1FormObject["OtherNameList"].arrayValue.count {
            let obj:[String:String] = [  "Status" : A1FormObject["OtherNameList"][i]["Status"].stringValue,
                                         "Name" : A1FormObject["OtherNameList"][i]["Name"].stringValue,
                                         "NameId" : A1FormObject["OtherNameList"][i]["NameId"].stringValue,
                                         "Message" : A1FormObject["OtherNameList"][i]["Message"].stringValue,
                                         "CandId" : A1FormObject["OtherNameList"][i]["CandId"].stringValue]
            otherNamesArray.append(obj)
        }
        
        for i in 0..<A1FormObject["A1SeriesAddressList"].arrayValue.count {
            let obj:[String:String] = [
                "Address" : A1FormObject["A1SeriesAddressList"][i]["Address"].stringValue,
                "Status" : A1FormObject["A1SeriesAddressList"][i]["Status"].stringValue,
                "Zip" : A1FormObject["A1SeriesAddressList"][i]["Zip"].stringValue,
                "State" : A1FormObject["A1SeriesAddressList"][i]["State"].stringValue,
                "AddressId" : A1FormObject["A1SeriesAddressList"][i]["AddressId"].stringValue,
                "FromDate" : A1FormObject["A1SeriesAddressList"][i]["FromDate"].stringValue,
                "CandId" : A1FormObject["A1SeriesAddressList"][i]["CandId"].stringValue,
                "Message" : A1FormObject["A1SeriesAddressList"][i]["Message"].stringValue,
                "ToDate" : A1FormObject["A1SeriesAddressList"][i]["ToDate"].stringValue,
                "City" : A1FormObject["A1SeriesAddressList"][i]["City"].stringValue ]
            addressArray.append(obj)
        }
        
        
        let params:[String:Any] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,
                                   "ProgramName":A1FormObject["ProgramName"].stringValue,
                                   "PermitDCID":A1FormObject["PermitDCID"].stringValue,
                                   "Date":A1FormObject["Date"].stringValue,
                                   "PersonalInfoDetail":personalObject,
                                   "ApplicantName":A1FormObject["PersonalInfoDetail"]["Name"].stringValue,
                                   "GroupChildCare":GroupChildCare,
                                   "A1SeriesAddressList":addressArray,
                                   "OtherNameList":otherNamesArray,
                                   "OtherName":otherNameType,
                                   "LeavedOutSideNY":livedOutSideNY,
                                   "FingerPrintType":fingerPrintType,
                                   "AppVersion":"IOS,\(Constants.APP_VERSION)"]
        //  print(params)
        Constants.A1insertParams = params
        
        //        let signView = Bundle.main.loadNibNamed("SignView", owner: nil, options: nil)![0] as! SignView
        //        signView.frame = CGRect(x:0,y:0, width:self.view.bounds.width, height:self.view.bounds.height)
        //        signView.setUp()
        //        signView.object = object
        //        signView.signDelegate = self
        //        self.view.addSubview(signView)
        //        self.view.bringSubview(toFront:signView)
        
        let window = UIApplication.shared.keyWindow!
        let formView = Bundle.main.loadNibNamed("A1SignView", owner: nil, options: nil)![0] as! A1SignView
        formView.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
        formView.setUp()
        formView.object = object
        formView.signDelegate = self
        window.makeKeyAndVisible()
        UIApplication.getTopMostViewController()!.view.addSubview(formView)
        UIApplication.getTopMostViewController()!.view.bringSubview(toFront:formView)
        
        
    }
    
    func getPrintFormData()
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:self.view)
            
            let params =
                ["CandID" : UserDefaults.standard.object(forKey: "cID") as! String,"FormCode":"A1_SeriesPDF"]  as [String : Any]
            print(params)
            ServerService.GeneratePrintPDF(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.getA1PrintFormDataObject(response:))
            
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            
        }
        
    }
    // response from the server
    func getA1PrintFormDataObject(response:AnyObject)->()
    {
        ServerService.hideProgressView()
        let printObject = response as! JSON
        print("****** PDF Data is ************\n",printObject)
        if printObject["PDFFileName"].stringValue.count > 5 {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let privacyViewController = mainStoryboard.instantiateViewController(withIdentifier: "pVC") as! PrivacyPolicyViewController
            privacyViewController.link = printObject["PDFFileName"].stringValue
            privacyViewController.headerText = object["FormName"].stringValue
            Constants.iSFormOkRequired = false
            privacyViewController.isPush = true
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
    
    @IBAction func printButton(_ sender: UIButton) {
        self.getPrintFormData()
    }
    
}

extension A1FormController:a1signatureDelagte
{
    func signatureStatus(success: Bool) {
        print("success")
        if fromSideMenu == true {
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
    
}
