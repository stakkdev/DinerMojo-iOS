//
//  DMFavouritesViewController.h
//  DinerMojo
//
//  Created by Carl Sanders on 06/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMTabBarViewController.h"
#import "DMBase.h"


@interface DMFavouritesViewController : DMTabBarViewController  <UITableViewDataSource, UITableViewDelegate>{
}

@property (weak, nonatomic) IBOutlet UITableView *favouritesTableView;


@end
