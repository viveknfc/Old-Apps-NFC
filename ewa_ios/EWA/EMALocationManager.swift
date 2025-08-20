//
//  EMALocationManager.swift
//  EWA
//
//  Created by NFC User on 4/27/21.
//  Copyright © 2021 NFC. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import CoreLocation

class EMALocationManager: NSObject {
    

    private let locationManager: CLLocationManager =  CLLocationManager()

    var currentLocation: CLLocation? = nil

    static let shared: EMALocationManager = {
        let instance = EMALocationManager()
        return instance
    }()
    
    ///Start Location updation
    func requestLocationAtOnce() {
        
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer //kCLLocationAccuracyBest
            locationManager.distanceFilter = kCLLocationAccuracyHundredMeters //kCLDistanceFilterNone
            // locationManager.startUpdatingLocation()
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation() //iOS 9 and later
//        locationManager.startUpdatingLocation()

    }
    
    /// Get Permission from User
    func getPermission() -> Bool {
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            return true
        case .authorizedWhenInUse:
            return true
        case .denied, .restricted, .notDetermined:
            return false
            /*    case .restricted:
             return false
             case .notDetermined:
             locationManager.requestWhenInUseAuthorization()
             return getPermission()
             */
        }
        
        //  return false
    }
    
    
   
}

/// Location manager delegate methods
extension EMALocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print( "Did Location access permission was changed: \(status)")
        
        switch status {
        case .denied:
            print( "get Location permission to access")
           // self.displayAlertWithTitleMessageAndTwoButtons()
        case .notDetermined,.restricted:
            print( "get Location permission to access")
            manager.requestWhenInUseAuthorization()
        default:
            print( "Permission given")
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //  state = .updating
        
        manager.stopUpdatingLocation()
        
        if let location = locations.last, location.horizontalAccuracy >= 0 {
            print("the location from emalocation manager is",location)
        }
        
        if let newLocation = locations.last {
               currentLocation = newLocation
            
               print("Location updated: \(currentLocation?.coordinate)")

               let accuracy = newLocation.horizontalAccuracy
               print("Location accuracy: \(accuracy) meters")

               // You can use the accuracy information as needed for your application.
               // For example, you might want to check if the accuracy meets a certain threshold before considering the location valid.
               if accuracy <= 20 {
                   print("Location is accurate enough for your needs.")
               } else {
                   print("Location accuracy may not be sufficient for your needs.")
               }
           }
        
       // print("Location updated: \(String(describing: locations.first?.coordinate))")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // state = .failed
        print( "Failed to update Locations: \(error.localizedDescription)")
        
        manager.requestLocation() //iOS 9 and later
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        //  state = .paused
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        // state = .updating
    }
}
