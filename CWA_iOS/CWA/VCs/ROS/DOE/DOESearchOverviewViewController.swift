//
//  DOESearchOverviewViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 02/04/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class DOESearchOverviewViewController: BaseViewController {
    @IBOutlet var lblHeading: UILabel!
    var titleHeader = ""
    var isFromSummaryPage = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblHeading.text = titleHeader
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        
        self.titlelbl.text = "Rapid Order System"
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextButtonTapped(_ sender:UIButton){
        
        
    }
    @IBAction func backButtonTapped(_ sender:UIButton){
        
        
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
