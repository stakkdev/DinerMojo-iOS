//
//  AnalyticsInteractors.swift
//
//  Created by Josh Campion on 22/01/2016.
//

import Foundation

import Fabric
import Crashlytics

import TDCAppDependencies

/// Helper class to allow submodules within Fabric to be registered for starting, allowing the final line of `application(_:didFinishLaunchingWithOptions:)` to be called in a clean, but dynamic manner.
final class FabricInitialiser {
    
    /// The Fabric kits to be started at the end of `application(_:didFinishLaunchingWithOptions:)` using `Fabric.with(_:)`.
    static var kits = [AnyObject]()
}

/**
 
 Default implementation of crash reporting using Crashlytics, through Fabric. This class should not be subclassed and is therefore 'final' for optimization.
 
 Crashlytics is not initialised when in `DEBUG` mode. If not in `DEBUG` the `preferences` interactor is queried. If the user has given permission `Crashlytics()` is appended to the `FabricInitialiser.kits` array to be initialised at the end of `application(_:didFinishLaunchingWithOptions:)`.
 */
final class FabricCrashReportingInteractor: CrashReporter
{
    var preferences:PreferencesInteractor
    
    init(preferences:PreferencesInteractor) {
        self.preferences = preferences
    }
    
    func setupCrashReporting() {
        #if DEBUG
            print("Not starting Crashlytics in Debug")
        #else
            if preferences.canSendCrashReports() {
                FabricInitialiser.kits.append(Crashlytics())
            }
        #endif
    }
    
    func simulateCrash() {
        Crashlytics.sharedInstance().crash()
    }
    
    func logToCrashReport(message:String) {
        #if !DEBUG
            CLSLogv(message, getVaList([]))
        #else
            print(message)
        #endif
    }
    
    func logNonFatalError(error: NSError) {
        
    }
}