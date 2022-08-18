//
//  DMTabBarViewController.m
//  DinerMojo
//
//  Created by hedgehog lab on 10/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMTabBarViewController.h"
#import "DMDineViewController.h"
#import "DMMapViewController.h"
#import "DMNewsFeedViewController.h"
#import "DMTabBarController.h"
#import "UIImage+Extensions.h"
#import "DinerMojo-Swift.h"
#import <GBVersionTracking/GBVersionTracking.h>

@interface DMTabBarViewController()
{
    
}

@end

@implementation DMTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[[self tabBarController] tabBar] setTintColor:[UIColor brandColor]];
    [[self tabBarController] setDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self updateNewsfeedBadge];
    [self checkIfShowNotificationsPopUp];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate checkBookingNotification];
}

- (void)checkIfShowNotificationsPopUp {
    if(![GBVersionTracking isFirstLaunchForVersion]) {
        [SGNotificationsSettings isPushNotificationsEnabledWithCompletion:^(BOOL enabled) {
            if (!enabled) {
                NSInteger numberOfTimesFired = [NSUserDefaults.standardUserDefaults integerForKey:@"turnOnNotificationPopUpFired"];
                if (numberOfTimesFired < 2) {
                    [self checkLastFiredDate];
                }
            }
        }];
    }
}

- (void)checkLastFiredDate {
    NSDate *lastDate = [NSUserDefaults.standardUserDefaults valueForKey:@"turnOnNotification"];
    if (lastDate != NULL) {
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                            fromDate:lastDate
                                                              toDate:[NSDate date]
                                                             options:0];
        if ([components day] > 14) {
            [self presentTurnOnNotificationsVC];
        }
        
    } else {
        [self presentTurnOnNotificationsVC];
    }
}

- (void)presentTurnOnNotificationsVC {
    TurnOnNotificationsViewController *vc = [[TurnOnNotificationsViewController alloc] initWithNibName:@"TurnOnNotificationsViewController" bundle:NULL];
    [vc setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [vc setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self presentViewController:vc animated:YES completion:NULL];
}

- (void)updateNewsfeedBadge {
    DMNewsRequest *newsRequest = [DMNewsRequest new];
    [newsRequest downloadNewsWithCompletionBlock:^(NSError *error, id results) {
        if (error == nil) {
            int unreadCount = 0;
            
            for (DMNewsItem *newsItem in results) {
                if (![newsItem isRead]) {
                    unreadCount += 1;
                }
            }
            UITabBarItem *item =  [[[self.tabBarController tabBar] items] objectAtIndex:2];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (unreadCount > 0) {
                    item.badgeValue = [NSString stringWithFormat:@"%d", unreadCount];
                    if ([[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending) {
                        item.badgeColor = [UIColor redColor];
                    }
                } else {
                    item.badgeValue = nil;
                }
            });
        }
    } withNewsType:@(DMNewsFeedAll)];
}

- (void)updateTabBarColor
{
    UITabBarController *tabController = self.tabBarController;
    
    NSInteger itemWidth = tabController.tabBar.frame.size.width / tabController.tabBar.items.count;
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(itemWidth * 2, 0, itemWidth, tabController.tabBar.frame.size.height)];
    
    UITabBarItem *item = [tabController.tabBar.items objectAtIndex:2];
    
    DMUser *currentUser = [[self userRequest] currentUser];
    UIColor *tintItemColor;
    tintItemColor = [UIColor whiteColor];
    DMUserMojoLevel currentUserMojoLevel = currentUser.mojoLevel;
    
    switch (currentUserMojoLevel) {
        case DMUserMojoLevelBlue:
            [backgroundView setBackgroundColor:[UIColor blueMainColor]];
            break;
        case DMUserMojoLevelSilver:
            [backgroundView setBackgroundColor:[UIColor silverMainColor]];
            tintItemColor = [UIColor darkGrayColor];
            
            break;
        case DMUserMojoLevelGold:
            [backgroundView setBackgroundColor:[UIColor goldMainColor]];
            break;
        case DMUserMojoLevelPlatinum:
            [backgroundView setBackgroundColor:[UIColor platinumMainColor]];
            break;
        default:
            break;
    }
    
    if (currentUser == nil)
    {
        [backgroundView setBackgroundColor:[UIColor clearColor]];
        tintItemColor = [UIColor darkGrayColor];
        
    }
    
    backgroundView.tag =  3;
    UIView *existingBackgroundView = [self.tabBarController.tabBar viewWithTag:3];
    [existingBackgroundView removeFromSuperview];
    
    
    
    UIImage *image = [[item.image imageWithTintedWithColor:tintItemColor] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.image = image;
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:tintItemColor, NSForegroundColorAttributeName, nil]  forState:UIControlStateNormal];
    
    
    [tabController.tabBar insertSubview:backgroundView atIndex:2];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tabBarController] setDelegate:self];
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(DMTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    UIViewController *destinationViewController = [self destinationViewControllerForSelectedTabBarViewController:viewController];
    
    BOOL isLoggedIn = [[self userRequest] isUserLoggedIn];
    
    if ([destinationViewController class] == [DMDineViewController class])
    {
        tabBarController.previousSelectedIndex = tabBarController.selectedIndex;
        
        if (isLoggedIn == YES)
        {
            CATransition *animation = [CATransition animation];
            [animation setType:kCATransitionFade];
            [animation setDuration:0.25];
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:
                                          kCAMediaTimingFunctionEaseIn]];
            [self.view.window.layer addAnimation:animation forKey:@"fadeTransition"];
            //            [self updateTabBarColor];
            
            
            [(DMDineViewController *)destinationViewController setInitialOffer:nil];
            
            return YES;
        }
        else
        {
            [self presentAlertForLoginInstructions:@"You need to log in or sign up to access this feature."];
            return NO;
            
        }
    }
    else
    {
        if ([destinationViewController class] == [DMMapViewController class] ||
            [destinationViewController class] == [DMNewsFeedViewController class])
        {
            return YES;
        }
        else
        {
            if (isLoggedIn == YES)
            {
                return YES;
            }
            else
            {
                [self presentAlertForLoginInstructions:@"You need to log in or sign up to access this feature."];
                return NO;
            }
        }
    }
}

#pragma mark - Launching Dine Scene

- (UIViewController *)destinationViewControllerForSelectedTabBarViewController:(UIViewController *)viewController
{
    if ([viewController class] == [UINavigationController class])
    {
        return [[(UINavigationController *)viewController viewControllers] objectAtIndex:0];
    }
    else
    {
        return viewController;
    }
}

- (void)animateDineController:(UINavigationController *)dineNavigationController onPresentingViewController:(UIViewController *)presentingViewController
{
    [dineNavigationController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [[presentingViewController tabBarController] presentViewController:dineNavigationController animated:YES completion:nil];
}


#pragma mark - AlertController For logged in features

- (void)presentAlertForLoginInstructions:(NSString *)instructions
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Login Required" message:instructions preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *login = [UIAlertAction actionWithTitle:@"Login / Sign up" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //[self.tabBarController setHidesBottomBarWhenPushed:YES];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *destinationViewController = [storyboard instantiateViewControllerWithIdentifier:@"landingNavigationController"];
        [self setRootViewController:destinationViewController animated:YES];
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:login];
    
    [alertController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)hideTabBar:(UITabBarController *) tabbarcontroller
{
    [UIView animateWithDuration:0.1 animations:^{
        UITabBar *tabBar = [tabbarcontroller tabBar];
        [tabBar setFrame:CGRectMake(CGRectGetMinX(tabBar.frame),
                                    CGRectGetMinY(tabBar.frame)+CGRectGetHeight(tabBar.frame),
                                    CGRectGetWidth(tabBar.frame),
                                    CGRectGetHeight(tabBar.frame))];
    }];
}

- (void)showTabBar:(UITabBarController *) tabbarcontroller
{
    [UIView animateWithDuration:0.1 animations:^{
        UITabBar *tabBar = [tabbarcontroller tabBar];
        [tabBar setFrame:CGRectMake(CGRectGetMinX(tabBar.frame),
                                    CGRectGetMinY(tabBar.frame)-CGRectGetHeight(tabBar.frame),
                                    CGRectGetWidth(tabBar.frame),
                                    CGRectGetHeight(tabBar.frame))];
    }];
    [self.navigationController setToolbarHidden:YES animated:YES];
    
}


@end

