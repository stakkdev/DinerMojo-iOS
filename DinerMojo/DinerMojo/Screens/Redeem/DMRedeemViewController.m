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
//#import <Crashlytics/Answers.h>
#import "FakeOfferObject.h"
#import "RedeemPointsToNextLevelCell.h"
#import <SDWebImage/SDWebImage.h>

@interface DMRedeemViewController ()<DMRedeemTableViewCellDelegate>

@end

@implementation DMRedeemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
    [self decorateInterface];
    
    self.birthdayOffers = [[NSMutableDictionary alloc] init];
    
    
    if(self.shouldCloseOnButtonTap) {
        [self.closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if(self.selectedOfferItem != NULL) {
        [self didSelectOfferItem:self.selectedOfferItem withAnimation:NO];
    }
    
    [self.userNewPointsLabel setAdjustsFontSizeToFitWidth:YES];
    [self.userNewPointsLabel setMinimumScaleFactor:0];
    [self.noOffersLabel setText:[NSString stringWithFormat:NSLocalizedString(@"reedem.message.notAvailable", @""), self.selectedVenue.name]];
    [self.noOffersLabel setNumberOfLines:0];
    [self checkIfRedeemed:NO];
}

-(void)close {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:NULL];
}

- (NSDate *)getBdayExpiryDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *bDayComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth fromDate:_currentUser.date_of_birth];
    NSDateComponents *currentDateCompones = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSDateComponents *realDateComponents = [[NSDateComponents alloc] init];
    [realDateComponents setYear:currentDateCompones.year];
    [realDateComponents setMonth:bDayComponents.month];
    [realDateComponents setDay:bDayComponents.day];
    NSDate *bdayDate = [calendar dateFromComponents:realDateComponents];
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 6;
    NSDate *expireDate = [calendar dateByAddingComponents:dayComponent toDate:bdayDate options:0];
    return expireDate;
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
            NSMutableArray *sortedArray = [[NSMutableArray alloc] init];
            NSMutableArray *availableForAllLevelsOffers = [[NSMutableArray alloc] init];
            NSMutableArray *availableForCertainTier = [[NSMutableArray alloc] init];
            NSMutableArray *notAvailableOffers = [[NSMutableArray alloc] init];
            
            
            for (DMOfferItem *offer in [results allObjects]) {
                
                
                if([self.currentUser availableMojoLevels:offer.allowed_mojo_levels]) {
                    if (offer.is_birthday_offerValue == YES) {
                        [sortedArray insertObject:offer atIndex:0];
                    } else {
                        if ([offer.allowed_mojo_levels containsObject:@"4"]) {
                            [availableForAllLevelsOffers addObject:offer];
                        } else {
                            [availableForCertainTier addObject:offer];
                        }
                    }
                } else {
                    if (offer.is_birthday_offerValue == YES) {
                        [notAvailableOffers insertObject:offer atIndex:0];
                    } else {
                        [notAvailableOffers addObject:offer];
                    }
                }
            }
            
            [sortedArray addObjectsFromArray:availableForAllLevelsOffers];
            [sortedArray addObjectsFromArray:availableForCertainTier];
            
            if (notAvailableOffers.count != 0) {
                [sortedArray addObject:[[FakeOfferObject alloc] init]];
                [sortedArray addObjectsFromArray:notAvailableOffers];
            }
            
            self.eligibleOffersArray = sortedArray;
            
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
    self.offerImage = [UIImage imageNamed:@"offer"];
    self.trophyImage = [UIImage imageNamed:@"icon_trophy"];
    self.placeholder = [UIImage imageNamed:@"example_img"];
    self.cakeImage = [UIImage imageNamed:@"icon_cake"];
    _confirmButton.titleLabel.numberOfLines = 2;
    
    self.offerDetailsBdayInfoImgView.clipsToBounds = YES;
    self.offerDetailsBdayInfoImgView.layer.cornerRadius = 20;
    
    self.offerDetailsTimeImgView.clipsToBounds = YES;
    self.offerDetailsTimeImgView.layer.cornerRadius = 11.5;
    
    NSString *myTier = [_currentUser myMojoLevelName];
    [self.myTierLabel setText:[NSString stringWithFormat:@"%@ tier", [myTier capitalizedString]]];
    
   // [self.venueNameLabel setText:self.selectedVenue.name];
   // [self.venueCuisineAreaLabel setText:[NSString stringWithFormat:@"%@ | %@", [[[self.selectedVenue categories] anyObject] name], self.selectedVenue.town]];
    [self.userPointsLabel setText:[NSString stringWithFormat:@"%@", self.currentUser.annual_points_balance]];
    DMVenueImage *venueImage = (DMVenueImage *) [self.selectedVenue primaryImage];

    [self.venueImageView sd_setImageWithURL:[NSURL URLWithString:[venueImage fullURL]]
                 placeholderImage:nil];
    
    _secondViewShadowView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_secondViewShadowView.bounds cornerRadius:0].CGPath;
    [_secondViewShadowView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [_secondViewShadowView.layer setShadowRadius:2.0f];
    [_secondViewShadowView.layer setShadowOffset:CGSizeMake(0, 0)];
    [_secondViewShadowView.layer setShadowOpacity:0.2f];
    
    [_bDayLabel setText:[NSString stringWithFormat:@"Happy birthday %@!", _currentUser.first_name]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (bool)checkIfRedeemed:(bool)coupon {
    if (self.selectedVenue.last_redeem == NULL) {
        return false;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self.selectedVenue.last_redeem];
    
    NSInteger hour = [components hour];
    [components setHour:5];
    [components setMinute:0];
    [components setSecond:0];

    NSDate *resetDate = [calendar dateFromComponents:components];
    if(hour > 4) {
        resetDate = [[NSDate alloc] initWithTimeInterval:60*60*24 sinceDate:resetDate];
    }
    
    if([[[NSDate alloc] init] compare:resetDate] == NSOrderedAscending) {
        CannotRedeemViewController *viewController = [[CannotRedeemViewController alloc] init];
        viewController.venue = self.selectedVenue;
        if (coupon) {
            viewController.imageUrl = self.selectedOfferItem.primitiveImage;
        }
        [viewController setModalPresentationStyle:UIModalPresentationOverFullScreen];
        [self presentViewController:viewController animated:YES completion:NULL];
        return true;
    }
    return false;
}
    
- (void)didSelectOfferItem:(DMOfferItem *)item withAnimation:(BOOL)withAnimation {
    self.selectedOfferItem = item;
    self.isRedeeming = YES;
    [self.userNewPointsLabel setText:[NSString stringWithFormat:@"%d", self.currentUser.annual_points_balanceValue]];
    
    if (item.expiry_date != NULL && item.is_birthday_offer.boolValue != YES) {
        NSDateComponents *components = [self getExpireDateComponents:item.is_birthday_offer.boolValue == YES ? [self getBdayExpiryDate] : item.expiry_date addDays:1];
        NSInteger hour = [components hour];
        NSInteger day = [components day];
        NSInteger month = [components month];
        
        if (month == 0) {
            if (day == 0) {
                [_offerDetailsTimeLeftLabel setText:[NSString stringWithFormat: hour == 1 ? @"only %ld hour left" : @"only %ld hours left", (long)hour]];
            } else {
                if (hour != 0) {
                    day += 1;
                }
                
                [_offerDetailsTimeLeftLabel setText:[NSString stringWithFormat: day == 1 ? @"only %ld day left" : @"only %ld days left", (long)day]];
            }
            
            [_offerDetailsTimeLeftHolder setHidden:NO];
            _offerDetailsTimeHolderHeightConstraint.constant = 23;
            _offerDetailsBdayHolderTopConstraint.constant = 6;
        } else {
            [_offerDetailsTimeLeftHolder setHidden:YES];
            _offerDetailsTimeHolderHeightConstraint.constant = 0;
            _offerDetailsBdayHolderTopConstraint.constant = 0;
        }
    } else if(item.is_birthday_offer.boolValue == YES){
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"d MMM"];
        [_offerDetailsTimeLeftLabel setText:[NSString stringWithFormat: @"valid until %@ ", [dateFormatter stringFromDate:[self getBdayExpiryDate]]]];
        [_offerDetailsTimeLeftLabel setHidden:NO];
    } else {
        [_offerDetailsTimeLeftHolder setHidden:YES];
        _offerDetailsTimeHolderHeightConstraint.constant = 0;
        _offerDetailsBdayHolderTopConstraint.constant = 0;
    }
    
    [_offerDetailsRewardLabel setText:item.news_description];
    
    if (item.terms_conditions != NULL && item.terms_conditions.length > 0) {
        [_offerDetailsSmallPrintLabel setText:item.terms_conditions];
        [_offerDetailsSmallPrintTitleLabel setHidden:NO];
        [_offerDetailsSmallPrintLabel setHidden:NO];
    } else {
        [_offerDetailsSmallPrintTitleLabel setHidden:YES];
        [_offerDetailsSmallPrintLabel setHidden:YES];
    }
    
    NSString *rewardNow = @"Reward me now\n";
    NSString *pointsString = @"It's free for DinerMojo members!";
    
    if(item.points_required.integerValue > 0) {
        pointsString = [NSString stringWithFormat:@"%ld Points", item.points_required.integerValue];
    }
    
    CGSize rewardTextSize = [self findHeightForText:item.news_description havingWidth:[_detailsScrollview contentSize].width andFont:_offerDetailsRewardLabel.font];
    CGSize smallPrintTextSize = [self findHeightForText:item.terms_conditions havingWidth:[_detailsScrollview contentSize].width andFont:_offerDetailsRewardLabel.font];

    _detailsScrollview.contentSize = CGSizeMake([_detailsScrollview contentSize].width, rewardTextSize.height + smallPrintTextSize.height + 66);
    
    NSString *confirmText = [NSString stringWithFormat:@"%@%@", rewardNow, pointsString];
    NSMutableAttributedString *confirmAttributedTitle = [[NSMutableAttributedString alloc] initWithString:confirmText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    [confirmAttributedTitle addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:12.0]
                  range:NSMakeRange(rewardNow.length, pointsString.length)];
    [confirmAttributedTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [confirmText length])];
    
    [_confirmButton setAttributedTitle:confirmAttributedTitle forState:UIControlStateNormal];
    _confirmButton.enabled = [_currentUser availableMojoLevels:item.allowed_mojo_levels];
    
    if ([_currentUser availableMojoLevels:item.allowed_mojo_levels] == YES) {
        _confirmButton.enabled = item.points_required.intValue <= _currentUser.annual_points_balance.intValue;
    }
    
    [_confirmButton setBackgroundColor:_confirmButton.enabled == YES ? [UIColor offersGreenColor] : [UIColor grayColor]];
    
    [_bDayInfoHolder setHidden:item.is_birthday_offer.boolValue == NO];
    _offerDetailsBdayHolderHeightConstraint.constant = item.is_birthday_offer.boolValue == YES ? 40 : 0;
    _offerDetailsRewardTitleTopConstraint.constant = item.is_birthday_offer.boolValue == YES ? 12 : 0;
    
    [self loadImageForImgView:_offerDetailsImageView imageUrl:item.image];
    [_offerDetailsTitle setText:item.title];
    
    
    if (withAnimation) {
        [UIView animateWithDuration:0.3 animations:^{
            self.horizontal.constant = -self.view.frame.size.width;
            self.right.constant = self.view.frame.size.width;
            [self.view layoutIfNeeded];
            _detailsScrollview.contentSize = CGSizeMake([_detailsScrollview contentSize].width, rewardTextSize.height + smallPrintTextSize.height + 66);
        }];
    } else {
        self.horizontal.constant = -self.view.frame.size.width;
        self.right.constant = self.view.frame.size.width;
        [self.view layoutIfNeeded];
        _detailsScrollview.contentSize = CGSizeMake([_detailsScrollview contentSize].width, rewardTextSize.height + smallPrintTextSize.height + 66);
    }
    
    [self.closeButton setImage:[UIImage imageNamed:@"BackNavIcon"] forState:UIControlStateNormal];
}


- (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGSize size = CGSizeZero;
    if (text) {
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font } context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    return size;
}
#pragma mark - UITableView Delegates


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![[self.eligibleOffersArray objectAtIndex:indexPath.row] isKindOfClass:[FakeOfferObject class]]) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.highlighted = NO;
        cell.selected = NO;
        
        DMOfferItem *item = [self.eligibleOffersArray objectAtIndex:indexPath.row];
        [self didSelectOfferItem:item withAnimation:YES];
    }
    
}

- (void)infoClicked:(NSString *)info {
    if (info != nil && info.length != 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"DinerMojo" message:info preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancel];
        
        [alertController setModalPresentationStyle:UIModalPresentationOverFullScreen];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (UITableViewCell *)getRedeemInfoCell:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    RedeemPointsToNextLevelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"RedeemPointsToNextLevelCell" bundle:nil] forCellReuseIdentifier:@"InfoCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.pointsHolderView setBackgroundColor:[_currentUser colorForMojoLevel:[_currentUser nextMojoLevel]]];
    [cell.pointsLabel setText:[NSString stringWithFormat:@"%ld points to %@", [_currentUser pointsToNextLevel], [_currentUser nextMojoLevelName].uppercaseString]];
    [cell.infoLabel setText:[NSString stringWithFormat: [[_currentUser nextMojoLevelName]  isEqual: @"platinum"] ? @"These rewards are available to %@ members" : @"These rewards are available to %@ members and above", [_currentUser nextMojoLevelName]]];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([[self.eligibleOffersArray objectAtIndex:indexPath.row] isKindOfClass:[FakeOfferObject class]]) {
        return [self getRedeemInfoCell:indexPath tableView:tableView];
    }
    
    DMOfferItem *item = [self.eligibleOffersArray objectAtIndex:indexPath.row];
    DMRedeemTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OfferCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"DMRedeemTableViewCell" bundle:nil] forCellReuseIdentifier:@"OfferCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"OfferCell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell.titleLabel setText:item.title];
    if (item.is_birthday_offerValue == YES) {
        cell.infoHolder.backgroundColor = [UIColor bDayColor];
    } else {
        cell.infoHolder.backgroundColor = [_currentUser getMojoLevelColor:item.allowed_mojo_levels];
    }
    
    
    if (item.expiry_date != NULL && item.is_birthday_offer.boolValue != YES) {
        NSDateComponents *components = [self getExpireDateComponents:item.is_birthday_offer.boolValue == YES ? [self getBdayExpiryDate] : item.expiry_date addDays:1];
        NSInteger hour = [components hour];
        NSInteger day = [components day];
        NSInteger month = [components month];
        
        if (month == 0) {
            if (day == 0) {
                [cell.expiryDateLabel setText:[NSString stringWithFormat: hour == 1 ? @"only %ld hour left" : @"only %ld hours left", (long)hour]];
            } else {
                if (hour != 0) {
                    day += 1;
                }
                
                [cell.expiryDateLabel setText:[NSString stringWithFormat: day == 1 ? @"only %ld day left" : @"only %ld days left", (long)day]];
            }
            
            [cell.timeHolderView setHidden:NO];
        } else {
            [cell.timeHolderView setHidden:YES];
        }
    } else if(item.is_birthday_offer.boolValue == YES){
        
         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
         [dateFormatter setDateFormat:@"d MMM"];
         [cell.expiryDateLabel setText:[NSString stringWithFormat: @"valid until %@ ", [dateFormatter stringFromDate:[self getBdayExpiryDate]]]];
         [cell.timeHolderView setHidden:NO];
    } else {
        [cell.timeHolderView setHidden:YES];
    }
    
    
    
    [self loadImageForImgView:cell.mainImageView imageUrl:item.image];
    
    NSString *pointsString = [NSString stringWithFormat:([item.points_required integerValue] == 0) ? @"Its free for DinerMojo members!" : @"%ld Points", (long)[item.points_required integerValue]];
    [cell.pointsLabel setText:pointsString];
    [cell.cakeHolderView setHidden:item.is_birthday_offer.boolValue == NO];
    
    return cell;
    
}

- (NSDateComponents *)getExpireDateComponents:(NSDate *)date addDays:(int)addDays {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = addDays; //adding one day because expiry date doesnt countain hours that means if its valid until today we show how many hours left until tomorrow
    NSDate *expireDate = [calendar dateByAddingComponents:dayComponent toDate:date options:0];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth)
                                               fromDate:[NSDate date]
                                                 toDate:expireDate
                                                options:0];
    
    
    return components;
}

- (void)loadImageForImgView:(UIImageView *)imgView imageUrl:(NSString *)imageUrl {
    __weak UIImageView *weakImgView = imgView;
    
    DMRequest *request = [DMRequest new];
    NSURL *url = [NSURL URLWithString:[request buildMediaURL:imageUrl]];
    
    if (imageUrl.length == 0 || imageUrl == NULL) {
        DMVenueImage *venueImage = (DMVenueImage *) [self.selectedVenue primaryImage];
        url = [NSURL URLWithString:[venueImage fullURL]];
    }
    [imgView sd_setImageWithURL:url];
    
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
    if([[self.eligibleOffersArray objectAtIndex:indexPath.row] isKindOfClass:[FakeOfferObject class]]) {
        return 180;
    }
    
    return 130;
}


- (IBAction)dismissView:(id)sender {
    if (_shouldCloseOnButtonTap) {
        return;
    }
    
    if (self.isRedeeming)
    {
        self.horizontal.constant = 0;
        self.right.constant = 0;
        
        [self.userNewPointsLabel setText:[NSString stringWithFormat:@"%d", self.currentUser.annual_points_balanceValue - self.selectedOfferItem.points_requiredValue]];

        [self.confirmButton setTitle:[NSString stringWithFormat:@"Yes, get ""%@"" now!", self.selectedOfferItem.title] forState:UIControlStateNormal];
        self.confirmButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.confirmButton.titleLabel.minimumScaleFactor = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
           [self.view layoutIfNeeded];
        }];
        
        [self.closeButton setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
        self.isRedeeming = NO;
    } else {
        [(DMDineNavigationController *)[self navigationController] cancelPressed];
    }
}

- (void)showAlertCameraPrivacy
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Camera Privacy" message:@"To use this feature we require your camera for verification. We do not store or use the image in any other way." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *privacy = [UIAlertAction actionWithTitle:@"Privacy Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            NSLog(@"Opened Url: %i", success);
        }];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Not Now" style:UIAlertActionStyleDestructive handler:nil];
    
    
    [alertController addAction:privacy];
    [alertController addAction:cancel];
    
    [alertController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowRedeemCoupon"])
    {
        NSString *type = @"standard";
        if(!self.standardRedeem) {
           type = @"offer";
        }
         //[Answers logContentViewWithName:[NSString stringWithFormat:@"Redeem %@", type] contentType:[NSString stringWithFormat:@"Redeem %@ - %@ - %@", type, self.selectedOfferItem.venue.name ,self.selectedOfferItem.title] contentId:@"" customAttributes:@{}];
        [FIRAnalytics logEventWithName:@"Redeem"
                            parameters:@{
                                         kFIRParameterItemID:[NSString stringWithFormat:@"Redeem %@ - %@ - %@", type, self.selectedOfferItem.venue.name ,self.selectedOfferItem.title],
                                         kFIRParameterItemName:[NSString stringWithFormat:@"Redeem %@ - %@ - %@", type, self.selectedOfferItem.venue.name ,self.selectedOfferItem.title]
                                         }];
        [[FIRCrashlytics crashlytics] logWithFormat:@"%@", [NSString stringWithFormat:@"Redeem %@ - %@ - %@", type, self.selectedOfferItem.venue.name ,self.selectedOfferItem.title]];
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(granted)
                    {
                        [self postCoupon];
                        
                    }
                    
                    else
                    {
                        [self showAlertCameraPrivacy];
                    }
                });
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
    if (![self checkIfRedeemed:YES]) {
        [self checkCamera];
    }
}
@end
