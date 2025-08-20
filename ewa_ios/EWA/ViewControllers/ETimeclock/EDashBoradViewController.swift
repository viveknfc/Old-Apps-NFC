//
//  EDashBoradViewController.swift
//  EWA
//
//  Created by NFC India on 12/12/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import MXSegmentedPager
import MXSegmentedControl

class EDashBoradViewController: MXSegmentedPagerController {
    
    
    var menuHeaders = ["eTimeClock","History"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Constants.ETCSelectedWeekend = ""
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.navigationController?.navigationBar.isTranslucent = false
       // self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//         loadSegments() // viv - scroll view is not working for table view so hided this
        let etc = UserDefaults.standard.object(forKey: "eTimeClock") as?  String ?? "0"
        
        if etc == "0" {
            print("viv entered e-timeclock")
            segmentedPager.pager.showPage(at: 0, animated: false)
            segmentedPager.segmentedControl.select(index: 0, animated: false)
        }
        else if etc == "1" {
            print("viv entered e-timeclock history")
            segmentedPager.pager.showPage(at: 1, animated: false)
            segmentedPager.segmentedControl.select(index: 1, animated: false)
        }
        
        // Parallax Header
        
        let headerView = UIView()
        headerView.frame = CGRect(x:0, y:0, width:self.view.bounds.size.width, height:25)
        headerView.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        segmentedPager.parallaxHeader.view = headerView
        
        segmentedPager.pager.reloadData()
    }
    
    
    func loadSegments()
    {
        // Parallax Header
        
        let headerView = UIView()
        headerView.frame = CGRect(x:0, y:0, width:self.view.bounds.size.width, height:25)
        headerView.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
        segmentedPager.parallaxHeader.view = headerView
        segmentedPager.parallaxHeader.mode = .center
        segmentedPager.parallaxHeader.height = 25
        segmentedPager.parallaxHeader.minimumHeight = 20
        
//        segmentedPager.pager.touchesShouldCancel(in: headerView)

        // Segmented Control customization
//        segmentedPager.segmentedControl.selectionIndicatorLocation = .down
//        segmentedPager.segmentedControl.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
//        segmentedPager.segmentedControl.titleTextAttributes = [NSAttributedStringKey.foregroundColor :UIColor.white,NSAttributedStringKey.font:UIFont(name:"Helvetica Neue",size:15)!]
//        segmentedPager.segmentedControl.selectedTitleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
//        segmentedPager.segmentedControl.selectionStyle = .fullWidthStripe //textWidthStripe
//        segmentedPager.segmentedControl.selectionIndicatorColor = UIColor.white
//        segmentedPager.segmentedControl.selectionIndicatorHeight = 3.0
        segmentedPager.bounces = false
        self.view.backgroundColor = UIColor(hexString:"F8F9FD")
        /*
         override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(true)
            if(isfromCard){
                segmentedPager.segmentedControl.selectedSegmentIndex = 4
                segmentedPager.pager.showPage(at: 4, animated: false)
                segmentedPager.pager.reloadData()

            }
        }
         
         */
        
    }
    
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didSelectViewAt index: Int) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "didSelectIndex"), object: index)

    }
    
    override func heightForSegmentedControl(in segmentedPager: MXSegmentedPager) -> CGFloat {
        return 30
    }
    
    
    override func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
        return menuHeaders.count
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return menuHeaders[index]
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didScrollWith parallaxHeader: MXParallaxHeader) {
        //  print("progress \(parallaxHeader.progress)")
    }
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, segueIdentifierForPageAt index: Int) -> String {
        return menuHeaders[index]
    }
    
    func segmentedPagerShouldScroll(toTop segmentedPager: MXSegmentedPager) -> Bool { //override removed
        return true
    }
    

}
