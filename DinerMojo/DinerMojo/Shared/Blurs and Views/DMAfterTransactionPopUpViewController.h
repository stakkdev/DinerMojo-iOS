//
//  DMAfterTransactionPopUpViewController.h
//  DinerMojo
//
//  Created by Patryk on 07/03/2019.
//  Copyright © 2019 hedgehog lab. All rights reserved.
//

#ifndef AfterTransactionPopUpViewController_h
#define AfterTransactionPopUpViewController_h

#import "DMOperationCompletePopUpViewController.h"

@interface DMAfterTransactionPopUpViewController : DMOperationCompletePopUpViewController

+ (DMAfterTransactionPopUpViewController *) buildRedeemingPointsAfterTransactionPopUpWithDelegate:(id<DMOperationCompletePopUpViewControllerDelegate>)delegate venueName:(NSString *)venueName andVenueId:(NSNumber *)venueId;
+ (DMAfterTransactionPopUpViewController *) buildBookingAfterTransactionPopUpWithDelegate:(id<DMOperationCompletePopUpViewControllerDelegate>)delegate venueName:(NSString *)venueName andVenueId:(NSNumber *)venueId;
+ (DMAfterTransactionPopUpViewController *) buildRefferalAfterTransactionPopUpWithDelegate:(id<DMOperationCompletePopUpViewControllerDelegate>)delegate;
+ (DMAfterTransactionPopUpViewController *)buildEarnAfterTransactionPopUpWithDelegate:(id<DMOperationCompletePopUpViewControllerDelegate>)delegate venueName:(NSString *)venueName andVenueId:(NSNumber *)venueId;

@end

#endif /* AfterTransactionPopUpViewController_h */
