//
//  DMSortByDistanceCell.swift
//  DinerMojo
//
//  Created by Karol Wawrzyniak on 16/12/2016.
//  Copyright © 2016 hedgehog lab. All rights reserved.
//

import UIKit

class DMSortByDistanceCell: UITableViewCell, UITableViewCellLoadableProtocol  {

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var distanceValueLabel: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!
    var data: DMSortByDistanceItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.leftLabel.text = NSLocalizedString("sort.distance.km", comment: "")
        self.rightLabel.text = NSLocalizedString("sort.distance.anywhere", comment: "")
        self.checkForAvailability()
    }

    func loadData(_ data: AnyObject?) {
        guard let data = data as? DMSortByDistanceItem else {
            return
        }
        
        self.data = data
        self.setDistanceForSlider(value: data.distance)
        self.checkForAvailability()
    }
    
    @IBAction func valueDidChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)

        self.setDistanceForSlider(value: currentValue)
    }
    
    func setDistanceForSlider(value: Int) {
        self.distanceValueLabel.text = "\(value) miles"
        
        if value >= 100 {
            self.distanceValueLabel.isHidden = true
        }
        else {
            self.distanceValueLabel.isHidden = false
        }
        
        self.distanceSlider.value = Float(value)
        self.data?.distance = value
    }
    
    func checkForAvailability() {
        if let data = self.data,
            data.itemId == DistanceFilter.Default.rawValue, data.groupName == GroupsName.DistanceFilter.rawValue {
            let status = DMLocationServices.sharedInstance().isLocationEnabled()
            self.availability(isEnabled: status)
        }
    }
    
    func availability(isEnabled: Bool) {
        self.distanceSlider.isEnabled = isEnabled
        
        if isEnabled {
            self.distanceSlider.alpha = 1
        }
        else {
            self.distanceSlider.alpha = 0.3
        }
    }
}
