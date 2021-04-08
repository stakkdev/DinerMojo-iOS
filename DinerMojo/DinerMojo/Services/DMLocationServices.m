//
//  DMServiceLocator.m
//  DinerMojo
//
//  Created by Carl Sanders on 29/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMLocationServices.h"



@implementation DMLocationServices

+ (DMLocationServices *)sharedInstance;
{
    static dispatch_once_t pred;
    static id shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[[self class] alloc] init];
        CLLocation *kingstone = [[CLLocation alloc] initWithLatitude:51.41259  longitude:-0.2974];
        [shared setCurrentLocation:kingstone];
        [shared setSelectedLocation:kingstone];
        [shared setInitialLocationUpdate:YES];
        
    });
    return shared;
}

- (void)startUpdatingCoordinates
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdating
{
    [[self locationManager] stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (_initialLocationUpdate) {
        [self setSelectedLocation:[locations lastObject]];
        [self setInitialLocationUpdate:NO];
        [self.delegate didInitiallyUpdateLocation];
    }
    [self setCurrentLocation:[locations lastObject]];
    
}

- (double)userLocationDistanceFromLocation:(CLLocation *)location
{
    return [[self currentLocation] distanceFromLocation:location];
}

- (double)distanceFromSelectedLocationFor:(CLLocation *)location
{
    return [[self selectedLocation] distanceFromLocation:location];
}

- (double)getDistanceWithLatitude:(NSNumber *)latitude andLongitude:(NSNumber *)longitude {
    CLLocation *venueCoordinates = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    double distance = [self userLocationDistanceFromLocation:venueCoordinates];
    return distance;
}

- (double)getSelectedLocationDistanceFrom:(DMVenue *)venue {
    NSNumber *latitude = venue.latitude;
    NSNumber *longitude = venue.longitude;
    CLLocation *venueCoordinates = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    double distance = [self distanceFromSelectedLocationFor:venueCoordinates];
    return distance;
}

- (double)getUserDistanceFrom:(DMVenue *)venue {
    NSNumber *latitude = venue.latitude;
    NSNumber *longitude = venue.longitude;
    CLLocation *venueCoordinates = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    double distance = [self userLocationDistanceFromLocation:venueCoordinates];
    return distance;
}

- (BOOL)isLocationEnabled {
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        return YES;
    }
    else {
        return NO;
    }
}

@end
