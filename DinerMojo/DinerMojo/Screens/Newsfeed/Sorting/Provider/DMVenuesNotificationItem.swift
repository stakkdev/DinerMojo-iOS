//
//  DMVenuesNotificationItem.swift
//  DinerMojo
//
//  Created by Mike Mikina on 5/2/17.
//  Copyright © 2017 hedgehog lab. All rights reserved.
//

import Foundation

@objc class DMVenuesNotificationItem: NSObject, TUTableViewData {
    @objc var type: String
    @objc var image: String
    @objc var name: String
    @objc var address: String
    @objc var venue: DMVenue
    @objc var color: UIColor

    @objc var isSelected = false
    @objc var colorSwitch = false

    @objc let itemId: Int
    @objc let groupName: Int

    @objc init(venue: DMVenue, groupName: Int, color: UIColor, selectedNotifications: SelectedNotification) {
        self.name = venue.name()
        self.type = venue.friendlyPlaceName()
        self.image = venue.primaryImage() != nil ? venue.primaryImage().fullURL() : ""
        self.type = (venue.categories().first as? DMVenueCategory)?.name() ?? ""
        self.address = venue.house_number_street_name() != nil ?  venue.house_number_street_name() : ""
        self.groupName = groupName
        self.itemId = venue.modelID().intValue
        self.venue = venue
        self.color = color
        self.isSelected = selectedNotifications.selected
    }

    @objc func reuseID() -> String {
        return "DMVenuesNotificationCell"
    }

}


