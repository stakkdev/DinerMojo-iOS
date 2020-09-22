//
//  DMLandingViewController.m
//  DinerMojo
//
//  Created by Carl Sanders on 01/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMLandingViewController.h"
#import "DMStartViewController.h"
#import <GBVersionTracking/GBVersionTracking.h>
#import "DinerMojo-Swift.h"

@interface DMLandingViewController ()

@end

@implementation DMLandingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self determineAppStart];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)determineAppStart
{
    if ([[self userRequest] isUserLoggedIn] == YES || [[self userRequest] hasUserSkipped] == YES)
    {
        [self goToVenues];
    }
    
    else
    {
        [self goToLandingPage];
    }
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIViewController *root = appDelegate.window.rootViewController;
    if([root isKindOfClass:UINavigationController.class]) {
        if([NSUserDefaults.standardUserDefaults boolForKey:@"showNotificationsOverlay"] && ![NSUserDefaults.standardUserDefaults boolForKey:@"shownNotificationsOverlay"]) {
            [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"shownNotificationsOverlay"];
            UINavigationController *nav = (UINavigationController *)root;
            if(nav.viewControllers.firstObject != NULL) {
                StartupNotificationsViewController *vc = [[StartupNotificationsViewController alloc] initWithNibName:@"StartupNotificationsViewController" bundle:NULL];
                vc.view.backgroundColor = [[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:0.95];
                vc.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
                [nav.viewControllers.firstObject.view addSubview:vc.view];
                [nav.viewControllers.firstObject addChildViewController:vc];
                [nav.viewControllers.firstObject didMoveToParentViewController:vc];
            }
        }
            /*if([GBVersionTracking isFirstLaunchForVersion]) {
                [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"showedOverlay"];
                UINavigationController *nav = (UINavigationController *)root;
                if(nav.viewControllers.firstObject != NULL) {
                    StartupViewController *vc = [[StartupViewController alloc] initWithNibName:@"StartupViewController" bundle:NULL];
                    vc.view.backgroundColor = [[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:0.95];
                    vc.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
                    [nav.viewControllers.firstObject.view addSubview:vc.view];
                    [nav.viewControllers.firstObject addChildViewController:vc];
                    [nav.viewControllers.firstObject didMoveToParentViewController:vc];
                }
            }*/
    }
}

@end
