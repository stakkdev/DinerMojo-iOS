//
//  DMDineViewController.h
//  DinerMojo
//
//  Created by Carl Sanders on 08/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMTabBarViewController.h"
#import "DMVenueModelController.h"
#import "DMDineNavigationController.h"
#import "DMOfferItem.h"

@interface DMDineViewController : DMTabBarViewController <UITableViewDelegate, DMDineNavigationControllerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet DMButton *closestButton;
@property (weak, nonatomic) IBOutlet DMButton *pointsValueButton;
@property (weak, nonatomic) IBOutlet DMButton *recentButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSArray *resultsArray;
@property (strong, nonatomic) NSMutableArray* dineArray;

@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;

@property (weak, nonatomic) DMOfferItem *initialOffer;

- (IBAction)recentButtonPressed:(id)sender;
- (IBAction)closeButtonTapped:(id)sender;
- (IBAction)closestButtonPressed:(id)sender;
- (IBAction)redeemRestaurant:(id)sender;
- (IBAction)earnRestaurant:(id)sender;

@end
