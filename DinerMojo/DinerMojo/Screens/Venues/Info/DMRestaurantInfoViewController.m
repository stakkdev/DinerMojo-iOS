//
//  DMRestaurantInfoViewController.m
//  DinerMojo
//
//  Created by Carl Sanders on 06/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMRestaurantInfoViewController.h"
#import "DMEarnReviewViewController.h"
#import <RDHCollectionViewGridLayout.h>
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


@interface DMRestaurantInfoViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property DMNewsItem *selectedOffer;
@property (strong, nonatomic) DMVenueModelController* mapModelController;


#pragma mark - Additional RestaurantInfo Actions
- (IBAction)share:(id)sender;
- (IBAction)callRestaurant:(id)sender;
- (IBAction)restaurantWebsite:(id)sender;
- (IBAction)restaurantMenu:(id)sender;
- (IBAction)restaurantNews:(id)sender;

@end

@implementation DMRestaurantInfoViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureControls];
    [self decorateInterface];
    
}

- (void)configureControls
{
    RDHCollectionViewGridLayout *layout = (RDHCollectionViewGridLayout *)[[self collectionView] collectionViewLayout];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    layout.itemSpacing = 0;
    layout.lineSpacing = 0;
    layout.lineSize = 120;
    layout.lineItemCount = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self venueApiDetails];
    [self.scrollView setDelegate:self];
 

    //Mapview
    MKCoordinateSpan span = MKCoordinateSpanMake(0.005f, 0.005f);
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.selectedVenue.latitudeValue,self.selectedVenue.longitudeValue);
    MKCoordinateRegion region = {coordinate, span};
    MKCoordinateRegion regionThatFits = [self.mapView regionThatFits:region];
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
    layer.frame = CGRectMake(0, 0, self.view.frame.size.width, 70);
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
            else
            {
                self.recommendedVenuesArray = results;
                [self.collectionView reloadData];
                
                if (self.recommendedVenuesArray.count == 0) {
                    [[self featureLabel] setText:@"Watch this space as exciting new venues join the club for you to discover or revisit."];
                    [self.featureLabel setHidden:NO];
                }
            }
        }];
    }
}

- (void)downloadVenueNews
{
    DMNewsRequest *newsRequest = [DMNewsRequest new];
    
    [newsRequest downloadVenueNewsWithCompletionBlock:^(NSError *error, id results) {
        [self updateSpecialOfferWithArray:results];
        
    } withNewsType:[NSNumber numberWithInt:DMNewsFeedOffers] withVenue:self.selectedVenue.modelID];
}

- (NSString *)verifiedTimeString:(NSString *)time
{
    return ([time isEqualToString:@""] || time == nil) ? @"closed" : time;
}

- (void)refreshVenue
{
    [self.restaurantCuisineLabel setText:[[[self.selectedVenue categories] anyObject] name]];
    [self.restaurantBudgetLabel setText:self.selectedVenue.priceBracketString];
    DMVenueOpeningTimes *openingTimes = (DMVenueOpeningTimes *) self.selectedVenue.opening_times;
    [self.mondayLabel setText:[self verifiedTimeString:openingTimes.monday]];
    [self.tuesdayLabel setText:[self verifiedTimeString:openingTimes.tuesday]];
    [self.wednesdayLabel setText:[self verifiedTimeString:openingTimes.wednesday]];
    [self.thursdayLabel setText:[self verifiedTimeString:openingTimes.thursday]];
    [self.fridayLabel setText:[self verifiedTimeString:openingTimes.friday]];
    [self.saturdayLabel setText:[self verifiedTimeString:openingTimes.saturday]];
    [self.sundayLabel setText:[self verifiedTimeString:openingTimes.sunday]];
    
    if (self.selectedVenue.trip_advisor_link.length == 0)
    {
        self.tripAdvisorButton.enabled = NO;
    }
    
    [[self userRequest] downloadUserProfileWithCompletionBlock:^(NSError *error, id results) {
        [self reloadUser];
    }];
    
    NSNumber *latitude = self.selectedVenue.latitude;
    NSNumber *longitude = self.selectedVenue.longitude;
    CLLocation *venueCoordinates = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    
    double distance = [[DMLocationServices sharedInstance] userLocationDistanceFromLocation:venueCoordinates];
    
    MKDistanceFormatter *df = [MKDistanceFormatter new];
    [df setUnitStyle:MKDistanceFormatterUnitStyleFull];
    
    NSString *friendlyDistance = [df stringFromDistance:distance];
    
    // TODO: Once we have user location, calculate distance based on the longitude and latitude
    [[self restaurantLocationLabel] setText:[NSString stringWithFormat:@"%@",friendlyDistance]];
    
    if ([[[[[self userRequest] currentUser] favourite_venues] allObjects] containsObject:self.selectedVenue])
    {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favourite_active"] forState:UIControlStateNormal];
    }
    
    else
    {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favourite_inactive"] forState:UIControlStateNormal];

    }
}

-(void)viewDidLayoutSubviews
{
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.collectionView.frame.origin.y + self.collectionView.frame.size.height + 0);
    
    self.scrollView.frame = CGRectMake(0, -1, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
    [self refreshVenue];
    
    //Set navigation bar transparent
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
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
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/app/id1017632373"];
    NSString *text = @"Love this place! And now, with DinerMojo, I get rewarded just for eating here ";
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.selectedVenue.primaryImage.fullURL]]];;
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[text, image, url] applicationActivities:nil];

    
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}

- (IBAction)redeemRestaurant:(id)sender {
    
    if (self.currentUser == nil)
    {
        [self presentAlertForLoginInstructions:@"You need to log in or sign up to access this feature."];
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
                     
                     [self presentViewController:alertController animated:YES completion:nil];
                 }
                 
                 else
                 {
                     [self.favoriteButton setImage:[UIImage imageNamed:@"favourite_active"] forState:UIControlStateNormal];
                 }
                 
                 
             }];
            
        }

    }
    
    else
    {
        [self presentAlertForLoginInstructions:@"To use this feature you need an account"];
    }
    
    
}
-(IBAction)callRestaurant:(id)sender
{
    NSString *phoneString = [self.selectedVenue friendlyPhoneNumber];
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phoneString]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl])
    {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
    else
    {
        UIAlertView *phoneAlert = [[UIAlertView alloc]initWithTitle:@"Phone Calls" message:@"Calls are not available on this device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [phoneAlert show];
    }

}

- (IBAction)restaurantWebsite:(id)sender{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DMWebViewController *webView = (DMWebViewController*)[storyboard instantiateViewControllerWithIdentifier:@"webView"];
    [webView setWebURL:self.selectedVenue.web_address];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:webView];
    [self presentViewController:navController animated:YES completion:nil];
    
}

- (IBAction)restaurantMenu:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DMWebViewController *webView = (DMWebViewController*)[storyboard instantiateViewControllerWithIdentifier:@"webView"];
    [webView setWebURL:self.selectedVenue.menu_url];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:webView];
    [self presentViewController:navController animated:YES completion:nil];
    
}

- (IBAction)restaurantNews:(id)sender
{
    
}

- (IBAction)openTripadvisor:(id)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DMWebViewController *webView = (DMWebViewController*)[storyboard instantiateViewControllerWithIdentifier:@"webView"];
    [webView setWebURL:self.selectedVenue.trip_advisor_link];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:webView];
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

- (IBAction)showVenueNews:(id)sender
{
    [self performSegueWithIdentifier:@"ShowNewsInfo" sender:nil];
}


#pragma mark - UICollectionView


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.recommendedVenuesArray count];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary = [self.recommendedVenuesArray objectAtIndex:indexPath.row];
    NSNumber *idNumber = [dictionary objectForKey:@"id"];
    
    DMVenue *venue = [DMVenue MR_findFirstByAttribute:@"modelID" withValue:idNumber];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    DMRestaurantInfoViewController *restaurantInfoView = (DMRestaurantInfoViewController *) [storyboard instantiateViewControllerWithIdentifier:@"DMRestaurantInfo"];
    [restaurantInfoView setSelectedVenue:venue];
    [self.navigationController pushViewController:restaurantInfoView animated:YES];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    DMRestaurantInfoRelatedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *dictionary = [self.recommendedVenuesArray objectAtIndex:indexPath.row];
    NSNumber *idNumber = [dictionary objectForKey:@"id"];
    
    DMVenue *venue = [DMVenue MR_findFirstByAttribute:@"modelID" withValue:idNumber];
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

- (void)readyToDismissCancelledDineNavigationController:(DMDineNavigationController *)dineNavigationController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[self userRequest] downloadUserProfileWithCompletionBlock:^(NSError *error, id results) {
        [self reloadUser];
    }];
}


@end
