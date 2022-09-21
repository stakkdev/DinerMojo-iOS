//
//  EmailVerifyViewController.swift
//  DinerMojo
//
//  Created by XXX on 31/08/22.
//  Copyright © 2022 hedgehog lab. All rights reserved.
//

import UIKit

class EmailVerifyViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var textFieldEmail: UITextField!
    @objc var viewDismiss: (() -> Void)?
    @objc var setPassword: ((Int, String) -> Void)?
    @IBOutlet weak var btnEmailChanging: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnEmailChanging.titleLabel?.font = UIFont(name: "OpenSans-Italic", size: 13)
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: false) {
            self.viewDismiss?()
        }
    }
    
    @IBAction func emailChangedButtonAction(_ sender: Any) {
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
