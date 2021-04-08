//
// Created by Karol Wawrzyniak on 16/12/2016.
// Copyright (c) 2016 hedgehog lab. All rights reserved.
//

import UIKit

@objc enum GroupsName: Int {
    case SortBy = 1000
    case ShowVenues = 1001
    case DistanceFilter = 1002
    case RestaurantsFilter = 1003
    case NewsShow = 1004
    case NewsFor = 1005
    case FavouritesOnly = 1006
    case TellMe = 1007
    case Things = 1008
    case DiningNotifications = 1009
    case LifestyleNotifications = 1010
}

@objc enum SortByItems: Int {
    case NearestItem = 2000
    case RecentItem
    case AZ
}

@objc enum ShowVenues: Int {
    case RedeemItem = 3000
    case EarnPointsItem
    case NewsItem
    case OffersItem
}

@objc enum DistanceFilter: Int {
    case Default = 4000
    case OneMile
    case FiveMiles
    case TenMiles
}

@objc enum ShowNewsGroup: Int {
    case ShowNewsItem = 1
    case OfferItem = 3
    case All = 0
}

@objc enum ForNewsGroup: Int {
    case DiningItem = 6000
    case LifestyleItem
    case DMClubItem
    case All
}

@objc enum FavouritesGroup: Int {
    case FavouritesOnlyItem = 7000
}

@objc enum NotificationFrequencyGroup: Int {
    case NImmediatelyItem = 8000
    case NDailyItem
    case NWeeklyItem
    case NNeverItem
}

@objc enum ThingsGroup: Int {
    case NVenuesItem = 9000
    case NDMClubItem
}


class DMTableItemsFactory: NSObject {
    
    func limitByRadiusItem(selectedItems: [FilterItem]) -> DMOptionGroupItem {
        let defaultItem = DMRadioSortOptionItem(NSLocalizedString("limit.default", comment: ""), groupName: GroupsName.DistanceFilter.rawValue, itemId: DistanceFilter.Default.rawValue)
        defaultItem.isSelected = self.checkSelection(item: defaultItem, selectedItems: selectedItems)
        
        let oneMileItem = DMRadioSortOptionItem(NSLocalizedString("limit.oneMile", comment: ""), groupName: GroupsName.DistanceFilter.rawValue, itemId: DistanceFilter.OneMile.rawValue)
        oneMileItem.isSelected = self.checkSelection(item: oneMileItem, selectedItems: selectedItems)
        
        let fiveMilesItem = DMRadioSortOptionItem(NSLocalizedString("limit.fiveMiles", comment: ""), groupName: GroupsName.DistanceFilter.rawValue, itemId: DistanceFilter.FiveMiles.rawValue)
        fiveMilesItem.isSelected = self.checkSelection(item: fiveMilesItem, selectedItems: selectedItems)
        
        let tenMilesItem = DMRadioSortOptionItem(NSLocalizedString("limit.tenMiles", comment: ""), groupName: GroupsName.DistanceFilter.rawValue, itemId: DistanceFilter.TenMiles.rawValue)
        tenMilesItem.isSelected = self.checkSelection(item: tenMilesItem, selectedItems: selectedItems)
        
        if selectedItems.count == 0 {
            defaultItem.isSelected = true
        }
        let subItems = [defaultItem, oneMileItem, fiveMilesItem, tenMilesItem]
        let limitByItem = DMOptionGroupItem(NSLocalizedString("limit.by", comment: ""), items: subItems)
        limitByItem.allowOnlyOneInGroup = true
        return limitByItem
    }
    
    func sortByGroupItem(selectedItems: [FilterItem]) -> DMOptionGroupItem {
        let nearestItem = DMRadioSortOptionItem(NSLocalizedString("sort.nearest", comment: ""), groupName: GroupsName.SortBy.rawValue, itemId: SortByItems.NearestItem.rawValue)
        nearestItem.isSelected = self.checkSelection(item: nearestItem, selectedItems: selectedItems)
        
        let recentItem = DMRadioSortOptionItem(NSLocalizedString("sort.most.recent", comment: ""), groupName: GroupsName.SortBy.rawValue, itemId: SortByItems.RecentItem.rawValue)
        recentItem.isSelected = self.checkSelection(item: recentItem, selectedItems: selectedItems)
        
        let azItem = DMRadioSortOptionItem(NSLocalizedString("sort.az", comment: ""), groupName: GroupsName.SortBy.rawValue, itemId: SortByItems.AZ.rawValue)
        azItem.isSelected = self.checkSelection(item: azItem, selectedItems: selectedItems)
        if selectedItems.count == 0 {
            nearestItem.isSelected = true
        }
        let subItems = [nearestItem, recentItem, azItem]
        let sortByItem = DMOptionGroupItem(NSLocalizedString("sort.by", comment: ""), items: subItems)
        sortByItem.allowOnlyOneInGroup = true
        return sortByItem
    }
    
    func showNewsGroupItem(selectedItems: [FilterItem]) -> DMOptionGroupItem {
        
        let newsItem = DMRadioSortOptionItem(NSLocalizedString("news.show.news", comment: ""), groupName: GroupsName.NewsShow.rawValue, itemId: ShowNewsGroup.ShowNewsItem.rawValue)
        newsItem.isSelected = self.checkSelection(item: newsItem, selectedItems: selectedItems)
        
        let offerItem = DMRadioSortOptionItem(NSLocalizedString("news.show.offers", comment: ""), groupName: GroupsName.NewsShow.rawValue, itemId: ShowNewsGroup.OfferItem.rawValue)
        offerItem.isSelected = self.checkSelection(item: offerItem, selectedItems: selectedItems)
        
        let allItem = DMRadioSortOptionItem(NSLocalizedString("news.show.all", comment: ""), groupName: GroupsName.NewsShow.rawValue, itemId: ShowNewsGroup.All.rawValue)
        allItem.isSelected = self.checkSelection(item: allItem, selectedItems: selectedItems)
        allItem.selectAllType = true
        
        let subItems = [newsItem, offerItem, allItem]
        let sortByItem = DMOptionGroupItem(NSLocalizedString("news.show", comment: ""), items: subItems)
        
        return sortByItem
    }
    
    func forNewsGroupItem(selectedItems: [FilterItem]) -> DMOptionGroupItem {
        
        let diningItem = DMRadioSortOptionItem(NSLocalizedString("news.for.dining", comment: ""), groupName: GroupsName.NewsFor.rawValue, itemId: ForNewsGroup.DiningItem.rawValue)
        diningItem.isSelected = self.checkSelection(item: diningItem, selectedItems: selectedItems)
        
        let lifestyleItem = DMRadioSortOptionItem(NSLocalizedString("news.for.lifestyle", comment: ""), groupName: GroupsName.NewsFor.rawValue, itemId: ForNewsGroup.LifestyleItem.rawValue)
        lifestyleItem.isSelected = self.checkSelection(item: lifestyleItem, selectedItems: selectedItems)
        
        let dmclubItem = DMRadioSortOptionItem(NSLocalizedString("news.for.dmclub", comment: ""), groupName: GroupsName.NewsFor.rawValue, itemId: ForNewsGroup.DMClubItem.rawValue)
        dmclubItem.isSelected = self.checkSelection(item: dmclubItem, selectedItems: selectedItems)
        
        let allItem = DMRadioSortOptionItem(NSLocalizedString("news.for.all", comment: ""), groupName: GroupsName.NewsFor.rawValue, itemId: ForNewsGroup.All.rawValue)
        allItem.isSelected = self.checkSelection(item: allItem, selectedItems: selectedItems)
        allItem.selectAllType = true
        
        let subItems = [diningItem, lifestyleItem, dmclubItem, allItem]
        let sortByItem = DMOptionGroupItem(NSLocalizedString("news.for", comment: ""), items: subItems)
        
        return sortByItem
    }
    
    func favouritesGroupItem(selectedItems: [FilterItem]) -> DMOptionGroupItem {
        
        let favouritesItem = DMRadioSortOptionItem(NSLocalizedString("news.favourites.show", comment: ""), groupName: GroupsName.FavouritesOnly.rawValue, itemId: FavouritesGroup.FavouritesOnlyItem.rawValue)
        favouritesItem.isSelected = self.checkSelection(item: favouritesItem, selectedItems: selectedItems)
        favouritesItem.selectOnlyThisOne = true
        
        let subItems = [favouritesItem]
        let sortByItem = DMOptionGroupItem(NSLocalizedString("news.favourites", comment: ""), items: subItems)
        
        return sortByItem
    }
    
    func currentLocationInfoGroupItem() -> DMOptionGroupItem {
        let item = DMLocationInfoItem()
        
        let subItems = [item]
        let sortByItem = DMOptionGroupItem(NSLocalizedString("test", comment: ""), items: subItems)
        return sortByItem
    }
    
    func checkSelection(item: DMRadioSortOptionItem, selectedItems: [FilterItem]) -> Bool {
        if selectedItems.firstIndex(where: {$0.itemId == item.itemId}) != nil {
            return true
        }
        
        return false
    }
    
    func getDistanceElement(item: DMSortByDistanceItem, selectedItems: [FilterItem]) -> FilterItem? {
        if let i = selectedItems.firstIndex(where: { $0.itemId == item.itemId }) {
            return selectedItems[i]
        }
        
        return nil
    }

    func showVenuesGroupItem(selectedItems: [FilterItem]) -> DMOptionGroupItem {

        let redeemItem = DMRadioSortOptionItem(NSLocalizedString("sort.venues.redeem", comment: ""), groupName: GroupsName.ShowVenues.rawValue, itemId: ShowVenues.RedeemItem.rawValue)
        redeemItem.isSelected = self.checkSelection(item: redeemItem, selectedItems: selectedItems)
        let earnPointsItem = DMRadioSortOptionItem(NSLocalizedString("sort.venues.earn.points", comment: ""), groupName: GroupsName.ShowVenues.rawValue, itemId: ShowVenues.EarnPointsItem.rawValue)
        earnPointsItem.isSelected = self.checkSelection(item: earnPointsItem, selectedItems: selectedItems)
        let newsItem = DMRadioSortOptionItem(NSLocalizedString("sort.venues.news", comment: ""), groupName: GroupsName.ShowVenues.rawValue, itemId: ShowVenues.NewsItem.rawValue)
        newsItem.isSelected = self.checkSelection(item: newsItem, selectedItems: selectedItems)
        let offersItem = DMRadioSortOptionItem(NSLocalizedString("sort.venues.offers", comment: ""), groupName: GroupsName.ShowVenues.rawValue, itemId: ShowVenues.OffersItem.rawValue)
        offersItem.isSelected = self.checkSelection(item: offersItem, selectedItems: selectedItems)
        let subItems = [redeemItem, earnPointsItem, newsItem, offersItem]

        let sortByItem = DMOptionGroupItem(NSLocalizedString("show.venues", comment: ""), items: subItems)

        return sortByItem
    }


    func restaurantsFilterGroupItem(_ names: [NSDictionary], selectedItems: [FilterItem]) -> DMOptionGroupItem {

        let item = self.groupItem(names, groupName: NSLocalizedString("sort.restaurants", comment: ""), selectedItems: selectedItems)
        return item
    }

    func otherVenuesFilterGroupItem(_ names: [NSDictionary], selectedItems: [FilterItem]) -> DMOptionGroupItem {

        let item = self.groupItem(names, groupName: NSLocalizedString("sort.other.venues", comment: ""), selectedItems: selectedItems)
        return item
    }

    private func groupItem(_ names: [NSDictionary], groupName: String, selectedItems: [FilterItem]) -> DMOptionGroupItem {

        var subItems = [DMRadioSortOptionItem]()
        var i = 0
        for item in names {
            guard let name = item["name"] as? String, let modelID = item["modelID"] as? NSNumber else {
                continue
            }
            
            let subItem = DMRadioSortOptionItem(name, groupName: GroupsName.RestaurantsFilter.rawValue, itemId: Int(modelID))
            subItem.isSelected = self.checkSelection(item: subItem, selectedItems: selectedItems)
            subItems.append(subItem)
            i += 1
        }

        let groupItem = DMOptionGroupItem(groupName, items: subItems)

        return groupItem
    }

}
