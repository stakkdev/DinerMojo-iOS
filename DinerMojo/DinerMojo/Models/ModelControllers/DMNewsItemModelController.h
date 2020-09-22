//
//  DMNewsItemModelController.h
//  DinerMojo
//
//  Created by hedgehog lab on 05/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMNewsRequest.h"
#import "DMSortVenueFeedViewController.h"

typedef NS_ENUM(NSInteger, DMNewsFeedState) {
    DMNewsFeedAll = 0,
    DMNewsFeedNews = 1,
    DMNewsFeedOffers = 2,
    DMNewsFeedRewards = 3,
    DMNewsFeedNone = 4,
    DMNewsFeedProdigal = 5
};

@interface DMNewsItemModelController : NSObject

@property (nonatomic) DMNewsFeedState newsFeedState;

@property (strong, nonatomic) NSMutableArray* allItems;
@property (strong, nonatomic) NSMutableArray* newsItems;
@property (strong, nonatomic) NSMutableArray* offersItems;

@property DMSortNewsfeedViewControllerSortItemType currentSortItemType;

@property (strong, nonatomic) NSMutableArray* currentDataSource;

@property (nonatomic) BOOL showFavourites;
@property (nonatomic, strong) NSArray *filters;

- (void)sortNewsFeedWithSortType:(DMSortNewsfeedViewControllerSortItemType)itemType;
- (void)refreshCurrentSource;


@end
