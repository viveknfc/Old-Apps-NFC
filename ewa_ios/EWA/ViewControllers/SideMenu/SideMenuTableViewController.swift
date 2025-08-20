//
//  SideMenuTableViewController.swift
//  EWA
//
//  Created by NFC Solutions on 30/10/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit
import ExpyTableView
import SDWebImage
import Photos
import SwiftyJSON
import ANLoader
import CropViewController
import CoreLocation

class SideMenuTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate
{
    
    
    //Outlets form the storyBoard
    
    @IBOutlet var editIcon: UIImageView!
    @IBOutlet var headerView: UIView!
    //@IBOutlet var imageTopConstrain: NSLayoutConstraint!
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var expTableView: ExpyTableView!
    @IBOutlet weak var locationToggle: UISwitch!
    @IBOutlet weak var locationAccesslabel: UILabel!
    
    @IBOutlet weak var versionLabel: UILabel!
    //Variable declarations
    
    let imagePicker = UIImagePickerController()
    var titles = [String]()
    var icons = ["dash.png","list.png","bclock.png"]
    //var Availabilitysegues = ["showCenterController","sAvailSegue","jobsSegue"]
    //var TimeSlips = ["doeSegue","timeSegue"]
    var picUploadData:JSON = JSON.null
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    
    
    override func loadView() {
        super.loadView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viv reaches sidemenu table vc view did load")
        
        
        titles = Constants.menuHeaders
        imagePicker.delegate = self
        if titles.contains("Demo Candidates")
        {
            let demoIndex = titles.index(where:{$0 == "Demo Candidates"})
            titles.rearrange(from:demoIndex!, to: 0)
            Constants.titleImages.rearrange(from:demoIndex!, to:0)
        }
        
        //configuring profileImageView
        headerImageView.layer.cornerRadius = 60
        headerImageView.layer.masksToBounds = true
        headerImageView.isUserInteractionEnabled = true
        
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            headerView.frame.size.height = 250
        }
        
        //adding tap gesture to profileImage
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SideMenuTableViewController.myviewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        headerImageView.addGestureRecognizer(tapGesture)
        editIcon.addGestureRecognizer(tapGesture)
        
        
        //registering notification for updating profile image
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateImage(notification:)), name: Notification.Name("updateImage"), object: nil)
        
        //registering notification for shpwing or hiding the toggle button
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateToogleButton(notification:)), name: Notification.Name("updateToggleButton"), object: nil)
        
        //locationAccesslabel.isHidden = true
        //locationToggle.isHidden = true
        
        show_hide_togglebutton()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        for e in 0..<titles.count {
            expTableView.expand(e+1)
            //expTableView.expand(e)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("loaded")
        versionLabel.text = "v.\(Constants.APP_VERSION)"

        self.imageShow()
    }
    
    
    
    //this is called updateToogle notififcation gets called
    @objc func updateToogleButton(notification: Notification)
    {
        print("update toggle button clicked")
        show_hide_togglebutton()
    }
    
    
    //this is called updateImage notififcation gets called
    @objc func updateImage(notification: Notification)
    {
        self.imageShow()
    }
    
    //this method is use to hide or show location toggle button
    func show_hide_togglebutton()
    {
        //
        print("viv reached show or hide toggle button")
        let access = checkLocationPermission()
        if access
        {
            print("Access is true")
            locationToggle.isHidden = true
            locationAccesslabel.isHidden = true
        }
        else
        {
            print("Access is false")
            locationAccesslabel.isHidden = false
            locationToggle.isOn = false
            locationToggle.isHidden = false
        }
        //        not in use
        //                if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height >= 2436 {
        //        }
        
    }
    
    
    
    
    
    
    //this function is used to show the image on the profileImageView
    func imageShow()  {
        if UserDefaults.standard.object(forKey:"ImageFile") != nil {
            
            
            if ((UserDefaults.standard.object(forKey:"ImageFile") as! String)).count>0
            {
                let decodedData = Data(base64Encoded:UserDefaults.standard.object(forKey:"ImageFile") as! String, options: .ignoreUnknownCharacters)
                let decodedimage = UIImage(data:decodedData!)
                print(decodedimage!)
                headerImageView.image = decodedimage
            }
        }
    }
    
    //this fuction will get called when set taps on the profileImageView
    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
        print("My view tapped reached")
        self.showImagePicker()
    }
    
    //show imagePicker
    func showImagePicker() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //this method will open the camera
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            if #available(iOS 13.0, *) {
                imagePicker.modalPresentationStyle = .fullScreen;
            } else {
                // Fallback on earlier versions
            }
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    //this method will open the gallery
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        if #available(iOS 13.0, *) {
            imagePicker.modalPresentationStyle = .fullScreen;
        } else {
            // Fallback on earlier versions
        }
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //        headerImageView.image = chosenImage
        //        imagePicker.dismiss(animated: true, completion: nil)
        //
        //        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
        //            self.sideMenuController?.toggle()
        //        })
        //
        //        let base64String = chosenImage.toBase64()
        //        let params = ["CandId":UserDefaults.standard.object(forKey:"cID") as! String,"ImageFile":base64String!] as [String:Any]
        //        ServerService.AccountInsertProfilePicture(self, params: params, method: "POST", accessToken:Constants.Token,acces:true, callBack:self.getresponseForPic(response:))
        //
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
            print(params)
            ServerService.AccountInsertProfilePicture(self, params: params, method: "POST", accessToken:Constants.Token,acces:true, callBack:self.getresponseForPic(response:))
        })
        
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    //aftergettingResponseFrom the server
    func getresponseForPic(response:AnyObject)->()
    {
        
        print(response)
        picUploadData = response as! JSON
        if picUploadData["MessageStatus"].intValue == 1
        {
            UserDefaults.standard.set(picUploadData["ImageFile"].stringValue, forKey: "ImageFile")
            self.imageShow()
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:Constants.imageMessage, title:"", view:self)
        }
        else
        {
            ANLoader.hide()
            ServerService.ShowAlertMessage(ErrorMessage:picUploadData["Message"].stringValue, title:"", view:self)
        }
    }
    
    
    
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return titles.count+1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if titles.contains("Demo Candidates")
        {
            
            if section<=1
            {
                return 1
            }
            else
            {
                
                return Constants.menuSections[section-2].count+1
            }
        }
        else
        {
            if section==0
            {
                return 1
            }
            else
            {
                return Constants.menuSections[section-1].count+1
            }
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mCell") as! MenuTableViewCell
        cell.selectionStyle = .gray // .none was there viv
        
        if titles.contains("Demo Candidates")
        {
            if indexPath.section>1
            {
                if Constants.menuSections[indexPath.section-2][indexPath.row-1] == "OnCall Counsel Timeslips"
                {
                    cell.nameLabel?.text = "Enter Timeslips"
                }
                else
                {
                    cell.nameLabel?.text = Constants.menuSections[indexPath.section-2][indexPath.row-1]
                }
            }
        }
        else
        {
            if Constants.menuSections[indexPath.section-1][indexPath.row-1] == "OnCall Counsel Timeslips"
            {
                cell.nameLabel?.text = "Enter Timeslips"
            }
            else
            {
                cell.nameLabel?.text = Constants.menuSections[indexPath.section-1][indexPath.row-1]
            }
        }
        

        return cell
    }
        
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if titles.contains("Demo Candidates")
        {
            if indexPath.row >= 1
            {
                return 60
            }
            else
            {
                return 44
            }
        }
        else
        {
            if indexPath.row == 0
            {
                return 60
            }
            else
            {
                if Constants.menuSections[indexPath.section-1][indexPath.row-1] == "Settings" {
                    // if indexPath.section == 6 {
                    return 0
                }
                else {
                    return 44
                }
            }
        }
    }
    
    
    
    
    
    //location togglr button action
    @IBAction func turnLocationLoaction(_ sender: Any) {
        if let bundleId = Bundle.main.bundleIdentifier,
           let url = URL(string: "\(UIApplicationOpenSettingsURLString)&path=LOCATION/\(bundleId)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    /*
     //that below method will check for the location services
     //check for location permissions
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
    
    //MARK:- EtimeClocks Flow
    func navigateToETimeClocks(){
        let identifier = "eTimeClock History"
        let vc1:UIViewController = (self.storyboard?.instantiateViewController(withIdentifier:identifier))!
        let navi = BaseNaviViewController(rootViewController:vc1)
        navi.navigationBar.tintColor = .white
        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:identifier)
    }
    
    
}


//END OF CLASS



//Extensions

extension SideMenuTableViewController: ExpyTableViewDelegate {
    func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int) {
            // Your implementation here
        }
}

extension SideMenuTableViewController: ExpyTableViewDataSource {
    
    
    func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
        return true
    }
    
    func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HeaderTableViewCell.self)) as! HeaderTableViewCell
        //Make your customizations here.
        
        if titles.contains("Demo Candidates")
        {
            if section == 0
            {
                cell.labelHeader.text = "Dashboard"
                cell.icon.image = UIImage(named:icons[0])
            }
            else if section == 1
            {
                //                cell.labelHeader.text = titles[1]
                //                cell.icon.sd_setImage(with:URL(string:Constants.titleImages[section-1].replace(target:"\\", withString:"//")), placeholderImage: UIImage(named:"placeholder.png"))
                showTitles(cell: cell, section:section)
            }
            else
            {
                showTitles(cell: cell, section:section)
                
            }
            
            
        }
        else
        {
            if section == 0
            {
                cell.labelHeader.text = "Dashboard"
                cell.icon.image = UIImage(named:icons[0])
            }
            else
            {
                showTitles(cell: cell, section:section)
            }
        }
        return cell
    }
    
    // showing the title in row for index method
    func showTitles(cell:HeaderTableViewCell,section: Int)
    {
        if titles.count>=1
        {
            cell.labelHeader.text = titles[section-1]
            cell.icon.sd_setImage(with:URL(string:Constants.titleImages[section-1].replace(target:"\\", withString:"//")), placeholderImage: UIImage(named:"placeholder.png"))
        }
        else
        {
            cell.labelHeader.text = ""
        }
    }
}




extension SideMenuTableViewController {
    //ExpyTableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select row is selected")
        if titles.contains("Demo Candidates")
        {
            
            if indexPath.section>=2
            {
                if indexPath.row>0
                {
                    embedIntoController(indexPath:indexPath)
                }
                if titles[indexPath.section-1] == "Settings"
                {
                    main_menu_clicked(indexPath:indexPath)
                }
                else if titles[indexPath.section-1] == "Notifications"
                {
                    main_menu_clicked(indexPath:indexPath)
                    
                }
            }
            else if indexPath.section == 0
            {
                print("identifier dashboard is selected")
                sideMenuController?.performSegue(withIdentifier:"dashBoard", sender: nil)
                
            }
            else if indexPath.section == 1
            {
                print("identifier demoCandidates is selected")
                sideMenuController?.performSegue(withIdentifier:"demoCandidates", sender: nil)
            }
            
        }
        else
        {
            if indexPath.section>=1
            {
                if titles[indexPath.section-1] == "Settings"
                {
                    main_menu_clicked(indexPath:indexPath)
                }
                else if titles[indexPath.section-1] == "Notifications"
                {
                    main_menu_clicked(indexPath:indexPath)
                }
                else if indexPath.row>0
                {
                    embedIntoController(indexPath:indexPath)
                }
            }
            else if indexPath.section == 0
            {
                print("dashboard is coming from here")
                sideMenuController?.performSegue(withIdentifier:"dashBoard", sender: nil)
                
            }
            
        }
        tableView.deselectRow(at: indexPath, animated: false)
        print("DID SELECT row: \(indexPath.row), section: \(indexPath.section)")
    }
    
    
    
    func main_menu_clicked(indexPath:IndexPath)
    {
        let identifier = titles[indexPath.section-1]
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateVC(withIdentifier: identifier) {
            let navi = BaseNaviViewController(rootViewController:viewController)
            navi.navigationBar.tintColor = .white
            navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            sideMenuController?.embed(centerViewController:navi, cacheIdentifier:identifier)
        }
        else {
            
        }
    }
    
    // embdedding a controller into the menu
    func embedIntoController(indexPath: IndexPath)
    {
        var identifier = String()
        if titles.contains("Demo Candidates")
        {
            identifier = Constants.menuSections[indexPath.section-2][indexPath.row-1]
        }
        else
        {
            identifier = Constants.menuSections[indexPath.section-1][indexPath.row-1]
        }
        Constants.Menu = identifier
        let mon =  Constants.dashObject["List"].arrayValue.filter { $0["LinkText"].stringValue == identifier && $0["ParentMenuId"].intValue > 0} as [JSON]
        print(mon.count)
        print("***viv the response is \(mon)***")
        if mon.count > 0 && mon[0]["LinkType"].intValue == 1{
            print(mon[0]["LinkUrl"].stringValue)
            print(mon[0]["LinkText"].stringValue)
            print("********Vivek**********")
            Constants.LinkUrl = mon[0]["LinkUrl"].stringValue
            Constants.LinkText = mon[0]["LinkText"].stringValue
            Constants.iSFormOkRequired = false
            self.sideMenuController?.toggle()
            //  let dataDict:[String: String] = ["LinkUrl": mon[0]["LinkUrl"].stringValue,
            //   "LinkText":mon[0]//["LinkText"].stringValue]
            // NotificationCenter.default.post(name: Notification.Name("StandAlone"), object: nil, userInfo: dataDict)
            self.pushToStandAlone()
            
        }
        else {
            
            if identifier == "eTimeClock"
            {
                print("clicked etimeclock from sidemenu")
                identifier = "eTimeClock History"
                UserDefaults.standard.set("0", forKey: "eTimeClock")
            }
            
            else if  identifier == "eTimeClock History" {
                print("clicked etimeclock history from sidemenu")
                identifier = "eTimeClock History"
                UserDefaults.standard.set("1", forKey: "eTimeClock")
            }
            else if identifier == "Manage Text Message" {
                //identifier = "ManageTextMessages"
                let VC = ManageTextMessages(nibName: "ManageTextMessages", bundle: nil)
                let navi = BaseNaviViewController(rootViewController:VC)
                navi.navigationBar.tintColor = .white
                navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                sideMenuController?.embed(centerViewController:navi, cacheIdentifier:identifier)
            }
            else if identifier == Constants.A1Form {
                
                print("*********VIVEK Clicked A1 Form Here**********")
                
                //viv start
                
                if ConnectionCheck.isConnectedToNetwork()
                {
                    ServerService.showActivityIndicatory(uiView:self.view)
                    
                    let params =
                        ["candId":UserDefaults.standard.object(forKey: "cID") as! String]  as [String : Any]
                    print(params)
                    ServerService.getA1FormData(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: getA1FormDataObject(response:))
                    
                }
                else
                {
                    ServerService.hideProgressView()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                    
                }
                
                func getA1FormDataObject(response:AnyObject)->() {

                    ServerService.hideProgressView()
                    var A1FormObject = response as! JSON
                    print(A1FormObject)
                    
                    if A1FormObject["LinkURL"] == nil {
                        print("***VIV the link count id \(A1FormObject["LinkURL"])")
                        print("***VIV the link count is \(String(describing: A1FormObject["LinkURL"].string?.count)) ***")
                    }
                    
                    else {
                        print("*** VIV A1 else clause Entered here***")
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let privacyViewController = mainStoryboard.instantiateViewController(withIdentifier: "pVC") as! PrivacyPolicyViewController
    //                    privacyViewController.link = "https://apps.tempositions.com/EWAAPITest/api/Forms/A1Series"
                        privacyViewController.link = A1FormObject["LinkURL"].string ?? ""
                        privacyViewController.headerText = A1FormObject["LinkName"].string ?? ""
                        Constants.iSFormOkRequired = false
                        privacyViewController.isPush = true
                        
                        let navi = BaseNaviViewController(rootViewController:privacyViewController)
                                        navi.navigationBar.tintColor = .white
                                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"A1FormController")
                    }
                    
      
                    
                }

            }
            else if identifier == Constants.A2Form {
                
                print("*********VIVEK Clicked A2 Form Here**********")
                
                //viv start
                
                if ConnectionCheck.isConnectedToNetwork()
                {
                    ServerService.showActivityIndicatory(uiView:self.view)
                    
                    let params =
                        ["candId":UserDefaults.standard.object(forKey: "cID") as! String]  as [String : Any]
                    print(params)
                    ServerService.getA2FormData(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: getA2FormDataObject(response:))
                    
                }
                else
                {
                    ServerService.hideProgressView()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                    
                }
                
                func getA2FormDataObject(response:AnyObject)->() {

                    ServerService.hideProgressView()
                    var A2FormObject = response as! JSON
                    print(A2FormObject)
                    
                    
                    if A2FormObject["LinkURL"] == nil {
                        print("***VIV the link count id \(A2FormObject["LinkURL"])")
                        print("***VIV the link count is \(String(describing: A2FormObject["LinkURL"].string?.count)) ***")
                    }
                    
                    else {
                        print("*** VIV A2 else clause Entered here***")
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let privacyViewController = mainStoryboard.instantiateViewController(withIdentifier: "pVC") as! PrivacyPolicyViewController
    //                    privacyViewController.link = "https://apps.tempositions.com/EWAAPITest/api/Forms/A1Series"
                        privacyViewController.link = A2FormObject["LinkURL"].string ?? ""
                        privacyViewController.headerText = A2FormObject["LinkName"].string ?? ""
                        Constants.iSFormOkRequired = false
                        privacyViewController.isPush = true
                        
                        let navi = BaseNaviViewController(rootViewController:privacyViewController)
                                        navi.navigationBar.tintColor = .white
                                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"A2FormController")
                    }
 
                    
                }
                
            }
            
            else if identifier == Constants.A3Form {
                
                print("*********A3 Form clicked VIVEK*********/n")
                
                //viv start
                
                if ConnectionCheck.isConnectedToNetwork()
                {
                    ServerService.showActivityIndicatory(uiView:self.view)
                    
                    let params =
                        ["candId":UserDefaults.standard.object(forKey: "cID") as! String]  as [String : Any]
                    print(params)
                    ServerService.getA3FormData(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: getA3FormDataObject(response:))
                    
                }
                else
                {
                    ServerService.hideProgressView()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                    
                }
                
                func getA3FormDataObject(response:AnyObject)->() {

                    ServerService.hideProgressView()
                    var A3FormObject = response as! JSON
                    print(A3FormObject)
                    
                    if A3FormObject["LinkURL"] == nil {
                        print("***VIV the link count id \(A3FormObject["LinkURL"])")
                        print("***VIV the link count is \(String(describing: A3FormObject["LinkURL"].string?.count)) ***")
                    }
                    
                    else {
                        print("*** VIV A3 else clause Entered here***")
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let privacyViewController = mainStoryboard.instantiateViewController(withIdentifier: "pVC") as! PrivacyPolicyViewController
    //                    privacyViewController.link = "https://apps.tempositions.com/EWAAPITest/api/Forms/A1Series"
                        privacyViewController.link = A3FormObject["LinkURL"].string ?? ""
                        privacyViewController.headerText = A3FormObject["LinkName"].string ?? ""
                        Constants.iSFormOkRequired = false
                        privacyViewController.isPush = true
                        
                        let navi = BaseNaviViewController(rootViewController:privacyViewController)
                                        navi.navigationBar.tintColor = .white
                                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"A1FormController")
                    }
                    
                }

            }
            
            else if identifier == Constants.PoliciesAndProcedures {
                
                print("*********PoliciesAndProcedures clicked VIVEK*********")
                
                //viv start
                
                if ConnectionCheck.isConnectedToNetwork()
                {
                    ServerService.showActivityIndicatory(uiView:self.view)
                    
                    let params =
                        ["candId":UserDefaults.standard.object(forKey: "cID") as! String]  as [String : Any]
                    print(params)
                    ServerService.getFormsPoliciesAndProcedures(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: getFormsPoliciesAndProceduresObject(response:))
                    
                }
                else
                {
                    ServerService.hideProgressView()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                    
                }
                
                func getFormsPoliciesAndProceduresObject(response:AnyObject)->() {

                    ServerService.hideProgressView()
                    var FormsPoliciesAndProceduresObject = response as! JSON
                    print(FormsPoliciesAndProceduresObject)
                    
                    if FormsPoliciesAndProceduresObject["LinkURL"] == nil {
                        print("***VIV the link count id \(FormsPoliciesAndProceduresObject["LinkURL"])")
                        print("***VIV the link count is \(String(describing: FormsPoliciesAndProceduresObject["LinkURL"].string?.count)) ***")
                    }
                    
                    else {
                        print("*** VIV FormsPoliciesAndProceduresObject else clause Entered here***")
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let privacyViewController = mainStoryboard.instantiateViewController(withIdentifier: "pVC") as! PrivacyPolicyViewController
    //                    privacyViewController.link = "https://apps.tempositions.com/EWAAPITest/api/Forms/A1Series"
                        privacyViewController.link = FormsPoliciesAndProceduresObject["LinkURL"].string ?? ""
                        privacyViewController.headerText = FormsPoliciesAndProceduresObject["LinkName"].string ?? ""
                        Constants.iSFormOkRequired = false
                        privacyViewController.isPush = true
                        
                        let navi = BaseNaviViewController(rootViewController:privacyViewController)
                                        navi.navigationBar.tintColor = .white
                                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"PoliciesAndProcedures")
                        
                    }
                    
  
                }

            }
            
            else if identifier == Constants.DisclosureConsentForm {
                
                print("*********Disclosure Form clicked VIVEK*********")
                
                //viv start
                
                if ConnectionCheck.isConnectedToNetwork()
                {
                    ServerService.showActivityIndicatory(uiView:self.view)
                    
                    let params =
                        ["candId":UserDefaults.standard.object(forKey: "cID") as! String]  as [String : Any]
                    print(params)
                    ServerService.getFormsDisclosureContent(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: getFormsDisclosureContentObject(response:))
                    
                }
                else
                {
                    ServerService.hideProgressView()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                    
                }
                
                func getFormsDisclosureContentObject(response:AnyObject)->() {

                    ServerService.hideProgressView()
                    var FormsDisclosureContentObject = response as! JSON
                    print(FormsDisclosureContentObject)
                    
                    if FormsDisclosureContentObject["LinkURL"] == nil {
                        print("***VIV the link count id \(FormsDisclosureContentObject["LinkURL"])")
                        print("***VIV the link count is \(String(describing: FormsDisclosureContentObject["LinkURL"].string?.count)) ***")
                    }
                    
                    else {
                        print("*** VIV FormsDisclosureContentObject else clause Entered here***")
                        
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let privacyViewController = mainStoryboard.instantiateViewController(withIdentifier: "pVC") as! PrivacyPolicyViewController
    //                    privacyViewController.link = "https://apps.tempositions.com/EWAAPITest/api/Forms/A1Series"
                        privacyViewController.link = FormsDisclosureContentObject["LinkURL"].string ?? ""
                        privacyViewController.headerText = FormsDisclosureContentObject["LinkName"].string ?? ""
                        Constants.iSFormOkRequired = false
                        privacyViewController.isPush = true
                        
                        let navi = BaseNaviViewController(rootViewController:privacyViewController)
                                        navi.navigationBar.tintColor = .white
                                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"DisclosureForm")
                    }
                    
              
                    
                }

            }
            
            else if identifier == Constants.OCCConfidentiality {
                
                print("*********OCCConfidentiality clicked VIVEK*********")
                
                //viv start
                
                if ConnectionCheck.isConnectedToNetwork()
                {
                    ServerService.showActivityIndicatory(uiView:self.view)
                    
                    let params =
                        ["candId":UserDefaults.standard.object(forKey: "cID") as! String]  as [String : Any]
                    print(params)
                    ServerService.getFormsOCCConfidentiality(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: getFormsOCCConfidentialityObject(response:))
                    
                }
                else
                {
                    ServerService.hideProgressView()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                    
                }
                
                func getFormsOCCConfidentialityObject(response:AnyObject)->() {

                    ServerService.hideProgressView()
                    var FormsOCCConfidentialityObject = response as! JSON
                    print(FormsOCCConfidentialityObject)
                    
                    if FormsOCCConfidentialityObject["LinkURL"] == nil {
                        print("***VIV the link count id \(FormsOCCConfidentialityObject["LinkURL"])")
                        print("***VIV the link count is \(String(describing: FormsOCCConfidentialityObject["LinkURL"].string?.count)) ***")
                    }
                    
                    else {
                        
                        print("*** VIV FormsOCCConfidentialityObject else clause Entered here***")
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let privacyViewController = mainStoryboard.instantiateViewController(withIdentifier: "pVC") as! PrivacyPolicyViewController
    //                    privacyViewController.link = "https://apps.tempositions.com/EWAAPITest/api/Forms/A1Series"
                        privacyViewController.link = FormsOCCConfidentialityObject["LinkURL"].string ?? ""
                        privacyViewController.headerText = FormsOCCConfidentialityObject["LinkName"].string ?? ""
                        Constants.iSFormOkRequired = false
                        privacyViewController.isPush = true
                        
                        let navi = BaseNaviViewController(rootViewController:privacyViewController)
                                        navi.navigationBar.tintColor = .white
                                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"OCCConfidentialityForm")
                    }
                    

                    
                }

            }
            
            else if identifier == Constants.SCRName {
                
                //viv stars here
                
                print("***VIVEK SCRConsentInfoController Clicked From SideMenuBar***")
                
                if ConnectionCheck.isConnectedToNetwork()
                {
                    ServerService.showActivityIndicatory(uiView:self.view)
                    
                    let params =
                        ["CandId" : UserDefaults.standard.object(forKey: "cID") as! String]  as [String : Any]
                    print(params)
                    ServerService.GetSCRForm(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: getSCRDataObject(response:))
                }
                else
                {
                    ServerService.hideProgressView()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                    
                }
                
                // response from the server
                func getSCRDataObject(response:AnyObject)->()
                {
                    ServerService.hideProgressView()
                    var SCRInfoObject = response as! JSON
                    print("****** SCR Info Data from Side Menu Bar is ************\n",SCRInfoObject)
                    
                    if SCRInfoObject["LinkURL"] == nil {
                        print("***VIV the link count id \(SCRInfoObject["LinkURL"])")
                        print("***VIV the link count is \(String(describing: SCRInfoObject["LinkURL"].string?.count)) ***")
                    }
                    
                    else {
                        print("*** VIV SCRInfoObject of SCRName else clause Entered here***")
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let privacyViewController = mainStoryboard.instantiateViewController(withIdentifier: "pVC") as! PrivacyPolicyViewController
                        privacyViewController.link = SCRInfoObject["LinkURL"].string ?? ""
                        privacyViewController.headerText = SCRInfoObject["ScrFormName"].string ?? ""
                        Constants.iSFormOkRequired = false
                        privacyViewController.isPush = true
                        
                        let navi = BaseNaviViewController(rootViewController:privacyViewController)
                                        navi.navigationBar.tintColor = .white
                                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"SCR Consent")
                        
                    }

 
                    
                }
                
                //viv ends
                
//                let VC = SCRConsentInfoController(nibName: "SCRConsentInfoController", bundle: nil)
//                let object = JSON(["FormName":identifier])
//                VC.object = object
//                VC.fromSideMenu = true
//                let navi = BaseNaviViewController(rootViewController:VC)
//                navi.navigationBar.tintColor = .white
//                navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
//                sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"SCRConsentInfoController")
            }
            
            else if identifier == Constants.SCRConsent {
                
                if ConnectionCheck.isConnectedToNetwork()
                {
                    ServerService.showActivityIndicatory(uiView:self.view)
                    
                    print("***VIV SCRConsent Clicked From Side Menu Bar***")
                    
                    let params =
                    ["CandId" : UserDefaults.standard.object(forKey: "cID") as! String]  as [String : Any]
                    print(params)
                    ServerService.GetSCRConsentForm(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: getSCRDataObject(response:))
                }
                else
                {
                    ServerService.hideProgressView()
                    ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
                    
                }
                
                
                // response from the server
                func getSCRDataObject(response:AnyObject)->()
                {
                    
                    ServerService.hideProgressView()
                    var SCRInfoObject = response as! JSON
                    print("****** SCR Info Data from Side Menu Bar is ************\n",SCRInfoObject)
                    
                    if SCRInfoObject["LinkURL"] == nil {
                        print("***VIV the link count id \(SCRInfoObject["LinkURL"])")
                        print("***VIV the link count is \(String(describing: SCRInfoObject["LinkURL"].string?.count)) ***")
                    }
                    
                    else {
                        print("*** VIV SCRInfoObject SCRConsent else clause Entered here***")
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let privacyViewController = mainStoryboard.instantiateViewController(withIdentifier: "pVC") as! PrivacyPolicyViewController
                        privacyViewController.link = SCRInfoObject["LinkURL"].string ?? ""
                        privacyViewController.headerText = SCRInfoObject["ScrFormName"].string ?? ""
                        Constants.iSFormOkRequired = false
                        privacyViewController.isPush = true
                        
                        let navi = BaseNaviViewController(rootViewController:privacyViewController)
                        navi.navigationBar.tintColor = .white
                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:"SCR Consent Form")
                        
                    }
                    

                }
            }
            
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateVC(withIdentifier: identifier) {
                let navi = BaseNaviViewController(rootViewController:viewController)
                navi.navigationBar.tintColor = .white
                navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                sideMenuController?.embed(centerViewController:navi, cacheIdentifier:identifier)
            }
            else {
                
                // ServerService.ShowAlertMessage(ErrorMessage: "No controller Available", title: "Oops . . . !", view: self)
            }
        }
    }
    
}

class HeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet var icon: UIImageView!
}

extension UIStoryboard {
    func instantiateVC(withIdentifier identifier: String) -> UIViewController? {
        // "identifierToNibNameMap" – dont change it. It is a key for searching IDs
        if let identifiersList = self.value(forKey: "identifierToNibNameMap") as? [String: Any] {
            if identifiersList[identifier] != nil {
                return self.instantiateViewController(withIdentifier: identifier)
            }
        }
        return nil
    }
}

