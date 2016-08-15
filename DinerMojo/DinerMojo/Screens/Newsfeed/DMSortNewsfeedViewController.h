//
//  DMSortNewsfeedViewController.h
//  DinerMojo
//
//  Created by Carl Sanders on 29/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DMSortNewsfeedViewControllerSortItemType) {
    DMSortNewsfeedViewControllerSortItemTypeNearestToMe = 0,
    DMSortNewsfeedViewControllerSortItemTypeMostRecent = 1,
    DMSortNewsfeedViewControllerSortItemTypeAtoZ = 2,
};


@class DMSortNewsfeedViewController;
@protocol DMSortNewsfeedViewControllerDelegate <NSObject>
@optional

- (void)sortNewsfeedViewController:(DMSortNewsfeedViewController *)sortNewsfeedViewController didSelectSortItem:(DMSortNewsfeedViewControllerSortItemType)itemType;
- (void)closeButtonPressedOnSortViewController:(DMSortNewsfeedViewController *)sortNewsfeedViewController;

@end

@interface DMSortNewsfeedViewController : UIViewController

@property (weak, nonatomic) IBOutlet DMButton *nearestToMeButton;
@property (weak, nonatomic) IBOutlet DMButton *mostRecentButton;
@property (weak, nonatomic) IBOutlet DMButton *restaurantAZButton;

@property (nonatomic, weak) id <DMSortNewsfeedViewControllerDelegate> delegate;

//@property (nonatomic, weak) id <CloseSortViewDelegate> closeDelegate;



- (IBAction)nearestToMeButton:(id)sender;
- (IBAction)mostRecentButton:(id)sender;
- (IBAction)restaurantAZButton:(id)sender;


@property (weak, nonatomic) IBOutlet UIImageView *nearestToMeSortCheckImage;
@property (weak, nonatomic) IBOutlet UIImageView *mostRecentSortCheckImage;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantAZSortCheckImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nearestToMeButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *restaurantAZButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mostRecentButtonConstraint;

@property NSInteger selectedType;

- (IBAction)dismissView:(id)sender;

@end
