//
//  StartupViewController.swift
//  DinerMojo
//
//  Created by Michał Łubgan on 10.05.2017.
//  Copyright © 2017 hedgehog lab. All rights reserved.
//

import UIKit

class StartupViewController: UIViewController {
    
    @IBOutlet weak var descLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        let text = NSLocalizedString("startup.desc1", comment: "")
        let text2 = NSLocalizedString("startup.desc2", comment: "")
        let text3 = NSLocalizedString("startup.desc3", comment: "")
        
        let attrString = NSMutableAttributedString(string: text)
        
        let newsfeedAttachment = NSTextAttachment()
        newsfeedAttachment.image = UIImage(named: "news_offers")
        let newsfeedAttributedString = NSAttributedString(attachment: newsfeedAttachment)
        
        let rewardAttachment = NSTextAttachment()
        rewardAttachment.image = UIImage(named: "redeem_icon_enabled")
        let rewardAttributedString = NSAttributedString(attachment: rewardAttachment)
        
        attrString.append(newsfeedAttributedString)
        attrString.append(NSAttributedString(string: text2))
        attrString.append(rewardAttributedString)
        attrString.append(NSAttributedString(string: text3))
        
        descLabel.attributedText = attrString
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        self.view.removeFromSuperview()
    }
    
}
