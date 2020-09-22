//
//  PopUpModel.swift
//  DinerMojo
//
//  Created by Patryk on 06/03/2019.
//  Copyright © 2019 hedgehog lab. All rights reserved.
//

import Foundation

@objc class PopUpModel: NSObject {
    let id: Int
    let venueName: String?
    let venueId: Int?
    let type: String
    let dateCreated: String
    let user: Int
    
    init?(json: NSDictionary) {
        guard let popUpDict = json["popup"] as? [String: Any] else { return nil }
        guard let id = popUpDict["id"] as? Int else { return nil }
        if let venueDict = popUpDict["venue"] as? [String: Any] {
            self.venueName = venueDict["name"] as? String
            self.venueId = venueDict["id"] as? Int
        } else {
            self.venueName = nil
            self.venueId = nil
        }
        guard let typeName = popUpDict["type"] as? String else { return nil }
        guard let dateCreated = popUpDict["date_created"] as? String else { return nil }
        guard let user = popUpDict["user"] as? Int else { return nil }
        
        self.id = id
        self.type = typeName
        self.dateCreated = dateCreated
        self.user = user
    }
}

// Static mock objects
extension PopUpModel {
    static var mockRedeemingPointsModel: PopUpModel? {
        let json: [String: Any] = [
            "popup": [
                "id": 10,
                "venue": [
                    "name": "Some name",
                    "id": 48 // Ros Ana
                ],
                "type": "Redeeming points",
                "date_created": "2019-03-04T12:25:05.358142Z",
                "user": 701
            ]
        ]
        return PopUpModel(json: json as NSDictionary)
    }
    
    static var mockBookingModel: PopUpModel? {
        let json: [String: Any] = [
            "popup": [
                "id": 10,
                "venue": [
                    "name": "Some name",
                    "id": 48 // Ros Ana
                ],
                "type": "Booking",
                "date_created": "2019-03-04T12:25:05.358142Z",
                "user": 701
            ]
        ]
        return PopUpModel(json: json as NSDictionary)
    }
    
    static var mockReferralModel: PopUpModel? {
        let json: [String: Any] = [
            "popup": [
                "id": 10,
                "venue": [
                    "name": "Some name"
                ],
                "type": "Referral",
                "date_created": "2019-03-04T12:25:05.358142Z",
                "user": 701
            ]
        ]
        return PopUpModel(json: json as NSDictionary)
    }
}
