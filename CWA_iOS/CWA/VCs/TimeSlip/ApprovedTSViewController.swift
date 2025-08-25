//
//  ApprovedTSViewController.swift
//  CWA
//
//  Created by Jayaprada on 04/06/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON

class ApprovedTSViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return approvedDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ApproveTimeSlipTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ApproveTimeSlipTableViewCellIdentifier") as! ApproveTimeSlipTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let  ts:GetApproveTimeSlip = approvedDatas[indexPath.row] as! GetApproveTimeSlip
        
        let empName =   ts.Name
        let weekEnd = ts.WeekEnding
        let hours =  ts.Hours

        cell.lblEmpName.text = empName
        cell.lblDate.text = weekEnd
        cell.lblHours.text = hours
        cell.lblReference.text = String(format:"%@",ts.BillDate!)
 
        
        
        cell.evaluateButton.addTarget(self, action:#selector(self.evaluateButtonTapped), for: .touchUpInside)
        cell.evaluateButton.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.evaluateButton.setTitleColor(UIColor.white, for: .normal)

        
        cell.lblEmpNameTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.lblHoursTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.lblDateTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
         cell.lblReferenceTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        return cell
        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
        
    }
    @IBAction func evaluateButtonTapped(_ sender: UIButton){
        let senderPosition  = sender.convert(CGPoint.zero, to: listTableView)
        
        let indexPath =  listTableView.indexPathForRow(at:senderPosition)
        let s = approvedDatas[(indexPath?.row)!] as! GetApproveTimeSlip
 
 
        self.pushToViewEditPage(getApproveObj: s)
    }
    
    func pushToViewEditPage(getApproveObj: GetApproveTimeSlip ){
        
        
        
        
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is ApproveTimeSheetDetailsViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ApproveTimeSheetDetailsSegue") as! ApproveTimeSheetDetailsViewController
            
            nextViewController.getApproveTSObj = getApproveObj
            nextViewController.showOnlyView = false
            
            nextViewController.isFromApprovedList = false
            nextViewController.isFromTSYouHvApprovedList = true
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
     var isFromSafety = false
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var noDataLbl: UILabel!
    var menuTitle = ""
    var approvedDatas = NSMutableArray()
    @objc override func appWillEnterForeground(){
        print("appWillEnterForeground Division")
        if approvedDatas.count == 0{
            self.getTimeSlipYouHaveApprovedList()
            
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
self.getTimeSlipYouHaveApprovedList()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.listTableView.tableFooterView = UIView()
        
        if menuTitle.contains("View"){
            self.titlelbl.text = menuTitle.replace(target: "View", withString: "") //"eTimeslips you've approved"
        }else if menuTitle.count > 0{
            self.titlelbl.text = menuTitle
        }else{
            self.titlelbl.text = "eTimeslips you've approved"
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTimeSlipYouHaveApprovedList() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            let defaults = UserDefaults.standard
            
             let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
 
            //userid as String
            let params :[String:String] = ["ContactId":ContactId]
            print(params)
            RestAPI.getTimeSlipsYouHaveApproved(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
            
        }else{
             //            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    func getResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            
            //            self.ShowAlertMessage(message: response as! String, title: "")
             self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
                self.noDataLbl.isHidden = true
                let dataArray = object["ViewApprovedList"].array
                approvedDatas.removeAllObjects()
                
                for dict in dataArray! {
                    
                    let hours = String(format:"%.2f",dict["Hours"].doubleValue)
                    
                    let div = GetApproveTimeSlip.init(TypeValue: 0,
                                                      WeekEnding: dict["WeekEnd"].stringValue,
                                                      CandId: 0,
                                                      Name: dict["TempName"].stringValue,
                                                      Hours:  hours,
                                                      approvedBy: "",
                                                      referenceBy: "",
                                                      Approved: 0,
                                                      TimeId: dict["TimeId"].intValue,
                                                      isApproveSelected: 0,
                                                      OrderId: 0,
                                                      BillDate:dict["Billdate"].stringValue,
                                                      PrevBillDate:"",
                                                      ShowOT: "")
                    
                    approvedDatas.add(div)
                }
                listTableView.reloadData()
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                self.noDataLbl.isHidden = false
                if message == "No Records Found"{
                    self.noDataLbl.textColor = UIColor.black
                    self.noDataLbl.backgroundColor = UIColor.white

                }else{
                    self.noDataLbl.textColor = UIColor(hexString:danger_Color)
                    self.noDataLbl.backgroundColor = UIColor(hexString:danger_background_Color)

                }
                self.noDataLbl.text = message
                 self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
    }
    @IBAction override func okButtonTapped(_ sender: Any) {
        //        print("signoutButtonTapped")
        alertController.dismiss(animated: true, completion: nil)
         self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- GoBack
      override func goBack() {
          if isFromSafety {
              popToDasboardPageDirectly()
          }
          else {
              self.navigationController?.popViewController(animated: true)
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
