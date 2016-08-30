//
//  AnalyticEntities.swift
//
//  Created by Josh Campion on 22/01/2016.
//

import Foundation

import TDCAppDependencies

// Extend the general analytic event to use the enums specific to this app.
extension AnalyticEvent {

    // MARK: Enum Extensions
    
    /// Convenience initialiser to create a new event from enums for String safety
    init(category:AnalyticCategory, action:AnalyticAction, label:String?, userInfo:[String:Any]? = nil) {
        self.init(category: category.rawValue, action: action.rawValue, label: label, userInfo: userInfo)
    }
    
    /// Convenience initialiser to create a screen view event. Static keys are used to determine category and action so these events can be easily filtered by an AnalyticsInteractor.
    init(screenName:String) {
        self.init(category: .Screens, action: .Viewed, label: screenName)
    }
    
    /// Convenience initialiser to create a screen view event. Static keys are used to determine category and action so these events can be easily filtered by an AnalyticsInteractor.
    init(screenName:AnalyticScreen) {
        self.init(category: .Screens, action: .Viewed, label: screenName.rawValue)
    }
    
    /// Convenience comparison using Analytic enums.
    func isCategory(category:AnalyticCategory, andAction action:AnalyticAction) -> Bool {
        return self.category == category.rawValue && self.action == action.rawValue
    }
}

/// Protocol for a view which can automatically send a screen view AnalyticEvent.
protocol AnalyticScreenView {
    
    /// The name that should be reported for this view.
    var screenName:AnalyticScreen { get set }
    
    /// Should report a screen view AnalyticEvent. The default implementation sends an `AnalyticEvent` as a screen view with the `screenName`.
    func registerScreenView()
}

extension AnalyticScreenView {
    
    /// Sends an `AnalyticEvent` as a screen view with the `screenName`.
    func registerScreenView() {
                AppDependencies.sharedDependencies().analyticsReporter?.sendAnalytic(AnalyticEvent(screenName: screenName))
    }
}