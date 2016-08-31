//
//  AppDelegate.swift
//  DinerMojo
//
//  Created by Ben Baggley on 31/08/2016.
//  Copyright © 2016 hedgehog lab. All rights reserved.
//

import UIKit
import Fabric

extension AppDelegate {
    
    func swiftApplication(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        _ = ApplicationDependencies.sharedDependencies()
        
        if FabricInitialiser.kits.count > 0 {
            // starting Fabric has to be the last method
            Fabric.with(FabricInitialiser.kits)
        }
        
        return true
    }
}
