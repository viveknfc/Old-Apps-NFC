//
//  NotificationViewController.swift
//  EWA
//
//  Created by NFC India on 12/04/19.
//  Copyright © 2019 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import SideMenuController


class NotificationViewController: BaseViewController {
    
    // storyboardID literals shortcut
    var navigationLiterals = [["PJB":"Personal Job Bank"],["TIMESLIP":"Enter Timeslips"],["MSG":"Notifications"],["ASSM":"Assignments"],["ETC":"eTimeClock History"]]
    
    //reference's from the storyboard
    @IBOutlet weak var notificationTableView: UITableView!
    @IBOutlet weak var errorlabel: UILabel!
    
    //variable declaration's
    var pushNotiFicationobject:JSON = JSON.null
    var listOfPush = [PushNotification]()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Notifications"
        get_List_Of_Notifications()
    }
    
    
    //this function is to get the list of push notifications
    func get_List_Of_Notifications()
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:self.view)
            let params:[String:String] = ["CandidateId":UserDefaults.standard.object(forKey: "cID") as! String]
            print(params)
            ServerService.getListOfPush(self, params: params, method: "POST",accessToken:Constants.Token, acces:true,callBack:getresponse(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
        
    }
    
    ///*AfterHGettingResponse From the server for push notifcations list call back method*
    func getresponse(response:AnyObject)->()
    {
        print(response)
        ServerService.hideProgressView()
        pushNotiFicationobject = response as! JSON
        
        if pushNotiFicationobject["MessageStatus"].intValue == 1
        {
        for noti in 0..<pushNotiFicationobject["listPushnotificationsByCandidates"].arrayValue.count
        {
            let notification =  PushNotification.init(pushId:pushNotiFicationobject["listPushnotificationsByCandidates"][noti][""].stringValue, candidateId:pushNotiFicationobject["listPushnotificationsByCandidates"][noti]["Candidate"].stringValue, subject:pushNotiFicationobject["listPushnotificationsByCandidates"][noti]["Subject"].stringValue, messageBody:pushNotiFicationobject["listPushnotificationsByCandidates"][noti]["MessageBody"].stringValue, messageType:pushNotiFicationobject["listPushnotificationsByCandidates"][noti]["MessageType"].intValue,dateTime:pushNotiFicationobject["listPushnotificationsByCandidates"][noti]["DateSent"].stringValue, actionType:pushNotiFicationobject["listPushnotificationsByCandidates"][noti]["ActionType"].stringValue)
            listOfPush.append(notification)
        }
            notificationTableView.backgroundColor = UIColor.init(hexString:"#EFEFF4")
            errorlabel.isHidden = true
            notificationTableView.reloadData()
        }
        else
        {
            notificationTableView.backgroundColor = UIColor.clear
            errorlabel.isHidden = false
            if pushNotiFicationobject["Message"].stringValue == "Failure"
            {
                errorlabel.text = "\n No notifications found \n"
            }
            else
            {
                errorlabel.text = pushNotiFicationobject["Message"].stringValue
            }
        }
        
    }


}


//END OF THE CLASS


 //MARK: Extensions
extension NotificationViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfPush.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"notiCell") as! NotificationTableViewCell
        if listOfPush[indexPath.row].actionType == "MSG"
        {
            cell.titleLabel.text = "Message"
        }
        else
        {
        cell.titleLabel.text = listOfPush[indexPath.row].actionType
        }
        cell.subjectLabel.text = listOfPush[indexPath.row].subject
        cell.datetime.text = listOfPush[indexPath.row].dateTime
        cell.selectionStyle = .none
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        var height = Constants.calculateHeight(inString:listOfPush[indexPath.row].subject, width:self.view.bounds.size.width-20)
        height = height+50
        return (max(height,70))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let pushItem = listOfPush[indexPath.row]
        
        if pushItem.messageType == 1
        {
            pushToDetailPage(pushItem:pushItem)
        }
        else if pushItem.messageType == 2
        {
            //Transit Check
            pushToWebPage(pushItem:pushItem)
        }
        else if pushItem.messageType == 9
        {
            if pushItem.actionType == "PJB"
            {
            let dateString = String(listOfPush[indexPath.row].messageBody.suffix(21))
            let dates = dateString.components(separatedBy:"-")
            print(dates)
            Constants.PushDataFromNotification = dates
            }
            
            if let result = navigationLiterals.compactMap({$0[pushItem.actionType]}).first {
                let vc1:UIViewController = (self.storyboard?.instantiateViewController(withIdentifier:result))!
                let navi = BaseNaviViewController(rootViewController:vc1)
                navi.navigationBar.tintColor = .white
                navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                sideMenuController?.embed(centerViewController:navi, cacheIdentifier:result)

            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }

    //func pushing to detail page
    func pushToDetailPage(pushItem:PushNotification)
    {
        let vc = UIStoryboard.init(name:"Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"notiDetail") as! NotificationDetailsViewController
        vc.push = pushItem
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem 
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //func for pushing to webView
    func pushToWebPage(pushItem:PushNotification)
    {
        let vc = UIStoryboard.init(name:"Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"Transit Check") as! FormViewController
        vc.push = pushItem
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
