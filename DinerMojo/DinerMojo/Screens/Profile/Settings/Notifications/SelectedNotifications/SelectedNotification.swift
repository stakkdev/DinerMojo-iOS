//
//  SelectedNotification.swift
//  DinerMojo
//
//  Created by Michał Łubgan on 23.06.2017.
//  Copyright © 2017 hedgehog lab. All rights reserved.
//

import Foundation

@objc class SelectedNotification: NSObject {
    @objc let venue: DMVenue
    @objc var id: NSNumber {
        return self.venue.primitiveModelID()
    }
    @objc var selected: Bool
    
    @objc init(venue: DMVenue, selected: Bool) {
        self.venue = venue
        self.selected = selected
    }
}
