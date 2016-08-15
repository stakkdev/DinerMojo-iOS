//
//  DMVenueRequest.h
//  DinerMojo
//
//  Created by hedgehog lab on 01/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMRequest.h"

@interface DMVenueRequest : DMRequest

-(void)downloadVenuesWithCompletionBlock:(RequestCompletion)completionBlock;
- (void)downloadLiveVenuesWithCompletionBlock:(RequestCompletion)completionBlock;

@end
