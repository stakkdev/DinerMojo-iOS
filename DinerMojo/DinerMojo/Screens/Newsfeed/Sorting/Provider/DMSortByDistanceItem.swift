//
//  DMSortByDistanceItem.swift
//  DinerMojo
//
//  Created by Mike Mikina on 4/9/17.
//  Copyright © 2017 hedgehog lab. All rights reserved.
//

import UIKit

class DMSortByDistanceItem: NSObject, TUTableViewData {
    
    var distance: Int = 100
    let itemId: Int
    let groupName: Int
    
    init(_ groupName: Int, itemId: Int) {
        self.groupName = groupName
        self.itemId = itemId
    }
    
    func reuseID() -> String {
        return "DMSortByDistanceCell"
    }
}
