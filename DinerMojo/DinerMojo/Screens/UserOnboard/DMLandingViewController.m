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
#import "UIImage+animatedGIF.h"
#import <ImageIO/ImageIO.h>

@interface DMLandingViewController () {
    // LOTAnimationView * animation;
}
@end

@implementation DMLandingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self determineAppStart];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadAnimation];
}


-(void) loadAnimation {
    [self.launchAnimationView setHidden:NO];
    [self.view bringSubviewToFront:self.launchAnimationView];
    
    //textAnimation
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Text_IAnimation" withExtension:@"gif"];
    self.textImageView.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
    self.textImageView.animationRepeatCount = 1;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self determineAppStart];
        [self.launchAnimationView setHidden:YES];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)determineAppStart
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (appDelegate.isFromLaunch == YES) {
            [[DMLocationServices sharedInstance] startUpdatingCoordinates];
            appDelegate.isFromLaunch = NO;
        }
        [appDelegate registerPushNotificationMethod];
    });

    
    if ([[self userRequest] isUserLoggedIn] == YES || [[self userRequest] hasUserSkipped] == YES)
    {
        [self goToVenues:YES];
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
