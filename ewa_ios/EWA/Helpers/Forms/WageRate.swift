//
//  WageRate.swift
//  EWA
//
//  Created by NFC India on 04/10/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON


protocol wageRateDelegate: class {
    func wageRateStatus(success:Bool)
}

class WageRate: UIView {
    
    @IBOutlet weak var scrollVview: UIScrollView!
    var object:JSON = JSON.null
    weak var wagRateDelegate: wageRateDelegate?
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var wageRateTextField: UITextField!
    @IBOutlet weak var wageRateCheckBoxOne: UIButton!
    @IBOutlet weak var wageRateCheckBoxTwo: UIButton!
    
    @IBOutlet weak var hiring: UIButton!
    @IBOutlet weak var onFeb: UIButton!
    @IBOutlet weak var beforeChange: UIButton!
    @IBOutlet weak var regularPay: UIButton!
    @IBOutlet weak var unknownPay: UIButton!
    @IBOutlet weak var avgRate: UIButton!
    @IBOutlet weak var employRate: UIButton!
    @IBOutlet weak var none: UIButton!
    @IBOutlet weak var tips: UIButton!
    @IBOutlet weak var meals: UIButton!
    @IBOutlet weak var loading: UIButton!
    @IBOutlet weak var other: UIButton!
    @IBOutlet weak var weekly: UIButton!
    @IBOutlet weak var biWeekly: UIButton!
    @IBOutlet weak var payOther: UIButton!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var doingBusinessLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var preparesNameLabel: UILabel!
    
    @IBOutlet weak var lsNumberLabel: UILabel!
    @IBOutlet weak var printButton: UIButton!
    @IBOutlet weak var fullWageRateLabel: UILabel!
    
    @IBOutlet weak var seventhPointExtraView: UIView!
    
    @IBOutlet weak var seventhPointConstaint: NSLayoutConstraint! //120 to 0
    func setUp()
    {
        scrollVview.scrollToTop(animated: false)
        firstView.layer.borderColor = UIColor.black.cgColor
        firstView.layer.borderWidth = 1.0
        firstView.layer.cornerRadius = 1.0
        
        let did = UserDefaults.standard.object(forKey: "dID") as! String
        if did == "50" || did == "117"{
            seventhPointExtraView.isHidden = false
            seventhPointConstaint.constant  = 120
        }
        else{
            seventhPointExtraView.isHidden = true
            seventhPointConstaint.constant  = 0
        }
        
        if object["Hiring"].boolValue == true
        {
            hiring.setImage(UIImage(named:"radio.png"), for:.normal)
        }
        if object["onorbeforefebfirst"].boolValue == true
        {
            onFeb.setImage(UIImage(named:"radio.png"), for:.normal)
        }
        if object["BeforeChangeInPayRate"].boolValue == true
        {
            beforeChange.setImage(UIImage(named:"radio.png"), for:.normal)
        }
        if object["RegularPayDay"].boolValue == true
        {
            regularPay.setImage(UIImage(named:"radio.png"), for:.normal)
        }
        if object["UnknownPayDay"].boolValue == true
        {
            unknownPay.setImage(UIImage(named:"radio.png"), for:.normal)
        }
        if object["AverageWageRate"].boolValue == true
        {
            avgRate.setImage(UIImage(named:"radio.png"), for:.normal)
        }
        if object["EmployeeRate"].boolValue == true
        {
            employRate.setImage(UIImage(named:"radio.png"), for:.normal)
        }
        if object["None"].boolValue == true
        {
            none.setImage(UIImage(named:"radio.png"), for:.normal)
        }
        if object["Tips"].boolValue == true
        {
            tips.setImage(UIImage(named:"radio.png"), for:.normal)
        }
        if object["Meals"].boolValue == true
        {
            meals.setImage(UIImage(named:"radio.png"), for:.normal)
        }
        if object["Lodging"].boolValue == true
        {
            loading.setImage(UIImage(named:"radio.png"), for:.normal)
        }
        if object["Other"].boolValue == true
        {
            other.setImage(UIImage(named:"radio.png"), for:.normal)
        }
        if object["Weekly"].boolValue == true
        {
            weekly.setImage(UIImage(named:"radio.png"), for:.normal)
        }
        if object["BiWeekly"].boolValue == true
        {
            biWeekly.setImage(UIImage(named:"radio.png"), for:.normal)
        }
        if object["OtherWeekly"].boolValue == true
        {
            other.setImage(UIImage(named:"radio.png"), for:.normal)
        }
        
        nameLabel.text = object["CompanyName"].stringValue
        doingBusinessLabel.text = object["DbaName"].stringValue
        addressLabel.text = object["CompAddress"].stringValue
        phoneLabel.text = object["CompPhone"].stringValue
        if object["PreparerName"].stringValue.count > 0
        {
            preparesNameLabel.text = object["PreparerName"].stringValue
        }
        else {
            preparesNameLabel.text = "Prasad Kadrikar"
        }
        fullWageRateLabel.text = object["WageRateFullText"].stringValue
        headerImageView.sd_setImage(with:URL(string: object["WageRateImageUrl"].stringValue), placeholderImage: UIImage(named:"placeholder.png"))
        headerLabel.text = object["WageRateHeading"].stringValue
        lsNumberLabel.text = object["WageRateLicense"].stringValue
        if object["WageRatePrint"].stringValue == "0"{
            printButton.isHidden = true
        }
        else{
            printButton.isHidden = false
        }
        
    }
    
    
    @IBAction func wageRateOneAction(_ sender: UIButton) {
        wageRateCheckBoxOne.setImage(UIImage(named: "radio.png"), for:.normal)
        wageRateCheckBoxTwo.setImage(UIImage(named: "circle.png"), for:.normal)
    }
    @IBAction func wageRateTwoAction(_ sender: UIButton) {
        wageRateCheckBoxOne.setImage(UIImage(named: "circle.png"), for:.normal)
        wageRateCheckBoxTwo.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    @IBAction func wageRateAction(_ sender: UIButton) {
        print("*********** Forms in formView is *********",object)
        
        let signView = Bundle.main.loadNibNamed("SignView", owner: nil, options: nil)![0] as! SignView
        signView.frame = CGRect(x:0,y:0, width:self.bounds.width, height:self.bounds.height)
        signView.setUp()
        signView.object = object
        signView.signDelegate = self
        self.addSubview(signView)
        self.bringSubview(toFront:signView)
    }
    // function to remove from superView
    func removePickerViewFromSuperView(){
        
        self.frame = CGRect(x:0,y:UIScreen.main.bounds.size.height,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
        
        UIView.animate(withDuration: 2.8, animations:  {
            
            self.removeFromSuperview()
            
        }) { (animationComplete) in
        }
    }
    
    @IBAction func printClciked(_ sender: UIButton) {
    }
}

extension WageRate:signatureDelagte
{
    func signatureStatus(success: Bool) {
        print("success")
        removePickerViewFromSuperView()
        wagRateDelegate?.wageRateStatus(success:true)
    }
    
}
extension UIScrollView {
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: 1,height: self.frame.height), animated: animated)
        }
    }
    
    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
    
}
