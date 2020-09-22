//
//  DMNotificationVenueListViewController.h
//  DinerMojo
//
//  Created by Mike Mikina on 5/2/17.
//  Copyright © 2017 hedgehog lab. All rights reserved.
//

#import "DMTabBarViewController.h"
#import "SubscriptionsObject.h"
@class DMNotificationsVenueProvider;
@protocol DMNotificationVenueDelegate;
@interface DMNotificationVenueListViewController : DMTabBarViewController
@property (nonatomic, assign) UIViewController<DMNotificationVenueDelegate> *delegate;
@property(nonatomic, strong) NSArray *notificationLifestyles;
@property(nonatomic, strong) NSArray *notificationDinings;
@property(nonatomic, strong) SubscriptionsObject *subObject;
@end
