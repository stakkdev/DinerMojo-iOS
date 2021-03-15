//
//  DMVenueRequest.h
//  DinerMojo
//
//  Created by hedgehog lab on 01/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMRequest.h"

@interface DMVenueRequest : DMRequest

- (void)downloadVenuesWithCompletionBlock:(RequestCompletion)completionBlock;
- (void)cachedVenues:(RequestCompletion)completionBlock;
- (void)cachedFavoriteVenues:(RequestCompletion)completionBlock;
- (NSArray *)cachedFavouriteVenuesIds;
- (void)downloadLiveVenuesWithCompletionBlock:(RequestCompletion)completionBlock;
- (void)downloadVenueCategoriesWithCompletionBlock:(RequestCompletion)completionBlock;
- (void)postBooking:(NSNumber *)venueId date:(NSString *)date number:(NSNumber *)number clientDesc:(NSString *)clientDesc phone:(NSString *)phone completion:(RequestCompletion)completionBlock;
- (void)updateBookingTracker:(NSNumber *)venueId completion:(RequestCompletion)completionBlock;
- (void)getBookingByID:(NSNumber *)bookingId completionBlock:(RequestCompletion)completionBlock;
- (void)shareReceivePoints:(RequestCompletion)completionBlock;

@end
