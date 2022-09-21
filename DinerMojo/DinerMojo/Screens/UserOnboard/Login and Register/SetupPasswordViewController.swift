//
//  SetupPasswordViewController.swift
//  DinerMojo
//
//  Created by XXX on 31/08/22.
//  Copyright © 2022 hedgehog lab. All rights reserved.
//

import UIKit

class SetupPasswordViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var textFieldVerificationCode: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @objc var viewDismiss: (() -> Void)?
    @objc var successSetupPassword: (() -> Void)?
    @objc var userId: Int = 0
    @objc var emailId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: false) {
            self.viewDismiss?()
        }
    }
    
    @IBAction func setupPasswordButtonAction(_ sender: Any) {
        if textFieldVerificationCode.text?.isEmpty ?? true {
            showOkAlert(title: "Error", message: "Please enter valid Verification Code.")
        } else if textFieldPassword.text?.count ?? 0 < 6 {
            showOkAlert(title: "Error", message: "Your password needs to be atleast 6 characters long.")
        } else {
            callFacebookSetupPasswordAPI()
        }
    }
    
    private func callFacebookSetupPasswordAPI() {
        activityIndicator.startAnimating()
        btnClose.isHidden = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let userRequest = DMUserRequest()
        userRequest.facebookEmailVerification("\(userId)", otp: textFieldVerificationCode.text ?? "", password: textFieldPassword.text ?? "") { error, response in
            if error == nil {
                if let resp = response as? [String: Any] {
                    debugPrint("resp--\(resp)")
                    userRequest.login(withEmail: self.emailId, password: self.textFieldPassword.text ?? "") { error, response in
                        if error == nil {
                            self.dismiss(animated: false) {
                                self.successSetupPassword?()
                            }
                        } else {
                            self.showOkAlert(title: "Error", message: "Something went wrong, please try again later" )
                        }
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.activityIndicator.stopAnimating()
                        self.btnClose.isHidden = false
                    }
                    
                } else {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.activityIndicator.stopAnimating()
                    self.btnClose.isHidden = false
                    self.showOkAlert(title: "Error", message: "Something went wrong, please try again later" )
                }
            } else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.activityIndicator.stopAnimating()
                self.btnClose.isHidden = false
                self.showOkAlert(title: "Error", message: "Something went wrong, please try again later" )
            }
        }
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
