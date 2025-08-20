//
//  TimeOutClass.swift
//  EWA
//
//  Created by NFC India on 07/06/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import Foundation
import UIKit

class TimeOutClass
{
    
    static let sharedInstance = TimeOutClass()
    
    var seconds = Constants.ApiTimeOut //This variable will hold a starting value of seconds. It could be any amount above 0.
    
    var timer = Timer()
    
    
    func runTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    @objc func updateTimer() {
        seconds -= 1
        if seconds<1
        {
            print("timed out")
            seconds = Constants.ApiTimeOut
            timer.invalidate()
            Constants.Token = ""
        }
        else
        {
//           print("running")
        }
//        print(seconds)
    }
    @objc func resetTimer()
    {
        print("***VIV reset Timer called")
        timer.invalidate()
        seconds =  Constants.ApiTimeOut
    }

}
