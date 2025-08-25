//
//  TrackEmpLocationVC.swift
//  CWA
//
//  Created by NFC User on 1/28/19.
//  Copyright © 2019 NFC Solutionsusa. All rights reserved.
//https://medium.com/@matschmidy/how-to-implement-custom-and-dynamic-map-marker-info-windows-for-google-maps-ios-e9d993ef46d4

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces
import SDWebImage
import SwiftyJSON

class TrackEmpLocationVC: BaseViewController {
    
    
    var isFailedServerCall = false
    
    let Office_Marker_Icon_View_TAG = 1010
    
    var OrderID = Int()
    var selectedInfoWindowIndex = -1
    @IBOutlet weak var empBgWhiteView: UIView!
    @IBOutlet weak var empView: UIView!
    @IBOutlet weak var empTableView: UITableView!
    @IBOutlet weak var empNumBtn: UIButton!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var empViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var allMarkers = [GMSMarker]()
    var allMarkerWindows = [MapMarkerWindow]()
    fileprivate var locationMarker : GMSMarker? = GMSMarker()
    var empLocationData = [EmpLocModel]()
    var officeInfoView = MapMarkerWindow()
    let Office_Image_Icon =  "office_icon"
    var OfficeAddress =   ""
    var OfficeLattitude =   Double(0)
    var OfficeLongitude =  Double(0)
    var locationDataObject:JSON = JSON.null
    var OrderStartTimeDate = String()
    
    //MARK: View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.titlelbl.text = "Candidate Location Details"
        //Location Manager code to fetch current location
        refreshButton.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        self.mapView.bringSubviewToFront(self.refreshButton)
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        empTableView.tableFooterView = UIView()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.updateEmpViewFrameForBtnIsSelected(isSelected: self.empNumBtn.isSelected)
        self.view.addSubview(self.empView)
        checkLocationAccess { hasAccess in
        if hasAccess
        {
            // Location Permission available
        }
        else {
            // Location Permission not available
            self.askPermission()
        }
    }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.empTableView.isHidden = false
        
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TrackEmpLocationVC.empListViewTapped(_:)))
        //empView.addGestureRecognizer(tapGesture)
        empView.isUserInteractionEnabled = true
        tapGesture.delegate = self
        self.empNumBtn.setTitle( "No candidates found" , for: .normal)
        // self.getHardcodedResponse()
        self.getCandidateLocationServerCall()
    }
    // MARK: Gesture
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if (touch.view?.isDescendant(of: empTableView))! {
            return false
        }
        return true
        
    }
    // MARK: Button Action
    
    @objc func empListViewTapped(_ sender: UITapGestureRecognizer)
    {
        self.removeEmpDropDownList()
    }
    @IBAction func candidateListBtnTapped(_ sender: UIButton){
        
        
        if self.empLocationData.count > 0{
            self.empView.backgroundColor  = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
            if sender.isSelected == true{
                sender.isSelected = false
            }else{
                sender.isSelected = true
            }
        }
        
        self.updateEmpViewFrameForBtnIsSelected(isSelected: sender.isSelected)
        
    }
    // MARK: Private Methods
    
    func removeEmpDropDownList(){
        
        self.updateEmpViewFrameForBtnIsSelected(isSelected: false)
        
    }
    
    
    // MARK: reverseGeoCode
    
    
    func getAddressFromLatLon(empObj: EmpLocModel)-> String {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double =  empObj.Latitude!
        //21.228124
        let lon: Double =  empObj.Longitude!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        var addressString : String = ""
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                DispatchQueue.main.async {
                    //  update UI here
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                            print("subLocality",addressString)
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                            print("thoroughfare",addressString)
                            
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                            print("locality",addressString)
                            
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                            print("country",addressString)
                            
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                            print("postalCode",addressString)
                            
                        }
                        print(empObj.first_Name!+addressString)
                        empObj.LocationName = addressString
                        DispatchQueue.main.async { [weak self] in
                            self?.empTableView.reloadData()
                        }
                    }
                }
        })
        return addressString
    }
    //MARK: Load markers
    
    func addOfficeMarkerOnMapWithLatLong(address: String,officeLat:Double ,officeLong:Double){
        let camera = GMSCameraPosition.camera(withLatitude: officeLat, longitude: officeLong, zoom: 10)
        self.mapView.camera = camera
        
        DispatchQueue.main.async(execute: {
            let marker = GMSMarker()
            // Assign custom image for each marker
            let markerImage = UIImage.init(named: self.Office_Image_Icon)
            let markerView = UIImageView(image: markerImage)
            marker.iconView = markerView
            marker.position = CLLocationCoordinate2D(latitude: officeLat  , longitude: officeLong  )
            marker.map = self.mapView
            marker.iconView!.tag = self.Office_Marker_Icon_View_TAG
            //Add Info window
            self.officeInfoView = MapMarkerWindow.instanceFromNib() as! MapMarkerWindow
            self.officeInfoView.profilePic.isHidden = true
            self.officeInfoView.nameLbl.isHidden = true
            self.officeInfoView.statusLbl.isHidden = true
            self.officeInfoView.walklabel.isHidden = true
            self.officeInfoView.publicTime.isHidden = true
            self.officeInfoView.vehicleTime.isHidden = true
            self.officeInfoView.busImage.isHidden = true
            self.officeInfoView.walkImageView.isHidden = true
            self.officeInfoView.carImageView.isHidden = true
            self.officeInfoView.tempositionLogo.isHidden = true
            
            let label = UILabel.init(frame: self.officeInfoView.frame)
            label.text = address
            label.textAlignment = .center
            label.textColor = UIColor.black
            label.font = UIFont.systemFont(ofSize: 14)
            label.numberOfLines = 0
            self.officeInfoView.addSubview(label)
            
        })
        
    }
    func addMarkerOnRespectiveLatLong(lat: Double,lon: Double,tintColor: UIColor){
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude:lat, longitude:lon)
        marker.icon = UIImage(named:"map_pin")
        marker.map = mapView
        allMarkers.append(marker)
    }
    func loadNiB() -> MapMarkerWindow {
        let infoWindow = MapMarkerWindow.instanceFromNib() as! MapMarkerWindow
        return infoWindow
    }
    
    func loadMarkersFromDB() {
        allMarkers.removeAll()
        self.mapView.clear()
        
        var count = 0
        for data in empLocationData{
            let d:EmpLocModel = data as EmpLocModel
            let latitude =  Double(d.Latitude!)
            let longitude =  Double(d.Longitude!)
            DispatchQueue.main.async(execute: {
                let marker = GMSMarker()
                // Assign custom image for each marker
                let markerImage = UIImage.init(named: "map_pin")
                if d.tintColor?.count == 0{
                    d.tintColor = "#23dwe2"
                }
                
                let iView = UIView(frame: CGRect(x:0,y:0,width:40,height:40))
                let image = markerImage?.maskWithColor(color: UIColor(hexString: d.tintColor!))
                let markerView = UIImageView(image: image)
                markerView.frame = CGRect(x:0,y:0,width:40,height:40)
                count = count+1
                
                //                   let empImageView = UIImageView(frame: CGRect(x:iView.center.x/2,y:5,width:20,height:20))
                //                 empImageView.layer.cornerRadius = 10
                //                 empImageView.layer.masksToBounds = true
                //                empImageView.image = UIImage(named: "12.jpg")
                let label = UILabel(frame: CGRect(x:iView.center.x/2,y:7,width:20,height:18))
                label.text = "\(count)"
                label.textColor = UIColor.black
                label.font = UIFont.boldSystemFont(ofSize: 12)
                label.textAlignment = .center
                label.backgroundColor = UIColor(hexString: d.tintColor!)
                iView.addSubview(markerView)
                iView.addSubview(label)
                
                marker.iconView = iView
                marker.position = CLLocationCoordinate2D(latitude: latitude  , longitude: longitude  )
                marker.map = self.mapView
                // *IMPORTANT* Assign all the spots data to the marker's userData property
                marker.userData = d
                self.allMarkers.append(marker)
                
            })
        }
        self.loadAllMarkerWindows()
    }
    func loadAllMarkerWindows(){
        allMarkerWindows.removeAll()
        for data in empLocationData{
            let markerData:EmpLocModel = data as EmpLocModel
            
            DispatchQueue.main.async(execute: {
                let infoView = MapMarkerWindow.instanceFromNib() as! MapMarkerWindow
                
                if markerData.tintColor?.count == 0{
                    markerData.tintColor = "#23dwe2"
                }
                
                infoView.profilePic.layer.borderColor = UIColor(hexString:markerData.tintColor!).cgColor
                infoView.profilePic.layer.cornerRadius = 25
                infoView.profilePic.layer.borderWidth = 2
                infoView.profilePic.layer.masksToBounds = true
                
                
                let name =  (markerData.first_Name)!+" "+(markerData.Last_Name)!
                let status = markerData.Status
                if (markerData.Photo?.count)! > 0{
                    DispatchQueue.main.async(execute: { () -> Void in
                        let decodedData = Data(base64Encoded:markerData.Photo!, options: .ignoreUnknownCharacters)
                        let decodedimage = UIImage(data:decodedData!)
                        print(decodedimage!)
                        if decodedimage != nil{
                            infoView.profilePic.image = decodedimage
                        }
                    })
                }else{
                    infoView.profilePic.image = UIImage(named: "Avatar")
                }
                
                //infoView.profilePic.image = UIImage(named: "12.jpg")
                
                infoView.nameLbl.text = name
                infoView.statusLbl.text = status
                infoView.publicTime.text = markerData.PublicTime
                infoView.vehicleTime.text = markerData.VehicalTime
                infoView.walklabel.text = markerData.WalkTime
                infoView.tempositionLogo.sd_setImage(with: URL(string:self.locationDataObject["OfficeLogo"].stringValue), placeholderImage: UIImage(named: ""))
                self.allMarkerWindows.append(infoView)
            })
        }
    }
    
    
    // MARK: - SERVER CALL
    func getCandidateLocationServerCall() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            let defaults = UserDefaults.standard
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            
            //userid as String
            let params :[String:String] = ["OrderId":"\(self.OrderID)","ClientID":clientID,"OrderStartTime":OrderStartTimeDate]
            print(params)
            RestAPI.getCandidateLocationDetails(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
            
        }else{
            isFailedServerCall = true
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    
    func getResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            isFailedServerCall = true
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            let object = response as! JSON
            locationDataObject = object
            
            if object["MessageStatus"].intValue == 1
            {
                
                self.empLocationData.removeAll()
                if object["candDetailslist"].null == nil{
                    //  self.empLocationData.removeAll()
                    let locList = object["candDetailslist"].array
                    
                    var  emp = EmpLocModel.init(Latitude: 0, Longitude: 0, first_Name: "", Last_Name: "", LocationName: "", Status: "", Photo: "", tintColor: "", Order_id: 0, VehicalTime:"", PublicTime:"", WalkTime:"",State: "",Address: "",Zip: "",City: "",DirectionUrl: "")
                    
                    for dict in locList!{
                        var lastSeen = String() //LocationMessage
                        if dict["LocationMessage"].stringValue.count > 0 {
                            lastSeen = dict["LocationMessage"].stringValue
                        }
                        else {
                            lastSeen = dict["LastseenMessage"].stringValue
//                            if lastSeen.count == 0 && dict["Lastseen"].stringValue.count > 0{
//                                lastSeen = "Last seen on "+dict["Lastseen"].stringValue
//                            }
                        }
                        let loc = EmpLocModel.init(Latitude: dict["Latitude"].doubleValue, Longitude: dict["Longitude"].doubleValue, first_Name: dict["first_Name"].stringValue, Last_Name:  dict["Last_Name"].stringValue, LocationName:  "", Status:  lastSeen, Photo:  dict["Photo"].stringValue, tintColor:  dict["Pin_color"].stringValue, Order_id:  dict["Order_id"].intValue, VehicalTime:dict["Driving"].stringValue.count>0 ?dict["Driving"].stringValue:"--" , PublicTime:dict["Transit"].stringValue.count>0 ? dict["Transit"].stringValue:"--", WalkTime:dict["Walking"].stringValue.count>0 ?
                            dict["Walking"].stringValue:"--", State: dict["State"].stringValue,Address: dict["Address"].stringValue,Zip: dict["Zip"].stringValue,City: dict["City"].stringValue,DirectionUrl: dict["DirectionUrl"].stringValue)
                        
                        if dict["Longitude"].doubleValue == 0 && dict["Latitude"].doubleValue == 0{
                            loc.LocationName = "Address not updated"
                        }else{
                            emp = loc
                        }
                        self.empLocationData.append(loc)
                    }
                    //reverse geo code for getting address
                    for dict in self.empLocationData{
                        DispatchQueue.main.async { [weak self] in
                            if dict.Longitude == 0 && dict.Latitude == 0{
                            }else{
                                let address = self?.reverseGeoCode(empObj: dict) //self!.getAddressFromLatLon(empObj: dict)
                                print(address!)
                            }
                        }
                    }
                    
                    let text = self.empLocationData.count == 1 ? "1 Candidate found" : "\(self.empLocationData.count)"+" "+"Candidates found"
                    
                    self.empNumBtn.setTitle(text, for: .normal)
                    
                    if self.empLocationData.count > 0{
                        DispatchQueue.main.async { () -> Void in
                            if emp.Longitude == 0 && emp.Latitude == 0{
                            }else{
                                self.loadMarkersFromDB()
                            }
                        }
                    }
                    OfficeAddress = object["OfficeAddress"].null == nil ? object["OfficeAddress"].stringValue : ""
                    OfficeLattitude = object["OfficeLattitude"].null == nil ? object["OfficeLattitude"].doubleValue : Double(0)
                    OfficeLongitude = object["OfficeLongitude"].null == nil ? object["OfficeLongitude"].doubleValue : Double(0)
                    if (OfficeLattitude == 0 || OfficeLongitude == 0 ) {
                        let camera = GMSCameraPosition.camera(withLatitude: emp.Latitude!, longitude: emp.Longitude!, zoom: 16)
                        self.mapView.camera = camera
                        self.OfficeAddress = ""
                    }else{
                        //camera will zoom to office address
                        
                        self.addOfficeMarkerOnMapWithLatLong(address: OfficeAddress,officeLat:OfficeLattitude ,officeLong:OfficeLongitude)
                        
                    }
                    self.empTableView.reloadData()
                    
                    
                }else{
                    isFailedServerCall = true
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: Error_Message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                }
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    message = Error_Message
                }
                isFailedServerCall = true
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
            
        }
    }
    
    
    //MARK:  Screen Rotation
    func updateEmpViewFrameForBtnIsSelected(isSelected: Bool){
        
        var iphoneX = false
        if #available(iOS 11.0, *) {
            if self.isPortrait() == true {
                if ((UIApplication.shared.keyWindow?.safeAreaInsets.top)! > CGFloat(20.0)) {
                    iphoneX = true
                }
            }else{
                if ((UIApplication.shared.keyWindow?.safeAreaInsets.bottom)! > CGFloat(20.0)) {
                    iphoneX = true
                }
            }
        }
        
        if isSelected == false{
            if iphoneX == true{
                self.empView.frame = CGRect(x:0,y: UIScreen.main.bounds.size.height - 80,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height/2)
            }else{
                
                self.empView.frame = CGRect(x:0,y: UIScreen.main.bounds.size.height - 60,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height/2)
            }
            
            UIView.animate(withDuration: 3.0, animations: {
                self.empViewTopConstraint.constant = 0
            }, completion: nil)
            self.view.layoutIfNeeded()
            self.arrowImageView.image = UIImage.init(named: "up_arrow")
            self.empView.backgroundColor = UIColor.white
            self.view.layoutIfNeeded()
            self.empTableView.isHidden = true
        }else{
            self.empView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
            self.arrowImageView.image = UIImage.init(named: "Down_arrow")
            self.empView.frame = CGRect(x:0,y: 0,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.empViewTopConstraint.constant = UIScreen.main.bounds.size.height
            UIView.animate(withDuration: 3.0, animations: {
                self.empViewTopConstraint.constant = UIScreen.main.bounds.size.height/2 - 100
            }, completion: nil)
            self.view.layoutIfNeeded()
            self.empTableView.isHidden = false
        }
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.addDivisionNameOnTop()
            self.updateEmpViewFrameForBtnIsSelected(isSelected: self.empNumBtn.isSelected)
        })
        
    }
    @IBAction override func okButtonTapped(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        if isFailedServerCall == true{
            
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    
    func getHardcodedResponse(){
        var address = ""
        
        let e2 = EmpLocModel.init(Latitude: 17.4099, Longitude: 78.4732, first_Name: "Riky2  ", Last_Name:  "Pointing2", LocationName:  address, Status:  "Lumbini park", Photo:  "", tintColor:  "#719b84", Order_id:  11, VehicalTime:"", PublicTime: "", WalkTime:"",State: "",Address: "",Zip: "",City: "",DirectionUrl: "")
        let e3 = EmpLocModel.init(Latitude: 17.0501, Longitude: 78.8766, first_Name: "Riky3  ", Last_Name:  "Pointing3", LocationName:  address, Status:  "Secmec", Photo:  "", tintColor:  "#f0b5bc", Order_id:  12,VehicalTime: "", PublicTime: "", WalkTime: "",State: "",Address: "",Zip: "",City: "",DirectionUrl: "")
        let e4 = EmpLocModel.init(Latitude: 17.4062, Longitude: 78.4691, first_Name: "Riky4  ", Last_Name:  "Pointing4", LocationName:  address, Status:  "Birla temple", Photo:  "", tintColor:  "#11526c", Order_id:  13,VehicalTime: "", PublicTime: "", WalkTime:"",State: "",Address: "",Zip: "",City: "",DirectionUrl: "")
        let e5 = EmpLocModel.init(Latitude: 17.3313, Longitude: 78.4662, first_Name: "Riky5  ", Last_Name:  "Pointing1", LocationName:  address, Status:  "Taj Falaknuma Palace", Photo:  "", tintColor:  "#74647b", Order_id:  10,VehicalTime:"", PublicTime:"", WalkTime:"",State: "",Address: "",Zip: "",City: "",DirectionUrl: "")
        
        let e6 = EmpLocModel.init(Latitude: 17.3713, Longitude: 78.4804, first_Name: "Riky6  ", Last_Name:  "Pointing2", LocationName:  address, Status:  "Salar Jung Museum", Photo:  "", tintColor:  "#9c4f65", Order_id:  11,VehicalTime:"", PublicTime:"", WalkTime:"",State: "",Address: "",Zip: "",City: "",DirectionUrl: "")
        let e7 = EmpLocModel.init(Latitude: 17.4948, Longitude: 78.3996, first_Name: "Riky7  ", Last_Name:  "Pointing3", LocationName:  address, Status:  "The Swayamvar,Forum ", Photo:  "", tintColor:  "#8c574c", Order_id:  12,VehicalTime:"", PublicTime:"", WalkTime:"",State: "",Address: "",Zip: "",City: "",DirectionUrl: "")
        let e8 = EmpLocModel.init(Latitude: 17.4475, Longitude: 78.3556, first_Name: "Riky8  ", Last_Name:  "Pointing4", LocationName:  address, Status:  "DLF", Photo:  "", tintColor:  "#b33044", Order_id:  13,VehicalTime:"", PublicTime:"", WalkTime:"",State: "",Address: "",Zip: "",City: "",DirectionUrl: "")
        
        
        self.empLocationData.append(e2)
        self.empLocationData.append(e3)
        self.empLocationData.append(e4)
        self.empLocationData.append(e5)
        self.empLocationData.append(e6)
        self.empLocationData.append(e7)
        self.empLocationData.append(e8)
        
        for dict in self.empLocationData{
            DispatchQueue.main.async { [weak self] in
                address =    self!.getAddressFromLatLon(empObj: dict)
                print(address)
            }
        }
        
        self.empTableView.reloadData()
        self.loadMarkersFromDB()
        
        let totalCandidate =  "\(empLocationData.count)"+" Candidates found"
        
        self.empNumBtn.setTitle(totalCandidate, for: .normal)
        let camera = GMSCameraPosition.camera(withLatitude: 17.5141, longitude: 78.3930, zoom: 16)
        self.mapView.camera = camera
        //        self.addOfficeMarkerOnMapWithLatLong(address: "")
    }
    func reverseGeoCode(empObj: EmpLocModel)-> String
    {
        let lat: Double =  empObj.Latitude!
        //21.228124
        let long: Double =  empObj.Longitude!
        
        var address = ""
        DispatchQueue.global(qos:.userInitiated).async {
            
            let urlString = String(format:"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&key=AIzaSyD6xpmUz94TVR3hUjKYEuBSILJJJoP70HQ",lat,long)
            
            var request = URLRequest(url: URL(string:urlString)!)
            request.httpMethod = "POST"
            let postString: String = String(format:"")
            
            request.httpBody = postString.data(using: .utf8)
            
            URLSession.shared.dataTask(with:request) { (data, response, error) in
                if error != nil
                {
                    print("error is ",error!)
                }
                else
                {
                    let  json = JSON(data!)
                    //                    print("********Address********",json)
                    OperationQueue.main.addOperation
                        {
                            //                             print("********Address format ********", json["results"][0]["formatted_address"].stringValue)
                            
                            if json["results"].null == nil{
                                let results = json["results"]
                                if results.count > 0{
                                    address =  json["results"][0]["formatted_address"].stringValue
                                    print(empObj.first_Name!+address)
                                    empObj.LocationName = address
                                    
                                    DispatchQueue.main.async { [weak self] in
                                        self?.empTableView.reloadData()
                                    }
                                }
                            }
                    }
                }
            }.resume()
            
        }
        return address
    }
    
    //MARK:- GetDirections Action
    @objc func getDirectionsClicked(_ sender: UIButton){
        print(sender.tag)

        let object:EmpLocModel = self.empLocationData[sender.tag]
        
        checkLocationAccess { hasAccess in
        if hasAccess
            {
            DispatchQueue.main.async {
            
            //            let address = object.Address!+object.City!+object.State!+object.Zip!
            //            if let url = URL(string:"comgooglemaps://?saddr=&daddr=\(address.replace(target:" ", withString:""))&directionsmode=driving") {
            //                UIApplication.shared.open(url, options: [:])
            //            }
            //            else {
            NSLog("Can't use comgooglemaps://")
            self.moveTowebView(object.DirectionUrl!)
            //    }
        }
            
        }
        else
        {
            let alertController = UIAlertController(title: "", message: "Allow Client Mobile Access to access your location and try again", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "DENY", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("Cancel Pressed")
                // self.link = self.object["DirectionUrl"].stringValue
                // self.performSegue(withIdentifier: "webSegue", sender: nil)
                self.moveTowebView(object.DirectionUrl!)
            }
            
            let okAction = UIAlertAction(title: "ALLOW", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
                if let bundleId = Bundle.main.bundleIdentifier,
                   let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            
            // Add the actions
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
        }
    }
    }
    
    func moveTowebView(_ directURLStr: String){
        // let link =  "https://www.google.com/maps/dir/Cyber+Towers,+Hitech+City+Road,+Patrika+Nagar,+HITEC+City,+Hyderabad,+Telangana/NFC+Solutions+India,+2nd+Floor,+MR+Prime,+Survey+No.6,+BP+Raju+Marg+Behind+Ratnadeep+Super+Market,+Whitefields,+Kondapur,+Hyderabad,+Telangana+500084/@17.4521814,78.3661098,15z/data=!3m1!4b1!4m14!4m13!1m5!1m1!1s0x3bcb93ded9f6f0d7:0xa3d91e5d00d50b63!2m2!1d78.3810382!2d17.4504102!1m5!1m1!1s0x3bcb93c0bb6c1383:0xb68ccf10a7303c60!2m2!1d78.3653053!2d17.4558391!3e0"
        let link = directURLStr
        let storyBoard : UIStoryboard = UIStoryboard(name: "Location", bundle:nil)
        let screen = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        screen.link = link
        self.navigationController?.pushViewController(screen, animated: true)
    }
    
    //MARK:- RefreshDataAction
    
    @IBAction func reloadDataClicked(_ sender: UIButton) {
        self.getCandidateLocationServerCall()
    }
    
}


extension TrackEmpLocationVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.empLocationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:TrackEmpLocCell = tableView.dequeueReusableCell(withIdentifier: "TrackEmpLocCell") as! TrackEmpLocCell
        //cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        
        
        
        let obj:EmpLocModel = self.empLocationData[indexPath.row]
        cell.lblName.text = obj.first_Name!+" "+obj.Last_Name!
        cell.lblStatus.text = obj.Status
        cell.lblAddress.text = obj.LocationName
        
        if obj.LocationName == "Address not updated"
        {
            cell.lblStatus.isHidden = true
            cell.busImageView.isHidden = true
            cell.carImageView.isHidden = true
            cell.walkImageView.isHidden = true
            cell.vehicleLabel.isHidden = true
            cell.publicLabel.isHidden = true
            cell.walklabel.isHidden = true
        }
        
        
        cell.vehicleLabel.text = obj.VehicalTime
        cell.publicLabel.text = obj.PublicTime
        cell.walklabel.text = obj.WalkTime
        
        if obj.tintColor?.count == 0{
            obj.tintColor = "#23dwe2"
        }
        
        cell.profilePic.layer.cornerRadius = 35
        cell.profilePic.layer.borderColor = UIColor(hexString:obj.tintColor!).cgColor
        cell.profilePic.layer.borderWidth = 3
        cell.profilePic.layer.masksToBounds = true
        cell.lblNum.text = "\(indexPath.row+1)"
        cell.lblNum.layer.cornerRadius = 10
        cell.lblNum.layer.masksToBounds = true
        cell.lblNum.backgroundColor = UIColor(hexString:obj.tintColor!)
        if (obj.Photo?.count)! > 0{
            DispatchQueue.main.async(execute: { () -> Void in
                let decodedData = Data(base64Encoded:obj.Photo!, options: .ignoreUnknownCharacters)
                let decodedimage = UIImage(data:decodedData!)
                print(decodedimage!)
                if decodedimage != nil{
                    cell.profilePic.image = decodedimage
                }
            })
        }else{
            cell.profilePic.image = UIImage(named: "Avatar")
        }
        cell.selectionStyle = .none
        if obj.DirectionUrl!.count > 0 {
            cell.getDirectionsButton.isEnabled = true
        }
        else {
            cell.getDirectionsButton.isEnabled = false
        }
        cell.getDirectionsButton.tag = indexPath.row
        cell.getDirectionsButton.addTarget(self, action: #selector(getDirectionsClicked(_ :)), for: .touchUpInside)
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        let obj:EmpLocModel = self.empLocationData[indexPath.row]
        let name = obj.first_Name!+" "+obj.Last_Name!
        let address = obj.LocationName
        let status = obj.Status
        let message = String(format: "%@%@%@",name,status!,address!)
        
        let height =  message.heightWithConstrainedWidth(width: UIScreen.main.bounds.size.width, font: UIFont.boldSystemFont(ofSize: 14))
        
        return height+90+35
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.removeEmpDropDownList()
        
        // your code here
        let emp:EmpLocModel = self.empLocationData[indexPath.row]
        if emp.Longitude == 0 && emp.Latitude == 0{
            self.navigationController?.view.makeToast("Address not updated", duration: 1.5, position: .bottom, title: "", image: nil)
            
        }else{
            self.selectedInfoWindowIndex = indexPath.row
            self.mapView.selectedMarker = self.allMarkers[indexPath.row]
            let camera = GMSCameraPosition.camera(withLatitude: emp.Latitude!, longitude: emp.Longitude!, zoom: 20)
            //self.mapView.camera = camera
            self.mapView.animate(to:camera)
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dView = UIView(frame: CGRect(x:0,y:0,width:tableView.frame.size.width,height: 35))
        
        dView.backgroundColor = UIColor.white
        let officeAddressLabel = UILabel(frame: CGRect(x:30,y:5,width:tableView.frame.size.width - 49,height: 20))
        officeAddressLabel.textColor = UIColor.lightGray
        officeAddressLabel.text = "Office Address"
        officeAddressLabel.font = UIFont.systemFont(ofSize: 12)
        
        let button = UIButton(frame: CGRect(x:20,y:30,width:tableView.frame.size.width - 40,height: 35))
        button.setTitle(OfficeAddress, for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.numberOfLines = 0
        button.setImage(UIImage(named: "office_icon"), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top:0, left:10, bottom:0, right:0);
        
        let lineLabel = UILabel(frame: CGRect(x:0,y:74,width:tableView.frame.size.width,height: 1))
        lineLabel.backgroundColor = UIColor.lightGray
        dView.addSubview(lineLabel)
        
        dView.addSubview(officeAddressLabel)
        
        dView.addSubview(button)
        return dView
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if OfficeAddress.count > 0{
            return 75
        }
        return 0
    }
    
}

extension TrackEmpLocationVC: GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width:self.view.bounds.size.width-50, height: 85))
        if marker.iconView?.tag == Office_Marker_Icon_View_TAG{
            view.addSubview(officeInfoView)
        }else{
            if selectedInfoWindowIndex >= 0{
                let infoView = allMarkerWindows[selectedInfoWindowIndex]
                view.addSubview(infoView)
            }
        }
        return view
        
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if marker.iconView?.tag == Office_Marker_Icon_View_TAG{
            self.mapView.selectedMarker = marker
            
        }else{
            
            let index = allMarkers.index(of:marker)
            selectedInfoWindowIndex = index!
            self.mapView.selectedMarker = marker
            let emp:EmpLocModel = self.empLocationData[selectedInfoWindowIndex]
            let camera = GMSCameraPosition.camera(withLatitude: emp.Latitude!, longitude: emp.Longitude!, zoom: 20)
            self.mapView.camera = camera
            
        }
        return true
    }
    
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        addSublayer(border)
    }
}



extension UIView {
    /**
     Wrapper for useful debugging description of view hierarchy
     */
    var recursiveDescription: NSString {
        return value(forKey: "recursiveDescription") as! NSString
    }
    
}
extension UIViewController: CLLocationManagerDelegate{
    
    
    //viv start for location permission
    
    func checkLocationAccess(completion: @escaping (Bool) -> Void) {
        let queue = DispatchQueue(label: "com.example.locationQueue", qos: .background)
        
        queue.async {
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case .denied, .restricted:
                    print("No access")
                    completion(false)
                case .authorizedAlways, .authorizedWhenInUse, .notDetermined:
                    print("Access")
                    completion(true)
                }
            } else {
                print("Location services not enabled")
                completion(false)
            }
        }
    }
    
    //end
    
    func askPermission(){
        let alertController = UIAlertController(title: "", message: "Allow Client Mobile Access to access your location and try again", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "DENY", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("Cancel Pressed")
            
        }
        
        let okAction = UIAlertAction(title: "ALLOW", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            if let bundleId = Bundle.main.bundleIdentifier,
                let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        // Add the actions
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showCustomAlertWithOkButton(
        title: String,
        titleColor: UIColor,
        titleBackgroundColor: UIColor,
        buttonBackgroundColor: UIColor,
        buttonTitleColor: UIColor,
        targetViewControllerIdentifier: String? = nil,
        completion: (() -> Void)? = nil
    ) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let customAlertVC = storyboard.instantiateViewController(withIdentifier: "AlertWithOk") as? CustomAlertWithOkButtonViewController {
            
            customAlertVC.modalPresentationStyle = .overCurrentContext
            customAlertVC.modalTransitionStyle = .crossDissolve
            
            // Set the alert properties
            customAlertVC.alertMessage = title
            customAlertVC.alertMessageColor = titleColor
            customAlertVC.alertMessageBackgroundColor = titleBackgroundColor
            customAlertVC.alertActionTitle = "OK" // Assuming you want a default OK button text
            customAlertVC.alertButtonBackgroundColor = buttonBackgroundColor
            customAlertVC.alertButtonTitleColor = buttonTitleColor
            
            // Calculate the frame for the semi-transparent background view
                    var statusBarHeight: CGFloat = 0
                    if #available(iOS 13.0, *) {
                        statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
                    } else {
                        statusBarHeight = UIApplication.shared.statusBarFrame.height
                    }
                    
            if let navigationController = self.navigationController {
                let navBarHeight = navigationController.navigationBar.frame.height
                let topHeight = navBarHeight + statusBarHeight
                
                let backgroundView = UIView(frame: CGRect(x: 0, y: topHeight, width: self.view.bounds.width, height: self.view.bounds.height - topHeight))
                backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                backgroundView.tag = 999 // Arbitrary tag to identify the view later
                self.view.addSubview(backgroundView)
            }
            
            // Define the action handler
                   customAlertVC.actionHandler = { [weak self] in
                       
                       // Remove the semi-transparent background view
                        self?.view.viewWithTag(999)?.removeFromSuperview()
                       
                       completion?()
                       
                       if let targetIdentifier = targetViewControllerIdentifier {
                           let targetVC = storyboard.instantiateViewController(withIdentifier: targetIdentifier)
                           self?.present(targetVC, animated: true, completion: nil)
                           
                       }
                   }
            
            self.present(customAlertVC, animated: true, completion: nil)
        }
    }
    
    //Customer Alert with Retry Option
    
    func showCustomAlertWithRetryAndCancelButtons(
        title: String,
        titleColor: UIColor,
        titleBackgroundColor: UIColor,
        primaryButtonTitle: String = "Cancel",
        primaryButtonBackgroundColor: UIColor,
        primaryButtonTitleColor: UIColor,
        secondaryButtonTitle: String = "Retry",
        secondaryButtonBackgroundColor: UIColor,
        secondaryButtonTitleColor: UIColor,
        completion: (() -> Void)? = nil,
        secondaryCompletion: (() -> Void)? = nil
    ) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let customAlertVC = storyboard.instantiateViewController(withIdentifier: "AlertWithRetry") as? CustomAlertwithRetryandCancel {
            
            customAlertVC.modalPresentationStyle = .overCurrentContext
            customAlertVC.modalTransitionStyle = .crossDissolve
            
            // Set the alert properties
            customAlertVC.alertMessage = title
            customAlertVC.alertMessageColor = titleColor
            customAlertVC.alertMessageBackgroundColor = titleBackgroundColor
            customAlertVC.alertActionTitle = primaryButtonTitle
            customAlertVC.alertButtonBackgroundColor = primaryButtonBackgroundColor
            customAlertVC.alertButtonTitleColor = primaryButtonTitleColor
            customAlertVC.secondaryActionTitle = secondaryButtonTitle
            customAlertVC.secondaryButtonBackgroundColor = secondaryButtonBackgroundColor
            customAlertVC.secondaryButtonTitleColor = secondaryButtonTitleColor

            // Calculate the frame for the semi-transparent background view
            var statusBarHeight: CGFloat = 0
            if #available(iOS 13.0, *) {
                statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            } else {
                statusBarHeight = UIApplication.shared.statusBarFrame.height
            }
            
            if let navigationController = self.navigationController {
                let navBarHeight = navigationController.navigationBar.frame.height
                let topHeight = navBarHeight + statusBarHeight
                
                let backgroundView = UIView(frame: CGRect(x: 0, y: topHeight, width: self.view.bounds.width, height: self.view.bounds.height - topHeight))
                backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                backgroundView.tag = 999 // Arbitrary tag to identify the view later
                self.view.addSubview(backgroundView)
            }
            
            // Define the primary action handler
            customAlertVC.actionHandler = { [weak self] in
                self?.view.viewWithTag(999)?.removeFromSuperview()
                completion?()

            }
            
            // Define the secondary action handler
            customAlertVC.secondaryActionHandler = { [weak self] in
                self?.view.viewWithTag(999)?.removeFromSuperview()
                secondaryCompletion?()
            }
            
            self.present(customAlertVC, animated: true, completion: nil)
        }
    }

}
