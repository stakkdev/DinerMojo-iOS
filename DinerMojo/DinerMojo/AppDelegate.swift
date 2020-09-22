//
//  AppDelegate.swift
//  DinerMojo
//
//  Created by Ben Baggley on 31/08/2016.
//  Copyright © 2016 hedgehog lab. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Siren

extension AppDelegate {
    
    @objc func swiftApplication(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any]?) {
        let siren = Siren.shared
        let rules = Rules(promptFrequency: .daily, forAlertType: .option)
        siren.rulesManager = .init(globalRules: rules, showAlertAfterCurrentVersionHasBeenReleasedForDays: 0)
    }
    
}
