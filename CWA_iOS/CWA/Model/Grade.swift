//
//  Grade.swift
//  CWA
//
//  Created by NFC Solutionsusa on 27/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class Grade: NSObject {
    var GradeCode: Int?
    var GradeName: String?
    var isSelected: String?

    init(GradeCode: Int?,GradeName: String?,isSelected: String? ){
        self.GradeCode = GradeCode
        self.GradeName = GradeName
        self.isSelected = isSelected
    }
}
