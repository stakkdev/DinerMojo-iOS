//
//  ApplicationDependencies.swift
//
//  Created by Josh Campion on 22/01/2016.
//

import Foundation

import TDCAppDependencies

/// - returns: A flag for whether the \"TESTING\" environment variable is present. This allows code to run dependening on whether this is a testing target or not. The primary use for this should be to prevent Google Analytics / Fabric from running in Unit Tests.
let isTesting:Bool = {
    return NSProcessInfo.processInfo().environment["TESTING"] != nil
}()

/// Global singleton for holding all variables than can be used for dependency injection.
class ApplicationDependencies : AppDependencies {
    
    override required init() {
        
        super.init()
        
        viewLoader = nil
        
        if isTesting {
            analyticsReporter = TestAnalyticsReporter()
            crashReporter = TestCrashReporter()
        } else {
            
            #if DEBUG
                // GA pushes all crashes up which adds lag to the app when debugging so just use test
                analyticsReporter = TestAnalyticsReporter()
                #else
                analyticsReporter = GoogleAnalyticsInteractor(preferences: self)
            #endif
            
            crashReporter = FabricCrashReportingInteractor(preferences: self)
        }
    }
    
    func installRootViewControllerIntoWindow(window: UIWindow) {
   
        window.rootViewController = viewLoader?.configuredRootViewController()
    }
}