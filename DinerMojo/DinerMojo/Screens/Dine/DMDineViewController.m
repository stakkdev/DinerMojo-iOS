//
//  DMDineViewController.m
//  DinerMojo
//
//  Created by Carl Sanders on 08/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMDineViewController.h"
#import "DMTabBarController.h"
#import "DMDineVenueTableViewCell.h"
#import "DMEarnReviewViewController.h"
#import "DMRedeemViewController.h"
#import "DMVenueImage.h"
#import "DMLocationServices.h"
#import <MapKit/MapKit.h>
#import "DMVenueRequest.h"
#import <SDWebImage/SDWebImage.h>

typedef NS_ENUM(NSInteger, DMFilter) {
    DMClosest = 0,
    DMRecent = 1,
};


@interface DMDineViewController ()

@property DMVenue *selectedVenue;
@property NSInteger selectedCell;
@property NSInteger selectedFilter;

@end

@implementation DMDineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
    [self decorateInterface];
}

- (void)configureControls
{
    [self closestButtonPressed:nil];
}

- (void)decorateInterface
{
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, self.view.frame.size.height - 154, self.view.frame.size.width, 90);
    layer.colors = [NSArray arrayWithObjects:
                    (id)[[[UIColor whiteColor] colorWithAlphaComponent:0.0f] CGColor],
                    (id)[[[UIColor whiteColor] colorWithAlphaComponent:0.8f] CGColor],
                    (id)[[[UIColor whiteColor] colorWithAlphaComponent:1.0f] CGColor],
                    (id)[[UIColor whiteColor] CGColor],
                    nil];
    [self.view.layer insertSublayer:layer above:self.tableView.layer];
    self.view.layer.masksToBounds = NO;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self hideTabBar];
    self.resultsArray = nil;
    self.dineArray = nil;
    [self reloadScreen];
    [self reloadTableData];
    [self downloadVenues];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Reloads

- (void)reloadUserData
{
    DMUser *currentUser = [[self userRequest] currentUser];
    [self.pointsValueButton setTitle:[NSString stringWithFormat:@"%@", currentUser.annual_points_balance] forState:UIControlStateNormal];
}

- (void)downloadVenues
{
    DMVenueRequest *venueRequest = [DMVenueRequest new];
    
    [self.emptyLabel setText:@"Fetching restaurants..."];
    [self.emptyLabel setHidden:NO];
    
    [venueRequest downloadLiveVenuesWithCompletionBlock:^(NSError *error, id results) {
        if (error == nil)
        {
            self.resultsArray = results;
            [self.emptyLabel setHidden:YES];
            [self reloadTableData];
            
        }
        else
        {
            [self.emptyLabel setText:@"Can't fetch restaurants. Check your connection."];
        }
        [self.activityIndicator stopAnimating];
        
        
    }];
}



- (void)reloadTableData
{

    if (self.selectedFilter == DMClosest)
    {
        self.dineArray = [[self sortClosestData:self.resultsArray] mutableCopy];

    }
    
    else if (self.selectedFilter == DMRecent)
    {
        
        self.dineArray = [[self sortRecentData:self.resultsArray] mutableCopy];

    }
    
    self.selectedCell = 0;
    
    [UIView transitionWithView:self.tableView duration:0.35f options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void)
     { [self.tableView reloadData]; }completion: nil];
    
    
    if (self.dineArray.count == 0)
    {
        [self.emptyLabel setHidden:NO];
    }
    else
    {
        [self.emptyLabel setHidden:YES];
    }
    
    if (self.initialOffer)
    {
        if ([self.dineArray containsObject:self.initialOffer.venue])
        {
            [self gotoVenuesOffersFromInitialOffer];
        }
    }
    
}

- (void)gotoVenuesOffersFromInitialOffer
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.dineArray indexOfObject:self.initialOffer.venue] inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"ShowRedeemDine" sender:nil];
}

- (void)reloadScreen
{
    [self reloadUserData];
    
    [[self userRequest] downloadUserProfileWithCompletionBlock:^(NSError *error, id results) {
    
        if (error == nil)
        {
            [self reloadUserData];
        }
    }];
}

#pragma mark - UITableView Delegates


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DMDineVenueTableViewCell *cell;
    cell.selected = NO;
    
    if (self.selectedCell >= 0)
    {
        cell = (DMDineVenueTableViewCell *) [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedCell inSection:0]];
        cell.venueImageView.alpha = 1.0;
        cell.tickButton.hidden = YES;
    }
    
    cell = (DMDineVenueTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    cell.venueImageView.alpha = 0.5;
    cell.tickButton.hidden = NO;
    self.selectedCell = indexPath.row;
    self.selectedVenue = [self.dineArray objectAtIndex:indexPath.row];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DMDineVenueTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OfferCell"];
    [tableView registerNib:[UINib nibWithNibName:@"DMDineVenueTableViewCell" bundle:nil] forCellReuseIdentifier:@"DineCell"];
    cell = [tableView dequeueReusableCellWithIdentifier:@"DineCell"];
    
    DMVenue *item = [self.dineArray objectAtIndex:indexPath.row];

    [cell.venueNameLabel setText:item.name];
    [cell.venueBudgetLabel setText:item.priceBracketString];
    [cell.venueCuisineLabel setText:[[[item categories] anyObject] name]];
    [cell.venueAreaLabel setText:item.house_number_street_name];
    
    if (indexPath.row == self.selectedCell)
    {
        cell.venueImageView.alpha = 0.5;
        cell.tickButton.hidden = NO;
        self.selectedCell = indexPath.row;
        self.selectedVenue = [self.dineArray objectAtIndex:indexPath.row];
    }
    
    else
    {
        cell.venueImageView.alpha = 1;
        cell.tickButton.hidden = YES;

    }
    
    DMVenueImage *venueImage = (DMVenueImage *) [item primaryImage];
    
    [[cell venueImageView]sd_setImageWithURL:[NSURL URLWithString:[venueImage fullURL]]
                 placeholderImage:nil];

    NSNumber *latitude = item.latitude;
    NSNumber *longitude = item.longitude;
    CLLocation *venueCoordinates = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    
    double distance = [[DMLocationServices sharedInstance] userLocationDistanceFromLocation:venueCoordinates];
    
    MKDistanceFormatter *df = [MKDistanceFormatter new];
    [df setUnitStyle:MKDistanceFormatterUnitStyleFull];
    
    NSString *friendlyDistance = [df stringFromDistance:distance];
    
    [[cell venueMilesLabel] setText:[NSString stringWithFormat:@"%@",friendlyDistance]];

    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 65;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor whiteColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dineArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



#pragma mark - Button presses

- (IBAction)recentButtonPressed:(id)sender {
    
    self.selectedFilter = DMRecent;
    [self reloadTableData];
    [self.recentButton setBackgroundColor:[UIColor brandColor]];
    [self.closestButton setBackgroundColor:[UIColor newsGrayColor]];
    
}

- (IBAction)closeButtonTapped:(id)sender
{
//    [self showTabBar];
//    
//    [self.tabBarController setSelectedIndex:[(DMTabBarController *) self.tabBarController previousSelectedIndex]];
//    
    
}

- (IBAction)closestButtonPressed:(id)sender {
    
    self.selectedFilter = DMClosest;
    [self reloadTableData];
    
    [self.closestButton setBackgroundColor:[UIColor brandColor]];
    [self.recentButton setBackgroundColor:[UIColor newsGrayColor]];
}


- (IBAction)redeemRestaurant:(id)sender
{
    self.initialOffer = nil;
    
    if (self.selectedVenue)
    {
        if ([[[[self userRequest] currentUser] is_email_verified] boolValue] == YES)
        {
            [self performSegueWithIdentifier:@"ShowRedeemDine" sender:nil];
        }
        else
        {
            [self presentEmailVerificationCheckViewControllerWithCompletionBlock:^(NSError *error, id results) {
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([[[[self userRequest] currentUser] is_email_verified] boolValue] == YES)
                    {
                        [self performSegueWithIdentifier:@"ShowRedeemDine" sender:nil];
                    }
                    else
                    {
                        [self presentUnverifiedEmailViewControllerWithStyle:UIBlurEffectStyleExtraLight];
                    }
                }];
            }];
        }
    }
}

- (IBAction)earnRestaurant:(id)sender
{
    if (self.selectedVenue)
    {
        if ([[[[self userRequest] currentUser] is_email_verified] boolValue] == YES)
        {
            [self performSegueWithIdentifier:@"ShowEarnDine" sender:nil];
        }
        else
        {
            [self presentEmailVerificationCheckViewControllerWithCompletionBlock:^(NSError *error, id results) {
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([[[[self userRequest] currentUser] is_email_verified] boolValue] == YES)
                    {
                        [self performSegueWithIdentifier:@"ShowEarnDine" sender:nil];
                    }
                    else
                    {
                        [self presentUnverifiedEmailViewControllerWithStyle:UIBlurEffectStyleExtraLight];
                    }
                }];
            }];
        }
    }
    else
    {
        
    }
}

- (void)hideTabBar
{
    UITabBar *tabBar = self.tabBarController.tabBar;
    [tabBar setFrame:CGRectMake(CGRectGetMinX(tabBar.frame),
                                CGRectGetMinY(tabBar.frame)+CGRectGetHeight(tabBar.frame),
                                CGRectGetWidth(tabBar.frame),
                                CGRectGetHeight(tabBar.frame))];
    
}

- (void)showTabBar
{
    UITabBar *tabBar = self.tabBarController.tabBar;
    [tabBar setFrame:CGRectMake(CGRectGetMinX(tabBar.frame),
                                CGRectGetMinY(tabBar.frame)-CGRectGetHeight(tabBar.frame),
                                CGRectGetWidth(tabBar.frame),
                                CGRectGetHeight(tabBar.frame))];
    
    
}

- (NSArray *)sortClosestData:(NSArray *)data;
{
    return [data sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        
        DMVenue *place1 = (DMVenue *) a;
        DMVenue *place2 = (DMVenue *) b;
        
        DMLocationServices *locationServices = [DMLocationServices sharedInstance];
        
        CLLocationDistance aDistance = [locationServices userLocationDistanceFromLocation:[[CLLocation alloc] initWithLatitude:[[place1 latitude] doubleValue] longitude:[[place1 longitude] doubleValue]]];
        CLLocationDistance bDistance = [locationServices userLocationDistanceFromLocation:[[CLLocation alloc] initWithLatitude:[[place2 latitude] doubleValue] longitude:[[place2 longitude] doubleValue]]];
        
        return (aDistance > bDistance);
        
    }];
}

- (NSArray *)sortRecentData:(NSArray *)data;
{
    return [data sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        
        DMVenue *place1 = (DMVenue *) a;
        DMVenue *place2 = (DMVenue *) b;
        
        NSDate *place1Date = place1.user_last_viewed;
        NSDate *place2Date = place2.user_last_viewed;

        
        return ([place2Date compare:place1Date]);
        
    }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowEarnDine"])
    {
        DMDineNavigationController *vc = segue.destinationViewController;
        [vc setDineNavigationDelegate:self];
        DMEarnReviewViewController *earnViewController = (DMEarnReviewViewController *)[[vc viewControllers] objectAtIndex:0];
        earnViewController.selectedVenueID = self.selectedVenue.modelID;
    }
    
    if ([segue.identifier isEqualToString:@"ShowRedeemDine"])
    {
        DMDineNavigationController *vc = segue.destinationViewController;
        [vc setDineNavigationDelegate:self];
        DMRedeemViewController *redeemViewController = (DMRedeemViewController *)[[vc viewControllers] objectAtIndex:0];
        [redeemViewController setStandardRedeem:NO];
        redeemViewController.selectedVenue = self.selectedVenue;
        redeemViewController.initialOffer = self.initialOffer;
    }
}

#pragma mark - DMDineNavigationControllerDelegate

- (void)readyToDismissCompletedDineNavigationController:(DMDineNavigationController *)dineNavigationController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self reloadScreen];
}

- (void)readyToDismissCancelledDineNavigationController:(DMDineNavigationController *)dineNavigationController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self reloadScreen];

}

@end
