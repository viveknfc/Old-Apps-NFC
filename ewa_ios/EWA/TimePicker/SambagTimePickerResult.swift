//
//  SambagTimePickerResult.swift
//  Sambag
//
//  Created by Mounir Ybanez on 02/06/2017.
//  Copyright © 2017 Ner. All rights reserved.
//

public struct SambagTimePickerResult {
    
    public var hour: Int
    public var minute: Int
    public var meridian: TimeMeridian
    
    public init() {
        self.hour = 0
        self.minute = 0
       self.meridian  = .am
    }
}

extension SambagTimePickerResult: CustomStringConvertible {
    
    public var description: String {
        if hour<=9
        {
            if minute<=9
            {
                return "0\(hour):0\(minute) \(meridian)"
            }
            else
            {
                return "0\(hour):\(minute) \(meridian)"
            }
        }
        else
        {
            if minute<=9
            {
                return "\(hour):0\(minute) \(meridian)"
            }
            else
            {
                return "\(hour):\(minute) \(meridian)"
            }
        }
    }
}
