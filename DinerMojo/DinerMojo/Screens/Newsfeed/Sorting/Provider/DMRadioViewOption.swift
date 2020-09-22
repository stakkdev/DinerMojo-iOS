//
//  DMRadioViewOption.swift
//  DinerMojo
//
//  Created by Mike Mikina on 4/23/17.
//  Copyright © 2017 hedgehog lab. All rights reserved.
//

import UIKit
import SnapKit

@objc class DMRadioViewOption: UIView {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @objc class func instanceFromNib() -> DMRadioViewOption {
        return UINib(nibName: "DMRadioViewOption", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DMRadioViewOption
    }
    
    @objc func setupView(parent: UIView, title: String) -> UIButton {
        self.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(self)
        self.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(parent)
        }
        
        self.titleLabel.text = title
        return self.button
    }
    
    @objc func setSelected(selected: Bool) {
        self.button.isSelected = selected
        self.titleLabel.isHighlighted = selected
    }
}
