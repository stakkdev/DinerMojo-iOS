//
//  DMLocationInfoItemCell.swift
//  DinerMojo
//
//  Created by Mike Mikina on 4/11/17.
//  Copyright © 2017 hedgehog lab. All rights reserved.
//

import QuartzCore

class DMLocationInfoItemCell: UIView  {
    
    @IBOutlet weak var itemContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let color = UIColor.init(hexString: "#2F9F93") {
            self.itemContainer.layer.borderColor = color.cgColor
        }
    }
    
    @IBAction func openSettings(_ sender: Any) {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.openURL(url)
        }
    }
}
