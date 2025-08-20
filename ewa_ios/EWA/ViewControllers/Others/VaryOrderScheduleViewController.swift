//
//  VaryOrderScheduleViewController.swift
//  EWA
//
//  Created by NFC Solutions on 08/03/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import ANLoader

class VaryOrderScheduleViewController: UIViewController {
    var orderObject:JSON = JSON.null
    @IBOutlet var orderTableView: UITableView!
    var from = String()
    var orderId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.updateNavigationBarColor()
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        
        if #available(iOS 11.0, *) {
            orderTableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        if from == "PJB"
        {
            if ConnectionCheck.isConnectedToNetwork()
            {
                //ANLoader.showLoading()
                ServerService.showActivityIndicatory(uiView:self.view)
                let params:[String:String] = ["orderId":orderId]
                ServerService.personalJobBankVaryOrderSchedule(self, params: params, method: "POST",accessToken:Constants.Token, acces:true,callBack:getresponse(response:))
            }
            else
            {
                ANLoader.hide()
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            }
        }
        else
        {
            if ConnectionCheck.isConnectedToNetwork()
            {
                ANLoader.showLoading()
                let params:[String:String] = ["orderId":orderId]
                ServerService.assignmentsVaryOrderSchedule(self, params: params, method: "POST",accessToken:Constants.Token, acces:true,callBack:getresponse(response:))
            }
            else
            {
                ANLoader.hide()
                ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            }
        }
        
    }
    //aftergettingResponseFrom the server
    func getresponse(response:AnyObject)->()
    {
        print(response)
        ANLoader.hide()
        ServerService.hideProgressView()
        orderObject = response as! JSON
        if orderObject.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        orderTableView.reloadData()
        
    }
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "M/dd/yyyy HH:mm:ss z"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return  dateFormatter.string(from: date!)
        
    }
    
}
extension VaryOrderScheduleViewController:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 285
    }
}
extension VaryOrderScheduleViewController:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"vCell") as! VaryTableViewCell
        
        let date = orderObject["VaryOrderList"][indexPath.row]["EndOfWeek"].stringValue.components(separatedBy:"/")
        
        var month = String()
        var day = String()
        
        if date[0].count == 1
        {
            month.append("0"+date[0])
        }
        else
        {
            month = date[0]
        }
        if date[1].count == 1
        {
            day.append("0"+date[1])
        }
        else
        {
            day = date[1]
        }
        cell.dateLabel.text = "Week\(indexPath.row+1)"+" "+"\n"+orderObject["VaryOrderList"][indexPath.row]["StartOfWeek"].stringValue+"-"+month+"/"+day
        cell.mondayLabel.text = orderObject["VaryOrderList"][indexPath.row]["MonDay"].stringValue
        cell.tuesdayLabel.text = orderObject["VaryOrderList"][indexPath.row]["Tuesday"].stringValue
        cell.wednesdayLabel.text = orderObject["VaryOrderList"][indexPath.row]["WednesDay"].stringValue
        cell.thursdayLabel.text = orderObject["VaryOrderList"][indexPath.row]["ThursDay"].stringValue
        cell.fridayLabel.text = orderObject["VaryOrderList"][indexPath.row]["FriDay"].stringValue
        cell.saturdayLabel.text = orderObject["VaryOrderList"][indexPath.row]["SaturDay"].stringValue
        cell.sundayLabel.text = orderObject["VaryOrderList"][indexPath.row]["SunDay"].stringValue
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderObject["VaryOrderList"].arrayValue.count
    }
}


