//
//  CannotRedeemViewController.swift
//  DinerMojo
//
//  Created by Michał Łubgan on 28.03.2018.
//  Copyright © 2018 hedgehog lab. All rights reserved.
//

import UIKit

@objc class CannotRedeemViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    
    @objc var venue: DMVenue?
    @objc var imageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        let request = DMRequest()
        if let imageUrl = imageUrl, let url = URL(string: request.buildMediaURL(imageUrl)) {
            imageView.setImageWith(url)
        } else if let url = URL(string: venue?.primaryImage().fullURL() ?? "") {
            imageView.setImageWith(url)
        }
        
        if let venue = venue {
            if venue.last_redeem_name() != nil && venue.last_redeem() != nil {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm dd MMMM yyyy"
                let redeemDate = formatter.string(from: venue.last_redeem())
                let fullContent = String(format: NSLocalizedString("reedem.notAvailable.extended.description", comment: ""), venue.name(), venue.last_redeem_name(), redeemDate)
                let font = UIFont.init(name: "OpenSans", size: 15)!
                let largerFont = UIFont.init(name: "OpenSans", size: 17)!
                let attributedContent = DMAttributedStringDecorator.attributedStrings(fullString: fullContent, boldStrings: [venue.last_redeem_name(), redeemDate], font: font, boldFont: largerFont)
                descLabel.attributedText = attributedContent
                
                return
            }
            
            descLabel.text = String(format: NSLocalizedString("reedem.notAvailable.description", comment: ""), venue.name())
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        dismiss(animated: true, completion: nil)
    }
    
    private func setup() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 0)
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
    }
    
}
