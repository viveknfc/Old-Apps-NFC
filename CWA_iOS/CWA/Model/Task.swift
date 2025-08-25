//
//  Task.swift
//  CWA
//
//  Created by NFC Solutionsusa on 01/03/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class Task: NSObject {
    var Text: String?
    var Id: Int?
    var isChecked: String?
    
    init(Text: String?, Id: Int?,isChecked: String?){
        
        self.Text = Text
        self.Id = Id
        self.isChecked = isChecked
    }
}
