//
//  DMRedeemViewController.h
//  DinerMojo
//
//  Created by Robert Sammons on 17/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMOfferItem.h"

@interface DMRedeemViewController : DMTabBarViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontal;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *right;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) NSArray *eligibleOffersArray;

@property (weak, nonatomic) IBOutlet DMImageView *venueImageView;
@property (weak, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueCuisineAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *noOffersLabel;

@property (weak, nonatomic) IBOutlet UILabel *confirmRedeemLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *userNewPointsLabel;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileInitialsLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) DMOfferItem *initialOffer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redeemButtonBottom;

@property DMVenue *selectedVenue;
@property DMOfferItem *selectedOfferItem;
@property DMUser *currentUser;
@property BOOL isRedeeming;
@property NSNumber *selectedRedeemID;

- (IBAction)dismissView:(id)sender;
- (IBAction)processCoupon:(id)sender;

@end
