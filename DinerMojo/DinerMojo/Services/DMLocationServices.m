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
       
        CLLocation *kingstone = [[CLLocation alloc] initWithLatitude:51.4148  longitude:-0.3005];
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
    [self setCurrentLocation:[locations lastObject]];
    if (_initialLocationUpdate) {
        [self setSelectedLocation:[locations lastObject]];
        [self setInitialLocationUpdate:NO];
        [self.delegate didInitiallyUpdateLocation];
    }
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:manager.location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
        
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            return;
        }
        NSLog(@"placemarks=%@",[placemarks objectAtIndex:0]);
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        NSLog(@"placemark.name =%@",placemark.name);
        [self setLocationName:placemark.name];
    }];
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
