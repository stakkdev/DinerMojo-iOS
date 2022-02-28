//
//  UpdateLocationTableViewItem.swift
//  DinerMojo
//
//  Created by XXX on 22/02/22.
//  Copyright © 2022 hedgehog lab. All rights reserved.
//

import Foundation

@objc class UpdateLocationTableViewItem: NSObject, TUTableViewData {
    @objc var searchText: String = ""
    let itemId: Int
    let groupName: Int
    
    init(_ groupName: Int, itemId: Int, searchText: String) {
        self.groupName = groupName
        self.itemId = itemId
        self.searchText = searchText
    }
    
    func reuseID() -> String {
        return "UpdateLocationTableViewCell"
    }
}
