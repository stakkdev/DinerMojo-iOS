//
//  DMServiceLocator.h
//  DinerMojo
//
//  Created by Carl Sanders on 29/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//
#import <Foundation/Foundation.h>
@import CoreLocation;

@interface DMLocationServices : NSObject <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) DMVenue *venueLocation;



+ (DMLocationServices*)sharedInstance;

- (void)startUpdatingCoordinates;
- (void)stopUpdating;
- (double)userLocationDistanceFromLocation:(CLLocation *)location;
- (double)getDistanceWithLatitude:(NSNumber *)latitude andLongitude:(NSNumber *)longitude;
- (BOOL)isLocationEnabled;
- (double)getDistanceFor:(DMVenue *)venue;


@end
