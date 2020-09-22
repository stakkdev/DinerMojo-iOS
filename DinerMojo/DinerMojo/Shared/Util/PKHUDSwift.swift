//
//  PKHUDSwift.swift
//  DinerMojo
//
//  Created by Michał Łubgan on 06/07/2020.
//  Copyright © 2020 hedgehog lab. All rights reserved.
//

import Foundation
import PKHUD

@objc extension PKHUD {
    
    @objc static var sharedHUDObjc: PKHUD {
        return PKHUD.sharedHUD
    }
    
    @objc var contentViewObjc: UIView {
        set {
            self.contentView = newValue
        }
        get {
            return self.contentView
        }
    }
    
    @objc func showOn(view: UIView?) {
        self.show(onView: view)
    }

    @objc func hide(animated: Bool) {
        hide(animated)
    }
    
}

@objc extension PKHUDProgressView {
    
    @objc convenience init(title: String, sub: String) {
        self.init(title: title, subtitle: sub)
    }
    
}
