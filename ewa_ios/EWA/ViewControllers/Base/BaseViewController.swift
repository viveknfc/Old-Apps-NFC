//
//  BaseViewController.swift
//  EWA
//
//  Created by NFC India on 28/09/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON
import CropViewController

class BaseViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate {
    
    
    var picUploadData:JSON = JSON.null
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    var imagePicker = UIImagePickerController()
    var containerView: UIView = UIView()
    var actInd=UIActivityIndicatorView()
    
    var alertController = UIAlertController()
    
    let info_Text = "Info"
    let Warning_Text = "Warning"
    let Success_Text = "Success"
    let Danger_Text = "Danger"
    
    let success_Color = "#3c763d"
    let success_background_Color = "#dff0d8"
    let success_border_Color = "#d6e9c6"
    
    let info_Color = "#31708f"
    let info_background_Color = "#d9edf7"
    let info_border_Color = "#bce8f1"
    
    let warning_Color = "#8a6d3b"
    let warning_background_Color = "#fcf8e3"
    let warning_border_Color = "#faebcc"
    
    let danger_Color = "#a94442"
    let danger_background_Color = "#f2dede"
    let danger_border_Color = "#ebccd1"
    
    let greenColor = UIColor.init(red: 92/255, green: 184/255, blue: 92/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightNavMeaasge = UIBarButtonItem(image: UIImage(named: "message"), style: .plain, target: self, action: #selector(viewMessageAction))
        
        let rightNavUser =  UIBarButtonItem(image: UIImage(named: "user"), style: .plain, target: self, action: #selector(NavgationBarButtonTap))
        if UserDefaults.standard.object(forKey:"color") != nil
        {
            self.updateNavigationBarColor()
            
        }
        
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        if #available(iOS 11.0, *) {
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        if UserDefaults.standard.object(forKey:"token") != nil
        {
            //getting the employee type 1 for permanent employee
            let employeeType  = UserDefaults.standard.object(forKey:"EmployeeType") as! Int
            if employeeType == 1
            {
                // if permanent employee adding only user button
                self.navigationItem.rightBarButtonItem = rightNavUser
            }
            else
            {
                // if for normal users showing both the buttons
                self.navigationItem.rightBarButtonItems = [rightNavUser,rightNavMeaasge]
            }
            
        }
        else
        {
            // if not logged user hiding all the buttons
            self.navigationController?.navigationItem.rightBarButtonItems = nil
        }
        
        
    }
    
    
    //view messages action
    @objc func viewMessageAction(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"message") as? MessagesViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    //user dropDown Action
    @objc func NavgationBarButtonTap(_ sender: UIBarButtonItem, event: UIEvent)
    {
        showUp(event: event)
    }
    
    
    func showUp(event: UIEvent)
    {
        let config = FTConfiguration.shared
        config.textColor = UIColor.black
        config.backgoundTintColor = UIColor.white
        config.borderColor = UIColor.lightGray
        config.menuWidth = 200
        config.menuSeparatorColor = UIColor.lightGray
        config.textAlignment = .left
        config.textFont = UIFont.systemFont(ofSize: 14)
        config.menuRowHeight = 40
        config.cornerRadius = 6
        config.menuSeparatorInset = UIEdgeInsetsMake(0,0,0,0)
        FTPopOverMenu.showForEvent(event: event, with:Constants.menuOptionNameArray, done: { (selectedIndex) -> () in
            print(selectedIndex)
            if selectedIndex == 1 {
                //getting the employee type 1 for permanent employee
                let employeeType  = UserDefaults.standard.object(forKey:"EmployeeType") as! Int
                if employeeType == 1
                {
                    Constants.menuHeaders.removeAll()
                    Constants.menuSectionLogos.removeAll()
                    Constants.menuSections.removeAll()
                    Constants.titleImages.removeAll()
                    Constants.menuObjj.removeAll()
                    Constants.dashObject = JSON.null
                    TimeOutClass.sharedInstance.resetTimer()
                    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                    (UIApplication.shared.delegate as? AppDelegate)?.APSlocation_Set_up()
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ewaLogin") as! LoginViewController
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                }
                else {
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"Change Password") as? ChangePasswordViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
                
            }
            else if selectedIndex == 3
            {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let privacyViewController = mainStoryboard.instantiateViewController(withIdentifier: "pVC") as! PrivacyPolicyViewController
                privacyViewController.link = "https://apps.tempositions.com/TempositionsEWAAPI/Forms/PrivacyPolicy.pdf"
                privacyViewController.headerText = "Privacy Policy"
                Constants.iSFormOkRequired = false
                privacyViewController.isPush = true
                self.navigationController?.pushViewController(privacyViewController, animated: true)
                
            }
            
            else if selectedIndex == 4
            {
                Constants.menuHeaders.removeAll()
                Constants.menuSectionLogos.removeAll()
                Constants.menuSections.removeAll()
                Constants.titleImages.removeAll()
                Constants.menuObjj.removeAll()
                Constants.dashObject = JSON.null
                TimeOutClass.sharedInstance.resetTimer()
                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                let defaults = UserDefaults.standard
                let dictionary = defaults.dictionaryRepresentation()
                dictionary.keys.forEach { key in
                    defaults.removeObject(forKey: key)
                }
                (UIApplication.shared.delegate as? AppDelegate)?.APSlocation_Set_up()
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ewaLogin") as! LoginViewController
                UIApplication.shared.keyWindow?.rootViewController = viewController
                
            }
            else if selectedIndex == 2
            {
                let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                    self.openCamera(viewController:self)
                }))
                
                alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                    self.openGallary(viewController:self)
                }))
                
                alert.addAction(UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        },cancel: {
            
        })
    }
    
    
    func openCamera(viewController:UIViewController)
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            imagePicker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            viewController.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func openGallary(viewController:UIViewController)
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        viewController.present(imagePicker, animated: true, completion: nil)
        
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
            ServerService.showActivityIndicatory(uiView:self.view)
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
        ServerService.hideProgressView()
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
    
    
    //activity indicator method
    func showActivityIndicatoryInSelf(uiView: UIView) {
        
        
        containerView.frame = uiView.frame
        containerView.center = uiView.center
        containerView.backgroundColor = UIColor.uicolorFromHex(0xffffff, alpha: 0.1)
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor.black
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        loadingView.tag = 1001
        
        //let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.activityIndicatorViewStyle =
        UIActivityIndicatorView.Style.whiteLarge
        actInd.center = CGPoint(x: loadingView.frame.size.width/2, y: loadingView.frame.size.height/2);
        loadingView.addSubview(actInd)
        containerView.addSubview(loadingView)
        //        let window = UIApplication.shared.keyWindow!
        //        window.addSubview(loadingView)
        //        window.bringSubviewToFront(loadingView)
        uiView.addSubview(containerView)
        actInd.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    //removing the activity indicator
    func hideProgressView() {
        ServerService.myIndicator.stopAnimating()
        ServerService.myIndicator.stopAnimating()
        containerView.removeFromSuperview()
        let window = UIApplication.shared.keyWindow!
        window.viewWithTag(1001)?.removeFromSuperview()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
}

extension UIViewController {
    func updateNavigationBarColor() {
        if #available(iOS 13.0, *) {
           /* let barBackgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = barBackgroundColor
            appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            */
            let barAppearance = UINavigationBarAppearance()
            barAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

    barAppearance.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
    UINavigationBar.appearance().tintColor = UIColor.white
    UINavigationBar.appearance().standardAppearance = barAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = barAppearance

        }
        else {
            self.navigationController?.navigationBar.barTintColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        }
    }
}
