//
//  SelectedNotificationsParser.swift
//  DinerMojo
//
//  Created by Michał Łubgan on 23.06.2017.
//  Copyright © 2017 hedgehog lab. All rights reserved.
//

import Foundation
import MagicalRecord

@objc class SelectedNotificationsParser: NSObject {
    let subscriptionsObject: SubscriptionsObject
    let ids: [NSNumber]
    
    @objc init(subscriptionsObject: SubscriptionsObject, ids: [NSNumber]) {
        self.subscriptionsObject = subscriptionsObject
        self.ids = ids
    }
    
    @objc func create() -> [String : Any] {
        let selectedIds = self.selectedIds()
        guard var fetchedDinings = DMVenue.mr_findAll(with: NSPredicate(format: "venue_type = \"restaurant\"")) as? [DMVenue] else { return [:] }
        fetchedDinings = fetchedDinings.sorted{$0.name.compare($1.name, options: .caseInsensitive) == .orderedDescending }
        var allDining = [DMVenue]()
        
        for dining in fetchedDinings {
            if ids.contains(dining.primitiveModelID()) {
                allDining.append(dining)
            }
        }
        var dinings = [SelectedNotificationsDining]()
        for dining in allDining {
            let notificationDining = SelectedNotificationsDining(venue: dining, selected: selectedIds.contains(dining.primitiveModelID()))
            dinings.append(notificationDining)
        }
        
        guard var fetchedLifestyles = DMVenue.mr_findAll(with: NSPredicate(format: "venue_type = \"non_restaurant\"")) as? [DMVenue] else { return [:] }
        fetchedLifestyles = fetchedLifestyles.sorted{$0.name.compare($1.name, options: .caseInsensitive) == .orderedDescending }
        var allLifestyle = [DMVenue]()
        
        for lifestyle in fetchedLifestyles {
            if ids.contains(lifestyle.primitiveModelID()) {
                allLifestyle.append(lifestyle)
            }
        }
        var lifestyles = [SelectedNotificationsLifestyle]()
        for lifestyle in allLifestyle {
            let notificationLifestyle = SelectedNotificationsLifestyle(venue: lifestyle, selected: selectedIds.contains(lifestyle.primitiveModelID()))
            lifestyles.append(notificationLifestyle)
        }
        var dictionary = [String : Any]()
        dictionary.updateValue(dinings, forKey: "dinings")
        dictionary.updateValue(lifestyles, forKey: "lifestyles")
        return dictionary
    }
    
    private func selectedIds() -> [NSNumber] {
        var selectedIds = [NSNumber]()
        let dic = self.subscriptionsObject.subscriptions
        for dictionary in dic as? [NSDictionary] ?? [] {
            if let id = (dictionary["venue"] as? NSDictionary)?["id"] as? NSNumber {
                selectedIds.append(id)
            }
        }
        
        return selectedIds
    }
    
    @objc static func getSelected(dinings: NSArray, lifestyles: NSArray) -> [NSNumber] {
        var selected = [NSNumber]()
        for value in dinings as? [SelectedNotificationsDining] ?? [] {
            if value.selected {
                selected.append(value.id)
            }
        }
        
        for value in lifestyles as? [SelectedNotificationsLifestyle] ?? [] {
            if value.selected {
                selected.append(value.id)
            }
        }
        
        return selected
    }
}
