//
//  SimpleRadioTableViewCell.swift
//  DinerMojo
//
//  Created by Kristyna Fojtikova on 25/03/2021.
//  Copyright © 2021 hedgehog lab. All rights reserved.
//

import UIKit

class SimpleRadioTableViewCell: UITableViewCell {
    
    // MARK: References
    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    private var enabled: Bool = false {
        didSet {
            updateUI()
        }
    }

    // MARK: Initialise
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    // MARK: - Public functions
    
    @objc public func setup(with title: String, and enabled: Bool) {
        self.nameLabel.text = title
        self.enabled = enabled
    }
    
    @objc public func toggleEnabled(to newValue: Bool) {
        self.enabled = newValue
    }
    
    // MARK: - Private functions
    
    private func updateUI() {
        updateButtonImage()
        updateLabelColor()
    }
    
    private func updateButtonImage() {
        let selectedImage = UIImage(named: "SelectedCheckMark22")
        let unselectedImage = UIImage(named: "UnselectedCheckMark22")
        radioButton.setImage(enabled ? selectedImage : unselectedImage, for: .normal)
    }
    
    private func updateLabelColor() {
        self.nameLabel.isHighlighted = enabled
        
    }
    
}
