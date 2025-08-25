//
//  colorLegendViewController.swift
//  CWA
//
//  Created by NFC User on 11/10/23.
//  Copyright © 2023 NFC Solutionsusa. All rights reserved.
//

import UIKit

class colorLegendViewController: UIViewController {
    
    @IBOutlet weak var dismissButton: UIButton!
 
    @IBOutlet weak var mainView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        mainView.layer.cornerRadius = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
