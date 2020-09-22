//
// Created by Karol Wawrzyniak on 28/07/16.
// Copyright (c) 2016 ApricotSoftware. All rights reserved.
//

import UIKit

@objc protocol TUTableViewManagerDelegate {

    func didSelect(_ item: TUTableViewData)

    @objc optional func didDeselect(_ item: TUTableViewData)

    @objc optional func decorateCell(_ item: UITableViewCell)

    @objc optional func loadMoreData()

    @objc optional func didSelectSection(_ item: TUGroupedTableViewData, senderFrame: CGRect)
}

protocol TUTableReorderDelegate {
    func saveObjectAndInsertBlankRowAtIndexPath(_ indexPath: IndexPath!) -> Void

    func moveRowAtIndexPath(_ fromIndexPath: IndexPath!, toIndexPath: IndexPath!, dataItem: TUTableViewData)

    func finishReorderingWithObject(_ object: AnyObject!, atIndexPath indexPath: IndexPath!, data: [TUTableViewData])
}

extension UIView {

    func parentTableView() -> UITableView? {

        var aView = self.superview
        while aView != nil {
            if aView is UITableView {
                return aView as? UITableView
            }

            if let aSuperview = aView?.superview {
                aView = aSuperview
            } else {
                aView = nil
            }
        }
        return nil
    }

    func parentCell() -> UITableViewCell? {
        var aView = self.superview
        while aView != nil {
            if aView is UITableViewCell {
                return aView as? UITableViewCell
            }

            if let aSuperview = aView?.superview {
                aView = aSuperview
            } else {
                aView = nil
            }
        }
        return nil
    }
}

class TUTableViewManager: NSObject, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView?

    var delegate: TUTableViewManagerDelegate?

    var data: [TUTableViewData]? {
        didSet {
            self.tableView!.reloadData()
        }
    }

    var searchActive: Bool?

    var filtered: [TUTableViewData]? {
        didSet {
            self.tableView!.reloadData()
        }
    }

    init(tableView: UITableView, reuseIDs: [String]) {
        super.init()
        self.tableView = tableView
        self.tableView!.dataSource = self
        self.tableView?.delegate = self
        self.tableView!.estimatedRowHeight = 50
        self.tableView!.separatorColor = UIColor.clear
        self.data = [TUTableViewData]()

        for reuseID in reuseIDs {
            self.tableView?.register(UINib(nibName: reuseID, bundle: nil), forCellReuseIdentifier: reuseID)
        }
    }

    func scrollUp() {
        guard let tbl = self.tableView else {
            return
        }
        var offset = tbl.contentOffset
        let scrollStep = offset.y - 50
        if scrollStep >= 0 {
            offset.y = scrollStep
            tbl.setContentOffset(offset, animated: true)
        }
    }

    func scrollDown() {

        guard let tbl = self.tableView else {
            return
        }

        var offset = tbl.contentOffset
        let scrollStep = offset.y + 50
        if scrollStep <= (tbl.contentSize.height - tbl.frame.height) {
            offset.y = scrollStep
            tbl.setContentOffset(offset, animated: true)
        }
    }

    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let active = searchActive {
            if active {
                if let filteredData = filtered {
                    return filteredData.count
                } else {
                    return 0
                }
            }
        }

        if let data = self.data {
            return data.count
        } else {
            return 0
        }
    }

    @objc func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var dataItem: TUTableViewData
        if let active = searchActive {
            if active {
                dataItem = self.filtered![indexPath.row]
            } else {
                dataItem = self.data![indexPath.row]
            }
        } else {
            dataItem = self.data![indexPath.row]
        }

        let cell: UITableViewCellLoadableProtocol = (tableView.dequeueReusableCell(withIdentifier: dataItem.reuseID()) as? UITableViewCellLoadableProtocol)!
        cell.loadData(dataItem)

        self.delegate?.decorateCell?(cell as! UITableViewCell)
        let tableViewCell = cell as! UITableViewCell
        tableViewCell.layoutSubviews()
        return tableViewCell
    }

    @objc func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataItem: TUTableViewData = self.data![indexPath.row]
        if let pDelegate = self.delegate {
            pDelegate.didSelect(dataItem)
        }
    }
}
