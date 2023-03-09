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
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "DinerMojo-Swift.h"
#import "DMVenueCategory.h"
#import <GBVersionTracking/GBVersionTracking.h>
#import <UserNotifications/UserNotifications.h>
#import "Reachability.h"

@import UserNotifications;
@import GooglePlaces;

@interface AppDelegate ()
@property(nonatomic, retain) Reachability* reach;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self loadDatabase];
    [self decorateGlobalAppInterface];
    [GBVersionTracking track];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:195.0];
    [[DMFacebookService sharedInstance] setPermissions:@[@"public_profile", @"email"]];
    
    [FIRApp configure];
    [FIRMessaging messaging].delegate = self;
    
    if (launchOptions != nil)
    {
        self.notificationPayload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    }
    
    [[DMUserRequest new] updateProfileEmailVerifificationDisplayed:NO];
    [self checkIfUserLoggedIn];
    
    [self swiftApplication:application didFinishLaunchingWithOptions:launchOptions];
    [NSUserDefaults.standardUserDefaults setBool:NO forKey:@"didShowGDPR"];
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:200 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    [GMSPlacesClient provideAPIKey: @"AIzaSyDsbxrDudbltwXMI94slV9C_h7-s8kYNBI"];//Secrets.googlePlacesApiKey
    
    // User Registration process
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if( !error ) {
            // required to get the app to do anything at all about push notifications
            dispatch_async(dispatch_get_main_queue(), ^{
                // use weakSelf here
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            });
            NSLog( @"Push registration success." );
        } else {
            NSLog( @"Push registration FAILED" );
            NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
            NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );
        }
    }];
    
    //[self initializeReachbility];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (void)initializeReachbility {
    // Allocate a reachability object
    self.reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Tell the reachability that we DON'T want to be reachable on 3G/EDGE/CDMA
    self.reach.reachableOnWWAN = NO;
    
    // Here we set up a NSNotification observer. The Reachability that caused the notification
    // is passed in the object parameter
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [self.reach startNotifier];
}

/*
- (void)reachabilityChanged:(NSNotification*)notification {
    Reachability* reachability = notification.object;
    
    if(reachability.currentReachabilityStatus == NotReachable) {
        NSLog(@"Internet off");
        UIViewController *test = [self topViewController];
        if ([test isKindOfClass:[DMOperationCompletePopUpViewController class]]) {
            NSLog(@"Already present");
            return;
        }
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DMOperationCompletePopUpViewController *testVC = [storyboard instantiateViewControllerWithIdentifier:@"operationComplete"];
        
        [testVC setColor:[UIColor colorWithRed:(245/255.f) green:(147/255.f) blue:(54/255.f) alpha:1]];
        [testVC setStatus:DMOperationCompletePopUpViewControllerStatusError];
        [testVC setPopUpDescriptionAttributed:[[NSMutableAttributedString alloc] initWithString:@"Something wrong with your connection. Plesae try again"]];
        [testVC setPopUpTitle:@"Oops.."];
        [testVC setActionButtonTitle:@"Go to settings"];
        [testVC setEffectStyle:UIBlurEffectStyleExtraLight];
        [testVC setModalPresentationStyle:UIModalPresentationOverFullScreen];
        [testVC setShoulHideDontShowAgainButton:YES];
        [testVC setDelegate: self];
        [testVC setModalPresentationStyle:UIModalPresentationOverFullScreen];
        if([self.window.rootViewController isKindOfClass:UITabBarController.class]) {
            [[(UITabBarController *)self.window.rootViewController selectedViewController] presentViewController:testVC animated:YES completion:NULL];
        } else {
            [self.window makeKeyAndVisible];
            [self.window.rootViewController presentViewController:testVC animated:YES completion:NULL];
        }
    } else {
        NSLog(@"Internet on");
        UIViewController *test = [self topViewController];
        if ([test isKindOfClass:[DMOperationCompletePopUpViewController class]]) {
            [test dismissViewControllerAnimated:false completion:nil];
        }
    }
}*/

-(void)actionButtonPressedFromOperationCompletePopupViewController:(DMOperationCompletePopUpViewController *)operationCompletePopupViewController {
    //NSLog(@"Here button is taaped");
     if ([[operationCompletePopupViewController actionButtonTitle] isEqualToString:@"Go to settings"]) {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
                                                    options:@{}
                                          completionHandler:^(BOOL success) {
                 }];
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

- (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

-(UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [NSUserDefaults.standardUserDefaults setObject:userInfo forKey:@"notification"];
    NSInteger count = [NSUserDefaults.standardUserDefaults integerForKey:@"numberOfNotifications"] + 1;
    [NSUserDefaults.standardUserDefaults setInteger:(count) forKey:@"numberOfNotifications"];
    if ( application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground  )
    {
        self.notificationPayload = userInfo;
        //NSLog(@"%@", self.notificationPayload);
        if(count == 3) {
            [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"showNotificationsOverlay"];
        }
    }
    else
    {
        NSDictionary *alert = [userInfo objectForKey:@"aps"];
        //NSLog(@"%@", [alert objectForKey:@"alert"]);
        if(count == 3) {
            [self showNotificationOverlay];
        }
    }
    
    [self showBookingNotificationWithUserInfo:userInfo];
    [self showNewsNotificationIfNeeded];
//    [self application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:^(UIBackgroundFetchResult result) {
//    }];
}

-(void)registerForNotifications
{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
        if(!error){
            dispatch_async(dispatch_get_main_queue(), ^{
                // use weakSelf here
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            });
        }
    }];
}

- (NSString *)getFormattedStringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy.MM.dd";
    return [formatter stringFromDate:date];
}

- (NSDate *)getFormatedDateFromString:(NSString *)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [formatter setLocale:enUSPOSIXLocale];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    [formatter setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
    return [formatter dateFromString:string];
}

-(void)checkBookingNotification {
    [self showBookingNotificationWithUserInfo:self.notificationPayload];
    [self showNewsNotificationIfNeeded];
}

- (void)showBookingNotificationWithUserInfo:(NSDictionary *)userInfo {
    if([self.window.rootViewController isKindOfClass:UITabBarController.class]) {
        DMVenueRequest *venueRequest = [DMVenueRequest new];
        if (userInfo != nil) {
            if (userInfo[@"bookingID"] != nil) {
                NSNumber *bookingId = userInfo[@"bookingID"];
                [venueRequest getBookingByID:[[NSNumber alloc] initWithInt:[bookingId intValue]] completionBlock:^(NSError *error, id results) {
                    self.notificationPayload = nil;
                    
                    if ([results isKindOfClass:[NSArray class]]) {
                        NSArray *result = (NSArray *)results;
                        
                        if ([result count] > 0) {
                            NSNumber *people = (NSNumber *)[result valueForKey:@"people"][0];
                            NSString *booking_timestamp = (NSString *)[result valueForKey:@"booking_timestamp"][0];
                            
                            NSDate *bookingDate = [self getFormatedDateFromString:booking_timestamp];
                            NSCalendar *calendar = [NSCalendar currentCalendar];
                            NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:bookingDate];
                            NSString *time = [NSString stringWithFormat:@"%ld:%02ld",(long)[dateComponents hour], (long)[dateComponents minute]];
                            NSString *shortDate = [self getFormattedStringFromDate:bookingDate];
                            NSArray *venue = [result valueForKey:@"venue"];
                            NSString *venue_name = (NSString *)[venue valueForKey:@"name"][0];
                            NSString *peopleString;
                            
                            if ([people integerValue] == 1) {
                                peopleString = @"person";
                            } else {
                                peopleString = @"people";
                            }
                            
                            NSString *fullDesc = [NSString stringWithFormat:@"Your booking at %@ at %@ on %@ for %ld %@ was confirmed by venue", venue_name, time, shortDate, (long)[people integerValue], peopleString];
                            
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            DMOperationCompletePopUpViewController *testVC = [storyboard instantiateViewControllerWithIdentifier:@"operationComplete"];
                            
                            [testVC setColor:[UIColor colorWithRed:(245/255.f) green:(147/255.f) blue:(54/255.f) alpha:1]];
                            [testVC setStatus:DMOperationCompletePopUpViewControllerStatusSuccess];
                            [[testVC actionButton] setHidden:YES];
                            [testVC setPopUpDescriptionAttributed:[[NSMutableAttributedString alloc] initWithString:fullDesc]];
                            [testVC setPopUpTitle:@"Booking Update"];
                            [testVC setEffectStyle:UIBlurEffectStyleExtraLight];
                            [testVC setModalPresentationStyle:UIModalPresentationOverFullScreen];
                            [testVC setShoulHideDontShowAgainButton:YES];
                            [testVC setModalPresentationStyle:UIModalPresentationOverFullScreen];
                            [[(UITabBarController *)self.window.rootViewController selectedViewController] presentViewController:testVC animated:YES completion:NULL];
                        }
                    }
                }];
            }
        }
    } else {
        if (userInfo != nil) {
            self.notificationPayload = userInfo;
        }
    }
}

-(void)showNotificationOverlay {
    if([self.window.rootViewController isKindOfClass:UITabBarController.class]) {
        StartupNotificationsViewController *vc = [[StartupNotificationsViewController alloc] initWithNibName:@"StartupNotificationsViewController" bundle:NULL];
        [vc setModalPresentationStyle:UIModalPresentationFullScreen];
        [[(UITabBarController *)self.window.rootViewController selectedViewController] presentViewController:vc animated:YES completion:NULL];
    } else {
        [NSUserDefaults.standardUserDefaults setInteger: 2 forKey:@"numberOfNotifications"];
    }
}

-(void) decorateGlobalAppInterface
{
    [self applyAppWideNavigationBackButton];
    
    //UINavigationBar
    [[UINavigationBar appearance] setBarTintColor:[UIColor navColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
        NSForegroundColorAttributeName: [UIColor whiteColor],
        NSFontAttributeName: [UIFont navigationFont]
    }];
    
    NSArray *array = [NSArray arrayWithObject:[UINavigationBar class]];
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:array]
     setTitleTextAttributes:
         @{NSForegroundColorAttributeName:[UIColor whiteColor],
           NSFontAttributeName:[UIFont navigationBarButtonItemFont]
         }
     forState:UIControlStateNormal];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //NSString *fcmToken = [[FIRInstanceID instanceID] token];
    
    
    //DMUserRequest *userRequest = [DMUserRequest new];
    //const unsigned *tokenBytes = [deviceToken bytes];
    //NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
    //                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
    //                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
    //                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    // [userRequest setDeviceToken:hexToken];
    [FIRMessaging messaging].APNSToken = deviceToken;
    //  Messaging.messaging().apnsToken = deviceToken
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to register for PUSH: %@", error.description);
}


- (void)applyAppWideNavigationBackButton
{
    // UINavigationBar custom back button across app
    if ([[UINavigationBar class] instancesRespondToSelector:@selector(setBackIndicatorImage:)])
    {
        [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"BackNavIcon"];
        [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"BackNavIcon"];
        [UINavigationBar appearance].backItem.title = @" ";
    }
}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
    // Notify about received token.
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
    [[NSNotificationCenter defaultCenter] postNotificationName:
     @"FCMToken" object:nil userInfo:dataDict];
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
    
    DMUserRequest *userRequest = [DMUserRequest new];
    // const unsigned *tokenBytes = [deviceToken bytes];
    //    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
    //                   ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
    //                 ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
    //                  ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    [userRequest setDeviceToken:fcmToken];
}
//// [END refresh_token]



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
    
    [self showNewsNotificationIfNeeded];
    
    if ([NSUserDefaults.standardUserDefaults boolForKey:@"showNotificationsOverlay"]) {
        [NSUserDefaults.standardUserDefaults setBool:NO forKey:@"showNotificationsOverlay"];
        [self showNotificationOverlay];
    }
}

- (void)checkIfUserLoggedIn {
    DMUserRequest *userRequest = [DMUserRequest new];
    if ([userRequest isUserLoggedIn] == YES ) {
        [self registerForNotifications];
    }
}

- (void)showNewsNotificationIfNeeded {
    if ([self notificationPayload] != nil && [self.window.rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
        if(self.notificationPayload[@"news_id"] != NULL && self.notificationPayload[@"bookingID"] == NULL) {
            NSLog(@"Notification tab selected:");
            if (tabController.selectedIndex == 2) {
                NSLog(@"Notification tab 2 tab existed selected:");
                tabController.selectedIndex = 1;
            }
            tabController.selectedIndex = 2;
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
    ];
    // Add any custom logic here.
    return handled;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return [[FBSDKApplicationDelegate sharedInstance] application: app
                                                          openURL: url
                                                          options: options];
}

- (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken {
    NSLog(@"The Token is: %@", fcmToken);
    [[NSUserDefaults standardUserDefaults] setObject:fcmToken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"User Info willPresentNotification : %@",notification.request.content.userInfo);
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

//Called to let your app know which action was selected by the user for a given notification.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler{
    NSLog(@"User Info didReceiveNotificationResponse : %@", response.notification.request.content.userInfo);
    self.notificationPayload = response.notification.request.content.userInfo;
    [self showNewsNotificationIfNeeded];
    completionHandler();
}
@end


