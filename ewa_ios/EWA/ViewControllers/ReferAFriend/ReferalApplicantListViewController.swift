//
//  ReferalApplicantListViewController.swift
//  EWA
//
//  Created by NFC India on 13/08/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON


class ReferalApplicantListViewController: BaseViewController {
    
    
    @IBOutlet weak var referalListView: UITableView!
    var applicantListData:JSON = JSON.null
    var applicantsList = [ReferalApplicantList]()
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viv in ReferalApplicantListViewController")
        
        // Do any additional setup after loading the view.
        self.updateNavigationBarColor()
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        getApplicantList()
        
        self.title = "Referral Bonus"
    }
    
    
    
    //function to get applicantList
    func getApplicantList()
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:self.view)
            let params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String]
            ServerService.getReferalApplicantList(self, params:params, method:"POST", accessToken:Constants.Token, acces:true, callBack:self.getReferalApplicantList(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
    }
    
    //getting applicantList
    func getReferalApplicantList(response:AnyObject)->()
    {
        applicantsList.removeAll()
        ServerService.hideProgressView()
        applicantListData = response as! JSON
        print(applicantListData)
        errorLabel.text = applicantListData["Message"].stringValue
        if applicantListData["MessageStatus"].intValue == 1
        {
            for app in 0..<applicantListData["ApplicantsList"].arrayValue.count
            {
                let applicant = ReferalApplicantList.init(name:applicantListData["ApplicantsList"][app]["ApplicantFullName"].stringValue, email: applicantListData["ApplicantsList"][app]["ApplicantEmail"].stringValue,referalDate:Constants.getFormattedDateForPersonalJob(string:applicantListData["ApplicantsList"][app]["ReferedDate"].stringValue.substring(to:10)), applicationReceivedDate:Constants.getFormattedDateForPersonalJob(string: applicantListData["ApplicantsList"][app]["AppRecDate"].stringValue.substring(to:10)), status: applicantListData["ApplicantsList"][app]["Status"].stringValue)
                applicantsList.append(applicant)
            }
            if applicantListData["ApplicantsList"].arrayValue.count>0
            {
                referalListView.backgroundColor = .white
            }
            else
            {
                referalListView.backgroundColor = .clear
                errorLabel.text = "No Records Found"
            }
        }
        else
        {
            referalListView.backgroundColor = .clear
        }
        referalListView.reloadData()
        
    }
    @IBAction func handleNavgationBarButtonTap(_ sender: UIBarButtonItem, event: UIEvent)
    
    {
        Constants.showUp(event:event,viewController:self)
        
    }
}




extension ReferalApplicantListViewController:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "referalBonus") as! ReferalBonusViewController
        nextViewController.applicant = applicantsList[indexPath.row]
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
extension ReferalApplicantListViewController:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applicantsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"raCell") as! ReferalApplicantListTableViewCell
        cell.nameLabel.text = applicantsList[indexPath.row].name!
        cell.emailLabel.text = applicantsList[indexPath.row].email!
        if applicantsList[indexPath.row].applicationReceivedDate == "01/01/0001"
        {
            cell.receivedDate.text = ""
        }
        else
        {
            cell.receivedDate.text = applicantsList[indexPath.row].applicationReceivedDate
        }
        cell.referalDateLabel.text = applicantsList[indexPath.row].referalDate
        cell.statusLabel.text = applicantsList[indexPath.row].status!
        
        cell.selectionStyle = .none
        return cell
    }
    
    
}
