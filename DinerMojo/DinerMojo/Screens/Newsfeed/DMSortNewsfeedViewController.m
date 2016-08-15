//
//  DMSortNewsfeedViewController.m
//  DinerMojo
//
//  Created by Carl Sanders on 29/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMSortNewsfeedViewController.h"
#import "DMNewsFeedViewController.h"


@interface DMSortNewsfeedViewController ()

@end

@implementation DMSortNewsfeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.selectedType)
    {
        case DMSortNewsfeedViewControllerSortItemTypeAtoZ:
            [self decorateRestaurantAZButton];
            break;
        case DMSortNewsfeedViewControllerSortItemTypeMostRecent:
            [self decorateMostRecentButton];
            
            break;
        case DMSortNewsfeedViewControllerSortItemTypeNearestToMe:
            [self decorateNearestToMeButton];
            break;
        default:
            break;
    }
    
    [self.view layoutIfNeeded];
}

- (void)informDelegateOfSelection:(DMSortNewsfeedViewControllerSortItemType)sortItemType
{
    if ([self delegate] != nil)
    {
        if ([[self delegate] respondsToSelector:@selector(sortNewsfeedViewController:didSelectSortItem:)])
        {
            [[self delegate] sortNewsfeedViewController:self didSelectSortItem:sortItemType];
        }
    }
}

- (void)decorateNearestToMeButton
{
    [self.nearestToMeButton setBackgroundColor:[UIColor navColor]];
    [self.mostRecentButton setBackgroundColor:[UIColor newsGrayColor]];
    [self.restaurantAZButton setBackgroundColor:[UIColor newsGrayColor]];
    
    [[self nearestToMeSortCheckImage] setAlpha:1.0];
    [[self mostRecentSortCheckImage] setAlpha:0.0];
    [[self restaurantAZSortCheckImage] setAlpha:0.0];
    
    self.nearestToMeButtonConstraint.constant = 57;
    self.mostRecentButtonConstraint.constant = 86;
    self.restaurantAZButtonConstraint.constant = 86;
}
- (IBAction)nearestToMeButton:(id)sender {
    
    [self decorateNearestToMeButton];

    [UIButton animateWithDuration:0.2
                       animations:^{
                           [self.view layoutIfNeeded];
                       }
                       completion:^(BOOL finished){
                           [self informDelegateOfSelection:DMSortNewsfeedViewControllerSortItemTypeNearestToMe];
                       }];
    
}

- (void)decorateMostRecentButton
{
    [self.mostRecentButton setBackgroundColor:[UIColor navColor]];
    [self.nearestToMeButton setBackgroundColor:[UIColor newsGrayColor]];
    [self.restaurantAZButton setBackgroundColor:[UIColor newsGrayColor]];
    
    [[self nearestToMeSortCheckImage] setAlpha:0.0];
    [[self mostRecentSortCheckImage] setAlpha:1.0];
    [[self restaurantAZSortCheckImage] setAlpha:0.0];
    
    self.mostRecentButtonConstraint.constant = 57;
    self.nearestToMeButtonConstraint.constant = 86;
    self.restaurantAZButtonConstraint.constant = 86;
}

- (IBAction)mostRecentButton:(id)sender {
    
    [self decorateMostRecentButton];
    
    [UIButton animateWithDuration:0.2
                       animations:^{
                           [self.view layoutIfNeeded];
                       }
                       completion:^(BOOL finished){
                           [self informDelegateOfSelection:DMSortNewsfeedViewControllerSortItemTypeMostRecent];
                           
                       }];
}

- (void)decorateRestaurantAZButton
{
    [self.restaurantAZButton setBackgroundColor:[UIColor navColor]];
    [self.nearestToMeButton setBackgroundColor:[UIColor newsGrayColor]];
    [self.mostRecentButton setBackgroundColor:[UIColor newsGrayColor]];
    
    [[self nearestToMeSortCheckImage] setAlpha:0.0];
    [[self mostRecentSortCheckImage] setAlpha:0.0];
    [[self restaurantAZSortCheckImage] setAlpha:1.0];
    
    self.restaurantAZButtonConstraint.constant = 57;
    self.mostRecentButtonConstraint.constant = 86;
    self.nearestToMeButtonConstraint.constant = 86;
    
}
- (IBAction)restaurantAZButton:(id)sender {
    
    [self decorateRestaurantAZButton];
    
    [UIButton animateWithDuration:0.2
                       animations:^{
                           [self.view layoutIfNeeded];
                       }
                       completion:^(BOOL finished){
                           [self informDelegateOfSelection:DMSortNewsfeedViewControllerSortItemTypeAtoZ];
                           
                       }];
}

- (IBAction)dismissView:(id)sender {
    
    if ([self delegate] != nil)
    {
        if ([[self delegate] respondsToSelector:@selector(closeButtonPressedOnSortViewController:)])
        {
            [[self delegate] closeButtonPressedOnSortViewController:self];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
