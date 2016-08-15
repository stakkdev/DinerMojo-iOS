//
//  AppDelegate.m
//  DinerMojo
//
//  Created by hedgehog lab on 27/04/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "AppDelegate.h"
#import "DMFacebookService.h"
#import "DMLocationServices.h"
#import "DMNewsFeedViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface AppDelegate ()

@end



@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self loadDatabase];
    [self decorateGlobalAppInterface];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:195.0];
    [[DMFacebookService sharedInstance] setPermissions:@[@"email", @"user_birthday"]];
    
    
    if (launchOptions != nil)
    {
        self.notificationPayload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    }
    
    [[DMUserRequest new] updateProfileEmailVerifificationDisplayed:NO];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ( application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground  )
    {
        self.notificationPayload = userInfo;
        NSLog(@"%@", self.notificationPayload);
    }
    else
    {
        NSDictionary *alert = [userInfo objectForKey:@"aps"];
        NSLog(@"%@", [alert objectForKey:@"alert"]);

    }
}

-(void) decorateGlobalAppInterface
{
    //UIStatusBar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self applyAppWideNavigationBackButton];
    
    //UINavigationBar
    [[UINavigationBar appearance] setBarTintColor:[UIColor navColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont navigationFont]
    
                                                            }];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont navigationBarButtonItemFont]
       }
     forState:UIControlStateNormal];

}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
{
    DMUserRequest *userRequest = [DMUserRequest new];
    
    [userRequest setDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
}


- (void)applyAppWideNavigationBackButton
{
    //UINavigationBar custom back button across app
    if ([[UINavigationBar class] instancesRespondToSelector:@selector(setBackIndicatorImage:)])
    {
        [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"BackNavIcon"];
        [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"BackNavIcon"];
        [UINavigationBar appearance].backItem.title = @" ";
    }
}


-(void)loadDatabase;
{
    [MagicalRecord setupAutoMigratingCoreDataStack];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[DMUserRequest new] updateProfileEmailVerifificationDisplayed:NO];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSDKAppEvents activateApp];
    
    [[DMLocationServices sharedInstance] startUpdatingCoordinates];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if ([self notificationPayload] != nil)
    {
        UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
        tabController.selectedIndex = 1;
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

@end
