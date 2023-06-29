//
//  AppDelegate.h
//  DinerMojo
//
//  Created by hedgehog lab on 27/04/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "Reachability.h"
#import "DMOperationCompletePopUpViewController.h"

@import Firebase;

@interface AppDelegate : UIResponder <UIApplicationDelegate,FIRMessagingDelegate,UNUserNotificationCenterDelegate, DMOperationCompletePopUpViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, assign) BOOL isFromLaunch;
@property (strong, nonatomic) NSDictionary *notificationPayload;
- (void)checkBookingNotification;
- (void)showBookingNotificationWithUserInfo:(NSDictionary *)userInfo;
- (UIViewController*)topViewController;
- (void)registerPushNotificationMethod;

@end

