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
@synthesize filteredVenues = _filteredVenues;
@synthesize mapAnnotations = _mapAnnotations;

- (void)setVenues:(NSArray *)venues {
    _venues = venues;
    [self apply:_filters];
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

- (void)apply:(NSArray *)filters {
    // Init
    NSMutableArray *restaurantsTypePredicates = [[NSMutableArray alloc] init];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    
    // Sort
    NSSortDescriptor *activeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"state" ascending:NO];
    NSSortDescriptor *alphabeticalSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor *createdAtSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created_on" ascending:YES];
    [sortDescriptors addObject:activeSortDescriptor];
    BOOL sortByDistance = NO;
    
    // Filter: redemtion & offer venues
    BOOL filterRedeemPoints = NO;
    BOOL filterEarnsPoints = NO;
    BOOL filterHasNews = NO;
    BOOL filterHasOffers = NO;

    
    // Loop through filters
    for (FilterItem *filter in filters)
    {
        if (filter.groupName == GroupsNameSortBy) {
            if (filter.itemId == SortByItemsAZ) {
                [sortDescriptors addObject:alphabeticalSortDescriptor];
            } else if (filter.itemId == SortByItemsRecentItem) {
                [sortDescriptors addObject:createdAtSortDescriptor];
            } else if (filter.itemId == SortByItemsNearestItem) {
                sortByDistance = YES;
            }
        } else if (filter.groupName == GroupsNameRestaurantsFilter) {
            
        } else if (filter.groupName == GroupsNameShowVenues) {
            if (filter.itemId == ShowVenuesRedeemItem) {
                filterRedeemPoints = YES;
            } else if (filter.itemId == ShowVenuesEarnPointsItem) {
                filterEarnsPoints = YES;
            } else if (filter.itemId == ShowVenuesNewsItem) {
                filterHasNews = YES;
            } else if (filter.itemId == ShowVenuesOffersItem) {
                filterHasOffers = YES;
            }
        } else if (filter.groupName == GroupsNameThings) {

        } else if (filter.groupName == GroupsNameTellMe) {

        }
    }
    
    if (filterHasOffers || filterHasNews || filterEarnsPoints || filterRedeemPoints) {
        NSMutableArray *predicatesStrings = [[NSMutableArray alloc] init];
        if (filterHasNews) {
            [predicatesStrings addObject:@"has_news == YES"];
        }
        if (filterHasOffers) {
            [predicatesStrings addObject:@"has_offers == YES"];
        }
        if (filterEarnsPoints) {
            [predicatesStrings addObject:@"allows_earns == YES"];
        }
        if (filterRedeemPoints) {
            [predicatesStrings addObject:@"allows_redemptions == YES"];
        }
        NSString *offersPredicateString = [self combine:predicatesStrings];
        [predicates addObject:[NSPredicate predicateWithFormat:offersPredicateString]];
    }
    
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    
    NSArray *sortedArray = [[_venues filteredArrayUsingPredicate:compoundPredicate] sortedArrayUsingDescriptors:sortDescriptors];
    
    if (sortByDistance) {
        NSArray *locationSortedArray;
        locationSortedArray = [sortedArray sortedArrayUsingComparator:^NSComparisonResult(DMVenue* a, DMVenue* b) {
            double distanceA = [[DMLocationServices sharedInstance] getDistanceFor:a];
            double distanceB = [[DMLocationServices sharedInstance] getDistanceFor:b];
            return distanceA > distanceB;
        }];
        _filteredVenues = locationSortedArray;
        _mapAnnotations = [self annotations:locationSortedArray];
        return;
    }
    _filteredVenues = sortedArray;
    _mapAnnotations = [self annotations:sortedArray];
}

- (NSString *)combine:(NSArray *)predicates {
    NSMutableString *finalPredicate = [[NSMutableString alloc] init];
    NSInteger *addedPredicatesCount = 0;
    
    for (NSString *predicate in predicates) {
        if (addedPredicatesCount == 0) {
            finalPredicate = predicate;
        } else {
            finalPredicate = [NSString stringWithFormat:@"%@ %@ %@", finalPredicate, @"OR", predicate];
        }
        addedPredicatesCount += 1;
    }
     
    if (addedPredicatesCount > 1) {
        finalPredicate = [NSString stringWithFormat:@"%@%@%@",  @"(", finalPredicate, @")"];
    }
    return finalPredicate;
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
