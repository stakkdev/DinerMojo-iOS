//
//  AfterTransactionPopUpManager.swift
//  DinerMojo
//
//  Created by Patryk on 07/03/2019.
//  Copyright © 2019 hedgehog lab. All rights reserved.
//

import Foundation

@objc class AfterTransactionPopUpManager: NSObject {

    @objc static func downloadPopUpModel(forVenue venueId: Int, completion: @escaping (PopUpModel?) -> Void) {
        guard let location = DMLocationServices.sharedInstance()?.currentLocation else {
            completion(nil)
            return
        }
        let request = DMPopUpRequest(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            andVenue: Int32(venueId)
        )
        request?.downloadPopup(completionBlock: { (error, result) in
            guard let result = result as? [String: Any], error == nil,
                let model = PopUpModel(json: result as NSDictionary) else {
                    completion(nil)
                    return
            }
            completion(model)
        })
    }

    @objc static func createPopUp(withModel model: PopUpModel, forDelegate delegate: DMOperationCompletePopUpViewControllerDelegate) -> DMAfterTransactionPopUpViewController {
        let type = model.type
        switch type {
        case "Booking":
            return DMAfterTransactionPopUpViewController.buildBookingAfterTransactionPopUp(with: delegate, venueName: model.venueName, andVenueId: NSNumber(integerLiteral: model.venueId ?? 0))
        case "Redeeming points":
            return DMAfterTransactionPopUpViewController.buildRedeemingPointsAfterTransactionPopUp(with: delegate, venueName: model.venueName, andVenueId: NSNumber(integerLiteral: model.venueId ?? 0))
        case "Referral":
            return DMAfterTransactionPopUpViewController.buildRefferalAfterTransactionPopUp(with: delegate)
        case "Earn":
            return DMAfterTransactionPopUpViewController.buildEarnAfterTransactionPopUp(with: delegate, venueName: model.venueName, andVenueId: NSNumber(integerLiteral: model.venueId ?? 0))
        default:
            return DMAfterTransactionPopUpViewController.buildRefferalAfterTransactionPopUp(with: delegate)
        }
    }
}
