//
//  EmpLocModel.swift
//  CWA
//
//  Created by NFC User on 1/28/19.
//  Copyright © 2019 NFC Solutionsusa. All rights reserved.
//

import UIKit

class EmpLocModel: NSObject {
 
    var Latitude: Double?
    var Longitude: Double?
    var first_Name: String?
    var Last_Name: String?
    var Order_id: Int?
    var LocationName: String?
    var Status: String?
    var Photo: String?
    var tintColor: String?
    var VehicalTime:String?
    var PublicTime:String?
    var WalkTime:String?
    var State:String?
    var Address:String?
    var Zip:String?
    var City:String?
    var DirectionUrl:String?
    
    
    /*
     {
       "DirectionUrl" : null,
       "Walking" : "5 h 35 m",
       "Pin_color" : "#CE4535",
       "Lastseen" : "3\/20\/2020 7:37:56 AM",
       "State" : "ts",
       "Address" : "Lb nagar",
       "Zip" : "500074",
       "TrackLickStatus" : 0,
       "Status" : 1,
       "first_Name" : "Test",
       "Order_id" : 1077992,
       "Driving" : "1 h 14 m",
       "City" : "hyderabad",
       "Latitude" : "17.4560358699241",
       "Photo" : null,
       "TimeDiff" : "00:00:29.5125215",
       "LastseenMessage" : "Active",
       "Longitude" : "78.3651182452483",
       "Cand_id" : 233451,
       "CandName" : null,
       "Last_Name" : "test55",
       "Transit" : "1 h 30 m"
     }
     */
    
//    "Order_id": 789904,
//    "Cand_id": 190855,
//    "Last_Name": "Pierre-Louis",
//    "first_Name": "Jeffrey",
//    "Photo": null,
//    "Latitude": null,
//    "Longitude": null
    //
    
    init(Latitude: Double?,Longitude: Double?,first_Name: String?,Last_Name: String?,LocationName: String?,Status: String?,Photo: String?,tintColor: String?,Order_id: Int?,VehicalTime:String?,PublicTime:String?,WalkTime:String?,State:String?,Address:String?,Zip:String?,City:String?,DirectionUrl:String?){
        
        self.Latitude = Latitude
        self.Longitude =  Longitude
        self.first_Name = first_Name
        self.Last_Name = Last_Name
        self.LocationName = LocationName
        self.Status = Status
        self.Photo = Photo
        self.tintColor = tintColor
        self.Order_id = Order_id
        self.VehicalTime = VehicalTime
        self.WalkTime = WalkTime
        self.PublicTime = PublicTime
        self.State = State
        self.Address = Address
        self.Zip = Zip
        self.City = City
        self.DirectionUrl = DirectionUrl

    }
    
 }

