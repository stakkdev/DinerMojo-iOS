//
//  DMDineNavigationController.m
//  DinerMojo
//
//  Created by hedgehog lab on 03/07/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMDineNavigationController.h"

@interface DMDineNavigationController ()

@end

@implementation DMDineNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)dineComplete
{
    if ([self dineNavigationDelegate] != nil)
    {
        if ([[self dineNavigationDelegate] respondsToSelector:@selector(readyToDismissCompletedDineNavigationController:)])
        {
            [[self dineNavigationDelegate] readyToDismissCompletedDineNavigationController:self];
        }
    }
}

- (void)dineCompleteWithVc:(UIViewController *)vc
{
    if ([self dineNavigationDelegate] != nil)
    {
        if ([[self dineNavigationDelegate] respondsToSelector:@selector(readyToDismissCompletedDineNavigationController:with:)])
        {
            [[self dineNavigationDelegate] readyToDismissCompletedDineNavigationController:self with:vc];
        }
    }
}

- (void)cancelPressed
{
    if ([self dineNavigationDelegate] != nil)
    {
        if ([[self dineNavigationDelegate] respondsToSelector:@selector(readyToDismissCancelledDineNavigationController:)])
        {
            [[self dineNavigationDelegate] readyToDismissCancelledDineNavigationController:self];
        }
    }
}

@end
