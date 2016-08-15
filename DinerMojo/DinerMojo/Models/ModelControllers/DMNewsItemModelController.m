//
//  DMNewsItemModelController.m
//  DinerMojo
//
//  Created by hedgehog lab on 05/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMNewsItemModelController.h"
#import "DMNewsItem.h"
#import "DMLocationServices.h"

@implementation DMNewsItemModelController

- (id)init
{
    self = [super init];
    if (self) {
        _newsFeedState = DMNewsFeedAll;
        _showFavourites = NO;
    }
    return self;
}

-(void)sortNewsFeedWithSortType:(DMSortNewsfeedViewControllerSortItemType)itemType
{
    _currentSortItemType = itemType;
    
    switch (_currentSortItemType) {
        case DMSortNewsfeedViewControllerSortItemTypeAtoZ:
            
            [_currentDataSource sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [[[(DMNewsItem *)obj1 venue] name] compare:[[(DMNewsItem *)obj2 venue] name]];
            }];

            break;
        case DMSortNewsfeedViewControllerSortItemTypeMostRecent:
            [_currentDataSource sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [[(DMNewsItem *)obj2 created_at] compare:[(DMNewsItem *)obj1 created_at]];
            }];
            break;
            
        case DMSortNewsfeedViewControllerSortItemTypeNearestToMe:
            _currentDataSource = [NSMutableArray arrayWithArray:[[self sortByLocationForData:_currentDataSource] mutableCopy]];
            break;
            
        default:
            break;
    }

}

- (NSArray *)sortByLocationForData:(NSArray *)data;
{
    return [data sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        
        DMVenue *place1 = (DMVenue *)[(DMNewsItem *) a venue];
        DMVenue *place2 = (DMVenue *)[(DMNewsItem *) b venue];
        
        DMLocationServices *locationServices = [DMLocationServices sharedInstance];
        
        CLLocationDistance aDistance = [locationServices userLocationDistanceFromLocation:[[CLLocation alloc] initWithLatitude:[[place1 latitude] doubleValue] longitude:[[place1 longitude] doubleValue]]];
        CLLocationDistance bDistance = [locationServices userLocationDistanceFromLocation:[[CLLocation alloc] initWithLatitude:[[place2 latitude] doubleValue] longitude:[[place2 longitude] doubleValue]]];
        
    
        
        return (aDistance > bDistance);
        
    }];
}

- (NSMutableArray *)favouritesForData:(NSArray *)data
{
    DMUser *currentUser = [[DMUserRequest new] currentUser];
    NSSet *favourites = [currentUser favourite_venues];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"venue IN %@", favourites];
    return [NSMutableArray arrayWithArray:[data filteredArrayUsingPredicate:predicate]];
}

- (void)setNewsFeedState:(DMNewsFeedState)newsFeedState
{
    _newsFeedState = newsFeedState;
    
    switch (_newsFeedState) {
        case DMNewsFeedNews:
            _currentDataSource = _newsItems;
            break;
        case DMNewsFeedOffers:
            _currentDataSource = _offersItems;
            break;
        default:
            _currentDataSource = _allItems;
    }
    
    if (_showFavourites == YES)
    {
        _currentDataSource = [self favouritesForData:_currentDataSource];
    }
    
    [self sortNewsFeedWithSortType:[self currentSortItemType]];
}

- (void)setShowFavourites:(BOOL)showFavourites
{
    _showFavourites = showFavourites;
    
    [self setNewsFeedState:_newsFeedState];
    
}

- (void)refreshCurrentSource
{
    [self setNewsFeedState:_newsFeedState];
}

@end