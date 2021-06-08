//
//  DMVenueRequest.m
//  DinerMojo
//
//  Created by hedgehog lab on 01/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMVenueRequest.h"
#import "DMMappingHelper.h"
#import "DMVenueImage.h"

@implementation DMVenueRequest

- (void)cachedVenues:(RequestCompletion)completionBlock;
{
    
    NSFetchRequest *venuesFetch = [NSFetchRequest fetchRequestWithEntityName:@"DMVenue"];
    NSError *error;
    NSArray *fetchedVenues = [[self objectContext] executeFetchRequest:venuesFetch error:&error];
    if (fetchedVenues == nil) {
        NSLog(@"Error fetching: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    for (DMVenue *venue in fetchedVenues) {
        
    }
    completionBlock(nil, fetchedVenues);
}

- (NSMutableArray *)cachedFavouriteVenuesIds {
    NSString *stringFavoriteIds = [[NSUserDefaults standardUserDefaults] objectForKey:@"favourite_ids"];
    NSArray *all_ids = [stringFavoriteIds componentsSeparatedByString:@","];
    NSMutableArray *cachedFavouriteIds = [[NSMutableArray alloc] initWithArray:all_ids];
    return cachedFavouriteIds;
}

- (void)cachedFavoriteVenues:(RequestCompletion)completionBlock;
{
    NSFetchRequest *venuesFetch = [NSFetchRequest fetchRequestWithEntityName:@"DMVenue"];
    NSError *error;
    NSArray *fetchedVenues = [[self objectContext] executeFetchRequest:venuesFetch error:&error];
    if (fetchedVenues == nil) {
        NSLog(@"Error fetching: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    NSMutableArray *favs = [[NSMutableArray alloc] init];
    NSArray *all_ids = [self cachedFavouriteVenuesIds];
    for (DMVenue *venue in fetchedVenues) {
        NSString* stringId = [NSString stringWithFormat:@"%d",venue.modelIDValue];
        if([all_ids containsObject:stringId]) {
            [favs addObject:venue];
        }
    }
    completionBlock(nil, favs);
}



- (void)downloadVenuesWithCompletionBlock:(RequestCompletion)completionBlock;
{
    [self GET:@"venues" withParams:nil withCompletionBlock:^(NSError *error, id results) {
        if (error) {
            completionBlock(error, nil);
        } else {
            // Map venue data here
            NSArray *mappedVenues = [DMMappingHelper mapVenues:results withMapping:[[self mappingProvider] venueMappingWithoutNews] inContext:[self objectContext]];
            completionBlock(nil, mappedVenues);
        }
    }];
}

- (void)downloadLiveVenuesWithCompletionBlock:(RequestCompletion)completionBlock;
{
    [self GET:@"live_venues" withParams:nil withCompletionBlock:^(NSError *error, id results) {
        if (error) {
            completionBlock(error, nil);
        } else {
            // Map venue data here
            NSArray *mappedVenues = [DMMappingHelper mapVenues:results withMapping:[[self mappingProvider] venueMappingWithoutNews] inContext:[self objectContext]];
            completionBlock(nil, mappedVenues);
        }
    }];
}

-(void)postBooking:(NSNumber *)venueId date:(NSString *)date number:(NSNumber *)number clientDesc:(NSString *)clientDesc phone:(NSString *)phone completion:(RequestCompletion)completionBlock {
    NSDictionary *params = @{ @"time" : date, @"people" : number, @"client_desc" : clientDesc, @"phone_number": phone};
    NSString *url = [NSString stringWithFormat:@"venues/%@/booking", venueId];
    [self POST:url withParams:params withCompletionBlock:^(NSError *error, id results) {
        if(error) {
            completionBlock(error, nil);
        } else {
            completionBlock(nil, nil);
        }
    }];
}

-(void)updateBookingTracker:(NSNumber *)venueId completion:(RequestCompletion)completionBlock {
    NSString *url = [NSString stringWithFormat:@"venues/%@/booking", venueId];
    
    [self GET:url withParams:nil withCompletionBlock:^(NSError *error, id results) {
        if(error) {
            completionBlock(error, nil);
        } else {
            completionBlock(nil, nil);
        }
    }];
}

- (void)getBookingByID:(NSNumber *)bookingId completionBlock:(RequestCompletion)completionBlock {
    NSString *url = [NSString stringWithFormat:@"user/me/booking/%@", bookingId];
    
    [self GET:url withParams:nil withCompletionBlock:^(NSError *error, id results) {
        if(error) {
            completionBlock(error, nil);
        } else {
            completionBlock(nil, results);
        }
    }];
}
    
- (void)shareReceivePoints:(RequestCompletion)completionBlock {
    [self POST:@"user/share" withParams:NULL withCompletionBlock:^(NSError *error, id results) {
        if (error) {
            completionBlock(error, nil);
        } else {
            completionBlock(nil, nil);
        }
    }];
}

- (void)downloadVenueCategoriesWithCompletionBlock:(RequestCompletion)completionBlock {
    [self GET:@"venue_categories" withParams:nil withCompletionBlock:^(NSError *error, id results) {
        if (error) {
            completionBlock(error, nil);
        } else {
            NSArray *mappedCategories = [DMMappingHelper mapVenues:results withMapping:[[self mappingProvider]  categoryMapping] inContext:[self objectContext]];
            completionBlock(error, mappedCategories);
        }
    }];
}

@end
