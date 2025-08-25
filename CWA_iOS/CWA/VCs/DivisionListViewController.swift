//
//  DivisionListViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 01/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class DivisionListViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    var isFromSignin = false
    @IBOutlet weak var noDivisionView: UIView!
    
    var isSearching = false
    private let divRefreshControl = UIRefreshControl()
    
    @IBOutlet weak var divSearchBar: UISearchBar!
    @IBOutlet weak var divisionListTableView: UITableView!
    var divisionDataArray = NSMutableArray()
    var filteredDataArray = NSMutableArray()
    
    private let tblRefreshControl = UIRefreshControl()
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        CMALocationManager.shared.requestLocationAtOnce()
        self.updateTintColor()
        self.view.backgroundColor = UIColor.white
        self.titlelbl.text = "Divisions"
        self.getDivisionListCall()
        let textFieldInsideUISearchBar = divSearchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.borderStyle = .none
        textFieldInsideUISearchBar?.layer.borderColor = borderColor.cgColor
        textFieldInsideUISearchBar?.layer.borderWidth = 1
        textFieldInsideUISearchBar?.backgroundColor = UIColor.white
        
        //        divSearchBar.subviews.forEach { divSearchBar in
        //            if divSearchBar is UITextInputTraits {
        //                do {
        //                    (divSearchBar as? UITextField)?.borderStyle = .bezel
        //                    //                    case none
        //                    //
        //                    //                    case line
        //                    //
        //                    //                    case bezel
        //                    //
        //                    //                    case roundedRect
        //                } catch {
        //                    // ignore exception
        //                }
        //            }
        //        }
    }
    @objc override func appWillEnterForeground(){
        print("appWillEnterForeground Division")
        if divisionDataArray.count == 0{
            self.getDivisionListCall()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.title = "Divisions"
        
        
        if #available(iOS 10.0, *) {
            divisionListTableView.refreshControl = divRefreshControl
        } else {
            divisionListTableView.addSubview(divRefreshControl)
        }
        
        // Configure Refresh Control
        divRefreshControl.addTarget(self, action: #selector(refreshOrder(_:)), for: .valueChanged)
        
        if isFromSignin {
            let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: navigationController, action: nil)
            navigationItem.leftBarButtonItem = backButton
            
            
        }
        if #available(iOS 10.0, *) {
            divisionListTableView.refreshControl = tblRefreshControl
        } else {
            divisionListTableView.addSubview(tblRefreshControl)
        }
        divisionListTableView.tableFooterView = UIView()
        // Configure Refresh Control
        tblRefreshControl.addTarget(self, action: #selector(refreshNotif(_:)), for: .valueChanged)
        
        //CLASS EXTENSION
        
        //        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(keyboardDoneBtnTapped))]
        toolBar.sizeToFit()
        
        divSearchBar.inputAccessoryView = toolBar
        
        //        let textFieldInsideUISearchBar = divSearchBar.value(forKey: "searchField") as? UITextField
        //        textFieldInsideUISearchBar?.borderStyle = .none
        //        textFieldInsideUISearchBar?.backgroundColor = UIColor.white
        
        
        self.updateTintColor()
        
        self.getDivisionListCall()
    }
    @objc func keyboardDoneBtnTapped(sender: UIButton)  {
        //        isSearching = false
        divSearchBar.endEditing(true)
    }
    
    func updateTintColor(){
        if UserDefaults.standard.value(forKey: "User_ColorCode") == nil{
            
        }else{
            divSearchBar.barTintColor = UIColor.white //UIColor(hexString:UserDefaults.standard.object(forKey:"User_ColorCode")as! String)
            if #available(iOS 13.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithDefaultBackground()
                appearance.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"User_ColorCode")as! String)
                navigationController?.navigationBar.prefersLargeTitles = false
                navigationController?.navigationBar.standardAppearance = appearance
                navigationController?.navigationBar.scrollEdgeAppearance = appearance
            } else {
                self.navigationController?.navigationBar.barTintColor = UIColor(hexString:UserDefaults.standard.object(forKey:"User_ColorCode")as! String)
            }
        }
        
    }
    func setUpRefreshControl(refreshControl: UIRefreshControl)  {
        
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
        
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Order ...", attributes: attributes)
        
        
    }
    @objc private func refreshNotif(_ sender: UIRefreshControl) {
        
        let refreshControl = sender
        // Fetch  Data
        
        self.getDivisionListCall()
        refreshControl.endRefreshing()
    }
    @objc private func refreshOrder(_ sender: UIRefreshControl) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if isSearching == true {
            return filteredDataArray.count
        }
        return divisionDataArray.count
        
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell:DivisionListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DivisionListTableViewCellIdentifire") as! DivisionListTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        //        var cell = tableView.dequeueReusableCell(withIdentifier: "DivisionListTableViewCellIdentifire") as UITableViewCell?
        //        if !(cell != nil) {
        //            cell = UITableViewCell(style:.subtitle, reuseIdentifier: "DivisionListTableViewCellIdentifire")
        //        }
        //
        //        cell?.accessoryType = .disclosureIndicator
        //        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        //
        var s = Division.init(Div_ID: 0, client_name:"", district: "", City:"", location_code: "", State:"", CodeZip:"", Phone:"", client_id:0, contact_id:0, pending_ts: 0,division: "",comp_name: "",LogoPath: "",ColorCode:"",SmallLogoPath: "" )
        if isSearching == true {
            s = filteredDataArray[indexPath.row] as! Division
            
        }else{
            s = divisionDataArray[indexPath.row] as! Division
            
        }
        
        
        
        let  div:Division = s
        
        let clientName =   div.client_name
        let divsionName =   div.division
        let pendingStatus =   div.pending_ts
        let comp_name =   div.comp_name
        
        //Div == 102,PKadrikar
        //UserDefaults.standard.object(forKey:"LogoPath")as! String)
        let defaults = UserDefaults.standard
        let DivisionId = defaults.integer(forKey: "DivisionId")
        
        if DivisionId == 102 {
            
            cell.TextLabel?.text = comp_name
            cell.DetailTextLabel?.text = div.district
            if comp_name?.count == 0{
                cell.TextLabel?.text = clientName
                cell.DetailTextLabel?.text = divsionName
                
            } else{
                cell.TextLabel?.text = comp_name
                cell.DetailTextLabel?.text = div.district
                
            }
        }else{
            if clientName?.count == 0{
                cell.TextLabel?.text = comp_name
                cell.DetailTextLabel?.text = div.district
                
            } else{
                cell.TextLabel?.text = clientName
                cell.DetailTextLabel?.text = divsionName
                
            }
        }
        
        
        
        let imageURLString = div.SmallLogoPath
        
        let imageURL = URL(string:imageURLString!)
        
        cell.ImageView?.sd_setImage(with: imageURL, placeholderImage: UIImage.init(named: "ImagePlaceholder"), options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            
            // Perform operation.
            if image != nil {
                
                cell.ImageView?.image = image
            }
        })
        
        
        if pendingStatus == 0 {
            cell.backgroundColor = UIColor.white
            
        }else{
            cell.backgroundColor = UIColor(hexString:"#39B3D7")
        }
        if cell.DetailTextLabel.text?.count == 0{
            cell.TextLabelHeightConstraint.constant = 50
        }else{
            cell.TextLabelHeightConstraint.constant = 31
        }
        cell.layoutIfNeeded()
        return cell
        
    }
    
    
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
        
    }
    func dropDownView(){}
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let rect = tableView.rectForRow(at: indexPath)
        var point = CGPoint(x: rect.midX, y: rect.midY)
        point = tableView.convert(point, to: nil)
        
        //        print(point)
        
        
        var s = Division.init(Div_ID: 0, client_name:"", district: "", City:"", location_code: "", State:"", CodeZip:"", Phone:"", client_id:0, contact_id:0, pending_ts: 0,division: "",comp_name: "",LogoPath: "",ColorCode:"",SmallLogoPath: "" )
        if isSearching == true {
            s = filteredDataArray[indexPath.row] as! Division
            
        }else{
            s = divisionDataArray[indexPath.row] as! Division
            
        }
        
        let  div:Division = s
        let ColorCode = div.ColorCode
        let logoPath = div.LogoPath
        let clientID = String(format:"%d",div.client_id!)
        let contactID = String(format:"%d",div.contact_id!)
        let divisionID = String(format:"%d",div.Div_ID!)
        //GET DIVISION NAME
        let clientName =   div.client_name
        let comp_name =   div.comp_name
        var divName = ""
        //Div == 102,PKadrikar
        //UserDefaults.standard.object(forKey:"LogoPath")as! String)
        let defaults = UserDefaults.standard
        let DivisionId = defaults.integer(forKey: "DivisionId")
        
        if DivisionId == 102 {
            
            divName = comp_name!
            if comp_name?.count == 0{
                divName = clientName!
                
            } else{
                divName = comp_name!
                
            }
        }else{
            if clientName?.count == 0{
                divName = comp_name!
                
            } else{
                divName = clientName!
                
            }
        }
        
        UserDefaults.standard.set(ColorCode, forKey: "ColorCode")
        UserDefaults.standard.set(logoPath, forKey: "LogoPath")
        UserDefaults.standard.set(clientID, forKey: "ClientID")
        UserDefaults.standard.set(contactID, forKey: "ContactId")
        UserDefaults.standard.set(divisionID, forKey: "DivisionId")
        UserDefaults.standard.set(divName, forKey: "DivisionName")
        
        UserDefaults.standard.synchronize()
        print(divName)
        print(DivisionId)
        
        var isControllerExists = false
        var dashboardVC = DashboardViewController()
        
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is DashboardViewController {
                    print("Your controller exist")
                    dashboardVC = viewController as! DashboardViewController
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DashboardSegue") as! DashboardViewController
            
            nextViewController.selectedDivisionContactID = div.contact_id!
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }else{
            dashboardVC.selectedDivisionContactID = div.contact_id!
            dashboardVC.isFromDivisionPage = true
            self.navigationController?.popToViewController(dashboardVC, animated: true)
        }
        
    }
    
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //
    //
    //        return 0
    //
    //        //        if UserDefaults.standard.object(forKey:"LogoPath") != nil {
    ////
    ////            return 80
    ////        }else{
    ////        }
    //    }
    //
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //
    //
    //        let view = UIView()
    //
    //        let label = UILabel()
    //
    ////        let LogoPath = UserDefaults.standard.object(forKey:"LogoPath")
    //
    ////        if LogoPath != nil {
    ////
    ////            let logoImageView = UIImageView()
    ////            logoImageView.frame = CGRect(x:0, y:0, width:100, height:80)
    ////
    ////
    ////            let imageURL = URL(string:LogoPath as! String)
    ////
    ////            logoImageView.sd_setImage(with: imageURL, placeholderImage: UIImage.init(named: "user_profile.png"), options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
    ////
    ////                // Perform operation.
    ////            })
    ////
    ////            logoImageView.contentMode = UIViewContentMode.scaleAspectFit
    ////            view.addSubview(logoImageView)
    ////
    ////            label.frame =  CGRect(x:105, y:0, width:tableView.frame.size.width - 105, height:80)
    ////            view.frame = CGRect(x:0, y:0, width:tableView.frame.size.width, height:80)
    ////
    ////        }else{
    //
    //            view.frame = CGRect(x:0, y:0, width:tableView.frame.size.width, height:40)
    //
    //            label.frame = CGRect(x:0, y:0, width:tableView.frame.size.width , height:view.frame.size.height)
    ////        }
    //
    //
    //        label.textAlignment = NSTextAlignment.left
    //        label.font = UIFont.boldSystemFont(ofSize: 14)
    //        label.backgroundColor = UIColor(red: 91/255, green: 192/255, blue: 222/255, alpha: 1.0)
    //        view.backgroundColor = UIColor.green
    //        label.text = "Rows highlighted in blue indicate there are pending time slip(s) for the division"
    //        label.numberOfLines = 0
    //        label.textColor = UIColor.white
    //
    //        view.addSubview(label)
    //
    //        return view
    //    }
    //
    
    
    
    func pushToDashboardPage() {
        
        
        
    }
    //MARK: - UISEARCHBAR DELEGATE METHODS
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        //        isSearching = false
        
        searchBar.endEditing(false)
        
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) // called when text changes (including clear)
    {
        isSearching = true
        
        //////////////////**********************SEARCH**********///////////////
        
        filteredDataArray.removeAllObjects()
        if searchText.count > 0
        {
            var found = false
            
            
            for div in divisionDataArray{
                
                let  divObj:Division = div as! Division
                var servicename = ""
                let clientName =   divObj.client_name
                let comp_name =   divObj.comp_name
                let district =   divObj.district
                
                let defaults = UserDefaults.standard
                let DivisionId = defaults.integer(forKey: "DivisionId")
                
                
                
                if DivisionId == 102 {
                    
                    servicename = (comp_name?.lowercased())!
                    if comp_name?.count == 0{
                        servicename = (clientName?.lowercased())!+(district?.lowercased())!
                    } else{
                        servicename = (comp_name?.lowercased())!+(district?.lowercased())!
                        
                    }
                }else{
                    if clientName?.count == 0{
                        servicename = (comp_name?.lowercased())!+(district?.lowercased())!
                    } else{
                        servicename = (clientName?.lowercased())!+(district?.lowercased())!
                        
                    }
                }
                
                
                
                
                
                //                print(servicename)
                
                let searchString = searchText.lowercased()
                
                found = (servicename.contains(searchString)) || (servicename.caseInsensitiveCompare(searchString) == ComparisonResult.orderedSame)
                
                
                if found {
                    //                    print("found")
                    filteredDataArray.add(divObj)
                    //                        [filteredData addObject:dict];
                }
                else{
                    //                    print("Not found")
                }
            }
        }
        else
        {
            isSearching = false
            searchBar.endEditing(true)
            
        }
        divisionListTableView.reloadData()
        
        /////////////////////******** END OF SEARCH *********//////
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) // called when cancel button pressed
    {
        isSearching = false
        searchBar.endEditing(true)
        
    }
    
    
    // MARK: - SERVER CALL
    
    
    func getDivisionListCall() {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: (self.view)!)
            let defaults = UserDefaults.standard
            
            let username = defaults.string(forKey: "UserName")
            let clientID = String(format:"%d", defaults.integer(forKey: "User_ClientID"))
            let DivisionId = String(format:"%d", defaults.integer(forKey: "User_DivisionId"))
            
            //userid as String
            let params :[String:String] = ["UserName":username!,"ClientID":clientID,"DivisionId":DivisionId]
            print("viv the params from 563 line is\(params)***")
            RestAPI.getListOfDivisions(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
            
        }else{
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
    }
    
    func getResponse(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print("viv the division response is ",response)
        if response is String{
            
            //            self.ShowAlertMessage(message: response as! String, title: "")
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            let object = response as! JSON
            
            
            if object["MessageStatus"].intValue == 1
            {
                
                let dataArray = object["DivisionList"].array
                divisionDataArray .removeAllObjects()
                
                let clientID = UserDefaults.standard.string(forKey: "ClientID")
                if clientID != nil {
                }else{
                    
                    let logoPath = object["LogoPath"].stringValue
                    
                    UserDefaults.standard.set(object["ColorCode"].stringValue, forKey: "ColorCode")
                    UserDefaults.standard.set(logoPath, forKey: "LogoPath")
                    UserDefaults.standard.synchronize()
                    
                }
                
                
                for dict in dataArray! {
                    
                    let div = Division.init(Div_ID: dict["Div_ID"].intValue, client_name: dict["client_name"].stringValue, district: dict["district"].stringValue, City:  dict["City"].stringValue, location_code: dict["location_code"].stringValue, State: dict["State"].stringValue, CodeZip: dict["CodeZip"].stringValue, Phone: dict["Phone"].stringValue, client_id: dict["client_id"].intValue, contact_id: dict["contact_id"].intValue, pending_ts: dict["pending_ts"].intValue,division: dict["division"].stringValue,comp_name: dict["comp_name"].stringValue,LogoPath: dict["LogoPath"].stringValue,ColorCode: dict["ColorCode"].stringValue,SmallLogoPath:dict["APISmallLogoPath"].stringValue)
                    
                    divisionDataArray.add(div)
                    divisionListTableView.reloadData()
                }
                if divisionDataArray.count == 0 {
                    noDivisionView.isHidden = false
                }else{
                    noDivisionView.isHidden = true
                }
                
                
            }else{
                
                var message = object["message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
                //                self.ShowAlertMessage(message: message, title: "")
                //            RestAPI.ShowAlertMessage(ErrorMessage: message, titleMessage: " ", view: self)
            }
        }
    }
    
}
/*
 {
 "IsMultiple" : false,
 "MessageStatus" : 1,
 "MessageColor" : 0,
 "DivisionCount" : 0,
 "Position" : "d",
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/school_pro_1.jpg",
 "ClientID" : 44886,
 "DivisionList" : [
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Aditi Shah c\/o TemPositions",
 "contact_id" : 213300,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/healthcareside.png",
 "Div_ID" : 114,
 "client_id" : 53494,
 "ColorCode" : "#27b1a2",
 "location_code" : "",
 "pending_ts" : 27
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "Community School Dist Two          ",
 "comp_name" : "ALFRED E. SMITH                    ",
 "contact_id" : 211932,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/school_pro_1.jpg",
 "Div_ID" : 102,
 "client_id" : 74203,
 "ColorCode" : "#002763",
 "location_code" : "02M001",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "TemPositions, Inc.",
 "comp_name" : "IT Division",
 "contact_id" : 170737,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/office_1.jpg",
 "Div_ID" : 13,
 "client_id" : 1876,
 "ColorCode" : "#ff8700",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Client 198",
 "contact_id" : 199731,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/hospitalityside.png",
 "Div_ID" : 57,
 "client_id" : 49840,
 "ColorCode" : "#00300e",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (AcctPositions S.F.)",
 "contact_id" : 199725,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/AcctPositions.png",
 "Div_ID" : 35,
 "client_id" : 30217,
 "ColorCode" : "#630101",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (AcctPositions)",
 "contact_id" : 199718,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/AcctPositions.png",
 "Div_ID" : 5,
 "client_id" : 3342,
 "ColorCode" : "#630101",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (ACS - eTimeClock)",
 "contact_id" : 211112,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/healthcareside.png",
 "Div_ID" : 15,
 "client_id" : 73980,
 "ColorCode" : "#27b1a2",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (Administration for Child Services)",
 "contact_id" : 194853,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/healthcareside.png",
 "Div_ID" : 15,
 "client_id" : 70831,
 "ColorCode" : "#27b1a2",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (AOC)",
 "contact_id" : 199722,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/office_1.jpg",
 "Div_ID" : 115,
 "client_id" : 30218,
 "ColorCode" : "#ff8700",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (CompuForce S.F.)",
 "contact_id" : 199720,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/compuforce_1.jpg",
 "Div_ID" : 32,
 "client_id" : 53385,
 "ColorCode" : "#7bc142",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (CompuForce S.F.)",
 "contact_id" : 194113,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/compuforce_1.jpg",
 "Div_ID" : 32,
 "client_id" : 28816,
 "ColorCode" : "#7bc142",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (CompuForce)",
 "contact_id" : 194845,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/compuforce_1.jpg",
 "Div_ID" : 4,
 "client_id" : 70826,
 "ColorCode" : "#7bc142",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (Convention Services)",
 "contact_id" : 199721,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/Convention Services.png",
 "Div_ID" : 113,
 "client_id" : 32160,
 "ColorCode" : "#5a6d68",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "Department of Education - Health Aides",
 "comp_name" : "Test Company (DOE School Nursing)",
 "contact_id" : 211586,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/SchoolRnside.PNG",
 "Div_ID" : 97,
 "client_id" : 74098,
 "ColorCode" : "#dd001d",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (Health Homes - LI)",
 "contact_id" : 199734,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/healthcareside.png",
 "Div_ID" : 47,
 "client_id" : 22364,
 "ColorCode" : "#27b1a2",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (Hospitality - CA)",
 "contact_id" : 199729,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/hospitalityside.png",
 "Div_ID" : 126,
 "client_id" : 30219,
 "ColorCode" : "#00300e",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (HR Staffing Solutions S.F.)",
 "contact_id" : 199728,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/HR Staffing Solutions.png",
 "Div_ID" : 103,
 "client_id" : 27602,
 "ColorCode" : "#7c6a57",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (HR Staffing Solutions)",
 "contact_id" : 199719,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/HR Staffing Solutions.png",
 "Div_ID" : 18,
 "client_id" : 39004,
 "ColorCode" : "#7c6a57",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (Magill - TemPositions)",
 "contact_id" : 199714,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/office_1.jpg",
 "Div_ID" : 95,
 "client_id" : 32159,
 "ColorCode" : "#ff8700 ",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "New York City Law Department",
 "comp_name" : "Test Company (NY Law Dept.)",
 "contact_id" : 195211,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/occ_1.jpg",
 "Div_ID" : 6,
 "client_id" : 70937,
 "ColorCode" : "#525398",
 "location_code" : "",
 "pending_ts" : 5
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (On Call Counsel S.F.)",
 "contact_id" : 199724,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/occ_1.jpg",
 "Div_ID" : 33,
 "client_id" : 29245,
 "ColorCode" : "#525398",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (OnCallCounsel)",
 "contact_id" : 195210,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/occ_1.jpg",
 "Div_ID" : 6,
 "client_id" : 70827,
 "ColorCode" : "#525398",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "Test Company",
 "comp_name" : "Test Company (Opus Scientific)",
 "contact_id" : 199709,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/logo_2.png",
 "Div_ID" : 123,
 "client_id" : 64675,
 "ColorCode" : "#0c69a1",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (Opus Staffing)",
 "contact_id" : 199730,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/Opus Staffing_Small.jpg",
 "Div_ID" : 124,
 "client_id" : 66761,
 "ColorCode" : "#0c69a1",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (School Professional UPK)",
 "contact_id" : 199715,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/school_pro_1.jpg",
 "Div_ID" : 117,
 "client_id" : 57997,
 "ColorCode" : "#002763",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (School Professionals LI)",
 "contact_id" : 199733,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/school_pro_1.jpg",
 "Div_ID" : 99,
 "client_id" : 28606,
 "ColorCode" : "#002763",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (School Professionals S.F.)",
 "contact_id" : 199727,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/school_pro_1.jpg",
 "Div_ID" : 92,
 "client_id" : 59380,
 "ColorCode" : "#002763",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (School Professionals)",
 "contact_id" : 194848,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/school_pro_1.jpg",
 "Div_ID" : 50,
 "client_id" : 70830,
 "ColorCode" : "#002763",
 "location_code" : "",
 "pending_ts" : 15
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (School RN)",
 "contact_id" : 194846,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/SchoolRnside.PNG",
 "Div_ID" : 7,
 "client_id" : 70828,
 "ColorCode" : "#dd001d",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (Social Services - LI)",
 "contact_id" : 199735,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/healthcareside.png",
 "Div_ID" : 120,
 "client_id" : 25453,
 "ColorCode" : "#27b1a2",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (Social Services)",
 "contact_id" : 194855,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/healthcareside.png",
 "Div_ID" : 9,
 "client_id" : 70832,
 "ColorCode" : "#27b1a2",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (TemPositions Eden Hospitality LI)",
 "contact_id" : 199732,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/hospitalityside.png",
 "Div_ID" : 112,
 "client_id" : 25898,
 "ColorCode" : "#00300e",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (TemPositions Eden Hospitality)",
 "contact_id" : 194847,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/hospitalityside.png",
 "Div_ID" : 55,
 "client_id" : 70829,
 "ColorCode" : "#00300e",
 "location_code" : "",
 "pending_ts" : 8
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (TemPositions Eden Rand CT)",
 "contact_id" : 199716,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/hospitalityside.png",
 "Div_ID" : 59,
 "client_id" : 15184,
 "ColorCode" : "#00300e",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (TemPositions Hospitality - CA)",
 "contact_id" : 195316,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/hospitalityside.png",
 "Div_ID" : 81,
 "client_id" : 70960,
 "ColorCode" : "#00300e",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (TemPositions Office Melville)",
 "contact_id" : 199726,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/office_1.jpg",
 "Div_ID" : 45,
 "client_id" : 59371,
 "ColorCode" : "#ff8700",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (TemPositions Office)",
 "contact_id" : 194844,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/office_1.jpg",
 "Div_ID" : 2,
 "client_id" : 70825,
 "ColorCode" : "#ff8700",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (TemPositions S.F.)",
 "contact_id" : 199723,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/office_1.jpg",
 "Div_ID" : 29,
 "client_id" : 59379,
 "ColorCode" : "#ff8700",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (TemPositions VMS)",
 "contact_id" : 199712,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/office_1.jpg",
 "Div_ID" : 118,
 "client_id" : 71814,
 "ColorCode" : "#ff8700",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "Test Company",
 "comp_name" : "Test Company (TemPositions\/Opus)",
 "contact_id" : 199710,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/logo_2.png",
 "Div_ID" : 58,
 "client_id" : 64676,
 "ColorCode" : "#0c69a1",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (Test Division)",
 "contact_id" : 163618,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/office_1.jpg",
 "Div_ID" : 13,
 "client_id" : 25431,
 "ColorCode" : "#ff8700",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (Vintage\/TemPositions)",
 "contact_id" : 199717,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/office_1.jpg",
 "Div_ID" : 100,
 "client_id" : 41192,
 "ColorCode" : "#ff8700 ",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "District 11",
 "comp_name" : "Test Location",
 "contact_id" : 194857,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/school_pro_1.jpg",
 "Div_ID" : 102,
 "client_id" : 44843,
 "ColorCode" : "#002763",
 "location_code" : "11TEST",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "Test District",
 "comp_name" : "Test Location Code",
 "contact_id" : 160158,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/school_pro_1.jpg",
 "Div_ID" : 102,
 "client_id" : 44886,
 "ColorCode" : "#002763",
 "location_code" : "00TEST",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "District 09",
 "comp_name" : "Test School",
 "contact_id" : 199241,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/school_pro_1.jpg",
 "Div_ID" : 102,
 "client_id" : 44852,
 "ColorCode" : "#002763",
 "location_code" : "09p875",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "District 09",
 "comp_name" : "Test School",
 "contact_id" : 199241,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/school_pro_1.jpg",
 "Div_ID" : 102,
 "client_id" : 44852,
 "ColorCode" : "#002763",
 "location_code" : "09P876",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "TestClient",
 "contact_id" : 173348,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/office_1.jpg",
 "Div_ID" : 13,
 "client_id" : 22201,
 "ColorCode" : "#ff8700",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "District 01",
 "comp_name" : "TESTING SCHOOL",
 "contact_id" : 211898,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/school_pro_1.jpg",
 "Div_ID" : 102,
 "client_id" : 44934,
 "ColorCode" : "#002763",
 "location_code" : "01M791",
 "pending_ts" : 0
 }
 ],
 "ContactID" : 0,
 "IsModel" : false,
 "DivID" : 102,
 "ColorCode" : "#002763",
 "ros" : 0,
 "cnt" : 1,
 "DivisionSkin" : "schoolprofessional.css"
 }
 {
 "IsMultiple" : false,
 "MessageStatus" : 1,
 "MessageColor" : 0,
 "DivisionCount" : 0,
 "Position" : "d",
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/school_pro_1.jpg",
 "ClientID" : 44886,
 "DivisionList" : [
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Aditi Shah c\/o TemPositions",
 "contact_id" : 213300,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/healthcareside.png",
 "Div_ID" : 114,
 "client_id" : 53494,
 "ColorCode" : "#27b1a2",
 "location_code" : "",
 "pending_ts" : 27
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "Community School Dist Two          ",
 "comp_name" : "ALFRED E. SMITH                    ",
 "contact_id" : 211932,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/school_pro_1.jpg",
 "Div_ID" : 102,
 "client_id" : 74203,
 "ColorCode" : "#002763",
 "location_code" : "02M001",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "TemPositions, Inc.",
 "comp_name" : "IT Division",
 "contact_id" : 170737,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/office_1.jpg",
 "Div_ID" : 13,
 "client_id" : 1876,
 "ColorCode" : "#ff8700",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Client 198",
 "contact_id" : 199731,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/hospitalityside.png",
 "Div_ID" : 57,
 "client_id" : 49840,
 "ColorCode" : "#00300e",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (AcctPositions S.F.)",
 "contact_id" : 199725,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/AcctPositions.png",
 "Div_ID" : 35,
 "client_id" : 30217,
 "ColorCode" : "#630101",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (AcctPositions)",
 "contact_id" : 199718,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/AcctPositions.png",
 "Div_ID" : 5,
 "client_id" : 3342,
 "ColorCode" : "#630101",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (ACS - eTimeClock)",
 "contact_id" : 211112,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/healthcareside.png",
 "Div_ID" : 15,
 "client_id" : 73980,
 "ColorCode" : "#27b1a2",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (Administration for Child Services)",
 "contact_id" : 194853,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/healthcareside.png",
 "Div_ID" : 15,
 "client_id" : 70831,
 "ColorCode" : "#27b1a2",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (AOC)",
 "contact_id" : 199722,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/office_1.jpg",
 "Div_ID" : 115,
 "client_id" : 30218,
 "ColorCode" : "#ff8700",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (CompuForce S.F.)",
 "contact_id" : 199720,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/compuforce_1.jpg",
 "Div_ID" : 32,
 "client_id" : 53385,
 "ColorCode" : "#7bc142",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (CompuForce S.F.)",
 "contact_id" : 194113,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/compuforce_1.jpg",
 "Div_ID" : 32,
 "client_id" : 28816,
 "ColorCode" : "#7bc142",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (CompuForce)",
 "contact_id" : 194845,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/compuforce_1.jpg",
 "Div_ID" : 4,
 "client_id" : 70826,
 "ColorCode" : "#7bc142",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (Convention Services)",
 "contact_id" : 199721,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/Convention Services.png",
 "Div_ID" : 113,
 "client_id" : 32160,
 "ColorCode" : "#5a6d68",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "Department of Education - Health Aides",
 "comp_name" : "Test Company (DOE School Nursing)",
 "contact_id" : 211586,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/SchoolRnside.PNG",
 "Div_ID" : 97,
 "client_id" : 74098,
 "ColorCode" : "#dd001d",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (Health Homes - LI)",
 "contact_id" : 199734,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/healthcareside.png",
 "Div_ID" : 47,
 "client_id" : 22364,
 "ColorCode" : "#27b1a2",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (Hospitality - CA)",
 "contact_id" : 199729,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/hospitalityside.png",
 "Div_ID" : 126,
 "client_id" : 30219,
 "ColorCode" : "#00300e",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (HR Staffing Solutions S.F.)",
 "contact_id" : 199728,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/HR Staffing Solutions.png",
 "Div_ID" : 103,
 "client_id" : 27602,
 "ColorCode" : "#7c6a57",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (HR Staffing Solutions)",
 "contact_id" : 199719,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/HR Staffing Solutions.png",
 "Div_ID" : 18,
 "client_id" : 39004,
 "ColorCode" : "#7c6a57",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (Magill - TemPositions)",
 "contact_id" : 199714,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/office_1.jpg",
 "Div_ID" : 95,
 "client_id" : 32159,
 "ColorCode" : "#ff8700 ",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "New York City Law Department",
 "comp_name" : "Test Company (NY Law Dept.)",
 "contact_id" : 195211,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/occ_1.jpg",
 "Div_ID" : 6,
 "client_id" : 70937,
 "ColorCode" : "#525398",
 "location_code" : "",
 "pending_ts" : 5
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (On Call Counsel S.F.)",
 "contact_id" : 199724,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/occ_1.jpg",
 "Div_ID" : 33,
 "client_id" : 29245,
 "ColorCode" : "#525398",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (OnCallCounsel)",
 "contact_id" : 195210,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/occ_1.jpg",
 "Div_ID" : 6,
 "client_id" : 70827,
 "ColorCode" : "#525398",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "Test Company",
 "comp_name" : "Test Company (Opus Scientific)",
 "contact_id" : 199709,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/logo_2.png",
 "Div_ID" : 123,
 "client_id" : 64675,
 "ColorCode" : "#0c69a1",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (Opus Staffing)",
 "contact_id" : 199730,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/Opus Staffing_Small.jpg",
 "Div_ID" : 124,
 "client_id" : 66761,
 "ColorCode" : "#0c69a1",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (School Professional UPK)",
 "contact_id" : 199715,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/school_pro_1.jpg",
 "Div_ID" : 117,
 "client_id" : 57997,
 "ColorCode" : "#002763",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (School Professionals LI)",
 "contact_id" : 199733,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/school_pro_1.jpg",
 "Div_ID" : 99,
 "client_id" : 28606,
 "ColorCode" : "#002763",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (School Professionals S.F.)",
 "contact_id" : 199727,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/school_pro_1.jpg",
 "Div_ID" : 92,
 "client_id" : 59380,
 "ColorCode" : "#002763",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (School Professionals)",
 "contact_id" : 194848,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/school_pro_1.jpg",
 "Div_ID" : 50,
 "client_id" : 70830,
 "ColorCode" : "#002763",
 "location_code" : "",
 "pending_ts" : 15
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (School RN)",
 "contact_id" : 194846,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/SchoolRnside.PNG",
 "Div_ID" : 7,
 "client_id" : 70828,
 "ColorCode" : "#dd001d",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (Social Services - LI)",
 "contact_id" : 199735,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/healthcareside.png",
 "Div_ID" : 120,
 "client_id" : 25453,
 "ColorCode" : "#27b1a2",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (Social Services)",
 "contact_id" : 194855,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/healthcareside.png",
 "Div_ID" : 9,
 "client_id" : 70832,
 "ColorCode" : "#27b1a2",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (TemPositions Eden Hospitality LI)",
 "contact_id" : 199732,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/hospitalityside.png",
 "Div_ID" : 112,
 "client_id" : 25898,
 "ColorCode" : "#00300e",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (TemPositions Eden Hospitality)",
 "contact_id" : 194847,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/hospitalityside.png",
 "Div_ID" : 55,
 "client_id" : 70829,
 "ColorCode" : "#00300e",
 "location_code" : "",
 "pending_ts" : 8
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (TemPositions Eden Rand CT)",
 "contact_id" : 199716,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/hospitalityside.png",
 "Div_ID" : 59,
 "client_id" : 15184,
 "ColorCode" : "#00300e",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (TemPositions Hospitality - CA)",
 "contact_id" : 195316,
 "LogoPath" : "https:\/\/apps.tempositions.com\/ewa\/Images\/hospitalityside.png",
 "Div_ID" : 81,
 "client_id" : 70960,
 "ColorCode" : "#00300e",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (TemPositions Office Melville)",
 "contact_id" : 199726,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/office_1.jpg",
 "Div_ID" : 45,
 "client_id" : 59371,
 "ColorCode" : "#ff8700",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (TemPositions Office)",
 "contact_id" : 194844,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/office_1.jpg",
 "Div_ID" : 2,
 "client_id" : 70825,
 "ColorCode" : "#ff8700",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (TemPositions S.F.)",
 "contact_id" : 199723,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/office_1.jpg",
 "Div_ID" : 29,
 "client_id" : 59379,
 "ColorCode" : "#ff8700",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (TemPositions VMS)",
 "contact_id" : 199712,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/office_1.jpg",
 "Div_ID" : 118,
 "client_id" : 71814,
 "ColorCode" : "#ff8700",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "Test Company",
 "comp_name" : "Test Company (TemPositions\/Opus)",
 "contact_id" : 199710,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/logo_2.png",
 "Div_ID" : 58,
 "client_id" : 64676,
 "ColorCode" : "#0c69a1",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (Test Division)",
 "contact_id" : 163618,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/office_1.jpg",
 "Div_ID" : 13,
 "client_id" : 25431,
 "ColorCode" : "#ff8700",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "Test Company (Vintage\/TemPositions)",
 "contact_id" : 199717,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/office_1.jpg",
 "Div_ID" : 100,
 "client_id" : 41192,
 "ColorCode" : "#ff8700 ",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "District 11",
 "comp_name" : "Test Location",
 "contact_id" : 194857,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/school_pro_1.jpg",
 "Div_ID" : 102,
 "client_id" : 44843,
 "ColorCode" : "#002763",
 "location_code" : "11TEST",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "Test District",
 "comp_name" : "Test Location Code",
 "contact_id" : 160158,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/school_pro_1.jpg",
 "Div_ID" : 102,
 "client_id" : 44886,
 "ColorCode" : "#002763",
 "location_code" : "00TEST",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "District 09",
 "comp_name" : "Test School",
 "contact_id" : 199241,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/school_pro_1.jpg",
 "Div_ID" : 102,
 "client_id" : 44852,
 "ColorCode" : "#002763",
 "location_code" : "09p875",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "District 09",
 "comp_name" : "Test School",
 "contact_id" : 199241,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/school_pro_1.jpg",
 "Div_ID" : 102,
 "client_id" : 44852,
 "ColorCode" : "#002763",
 "location_code" : "09P876",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "",
 "comp_name" : "TestClient",
 "contact_id" : 173348,
 "LogoPath" : "https:\/\/apps.tempositions.com\/Images\/office_1.jpg",
 "Div_ID" : 13,
 "client_id" : 22201,
 "ColorCode" : "#ff8700",
 "location_code" : "",
 "pending_ts" : 0
 },
 {
 "IsMultiple" : true,
 "ext" : 0,
 "Fl" : 0,
 "district" : "District 01",
 "comp_name" : "TESTING SCHOOL",
 "contact_id" : 211898,
 "LogoPath" : "http:\/\/apps.tempositions.com\/images\/school_pro_1.jpg",
 "Div_ID" : 102,
 "client_id" : 44934,
 "ColorCode" : "#002763",
 "location_code" : "01M791",
 "pending_ts" : 0
 }
 ],
 "ContactID" : 0,
 "IsModel" : false,
 "DivID" : 102,
 "ColorCode" : "#002763",
 "ros" : 0,
 "cnt" : 1,
 "DivisionSkin" : "schoolprofessional.css"
 }
 */
