//
//  AppDelegate.h
//  DinerMojo
//
//  Created by hedgehog lab on 27/04/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Firebase;

@interface AppDelegate : UIResponder <UIApplicationDelegate,FIRMessagingDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDictionary *notificationPayload;
- (void)checkBookingNotification;
- (void)showBookingNotificationWithUserInfo:(NSDictionary *)userInfo;

@end

