//
//  E-RegisterDivisionListVC.swift
//  CWA
//
//  Created by NFC User on 26/09/23.
//  Copyright © 2023 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class E_RegisterDivisionListVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var divisionSearchBar: UISearchBar!
    @IBOutlet weak var divisionTableView: UITableView!
    
    var divisionDataArray = NSMutableArray()
    var filteredDataArray = NSMutableArray()
    var isSearching = false
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        CMALocationManager.shared.requestLocationAtOnce()
        
       getDivisionListCall()
        self.view.backgroundColor = UIColor.white
        self.titlelbl.text = "E-Check In"
    }
    
    @objc override func appWillEnterForeground(){
        print("appWillEnterForeground Division")
        if divisionDataArray.count == 0{
            self.getDivisionListCall()
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        getDivisionListCall()

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(keyboardDoneBtnTapped))]
        toolBar.sizeToFit()
        
        divisionSearchBar.inputAccessoryView = toolBar
    }
    
    @objc func keyboardDoneBtnTapped(sender: UIButton)  {
        divisionSearchBar.endEditing(true)
    }
    
    //MARK: - Division List API Call
    
    func getDivisionListCall() {
        
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable{
            
            JustHUD.shared.showInView(view: (self.view)!)
            
            let username = String(format:"%@", UserDefaults.standard.string(forKey: "UserName")!)
            
            let params :[String:String] = ["Email":username]
            
            print("the parameter for echeck in div is", params)
            
            RestAPI.getListOfERegisterDivisions(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getResponse(response:))
            
        }
        else{
            
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    
    //MARK: - API Response
    
    func getResponse(response:AnyObject)->() {
        
        JustHUD.shared.hide()
        
        if response is String{
         
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
        else {
            
            let object = response as! JSON
            
            print("the Division List of E-Check in is", object) //Artel Hotel Times Square
            
            let dataArray = object.array
            divisionDataArray .removeAllObjects()
            
            for dict in dataArray! {
                
                let div = E_RegisterDivision.init(Div_ID: dict["Div_ID"].intValue, client_name: dict["client_name"].stringValue, district: dict["district"].stringValue, City:  dict["City"].stringValue, location_code: dict["location_code"].stringValue, State: dict["State"].stringValue, CodeZip: dict["CodeZip"].stringValue, Phone: dict["Phone"].stringValue, client_id: dict["client_id"].intValue, contact_id: dict["contact_id"].intValue, pending_ts: dict["pending_ts"].intValue,division: dict["division"].stringValue,comp_name: dict["comp_name"].stringValue,LogoPath: dict["LogoPath"].stringValue,ColorCode: dict["ColorCode"].stringValue,APISmallLogoPath:dict["APISmallLogoPath"].stringValue)
                
                divisionDataArray.add(div)
                divisionTableView.reloadData()
                
            }
            
        }
        
    }
    
    //MARK: - Table View
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if isSearching == true {
            return filteredDataArray.count
        }

        return divisionDataArray.count
    
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell:E_RegisterTableViewCell = tableView.dequeueReusableCell(withIdentifier: "eRegisterCellIdentifier") as! E_RegisterTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear

        var s = E_RegisterDivision.init(Div_ID: 0, client_name:"", district: "", City:"", location_code: "", State:"", CodeZip:"", Phone:"", client_id:0, contact_id:0, pending_ts: 0,division: "",comp_name: "",LogoPath: "",ColorCode:"",APISmallLogoPath: "" )
        if isSearching == true {
            s = filteredDataArray[indexPath.row] as! E_RegisterDivision

        }else{
            s = divisionDataArray[indexPath.row] as! E_RegisterDivision

        }

        let div:E_RegisterDivision = s

        let clientName = div.client_name
        
        cell.divisionName?.text = clientName
        
        let imageURLString = div.APISmallLogoPath
        
        let imageURL = URL(string:imageURLString!)
        
        cell.divisionLogo?.sd_setImage(with: imageURL, placeholderImage: UIImage.init(named: "eCheckin"), options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            
            // ImagePlaceholder
            if image != nil {
                
                cell.divisionLogo?.image = image
            }
        })
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var s = E_RegisterDivision.init(Div_ID: 0, client_name:"", district: "", City:"", location_code: "", State:"", CodeZip:"", Phone:"", client_id:0, contact_id:0, pending_ts: 0,division: "",comp_name: "",LogoPath: "",ColorCode:"",APISmallLogoPath: "" )
        if isSearching == true {
            s = filteredDataArray[indexPath.row] as! E_RegisterDivision

        }else{
            s = divisionDataArray[indexPath.row] as! E_RegisterDivision

        }
        
        let div:E_RegisterDivision = s
        
        let contactID = div.contact_id
        let clientID = div.client_id
        
        UserDefaults.standard.set(clientID, forKey: "E_CheckInClientID")
        UserDefaults.standard.set(contactID, forKey: "E_CheckInContactID")
        
        var isControllerExists = false
        var tabVC = E_RegisterTabVC()
        
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is E_RegisterTabVC {
                    print("Your controller exist")
                    tabVC = viewController as! E_RegisterTabVC
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "E_RegisterTabSegue") as! E_RegisterTabVC
            
            nextViewController.selectedDivisionContactID = div.contact_id!
            nextViewController.selectedDivisionClientID = div.client_id!
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }else{
            tabVC.selectedDivisionContactID = div.contact_id!
            tabVC.selectedDivisionClientID = div.client_id!
            tabVC.isFromDivisionPage = true
            self.navigationController?.popToViewController(tabVC, animated: true)
        }
    
    }
    
    //MARK: - UISearch Bar
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        searchBar.endEditing(false)
        
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        isSearching = true
        
        filteredDataArray.removeAllObjects()
        if searchText.count > 0
        {
            var found = false
   
            for div in divisionDataArray{
                
                let  divObj:E_RegisterDivision = div as! E_RegisterDivision
                var servicename = ""
                let clientName = divObj.client_name

                servicename = (clientName?.lowercased())!
                
                let searchString = searchText.lowercased()
                
                found = (servicename.contains(searchString)) || (servicename.caseInsensitiveCompare(searchString) == ComparisonResult.orderedSame)
                
                
                if found {
                    filteredDataArray.add(divObj)
                }
                else{

                }
            }
        }
        else
        {
            isSearching = false
            searchBar.endEditing(true)
            
        }
        divisionTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        isSearching = false
        searchBar.endEditing(true)
        
    }
    
}
