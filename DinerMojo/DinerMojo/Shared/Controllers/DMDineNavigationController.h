//
//  DMDineNavigationController.h
//  DinerMojo
//
//  Created by hedgehog lab on 03/07/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

@class DMDineNavigationController;

@protocol DMDineNavigationControllerControllerDelegate <NSObject>

@optional

- (void)readyToDismissCompletedDineNavigationController:(DMDineNavigationController *)dineNavigationController;
- (void)readyToDismissCancelledDineNavigationController:(DMDineNavigationController *)dineNavigationController;
- (void)readyToDismissCompletedDineNavigationController:(DMDineNavigationController *)dineNavigationController with:(UIViewController *)vc;

@end

@interface DMDineNavigationController : UINavigationController

@property (nonatomic, weak) id <DMDineNavigationControllerControllerDelegate> dineNavigationDelegate;

- (void)dineComplete;
- (void)dineCompleteWithVc:(UIViewController *)vc;
- (void)cancelPressed;

@end
