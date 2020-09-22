//
//  FacebookShareManager.swift
//  DinerMojo
//
//  Created by Michał Łubgan on 29.06.2018.
//  Copyright © 2018 hedgehog lab. All rights reserved.
//

import UIKit
import FBSDKShareKit

@objc class FacebookShareManager: NSObject {
    
    @objc let clientManager = DMVenueRequest()
    @objc var dialog: ShareDialog?
    
    private var shareUrl: String? {
        guard let envPath = Bundle.main.path(forResource: "Environments", ofType: "plist"), let config = Bundle.main.infoDictionary, let currentConfig = config["Configuration"] as? String else { return nil }
        let env = NSDictionary(contentsOfFile: envPath)
        let currentEnv = env?.object(forKey: currentConfig) as? [String: Any]
        return currentEnv?["shareUrl"] as? String
    }
    
    @objc func share(presentingVC: UIViewController & SharingDelegate, url: String) {
        guard let urlString = shareUrl, let url = URL(string: urlString) else { return }
        let content = ShareLinkContent()
        content.contentURL = url
        dialog = ShareDialog()
        dialog?.fromViewController = presentingVC
        dialog?.shareContent = content
        dialog?.mode = .shareSheet
        dialog?.delegate = presentingVC
        dialog?.show()
    }
    
}
