//
//  DMVenueModelController.m
//  DinerMojo
//
//  Created by hedgehog lab on 01/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMVenueModelController.h"
#import "DMVenue.h"
#import "DinerMojo-Swift.h"
#import <CoreLocation/CoreLocation.h>
#import "DMLocationServices.h"

@implementation DMVenueModelController
@synthesize venues = _venues;
@synthesize mapAnnotations = _mapAnnotations;

- (void)setVenues:(NSArray *)venues {
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"state" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, sortDescriptor2, nil];
    venues = [venues sortedArrayUsingDescriptors:sortDescriptors];
    
    _venues = venues;
    _mapAnnotations = [self annotations:venues];
}

- (NSArray *)annotations:(NSArray *)venues {
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    
    for (DMVenue *venue in venues) {
        NSNumber *latitude = venue.latitude;
        NSNumber *longitude = venue.longitude;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = coordinate;
        annotation.title = venue.name;
        annotation.subtitle = @"";
        [annotations addObject:annotation];
    }
    
    return annotations;
}

- (NSArray *)venuesForFilter {
    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    NSMutableArray *restaurantsTypePredicates = [[NSMutableArray alloc] init];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
    
    [predicates addObject:[NSPredicate predicateWithFormat:@"venue_type = \"restaurant\" AND (allows_earns == YES OR allows_redemptions == YES)"]];
    
    if([sortDescriptors count] == 0) {
        [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"created_on" ascending:NO]];
    }
    
    if(restaurantsTypePredicates.count > 0) {
        NSPredicate *compoundRestaurantsTypePredicate = [NSCompoundPredicate orPredicateWithSubpredicates:restaurantsTypePredicates];
        [predicates addObject:compoundRestaurantsTypePredicate];
    }
    
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    NSArray *sortedArray = [[_venues filteredArrayUsingPredicate:compoundPredicate] sortedArrayUsingDescriptors:sortDescriptors];
    
    return sortedArray;
}

@end
