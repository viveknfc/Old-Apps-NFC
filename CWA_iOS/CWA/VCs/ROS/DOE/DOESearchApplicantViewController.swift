//
//  DOESearchApplicantViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 03/04/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON

class DOESearchApplicantViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var applicantTableView: UITableView!
    @IBOutlet weak var searchtextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var SearchDataView: UIView!
    @IBOutlet weak var NoteView: UIView!
    @IBOutlet var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var NoteViewHeightConstraint: NSLayoutConstraint!
    var isFromSummaryPage = false

    var isSearching = false
    var existingApplicantList = NSMutableArray()
    var searchedApplicantList = NSMutableArray()
    var AddApplicantDuplicateParam = NSDictionary()
    var isFromAddApplicantPage = false
    var isSuccessfullyAlert = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if isFromAddApplicantPage == true{
            SearchDataView.isHidden = true
            NoteView.isHidden = false
            tableViewTopConstraint.constant = NoteViewHeightConstraint.constant + 66 + 20
            self.view.layoutIfNeeded()
        }else{
            SearchDataView.isHidden = false
            NoteView.isHidden = true
            tableViewTopConstraint.constant = 93 + 40 + 20
            self.view.layoutIfNeeded()
            
        }
        applicantTableView.tableFooterView = UIView()
        noDataView.backgroundColor = UIColor(hexString:warning_background_Color)
        lblNoData.textColor = UIColor(hexString:warning_Color)
        
        noDataView.isHidden = true
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(keyboardDoneBtnTapped))]
        toolBar.sizeToFit()
        searchtextField.inputAccessoryView = toolBar
        
        self.getExistingConsultantsListData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFromAddApplicantPage == true{
            self.titlelbl.text = "Insert applicant"
        }else{
            self.titlelbl.text = "Search applicant"

        }
    }
    @objc func keyboardDoneBtnTapped(sender: UIButton){
        self.view.endEditing(true)
    }
    @IBAction func searchButtonTapped(_ sender: UIButton){
     searchtextField.endEditing(true)
        if (searchtextField.text?.count)! > 0{
            isSearching = true
            self.getSearchedApplicantData(SearchString: searchtextField.text!)
        }
    }
    @IBAction func continueButtonTapped(_ sender: UIButton){
        self.DOE_Add_Applicant_ServerCall()
    }
    @objc func selectBtnTapped(_ sender: UIButton){
        
        let senderPosition  = sender.convert(CGPoint.zero, to: applicantTableView)
        
        let indexPath =  applicantTableView.indexPathForRow(at:senderPosition)
        
        ////SAVE MODEL IN DEFAULTS ///
        var applicantObj = Applicant.init(CandidateId: "0", ApplicantId: "", Name: "", ConsultantType: "", Email: "", Address: "", City: "", State: "", Zip: "", SSN: "", isSelected: "",appliType: "",ApplicationId:  "0",NewApplicant:  "",extraCandId: "0")
       
        if isSearching == true {
            applicantObj = searchedApplicantList[(indexPath?.row)!] as! Applicant
            if isFromAddApplicantPage == true{
                applicantObj.extraCandId = applicantObj.CandidateId
                if Int(applicantObj.extraCandId!) == 0{
                    applicantObj.extraCandId = applicantObj.ApplicantId
                }
              }
        }else{
            applicantObj = existingApplicantList[(indexPath?.row)!] as! Applicant
            
            if isFromAddApplicantPage == true{
                applicantObj.extraCandId = applicantObj.CandidateId
                if Int(applicantObj.extraCandId!) == 0{
                applicantObj.extraCandId = applicantObj.ApplicantId
                }
              }
        }
        
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: applicantObj)
        userDefaults.set(encodedData, forKey: "DoeApplicantModel")
        userDefaults.synchronize()
        
        
        ////
        //pushToChooseList
        self.pushToDOEChooseConsultantReportToViewController()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching == true {
            return searchedApplicantList.count
            
        }else{
            return existingApplicantList.count
        }
 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:SearchTableViewCell = applicantTableView.dequeueReusableCell(withIdentifier: "DOESearchCellIdentifier" ) as! SearchTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.lblNamePlaceholder.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.lblYTDHRPlaceholder.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.lblDatePlaceholder.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.lblPositionPlaceholder.textColor  = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
        var applicantObj = Applicant.init(CandidateId: "0", ApplicantId: "", Name: "", ConsultantType: "", Email: "", Address: "", City: "", State: "", Zip: "", SSN: "", isSelected: "",appliType: "",ApplicationId:  "0",NewApplicant:  "",extraCandId: "0")
        
        if isSearching == true {
            applicantObj = searchedApplicantList[indexPath.row] as! Applicant
            
        }else{
            applicantObj = existingApplicantList[indexPath.row] as! Applicant
            
        }
        
        cell.lblNameValue.text = applicantObj.Name
        cell.lblPositionvalue.text = applicantObj.Email
        cell.lblYTDHRValue.text = applicantObj.Address
        cell.lblDateValue.text = String(format:"%@,%@,%@",applicantObj.City!,applicantObj.State!,applicantObj.Zip!)
        
        cell.checkButton.removeTarget(self, action:#selector(self.selectBtnTapped), for:.touchUpInside)
        cell.checkButton.addTarget(self, action:#selector(self.selectBtnTapped), for:.touchUpInside)
        
        
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Server Call
    func getSearchedApplicantData(SearchString: String) {
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            
            let defaults = UserDefaults.standard
            
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let UserName = String(format:"%@", UserDefaults.standard.string(forKey: "UserName")!)
            
            let params :[String:String] = ["ContactId":ContactId,"ClientID":clientID,"UserName": UserName,"SearchKey": SearchString]
            
            print(params)
            searchedApplicantList.removeAllObjects()
            RestAPI.SearchForReturningConsultant_Call(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getSearchedApplicantResponse(response:))
        }else{
            isSuccessfullyAlert = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    func getExistingConsultantsListData() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            
            let defaults = UserDefaults.standard
            
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let UserName = String(format:"%@", UserDefaults.standard.string(forKey: "UserName")!)
            
            let params :[String:String] = ["ContactId":ContactId,"ClientID":clientID,"UserName": UserName]
            
            print(params)
            searchedApplicantList.removeAllObjects()

            RestAPI.SearchForExistingConsultant_Call(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getExistingConsultantsResponse(response:))
        }else{
            isSuccessfullyAlert = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
    }
    func getExistingConsultantsResponse(response:AnyObject)->()
    {
        print(response)
        JustHUD.shared.hide()
        if response is String{
            isSuccessfullyAlert = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                let dataArray = object["ConsultantsList"].array
                
                for dict in dataArray! {
                    
                    let applicantObj = Applicant.init(CandidateId: dict["CandidateId"].stringValue, ApplicantId: dict["ApplicantId"].stringValue, Name: dict["Name"].stringValue, ConsultantType: dict["ConsultantType"].stringValue, Email: dict["Email"].stringValue, Address: dict["Address"].stringValue, City: dict["City"].stringValue, State: dict["State"].stringValue, Zip: dict["Zip"].stringValue,SSN: dict["SSN"].stringValue , isSelected: "0",appliType: "1",ApplicationId:  dict["ApplicationId"].stringValue ,NewApplicant:  "0",extraCandId: "0")
                    
                    existingApplicantList.add(applicantObj)
                }
                applicantTableView.reloadData()
            }else{
                isSuccessfullyAlert = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
            
        }
    }
    func getSearchedApplicantResponse(response:AnyObject)->()
    {
        print(response)
        JustHUD.shared.hide()
        
        if response is String{
            self.noDataView.isHidden = false

            isSuccessfullyAlert = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                
                let dataArray = object["ConsultantsList"].array
                
                for dict in dataArray! {
                    
                    let applicantObj = Applicant.init(CandidateId: dict["CandidateId"].stringValue, ApplicantId: dict["ApplicantId"].stringValue, Name: dict["Name"].stringValue, ConsultantType: dict["ConsultantType"].stringValue, Email: dict["Email"].stringValue, Address: dict["Address"].stringValue, City: dict["City"].stringValue, State: dict["State"].stringValue, Zip: dict["Zip"].stringValue,SSN: dict["SSN"].stringValue, isSelected: "0",appliType: "1",ApplicationId:  dict["ApplicationId"].stringValue,NewApplicant:  "0",extraCandId: "0")
                    
                    searchedApplicantList.add(applicantObj)
                }
                if searchedApplicantList.count  == 0{
                    self.noDataView.isHidden = false
                }else{
                    self.noDataView.isHidden = true
                }
                applicantTableView.reloadData()
            }else{
                self.noDataView.isHidden = false
                isSuccessfullyAlert = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                applicantTableView.reloadData()

            }
        }
        
    }
    func DOE_Add_Applicant_ServerCall(){
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            
            print(AddApplicantDuplicateParam)
            RestAPI.DOE_AddDuplicateApplicant_Call(self, params: AddApplicantDuplicateParam as! [String : String], method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))

        }else{
            isSuccessfullyAlert = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    func getResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        self.view.endEditing(true)
        print(response)
        if response is String{
            //            lblNoData.isHidden = false
            //            self.ShowAlertMessage(message: response as! String, title: "")
            isSuccessfullyAlert = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            var message = object["Message"].stringValue
            
            if object["MessageStatus"].intValue == 1
            {
                if message.count == 0 {
                    
                    message = "Applicant added successfully"
                    
                }
                
                let Name = String(format:"%@ %@ %@",object["FirstName"].stringValue,object["MiddleName"].stringValue,object["LastName"].stringValue)
                var ApplicationId = object["ApplicationId"].stringValue
                if ApplicationId.count == 0{
                ApplicationId = "0"
                }
                
                let applicantObj = Applicant.init(CandidateId: object["CandidateId"].stringValue, ApplicantId: object["ApplicationId"].stringValue, Name:  Name , ConsultantType: "", Email: object["Email"].stringValue, Address: object["Address"].stringValue, City: object["City"].stringValue, State: object["State"].stringValue, Zip: object["Zip"].stringValue,SSN: object["SSN"].stringValue, isSelected: "0",appliType: object["Type"].stringValue,ApplicationId:  ApplicationId,NewApplicant:  object["NewApplicant"].stringValue,extraCandId: object["ApplicationId"].stringValue)
                
                let userDefaults = UserDefaults.standard
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: applicantObj)
                userDefaults.set(encodedData, forKey: "DoeApplicantModel")
                userDefaults.synchronize()

                isSuccessfullyAlert = true
                self.pushToDOEChooseConsultantReportToViewController()
//                     self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
             }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                isSuccessfullyAlert = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
    }
    // MARK: - Navigation
    func pushToDOEChooseConsultantReportToViewController(){
        var isControllerExists = false
        var vc = UIViewController()
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOEChooseConsultantReportToViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    vc = viewController
                    break
                }
            }
        }
        //the data should be refreshed so isfromsummarypage = false
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOEChooseConsultantReportToSegue") as! DOEChooseConsultantReportToViewController
            nextViewController.isFromSummaryPage = false
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
                 let nextVC:DOESchduleViewController = vc as! DOESchduleViewController
                nextVC.isFromSummaryPage = false
                self.navigationController?.popToViewController(nextVC, animated: true)
         }
    }
    @IBAction override func okButtonTapped(_ sender: Any) {
         self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
        if isSuccessfullyAlert == true{
            self.pushToDOEChooseConsultantReportToViewController()
        }
    }
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
