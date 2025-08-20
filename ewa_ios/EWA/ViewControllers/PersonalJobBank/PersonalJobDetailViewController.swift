//
//  PersonalJobDetailViewController.swift
//  EWA
//
//  Created by NFC Solutions on 05/12/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import ANLoader
import CropViewController

class PersonalJobDetailViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate {
    
    @IBOutlet var headerTextLabel: UILabel!
    @IBOutlet var deatilsTableView: UITableView!
    var job:JSON = JSON.null
    var jobDetails:JSON =  JSON.null
    var picUploadData:JSON = JSON.null
    var titlesArray = ["Company Name","Company Description","Job Title","Pay Rate","Date Range","Order Schedule","Description","Uniform","Location","City, State, Zip","Report To","Directions"]
    var orderId = String()
    var detailStatus = String()
    var linkString = String()
    var indexRows = [0,1,2,3,14,5,6,7,8,19,10,11]
    var ObjectKeys = ["CompanyName","CompanyDescription","JobTitle","PayRate","DateRange","CandOrderSchedule","JobDescription","uniform","Address","State","ReportTo","Go There"]
    
    @IBOutlet var headerView: UIView!
    
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
            ANLoader.hide()
        })
        if ConnectionCheck.isConnectedToNetwork()
        {
            //ANLoader.showLoading("", disableUI:false)
            ServerService.showActivityIndicatory(uiView:self.view)
            let paramsMenu:[String:String] = ["OrderId":orderId,"DetailsStatus":detailStatus,"CandId":UserDefaults.standard.object(forKey: "cID") as! String]
            print(paramsMenu)
            ServerService.getPersonalJobBankJobDetails(self, params: paramsMenu, method:"POST", accessToken:Constants.Token, acces:true, callBack: getresponse(response:))
        }
        else
        {
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
        }
        
        
        self.title = "Details"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17)]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
    }
    
    //aftergettingResponseFrom the server
    func getresponse(response:AnyObject)->()
    {
        ANLoader.hide()
        ServerService.hideProgressView()
        jobDetails = response as! JSON
        print(jobDetails)
        if jobDetails.isEmpty
        {
            print("empty")
            ServerService.ShowAlertMessage(ErrorMessage:"Due to some network issues we were unable to get data, please try again after some time", title:"", view:self)
        }
        else
        {
            headerTextLabel.text = jobDetails["DetailStatusMessage"].stringValue
            headerView.frame.size.height = Constants.calculateHeightWithFont(inString:jobDetails["DetailStatusMessage"].stringValue
                ,width:self.view.bounds.size.width-20,font:UIFont.systemFont(ofSize:17))+20
            deatilsTableView.reloadData()
        }
    }
    @IBAction func handleNavgationBarButtonTap(_ sender: UIBarButtonItem, event: UIEvent)
        
    {
        Constants.showUp(event:event,viewController:self)
        
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
extension PersonalJobDetailViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == indexRows[indexPath.row]
        {
            
            if indexPath.row == 6
            {
                let heightOfRow = jobDetails[ObjectKeys[indexPath.row]].stringValue.htmlToAttributedString!.height(withConstrainedWidth:self.view.bounds.size.width-20)
                //Constants.calculateHeightWithFont(inString:jobDetails[ObjectKeys[indexPath.row]].stringValue
                //,width:self.view.bounds.size.width-20,font:UIFont.systemFont(ofSize:15))
                return (heightOfRow+50)
            }
            else if indexPath.row == 4
            {
                let heightOfRow = Constants.calculateHeightWithFont(inString:jobDetails["DateRange"].stringValue+" "+jobDetails["DateRangeText"].stringValue
                    ,width:self.view.bounds.size.width-20,font:UIFont.systemFont(ofSize:15))
                return (heightOfRow+50)
                
            }
            else if indexPath.row == 5
            {
                
                var ScheduleString = String()
                
                for i in 0..<jobDetails["CandScheduleList"].arrayValue.count
                {
                    if i ==  0
                    {
                        ScheduleString.append(jobDetails["CandScheduleList"][i].stringValue.removeHtmlFromString(inPutString: jobDetails["CandScheduleList"][i].stringValue))
                    }
                    else
                    {
                        ScheduleString.append("\n"+jobDetails["CandScheduleList"][i].stringValue.removeHtmlFromString(inPutString: jobDetails["CandScheduleList"][i].stringValue))
                    }
                    
                }
                let heightOfRow = Constants.calculateHeightWithFont(inString:ScheduleString,width:self.view.bounds.size.width-20,font:UIFont.systemFont(ofSize:15))
                return (heightOfRow+50)
                
            }
            else if indexPath.row == 7 {
                if jobDetails["Isdivuniform"].intValue == 0 {
                    return 0
                }
                else {
                    
                    let heightOfRow = Constants.calculateHeight(inString:jobDetails[ObjectKeys[indexPath.row]].stringValue.htmlToString
                        ,width:self.view.bounds.size.width-20)
                    return (heightOfRow+50)
                }
            }
            else
            {
                let heightOfRow = Constants.calculateHeight(inString:jobDetails[ObjectKeys[indexPath.row]].stringValue
                    ,width:self.view.bounds.size.width-20)
                return (heightOfRow+50)
            }
        }
        else if indexPath.row == 9
        {
            return 60
        }
        else
        {
            return 70
        }
    }
}
extension PersonalJobDetailViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"jCell") as! JobDeatilTableViewCell
        cell.titleLabel.text = titlesArray[indexPath.row]
        if indexPath.row == 0
        {
            cell.accessoryType = .none
            cell.contentLabel.text =  jobDetails["CompanyName"].stringValue
            cell.contentLabel.textColor = .darkGray
            return cell
        }
        else if indexPath.row == 1
        {
            cell.accessoryType = .none
            cell.contentLabel.text =  jobDetails["CompanyDescription"].stringValue
            cell.contentLabel.textColor = .darkGray
            return cell
        }
        else if indexPath.row == 2
        {
            cell.accessoryType = .none
            cell.contentLabel.text =  jobDetails["JobTitle"].stringValue
            cell.contentLabel.textColor = .darkGray
            return cell
        }
        else if indexPath.row == 5
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier:"scCell") as! ScheduleTableViewCell
            cell.titleLabel.text = titlesArray[indexPath.row]
            cell.accessoryType = .none
            if jobDetails["CandOrderSchedule"].stringValue == "Click here to view FULL schedule"
            {
                cell.cLabelConstrain.constant = 10
                cell.contentLabel.text =  jobDetails["CandOrderSchedule"].stringValue.removeHtmlFromString(inPutString: jobDetails["CandOrderSchedule"].stringValue)
                cell.contentLabel.textColor = UIColor(hexString:"#337ab7")
                cell.contentLabel.underline()
            }
            else
            {
                var ScheduleString = String()
                var daysString = String()
                for i in 0..<jobDetails["CandScheduleList"].arrayValue.count
                {
                    if i ==  0
                    {
                        let string = jobDetails["CandScheduleList"][i].stringValue.removeHtmlFromString(inPutString: jobDetails["CandScheduleList"][i].stringValue)
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
                        let string = jobDetails["CandScheduleList"][i].stringValue.removeHtmlFromString(inPutString: jobDetails["CandScheduleList"][i].stringValue)
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
            cell.contentLabel.attributedText =  jobDetails["JobDescription"].stringValue.htmlToAttributedString
            cell.contentLabel.textColor = .darkGray
            return cell
        }
        else if indexPath.row == 4
        {
            cell.accessoryType = .none
            cell.contentLabel.text =  jobDetails["DateRange"].stringValue
            return cell
        }
        else  if indexPath.row == 7{
            cell.accessoryType = .none
            cell.contentLabel.text = jobDetails["uniform"].stringValue.htmlToString
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row == 8
        {
            cell.accessoryType = .none
            cell.contentLabel.text =  jobDetails["Address"].stringValue
            cell.contentLabel.textColor = .darkGray
            return cell
        }
        else if indexPath.row == 9
        {
            cell.accessoryType = .none
            cell.contentLabel.text =  jobDetails["City"].stringValue+", "+jobDetails["State"].stringValue+", "+jobDetails["Zip"].stringValue
            cell.contentLabel.textColor = .darkGray
            return cell
        }
        else if indexPath.row == 10
        {
            cell.accessoryType = .none
            cell.contentLabel.text =  jobDetails["ReportTo"].stringValue
            cell.contentLabel.textColor = .darkGray
            return cell
        }
            
        else if indexPath.row == 3
        {
            
            if jobDetails["PayRate"].string == "Click on this link to view the Current Pay Rate Schedule"
            {
                cell.accessoryType = .none
                cell.contentLabel.text = jobDetails["PayRate"].stringValue
                cell.contentLabel?.textColor = UIColor(hexString:"#337ab7")
                cell.contentLabel.underline()
            }
            else
            {
                cell.accessoryType = .none
                cell.contentLabel.text =  jobDetails["PayRate"].stringValue
                cell.contentLabel.textColor = .darkGray
            }
            return cell
        }
        else
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "mCell") as! MapTableViewCell
            cell.titleLabel.text = titlesArray[indexPath.row]
            cell.descriptionLabel.text = jobDetails["Direction"].stringValue
            if jobDetails["Direction"].stringValue.count>0
            {
                cell.accessoryType = .none
                cell.descriptionLabel.underline()
            }
            else
            {
                cell.accessoryType = .none
            }
            cell.descriptionLabel?.textColor = UIColor(hexString:"#337ab7")
            cell.selectionStyle = .none
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 11
        {
            if jobDetails["Direction"].stringValue.count>0
            {
                linkString = jobDetails["DirectionUrl"].stringValue
                self.performSegue(withIdentifier:"detailSegue", sender: nil)
            }
        }
        else if indexPath.row == 3
        {
            if jobDetails["PayRate"].string == "Click on this link to view the Current Pay Rate Schedule"
            {
                linkString = jobDetails["PayRateSchedulePDFPath"].stringValue
                self.performSegue(withIdentifier:"detailSegue", sender: nil)
            }
        }
        else if indexPath.row == 5
        {
            if jobDetails["CandOrderSchedule"].stringValue == "Click here to view FULL schedule"
            {
                self.performSegue(withIdentifier:"varySegue", sender:nil)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailSegue"
        {
            let dvc = segue.destination as! WebViewController
            dvc.link = linkString
            
        }
        if segue.identifier == "varySegue"
        {
            let dvc = segue.destination as! VaryOrderScheduleViewController
            dvc.from = "PJB"
            dvc.orderId = orderId
        }
    }
}
