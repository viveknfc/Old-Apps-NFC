//
//  Constants.swift
//  EWA
//
//  Created by NFC Solutions on 20/11/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON



class Constants {
    
    static var globalPopupMessage = String()
    static var globalPopupStatus = -1
    static var globalPopupFormName = String()
    static var globalPopupFormLink = String()
    static var globalPopupKey = String()
       static var globalAlertStatus = -1
       
    static var DOEResponseObject:JSON = JSON.null
    // Color Codes
      
      static var info_Text = "Info"
         static var Warning_Text = "Warning"
         static var Success_Text = "Success"
         static var Danger_Text = "Danger"
         
         static var success_Color = "#3c763d"
         static var success_background_Color = "#dff0d8"
         static var success_border_Color = "#d6e9c6"
         
         static var info_Color = "#31708f"
         static var info_background_Color = "#d9edf7"
         static var info_border_Color = "#bce8f1"
         
         static var warning_Color = "#8a6d3b"
         static var warning_background_Color = "#fcf8e3"
         static var warning_border_Color = "#faebcc"
         
         static var danger_Color = "#a94442"
         static var danger_background_Color = "#f2dede"
         static var danger_border_Color = "#ebccd1"
    
    static  func calculateHeight(inString:String,width:CGFloat) -> CGFloat {
        let messageString = inString
        let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue) : UIFont.systemFont(ofSize:15.0)]
        
        let attributedString : NSAttributedString = NSAttributedString(string: messageString, attributes: attributes)
        
        let rect : CGRect = attributedString.boundingRect(with: CGSize(width:width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        let requredSize:CGRect = rect
        return requredSize.height
    }
    static  func calculateHeightWithFont(inString:String,width:CGFloat,font:UIFont) -> CGFloat {
        let messageString = inString
        let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue) :font]
        
        let attributedString : NSAttributedString = NSAttributedString(string: messageString, attributes: attributes)
        
        let rect : CGRect = attributedString.boundingRect(with: CGSize(width:width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        let requredSize:CGRect = rect
        return requredSize.height
    }
    static func getFormattedDate(string: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // This formate is input formated .
        let formateDate = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "dd  EEE" // Output Formated
        return dateFormatter.string(from: formateDate)
    }
    //function to get date
    static func getFormattedDateIn(string: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // This formate is input formated .
        let formateDate = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "dd  EEE" // Output Formated
        return dateFormatter.string(from: formateDate)
    }
    //function to get date
    static func getFormattedDateForEdit(string: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // This formate is input formated .
        let formateDate = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "MM/dd/yyyy" // Output Formated
        return dateFormatter.string(from: formateDate)
    }
    //function to get date
    static func getFormattedDateForEditTimeSlip(string: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.preferredLocale()
        dateFormatter.dateFormat = "MM/dd/yyyy" // This formate is input formated .
        let formateDate = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "dd   EEE" // Output Formated
        return dateFormatter.string(from: formateDate)
    }
}
