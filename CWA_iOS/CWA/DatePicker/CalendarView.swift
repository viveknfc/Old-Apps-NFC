//
//  CalendarView.swift
//  CWA
//
//  Created by NFC Solutionsusa on 11/09/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarView: UIView {
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var bgButton: UIButton!
    @IBOutlet weak var calendarBGView: UIView!

    @IBOutlet weak var calendarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarBottomConstraint: NSLayoutConstraint!

    
    func setupCalendar(){
        //        self.view.addGestureRecognizer(self.scopeGesture)
        self.calendar.scope = .month
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        self.calendar.appearance.selectionColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        self.calendar.appearance.weekdayTextColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        self.calendar.appearance.headerTitleColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        self.calendar.appearance.todayColor = UIColor(hexString:"#EDEFF2")//bg circle
        self.calendar.appearance.titleTodayColor = UIColor.black

         self.calendarBGView.layer.borderColor = UIColor.black.cgColor
        self.calendarBGView.layer.borderWidth = 1

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
        
      
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.frame = CGRect(x:0,y:UIScreen.main.bounds.size.height,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
            
            UIView.animate(withDuration: 2.8, animations:  {
                
                self.removeFromSuperview()
                
            }) { (animationComplete) in
            }
        })
        
    }
    func showPickerViewInOrientation(superView:UIView,isPortrait: Bool) {
        
        if self.isDescendant(of: superView) {
            
            self.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
            
            var iphoneX = false
            if #available(iOS 11.0, *) {
                if isPortrait == true {
                    if ((UIApplication.shared.keyWindow?.safeAreaInsets.top)! > CGFloat(0.0)) {
                        iphoneX = true
                    }
                }else{
                    if ((UIApplication.shared.keyWindow?.safeAreaInsets.bottom)! > CGFloat(0.0)) {
                        iphoneX = true
                    }
                }
            }
            
            if isPortrait == false{
                if iphoneX == true{
                    self.calendarBottomConstraint.constant = CGFloat(25)

                    self.calendarTopConstraint.constant = UIScreen.main.bounds.size.height - 300
                }else{
                    self.calendarTopConstraint.constant = UIScreen.main.bounds.size.height - 250
                }
            }else{
                if iphoneX == true{
                    self.calendarBottomConstraint.constant = CGFloat(35)

                    self.calendarTopConstraint.constant = UIScreen.main.bounds.size.height - 350
                }else{
                    self.calendarTopConstraint.constant = UIScreen.main.bounds.size.height - 280
                }
            }
            self.layoutIfNeeded()
        }
    }
    func showPickerViewOnSuperView(superView:UIView ,isPortrait: Bool) {
        

        if !self.isDescendant(of: superView) {
             self.frame =    CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
            
            superView.addSubview(self)
            superView.bringSubviewToFront(self)
            
            var iphoneX = false
            var TopPadding = 0
            var BottomPadding = 0

            if #available(iOS 11.0, *) {
                if isPortrait == true {
                    if ((UIApplication.shared.keyWindow?.safeAreaInsets.top)! > CGFloat(0.0)) {
                        iphoneX = true
                    }
                }else{
                    if ((UIApplication.shared.keyWindow?.safeAreaInsets.bottom)! > CGFloat(0.0)) {
                        iphoneX = true
                    }
                }
            }
            
            if isPortrait == true {
                if iphoneX == true{
                    TopPadding = 350
                    BottomPadding = 35

                }else{
                    TopPadding = 280
                }
            }else{
                if iphoneX == true{
                    TopPadding = 300
                    BottomPadding = 25
                }else{
                    TopPadding = 250
                }
            }
            
            calendarTopConstraint.constant = UIScreen.main.bounds.size.height
            self.calendarBottomConstraint.constant = CGFloat(BottomPadding)

            UIView.animate(withDuration: 0.5, animations: {
                self.calendarTopConstraint.constant = UIScreen.main.bounds.size.height - CGFloat(TopPadding)

            }) { (animationComplete) in
            }
            
            self.layoutIfNeeded()
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
