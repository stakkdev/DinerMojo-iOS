//
//  DMAfterTransactionPopUpViewController.m
//  DinerMojo
//
//  Created by Patryk on 07/03/2019.
//  Copyright © 2019 hedgehog lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMAfterTransactionPopUpViewController.h"

#import "DinerMojo-Swift.h"

@interface DMAfterTransactionPopUpViewController()

@end

@implementation DMAfterTransactionPopUpViewController

#pragma mark - static build methods

+ (DMAfterTransactionPopUpViewController *)buildBookingAfterTransactionPopUpWithDelegate:(id<DMOperationCompletePopUpViewControllerDelegate>)delegate venueName:(NSString *)venueName andVenueId:(NSNumber *)venueId {
    NSString *title = @"Book using DinerMojo";
    NSString *description = [NSString stringWithFormat:@"It is simple and makes it easier for our restaurants to make sure you get your favourite table. Just mention in comments and they will do their best for you. Check it out for %@ below.", venueName];
    NSString *buttonTitle = @"Take a look";
    NSString *type = @"Booking";
    return [DMAfterTransactionPopUpViewController buildWithType:type
                                                       delegate:delegate
                                                          title:title
                                                    description:description
                                                    buttonTitle:buttonTitle
                                                        venueId:venueId];
}

+ (DMAfterTransactionPopUpViewController *)buildRefferalAfterTransactionPopUpWithDelegate:(id<DMOperationCompletePopUpViewControllerDelegate>)delegate {
    NSString *title = @"Refer friends and earn more points";
    NSString *description = @"Refer friends to DinerMojo and you get 100 points and they get 100 points. Then earn 10% of any points they earn for a full year. It’s easy and you get points for helping them enjoy DinerMojo. Get started now.";
    NSString *buttonTitle = @"Take a look";
    NSString *type = @"Referral";
    return [DMAfterTransactionPopUpViewController buildWithType:type
                                                       delegate:delegate
                                                          title:title
                                                    description:description
                                                    buttonTitle:buttonTitle
                                                        venueId:nil];
}

+ (DMAfterTransactionPopUpViewController *)buildRedeemingPointsAfterTransactionPopUpWithDelegate:(id<DMOperationCompletePopUpViewControllerDelegate>)delegate venueName:(NSString *)venueName andVenueId:(NSNumber *)venueId {
    NSString *title = [NSString stringWithFormat:@"Great rewards at %@", venueName];
    NSString *description = [NSString stringWithFormat:@"You can use points you earned at any venue where you see the yellow present icon, not just this one. Take a look at the rewards you could get at %@.", venueName];
    NSString *buttonTitle = @"Take a look";
    NSString *type = @"Redeeming points";
    return [DMAfterTransactionPopUpViewController buildWithType:type
                                                       delegate:delegate
                                                          title:title
                                                    description:description
                                                    buttonTitle:buttonTitle
                                                        venueId:venueId];
}

+ (DMAfterTransactionPopUpViewController *)buildEarnAfterTransactionPopUpWithDelegate:(id<DMOperationCompletePopUpViewControllerDelegate>)delegate venueName:(NSString *)venueName andVenueId:(NSNumber *)venueId {
    NSString *title = [NSString stringWithFormat:@"Earn points at %@", venueName];
    NSString *description = @"You can earn points at many other independent venues that we think you should try because they are so amazing. Find them on DinerMojo; Restaurants and Lifestyle, enjoy the experience and collect points to use wherever you see the present icon.";
    NSString *buttonTitle = @"Take a look";
    NSString *type = @"Earn";
    return [DMAfterTransactionPopUpViewController buildWithType:type
                                                       delegate:delegate
                                                          title:title
                                                    description:description
                                                    buttonTitle:buttonTitle
                                                        venueId:venueId];
}

+ (DMAfterTransactionPopUpViewController *)buildWithType:(NSString *)type
                                                delegate:(id<DMOperationCompletePopUpViewControllerDelegate>)delegate
                                                   title:(NSString *)title
                                             description:(NSString *)description
                                             buttonTitle:(NSString *)buttonTitle
                                                 venueId:(NSNumber *)venueId {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIColor *titleColor = [UIColor colorWithRed:(245/255.f) green:(147/255.f) blue:(54/255.f) alpha:1];
    
    DMAfterTransactionPopUpViewController *operationCompletePopUpViewController = (DMAfterTransactionPopUpViewController *)[storyboard instantiateViewControllerWithIdentifier:@"operationComplete"];
    [operationCompletePopUpViewController setType:type];
    [operationCompletePopUpViewController setDelegate:delegate];
    [operationCompletePopUpViewController setColor:titleColor];
    [operationCompletePopUpViewController setStatus:DMOperationCompletePopUpViewControllerStatusSuccess];
    [operationCompletePopUpViewController setPopUpTitle:title];
    [operationCompletePopUpViewController setPopUpDescription:description];
    [operationCompletePopUpViewController setActionButtonTitle:buttonTitle];
    [operationCompletePopUpViewController setEffectStyle:UIBlurEffectStyleExtraLight];
    [operationCompletePopUpViewController setShoulHideDontShowAgainButton:NO];
    if (venueId) {
        [operationCompletePopUpViewController setVenueId:venueId];
    }
    [operationCompletePopUpViewController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    return operationCompletePopUpViewController;
}

@end
