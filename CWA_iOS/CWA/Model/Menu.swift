//
//  Menu.swift
//  CWA
//
//  Created by NFC Solutionsusa on 16/11/17.
//  Copyright © 2017 NFC Solutionsusa. All rights reserved.
//

import UIKit

class Menu: NSObject {

    var MenuId: Int?
    var LinkText: String?
    var MenuOrder : Int?
    var logoPath : String?
    var ParentMenuId : Int?
    var ParentMenuName : String?
    var Action: String?
    
    init(MenuId: Int? = nil, LinkText: String? = nil, MenuOrder: Int? = nil, logoPath: String? = nil, ParentMenuId: Int? = nil, ParentMenuName: String? = nil, Action: String? = nil) {
        self.MenuId = MenuId
        self.LinkText = LinkText
        self.MenuOrder = MenuOrder
        self.logoPath = logoPath
        self.ParentMenuId = ParentMenuId
        self.ParentMenuName = ParentMenuName
        self.Action = Action
    }
}
