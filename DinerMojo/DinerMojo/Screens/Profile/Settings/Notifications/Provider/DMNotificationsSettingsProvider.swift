//
// Created by Karol Wawrzyniak on 19/12/2016.
// Copyright (c) 2016 hedgehog lab. All rights reserved.
//

import Foundation

@objc class DMNotificationsSettingsProvider: NSObject, TUListProviderProtocol {

    @objc var reuseIDs: [String] = ["DMRadioSortOptionCell", "DMVenuesOptionCell"];
    @objc var delegate: TUListProviderDelegate?
    @objc var itemsFactory: DMNotificationItemsFactory
    @objc var settings: SubscriptionsObject
    @objc var ids: [Int]?
    @objc var name: NSString?

    @objc var frequency: Int

    @objc init(frequency: Int, settings: SubscriptionsObject) {
        self.itemsFactory = DMNotificationItemsFactory()
        self.frequency = frequency
        self.settings = settings
    }

    @objc func preload() -> [AnyObject]? {
        return self.createData()
    }

    private func createData() -> [AnyObject]? {
        let tellMeSection = self.itemsFactory.notifyMeItem(frequency: self.frequency)
        let thingsSection = self.itemsFactory.thingsSectionItem(settings: self.settings, ids: ids, name: name)

        return [tellMeSection, thingsSection];

    }

    func requestData() {

    }
}
