//
//  SubscriptionsObject.m
//  DinerMojo
//
//  Created by Mike Mikina on 5/1/17.
//  Copyright © 2017 hedgehog lab. All rights reserved.
//

#import "SubscriptionsObject.h"

@implementation SubscriptionsObject

+ (SubscriptionsObject *)createObjectFromDictionary:(NSDictionary *)dic {
    SubscriptionsObject *sub = [[SubscriptionsObject alloc] init];
    NSLog(@"Subscription object are: %@",dic);
    if([dic[@"my_favs_sub"] boolValue]) {
        sub.my_favs_sub = YES;
    }
    else {
        sub.my_favs_sub = NO;
    }
    
    if([dic[@"all_venues_sub"] boolValue]) {
        sub.all_venues_sub = YES;
    }
    else {
        sub.all_venues_sub = NO;
    }
    
    if([dic[@"dinermojo_sub"] boolValue]) {
        sub.dinermojo_sub = YES;
    }
    else {
        sub.dinermojo_sub = NO;
    }
    
    NSArray *array = dic[@"subscriptions"];
    sub.subscriptions = array;
    
    return sub;
}

@end
