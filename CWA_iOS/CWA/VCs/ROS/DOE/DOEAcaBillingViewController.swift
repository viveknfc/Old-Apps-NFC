//
//  DOEAcaBillingViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 26/04/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON
class DOEAcaBillingViewController: BaseViewController {
   
    @IBOutlet var BillingTextView: UITextView!
    @IBOutlet var okButton: UIButton!
    var CandidateId = ""
    var HourlyPayRate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
self.getAcaBillingData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        
        
        self.titlelbl.text = "DOE Aca Billing"
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okButtonTappedOnVC(_ sender: UIButton){
       self.pushToDetailsPage()
    }
    func pushToDetailsPage(){
        var isControllerExists = false
        var vc = UIViewController()
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOEOrderDetailsViewController {
                    print("Your controller exist")
                    vc = viewController
                    isControllerExists = true
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
    func getAcaBillingData() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {

            let params :[String:String] = ["HourlyPayRate":HourlyPayRate,
                "CandidateId":CandidateId]
            
            print(params)
            
            RestAPI.getROSDOEAcaBillingData(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getROSResponse(response:))
        }else{
             self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    func getROSResponse(response:AnyObject)->()
    {
         print(response)
        if response is String{
             self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                let NoteMessage = object["Note"].stringValue
                let EmailMessage = object["ContactEmail"].stringValue
                let DOEMonthlyPayment = object["DOEMonthlyPayment"].stringValue
                
                let BillingMessage = String(format:"%@\n\n%@",NoteMessage,EmailMessage)
                var changeText = ""
                let attribute = NSMutableAttributedString.init(string: BillingMessage)
                let strNumber: NSString = BillingMessage as NSString
                changeText = DOEMonthlyPayment
                let range = (strNumber).range(of: changeText)
                attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15) , range: range)
                let range1 = (strNumber).range(of: EmailMessage)
                attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15) , range: range1)
                BillingTextView.attributedText =  attribute
                
            }
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
