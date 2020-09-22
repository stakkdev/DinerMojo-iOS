//
// Created by Karol Wawrzyniak on 19/12/2016.
// Copyright (c) 2016 hedgehog lab. All rights reserved.
//

import UIKit

class DMNotificationSelectionManager: NSObject, TUSortSelectionManagerProtocol {


    var selections = Dictionary<IndexPath, Bool>()

    func multipleSelectionEnabled() -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let paths = Array(self.selections.keys) as [IndexPath]
        for ip in paths {
            if ip == indexPath{
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }else if ip.section == indexPath.section {
                tableView.deselectRow(at: ip, animated: true)
                self.selections.removeValue(forKey: ip)
            }

        }

        selections[indexPath] = true
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

        let paths = Array(self.selections.keys) as [IndexPath]
        for ip in paths {
            if ip == indexPath{
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }else if ip.section == indexPath.section {
                tableView.deselectRow(at: ip, animated: true)
                self.selections.removeValue(forKey: ip)
            }
        }

    }

}
