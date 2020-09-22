//
//  DMViewControllersProvider.swift
//  DinerMojo
//
//  Created by Karol Wawrzyniak on 16/12/2016.
//  Copyright © 2016 hedgehog lab. All rights reserved.
//

import UIKit

@objc class DMViewControllersProvider: NSObject {

    @objc static let instance = DMViewControllersProvider()

    @objc func sortVC() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let sortVC = storyBoard.instantiateViewController(withIdentifier: "sortVenueFeedView")
        let nav = UINavigationController(rootViewController: sortVC)
        nav.modalPresentationStyle = .overFullScreen
        nav.modalTransitionStyle = .crossDissolve
        return nav
    }
    
    @objc func sortNewsVC() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let sortVC = storyBoard.instantiateViewController(withIdentifier: "sortNewsFeedView")
        let nav = UINavigationController(rootViewController: sortVC)
        nav.modalPresentationStyle = .overFullScreen
        nav.modalTransitionStyle = .crossDissolve
        return nav
    }
    
    @objc func notificationsVenuesVC() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let sortVC = storyBoard.instantiateViewController(withIdentifier: "notificationsVenueView")
        let nav = UINavigationController(rootViewController: sortVC)
        nav.modalPresentationStyle = .overFullScreen
        nav.modalTransitionStyle = .crossDissolve
        return nav
    }
    
}
