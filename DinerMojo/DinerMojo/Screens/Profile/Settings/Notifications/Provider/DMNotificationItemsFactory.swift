//
// Created by Karol Wawrzyniak on 19/12/2016.
// Copyright (c) 2016 hedgehog lab. All rights reserved.
//

import UIKit
import MagicalRecord
// TODO: fix types for notifications

class DMNotificationItemsFactory: NSObject {

    private var headerColor = UIColor(hexString: "#E8E8E8")!

    func notifyMeItem(frequency: Int?) -> DMOptionGroupItem {
        let immediately = DMRadioSortOptionItem(NSLocalizedString("notifications.notify.me.immediately", comment: ""), groupName: GroupsName.TellMe.rawValue, itemId: NotificationFrequencyGroup.NImmediatelyItem.rawValue)
        let daily = DMRadioSortOptionItem(NSLocalizedString("notifications.notify.me.daily", comment: ""), groupName: GroupsName.TellMe.rawValue, itemId: NotificationFrequencyGroup.NDailyItem.rawValue)
        let weekly = DMRadioSortOptionItem(NSLocalizedString("notifications.notify.me.weekly", comment: ""), groupName: GroupsName.TellMe.rawValue, itemId: NotificationFrequencyGroup.NWeeklyItem.rawValue)
        let never = DMRadioSortOptionItem(NSLocalizedString("notifications.notify.me.never", comment: ""), groupName: GroupsName.TellMe.rawValue, itemId: NotificationFrequencyGroup.NNeverItem.rawValue)
        
        if frequency == 0 {
            immediately.isSelected = true
        }
        else if frequency == 1 {
            daily.isSelected = true
        }
        else if frequency == 2 {
            weekly.isSelected = true
        }
        else if frequency == 3 {
            never.isSelected = true
        }

        let group = DMOptionGroupItem.create(
                NSLocalizedString("notifications.notify.me", comment: ""),
                items: [immediately, daily, weekly, never],
                backgroundColor: self.headerColor,
                fontColor: UIColor(hexString: "#868686")!)

        group.allowOnlyOneInGroup = true
        return group
    }
    
    func limitByRadiusItem(selectedItems: [FilterItem], locationNotification: LocationNotification?) -> DMOptionGroupItem {
        
        var radiousValue:Double = 0.0
        if let radious = locationNotification?.locationRadius {
            radiousValue = Double(truncating: radious)
        }
        
        let defaultItem = DMRadioSortOptionItem(NSLocalizedString("limit.default", comment: ""), groupName: GroupsName.DistanceFilter.rawValue, itemId: DistanceFilter.OnlyHere.rawValue)
        defaultItem.isSelected = (radiousValue == 0.1) ? true : false
        
        let oneMileItem = DMRadioSortOptionItem(NSLocalizedString("limit.oneMile", comment: ""), groupName: GroupsName.DistanceFilter.rawValue, itemId: DistanceFilter.OneMile.rawValue)
        oneMileItem.isSelected = (radiousValue == 1) ? true : false
      
        let fiveMilesItem = DMRadioSortOptionItem(NSLocalizedString("limit.fiveMiles", comment: ""), groupName: GroupsName.DistanceFilter.rawValue, itemId: DistanceFilter.FiveMiles.rawValue)
        fiveMilesItem.isSelected = (radiousValue == 5) ? true : false
     
        let tenMilesItem = DMRadioSortOptionItem(NSLocalizedString("limit.tenMiles", comment: ""), groupName: GroupsName.DistanceFilter.rawValue, itemId: DistanceFilter.TenMiles.rawValue)
        tenMilesItem.isSelected = (radiousValue == 10) ? true : false
        
        //print(tenMilesItem)
        
        if selectedItems.count == 0
        {
            //fiveMilesItem.isSelected = true
        }
        let subItems = [defaultItem, oneMileItem, fiveMilesItem, tenMilesItem]
        let limitByItem = DMOptionGroupItem(NSLocalizedString("limit.by", comment: ""), items: subItems)
        limitByItem.allowOnlyOneInGroup = true
        return limitByItem
    }
    
    func checkSelection(item: DMRadioSortOptionItem, selectedItems: [FilterItem]) -> Bool {
        if selectedItems.firstIndex(where: {$0.itemId == item.itemId}) != nil {
            return true
        }
        return false
    }
    
    func locationItem(locationNotification: LocationNotification?) -> DMOptionGroupItem {
        let searchLocation = UpdateLocationTableViewItem(GroupsName.SearchLocation.rawValue, itemId: NotificationFavouriteGroup.NSearchItem.rawValue, searchText: locationNotification?.locationName ?? "")
        
        let favLocation = DMRadioSortOptionItem(NSLocalizedString("notifications.location.favourite", comment: ""), groupName: GroupsName.FavLocation.rawValue, itemId: NotificationFavouriteGroup.NFavItem.rawValue)
        
        if locationNotification?.isFavouriteVenuesNotification ?? true {
            favLocation.isSelected = true
        }
        let group = DMOptionGroupItem.create(
                NSLocalizedString("notifications.location", comment: ""),
                items: [searchLocation, favLocation],
                backgroundColor: self.headerColor,
                fontColor: UIColor(hexString: "#868686")!)

        group.allowOnlyOneInGroup = true

        return group
    }

    func thingsSectionItem(settings: SubscriptionsObject, ids: [Int]?, name: NSString?) -> DMOptionGroupItem {
        let things = DMVenuesOptionItem(NSLocalizedString("notifications.things.all.venues", comment: ""), groupName: GroupsName.Things.rawValue, itemId: ThingsGroup.NVenuesItem.rawValue, subscribed: settings.subscriptions)
        things.ids = ids
        things.selectedName = name
        things.allVenues = settings.all_venues_sub
        things.newFavourite = settings.dinermojo_sub
        
        if(settings.subscriptions != nil && settings.subscriptions.count > 0) {
            things.selectedVenues = true
            things.selectedVenuesCaption = ""
        }
        
        if ids != nil {
            //things.allVenues = false
            things.myFav = false
        } else {
             things.myFav = settings.my_favs_sub
        }
        
        let dmNews = DMRadioSortOptionItem(NSLocalizedString("notifications.dmclub.news", comment: ""), groupName: GroupsName.Things.rawValue, itemId: ThingsGroup.NDMClubItem.rawValue)
        dmNews.isSelected = settings.dinermojo_sub
        
        let group = DMOptionGroupItem.create(
                NSLocalizedString("notifications.things.section.title", comment: ""),
                items: [things, dmNews],
                backgroundColor: self.headerColor,
                fontColor: UIColor(hexString: "#868686")!)
        return group
    }

    func diningSectionItem(settings: SubscriptionsObject, color: UIColor, selectedDinings: [SelectedNotificationsDining]) -> DMOptionGroupItem {
        
        var notificationItems = [DMVenuesNotificationItem]()
        
        for dining in selectedDinings {
            let item = DMVenuesNotificationItem(venue: dining.venue, groupName: GroupsName.DiningNotifications.rawValue, color: color, selectedNotifications: dining)
            notificationItems.append(item)
        }
        
        let group = DMOptionGroupItem.create(
            NSLocalizedString("notifications.section.dining", comment: ""),
            items: notificationItems,
            backgroundColor: UIColor.white,
            fontColor: color)
        
        return group
    }
    
    func lifestyleSectionItem(settings: SubscriptionsObject, color: UIColor, selectedLifestyles: [SelectedNotificationsLifestyle]) -> DMOptionGroupItem {
       
        var notificationItems = [DMVenuesNotificationItem]()
        
        for lifestyle in selectedLifestyles {
            let item = DMVenuesNotificationItem.init(venue: lifestyle.venue, groupName: GroupsName.LifestyleNotifications.rawValue, color: color, selectedNotifications: lifestyle)
            notificationItems.append(item)
        }
        
        let group = DMOptionGroupItem.create(
            NSLocalizedString("notifications.section.lifestyle", comment: ""),
            items: notificationItems,
            backgroundColor: UIColor.white,
            fontColor: color)
        
        return group
    }
}
