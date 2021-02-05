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
-(void)setVenues:(NSArray *)venues;
{
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"state" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, sortDescriptor2, nil];
    venues = [venues sortedArrayUsingDescriptors:sortDescriptors];
    
    _venues = venues;
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

- (NSArray *)venues {
    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    NSMutableArray *restaurantsTypePredicates = [[NSMutableArray alloc] init];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
    BOOL sortByDistance = NO;
    
    [predicates addObject:[NSPredicate predicateWithFormat:@"allows_earns == YES OR allows_redemptions == YES"]];
    BOOL news = NO;
    BOOL offers = NO;
    BOOL redeem = NO;
    BOOL earn = NO;
    for (FilterItem *item in self.filters) {
        if(item.itemId == ShowVenuesNewsItem) {
            news = YES;
        } else if(item.itemId == ShowVenuesOffersItem) {
            offers = YES;
        } else if(item.itemId == ShowVenuesRedeemItem) {
            redeem = YES;
        } else if(item.itemId == ShowVenuesEarnPointsItem) {
            earn = YES;
        }
    }
    
    for (FilterItem *item in self.filters) {

        if(item.itemId == SortByItemsAZ) {
            [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
        }
        else if(item.itemId == SortByItemsRecentItem) {
            [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"created_on" ascending:NO]];
        }
        else if(item.itemId == SortByItemsNearestItem) {
            sortByDistance = YES;
        } else if((item.itemId == ShowVenuesRedeemItem || item.itemId == ShowVenuesEarnPointsItem) && redeem && earn) {
            [predicates addObject:[NSPredicate predicateWithFormat:@"allows_redemptions == YES OR allows_earns == YES"]];
        }
        else if(item.itemId == ShowVenuesRedeemItem) {
            [predicates addObject:[NSPredicate predicateWithFormat:@"allows_redemptions == YES"]];
        }
        else if(item.itemId == ShowVenuesEarnPointsItem) {
            [predicates addObject:[NSPredicate predicateWithFormat:@"allows_earns == YES"]];
        } else if((item.itemId == ShowVenuesOffersItem || item.itemId == ShowVenuesNewsItem) && news && offers) {
            [predicates addObject:[NSPredicate predicateWithFormat:@"has_news == YES OR has_offers == YES"]];
        } else if(item.itemId == ShowVenuesNewsItem) {
            [predicates addObject:[NSPredicate predicateWithFormat:@"has_news == YES"]];
        }
        else if(item.itemId == ShowVenuesOffersItem) {
            [predicates addObject:[NSPredicate predicateWithFormat:@"has_offers == YES"]];
        }
        else if(item.itemId == DistanceFilterDistanceItem) {
            if(item.value < 100) {
                double radiusValue = item.value * 1.6; //convert to miles
                
                NSPredicate *distancePredicate = [NSPredicate predicateWithBlock:^BOOL(id item, NSDictionary *bindings) {
                    DMVenue *venue = item;
                    double distance = ([[DMLocationServices sharedInstance] getDistanceWithLatitude:venue.latitude andLongitude:venue.longitude]) / 1000;
                    return distance <= radiusValue;
                }];
                
                [predicates addObject:distancePredicate];
            }
        }
        else if(item.groupName == GroupsNameRestaurantsFilter) {
            if(!self.filterLifestyle) {
                [restaurantsTypePredicates addObject:[NSPredicate predicateWithFormat:@"ANY categories.modelID == %d", item.itemId]];
            }
        }
    }
    
    if([sortDescriptors count] == 0) {
        sortByDistance = YES;
    }

    switch (self.state) {
        case DMVenueMap: {
            [predicates addObject:[NSPredicate predicateWithFormat:@"venue_type = \"restaurant\""]];
        }
        break;
        
        case DMVenueList: {
            [predicates addObject:[NSPredicate predicateWithFormat:@"venue_type = \"non_restaurant\""]];
        }
        break;
            
        case DMVenueListFavourite: {
            DMUserRequest *userRequest = [DMUserRequest new];
            DMUser *currentUser = [userRequest currentUser];
            NSArray *favouriteVenues = [currentUser.favourite_venues allObjects];
            [self setVenues:favouriteVenues];
        }
        break;
            
        default: {
            [predicates addObject:[NSPredicate predicateWithFormat:@"(venue_type = \"restaurant\" OR venue_type = \"non_restaurant\")"]];
        }
        break;
    }
    
    if(restaurantsTypePredicates.count > 0) {
        NSPredicate *compoundRestaurantsTypePredicate = [NSCompoundPredicate orPredicateWithSubpredicates:restaurantsTypePredicates];
        [predicates addObject:compoundRestaurantsTypePredicate];
    }
    
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    NSArray *sortedArray = [[_venues filteredArrayUsingPredicate:compoundPredicate] sortedArrayUsingDescriptors:sortDescriptors];
    
    if(sortByDistance) {
        sortedArray = [sortedArray sortedArrayUsingComparator:^NSComparisonResult(DMVenue *a, DMVenue *b) {
            double distance1 = [[DMLocationServices sharedInstance] getDistanceWithLatitude:a.latitude andLongitude:a.longitude];
            double distance2 = [[DMLocationServices sharedInstance] getDistanceWithLatitude:b.latitude andLongitude:b.longitude];
            
            return distance1 > distance2;
        }];
    } /*else {
        NSSortDescriptor *desc = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                             ascending:YES selector:@selector(caseInsensitiveCompare:)];
        sortedArray = [sortedArray sortedArrayUsingDescriptors:[NSArray
                                                                arrayWithObject:desc]];
    }*/
    
    return sortedArray;
}



@end
