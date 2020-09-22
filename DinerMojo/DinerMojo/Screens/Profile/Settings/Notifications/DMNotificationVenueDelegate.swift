//
//  DMNotificationVenueDelegate.swift
//  DinerMojo
//
//  Created by Michał Łubgan on 05.05.2017.
//  Copyright © 2017 hedgehog lab. All rights reserved.
//

import Foundation

@objc protocol DMNotificationVenueDelegate {
    func saveVenues(dinings: NSArray, lifestyles: NSArray, name: NSString, changed: Bool)
}
