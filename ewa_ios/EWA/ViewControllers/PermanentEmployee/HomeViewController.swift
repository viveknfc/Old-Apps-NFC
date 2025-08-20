//
//  HomeViewController.swift
//  EWA
//
//  Created by NFC Solutions on 13/10/17.
//  Copyright © 2017 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomeViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var dashTableView: UITableView!
    
    
    //var menuArray = [String]()
    var headerTitles = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("***VIV the screen name is \(className)***")
        
        // Do any additional setup after loading the view.
        
        self.updateNavigationBarColor()
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        
        imageView.imageFromServerURL(urlString: UserDefaults.standard.object(forKey:"logo")as! String)
        //        messageLabel.text = UserDefaults.standard.object(forKey:"EmployeeTypMessage")as? String
        //        messageLabel.textColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        
        
        //menuArray = Constants.menuSections[0]
        headerTitles = Constants.menuHeaders
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateNavigationBarColor()
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        

    }
    
    @IBAction func handleNavgationBarButtonTap(_ sender: UIBarButtonItem, event: UIEvent)
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
        FTPopOverMenu.showForEvent(event: event, with: [UserDefaults.standard.object(forKey:"CandName") as! String,"Logout"], done: { (selectedIndex) -> () in
            print(selectedIndex)
            if selectedIndex == 0 {
                
                
            }
            else if selectedIndex == 1
            {
                Constants.menuHeaders.removeAll()
                Constants.menuSectionLogos.removeAll()
                Constants.menuSections.removeAll()
                Constants.menuObjj.removeAll()
                Constants.titleImages.removeAll()
                Constants.dashObject = JSON.null
                TimeOutClass.sharedInstance.resetTimer()
                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                (UIApplication.shared.delegate as? AppDelegate)?.APSlocation_Set_up()
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ewaLogin") as! LoginViewController
                UIApplication.shared.keyWindow?.rootViewController = viewController
                
            }        }, cancel: {
                
            })
    }
    
}


extension HomeViewController:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        Constants.menuOptionNameArray = [UserDefaults.standard.object(forKey:"CandName") as! String,"Logout"]
        var identifier = String()
        //        if indexPath.section == 0
        //        {
        identifier = Constants.menuSections[indexPath.section][indexPath.row]
        //}
        Constants.Menu = identifier
        let vc1:UIViewController = (self.storyboard?.instantiateViewController(withIdentifier:identifier))!
        let navi = BaseNaviViewController(rootViewController:vc1)
        navi.navigationBar.tintColor = .white
        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:identifier)
        
        //                let navi = BaseNaviViewController(rootViewController:vc1)
        //                navi.navigationBar.tintColor = .white
        //                navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //                sideMenuController?.embed(centerViewController:navi, cacheIdentifier:identifier)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0//40
    }
    /*
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     let headerView = UIView()
     headerView.frame = CGRect(x:0, y: 0, width: self.view.bounds.size.width, height:40)
     headerView.backgroundColor = .clear
     let headerLabel = UILabel()
     headerLabel.frame = CGRect(x:10, y: 0, width: self.view.bounds.size.width, height:40)
     headerLabel.backgroundColor = .clear
     headerLabel.text = headerTitles[section]
     headerLabel.textAlignment = .left
     headerView.addSubview(headerLabel)
     return headerView
     }
     */
    
    
    
}
extension HomeViewController:UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if section == 0
        //        {
        return Constants.menuSections[section].count
        //        }
        //        else
        //        {
        //            return 0
        //        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"dCell") as! DasboardTableViewCell
        cell.selectionStyle = .none
        //        if indexPath.section == 0
        //        {
        cell.nameLabel?.text = Constants.menuSections[indexPath.section][indexPath.row]
        cell.iconImageView.sd_setImage(with:URL(string:Constants.menuSectionLogos[0][indexPath.row].replace(target:"\\", withString:"//")), placeholderImage: UIImage(named:"placeholder.png"))
        
        //}
        return cell
    }
}







