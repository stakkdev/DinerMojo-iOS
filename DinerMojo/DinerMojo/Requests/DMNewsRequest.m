//
//  DMNewsRequest.m
//  DinerMojo
//
//  Created by hedgehog lab on 01/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMNewsRequest.h"
#import "DMMappingHelper.h"

@implementation DMNewsRequest

- (void)downloadNewsWithCompletionBlock:(RequestCompletion)completionBlock withNewsType:(NSNumber *) newsType;
{
    __weak typeof(self) weakSelf = self;
    //pass into params in a dictionary
    NSDictionary *queryDictionary = @{ @"update_type": newsType};
    NSLog(@"queryDictionary News is:%@", queryDictionary);

    [self GET:@"news" withParams:queryDictionary withCompletionBlock:^(NSError *error, id results) {
        if (error) {
            completionBlock(error, nil);
        } else {
            NSLog(@"downloadNewsWithCompletionBlock News is:%@", results);
            completionBlock(nil, [weakSelf parseAllNewsFromDictionaryArray:results inContext:[self objectContext]]);
        }
    }];
}

- (void)downloadVenueNewsWithCompletionBlock:(RequestCompletion)completionBlock withNewsType:(NSNumber *) newsType withVenue:(NSNumber *) venueID;
{
    __weak typeof(self) weakSelf = self;
    //pass into params in a dictionary
    NSDictionary *queryDictionary = @{ @"update_type": newsType, @"venue_id": venueID};
    NSLog(@"queryDictionary News is:%@", queryDictionary);
    
    [self GET:@"news" withParams:queryDictionary withCompletionBlock:^(NSError *error, id results) {
        if (error) {
            completionBlock(error, nil);
        } else {
            NSLog(@"downloadVenueNewsWithCompletionBlock News is:%@", results);
            completionBlock(nil, [weakSelf parseAllNewsFromDictionaryArray:results inContext:[self objectContext]]);
        }
    }];
}

- (NSArray *)parseAllNewsFromDictionaryArray:(NSArray *)results inContext:(NSManagedObjectContext *)context;
{
    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (NSDictionary *dictionary in results)
    {
        DMUpdateItemType type = [[dictionary objectForKey:@"update_type"] integerValue];
        
        if (type == DMUpdateItemTypeOffer)
        {
            [returnArray addObject:[DMMappingHelper mapOfferItem:dictionary withMapping:[[self mappingProvider] offerMapping] inContext:[self objectContext]]];
        }
        else if (type == DMUpdateItemTypeReward) {
            [returnArray addObject:[DMMappingHelper mapOfferItem:dictionary withMapping:[[self mappingProvider] offerMapping] inContext:[self objectContext]]];
        }
        else if (type == DMUpdateItemTypeProdigalReward) {
             [returnArray addObject:[DMMappingHelper mapNewsItem:dictionary withMapping:[[self mappingProvider] prodigalRewardMapping] inContext:[self objectContext]]];
        }
        else
        {
            [returnArray addObject:[DMMappingHelper mapNewsItem:dictionary withMapping:[[self mappingProvider] newsMapping] inContext:[self objectContext]]];
        }
    }
    return returnArray;
}

@end
