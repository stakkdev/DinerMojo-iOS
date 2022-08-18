//
// Created by Karol Wawrzyniak on 19/12/2016.
// Copyright (c) 2016 hedgehog lab. All rights reserved.
//

import Foundation

@objc class DMNotificationsSettingsProvider: NSObject, TUListProviderProtocol {

    @objc var reuseIDs: [String] = ["DMRadioSortOptionCell","DMRadioSortOptionCell", "DMVenuesOptionCell", "UpdateLocationTableViewCell"];
    @objc var delegate: TUListProviderDelegate?
    @objc var itemsFactory: DMNotificationItemsFactory
    @objc var settings: SubscriptionsObject
    @objc var ids: [Int]?
    @objc var name: NSString?

    @objc var frequency: Int
    @objc var locationNotification: LocationNotification?

    @objc init(frequency: Int, settings: SubscriptionsObject, locationNotification: LocationNotification) {
        self.itemsFactory = DMNotificationItemsFactory()
        self.frequency = frequency
        self.settings = settings
        self.locationNotification = locationNotification
    }

    @objc func preload() -> [AnyObject]? {
        return self.createData()
    }

    private func createData() -> [AnyObject]? {
        let locationSection = self.itemsFactory.locationItem(locationNotification: self.locationNotification)
        let limitByRadiusItem = self.itemsFactory.limitByRadiusItem(selectedItems: [], locationNotification: self.locationNotification)
        let tellMeSection = self.itemsFactory.notifyMeItem(frequency: self.frequency)
        let thingsSection = self.itemsFactory.thingsSectionItem(settings: self.settings, ids: ids, name: name)
        return [locationSection,limitByRadiusItem, tellMeSection, thingsSection];
    }

    func requestData() {

    }
}

@objc class LocationNotification: NSObject {
    @objc var latitude: NSNumber?
    @objc var longitude: NSNumber?
    @objc var locationName: String?
    @objc var locationRadius: NSNumber?
    @objc var isFavouriteVenuesNotification: Bool = true
    
    @objc init(locationName: String?, latitude: NSNumber?, longitude: NSNumber?, isFavouriteVenuesNotification: Bool = true, locationRadius: NSNumber?) {
        self.locationName = locationName
        self.latitude = latitude
        self.longitude = longitude
        self.isFavouriteVenuesNotification = isFavouriteVenuesNotification
        self.locationRadius = locationRadius
    }
}
