//
// Created by Mike Mikina on 4/23/17.
// Copyright (c) 2017 hedgehog lab. All rights reserved.
//

import UIKit

@objc class FilterItem: NSObject, NSCoding {
    @objc let groupName: Int
    @objc let itemId: Int
    @objc let value: Int
    @objc var payload: NotificationPayload?

    @objc init(groupName: Int, itemId: Int, value: Int) {
        self.groupName = groupName
        self.itemId = itemId
        self.value = value
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(groupName, forKey: "groupName")
        aCoder.encode(itemId, forKey: "itemId")
        aCoder.encode(value, forKey: "value")
    }
    
    required init?(coder aDecoder: NSCoder) {
        groupName = aDecoder.decodeInteger(forKey: "groupName")
        itemId = aDecoder.decodeInteger(forKey: "itemId")
        value = aDecoder.decodeInteger(forKey: "value")
    }

    @objc class func convertPayloadToDicrionary(payload: [FilterItem]) -> NSDictionary {
        let dictionary: NSMutableDictionary = [:]
        for item in payload {
            print("payload item is:", item.groupName)
            if item.itemId == NotificationFrequencyGroup.NImmediatelyItem.rawValue {
                dictionary.setObject(0, forKey: "frequency" as NSCopying)
            }
            else if item.itemId == NotificationFrequencyGroup.NDailyItem.rawValue {
                dictionary.setObject(1, forKey: "frequency" as NSCopying)
            }
            else if item.itemId == NotificationFrequencyGroup.NWeeklyItem.rawValue {
                dictionary.setObject(2, forKey: "frequency" as NSCopying)
            }
            else if item.itemId == NotificationFrequencyGroup.NNeverItem.rawValue {
                dictionary.setObject(3, forKey: "frequency" as NSCopying)
            }
            else if item.itemId == ThingsGroup.NVenuesItem.rawValue {
                if item.payload?.allVenues == true {
                    dictionary.setObject(true, forKey: "all_venues_sub" as NSCopying)
                } else {
                    dictionary.setObject(false, forKey: "all_venues_sub" as NSCopying)
                }
                if item.payload?.myFav == true {
                    dictionary.setObject(true, forKey: "my_favs_sub" as NSCopying)
                }
            }
            else if item.itemId == ThingsGroup.NDMClubItem.rawValue {
                dictionary.setObject(((item.value == 1) ? true : false), forKey: "dinermojo_sub" as NSCopying)
            }
            dictionary.setObject(false, forKey: "my_favs_sub" as NSCopying)
        }
        
        return NSDictionary(dictionary: dictionary)
    }
}
