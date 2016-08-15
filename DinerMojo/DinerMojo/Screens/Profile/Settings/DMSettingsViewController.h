 //
//  DMSettingsViewController.h
//  DinerMojo
//
//  Created by Carl Sanders on 12/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMViewController.h"
#import "DMTabBarViewController.h"
#import "DMWelcomeViewController.h"

@interface DMSettingsViewController : DMTabBarViewController <UITableViewDelegate, DMWelcomeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
