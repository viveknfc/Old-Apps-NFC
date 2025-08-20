//
//  DateSelection.swift
//  EMA
//
//  Created by NFC User on 5/17/21.
//

import UIKit

protocol popDateDelegate: class {
    func selectedDate(date:String, type: Int)
}

class DateSelection: UIView {
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var innerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    var topLabelText = String()
    var toCOntroller = UIViewController()
    weak var dateDelegate: popDateDelegate?
    var type = Int()
    var selectedDate = String()
    var maxdate = Date()
    var minDate = Date()
    @IBOutlet weak var doneButton: UIButton!
    func loadDateView() {
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.orientationChanged(notification:)),
            name: NSNotification.Name.UIDeviceOrientationDidChange,
            object: nil
        )
        topLabel.text = self.topLabelText
        topLabel.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        datePicker.tintColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        doneButton.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        
        if selectedDate.count > 0 {
            
            let lastWeekDate = Calendar.current.date(byAdding: .year, value: -60, to: Date())!
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.preferredLocale()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let lastWeekDateString = dateFormatter.string(from: lastWeekDate)
            let finalsixDate = dateFormatter.date(from: lastWeekDateString)
            
            
            if dateFormatter.date(from: selectedDate)! < finalsixDate! {
                let formatter = DateFormatter()
                formatter.locale = Locale.preferredLocale()
                formatter.dateFormat = "MM/dd/yyyy"
                selectedDate = formatter.string(from: Date())
                datePicker.setDate(Date(), animated: true)
            }
            else {
                let formatter = DateFormatter()
                formatter.locale = Locale.preferredLocale()
                formatter.dateFormat = "MM/dd/yyyy"
                datePicker.setDate(formatter.date(from: selectedDate)!, animated: true)
            }
        }
        else {
            let formatter = DateFormatter()
            formatter.locale = Locale.preferredLocale()
            formatter.dateFormat = "MM/dd/yyyy"
            selectedDate = formatter.string(from: Date())
            datePicker.setDate(Date(), animated: true)
            
        }
        if type == 0 {
            datePicker.maximumDate = Date()
        }
        else {
            datePicker.minimumDate = Date()
        }
        
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        switch UIDevice.current.orientation{
        case .portrait:
            innerViewHeight.constant = 460
        case .landscapeLeft:
            innerViewHeight.constant = self.bounds.size.height - 30
        case .landscapeRight:
            innerViewHeight.constant = self.bounds.size.height - 30
        default:
            print("Default")
        }
    }
    
    @objc func orientationChanged(notification: Notification) {
        // handle rotation here
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            innerViewHeight.constant = 460
           
        case .landscapeLeft:
            text="LandscapeLeft"
            innerViewHeight.constant = self.bounds.size.height - 30
           
        case .landscapeRight:
            text="LandscapeRight"
            innerViewHeight.constant = self.bounds.size.height - 30
            
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.locale = Locale.preferredLocale()
        let finalDate = formatter.string(from: datePicker.date)
        selectedDate = finalDate
        print(finalDate)
    }
    func removePickerViewFromSuperView(){
        
        self.frame = CGRect(x:0,y:UIScreen.main.bounds.size.height,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
        
        UIView.animate(withDuration: 2.8, animations:  {
            
            self.removeFromSuperview()
            
        }) { (animationComplete) in
        }
    }
    @IBAction func cancelClicked(_ sender: UIButton) {
        removePickerViewFromSuperView()
        
    }
    @IBAction func datePickerDoneClicked(_ sender: UIButton) {
        if selectedDate.count > 0 {
            removePickerViewFromSuperView()
            dateDelegate?.selectedDate(date: selectedDate, type: type)
        }
        else {
            let alert = UIAlertController(title:"Please \(topLabelText)", message: "", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "Ok",
                                   style: .default) { (action: UIAlertAction!) -> Void in
                
            }
            alert.addAction(ok)
            toCOntroller.present(alert, animated:true, completion:nil)
        }
    }
}
