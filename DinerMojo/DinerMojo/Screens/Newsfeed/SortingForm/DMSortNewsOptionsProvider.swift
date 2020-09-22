//
//  DMSortOptionsProvider.swift
//  DinerMojo
//
//  Created by Karol Wawrzyniak on 15/12/2016.
//  Copyright © 2016 hedgehog lab. All rights reserved.
//

import UIKit

@objc class DMSortNewsOptionsProvider: NSObject, TUListProviderProtocol {

    @objc var reuseIDs: [String] = ["DMRadioSortOptionCell"];
    var delegate: TUListProviderDelegate?
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
        var data = [DMOptionGroupItem]()
        data.append(self.itemsFactory.showNewsGroupItem(selectedItems: self.filterItems))
        data.append(self.itemsFactory.forNewsGroupItem(selectedItems: self.filterItems))

        /*let user = DMUserRequest().currentUser()
        
        if user != nil {
            data.append(self.itemsFactory.favouritesGroupItem(selectedItems: self.filterItems))
        }*/
        
        return data
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
