//
//  ROSOrderSummaryViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 09/12/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit
import SwiftyJSON

@objc protocol SummaryDelegate: class{
    
    func createNewOrderFromSummary()
}

class ROSOrderSummaryViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var summaryTableView: UITableView!
    @IBOutlet weak var createOrderButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblHeader: UILabel!
    var dropDownView = UIView()
    var  alertDropDownTableView = UITableView()
    
    let HC_WeekEndingTblViewTag = 1009
    var selectedWeekEnd = ""
    //HOS VIEWS///
    
    @IBOutlet weak var HOS_button_View: UIView!
    
    ////END.////
    var summaryObj = NSDictionary()
    var summaryDataArray = NSMutableArray()
    var HC_weekendingList = NSMutableArray()
    var summaryJSON = NSDictionary()
    var status = "New"
    var HOS_CREATE_ORDER_FLAG = false
    var SCHOOL_CREATE_ORDER_FLAG = false
    var OFFICE_CREATE_ORDER_FLAG = false
    var OCC_CREATE_ORDER_FLAG = false
    var HC_CREATE_ORDER_FLAG = false
    
    weak var delegate: SummaryDelegate? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titlelbl.text = "Order Summary"
        if HC_CREATE_ORDER_FLAG == true{
            self.createOrderButton.setTitle("Place Order", for: .normal)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateHeader(message:"")
        
        summaryTableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    func showLeftBarButtons(){
        let backButton = UIBarButtonItem.init(customView: self.backButton())
        //        let dashboardButton = UIBarButtonItem.init(customView: self.dashboardButton())
        self.navigationItem.leftBarButtonItem = backButton//[dashboardButton,backButton]
        self.titlelbl.frame = CGRect(x: 85, y: 0, width: UIScreen.main.bounds.width - 140, height: 44)
        
    }
    func dashboardButton() -> UIButton {
        let bBtn = UIButton()
        
        bBtn.frame = CGRect(x:0,y:0,width: 30,height:30)
        bBtn.setImage(UIImage.init(named: "Dashboard"),for:.normal)
        bBtn.addTarget(self, action:#selector(self.DashboardTapped), for: .touchUpInside)
        
        return bBtn
        
    }
    
    override func backButton()  -> UIButton {
        let bBtn = UIButton()
        
        bBtn.frame = CGRect(x:0,y:0,width: 30,height:30)
        bBtn.setImage(UIImage.init(named: "Back.png"),for:.normal)
        
        bBtn.addTarget(self, action:#selector(self.goBack), for: .touchUpInside)
        
        return bBtn
        
    }
    @objc   func DashboardTapped()
    {
        self.popToDasboardPage()
    }
    func popToDasboardPage(){
        
        
        
        var isControllerExists = false
        
        var dashboardVC = UIViewController()
        
        if let viewControllers = self.navigationController?.viewControllers {
            
            for viewController in viewControllers {
                
                if viewController is DashboardViewController {
                    print("Your controller exist")
                    dashboardVC = viewController
                    
                    isControllerExists = true
                    break
                }
            }
            
        }
        
        if isControllerExists {
            
            self.navigationController?.popToViewController(dashboardVC, animated: true)
            
        }else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DashboardSegue") as! DashboardViewController
            nextViewController.isFromDivisionPage = false
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
    }
    override   func goBack()
    {
        if status == "New"{
            
            self.navigationController?.popViewController(animated: true)
        }else{
            
            self.popToDasboardPage()
            
            //
            //            delegate?.createNewOrderFromSummary()
            //
            //            self.navigationController?.popViewController(animated: true)
        }
        
    }
    func updateHeader(message: String){
        lblHeader.backgroundColor = UIColor.clear
        if status == "New"{
            lblHeader.text = "Please review for accuracy prior to submission.\nIf you wish to change anything before submitting your order, click on the Back arrow on top of the screen."
            headerView.backgroundColor = UIColor(hexString:info_background_Color)
            lblHeader.textColor = UIColor(hexString:info_Color)
            
        }else{
            self.showLeftBarButtons()
            lblHeader.text = message
            headerView.backgroundColor = UIColor(hexString:success_background_Color)
            lblHeader.textColor = UIColor(hexString:success_Color)
            if HOS_CREATE_ORDER_FLAG == true{
                HOS_button_View.isHidden = false
                createOrderButton.isHidden = true
            }else if SCHOOL_CREATE_ORDER_FLAG == true || OCC_CREATE_ORDER_FLAG == true {
                HOS_button_View.isHidden = true
                createOrderButton.isHidden = false
                createOrderButton.setTitle("New Order", for: .normal)
            }else if OFFICE_CREATE_ORDER_FLAG == true{
                HOS_button_View.isHidden = true
                createOrderButton.isHidden = false
                createOrderButton.setTitle("Add New Order", for: .normal)
                
            }else if HC_CREATE_ORDER_FLAG == true{
                HOS_button_View.isHidden = true
                createOrderButton.isHidden = false
                createOrderButton.setTitle("New Order", for: .normal)
                
            }
        }
    }
    
    //MARK: BTN ACTION METHODS
    @IBAction func addPositionBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func newEventBtnTapped(_ sender: Any) {
        delegate?.createNewOrderFromSummary()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func createOrderBtnTapped(_ sender: Any) {
        if status == "New"{
            if HOS_CREATE_ORDER_FLAG == true{
                
                self.HOSCreateOrderData()
                
            }else if SCHOOL_CREATE_ORDER_FLAG == true {
                
                self.createOrderServerCall(param: summaryObj, callBack: getResponseForCreateOrder(response:))
                
            }else if OFFICE_CREATE_ORDER_FLAG == true{
                self.OfficeCreateOrderAPI()
            }else if OCC_CREATE_ORDER_FLAG == true{
                self.OCCCreateOrderAPI()
            }else if HC_CREATE_ORDER_FLAG == true{
                self.HCCreateOrderAPI()
            }
        }else{
            delegate?.createNewOrderFromSummary()
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TABLEVIEW DELEGATE & DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == HC_WeekEndingTblViewTag{
            return HC_weekendingList.count
        }
        return summaryDataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == HC_WeekEndingTblViewTag{
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?
            if !(cell != nil) {
                cell = UITableViewCell(style:.subtitle, reuseIdentifier: "CELL")
            }
            
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            cell?.textLabel?.text = (HC_weekendingList[indexPath.row] as! String)
            
            return cell!
            
        }
        let dict = summaryDataArray[indexPath.row] as? NSDictionary
        let header = dict!["Header"] as! String
        if HC_CREATE_ORDER_FLAG == true && header == "Week Ending"{
            return self.TextFieldCell(dataDict: NSDictionary(), indexPath: indexPath as NSIndexPath)
        }
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?
        if !(cell != nil) {
            cell = UITableViewCell(style:.subtitle, reuseIdentifier: "CELL")
        }
        
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let value = dict!["Value"] as! String
        
        cell?.textLabel?.text = header
        cell?.detailTextLabel?.text = value
        cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        
        cell?.textLabel?.numberOfLines = 0
        cell?.detailTextLabel?.numberOfLines = 0
        let modelName = UIDevice.current.modelName
        if modelName.contains("iPad") {
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
            cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        }
        
        if HC_CREATE_ORDER_FLAG == true  {
            let value = dict!["Value"] as! String
            
            cell?.detailTextLabel?.text = value
            
            var changeText = ""
            let attribute = NSMutableAttributedString.init(string: header)
            let strNumber: NSString = header as NSString
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
            
            if header.contains("Comments") || header == "Report To"{
                cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
                
            }else{
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
                
                if header.contains("Start Date"){
                    changeText = "Start Date"
                    let range = (strNumber).range(of: changeText)
                    attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15) , range: range)
                    
                }
                if header.contains("End Date") {
                    changeText = "End Date"
                    let range = (strNumber).range(of: changeText)
                    attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15) , range: range)
                    
                }
                if header.contains("Monday") {
                    changeText = "Monday"
                    let range = (strNumber).range(of: changeText)
                    attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15) , range: range)
                }
                if header.contains("Saturday") {
                    changeText = "Saturday"
                    let range = (strNumber).range(of: changeText)
                    attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15) , range: range)
                }
                if header.contains("Friday") {
                    changeText = "Friday"
                    let range = (strNumber).range(of: changeText)
                    attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15) , range: range)
                }
                if header.contains("Thursday") {
                    changeText = "Thursday"
                    let range = (strNumber).range(of: changeText)
                    attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15) , range: range)
                }
                if header.contains("Wednesday") {
                    changeText = "Wednesday"
                    let range = (strNumber).range(of: changeText)
                    attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15) , range: range)
                }
                if header.contains("Tuesday") {
                    changeText = "Tuesday"
                    let range = (strNumber).range(of: changeText)
                    attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15) , range: range)
                }
                if header.contains("Sunday") {
                    changeText = "Sunday"
                    let range = (strNumber).range(of: changeText)
                    attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15) , range: range)
                }
                if header.contains("Start Time") {
                    changeText = "Start Time"
                    let range = (strNumber).range(of: changeText)
                    attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15) , range: range)
                    
                }
                if header.contains("End Time") {
                    changeText = "End Time"
                    let range = (strNumber).range(of: changeText)
                    attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15) , range: range)
                    
                }
                if header.contains("Employees Needed") {
                    changeText = "Employees Needed"
                    let range = (strNumber).range(of: changeText)
                    attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15) , range: range)
                    
                }
                if header.contains("Requested Employees") {
                    changeText = "Requested Employees"
                    let range = (strNumber).range(of: changeText)
                    attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15) , range: range)
                }
                if header.contains("Position") {
                    changeText = "Position"
                    let range = (strNumber).range(of: changeText)
                    attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15) , range: range)
                }
                
                
                cell?.textLabel?.attributedText = attribute
            }
            
        }
        return cell!
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == HC_WeekEndingTblViewTag{
            return 44
        }
        let dict = summaryDataArray[indexPath.row] as? NSDictionary
        let header = dict!["Header"] as! String
        let value = dict!["Value"] as! String
        
        if HC_CREATE_ORDER_FLAG == true && header == "Week Ending"{
            return 70
        }
        
        let message = String(format:"%@\n\n%@",header,value)
        let modelName = UIDevice.current.modelName
        var font = 13
        if modelName.contains("iPad") {
            font = 16
        }
        if HC_CREATE_ORDER_FLAG == true && header != "Week Ending" {
            font = 16
        }
        let height =  message.heightWithConstrainedWidth(width: UIScreen.main.bounds.size.width - 10, font: UIFont.boldSystemFont(ofSize: CGFloat(font)))
        
        return max(44, height)
        
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if tableView.tag == HC_WeekEndingTblViewTag{
            
            selectedWeekEnd = (HC_weekendingList[indexPath.row] as? String)!
            self.summaryTableView.reloadData()
            self.removeDropDown()
        }
    }
    
    func TextFieldCell(dataDict: NSDictionary,indexPath: NSIndexPath) -> TextFieldTableViewCell {
        
        let cell:TextFieldTableViewCell = summaryTableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCellIdentifier") as! TextFieldTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        
        cell.entryTextField.delegate = self
        cell.entryTextField.text = selectedWeekEnd
        self.addRightImageToTextField(textField: cell.entryTextField, imageName: "expand-arrow")
        
        return cell
    }
    
    func addRightImageToTextField(textField: UITextField,imageName: String ){
        
        let imageView = UIImageView.init(frame: CGRect(x:0,y:0,width:20,height:20));
        let image = UIImage(named: imageName);
        imageView.image = image;
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        textField.rightView = imageView;
        textField.rightViewMode = UITextField.ViewMode.always
        textField.rightViewMode = .always
        
    }
    
    //    func popToDasboardPage(){
    //
    //
    //        //check if LaunchViewController is there on stack or not ,if present pop else push
    //
    //        var isControllerExists = false
    //
    //        var dashboardVC = UIViewController()
    //
    //        if let viewControllers = self.navigationController?.viewControllers {
    //
    //            for viewController in viewControllers {
    //
    //                if viewController is DashboardViewController {
    //                    print("Your controller exist")
    //                    dashboardVC = viewController
    //
    //                    isControllerExists = true
    //                    break
    //                }
    //            }
    //
    //        }
    //
    //        if isControllerExists {
    //
    //            self.navigationController?.popToViewController(dashboardVC, animated: true)
    //
    //        }else{
    //            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    //
    //            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DashboardSegue") as! DashboardViewController
    //
    //            self.navigationController?.pushViewController(nextViewController, animated: true)
    //
    //        }
    //    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func HOSCreateOrderData(){
        
        
        let urlString = RestAPI.BaseUrl+RestAPI.ROSHospitalityCreateOrderURL
        JustHUD.shared.showInView(view: view)
        print(summaryJSON)
        print(self.summaryObj)
        RestAPI.postRequestWithToken(urlString: urlString, params: self.summaryObj, callback: getResponseForCreateOrder(response:))
        
    }
    func OfficeCreateOrderAPI(){
        
        
        let urlString = RestAPI.BaseUrl+RestAPI.ROSOfficleCreateOrderURL
        JustHUD.shared.showInView(view: view)
        print(self.summaryObj)
        RestAPI.postRequestWithToken(urlString: urlString, params: self.summaryObj, callback: getResponseForCreateOrder(response:))
        
    }
    func OCCCreateOrderAPI(){
        
        
        let urlString = RestAPI.BaseUrl+RestAPI.OCCCreateOrderURL
        JustHUD.shared.showInView(view: view)
        print(self.summaryObj)
        
        RestAPI.postRequestWithToken(urlString: urlString, params: self.summaryObj, callback: getResponseForCreateOrder(response:))
        
    }
    func HCCreateOrderAPI(){
        let urlString = RestAPI.BaseUrl+RestAPI.HC_CreateOrderURL
        JustHUD.shared.showInView(view: view)
        print(summaryJSON)
        
        RestAPI.postRequestWithToken(urlString: urlString, params: summaryJSON, callback: getResponseForCreateOrder(response:))
        
    }
    func createOrderServerCall(param:Any, callBack:@escaping (AnyObject)->()){
        
        let urlString = RestAPI.BaseUrl+RestAPI.createOrderForSchoolProfessionalURL
        JustHUD.shared.showInView(view: view)
        print(param)
        
        RestAPI.postRequestWithToken(urlString: urlString, params: param, callback: getResponseForCreateOrder(response:))
        
    }
    func getResponseForCreateOrder(response:AnyObject)->()
    {
        
        JustHUD.shared.hide()
        
        print(response)
        if response is String{
            //            lblNoData.isHidden = false
            //            self.ShowAlertMessage(message: response as! String, title: "")
            self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: response as! String, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            
        }else{
            
            var object = response as! JSON
            
            if object["MessageStatus"].intValue == 1
            {
                
                status = "Done"
                
                if HOS_CREATE_ORDER_FLAG == true{
                    self.updateHeader(message:  object["OrderSummary"].stringValue)
                    
                }else if SCHOOL_CREATE_ORDER_FLAG == true{
                    self.updateHeader(message:  object["Message"].stringValue)
                    
                }else if OFFICE_CREATE_ORDER_FLAG == true{
                    self.updateHeader(message:  object["Message"].stringValue)
                    
                }else if OCC_CREATE_ORDER_FLAG == true{
                    self.updateHeader(message:  object["OrderId"].stringValue)
                    
                }else if HC_CREATE_ORDER_FLAG == true{
                    self.updateHeader(message:  object["Message"].stringValue)
                    
                }
                
            }else{
                
                var message = object["Message"].stringValue
                
                if message.count == 0 {
                    
                    message = Error_Message
                    
                }
                
                self.showCustomAlert(Title: "", attMessage: NSAttributedString(), message: message, okBtnTitle: "OK", cancelBtnTitle: "", type: Danger_Text, isAttributed: false)
            }
            
        }
        
    }
    
    //MARK: TextField Delegate
    public func textFieldDidEndEditing(_ textField: UITextField){
        
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        
        return true
        
    }
    public func textFieldDidBeginEditing(_ textField: UITextField){
        textField.resignFirstResponder()
        self.showDropDownTableViewWithTag(placeHolder: "Week Ending", tag: HC_WeekEndingTblViewTag)
        
    }
    
    func showDropDownTableViewWithTag( placeHolder: String,tag: Int){
        
        for view in dropDownView.subviews {
            view.removeFromSuperview()
        }
        dropDownView.frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        dropDownView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        let clearView = UIView()
        clearView.backgroundColor = UIColor.white
        clearView.layer.borderColor = borderColor.cgColor
        clearView.layer.cornerRadius = 5
        clearView.frame =  CGRect(x: 10, y: UIScreen.main.bounds.size.height , width: UIScreen.main.bounds.size.width - 20, height: 270)
        
        let titleLabel = UILabel.init(frame: CGRect(x: 10, y: 0, width: clearView.bounds.size.width - 20, height: 40))
        titleLabel.text = placeHolder
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.darkGray
        titleLabel.backgroundColor = UIColor.clear
        clearView.addSubview(titleLabel)
        
        //UItableview
        alertDropDownTableView.tableFooterView = UIView()
        alertDropDownTableView.delegate = self
        alertDropDownTableView.dataSource = self
        alertDropDownTableView.frame = CGRect(x: 10, y: titleLabel.frame.size.height, width: clearView.bounds.size.width - 20 , height: clearView.bounds.size.height -  titleLabel.frame.size.height - 10)
        alertDropDownTableView.tag = tag
        alertDropDownTableView.backgroundColor = UIColor.white
        alertDropDownTableView.reloadData()
        clearView.addSubview(alertDropDownTableView)
        
        
        UIView.animate(withDuration: 0.5, animations: {
            
            clearView.frame =  CGRect(x: 10, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width - 20, height: 200)
            
        }) { (animationComplete) in
            
        }
        
        dropDownView.addSubview(clearView)
        self.navigationController?.view.addSubview(dropDownView)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dropDownTapGesture))
        tap.delegate = self
        dropDownView.addGestureRecognizer(tap)
        
    }
    
    @objc func dropDownTapGesture(sender: UITapGestureRecognizer?) {
        dropDownView.removeFromSuperview()
        self.summaryTableView.reloadData()
        
    }
    // UIGestureRecognizerDelegate method
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if (touch.view?.isDescendant(of: self.alertDropDownTableView))! || (touch.view?.isDescendant(of:  self.summaryTableView))!  {
            return false
        }
        return true
    }
    func removeDropDown(){
        dropDownView.removeFromSuperview()
    }
    
    
    
}
