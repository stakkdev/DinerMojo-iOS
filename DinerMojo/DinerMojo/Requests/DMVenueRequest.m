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

@end
