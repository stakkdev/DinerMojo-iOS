//
//  TUTableViewData.swift
//
//  Created by Karol Wawrzyniak on 28/07/16.
//  Copyright © 2016 ApricotSoftware. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol TUTableViewData {
    func reuseID() -> String

    @objc optional func uniqHash() -> String
}

@objc public protocol TUGroupedTableViewData {
    func groupData() -> [TUTableViewData]

    func footerView() -> UIView?

    func headerReuseID() -> String?

    func decorateHeaderView(_ headerView: UIView)
    
    var allowOnlyOneInGroup: Bool { get set }
}

@objc protocol TUSortSelectionManagerProtocol {

    func multipleSelectionEnabled() -> Bool

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)

}


