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
@property (weak, nonatomic) IBOutlet UILabel *myTierLabel;
@property (weak, nonatomic) IBOutlet UIView *secondViewShadowView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rewardTextViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *bDayLabel;
@property (weak, nonatomic) IBOutlet DMImageView *venueImageView;
@property (weak, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *noOffersLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offerDetailsBdayHolderHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offerDetailsTimeHolderHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offerDetailsTimeHolderTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offerDetailsRewardTitleTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offerDetailsBdayHolderTopConstraint;

@property (weak, nonatomic) IBOutlet UILabel *offerDetailsSmallPrintTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *offerDetailsImageView;
@property (weak, nonatomic) IBOutlet UILabel *offerDetailsTitle;
@property (weak, nonatomic) IBOutlet UIView *bDayInfoHolder;
@property (weak, nonatomic) IBOutlet UIView *offerDetailsTimeLeftHolder;
@property (weak, nonatomic) IBOutlet UIImageView *offerDetailsBdayInfoImgView;
@property (weak, nonatomic) IBOutlet UIImageView *offerDetailsTimeImgView;
@property (weak, nonatomic) IBOutlet UILabel *offerDetailsTimeLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerDetailsRewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerDetailsSmallPrintLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *detailsScrollview;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *userNewPointsLabel;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileInitialsLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) DMOfferItem *initialOffer;

@property (nonatomic) IBOutlet NSLayoutConstraint *redeemButtonBottom;
@property (nonatomic) UIImage *offerImage;
@property (nonatomic) UIImage *cakeImage;
@property (nonatomic) UIImage *trophyImage;
@property (nonatomic) UIImage *placeholder;
@property (nonatomic) NSMutableDictionary *birthdayOffers;

@property DMVenue *selectedVenue;
@property DMOfferItem *selectedOfferItem;
@property DMUser *currentUser;
@property BOOL isRedeeming;
@property BOOL standardRedeem;
@property NSNumber *selectedRedeemID;
@property BOOL *shouldCloseOnButtonTap;
- (IBAction)dismissView:(id)sender;
- (IBAction)processCoupon:(id)sender;

@end
