//
//  TestAnalyticsViewController.swift
//  MozQuito
//
//  Created by Josh Campion on 22/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit

import TDCAppDependencies

class TestAnalyticsViewController: UIViewController, AnalyticScreenView {

     var screenName:AnalyticScreen = .Test
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        registerScreenView()
    }
    
    @IBAction func crashTapped() {
        AppDependencies.sharedDependencies().crashReporter?.simulateCrash()
    }

    @IBAction func eventTapped() {
        let testEvent = AnalyticEvent(category: .Test, action: .Test, label: nil)
        AppDependencies.sharedDependencies().analyticsReporter?.sendAnalytic(testEvent)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
