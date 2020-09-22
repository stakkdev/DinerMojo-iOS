//
//  DMVenuesNotificationCell.swift
//  DinerMojo
//
//  Created by Mike Mikina on 5/2/17.
//  Copyright © 2017 hedgehog lab. All rights reserved.
//

import Foundation

class DMVenuesNotificationCell: UITableViewCell, UITableViewCellLoadableProtocol {
    
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var venuePhoto: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var restaurantTitle: UILabel!
    @IBOutlet weak var restaurantType: UILabel!
    @IBOutlet weak var restaurantAddress: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    var data: DMVenuesNotificationItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }
    
    func loadData(_ data: AnyObject?) {
        
        guard let data = data as? DMVenuesNotificationItem else {
            return
        }

        self.selectedImageView.image = self.getImageWithColor(color: UIColor.gray, size: self.selectedImageView.frame.size)
        if let url = URL(string: data.image) {
            self.selectedImageView.setImageWith(url)
        }
        self.selectedImageView.clipsToBounds = true
        self.selectedImageView.layer.cornerRadius = self.checkImageView.frame.size.height/2
        
        self.selectionView.isHidden = !data.isSelected
        self.checkImageView.isHighlighted = data.isSelected
        self.restaurantAddress.text = data.address
        if data.type != "Default Category" {
            self.restaurantType.isHidden = false
            self.restaurantType.text = data.type
        } else {
            self.restaurantType.isHidden = true
        }
        self.restaurantTitle.text = data.name
        self.restaurantTitle.textColor = data.color
        self.checkImageView.isHighlighted = data.isSelected
        self.data = data
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        if let selected = self.data?.isSelected {
            let newValue = !selected
//            self.selectedImageView.isHidden = newValue
            self.checkImageView.isHighlighted = newValue
            self.selectionView.isHidden = !newValue
            self.data?.isSelected = newValue
        }
    }
    
    private func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
