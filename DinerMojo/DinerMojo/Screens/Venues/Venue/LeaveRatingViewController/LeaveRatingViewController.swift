//
//  LeaveRatingViewController.swift
//  DinerMojo
//
//  Created by Michał Łubgan on 27.03.2018.
//  Copyright © 2018 hedgehog lab. All rights reserved.
//

import UIKit
import SDWebImage

class LeaveRatingViewController: DMViewController {
    
    weak var earnViewController: UIViewController?
    
    var venue: DMVenue?
    
    @IBOutlet weak var venueImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBAction func openTripAdvisor(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let url = venue?.trip_advisor_link(), let webViewController = sb.instantiateViewController(withIdentifier: "webView") as? DMWebViewController {
            webViewController.webURL = url
            webViewController.delegate = self
            let nav = UINavigationController(rootViewController: webViewController)
            nav.modalPresentationStyle = .overFullScreen
            present(nav, animated: true, completion: nil)
        }
    }
    
    @IBAction func skipForNow(_ sender: Any) {
        presentAfterTransactionPopUp()
    }
    
    init(venue: DMVenue?) {
        self.venue = venue
        super.init(nibName: "LeaveRatingViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        guard let name = venue?.name() else { return }
        descriptionLabel.text = String(format: NSLocalizedString("rating.desc", comment: ""), name)
        if let url = URL(string: venue?.primaryImage().fullURL() ?? "") {
            venueImageView.sd_setImage(with: url, placeholderImage: nil)
        }
        
        venueImageView.layer.cornerRadius = venueImageView.frame.size.height / 2
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 0)
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
    }

    fileprivate func presentAfterTransactionPopUp() {
        guard let venueId = venue?.modelIDValue else { return }
        AfterTransactionPopUpManager.downloadPopUpModel(forVenue: Int(venueId)) { (model) in
            DispatchQueue.main.async {
                guard let model = model else {
                    self.earnViewController?.dismiss(animated: true, completion: nil)
                    return
                }
                let popUpVc = AfterTransactionPopUpManager.createPopUp(withModel: model, forDelegate: self)
                popUpVc.modalPresentationStyle = .overFullScreen
                self.present(popUpVc, animated: true, completion: nil)
            }
        }
    }
}

extension LeaveRatingViewController: DMWebViewControllerDelegate {
    func didDismissViewController() {
        presentAfterTransactionPopUp()
    }
}

// MARK: DMOperationCompletePopUpViewControllerDelegate implementation
extension LeaveRatingViewController {
    override func actionButtonPressed(fromOperationCompletePopupViewController operationCompletePopupViewController: DMOperationCompletePopUpViewController!) {
        DispatchQueue.main.async { [weak self] in
            self?.earnViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    override func actionButtonPressed(fromOperationCompletePopupViewController operationCompletePopupViewController: DMAfterTransactionPopUpViewController!, ofType type: String!) {
        operationCompletePopupViewController.dismiss(animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if type == "Booking" || type == "Redeeming points" {
            let vc = storyboard.instantiateViewController(withIdentifier: "DMRestaurantInfo")
            let venue = DMVenue.mr_findFirst(byAttribute: "modelID", withValue: operationCompletePopupViewController.venueId)
            guard let restaurantVc = vc as? DMRestaurantInfoViewController else { return }
            restaurantVc.selectedVenue = venue
            guard let dmNavController = presentingViewController as? DMDineNavigationController else { return }
            dmNavController.dineComplete(withVc: restaurantVc)
        } else if type == "Referral" {
            let vc = storyboard.instantiateViewController(withIdentifier: "DMReferAFriendViewController")
            let user = userRequest.currentUser()
            guard let points = user?.referred_pointsValue else { return }
            guard let referVc = vc as? DMReferAFriendViewController else { return }
            referVc.referredPoints = NSString(format: "%hd", points)
            guard let dmNavController = presentingViewController as? DMDineNavigationController else { return }
            dmNavController.dineComplete(withVc: referVc)
        }
    }
    
    override func ready(toDissmisOperationCompletePopupViewController operationCompletePopupViewController: DMOperationCompletePopUpViewController!) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
}
