//
//  DOESelectReferaConsultantViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 02/04/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON

class DOESelectReferaConsultantViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var mainTableView: UITableView!
    let SearchForReturningConsultantIdentifier = "SearchForReturningConsultant"
    let AddaNewConsultantIdentifier = "AddaNewConsultant"
    let ButtonCellIdentifier = "ButtonCell"
    var isSearchBtnSelected = false
    var isAddaNewConsultantSelected = false
    var isFromSummaryPage = false

var stateList = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        
        self.titlelbl.text = "Refer a Consultant"
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: UITableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            return self.DOEHeaderTableViewCell(indexPath: indexPath as NSIndexPath)
        }
        var identifier = ""
        if indexPath.row == 1{
            identifier = SearchForReturningConsultantIdentifier
        }else if indexPath.row == 2{
            identifier = AddaNewConsultantIdentifier
        }else if indexPath.row == 3{
            identifier = ButtonCellIdentifier
        }
        return self.ButtonTableCell(indexPath: indexPath as NSIndexPath,identifier: identifier)
        
        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 40
        }else  if indexPath.row == 1 || indexPath.row == 2 {
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
        
        return cell
        
    }
    func ButtonTableCell(indexPath: NSIndexPath,identifier: String) -> ButtonTableViewCell {
        
        let cell:ButtonTableViewCell = mainTableView.dequeueReusableCell(withIdentifier: identifier) as! ButtonTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        if identifier == SearchForReturningConsultantIdentifier{
            cell.dButton.removeTarget(self, action:#selector(self.SearchForConsultantButtonTapped), for: .touchUpInside)
            cell.dButton.addTarget(self, action:#selector(self.SearchForConsultantButtonTapped), for: .touchUpInside)
            cell.dButton.setTitle("Search for Returning Consultant", for: .normal)
        }else if identifier == AddaNewConsultantIdentifier{
            cell.dButton.removeTarget(self, action:#selector(self.addNewConsultantButtonTapped), for: .touchUpInside)
            cell.dButton.addTarget(self, action:#selector(self.addNewConsultantButtonTapped), for: .touchUpInside)
            cell.dButton.setTitle("Add a New Consultant", for: .normal)
        } else if identifier == ButtonCellIdentifier{
            if isFromSummaryPage == true{
                cell.returnToConfirmOrderButton.isHidden = false
                cell.nextButton.isHidden = true
                cell.backButton.isHidden = true
                cell.returnToConfirmOrderButton.removeTarget(self, action:#selector(self.returnToConfirmOrderButtonTapped), for: .touchUpInside)
                cell.returnToConfirmOrderButton.addTarget(self, action:#selector(self.returnToConfirmOrderButtonTapped), for: .touchUpInside)

            }else{
                cell.returnToConfirmOrderButton.isHidden = true
                cell.nextButton.isHidden = false
                cell.backButton.isHidden = false
                cell.nextButton.removeTarget(self, action:#selector(self.nextButtonTapped), for: .touchUpInside)
                cell.backButton.removeTarget(self, action:#selector(self.backButtonTapped), for: .touchUpInside)
                
                cell.nextButton.addTarget(self, action:#selector(self.nextButtonTapped), for: .touchUpInside)
                cell.backButton.addTarget(self, action:#selector(self.backButtonTapped), for: .touchUpInside)
                
            }
            

        }
        return cell
        
    }
    
    @objc func nextButtonTapped(sender:UIButton){
        var selectedApplicant = Applicant.init(CandidateId: "0", ApplicantId: "", Name: "", ConsultantType: "", Email: "", Address: "", City: "", State: "", Zip: "", SSN: "", isSelected: "",appliType: "",ApplicationId:  "0",NewApplicant:  "",extraCandId: "0")

        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "DoeApplicantModel") != nil{
            let decoded  = userDefaults.object(forKey: "DoeApplicantModel") as! Data
            let decodedApplicant = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Applicant
            selectedApplicant = decodedApplicant
        }
        if Int(selectedApplicant.CandidateId!)! == 0 && Int(selectedApplicant.ApplicationId!)! == 0 && Int(selectedApplicant.extraCandId!)! == 0 {
            if( isSearchBtnSelected == false &&
                isAddaNewConsultantSelected == false){
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Please select any one of the options", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }else if ( isSearchBtnSelected == false &&
                isAddaNewConsultantSelected == true){
//                self.navigationController?.popViewController(animated: true)
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Please select any one of the options", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

            }
            else{
//                self.navigationController?.popViewController(animated: true)
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Please select any one of the options", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

            }
        }else{
            self.pushToDOEChooseConsultantReportToViewController()

        }
        
        
        
    }
    @objc func returnToConfirmOrderButtonTapped(sender: UIButton){
        self.pushToDetailsPage()
    }
    @objc func backButtonTapped(sender:UIButton){
        
        self.navigationController?.popViewController(animated: true)
    }
    @objc func SearchForConsultantButtonTapped(sender:UIButton){
          isSearchBtnSelected = true
          isAddaNewConsultantSelected = false

    self.PushToDOESearchApplicantViewControllerPage()
    }
    @objc func addNewConsultantButtonTapped(sender:UIButton){
        isSearchBtnSelected = false
        isAddaNewConsultantSelected = true
        
        if stateList.count == 0{
            self.getStateList()
        }else{
            self.pushToAddReportToPage()
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
    
    func PushToDOESearchApplicantViewControllerPage(){
        var isControllerExists = false
        var vc = UIViewController()
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOESearchApplicantViewController {
                    print("Your controller exist")
                    vc = viewController
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOESearchApplicantSegue") as! DOESearchApplicantViewController
            nextViewController.isFromAddApplicantPage = false
            nextViewController.isFromSummaryPage = self.isFromSummaryPage
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }else{
            let vc1:DOESearchApplicantViewController = vc as! DOESearchApplicantViewController
            vc1.isFromSummaryPage =  self.isFromSummaryPage
            self.navigationController?.popViewController(animated: true)
        }
    }
    func pushToAddReportToPage(){
        var isControllerExists = false
        var vc = UIViewController()
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is AddNewReportToViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    vc = viewController
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddNewReportToSegue") as! AddNewReportToViewController
            
            nextViewController.isForAddReportToOCC = false
            nextViewController.isForAddReportToOffice = false
            nextViewController.isForAddReportToLocationOffice = false
            nextViewController.isForAddApplicantDOE = true
            nextViewController.DOE_Edit_State_List = stateList
            nextViewController.isFromSummaryPage = self.isFromSummaryPage
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }else{
            let nextViewController:AddNewReportToViewController = vc as! AddNewReportToViewController
            nextViewController.isFromSummaryPage = self.isFromSummaryPage
            self.navigationController?.popViewController(animated: true)
        }
    }
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
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOEChooseConsultantReportToSegue") as! DOEChooseConsultantReportToViewController
            nextViewController.isFromSummaryPage = self.isFromSummaryPage
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            let nextViewController:DOESelectReferaConsultantViewController = vc as! DOESelectReferaConsultantViewController
            nextViewController.isFromSummaryPage = self.isFromSummaryPage
            self.navigationController?.popToViewController(nextViewController, animated: true)
        }
    }
    //MARK: Server Call
    func getStateList(){
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
 
            JustHUD.shared.showInView(view: view)

            let params :[String:String] = ["ClientId":"0",
                                           "ContactId":"0"]
            
            print(params)
            
            RestAPI.DOE_getStateListCall(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
        }else{
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    func getResponse(response:AnyObject)->()
    {
         print(response)
        JustHUD.shared.hide()

        if response is String{
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                let states = object["StatesList"].array
                for dict in states!{
                    let state = State.init(StateId: dict["Value"].stringValue, StateName: dict["Text"].stringValue, StateCode: dict["Value"].stringValue, isSelected: "0")
                    stateList.add(state)
                }
            }
            
        }
        self.pushToAddReportToPage()

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
