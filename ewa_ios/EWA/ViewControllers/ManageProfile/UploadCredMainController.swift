//
//  UploadCredMainController.swift
//  EWA
//
//  Created by NFC User on 3/4/20.
//  Copyright © 2020 NFC. All rights reserved.
//

import UIKit
import MXSegmentedPager
import MXSegmentedControl

class UploadCredMainController: MXSegmentedPagerController {

      var menuHeaders = ["Upload","List"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
         loadSegments()
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
        
        // Segmented Control customization
//        segmentedPager.segmentedControl.selectionIndicatorLocation = .down
//        
//        segmentedPager.segmentedControl.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"color")as! String)
//        segmentedPager.segmentedControl.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font:UIFont(name:"Helvetica Neue",size:15)!]
//        segmentedPager.segmentedControl.selectedTitleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
//        segmentedPager.segmentedControl.selectionStyle = .fullWidthStripe //textWidthStripe
//        segmentedPager.segmentedControl.selectionIndicatorColor = UIColor.white
//        segmentedPager.segmentedControl.selectionIndicatorHeight = 3.0
        segmentedPager.bounces = false
        self.view.backgroundColor = UIColor(hexString:"F8F9FD")
        
    }
    
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didSelectViewAt index: Int) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "uploadCredIndexChanged"), object: index)

    }
    
    override func heightForSegmentedControl(in segmentedPager: MXSegmentedPager) -> CGFloat {
        return 40
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
    
    func segmentedPagerShouldScroll(toTop segmentedPager: MXSegmentedPager) -> Bool { // override removed
        return true
    }
    
    
}
