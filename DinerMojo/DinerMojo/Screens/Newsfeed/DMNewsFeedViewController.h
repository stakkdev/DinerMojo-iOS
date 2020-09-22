//
//  DMNewsFeedViewController.h
//  DinerMojo
//
//  Created by hedgehog lab on 27/04/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMTabBarViewController.h"
#import "DMNewsItemModelController.h"
#import "DMNewsRequest.h"
#import "DMNewsItem.h"
#import "TabsFilterView.h"

@interface DMNewsFeedViewController : DMTabBarViewController <DMSortVenueFeedViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *emptyTableLabel;
@property (weak, nonatomic) IBOutlet UIView *emptyTableDescriptionView;
@property (weak, nonatomic) IBOutlet UILabel *emptyTableDescriptionLabel;


@property (strong, nonatomic) DMNewsRequest* newsRequest;
@property (strong, nonatomic) DMNewsItemModelController* newsModelController;
@property (strong, nonatomic) DMUpdateItem *selectedNewsItem;
@property (nonatomic) NSInteger currentNewsType;
@property NSInteger currentSortType;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property NSString* pushNewsID;
@property BOOL connectionProblem;

@property BOOL isVenue;
@property DMVenue *selectedVenue;

- (IBAction)sortButtonPressed:(id)sender;
- (IBAction)favouriteButtonPressed:(id)sender;
- (IBAction)notifyMe:(id)sender;


- (IBAction)notifyMeButtonPressed:(id)sender;

@end

