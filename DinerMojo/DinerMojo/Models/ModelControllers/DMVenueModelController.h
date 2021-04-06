//
//  DMVenueModelController.h
//  DinerMojo
//
//  Created by hedgehog lab on 01/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

@import MapKit;

typedef NS_ENUM(NSInteger, DMVenueListState) {
    DMVenueListAll = 0,
    DMVenueMap = 1,
    DMVenueList = 2,
    DMVenueListNone = 3,
    DMVenueListFavourite = 4
};

@interface DMVenueModelController : NSObject

@property (strong, nonatomic) NSArray *venues;
@property (strong, nonatomic) NSArray *filteredVenues;
@property (strong, nonatomic) NSArray *mapAnnotations;
@property (nonatomic) DMVenueListState state;
@property (nonatomic, strong) NSArray *filters;
@property (nonatomic, strong) NSArray *selectedCategoriesIds;
@property (nonatomic, strong) NSArray *lifestyleCategories;
@property (nonatomic, strong) NSArray *restaurantCategories;
@property BOOL filterLifestyle;
@property BOOL filteringBySelectedLocation;

- (void)applyFilters:(NSArray *)filters sortBySelectedLocation:(BOOL)enabled;
- (void)updateCategories;
- (NSMutableArray *)getSelectedCategoriesForRestaurants;
- (NSMutableArray *)getSelectedCategoriesForLifestyle;

@end
