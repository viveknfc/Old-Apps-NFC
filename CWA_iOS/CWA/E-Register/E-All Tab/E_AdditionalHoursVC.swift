//
//  E_AdditionalHoursVC.swift
//  CWA
//
//  Created by NFC User on 11/10/23.
//  Copyright © 2023 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON

class E_AdditionalHoursVC: BaseViewController, DateTimePickerDelegate, UITextFieldDelegate {
 
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var checkInTF: UITextField!
    @IBOutlet weak var checkOuttF: UITextField!
    @IBOutlet weak var commentsTF: UITextField!
    
    var activeTextField: UITextField?
    var startTime: String?
    var endTime: String?
    
    var CandId: Int?
    var OrderId: Int?
    var WeekEnd: String?
    var BillDate: String?
    var StartTime: String?
    var EndTime: String?
    var CheckIn: String? // not assigned
    var CheckOut: String? // not assigned
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
    
    //End
    
    override func viewWillAppear(_ animated: Bool) {
        mainView.layer.cornerRadius = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        checkInTF.tag = 11
        checkOuttF.tag = 22
        commentsTF.tag = 33
        
        let timeInNewFormat = convertTimeFormat(inputTime: timeIn!)
        timeIn = timeInNewFormat
        
        let timeOutNewFormat = convertTimeFormat(inputTime: timeOut!)
        timeOut = timeOutNewFormat
    }
    
    //MARK: - TextField Delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.tag == 11 {
            textField.resignFirstResponder()
            activeTextField = textField
            self.view.endEditing(true)

            self.showPicker(ampm:false,selectedDate: Date())
            
            return false
        }
        else if textField.tag == 22 {
            textField.resignFirstResponder()
            activeTextField = textField
            self.view.endEditing(true)

            self.showPicker(ampm:false,selectedDate: Date())
            
            return false
        }else {
            return true
        }
        
    }
    
    //MARK: - Time Picker
    
    func showPicker(ampm:Bool,selectedDate: Date) {
        
        let min = selectedDate.addingTimeInterval(-60 * 60 * 24 * 4) //4 days -
        let max = selectedDate.addingTimeInterval(60 * 60 * 24 * 4)//4 days +
        let picker = DateTimePicker.show(selected: selectedDate, minimumDate: min, maximumDate: max)
        
        picker.timeInterval = DateTimePicker.MinuteInterval.default
        
        picker.highlightColor = #colorLiteral(red: 0.1515013874, green: 0.1768231988, blue: 0.4189088941, alpha: 1)
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = "Done"
        picker.doneBackgroundColor = #colorLiteral(red: 0.3742285371, green: 0.426192522, blue: 0.3634500504, alpha: 1)
        picker.locale = Locale(identifier: "en_GB")
        
        picker.todayButtonTitle = ""
        picker.isAmPm = ampm
        if ampm{
            picker.is12HourFormat = false
            picker.dateFormat = "hh:mm"
        }
        else
        {
            picker.is12HourFormat = true
            picker.dateFormat = "hh:mm aa"
        }
        picker.isTimePickerOnly = true
        picker.includeMonth = false
        
        picker.completionHandler = { [self] date in
            let formatter = DateFormatter()
            formatter.locale = Locale.preferredLocale()
            if ampm{
                formatter.dateFormat = "hh:mm"
            }
            else
            {
                formatter.dateFormat = "hh:mm aa"
            }
            
            self.activeTextField?.text = formatter.string(from: date)
            
            if self.activeTextField?.tag == 11 {
                self.startTime = formatter.string(from: date)
                CheckIn = self.convertTimeFormat(inputTime: startTime!)
                print("the start time is", self.startTime!)
            }
            else  if self.activeTextField?.tag == 22 {
                self.endTime = formatter.string(from: date)
                CheckOut = self.convertTimeFormat(inputTime: endTime!)
                print("the end time is", self.endTime!)
            }
            
        }
        
        picker.delegate = self
        NotificationCenter.default.post(name: Notification.Name("Time"), object: nil)
    }
    
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        print(picker.selectedDateString)
    }
    
    //MARK: - Save Button Pressed
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if let text = commentsTF.text, !text.isEmpty {
            
            print("the commets textfiel is", text)
            
            print("CandId",CandId as Any) //done
            print("OrderId",OrderId as Any) // done
            print("WeekEnd",WeekEnd as Any) //done
            print("BillDate",BillDate as Any) //done
            print("EndTime",EndTime as Any) //done
            print("CheckIn",CheckIn as Any) //done
            print("CheckOut",CheckOut as Any) //done
            print("ClientId",ClientId as Any) //done
            print("ContactId",ContactId as Any) //done
            print("ChkInType",ChkInType as Any) // done
            print("RouteName",RouteName as Any) //done
            print("timeOut",timeOut as Any) //done
            print("timeIn",timeIn as Any) //done
            print("breakMinutes",breakMinutes as Any) //done
            print("totlaHours",totlaHours as Any) //done
            print("RecCode",RecCode as Any) // done
            print("PayforBreak",PayforBreak as Any) //done
            print("Id",Id as Any) //done
            print("longitude",longitude as Any)
            print("latitude",latitude as Any)
            print("Address",Address as Any)
            print("StartTime",StartTime as Any)
            
            //IP
            
            if let ipAddress = getIPv4Address() {
                print("IP Address: \(ipAddress)")
                IPAddress = ipAddress
            } else {
                print("Unable to retrieve IP address")
            }
            
            //End
            
            if (CandId != nil && OrderId != nil && WeekEnd != nil && BillDate != nil && StartTime != nil && EndTime != nil && CheckIn != nil && CheckOut != nil && ClientId != nil && ContactId != nil && ChkInType != nil && RouteName != nil && timeOut != nil && timeIn != nil && breakMinutes != nil && totlaHours != nil && RecCode != nil && PayforBreak != nil && Id != nil && latitude != nil && longitude != nil) {
                
                let params: [String: Any] = ["CandId":CandId!, "OrderId":OrderId!, "WeekEnd":WeekEnd!, "BillDate":BillDate!, "StartTime":StartTime!, "EndTime": EndTime!, "CheckIn":CheckIn!, "CheckOut":CheckOut!, "Type":ChkInType!, "RouteName":RouteName!, "ClientId":ClientId!, "ContactId":ContactId!, "timeOut":timeOut!, "timeIn":timeIn!, "breakMinutes":breakMinutes!, "totlaHours":totlaHours!, "RecCode":RecCode!, "PayforBreak":PayforBreak!, "Id":Id!, "longitude":longitude!, "latitude": latitude!, "Address":Address ?? "Not Found", "AdditionalComments":text, "IPAddress":IPAddress, "Retry": 0]
                    
                    print("the Parameters for the API call is", params)
                
                let isInternetAvailable = self.isInternetAvailable()
                
                if isInternetAvailable {
                    
                    JustHUD.shared.showInView(view: (self.view)!)
                    
                    RestAPI.addTimeApi(self, params: params, method: "POST", accessToken: "", acces: true, callBack: addTimeResponse(response:))
                    
                }
                else{
                    
                    self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                    
                }
            }
            else {
                print("in Parameters some is nill")
            }
            
            
        } else {
            print("viv enters toast view")
            self.view.makeToast("Please Add Comments & Save", duration: 1.5, position: .bottom, title: "", image: nil)
        }
        
       
        
    }
    
    //MARK: - Additional Time API Response
    
    func addTimeResponse(response:AnyObject)->() {
        
//        JustHUD.shared.hide()
        
        if response is String{
            
            JustHUD.shared.hide()
         
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        else {
            
            let object = response as! JSON
            print("the Add Time API Response is", object)
            
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
                                
                                RestAPI.addTimeApi(self, params: params, method: "POST", accessToken: "", acces: true, callBack: addTimeResponse(response:))
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
                
//                let titleColor = #colorLiteral(red: 0.8576444983, green: 0.3266127706, blue: 0.3078376949, alpha: 1)
//                let titleBg = #colorLiteral(red: 0.9495584369, green: 0.8718144298, blue: 0.8732326627, alpha: 1)
//                let buttonBg = #colorLiteral(red: 0.8576444983, green: 0.3266127706, blue: 0.3078376949, alpha: 1)
//                let buttonTitleColor = UIColor.white
//                
//                self.showCustomAlertWithOkButton(title: title, titleColor: titleColor, titleBackgroundColor: titleBg, buttonBackgroundColor: buttonBg, buttonTitleColor: buttonTitleColor, targetViewControllerIdentifier: nil) {
//                    let screen = self.storyboard?.instantiateViewController(withIdentifier: "AllSubmitSegue") as! E_AllSubmitVC
//                    let navi = BaseNaviViewController(rootViewController:screen)
//                    navi.navigationBar.tintColor = .white
//                    navi.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//                    self.navigationController?.pushViewController(screen, animated: true)
//                    
//                }

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
    
    func pushToAllTab(){
        var isControllerExists = false
        var vc = UIViewController()
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is E_AllSubmitVC {
                    print("Your controller exist")
                    isControllerExists = true
                    vc = viewController
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AllSubmitSegue") as! E_AllSubmitVC
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            let vc1:E_AllSubmitVC = vc as! E_AllSubmitVC
            self.navigationController?.popToViewController(vc1, animated: true)
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
