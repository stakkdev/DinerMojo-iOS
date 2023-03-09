//
//  DMNewsItemViewController.h
//  DinerMojo
//
//  Created by Carl Sanders on 12/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMTabBarViewController.h"
#import "DMNewsItem.h"
#import "DMVenueProtocol.h"
#import "DMDineNavigationController.h"

@interface DMNewsItemViewController : DMTabBarViewController <UIScrollViewDelegate, DMDineNavigationControllerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *newsTextView;
@property (weak, nonatomic) IBOutlet UILabel *newsDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsTermsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet DMButton *restaurantButton;
@property (weak, nonatomic) IBOutlet DMButton *redeemButton;
@property (weak, nonatomic) IBOutlet DMButton *referFriendButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redeemButtonHeightConstraint;
@property BOOL isOffer;
@property BOOL isFromNewsPush;
@property DMNewsItem *selectedItem;

- (IBAction)share:(id)sender;
- (IBAction)viewRestaurant:(id)sender;
- (IBAction)redeemOffer:(id)sender;

@end
