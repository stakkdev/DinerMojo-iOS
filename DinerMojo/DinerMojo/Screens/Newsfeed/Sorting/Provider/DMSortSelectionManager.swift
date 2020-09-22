//
// Created by Karol Wawrzyniak on 16/12/2016.
// Copyright (c) 2016 hedgehog lab. All rights reserved.
//

import UIKit

class DMSortSelectionManager: NSObject, TUSortSelectionManagerProtocol {

    private var indexPathOfPreviouslySelectedRow: IndexPath?

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.section {
        case 0:
            if let previousIndexPath = self.indexPathOfPreviouslySelectedRow {
                tableView.deselectRow(at: previousIndexPath, animated: false)
            }
            self.indexPathOfPreviouslySelectedRow = indexPath

        default:
            break
        }

    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if let previousIndexPath = self.indexPathOfPreviouslySelectedRow {
                tableView.deselectRow(at: previousIndexPath, animated: false)
            }
            self.indexPathOfPreviouslySelectedRow = nil

        default:
            break
        }
    }

    func multipleSelectionEnabled() -> Bool {
        return true
    }

}
