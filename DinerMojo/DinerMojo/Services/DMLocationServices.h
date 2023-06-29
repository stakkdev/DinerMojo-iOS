//
//  DMServiceLocator.h
//  DinerMojo
//
//  Created by Carl Sanders on 29/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//
#import <Foundation/Foundation.h>
@import CoreLocation;

@protocol DMLocationServiceDelegate <NSObject>
@optional
- (void)didInitiallyUpdateLocation;

@end

@interface DMLocationServices : NSObject <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLLocation *selectedLocation;
@property (strong, nonatomic) NSString *locationName;
@property (strong, nonatomic) DMVenue *venueLocation;
@property (nonatomic) BOOL initialLocationUpdate;
@property (nonatomic, weak) id <DMLocationServiceDelegate> delegate;
@property (nonatomic) BOOL isDinerMojoNewsUpdated;
@property (nonatomic) BOOL isDinerMojoNewsSelected;



+ (DMLocationServices*)sharedInstance;

- (void)startUpdatingCoordinates;
- (void)stopUpdating;
- (double)userLocationDistanceFromLocation:(CLLocation *)location;
- (double)getDistanceWithLatitude:(NSNumber *)latitude andLongitude:(NSNumber *)longitude;
- (BOOL)isLocationEnabled;
- (double)getSelectedLocationDistanceFrom:(DMVenue *)venue;
- (double)getUserDistanceFrom:(DMVenue *)venue;


@end
