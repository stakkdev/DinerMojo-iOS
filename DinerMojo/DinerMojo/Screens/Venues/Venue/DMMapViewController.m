//
//  DMMapViewController.m
//  DinerMojo
//
//  Created by hedgehog lab on 27/04/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMMapViewController.h"
#import "DMVenueModelController.h"
#import "DMRestaurantCell.h"
#import "DMRequest.h"
#import "DMRestaurantInfoViewController.h"
#import "DMLocationServices.h"
#import "UIImage+Extensions.h"
#import "TabsFilterView.h"
#import <PureLayout/PureLayout.h>
#import "DinerMojo-Swift.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <Crashlytics/Answers.h>
#import <SDWebImage/SDWebImage.h>

@import MapKit;

@interface DMMapViewController () <TabsFilterViewDelegate, DMRestaurantCellDelegate, DMSortVenueFeedViewControllerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, MKMapViewDelegate>

@property (strong, nonatomic) DMVenueRequest* venueRequest;
@property (strong, nonatomic) DMUserRequest* userRequest;
@property (strong, nonatomic) DMVenueModelController* mapModelController;
@property (weak, nonatomic) IBOutlet UIView *tabsFilterViewContainer;
@property (strong, nonatomic) TabsFilterView *tabsFilterView;
@property (strong, nonatomic) NSArray *filterItems;
@property (strong, nonatomic) NSArray *favouriteIds;

@end

@implementation DMMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
     [NSUserDefaults.standardUserDefaults setInteger:0 forKey:@"didSort"];
    
    _venueRequest = [DMVenueRequest new];
    _mapModelController = [DMVenueModelController new];
    _mapModelController.filterLifestyle = NO;
    _mapModelController.state = DMVenueMap;
    FilterItem *nearestFilter = [[FilterItem alloc] initWithGroupName:GroupsNameSortBy itemId:SortByItemsNearestItem value:SortByItemsNearestItem];
    FilterItem *alphabeticalSort = [[FilterItem alloc] initWithGroupName:GroupsNameSortBy itemId:SortByItemsAZ value:SortByItemsAZ];
    NSMutableArray *initialFilters = [[NSMutableArray alloc] init];
    if (DMLocationServices.sharedInstance.currentLocation) {
        [initialFilters addObject:nearestFilter];
    } else {
        [initialFilters addObject:alphabeticalSort];
    }
    _mapModelController.filters = initialFilters;
    [_mapModelController apply:initialFilters];
 
    
    [restaurantsTableView registerNib:[UINib nibWithNibName:@"DMRestaurantCell" bundle:nil] forCellReuseIdentifier:@"RestaurantCell"];
    [self setupView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Answers logContentViewWithName:@"View venues" contentType:@"" contentId:@"" customAttributes:@{}];
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor brandColor]];
    self.navigationController.view.backgroundColor = [UIColor brandColor];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController setNavigationBarHidden:NO];
    [self setTitle:@"Venues"];
    [self.navigationItem setTitle:@"Venues"];
    [self.navigationController.navigationBar.topItem setTitle:@"Venues"];
    [self.activityIndicator startAnimating];
    [self downloadVenues];
    
    if([NSUserDefaults.standardUserDefaults boolForKey:@"showNotificationsOverlay"] && ![NSUserDefaults.standardUserDefaults boolForKey:@"shownNotificationsOverlay"]) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UIViewController *root = appDelegate.window.rootViewController;
        [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"shownNotificationsOverlay"];
        UINavigationController *nav = (UINavigationController *)root;
        if(nav.viewControllers.firstObject != NULL) {
            StartupNotificationsViewController*vc = [[StartupNotificationsViewController alloc] initWithNibName:@"StartupNotificationsViewController" bundle:NULL];
            vc.view.backgroundColor = [[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:0.95];
            vc.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
            [vc setModalPresentationStyle:UIModalPresentationOverFullScreen];
            [self.navigationController presentViewController:vc animated:YES completion:nil];        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self checkIfShowBirthdayPopUp];
    [self checkIfAcceptedGDPR];
}

- (void)checkIfAcceptedGDPR {
    DMUser* currentUser = [[self userRequest] currentUser];
    
    __weak DMMapViewController *weakSelf = self;
    [[self userRequest] downloadUserProfileWithCompletionBlock:^(NSError *error, id results) {
        if(!currentUser.is_gdpr_acceptedValue && ![NSUserDefaults.standardUserDefaults boolForKey:@"didShowGDPR"]  && [[weakSelf userRequest] isUserLoggedIn]) {
            [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"didShowGDPR"];
            AcceptGdprViewController *acceptViewController = [[AcceptGdprViewController alloc] initWithNibName:@"AcceptGdprViewController" bundle:nil];
            [acceptViewController setModalPresentationStyle:UIModalPresentationOverFullScreen];
            [weakSelf presentViewController:acceptViewController animated:YES completion:NULL];
        }
    }];
}

- (void)setupView {
    restaurantsTableView.emptyDataSetSource = self;
    restaurantsTableView.emptyDataSetDelegate = self;
    restaurantsTableView.tableFooterView = [UIView new];
    
    [self setupMap];
    [self setupCollectionView];
    
    TabsFilterView *tabView = [[NSBundle mainBundle] loadNibNamed:@"TabsFilterView" owner:self options:nil][0];
    tabView.delegate = self;
    [tabView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.tabsFilterViewContainer addSubview:tabView];
    [tabView autoPinEdgesToSuperviewEdges];
    self.tabsFilterView = tabView;
    [self.tabsFilterView selectTabForType:DMVenueMap];
}



/// MapView

-(void)setupMap {
    [mapView setShowsUserLocation:YES];
    [mapView registerClass:[CustomAnnotationView class] forAnnotationViewWithReuseIdentifier:MKMapViewDefaultAnnotationViewReuseIdentifier];
    [mapView setDelegate:self];
    CLLocation *newLocation = [DMLocationServices sharedInstance].currentLocation;
    [self zoomMapTo:newLocation];
    [self reloadMapAnnotations];
}

-(void)reloadMapAnnotations {
    CLLocation *newLocation = [DMLocationServices sharedInstance].currentLocation;
    [self zoomMapTo:newLocation];
    
    NSArray *annotations = [[self mapModelController] mapAnnotations];
    [mapView removeAnnotations:[mapView annotations]];
    [mapView addAnnotations:annotations];
    [collectionView reloadData];
}

-(void)zoomMapTo:(CLLocation *)newLocation {
    double miles = 1.0;
    double scalingFactor = ABS( (cos(2 * M_PI * newLocation.coordinate.latitude / 360.0) ));
    MKCoordinateSpan span;
    span.latitudeDelta = miles/69.0;
    span.longitudeDelta = miles/(scalingFactor * 69.0);
    MKCoordinateRegion region;
    region.span = span;
    region.center = newLocation.coordinate;
    [mapView setRegion:region animated:YES];
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", view.annotation.title];
    NSArray *filteredArray = [[[self mapModelController] filteredVenues] filteredArrayUsingPredicate:predicate];
    
    if (filteredArray.count > 0) {
        DMVenue *venue = [filteredArray objectAtIndex:0];
        NSInteger index = [[[self mapModelController] filteredVenues] indexOfObject:venue];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        });
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", view.annotation.title];
    NSArray *filteredArray = [[[self mapModelController] filteredVenues] filteredArrayUsingPredicate:predicate];
    
    if (filteredArray.count > 0) {
        DMVenue *venue = [filteredArray objectAtIndex:0];        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([venue.state integerValue] == DMVenueStateVerified) {
                [self performSegueWithIdentifier:@"restaurantInfoSegue" sender:venue];
            }
        });
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if (_collectionViewCellSelected == NO) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
}



// MARK: - Collection View Delegate

-(void)setupCollectionView {
    [collectionView setDelegate:self];
    [collectionView setDataSource:self];
    [collectionView setBackgroundColor:[UIColor clearColor]];
    _collectionViewCellSelected = NO;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[self mapModelController] mapAnnotations] count];;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"VenueCollectionViewCell";
    VenueCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    DMVenue *item = [[[self mapModelController] filteredVenues] objectAtIndex:indexPath.row];
    
    DMVenueImage *venueImage = (DMVenueImage *) [item primaryImage];
    NSString *category = [[[item categories] anyObject] name];
    
    cell.cellWidth.constant = UIScreen.mainScreen.bounds.size.width * 0.75;
    [cell.restaurantPrice setHidden:(_mapModelController.state == DMVenueList)];
    [cell.restaurantType setHidden:(_mapModelController.state == DMVenueList)];
    [[cell restaurantName] setText:item.name];
    [[cell restaurantType] setText:[NSString stringWithFormat:@"%@", category]];
    [[cell restaurantCategory] setText:[NSString stringWithFormat:@"%@", [[item friendlyPlaceName] uppercaseString]]];
    [[cell restaurantPrice] setText:[item priceBracketString]];
    [[cell restaurantImageView] setAlpha:1.0];

    if ([item.state integerValue] == DMVenueStateVerfiedDemo)
    {
        [[cell restaurantCategory] setText:@"Coming Soon to DinerMojo"];
        [[cell restaurantImageView] setAlpha:0.6];

    }
    
    cell.index = indexPath;
    cell.delegate = self;

    [cell setEarnVisibility:item.allows_earnsValue];
    [cell setRedeemVisibility:item.allows_redemptionsValue];

    NSNumber *latitude = item.latitude;
    NSNumber *longitude = item.longitude;
    CLLocation *venueCoordinates = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    
    double distance = [[DMLocationServices sharedInstance] userLocationDistanceFromLocation:venueCoordinates];
    if(distance != 0) {
        MKDistanceFormatter *df = [MKDistanceFormatter new];
        [df setUnitStyle:MKDistanceFormatterUnitStyleFull];
        
        NSString *friendlyDistance = [df stringFromDistance:distance];
        [[cell restaurantDistance] setText:[NSString stringWithFormat:@"(%@)",friendlyDistance]];
    } else {
        [[cell restaurantDistance] setText:@""];
    }
    NSString *urlString = [venueImage fullThumbURL];
    if(urlString == NULL) {
        urlString = [venueImage fullURL];
    }
    cell.restaurantImageView.image = nil;
    [[cell restaurantImageView] sd_setImageWithURL:[NSURL URLWithString:urlString]
                 placeholderImage:nil];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.clipsToBounds = YES;
    cell.layer.masksToBounds = YES;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _collectionViewCellSelected = YES;
    NSArray *selectedAnnotations = mapView.selectedAnnotations;
    for(id annotation in selectedAnnotations) {
        [mapView deselectAnnotation:annotation animated:NO];
    }
    
    MKPointAnnotation *annotation = [[[self mapModelController] mapAnnotations] objectAtIndex:indexPath.row];
    [mapView selectAnnotation:annotation animated:YES];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
    [self zoomMapTo:location];
    _collectionViewCellSelected = NO;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = UIScreen.mainScreen.bounds.size.width * 0.75;
    return CGSizeMake(width, 110.0);
}

// MARK: - Others



- (void)checkLastBirthdayViewControllerFiredDate {
    if (![NSUserDefaults.standardUserDefaults boolForKey:@"disabledBirthdayPopup"]) {
        NSDate *lastDate = [NSUserDefaults.standardUserDefaults valueForKey:@"setBirthday"];
        if (lastDate != NULL) {
            NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                                fromDate:lastDate
                                                                  toDate:[NSDate date]
                                                                 options:0];
            if ([components day] > 30) {
                [self presentBirthdayViewController];
            }
            
        } else {
            [self presentBirthdayViewController];
        }
    }
}

- (void)presentBirthdayViewController {
    BirthdayViewController *vc = [[BirthdayViewController alloc] initWithTabBar:self.tabBarController];
    [vc setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self presentViewController:vc animated:NO completion:NULL];
}

- (void)checkIfShowBirthdayPopUp {
    DMUser *currentUser = [[self userRequest] currentUser];
    if (currentUser.primitiveDate_of_birth == NULL && [[self userRequest] isUserLoggedIn] == YES) {
        [self checkLastBirthdayViewControllerFiredDate];
    }
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    NSInteger obj = [NSUserDefaults.standardUserDefaults integerForKey:@"didSort"];
    if(obj == 1) {
        return YES;
    }
    return NO;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"Sorry no Venues fit your requirements";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)downloadVenues {
    [self.downloadLabel setHidden:NO];
    
    [[ self venueRequest] cachedVenues:^(NSError *error, id results) {
        [self gotVenuesCompletionBlock:error id:results final:false];
    }];
    
    [[self venueRequest] downloadVenuesWithCompletionBlock:^(NSError *error, id results) {
        [self gotVenuesCompletionBlock:error id:results final: true];
    }];
}

- (void)updateFavouritesInitially:(BOOL *)initial {
    if (initial) {
        [[self userRequest] downloadFavouriteVenuesWithCompletionBlock:^(NSError *error, id results) {
            NSMutableArray *favIds = [[NSMutableArray alloc] init];
            for(DMVenue* venue in results) {
                NSString *stringId = [NSString stringWithFormat:@"%@", [venue modelID]];
                [favIds addObject: stringId];
            }
            _favouriteIds = favIds;
            [restaurantsTableView reloadData];
        }];
    }
    _favouriteIds = [[self venueRequest] cachedFavouriteVenuesIds];
}

- (void)gotVenuesCompletionBlock:(NSError *)error id:(NSArray *) results final:(BOOL) final {
    if (error == nil) {
        [[self mapModelController] setVenues:results];
        
        [UIView transitionWithView:restaurantsTableView duration:0.35f options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void) { [restaurantsTableView reloadData];
            [self reloadMapAnnotations];
        } completion: nil];
        
        [self.downloadLabel setHidden:YES];
        if (!final) {
            [self.activityIndicator stopAnimating];
        }
    } else {
        if (final) {
            [self.downloadLabel setHidden:NO];
            [self.downloadLabel setText:@"Can't fetch restaurants, check your connection."];
        }
    }
    if (final) {
        [self.activityIndicator stopAnimating];
    }
}

- (IBAction)sortButtonPressed:(id)sender {
    [NSUserDefaults.standardUserDefaults setInteger:1 forKey:@"didSort"];
    UINavigationController *vc = (UINavigationController*)DMViewControllersProvider.instance.sortVC;
    
    if (vc.viewControllers.count > 0) {
        DMSortVenueFeedViewController *filterVC = vc.viewControllers[0];
        filterVC.delegate = self;
        filterVC.filterItems = self.filterItems;
        filterVC.mapModelController = self.mapModelController;
    }
    
    [vc setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)selectedFilterItems:(NSArray *)filterItems {
    self.filterItems = filterItems;
    _mapModelController.filters = filterItems;
    [self.mapModelController apply:filterItems];
    [restaurantsTableView reloadData];
    [self reloadMapAnnotations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// MARK: - Table View Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self mapModelController] filteredVenues] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DMRestaurantCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RestaurantCell"];
    DMVenue *item = [[self mapModelController] filteredVenues][(unsigned long)indexPath.row];
    DMVenueImage *venueImage = (DMVenueImage *) [item primaryImage];
    NSString *category = [[[item categories] anyObject] name];
    
    [cell.restaurantPrice setHidden:(_mapModelController.state == DMVenueList)];
    [cell.restaurantType setHidden:(_mapModelController.state == DMVenueList)];
    [[cell restaurantName] setText:item.name];
    [[cell restaurantType] setText:[NSString stringWithFormat:@"%@", category]];
    [[cell restaurantCategory] setText:[NSString stringWithFormat:@"%@", [[item friendlyPlaceName] uppercaseString]]];
    [[cell restaurantPrice] setText:[item priceBracketString]];
    [[cell restaurantImageView] setAlpha:1.0];

    if ([item.state integerValue] == DMVenueStateVerfiedDemo)
    {
        [[cell restaurantCategory] setText:@"Coming Soon to DinerMojo"];
        [[cell restaurantImageView] setAlpha:0.6];

    }
    
    cell.index = indexPath;
    cell.delegate = self;

    [cell setEarnVisibility:item.allows_earnsValue];
    [cell setRedeemVisibility:item.allows_redemptionsValue];

    NSNumber *latitude = item.latitude;
    NSNumber *longitude = item.longitude;
    CLLocation *venueCoordinates = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    
    double distance = [[DMLocationServices sharedInstance] userLocationDistanceFromLocation:venueCoordinates];
    if(distance != 0) {
        MKDistanceFormatter *df = [MKDistanceFormatter new];
        [df setUnitStyle:MKDistanceFormatterUnitStyleFull];
        
        NSString *friendlyDistance = [df stringFromDistance:distance];
        [[cell restaurantDistance] setText:[NSString stringWithFormat:@"(%@)",friendlyDistance]];
    } else {
        [[cell restaurantDistance] setText:@""];
    }
    NSString *urlString = [venueImage fullThumbURL];
    if(urlString == NULL) {
        urlString = [venueImage fullURL];
    }
    cell.restaurantImageView.image = nil;
    [[cell restaurantImageView] sd_setImageWithURL:[NSURL URLWithString:urlString]
                 placeholderImage:nil];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 166;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DMVenue *item = [[self mapModelController] filteredVenues][(unsigned long)indexPath.row];
    if ([item.state integerValue] == DMVenueStateVerified)
    {
        [self performSegueWithIdentifier:@"restaurantInfoSegue" sender:item];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"restaurantInfoSegue"])
    {
       [(DMRestaurantInfoViewController *)[segue destinationViewController] setSelectedVenue:sender];
    }
}

- (void)didSelectTabItem:(DMVenueListState)item {
    _mapModelController.state = item;
    _mapModelController.filterLifestyle = (item == DMVenueList);
    [restaurantsTableView reloadData];
    [restaurantsTableView setHidden:(item == DMVenueMap)];
    [mapView setHidden:(item == DMVenueList)];
    [collectionView setHidden:(item == DMVenueList)];
    [self reloadMapAnnotations];
}

// MARK: - Restaurant cell delegate

- (void)didSelectRedeem:(NSIndexPath *)index {
    DMVenue *item = [[self mapModelController] filteredVenues][(unsigned long)index.row];
    if([item.allows_earns isEqualToNumber:@YES]) {
        [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusSuccess title:@"Earn points here!" description:NSLocalizedString(@"earn.message.available", nil) style:UIBlurEffectStyleExtraLight actionButtonTitle:nil color:[UIColor colorWithRed:(245/255.f) green:(147/255.f) blue:(54/255.f) alpha:1]];
    }
    else {
        NSString *cannotEarn = [[NSString alloc] initWithFormat:@"You can't earn points at %@ but you can reedem them here and earn them anywhere you see this symbol ", item.name];
        NSMutableAttributedString *cannotEarn2 = [[NSMutableAttributedString alloc] initWithString:cannotEarn];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageNamed:@"earn_icon_enabled"];
        textAttachment.bounds = CGRectMake(0, 0, 20, 20);
        
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [cannotEarn2 appendAttributedString:attrStringWithImage];
        
        [self presentOperationCompleteViewControllerWithStatusAttributed:DMOperationCompletePopUpViewControllerStatusError title:@"Earn" description:cannotEarn2 style:UIBlurEffectStyleExtraLight actionButtonTitle:nil color:[UIColor colorWithRed:(245/255.f) green:(147/255.f) blue:(54/255.f) alpha:1]];
    }
}

- (void)didSelectEarn:(NSIndexPath *)index {
    DMVenue *item = [[self mapModelController] filteredVenues][(unsigned long)index.row];
    if([item.allows_redemptions isEqualToNumber:@YES]) {
        [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusSuccess title:@"Reedem points here!" description:NSLocalizedString(@"redeem.message.available", nil) style:UIBlurEffectStyleExtraLight actionButtonTitle:nil color:[UIColor colorWithRed:(245/255.f) green:(147/255.f) blue:(54/255.f) alpha:1]];
    }
    else {
        DMVenue *selected = [[self mapModelController] venues][(unsigned long)index.row];
        NSString *cannotReedem = [[NSString alloc] initWithFormat:@"You can't redeem points at %@ but you can earn them here and reedem them anywhere you see this symbol ", selected.name];
        NSMutableAttributedString *cannotRedeem2 = [[NSMutableAttributedString alloc] initWithString:cannotReedem];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageNamed:@"redeem_icon_enabled"];
        textAttachment.bounds = CGRectMake(0, 0, 20, 20);
        
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [cannotRedeem2 appendAttributedString:attrStringWithImage];
        
        [self presentOperationCompleteViewControllerWithStatusAttributed:DMOperationCompletePopUpViewControllerStatusError title:@"Reedem" description:cannotRedeem2 style:UIBlurEffectStyleExtraLight actionButtonTitle:nil color:[UIColor colorWithRed:(245/255.f) green:(147/255.f) blue:(54/255.f) alpha:1]];
    }
}

@end
