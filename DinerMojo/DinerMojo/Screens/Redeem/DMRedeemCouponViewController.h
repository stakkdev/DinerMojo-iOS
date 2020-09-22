//
//  DMRedeemCouponViewController.h
//  DinerMojo
//
//  Created by Robert Sammons on 17/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import <Shimmer/FBShimmeringView.h>
#import "DMOfferItem.h"
#import "DMDineNavigationController.h"
#import "DinerMojo-Swift.h"
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface DMRedeemCouponViewController : DMTabBarViewController <DMOperationCompletePopUpViewControllerDelegate, DMDineNavigationControllerControllerDelegate, FBSDKSharingDelegate>

@property (weak, nonatomic) IBOutlet DMButton *shownButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *randomCodeLabel;
@property (weak, nonatomic) IBOutlet DMImageView *venueImageView;
@property (weak, nonatomic) IBOutlet DMImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *restaurantImageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *restaurantImageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet FBShimmeringView *viewForShimmer;
@property (weak, nonatomic) IBOutlet UIView *viewToShimmer;

@property (strong, nonatomic) NSDate *todaysDate;
@property (strong, nonatomic) NSDateFormatter *dateFormatTimeDate;
@property (strong, nonatomic) NSDateFormatter *dateFormatTodaysDate;
@property (weak, nonatomic) IBOutlet UILabel *userPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueCuisineAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerDescriptionLabel;

@property DMOfferItem *selectedOfferItem;
@property DMVenue *selectedVenue;
@property DMUser *currentUser;
@property NSNumber *selectedRedeemID;


- (IBAction)done:(id)sender;
- (IBAction)share:(id)sender;

@end
