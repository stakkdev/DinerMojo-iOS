//
//  DMTransactionTimelineViewController.h
//  DinerMojo
//
//  Created by Carl Sanders on 12/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMViewController.h"
#import "DMTabBarViewController.h"


@interface DMTransactionTimelineViewController : DMTabBarViewController <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
