//
//  DMPopUpRequest.h
//  DinerMojo
//
//  Created by Patryk on 06/03/2019.
//  Copyright © 2019 hedgehog lab. All rights reserved.
//

#ifndef DMPopUpRequest_h
#define DMPopUpRequest_h

#import "DMRequest.h"

static const int DMAfterTransactionPopUpBookingType = 0;
static const int DMAfterTransactionPopUpRedeemingType = 1;
static const int DMAfterTransactionPopUpReferralType = 2;
static const int DMAfterTransactionPopUpEarnType = 3;

@interface DMPopUpRequest : DMRequest

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) int venue;

-(instancetype)initWithLatitude:(double)latitude
                      longitude:(double)longitude
                       andVenue:(int)venue;

-(void)downloadPopupWithCompletionBlock:(RequestCompletion)completionBlock;
-(void)sendDontShowAgainWithType:(int)type andCompletionBlock:(RequestCompletion)completionBlock;

@end

#endif /* DMPopUpRequest_h */
