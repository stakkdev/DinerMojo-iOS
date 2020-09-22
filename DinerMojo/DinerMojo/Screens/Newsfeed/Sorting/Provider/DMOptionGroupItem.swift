//
//  DMOptionGroupItem.swift
//  DinerMojo
//
//  Created by Karol Wawrzyniak on 15/12/2016.
//  Copyright © 2016 hedgehog lab. All rights reserved.
//

import UIKit

class DMOptionGroupItem: NSObject, TUGroupedTableViewData {
    
    private var groupName: String
    private var subItems: [TUTableViewData]
    private var bgColour: UIColor?
    private var fontColor: UIColor?
    var allowOnlyOneInGroup: Bool
    
    static func create(_ name: String, items: [TUTableViewData], backgroundColor: UIColor?, fontColor: UIColor = UIColor.black) -> DMOptionGroupItem {
        let item = DMOptionGroupItem(name, items: items)
        item.bgColour = backgroundColor
        item.fontColor = fontColor
        return item
    }
    
    init(_ name: String, items: [TUTableViewData]) {
        self.groupName = name
        self.subItems = items
        self.allowOnlyOneInGroup = false
    }
    
    func groupData() -> [TUTableViewData] {
        return self.subItems
    }
    
    func headerReuseID() -> String? {
        return (self.subItems as? [DMVenuesNotificationItem] != nil) ? "DMNotificationVenueHeaderView" : "TUHeaderOptionGroupView"
    }
    
    func footerView() -> UIView? {
        let footer = UIView(frame: CGRect.zero);
        footer.backgroundColor = UIColor.white
        return footer
    }
    
    func decorateHeaderView(_ headerView: UIView) {
        
        if let header = headerView as? DMNotificationVenueHeaderView {
            
            header.headerLabel.text = self.groupName
            
            if let c = self.bgColour {
                header.headerView.backgroundColor = c
            }
            if let c = self.fontColor {
                header.headerLabel.textColor = c
            }
        } else if let header = headerView as? TUHeaderOptionGroupView {
            header.groupLabelName.text = self.groupName
            
            if let c = self.bgColour {
                header.headerContentView.backgroundColor = c
            }
            if let c = self.fontColor {
                header.groupLabelName.textColor = c
            }
        }
        
    }
    
}
