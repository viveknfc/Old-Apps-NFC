//
//  NotificationDetailsViewController.swift
//  EWA
//
//  Created by NFC India on 12/04/19.
//  Copyright © 2019 NFC. All rights reserved.
//

import UIKit
import  SwiftyJSON

class NotificationDetailsViewController: BaseViewController {

    //storyBorad reference's
    
    @IBOutlet weak var messageBodyLabel: UILabel!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    
    //varibale declarations
    var push = PushNotification.init(pushId:"", candidateId:"", subject:"", messageBody:"", messageType:0, dateTime:"",actionType:"")
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if push.actionType == "MSG"
        {
            self.title = "Message"
        }
        else
        {
            self.title = push.actionType
        }
        let height = Constants.calculateHeight(inString:push.messageBody, width:self.view.bounds.size.width-20)
        
        scrollHeight.constant = height+30
        messageBodyLabel.text = push.messageBody
        
    }
    
    
    
    
    
    

}
