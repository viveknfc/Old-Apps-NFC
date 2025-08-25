//
//  E_AllTabSaveVC.swift
//  CWA
//
//  Created by NFC User.
//  Copyright © 2023 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON

class E_AllTabSaveVC: BaseViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var textViewForReason: UITextView!
    
    var CandId: Int?
    var OrderId: Int?
    var WeekEnd: String?
    var BillDate: String?
    var StartTime: String?
    var EndTime: String?
    var CheckIn: String?
    var CheckOut: String?
    var ChkInType: Int?
    var RouteName: String?
    var ClientId: Int?
    var ContactId: Int?
    var timeOut: String?
    var timeIn: String?
    var breakMinutes: Int?
    var totlaHours: Int?
    var RecCode: String?
    var PayforBreak: Int?
    var Id: Int?
    var longitude: Double?
    var latitude: Double?
    var Address: String?
    
    var latToSend = Double()
    var lognToSend = Double()
    
    var IPAddress = String()
    
    override func viewWillAppear(_ animated: Bool) {
        mainView.layer.cornerRadius = 10
        textViewForReason.layer.cornerRadius = 10
        textViewForReason.layer.masksToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let checkInNewFormat = convertTimeFormat(inputTime: CheckIn!)
        CheckIn = checkInNewFormat
        
        let checkOutNewFormat = convertTimeFormat(inputTime: CheckOut!)
        CheckOut = checkOutNewFormat

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func closeActionButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Save API Call
    
    @IBAction func saveActionButton(_ sender: Any) {
        
        checkLocationAccess { [self] hasAccess in
            if hasAccess {
                DispatchQueue.main.async {
                //for loaction
                
                CMALocationManager.shared.requestLocationAtOnce()
                if let recentLocation = CMALocationManager.shared.currentLocation?.coordinate, CMALocationManager.shared.currentLocation?.horizontalAccuracy ?? -1 >= 0 {
                    self.latToSend = recentLocation.latitude
                    self.lognToSend = recentLocation.longitude
                }
                else {
                    //                JustHUD.shared.showInView(view: (self.view)!)
                    let delayInSeconds = 5
                    let delayInNanoSeconds = UInt64(delayInSeconds * 1_000_000_000)
                    DispatchQueue.main.asyncAfter(deadline: .now() + .nanoseconds(Int(delayInNanoSeconds))) { [self] in
                        CMALocationManager.shared.requestLocationAtOnce()
                        if let recentLocation = CMALocationManager.shared.currentLocation?.coordinate {
                            latToSend = recentLocation.latitude
                            lognToSend = recentLocation.longitude
                        }
                        //                    JustHUD.shared.hide()
                    }
                }
                print("the latitude is",self.latToSend)
                print("the longitude is", self.lognToSend)
                
                self.reverseGeoCode1(lat: self.latToSend, long: self.lognToSend) { address in
                    if let address = address {
                        // Use the address here
                        print("Address from all tab is:", address)
                        self.Address = address
                    } else {
                        print("Failed to retrieve address")
                    }
                }
                
                self.longitude = self.lognToSend
                self.latitude = self.latToSend
                
                //end
                
                //IP
                
                if let ipAddress = self.getIPv4Address() {
                    print("IP Address: \(ipAddress)")
                    self.IPAddress = ipAddress
                } else {
                    print("Unable to retrieve IP address")
                }
                
                //End
                
                if let text = self.textViewForReason.text, !text.isEmpty {
                    
                    //                print("CandId",CandId as Any) //done
                    //                print("OrderId",OrderId as Any) // done
                    //                print("WeekEnd",WeekEnd as Any) //done
                    //                print("BillDate",BillDate as Any) //done
                    //                print("EndTime",EndTime as Any) //done
                    //                print("CheckIn",CheckIn as Any) //done
                    //                print("CheckOut",CheckOut as Any) //done
                    //                print("ClientId",ClientId as Any) //done
                    //                print("ContactId",ContactId as Any) //done
                    //                print("ChkInType",ChkInType as Any) // done
                    //                print("RouteName",RouteName as Any) //done
                    //                print("timeOut",timeOut as Any) //done
                    //                print("timeIn",timeIn as Any) //done
                    //                print("breakMinutes",breakMinutes as Any) //done
                    //                print("totlaHours",totlaHours as Any) //done
                    //                print("RecCode",RecCode as Any) // done
                    //                print("PayforBreak",PayforBreak as Any) //done
                    //                print("Id",Id as Any) //done
                    //                print("longitude",longitude as Any)
                    //                print("latitude",latitude as Any)
                    //                print("Address",Address as Any)
                    //                print("StartTime",StartTime as Any)
                    
                    if (CandId != nil && OrderId != nil && WeekEnd != nil && BillDate != nil && StartTime != nil && EndTime != nil && CheckIn != nil && CheckOut != nil && ClientId != nil && ContactId != nil && ChkInType != nil && RouteName != nil && timeOut != nil && timeIn != nil && breakMinutes != nil && totlaHours != nil && RecCode != nil && PayforBreak != nil && Id != nil && latitude != nil && longitude != nil) {
                        
                        let params: [String: Any] = ["CandId":CandId!, "OrderId":OrderId!, "WeekEnd":WeekEnd!, "BillDate":BillDate!, "StartTime":StartTime!, "EndTime": EndTime!, "CheckIn":CheckIn!, "CheckOut":CheckOut!, "Type":ChkInType!, "RouteName":RouteName!, "ClientId":ClientId!, "ContactId":ContactId!, "timeOut":timeOut!, "timeIn":timeIn!, "breakMinutes":breakMinutes!, "totlaHours":totlaHours!, "RecCode":RecCode!, "PayforBreak":PayforBreak!, "Id":Id!, "longitude":longitude!, "latitude": latitude!, "Address":Address ?? "Not Found", "ReasonForTimeChange":text, "IPAddress":IPAddress, "Retry": 0]
                        
                        print("the Parameters for the API call is", params)
                        
                        let isInternetAvailable = self.isInternetAvailable()
                        
                        if isInternetAvailable {
                            
                            JustHUD.shared.showInView(view: (self.view)!)
                            
                            RestAPI.getAllTimeSave(self, params: params, method: "POST", accessToken: "", acces: true, callBack: saveResponse(response:))
                            
                        }
                        else{
                            
                            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                            
                        }
                    }
                    else {
                        print("in Parameters some is nill")
                    }
                    
                }
                else {
                    print("viv enters toast view")
                    self.view.makeToast("Please Enter Reason & Save", duration: 1.5, position: .bottom, title: "", image: nil)
                }
            }
        }
        else {
            // Location Permission not available
            self.askPermission()
        }
    }
      
    }
    
    //MARK: - Save API Response
    
    func saveResponse(response:AnyObject)->() {
        
//        JustHUD.shared.hide()
        
        if response is String{
            
            JustHUD.shared.hide()
         
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        else {
            
            let object = response as! JSON
            print("the Save API Response is", object)
           // self.dismiss(animated: true, completion: nil)
            
            if object[0]["Retry"].intValue == 1 {
                print("retry mechanism calling")
                
                //start
                
                let delayInSeconds = object[0]["Sleep"].intValue
                let delayInNanoSeconds = UInt64(delayInSeconds * 1_000_000_000)

                DispatchQueue.main.asyncAfter(deadline: .now() + .nanoseconds(Int(delayInNanoSeconds))) { [self] in
                        
                        CMALocationManager.shared.requestLocationAtOnce()
                        
                                if let recentLocation = CMALocationManager.shared.currentLocation?.coordinate, CMALocationManager.shared.currentLocation?.horizontalAccuracy ?? -1 >= 0 {
                                    latToSend = recentLocation.latitude
                                    lognToSend = recentLocation.longitude
                                }
                        
                        reverseGeoCode1(lat: latToSend, long: lognToSend) { address in
                            if let address = address {
                                // Use the address here
                                print("Address from retry chk in is:", address)
                                self.Address = address
                            } else {
                                print("Failed to retrieve address")
                            }
                        }
                        
                        longitude = lognToSend
                        latitude = latToSend
                        
                        if (CandId != nil && OrderId != nil && WeekEnd != nil && BillDate != nil && StartTime != nil && EndTime != nil && CheckIn != nil && CheckOut != nil && ClientId != nil && ContactId != nil && ChkInType != nil && RouteName != nil && timeOut != nil && timeIn != nil && breakMinutes != nil && totlaHours != nil && RecCode != nil && PayforBreak != nil && Id != nil && latitude != nil && longitude != nil) {
                            
                            let params: [String: Any] = ["CandId":CandId!, "OrderId":OrderId!, "WeekEnd":WeekEnd!, "BillDate":BillDate!, "StartTime":StartTime!, "EndTime": EndTime!, "CheckIn":CheckIn!, "CheckOut":CheckOut!, "Type":ChkInType!, "RouteName":RouteName!, "ClientId":ClientId!, "ContactId":ContactId!, "timeOut":timeOut!, "timeIn":timeIn!, "breakMinutes":breakMinutes!, "totlaHours":totlaHours!, "RecCode":RecCode!, "PayforBreak":PayforBreak!, "Id":Id!, "longitude":longitude!, "latitude": latitude!, "Address":Address ?? "Not Found", "IPAddress":IPAddress, "Retry": 1 ]
                            
                            print("the Parameters for the API call from retry mechanicsm is", params)
                            
                            let isInternetAvailable = self.isInternetAvailable()
                            
                            if isInternetAvailable {
                                
                                RestAPI.getAllTimeSave(self, params: params, method: "POST", accessToken: "", acces: true, callBack: saveResponse(response:))
                            }
                            else{
                                JustHUD.shared.hide()
                                
                                self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                                
                            }
                    
                        } else {
                            JustHUD.shared.hide()
                            print("in Parameters some is nill")
                        }
                    
                }
            
                //end
                
            }
            
            else if object[0]["StatusCode"].intValue == 0 {
                
                JustHUD.shared.hide()
                
                let title = object[0]["message"].stringValue
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: title, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                pushToAllTab()

            }
            
            else if object[0]["StatusCode"].intValue == 1 {
                
                let title = object[0]["message"].stringValue
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: title, okBtnTitle: "OK", cancelBtnTitle: "", type: Success_Text, isAttributed: false)
                pushToAllTab()
            }
        
            else {
                JustHUD.shared.hide()
            }
     
        }
        
    }
    
    //MARK: - Push to All Tab
    
    func pushToAllTab() {
        print("vivek reached push to all tab in 326")
        
        // Ensure the navigation controller exists
        guard let navigationController = self.navigationController else {
            print("Navigation controller is nil")
            return
        }
        
        var isControllerExists = false
        var vc: UIViewController?
        
        // Check the view controllers in the navigation stack
        let viewControllers = navigationController.viewControllers
        print("View controllers in navigation stack: \(viewControllers)")
        
        for viewController in viewControllers {
            if viewController is E_AllSubmitVC {
                print("Your controller exists")
                isControllerExists = true
                vc = viewController
                break
            }
        }
        
        if !isControllerExists {
            print("isControllerExists = false from 341")
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            // Instantiate the view controller with identifier "AllSubmitSegue"
            if let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AllSubmitSegue") as? E_AllSubmitVC {
                navigationController.pushViewController(nextViewController, animated: true)
            } else {
                print("Failed to instantiate view controller with identifier 'AllSubmitSegue'")
            }
        } else {
            if let vc1 = vc as? E_AllSubmitVC {
                navigationController.popToViewController(vc1, animated: true)
            } else {
                print("Failed to cast vc to E_AllSubmitVC")
            }
        }
    }
    
    //MARK: - Input Time Format
    
    
    func convertTimeFormat(inputTime: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "h:mm a"
        
        if let date = inputFormatter.date(from: inputTime) {
            
            var components = Calendar.current.dateComponents([.hour, .minute], from: date)
                    components.year = 1900
                    components.month = 1
                    components.day = 1
                    let newDate = Calendar.current.date(from: components)!
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let outputTime = outputFormatter.string(from: newDate)
            return outputTime
        } else {
            return nil
        }
    }

}
