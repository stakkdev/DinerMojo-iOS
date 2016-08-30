//
//  AppAnalytics.swift
//
//  Created by Josh Campion on 24/02/2016.
//

import Foundation

// APP SPECIFIC

enum AnalyticsCustomMetric: UInt {
    
    case DeviceType = 1
    
}

// MARK: - App Keys

let GoogleAnalyticsTrackingIDLive = "<#Live ID#>"
let GoogleAnalyticsTrackingIDStaging = "<#Staging ID#>"

// MARK: - Analytic Enums

// MARK: Screen Names

enum AnalyticScreen:String {
    case Test
}

// MARK: Analytic Categories

enum AnalyticCategory:String {
    case Screens
    case Test
}

// MARK: Analytic Actions

enum AnalyticAction:String {
    
    // Category: Screens
    case Viewed
    
    // Category: Test
    case Test
}