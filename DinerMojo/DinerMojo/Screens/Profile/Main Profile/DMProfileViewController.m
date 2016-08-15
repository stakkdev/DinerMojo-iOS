
//  DMProfileViewController.m
//  DinerMojo
//
//  Created by Carl Sanders on 06/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMProfileViewController.h"
#import "DMTransactionsModelController.h"
#import "DMRedeemTransaction.h"
#import "DMEarnTransaction.h"
#import "DMReferAFriendViewController.h"

@interface DMProfileViewController ()

@end

@interface DMProfileViewController()

@property (strong, nonatomic) DMUser *currentUser;
@property CGFloat pointValue;

@end

@implementation DMProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.scrollView setDelegate:self];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(downloadUser) forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:self.refreshControl];
    
    [[self contentView] setHidden:YES];
    [[self noProfileLabel] setHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self downloadUser];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}



-(void)viewDidLayoutSubviews
{
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 680);
}

- (void)downloadUser
{
    if ([[self contentView] isHidden])
    {
        [[self profileIndicatorView] startAnimating];
        [[self noProfileLabel] setHidden:YES];
        [[self refreshControl] endRefreshing];
    }
    
    
    [[self userRequest] downloadUserProfileWithCompletionBlock:^(NSError *error, id results) {
      
        if (error == nil)
        {
            [self setCurrentUser:[[self userRequest] currentUser]];
            [self.profileImageView setImageWithURL:[NSURL URLWithString:[[self currentUser] profilePictureFullURL]]];
            [self.profileInitialsLabel setText:[[self currentUser] initials]];
            
            [UIView animateWithDuration:0.15 animations:^{
                [self changeColor:self.userRequest.currentUser.mojoLevel];
            }];
            [self downloadTransaction];
            [[self navigationItem] setTitle:[[self currentUser] fullName]];
            
            [[self contentView] setHidden:NO];
            
            if ([[[[self userRequest] currentUser] is_email_verified] boolValue] == NO)
            {
                if ([[self userRequest] hasUpdateProfileEmailVerifificationDisplayed] == NO)
                {
                    [self presentUnverifiedEmailViewControllerWithStyle:UIBlurEffectStyleExtraLight];
                    [[self userRequest] updateProfileEmailVerifificationDisplayed:YES];
                }
            }
        } else {
            
            [[self contentView] setHidden:YES];
            [[self noProfileLabel] setHidden:NO];
            [[self scrollView] setBackgroundColor:[UIColor whiteColor]];
        }
        
        [[self profileIndicatorView] stopAnimating];
        [self.refreshControl endRefreshing];

    }];

}

- (void)downloadTransaction
{
    DMTransactionsModelController * transactionModelController = [DMTransactionsModelController new];
    [[self userRequest] downloadAllTransactionsWithCompletionBlock:^(NSError *error, id results) {
        if (error == nil)
        {
            [transactionModelController setTransactions: [[results reverseObjectEnumerator] allObjects]];
            
            double totalSavings = 0.0;
            double monthSavings = 0.0;
            double yearSavings = 0.0;

            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
            [numberFormatter setCurrencyCode:@"GBP"];
            
            for (DMTransaction *transaction in transactionModelController.transactions)
            {
                if ([transaction class] == [DMEarnTransaction class])
                {
                    DMEarnTransaction *earnTransaction = (DMEarnTransaction *) transaction;
                    
                    if (earnTransaction.state.integerValue == DMVerified)
                    {
                        totalSavings = [earnTransaction.amount_saved doubleValue] + totalSavings;
                        
                        NSDate *monthDate = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                                                     value:-30
                                                                                    toDate:[NSDate date]
                                                                                   options:0];
                        
                        NSDate *yearDate = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                                                    value:-365
                                                                                   toDate:[NSDate date]
                                                                                  options:0];
                        
                        
                        if([monthDate compare:transaction.created_at] == NSOrderedAscending)
                        {
                            monthSavings = [earnTransaction.amount_saved doubleValue] + monthSavings;
                            
                        }
                        
                        if ([yearDate compare:transaction.created_at] == NSOrderedAscending)
                        {
                            yearSavings = [earnTransaction.amount_saved doubleValue] + yearSavings;
                            
                        }
 
                    }
                    
                }
            }
            
            NSString *pointsString = [NSString stringWithFormat:([[[self currentUser] referred_points] integerValue] == 1) ? @"%li point so far" : @"%li points so far", (long)[[[self currentUser] referred_points] integerValue]];
            
            [self.referralPointsLabel setText:pointsString];
            
            if ([[self currentUser] referred_pointsValue] == 0)
            {
                [self.inviteLabel setText:@"Invite them"];
            }
            
            [self.savingMonthButton setTitle:[numberFormatter stringFromNumber:[NSNumber numberWithDouble:monthSavings]] forState:UIControlStateNormal];
            
            [self.savingYearButton setTitle:[numberFormatter stringFromNumber:[NSNumber numberWithDouble:yearSavings]] forState:UIControlStateNormal];

            
            [self.savingTotalButton setTitle:[numberFormatter stringFromNumber:[NSNumber numberWithDouble:totalSavings]] forState:UIControlStateNormal];
        }
        
    }];
}


-(void)changeColor:(NSInteger)accountType
{
    UIColor *mainColor;
    UIColor *subColor;
    UIColor *nextColor;
    
    //Reset to white
    [self.profileNameLabel setTextColor:[UIColor whiteColor]];
    [self.memberStatusLabel setTextColor:[UIColor whiteColor]];
    [self.earnMonthsLabel setTextColor:[UIColor whiteColor]];
    [self.pointsButton setTintColor:[UIColor whiteColor]];
    [self.settingsButton setTintColor:[UIColor whiteColor]];
    [self.infoButton setTintColor:[UIColor whiteColor]];
    self.pointValue = self.currentUser.annual_points_earned.floatValue;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM YYYY"];
    [self.myMojoLabel setText:@"My Mojo"];
    
    NSInteger pointsRemaining;
    NSString *pointsString;

    switch (accountType) {
        case DMUserMojoLevelPlatinum:
            mainColor = [UIColor platinumMainColor];
            subColor = [UIColor platinumSubColor];
            nextColor = [UIColor platinumMainColor];
            [self.largeCirclePointsButton setTitle:@"" forState:UIControlStateNormal];
            [self.largeCirclePointsButton setImage:[UIImage imageNamed:@"platinum_ribbon"] forState:UIControlStateNormal];
            [self.progressView setProgressTintColor:subColor];
            [self.progressView setProgress:1 animated:YES];
            [self.pointsToEarnLabel setText:@"Congratulations on becoming a Platinum Member"];
            [self.memberStatusLabel setText:[NSString stringWithFormat:@"Platinum Member - Joined %@", [dateFormatter stringFromDate:self.currentUser.created_at]]];
            self.pointValue = 1;
            
            break;
            
        case DMUserMojoLevelGold:
            mainColor = [UIColor goldMainColor];
            subColor = [UIColor goldSubColor];
            nextColor = [UIColor platinumMainColor];
            [self.progressView setProgressTintColor:subColor];
            //1000 is silver limit
            [self.largeCirclePointsButton setTitle:@"2000" forState:UIControlStateNormal];
            
            pointsRemaining = 2000 - self.currentUser.annual_points_earned.integerValue;
            
            pointsString = [NSString stringWithFormat:(pointsRemaining == 1) ? @"Earn %li more point to become a Platinum Member" : @"Earn %li more points to become a Platinum Member", (long)pointsRemaining];
            
            [self.pointsToEarnLabel setText:pointsString];
            
            [self.memberStatusLabel setText:[NSString stringWithFormat:@"Gold Member - Joined %@", [dateFormatter stringFromDate:self.currentUser.created_at]]];

            self.pointValue = ((self.pointValue - 1000) * 0.1) / 100;
            
            break;
            
        case DMUserMojoLevelSilver:
            mainColor = [UIColor silverMainColor];
            subColor = [UIColor silverSubColor];
            nextColor = [UIColor goldMainColor];
            [self.progressView setProgressTintColor:subColor];
            
            [self.profileNameLabel setTextColor:[UIColor silverTintColor]];
            [self.memberStatusLabel setTextColor:[UIColor silverTintColor]];
            [self.earnMonthsLabel setTextColor:[UIColor silverTintColor]];

            [self.pointsButton setTintColor:[UIColor silverTintColor]];
            [self.settingsButton setTintColor:[UIColor silverTintColor]];
            [self.infoButton setTintColor:[UIColor silverTintColor]];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            
            [self.memberStatusLabel setText:[NSString stringWithFormat:@"Silver Member - Joined %@", [dateFormatter stringFromDate:self.currentUser.created_at]]];

            
            //1000 is silver limit
            [self.largeCirclePointsButton setTitle:@"1000" forState:UIControlStateNormal];
            
            
            pointsRemaining = 1000 - self.currentUser.annual_points_earned.integerValue;
            
            pointsString = [NSString stringWithFormat:(pointsRemaining == 1) ? @"Earn %li more point to become a Gold Member" : @"Earn %li more points to become a Gold Member", (long)pointsRemaining];
            
            [self.pointsToEarnLabel setText:pointsString];
            
            self.pointValue = ((self.pointValue - 500) * 0.2) / 100;
            
            break;
        case DMUserMojoLevelBlue:
            mainColor = [UIColor blueMainColor];
            subColor = [UIColor blueSubColor];
            nextColor = [UIColor silverMainColor];
            [self.progressView setProgressTintColor:subColor];
            
            //500 is blue limit
            [self.largeCirclePointsButton setTitle:@"500" forState:UIControlStateNormal];
            [self.memberStatusLabel setText:[NSString stringWithFormat:@"Blue Member - Joined %@", [dateFormatter stringFromDate:self.currentUser.created_at]]];

            
            pointsRemaining = 500 - self.currentUser.annual_points_earned.integerValue;
            
            pointsString = [NSString stringWithFormat:(pointsRemaining == 1) ? @"Earn %li more point to become a Silver Member" : @"Earn %li more points to become a Silver Member", (long)pointsRemaining];
            
            [self.pointsToEarnLabel setText:pointsString];
            
            self.pointValue = (self.pointValue * 0.2) / 100;
            [self.largeCirclePointsButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            break;
            
        default:
            break;
    }
    
    [self.profileView setBackgroundColor:mainColor];
    [self.profilePictureView setBorderColor:subColor];
    [self.statusBarView setBackgroundColor:mainColor];
    [self.view setBackgroundColor:mainColor];
    [self.pointsProgressLabel setTextColor:subColor];
    
    [self.smallCirclePointsButton setBackgroundColor:subColor];
    [self.profilePictureView setBorderColor:subColor];
    [self.pointsButton setBackgroundColor:subColor];
    
    [self.largeCirclePointsButton setBackgroundColor:nextColor];
    [[self scrollView] setBackgroundColor:mainColor];
    
    self.navigationController.navigationBar.barTintColor = subColor;
    
    NSInteger pointsValue = [[[self currentUser] annual_points_balance] integerValue];
    
    NSString *pointsValueString = [NSString stringWithFormat:@"%li", (long)pointsValue];
    
    NSMutableAttributedString *points = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:(pointsValue == 1) ? @"%@ point" : @"%@ points", pointsValueString]];
    
    [points addAttribute:NSFontAttributeName value:[UIFont pointsLargeFont] range:NSMakeRange(0, pointsValueString.length)];
    
    [self.pointsButton setAttributedTitle:points forState:UIControlStateNormal];
    [self.pointsProgressLabel setText:[NSString stringWithFormat:@"%@", ([[[self currentUser] annual_points_earned] integerValue] > 0) ? [[self currentUser] annual_points_earned] : @""]];
    
    NSInteger integerpoints = (self.progressView.frame.size.width * self.pointValue -12.5);
    
    if (integerpoints > 35)
    {
        self.pointsProgressLabelConstraint.constant = integerpoints;
        [self.progressView setProgress:self.pointValue animated:YES];
        
        [UIView animateWithDuration:self.pointValue * 1.16 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
        
    }
    
}


- (IBAction)settingsButtonPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"ShowDMSettings" sender:nil];
}

#pragma mark - UIScrollViewDelegates

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.scrollView.contentOffset.y >= 157)
    {
        [self.settingsButton setHidden:YES];
    }
    
    else
    {
        [self.settingsButton setHidden:NO];

    }


}
- (IBAction)openRefer:(id)sender {

    [self performSegueWithIdentifier:@"ShowReferAFriend" sender:nil];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowReferAFriend"])
    {
        DMReferAFriendViewController *vc = [segue destinationViewController];
        vc.referredPoints = [NSString stringWithFormat:@"%hd", self.currentUser.referred_pointsValue];
    }
}


- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return ![view isKindOfClass:[UIButton class]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
