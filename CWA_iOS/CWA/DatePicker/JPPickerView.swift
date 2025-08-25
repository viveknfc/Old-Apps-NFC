//
//  JPPickerView.swift
//  BOW-Barber
//
//  Created by NFC Solutionsusa on 13/09/17.
//  Copyright © 2017 nfcsolutionsusa. All rights reserved.
//
//https://stackoverflow.com/questions/34155674/unable-to-pick-default-value-with-out-scrolling-in-picker-view

import UIKit

class JPPickerView: UIView {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var dtPickerView: UIDatePicker!
    @IBOutlet weak var dataPickerView: UIPickerView!
    @IBOutlet weak var pickerBgView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bgButton: UIButton!
    
    @IBOutlet weak var pickerBgTopConstraint: NSLayoutConstraint!
    
    func setupUI(){
        self.dtPickerView.setValue(UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String), forKey: "textColor")
        dtPickerView.tintColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        self.dtPickerView.backgroundColor = UIColor.white
        self.doneButton.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        self.dtPickerView.locale = NSLocale(localeIdentifier: "en_US") as Locale
        if #available(iOS 13.4, *) {
            dtPickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        pickerBgView.layer.borderColor = UIColor.black.cgColor
        pickerBgView.layer.borderWidth = 1
        //        pickerBgView.layer.borderColor = UIColor.lightGray.cgColor
        //        pickerBgView.layer.borderWidth = 1
        pickerBgView.backgroundColor = UIColor.white
        
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        self.removePickerViewFromSuperView()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        self.removePickerViewFromSuperView()
    }
    
    @IBAction func bgButtonTapped(_ sender: Any) {
        
        self.removeFromSuperview()
        
    }
    
    func removePickerViewFromSuperView(){
        
        self.frame = CGRect(x:0,y:UIScreen.main.bounds.size.height,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
        
        UIView.animate(withDuration: 2.8, animations:  {
            
            self.removeFromSuperview()
            
        }) { (animationComplete) in
        }
        
        
        
    }
    func showPickerViewInOrientation(superView:UIView,isPortrait: Bool) {
        
        if self.isDescendant(of: superView) {
            
            self.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
            
            var iphoneX = false
            if #available(iOS 11.0, *) {
                if ((UIApplication.shared.keyWindow?.safeAreaInsets.top)! > CGFloat(0.0)) {
                    iphoneX = true
                }
            }
            
            if isPortrait == false{
                if iphoneX == true{
                    self.pickerBgTopConstraint.constant = UIScreen.main.bounds.size.height - 250
                }else{
                    self.pickerBgTopConstraint.constant = UIScreen.main.bounds.size.height - 230
                }
            }else{
                if iphoneX == true{
                    self.pickerBgTopConstraint.constant = UIScreen.main.bounds.size.height - 280
                }else{
                    self.pickerBgTopConstraint.constant = UIScreen.main.bounds.size.height - 260
                }
            }
            
            self.layoutIfNeeded()
            
        }
        
    }
    func showPickerViewOnSuperView(superView:UIView ,isDatePicker: Bool,minuteInterval: Int,isPortrait: Bool) {
        
        
        if !self.isDescendant(of: superView) {
            
            self.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
            
            superView.addSubview(self)
            superView.bringSubviewToFront(self)
            if isDatePicker {
                dtPickerView.isHidden = false
                dataPickerView.isHidden = true
                dtPickerView.minuteInterval = minuteInterval
                
            }else{
                dtPickerView.isHidden = true
                dataPickerView.isHidden = false
                dataPickerView.reloadAllComponents()
                //                [dataPickerView selectRow:0 inComponent:0 animated:YES];
                dataPickerView.selectRow(0, inComponent: 0, animated: true)
            }
            var iphoneX = false
            var padding = 0
            
            if #available(iOS 11.0, *) {
                if ((UIApplication.shared.keyWindow?.safeAreaInsets.top)! > CGFloat(0.0)) {
                    iphoneX = true
                }
            }
            
            if isPortrait == true {
                if iphoneX == true{
                    padding = 280
                }else{
                    padding = 260
                }
            }else{
                
                let modelName = UIDevice.current.modelName
                if modelName.contains("iPad") //||  modelName.contains("Simulator")
                {
                    padding = 270
                }else{
                    if iphoneX == true{
                        padding = 250
                    }else{
                        padding = 230
                    }
                }

            }
            
            pickerBgTopConstraint.constant = UIScreen.main.bounds.size.height
            DispatchQueue.main.async(execute: { () -> Void in
                UIView.animate(withDuration: 0.5, animations: {
                    self.pickerBgTopConstraint.constant = UIScreen.main.bounds.size.height - CGFloat(padding)
                }) { (animationComplete) in
                }
                           self.layoutIfNeeded()
            })
        } else {
            self.removeFromSuperview()
        }
    }
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
