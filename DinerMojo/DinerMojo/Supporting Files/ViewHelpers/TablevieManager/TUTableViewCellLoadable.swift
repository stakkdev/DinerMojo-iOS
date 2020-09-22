//
// Created by Karol Wawrzyniak on 28/07/16.
// Copyright (c) 2016 ApricotSoftware. All rights reserved.
//

import Foundation

@objc protocol UITableViewCellLoadableProtocol {
    func loadData(_ data: AnyObject?)
    @objc optional func pinDelegate(_ delegate: AnyObject)
}
