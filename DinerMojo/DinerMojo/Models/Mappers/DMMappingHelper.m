//
//  DMMappingHelper.m
//  DinerMojo
//
//  Created by hedgehog lab on 01/07/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMMappingHelper.h"

@implementation DMMappingHelper

#pragma mark - Venues

+ (DMVenue *)mapVenue:(NSDictionary *)details withMapping:(FEMManagedObjectMapping *)mapping inContext:(NSManagedObjectContext *)context
{
    return [DMManagedObjectDeserializer deserializeObjectExternalRepresentation:details
                                                                   usingMapping:mapping
                                                                        context:context];
}

+ (NSArray *)mapVenues:(NSArray *)venues withMapping:(FEMManagedObjectMapping *)mapping inContext:(NSManagedObjectContext *)context
{
    return [DMManagedObjectDeserializer deserializeCollectionExternalRepresentation:venues
                                                                       usingMapping:mapping
                                                                            context:context];
}

#pragma mark - Updates (News / Offers)

+ (DMNewsItem *)mapNewsItem:(NSDictionary *)details withMapping:(FEMManagedObjectMapping *)mapping inContext:(NSManagedObjectContext *)context
{
    return [DMManagedObjectDeserializer deserializeObjectExternalRepresentation:details
                                                                   usingMapping:mapping
                                                                        context:context];
}

+ (DMOfferItem *)mapOfferItem:(NSDictionary *)details withMapping:(FEMManagedObjectMapping *)mapping inContext:(NSManagedObjectContext *)context
{
    return [DMManagedObjectDeserializer deserializeObjectExternalRepresentation:details
                                                                   usingMapping:mapping
                                                                        context:context];
}

+ (NSArray *)mapOfferItems:(NSArray *)offers withMapping:(FEMManagedObjectMapping *)mapping inContext:(NSManagedObjectContext *)context
{
    return [DMManagedObjectDeserializer deserializeCollectionExternalRepresentation:offers
                                                                       usingMapping:mapping
                                                                            context:context];
}

#pragma mark - Users

+ (DMUser *)mapUser:(NSDictionary *)details mapping:(FEMManagedObjectMapping *)mapping inContext:(NSManagedObjectContext *)context
{
    return [DMManagedObjectDeserializer deserializeObjectExternalRepresentation:details
                                                                   usingMapping:mapping
                                                                        context:context];
}

+ (NSArray *)mapUsers:(NSArray *)users mapping:(FEMManagedObjectMapping *)mapping inContext:(NSManagedObjectContext *)context
{
    return [DMManagedObjectDeserializer deserializeCollectionExternalRepresentation:users
                                                                       usingMapping:mapping
                                                                            context:context];
}

#pragma mark - Transactions

+ (DMEarnTransaction *)mapEarn:(NSDictionary *)details mapping:(FEMManagedObjectMapping *)mapping inContext:(NSManagedObjectContext *)context
{
    return [DMManagedObjectDeserializer deserializeObjectExternalRepresentation:details
                                                                   usingMapping:mapping
                                                                        context:context];
}

+ (DMRedeemTransaction *)mapRedeem:(NSDictionary *)details mapping:(FEMManagedObjectMapping *)mapping inContext:(NSManagedObjectContext *)context
{
    return [DMManagedObjectDeserializer deserializeObjectExternalRepresentation:details
                                                                   usingMapping:mapping
                                                                        context:context];
}

@end