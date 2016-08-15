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


@interface DMMapViewController ()

@property (strong, nonatomic) DMVenueRequest* venueRequest;
@property (strong, nonatomic) DMVenueModelController* mapModelController;

@end

@implementation DMMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _venueRequest = [DMVenueRequest new];
    _mapModelController = [DMVenueModelController new];
    
    [restaurantsTableView registerNib:[UINib nibWithNibName:@"DMRestaurantCell" bundle:nil] forCellReuseIdentifier:@"RestaurantCell"];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.activityIndicator startAnimating];
    [self downloadVenues];

}

- (void)downloadVenues
{
    [self.downloadLabel setHidden:NO];
    
    [[self venueRequest] downloadVenuesWithCompletionBlock:^(NSError *error, id results) {
         if (error == nil)
         {
             [[self mapModelController] setVenues:results];
             
             [UIView transitionWithView:restaurantsTableView duration:0.35f options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void)
              { [restaurantsTableView reloadData]; }completion: nil];
             
             [self.downloadLabel setHidden:YES];

             
         }
         else
         {
             [self.downloadLabel setText:@"Can't fetch restaurants, check your connection."];

         }
        [self.activityIndicator stopAnimating];


     }];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self mapModelController] venues] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DMRestaurantCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RestaurantCell"];
    
    DMVenue *item = [[[self mapModelController] venues] objectAtIndex:indexPath.row];
    
    DMVenueImage *venueImage = (DMVenueImage *) [item primaryImage];
    
    NSString *category = [[[item categories] anyObject] name];
    
    [[cell restaurantName] setText:item.name];
    
    [[cell restaurantCategory] setText:[NSString stringWithFormat:@"%@ | %@", category, [item friendlyPlaceName]]];
    
    [[cell restaurantPrice] setText:[item priceBracketString]];
    
    [[cell restaurantImageView] setAlpha:1.0];

    if ([item.state integerValue] == DMVenueStateVerfiedDemo)
    {
        [[cell restaurantCategory] setText:@"Coming Soon to DinerMojo"];
        [[cell restaurantImageView] setAlpha:0.6];

    }

    NSNumber *latitude = item.latitude;
    NSNumber *longitude = item.longitude;
    CLLocation *venueCoordinates = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    
    double distance = [[DMLocationServices sharedInstance] userLocationDistanceFromLocation:venueCoordinates];
    
    MKDistanceFormatter *df = [MKDistanceFormatter new];
    [df setUnitStyle:MKDistanceFormatterUnitStyleFull];
    
    NSString *friendlyDistance = [df stringFromDistance:distance];
    
    // TODO: Once we have user location, calculate distance based on the longitude and latitude
    [[cell restaurantDistance] setText:[NSString stringWithFormat:@"%@",friendlyDistance]];
    
    NSURL *url = [NSURL URLWithString:[venueImage fullThumbURL]];
    [[cell restaurantImageView] setImageWithURL:url];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 166;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DMVenue *item = [[[self mapModelController] venues] objectAtIndex:indexPath.row];
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

@end