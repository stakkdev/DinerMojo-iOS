//
//  Providers.swift
//
//  Created by Karol Wawrzyniak on 03/08/16.
//  Copyright © 2016 ApricotSoftware. All rights reserved.
//

import Foundation

@objc protocol TUListProviderDelegate: class {
    func didStartFetching(_ data: [AnyObject]?)
    func didFinishFetching(_ data: [AnyObject]?)
    func didFinishFetchingWithError(_ data: [AnyObject]?)
}

@objc protocol TUListProviderProtocol: class {
    var reuseIDs: [String] { get set }
    var delegate: TUListProviderDelegate? { get set }
    func preload() -> [AnyObject]?
    func requestData() -> Void
}
