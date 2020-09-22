//
//  DMVenuesOptionItem.swift
//  DinerMojo
//
//  Created by Mike Mikina on 4/23/17.
//  Copyright © 2017 hedgehog lab. All rights reserved.
//

import UIKit

class NotificationPayload: NSObject {
    var allVenues: Bool
    var selectedVenues: Bool
    var myFav: Bool

    init(allVenues: Bool, selectedVenues: Bool, myFav: Bool) {
        self.allVenues = allVenues
        self.selectedVenues = selectedVenues
        self.myFav = myFav
    }
}

class DMVenuesOptionItem: NSObject, TUTableViewData {

    internal var name: String
    var allVenues = false
    var selectedVenues = false
    var selectedVenuesCaption = ""
    var myFav = false
    var subscribed: [Any]?
    var ids: [Int]?
    var selectedName: NSString?
    let itemId: Int
    let groupName: Int

    init(_ name: String, groupName: Int, itemId: Int, subscribed: [Any]?) {
        self.name = name
        self.groupName = groupName
        self.itemId = itemId
        self.subscribed = subscribed
    }

    func reuseID() -> String {
        return "DMVenuesOptionCell"
    }

    func getPayload() -> NotificationPayload {
        let payload = NotificationPayload(allVenues: self.allVenues, selectedVenues: self.selectedVenues, myFav: self.myFav)
        return payload
    }
}

