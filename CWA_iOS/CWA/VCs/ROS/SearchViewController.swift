//
//  SearchViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 04/12/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

@objc protocol searchEmpDelegate: class{
    
    func selecetdEmployee(_ emps: NSMutableArray)
}

@objc protocol DOESelectLocationDelegate: class{
    
    func selectedLocation(_ emps: DOELocation)
}
class SearchViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonView: UIView!
    
    @IBOutlet weak var TableHeaderView: UIView!
    @IBOutlet weak var HeaderTitleLbl: UILabel!
    
    @IBOutlet weak var empListTableView: UITableView!
    var empDataArray = NSMutableArray()
    var selectedEmpDataArray = NSMutableArray()
    weak var delegate: searchEmpDelegate? = nil
    weak var DOEdelegate: DOESelectLocationDelegate? = nil
    
    var isSearching = false
    @IBOutlet weak var empSearchBar: UISearchBar!
    var filteredDataArray = NSMutableArray()
    var DOE_Search_Loc_Dict = NSDictionary()
    
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var noDataView: UIView!
    
    var isForSchoolProfessional = false
    var isForHospitality = false
    var isForOffice = false
    var isForOCC = false
    var isFOrHealthCare = false
    var isForDOESearchLoc = false
    var isHosOTAlert = false
    var isHosOTSelIndexPath = NSIndexPath()
    var Hos_Header_title = ""
    var isFav = Int()
    var selectedRow = Int()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titlelbl.text = "Search Employee"
        if isForDOESearchLoc == true {
            self.titlelbl.text = "Search Locations"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isForDOESearchLoc == true {
            tableBottomConstraint.constant = 0
            buttonView.isHidden = true
            self.view.layoutIfNeeded()
        }
        
        if Hos_Header_title.count > 0 && (isForHospitality == true || isFOrHealthCare == true){
            TableHeaderView.backgroundColor = UIColor(hexString:danger_background_Color)
            HeaderTitleLbl.textColor = UIColor(hexString:danger_Color)
            
            
            let height =  Hos_Header_title.heightWithConstrainedWidth(width: UIScreen.main.bounds.size.width - 30, font: UIFont.boldSystemFont(ofSize: 15))  //self.sizeOfString(string: message, constrainedToHeight: Double.greatestFiniteMagnitude).height + 80
            
            
            var headerFrame = TableHeaderView.frame
            headerFrame.size.height = height
            TableHeaderView.frame = headerFrame
            empListTableView.tableHeaderView = TableHeaderView
            
            HeaderTitleLbl.text = Hos_Header_title
            TableHeaderView.isHidden = false
        }else{
            var headerFrame = TableHeaderView.frame
            headerFrame.size.height = 0
            TableHeaderView.frame = headerFrame
            empListTableView.tableHeaderView = TableHeaderView
            TableHeaderView.isHidden = true
        }
        
        empListTableView.tableFooterView = UIView()
        //        self.title = "Employee Roster"
        empSearchBar.barTintColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        let textFieldInsideUISearchBar = empSearchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.borderStyle = .none
        textFieldInsideUISearchBar?.backgroundColor = UIColor.white
        noDataView.backgroundColor = UIColor(hexString:warning_background_Color)
        lblNoData.textColor = UIColor(hexString:warning_Color)
        
        if empDataArray.count > 0{
            //add the emp obj which are selecetd to selectedEmpArray
            selectedEmpDataArray.removeAllObjects()
            
            for emp in empDataArray {
                
                let  empObj:NewEmployee = emp as! NewEmployee
                if empObj.isCheckedInRoaster == "1"{
                    if selectedEmpDataArray.contains(empObj){}else{
                        selectedEmpDataArray.add(empObj)}
                }else{
                    selectedEmpDataArray.remove(empObj)
                }
                
            }
        }
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func goBack() {
        for emp in selectedEmpDataArray {
            
            let  empObj:NewEmployee = emp as! NewEmployee
            
            empObj.isCheckedInRoaster = "0"
            empObj.isSelected = "0"
            selectedEmpDataArray.remove(empObj)
            
        }
        
        
        selectedEmpDataArray.removeAllObjects()
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func cancelButtonTapped(_ sender: UIButton){
        
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func selectButtonTapped(_ sender: UIButton){
        
        let tempArray = NSMutableArray()
        if selectedEmpDataArray.count > 0{
            for emp in selectedEmpDataArray {
                
                let  empObj:NewEmployee = emp as! NewEmployee
                
                empObj.isCheckedInRoaster = "1"
                //                empObj.isSelected = "1"
                tempArray.add(empObj)
                
            }
            delegate?.selecetdEmployee(tempArray)
            
            self.navigationController?.popViewController(animated: true)
        }else{
            //            self.ShowAlertMessage(message: "Please select candidate before submitting.", title: "")
            
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: "Please select candidate before submitting.", okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
        
    }
    
    @IBAction func searchHistoryButtonTapped(_ sender: UIButton){
        
        let senderPosition  = sender.convert(CGPoint.zero, to: empListTableView)
        
        let indexPath =  empListTableView.indexPathForRow(at:senderPosition)
        
        self.showEmpHistoryDetails(indexPath: indexPath! as NSIndexPath)
        
    }
    
    @IBAction func DOESelectButtonTapped(_ sender: UIButton){
        
        let senderPosition  = sender.convert(CGPoint.zero, to: empListTableView)
        
        let indexPath =  empListTableView.indexPathForRow(at:senderPosition)
        
        let Location = empDataArray[(indexPath?.row)!] as! DOELocation
        
        //selectedLocation
        DOEdelegate?.selectedLocation(Location)
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func checkButtonTapped(_ sender: UIButton){
        
        let senderPosition  = sender.convert(CGPoint.zero, to: empListTableView)
        
        let indexPath =  empListTableView.indexPathForRow(at:senderPosition)
        var empObj = NewEmployee.init(CandidateId: 0, Name: "", lastDate: "", Weekly_Hours: "", positions: "", Eval: "", YTD_Hours: "", isCheckedInRoaster:  "0",isSelected: "0",Photo: "",Evaluation: 0,DummyImagePath:"",isfavourite:0,favColor:"")
        
        if isSearching == true {
            empObj = filteredDataArray[(indexPath?.row)!] as! NewEmployee
        }else{
            empObj = empDataArray[(indexPath?.row)!] as! NewEmployee
        }
        
        if isForHospitality == true || isFOrHealthCare == true{
            var empObj = NewEmployee.init(CandidateId: 0, Name: "", lastDate: "", Weekly_Hours: "", positions: "", Eval: "", YTD_Hours: "", isCheckedInRoaster:  "0",isSelected: "0",Photo: "",Evaluation: 0,DummyImagePath:"",ShowOT : "0",OTNote : "", IsSpreadOfHour : "",MessageSpreadofHours : "",isfavourite:0,favColor:"")
            if isSearching == true {
                empObj = filteredDataArray[(indexPath?.row)!] as! NewEmployee
            }else{
                empObj = empDataArray[(indexPath?.row)!] as! NewEmployee
            }
            if ((empObj.ShowOT == "1" || empObj.ShowOT == "True") && empObj.IsSpreadOfHour == "1") && empObj.isCheckedInRoaster == "0"{
                isHosOTSelIndexPath = indexPath! as NSIndexPath
                isHosOTAlert = true
                let OTmessage = empObj.OTNote
                let speardOfHoursMessage = empObj.MessageSpreadofHours
                let message = String(format:"%@\n\n%@",OTmessage!,speardOfHoursMessage!)
                if OTmessage!.count > 0 || speardOfHoursMessage!.count > 0{
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "Cancel", type: Danger_Text, isAttributed: false)
                }
                
            }else if ((empObj.ShowOT == "1" || empObj.ShowOT == "True") && empObj.IsSpreadOfHour != "1") && empObj.isCheckedInRoaster == "0"{
                isHosOTSelIndexPath = indexPath! as NSIndexPath
                isHosOTAlert = true
                
                if empObj.OTNote!.count > 0{
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: empObj.OTNote!, okBtnTitle: "OK", cancelBtnTitle: "Cancel", type: Danger_Text, isAttributed: false)
                }
                
            }else if (!(empObj.ShowOT == "1" || empObj.ShowOT == "True") && empObj.IsSpreadOfHour == "1") && empObj.isCheckedInRoaster == "0"{
                isHosOTSelIndexPath = indexPath! as NSIndexPath
                isHosOTAlert = true
                if empObj.MessageSpreadofHours!.count > 0{
                    self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: empObj.MessageSpreadofHours!, okBtnTitle: "OK", cancelBtnTitle: "Cancel", type: Danger_Text, isAttributed: false)
                }
                
            }else{
                self.addSelectedEmp(indexPath: indexPath! as NSIndexPath, empObj: empObj)
            }
        }else{
            self.addSelectedEmp(indexPath: indexPath! as NSIndexPath, empObj: empObj)
        }
    }
    @IBAction override func okButtonTapped(_ sender: Any) {
        
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
        if isHosOTAlert == true{
            
            var empObj = NewEmployee.init(CandidateId: 0, Name: "", lastDate: "", Weekly_Hours: "", positions: "", Eval: "", YTD_Hours: "", isCheckedInRoaster:  "0",isSelected: "0",Photo: "",Evaluation: 0,DummyImagePath:"",ShowOT : "0",OTNote : "", IsSpreadOfHour : "",MessageSpreadofHours : "",isfavourite:0,favColor:"")
            if isSearching == true {
                empObj = filteredDataArray[(isHosOTSelIndexPath.row)] as! NewEmployee
            }else{
                empObj = empDataArray[(isHosOTSelIndexPath.row)] as! NewEmployee
            }
            self.addSelectedEmp(indexPath: isHosOTSelIndexPath as NSIndexPath, empObj: empObj)
        }
    }
    @IBAction override func cancelBtnTapped(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        isHosOTAlert = false
    }
    
    func addSelectedEmp(indexPath: NSIndexPath, empObj: NewEmployee){
        
        let oObj:NewEmployee = empObj
        if selectedEmpDataArray.contains(oObj){
            selectedEmpDataArray.remove(oObj)
            oObj.isCheckedInRoaster = "0"
        }else{
            selectedEmpDataArray.add(oObj)
            oObj.isCheckedInRoaster = "1"
        }
        empDataArray.replaceObject(at: (indexPath.row), with: oObj)
        self.reloadTableViewRow(RowIndexPath: indexPath as NSIndexPath)
        
    }
    func reloadTableViewRow(RowIndexPath: NSIndexPath){
        DispatchQueue.main.async(execute: { () -> Void in
            self.empListTableView.reloadRows(at: [RowIndexPath as IndexPath], with: .none)
        })
    }
    
    //MARK: TABLEVIEW DELEGATE & DATASOURCE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching == true {
            return filteredDataArray.count
        }
        return empDataArray.count
        
    }
    func DOE_CellForIndexPath(indexPath: IndexPath,Identifier: String) -> SearchTableViewCell {
        let cell:SearchTableViewCell = empListTableView.dequeueReusableCell(withIdentifier: Identifier ) as! SearchTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if isForDOESearchLoc{
            
            var  locObj = DOELocation.init(LocationId: "", City: "", State: "", Zip: "", LocationDescription: "", StreetAddress: "", isJson: "", LocationCode: "")
            
            if isSearching == true {
                locObj = filteredDataArray[indexPath.row] as! DOELocation
            }else{
                locObj = empDataArray[indexPath.row] as! DOELocation
            }
            
            cell.lblNameValue.text = locObj.LocationCode
            cell.lblEval.text = locObj.LocationDescription
            cell.lblYTDHRValue.text = locObj.StreetAddress
            cell.lblSubjectValue.text = locObj.City
            cell.lblDateValue.text = locObj.State
            cell.lblPositionvalue.text = locObj.Zip
            
            cell.searchHistoryButton.removeTarget(self, action:#selector(self.DOESelectButtonTapped), for: .touchUpInside)
            cell.searchHistoryButton.addTarget(self, action:#selector(self.DOESelectButtonTapped), for: .touchUpInside)
            
            
        }
        return cell
    }
    
    func HOS_NewCellForEmployeeWithIndexPath(indexPath: IndexPath,Identifier: String) -> EmpEvaluationTableViewCell {
        let cell:EmpEvaluationTableViewCell = empListTableView.dequeueReusableCell(withIdentifier: Identifier ) as! EmpEvaluationTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        var emp = NewEmployee.init(CandidateId: 0, Name: "", lastDate: "", Weekly_Hours: "", positions: "", Eval: "", YTD_Hours: "", isCheckedInRoaster:  "0",isSelected: "0",Photo: "",Evaluation: 0,DummyImagePath:"",ShowOT : "0",OTNote : "", IsSpreadOfHour : "",MessageSpreadofHours : "",isfavourite:0,favColor:"")
        
        if isSearching == true {
            emp = filteredDataArray[indexPath.row] as! NewEmployee
        }else{
            emp = empDataArray[indexPath.row] as! NewEmployee
        }
        cell.favIcon.image =  cell.favIcon.image?.withRenderingMode(.alwaysTemplate)
        if emp.isfavourite == 0
        {
            cell.favIcon.tintColor = UIColor.lightGray
        }
        else
        {
            if (emp.favColor ?? "").isEmpty
            {
                cell.favIcon.tintColor = UIColor.red
            }
            else
            {
             cell.favIcon.tintColor = UIColor(hexString:emp.favColor!)
            }
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedOnFavIcon(sender:)))
        cell.favIcon.addGestureRecognizer(tap)
        cell.favIcon.isUserInteractionEnabled = true
        
        self.updateLabelWithEmpObj(emp: emp, cell: cell)
        if emp.ShowOT == "1" || emp.ShowOT == "True" || emp.IsSpreadOfHour == "1"{
            cell.borderView.layer.borderColor = UIColor.red.cgColor
            cell.borderView.layer.borderWidth = 4
            cell.lblName.textColor = UIColor.red
            
        }else{
            cell.borderView.layer.borderColor = UIColor.clear.cgColor
            cell.lblName.textColor = UIColor.black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if  isForHospitality == false && isFOrHealthCare == false{
            
            let additionalSeparatorThickness = CGFloat(1)
            let additionalSeparator = UIView(frame: CGRect(x:0,
                                                           y:cell.frame.size.height - additionalSeparatorThickness,
                                                           width:cell.frame.size.width,
                                                           height:additionalSeparatorThickness))
            additionalSeparator.backgroundColor = UIColor.lightGray
            cell.addSubview(additionalSeparator)
        }
        
    }
    func updateLabelWithEmpObj(emp: NewEmployee, cell:EmpEvaluationTableViewCell){
        
        cell.btnShowHistory.setTitle("Work History", for: .normal)
        
        cell.lblPositionTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.lblYTDHrTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.lblWeeklyTotalTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        cell.lblLastDateWorkedTitle.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        
        cell.lblName.text = emp.Name!
        cell.lblLastDateWorkedValue.text =  emp.lastDate!
        cell.lblWeeklyTotalValue.text = emp.Weekly_Hours!
        cell.lblYTDHrValue.text = emp.YTD_Hours!
        cell.lblPositionValue.text = emp.positions!
        
        cell.floatRatingView.type = .wholeRatings
        cell.floatRatingView.backgroundColor = UIColor.clear
        
        cell.floatRatingView.isUserInteractionEnabled = false
        cell.floatRatingView.rating = round(emp.Evaluation!)
        
        cell.checkButton.addTarget(self, action:#selector(self.checkButtonTapped), for: .touchUpInside)
        cell.btnShowHistory.addTarget(self, action:#selector(self.searchHistoryButtonTapped), for: .touchUpInside)
        
        if emp.isCheckedInRoaster! == "0" {
            cell.checkButton.isSelected = false
        }else if emp.isCheckedInRoaster! == "1"{
            cell.checkButton.isSelected = true
        }
        cell.userImageView.layer.cornerRadius = cell.userImageView.frame.size.width/2
        cell.userImageView.clipsToBounds = true
        
        cell.userImageView.layer.borderColor = borderColor.cgColor
        cell.userImageView.layer.borderWidth = 5.0
        
        let imageURL = URL(string:emp.DummyImagePath!)
        
        if emp.Photo!.count == 0{
            cell.userImageView.sd_setImage(with: imageURL, placeholderImage: UIImage.init(named: "ImagePlaceholder"), options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                if image != nil {
                    cell.userImageView.image = image!
                }
                
            })
        }else{
            DispatchQueue.main.async(execute: { () -> Void in
                let decodedData = Data(base64Encoded:emp.Photo!, options: .ignoreUnknownCharacters)
                let decodedimage = UIImage(data:decodedData!)
                print(decodedimage!)
                if decodedimage != nil{
                    cell.userImageView.image = decodedimage
                }
            })
        }
        
        
        if  isFOrHealthCare == true{
            cell.btnShowHistory.isHidden = true
        }else{
            cell.btnShowHistory.isHidden = false
        }
        
        let ScreenWidth = UIScreen.main.bounds.size.width
        if ScreenWidth > 375{
            cell.userImageViewTopConstraint.constant = 10
        }else{
            cell.userImageViewTopConstraint.constant = 31
        }
        cell.layoutIfNeeded()
        
        
    }
    
    func NewCellForEmployeeWithIndexPath(indexPath: IndexPath,Identifier: String) -> EmpEvaluationTableViewCell {
        let cell:EmpEvaluationTableViewCell = empListTableView.dequeueReusableCell(withIdentifier: Identifier ) as! EmpEvaluationTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        var emp = NewEmployee.init(CandidateId: 0, Name: "", lastDate: "", Weekly_Hours: "", positions: "", Eval: "", YTD_Hours: "", isCheckedInRoaster:  "0",isSelected: "0",Photo: "",Evaluation: 0,DummyImagePath:"",isfavourite:0,favColor:"")
        if isSearching == true {
            emp = filteredDataArray[indexPath.row] as! NewEmployee
        }else{
            emp = empDataArray[indexPath.row] as! NewEmployee
        }
        cell.favIcon.image =  cell.favIcon.image?.withRenderingMode(.alwaysTemplate)

        if emp.isfavourite == 0
        {
             cell.favIcon.tintColor = UIColor.lightGray
        }
        else
        {
            if (emp.favColor ?? "").isEmpty
            {
                cell.favIcon.tintColor = UIColor.red
            }
            else
            {
                cell.favIcon.tintColor = UIColor(hexString:emp.favColor!)
            }
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedOnFavIcon(sender:)))
        cell.favIcon.addGestureRecognizer(tap)
        cell.favIcon.isUserInteractionEnabled = true
        
        self.updateLabelWithEmpObj(emp: emp, cell: cell)
        
        return cell
    }
    
    @objc func tappedOnFavIcon(sender:UITapGestureRecognizer)
    {
        let location = sender.location(in: empListTableView)
        let indexPath = empListTableView.indexPathForRow(at: location)
        var emp = NewEmployee.init(CandidateId: 0, Name: "", lastDate: "", Weekly_Hours: "", positions: "", Eval: "", YTD_Hours: "", isCheckedInRoaster:  "0",isSelected: "0",Photo: "",Evaluation: 0,DummyImagePath:"",isfavourite:0,favColor:"")
        if isSearching == true {
            emp = filteredDataArray[indexPath!.row] as! NewEmployee
        }else{
            emp = empDataArray[indexPath!.row] as! NewEmployee
        }
        if emp.isfavourite == 0
        {
            isFav = 1
        }
        else
        {
            isFav = 0
        }
        fav_unfav_candidate(candidateID:emp.CandidateId!, isFav:isFav, row:indexPath!.row)
    }
    
    //this method selects or unselects the candidate for making him fav or unfav
    func fav_unfav_candidate(candidateID:Int,isFav:Int,row:Int)
    {
        let isInternetAvailable =  self.isInternetAvailable()
        //
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            selectedRow = row
            let defaults = UserDefaults.standard
            
            //let clientID = String(format:"%d", defaults.integer(forKey: "ClientID"))
            let ContactId = String(format:"%d", defaults.integer(forKey:"ContactId"))
            let params   = ["ContactId":ContactId,"CandidateId":candidateID,"Isfavourite":isFav,"OSSource":"iOS"] as [String : Any] as NSDictionary
            print(params)
            let urlString = RestAPI.BaseUrl+RestAPI.Fav_UnFav_Candidate
            RestAPI.postRequestWithToken(urlString: urlString, params: params, callback: getResponseForFavUnFav(response:))
            
        }else{
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
        }
    }
    
    func getResponseForFavUnFav(response:AnyObject)->()
    {
        JustHUD.shared.hide()
        self.navigationController?.view.hideAllToasts()
        
        print(response)
        if response is String{
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            let object = response as! JSON
            print(object)
            if object["MessageStatus"].intValue == 1
            {
                var emp = NewEmployee.init(CandidateId: 0, Name: "", lastDate: "", Weekly_Hours: "", positions: "", Eval: "", YTD_Hours: "", isCheckedInRoaster:  "0",isSelected: "0",Photo: "",Evaluation: 0,DummyImagePath:"",isfavourite:0,favColor:"")
                if isSearching == true {
                    emp = filteredDataArray[selectedRow] as! NewEmployee
                }else{
                    emp = empDataArray[selectedRow] as! NewEmployee
                }
                emp.isfavourite = isFav
                empListTableView.reloadData()
                let indexPath = IndexPath.init(row:selectedRow, section: 0)
                empListTableView.scrollToRow(at:indexPath, at:.none, animated:true)
            }
            else
            {
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    message = Error_Message
                }
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
            
            
        }
    }
    
    
    
    
    
    func colorCodeCell(indexPath: IndexPath)-> UITableViewCell {
        
        var cell = self.empListTableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?
        if !(cell != nil) {
            cell = UITableViewCell(style:.subtitle, reuseIdentifier: "CELL")
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        
        var  colorDict = NSDictionary()
        
        if isSearching == true {
            colorDict = filteredDataArray[indexPath.row] as! NSDictionary
        }else{
            colorDict = empDataArray[indexPath.row] as! NSDictionary
        }
        cell?.imageView?.image = UIImage.init(named: "transparent.png")
        cell?.imageView?.backgroundColor =  UIColor(hexString:(colorDict["color"] as? String)!)
        cell?.textLabel?.text = colorDict["Text"] as? String
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell?.imageView?.image = imageWithImage(image: (cell?.imageView?.image)!, scaledToSize: CGSize(width: 55, height: 35))
        
        return cell!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isForDOESearchLoc == true {
            return self.DOE_CellForIndexPath(indexPath: indexPath,Identifier: "DOE_SearchTableViewCellIdentifier")
            
        }else if  isForOCC == true || isForSchoolProfessional == true || isForOffice == true  {
            return self.NewCellForEmployeeWithIndexPath(indexPath: indexPath,Identifier: "EmpEvaluationTableViewCellIdentifier")
            
        }else if isForHospitality == true || isFOrHealthCare == true{
            return self.HOS_NewCellForEmployeeWithIndexPath(indexPath: indexPath,Identifier: "EmpEvaluationTableViewCellIdentifier")
        }
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isForHospitality == true || isForOCC == true || isForSchoolProfessional == true || isForOffice == true{
            
            let ScreenWidth = UIScreen.main.bounds.size.width
            if ScreenWidth > 375{
                return 290
            }
            return 310
        }
        if  isFOrHealthCare == true{
            let ScreenWidth = UIScreen.main.bounds.size.width
            if ScreenWidth > 375{
                return 250
            }
            return 270
        }
        return  0
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        
        //        self.showEmpHistoryDetails(indexPath: indexPath as NSIndexPath)
    }
    
    func showEmpHistoryDetails(indexPath: NSIndexPath){
        
        if isForHospitality == true || isForOffice || isForSchoolProfessional == true || isForOCC == true || isFOrHealthCare == true{
            var emp = NewEmployee.init(CandidateId: 0, Name: "", lastDate: "", Weekly_Hours: "", positions: "", Eval: "", YTD_Hours: "", isCheckedInRoaster:  "0",isSelected: "0",Photo: "",Evaluation: 0,DummyImagePath:"",isfavourite:0,favColor:"")
            if isSearching == true {
                emp = filteredDataArray[indexPath.row] as! NewEmployee
                
            }else{
                emp = empDataArray[indexPath.row] as! NewEmployee
                
            }
            //Push to Emp History
            let candidateid = String(format:"%d",emp.CandidateId!)
            
            self.pushToSearchEmpListPage(CandidateId: candidateid , empName : emp.Name! , empSchool : emp.positions!)
        }
        
        
    }
    
    
    //MARK: Navigation Methods
    
    func pushToSearchEmpListPage(CandidateId : String,empName : String,empSchool : String){
        var isControllerExists = false
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is EmpHistoryViewController {
                    print("Your controller exist")
                    isControllerExists = true
                    break
                }
            }
        }
        if isControllerExists == false{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EmpHistorySegue") as! EmpHistoryViewController
            
            nextViewController.CandidateId = CandidateId
            
            nextViewController.empName = empName
            nextViewController.empSchool = empSchool
            nextViewController.isForOffice = isForOffice
            nextViewController.isForHospitality = isForHospitality
            nextViewController.isForSchoolProfessional = isForSchoolProfessional
            nextViewController.isForOCC = isForOCC
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    
    //MARK: - UISEARCHBAR DELEGATE METHODS
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        //        isSearching = false
        
        searchBar.endEditing(false)
        if isForDOESearchLoc == true{
            self.getSearchLocationCodeDetailsData(LocCode: searchBar.text!)
        }
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) // called when text changes (including clear)
    {
        if isForDOESearchLoc == true{
            
        }else{
            isSearching = true
            
            //////////////////**********************SEARCH**********///////////////
            
            filteredDataArray.removeAllObjects()
            if searchText.count > 0
            {
                var found = false
                
                
                for empObj in empDataArray{
                    
                    if isForHospitality || isForOffice || isForSchoolProfessional || isForOCC{
                        let  emp:NewEmployee = empObj as! NewEmployee
                        let empName =   (emp.Name?.lowercased())!+(emp.lastDate?.lowercased())!
                        
                        let searchString = searchText.lowercased()
                        
                        found = (empName.contains(searchString)) || (empName.caseInsensitiveCompare(searchString) == ComparisonResult.orderedSame)
                        
                        if found {
                            filteredDataArray.add(emp)
                        }
                    } else if isFOrHealthCare{
                        if empObj is HealthCareEmployee{
                            let  emp:HealthCareEmployee = empObj as! HealthCareEmployee
                            
                            let empName =   (emp.Name?.lowercased())!+(emp.LastPosition?.lowercased())!+(emp.ERating?.lowercased())!+(emp.WeeklyHours?.lowercased())!
                            
                            let searchString = searchText.lowercased()
                            
                            found = (empName.contains(searchString)) || (empName.caseInsensitiveCompare(searchString) == ComparisonResult.orderedSame)
                            
                            if found {
                                filteredDataArray.add(emp)
                            }
                        }
                    }
                }
            }
            else
            {
                isSearching = false
                searchBar.endEditing(true)
                
            }
            empListTableView.reloadData()
        }
        /////////////////////******** END OF SEARCH *********//////
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) // called when cancel button pressed
    {
        isSearching = false
        searchBar.endEditing(true)
        
    }
    
    //MARK: Server Call
    
    func getSearchLocationCodeDetailsData(LocCode: String) {
        let isInternetAvailable = self.isInternetAvailable()
        
        if isInternetAvailable {
            JustHUD.shared.showInView(view: view)
            
            let params :[String:String] = ["LocationCode":LocCode]
            
            print(params)
            
            RestAPI.getDOESearchLocationCodeDetailsData(self, params: params, method: "POST", accessToken: "", acces: true, callBack: getSearchLocationCodeDetailsResponse(response:))
        }else{
            self.showCustomAlert(Title: InternetConnectionTitle, attMessage: NSAttributedString(), message: InternetConnectionMessage, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }
        
    }
    func getSearchLocationCodeDetailsResponse(response:AnyObject)->()
    {
        JustHUD.shared.hide()
        isSearching = false
        empDataArray.removeAllObjects()
        
        print(response)
        if response is String{
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            if object["MessageStatus"].intValue == 1
            {
                let locList = object["DoeLocationList"].array
                for dict in locList!{
                    let loc = DOELocation.init(LocationId: dict["LocationId"].stringValue, City: dict["City"].stringValue.trimmingCharacters(in: .whitespacesAndNewlines), State: dict["State"].stringValue, Zip: dict["Zip"].stringValue, LocationDescription: dict["LocationDescription"].stringValue, StreetAddress: dict["StreetAddress"].stringValue, isJson: dict["isJson"].stringValue, LocationCode: dict["LocationCode"].stringValue)
                    empDataArray.add(loc)
                }
                
                self.empListTableView.reloadData()
                
            }else{
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: object["Message"].stringValue, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
                
            }
        }
        self.empListTableView.reloadData()
        
    }
    
}
