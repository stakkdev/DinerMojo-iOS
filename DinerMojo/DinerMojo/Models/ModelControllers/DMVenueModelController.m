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
    [self applyFilters];
    [self updateCategories];
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

// MARK: - Applying filters

- (void)applyFilters {
    NSMutableArray *categoriesIds = [[NSMutableArray alloc] init];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    
    // Sort
    NSSortDescriptor *activeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"state" ascending:NO];
    NSSortDescriptor *alphabeticalSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor *createdAtSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created_on" ascending:YES];
    [sortDescriptors addObject:activeSortDescriptor];
    BOOL sortByDistance = NO;
    BOOL sortByDistanceFromSelectedLocation = NO;
    
    // Filter: redemtion & offer venues
    BOOL filterRedeemPoints = NO;
    BOOL filterEarnsPoints = NO;
    BOOL filterHasNews = NO;
    BOOL filterHasOffers = NO;

    
    // Loop through filters
    for (FilterItem *filter in _filters)
    {
        if (filter.groupName == GroupsNameSortBy) {
            if (filter.itemId == SortByItemsAZ) {
                [sortDescriptors addObject:alphabeticalSortDescriptor];
            } else if (filter.itemId == SortByItemsRecentItem) {
                [sortDescriptors addObject:createdAtSortDescriptor];
            } else if (filter.itemId == SortByItemsNearestItem) {
                sortByDistance = YES;
            } else if (filter.itemId == SortByItemsSelectedLocation) {
                sortByDistanceFromSelectedLocation = YES;
            }
        } else if (filter.groupName == GroupsNameRestaurantsFilter) {
            NSNumber *modelID = [[NSNumber alloc]initWithInteger:filter.itemId];
            [categoriesIds addObject: modelID];
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
    
    _selectedCategoriesIds = categoriesIds;
    
    if (categoriesIds.count > 0) {
        NSMutableArray *categoriesFilteredArray = [[NSMutableArray alloc] init];
        for (DMVenue *venue in sortedArray) {
            BOOL venueSelected = NO;
            for (DMVenueCategory *category in venue.categories) {
               BOOL categorySelected = [categoriesIds containsObject:category.modelID];
                if (categorySelected) {
                    venueSelected = YES;
                }
            }
            if (venueSelected) {
                [categoriesFilteredArray addObject:venue];
            }
        }
        sortedArray = categoriesFilteredArray;
    }
    
    if (sortByDistance) {
        NSArray *locationSortedArray;
        locationSortedArray = [sortedArray sortedArrayUsingComparator:^NSComparisonResult(DMVenue* a, DMVenue* b) {
            double distanceA = [[DMLocationServices sharedInstance] getUserDistanceFrom:a];
            double distanceB = [[DMLocationServices sharedInstance] getUserDistanceFrom:b];
            return distanceA > distanceB;
        }];
        sortedArray = locationSortedArray;
    } else if (sortByDistanceFromSelectedLocation) {
        NSArray *locationSortedArray;
        locationSortedArray = [sortedArray sortedArrayUsingComparator:^NSComparisonResult(DMVenue* a, DMVenue* b) {
            double distanceA = [[DMLocationServices sharedInstance] getSelectedLocationDistanceFrom:a];
            double distanceB = [[DMLocationServices sharedInstance] getSelectedLocationDistanceFrom:b];
            return distanceA > distanceB;
        }];
        sortedArray = locationSortedArray;
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

- (void)applyFilters:(NSArray *)filters sortBySelectedLocation:(BOOL)enabled {
    NSMutableArray *newFilters = [[NSMutableArray alloc]init];
    // filter current filters to:
    // remove sorting except by selected location if enabled
    // remove sorting by selected location if disabled
    for (FilterItem *filter in filters)
    {
        if (filter.groupName == GroupsNameSortBy) {
            if (
                filter.itemId == SortByItemsAZ ||
                filter.itemId == SortByItemsRecentItem ||
                filter.itemId == SortByItemsNearestItem
                ) {
                if (!enabled) {
                 [newFilters addObject:filter];
                }
            } else if (filter.itemId == SortByItemsSelectedLocation) {
                return;
            }
        } else {
            [newFilters addObject:filter];
        }
    }
    FilterItem *sortBySelectedLocation = [[FilterItem alloc] initWithGroupName:GroupsNameSortBy itemId:SortByItemsSelectedLocation value:0];
    // add sort by selected location if enabled
    if (enabled == YES) {
        [newFilters addObject:sortBySelectedLocation];
    }
    [self setFilteringBySelectedLocation:enabled];
    self.filters = newFilters;
    [self applyFilters];
}

// MARK: - Categories

- (NSArray *)venuesIncludingRestaurantType:(BOOL)includeRestaurantType includeLifestyleType:(BOOL)includeLifestyleType {
    
    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
    
    if (!includeLifestyleType) {
        [predicates addObject:[NSPredicate predicateWithFormat:@"venue_type = \"restaurant\" AND (allows_earns == YES OR allows_redemptions == YES)"]];
    } else if (!includeRestaurantType) {
        [predicates addObject:[NSPredicate predicateWithFormat:@"venue_type = \"non_restaurant\""]];
    }
    
    if([sortDescriptors count] == 0) {
        [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"created_on" ascending:NO]];
    }
    
    return [self venuesForPredicates:predicates sortDescriptors:sortDescriptors];

}

- (NSArray *)venuesForPredicates:(NSMutableArray *)predicates sortDescriptors:(NSMutableArray *)sortDescriptors {
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    NSArray *sortedArray = [[_venues filteredArrayUsingPredicate:compoundPredicate] sortedArrayUsingDescriptors:sortDescriptors];
    
    return sortedArray;

}

- (void)updateCategories {
    NSArray *lifestyleVenues = [self venuesIncludingRestaurantType:NO includeLifestyleType:YES];
    NSArray *restaurantVenues = [self venuesIncludingRestaurantType:YES includeLifestyleType:NO];
    NSArray *lifestyleCategories = [self categoriesFor:lifestyleVenues];
    NSArray *restaurantCategories = [self categoriesFor:restaurantVenues];
    _lifestyleCategories = lifestyleCategories;
    _restaurantCategories = restaurantCategories;
}

- (NSArray *)categoriesFor:(NSArray *)venues {
    NSMutableArray *allCategories = [[NSMutableArray alloc] init];
    
    for (DMVenue *venue in venues) {
        for (DMVenueCategory *cat in [venue.categories allObjects]) {
            [allCategories addObject:cat];
        }
    }
    NSArray *categories = [[NSSet setWithArray:allCategories] allObjects];
    NSSortDescriptor *alphabeticalSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:alphabeticalSortDescriptor, nil];
    NSArray *sortedArray = [categories sortedArrayUsingDescriptors:sortDescriptors];
    return sortedArray;
}

- (NSMutableArray *)getSelectedCategoriesForRestaurants {
    return [self selectedCategoriesForRestaurants:YES];
}

- (NSMutableArray *)getSelectedCategoriesForLifestyle {
    return [self selectedCategoriesForRestaurants:NO];
}

- (NSMutableArray *)selectedCategoriesForRestaurants:(BOOL)isRestaurants {
    NSMutableArray *selectedCategories = [[NSMutableArray alloc] init];
    NSArray *allCategories = isRestaurants ? _restaurantCategories : _lifestyleCategories;
    for (DMVenueCategory *category in allCategories) {
        if ([_selectedCategoriesIds containsObject:category.modelID]) {
            [selectedCategories addObject:category];
        }
    }
    return selectedCategories;
}

@end
