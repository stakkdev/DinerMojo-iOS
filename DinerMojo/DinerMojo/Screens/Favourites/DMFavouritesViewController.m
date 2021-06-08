//
//  DMFavouritesViewController.m
//  DinerMojo
//
//  Created by Carl Sanders on 06/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMFavouritesViewController.h"
#import "DMRestaurantInfoViewController.h"
#import "DMMapViewController.h"
#import "DMVenueModelController.h"
#import "DMRestaurantCell.h"
#import "TabsFilterView.h"
#import <PureLayout/PureLayout.h>
#import "DinerMojo-Swift.h"
#import <SDWebImage/SDWebImage.h>


@interface DMFavouritesViewController () <TabsFilterViewDelegate, DMRestaurantCellDelegate, DMSortVenueFeedViewControllerDelegate>

@property(strong, nonatomic) DMVenueModelController *venueModelController;
@property (strong, nonatomic) DMVenueRequest* venueRequest;

@property(nonatomic, strong) UIBarButtonItem *editButton;
@property(strong, nonatomic) UIToolbar *toolBar;
@property(strong, nonatomic) UIButton *selectToolBarButton;
@property(strong, nonatomic) UIButton *deleteToolBarButton;

@property(weak, nonatomic) IBOutlet UILabel *emptyTableLabel;
@property(weak, nonatomic) IBOutlet UIView *emptyTableDescriptionView;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property(weak, nonatomic) IBOutlet UIView *tabsFilterViewContainer;
@property (strong, nonatomic) NSArray *filterItems;
@property (strong, nonatomic) NSMutableArray *venues;

@end

@implementation DMFavouritesViewController

#pragma mark - life cycles

- (void)viewDidLoad {
    [super viewDidLoad];

    _venueRequest = [DMVenueRequest new];
    _venueModelController = [DMVenueModelController new];
    _venueModelController.state = DMVenueListFavourite;
    [self favouritesTableView].allowsMultipleSelectionDuringEditing = YES;
    [[self favouritesTableView] registerNib:[UINib nibWithNibName:@"DMRestaurantCell" bundle:nil] forCellReuseIdentifier:@"RestaurantCell"];
    [self setUpNavBarWithButtons];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self downloadVenues];
    [self navigationItem].title = @"Favourites";
}

#pragma mark - Setup

- (void)setUpNavBarWithButtons {
    UIBarButtonItem *deleteAllButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"remove.all.title", nil) style:UIBarButtonItemStylePlain target:self action:@selector(deleteAllPressed:)];
    self.navigationItem.rightBarButtonItem = deleteAllButton;
//    [_editButton setTitleTextAttributes:@{NSFontAttributeName: [UIFont navigationBarButtonItemFont]}
//                               forState:UIControlStateNormal];


}

#pragma mark - TableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _venues.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DMRestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RestaurantCell"];
    DMVenue *item = _venues[indexPath.row];
    DMVenueImage *venueImage = [item primaryImage];

    NSString *category = [[[item categories] anyObject] name];
    [[cell restaurantName] setText:item.name];
    [[cell restaurantCategory] setText:[NSString stringWithFormat:@"%@ | %@", category, [item friendlyPlaceName]]];
    [[cell restaurantPrice] setText:[item priceBracketString]];

    NSNumber *latitude = item.latitude;
    NSNumber *longitude = item.longitude;
    CLLocation *venueCoordinates = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];

    [[cell restaurantType] setText:[NSString stringWithFormat:@"%@", category]];
    double distance = [[DMLocationServices sharedInstance] userLocationDistanceFromLocation:venueCoordinates];
    if (distance == 0 ) {
        [[cell restaurantDistance] setText:@""];
    } else {
        MKDistanceFormatter *df = [MKDistanceFormatter new];
        [df setUnitStyle:MKDistanceFormatterUnitStyleFull];
        NSString *friendlyDistance = [df stringFromDistance:distance];
        [[cell restaurantDistance] setText:[NSString stringWithFormat:@"%@", friendlyDistance]];
    }
    
    if([venueImage fullURL].length == 0) {
        [[cell restaurantImageView] setImage:[self imageWithColor:[UIColor grayColor]]];
    } else {        
        [[cell restaurantImageView] sd_setImageWithURL:[NSURL URLWithString:[venueImage fullURL]]
                     placeholderImage:nil];
    }

    CGFloat alpha = (CGFloat) (([[self favouritesTableView] isEditing]) ? 0.0 : 1.0);
    cell.restaurantDistance.alpha = alpha;
    cell.restaurantPrice.alpha = alpha;

    cell.index = indexPath;
    cell.delegate = self;

    [cell setEarnVisibility:([item.allows_earns isEqualToNumber:[NSNumber numberWithBool:YES]]) ? YES : NO];
    [cell setRedeemVisibility:([item.allows_redemptions isEqualToNumber:[NSNumber numberWithBool:YES]]) ? YES : NO];
    [cell setToFavourite:YES];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    return 166;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self favouritesTableView] isEditing]) {
        return;
    }
    DMVenue *item = _venues[(NSUInteger) indexPath.row];
    [self performSegueWithIdentifier:@"favouritesSegue" sender:item];
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath; {
    if ([[self favouritesTableView] isEditing]) {
        return;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"favouritesSegue"]) {
        //pass data to the next controller here
        [(DMRestaurantInfoViewController *) [segue destinationViewController] setSelectedVenue:sender];
    }
}




#pragma mark - Actions

- (void)deleteAllPressed:(id)sender {
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Remove all" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deleteAllFavouriteVenues];
    }];
    [self displayWarning:@"Warning" message:@"Are you sure you would like to continue?" action:action dismissActionTitle:@"Cancel"];

}

#pragma mark - Data

- (void)downloadVenues {
    [self.emptyTableDescriptionView setHidden:YES];
    [self.emptyTableLabel setHidden:NO];
    [[self activityIndicator] startAnimating];
    [self.emptyTableLabel setText:@"Fetching favourites..."];
    [[ self venueRequest] cachedFavoriteVenues:^(NSError *error, id results) {
        [self gotFavouriteVenuesCompletionBlock:error id:results final:false];
    }];


    [[self userRequest] downloadFavouriteVenuesWithCompletionBlock:^(NSError *error, id results) {
        [self gotFavouriteVenuesCompletionBlock:error id:results final:true];
    }];
}

- (void)gotFavouriteVenuesCompletionBlock:(NSError *)error id:(NSArray *)results final: (BOOL)final {
    if (error == nil) {
        [self updateVenues:results];
        [UIView transitionWithView:self.favouritesTableView duration:0.35f options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void) {
            [self.favouritesTableView reloadData];
        }               completion:nil];

        [[self favouritesTableView] setHidden:NO];
        [self toggleNoFavouritesLabel];
        if (!final) {
            [[self activityIndicator] stopAnimating];
        }
    } else {
        if (final && _venues.count == 0) {
            [self.emptyTableLabel setHidden:NO];
            [self.emptyTableLabel setText:@"Can't fetch favourites. Check your connection"];
        } else {
            // Do nothing, let network call finish
        }
    }
    if (final) {
        [[self activityIndicator] stopAnimating];
    }
}

- (void)updateVenues:(NSMutableArray *)venues {
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortedVenues = [venues sortedArrayUsingDescriptors:@[sort]];
    NSMutableArray *newVenues = [[NSMutableArray alloc]initWithArray:sortedVenues];
    _venues = newVenues;
//    [_favouritesTableView reloadData];
}

- (void)deleteAllFavouriteVenues {
    NSMutableArray *venue_ids = [NSMutableArray new];
    for (DMVenue *venue in _venues) {
        [venue_ids addObject:venue.modelID];
    }
    [self deleteFavouriteVenues:venue_ids];
}

- (void)deleteFavouriteVenues:(NSArray *)venues {
    [[self userRequest] deleteVenues:venues withCompletionBlock:^(NSError *error, id results) {
        if (error) {
            [self displayError:@"Error" message: error.localizedDescription];
        }
        [[ self venueRequest] cachedFavoriteVenues:^(NSError *error, id results) {
            [self gotFavouriteVenuesCompletionBlock:error id:results final:false];
        }];
    }];
}


#pragma mark - UI

- (void)toggleNoFavouritesLabel; {
    if ([_venues count] == 0) {

        [[self emptyTableLabel] setHidden:NO];
        [[self emptyTableLabel] setText:@"No favourites at the moment"];
        [[self emptyTableDescriptionView] setHidden:NO];
        [[self favouritesTableView] setHidden:YES];
    } else {
        [[self emptyTableLabel] setHidden:YES];
        [[self emptyTableDescriptionView] setHidden:YES];
        [[self favouritesTableView] setHidden:NO];
    }

}


#pragma mark - lazy loading

- (UIImage *)imageWithColor:(UIColor *)color {

    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}


// MARK: - Restaurant cell delegate

- (void)didSelectRedeem:(NSIndexPath *)index {
    DMVenue *item = [_venues objectAtIndex:index.row];
    if([item.allows_earns isEqualToNumber:@YES]) {
        [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusSuccess title:@"Earn points here!" description:NSLocalizedString(@"earn.message.available", nil) style:UIBlurEffectStyleExtraLight actionButtonTitle:nil color:[UIColor colorWithRed:(245/255.f) green:(147/255.f) blue:(54/255.f) alpha:1]];
    }
    else {
        [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusError title:@"Earn" description:[[NSString alloc] initWithFormat:@"%@ %@", NSLocalizedString(@"earn.message.not.available", nil), item.name] style:UIBlurEffectStyleExtraLight actionButtonTitle:nil color:[UIColor colorWithRed:(245/255.f) green:(147/255.f) blue:(54/255.f) alpha:1]];
    }
}

- (void)didSelectEarn:(NSIndexPath *)index {
    DMVenue *item = [_venues objectAtIndex:index.row];
    if([item.allows_redemptions isEqualToNumber:@YES]) {
        [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusSuccess title:@"Reedem points here!" description:NSLocalizedString(@"redeem.message.available", nil) style:UIBlurEffectStyleExtraLight actionButtonTitle:nil color:[UIColor colorWithRed:(245/255.f) green:(147/255.f) blue:(54/255.f) alpha:1]];
    }
    else {
        NSString *cannotReedem = [[NSString alloc] initWithFormat:@"You can't redeem points at %@ but you can earn them here and reedem them anywhere you see this symbol ", item.name];
        NSMutableAttributedString *cannotRedeem2 = [[NSMutableAttributedString alloc] initWithString:cannotReedem];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageNamed:@"redeem_icon_enabled"];
        textAttachment.bounds = CGRectMake(0, 0, 20, 20);
        
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [cannotRedeem2 appendAttributedString:attrStringWithImage];
        
        [self presentOperationCompleteViewControllerWithStatusAttributed:DMOperationCompletePopUpViewControllerStatusError title:@"Reedem" description:cannotRedeem2 style:UIBlurEffectStyleExtraLight actionButtonTitle:nil color:[UIColor colorWithRed:(245/255.f) green:(147/255.f) blue:(54/255.f) alpha:1]];
    }
}

- (void)didSelectFavourite:(BOOL)favourite atIndex:(NSIndexPath *)index {
    DMVenue *venue =  [_venues objectAtIndex:[index row]];
    [[self userRequest] toggleVenue:venue to:favourite withCompletionBlock:^(NSError *error, id results) {
        if (error) {
            [self displayError:@"Error" message:@"Unable to update favourites preference. Please check your connection and try again."];
            [[self venueRequest] cachedFavoriteVenues:^(NSError *error, id results) {
                [self gotFavouriteVenuesCompletionBlock:error id:results final:YES];
            }];
        }
    }];
    [[self venueRequest] cachedFavoriteVenues:^(NSError *error, id results) {
        [self gotFavouriteVenuesCompletionBlock:error id:results final:YES];
    }];
}

// MARK: - Util

-(void)displayError:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:true completion:nil];
}

-(void)displayWarning:(NSString *)title message:(NSString *)message action:(UIAlertAction *)action dismissActionTitle:(NSString *)dismissActionTitle {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle: UIAlertControllerStyleAlert];
    [alert addAction:action];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:dismissActionTitle style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:dismissAction];
    [self presentViewController:alert animated:true completion:nil];
}


@end
