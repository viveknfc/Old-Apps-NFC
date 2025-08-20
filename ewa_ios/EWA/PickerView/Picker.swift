//
//  Picker.swift
//  cDemo
//
//  Created by NFC Solutions on 25/01/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

protocol pickerDelegate: class {
    func selected(time:String)
}


class Picker: UIView {
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var minPickerView: UIPickerView!
    weak var pickerDelegate: pickerDelegate?
    let hrs = ["00","01","02","03","04","05","06","07","08","09","10","11","12"]
    let mins = ["00","15","30","45","60"]

    @IBAction func cancelAction(_ sender: Any) {
        self.removePickerViewFromSuperView()
    }
    
    @IBAction func doneAction(_ sender: Any) {
        
        let hr = pickerView.selectedRow(inComponent:0)
        let min = minPickerView.selectedRow(inComponent:0)
        let time = "\(hrs[hr]):\(mins[min])"
        pickerDelegate?.selected(time:time)
        self.removePickerViewFromSuperView()
    }
    
    func removePickerViewFromSuperView(){
        
        self.frame = CGRect(x:0,y:UIScreen.main.bounds.size.height,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
        
        UIView.animate(withDuration: 0.50, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options:.curveEaseIn, animations:{
            self.removeFromSuperview()
            
        }) { (animationComplete) in
        }
    }
    func showPickerViewOnSuperView(superView:UIView) {
        
        self.frame = CGRect(x:0,y:UIScreen.main.bounds.size.height,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
        superView.addSubview(self)
        
        UIView.animate(withDuration: 0.50, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options:.curveEaseIn, animations: {
            self.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
            
        }) { (animationComplete) in
        }
    }
}

