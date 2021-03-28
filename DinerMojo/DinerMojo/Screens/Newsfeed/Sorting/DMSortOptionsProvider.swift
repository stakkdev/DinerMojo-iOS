//
//  DMSortOptionsProvider.swift
//  DinerMojo
//
//  Created by Karol Wawrzyniak on 15/12/2016.
//  Copyright © 2016 hedgehog lab. All rights reserved.
//

import UIKit

@objc class DMSortOptionsProvider: NSObject, TUListProviderProtocol {

    @objc var reuseIDs: [String] = ["DMRadioSortOptionCell", "DMSortByDistanceCell"];
    @objc var delegate: TUListProviderDelegate?
    @objc var itemsFactory: DMTableItemsFactory
    @objc var filterItems: [FilterItem] = []
    @objc var restaurantItems: [AnyObject] = []

    override init() {
        self.itemsFactory = DMTableItemsFactory()
    }

    func preload() -> [AnyObject]? {
        return self.createData()
    }

    private func createData() -> [AnyObject]? {

        let sortByItem = self.itemsFactory.sortByGroupItem(selectedItems: self.filterItems)
        let sortByVenues = self.itemsFactory.showVenuesGroupItem(selectedItems: self.filterItems)
//        let distanceItem = self.itemsFactory.distanceFilterGroupItem(selectedItems: self.filterItems)
//
//        var items = [NSDictionary]()
//
//        if let categoryItems = self.restaurantItems as? [NSManagedObject] {
//            if let keys = categoryItems.first?.entity.attributesByName.keys {
//                for item in categoryItems {
//                    items.append(item.dictionaryWithValues(forKeys: Array(keys)) as NSDictionary)
//                }
//            }
//        }
        
//        let restaurantItem = self.itemsFactory.restaurantsFilterGroupItem(items, selectedItems: self.filterItems)
        
        return [sortByItem, sortByVenues/*, distanceItem, restaurantItem */];
    }

    private func getRestaurantCategoryNames() -> [String] {
        var names: [String] = []

        for i in self.restaurantItems {
            if i is DMVenueCategory {
                names.append(i.name)
            }
        }
        
        return names
    }

    func requestData() {

    }

}
