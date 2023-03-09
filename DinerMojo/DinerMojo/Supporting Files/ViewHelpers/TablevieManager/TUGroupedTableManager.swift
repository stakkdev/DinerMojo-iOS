//
//  TUGroupedTableManager.swift
//
//  Created by Karol Wawrzyniak on 29/07/16.
//  Copyright © 2016 ApricotSoftware. All rights reserved.
//

import UIKit
import GooglePlaces

@objc protocol LocationNotificationDelegate {
    func locationUpdated()
}

@objc class TUGroupedTableManager: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    @objc var tableView: UITableView?
    
    @objc weak var parent: UIViewController?
    
    @objc var delegate: TUTableViewManagerDelegate?
    
    @objc var delegateLocation: LocationNotificationDelegate?
    
    @objc var notificationData: LocationNotification?
    
    @objc var selectionManager: TUSortSelectionManagerProtocol? {
        didSet {
            
            guard let sm = self.selectionManager else {
                self.tableView?.allowsMultipleSelection = false
                return
            }
            
            self.tableView?.allowsMultipleSelection = sm.multipleSelectionEnabled()
            
        }
    }
    
    @objc var data: [TUGroupedTableViewData]? {
        didSet {
            self.tableView!.reloadData()
        }
    }
    
    @objc var headersReuseIDs: [String]? {
        didSet {
            if let hri = self.headersReuseIDs {
                for headerReuseID in hri {
                    self.tableView?.register(UINib(nibName: headerReuseID, bundle: nil), forHeaderFooterViewReuseIdentifier: headerReuseID)
                }
            }
        }
    }
    
    @objc var heightAtIndexPath = NSMutableDictionary()
    
    private func setupManager(tableView: UITableView, reuseIDs: [String]) {
        self.tableView = tableView
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.separatorColor = UIColor.clear
        self.tableView?.backgroundColor = UIColor(hexString: "#FFFFFF")
        self.tableView!.estimatedRowHeight = 75
        self.tableView?.estimatedSectionHeaderHeight = 40
        self.tableView?.estimatedSectionFooterHeight = 10
        self.tableView?.rowHeight = UITableView.automaticDimension
        self.tableView?.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView?.sectionFooterHeight = UITableView.automaticDimension
        self.tableView?.separatorStyle = .none
        self.data = [TUGroupedTableViewData]()
        self.tableView!.tableFooterView = UIView(frame: CGRect.zero)
        
        for reuseID in reuseIDs {
            self.tableView?.register(UINib(nibName: reuseID, bundle: nil), forCellReuseIdentifier: reuseID)
        }
    }
    
    @objc init(_ provider: TUListProviderProtocol, tableView: UITableView) {
        super.init()
        self.setupManager(tableView: tableView, reuseIDs: provider.reuseIDs)
    }
    
    @objc init(tableView: UITableView, reuseIDs: [String]) {
        super.init()
        self.setupManager(tableView: tableView, reuseIDs: reuseIDs)
    }
    
    @objc func numberOfSections(in tableView: UITableView) -> Int {
        if let data = self.data {
            return data.count
        } else {
            return 0
        }
    }
    
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataGroup: TUGroupedTableViewData = self.data![section]
        let groups = dataGroup.groupData()
        return groups.count
    }
    
    @objc func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dataGroup: TUGroupedTableViewData = self.data![section]
        guard let headerID = dataGroup.headerReuseID() else {
            return nil
        }
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerID) else {
            return nil
        }
        headerView.tag = section
        dataGroup.decorateHeaderView(headerView)
        return headerView
    }
    
    @objc func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let dataGroup: TUGroupedTableViewData = self.data![section]
        return dataGroup.footerView()
    }
    
    @objc func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataGroup: TUGroupedTableViewData = self.data![indexPath.section]
        let groups = dataGroup.groupData()
        let dataItem = groups[indexPath.row]
        
        let cell: UITableViewCellLoadableProtocol = (tableView.dequeueReusableCell(withIdentifier: dataItem.reuseID()) as? UITableViewCellLoadableProtocol)!
        
        if let itemmm = dataItem as? UpdateLocationTableViewItem {
            print("notificationData: \(String(describing: notificationData))")
            itemmm.searchText = notificationData?.locationName ?? "Search..."
            cell.loadData(itemmm)
        } else {
            cell.loadData(dataItem)
        }
        
        
        if var c = cell as? TableViewSelectForGroup {
            
            c.clickCallback = { [unowned self] in
                if let _ = dataItem as? DMVenuesOptionItem {
                    self.parent?.performSegue(withIdentifier: "showNotificationsVenues", sender: nil)
                    return
                }
                
                if let _ = dataItem as? UpdateLocationTableViewItem {
                    print("Search location tapped")
                    print("notificationData: \(String(describing: notificationData))")
                    autocompleteClicked()
                    return
                }
                
                guard let item = dataItem as? DMRadioSortOptionItem else {
                    return
                }
                
                if dataGroup.allowOnlyOneInGroup == true {
                    
                    let selectionStatus = item.isSelected
                    if item.groupName == 1012 && item.itemId == 10001 {
                        notificationData?.isFavouriteVenuesNotification = item.isSelected
                        delegateLocation?.locationUpdated()
                    }
                    
                    if item.groupName == 1002 {
                        print(item.itemId)
                        let options = item.itemId
                        switch options {
                        case 4001:
                            notificationData?.locationRadius = 0.1
                        case 4002:
                            notificationData?.locationRadius = 1
                        case 4003,4000:
                            notificationData?.locationRadius = 5
                        case 4004:
                            notificationData?.locationRadius = 10
                        default:
                            print(options)
                        }
                        delegateLocation?.locationUpdated()
                    }
                    
                    for group in groups {
                        if let data = group as? DMRadioSortOptionItem {
                            if(data.isSelected) {
                                data.isSelected = false
                            }
                        }
                    }
                    item.isSelected = selectionStatus
                    self.tableView?.reloadData()
                }
                
                if item.selectAllType == true {
                    let selectionStatus = item.isSelected
                    
                    for group in groups {
                        if let data = group as? DMRadioSortOptionItem {
                            data.isSelected = selectionStatus
                        }
                    }
                    self.tableView?.reloadData()
                }
                
                if item.selectOnlyThisOne == true {
                    let selectionStatus = item.isSelected
                    
                    for data in self.data! {
                        let groupItems = data.groupData()
                        for group in groupItems {
                            if let data = group as? DMRadioSortOptionItem {
                                data.isSelected = false
                            }
                        }
                    }
                    item.isSelected = selectionStatus
                    self.tableView?.reloadData()
                }
                else {
                    for data in self.data! {
                        let groupItems = data.groupData()
                        var somethingIsDeSelectedFromGroup = false
                        
                        // iterate to deselect all type element and check if something
                        // is selected inside group
                        for group in groupItems {
                            if let data = group as? DMRadioSortOptionItem, data.selectOnlyThisOne == true {
                                data.isSelected = false
                            }
                            
                            if let data = group as? DMRadioSortOptionItem {
                                if !data.isSelected && data.selectAllType == false {
                                    somethingIsDeSelectedFromGroup = true
                                }
                            }
                        }
                        
                        if(somethingIsDeSelectedFromGroup) {
                            for group in groupItems {
                                if let data = group as? DMRadioSortOptionItem, data.selectAllType == true {
                                    data.isSelected = false
                                }
                            }
                        }
                    }
                    self.tableView?.reloadData()
                }
            }
        }
        
        self.delegate?.decorateCell?(cell as! UITableViewCell)
        
        if indexPath.section == self.data!.count - 1 && indexPath.row == groups.count - 1 {
            self.delegate?.loadMoreData?()
        }
        let tableCell = cell as! UITableViewCell
        tableCell.layoutIfNeeded()
        return tableCell
    }
    
    @objc func tableViewReselect() {
        guard let data = self.data else {
            return
        }
        var i = 0
        
        for section in data {
            let dataGroup: TUGroupedTableViewData = section
            let groups = dataGroup.groupData()
            var j = 0
            for group in groups {
                if let data = group as? DMRadioSortOptionItem {
                    if(data.isSelected) {
                        let indexPath = IndexPath(row: j, section: i)
                        if let tableView = self.tableView {
                            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                            self.selectionManager?.tableView(tableView, didSelectRowAt: indexPath)
                        }
                    }
                }
                j += 1
            }
            
            i += 1
        }
    }
    
    @objc func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = heightAtIndexPath.object(forKey: indexPath) as? NSNumber {
            return CGFloat(height.floatValue)
        } else {
            return UITableView.automaticDimension
        }
    }
    
    @objc func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let height = NSNumber(value: Float(cell.frame.size.height))
        heightAtIndexPath.setObject(height, forKey: indexPath as NSCopying)
    }
    
    @objc func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataGroup: TUGroupedTableViewData = self.data![indexPath.section]
        let groups = dataGroup.groupData()
        let dataItem = groups[indexPath.row]
        
        if let pDelegate = self.delegate {
            pDelegate.didSelect(dataItem)
        }
        self.selectionManager?.tableView(tableView, didSelectRowAt: indexPath)
    }
    
    @objc  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.selectionManager?.tableView(tableView, didDeselectRowAt: indexPath)
    }
    
    func scrollToDataItem(_ item: TUTableViewData) {
        var sectionIndex = 0
        
        if let pData = self.data {
            for groupItem in pData {
                let groupData = groupItem.groupData()
                
                let index = groupData.firstIndex(where: { (data) -> Bool in
                    return data.uniqHash!() == item.uniqHash!()
                })
                
                if let rowIndex = index {
                    let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                    self.tableView?.scrollToRow(at: indexPath, at: .top, animated: true)
                    return
                }
                
                sectionIndex = sectionIndex + 1
            }
        }
    }
    
    @objc public func getFilterData() -> [FilterItem] {
        var items = [FilterItem]()
        
        guard let data = self.data else {
            return items
        }
        var i = 0
        
        for section in data {
            let dataGroup: TUGroupedTableViewData = section
            let groups = dataGroup.groupData()
            var j = 0
            for group in groups {
                if let data = group as? DMRadioSortOptionItem {
                    if(data.isSelected) {
                        let item = FilterItem(groupName: data.groupName, itemId: data.itemId, value: 0)
                        items.append(item)
                    }
                }
                
                if let data = group as? DMSortByDistanceItem {
                    let item = FilterItem(groupName: data.groupName, itemId: data.itemId, value: data.distance)
                    items.append(item)
                }
                
                if let data = group as? DMVenuesOptionItem {
                    let item = FilterItem(groupName: data.groupName, itemId: data.itemId, value: 0)
                    item.payload = data.getPayload()
                    items.append(item)
                }
                j += 1
            }
            i += 1
        }
        
        return items
    }
}

extension TUGroupedTableManager: GMSAutocompleteViewControllerDelegate {
    // Present the Autocomplete view controller when the button is pressed.
    @objc func autocompleteClicked() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.primaryTextColor = UIColor.black
        autocompleteController.secondaryTextColor = UIColor.lightGray
        autocompleteController.tableCellSeparatorColor = UIColor.lightGray
        autocompleteController.tableCellBackgroundColor = UIColor.white
        
        let attributes:[NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes(attributes, for: .normal)
        
        autocompleteController.delegate = self
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                  UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue))
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        self.parent?.present(autocompleteController, animated: true, completion: nil)
    }
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(String(describing: place.name))")
        print("Place coordinate: \(String(describing: place.coordinate))")
        notificationData = LocationNotification(locationName: place.name, latitude: NSNumber(value: place.coordinate.latitude), longitude: NSNumber(value: place.coordinate.longitude), isFavouriteVenuesNotification: notificationData?.isFavouriteVenuesNotification ?? true, locationRadius: notificationData?.locationRadius)
        delegateLocation?.locationUpdated()
        tableView?.reloadData()
        
        let attributes:[NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes(attributes, for: .normal)
        self.parent?.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.parent?.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
