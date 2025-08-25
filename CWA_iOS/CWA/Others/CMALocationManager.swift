//
//  CMALocationManager.swift
//  CWA
//
//  Created by NFC User on 4/10/21.
//  Copyright © 2021 NFC Solutionsusa. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import CoreLocation

/*

class CMALocationManager: NSObject {
    

    private let locationManager: CLLocationManager =  CLLocationManager()

    var currentLocation = CLLocation()

    static let shared: CMALocationManager = {
        let instance = CMALocationManager()
        return instance
    }()
    
    ///Start Location updation
    func requestLocationAtOnce() {
        
        print("viv entering CMA location request location")
        
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation //kCLLocationAccuracyBest
            locationManager.distanceFilter = kCLLocationAccuracyHundredMeters //kCLDistanceFilterNone
            // locationManager.startUpdatingLocation()
            locationManager.requestWhenInUseAuthorization()
          //  locationManager.requestLocation() //iOS 9 and later
        locationManager.startUpdatingLocation()

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
extension CMALocationManager: CLLocationManagerDelegate {
    
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
        
        if ((locations.first?.coordinate) != nil) {
            
            currentLocation = locations.first!
            print( "Location updated: \(currentLocation.coordinate)")
            
            
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
 
 */

class CMALocationManager: NSObject {
    
    private let locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation? = nil
    
    static let shared: CMALocationManager = {
        let instance = CMALocationManager()
        return instance
    }()
    
    override init() {
        super.init()
        print("vivek enteres gowtham code")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
    }
    
    func requestLocationAtOnce() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func getPermission() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .denied, .restricted, .notDetermined:
            return false
        }
    }
}

extension CMALocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation() // added newly feb 24
        guard let newLocation = locations.last else { return }
        currentLocation = newLocation
        print("Location updated from gowtham: \(currentLocation?.coordinate)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to update Locations: \(error.localizedDescription)")
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        // Handle pause if needed
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        // Handle resume if needed
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    } }
