//
//  DMPopUpRequest.m
//  DinerMojo
//
//  Created by Patryk on 06/03/2019.
//  Copyright © 2019 hedgehog lab. All rights reserved.
//

#import "DMPopUpRequest.h"

@implementation DMPopUpRequest

- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude andVenue:(int)venue {
    self = [super init];
    if (self) {
        _latitude = latitude;
        _longitude = longitude;
        _venue = venue;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _latitude = 0.0;
        _longitude = 0.0;
        _venue = 0;
    }
    return self;
}

- (void)downloadPopupWithCompletionBlock: (RequestCompletion)completionBlock {
    NSDictionary *params = @{
        @"point": @{
            @"latitude": [NSNumber numberWithDouble:self.latitude],
            @"longitude": [NSNumber numberWithDouble:self.longitude]
        },
        @"venue": [NSNumber numberWithInteger:self.venue]
    };
    [self POST:@"user/me/post_transaction_hint"
        withParams: params
        withCompletionBlock:^(NSError *error, id results) {
            if (error) {
                completionBlock(error, nil);
            } else {
                completionBlock(nil, results);
            }
        }
     ];
}

- (void)sendDontShowAgainWithType:(int)type
               andCompletionBlock:(RequestCompletion)completionBlock {
    NSString *popUpPreference;
    switch (type) {
        case DMAfterTransactionPopUpBookingType:
            popUpPreference = @"show_booking_popup";
            break;
        case DMAfterTransactionPopUpRedeemingType:
            popUpPreference = @"show_redeem_popup";
            break;
        case DMAfterTransactionPopUpReferralType:
            popUpPreference = @"show_refer_popup";
            break;
        case DMAfterTransactionPopUpEarnType:
            popUpPreference = @"show_earn_popup";
            break;
        default:
            return;
    }
    NSDictionary *params = @{
        popUpPreference: @NO
    };
    [self PATCH:@"user/me/popup_preferences"
        withParams:params
        withCompletionBlock:^(NSError *error, id results) {
            if (error) {
                completionBlock(error, nil);
            } else {
                completionBlock(nil, results);
            }
        }
     ];
}

@end
