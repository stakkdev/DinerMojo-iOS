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


@interface DMFavouritesViewController () <TabsFilterViewDelegate, DMRestaurantCellDelegate, DMSortVenueFeedViewControllerDelegate>

@property(strong, nonatomic) DMVenueModelController *venueModelController;

@property(nonatomic, strong) UIBarButtonItem *editButton;
@property(strong, nonatomic) UIToolbar *toolBar;
@property(strong, nonatomic) UIButton *selectToolBarButton;
@property(strong, nonatomic) UIButton *deleteToolBarButton;

@property(weak, nonatomic) IBOutlet UILabel *emptyTableLabel;
@property(weak, nonatomic) IBOutlet UIView *emptyTableDescriptionView;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property(weak, nonatomic) IBOutlet UIView *tabsFilterViewContainer;
@property (strong, nonatomic) NSArray *filterItems;
@property (strong, nonatomic) NSArray *venues;

@end

@implementation DMFavouritesViewController

#pragma mark - life cycles

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addEditBtn];

    _venueModelController = [DMVenueModelController new];
    _venueModelController.state = DMVenueListFavourite;
    [self favouritesTableView].allowsMultipleSelectionDuringEditing = YES;
    [[self favouritesTableView] registerNib:[UINib nibWithNibName:@"DMRestaurantCell" bundle:nil] forCellReuseIdentifier:@"RestaurantCell"];
    [self toolBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self downloadVenues];
    [[self favouritesTableView] setHidden:YES];
}

- (void)addEditBtn {
    _editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(btnEditClicked)];
    self.navigationItem.leftBarButtonItem = _editButton;
    [_editButton setTitleTextAttributes:@{NSFontAttributeName: [UIFont navigationBarButtonItemFont]}
                               forState:UIControlStateNormal];

    [self toggleEditButtonEnabled];

    UIBarButtonItem *sortButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"sort.button.title", nil) style:UIBarButtonItemStylePlain target:self action:@selector(sortButtonPressed:)];
    self.navigationItem.rightBarButtonItem = sortButton;
    [_editButton setTitleTextAttributes:@{NSFontAttributeName: [UIFont navigationBarButtonItemFont]}
                               forState:UIControlStateNormal];


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

    double distance = [[DMLocationServices sharedInstance] userLocationDistanceFromLocation:venueCoordinates];

    MKDistanceFormatter *df = [MKDistanceFormatter new];
    [df setUnitStyle:MKDistanceFormatterUnitStyleFull];

    NSString *friendlyDistance = [df stringFromDistance:distance];

    // TODO: Once we have user location, calculate distance based on the longitude and latitude
    [[cell restaurantDistance] setText:[NSString stringWithFormat:@"%@", friendlyDistance]];
    
    if([venueImage fullURL].length == 0) {
        [[cell restaurantImageView] setImage:[self imageWithColor:[UIColor grayColor]]];
    } else {
        NSURL *url = [NSURL URLWithString:[venueImage fullURL]];
        [[cell restaurantImageView] setImageWithURL:url];
    }


    CGFloat alpha = (CGFloat) (([[self favouritesTableView] isEditing]) ? 0.0 : 1.0);
    cell.restaurantDistance.alpha = alpha;
    cell.restaurantPrice.alpha = alpha;

    cell.index = indexPath;
    cell.delegate = self;

    [cell setEarnVisibility:([item.allows_earns isEqualToNumber:[NSNumber numberWithBool:YES]]) ? YES : NO];
    [cell setRedeemVisibility:([item.allows_redemptions isEqualToNumber:[NSNumber numberWithBool:YES]]) ? YES : NO];


    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    return 166;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self favouritesTableView] isEditing]) {
        [self toggleDeleteButtonEnabled];
        return;
    }
    DMVenue *item = _venues[(NSUInteger) indexPath.row];
    [self performSegueWithIdentifier:@"favouritesSegue" sender:item];
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath; {
    if ([[self favouritesTableView] isEditing]) {
        [self toggleDeleteButtonEnabled];
        return;
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"favouritesSegue"]) {
        //pass data to the next controller here
        [(DMRestaurantInfoViewController *) [segue destinationViewController] setSelectedVenue:sender];
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}


#pragma mark - Actions

- (void)btnEditClicked {
    [self toggleEditMode];
}

- (void)sortButtonPressed:(id)sender {
    UINavigationController *vc = (UINavigationController*)DMViewControllersProvider.instance.sortVC;

    if (vc.viewControllers.count > 0) {
        DMSortVenueFeedViewController *filterVC = vc.viewControllers[0];
        filterVC.delegate = self;
        filterVC.filterItems = self.filterItems;
    }

    [vc setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self presentViewController:vc animated:YES completion:nil];
}

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

- (void)toggleEditMode; {
    [[self favouritesTableView] setEditing:![[self favouritesTableView] isEditing] animated:YES];
    if ([[self favouritesTableView] isEditing]) {
        [_editButton setTitle:@"Cancel"];
        [self.navigationItem setTitle:@"Edit Favourites"];
        // [self hideTabBar:self.tabBarController];
        [self showToolBar];
        [self updateOnScreenCellsForEditMode:YES];
    } else {
        [_editButton setTitle:@"Edit"];
        [self.navigationItem setTitle:@"Favourites"];
        //  [self showTabBar:self.tabBarController];
        [self hideToolBar];
        [self updateOnScreenCellsForEditMode:NO];
    }
}


- (void)toggleEditButtonEnabled; {
    [_editButton setEnabled:([_venues count] != 0)];
}


- (void)downloadVenues {
    [self.emptyTableDescriptionView setHidden:YES];
    [self.emptyTableLabel setHidden:NO];
    [[self activityIndicator] startAnimating];
    [self.emptyTableLabel setText:@"Fetching favourites..."];

    [[self userRequest] downloadFavouriteVenuesWithCompletionBlock:^(NSError *error, id results) {
        if (error == nil) {
            _venues = results;
            NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            _venues = [_venues sortedArrayUsingDescriptors:@[sort]];
            
            [UIView transitionWithView:self.favouritesTableView duration:0.35f options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void) {
                [self.favouritesTableView reloadData];
            }               completion:nil];

            [[self favouritesTableView] setHidden:NO];

            [self toggleNoFavouritesLabel];
            [self toggleEditButtonEnabled];

        } else {
            [self.emptyTableLabel setHidden:NO];
            [self.emptyTableLabel setText:@"Can't fetch favourites. Check your connection"];
        }

        [[self activityIndicator] stopAnimating];
    }];
}


- (void)updateOnScreenCellsForEditMode:(BOOL)editMode {
    NSArray *visibleCells = [[self favouritesTableView] visibleCells];

    CGFloat alpha = (CGFloat) (editMode ? 0.0 : 1.0);

    for (DMRestaurantCell *cell in visibleCells) {
        [UIView animateWithDuration:0.35f animations:^{
            cell.restaurantDistance.alpha = alpha;
            cell.restaurantPrice.alpha = alpha;
        }];
    }
}


- (void)toggleNoFavouritesLabel; {
    if ([_venues count] == 0) {

        [[self emptyTableLabel] setHidden:NO];
        [[self emptyTableLabel] setText:@"No favourites at the moment"];
        [[self emptyTableDescriptionView] setHidden:NO];
        [[self favouritesTableView] setHidden:YES];
    } else {
        [[self emptyTableLabel] setHidden:YES];
        [[self emptyTableDescriptionView] setHidden:YES];
    }

}


- (void)deleteFavouriteVenues:(NSArray *)venues {
    [[self userRequest] deleteVenues:venues withCompletionBlock:^(NSError *error, id results) {
        NSMutableArray *mutableResults = [[NSMutableArray alloc] initWithArray:results];
        NSMutableArray *venuesToDelete = [[NSMutableArray alloc] init];
        for(DMVenue *venue in mutableResults) {
            if(venue.name == NULL) {
                [venuesToDelete addObject: venue];
            }
        }
        for (DMVenue *venue in venuesToDelete) {
            [mutableResults removeObject:venue];
        }
        _venues = mutableResults;
        [[self venueModelController] setVenues:results];

        [[self favouritesTableView] reloadData];

        [self toggleEditMode];

        [self toggleEditButtonEnabled];
        [self toggleNoFavouritesLabel];
    }];
}


- (void)toggleDeleteButtonEnabled; {
    NSArray *selectedItemsIndexPaths = [[self favouritesTableView] indexPathsForSelectedRows];

    if ([selectedItemsIndexPaths count] == 0) {
        [[self deleteToolBarButton] setEnabled:NO];
        [[self deleteToolBarButton] setAlpha:0.5];
    } else {
        [[self deleteToolBarButton] setEnabled:YES];
        [[self deleteToolBarButton] setAlpha:1];

    }

}


- (void)deleteRow; {
    NSArray *selectedItemsIndexPaths = [[self favouritesTableView] indexPathsForSelectedRows];
    NSMutableArray *venue_ids = [NSMutableArray new];

    for (NSIndexPath *indexPath in selectedItemsIndexPaths) {
        DMVenue *venue = _venues[indexPath.row];
        [venue_ids addObject:venue.modelID];
    }

    [self deleteFavouriteVenues:venue_ids];
    [self toggleNoFavouritesLabel];
}


- (void)showToolBar {
    [UIToolbar animateWithDuration:0.3 animations:^{

        [[self toolBar] setFrame:CGRectMake(CGRectGetMinX([self toolBar].frame),
                CGRectGetMinY([self toolBar].frame) - CGRectGetHeight([self toolBar].frame),
                CGRectGetWidth([self toolBar].frame),
                CGRectGetHeight([self toolBar].frame))];
    }];
}


- (void)hideToolBar {
    [UIToolbar animateWithDuration:0.3 animations:^{

        [[self toolBar] setFrame:CGRectMake(CGRectGetMinX([self toolBar].frame),
                CGRectGetMinY([self toolBar].frame) + CGRectGetHeight([self toolBar].frame),
                CGRectGetWidth([self toolBar].frame),
                CGRectGetHeight([self toolBar].frame))];
    }];
}


- (void)selectAllRows; {
    for (NSInteger s = 0; s < [self favouritesTableView].numberOfSections; s++) {
        for (NSInteger r = 0; r < [[self favouritesTableView] numberOfRowsInSection:s]; r++) {
            [[self favouritesTableView] selectRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s]
                                                    animated:NO
                                              scrollPosition:UITableViewScrollPositionNone];
        }
    }
    [self toggleDeleteButtonEnabled];
}


#pragma mark - lazy loading


- (UIToolbar *)toolBar {
    if (_toolBar) {
        return _toolBar;
    }
    _toolBar = [[UIToolbar alloc] init];

    _toolBar.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, self.tabBarController.tabBar.frame.size.height);
    [self.tabBarController.view addSubview:_toolBar];
    [_toolBar setBackgroundImage:[self imageWithColor:[[UIColor navColor] colorWithAlphaComponent:1]] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
    [self selectToolBarButton];
    [self deleteToolBarButton];

    return _toolBar;
}


- (UIButton *)selectToolBarButton {
    if (_selectToolBarButton) {
        return _selectToolBarButton;
    }
    _selectToolBarButton = [[UIButton alloc] init];

    [_selectToolBarButton setTitle:@"Select All" forState:UIControlStateNormal];
    [_selectToolBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_selectToolBarButton setBackgroundColor:[UIColor clearColor]];
    [[_selectToolBarButton titleLabel] setFont:[UIFont fontWithName:@"OpenSans-Light" size:14]];
    _selectToolBarButton.frame = CGRectMake(0, 0, 100, 50);

    [_selectToolBarButton addTarget:self action:@selector(selectAllRows) forControlEvents:UIControlEventTouchUpInside];

    [self.toolBar addSubview:_selectToolBarButton];
    return _selectToolBarButton;
}


- (UIButton *)deleteToolBarButton {
    if (_deleteToolBarButton) {
        return _deleteToolBarButton;
    }

    _deleteToolBarButton = [[UIButton alloc] init];

    [_deleteToolBarButton setTitle:@"Delete" forState:UIControlStateNormal];
    [_deleteToolBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_deleteToolBarButton setBackgroundColor:[UIColor clearColor]];
    [[_deleteToolBarButton titleLabel] setFont:[UIFont fontWithName:@"OpenSans-Light" size:14]];
    _deleteToolBarButton.frame = CGRectMake(self.toolBar.frame.size.width - 100, 0, 100, 50);

    [_deleteToolBarButton addTarget:self action:@selector(deleteRow) forControlEvents:UIControlEventTouchUpInside];

    [self.toolBar addSubview:_deleteToolBarButton];

    [self toggleDeleteButtonEnabled];
    return _deleteToolBarButton;

}


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

- (void)selectedFilterItems:(NSArray *)filterItems {
    self.filterItems = filterItems;
    _venueModelController.filters = filterItems;
    [self.favouritesTableView reloadData];
}


@end
