//
//  PermanentMenuViewController.swift
//  EWA
//
//  Created by NFC India on 04/10/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import ExpyTableView
import SDWebImage

class PermanentMenuViewController: UIViewController {

    @IBOutlet weak var menuTableView: ExpyTableView!
    //var menu = [String]()
    var titles = [String]()
    var icons = ["dash.png","list.png","bclock.png"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //menu = Constants.menuSections
        titles = Constants.menuHeaders
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        for e in 0..<2 {
            menuTableView.expand(e+1)
        }
    }
    
    // MARK: - Table view data source
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return titles.count+1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section >= 1
        {
        return Constants.menuSections[section-1].count+1
        }
        else
        {
            return 1
        }
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier:"pmCell")   as! MenuTableViewCell
        if indexPath.section >= 1
        {
            if indexPath.row<=Constants.menuSections[indexPath.section-1].count
            {
                cell.nameLabel?.text = Constants.menuSections[indexPath.section-1][indexPath.row-1]
            }
        }
        
            cell.selectionStyle = .none
            return cell
        }
    


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}


//expTableView datasource and delegate

extension PermanentMenuViewController: ExpyTableViewDataSource {
    
    
    func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
        return true
    } // viv newly added
    
    
     func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HeaderTableViewCell.self)) as! HeaderTableViewCell
        
        if section == 0
        {
            cell.labelHeader.text = "Dashboard"
            cell.icon.image = UIImage(named:icons[section])
        }
        else
        {
        
            cell.labelHeader.text = titles[section-1]
        cell.icon.sd_setImage(with:URL(string:Constants.titleImages[section-1].replace(target:"\\", withString:"//")), placeholderImage: UIImage(named:"placeholder.png"))
        }
        return cell
    }
    
   
}
extension PermanentMenuViewController { //ExpyTableViewDelegate
    
//    func tableView(_ tableView: ExpyTableView.ExpyTableView, expyState state: ExpyTableView.ExpyState, changeForSection section: Int) {
//        <#code#>
//    }
    
    
    
    
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        Constants.menuOptionNameArray = [UserDefaults.standard.object(forKey:"CandName") as! String,"Logout"]
                
                var identifier = String()
                if indexPath.section == 0
                {
                    identifier = "pHome"
                    
                    let vc1:UIViewController = (self.storyboard?.instantiateViewController(withIdentifier:identifier))!
                    let nc1:UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: identifier+"Navi") as! UINavigationController
                    nc1.viewControllers = [vc1]
                    sideMenuController?.embed(centerViewController:nc1)
                    
                }
                else
                {
                    if indexPath.row>=1
                    {
                        if indexPath.section >= 1
                        {
                            identifier = Constants.menuSections[indexPath.section-1][indexPath.row-1]
                        }
                        Constants.Menu = identifier
                        let vc1:UIViewController = (self.storyboard?.instantiateViewController(withIdentifier:identifier))!
                        
                        let navi = BaseNaviViewController(rootViewController:vc1)
                        navi.navigationBar.tintColor = .white
                        navi.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                        sideMenuController?.embed(centerViewController:navi, cacheIdentifier:identifier)
                        
                    }
                }
        
        tableView.deselectRow(at: indexPath, animated: false)
        print("DID SELECT row: \(indexPath.row), section: \(indexPath.section)")
    }
    
}




