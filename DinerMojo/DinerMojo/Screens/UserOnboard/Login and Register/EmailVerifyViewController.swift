//
//  EmailVerifyViewController.swift
//  DinerMojo
//
//  Created by XXX on 31/08/22.
//  Copyright © 2022 hedgehog lab. All rights reserved.
//

import UIKit
import MessageUI

class EmailVerifyViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var lblHeaderText: UILabel!

    @objc var viewDismiss: (() -> Void)?
    @objc var setPassword: ((Int, String) -> Void)?
    @IBOutlet weak var btnEmailChanging: UIButton!
    
    @objc var emailText: String = ""
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnEmailChanging.titleLabel?.font = UIFont(name: "OpenSans-Italic", size: 13)
        
        if emailText.count > 2 {
            self.lblHeaderText.text = "We've moved away from Facebook sign-ins.\n\nWe want to protect DinerMojo members’ privacy and reduce the amount of exposure to third-party app tracking. As part of this, Facebook Log In is no longer available.\n\nClick the button below to set up a password. Once you've set up a password, you'll be able to sign in with that and your email address."
            self.textFieldEmail.text = self.emailText
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: false) {
            self.viewDismiss?()
        }
    }
    
    @IBAction func emailChangedButtonAction(_ sender: Any) {
        
        /*
         open email client with pre-populated fields:
         To: mailto:admin@highnetwork.co.uk
         Subject: Search Request
         */
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["team@dinermojo.com"])
            mail.setSubject("Already Changed Email")
            mail.setMessageBody("<p>Your 'old' email address:<br><br>Name:<br><br>Add a couple of venue names for venues that you have earned at or redeemed rewards at recently:<br><br></p>", isHTML: true)
            present(mail, animated: true)
        } else {
            // show failure alert
            showOkAlert(title: "Error", message: "Mail not configured on your device.")
        }
    }
    
    @IBAction func setupPasswordButtonAction(_ sender: Any) {
        if let email = textFieldEmail.text, email.isValidEmail() {
            callFacebookEmailVerifyAPI()
        } else {
            showOkAlert(title: "Error", message: "Please enter valid email id.")
        }
    }
    
    private func callFacebookEmailVerifyAPI() {
        activityIndicator.startAnimating()
        btnClose.isHidden = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let userRequest = DMUserRequest()
        userRequest.facebookEmailUpdate(textFieldEmail.text ?? "", completionBlock: { error, response  in
            if error == nil {
                if let resp = response as? [String: Any] {
                    debugPrint("resp--\(resp)")
                    if let userID = resp["id"] as? Int {
                        debugPrint("userID--\(userID)")
                        self.dismiss(animated: false) {
                            self.setPassword?(userID, self.textFieldEmail.text ?? "")
                        }
                    } else {
                        self.showOkAlert(title: "Error", message: "Something went wrong, please try again later" )
                    }
                }
            } else {
                self.showOkAlert(title: "Error", message: "Something went wrong, please try again later" )
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.activityIndicator.stopAnimating()
            self.btnClose.isHidden = false
        })

    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
