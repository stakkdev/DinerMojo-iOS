//
//  StateSerializer.swift
//  DinerMojo
//
//  Created by Patryk on 21.01.2019.
//  Copyright © 2019 hedgehog lab. All rights reserved.
//

import Foundation

/// The purpose of this class is to save and restore state of various parts of the application
@objc class StateSerializer: NSObject {
    
    private var filterStateFilePath: String {
        let paths = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true)
        let documentsDirectory = NSString(string: paths[0])
        let filterStateFile = documentsDirectory.appendingPathComponent("filterState.txt")
        
        return filterStateFile
    }
    
    /// saves state of filters in newsfeed view
    @objc func saveFilterState(items: NSArray) {
        NSKeyedArchiver.archiveRootObject(items, toFile: filterStateFilePath)
    }
    
    /// restores state of filters in newsfeed view
    @objc func restoreFilterState() -> NSArray? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: filterStateFilePath) as? NSArray
    }
}
