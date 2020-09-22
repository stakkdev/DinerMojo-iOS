//
//  DMRadioSortOptionCell.swift
//  DinerMojo
//
//  Created by Karol Wawrzyniak on 15/12/2016.
//  Copyright © 2016 hedgehog lab. All rights reserved.
//

import UIKit

class DMRadioSortOptionCell: UITableViewCell, UITableViewCellLoadableProtocol, TableViewSelectForGroup {

    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    var data: DMRadioSortOptionItem?
    var clickCallback: (() -> ())?

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        self.checkForAvailability()
    }
    
    func checkForAvailability() {
        if let data = self.data,
            data.itemId == SortByItems.NearestItem.rawValue, data.groupName == GroupsName.SortBy.rawValue {
            let status = DMLocationServices.sharedInstance().isLocationEnabled()
            self.availability(isEnabled: status)
        }
        else {
            self.nameLabel.textColor = UIColor(hexString: "#000000", alpha: 1)
        }
    }
    
    func availability(isEnabled: Bool) {
        if isEnabled {
            self.nameLabel.textColor = UIColor(hexString: "#000000", alpha: 1)
        }
        else {
            self.nameLabel.textColor = UIColor(hexString: "#DFE1E4", alpha: 1)
        }
    }

    func loadData(_ data: AnyObject?) {

        guard let data = data as? DMRadioSortOptionItem else {
            return
        }

        self.nameLabel.text = data.name
        self.data = data
        
        if let selected = self.data?.isSelected {
            self.radioButton.isSelected = selected
            self.nameLabel.isHighlighted = selected
        }
        
        self.checkForAvailability()
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        if let data = self.data,
            data.itemId == SortByItems.NearestItem.rawValue {
            if !DMLocationServices.sharedInstance().isLocationEnabled() {
                return
            }
        }
        
        if let selected = self.data?.isSelected {
            let newValue = !selected
            
            self.radioButton.isSelected = newValue
            self.nameLabel.isHighlighted = newValue
            self.data?.isSelected = newValue
            
            if let click = self.clickCallback {
                click()
            }
        }
    }
}
