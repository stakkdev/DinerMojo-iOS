//
//  DMVenueModelController.h
//  DinerMojo
//
//  Created by hedgehog lab on 01/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

typedef NS_ENUM(NSInteger, DMVenueListState) {
    DMVenueListAll = 0,
    DMVenueMap = 1,
    DMVenueList = 2,
    DMVenueListNone = 3,
    DMVenueListFavourite = 4
};

@interface DMVenueModelController : NSObject

@property (strong, nonatomic) NSArray* venues;
@property (nonatomic) DMVenueListState state;
@property (nonatomic, strong) NSArray *filters;
@property BOOL filterLifestyle;

- (NSArray *)venuesForFilter;
@end
