//
//  DMMappingProvider.h
//  DinerMojo
//
//  Created by Craig Tweedy on 08/01/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FastEasyMapping/FastEasyMapping.h>

@interface DMMappingProvider : NSObject

- (FEMManagedObjectMapping *)venueMappingWithoutNews;
- (FEMManagedObjectMapping *)venueMappingWithNews;
- (FEMManagedObjectMapping *)categoryMapping;
- (FEMManagedObjectMapping *)venueImageMapping;

- (FEMManagedObjectMapping *)newsMapping;
- (FEMManagedObjectMapping *)prodigalRewardMapping;
- (FEMManagedObjectMapping *)offerMapping;

- (FEMManagedObjectMapping *)completeUserMapping;
- (FEMManagedObjectMapping *)simpleUserMapping;
- (FEMManagedObjectMapping *)userFavouriteVenuesMapping;

- (FEMManagedObjectMapping *)earnMapping;
- (FEMManagedObjectMapping *)redeemMapping;

@end
