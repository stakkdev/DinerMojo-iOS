//
//  SGNotificationsSettings.swift
//  Created by Jaroslav Chaninovicz on 14/02/2017.
//  Copyright © 2017 Jaroslav Chaninovicz. All rights reserved.
//

import UIKit
typealias CompletionAction = ((Bool) -> Void)?

@objc class SGNotificationsSettings: NSObject {
    @objc static func isPushNotificationsEnabled(completion: CompletionAction) {
    /*    if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings: UNNotificationSettings) in
                if settings.authorizationStatus == .authorized {
                    completion?(true)
                } else {
                    completion?(false)
                }
            })
        } else {*/
            if let settingsTypes = UIApplication.shared.currentUserNotificationSettings?.types {
                if settingsTypes.contains(.alert) {
                    completion?(true)
                } else {
                    completion?(false)
                }
            }
        //}
    }
}
