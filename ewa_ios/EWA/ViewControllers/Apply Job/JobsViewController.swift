//
//  JobsViewController.swift
//  EWA
//
//  Created by NFC India on 21/01/19.
//  Copyright © 2019 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import DropDown


class JobsViewController: BaseViewController {
    
    var jobs = [ReferAFriend]()
    var jobsListData:JSON = JSON.null
    var jobsType:JSON = JSON.null
    @IBOutlet weak var jobsTableView: UITableView!
    @IBOutlet weak var jobsCategoryDropDown: PKButton!
    let chooseArticleDropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.chooseArticleDropDown
        ]
    }()
    var contract = Bool()
    var contractToHire = Bool()
    var direct = Bool()
    var jobCategoryType = String()
    var referedJob = ReferAFriend.init(title:"", jobType:"", categoryType:"", orderId:"", imageUrl:"", address:"",jobId:"")
    
    @IBOutlet weak var noJobsLabel: UILabel!
    
    var divisionId = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey:"color") != nil
        {
            self.updateNavigationBarColor()
            print("***VIV entered if block of color in viewdidload***")
        }
        else
        {
            print("***VIV entered else block of color in viewdidload***")
        }
        
        
        let titleDict: NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.black] // viv previously this was white
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedString.Key : Any]
        
        self.title = "Job Search"
        noJobsLabel.isHidden = true
        
        divisionId = UserDefaults.standard.value(forKey:"dID") as! String
        
        getJobsList()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // adding back if user not a logged user
        if UserDefaults.standard.object(forKey: "token") != nil
        {
            
        }
        else
        {
            
            let rightNavUser = UIButton(type: .system)
            rightNavUser.setImage(UIImage(named: "back"), for: .normal)
            rightNavUser.setTitle("Back", for: .normal)
            rightNavUser.tintColor = .black // viv newly added
            rightNavUser.addTarget(self, action: #selector(NavgationBackButtonTapped), for: .touchUpInside)
            rightNavUser.sizeToFit()
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: rightNavUser)
            
        }
    }
    
    //back action
    @objc func NavgationBackButtonTapped(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated:true, completion:nil)
    }
    
    
    
    //GET Job list api
    func getJobsList()
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            self.showActivityIndicatoryInSelf(uiView:self.view)
            let params:[String:Any] = ["JobCategory":jobCategoryType,"DivisionId":divisionId]
        
            ServerService.referalGetJobCategoryList(self, params:params, method:"POST", accessToken:"247608:Y4y3oQqa7KU=", acces:true, callBack:self.getresponseForJobsList(response:))
        }
        else
        {
            self.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
        
    }
    //getresponseForJobsList Response
    func getresponseForJobsList(response:AnyObject)->()
    {
        jobs.removeAll()
        self.hideProgressView()
        jobsListData = response as! JSON
        print(jobsListData)
        noJobsLabel.text = "VIVEK"
        if jobsListData["MessageStatus"].intValue == 1
        {
//            for job in 0..<jobsListData["JobsList"].arrayValue.count // viv hided this and gave below count of 10
            for job in 0..<10
            {
                
                let rJob = ReferAFriend.init(title:jobsListData["JobsList"][job]["JobTitle"].stringValue, jobType: jobsListData["JobsList"][job]["JobType"].stringValue, categoryType: jobsListData["JobsList"][job]["JobCategory"].stringValue, orderId: jobsListData["JobsList"][job]["OrderId"].stringValue, imageUrl: jobsListData["JobsList"][job]["PostingImgUrl"].stringValue, address: jobsListData["JobsList"][job]["City"].stringValue+","+jobsListData["JobsList"][job]["State"].stringValue,jobId:jobsListData["JobsList"][job]["JobId"].stringValue)
                jobs.append(rJob)
            }
            if jobsListData["JobsList"].arrayValue.count>0
            {
                jobsTableView.backgroundColor = .white
                noJobsLabel.isHidden = true
            }
            else
            {
                jobsTableView.backgroundColor = .clear
                noJobsLabel.isHidden = false
            }
        }
        else
        {
            jobsTableView.backgroundColor = .clear
            noJobsLabel.isHidden = false
        }
        jobsTableView.reloadData()
    }
    
    
    //DropDown setUp
    func setupChooseArticleDropDown(anchorView:UIButton,items:[String]) {
        chooseArticleDropDown.anchorView = anchorView
        chooseArticleDropDown.bottomOffset = CGPoint(x: 0, y: anchorView.bounds.height)
        chooseArticleDropDown.backgroundColor = .white
        chooseArticleDropDown.dataSource =  items
        chooseArticleDropDown.selectionAction = { [unowned self] (index,item) in
            print(self.index)
            print(item)
            self.jobCategoryType = item
            anchorView.setTitle(item, for: .normal)
            anchorView.titleLabel?.textAlignment = .left
            if item == "---Select Job Category---"
            {
                self.getJobsList()
            }
            else
            {
                
                self.getTypeOfJobs()
            }
        }
        
    }
    
    @IBAction func jobCategoryDropDownAction(_ sender: UIButton) {
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        
        var itemsDrop:[String] = ["---Select Job Category---"]
        for category in 0..<jobsListData["JobCategoryList"].arrayValue.count
        {
            itemsDrop.append(jobsListData["JobCategoryList"][category]["Value"].stringValue)
        }
        setupChooseArticleDropDown(anchorView:sender,items:itemsDrop)
        chooseArticleDropDown.show()
    }
    
    
    @IBAction func contractAction(_ sender: Checkbox) {
        contract = sender.isChecked
        self.getTypeOfJobs()
    }
    
    @IBAction func contractToHire(_ sender: Checkbox) {
        contractToHire = sender.isChecked
        self.getTypeOfJobs()
    }
    
    @IBAction func directAction(_ sender: Checkbox) {
        direct = sender.isChecked
        self.getTypeOfJobs()
    }
    
    
    
    //function for getting Type of jobs on search
    func getTypeOfJobs()
    {
        
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:self.view)
            let params:[String:Any] = ["DivisionId":divisionId,"IsContract":contract,
                                       "IsContractToHire":contractToHire,
                                       "IsDirectHire":direct,"JobCategory":jobCategoryType]
            print("********typeParams******",params)
            ServerService.referalGetJobType(self, params:params, method:"POST", accessToken:"247608:Y4y3oQqa7KU=", acces:true, callBack:self.getresponseForJobsListFoType(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
        
    }
    //getresponseForJobsListFoType Response
    func getresponseForJobsListFoType(response:AnyObject)->()
    {
        jobs.removeAll()
        ServerService.hideProgressView()
        jobsType = response as! JSON
        print(jobsType)
        
        if jobsType["MessageStatus"].intValue == 1
        {
            for job in 0..<jobsType["JobsList"].arrayValue.count
            {
                
                let rJob = ReferAFriend.init(title:jobsType["JobsList"][job]["JobTitle"].stringValue, jobType: jobsType["JobsList"][job]["JobType"].stringValue, categoryType: jobsType["JobsList"][job]["JobCategory"].stringValue, orderId: jobsType["JobsList"][job]["OrderId"].stringValue, imageUrl: jobsType["JobsList"][job]["PostingImgUrl"].stringValue, address: jobsType["JobsList"][job]["City"].stringValue+","+jobsType["JobsList"][job]["State"].stringValue, jobId:jobsType["JobsList"][job]["JobId"].stringValue)
                jobs.append(rJob)
            }
            if jobsType["JobsList"].arrayValue.count>0
            {
                jobsTableView.backgroundColor = .white
                noJobsLabel.isHidden = true
            }
            else
            {
                jobsTableView.backgroundColor = .clear
                noJobsLabel.isHidden = false
            }
        }
        else
        {
            jobsTableView.backgroundColor = .clear
            noJobsLabel.isHidden = false
        }
        jobsTableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue"
        {
            let dvc = segue.destination as! JobDetailsViewController
            dvc.referedJob = referedJob
        }
    }
    
    @IBAction func handleNavgationBarButtonTap(_ sender: UIBarButtonItem, event: UIEvent)
    
    {
        Constants.showUp(event:event, viewController:self)
        
    }
    
    
    
    
}
//END OF CLASS





//Extension for tableview
extension JobsViewController:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        referedJob = jobs[indexPath.row]
        self.performSegue(withIdentifier:"detailSegue", sender:nil)
        
        //        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        //        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "rJobDetails") as! ReferAFriendJobDetailsViewController
        //        nextViewController.referedJob = jobs[indexPath.row]
        //        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
extension JobsViewController:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"rfCell") as! ReferFriendTableViewCell
        
        cell.titleLabel.text = jobs[indexPath.row].title!
        cell.categoryType.text = jobs[indexPath.row].categoryType!
        cell.jobTypeLabel.text = jobs[indexPath.row].jobType!
        cell.addressLabel.text = jobs[indexPath.row].address!
        cell.jobImageView.sd_setImage(with:URL(string:jobs[indexPath.row].imageUrl!), placeholderImage: UIImage(named:"placeholder.png"))
        
        cell.selectionStyle = .none
        
        return cell
    }
}
