//
//  DOEConsultantSourcedViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 02/04/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class DOEConsultantSourcedViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var mainTableView: UITableView!
    let ReferaConsultantIdentifier = "ReferaConsultant"
    let SearchForConsultantIdentifier = "SearchForConsultant"
    let SchoolProfessioalToRecruitIdentifier = "SchoolProfessioalToRecruit"
    let BottomCellIdentifier = "BottonCellIdentifier"
    var isReferBtnSelected = false
    var isSearchBtnSelected = false
    var isSchoolProfBtnSelected = false
    var isFromSummaryPage = false
    
    var selectedApplicant = Applicant.init(CandidateId: "0", ApplicantId: "", Name: "", ConsultantType: "", Email: "", Address: "", City: "", State: "", Zip: "", SSN: "", isSelected: "",appliType: "",ApplicationId:  "0",NewApplicant:  "",extraCandId: "0")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @objc func methodOfReceivedNotification(){
        
        //        var info = notification.userInfo!
        isFromSummaryPage = true
        self.mainTableView.reloadData()
    }
    @objc override func goBack()
    {
        if isFromSummaryPage == true{
            isFromSummaryPage = false
            self.pushToDetailsPage()
        }else{
            isFromSummaryPage = false
            //pop to 
            self.navigationController?.popViewController(animated: true)
        }
    }
    func pushToDetailsPage(){
        var isControllerExists = false
        var vc = UIViewController()
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOEOrderDetailsViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    vc = viewController
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOEOrderDetailsSegue") as! DOEOrderDetailsViewController
            nextViewController.isFromROSDOE = true
            nextViewController.isFromHistoricalOrder = false
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            let vc1:DOEOrderDetailsViewController = vc as! DOEOrderDetailsViewController
            vc1.isFromROSDOE = true
            vc1.isFromHistoricalOrder = false
            self.navigationController?.popToViewController(vc1, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        
        self.titlelbl.text = "Candidate"
        
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "DoeApplicantModel") != nil{
            let decoded  = userDefaults.object(forKey: "DoeApplicantModel") as! Data
            let decodedApplicant = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Applicant
            selectedApplicant = decodedApplicant
        }else{
            selectedApplicant = Applicant.init(CandidateId: "0", ApplicantId: "", Name: "", ConsultantType: "", Email: "", Address: "", City: "", State: "", Zip: "", SSN: "", isSelected: "",appliType: "",ApplicationId:  "0",NewApplicant:  "",extraCandId: "0")
        }
        //
        if isFromSummaryPage == true{
            self.methodOfReceivedNotification()
        }
        self.mainTableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            return self.DOEHeaderTableViewCell(indexPath: indexPath as NSIndexPath)
        }else if indexPath.row == 1{
            var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?
            if !(cell != nil) {
                cell = UITableViewCell(style:.subtitle, reuseIdentifier: "CELL")
            }
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            
            if Int(selectedApplicant.CandidateId!)! == 0 && Int(selectedApplicant.ApplicationId!)! == 0 && Int(selectedApplicant.extraCandId!)! == 0{
                cell?.textLabel?.text = ""
                
                cell?.detailTextLabel?.text = ""
                
            }else{
                cell?.textLabel?.text = "Selected Consultant:"
                
                let applicantDetails = String(format:"\n%@\n%@\n%@, %@, %@\n%@\n%@",selectedApplicant.Name!,selectedApplicant.Address!,selectedApplicant.City!,selectedApplicant.State!,selectedApplicant.Zip!,selectedApplicant.SSN!,selectedApplicant.Email!)
                cell?.detailTextLabel?.text = applicantDetails
                cell?.detailTextLabel?.numberOfLines = 0
                cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
            }
            return cell!
            
        }
        var identifier = ""
        if indexPath.row == 2{
            identifier = ReferaConsultantIdentifier
        }else if indexPath.row == 3{
            identifier = SearchForConsultantIdentifier
        }else if indexPath.row == 4{
            identifier = SchoolProfessioalToRecruitIdentifier
        }else if indexPath.row == 5{
            identifier = BottomCellIdentifier
        }
        return self.ButtonTableCell(indexPath: indexPath as NSIndexPath,identifier: identifier)
        
        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            
            let screensize = UIScreen.main.bounds.size.width
            
            if screensize == 320 {
                return 290
            }
            return 270
        }
        else  if indexPath.row == 1{
if Int(selectedApplicant.CandidateId!)! == 0 && Int(selectedApplicant.ApplicationId!)! == 0 && Int(selectedApplicant.extraCandId!)! == 0
            {
                return 0
            }
            return 125
        }else if indexPath.row == 3{
            return 0
        }
        else  if indexPath.row == 4 || indexPath.row == 2 {
            return 125
        }
        return 60
    }
    
    //MARK: Custom Cell
    //DOEHeaderTableViewCell
    func DOEHeaderTableViewCell(indexPath: NSIndexPath) -> DOEHeaderTableViewCell {
        
        let cell:DOEHeaderTableViewCell = mainTableView.dequeueReusableCell(withIdentifier: "DOEHeaderTableViewCellIdentifier") as! DOEHeaderTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        var text = ""
        var changedText = ""
        if isReferBtnSelected == true{
            text = "You have selected 'Refer a consultant'"
            changedText = "Refer a consultant"
        }else if isSearchBtnSelected == true{
            text = "You have selected 'Search for a consultant'"
            changedText = "Search for a consultant"
        }else if isSchoolProfBtnSelected == true{
            text = "You have selected 'School Professionals to Recruit'"
            changedText = "School Professionals to Recruit"
        }
        if text.count > 0{
            cell.lblHeader.halfTextMakeToBold(fullText: text, changeText: changedText, textColor: UIColor.black)
        }else{
            cell.lblHeader.text = ""
        }
        
        return cell
        
    }
    func ButtonTableCell(indexPath: NSIndexPath,identifier: String) -> ButtonTableViewCell {
        
        let cell:ButtonTableViewCell = mainTableView.dequeueReusableCell(withIdentifier: identifier) as! ButtonTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        if identifier == ReferaConsultantIdentifier{
            cell.dButton.removeTarget(self, action:#selector(self.ReferaConsultantButtonTapped), for: .touchUpInside)
            cell.dButton.addTarget(self, action:#selector(self.ReferaConsultantButtonTapped), for: .touchUpInside)
            cell.dButton.setTitle("Refer a Consultant", for: .normal)
            
        }else if identifier == SearchForConsultantIdentifier{
            cell.dButton.removeTarget(self, action:#selector(self.SearchForConsultantButtonTapped), for: .touchUpInside)
            cell.dButton.addTarget(self, action:#selector(self.SearchForConsultantButtonTapped), for: .touchUpInside)
            cell.dButton.setTitle("Search for a Consultant", for: .normal)
            
        }else if identifier == SchoolProfessioalToRecruitIdentifier{
            cell.dButton.removeTarget(self, action:#selector(self.SchoolProfessioalToRecruitButtonTapped), for: .touchUpInside)
            cell.dButton.addTarget(self, action:#selector(self.SchoolProfessioalToRecruitButtonTapped), for: .touchUpInside)
            cell.dButton.setTitle("School Professionals to Recruit", for: .normal)
            
        }else if identifier == BottomCellIdentifier{
            if isFromSummaryPage == true{
                cell.returnToConfirmOrderButton.removeTarget(self, action:#selector(self.returnToConfirmOrderButtonTapped), for: .touchUpInside)
                cell.returnToConfirmOrderButton.addTarget(self, action:#selector(self.returnToConfirmOrderButtonTapped), for: .touchUpInside)
                cell.nextButton.isHidden = true
                cell.backButton.isHidden = true
                
                cell.returnToConfirmOrderButton.isHidden = false
            }else{
                cell.returnToConfirmOrderButton.isHidden = true
                cell.nextButton.isHidden = false
                cell.backButton.isHidden = false
                cell.nextButton.addTarget(self, action:#selector(self.nextButtonTapped), for: .touchUpInside)
                cell.backButton.addTarget(self, action:#selector(self.backButtonTapped), for: .touchUpInside)
            }
        }
        return cell
        
    }
    
    @objc func returnToConfirmOrderButtonTapped(sender: UIButton){
        isFromSummaryPage = false
        self.pushToDetailsPage()
    }
    
    @objc func ReferaConsultantButtonTapped(sender:UIButton){
        isReferBtnSelected = true
        isSchoolProfBtnSelected = false
        isSearchBtnSelected = false
        self.mainTableView.reloadData()
        self.pushToDOESelectReferaConsultantViewController()
    }
    @objc func SearchForConsultantButtonTapped(sender:UIButton){
        isReferBtnSelected = false
        isSchoolProfBtnSelected = false
        isSearchBtnSelected = true
        self.mainTableView.reloadData()
        self.clearPayRateAndSchduleDataIfThere()
        self.pushToDOESearchOverviewViewController()
    }
    @objc func SchoolProfessioalToRecruitButtonTapped(sender:UIButton){
        isReferBtnSelected = false
        isSchoolProfBtnSelected = true
        isSearchBtnSelected = false
        self.mainTableView.reloadData()
        self.clearPayRateAndSchduleDataIfThere()
        self.pushToDOEChooseConsultantReportToViewController()
    }
    @objc func nextButtonTapped(sender:UIButton){
        if  (isReferBtnSelected == false &&
            isSchoolProfBtnSelected == false &&
            isSearchBtnSelected == false){
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Please select any one of the options", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }else{
            self.pushToDOEChooseConsultantReportToViewController()
        }
    }
    func clearPayRateAndSchduleDataIfThere(){
        
        let defaults = UserDefaults.standard
        
        //        defaults.removeObject(forKey: "DoeScheduleModel")
        
        defaults.removeObject(forKey: "DoePayrateModel")
        
        defaults.removeObject(forKey: "DoePayrateScheduleModel")
        
        defaults.removeObject(forKey: "DoeWaiverModel")
        
        defaults.removeObject(forKey: "DoeApplicantModel")
        defaults.synchronize()
        
    }
    @objc func backButtonTapped(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
        
    }
    func pushToDOESelectReferaConsultantViewController(){
        var isControllerExists = false
        var vc = UIViewController()
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOESelectReferaConsultantViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    vc = viewController
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOESelectReferaConsultantSegue") as! DOESelectReferaConsultantViewController
            nextViewController.isFromSummaryPage = self.isFromSummaryPage
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else {
            let vc1:DOESelectReferaConsultantViewController = vc as! DOESelectReferaConsultantViewController
            vc1.isFromSummaryPage = self.isFromSummaryPage
            self.navigationController?.popToViewController(vc1, animated: true)
        }
    }
    func pushToDOESearchOverviewViewController(){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOESelectReferaConsultantViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOESearchOverviewSegue") as! DOESearchOverviewViewController
            nextViewController.titleHeader = "Overview"
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    func pushToDOEChooseConsultantReportToViewController(){
        var isControllerExists = false
        var vc =  UIViewController()
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOESelectReferaConsultantViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    vc = viewController
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOEChooseConsultantReportToSegue") as! DOEChooseConsultantReportToViewController
            nextViewController.isFromSummaryPage = self.isFromSummaryPage
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else {
            let vc1:DOEChooseConsultantReportToViewController = vc as! DOEChooseConsultantReportToViewController
            vc1.isFromSummaryPage = self.isFromSummaryPage
            self.navigationController?.popToViewController(vc1, animated: true)
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
