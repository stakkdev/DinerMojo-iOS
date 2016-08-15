//
//  DMTabBarViewController.h
//  DinerMojo
//
//  Created by hedgehog lab on 10/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMViewController.h"

@interface DMTabBarViewController : DMViewController <UITabBarControllerDelegate>

- (void)hideTabBar:(UITabBarController *) tabbarcontroller;
- (void)showTabBar:(UITabBarController *) tabbarcontroller;
- (void)presentAlertForLoginInstructions:(NSString *)instructions;
- (void)updateTabBarColor;

@end
