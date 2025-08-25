//
//  PositionSkill.swift
//  CWA
//
//  Created by NFC Solutionsusa on 27/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class PositionSkill: NSObject {
    var SkillCode: Int?
    var SkillName: String?
    var isSelected: String?
    var SkillExperience: Int?

    init(SkillCode: Int?,SkillName: String?,isSelected: String?,SkillExperience: Int? ){
        self.SkillCode = SkillCode
        self.isSelected = isSelected
        self.SkillName = SkillName
        self.SkillExperience =  SkillExperience
    }
}
