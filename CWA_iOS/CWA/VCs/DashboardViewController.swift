//
//  DashboardViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 01/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
///260542/

import UIKit
import SwiftyJSON
import SDWebImage
import WebKit

class DashboardViewController: BaseViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegateFlowLayout {
    
    
    let Privacy_Policy_Menu_Id = 56
    let E_Register_Menu_Id = 20
    // let Client_Invoice_Menu_Id = 9
    let Division_Menu_Id = 2
    let Historic_Order_Menu_Id = 17
    let ROS_DOE_Menu_Id = 18
    let Order_List_Menu_Id = 50
    let Active_Orders_Menu_Id = 45
    let Weekly_Staffing_Schedule_Menu_Id = 55
    let ROS_Menu_Id = 21
    let SCR_Menu_Id = 58
    let eTimeClock_Menu_Id = 40
    let SafetyGuidlines_Id = 60
    let ClientLocationScreen_Id = "22"
    
    
    let Orders_Parent_Menu_Id = "3"
    let Time_Slip_Parent_Menu_Id = "6"
    let Reports_Parent_Menu_Id = "10"
    let Client_Invoice_Parent_Menu_Id = "9"
    let EUA_Parent_Menu_Id = "11"
    let SCR_Parent_Menu_Id = "19"
    
    let side_table_tag = 1001
    let main_table_tag = 1002
    var isClient = -1
    var ClientName = ""
    var WeeklyStaffing = ""
    var isFromDivisionPage = false
    var SelectedMenuID = -1
    var SelectedMenuName = ""
    var isFromSafetey = false
    
    let today = Date() // for e-checkin date
    var actionURL = ""
    
    @IBOutlet weak var formNameLabel: UILabel!
    @IBOutlet var formPopUpView: UIView!
    @IBOutlet weak var formWebView: WKWebView!
    
    
    @IBOutlet weak var formOKButton: UIButton!
    
    
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var menuColView: UICollectionView!
    @IBOutlet weak var divLogoImageView : UIImageView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    @IBOutlet weak var logoImageView: UIView!
    
    let colCellIdentifier = "MenuCollectionViewCellIdentifier"
    var logoImage = UIImage()
    @IBOutlet weak var sideMenuTableView: UITableView!
    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var sideMenuTblBgView: UIView!
    @IBOutlet weak var sideMenuTblBaseView: UIView!
    @IBOutlet weak var headerImageView : UIImageView!
    @IBOutlet weak var lblUserName : UILabel!
    
    @IBOutlet weak var versionLbl : UILabel!
    @IBOutlet weak var sideMenuTblBaseViewTrailingConstraint: NSLayoutConstraint!
    
    var menuArray = NSMutableArray()
    var menuColArray = NSMutableArray()
    var selectedDivisionContactID = 0
    let window = UIApplication.shared.keyWindow
    
    let menuHeaderList = NSMutableArray()
    let OrderList = NSMutableArray()
    let ReportList = NSMutableArray()
    let TimeSlipList = NSMutableArray()
    let ClientInvoiceList = NSMutableArray()
    let EUAList = NSMutableArray()
    let SCRList = NSMutableArray()
    let ClientLoc = NSMutableArray()
    
    @IBOutlet weak var pendingTimeSlipTableView: UITableView!
    
    @objc override func appWillEnterForeground(){
        print("appWillEnterForeground Division")
        if menuArray.count == 0{
            self.getMenuListCall()
        }
        
    }
    func getReasonForException(){
        if let exception = UserDefaults.standard.object(forKey: "ExceptionHandler") as? [String] {
            
            print("Error was occured on previous session! \n", exception, "\n\n-------------------------")
            var exceptions = ""
            for e in exception {
                exceptions = exceptions + e + "\n"
            }
            print("Exception",exceptions)
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        CMALocationManager.shared.requestLocationAtOnce()
        
        //        self.title = "Dashboard"
        refreshButton.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        // Do any additional setup after loading the view.
        let menuButton = UIBarButtonItem.init(customView: self.sideMenuButton())
        self.navigationItem.leftBarButtonItem = menuButton
        self.updateHeaderViewForLogo()
        window?.addSubview(sideMenuView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.sideMenuTapGesture))
        tap.delegate = self
        sideMenuView.addGestureRecognizer(tap)
        sideMenuView.isHidden = true
        sideMenuTableView.tableFooterView = UIView()
        menuTableView.tableFooterView = UIView()
        sideMenuView.frame = UIScreen.main.bounds
        //        if let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
        //            versionLbl.text =  "v."+version
        //        }
        versionLbl.text = "v.\(RestAPI.displayVersion)"
        self.updateCollectionViewCellSize()
        self.getMenuListCall()
        
        if menuHeaderList.count == 0{
            
            let sViews =  self.navigationController?.view.subviews
            for v in sViews!{
                if v.tag == Division_View_TAG{
                    v.removeFromSuperview()
                }
            }
        }else{
            self.addDivisionNameOnTop()
        }
        
        
    }
    //MARK:- LoadAlertPopView
    func loadAlertPopupWithObject(_ viewStatus: Int, messageText: String, popKeyToSend: String, apiCallrequired: Bool)
    {
        let window = UIApplication.shared.keyWindow!
        
        let formView = Bundle.main.loadNibNamed("AlertPopView", owner: nil, options: nil)![0] as! AlertPopView
        
        formView.frame = CGRect(x:0,y:0, width: window.bounds.width, height:window.bounds.height)
        formView.viewStatus = viewStatus
        formView.popKeyToSend = popKeyToSend
        formView.messageText = messageText
        formView.loadForm()
        formView.toCOntroller = self
        formView.popAlertDashDelegate = self
        formView.apiCallrequired = apiCallrequired
        
        window.addSubview(formView)
        window.bringSubviewToFront(formView)
    }
    
    func updateHeaderViewForLogo(){
        let UserName = UserDefaults.standard.string(forKey: "CandName")
        
        self.sideMenuTableView.reloadData()
        self.menuTableView.reloadData()
        
        if UserDefaults.standard.string(forKey: "ColorCode") != nil {
            
            //   self.navigationController?.navigationBar.barTintColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
            if #available(iOS 13.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithDefaultBackground()
                appearance.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
                navigationController?.navigationBar.prefersLargeTitles = false
                navigationController?.navigationBar.standardAppearance = appearance
                navigationController?.navigationBar.scrollEdgeAppearance = appearance
            }
            else {
                // Fallback on earlier versions
                self.navigationController?.navigationBar.barTintColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
            }
        }
        
        spinnerView.startAnimating()
        spinnerView.hidesWhenStopped = true
        self.divLogoImageView.isHidden = true
        lblUserName.text = UserName
        headerImageView.image = nil
        headerImageView.isHidden = true
        if UserDefaults.standard.object(forKey:"LogoPath") == nil{
            headerImageView.image = UIImage.init(named: "ImagePlaceholder")
            divLogoImageView.image = UIImage.init(named: "ImagePlaceholder")
        }else{
            
            let imageURLString = UserDefaults.standard.object(forKey:"LogoPath")as! String
            
            let imageURL = URL(string:imageURLString)
            //
         //   headerImageView.sd_setShowActivityIndicatorView(true)
           // headerImageView.sd_setIndicatorStyle(.gray)
            
            headerImageView.sd_setImage(with: imageURL, placeholderImage: UIImage.init(named: "ImagePlaceholder"), options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                if image != nil {
                    self.headerImageView.isHidden = false
                    self.divLogoImageView.isHidden = false
                    
                    self.logoImage = image!
                    self.divLogoImageView.image = image
                    self.menuColView.reloadData()
                    self.spinnerView.stopAnimating()
                }
                
            })
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //  self.titlelbl.text = "Dashboard"
        self.changeNavigationTitle("Dashboard")
        
        sessionIdAPICall() //viv for session id
        
        self.updateHeaderViewForLogo()
        print(ClientName)
        if isFromDivisionPage == true{
            
            self.getMenuListCall()
            
        }
        if menuHeaderList.count == 0{
            
            let defaults = UserDefaults.standard
            let sViews =  self.navigationController?.view.subviews
            //            let msg  =  defaults.string(forKey: "DivisionName")
            for v in sViews!{
                if v.tag == Division_View_TAG{
                    v.removeFromSuperview()
                }
            }
        }else{
            //            self.addDivisionNameOnTop()
        }
        
        DateManager.shared.selectedDate = today // for e-checkin today's date
        
    }
    func changeNavigationTitle(_ titleStr: String) {
        let tlabel = UILabel()
        tlabel.text = titleStr
        tlabel.textColor = UIColor.white
        tlabel.font = UIFont.systemFont(ofSize:17)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.textAlignment = .left
        tlabel.numberOfLines = 0
        tlabel.minimumScaleFactor = 0.5
        self.navigationItem.titleView = tlabel
    }
    func updateCollectionViewCellSize() {
        let screenWidth  = UIScreen.main.bounds.size.width
        
        //        return CGSize(width:screenWidth/2 - 5 , height: 150)
        
        let cellWidth : CGFloat = screenWidth/2 - 5
        var cellheight : CGFloat = CGFloat(150)
        let modelName = UIDevice.current.modelName
        if modelName.contains("iPad") {
            cellheight = CGFloat(200)
        }
        let cellSize = CGSize(width: cellWidth , height:cellheight)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        menuColView.setCollectionViewLayout(layout, animated: true)
        
        
    }
    @objc func showSideMenu()
    {
        self.showSideMenuOverlayView(willHide: false)
    }
    
    func sideMenuButton() -> UIButton {
        let bBtn = UIButton()
        
        bBtn.frame = CGRect(x:0,y:0,width: 40,height:40)
        bBtn.setImage(UIImage.init(named: "Menu"),for:.normal)
        
        bBtn.addTarget(self, action:#selector(self.showSideMenu), for: .touchUpInside)
        
        return bBtn
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if (touch.view?.isDescendant(of: sideMenuTableView))! || (touch.view?.isDescendant(of:  menuTableView))! {
            return false
        }
        return true
        
    }
    
    func clearDOEData(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "PositionTitle")
        defaults.removeObject(forKey: "PositionDescription")
        defaults.removeObject(forKey: "LocationCode")
        defaults.removeObject(forKey: "Location")
        
        defaults.removeObject(forKey: "DoeApplicantModel")
        
        defaults.removeObject(forKey: "DoeScheduleModel")
        
        defaults.removeObject(forKey: "ApproveTimeslip")
        defaults.removeObject(forKey: "AltApproveTimeslip")
        defaults.removeObject(forKey: "TsApproverSupervisor")
        defaults.removeObject(forKey: "PersonToReport")
        defaults.removeObject(forKey: "CertifyHours")
        
        defaults.removeObject(forKey: "DoePayrateModel")
        
        defaults.removeObject(forKey: "DoePayrateScheduleModel")
        
        defaults.removeObject(forKey: "DoeWaiverModel")
        defaults.synchronize()
        
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("PushToDOESchdulePageFromDetails"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("PushToDOEReferConsultantPageFromDetails"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("PushToDOEOrderPageFromDetails"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("PushToDOEPayratePageFromDetails"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("PushToWaiverPageFromDetails"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("PushToDOELocationPageFromDetails"), object: nil)
    }
    func showSideMenuOverlayView(willHide: Bool) {
        
        let screenWidth = UIScreen.main.bounds.size.width
        
        if willHide {
            self.sideMenuView.isHidden = true
            self.sideMenuTblBgView.isHidden = true
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
                self.sideMenuTblBaseViewTrailingConstraint.constant = -screenWidth
            }, completion: { (finished: Bool) in
                
            })
        }else{
            self.sideMenuView.isHidden = false
            self.sideMenuTableView.reloadData()
            self.sideMenuTblBgView.isHidden = false
            //            if self.isPortrait() == false{
            self.sideMenuView.frame = UIScreen.main.bounds
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
                
                if self.isPortrait(){
                    self.sideMenuTblBaseViewTrailingConstraint.constant = 58
                }else{
                    self.sideMenuTblBaseViewTrailingConstraint.constant = 250
                }
            }, completion: { (finished: Bool) in
            })
        }
        self.sideMenuTblBaseView.layoutIfNeeded()
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK:-  TABLEVIEW DATA SOURCE METHOD
    public func numberOfSections(in tableView: UITableView) -> Int{
        return menuHeaderList.count
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView.tag == side_table_tag{
           if menuHeaderList[section] is NSMutableDictionary{
                
                let dataDict:NSMutableDictionary = menuHeaderList[section] as! NSMutableDictionary
                if dataDict.allKeys.count == 0{}else{
                    
                    let parentID = dataDict["ParentMenuId"] as! String
                    let isExpanded =   dataDict["Expanded"] as! String
                    
                    if parentID == Orders_Parent_Menu_Id{
                        if isExpanded == "1"{
                            return OrderList.count
                        }
                    }else if  parentID == Time_Slip_Parent_Menu_Id{
                        if isExpanded == "1"{
                            return TimeSlipList.count
                        }
                    }else if  parentID == Reports_Parent_Menu_Id{
                        if isExpanded == "1"{
                            return ReportList.count
                        }
                    }else if  parentID == Client_Invoice_Parent_Menu_Id{
                        if isExpanded == "1"{
                            return ClientInvoiceList.count
                        }
                    }else if  parentID == EUA_Parent_Menu_Id{
                        if isExpanded == "1"{
                            return EUAList.count
                        }
                    }else if  parentID == SCR_Parent_Menu_Id{
                        if isExpanded == "1"{
                            return SCRList.count
                        }
                    }
                    else if parentID == ClientLocationScreen_Id {
                        if isExpanded == "1"{
                            return ClientLoc.count
                        }
                    }
                }
            }else{
                return 1
            }
            
        }else if tableView.tag == main_table_tag{
            let dataDict:NSMutableDictionary = menuHeaderList[section] as! NSMutableDictionary
            if dataDict.allKeys.count == 0{}else{
                
                let parentID = dataDict["ParentMenuId"] as! String
                let isExpanded =   dataDict["Expanded"] as! String
                
                if parentID == Orders_Parent_Menu_Id{
                    return OrderList.count
                }else if  parentID == Time_Slip_Parent_Menu_Id{
                    return TimeSlipList.count
                }else if  parentID == Reports_Parent_Menu_Id{
                    return ReportList.count
                }else if  parentID == Client_Invoice_Parent_Menu_Id{
                    return ClientInvoiceList.count
                }else if  parentID == EUA_Parent_Menu_Id{
                    return EUAList.count
                }else if  parentID == SCR_Parent_Menu_Id{
                    return SCRList.count
                }
                else if parentID == ClientLocationScreen_Id {
                    return ClientLoc.count
                }
            }
        }
        
        
        return 0
        
        
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if tableView.tag == side_table_tag || tableView.tag == main_table_tag{
            
            
            
            let cell:DefaultTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DefaultTableViewCellIdentifier") as! DefaultTableViewCell
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            cell.backgroundColor = UIColor.clear
            
            var cellText = ""
            var logoPath = ""
            if menuHeaderList.count > indexPath.section{
                
                let dataDict:NSMutableDictionary = menuHeaderList[indexPath.section] as! NSMutableDictionary
                if dataDict.allKeys.count == 0{}else{
                    
                    let parentID = dataDict["ParentMenuId"] as! String
                    print("viv the parent id is ", parentID)
                    
                    if parentID == Orders_Parent_Menu_Id{
                        let menuObj = OrderList[indexPath.row]
                        let  menuOb:Menu = menuObj as! Menu
                        
                        cellText = menuOb.LinkText!
                        logoPath = menuOb.logoPath!
                        
                    }else if  parentID == Time_Slip_Parent_Menu_Id{
                        let menuObj = TimeSlipList[indexPath.row]
                        let  menuOb:Menu = menuObj as! Menu
                        
                        cellText = menuOb.LinkText!
                        logoPath = menuOb.logoPath!
                        
                        
                    }else if  parentID == Reports_Parent_Menu_Id{
                        let menuObj = ReportList[indexPath.row]
                        let  menuOb:Menu = menuObj as! Menu
                        
                        cellText = menuOb.LinkText!
                        logoPath = menuOb.logoPath!
                        
                        
                    }else if  parentID == Client_Invoice_Parent_Menu_Id{
                        let menuObj = ClientInvoiceList[indexPath.row]
                        let  menuOb:Menu = menuObj as! Menu
                        
                        cellText = menuOb.LinkText!
                        logoPath = menuOb.logoPath!
                    }else if  parentID == EUA_Parent_Menu_Id{
                        let menuObj = EUAList[indexPath.row]
                        let  menuOb:Menu = menuObj as! Menu
                        
                        cellText = menuOb.LinkText!
                        logoPath = menuOb.logoPath!
                    }else if  parentID == SCR_Parent_Menu_Id{
                        let menuObj = SCRList[indexPath.row]
                        let  menuOb:Menu = menuObj as! Menu
                        
                        cellText = menuOb.LinkText!
                        logoPath = menuOb.logoPath!
                    }
                    else if  parentID == ClientLocationScreen_Id{
                        let menuObj = ClientLoc[indexPath.row]
                        let  menuOb:Menu = menuObj as! Menu
                        
                        cellText = menuOb.LinkText!
                        logoPath = menuOb.logoPath!
                    }
                }
            }
            
            cell.lblDataText?.text = cellText
            
            
            if tableView.tag == main_table_tag{
                self.addDropDownShadowToView(shadowView: cell.bgView)
                cell.cellImageView.isHidden = false
                let imageURL =   URL(string:logoPath)
                
                cell.cellImageView.sd_setImage(with: imageURL, placeholderImage: UIImage.init(named: "ImagePlaceholder"), options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                    
                })
            }else{
                cell.cellImageView.isHidden = true
            }
            return cell
        }
        
        
        let cell:PendingTimeSlipTableViewCell = pendingTimeSlipTableView.dequeueReusableCell(withIdentifier: "PendingTimeSlipCellIdentifier") as! PendingTimeSlipTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.viewEditButton.addTarget(self, action:#selector(self.handleViewEditTimeslip), for: .touchUpInside)
        cell.approveButton.addTarget(self, action:#selector(self.handleApproveTimeslip), for: .touchUpInside)
        
        return cell
        
    }
    
    
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var MenuName = ""
        var MenuId = 0
        
        if menuHeaderList.count > indexPath.section{
            let dataDict:NSMutableDictionary = menuHeaderList[indexPath.section] as! NSMutableDictionary
            if dataDict.allKeys.count == 0{}else{
                
                let parentID = dataDict["ParentMenuId"] as! String
                let isExpanded =   dataDict["Expanded"] as! String
                
                if parentID == Orders_Parent_Menu_Id{
                    if isExpanded == "1"{
                        let menuObj = OrderList[indexPath.row]
                        
                        let  menuOb:Menu = menuObj as! Menu
                        
                        MenuName = menuOb.LinkText!
                        MenuId =  menuOb.MenuId!
                        
                    }
                }else if  parentID == Time_Slip_Parent_Menu_Id{
                    if isExpanded == "1"{
                        let menuObj = TimeSlipList[indexPath.row]
                        
                        let  menuOb:Menu = menuObj as! Menu
                        
                        MenuName = menuOb.LinkText!
                        MenuId =  menuOb.MenuId!
                    }
                }else if  parentID == Reports_Parent_Menu_Id{
                    if isExpanded == "1"{
                        let menuObj = ReportList[indexPath.row]
                        
                        let  menuOb:Menu = menuObj as! Menu
                        
                        MenuName = menuOb.LinkText!
                        MenuId =  menuOb.MenuId!
                    }
                }else if  parentID == Client_Invoice_Parent_Menu_Id{
                    if isExpanded == "1"{
                        let menuObj = ClientInvoiceList[indexPath.row]
                        
                        let  menuOb:Menu = menuObj as! Menu
                        
                        MenuName = menuOb.LinkText!
                        MenuId =  menuOb.MenuId!
                    }
                }else if  parentID == EUA_Parent_Menu_Id{
                    if isExpanded == "1"{
                        let menuObj = EUAList[indexPath.row]
                        
                        let  menuOb:Menu = menuObj as! Menu
                        
                        MenuName = menuOb.LinkText!
                        MenuId =  menuOb.MenuId!
                    }
                }else if  parentID == SCR_Parent_Menu_Id{
                    if isExpanded == "1"{
                        let menuObj = SCRList[indexPath.row]
                        
                        let  menuOb:Menu = menuObj as! Menu
                        
                        MenuName = menuOb.LinkText!
                        MenuId =  menuOb.MenuId!
                    }
                }else if  parentID == ClientLocationScreen_Id{
                    if isExpanded == "1"{
                        let menuObj = ClientLoc[indexPath.row]
                        
                        let  menuOb:Menu = menuObj as! Menu
                        
                        MenuName = menuOb.LinkText!
                        MenuId =  menuOb.MenuId!
                    }
                }
            }
            
            
        }
        
        let message =  MenuName
        let screenSize = UIScreen.main.bounds.size
        if tableView.tag == main_table_tag{
            let height = message.heightWithConstrainedWidth(width: screenSize.width - 100, font: UIFont.boldSystemFont(ofSize: 18))
            
            if screenSize.width == 320  &&  message.count > 26{
                return max(75, height)
            }else if  message.count > 26{
                return max(75, height)
                
            }
        }
        //side tableview
        let height = message.heightWithConstrainedWidth(width: UIScreen.main.bounds.size.width - 153, font: UIFont.boldSystemFont(ofSize: 16))
        if screenSize.width == 320  &&  message.count > 26{
            return max(55, height)
        }
        return max(60, height)
        
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        //        if tableView.tag == side_table_tag {
        
        var MenuName = ""
        var MenuId = 0
        
        self.showSideMenuOverlayView(willHide: true)
        if menuHeaderList.count > indexPath.section{
            let dataDict:NSMutableDictionary = menuHeaderList[indexPath.section] as! NSMutableDictionary
            if dataDict.allKeys.count == 0{}else{
                
                let parentID = dataDict["ParentMenuId"] as! String
                let isExpanded =   dataDict["Expanded"] as! String
                
                if parentID == Orders_Parent_Menu_Id{
                    let menuObj = OrderList[indexPath.row]
                    
                    let  menuOb:Menu = menuObj as! Menu
                    
                    if menuOb.MenuId == 150 {
                        actionURL = menuOb.Action ?? ""
                    }
                    if tableView.tag == main_table_tag{
                        MenuName = menuOb.LinkText!
                        MenuId =  menuOb.MenuId!
                        
                        
                    }else{
                        if isExpanded == "1"{
                            MenuName = menuOb.LinkText!
                            MenuId =  menuOb.MenuId!
                            
                        }
                    }
                    
                }else if  parentID == Time_Slip_Parent_Menu_Id{
                    let menuObj = TimeSlipList[indexPath.row]
                    
                    let  menuOb:Menu = menuObj as! Menu
                    if tableView.tag == main_table_tag{
                        MenuName = menuOb.LinkText!
                        MenuId =  menuOb.MenuId!
                        
                    }else{
                        if isExpanded == "1"{
                            
                            MenuName = menuOb.LinkText!
                            MenuId =  menuOb.MenuId!
                        }
                    }
                }else if  parentID == Reports_Parent_Menu_Id{
                    let menuObj = ReportList[indexPath.row]
                    let  menuOb:Menu = menuObj as! Menu
                    if tableView.tag == main_table_tag{
                        MenuName = menuOb.LinkText!
                        MenuId =  menuOb.MenuId!
                    }else{
                        if isExpanded == "1"{
                            MenuName = menuOb.LinkText!
                            MenuId =  menuOb.MenuId!
                        }
                    }
                }else if  parentID == Client_Invoice_Parent_Menu_Id{
                    let menuObj = ClientInvoiceList[indexPath.row]
                    let  menuOb:Menu = menuObj as! Menu
                    if tableView.tag == main_table_tag{
                        MenuName = menuOb.LinkText!
                        MenuId =  menuOb.MenuId!
                    }else{
                        if isExpanded == "1"{
                            MenuName = menuOb.LinkText!
                            MenuId =  menuOb.MenuId!
                        }
                    }
                }else if  parentID == EUA_Parent_Menu_Id{
                    let menuObj = EUAList[indexPath.row]
                    let  menuOb:Menu = menuObj as! Menu
                    if tableView.tag == main_table_tag{
                        MenuName = menuOb.LinkText!
                        MenuId =  menuOb.MenuId!
                    }else{
                        if isExpanded == "1"{
                            MenuName = menuOb.LinkText!
                            MenuId =  menuOb.MenuId!
                        }
                    }
                }else if  parentID == SCR_Parent_Menu_Id{
                    let menuObj = SCRList[indexPath.row]
                    let  menuOb:Menu = menuObj as! Menu
                    if tableView.tag == main_table_tag{
                        MenuName = menuOb.LinkText!
                        MenuId =  menuOb.MenuId!
                    }else{
                        if isExpanded == "1"{
                            MenuName = menuOb.LinkText!
                            MenuId =  menuOb.MenuId!
                        }
                    }
                } else if  parentID == ClientLocationScreen_Id{
                    let menuObj = ClientLoc[indexPath.row]
                    let  menuOb:Menu = menuObj as! Menu
                    if tableView.tag == main_table_tag{
                        MenuName = menuOb.LinkText!
                        MenuId =  menuOb.MenuId!
                    }else{
                        if isExpanded == "1"{
                            MenuName = menuOb.LinkText!
                            MenuId =  menuOb.MenuId!
                        }
                    }
                }
                //
            }
            
            self.navigateToCorrespondingPage(MenuName:MenuName,MenuId: MenuId)
        }
        
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        print("the section is ",section)
       if menuHeaderList.count >  section{

            if menuHeaderList[section] is NSMutableDictionary{
                
                let dataDict:NSMutableDictionary = menuHeaderList[section] as! NSMutableDictionary
                if dataDict.allKeys.count == 0{
       
                }else{
                    
                    let parentID = dataDict["ParentMenuId"] as! String
                    
                    if tableView.tag == main_table_tag{
                        
                        if parentID == "0"{
                            
                            let MenuName = dataDict["Header"] as! String
                            
                            if MenuName == "Dashboard"{
                                return 0
                            }
                            return 70//for division
                        }else  if parentID == "18"{
                            
                            let MenuID = dataDict["MenuID"] as! String
                            
                            if MenuID == "56"{
                                return 0
                            }
                            return 70//for division
                        }
                        return 50
                    }else if tableView.tag == side_table_tag{
                        return 40
                        
                    }
                    if parentID == "18"{
                        return 70
                    }
                }
            }

        }
        
        return 40
        
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        if menuHeaderList.count > section{
            let dataDict:NSDictionary = menuHeaderList[section] as! NSDictionary
            let tapBtn = UIButton.init(frame: CGRect(x:0,y:0,width: tableView.frame.width ,height: 45))
            tapBtn.addTarget(self, action:#selector(self.headerBtnTapped), for: .touchUpInside)
            tapBtn.tag = section
            tapBtn.backgroundColor = UIColor.clear
            let mainHeaderView = UIView()
            
            if dataDict.allKeys.count == 0{}else{
                
                
                if tableView.tag == main_table_tag{
                    //.init(frame: CGRect(x:0,y:0,width: tableView.frame.width ,height: 60))
                    mainHeaderView.frame = CGRect(x:0,y:0,width: tableView.frame.width ,height: 60)
                    let whiteView  = UIView()
                    let textLabel = UILabel.init(frame: CGRect(x:5,y:5,width: tableView.frame.size.width - 25 ,height: 50))
                    textLabel.backgroundColor = UIColor.clear
                    textLabel.text = "  "+(dataDict["Header"] as? String)!
                    textLabel.font = UIFont.boldSystemFont(ofSize: 16)
                    mainHeaderView.backgroundColor = view.backgroundColor
                    
                    let parentID = dataDict["ParentMenuId"] as! String
                    let arrowImageView = UIImageView.init(frame: CGRect(x:tableView.frame.size.width - 55,y:20,width: 15 ,height: 15))
                    arrowImageView.contentMode = UIView.ContentMode.scaleAspectFit
                    arrowImageView.image = UIImage.init(named: "right_arrow.png")
                    
                    if parentID == "0" || parentID == "20"{
                        arrowImageView.isHidden = false
                        textLabel .frame = CGRect(x:30,y:5,width: tableView.frame.size.width - 35 ,height: 40)
                        textLabel.backgroundColor = UIColor.clear
                        
                        if dataDict["LogoPath"]  != nil{
                            let LogoPath = dataDict["LogoPath"] as! String
                            
                            if LogoPath.count == 0{
                                
                            }else{
                                //menu image
                                let imageView = UIImageView.init(frame: CGRect(x:5,y:10,width: 25 ,height: 25))
                                imageView.contentMode = UIView.ContentMode.scaleAspectFit
                                imageView.backgroundColor = UIColor.clear
                                let imageURL =   URL(string:LogoPath)
                                imageView.sd_setImage(with: imageURL, placeholderImage: UIImage.init(named: "ImagePlaceholder"), options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                                    
                                })
                                whiteView.addSubview(imageView)
                            }
                        }
                        whiteView.backgroundColor = UIColor.white
                        whiteView.frame = CGRect(x:20,y:5,width: UIScreen.main.bounds.size.width - 35 ,height: 50)
                        if self.isPortrait() == false{
                            whiteView.frame = CGRect(x:20,y:5,width: UIScreen.main.bounds.size.width - 35 ,height: 50)
                        }
                        self.addDropDownShadowToView(shadowView: whiteView)
                    }else{
                        mainHeaderView.backgroundColor = view.backgroundColor
                        whiteView.frame = CGRect(x:0,y:5,width: tableView.frame.size.width - 35 ,height: 50)
                        
                        whiteView.layer.shadowColor = UIColor.clear.cgColor
                        arrowImageView.isHidden = true
                        textLabel.backgroundColor = UIColor.clear
                    }
                    whiteView.addSubview(textLabel)
                    whiteView.addSubview(arrowImageView)
                    mainHeaderView.addSubview(whiteView)
                    mainHeaderView.addSubview(tapBtn)
                    return mainHeaderView
                }
            }
            
            
            
            if dataDict.allKeys.count == 0{}else{
                let headerView = UIView.init(frame: CGRect(x:0,y:0,width: tableView.frame.width ,height: 45))
                //menu image
                
                let imageView = UIImageView.init(frame: CGRect(x:10,y:10,width: 25 ,height: 25))
                imageView.contentMode = UIView.ContentMode.scaleAspectFit
                //menu header name
                let textLabel = UILabel.init(frame: CGRect(x:40,y:0,width: tableView.frame.size.width - 45 ,height: 45))
                textLabel.font = UIFont.boldSystemFont(ofSize: 16)
                
                textLabel.backgroundColor = UIColor.clear
                imageView.backgroundColor = UIColor.clear
                ////////
                let parentID = dataDict["ParentMenuId"] as! String
                let isExpanded =   dataDict["Expanded"] as! String
                
                var tempCount = 0
                
                if parentID == Orders_Parent_Menu_Id{
                    tempCount =  OrderList.count
                }else if  parentID == Time_Slip_Parent_Menu_Id{
                    tempCount =   TimeSlipList.count
                }else if  parentID == Reports_Parent_Menu_Id{
                    tempCount =  ReportList.count
                }else if  parentID == Client_Invoice_Parent_Menu_Id{
                    tempCount =  ClientInvoiceList.count
                }else if  parentID == EUA_Parent_Menu_Id{
                    tempCount =  EUAList.count
                }else if  parentID == SCR_Parent_Menu_Id{
                    tempCount =  SCRList.count
                }else if  parentID == ClientLocationScreen_Id{
                    tempCount =  ClientLoc.count
                }
                
                for lView in (headerView.subviews){
                    
                    if lView.tag == 1090{
                        lView.removeFromSuperview()
                    }
                }
                if tempCount > 0{
                    
                    let arrowImageView = UIImageView.init(frame: CGRect(x:textLabel.frame.size.width + 20,y:10,width: 15 ,height: 15))
                    arrowImageView.contentMode = UIView.ContentMode.scaleAspectFit
                    arrowImageView.backgroundColor = UIColor.clear
                    arrowImageView.tag = 1090
                    headerView.addSubview(arrowImageView)
                    if isExpanded == "1"{
                        arrowImageView.image = UIImage.init(named: "up_arrow")
                    }else{
                        
                        arrowImageView.image = UIImage.init(named: "Down_arrow")
                        
                    }
                }                
                
                /////////////
                let Header = dataDict["Header"] as! String
                print("Header Name: \(Header)")
                textLabel.text = Header
                
                if dataDict["LogoPath"]  != nil{
                    let LogoPath = dataDict["LogoPath"] as! String
                    if LogoPath.count == 0{
                    }else{
                        let imageURL =   URL(string:LogoPath)
                        imageView.sd_setImage(with: imageURL, placeholderImage: UIImage.init(named: "ImagePlaceholder"), options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                        })
                    }
                }else{
                    imageView.image = UIImage.init(named: Header)
                }
                headerView.backgroundColor = UIColor.white
                
                headerView.addSubview(textLabel)
                headerView.addSubview(tapBtn)
                headerView.addSubview(imageView)
                let lineView = UIView.init(frame: CGRect(x:15,y:headerView.frame.size.height - 1,width: tableView.frame.width + 100 ,height: 1))
                lineView.backgroundColor = borderColor
                headerView.addSubview(lineView)
                return headerView
            }
        }
    //viv new for e-register
        
        else if menuHeaderList.count == section {
            if tableView.tag == side_table_tag{
                print("viv enters side menu for e-register")
                let headerView = UIView.init(frame: CGRect(x:0,y:0,width: tableView.frame.width ,height: 45))
                let textLabel = UILabel.init(frame: CGRect(x:40,y:0,width: tableView.frame.size.width - 45 ,height: 45))
                textLabel.font = UIFont.boldSystemFont(ofSize: 16)
                textLabel.backgroundColor = UIColor.clear
                
                textLabel.text = "E-Register"
                
                headerView.backgroundColor = UIColor.white
                headerView.addSubview(textLabel)
                let lineView = UIView.init(frame: CGRect(x:15,y:headerView.frame.size.height - 1,width: tableView.frame.width + 100 ,height: 1))
                lineView.backgroundColor = borderColor
                headerView.addSubview(lineView)
                return headerView
            }
        }
        
        //end
        
        return UIView()
        
    }
    @objc func headerBtnTapped(sender: UIButton)  {
        
        
        let dataDict:NSMutableDictionary = menuHeaderList[sender.tag] as! NSMutableDictionary
        
        if dataDict.allKeys.count == 0{}else{
            let parentID = dataDict["ParentMenuId"] as! String
            
            if parentID == "0"{
                
                let MenuID =  dataDict["MenuID"] as! String
                let MenuName = dataDict["Header"] as! String
                self.showSideMenuOverlayView(willHide: true)
                
                
                self.navigateToCorrespondingPage(MenuName: MenuName, MenuId: Int(MenuID)!)
            }else if parentID == "18"{
                let MenuID =  dataDict["MenuID"] as! String
                let MenuName = dataDict["Header"] as! String
                self.showSideMenuOverlayView(willHide: true)

                if MenuName == "Privacy Policy" {
                    self.navigateToCorrespondingPage(MenuName: "", MenuId: Int(MenuID)!)
                }
  
            }
            else if parentID == "20"{
                
                let MenuID =  dataDict["MenuID"] as! String
                let MenuName = dataDict["Header"] as! String
                self.showSideMenuOverlayView(willHide: true)
                
                
                self.navigateToCorrespondingPage(MenuName: MenuName, MenuId: Int(MenuID)!)
                
            }
            else{
                let isExpanded =   dataDict["Expanded"] as! String
                
                if isExpanded == "1"{
                    dataDict["Expanded"] = "0"
                }else{
                    dataDict["Expanded"] = "1"
                }
                
            }
        }
        menuHeaderList.replaceObject(at: sender.tag, with: dataDict)
        sideMenuTableView.reloadData()
        menuTableView.reloadData()
        
        
    }
    //
    
    //MARK: -UICOLLECTIONVIEW DELEGATE & DATASOURCE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuColArray.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: colCellIdentifier, for: indexPath) as! MenuCollectionViewCell
        
        let menuObj = menuColArray[indexPath.row]
        let  menuOb:Menu = menuObj as! Menu
        
        
        cell.menuLabel.text = menuOb.LinkText
        cell.menuImageView.clipsToBounds = true
        let imageURL =   URL(string:menuOb.logoPath!)
        
        cell.menuImageView.sd_setImage(with: imageURL, placeholderImage: UIImage.init(named: "ImagePlaceholder"), options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            
            
        })
        //         cell.menuImageView?.image = imageWithImage(image: cell.menuImageView.image!, scaledToSize: CGSize(width: 25, height: 25))
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        let screenWidth  = UIScreen.main.bounds.size.width
        
        return CGSize(width:screenWidth/2 - 5 , height: 150)
        
    }
    //Use for interspacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
                        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let menuObj = menuColArray[indexPath.row]
        
        let  menuOb:Menu = menuObj as! Menu
        
        let MenuName = menuOb.LinkText
        
        self.navigateToCorrespondingPage(MenuName:MenuName!,MenuId: menuOb.MenuId! )
    }
    
    
    
    
    
    //MARK: - UIBUTTON ACTION
    @objc func handleApproveTimeslip(sender: UIButton){
        
        let senderPosition  = sender.convert(CGPoint.zero, to: pendingTimeSlipTableView)
        
        let indexPath =  pendingTimeSlipTableView.indexPathForRow(at:senderPosition)
        print(indexPath?.row ?? NSInteger())
    }
    @objc func handleViewEditTimeslip(sender: UIButton){
        
        let senderPosition  = sender.convert(CGPoint.zero, to: pendingTimeSlipTableView)
        
        let indexPath =  pendingTimeSlipTableView.indexPathForRow(at:senderPosition)
        print(indexPath?.row ?? NSInteger())
    }
    @IBAction func refreshButtonTapped(_ sender:UIButton){
        
        self.getMenuListCall()
        
    }
    
    @objc func sideMenuTapGesture(sender: UITapGestureRecognizer?) {
        print("*** viv tag gesture***")
        self.showSideMenuOverlayView(willHide: true)
        
    }
    
    @objc func tableHeaderViewTapGesture(sender: UITapGestureRecognizer?) {
        // print("Tapped")
        
        let headerView = sender?.view
        let dataDict:NSMutableDictionary = menuHeaderList[headerView!.tag] as! NSMutableDictionary
        
        //        let parentID = dataDict["ParentMenuId"] as! String
        let isExpanded =   dataDict["Expanded"] as! String
        
        if isExpanded == "1"{
            dataDict["Expanded"] = "0"
        }else{
            dataDict["Expanded"] = "1"
        }
        
        menuHeaderList.replaceObject(at: headerView!.tag, with: dataDict)
        sideMenuTableView.reloadData()
        menuTableView.reloadData()
    }
    
    
    // MARK: - SERVER CALL
    
    func getSafetyGuidlines() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            
            var ContactId =  "\(selectedDivisionContactID)"
            
            if ContactId == "0" || ContactId.count == 0{
                ContactId = UserDefaults.standard.object(forKey:"ContactId") as! String
            }else{
            }
            
            //userid as String
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let DivisionId = String(format:"%d", defaults.integer(forKey: "DivisionId"))
            
            //userid as String
            let params :[String:String] = ["ContactId":ContactId,"ClientID":clientID,"DivisionId":DivisionId]
            print(params)
            RestAPI.GetSafetyGuidlines(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getSafetyGuidlinesResponse(response:))
        }else{
            //            refreshButton.isHidden = false
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
    }
    
    func getSafetyGuidlinesResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            let object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                let IsAgree = object["IsAgree"].stringValue
                let Agrementfooter = object["Agrementfooter"].stringValue
                if object["IsAgree"].stringValue == "1"{
                    if SelectedMenuID == Get_TS_YouHave_Approved_Menu_Id {
                        //TS You have Approved
                        
                        self.pushToTSYouHaveApprovedPage()
                    }else  if SelectedMenuID == 32  || SelectedMenuID == 33 || SelectedMenuID == 34 {
                        //approve time slips
                        // 33 ==
                        self.pushToApproveTimeSlipPage()
                    }else  if SelectedMenuID == Enter_TS_Menu_Id {
                        //enter e timeslip
                        self.pushToEnterTimeSlipPage()
                        
                    }else  if SelectedMenuID == HOS_Group_TS_Menu_Id {
                        
                        self.pushToHospitalityGroupTSPage()
                        
                    }else  if SelectedMenuID == EUA_Menu_Id {
                        var agreementHeader = ""
                        if object["AgreemenetHeader"].stringValue.count == 0{
                        }else{
                            agreementHeader = String(format:"<p>%@</p>\r\n\r\n",object["AgreemenetHeader"].stringValue)
                            
                        }
                        let agreementString =   agreementHeader+object["AgreementText"].stringValue
                        let EuaId =  object["EuaId"].stringValue
                        let Message = object["Message"].stringValue
                        self.PushToEmpUsageAgreementPage(AgreementText: agreementString,EuaId: EuaId,checkAgreementMsg:Message,IsAgree: IsAgree,Agrementfooter: Agrementfooter )
                        //AgreemenetHeader
                    }else  if SelectedMenuID == SafetyGuidlines_Id {
                        var agreementHeader = ""
                        if object["AgreemenetHeader"].stringValue.count == 0{
                        }else{
                            agreementHeader = String(format:"<p>%@</p>\r\n\r\n",object["AgreemenetHeader"].stringValue)
                            
                        }
                        let agreementString =   agreementHeader+object["AgreementText"].stringValue
                        let EuaId =  object["EuaId"].stringValue
                        let Message = object["Message"].stringValue
                        self.PushToSafetyGuidlinesPage(AgreementText: agreementString,EuaId: EuaId,checkAgreementMsg:Message,IsAgree: IsAgree,Agrementfooter: Agrementfooter, titleName: object["Label"].stringValue, showSkip:object["Skip"].stringValue)
                        //AgreemenetHeader
                    }else  if   SelectedMenuID == eTimeClock_Menu_Id  {
                        
                        self.pushToeTimeClockPage(menuTitle: SelectedMenuName)
                        
                    }
                    else  if SelectedMenuID == Client_Invoice_Menu_Id {
                        
                        self.pushToClientInvoicePage()
                        
                    }
                    else if SelectedMenuID == Payment_Informatio_Id {
                        self.pushToCashApplicationPage()
                    }
                    
                    
                }else{
                    var agreementHeader = ""
                    if object["AgreemenetHeader"].stringValue.count == 0{
                    }else{
                        agreementHeader = String(format:"<p>%@</p>\r\n\r\n",object["AgreemenetHeader"].stringValue)
                        
                    }
                    let agreementString =   agreementHeader+object["AgreementText"].stringValue
                    let EuaId =  object["EuaId"].stringValue
                    let Message = object["Message"].stringValue
                    self.PushToSafetyGuidlinesPage(AgreementText: agreementString,EuaId: EuaId,checkAgreementMsg:Message,IsAgree: IsAgree,Agrementfooter: Agrementfooter, titleName: object["Label"].stringValue, showSkip:object["Skip"].stringValue)
                    
                }
                
            }else{
                var message = object["message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
    }
    
    func getEmpAgreementForApproveTS() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            
            var ContactId =  "\(selectedDivisionContactID)"
            
            if ContactId == "0" || ContactId.count == 0{
                ContactId = UserDefaults.standard.object(forKey:"ContactId") as! String
            }else{
            }
            
            //userid as String
            let defaults = UserDefaults.standard
            
            let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let DivisionId = String(format:"%d", defaults.integer(forKey: "DivisionId"))
            
            //userid as String
            let params :[String:String] = ["ContactId":ContactId,"ClientID":clientID,"DivisionId":DivisionId]
            print(params)
            RestAPI.checkEmpAgreement(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getEmpApproveTSAgreementResponse(response:))
        }else{
            //            refreshButton.isHidden = false
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    func getMenuListCall() {
        JustHUD.shared.showInView(view: view)
        self.changeNavigationTitle("Dashboard")
        self.formPopUpView.removeFromSuperview()
        let isInternetAvailable = self.isInternetAvailable()
        
        menuArray .removeAllObjects()
        ReportList.removeAllObjects()
        TimeSlipList.removeAllObjects()
        OrderList.removeAllObjects()
        OrderList.removeAllObjects()
        menuHeaderList.removeAllObjects()
        TimeSlipList.removeAllObjects()
        menuColArray.removeAllObjects()
        ClientInvoiceList.removeAllObjects()
        EUAList.removeAllObjects()
        ClientLoc.removeAllObjects()
        menuTableView.reloadData()
        
        if isInternetAvailable {
            //
            
            var ContactId = String(format:"%d", selectedDivisionContactID)
            
            if ContactId == "0" || ContactId.count == 0{
                ContactId = UserDefaults.standard.object(forKey:"ContactId") as! String
            }else{
            }
            
            //userid as String
            let params :[String:String] = ["ContactId":ContactId]
            print("The Menu List Parameter from dashbaord is ",params)
            RestAPI.getListOfMenus(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
        }else{
            JustHUD.shared.hide()
            refreshButton.isHidden = false
            
            //            self.ShowAlertMessage(message: InternetConnectionMessage, title: InternetConnectionTitle )
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    
    func getResponse(response:AnyObject)->()
    {
        
        
        
        
        isFromDivisionPage = false
        
        
       // print("vidhya the response is",response)
        if response is String{
            JustHUD.shared.hide()
            menuArray .removeAllObjects()
            ReportList.removeAllObjects()
            TimeSlipList.removeAllObjects()
            OrderList.removeAllObjects()
            menuHeaderList.removeAllObjects()
            TimeSlipList.removeAllObjects()
            menuColArray.removeAllObjects()
            ClientInvoiceList.removeAllObjects()
            EUAList.removeAllObjects()
            ClientLoc.removeAllObjects()
            SCRList.removeAllObjects()
            
            menuTableView.reloadData()
            refreshButton.isHidden = false
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            let object = response as! JSON
            print("viv the list of menu response from dashboard is", object)
            
            if object["MessageStatus"].intValue == 1
            {
                self.addDivisionNameOnTop()
                
                refreshButton.isHidden = true
                let dataArray = object["List"].array
                isClient = object["IsClient"].intValue
                ClientName = object["ClientName"].stringValue
                WeeklyStaffing = object["WeeklyStaffing"].stringValue
                if dataArray != nil{
                    
                    for dict in dataArray! {
                        
                        let menu = Menu.init(MenuId: dict["MenuId"].intValue, LinkText: dict["LinkText"].stringValue, MenuOrder: dict["MenuOrder"].intValue,logoPath: dict["LogoPath"].stringValue,ParentMenuId : dict["ParentMenuId"].intValue,ParentMenuName: dict["ParentMenuName"].stringValue, Action: dict["Action"].stringValue)
                        var dict = NSMutableDictionary()
                        
                        var dict1 = NSMutableDictionary()
                        
                        if menu.ParentMenuId == Int(Orders_Parent_Menu_Id){
                            if OrderList.contains(menu){
                            }else{
                                OrderList.add(menu)}
                            dict = ["Header":"\(menu.ParentMenuName!)","rows":OrderList,"ParentMenuId":"\(menu.ParentMenuId!)","Expanded":"1"]
                        }else if menu.ParentMenuId == Int(Reports_Parent_Menu_Id){
                            if ReportList.contains(menu){
                                
                            }else{
                                ReportList.add(menu)}
                            dict = ["Header":"\(menu.ParentMenuName!)","rows":ReportList,"ParentMenuId":"\(menu.ParentMenuId!)","Expanded":"1"]
                            
                        }else if menu.ParentMenuId == Int(Time_Slip_Parent_Menu_Id){
                            if TimeSlipList.contains(menu){}else{
                                TimeSlipList.add(menu)}
                            dict = ["Header":"\(menu.ParentMenuName!)","rows":TimeSlipList,"ParentMenuId":"\(menu.ParentMenuId!)","Expanded":"1"]
                        }
                        else if menu.ParentMenuId == 0{
                            dict = ["Header":"\(menu.LinkText!)","ParentMenuId":"\(menu.ParentMenuId!)","LogoPath":menu.logoPath!,"Expanded":"1","MenuID":String(format:"%d",menu.MenuId!)]
                        }
                        else if menu.ParentMenuId == 18{
                            dict = ["Header":"\(menu.ParentMenuName!)","ParentMenuId":"\(menu.ParentMenuId!)","LogoPath":menu.logoPath!,"Expanded":"1","MenuID":String(format:"%d",menu.MenuId!)]
                            
                        }
                        else if menu.ParentMenuId == Int(Client_Invoice_Parent_Menu_Id){
                            if ClientInvoiceList.contains(menu){
                                
                            }else{
                                ClientInvoiceList.add(menu)}

                            dict = ["Header":"\(menu.ParentMenuName!)","rows":ClientInvoiceList,"ParentMenuId":"\(menu.ParentMenuId!)","LogoPath":menu.logoPath!,"Expanded":"1"]
                        }else if menu.ParentMenuId == Int(EUA_Parent_Menu_Id){
                            if EUAList.contains(menu){
                                
                            }else{
                                EUAList.add(menu)}
                            dict = ["Header":"\(menu.ParentMenuName!)","rows":EUAList,"ParentMenuId":"\(menu.ParentMenuId!)","LogoPath":menu.logoPath!,"Expanded":"1"]
                            
                            //   dict = ["Header":"Employee Usage Agreement","ParentMenuId":"\(menu.ParentMenuId!)","LogoPath":menu.logoPath!,"Expanded":"1","MenuID":String(format:"%d",menu.MenuId!)]
                        }else if menu.ParentMenuId == Int(SCR_Parent_Menu_Id){
                            if SCRList.contains(menu){
                                
                            }else{
                                SCRList.add(menu)}
                            dict = ["Header":"\(menu.ParentMenuName!)","ParentMenuId":"\(menu.ParentMenuId!)","LogoPath":menu.logoPath!,"Expanded":"1","MenuID": "\(menu.MenuId!)"]
                        }
                        else if menu.ParentMenuId == Int(ClientLocationScreen_Id){
                            if ClientLoc.contains(menu){
                                
                            }else{
                                ClientLoc.add(menu)}
                            dict = ["Header":"\(menu.ParentMenuName!)","ParentMenuId":"\(menu.ParentMenuId!)","LogoPath":menu.logoPath!,"Expanded":"1","MenuID":String(format:"%d",menu.MenuId!)]
                            
                        }
                        if menuHeaderList.contains(dict){}else{
                            menuHeaderList.add(dict)
                            
                            //viv new
//                            if menu.ParentMenuId == 18 {
//                                if menuHeaderList.contains(dict1){}else{
//                                    menuHeaderList.add(dict1)
//                                }
//                            }
                            //viv end
                            
                            //viv from here the menu headerlist is adding
                            print("The Menu Header List is \(menuHeaderList)***")
                        }
                        if menuArray.contains(menu){
                        }else{
                            menuArray.add(menu)
                            print("The Menu Array List is \(menuArray)***")
                        }
                        DispatchQueue.main.async(execute: { () -> Void in
                            JustHUD.shared.hide()
                            self.sideMenuTableView.reloadData()
                            self.menuTableView.reloadData()
                        })
                        
                    }
                }
                //                var dict = NSMutableDictionary()
                //
                //                  dict = ["Header":"Privacy Policy","rows":[],"ParentMenuId":"","Expanded":"0"]
                //
                //                if menuHeaderList.contains(dict){}else{
                //                    menuHeaderList.add(dict)
                //                }
                
                //                menuColArray = menuArray
                for menu in menuArray{
                    let menuObj:Menu = menu as! Menu
                    menuColArray.add(menuObj)
                }
                menuColView.reloadData()
                
                self.constructColViewArray()
                
                Constants.globalPopupStatus = object["GlobalPopup"]["popupStatus"].intValue
                Constants.globalPopupMessage = object["GlobalPopup"]["PopupMessage"].stringValue
                Constants.globalPopupFormName = object["GlobalPopup"]["FormName"].stringValue
                Constants.globalPopupFormLink = object["GlobalPopup"]["FormLink"].stringValue
                Constants.globalPopupKey = object["GlobalPopup"]["PopupKey"].stringValue
                Constants.globalAlertStatus = object["GlobalPopup"]["Status"].intValue
                
                self.showFormsIfRequired()
                
                
            }else{
                JustHUD.shared.hide()
                refreshButton.isHidden = false
                var message = object["message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                //            RestAPI.ShowAlertMessage(ErrorMessage: message, titleMessage: " ", view: self)
            }
        }
    }
    func pushToCashApplicationPage(){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is ClientInvoiceViewController {
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CashApplicationController") as! CashApplicationController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        //        let screen = self.storyboard?.instantiateViewController(withIdentifier: "CashApplicationController") as! CashApplicationController
        //        self.navigationController?.pushViewController(screen, animated: true)
    }
    
    func showFormsIfRequired(){
        
        //Checking if global alert and form available
        if Constants.globalPopupStatus == 1 { // Show Alert
            if  Constants.globalAlertStatus == 1 || Constants.globalAlertStatus == 2 || Constants.globalAlertStatus == 4{
                
                self.loadAlertPopupWithObject(Constants.globalAlertStatus, messageText: Constants.globalPopupMessage, popKeyToSend: Constants.globalPopupKey, apiCallrequired: true)
            }
            if Constants.globalAlertStatus == 3  {
                self.loadAlertPopupWithObject(Constants.globalAlertStatus, messageText: Constants.globalPopupMessage, popKeyToSend: Constants.globalPopupKey, apiCallrequired: false)
            }
        }
        else if Constants.globalPopupStatus == 2 { //Show Form
            self.changeNavigationTitle(Constants.globalPopupFormName)
            self.showFormToUser()
        }
        
    }
    func getEmpApproveTSAgreementResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            
            //            self.ShowAlertMessage(message: response as! String, title: "")
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            let object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                let IsAgree = object["IsAgree"].stringValue
                let Agrementfooter = object["Agrementfooter"].stringValue
                if object["IsAgree"].stringValue == "1"{
                    if SelectedMenuID == EUA_Menu_Id {
                        var agreementHeader = ""
                        if object["AgreemenetHeader"].stringValue.count == 0{
                        }else{
                            agreementHeader = String(format:"<p>%@</p>\r\n\r\n",object["AgreemenetHeader"].stringValue)
                            
                        }
                        let agreementString =   agreementHeader+object["AgreementText"].stringValue
                        let EuaId =  object["EuaId"].stringValue
                        let Message = object["Message"].stringValue
                        self.PushToEmpUsageAgreementPage(AgreementText: agreementString,EuaId: EuaId,checkAgreementMsg:Message,IsAgree: IsAgree,Agrementfooter: Agrementfooter )
                        //AgreemenetHeader
                    }else {
                        isFromSafetey = false
                        self.getSafetyGuidlines()
                    }
                    /*
                     if SelectedMenuID == Get_TS_YouHave_Approved_Menu_Id {
                     //TS You have Approved
                     
                     self.pushToTSYouHaveApprovedPage()
                     }else  if SelectedMenuID == 32  || SelectedMenuID == 33 || SelectedMenuID == 34 {
                     //approve time slips
                     // 33 ==
                     self.pushToApproveTimeSlipPage()
                     }else  if SelectedMenuID == Enter_TS_Menu_Id {
                     //enter e timeslip
                     self.pushToEnterTimeSlipPage()
                     
                     }else  if SelectedMenuID == HOS_Group_TS_Menu_Id {
                     
                     self.pushToHospitalityGroupTSPage()
                     
                     }else  if SelectedMenuID == EUA_Menu_Id {
                     var agreementHeader = ""
                     if object["AgreemenetHeader"].stringValue.count == 0{
                     }else{
                     agreementHeader = String(format:"<p>%@</p>\r\n\r\n",object["AgreemenetHeader"].stringValue)
                     
                     }
                     let agreementString =   agreementHeader+object["AgreementText"].stringValue
                     let EuaId =  object["EuaId"].stringValue
                     let Message = object["Message"].stringValue
                     self.PushToEmpUsageAgreementPage(AgreementText: agreementString,EuaId: EuaId,checkAgreementMsg:Message,IsAgree: IsAgree,Agrementfooter: Agrementfooter )
                     //AgreemenetHeader
                     }else  if   SelectedMenuID == eTimeClock_Menu_Id  {
                     
                     self.pushToeTimeClockPage(menuTitle: SelectedMenuName)
                     
                     }
                     */
                }else{
                    var agreementHeader = ""
                    if object["AgreemenetHeader"].stringValue.count == 0{
                    }else{
                        agreementHeader = String(format:"<p>%@</p>\r\n\r\n",object["AgreemenetHeader"].stringValue)
                        
                    }
                    let agreementString =   agreementHeader+object["AgreementText"].stringValue
                    let EuaId =  object["EuaId"].stringValue
                    let Message = object["Message"].stringValue
                    self.PushToEmpUsageAgreementPage(AgreementText: agreementString,EuaId: EuaId,checkAgreementMsg:Message,IsAgree: IsAgree,Agrementfooter: Agrementfooter )
                    
                }
                
            }else{
                var message = object["message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
        }
    }
    func constructColViewArray() {
        if menuColArray.count > 0 {
            
            let menuObj = menuColArray[0]
            
            let  menuOb:Menu = menuObj as! Menu
            
            let MenuName = menuOb.LinkText
            
            if(MenuName?.caseInsensitiveCompare("Dashboard") == ComparisonResult.orderedSame){
                menuColArray .removeObject(at: 0)
            }
            menuColView.reloadData()
            
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
            DispatchQueue.main.async(execute: { () -> Void in
                self.sideMenuTableView.reloadData()
                self.menuTableView.reloadData()
                self.sideMenuView.frame = UIScreen.main.bounds
                self.addDivisionNameOnTop()
                
                
            })
        case .portraitUpsideDown:
            text="PortraitUpsideDown"
        case .landscapeLeft:
            text="LandscapeLeft"
            DispatchQueue.main.async(execute: { () -> Void in
                self.sideMenuTableView.reloadData()
                self.menuTableView.reloadData()
                self.sideMenuView.frame = UIScreen.main.bounds
                self.addDivisionNameOnTop()
                
            })
        case .landscapeRight:
            text="LandscapeRight"
            DispatchQueue.main.async(execute: { () -> Void in
                self.sideMenuTableView.reloadData()
                self.menuTableView.reloadData()
                self.sideMenuView.frame = UIScreen.main.bounds
                self.addDivisionNameOnTop()
                
            })
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
        DispatchQueue.main.async(execute: { () -> Void in
            self.sideMenuTableView.reloadData()
            
            if self.sideMenuView.isHidden == false{
                UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
                    
                    if self.isPortrait(){
                        self.sideMenuTblBaseViewTrailingConstraint.constant = 58
                    }else{
                        self.sideMenuTblBaseViewTrailingConstraint.constant = 250
                    }
                }, completion: { (finished: Bool) in
                    
                })
            }
        })
    }
    
    //MARK: Navigation Methods
    func sd(){
        
    }
    func navigateToCorrespondingPage(MenuName: String,MenuId: Int)  {
        
        self.clearDOEData()
        
        SelectedMenuID = MenuId
        SelectedMenuName = MenuName
        if MenuId == Division_Menu_Id {
            //Division
            //            self.pushToMapVC()
            self.pushToDivisionsListPage()
            
        }else  if MenuId == SCR_Menu_Id {
            self.pushToSCRPage()
        }else  if MenuId == Privacy_Policy_Menu_Id {
            //privacy policy
            //            self.pushToeTimeClockPage(menuTitle: SelectedMenuName)
            self.pushToViewPDFPage()
            //            self.pushToeTimeClockPage(menuTitle: SelectedMenuName)
        }else if MenuId == E_Register_Menu_Id{ //viv e-register
            self.pushToE_RegisterPage()
        }
        else  if MenuId == EUA_Menu_Id {
            self.getEmpAgreementForApproveTS()
        }
        else if MenuId == SafetyGuidlines_Id {
            isFromSafetey = true
            self.getSafetyGuidlines()
        }
        else  if MenuId == 1 {
            //Dashboard
        }else if MenuId == Client_Invoice_Menu_Id {
            //self.pushToClientInvoicePage()
            self.getEmpAgreementForApproveTS()
        }else  if MenuId == Historic_Order_Menu_Id {
            //view exsiting and historic order
            self.pushToHistoricOrderPage()
        }else  if MenuId == ROS_DOE_Menu_Id {
            //new doe order
            self.pushToROSDOEPage()
            
        }else  if MenuId == HOS_Group_TS_Menu_Id {
            self.getEmpAgreementForApproveTS()
            
        }else  if MenuId == Order_List_Menu_Id {
            //Order List
            self.pushToOrderListPage()
            
        }else  if MenuId == Active_Orders_Menu_Id {
            //Active orders
            self.pushToActiveOrderPage()
        }else  if MenuId == Get_TS_YouHave_Approved_Menu_Id || MenuId == eTimeClock_Menu_Id {
            //TS You have Approved
            
            self.getEmpAgreementForApproveTS()
            
        }else  if MenuId == 32  || MenuId == 33 || MenuId == 34 {
            //approve time slips
            // 33 ==
            self.getEmpAgreementForApproveTS()
        }else  if MenuId == Weekly_Staffing_Schedule_Menu_Id {
            
            //weekly staffing schdule
            self.pushToWeeklyStaffingPage()
        }else  if MenuId == 21 {
            //enter a new job
            
            let DivisionId = String(format:"%d", UserDefaults.standard.integer(forKey: "DivisionId"))
            
            
            if DivisionId == "50" ||  DivisionId == "117" || DivisionId == "92" || DivisionId == "132"{
            // earlier for this above division id it will go to ROSschool professional page
                            self.pushToROSSchoolProfessionalPage()
                //self.webViewforSchoolProfessional()
            }
            
            else {
                if  ClientName == "Hospitality"{
                    self.pushToROSHospitalityPage()
                }else if ClientName == "Office"{
                    self.pushToROSOfficePage()
                }else if ClientName == "OnCallCounsel"{
                    self.pushToROSOCCPage()
                }else if ClientName == "HealthCare"{
                    self.pushToROSHealthCarePage()
                }else if ClientName.contains("School Proffesional"){
                    self.pushToROSSchoolProfessionalPage()
                }else{
                    self.pushToROSOfficePage()
                }
            }
            
//                if DivisionId == "125" ||  DivisionId == "143" || DivisionId == "138" ||  DivisionId == "150" || DivisionId == "151" ||  DivisionId == "152"{
//
//                    print("viv the division id is \(DivisionId)")
//                    self.pushToROSSchoolProfessionalPage()
//                    print("Viv Division Id's to exclude")
//
//
//                }
//                    else {
//
//                    print("viv the division id is \(DivisionId)")
//                    self.webViewforSchoolProfessional()
//
//                }
                
        }else  if MenuId == 31 {//enter e timeslip
            //check agreement form
            self.getEmpAgreementForApproveTS()
        }
        else  if MenuId == Payment_Informatio_Id {
            //Cash Application
            //check agreement form
            // self.getEmpAgreementForApproveTS()
            self.pushToCashApplicationPage()
        }else if MenuId == 65{
            let nextViewController = CaptureClientLocation(nibName: "CaptureClientLocation", bundle: nil)
            nextViewController.screenName = SelectedMenuName
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        else if MenuId == 150 {
            print("viv entered web view")
            pushToWebView(file: actionURL)
        }
        
        
    }
    func PushToSafetyGuidlinesPage(AgreementText: String, EuaId: String, checkAgreementMsg: String, IsAgree: String,Agrementfooter: String,titleName: String, showSkip: String){
        
        var isControllerExists = false
        
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is SafteyGuidlinesController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SafteyGuidlinesController") as! SafteyGuidlinesController
            nextViewController.htmlStringToLoad = AgreementText
            nextViewController.EuaId = EuaId
            nextViewController.checkAgreementMsg = checkAgreementMsg
            nextViewController.selectedMenuId = SelectedMenuID
            nextViewController.selectedMenuName = SelectedMenuName
            nextViewController.IsAgree = IsAgree
            nextViewController.Agrementfooter = Agrementfooter
            nextViewController.titleName = titleName
            nextViewController.showSkipButton = showSkip
            nextViewController.isFromSafetey = isFromSafetey
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    func PushToEmpUsageAgreementPage(AgreementText: String, EuaId: String, checkAgreementMsg: String, IsAgree: String,Agrementfooter: String){
        
        var isControllerExists = false
        
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is EmpUsageAgreementViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EmpUsageAgreementSegue") as! EmpUsageAgreementViewController
            nextViewController.htmlStringToLoad = AgreementText
            nextViewController.EuaId = EuaId
            nextViewController.checkAgreementMsg = checkAgreementMsg
            nextViewController.selectedMenuId = SelectedMenuID
            nextViewController.selectedMenuName = SelectedMenuName
            nextViewController.IsAgree = IsAgree
            nextViewController.Agrementfooter = Agrementfooter
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    func pushToROSOCCPage(){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is ROSLawDeptViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ROSLawDeptSegue") as! ROSLawDeptViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func pushToROSSchoolProfessionalPage(){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is ROSSchoolProfessionalViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ROSSchoolProfessionalSegue") as! ROSSchoolProfessionalViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
    }
    
    func pushToHistoricOrderPage(){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is HistoricOrderViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HistoricOrderSegue") as! HistoricOrderViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
    }
    func pushToClientInvoicePage(){
        
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is ClientInvoiceViewController {
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ClientInvoiceSegue") as! ClientInvoiceViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    func pushToOrderListPage(){
        
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is OrderListViewController {
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OrderListSegue") as! OrderListViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    func pushToWeeklyStaffingPage(){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is WeeklyStaffingViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "WeeklyStaffingViewController") as! WeeklyStaffingViewController
            nextViewController.WeeklyStaffing = WeeklyStaffing
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        
    }
    func pushToApproveTimeSlipPage(){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is ApproveTimeSlipViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ApproveTimeSlipSegue") as! ApproveTimeSlipViewController
            nextViewController.willShowNoteAlert = "1"
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        //        self.PushToEmpUsageAgreementPage()
        
        
    }
    func pushToViewPDFPage(){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is LoadWebContentViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoadWebContentSegue") as! LoadWebContentViewController
            
            nextViewController.isForPrivacyPolicy = true
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
        
        
    }
    
    //viv web view page
    
    func pushToWebView(file: String){
        
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is LoadWebContentViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoadWebContentSegue") as! LoadWebContentViewController
            
            nextViewController.fileName = file
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
    }
    
    //viv e-register page
    
    func pushToE_RegisterPage(){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is E_RegisterDivisionListVC {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "E_RegisterTabSegue") as! E_RegisterTabVC
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
        
        
    }

    
    //end
    
    //    func pushToROSOfficePage(){
    //
    //
    //
    //        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    //
    //        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewRosOfficeVC") as! NewRosOfficeVC
    //
    //        self.navigationController?.pushViewController(nextViewController, animated: true)
    //
    //
    //
    //    }
    func pushToMapVC(){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is TrackEmpLocationVC {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Location", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TrackEmpLocationVC") as! TrackEmpLocationVC
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
    }
    func pushToROSOfficePage(){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is ROSOfficeViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ROSOfficeSegue") as! ROSOfficeViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
        
        
    }
    func pushToDivisionsListPage(){
        
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DivisionListViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DivisionListSegue") as! DivisionListViewController
            nextViewController.isFromSignin = false
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    func pushToActiveOrderPage(){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is ActiveOrderViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ActiveOrderSegue") as! ActiveOrderViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    func pushToTSYouHaveApprovedPage(){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is ApprovedTSViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ApprovedTSSegue") as! ApprovedTSViewController
            nextViewController.menuTitle = SelectedMenuName
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    func pushToEnterTimeSlipPage(){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is EnterTimeSlipViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Enter Timeslips") as! EnterTimeSlipViewController
            nextViewController.menuName = SelectedMenuName
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    func pushToROSHospitalityPage(){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is ROSHospitalityViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ROSHospitalitySegue") as! ROSHospitalityViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    func pushToROSHealthCarePage(){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is ROSHealthCareViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ROSHealthCareSegue") as! ROSHealthCareViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    func pushToSchdulePage(){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is AddNewReportToViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOESchduleSegue") as! DOESchduleViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
        
    }
    
    func pushToHospitalityGroupTSPage(){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is HospitalityGroupTSViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HospitalityGroupTSSegue") as! HospitalityGroupTSViewController
            
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
        
        
    }
    
    //
    func pushToROSDOEPage(){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOEConsultantPosTableViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOEConsultantPosSegue") as! DOEConsultantPosTableViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    func pushToDOEWaiverFormPage(){
        
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DOEWaiverFormTableViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DOEWaiverFormSegue") as! DOEWaiverFormTableViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        
    }
    func pushToeTimeClockPage(menuTitle: String){
        
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is eTimeClockViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "eTimeClockViewSegue") as! eTimeClockViewController
            nextViewController.menuTitle = SelectedMenuName
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        
    }
    func pushToSCRPage(){
        
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is SCRClearanceViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SCRClearanceVC") as! SCRClearanceViewController
            nextViewController.selectedMenuName = SelectedMenuName
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        
    }
    
    //MARK:- FormViewActions
    @IBAction func formPOpViewOkClicked(_ sender: UIButton) {
        
        let isInternetAvailable = self.isInternetAvailable()
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            
            var ContactId = String(format:"%d", selectedDivisionContactID)
            
            if ContactId == "0" || ContactId.count == 0{
                ContactId = UserDefaults.standard.object(forKey:"ContactId") as! String
            }else{
            }
            
            //userid as String
            let params :[String:String] = ["ContactId":ContactId,
                                           "PopupKey": Constants.globalPopupKey]
            print(params)
            RestAPI.formOkClickSubmit(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getOkClickResponse(response:))
        }else{
            refreshButton.isHidden = false
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
        
        
        
        
        
    }
    
    func getOkClickResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        let object = response as! JSON
        print(object)
        
        var formRespObject: JSON = JSON.null
        formRespObject = response as! JSON
        print(formRespObject)
        
        if formRespObject["MessageStatus"].intValue == 1 {
            self.changeNavigationTitle("Dashboard")
            formPopUpView.removeFromSuperview()
            self.getMenuListCall()
        }
        else {
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: formRespObject["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: info_Text, isAttributed: false)
        }
    }
    
    func showFormToUser(){
        formPopUpView.frame = CGRect(x:0,y:10, width:self.view.bounds.width, height:self.view.bounds.height-10)
        
        self.view.addSubview(formPopUpView)
        self.view.bringSubviewToFront(formPopUpView)
        let url = URL(string:Constants.globalPopupFormLink.replace(target:"\\", withString:"").replace(target:"https://docs.google.com/viewer?embedded=true&url=", withString:""))
        // let url = URL(string: "https://www.google.co.in")
        let request = URLRequest(url: url!)
        formWebView.load(request)
    }
    
    func webViewforSchoolProfessional(){
        print("viv enters school professional web view")
  
        let session = UserDefaults.standard.string(forKey: "SessionId")
        let clientId = UserDefaults.standard.string(forKey: "ClientID")
        let clientContactId = UserDefaults.standard.string(forKey: "ContactId")
        let divisionName = String(UserDefaults.standard.string(forKey: "DivisionName")!)
        let index = divisionName.index(divisionName.startIndex, offsetBy: 3)
        let substring = divisionName[..<index]
        let firstThreeCharacters = String(substring)

        print(firstThreeCharacters)
        print("the division name is", divisionName)
        print("the division name first 3 letters is", firstThreeCharacters)
        
        let urlLink = "https://apps.tempositions.com/rosui/auth/redirect/?sessionId=\(session!)&redirectUri=orders%2Fros%3FisExternal%3D1%26clientId%3D\(clientId!)%26clientName%3D\(firstThreeCharacters)%26clientcontactId%3D\(clientContactId!)"
        
        
        
        let updatedURLString = urlLink.replacingOccurrences(of: " ", with: "%20")
        
        print("the url link is",updatedURLString)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "WKWebVC") as! WKWebViewController
        
        nextViewController.URLstring = updatedURLString
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    //MARK: - Session Id API Call
    
    func sessionIdAPICall() {
        
        let url = URL(string: "\(RestAPI.BaseUrl)Account/Session")!
        print("the session id url complete is",url)
        //https://apps.tempositions.com/TempositionsCWA_API/CWAAPI/
        //https://apps.tempositions.com/TemPositionsCMAAPIDEV/CWAAPI/
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let username = UserDefaults.standard.string(forKey: "UserName")
        let password = UserDefaults.standard.string(forKey: "Password")
        let requestBody = "UserName=\(String(describing: username))&password=\(String(describing: password))"
        request.httpBody = requestBody.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Process the response or handle any errors here
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Response status code: \(response.statusCode)")
            }
            
            if let data = data {
                // Handle the response data here
                let responseString = String(data: data, encoding: .utf8)
                print("Response data: \(responseString ?? "")")
                
                let dJson = JSON(data)
                
                print("The session id is", dJson["SessionId"])
                UserDefaults.standard.set(dJson["SessionId"].stringValue, forKey: "SessionId")
                
            }
        }

        // Start the URLSession task
        task.resume()
    }
    
}

extension DashboardViewController: popAlertDashDelegate {
    func formStatuss(success: Bool) {
        
        print("Alert Successed")
        self.getMenuListCall()
    }
}

/*
 parent id = 3: Orders
 parent id = 6: Time Slips
 parent id = 10: Reports
 parent id = 0: Dashboard/Divisions
 
 */
