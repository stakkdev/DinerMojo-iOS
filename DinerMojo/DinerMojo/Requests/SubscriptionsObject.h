//
//  SubscriptionsObject.h
//  DinerMojo
//
//  Created by Mike Mikina on 5/1/17.
//  Copyright © 2017 hedgehog lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubscriptionsObject : NSObject

@property (nonatomic, strong) NSArray *subscriptions;

@property (nonatomic) BOOL my_favs_sub;
@property (nonatomic) BOOL dinermojo_sub;
@property (nonatomic) BOOL all_venues_sub;


+ (SubscriptionsObject *)createObjectFromDictionary:(NSDictionary *)dic;

@end
