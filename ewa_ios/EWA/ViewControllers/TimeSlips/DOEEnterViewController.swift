//
//  DOEEnterViewController.swift
//  EWA
//
//  Created by NFC Solutions on 20/11/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toast_Swift
import ANLoader
import CropViewController

class DOEEnterViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CropViewControllerDelegate {
    
    @IBOutlet var namelabel: UILabel!
    var isTotalNegative = Bool()
    var isZero = Bool()
    @IBOutlet var timeSlipTableView: UITableView!
    var weekEnds:JSON = JSON.null
    var object:JSON = JSON.null
    var submitObject:JSON = JSON.null
    var picUploadData:JSON = JSON.null
    var indexNumber = Int()
    var weekEnd = String()
    
    
    var clientName = String()
    var theme: SambagTheme = .light
    var activeTextField: UITextField?
    var starTimes = NSMutableArray()
    var endTimes   = NSMutableArray()
    var totalHours = NSMutableArray()
    var indexWeek = Int()
    var weekedays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    var cleared = Bool()
    var totalTimeInHours = NSMutableArray()
    
    @IBOutlet var totalTimeTextLabel: UILabel!
    @IBOutlet var totalTimeLabel: UILabel!
    
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        namelabel.text = object["ChildList"][indexNumber]["FirstName"].stringValue+" "+object["ChildList"][indexNumber]["LastName"].stringValue+" "+"(\(object["ChildList"][indexNumber]["DoeChildId"].stringValue))"
        totalHours = ["00:00","00:00","00:00","00:00","00:00","00:00","00:00"]
        starTimes = ["","","","","","",""]
        endTimes = ["","","","","","",""]
        totalTimeInHours = ["","","","","","",""]
        //totalTimeLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        //totalTimeTextLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        
    }
    
    
    @IBAction func submitAction(_ sender: UIButton)
    {
        isTotalNegative = false
        isZero = false
        for i in 0..<7
        {
            let hours = totalTimeInHours[i] as! String
            if hours.hasPrefix("-")
            {
                isTotalNegative = true
                break
            }
            if ((starTimes[i] as! String).count>0)||((endTimes[i] as! String).count>0)
            {
                if totalTimeInHours[i] as! String == ""
                {
                    isTotalNegative = true
                    break
                }
                else
                {
                    let totalHours:Double = Double(totalTimeInHours[i] as! String)!
                    if totalHours == 0
                    {
                        isZero = true
                        indexWeek = i
                        break
                    }
                }
            }
        }
        if isTotalNegative
        {
            ServerService.ShowAlertMessage(ErrorMessage: "", title:"Please make sure total hours should not be less than zero or zero.", view: self)
            isTotalNegative = false
        }
        else if isZero
        {
            ServerService.ShowAlertMessage(ErrorMessage: "", title: "Timeslip Total hour should not be zero.", view: self)
            self.navigationController?.view.makeToast("Start and End Time cannot be same on (\(weekedays[indexWeek]))", duration: 3.0, position: .bottom, title: "", image: nil)
            
        }
        else
        {
            let totalHoursLabel:Double = Double(totalTimeLabel.text!)!
            if totalHoursLabel == 0
            {
                ServerService.ShowAlertMessage(ErrorMessage: "", title:"Timeslip Total hour should not be zero.", view: self)
            }
            else
            {
                if totalHoursLabel < 0.5
                {
                    ServerService.ShowAlertMessage(ErrorMessage: "", title:"Timeslip Total hour should be greater than 0.5", view: self)
                }
                else
                {
                    let confromAlert = UIAlertController(title: "Have you entered correct information?", message:"", preferredStyle: UIAlertControllerStyle.alert)
                    confromAlert.addAction(UIAlertAction(title: "NO", style: .destructive) { (action:UIAlertAction!) in
                        
                        
                    })
                    confromAlert.addAction(UIAlertAction(title: "YES", style: .default) { (action:UIAlertAction!) in
                        
                        let userData:[String:Any] = ["OrderId":self.object["ChildList"][self.indexNumber]["OrderId"].intValue,
                                                     "ChildId": self.object["ChildList"][self.indexNumber]["ChildId"].intValue,
                                                     "DoeChildId":self.object["ChildList"][self.indexNumber]["DoeChildId"].stringValue,
                                                     "FirstName": self.object["ChildList"][self.indexNumber]["FirstName"].stringValue,
                                                     "LastName": self.object["ChildList"][self.indexNumber]["LastName"].stringValue,
                                                     "GroupSize": self.object["ChildList"][self.indexNumber]["GroupSize"].stringValue,
                                                     "Frequency": self.object["ChildList"][self.indexNumber]["Frequency"].stringValue,
                                                     "Duratn": self.object["ChildList"][self.indexNumber]["Duration"].stringValue,
                                                     "ServiceLocation": self.object["ChildList"][self.indexNumber]["ServiceLocation"].stringValue,
                                                     "MonStart": "\(self.starTimes[0])",
                            "MonEnd": "\(self.endTimes[0])",
                            "MonSubTotal": "\(self.totalTimeInHours[0])",
                            "ChildMonTotal": "\(self.totalTimeInHours[0])",
                            "ChildTueTotal": "\(self.totalTimeInHours[1])",
                            "ChildWedTotal": "\(self.totalTimeInHours[2])",
                            "ChildThuTotal": "\(self.totalTimeInHours[3])",
                            "ChildFriTotal": "\(self.totalTimeInHours[4])",
                            "TueStart": "\(self.starTimes[1])",
                            "TueEnd": "\(self.endTimes[1])",
                            "TueSubTotal": "\(self.totalTimeInHours[1])",
                            "WedStart": "\(self.starTimes[2])",
                            "WedEnd": "\(self.endTimes[2])",
                            "WedSubTotal": "\(self.totalTimeInHours[2])",
                            "ThuStart": "\(self.starTimes[3])",
                            "ThuEnd": "\(self.endTimes[3])",
                            "ThuSubTotal": "\(self.totalTimeInHours[3])",
                            "FriStart": "\(self.starTimes[4])",
                            "FriEnd": "\(self.endTimes[4])",
                            "FriSubTotal": "\(self.totalTimeInHours[4])",
                            "SatStart": "\(self.starTimes[5])",
                            "SatEnd": "\(self.endTimes[5])",
                            "SatSubTotal": "\(self.totalTimeInHours[5])",
                            "SunStart": "\(self.starTimes[6])",
                            "SunEnd": "\(self.endTimes[6])",
                            "SunSubTotal": "\(self.totalTimeInHours[6])",
                            "TimeslipsTotal":"\(totalHoursLabel)"
                        ]
                        
                        let params:[String:Any] = ["FormCheckInfo": "",
                                                   "ChildList": [userData],
                                                   "CandidateId": UserDefaults.standard.object(forKey: "cID") as! String,
                                                   "DivisionId": UserDefaults.standard.object(forKey: "dID") as! String,
                                                   "Name": self.clientName,
                                                   "MonTotal": "\(self.totalTimeInHours[0])",
                            "TueTotal": "\(self.totalTimeInHours[1])",
                            "WedTotal": "\(self.totalTimeInHours[2])",
                            "ThuTotal": "\(self.totalTimeInHours[3])",
                            "FriTotal": "\(self.totalTimeInHours[4])",
                            "SatTotal": "\(self.totalTimeInHours[5])",
                            "SunTotal": "\(self.totalTimeInHours[6])",
                            "SelectedWeekEnd": self.object["WeekDays"][6].stringValue,
                            "ClientName": self.self.clientName,
                            "TimeslipsTotal": "\(totalHoursLabel)",
                            "MonCurrentDate": self.object["WeekDays"][0].stringValue,
                            "TueCurrentDate": self.object["WeekDays"][1].stringValue,
                            "WedCurrentDate": self.object["WeekDays"][2].stringValue,
                            "ThuCurrentDate": self.object["WeekDays"][3].stringValue,
                            "FriCurrentDate": self.object["WeekDays"][4].stringValue,
                            "ConfirmationMessage": true,"Source":"iOS"]
                        
                        
                        print(params)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
                            ANLoader.hide()
                        })
                        if ConnectionCheck.isConnectedToNetwork()
                        {
                            //ANLoader.showLoading("", disableUI:true)
                            ServerService.showActivityIndicatory(uiView:self.view)
                            ServerService.getDoeEnterTimeSlipSubmitDOEEnterTimeSlip(self, params: params, method:"POST",accessToken:Constants.Token, acces:true, callBack: self.getresponse(response:))
                        }
                        else
                        {
                            ANLoader.hide()
                            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                        }
                    })
                    self.present(confromAlert, animated: true)
                    confromAlert.view.tintColor = UIColor(hexString: "#449D44")
                }
            }
        }
    }
    
    
    
    
    
    //aftergettingResponseFrom the server
    func getresponse(response:AnyObject)->()
    {
        ANLoader.hide()
        ServerService.hideProgressView()
        submitObject = response as! JSON
        print(submitObject)
        if submitObject.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if submitObject["HttpRequestStatus"].intValue == 200
        {
            ServerService.ShowAlertMessage(ErrorMessage: "", title: submitObject["InformationMessage"].stringValue, view: self)
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage: "", title: submitObject["ErrorMessage"].stringValue.removeHtmlFromString(inPutString: submitObject["ErrorMessage"].stringValue), view: self)
        }
        
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        activeTextField =  textField
        textField.resignFirstResponder()
        //        let vc = SambagTimePickerViewController()
        //        var itemsMin = [Int]()
        //        for i in 0..<object["BindActivityMinutesList"].arrayValue.count
        //        {
        //            let item = object["BindActivityMinutesList"][i].intValue
        //            if item == 60
        //            {
        //            }
        //            else
        //            {
        //                itemsMin.append(item)
        //            }
        //
        //        }
        //
        //        var minuteItems = [String]()
        //        for j in 0..<object["BindActivityMinutesList"].arrayValue.count
        //        {
        //            let item = object["BindActivityMinutesList"][j].stringValue
        //            if item == "0"
        //            {
        //                minuteItems.append("00")
        //            }
        //            else if item == "60"
        //            {
        //
        //            }
        //            else
        //            {
        //                minuteItems.append(item)
        //            }
        //        }
        //        vc.minutes = itemsMin
        //        vc.timeMintutes = minuteItems
        //        vc.meridians = minuteItems
        //        vc.meridians = []
        //        vc.theme = theme
        //        vc.delegate = self
        if cleared
        {
            cleared = false
            textField.endEditing(true)
        }
        else
        {
            showPicker()
            //present(vc, animated: true, completion: nil)
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if (textField.tag>7&&textField.tag<16)
        {
            starTimes.replaceObject(at:textField.tag-8, with:textField.text!)
            timeSlipTableView.reloadData()
            
        }
        else if (textField.tag>96&&textField.tag<104)
        {
            endTimes.replaceObject(at:textField.tag-97, with:textField.text!)
            timeSlipTableView.reloadData()
        }
        
    }
    func convertDate(date:String,min:Bool) -> String
    {
        let tt = date
        let dateFormatterf = DateFormatter()
        dateFormatterf.locale = Locale.preferredLocale()
        if min
        {
            dateFormatterf.dateFormat = "h:mm"
        }
        else
        {
            dateFormatterf.dateFormat = "h:mm aa"
        }
        
        let dateee = dateFormatterf.date(from: tt)
        dateFormatterf.dateFormat = "HH:mm"
        if (dateee != nil)
        {
            let Date24 = dateFormatterf.string(from: dateee!)
            print("24 hour formatted Date:",Date24)
            return Date24
        }
        else
        {
            return ""
        }
    }
    func addTimes(start:String,end:String,min:Bool) -> Int
    {
        let startDate = start
        let endDate = end
        
        let startArray = startDate.components(separatedBy: (":"))
        let endArray = endDate.components(separatedBy: (":"))
        
        let startHours = startArray[0].integerValue * 60
        let startMinutes = startArray[1].integerValue + startHours
        
        let endHours = endArray[0].integerValue * 60
        let endMinutes = endArray[1].integerValue + endHours
        
        var timeDifference = 0
        if min
        {
            timeDifference = startMinutes - endMinutes
        }
        else
        {
            timeDifference = endMinutes - startMinutes
        }
        let day = 24 * 60
        
        if timeDifference < 0 {
            timeDifference += day
        }
        print(timeDifference)
        return timeDifference
    }
    func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
    func getHours(start:String,end:String,i:Int,min:Bool)
    {
        let tuple = minutesToHoursMinutes(minutes: self.addTimes(start:self.convertDate(date:start,min:min), end: self.convertDate(date:end,min:min),min:min))
        //        if tuple.hours<10
        //        {
        //            if tuple.leftMinutes<10
        //            {
        //                totalHours.replaceObject(at: i-1, with: String(format:"0%d",tuple.hours)+":"+String(format:"0%d",tuple.leftMinutes))
        //            }
        //            else
        //            {
        //                totalHours.replaceObject(at: i-1, with: String(format:"0%d",tuple.hours)+":"+String(format:"%d",tuple.leftMinutes))
        //            }
        //        }
        //        else
        //        {
        //
        //            if tuple.leftMinutes<10
        //            {
        //                totalHours.replaceObject(at: i-1, with: String(format:"%d",tuple.hours)+":"+String(format:"0%d",tuple.leftMinutes))
        //            }
        //            else
        //            {
        //                totalHours.replaceObject(at: i-1, with: String(format:"%d",tuple.hours)+":"+String(format:"%d",tuple.leftMinutes))
        //            }
        //        }
        var totalTimeConversionArray = Double()
        let hours = String(format:"%d:%d",tuple.hours,tuple.leftMinutes)
        let fileArray = hours.components(separatedBy:":")
        var hoursToMin:Double = Double()
        if fileArray.count>0
        {
            hoursToMin = Double(fileArray[0])!
        }
        var mins:Double = Double()
        if fileArray.count == 2
        {
            mins = Double(fileArray[1])!
        }
        totalTimeConversionArray = hoursToMin+mins/60
        if hours.hasPrefix("-")
        {
            totalTimeInHours.replaceObject(at:i-1, with:String(format:"-%.2f",totalTimeConversionArray))
        }
        else{
            totalTimeInHours.replaceObject(at:i-1, with:String(format:"%.2f",totalTimeConversionArray))
        }
        self.addTotal()
    }
    func addTotal()
    {
        //        var toatHours = Int()
        //        for i in 0..<7
        //        {
        //            let hours = totalHours[i] as! String
        //            let fileArray = hours.components(separatedBy: ":")
        //            let hoursToMin = Int(fileArray[0])!*60
        //            var tmins = Int(fileArray[1])!
        //            if (hoursToMin<0)||(Int(fileArray[0])! == -0)
        //            {
        //                tmins = -tmins
        //            }
        //            toatHours += hoursToMin+tmins
        //        }
        //        if self.minutesToHoursMinutes(minutes: toatHours).leftMinutes<10
        //        {
        //            totalTimeLabel.text = String(format:"%d:0%d",self.minutesToHoursMinutes(minutes: toatHours).hours,Swift.abs(self.minutesToHoursMinutes(minutes: toatHours).leftMinutes))
        //        }
        //        else
        //        {
        //            totalTimeLabel.text = String(format:"%d:%d",self.minutesToHoursMinutes(minutes: toatHours).hours,Swift.abs(self.minutesToHoursMinutes(minutes: toatHours).leftMinutes))
        //        }
        var toatHours = Double()
        for i in 0..<7
        {
            var hours = Double()
            if totalTimeInHours[i] as! String != ""
            {
                hours = Double(totalTimeInHours[i] as! String)!
                toatHours += hours
            }
            else
            {
                
            }
        }
        totalTimeLabel.text = String(format:"%.2f",toatHours)
    }
    @IBAction func handleNavgationBarButtonTap(_ sender: UIBarButtonItem, event: UIEvent)
        
    {
        Constants.showUp(event:event,viewController:self)
        
    }
    public func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        cleared = true
        return true
    }
    
    func total()
    {
        var totalIsNull = Bool()
        for total in 0..<totalTimeInHours.count
        {
            if (starTimes[total] as! String).count>0&&(endTimes[total] as! String).count>0
            {
                totalIsNull = false
                break
            }
            else
            {
                totalIsNull = true
            }
        }
        if totalIsNull
        {
            totalTimeLabel.text = "0"
        }
        else
        {
            
        }
    }
    
    
    
    func showPicker()
    {
        let min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
        let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
        let picker = DateTimePicker.show(selected: Date(), minimumDate: min, maximumDate: max)
        
        if object["stepping"].intValue == 30
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.thirty
        }
        else if object["stepping"].intValue == 15
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.fifteen
        }
        else if object["stepping"].intValue == 10
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.ten
        }
        else if object["stepping"].intValue == 6
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.six
        }
        else if object["stepping"].intValue == 5
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.five
        }
        else if object["stepping"].intValue == 1
        {
            picker.timeInterval = DateTimePicker.MinuteInterval.default
        }
        else{
            picker.timeInterval = DateTimePicker.MinuteInterval.default
        }
        picker.highlightColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = "Select"
        picker.doneBackgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        picker.locale = Locale(identifier: "en_GB")
        picker.isDefault = true
        picker.todayButtonTitle = ""
        picker.is12HourFormat = true
        picker.dateFormat = "hh:mm aa"
        picker.isTimePickerOnly = true
        //picker.isDatePickerOnly = true
        picker.includeMonth = false // if true the month shows at top
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.locale = Locale.preferredLocale()
            formatter.dateFormat = "hh:mm aa"
            // self.activeTextField?.text = formatter.string(from: date)
            if (self.self.activeTextField!.tag>7)&&(self.activeTextField!.tag)<16
            {
                self.activeTextField?.text = String(describing:formatter.string(from: date))
                self.starTimes.replaceObject(at: (self.activeTextField?.tag)!-8, with:formatter.string(from: date))
            }
            else if (self.self.activeTextField!.tag>96)&&(self.activeTextField!.tag)<104
            {
                self.activeTextField?.text = String(describing: formatter.string(from: date))
                self.endTimes.replaceObject(at: (self.activeTextField?.tag)!-97, with:formatter.string(from: date))
            }
            self.timeSlipTableView.reloadData()
            
        }
        picker.delegate = self
        NotificationCenter.default.post(name: Notification.Name("Time"), object: nil)
    }
    
    @IBAction func resetAction(_ sender: ShadowButton) {
        let confromAlert = UIAlertController(title: "Would you like to clear Entered Timeslip for the following weekend \(weekEnd)?", message:"", preferredStyle: UIAlertControllerStyle.alert)
        confromAlert.addAction(UIAlertAction(title: "NO", style: .destructive) { (action:UIAlertAction!) in
            
            
        })
        confromAlert.addAction(UIAlertAction(title: "YES", style: .default) { (action:UIAlertAction!) in
            
            self.starTimes = ["","","","","","",""]
            self.endTimes = ["","","","","","",""]
            self.totalTimeInHours = ["","","","","","",""]
            self.isTotalNegative = false
            self.isZero = false
            self.timeSlipTableView.scrollToRow(at:IndexPath(item: 0, section: 0), at:.top, animated:true)
            for row in 0..<8
            {
                let indexPath = IndexPath(item: row, section: 0)
                self.timeSlipTableView.reloadRows(at: [indexPath], with: .fade)
            }
            self.navigationController?.view.makeToast("Schedule has been cleared for this \(self.weekEnd) weekend.", duration: 3.0, position: .bottom, title: "", image: nil)
        })
        
        self.present(confromAlert, animated: true)
        confromAlert.view.tintColor = UIColor(hexString: "#449D44")
    }
    
    //imagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = (info[UIImagePickerControllerOriginalImage] as? UIImage) else { return }
        
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.delegate = self
        
        // Uncomment this if you wish to provide extra instructions via a title label
        //cropController.title = "Crop Image"
        
        // -- Uncomment these if you want to test out restoring to a previous crop setting --
        //cropController.angle = 90 // The initial angle in which the image will be rotated
        //cropController.imageCropFrame = CGRect(x: 0, y: 0, width: 2848, height: 4288) //The initial frame that the crop controller will have visible.
        
        // -- Uncomment the following lines of code to test out the aspect ratio features --
        cropController.aspectRatioPreset = .presetSquare; //Set the initial aspect ratio as a square
        cropController.aspectRatioLockEnabled = true // The crop box is locked to the aspect ratio and can't be resized away from it
        cropController.resetAspectRatioEnabled = false // When tapping 'reset', the aspect ratio will NOT be reset back to default
        cropController.aspectRatioPickerButtonHidden = true
        
        // -- Uncomment this line of code to place the toolbar at the top of the view controller --
        //cropController.toolbarPosition = .top
        
        cropController.rotateButtonsHidden = true
        cropController.rotateClockwiseButtonHidden = true
        
        //cropController.doneButtonTitle = "Title"
        //cropController.cancelButtonTitle = "Title"
        
        self.image = image
        
        
        //If profile picture, push onto the same navigation stack
        if croppingStyle == .circular {
            picker.pushViewController(cropController, animated: true)
        }
        else { //otherwise dismiss, and then present from the main controller
            picker.dismiss(animated: true, completion: {
                if #available(iOS 13.0, *) {
                    cropController.modalPresentationStyle = .fullScreen;
                } else {
                    // Fallback on earlier versions
                }
                self.present(cropController, animated: true, completion: nil)
                //self.navigationController!.pushViewController(cropController, animated: true)
            })
        }
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        cropViewController.dismiss(animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            ANLoader.showLoading("", disableUI:true)
            let selectedImage:UIImage = image.resize(withWidth:200)!
            let base64String = selectedImage.toBase64()
            let params = ["CandId":UserDefaults.standard.object(forKey:"cID") as! String,"ImageFile":base64String!] as [String:Any]
            ServerService.AccountInsertProfilePicture(self, params: params, method: "POST", accessToken:Constants.Token,acces:true, callBack:self.getresponseForPic(response:))
        })
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    //aftergettingResponseFrom the server
    func getresponseForPic(response:AnyObject)->()
    {
        print(response)
        ANLoader.hide()
        picUploadData = response as! JSON
        if picUploadData.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else if picUploadData["MessageStatus"].intValue == 1
        {
            UserDefaults.standard.set(picUploadData["ImageFile"].stringValue, forKey: "ImageFile")
            NotificationCenter.default.post(name: Notification.Name("updateImage"), object: nil)
            ServerService.ShowAlertMessage(ErrorMessage:Constants.imageMessage, title:"", view:self)
        }
        else
        {
            ServerService.ShowAlertMessage(ErrorMessage:picUploadData["Message"].stringValue, title:"", view:self)
        }
    }
    
    
}
extension DOEEnterViewController:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row==0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "hCell") as! THTableViewCell
            cell.selectionStyle = .none
            cell.startTimeLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
            cell.endLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
            cell.totalLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
            cell.dateLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "doeCell") as! DOEEnterTableViewCell
            
            cell.startTimeTextField.tag = 7+indexPath.row
            cell.endTimeField.tag   = 96+indexPath.row
            cell.startTimeTextField.text = starTimes[indexPath.row-1] as? String
            cell.endTimeField.text = endTimes[indexPath.row-1] as? String
            
            if self.view.bounds.size.height <= 568
            {
                cell.startTimeTextField.font = UIFont.systemFont(ofSize:9)
                cell.endTimeField.font = UIFont.systemFont(ofSize: 9)
            }
            else
            {
                cell.startTimeTextField.font = UIFont.systemFont(ofSize:14)
                cell.endTimeField.font = UIFont.systemFont(ofSize: 14)
            }
            if indexPath.row == 6||indexPath.row == 7
            {
                cell.startTimeTextField.isEnabled = false
                cell.endTimeField.isEnabled = false
                cell.startTimeTextField.backgroundColor = UIColor(hexString:"#EEEEEE")
                cell.endTimeField.backgroundColor = UIColor(hexString:"#EEEEEE")
                cell.startTimeTextField.leftView?.isHidden = true
                cell.endTimeField.leftView?.isHidden = true
            }
            else
            {
                cell.startTimeTextField.isEnabled = true
                cell.endTimeField.isEnabled = true
                cell.startTimeTextField.leftView?.isHidden = false
                cell.endTimeField.leftView?.isHidden = false
            }
            
            if weekEnds[indexPath.row-1].stringValue.count>0
            {
                
                cell.dateLabel.text = Constants.getFormattedDateForTimeSlips(string:weekEnds[indexPath.row-1].stringValue).uppercased()
            }
            else
            {
                cell.dateLabel.text = ""
            }
            cell.selectionStyle = .none
            cell.dateLabel.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
            if (cell.startTimeTextField.text!.count>0)&&(cell.endTimeField.text?.count)!>0
            {
                starTimes.replaceObject(at: indexPath.row-1, with: cell.startTimeTextField.text!)
                endTimes.replaceObject(at: indexPath.row-1, with: cell.endTimeField.text!)
                self.getHours(start:cell.startTimeTextField.text!, end:cell.endTimeField.text!, i:indexPath.row,min:false)
            }
            //            if (cell.startTimeTextField.text!.count>=0)
            //            {
            //                starTimes.replaceObject(at: indexPath.row-1, with: cell.startTimeTextField.text!)
            //
            //            }
            //            if (cell.endTimeField.text?.count)!>=0
            //            {
            //                endTimes.replaceObject(at: indexPath.row-1, with: cell.endTimeField.text!)
            //            }
            if (cell.startTimeTextField.text!.count>0)&&(cell.endTimeField.text?.count)!>0
            {
                cell.totalLabel.text = totalTimeInHours[indexPath.row-1] as? String
            }
            else
            {
                totalTimeInHours.replaceObject(at:indexPath.row-1, with:"")
                //totalHours.replaceObject(at:indexPath.row-1, with: "00:00")
                cell.totalLabel.text = ""
                self.total()
            }
            return cell
        }
    }
}
extension DOEEnterViewController:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return 35
        }
        else
        {
            if indexPath.row == 7
            {
                return 54
            }
            else
            {
                return 52
            }
        }
    }
    
}
extension DOEEnterViewController: SambagTimePickerViewControllerDelegate {
    
    func sambagTimePickerDidSet(_ viewController: SambagTimePickerViewController, result: SambagTimePickerResult)
    {
        
        if (activeTextField!.tag>7)&&(activeTextField!.tag)<16
        {
            activeTextField?.text = String(describing: result)
            starTimes.replaceObject(at: (activeTextField?.tag)!-8, with:String(describing: result))
        }
        else if (activeTextField!.tag>96)&&(activeTextField!.tag)<104
        {
            activeTextField?.text = String(describing: result)
            endTimes.replaceObject(at: (activeTextField?.tag)!-97, with:String(describing: result))
        }
        timeSlipTableView.reloadData()
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func sambagTimePickerDidCancel(_ viewController: SambagTimePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
extension DOEEnterViewController:DateTimePickerDelegate
{
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        
        print(picker.selectedDateString)
    }
}




