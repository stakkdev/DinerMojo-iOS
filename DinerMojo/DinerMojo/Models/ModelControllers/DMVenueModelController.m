//
//  DMVenueModelController.m
//  DinerMojo
//
//  Created by hedgehog lab on 01/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMVenueModelController.h"
#import "DMVenue.h"

@implementation DMVenueModelController

-(void)setVenues:(NSArray *)venues;
{
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"state" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, sortDescriptor2, nil];
    venues = [venues sortedArrayUsingDescriptors:sortDescriptors];
    
//    venues = [venues sortedArrayUsingComparator:^NSComparisonResult(DMVenue *obj1, DMVenue *obj2) {
//        return [[obj1 name] compare:[obj2 name]];
//    }];
//    
    
    _venues = venues;
}

@end
