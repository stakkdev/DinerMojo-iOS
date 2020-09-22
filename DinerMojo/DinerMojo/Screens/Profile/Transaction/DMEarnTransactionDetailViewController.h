//
//  DMEarnTransactionDetailViewController.h
//  DinerMojo
//
//  Created by Carl Sanders on 12/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMViewController.h"
#import "DMTabBarViewController.h"
#import "DMEarnTransaction.h"
#import "DMTransaction.h"
#import "DMRedeemTransaction.h"

@interface DMEarnTransactionDetailViewController : DMTabBarViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *greenBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *receiptView;
@property (weak, nonatomic) IBOutlet UIImageView *receiptImageView;
@property (weak, nonatomic) IBOutlet DMButton *viewRestaurantButton;
@property (weak, nonatomic) IBOutlet UILabel *amountSavedTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencySavedLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountSpendLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *startingBalanceValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *closingBalanceValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *rejectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property BOOL isEarnTransaction;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property DMTransaction *selectedTransaction;

- (IBAction)showReceiptImage:(id)sender;
- (IBAction)viewRestaurant:(id)sender;
- (IBAction)share:(id)sender;

@end
