//
//  EmpHistoryViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 04/12/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON
import Foundation

class EmpHistoryViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    var isForSchoolProfessional = false
    var isForHospitality = false
    var isForOffice = false
    var isForOCC = false
    
    @IBOutlet weak var lblEmpName: UILabel!
    @IBOutlet weak var lblSchool: UILabel!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var lblSchoolTitle: UILabel!
    
    var isSearching = false
    @IBOutlet weak var empSearchBar: UISearchBar!
    var filteredDataArray = NSMutableArray()
    
    @IBOutlet weak var empHistoryTableView: UITableView!
    var empHistoryArray = NSMutableArray()
    var CandidateId = ""
    var empName = ""
    var empSchool = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.titlelbl.text = "Employee Work History"
             lblSchoolTitle.text = "Client Name"
     }
    @objc override func appWillEnterForeground(){
        print("appWillEnterForeground Division")
        
        if isForSchoolProfessional == true{
            if empHistoryArray.count == 0{
                self.getSchoolProfEmpHistoryData()}
        }else if isForHospitality == true{
            if empHistoryArray.count == 0{self.getHospitalityEmpHistoryData()}
        }else if isForOffice == true{
            if empHistoryArray.count == 0{self.getOfficeEmpHistoryData()}
        }else if isForOCC == true{
            if empHistoryArray.count == 0{self.getOCCEmpHistoryData()}
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        empHistoryTableView.tableFooterView = UIView()
        //        self.title = "Employee Work History"
        
        lblEmpName.text = empName
        lblSchool.text = ""
        if isForSchoolProfessional == true{
            self.getSchoolProfEmpHistoryData()
        }else if isForHospitality == true{
            self.getHospitalityEmpHistoryData()
        }else if isForOffice == true{
            self.getOfficeEmpHistoryData()
        }else if isForOCC == true{
            self.getOCCEmpHistoryData()
            
        }
        
        
        noDataView.isHidden = true
        noDataView.backgroundColor = UIColor(hexString:danger_background_Color)
        lblNoData.textColor = UIColor(hexString:danger_Color)
        empSearchBar.barTintColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        let textFieldInsideUISearchBar = empSearchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.borderStyle = .none
        textFieldInsideUISearchBar?.backgroundColor = UIColor.white
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    //MARK: TABLEVIEW DELEGATE & DATASOURCE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching == true {
            return filteredDataArray.count
        }
        
        return empHistoryArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:EmpHistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EmpHistoryTableViewCellIdentifier") as! EmpHistoryTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        var  emp = NSDictionary()
        
        if isSearching == true {
            
            emp = filteredDataArray[indexPath.row] as! NSDictionary
            
        }else{
            emp = empHistoryArray[indexPath.row] as! NSDictionary
            
        }
        let  empObj:NSDictionary = emp as NSDictionary
        
        
        let datesWorked =   empObj["DatesWorked"] as! String
        let subject = empObj["Subject"] as! String
        let Evaluation = empObj["Evaluation"] as! Double
        
        
        cell.lblDate.text = datesWorked
        cell.lblSubjects.text = subject
        cell.floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        cell.floatRatingView.type = .wholeRatings
        cell.floatRatingView.backgroundColor = UIColor.clear
//        cell.floatRatingView.rating = Evaluation
        cell.floatRatingView.rating = round(Evaluation)

        cell.floatRatingView.isUserInteractionEnabled = false
        
        cell.lblSubjectTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.lblDateTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.lblEval.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
        return cell
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var  emp = NSDictionary()
        
        if isSearching == true {
            
            emp = filteredDataArray[indexPath.row] as! NSDictionary
            
        }else{
            emp = empHistoryArray[indexPath.row] as! NSDictionary
            
        }
        
        let  empObj:NSDictionary = emp as NSDictionary
        
        let subject = empObj["Subject"] as! String
        
        let height =  self.sizeOfString(string: subject, constrainedToHeight: Double.greatestFiniteMagnitude).height + 20
        return max(115, height)
        
        
    }
    //MARK: Server Call
    
    func getSchoolProfEmpHistoryData() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            let defaults = UserDefaults.standard
            
            let CandidateId = self.CandidateId
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            
            let params :[String:String] = ["ClientId" : clientID , "CandidateId" : CandidateId]
            print(params)
            RestAPI.getEmpHistoryROSSchoolProfes(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getEmpHistoryResponse(response:))
            
        }else{
            noDataView.isHidden = false
            lblNoData.text = "No Internet Connection"
            //            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
    }
    func getHospitalityEmpHistoryData() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            let defaults = UserDefaults.standard
            
            let CandidateId = self.CandidateId
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            
            let params :[String:String] = ["CandName":empName,"ClientId" : clientID , "CandidateID" : CandidateId]
            print(params)
            RestAPI.getEmpHistoryHospitality(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getEmpHistoryResponse(response:))
            
        }else{
            noDataView.isHidden = false
            lblNoData.text = "No Internet Connection"
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
    }
    func getOfficeEmpHistoryData() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            let defaults = UserDefaults.standard
            
            let CandidateId = self.CandidateId
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            
            let params :[String:String] = ["ClientId" : clientID , "candID" : CandidateId]
            print(params)
            RestAPI.getEmpHistoryOffice(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getEmpHistoryResponse(response:))
            
        }else{
            noDataView.isHidden = false
            lblNoData.text = "No Internet Connection"
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
    }
    func getOCCEmpHistoryData(){
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            
            let params :[String:String] = ["ClientId" : clientID,
                                           "CandidateId" : CandidateId ,
                                           "Name" : empName]
            print(params)
            RestAPI.getEmpHistoryOCC(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getEmpHistoryResponse(response:))
            
        }else{
            noDataView.isHidden = false
            lblNoData.text = "No Internet Connection"
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
    }
    
    
    
    func getEmpHistoryResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            //            lblNoData.isHidden = false
            noDataView.isHidden = false
            lblNoData.text = response as? String
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                if isForOffice == true{
                    empHistoryArray.removeAllObjects()
                    let empHistory = object["HistoryList"].array
                    for dict in empHistory!{
                        let dictObj = ["DatesWorked":dict["DatesWorked"].stringValue,"School":"","Subject":dict["Position"].stringValue,"Evaluation":dict["Evaluation"].doubleValue] as [String : Any]
                        empHistoryArray.add(dictObj)
                        lblSchool.text = dict["Client"].stringValue
                        
                    }
                    
                    if empHistory?.count == 0{
                        noDataView.isHidden = false
                        var msg = object["Message"].stringValue
                        if msg.count == 0{
                            msg = "No records found"
                        }
                        lblNoData.text = msg
                        
                    }else{
                        noDataView.isHidden = true
                        
                    }
                }else if isForHospitality == true{
                    empHistoryArray.removeAllObjects()
                    let empHistory = object["HistoryModel"].array
                    for dict in empHistory!{
                        
                        let dictObj = ["DatesWorked":dict["DatesWorked"].stringValue,"School":"","Subject":dict["Position"].stringValue,"Evaluation":dict["Evaluation"].doubleValue] as [String : Any]
                        
                        //                        let dictObj = ["DatesWorked":dict["DatesWorked"].stringValue,"School":"","Subject":dict["positions"].stringValue]
                        empHistoryArray.add(dictObj)
                        lblSchool.text = dict["Client"].stringValue
                        
                    }
                    
                    if empHistory?.count == 0{
                        noDataView.isHidden = false
                        var msg = object["Message"].stringValue
                        if msg.count == 0{
                            msg = "No records found"
                        }
                        lblNoData.text = msg
                        
                    }else{
                        noDataView.isHidden = true
                        
                    }
                }else if isForSchoolProfessional == true{
                    empHistoryArray.removeAllObjects()
                    let empHistory = object["HistoryModel"].array
                    for dict in empHistory!{
                     
                        let dictObj = ["DatesWorked":dict["DatesWorked"].stringValue,"School":"","Subject":dict["Position"].stringValue,"Evaluation":dict["Evaluation"].doubleValue] as [String : Any]
                        
                        empHistoryArray.add(dictObj)
                        lblSchool.text = dict["Client"].stringValue
                        lblEmpName.text = empName
                    }
                    
                    if empHistory?.count == 0{
                        noDataView.isHidden = false
                        var msg = object["Message"].stringValue
                        if msg.count == 0{
                            msg = "No records found"
                        }
                        lblNoData.text = msg
                        
                    }else{
                        noDataView.isHidden = true
                        
                    }
                }else if isForOCC == true{
                    empHistoryArray.removeAllObjects()
                    let empHistory = object["OccSearchmodelList"].array
                    for dict in empHistory!{
                        let dictObj = ["DatesWorked":dict["DatesWorked"].stringValue,"School":"","Subject":dict["Position"].stringValue,"Evaluation":dict["Evaluation"].doubleValue] as [String : Any]
                        
                        empHistoryArray.add(dictObj)
                        lblSchool.text = dict["Client"].stringValue

                    }
                    
                    if empHistory?.count == 0{
                        noDataView.isHidden = false
                        var msg = object["Message"].stringValue
                        if msg.count == 0{
                            msg = "No records found"
                        }
                        lblNoData.text = msg
                        
                    }else{
                        noDataView.isHidden = true
                        
                    }
                }
                empHistoryTableView.reloadData()
                
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                noDataView.isHidden = false
                lblNoData.text = message
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
                //                self.ShowAlertMessage(message: message, title: "")
            }
        }
    }
    
    
    //MARK: - UISEARCHBAR DELEGATE METHODS
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        //        isSearching = false
        
        searchBar.endEditing(false)
        
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) // called when text changes (including clear)
    {
        isSearching = true
        
        //////////////////**********************SEARCH**********///////////////
        
        filteredDataArray.removeAllObjects()
        if searchText.count > 0
        {
            var found = false
            
            
            for eObj in empHistoryArray{
                
                let  empObj =  eObj as! NSDictionary
                let datesWorked =   empObj["DatesWorked"] as! String
                let subject = empObj["Subject"] as! String
                
                let empName =   (subject.lowercased())+(datesWorked.lowercased())
                
                let searchString = searchText.lowercased()
                
                found = (empName.contains(searchString)) || (empName.caseInsensitiveCompare(searchString) == ComparisonResult.orderedSame)
                
                if found {
                    filteredDataArray.add(empObj)
                }
            }
        }
        else
        {
            isSearching = false
            searchBar.endEditing(true)
            
        }
        empHistoryTableView.reloadData()
        
        /////////////////////******** END OF SEARCH *********//////
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) // called when cancel button pressed
    {
        isSearching = false
        searchBar.endEditing(true)
        
    }
    
    
}
