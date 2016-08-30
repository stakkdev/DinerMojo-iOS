//
//  AnalyticsInteractors.swift
//  MozQuito
//
//  Created by Josh Campion on 22/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

import TDCAppDependencies

/// Default implementation of analytics using Google Analytics. This class should not be subclassed and is therefore 'final' for optimization.
final class GoogleAnalyticsInteractor:AnalyticsReporter {
    
    var preferences:PreferencesInteractor
    
    init(preferences:PreferencesInteractor) {
        self.preferences = preferences
    }
    
    func enableAnalytics(enable: Bool) {
        GAI.sharedInstance().optOut = !enable
    }
    
    func setupAnalytics() {
        
        #if DEBUG || BETA_TESTING
            let trackingID = GoogleAnalyticsTrackingIDStaging
        #else
            let trackingID = GoogleAnalyticsTrackingIDLive
        #endif
        
        enableAnalytics(preferences.canSendAnalytics() ?? false)
        
        // Configure tracker from GoogleService-Info.plist.
        GAI.sharedInstance().defaultTracker = GAI.sharedInstance().trackerWithTrackingId(trackingID)
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        
        #if DEBUG
            gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
        #endif
        
        
    }
    
    func sendAnalytic(event: AnalyticEvent, asNewSession session:AnalyticSession? = nil) {
        
        let builder:GAIDictionaryBuilder
        let tracker = GAI.sharedInstance().defaultTracker
        
        if event.isCategory(.Screens, andAction: .Viewed) {
            // this is a screen view
            tracker.set(kGAIScreenName, value: event.label)
            builder = GAIDictionaryBuilder.createScreenView()
            
        } else {
            // build a standard event
            let value = event.userInfo["value"] as? NSNumber
            
            builder = GAIDictionaryBuilder.createEventWithCategory(event.category,
                                                                   action: event.action,
                                                                   label: event.label,
                                                                   value: value)
        }
        
        if let s = session {
            builder.set("start", forKey: kGAISessionControl)
            
            // configure any sesion scope custom dimensions here
            // set the device name etc.
            for (dim, value) in s.customDimensions {
                tracker.set(GAIFields.customDimensionForIndex(dim), value: value)
            }
        }
        
        AppDependencies.sharedDependencies().crashReporter?.logToCrashReport(event.description)
        
        // send the event
        tracker.send(builder.build() as [NSObject: AnyObject])
    }
    
    func sendScreenView(screenName: String) {
        let screenEvent = AnalyticEvent(screenName: screenName)
        sendAnalytic(screenEvent)
    }
}
