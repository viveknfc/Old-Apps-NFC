//
//  WeeklyStaffingOrderDetailsViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 15/12/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//
//260542

import UIKit
import SwiftyJSON

class WeeklyStaffingOrderDetailsViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var listTableView: UITableView!
    var  dataArray = NSMutableArray()
var Schedule = ""
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var noDataView: UIView!

    var CandId = ""
    var OrderID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.title = "Weekly Staffing Schdule"
        listTableView.tableFooterView = UIView()
self.getOrderDetails()
        noDataView.isHidden = true
        noDataView.backgroundColor = UIColor(hexString:danger_background_Color)
        lblNoData.textColor = UIColor(hexString:danger_Color)

        // Do any additional setup after loading the view.
    }
    @objc override func appWillEnterForeground(){
        print("appWillEnterForeground Division")
        
        if dataArray.count == 0{
            self.getOrderDetails()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titlelbl.text = "Weekly Staffing Schedule"

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: TableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count //dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dict = dataArray[indexPath.row] as! NSDictionary
        if dict["name"] as? String == "Start-End Time"{
            
            let msh = Schedule
            
            let htmlString = "<html>" + msh + "</html>"
             let str  = htmlString.withoutHtml
            print(str)
            
 //            let options: [String: AnyObject] = [NSDocumentTypeDocumentAttribute.rawValue: NSHTMLTextDocumentType as AnyObject, NSCharacterEncodingDocumentAttribute.rawValue: String.Encoding.utf8 as AnyObject]
//            let attributedHTMLString = try! NSAttributedString(data: htmlStringData, options: options, documentAttributes: nil)
//            let string = attributedHTMLString.string

//            let attributed = try NSAttributedString(data: htmlString.data(using: .unicode)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)

            
            let messageText = htmlString.htmlToAttributedString
 
            let cell1 : DefaultTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DefaultTableViewCellIdentifier") as! DefaultTableViewCell
  
            cell1.lblDataText.text = dict["name"] as? String
            cell1.lblSubDataText.text = str
            
            cell1.lblSubDataText?.numberOfLines = 0
            cell1.lblSubDataText?.textColor = UIColor.darkGray
            cell1.lblDataText?.font = UIFont.boldSystemFont(ofSize: 14)
            cell1.lblSubDataText?.font = UIFont.systemFont(ofSize: 12)

            return cell1
            
        }
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?
        if !(cell != nil) {
            cell = UITableViewCell(style:.subtitle, reuseIdentifier: "CELL")
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        cell?.detailTextLabel?.numberOfLines = 0
        cell?.detailTextLabel?.textColor = UIColor.darkGray
        cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        
        cell?.textLabel?.text = dict["name"] as? String
        cell?.detailTextLabel?.text = dict["value"] as? String
        return cell!
        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dict = dataArray[indexPath.row] as! NSDictionary
 
        var value = ""
        
         if dict["name"] as? String == "Start-End Time"{
            
            value = Schedule
        }else{
            value = (dict["value"] as? String)!
        }

        
        
        let message  = String(format:"%@\n%@",(dict["name"] as? String)!,value)
        
        var height =  message.heightWithConstrainedWidth(width: UIScreen.main.bounds.size.width, font: UIFont.boldSystemFont(ofSize: 13))  //self.sizeOfString(string: message, constrainedToHeight: Double.greatestFiniteMagnitude).height + 80
        if dict["name"] as? String == "Start-End Time"{
            
            let htmlString = "<html>" + value + "</html>"
            let str  = htmlString.withoutHtml
            print(str)
//            return max(70, height+20)
            if UIDevice.current.modelName.contains("iPad"){
                if height > 100{
                    height = height + 140
                }else{
                    height = height + 30
                }
                return max(70, height)

            }
            
//            if height > 100{
//                height = height + 70
//            }else{
                height = height + 30
//            }
            return max(70, height)
            
        }
        return max(50, height)
    }
    // MARK: - SERVER CALL
    
    
    func getOrderDetails() {
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
 
 
            //userid as String
            let params :[String:String] = ["OrderId":OrderID,"CandId":CandId]
            print(params)
            RestAPI.getWeeklyStaffingSchduleDetails(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
        }else{
            
//            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

        }
        
        
    }
    
    func getResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        dataArray.removeAllObjects()
  
        print(response)
        if response is String{
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            noDataView.isHidden = false
            lblNoData.text = response as? String
        }else{
            
            var object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
                var jTitle = ""
                var reportTo = ""
             
                let objDict = object["WeeklyStaffInfo"].dictionary
                let startDate = self.getFormattedDate(string: (objDict!["StartDate"]?.stringValue)!)
                let endDate = self.getFormattedDate(string: (objDict!["EndDate"]?.stringValue)!  )

                let schoolNameDict = ["name":"School Name","value":(objDict!["CompName"]?.stringValue)!]
                let orderIDDict = ["name":"Order ID","value":OrderID]
                if objDict!["JobTitle"] != nil{
                    jTitle = (objDict!["JobTitle"]?.stringValue)!
                }
                let jobTitleDict = ["name":"Job Title","value":jTitle]
                if objDict!["ReportTo"] != nil{
                    reportTo = (objDict!["ReportTo"]?.stringValue)!
                }
                let reportToDict = ["name":"Report To","value":reportTo]
                let orderedByDict = ["name":"Ordered By","value":objDict!["OrderBy"]?.stringValue]
                let dateRangeDict = ["name":"Date Range","value":String(format:"%@ - %@",startDate,endDate)]
                let startendTimeDict = ["name":"Start-End Time","value": String(format:"%@ - %@",(objDict!["StartTime"]?.stringValue)!,(objDict!["EndTime"]?.stringValue)!)]
                let descDict = ["name":"Description","value":(objDict!["JobDesc"]?.stringValue)!]
                let referenceDict = ["name":"Reference Note","value":(objDict!["PONumber"]?.stringValue)!]
                let locationDict = ["name":"Location","value":(objDict!["Address"]?.stringValue)!]
                let cityDict = ["name":"City","value":(objDict!["City"]?.stringValue)!]
                let stateDict = ["name":"State","value":(objDict!["State"]?.stringValue)!]
                let zipDict = ["name":"Zip","value":(objDict!["Zip"]?.stringValue)!]
                Schedule =   object["Schedule"].stringValue

                dataArray = [schoolNameDict,orderIDDict,jobTitleDict,reportToDict,orderedByDict,dateRangeDict,startendTimeDict,descDict,referenceDict,locationDict,cityDict,stateDict,zipDict]
                noDataView.isHidden = true
                listTableView.reloadData()
            }else{
 
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                if message == "No Record Found"{
                    
                }else{
                    noDataView.isHidden = false
                    lblNoData.text = message
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)

//                    self.ShowAlertMessage(message: message, title: "")
                }
            }
        }
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        
        self.addDivisionNameOnTop()
        DispatchQueue.main.async(execute: { () -> Void in
            self.listTableView.reloadData()            })

        
     
       
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
extension String {
    public var withoutHtml: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }
        
        return attributedString.string
    }
}
