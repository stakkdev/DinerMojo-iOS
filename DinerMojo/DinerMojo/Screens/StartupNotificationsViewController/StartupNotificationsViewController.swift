//
//  StartupNotificationsViewController.swift
//  DinerMojo
//
//  Created by Michał Łubgan on 27.07.2017.
//  Copyright © 2017 hedgehog lab. All rights reserved.
//

import UIKit
import FBSDKShareKit

class StartupNotificationsViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    
    @IBAction func openSettings(_ sender: Any) {
        guard let presentingVC = (self.presentingViewController as? UITabBarController)?.selectedViewController else { return }
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "DMNotificationSettingsViewController") as? DMNotificationSettingsViewController else { return }
        presentingVC.show(vc, sender: self)
        presentingVC.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissPopup(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        self.view.removeFromSuperview()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
        tapGesture.numberOfTapsRequired = 1
        self.topView.addGestureRecognizer(tapGesture)
    }
    
}
