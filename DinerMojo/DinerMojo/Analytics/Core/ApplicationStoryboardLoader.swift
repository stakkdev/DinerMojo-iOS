//
//  ApplicationStoryboardLoader.swift
//
//  Created by Josh Campion on 22/01/2016.
//

import Foundation

import TheDistanceCore

enum StoryboadID:String {
    case Test
}

enum ViewControllerID:String {
    case TestVC
}

class ApplicationStoryboardLoader: StoryboardLoader {
    
    static func storyboardIdentifierForViewControllerIdentifier(viewControllerID: ViewControllerID) -> StoryboadID {
        switch viewControllerID {
        case .TestVC:
            return .Test
        }
    }
}

