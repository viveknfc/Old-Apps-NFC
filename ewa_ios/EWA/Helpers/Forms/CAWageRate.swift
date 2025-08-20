//
//  CAWageRate.swift
//  EWA
//
//  Created by NFC India on 04/10/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON


protocol caWageRateDelegate: class {
    func caWageRateStatus(success:Bool)
}


class CAWageRate: UIView {

    
    var object:JSON = JSON.null
    weak var caWageRateDelegate: caWageRateDelegate?
    
    @IBOutlet weak var peoYes: UIButton!
    @IBOutlet weak var peoNo: UIButton!
    @IBOutlet weak var hour: UIButton!
    @IBOutlet weak var shift: UIButton!
    @IBOutlet weak var day: UIButton!
    @IBOutlet weak var week: UIButton!
    @IBOutlet weak var salary: UIButton!
    @IBOutlet weak var piecerRate: UIButton!
    @IBOutlet weak var comission: UIButton!
    @IBOutlet weak var caOther: UIButton!
    @IBOutlet weak var rateYes: UIButton!
    @IBOutlet weak var rateNo: UIButton!
    @IBOutlet weak var agYes: UIButton!
    @IBOutlet weak var agNo: UIButton!
    @IBOutlet weak var certCheck: UIButton!
    @IBOutlet weak var topUserLabel: UILabel!
    @IBOutlet weak var bottomUserLabel: UILabel!
    @IBOutlet weak var one: UIButton!
    @IBOutlet weak var two: UIButton!
    @IBOutlet weak var three: UIButton!
    @IBOutlet weak var four: UIButton!
    
    
    func setUp()
    {
        topUserLabel.text = """
        Employee
        Employee Name: \(UserDefaults.standard.object(forKey:"CandName") as! String)
        Start Date: 01/01/1900 12:00 AM
        Employer
        Legal Name of Hiring Employer: TemPositions Inc.
        Is hiring employer a staffing agency/business (e.g., Temporary Services Agency; Employee Leasing
        """
        
        bottomUserLabel.text = """
        Acknowledgment Of Receipt
        Prasad Kadrikar
        (PRINT NAME of Employer representative) \(UserDefaults.standard.object(forKey:"CandName") as! String)
        (PRINT NAME of Employee)
        Prasad Kadrikar
        (SIGNATURE of Employer representative) \(UserDefaults.standard.object(forKey:"CandName") as! String)
        (SIGNATURE of Employee)
        01/01/1753
        (Date provided to employee & signed by representative) 12/15/2017 12:00 AM
        (Date received by employee & signed by employee)
        
        We are required by law to provide you with a copy of this form. Select "E-Mail" below to have the form emailed to you or "Paper" to print out the form. The form will be emailed or printed when you press "Print Form".
        """
    }
    
    
    @IBAction func caWageRate(_ sender: UIButton) {
        print("*********** Forms in formView is *********",object)
        
        let signView = Bundle.main.loadNibNamed("SignView", owner: nil, options: nil)![0] as! SignView
        signView.frame = CGRect(x:0,y:0, width:self.bounds.width, height:self.bounds.height)
        signView.setUp()
        signView.object = object
        signView.signDelegate = self
        self.addSubview(signView)
        self.bringSubview(toFront:signView)
    }
    
    @IBAction func poeYes(_ sender: UIButton) {
        peoYes.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    
    @IBAction func poeNo(_ sender: UIButton) {
        peoNo.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    
    @IBAction func shiftAction(_ sender: UIButton) {
        shift.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    @IBAction func hrAction(_ sender: UIButton) {
        hour.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    
    @IBAction func dayAction(_ sender: UIButton) {
        day.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    
    @IBAction func weekAction(_ sender: Any) {
        week.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    
    @IBAction func salaryAction(_ sender: Any) {
        salary.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    
    @IBAction func rateAction(_ sender: Any) {
        piecerRate.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    @IBAction func comissionAction(_ sender: Any) {
        comission.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    @IBAction func otherAction(_ sender: Any) {
        caOther.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    
    @IBAction func payYes(_ sender: Any) {
        rateYes.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    @IBAction func payNo(_ sender: Any) {
        rateNo.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    
    @IBAction func agrYes(_ sender: Any) {
        agYes.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    @IBAction func agrNo(_ sender: Any) {
        agNo.setImage(UIImage(named: "radio.png"), for:.normal)
    }
    @IBAction func certAction(_ sender: Any) {
        certCheck.setImage(UIImage(named: "check.png"), for:.normal)
    }
    
    @IBAction func oneAction(_ sender: Any) {
        one.setImage(UIImage(named: "check.png"), for:.normal)
    }
    @IBAction func twoAction(_ sender: Any) {
        two.setImage(UIImage(named: "check.png"), for:.normal)
    }
    @IBAction func threeAction(_ sender: Any) {
        three.setImage(UIImage(named: "check.png"), for:.normal)
    }
    
    @IBAction func fourAction(_ sender: Any) {
        four.setImage(UIImage(named: "check.png"), for:.normal)
    }
    
    
    
    
    // function to remove from superView
    func removePickerViewFromSuperView(){
        
        self.frame = CGRect(x:0,y:UIScreen.main.bounds.size.height,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
        
        UIView.animate(withDuration: 2.8, animations:  {
            
            self.removeFromSuperview()
            
        }) { (animationComplete) in
        }
    }
    
}


extension CAWageRate:signatureDelagte
{
    func signatureStatus(success: Bool) {
        print("success")
        removePickerViewFromSuperView()
        caWageRateDelegate?.caWageRateStatus(success:true)
    }
    
}
