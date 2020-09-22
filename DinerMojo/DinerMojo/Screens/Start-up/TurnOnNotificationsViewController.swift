//
//  TurnOnNotificationsViewController.swift
//  DinerMojo
//
//  Created by Jaroslav Chaninovicz on 07/12/2017.
//  Copyright © 2017 hedgehog lab. All rights reserved.
//

import UIKit

class TurnOnNotificationsViewController: UIViewController {
    @IBOutlet weak var goToSettingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFiredTimes()
        goToSettingsButton.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(appCameFromBackground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    private func updateFiredTimes() {
        if let numberOfTimes = UserDefaults.standard.value(forKey: "turnOnNotificationPopUpFired") as? Int {
            UserDefaults.standard.set(numberOfTimes + 1, forKey: "turnOnNotificationPopUpFired")
        } else {
            UserDefaults.standard.set(1, forKey: "turnOnNotificationPopUpFired")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissMyself()
    }
    
    @objc private func goToSettings() {
        UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    @objc internal func appCameFromBackground() {
        SGNotificationsSettings.isPushNotificationsEnabled { (enabled) in
            if enabled {
                self.dismissMyself()
            }
        }
    }
    
    private func dismissMyself() {
        UserDefaults.standard.set(Date(), forKey: "turnOnNotification")
        NotificationCenter.default.removeObserver(self)
        dismiss(animated: true, completion: nil)
    }
}
