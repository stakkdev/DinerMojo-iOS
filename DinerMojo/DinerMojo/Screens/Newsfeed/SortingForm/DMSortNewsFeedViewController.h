//
//  DMSortVenueFeedViewController.h
//  DinerMojo
//
//  Created by Carl Sanders on 29/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DMSortNewsFeedViewControllerDelegate <NSObject>
@optional

- (void)selectedFilterItems:(NSArray*)filterItems;

@end

@interface DMSortNewsFeedViewController : UIViewController

@property(nonatomic, weak) id <DMSortNewsFeedViewControllerDelegate> delegate;
@property (strong, nonatomic) NSArray *filterItems;

@property NSInteger selectedType;

- (IBAction)dismissView:(id)sender;

@end
