//
//  DMRestaurantInfoViewController.m
//  DinerMojo
//
//  Created by Carl Sanders on 06/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMRestaurantInfoViewController.h"
#import "DMEarnReviewViewController.h"
#import <RDHCollectionViewGridLayout/RDHCollectionViewGridLayout.h>
#import "DMRestaurantInfoRelatedCell.h"
#import "DMRestaurantInfoImageCarouselViewController.h"
#import "DMWebViewController.h"
#import "DMVenueImage.h"
#import "DMVenueOpeningTimes.h"
#import "DMNewsItemViewController.h"
#import "DMVenueModelController.h"
#import "DMLocationServices.h"
#import "DMRedeemViewController.h"
#import "DMNewsFeedViewController.h"
#import "DMRequest.h"
#import "DMNewsRequest.h"
#import "DMNewsItemModelController.h"
#import "DMVenue.h"
#import "DinerMojoConstants.h"
#import <PureLayout/PureLayout.h>
#import "DinerMojo-Swift.h"
#import <Crashlytics/Answers.h>
#import "RestaurantInfoButtonEnum.h"
#import "DMPopUpRequest.h"
#import <SDWebImage/SDWebImage.h>

@interface DMRestaurantInfoViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIActivityItemSource, BookingViewControllerDelegate>

@property DMNewsItem *selectedOffer;
@property (weak, nonatomic) IBOutlet UIImageView *arrowDropdown;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *openingTimesConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeightConstraint;
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *buttons;
@property (nonatomic, retain) IBOutletCollection(UIImageView) NSArray *imgViews;
@property (weak, nonatomic) IBOutlet UIImageView *bookImgView;
#pragma mark - Additional RestaurantInfo Actions

- (IBAction)callRestaurant:(id)sender;
- (IBAction)restaurantWebsite:(id)sender;
- (IBAction)restaurantMenu:(id)sender;
- (IBAction)restaurantNews:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *earnIcon;
@property (weak, nonatomic) IBOutlet UIView *openingTimesView;
@property (weak, nonatomic) IBOutlet UIImageView *redeemIcon;
@end

@implementation DMRestaurantInfoViewController {
}
-(void)showVenueNews:(id)sender {}
- (IBAction)callRestaurant:(id)sender {
    [self callRestaurant];
}

- (IBAction)restaurantMenu:(id)sender {
    [self restaurantMenu];
}

- (IBAction)restaurantWebsite:(id)sender {
    [self restaurantWebsite];
}
- (IBAction)openBooking:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    
    if([[self userRequest] currentUser] == nil) {
        [self presentAlertForLogin];
        return;
    }
    if(!self.selectedVenue.booking_availableValue) {
        [self bookingNotAvailableAlert];
        return;
    }
    
    [self updateBookingTrackerInBackend];
    
    if(![self.selectedVenue.booking_url isEqualToString:@""] && self.selectedVenue.booking_url != nil) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DMWebViewController *webView = (DMWebViewController*)[storyboard instantiateViewControllerWithIdentifier:@"webView"];
        [webView setWebURL:self.selectedVenue.booking_url];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:webView];
        [navController setModalPresentationStyle:UIModalPresentationOverFullScreen];
        [self presentViewController:navController animated:YES completion:nil];
    } else {
        BookingViewController *vc = [[BookingViewController alloc] initWithNibName:@"BookingViewController" bundle:NULL];
        vc.delegate = self;
        [vc setVenue:self.selectedVenue];
        [self.navigationController showViewController:vc sender:self];
    }
}

- (void)updateBookingTrackerInBackend {
    NSNumber *venueId = [self.selectedVenue primitiveModelID];
    
    DMVenueRequest *request = [DMVenueRequest new];
    [request updateBookingTracker:venueId completion:^(NSError *error, id results) {}];
}

- (void)bookingNotAvailableAlert {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"This venue does not allow online booking. Please call for reservations" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
     }];
    
    [alert addAction:ok];
    
    [alert setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", self.selectedVenue.primitiveModelID);
    [self configureControls];
    [self decorateInterface];

    [self.favoriteButton setHidden:YES];
    
    if(!self.selectedVenue.allows_earnsValue) {
        [[self earnButton] setBackgroundColor:[UIColor grayColor]];
    }
    if(!self.selectedVenue.allows_redemptionsValue) {
        [[self redeemButton] setBackgroundColor:[UIColor grayColor]];
    }
    
    if(self.selectedVenue.primaryImage.fullURL == NULL) {
        [self.shareButton setImage:[[UIImage alloc] init]];
    }
    [self addClearShadowToView:self.gradientView];
    [self addShadowToView:self.infoShadowView];
    [self setupButtons];
    //[self setUpNavigationButton];
    if([self.selectedVenue.venue_type isEqualToString:RESTAURANT_TYPE]) {
        [Answers logContentViewWithName:@"View restaurant info" contentType:[NSString stringWithFormat:@"View restaurant info - %@", self.selectedVenue.name] contentId:[NSString stringWithFormat:@"%@", self.selectedVenue.name] customAttributes:@{}];
    } else {
        [Answers logContentViewWithName:@"View lifestyle info" contentType:[NSString stringWithFormat:@"View lifestyle info - %@", self.selectedVenue.name] contentId:[NSString stringWithFormat:@"%@", self.selectedVenue.name] customAttributes:@{}];
    }
    
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)addGradient:(UIView *)view {
    [view setBackgroundColor:[UIColor clearColor]];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.startPoint = CGPointMake(0.5f, 0.0f);
    gradient.endPoint = CGPointMake(0.5f, 1.0f);
    gradient.frame = view.bounds;
    gradient.colors = @[(id)[[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor, (id)[[UIColor whiteColor] colorWithAlphaComponent:0.0].CGColor];
    
    [view.layer insertSublayer:gradient atIndex:0];
}

-(void)addClearShadowToView:(UIView *)view {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.startPoint = CGPointMake(0.5f, 1.0f);
    gradient.endPoint = CGPointMake(0.5f, 0.0f);
    gradient.frame = CGRectMake(0, -40, view.frame.size.width, 40);
    gradient.colors = @[(id)[[UIColor whiteColor] colorWithAlphaComponent:1.0f].CGColor, (id)[[UIColor whiteColor] colorWithAlphaComponent:0.0].CGColor];
    
    [view.layer insertSublayer:gradient atIndex:0];
}

-(void)addShadowToView:(UIView *)view {
    view.layer.shadowRadius  = 3.0f;
    view.layer.shadowColor   = [UIColor lightGrayColor].CGColor;
    view.layer.shadowOffset  = CGSizeMake(0.0f, -2.0f);
    view.layer.shadowOpacity = 0.5f;
    view.layer.masksToBounds = NO;
}

- (void)configureControls
{
    RDHCollectionViewGridLayout *layout = (RDHCollectionViewGridLayout *)[[self collectionView] collectionViewLayout];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    layout.itemSpacing = 0;
    layout.lineSpacing = 0;
    layout.lineSize = 120;
    layout.lineItemCount = 1;
    if (@available(iOS 13.0, *)) {
        self.scrollView.automaticallyAdjustsScrollIndicatorInsets = NO;
    }
    [self venueApiDetails];
    [self.scrollView setDelegate:self];
 

    //Mapview
    MKCoordinateSpan span = MKCoordinateSpanMake(0.005f, 0.005f);
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.selectedVenue.latitudeValue,self.selectedVenue.longitudeValue);
    MKCoordinateRegion region = {coordinate, span};
    MKCoordinateRegion regionThatFits = [self.mapView regionThatFits:region];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coordinate];
    [self.mapView addAnnotation:annotation];
    [self.mapView setRegion:regionThatFits animated:YES];
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(self.selectedVenue.latitudeValue, self.selectedVenue.longitudeValue);    
    self.selectedVenue.user_last_viewed = [NSDate date];
    
    DMRequest *request = [DMRequest new];
    [request saveInContext:[request objectContext]];
    [self refreshVenue];
    [self downloadVenueNews];

}

- (void)decorateInterface
{
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, 0, self.view.frame.size.width, 120);
    layer.colors = [NSArray arrayWithObjects:
                    (id)[[[UIColor blackColor] colorWithAlphaComponent:0.9f] CGColor],
                    (id)[[[UIColor blackColor] colorWithAlphaComponent:0.6f] CGColor],
                    (id)[[[UIColor blackColor] colorWithAlphaComponent:0.4f] CGColor],
                    (id)[[UIColor clearColor] CGColor],
                    nil];
    [self.view.layer insertSublayer:layer above:self.view.layer];
    self.view.layer.masksToBounds = NO;
    [self.directionsButton setBackgroundColor:[[UIColor brandColor] colorWithAlphaComponent:0.7f]];

}

- (void)reloadUser
{
    self.currentUser = [[self userRequest] currentUser];
    if (self.currentUser == nil)
    {
        [self.pointsValueButton setTitle:@"- -" forState:UIControlStateNormal];
        [self.featureLabel setHidden:NO];
    }
    else
    {
        [self.pointsValueButton setTitle:[NSString stringWithFormat:@"%@", self.currentUser.annual_points_balance] forState:UIControlStateNormal];
        
        [[self userRequest] recommendedVenue:self.selectedVenue withComplectionBlock:^(NSError *error, id results) {
            if (error) {
            }
            else {
                NSMutableArray *venues = [[NSMutableArray alloc] init];
                for(NSDictionary *dictionary in results) {
                    NSNumber *idNumber = [dictionary objectForKey:@"id"];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"modelID = %@ AND venue_type = \"restaurant\"", idNumber];
                    DMVenue *venue = [DMVenue MR_findFirstWithPredicate:predicate sortedBy:NULL ascending:TRUE];
                    if (venue != NULL) {
                        [venues addObject:venue];
                    }
                }
                
                self.recommendedVenuesArray = venues;
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    if (self.recommendedVenuesArray.count == 0) {
                        [[self featureLabel] setText:@"Watch this space as exciting new venues join the club for you to discover or revisit."];
                        [self.featureLabel setHidden:NO];
                        self.collectionHeightConstraint.constant = 0;
                        [self.collectionView setHidden:YES];
                    } else {
                        self.collectionHeightConstraint.constant = 155;
                        [self.collectionView setHidden:NO];
                    }
                });
                [self.collectionView reloadData];
            }
        }];
    }
}

- (void)downloadVenueNews
{
    DMNewsRequest *newsRequest = [DMNewsRequest new];
    
    [newsRequest downloadVenueNewsWithCompletionBlock:^(NSError *error, id results) {
        [self updateSpecialOfferWithArray:results];
        
    } withNewsType:[NSNumber numberWithInt:DMNewsFeedNews] withVenue:self.selectedVenue.modelID];
}

- (NSString *)verifiedTimeString:(NSString *)time
{
    return ([time isEqualToString:@""] || time == nil) ? @"closed" : time;
}

- (void)refreshVenue
{
    if([self.selectedVenue.venue_type isEqualToString:NON_RESTAURANT_TYPE]) {
        [self.restaurantBudgetLabel setText:@"Lifestyle"];
    } else {
        NSString *about = [[NSString alloc] initWithFormat:@"%@ %@", [[[self.selectedVenue categories] anyObject] name], [self.selectedVenue priceBracketString]];
        [self.restaurantBudgetLabel setText:about];
    }
    /*DMVenueOpeningTimes *openingTimes = (DMVenueOpeningTimes *) self.selectedVenue.opening_times;
    [self.mondayLabel setText:[self verifiedTimeString:openingTimes.monday]];
    [self.tuesdayLabel setText:[self verifiedTimeString:openingTimes.tuesday]];
    [self.wednesdayLabel setText:[self verifiedTimeString:openingTimes.wednesday]];
    [self.thursdayLabel setText:[self verifiedTimeString:openingTimes.thursday]];
    [self.fridayLabel setText:[self verifiedTimeString:openingTimes.friday]];
    [self.saturdayLabel setText:[self verifiedTimeString:openingTimes.saturday]];
    [self.sundayLabel setText:[self verifiedTimeString:openingTimes.sunday]];
    
    if (self.selectedVenue.trip_advisor_link.length == 0)
    {
        [self.tripAdvisorButton setHidden:YES];
        [self.tripAdvisorArrow setHidden:YES];
        [self.tripAdvisorImage setHidden:YES];
        self.collectionViewTop.priority = 1000;
    }*/
    
    [[self userRequest] downloadUserProfileWithCompletionBlock:^(NSError *error, id results) {
        [self reloadUser];
    }];
    
    NSNumber *latitude = self.selectedVenue.latitude;
    NSNumber *longitude = self.selectedVenue.longitude;
    CLLocation *venueCoordinates = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    
    double distance = [[DMLocationServices sharedInstance] userLocationDistanceFromLocation:venueCoordinates];
    if(distance == 0) {
        [[self restaurantLocationLabel] setText:@"- feet"];
    } else {
        MKDistanceFormatter *df = [MKDistanceFormatter new];
        [df setUnitStyle:MKDistanceFormatterUnitStyleFull];
    
        NSString *friendlyDistance = [df stringFromDistance:distance];
    
        // TODO: Once we have user location, calculate distance based on the longitude and latitude
        [[self restaurantLocationLabel] setText:[NSString stringWithFormat:@"%@",friendlyDistance]];
    }
    if ([[[[[self userRequest] currentUser] favourite_venues] allObjects] containsObject:self.selectedVenue])
    {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favourite_active"] forState:UIControlStateNormal];
    }
    
    else
    {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favourite_inactive"] forState:UIControlStateNormal];
    }
    
    if(self.selectedVenue.allows_earnsValue) {
        self.earnIcon.image = [UIImage imageNamed:@"earn_icon_enabled"];
    }
    else {
        self.earnIcon.image = [UIImage imageNamed:@"earn_icon_disabled"];
    }
    
    if(self.selectedVenue.allows_redemptionsValue) {
        self.redeemIcon.image = [UIImage imageNamed:@"redeem_icon_enabled"];
    }
    else {
        self.redeemIcon.image = [UIImage imageNamed:@"redeem_icon_disabled"];
    }
    
    self.bookImgView.image = [UIImage imageNamed:self.selectedVenue.booking_availableValue ? @"book" : @"callendar_grey"];
}

-(void)setupButtons {
    int i = 0;
    [self.arrowDropdown setImage: [self.arrowDropdown.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.arrowDropdown setTintColor:[UIColor brandColor]];
    for(UIButton *btn in self.buttons) {
        btn.titleLabel.numberOfLines = 0;
        if(i != 1) {
            btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        } else {
            btn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
//            btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//            btn.titleLabel.numberOfLines = 1;
        }
        
        [btn.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [btn.titleLabel setMinimumScaleFactor:0];
        [self setupButton:i];
        i++;
    }
}
    
-(UITapGestureRecognizer*)recognizerFor:(RestaurantInfoButtonEnum)type {
    switch (type) {
        case kPhoneNumber:
            return [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callRestaurant:)];
        case kWebSite:
            return [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(restaurantWebsite)];
        case kOpeningHours:
            return [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpeningTimes)];
        case kMenu:
            return [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(restaurantMenu)];
        case kNews:
            return [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(restaurantNews:)];
        break;
        case kTripAdvisor:
            return [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openTripadvisor:)];
        case kEmptyButton:
            return [[UITapGestureRecognizer alloc] init];
    }
}

-(void)setUpNavigationButton {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage* image = [[UIImage imageNamed:@"icon_navigation"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        //[image setTintColor: UIColor.brandColor];
        [self.navButton setImage:image forState:UIControlStateNormal];
        [self.navButton setTintColor:UIColor.brandColor];
    });
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];UIImage *image = [[UIImage imageNamed:@"icon_navigation"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];[button setImage:image forState:UIControlStateNormal]; button.tintColor = [UIColor redColor];
//    self.navButton = button;
}
    
-(void)setupButton:(int)index {
    RestaurantInfoButtonEnum type = [RestaurantInfoButtonType typeFor:index withVenue:self.selectedVenue];
    UIButton* button = self.buttons[index];
    NSString* title = [RestaurantInfoButtonType titleFor:type withVenue:self.selectedVenue];
    NSString* imageName = [RestaurantInfoButtonType imageNameFor:type];
    UIImage* image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView* imageView = self.imgViews[index];
    BOOL isActive = [RestaurantInfoButtonType isActiveWith:self.selectedVenue forType:type];
    UIColor* color = isActive ? UIColor.brandColor : UIColor.grayColor;
    UITapGestureRecognizer* recognizer = [self recognizerFor:type];
    BOOL isAlwaysActive = [RestaurantInfoButtonType isButtonAlwaysActiveFor:type];
    [button setTitle:title forState:UIControlStateNormal];
    [imageView setImage:image];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setUserInteractionEnabled:isAlwaysActive || isActive];
    [imageView setUserInteractionEnabled:isAlwaysActive || isActive];
    [imageView setTintColor:color];
    [imageView addGestureRecognizer:recognizer];
}

-(NSString *)dayFor:(int)day {
    NSString *hours = [[NSString alloc] init];
    switch (day) {
        case 0:
            hours = @"Mon";
            break;
        case 1:
            hours = @"Tue";
            break;
        case 2:
            hours = @"Wed";
            break;
        case 3:
            hours = @"Thu";
            break;
        case 4:
            hours = @"Fri";
            break;
        case 5:
            hours = @"Sat";
            break;
        case 6:
            hours = @"Sun";
            break;
            
        default:
            break;
    }
    return hours;
}

-(IBAction)toggleOpeningTimes {
    BOOL isOpened = self.openingTimesConstraint.priority != 999;
    if(isOpened) {
        for(UIView *subview in self.openingTimesView.subviews) {
            [subview removeFromSuperview];
        }
        [self.openingTimesConstraint setPriority:999];
        [self.openingTimesView.superview layoutIfNeeded];
        [self.openingTimesView.superview layoutSubviews];
        [self.openingTimesView setHidden:YES];
        [self.view layoutIfNeeded];
    } else {
        [self.openingTimesConstraint setPriority:250];
        [self.openingTimesView setHidden:NO];
        DMVenueOpeningTimes *openingTimes = (DMVenueOpeningTimes *) self.selectedVenue.opening_times;
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
        NSInteger weekday = [comps weekday];
        
        UIView *lastLabel = nil;
        for(int i = 0; i<6; i++) {
            int j = (int)weekday + i - 1;
            if(j == -1) j = 0;
            if(j > 6) j -= 7;
            NSString *opening = [RestaurantInfoButtonType openingHoursForDay:j openingTimes:openingTimes];
            NSString *day = [self dayFor:j];
            UILabel *lbl = [[UILabel alloc] init];
            [lbl setAdjustsFontSizeToFitWidth:YES];
            [lbl setMinimumScaleFactor:0];
            [lbl setFont:[UIFont fontWithName:@"OpenSans" size:11]];
            [lbl setNumberOfLines:2];
            [lbl setAutoresizingMask:UIViewAutoresizingNone];
            if([opening isEqualToString:@""]) {
                opening = @"closed";
            }
            [lbl setText:[[NSString alloc] initWithFormat:@"%@:\n%@", day, opening]];
            [self.openingTimesView addSubview:lbl];
            if(lastLabel == nil) {
           
                [lbl autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.openingTimesView];
            } else {
                
                [lbl autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lastLabel];
            }
            lastLabel = lbl;
            
            [lbl autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.openingTimesView];
            [lbl autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.openingTimesView];
            
        }
        
        if(self.openingTimesView.subviews.count > 0) {
            [lastLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.openingTimesView];
        }
        [self.openingTimesView layoutIfNeeded];
        [self.openingTimesView layoutSubviews];
        [self.view layoutIfNeeded];
    }
}

- (void)tabBarSelectedWithPosition:(NSInteger)position {
    switch (position) {
        case 0:
            [self callRestaurant];
        break;
            
        case 1:
            [self restaurantWebsite];
        break;
            
        case 2:
            if([self.selectedVenue.venue_type isEqualToString:NON_RESTAURANT_TYPE]) {
                if(self.selectedVenue.has_offersValue || self.selectedVenue.has_newsValue) {
                    [self showVenueNews];
                }
            }
            else {
                [self restaurantMenu];
            }
        break;
            
        case 3:
            if(self.selectedVenue.has_newsValue || self.selectedVenue.has_offersValue) {
                [self showVenueNews];
            }
        break;
        default:
        break;
    }
}

-(void)viewDidLayoutSubviews
{
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.collectionView.frame.origin.y + self.collectionView.frame.size.height + self.openingTimesView.frame.size.height);
    self.scrollView.frame = CGRectMake(0, -1, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    if(@available(iOS 11, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.scrollView.contentInset = UIEdgeInsetsZero;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setHidesBottomBarWhenPushed:NO];
    [[[self tabBarController] tabBar] setHidden:NO];
    [self refreshVenue];
    
    //Set navigation bar transparent
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar.topItem setTitle:self.selectedVenue.name];
    [self.navigationController.navigationBar setTitleTextAttributes: @{
                                                                       NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:19.0f],
                                                                       NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                       }];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes: @{
                                                                       NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:17.0f],
                                                                       NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                       }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"restaurantImageInfo"])
    {
        DMRestaurantInfoImageCarouselViewController *vc = [segue destinationViewController];
        [vc setVenueInfo:self.selectedVenue];
    }
    
    if ([segue.identifier isEqualToString:@"ShowOffer"])
    {
        DMNewsItemViewController *vc = [segue destinationViewController];
        [vc setIsOffer:YES];
        [vc setSelectedItem:self.selectedOffer];
    }
    
    if ([segue.identifier isEqualToString:@"ShowNewsInfo"])
    {
        DMNewsFeedViewController *vc = [segue destinationViewController];
        [vc setSelectedVenue:self.selectedVenue];
        [vc setIsVenue:YES];
    }
    
    if ([segue.identifier isEqualToString:@"ShowEarnVenue"])
    {
        DMDineNavigationController *vc = segue.destinationViewController;
        [vc setDineNavigationDelegate:self];
        DMEarnReviewViewController *earnViewController = (DMEarnReviewViewController *)[[vc viewControllers] objectAtIndex:0];
        earnViewController.selectedVenueID = self.selectedVenue.modelID;
    }
    
    if ([segue.identifier isEqualToString:@"ShowRedeemVenue"])
    {
        DMDineNavigationController *vc = segue.destinationViewController;
        [vc setDineNavigationDelegate:self];
        DMRedeemViewController *redeemViewController = (DMRedeemViewController *)[[vc viewControllers] objectAtIndex:0];
        [redeemViewController setStandardRedeem:YES];
        redeemViewController.selectedVenue = self.selectedVenue;
    }
    
}

-(void)venueApiDetails
{
    [[self restaurantDescriptionLabel]setText:self.selectedVenue.venue_description];
    [[self restaurantAddressLabel]setText:[self.selectedVenue friendlyFullString]];
    [[self restautrantTitleName]setTitle:self.selectedVenue.name];
}

-(void)updateSpecialOfferWithArray:(NSArray *) offers
{
    self.selectedOffer = [offers firstObject];
    BOOL isRestaurant = [self.selectedVenue.venue_type isEqualToString:@"restaurant"];
    BOOL hasNews = (offers.count != 0);
    self.selectedVenue.has_newsValue = hasNews;
    self.selectedVenue.has_offersValue = hasNews;
    [self setupButton:(isRestaurant ? 4 : 3)];
    
    if (self.selectedOffer)
    {
        [[self restaurantSpecialOfferDetailLabel] setText:self.selectedOffer.news_description];
    }
    
    else
    {
        [[self restaurantSpecialOfferDetailLabel] setText:@"There are no special offers at this time"];
        self.restaurantSpecialOfferHeightPaddingConstraint.constant = 0;
        self.restaurantSpecialOfferHeightConstraint.constant = 0;
        [self.view layoutIfNeeded];
        
    }
}


#pragma mark - RestaurantInfo Actions

- (IBAction)share:(id)sender
{
    NSString *type = @"restaurant";
    if([self.selectedVenue.venue_type isEqualToString:NON_RESTAURANT_TYPE]) {
        type = @"lifestyle";
    }
    [Answers logShareWithMethod:[NSString stringWithFormat:@"Share %@ venue", type] contentName:[NSString stringWithFormat:@"Share %@ - %@", type, self.selectedVenue.name] contentType:@"" contentId:@"" customAttributes:@{}];
    NSString *text = [[NSString alloc] initWithFormat:@"I love this place - %@, %@! With DinerMojo, I get rewarded there when using my points earned by spending at DinerMojo’s great restaurants. Download the free app and give it a try. \nhttp://bit.ly/DownloadFromGooglePlay\nhttp://bit.ly/DownloadFromTheAppStore", self.selectedVenue.name, self.selectedVenue.town];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.selectedVenue.primaryImage.fullURL]]];
    if(image == NULL) {
        image = [[UIImage alloc] init];
    }
    
    DMActivityViewController *activityViewController = [[DMActivityViewController alloc] initWithActivityItems:@[text, image] applicationActivities:nil];
    [activityViewController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}


- (IBAction)redeemRestaurant:(id)sender {
    
    if ([[self userRequest] currentUser] == nil)
    {
        [self presentAlertForLoginInstructions:@"You need to log in or sign up to access this feature."];
    }
    else if(!self.selectedVenue.allows_redemptionsValue) {
        NSString *cannotReedem = [[NSString alloc] initWithFormat:@"You can't redeem points at %@ but you can earn them here and reedem them anywhere you see this symbol ", self.selectedVenue.name];
        NSMutableAttributedString *cannotRedeem2 = [[NSMutableAttributedString alloc] initWithString:cannotReedem];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageNamed:@"redeem_icon_enabled"];
        textAttachment.bounds = CGRectMake(0, 0, 20, 20);
        
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [cannotRedeem2 appendAttributedString:attrStringWithImage];
        
        [self presentOperationCompleteViewControllerWithStatusAttributed:DMOperationCompletePopUpViewControllerStatusError
                                                                   title:@"Reedem" description:cannotRedeem2
                                                                   style:UIBlurEffectStyleExtraLight
                                                       actionButtonTitle:nil
                                                                   color:[UIColor colorWithRed:(245/255.f)
                                                                                         green:(147/255.f)
                                                                                          blue:(54/255.f)
                                                                                         alpha:1]];
    }
    else
    {
        if ([[[[self userRequest] currentUser] is_email_verified] boolValue] == YES)
        {
            [self performSegueWithIdentifier:@"ShowRedeemVenue" sender:nil];
        }
        else
        {
            [self presentEmailVerificationCheckViewControllerWithCompletionBlock:^(NSError *error, id results) {
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([[[[self userRequest] currentUser] is_email_verified] boolValue] == YES)
                    {
                        [self performSegueWithIdentifier:@"ShowRedeemVenue" sender:nil];
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
    if (self.currentUser == nil)
    {
        [self presentAlertForLoginInstructions:@"You need to log in or sign up to access this feature."];
    }
    else if(!self.selectedVenue.allows_earnsValue) {
        NSString *cannotEarn = [[NSString alloc] initWithFormat:@"You can't earn points at %@ but you can reedem them here and earn them anywhere you see this symbol ", self.selectedVenue.name];
        NSMutableAttributedString *cannotEarn2 = [[NSMutableAttributedString alloc] initWithString:cannotEarn];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageNamed:@"earn_icon_enabled"];
        textAttachment.bounds = CGRectMake(0, 0, 20, 20);
        
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [cannotEarn2 appendAttributedString:attrStringWithImage];
        
        [self presentOperationCompleteViewControllerWithStatusAttributed:DMOperationCompletePopUpViewControllerStatusError title:@"Earn" description:cannotEarn2 style:UIBlurEffectStyleExtraLight actionButtonTitle:nil color:[UIColor colorWithRed:(245/255.f) green:(147/255.f) blue:(54/255.f) alpha:1]];
    }
    else
    {
        if ([[[[self userRequest] currentUser] is_email_verified] boolValue] == YES)
        {
            [self performSegueWithIdentifier:@"ShowEarnVenue" sender:nil];
        }
        else
        {
            [self presentEmailVerificationCheckViewControllerWithCompletionBlock:^(NSError *error, id results) {
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([[[[self userRequest] currentUser] is_email_verified] boolValue] == YES)
                    {
                        [self performSegueWithIdentifier:@"ShowEarnVenue" sender:nil];
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

-(void) sendPopUpRequest {
    int venueId = [self.selectedVenue.primitiveModelID intValue];
    CLLocation *location = DMLocationServices.sharedInstance.currentLocation;
    DMPopUpRequest *request = [[DMPopUpRequest alloc]
        initWithLatitude:location.coordinate.latitude
        longitude:location.coordinate.longitude
        andVenue:venueId];
    [request downloadPopupWithCompletionBlock:^(NSError *error, id results) {
        NSLog(@"tedasdasd");
    }];
}


- (void)presentAlertForLogin
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Login Required" message:@"You need to log in or sign up to access this feature." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancel];
    
    [alertController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)presentAlertForLoginInstructions:(NSString *)instructions
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Login Required" message:instructions preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *login = [UIAlertAction actionWithTitle:@"Login / Sign up" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *destinationViewController = [storyboard instantiateViewControllerWithIdentifier:@"landingNavigationController"];
        [self setRootViewController:destinationViewController animated:YES];
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:login];
    
    [alertController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)favoriteVenue:(id)sender
{
    if ([[self userRequest] currentUser] != nil)
    {
        if ([[[[[self userRequest] currentUser] favourite_venues] allObjects] containsObject:self.selectedVenue])
        {
            
            NSMutableArray *venue_ids = [NSMutableArray new];
            [venue_ids addObject:self.selectedVenue.modelID];
            
            [[self userRequest] deleteVenues:venue_ids withCompletionBlock:^(NSError *error, id results) {
                if (error)
                {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops, can't remove favourite" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    
                    [alertController addAction:ok];
                    
                    [alertController setModalPresentationStyle:UIModalPresentationOverFullScreen];
                    [self presentViewController:alertController animated:YES completion:nil];            }
                
                else
                {
                    [self.favoriteButton setImage:[UIImage imageNamed:@"favourite_inactive"] forState:UIControlStateNormal];
                }
                
            }];
        }
        
        else
        {
            [[self userRequest] addVenue:self.selectedVenue withCompletionBlock:^(NSError *error, id results)
             {
                 if (error)
                 {
                     
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops, can't add favourite" message:nil preferredStyle:UIAlertControllerStyleAlert];
                     
                     UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                     
                     [alertController addAction:ok];
                     
                     [alertController setModalPresentationStyle:UIModalPresentationOverFullScreen];
                     [self presentViewController:alertController animated:YES completion:nil];
                 }
                 
                 else
                 {
                     [self.favoriteButton setImage:[UIImage imageNamed:@"favourite_active"] forState:UIControlStateNormal];
                 }
                 
                 
             }];
            
        }
    } else
    {
        [self presentAlertForLoginInstructions:@"To use this feature you need an account"];
    }
}

- (void)callRestaurant {
    NSString *phoneString = [self.selectedVenue friendlyPhoneNumber];
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phoneString]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl])
    {
        [[UIApplication sharedApplication] openURL:phoneUrl options:@{} completionHandler:^(BOOL success) {
            NSLog(@"Opened Url: %i", success);
        }];

    }
    else
    {
        UIAlertView *phoneAlert = [[UIAlertView alloc]initWithTitle:@"Phone Calls" message:@"Calls are not available on this device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [phoneAlert show];
    }

}

- (void)restaurantWebsite {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DMWebViewController *webView = (DMWebViewController*)[storyboard instantiateViewControllerWithIdentifier:@"webView"];
    [webView setWebURL:self.selectedVenue.web_address];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:webView];
    [navController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)restaurantMenu {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DMWebViewController *webView = (DMWebViewController*)[storyboard instantiateViewControllerWithIdentifier:@"webView"];
    [webView setWebURL:self.selectedVenue.menu_url];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:webView];
    [navController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self presentViewController:navController animated:YES completion:nil];
    
}

- (IBAction)restaurantNews:(id)sender
{
    [self showVenueNews];
}

- (IBAction)openTripadvisor:(id)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DMWebViewController *webView = (DMWebViewController*)[storyboard instantiateViewControllerWithIdentifier:@"webView"];
    [webView setWebURL:self.selectedVenue.trip_advisor_link];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:webView];
    [navController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)openMaps:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.selectedVenue.latitudeValue, self.selectedVenue.longitudeValue);
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                   addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem setName:self.selectedVenue.name];
    [mapItem openInMapsWithLaunchOptions:nil];
}

- (IBAction)showOffer:(id)sender
{
    if (self.selectedOffer)
    {
        [self performSegueWithIdentifier:@"ShowOffer" sender:nil];
    }
}

- (void)showVenueNews {
    [self performSegueWithIdentifier:@"ShowNewsInfo" sender:nil];
}


#pragma mark - UICollectionView


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.recommendedVenuesArray count];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DMVenue *venue = [self.recommendedVenuesArray objectAtIndex:indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    DMRestaurantInfoViewController *restaurantInfoView = (DMRestaurantInfoViewController *) [storyboard instantiateViewControllerWithIdentifier:@"DMRestaurantInfo"];
        [restaurantInfoView setSelectedVenue:venue];
        [self.navigationController pushViewController:restaurantInfoView animated:YES];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    DMRestaurantInfoRelatedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    DMVenue *venue = [self.recommendedVenuesArray objectAtIndex:indexPath.row];
    [cell.imageView setImage:nil];
    [cell.imageView setImageWithURL:[NSURL URLWithString:[venue.primaryImage fullThumbURL]]];
    [cell.venueNameLabel setText:venue.name];
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DMDineNavigationControllerDelegate

- (void)readyToDismissCompletedDineNavigationController:(DMDineNavigationController *)dineNavigationController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[self userRequest] downloadUserProfileWithCompletionBlock:^(NSError *error, id results) {
        [self reloadUser];
    }];
}

- (void)readyToDismissCompletedDineNavigationController:(DMDineNavigationController *)dineNavigationController with:(UIViewController *)vc
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[self userRequest] downloadUserProfileWithCompletionBlock:^(NSError *error, id results) {
        [self reloadUser];
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)readyToDismissCancelledDineNavigationController:(DMDineNavigationController *)dineNavigationController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[self userRequest] downloadUserProfileWithCompletionBlock:^(NSError *error, id results) {
        [self reloadUser];
    }];
}


@end
