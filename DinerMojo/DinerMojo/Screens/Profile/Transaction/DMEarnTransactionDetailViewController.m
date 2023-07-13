//
//  DMEarnTransactionDetailViewController.m
//  DinerMojo
//
//  Created by Carl Sanders on 12/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMEarnTransactionDetailViewController.h"
#import "DMRestaurantInfoViewController.h"
#import "DMTransactionReceiptImageViewController.h"
#import "DMOfferItem.h"
//#import <Crashlytics/Answers.h>
#import "DinerMojo-Swift.h"

@interface DMEarnTransactionDetailViewController ()

@end

@implementation DMEarnTransactionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self decorateInterface];
    [self configureControls];
    
    NSInteger venueState = [[[[self selectedTransaction] venue] state] integerValue];
    
    [[self viewRestaurantButton] setHidden:(venueState != DMVenueStateVerified)];
}

- (void)configureControls
{
    DMVenue *transactionVenue = (DMVenue *)self.selectedTransaction.venue;
    
    
    self.navigationItem.title = transactionVenue.name;
    
    NSDateFormatter *dateFormatterDay = [[NSDateFormatter alloc] init];
    [dateFormatterDay setDateFormat:@"d"];
    
    NSDateFormatter *dateFormatterMonth = [[NSDateFormatter alloc] init];
    [dateFormatterMonth setDateFormat:@"MMMM"];
    self.dateLabel.text = [NSString stringWithFormat:@"%@%@ %@", [dateFormatterDay stringFromDate:self.selectedTransaction.created_at], [self daySuffixForDate:self.selectedTransaction.created_at], [dateFormatterMonth stringFromDate:self.selectedTransaction.created_at]];
    
    self.startingBalanceValueLabel.text = [NSString stringWithFormat:@"%@", self.selectedTransaction.start_balance];
    self.closingBalanceValueLabel.text = [NSString stringWithFormat:@"%@", self.selectedTransaction.closing_balance];
    
    if (!self.isEarnTransaction)
    {
        DMRedeemTransaction *redeemTransaction = (DMRedeemTransaction *)self.selectedTransaction;
        [self.amountSpendLabel setHidden:YES];
        
        NSString *pointsString = [NSString stringWithFormat:([redeemTransaction.points_redeemed integerValue] == 1) ? @"-%ld point" : @"-%ld points", (long)[redeemTransaction.points_redeemed integerValue]];
        
        DMOfferItem *offer = (DMOfferItem *)redeemTransaction.offer;
        [self.pointsLabel setText:pointsString];
        [self.discountLabel setText:[NSString stringWithFormat:@"(-%@) - %@", redeemTransaction.points_redeemed, offer.title]];
        [self.greenBackgroundView setHidden:YES];
        [self.receiptImageView setBackgroundColor:[UIColor navColor]];
        [self.rejectionLabel setText:@""];
    }
    
    else
    {
        DMEarnTransaction *earnTransaction = (DMEarnTransaction *)self.selectedTransaction;
        
        NSString *pointsString = [NSString stringWithFormat:([earnTransaction.points_earned integerValue] == 1) ? @"+%ld point" : @"+%ld points", (long)[earnTransaction.points_earned integerValue]];
        if((long)[earnTransaction.points_earned integerValue] == 0) {
            pointsString = @"Pending";
        }
        
        
        [self.pointsLabel setText:pointsString];
        [self.discountLabel setText:pointsString];
        
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        [numberFormatter setCurrencyCode:@"GBP"];
        
        [self.amountSpendLabel setText:[numberFormatter stringFromNumber:earnTransaction.bill_amount]];
        [self.pointsLabel setTextColor:[UIColor brandColor]];
        [self.discountLabel setTextColor:[UIColor brandColor]];
        if (earnTransaction.stateValue == DMRejected)
        {
            [self.rejectionLabel setText:[NSString stringWithFormat:@"Rejected: %@", earnTransaction.rejection_reason]];
        }
        else
        {
            [self.rejectionLabel setText:@""];
        }
        [self.rejectionLabel setNumberOfLines:0];
        [self.rejectionLabel sizeToFit];
        NSURL *url = [NSURL URLWithString:[[self userRequest] buildMediaURL:earnTransaction.bill_image]];
        [self.activityIndicator setHidden:NO];
        [self.activityIndicator startAnimating];
        
        [self.receiptImageView setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [self.activityIndicator setHidden:YES];
            [self.activityIndicator stopAnimating];
            [self.receiptImageView setImage:image];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            [self.activityIndicator setHidden:YES];
            [self.activityIndicator stopAnimating];
        }];
        
    }
    
}

- (void)decorateInterface
{
    
    if (self.isEarnTransaction)
    {
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.frame = CGRectMake(0, 0, self.view.frame.size.width, 70);
        layer.colors = [NSArray arrayWithObjects:
                        (id)[[[UIColor blackColor] colorWithAlphaComponent:0.9f] CGColor],
                        (id)[[[UIColor blackColor] colorWithAlphaComponent:0.6f] CGColor],
                        (id)[[[UIColor blackColor] colorWithAlphaComponent:0.4f] CGColor],
                        (id)[[UIColor clearColor] CGColor],
                        nil];
        [self.view.layer insertSublayer:layer above:self.view.layer];
        self.view.layer.masksToBounds = NO;
        
    }
    
    [self.currencySavedLabel setTextColor:[UIColor brandColor]];
    [self.amountSavedTitleLabel setTextColor:[UIColor brandColor]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Set navigation bar transparent
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)viewDidLayoutSubviews
{
    if (!self.isEarnTransaction)
    {
        self.imageViewHeightConstraint.constant = self.navigationController.navigationBar.frame.size.height + 20;
//        self.receiptImageView.backgroundColor = [UIColor navColor];
        [self.view layoutIfNeeded];
    }
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.viewRestaurantButton.frame.origin.y + self.viewRestaurantButton.frame.size.height + 10);
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)daySuffixForDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger dayOfMonth = [calendar component:NSCalendarUnitDay fromDate:date];
    switch (dayOfMonth) {
        case 1:
        case 21:
        case 31: return @"st";
        case 2:
        case 22: return @"nd";
        case 3:
        case 23: return @"rd";
        default: return @"th";
    }
}

- (IBAction)showReceiptImage:(id)sender {
    [self performSegueWithIdentifier:@"ShowReceiptImage" sender:nil];
}

- (IBAction)viewRestaurant:(id)sender
{
    [self performSegueWithIdentifier:@"ShowRestaurantTransaction" sender:nil];
}

- (IBAction)share:(id)sender {
    UIImage *image = self.receiptImageView.image;
    if(image == NULL) {
        image = [[UIImage alloc] init];
    }
    DMActivityViewController *activityViewController = [[DMActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
    
    [activityViewController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self.navigationController presentViewController:activityViewController animated:YES completion:^{}];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowRestaurantTransaction"])
    {
        DMRestaurantInfoViewController *vc = segue.destinationViewController;
        vc.selectedVenue = (DMVenue *) self.selectedTransaction.venue;
    }
    
    if ([segue.identifier isEqualToString:@"ShowReceiptImage"])
    {
        DMTransactionReceiptImageViewController *vc = segue.destinationViewController;
        vc.image = self.receiptImageView.image;
    }
}
@end
