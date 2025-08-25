//
//  CaptureClientLocation.swift
//  CWA
//
//  Created by NFC User on 4/8/21.
//  Copyright © 2021 NFC Solutionsusa. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import SwiftyJSON

class CaptureClientLocation: BaseViewController, GMSMapViewDelegate {
    @IBOutlet weak var locationMapView: GMSMapView!
    @IBOutlet weak var captureButton: UIButton!
 //   var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var screenName = String()
    var latToSend = Double()
    var lognToSend = Double()
    var addressToSend = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.title = screenName
        captureButton.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        // Do any additional setup after loading the view.
     /*
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        // locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation() //iOS 9 and later
 */
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        CMALocationManager.shared.requestLocationAtOnce()
        
        checkLocationAccess { hasAccess in
        
        if hasAccess
        {
            CMALocationManager.shared.requestLocationAtOnce()
            CMALocationManager.shared.requestLocationAtOnce()
            // Location Permission available
            self.locationMapView.delegate = self
            self.locationMapView.isMyLocationEnabled = true
            if let recentLocation = CMALocationManager.shared.currentLocation?.coordinate, CMALocationManager.shared.currentLocation?.horizontalAccuracy ?? -1 >= 0 {
                self.latToSend = recentLocation.latitude
                self.lognToSend = recentLocation.longitude
            }
//            print(latToSend)
//            print(lognToSend)
            let camera = GMSCameraPosition.camera(withLatitude: self.latToSend, longitude: self.lognToSend, zoom: 17)
            self.locationMapView.settings.allowScrollGesturesDuringRotateOrZoom = false
            self.locationMapView.animate(to: camera)
            self.locationMapView.settings.myLocationButton = true
            /*
             let initialLocation = CLLocationCoordinate2DMake(latToSend, lognToSend)
             let marker = GMSMarker(position: initialLocation)
             let markImage = UIImageView()
             markImage.image = UIImage(named: "pin")
             markImage.frame =  CGRect(x:0, y:0, width: 20 , height: 35)
             marker.iconView = markImage
             marker.map = self.locationMapView
             */
            self.addressToSend = self.reverseGeoCode(lat: self.latToSend, long: self.lognToSend)
        }
        else {
            // Location Permission not available
            self.askPermission()
        }
        
    }
        
       
    }
    //MARK:- Update Client Location
    @IBAction func updateClicked(_ sender: UIButton) {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            
            let params :[String:String] = ["ClientID":clientID,
                                           "Latitude":"\(latToSend)",
                                           "Longitude":"\(lognToSend)",
                                           "IsActive":"1",
                                           "Address":"\(addressToSend)",
                                           "ContactId":String(format: "%d", defaults.integer(forKey: "ContactId")),
                                           "Date":self.getToday()]
            
            print(params)
            
            RestAPI.updateLocationOfClient(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getROSResponse(response:))
        }else{
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    func getToday()-> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale()
        formatter.dateFormat = "MM/dd/yyyy"
        let result = formatter.string(from: date)
        return result
    }
    func getROSResponse(response:AnyObject)->()
    {
        JustHUD.shared.hide()
        print(response)
        if response is String{
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            let object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
            }else{
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }
    }
    
    // Camera change Position this methods will call every time
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker)
    {
        print("New Co-ordinates - \(marker.position)")
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition)
    {
        
        latToSend = mapView.camera.target.latitude
        lognToSend = mapView.camera.target.longitude
        print("Updated Location \(latToSend) , \(lognToSend)")
        //   self.getAddressFromCordinate(coordinate: CLLocationCoordinate2DMake(mapView.camera.target.latitude, mapView.camera.target.longitude))
    //    let camera = GMSCameraPosition.camera(withLatitude: latToSend, longitude: CMALocationManager.shared.currentLocation.coordinate.longitude, zoom: 30)
    //    locationMapView.settings.allowScrollGesturesDuringRotateOrZoom = false
      //  locationMapView.animate(to: camera)
        self.addressToSend = reverseGeoCode(lat: latToSend, long: lognToSend)
    }
    
    func getAddressFromCordinate(coordinate:CLLocationCoordinate2D)
    {
        
        let geocoder: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude:latToSend, longitude: lognToSend)
        geocoder.reverseGeocodeLocation(loc, completionHandler:
                                            {(placemarks, error) in
                                                if (error != nil)
                                                {
                                                    print("reverse geodcode fail: \(error!.localizedDescription)")
                                                }
                                                let pm = placemarks! as [CLPlacemark]
                                                
                                                if pm.count > 0 {
                                                    let pm = placemarks![0]
                                                    
                                                    // print (pm)
                                                    var addressString : String = ""
                                                    if pm.subLocality != nil {
                                                        addressString = addressString + pm.subLocality! + ", "
                                                    }
                                                    if pm.thoroughfare != nil {
                                                        addressString = addressString + pm.thoroughfare! + ", "
                                                    }
                                                    if pm.locality != nil {
                                                        addressString = addressString + pm.locality! + ", "
                                                    }
                                                    if pm.country != nil {
                                                        addressString = addressString + pm.country! + ", "
                                                    }
                                                    if pm.postalCode != nil {
                                                        addressString = addressString + pm.postalCode! + " "
                                                    }
                                                    
                                                    
                                                    print(addressString)
                                                    if let lines = pm.addressDictionary?["FormattedAddressLines"] as? [String] {
                                                        let placeString = lines.joined(separator: ", ")
                                                        // Do your thing
                                                        self.addressToSend = placeString
                                                        print("Norma Geo Code Address@@@ \(self.addressToSend)")
                                                    }
                                                }
                                            })
        
        let ggg = GMSGeocoder()
        var currentAddress = String()
        
        ggg.reverseGeocodeCoordinate(coordinate) { (response, error) in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                currentAddress = lines.joined(separator: "\n")
                print("Google SDK Address@@@ \(currentAddress)")
            }
        }
    }
    
//    func reverseGeoCode(lat: Double, long: Double)
//    {
//
//        var address = ""
//        DispatchQueue.global(qos:.userInitiated).async {
//
//            let urlString = String(format:"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&key=AIzaSyD6xpmUz94TVR3hUjKYEuBSILJJJoP70HQ",lat,long)
//
//            var request = URLRequest(url: URL(string:urlString)!)
//            request.httpMethod = "POST"
//            let postString: String = String(format:"")
//
//            request.httpBody = postString.data(using: .utf8)
//
//            URLSession.shared.dataTask(with:request) { (data, response, error) in
//                if error != nil
//                {
//                    print("error is ",error!)
//                }
//                else
//                {
//                    let  json = JSON(data!)
//                    //                    print("********Address********",json)
//                    OperationQueue.main.addOperation
//                    {
//
//                        if json["results"].null == nil{
//                            let results = json["results"]
//                            if results.count > 0{
//                                address =  json["results"][0]["formatted_address"].stringValue
//                                self.addressToSend = address
//                                print(address)
//                            }
//                        }
//                    }
//                }
//            }.resume()
//
//        }
//    }
    
    
}
/*
extension CaptureClientLocation: CLLocationManagerDelegate {
    
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
            
            let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, zoom: 20)
            locationMapView.settings.allowScrollGesturesDuringRotateOrZoom = false
            locationMapView.isMyLocationEnabled = true
            locationMapView.animate(to: camera)
            latToSend = (locationManager.location?.coordinate.latitude)!
            lognToSend = (locationManager.location?.coordinate.latitude)!
            // self.getAddressFromCordinate(coordinate: CLLocationCoordinate2DMake(locationMapView.camera.target.latitude, locationMapView.camera.target.longitude))
            self.reverseGeoCode(lat: latToSend, long: lognToSend)
          //  self.locationManager.stopUpdatingLocation()
        }
        
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
