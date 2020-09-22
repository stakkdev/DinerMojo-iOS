//
//  DMRadioSortOptionItem.swift
//  DinerMojo
//
//  Created by Karol Wawrzyniak on 15/12/2016.
//  Copyright © 2016 hedgehog lab. All rights reserved.
//

import UIKit

class DMRadioSortOptionItem: NSObject, TUTableViewData {

    internal var name: String
    var isSelected = false
    var selectAllType = false
    var selectOnlyThisOne = false
    
    let itemId: Int
    let groupName: Int

    init(_ name: String, groupName: Int, itemId: Int) {
        self.name = name
        self.groupName = groupName
        self.itemId = itemId
    }

    func reuseID() -> String {
        return "DMRadioSortOptionCell"
    }
}
