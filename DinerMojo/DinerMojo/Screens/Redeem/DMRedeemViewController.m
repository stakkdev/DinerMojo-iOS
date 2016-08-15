//
//  DMRedeemViewController.m
//  DinerMojo
//
//  Created by Robert Sammons on 17/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMRedeemViewController.h"
#import "DMRedeemTableViewCell.h"
#import "DMVenueImage.h"
#import <AVFoundation/AVFoundation.h>
#import "DMOfferItem.h"
#import "DMRedeemCouponViewController.h"
#import "DMOperationCompletePopUpViewController.h"
#import "DMDineNavigationController.h"


@interface DMRedeemViewController ()

@end

@implementation DMRedeemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
    [self decorateInterface];
    
    
    
}

- (void)configureControls
{
    self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    self.currentUser = [[self userRequest] currentUser];
    [self.activityIndicator startAnimating];
    [[self userRequest] downloadAllAvailableOffersWithVenueID:self.selectedVenue.modelID withCompletionBlock:^(NSError *error, id results) {
        if (error == nil)
        {
            self.eligibleOffersArray = [results allObjects];
            if (self.eligibleOffersArray.count == 0)
            {
                [self.noOffersLabel setHidden:NO];
            }
            [UIView transitionWithView:self.tableView duration:0.35f options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void)
             {
                 [self.tableView reloadData];
             } completion:^(BOOL finished) {
                 if (self.initialOffer != nil)
                 {
                     [self gotoOfferFromInitialOffer];
                 }
             }];
        }
        
        else
        {
            [self.noOffersLabel setHidden:NO];
            [self.noOffersLabel setText:@"Oops can't fetch offers. Check your connection."];
        }
        
        [[self activityIndicator] stopAnimating];

        
    }];
    
    [self.profileImageView setImageWithURL:[NSURL URLWithString:[self.currentUser profilePictureFullURL]]];
    [self.profileInitialsLabel setText:[self.currentUser initials]];
    
    [self decorateInterface];
    
}

- (void)gotoOfferFromInitialOffer
{
    if ([self.eligibleOffersArray containsObject:[self initialOffer]])
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.eligibleOffersArray indexOfObject:self.initialOffer] inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    }
    else
    {
        [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusError title:@"Oops!" description:@"This offer has now expired." style:UIBlurEffectStyleDark actionButtonTitle:nil];
    }
}

- (void)decorateInterface
{
    if (IS_IPHONE_4)
    {
        self.redeemButtonBottom.constant = 6;
    }
    
    [self.venueNameLabel setText:self.selectedVenue.name];
    [self.venueCuisineAreaLabel setText:[NSString stringWithFormat:@"%@ | %@", [[[self.selectedVenue categories] anyObject] name], self.selectedVenue.town]];
    [self.userPointsLabel setText:[NSString stringWithFormat:@"%@", self.currentUser.annual_points_balance]];
    DMVenueImage *venueImage = (DMVenueImage *) [self.selectedVenue primaryImage];
    
    NSURL *url = [NSURL URLWithString:[venueImage fullURL]];
    [self.venueImageView setImageWithURL:url];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegates


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.highlighted = NO;
    cell.selected = NO;
    
    DMOfferItem *item = [self.eligibleOffersArray objectAtIndex:indexPath.row];
    
    self.selectedOfferItem = item;
    
    self.isRedeeming = YES;
    
    
    [self.userNewPointsLabel setText:[NSString stringWithFormat:@"%d", self.currentUser.annual_points_balanceValue - self.selectedOfferItem.points_requiredValue]];
    
    NSString *pointsString = [NSString stringWithFormat:([self.selectedOfferItem.points_required integerValue] == 1) ? @"Are you sure you want to redeem %ld point for ""%@""?" : @"Are you sure you want to redeem %ld points for ""%@""?", (long)[self.selectedOfferItem.points_required integerValue] , self.selectedOfferItem.title];
    
    [self.confirmRedeemLabel setText:pointsString];
    
    
    
    if (self.selectedOfferItem.is_special_offerValue == 1)
    {
        [self.confirmButton setBackgroundColor:[UIColor offersColor]];
    }
    
    else
    {
        [self.confirmButton setBackgroundColor:[UIColor brandColor]];
    }
    [self.confirmButton setTitle:[NSString stringWithFormat:@"Yes, get ""%@"" now!", self.selectedOfferItem.title] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.35 delay:0.0f usingSpringWithDamping:0.75 initialSpringVelocity:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
        self.horizontal.constant = -self.view.frame.size.width;
        self.right.constant = self.view.frame.size.width;
        [self.view layoutIfNeeded];
    } completion:nil];
    
    [self.closeButton setImage:[UIImage imageNamed:@"back_arrow_grey"] forState:UIControlStateNormal];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DMRedeemTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OfferCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"DMRedeemTableViewCell" bundle:nil] forCellReuseIdentifier:@"OfferCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"OfferCell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    DMOfferItem *item = [self.eligibleOffersArray objectAtIndex:indexPath.row];
    
    NSString *pointsString = [NSString stringWithFormat:([item.points_required integerValue] == 1) ? @"%ldpt = %@" : @"%ldpts = %@", (long)[item.points_required integerValue], item.title];
    
    [cell.offerLabel setText:pointsString];
    
    
    
    if (item.is_special_offerValue == 1)
    {
        
        [cell.offerBackgroundView setBackgroundColor:[UIColor offersColor]];
        [cell.offerImageView setHidden:NO];
        
        
    }
    
    
    return cell;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.eligibleOffersArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}


- (IBAction)dismissView:(id)sender {
    
    if (self.isRedeeming)
    {
        self.horizontal.constant = 0;
        self.right.constant = 0;
        
        [self.userNewPointsLabel setText:[NSString stringWithFormat:@"%d", self.currentUser.annual_points_balanceValue - self.selectedOfferItem.points_requiredValue]];
        
        NSString *pointsString = [NSString stringWithFormat:([self.selectedOfferItem.points_required integerValue] == 1) ? @"Are you sure you want to redeem %ld point for ""%@""?" : @"Are you sure you want to redeem %ld points for ""%@""?", (long)[self.selectedOfferItem.points_required integerValue], self.selectedOfferItem.title];
        
        [self.confirmRedeemLabel setText:pointsString];
        
        if (self.selectedOfferItem.is_special_offerValue == 1)
        {
            [self.confirmButton setBackgroundColor:[UIColor offersColor]];
        }
        
        else
        {
            [self.confirmButton setBackgroundColor:[UIColor brandColor]];
        }
        [self.confirmButton setTitle:[NSString stringWithFormat:@"Yes, get ""%@"" now!", self.selectedOfferItem.title] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.35 delay:0.0f usingSpringWithDamping:0.75 initialSpringVelocity:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
        [self.closeButton setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
        self.isRedeeming = NO;
        
    }
    
    else
    {
        [(DMDineNavigationController *)[self navigationController] cancelPressed];
    }
}



- (void)showAlertCameraPrivacy
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Camera Privacy" message:@"To use this feature we require your camera for verification. We do not store or use the image in any other way." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *privacy = [UIAlertAction actionWithTitle:@"Privacy Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Not Now" style:UIAlertActionStyleDestructive handler:nil];
    
    
    [alertController addAction:privacy];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowRedeemCoupon"])
    {
        DMRedeemCouponViewController *vc = segue.destinationViewController;
        vc.selectedOfferItem = self.selectedOfferItem;
        vc.selectedVenue = self.selectedVenue;
        vc.selectedRedeemID = self.selectedRedeemID;
        
    }
}

- (void)checkCamera
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (status) {
            
        case AVAuthorizationStatusAuthorized:
            
            [self postCoupon];
            
            break;
            
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:
            
            [self showAlertCameraPrivacy];
            
            break;
            
        case AVAuthorizationStatusNotDetermined:
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted)
                {
                    [self postCoupon];
                    
                }
                
                else
                {
                    [self showAlertCameraPrivacy];
                }
            }];
            break;
    }
    
}

- (void)postCoupon
{
    [[self userRequest] postRedeemTransactionWithOfferID:self.selectedOfferItem.modelID venueID:self.selectedVenue.modelID withCompletionBlock:^(NSError *error, id results) {
        
        if (error)
        {
            [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusError title:@"Oops" description:@"Something went wrong, please try again later"  style:UIBlurEffectStyleExtraLight actionButtonTitle:nil];
        }
        
        else
        {
            NSDictionary *dictionary = [results objectAtIndex:0];
            self.selectedRedeemID = [dictionary objectForKey:@"id"];
            //Update user points
            [[self userRequest] downloadUserProfileWithCompletionBlock:^(NSError *error, id results) {
                [self performSegueWithIdentifier:@"ShowRedeemCoupon" sender:nil];
            }];
            
        }
    }];
    [self.confirmButton setEnabled:NO];

}

- (IBAction)processCoupon:(id)sender {
    [self checkCamera];
}
@end
