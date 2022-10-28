//
//  DMRestaurantInfoViewController.h
//  DinerMojo
//
//  Created by Carl Sanders on 06/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMTabBarViewController.h"
#import "DMVenueImage.h"
#import "DMVenueImage.h"
#import "DMNewsItem.h"
#import <MapKit/MapKit.h>
#import "DMDineNavigationController.h"

@class UICollectionView;

@interface DMRestaurantInfoViewController : DMTabBarViewController <UIScrollViewDelegate, DMDineNavigationControllerControllerDelegate>


#pragma mark - Venue Data

@property (strong, nonatomic) DMVenue *selectedVenue;
@property (strong, nonatomic) DMNewsItem *NewsInfo;
@property (strong, nonatomic) DMVenueImage *venueImage;
@property (strong, nonatomic) DMUser *currentUser;


@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *restaurantImages;
@property (strong, nonatomic) NSArray *recommendedVenuesArray;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UIView *gradientView;


#pragma mark - venueInfo Restaurant Details

@property (weak, nonatomic) IBOutlet UIView *infoShadowView;
@property (weak, nonatomic) IBOutlet DMButton *earnButton;
@property (weak, nonatomic) IBOutlet DMButton *redeemButton;
@property (weak, nonatomic) IBOutlet UILabel *restaurantLocationLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *restautrantTitleName;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImageView;
@property (weak, nonatomic) IBOutlet UILabel *restaurantCuisineLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantBudgetLabel;
@property (weak, nonatomic) IBOutlet UIButton *directionsButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet DMButton *pointsValueButton;
@property (weak, nonatomic) IBOutlet UILabel *featureLabel;
@property (weak, nonatomic) IBOutlet UIButton *navButton;



#pragma mark - venueInfo Special offer Details

@property (weak, nonatomic) IBOutlet UILabel *restaurantSpecialOfferDetailLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *restaurantSpecialOfferHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *restaurantSpecialOfferHeightPaddingConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantSpecialOfficeImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewTop;


- (IBAction)openTripadvisor:(id)sender;
- (IBAction)openMaps:(id)sender;
- (IBAction)showOffer:(id)sender;
- (IBAction)showVenueNews:(id)sender;
- (IBAction)share:(id)sender;
- (IBAction)redeemRestaurant:(id)sender;
- (IBAction)earnRestaurant:(id)sender;
- (IBAction)favoriteVenue:(id)sender;



@end
