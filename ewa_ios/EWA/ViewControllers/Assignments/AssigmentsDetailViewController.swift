//
//  AssigmentsDetailViewController.swift
//  EWA
//
//  Created by NFC Solutions on 20/10/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import ANLoader
import CropViewController
import CoreLocation

class AssigmentsDetailViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CropViewControllerDelegate {
    
    @IBOutlet var orderTableView: UITableView!
    var object: JSON = JSON.null
    var orderId = String()
    var Division = String()
    var dateString = String()
    var startTime = String()
    var EndTime = String()
    var link = String()
    var picUploadData:JSON = JSON.null
    var locationManager = CLLocationManager()
    
    var titles  = ["Client Name","Job Title","Report To","Pay Rate","Date Range","Assignment Schedule","Description","Uniform","Client Description","Location","City, State, Zip","Directions"]
    
    @IBOutlet var headerLabel: UILabel!
    
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        
        
        
        //calling the api
        DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
            ANLoader.hide()
        })
        if ConnectionCheck.isConnectedToNetwork()
        {
            // ANLoader.showLoading("", disableUI:false)
            ServerService.showActivityIndicatory(uiView:self.view)
            let params:[String:String] = ["CandId":UserDefaults.standard.object(forKey: "cID") as! String,"orderId":orderId,"Date":dateString,"StartTime":startTime,"EndTime":EndTime,"Division":Division]
           print(params)
            ServerService.getOrderDetails(self, params: params, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponse(response:))
        }
        else
        {
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
        
    }
    
    //aftergettingResponseFrom the server
    func getresponse(response:AnyObject)->()
    {
        ANLoader.hide()
        ServerService.hideProgressView()
        object = response as! JSON
        print(object)
        if object.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else
        {
            titles[0] = object["Category"].stringValue
            headerLabel.text = object["Message"].stringValue
            orderTableView.reloadData()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "webSegue"
        {
            let dvc = segue.destination as! WebViewController
            dvc.link = link
        }
        if segue.identifier == "varySegue"
        {
            let dvc = segue.destination as! VaryOrderScheduleViewController
            dvc.from = "Assigments"
            dvc.orderId = orderId
        }
    }
    @IBAction func handleNavgationBarButtonTap(_ sender: UIBarButtonItem, event: UIEvent)
        
    {
        Constants.showUp(event:event,viewController:self)
        
    }
    
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
        ANLoader.hide()
        print(response)
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
    
    /*
     //checks for location permission
     func checkLocationPermission() -> Bool
     {
     var access = Bool()
     if CLLocationManager.locationServicesEnabled()
     {
     switch(CLLocationManager.authorizationStatus())
     {
     case .authorizedAlways, .authorizedWhenInUse:
     print("Authorize.")
     access = true
     break
     case .notDetermined:
     print("Not determined.")
     access = false
     break
     case .restricted:
     print("Restricted.")
     access = false
     break
     case .denied:
     print("Denied.")
     access = false
     }
     }
     return access
     }
     */
    
    
    
}
extension AssigmentsDetailViewController:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if indexPath.row == 11
        {
            
            print("Permission is",checkLocationPermission())
            
            if checkLocationPermission()
            {
//                let address = object["Address"].stringValue+object["City"].stringValue+object["State"].stringValue+object["Zip"].stringValue
//                if let url = URL(string:"comgooglemaps://?saddr=&daddr=\(address.replace(target:" ", withString:""))&directionsmode=driving") {
//                    UIApplication.shared.open(url, options: [:])
//                }
//                else {
                    if object["DirectionUrl"].stringValue.count > 0 {
                    NSLog("Can't use comgooglemaps://")
                    link = object["DirectionUrl"].stringValue
                    self.performSegue(withIdentifier: "webSegue", sender: nil)
                    }
             //   }
            }
            else
            {
                let alertController = UIAlertController(title: "", message: "Allow TGCMobileApp to access your location and try again", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "DENY", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                    self.link = self.object["DirectionUrl"].stringValue
                    self.performSegue(withIdentifier: "webSegue", sender: nil)
                }
                
                let okAction = UIAlertAction(title: "ALLOW", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    if let bundleId = Bundle.main.bundleIdentifier,
                        let url = URL(string: "\(UIApplicationOpenSettingsURLString)&path=LOCATION/\(bundleId)") {
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
        if indexPath.row == 3
        {
            if object["Payrate"].string == "Click on this link to view the Current Pay Rate Schedule"
            {
                link = object["SPRates"].stringValue
                self.performSegue(withIdentifier: "webSegue", sender: nil)
            }
        }
        else if indexPath.row == 5
        {
            if object["CandOrderSchedule"].stringValue == "Click here to view FULL schedule"
            {
                self.performSegue(withIdentifier:"varySegue", sender:nil)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row ==     0
        {
            let heightOfRow = Constants.calculateHeight(inString:object["CompanyName"].stringValue,width:self.view.bounds.size.width)
            return (heightOfRow+40)
        }
        else if indexPath.row == 1
        {
            let heightOfRow = Constants.calculateHeight(inString:object["JobTitle"].stringValue,width:self.view.bounds.size.width)
            return (heightOfRow+40)
        }
        else if indexPath.row == 2
        {
            let heightOfRow = Constants.calculateHeight(inString:object["ReportTo"].stringValue,width:self.view.bounds.size.width)
            return (heightOfRow+40)
        }
        else if indexPath.row == 3
        {
            if object["Payrate"].string == "Click on this link to view the Current Pay Rate Schedule"
            {
                let heightOfRow = Constants.calculateHeight(inString:object["Payrate"].stringValue,width:self.view.bounds.size.width)
                return (heightOfRow+40)
            }
            else
            {
                let heightOfRow = Constants.calculateHeight(inString:object["Payrate"].stringValue,width:self.view.bounds.size.width)
                return (heightOfRow+40)
            }
        }
        else if indexPath.row == 4
        {
            if object.count>0
            {
                let heightOfRow = Constants.calculateHeight(inString:Constants.getFormattedDate(string:object["StartDate"].stringValue)+" to "+Constants.getFormattedDate(string:object["EndDate"].stringValue),width:self.view.bounds.size.width)
                return (heightOfRow+40)
                
            }
            else
            {
                return 30
            }
        }
        else if indexPath.row == 5
        {
            var ScheduleString = String()
            
            for i in 0..<object["CandScheduleList"].arrayValue.count
            {
                if i ==  0
                {
                    ScheduleString.append(object["CandScheduleList"][i].stringValue.removeHtmlFromString(inPutString: object["CandScheduleList"][i].stringValue))
                }
                else
                {
                    ScheduleString.append("\n"+object["CandScheduleList"][i].stringValue.removeHtmlFromString(inPutString: object["CandScheduleList"][i].stringValue))
                }
                
            }
            let heightOfRow = Constants.calculateHeightWithFont(inString:ScheduleString,width:self.view.bounds.size.width-20,font:UIFont.systemFont(ofSize:15))
            return (heightOfRow+40)
        }
        else if indexPath.row == 6
        {
            let heightOfRow =   object["JobDescription"].stringValue.htmlToAttributedString!.height(withConstrainedWidth:self.view.bounds.size.width)
            //Constants.calculateHeight(inString:object["JobDescription"].stringValue.htmlToAttributedString,width:self.view.bounds.size.width)
            return (heightOfRow+40)
        }
        else if indexPath.row == 7{
            if object["Isdivuniform"].intValue == 0 {
                return 0
            }
            else {
                let txt = object["Uniform"].stringValue.htmlToString
                let heightOfRow = Constants.calculateHeight(inString:txt,width:self.view.bounds.size.width)
                return (heightOfRow+40)
            }
            
        }
        else if indexPath.row == 8
        {
            let heightOfRow = Constants.calculateHeight(inString:object["ClientDescription"].stringValue,width:self.view.bounds.size.width)
            return (heightOfRow+40)
        }
        else if indexPath.row == 9
        {
            let heightOfRow = Constants.calculateHeight(inString:object["Address"].stringValue,width:self.view.bounds.size.width)
            return (heightOfRow+40)
        }
        else if indexPath.row == 10
        {
            let heightOfRow = Constants.calculateHeight(inString:object["City"].stringValue+","+object["State"].stringValue+","+object["Zip"].stringValue,width:self.view.bounds.size.width)
            return (heightOfRow+40)
            
        }
        else if indexPath.row == 11
        {
            let heightOfRow = Constants.calculateHeight(inString:object["Direction"].stringValue,width:self.view.bounds.size.width-20)
            return (heightOfRow+90)
        }
        else {
            return 0
        }
        
    }
    
}
extension AssigmentsDetailViewController:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adCell") as! AssignmentDetailTableViewCell
        cell.titleLabel.text = titles[indexPath.row]
        if indexPath.row ==     0
        {
            cell.accessoryType = .none
            cell.descriptionLabel.text = object["CompanyName"].stringValue
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row == 1
        {
            cell.accessoryType = .none
            cell.descriptionLabel.text = object["JobTitle"].stringValue
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row == 2
        {
            cell.accessoryType = .none
            cell.descriptionLabel.text = object["ReportTo"].stringValue
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row == 3
        {
            if object["Payrate"].string == "Click on this link to view the Current Pay Rate Schedule"
            {
                cell.accessoryType = .none
                cell.descriptionLabel?.textColor = UIColor(hexString:"#337ab7")
                cell.descriptionLabel.text = object["Payrate"].stringValue
                cell.descriptionLabel.underline()
            }
            else
            {
                cell.accessoryType = .none
                cell.descriptionLabel?.textColor = .black
                cell.descriptionLabel.text = object["Payrate"].stringValue
            }
            
            cell.selectionStyle = .none
            return cell
            
        }
        else if indexPath.row == 4
        {
            if object.count>0
            {
                
                cell.descriptionLabel.text =  Constants.getFormattedDate(string:object["StartDate"].stringValue)+" to "+Constants.getFormattedDate(string:object["EndDate"].stringValue)
            }
            cell.accessoryType = .none
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row == 5
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:"scCell") as! ScheduleTableViewCell
            cell.titleLabel.text = titles[indexPath.row]
            cell.accessoryType = .none
            if object["CandOrderSchedule"].stringValue == "Click here to view FULL schedule"
            {
                cell.cLabelConstrain.constant = 10
                cell.contentLabel.text =  object["CandOrderSchedule"].stringValue.removeHtmlFromString(inPutString: object["CandOrderSchedule"].stringValue)
                cell.contentLabel.textColor = UIColor(hexString:"#337ab7")
                cell.contentLabel.underline()
            }
            else
            {
                var ScheduleString = String()
                var daysString = String()
                for i in 0..<object["CandScheduleList"].arrayValue.count
                {
                    if i ==  0
                    {
                        let string = object["CandScheduleList"][i].stringValue.removeHtmlFromString(inPutString: object["CandScheduleList"][i].stringValue)
                        if let range = string.range(of:"day") {
                            let firstPart = string[string.startIndex..<range.lowerBound]
                            print(firstPart) // print Hello
                            daysString.append(firstPart+"day")
                            let secondPart = string.components(separatedBy:"day")[1]
                            ScheduleString.append(secondPart)
                        }
                        // ScheduleString.append(jobDetails["CandScheduleList"][i].stringValue.removeHtmlFromString(inPutString: jobDetails["CandScheduleList"][i].stringValue))
                    }
                    else
                    {
                        let string = object["CandScheduleList"][i].stringValue.removeHtmlFromString(inPutString: object["CandScheduleList"][i].stringValue)
                        if let range = string.range(of:"day") {
                            let firstPart = string[string.startIndex..<range.lowerBound]
                            print(firstPart) // print Hello
                            daysString.append("\n"+firstPart+"day")
                            let secondPart = string.components(separatedBy:"day")[1]
                            ScheduleString.append("\n"+secondPart)
                        }
                        //ScheduleString.append("\n"+jobDetails["CandScheduleList"][i].stringValue.removeHtmlFromString(inPutString: jobDetails["CandScheduleList"][i].stringValue))
                    }
                    
                }
                cell.cLabelConstrain.constant = 100
                cell.selectionStyle = .none
                cell.daysLabel.text = daysString
                cell.contentLabel.text = ScheduleString
                cell.contentLabel.textColor = .darkGray
            }
            return cell
        }
        else if indexPath.row == 6
        {
            cell.accessoryType = .none
            cell.descriptionLabel.attributedText =      object["JobDescription"].stringValue.htmlToAttributedString
            cell.descriptionLabel.numberOfLines = 0
            cell.selectionStyle = .none
            return cell
        }
        else  if indexPath.row == 7{
            cell.accessoryType = .none
            cell.descriptionLabel.text = object["Uniform"].stringValue.htmlToString
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row == 8
        {
            cell.accessoryType = .none
            cell.descriptionLabel.text = object["ClientDescription"].stringValue
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row == 9
        {
            cell.accessoryType = .none
            cell.descriptionLabel.text = object["Address"].stringValue
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row == 10
        {
            cell.accessoryType = .none
            cell.descriptionLabel.text = object["City"].stringValue+", "+object["State"].stringValue+", "+object["Zip"].stringValue
            cell.selectionStyle = .none
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mCell") as! MapTableViewCell
            cell.titleLabel.text = titles[indexPath.row]
            cell.descriptionLabel.text = object["Direction"].stringValue
            cell.descriptionLabel.textAlignment = .left
            cell.accessoryType = .none
            cell.descriptionLabel?.textColor = UIColor(hexString:"#337ab7")
            if object["Direction"].stringValue.count>0
            {
                cell.descriptionLabel.underline()
            }
            cell.selectionStyle = .none
            return cell
        }
        
        
    }
}



