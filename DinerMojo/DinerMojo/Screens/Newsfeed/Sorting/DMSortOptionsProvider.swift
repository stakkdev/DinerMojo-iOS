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

        let limitByRadiusItem = self.itemsFactory.limitByRadiusItem(selectedItems: self.filterItems)
        let sortByItem = self.itemsFactory.sortByGroupItem(selectedItems: self.filterItems)
        let sortByVenues = self.itemsFactory.showVenuesGroupItem(selectedItems: self.filterItems)
        
        return [limitByRadiusItem, sortByItem, sortByVenues/*, distanceItem, restaurantItem */];
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
