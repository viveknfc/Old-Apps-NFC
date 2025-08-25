//
//  EmployeeWithNoTimeSlipListViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 15/12/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON

class EmployeeWithNoTimeSlipListViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var dataArray = NSMutableArray()
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var lblTimeslipMessage: UILabel!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var refreshBtn: UIButton!
    
    var NoIbClient = ""
    var weekending = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "No Timeslips List"
refreshBtn.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        listTableView.tableFooterView = UIView()
        self.getEmployeesWithNoTimeSlip()
        // Do any additional setup after loading the view.
    }
    @objc override func appWillEnterForeground(){
        print("appWillEnterForeground Division")
        if dataArray.count == 0{
            self.getEmployeesWithNoTimeSlip()
        }
        
    }
    @IBAction func refreshButtonTapped(_ sender: UIButton){
        self.getEmployeesWithNoTimeSlip()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titlelbl.text = "Employees With No Timeslips List"

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:-  TABLEVIEW DATA SOURCE METHOD
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return dataArray.count
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell:EmpHistoryTableViewCell = listTableView.dequeueReusableCell(withIdentifier: "EmpHistoryTableViewCellIdentifier") as! EmpHistoryTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        cell.lblDateTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.lblSubjectTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        let dict = dataArray[indexPath.row] as! NSDictionary
        
        let name = dict["name"] as! String
        let ordernum = dict["value"] as! String
        cell.lblDate.text = name
        cell.lblSubjects.text = ordernum
        return cell
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    // MARK: - SERVER CALL
    
    
    func getEmployeesWithNoTimeSlip() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            
            let defaults = UserDefaults.standard
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let ContactId = String(format:"%d", defaults.integer(forKey: "ContactId"))
            
            let params :[String:String] = ["NoIbClient": NoIbClient,"Weekend": weekending,"ClientId": clientID,"ContactId": ContactId]
            
            
            print(params)
            
            RestAPI.getEmployeesWithNoTimeSlip(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
            
        }else{
            noDataView.isHidden = false
            lblNoData.text = "No Internet Connection"
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
                
                if object["TimeslipMessage"].stringValue.count > 0{
                let htmlString = "<html>" + object["TimeslipMessage"].stringValue
                
                lblTimeslipMessage.attributedText = htmlString.htmlToAttributedString
                }
 
                
                let array = object["NoTimeSlipOrderList"].array
                dataArray.removeAllObjects()
                for dict in array!{
                    let dictObj = ["name":dict["EmployeeName"].stringValue,"value":String(format:"%d",dict["Order"].intValue)]
                    dataArray.add(dictObj)
                }
                if dataArray.count == 0{
                    noDataView.isHidden = false
                    noDataView.backgroundColor = UIColor(hexString:danger_background_Color)
                    lblNoData.textColor = UIColor(hexString:danger_Color)
                    lblNoData.text = "No data available "

                }else{
                    noDataView.isHidden = true
                    
                }
                listTableView.reloadData()
                
                
            }else{
                
                var message = object["message"].stringValue
                
                if message.count == 0 {
                    
                    message = "There is some error"
                    
                }
                noDataView.backgroundColor = UIColor(hexString:danger_background_Color)
                lblNoData.textColor = UIColor(hexString:danger_Color)
                lblNoData.text = message
                noDataView.isHidden = false
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
    }
    
    //getEmployeesWithNoTimeSlip
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
