//
//  DashBoardListViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 22/01/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class DashBoardListViewController: UIViewController {

    
    @IBOutlet weak var sideMenuTableView: UITableView!
    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var sideMenuTblBgView: UIView!
    var menuArray = NSMutableArray()
    var parentArray = NSMutableArray()
    var childArray = NSMutableArray()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}
