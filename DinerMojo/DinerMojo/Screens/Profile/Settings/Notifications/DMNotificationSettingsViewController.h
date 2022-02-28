//
//  DMNotificationSettingsViewController.h
//  DinerMojo
//
//  Created by Carl Sanders on 12/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMTabBarViewController.h"

@protocol DMNotificationVenueDelegate;
@protocol LocationNotificationDelegate;

@interface DMNotificationSettingsViewController : DMTabBarViewController <DMNotificationVenueDelegate, UIAlertViewDelegate, LocationNotificationDelegate>

@property(strong, nonatomic) DMUserRequest *request;
@property(nonatomic, strong) IBOutlet UITableView *tableView;

- (IBAction)saveNotification:(id)sender;

@end
