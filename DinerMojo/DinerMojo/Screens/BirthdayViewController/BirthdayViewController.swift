//
//  BirthdayViewController.swift
//  DinerMojo
//
//  Created by Michał Łubgan on 27.03.2018.
//  Copyright © 2018 hedgehog lab. All rights reserved.
//

import UIKit

@objc class BirthdayViewController: UIViewController {
    
    weak var venuesTabBarController: UITabBarController?
    
    @IBAction func setBirthdayDate(_ sender: Any) {
        UserDefaults.standard.set(Date(), forKey: "setBirthday")
        venuesTabBarController?.selectedIndex = 2
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "DMEditProfileViewController") as? DMEditProfileViewController else { return }
        venuesTabBarController?.selectedViewController?.show(vc, sender: self)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func skipForNow(_ sender: Any) {
        UserDefaults.standard.set(Date(), forKey: "setBirthday")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func skipForever(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "disabledBirthdayPopup")
        dismiss(animated: true, completion: nil)
    }
    
    @objc init(tabBar: UITabBarController) {
        self.venuesTabBarController = tabBar
        super.init(nibName: "BirthdayViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
