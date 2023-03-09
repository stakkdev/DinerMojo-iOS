//
//  EarnNotificationTapVC.swift
//  DinerMojo
//
//  Created by Chauhan on 24/02/23.
//  Copyright © 2023 hedgehog lab. All rights reserved.
//

import UIKit

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

class EarnNotificationTapVC: UIViewController {
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblHeaderText: UILabel!
    @IBOutlet weak var vwPopUp: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @objc var viewDismiss: (() -> Void)?
    @objc var setPassword: ((Int, String) -> Void)?
    
    @objc var emailText: String = ""
    
    @objc var newsID: NSNumber = 1

    
    // MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print("model new id is:", newsID)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.vwPopUp.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
    }
    
    // MARK: - All Button Action Methods
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: false) {
            self.viewDismiss?()
        }
    }
    
    @IBAction func likeButtonAction(_ sender: Any) {
        self.callLikeDislikeAPI(isLike: true)
        
    }
    
    @IBAction func dislikeButtonAction(_ sender: Any) {
        self.callLikeDislikeAPI(isLike: false)
    }
    
    private func callLikeDislikeAPI(isLike: Bool) {
        activityIndicator.startAnimating()
        btnClose.isHidden = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let userRequest = DMUserRequest()
        userRequest.likeDislikeEarnNotification(newsID, to: NSNumber(value: isLike), completionBlock: { error, response  in
            if error == nil {
                if let resp = response as? [String: Any] {
                    debugPrint("resp--\(resp)")
                    //if let userID = resp["id"] as? Int {
                        //debugPrint("userID--\(userID)")
                        self.dismiss(animated: false)
                    //{
//                        }
//                    } else {
//                        self.showOkAlert(title: "Error", message: "Something went wrong, please try again later" )
//                    }
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
