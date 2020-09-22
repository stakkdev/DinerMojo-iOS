//
//  DMTransactionTimelineViewController.m
//  DinerMojo
//
//  Created by Carl Sanders on 12/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMTransactionTimelineViewController.h"
#import "DMTransactionTableViewCell.h"
#import "DMEarnTransactionDetailViewController.h"
#import "DMTransactionsModelController.h"
#import "DMRedeemTransaction.h"
#import "DMEarnTransaction.h"
#import <Crashlytics/Answers.h>

@interface DMTransactionTimelineViewController ()

@property (strong, nonatomic) DMTransactionsModelController* transactionModelController;


@property (weak, nonatomic) IBOutlet UILabel *emptyTableLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property BOOL isEarnTransaction;
@property DMTransaction *selectedTransaction;
@property UIRefreshControl *refreshControl;

@end


@implementation DMTransactionTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    [self refreshTable];
    UIView *nibView = [[[NSBundle mainBundle] loadNibNamed:@"DMTransactionTableViewFooter" owner:self options:nil] objectAtIndex:0];
    self.tableView.tableFooterView = nibView;
    [self.tableView setHidden:YES];
    [[self emptyTableLabel] setHidden:YES];
    
    [Answers logContentViewWithName:@"View timeline" contentType:@"View timeline" contentId:@"" customAttributes:@{}];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)refreshTable
{
    [self.activityIndicator startAnimating];

    _transactionModelController = [DMTransactionsModelController new];
    [[self userRequest] downloadAllTransactionsWithCompletionBlock:^(NSError *error, id results) {
        if (error == nil)
        {
            
            [[self transactionModelController] setTransactions:[results  allObjects]];
            [UIView transitionWithView:self.tableView duration:0.35f options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void)
             {
                 [self.tableView reloadData];
                 [self.tableView setHidden:NO];
                 [self.emptyTableLabel setHidden:YES];
             
             }completion: nil];
            
            if ([results allObjects].count == 0)
            {
                [self toggleNoTransactionsLabel];
            }
        }
        else
        {
            [self.emptyTableLabel setText:@"Oops, can't fetch transactions at this time."];
            [self.emptyTableLabel setHidden:NO];
            [self.tableView setHidden:YES];
        }
        
        [self.refreshControl endRefreshing];
        [self.activityIndicator stopAnimating];

    }];
    

}

- (void)toggleNoTransactionsLabel;
{
    if (![self.tableView numberOfRowsInSection:0]) {
        
        [[self emptyTableLabel] setHidden:NO];
        [[self emptyTableLabel] setText:@"You have no Transaction history"];
        [self.tableView setHidden:YES];
    }
    else
    {
        [[self emptyTableLabel] setHidden:YES];

    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegates

- (void)populateTransactionCell:(DMTransactionTableViewCell *)cell withTransaction:(DMTransaction *)transaction
{
    DMVenue *transactionVenue = (DMVenue *)transaction.venue;

    NSDate *dateTo = transaction.created_at;
    
    if (dateTo != nil)
    {
        NSDateFormatter *monthDateFormatter = [[NSDateFormatter alloc] init];
        [monthDateFormatter setDateFormat:@"MMM"];
        
        NSDateFormatter *dayDateFormatter = [[NSDateFormatter alloc] init];
        [dayDateFormatter setDateFormat:@"d"];
        
        NSDictionary *numberDict = [NSDictionary dictionaryWithObject: [UIFont fontWithName:@"OpenSans-SemiBold" size:24.0] forKey:NSFontAttributeName];
        NSMutableAttributedString *numberAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", [dayDateFormatter stringFromDate:dateTo]] attributes: numberDict];
        
        NSDictionary *monthDict = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"OpenSans-SemiBold" size:12.0] forKey:NSFontAttributeName];
        NSMutableAttributedString *monthAttrString = [[NSMutableAttributedString alloc]initWithString:[[[monthDateFormatter stringFromDate:dateTo] substringToIndex:3] uppercaseString] attributes:monthDict];
        [monthAttrString addAttribute:NSKernAttributeName value:@(0.1) range:NSMakeRange(0, monthAttrString.length)];
        
        [numberAttrString appendAttributedString:monthAttrString];
        
        [cell.dateLabel setAttributedText:numberAttrString];

    }
    
    [cell.restaurantTitleLabel setText:transactionVenue.name];
    NSString *cuisine = [[[transactionVenue categories] anyObject] name];
    [cell.cuisineLabel setText:cuisine];
    [cell.areaLabel setText:transactionVenue.town];
    

}

- (void)populateRedeemCell:(DMTransactionTableViewCell *)cell withRedeemTransaction:(DMRedeemTransaction *)transaction
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencyCode:@"GBP"];
    
    
    [cell.pointsLabel setText:[NSString stringWithFormat:@"-%@", transaction.points_redeemed]];
//    if (![transaction.savings isEqualToNumber:[NSNumber numberWithInt:0]])
//    {
//        [cell.priceLabel setText:[NSString stringWithFormat:@"You saved %@ (-%@%%)", [numberFormatter stringFromNumber:transaction.savings], transaction.discount_as_percentage]];
//    }
//    
//    else
//    {
//        [cell.priceLabel setText:@""];
//    }
    [cell.priceLabel setText:@""];

    [cell.pointsLabel setTextColor:[UIColor lightGrayColor]];
    [cell.restaurantTitleLabel setTextColor:[UIColor lightGrayColor]];
    [cell.priceLabel setTextColor:[UIColor brandColor]];
}

- (void)populateEarnCell:(DMTransactionTableViewCell *)cell withEarnTransaction:(DMEarnTransaction *)transaction
{
    
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencyCode:@"GBP"];
    
    [cell.priceLabel setTextColor:[UIColor brandColor]];
    [cell.restaurantTitleLabel setTextColor:[UIColor brandColor]];
    [cell.pointsLabel setTextColor:[UIColor brandColor]];
    
    switch ([transaction.state integerValue]) {
        case DMVerified:
            [cell.priceLabel setText:[numberFormatter stringFromNumber:transaction.bill_amount]];
            [cell.pointsLabel setText:[NSString stringWithFormat:@"+%@", transaction.points_earned]];
            [cell.priceLabel setTextColor:[UIColor brandColor]];
            
            break;
        case DMRejected:
            [cell.priceLabel setText:@"Rejected"];
            [cell.priceLabel setTextColor:[UIColor redColor]];
            [cell.pointsLabel setText:@""];
            break;
        case DMPending:
        case DMChecked:
            [cell.priceLabel setText:@"Pending"];
            [cell.priceLabel setTextColor:[UIColor brandColor]];
            [cell.pointsLabel setText:@""];
            break;
        default:
            break;
    }
    
    if (transaction.earn_typeValue == DMTransactionEarnTypeReferred)
    {
        [cell.priceLabel setText:@"Referral"];
        //Referrals dont have a bill
        [cell setUserInteractionEnabled:NO];
        
    }
    
    if (transaction.earn_typeValue == DMTransactionEarnTypeLoyalty)
    {
        NSString *loyalty_description = ([(DMEarnTransaction *)transaction loyalty_description] == nil) ? @"" : [(DMEarnTransaction *)transaction loyalty_description];
        [cell.priceLabel setText:@""];
        [cell setUserInteractionEnabled:NO];
        [cell.restaurantTitleLabel setText:@"Loyalty Points"];
        [cell.priceLabel setText:loyalty_description];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DMTransactionTableViewCell *cell = (DMTransactionTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    DMTransaction *transaction = [[[self transactionModelController] transactions] objectAtIndex:indexPath.row];
    
    self.selectedTransaction = transaction;

    [self populateTransactionCell:cell withTransaction:transaction];
    
    if ([transaction class] == [DMEarnTransaction class])
    {
        self.isEarnTransaction = YES;
    }
    else
    {
        self.isEarnTransaction = NO;
    }
    
    
    
    [self performSegueWithIdentifier:@"ShowTransactionDetail" sender:nil];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DMTransactionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"DMTransactionTableViewCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    }
    
    DMTransaction *transaction = [[[self transactionModelController] transactions] objectAtIndex:indexPath.row];
    
    [self populateTransactionCell:cell withTransaction:transaction];
    
    if ([transaction class] == [DMEarnTransaction class])
    {
        [self populateEarnCell:cell withEarnTransaction:(DMEarnTransaction *)transaction];
    }
    else
    {
        [self populateRedeemCell:cell withRedeemTransaction:(DMRedeemTransaction *)transaction];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 98;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self transactionModelController] transactions] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect headerLabelFrame = CGRectMake(CGRectGetMinX(tableView.frame), CGRectGetMinY(tableView.frame), CGRectGetWidth(tableView.bounds), 88.0);
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:headerLabelFrame];
    [headerLabel setNumberOfLines:2];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerLabel setFont:[UIFont fontWithName:@"Open Sans" size:17.0]];
    [headerLabel setText:@"Click a transaction for more details"];
    [headerLabel setTextColor:[UIColor blackColor]];
    [headerLabel setBackgroundColor:[UIColor colorWithRed:232.0 / 255.0 green:232.0 / 255.0 blue:232.0 / 255.0 alpha:1.0]];
    return headerLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 72.0;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowTransactionDetail"])
    {
        DMEarnTransactionDetailViewController *vc = segue.destinationViewController;
        vc.isEarnTransaction = self.isEarnTransaction;
        vc.selectedTransaction = self.selectedTransaction;
        
    }
}


@end
