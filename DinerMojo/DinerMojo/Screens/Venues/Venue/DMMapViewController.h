//
//  DMMapViewController.h
//  DinerMojo
//
//  Created by hedgehog lab on 27/04/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMTabBarViewController.h"
#import "DMLocationServices.h"

@interface DMMapViewController : DMTabBarViewController <UITableViewDataSource, UITableViewDelegate>{
    

IBOutlet UITableView *restaurantsTableView;
    
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;

@end

