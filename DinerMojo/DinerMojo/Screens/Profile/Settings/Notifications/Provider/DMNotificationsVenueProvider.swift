//
//  DMNotificationsVenueProvider.swift
//  DinerMojo
//
//  Created by Mike Mikina on 5/2/17.
//  Copyright © 2017 hedgehog lab. All rights reserved.
//

import Foundation

@objc class DMNotificationsVenueProvider: NSObject, TUListProviderProtocol {
    
    @objc var reuseIDs: [String] = ["DMVenuesNotificationCell"];
    @objc var delegate: TUListProviderDelegate?
    @objc var itemsFactory: DMNotificationItemsFactory
    @objc var settings: SubscriptionsObject
    @objc var selectedLifestyles: [SelectedNotificationsLifestyle]
    @objc var selectedDinings: [SelectedNotificationsDining]
    
    @objc init(settings: SubscriptionsObject, selectedNotificationsDining: NSArray, selectedNotificationsLifestyle: NSArray) {
        self.itemsFactory = DMNotificationItemsFactory()
        self.settings = settings
        self.selectedLifestyles = (selectedNotificationsLifestyle as? [SelectedNotificationsLifestyle]) ?? []
        self.selectedDinings = (selectedNotificationsDining as? [SelectedNotificationsDining]) ?? []
    }
    
    @objc func preload() -> [AnyObject]? {
        return self.createData()
    }
    
    private func createData() -> [AnyObject]? {
        let diningColor = UIColor(red: 95/255, green: 186/255, blue: 160/255, alpha: 1.0)
        let dining = self.itemsFactory.diningSectionItem(settings: self.settings, color: diningColor, selectedDinings: self.selectedDinings)
        let lifestyleColor = UIColor(red: 204/255, green: 98/255, blue: 30/255, alpha: 1.0)
        let lifestyle = self.itemsFactory.lifestyleSectionItem(settings: self.settings, color: lifestyleColor, selectedLifestyles: self.selectedLifestyles)
        
        return [dining, lifestyle];
        
    }
    
    func requestData() {
        
    }
}
