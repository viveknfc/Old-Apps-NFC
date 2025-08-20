//
//  ReferalBonusViewController.swift
//  EWA
//
//  Created by NFC India on 13/08/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReferalBonusViewController: BaseViewController {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var referaldates: UILabel!
    @IBOutlet weak var referalBonusListView: UITableView!
    @IBOutlet weak var segmentContol: BetterSegmentedControl!
    @IBOutlet weak var viewForList: UIView!
    @IBOutlet var othersListView: UITableView!
    @IBOutlet weak var noRecordsFound: UILabel!
    
    
    var referalBonusData:JSON = JSON.null
    var workingApplicantsList = [ReferalBonus]()
    var otherApplicantsList = [ReferalBonus]()
    
    var applicant = ReferalApplicantList.init(name:"", email:"", referalDate:"", applicationReceivedDate:"", status:"")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.updateNavigationBarColor()
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        
        nameLabel.text = applicant.name!
        emailLabel.text = applicant.email!
        if applicant.referalDate! == "01/01/0001"
        {
            referaldates.text = ""
        }
        else
        {
            referaldates.text = applicant.referalDate!
        }
        self.title = "Referral Bonus Details"
        getApplicantList()
        segmentContol.indicatorViewBackgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        segmentContol.titles = ["Applied Positions","Working Positions"]
        
        noRecordsFound.isHidden = true
    }
    
    //function to get applicantList
    func getApplicantList()
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:self.view)
            let params:[String:String] = ["Email":applicant.email!]
            ServerService.referalShowComissions(self, params:params, method:"POST", accessToken:Constants.Token, acces:true, callBack:self.getReferalApplicantList(response:))
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
        otherApplicantsList.removeAll()
        workingApplicantsList.removeAll()
        ServerService.hideProgressView()
        referalBonusData = response as! JSON
        print(referalBonusData)
        noRecordsFound.text = referalBonusData["Message"].stringValue
        if referalBonusData["MessageStatus"].intValue == 1
        {
            for app in 0..<referalBonusData["WorkingApplicantsList"].arrayValue.count
            {
                let applicantBonus = ReferalBonus.init(position: referalBonusData["WorkingApplicantsList"][app]["Position"].stringValue, requiredHours: referalBonusData["WorkingApplicantsList"][app]["RequiredHours"].stringValue, commission: referalBonusData["WorkingApplicantsList"][app]["Commision"].intValue, applicationReceivedDate:Constants.getFormattedDateForPersonalJob(string:referalBonusData["WorkingApplicantsList"][app]["AppRecDate"].stringValue.substring(to: 10)), currentHours: referalBonusData["WorkingApplicantsList"][app]["CurrentHours"].stringValue)
                workingApplicantsList.append(applicantBonus)
            }
            for app in 0..<referalBonusData["OtherApplicantsList"].arrayValue.count
            {
                let applicantBonus = ReferalBonus.init(position: referalBonusData["OtherApplicantsList"][app]["Position"].stringValue, requiredHours: referalBonusData["OtherApplicantsList"][app]["RequiredHours"].stringValue, commission: referalBonusData["OtherApplicantsList"][app]["Commision"].intValue, applicationReceivedDate:Constants.getFormattedDateForPersonalJob(string:referalBonusData["OtherApplicantsList"][app]["AppRecDate"].stringValue.substring(to: 10)), currentHours: referalBonusData["OtherApplicantsList"][app]["CurrentHours"].stringValue)
                otherApplicantsList.append(applicantBonus)
            }
            
            
            if referalBonusData["OtherApplicantsList"].arrayValue.count>0
            {
                referalBonusListView.backgroundColor = .white
                referalBonusListView.frame = CGRect(x: 0, y: 0, width:viewForList.bounds.size.width, height:viewForList.bounds.size.height)
                viewForList.addSubview(referalBonusListView)
            }
            else
            {
                noRecordsFound.isHidden = false
                referalBonusListView.backgroundColor = .clear
                noRecordsFound.text = "No Records Found"
            }
            if referalBonusData["WorkingApplicantsList"].arrayValue.count>0
            {
                othersListView.backgroundColor = .white
                othersListView.frame = CGRect(x: 0, y: 0, width:viewForList.bounds.size.width, height:viewForList.bounds.size.height)
            }
            else
            {
                noRecordsFound.isHidden = false
                othersListView.backgroundColor = .clear
                noRecordsFound.text = "No Records Found"
            }
        }
        else
        {
            noRecordsFound.isHidden = false
            referalBonusListView.backgroundColor = .clear
        }
        referalBonusListView.reloadData()
        othersListView.reloadData()
    }
    
    @IBAction func handleNavgationBarButtonTap(_ sender: UIBarButtonItem, event: UIEvent)
    
    {
        Constants.showUp(event:event,viewController:self)
        
    }
    
    
    @IBAction func segmentAction(_ sender: BetterSegmentedControl) {
        
        if sender.index == 0 {
            othersListView.removeFromSuperview()
            viewForList.addSubview(referalBonusListView)
        }
        else if sender.index == 1
        {
            referalBonusListView.removeFromSuperview()
            viewForList.addSubview(othersListView)
        }
        
    }
    
}

//END OF CLASS

//TableView Extensions
extension ReferalBonusViewController:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
}
extension ReferalBonusViewController:UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == referalBonusListView
        {
            return otherApplicantsList.count
        }
        else
        {
            return workingApplicantsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"rbCell") as! ReferalBonusTableViewCell
        
        if tableView == referalBonusListView
        {
            cell.positionLabel.text = otherApplicantsList[indexPath.row].position!
            cell.applicationReceivedDate.text = otherApplicantsList[indexPath.row].applicationReceivedDate!
            cell.currentHours.text = otherApplicantsList[indexPath.row].currentHours!
            cell.comissionLabel.text = "$ "+String(format: "%.2f",otherApplicantsList[indexPath.row].commission!)
            cell.requiredHours.text = otherApplicantsList[indexPath.row].requiredHours!
        }
        else
        {
            cell.positionLabel.text = workingApplicantsList[indexPath.row].position!
            cell.applicationReceivedDate.text = workingApplicantsList[indexPath.row].applicationReceivedDate!
            cell.currentHours.text = workingApplicantsList[indexPath.row].currentHours!
            cell.comissionLabel.text = "$ "+String(format: "%.2f",workingApplicantsList[indexPath.row].commission!)
            cell.requiredHours.text = workingApplicantsList[indexPath.row].requiredHours!
        }
        cell.selectionStyle = .none
        return cell
    }
    
    
}
