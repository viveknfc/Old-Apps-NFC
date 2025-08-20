//
//  TimeMeridian.swift
//  Sambag
//
//  Created by Mounir Ybanez on 02/06/2017.
//  Copyright © 2017 Ner. All rights reserved.
//

public enum TimeMeridian {

    case am
    case pm
    case no
}

extension TimeMeridian: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .am: return "AM"
        case .pm: return "PM"
        case .no: return ""
        }
    }
}
