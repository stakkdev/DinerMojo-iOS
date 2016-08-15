//
//  DMMappingHelper.h
//  DinerMojo
//
//  Created by hedgehog lab on 01/07/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMManagedObjectDeserializer.h"

#import "DMNewsItem.h"
#import "DMOfferItem.h"
#import "DMEarnTransaction.h"
#import "DMRedeemTransaction.h"

@interface DMMappingHelper : NSObject

+ (DMVenue *)mapVenue:(NSDictionary *)details withMapping:(FEMManagedObjectMapping *)mapping inContext:(NSManagedObjectContext *)context;
+ (NSArray *)mapVenues:(NSArray *)venues withMapping:(FEMManagedObjectMapping *)mapping inContext:(NSManagedObjectContext *)context;

+ (DMNewsItem *)mapNewsItem:(NSDictionary *)details withMapping:(FEMManagedObjectMapping *)mapping inContext:(NSManagedObjectContext *)context;
+ (DMOfferItem *)mapOfferItem:(NSDictionary *)details withMapping:(FEMManagedObjectMapping *)mapping inContext:(NSManagedObjectContext *)context;
+ (NSArray *)mapOfferItems:(NSArray *)offers withMapping:(FEMManagedObjectMapping *)mapping inContext:(NSManagedObjectContext *)context;

+ (DMUser *)mapUser:(NSDictionary *)details mapping:(FEMManagedObjectMapping *)mapping inContext:(NSManagedObjectContext *)context;
+ (NSArray *)mapUsers:(NSArray *)users mapping:(FEMManagedObjectMapping *)mapping inContext:(NSManagedObjectContext *)context;

+ (DMEarnTransaction *)mapEarn:(NSDictionary *)details mapping:(FEMManagedObjectMapping *)mapping inContext:(NSManagedObjectContext *)context;
+ (DMRedeemTransaction *)mapRedeem:(NSDictionary *)details mapping:(FEMManagedObjectMapping *)mapping inContext:(NSManagedObjectContext *)context;

@end
