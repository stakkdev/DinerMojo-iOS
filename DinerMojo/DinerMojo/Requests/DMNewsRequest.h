//
//  DMNewsRequest.h
//  DinerMojo
//
//  Created by hedgehog lab on 01/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMRequest.h"

@interface DMNewsRequest : DMRequest

- (void)downloadNewsWithCompletionBlock:(RequestCompletion)completionBlock withNewsType:(NSNumber *) newsType;
- (void)downloadVenueNewsWithCompletionBlock:(RequestCompletion)completionBlock withNewsType:(NSNumber *) newsType withVenue:(NSNumber *) venueID;

@end
