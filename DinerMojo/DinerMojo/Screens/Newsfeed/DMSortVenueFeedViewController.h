//
//  DMSortVenueFeedViewController.h
//  DinerMojo
//
//  Created by Carl Sanders on 29/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMVenueModelController.h"
typedef NS_ENUM(NSInteger, DMSortNewsfeedViewControllerSortItemType) {
    DMSortNewsfeedViewControllerSortItemTypeNearestToMe = 0,
    DMSortNewsfeedViewControllerSortItemTypeMostRecent = 1,
    DMSortNewsfeedViewControllerSortItemTypeAtoZ = 2,
};


@class DMSortVenueFeedViewController;
@class DMSortByDistanceView;

@protocol DMSortVenueFeedViewControllerDelegate <NSObject>
@optional

- (void)sortVenueFeedViewController:(DMSortVenueFeedViewController *)sortVenueFeedViewController didSelectSortItem:(DMSortNewsfeedViewControllerSortItemType)itemType;

- (void)closeButtonPressedOnSortViewController:(DMSortVenueFeedViewController *)sortNewsfeedViewController;

- (void)selectedFilterItems:(NSArray*)filterItems;

@end

@interface DMSortVenueFeedViewController : UIViewController

@property(weak, nonatomic) IBOutlet UIView *sortViewContainer;
@property(strong, nonatomic) DMSortByDistanceView *sortView;

@property(strong, nonatomic) DMVenueModelController *mapModelController;
@property(nonatomic, weak) id <DMSortVenueFeedViewControllerDelegate> delegate;
@property (strong, nonatomic) NSArray *filterItems;

//@property (nonatomic, weak) id <CloseSortViewDelegate> closeDelegate;

@property NSInteger selectedType;

- (IBAction)dismissView:(id)sender;

@end
