//
//  JobDetailsViewController.swift
//  EWA
//
//  Created by NFC India on 21/01/19.
//  Copyright © 2019 NFC. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON
import FacebookShare
import FacebookCore

class JobDetailsViewController: UIViewController , SharingDelegate {

    
    
    // reference's from storyboard
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var jobTypeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var jobImageView: UIImageView!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var faceBookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var linkedin: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    
    
    
    
    // varaiable declarations
    var orderDetails:JSON = JSON.null
    var referedJob = ReferAFriend.init(title:"", jobType:"", categoryType:"", orderId:"", imageUrl:"", address:"",jobId:"")
    var candId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.navigationBar.barTintColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        
        let titleDict: NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.black] // viv - here it was white previously
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedString.Key : Any]
        
        self.navigationController?.navigationBar.tintColor = UIColor.black // viv - newly added

        
        
        jobTitleLabel.text = referedJob.title!
        categoryLabel.text = referedJob.categoryType!
        jobTypeLabel.text = referedJob.jobType!
        locationLabel.text = referedJob.address!
        jobImageView.sd_setImage(with:URL(string:referedJob.imageUrl!), placeholderImage: UIImage(named:"placeholder.png"))
        
        
        
        twitterButton.layer.cornerRadius = 25
        twitterButton.layer.masksToBounds = true
        
        linkedin.layer.cornerRadius = 25
        linkedin.layer.masksToBounds = true
        
        emailButton.layer.cornerRadius = 25
        emailButton.layer.masksToBounds = true
        
        self.title = "Job Details"
        
        candId = UserDefaults.standard.value(forKey:"cID") as! String
        print("***VIV the candId from JobDetailVC is \(candId)***")
        getOrderDetails()
    }
    
    //getting order details
    func getOrderDetails()
    {
        
        if ConnectionCheck.isConnectedToNetwork()
        {
            ServerService.showActivityIndicatory(uiView:self.view)
            let params:[String:Any] = ["JobId":referedJob.orderId!,"JobTitle":referedJob.title!,"CandId":candId]
            //viv- changed API from OrderID to JobId

            print("********Params For Order Details******",params)
            ServerService.referalGetJobDetails(self, params:params, method:"POST", accessToken:"247608:Y4y3oQqa7KU=", acces:true, callBack:self.getresponseForJobsDetails(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
        
        
    }
    //getresponseForJobsDetails Response
    func getresponseForJobsDetails(response:AnyObject)->()
    {
        
        ServerService.hideProgressView()
        orderDetails = response as! JSON
        print(orderDetails)
        if orderDetails["MessageStatus"].intValue == 1
        {
            companyNameLabel.text = orderDetails["CompanyName"].stringValue
            let description = orderDetails["JobDescription"].stringValue.replace(target:":", withString:"")
            descriptionLabel.attributedText = description.htmlToAttributedString
            let heightOfContent = descriptionLabel.attributedText!.height(withConstrainedWidth:self.view.bounds.size.width-30)
            print(descriptionLabel.attributedText!.height(withConstrainedWidth:self.view.bounds.size.width-30))
            
            scrollHeight.constant = 420+heightOfContent
            
        }
    }
    
    @IBAction func facebookAction(_ sender: UIButton) {
        
//        let content = LinkShareContent(url: URL(string:orderDetails["FBJobUrl"].stringValue.replace(target:"%26", withString:"&")+"9")!, quote:jobTitleLabel.text)
//        do
//        {
//            try ShareDialog.show(from:self, content: content)
//        }catch
//        {
//
//        }
        guard let url = URL(string: orderDetails["FBJobUrl"].stringValue.replace(target:"%26", withString:"&")+"9") else { return }
               let content = ShareLinkContent()
               content.contentURL = url
               self.showShareDialog(content)
        
    }
    
    func showShareDialog(_ content: ShareLinkContent,mode: ShareDialog.Mode = .automatic) {
        let dialog = ShareDialog(
            fromViewController: self,
            content: content,
            delegate: self
        )
        dialog.mode = mode
        dialog.show()
    }
    @IBAction func twitterAction(_ sender: UIButton) {
        //        https://twitter.com/intent/tweet?text=&url=
        
        let urlString = "https://twitter.com/intent/tweet?text=&url=\(orderDetails["TwitterJobUrl"].stringValue+"10")"
        
        
        guard let url = URL(string:urlString)  else { return }
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    
    @IBAction func linkedinAction(_ sender: UIButton) {
        
        let linkedinUrl = "http://www.linkedin.com/shareArticle?mini=true&url=\(orderDetails["LinkedInJobUrl"].stringValue.replace(target:"=", withString:"%3D")+"12")"
        
        
        guard let url = URL(string:linkedinUrl)  else { return }
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    @IBAction func emailAction(_ sender: UIButton) {
        self.performSegue(withIdentifier:"emailSegue", sender:nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "emailSegue"
        {
            let dvc = segue.destination as! SendEmailViewController
            dvc.jobDetails = orderDetails
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        }
    }
    
    
    @IBAction func applyJob(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "applyJob") as! ApplyJobViewController
        nextViewController.referedJob = referedJob
        nextViewController.jobDetails = orderDetails
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    //MARK:- Share Dialouge Delegates
       func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        print("completed sharing")
       }
       
       func sharer(_ sharer: Sharing, didFailWithError error: Error) {
           print("Error while sharing")
       }
       
       func sharerDidCancel(_ sharer: Sharing) {
           print("Pressed Cancel")
       }
}
