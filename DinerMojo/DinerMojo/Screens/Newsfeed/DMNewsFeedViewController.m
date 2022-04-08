//
//  DMNewsFeedViewController.m
//  DinerMojo
//
//  Created by hedgehog lab on 27/04/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMNewsFeedViewController.h"
#import "DMNewsFeedTableViewCell.h"
#import "DMNewsItemViewController.h"
#import <PureLayout/PureLayout.h>
#import "DinerMojo-Swift.h"
#import "DMRestaurantInfoViewController.h"
#import <Crashlytics/Answers.h>

@interface DMNewsFeedViewController ()

@property (strong, nonatomic) NSArray *filterItems;
@property (strong, nonatomic) StateSerializer* serializer;

@end

@implementation DMNewsFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self decorateInterface];
    _newsRequest = [DMNewsRequest new];
    _newsModelController = [DMNewsItemModelController new];
    _serializer = [[StateSerializer alloc] init];
    
    self.currentSortType = DMSortNewsfeedViewControllerSortItemTypeMostRecent;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    NSArray *filterItems = [self.serializer restoreFilterState];
    if (filterItems == nil || filterItems.count == 0) {
        FilterItem *filterItem = [[FilterItem alloc]initWithGroupName:GroupsNameNewsShow itemId:ShowNewsGroupShowNewsItem value: YES];
        filterItems = @[filterItem];
    }
    
    [self selectedFilterItems:filterItems];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *navBarAppearance = [[UINavigationBarAppearance alloc] init];
        [navBarAppearance configureWithOpaqueBackground];
        navBarAppearance.backgroundColor = [UIColor colorWithRed:105.0f/255.0f green:201.0f/255.0f blue:179.0f/255.0f alpha:0.98f];
        [navBarAppearance setTitleTextAttributes:
         @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        self.navigationController.navigationBar.standardAppearance = navBarAppearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance;
    } else {
        
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [Answers logContentViewWithName:@"View newsfeed" contentType:@"" contentId:@"" customAttributes:@{}];
    
    [self.activityIndicator startAnimating];
    
    NSString *newsId = [(AppDelegate *) [[UIApplication sharedApplication] delegate] notificationPayload][@"news_id"];
    NSString *bookingId = [(AppDelegate *) [[UIApplication sharedApplication] delegate] notificationPayload][@"bookingID"];
    
    if (bookingId == NULL && newsId != NULL) {
        self.pushNewsID = newsId;
    }
    
    if (self.isVenue) {
        [self.navigationItem setRightBarButtonItem:nil];
        [self.navigationItem setLeftBarButtonItem:nil];
        [self.navigationItem setTitle:self.selectedVenue.name];
        [self downloadVenueNews];
    } else {
        [self downloadNews];
    }
    
    self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"newsfeed.title", nil);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    [self.view layoutSubviews];
//    [self.view layoutIfNeeded];
//    [self.navigationController.navigationBar setNeedsLayout];
//    [self.navigationController.navigationBar updateConstraintsIfNeeded];
//
    NSLog(@"Here contolers comes for UIView to check");
}

- (void)downloadVenueNews {
    [self showZeroMessageStatus:NO];
    [self.emptyTableLabel setHidden:NO];
    [self.emptyTableLabel setText:@"Fetching news..."];
    
    [[self newsRequest] downloadVenueNewsWithCompletionBlock:^(NSError *error, id results) {
        if (error == nil) {
            [[self newsModelController] setAllItems:results];
            [[self newsModelController] refreshCurrentSource];
            
            [UIView transitionWithView:self.tableView duration:0.35f options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void) {
                [self.tableView reloadData];
            }               completion:nil];
            
            [self updateZeroMessageStatus];
            
        } else {
            [self.emptyTableLabel setHidden:NO];
            [self.emptyTableDescriptionView setHidden:NO];
        }
        
        [self.activityIndicator stopAnimating];
        
        [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
        
    }                                           withNewsType:@(DMNewsFeedNews) withVenue:self.selectedVenue.modelID];
}


- (void)downloadNews {
    [self showZeroMessageStatus:NO];
    [self.emptyTableLabel setHidden:NO];
    [self.emptyTableLabel setText:@"Fetching news..."];
    
    
    [[self newsRequest] downloadNewsWithCompletionBlock:^(NSError *error, id results) {
        if (error == nil) {
            [[self newsModelController] setAllItems:results];
            [[self newsModelController] refreshCurrentSource];
            [[self newsModelController] sortNewsFeedWithSortType:(DMSortNewsfeedViewControllerSortItemType) self.currentSortType];
            [UIView transitionWithView:self.tableView duration:0.35f options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void) {
                [self.tableView reloadData];
            }               completion:nil];
            
            if (self.newsModelController.allItems.count == 0) {
                [self.tableView setHidden:YES];
                [self.emptyTableLabel setHidden:YES];
                [self.emptyTableDescriptionView setHidden:NO]; //0 venues
                self.connectionProblem = NO;
            }
            
            [self updateZeroMessageStatus];
            
            if (self.pushNewsID) {
                self.selectedNewsItem = [DMUpdateItem MR_findFirstByAttribute:@"modelID" withValue:self.pushNewsID];
                if (self.selectedNewsItem != NULL) {
                    [self performSegueWithIdentifier:@"newsDetailSegue" sender:nil];
                }
                
                self.pushNewsID = nil;
                AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
                appDelegate.notificationPayload = nil;
            }
        } else {
            [self.tableView setHidden:YES];
            [self.emptyTableLabel setHidden:NO]; //check internet
            [self.emptyTableDescriptionView setHidden:NO];
            self.connectionProblem = YES;
            [self.emptyTableLabel setText:@"Can't fetch news. Check your connection."];
            [self.emptyTableDescriptionLabel setText:@"Nothing to report now but we can notify you when there is"];
            if (self.pushNewsID) {
                self.pushNewsID = nil;
                AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
                appDelegate.notificationPayload = nil;
            }
            
            
        }
        
        [self.activityIndicator stopAnimating];
        
        [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
        
        
    }                                      withNewsType:@(DMNewsFeedAll)];
}

- (void)decorateInterface {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"newsDetailSegue"]) {
        DMNewsItemViewController *vc = segue.destinationViewController;
        [vc setSelectedItem:(DMNewsItem *) self.selectedNewsItem];
    }
    else if([segue.identifier isEqualToString:@"restaurantNewsInfoSegue"]) {
        [(DMRestaurantInfoViewController *)[segue destinationViewController] setSelectedVenue:sender];
    }
}

#pragma mark - UITableView Delegates


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //    self.selectedNewsItem = [[self newsModelController] currentDataSource][indexPath.row];
    
    //    [self performSegueWithIdentifier:@"newsDetailSegue" sender:nil];
    cell.selected = NO;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DMNewsFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"DMNewsFeedTableViewCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    }
    
    [cell setupActions];
    
    DMNewsItem *newsItem = [[self newsModelController] currentDataSource][indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.tapOnNewsCell = ^{
        newsItem.isRead = YES;
        weakSelf.selectedNewsItem = newsItem;
        [weakSelf performSegueWithIdentifier:@"newsDetailSegue" sender:nil];
    };
    
    cell.tapOnVenueIcon = ^{
        DMVenue *item = (DMVenue *) [newsItem venue];
        
        if (item != nil && [item.state integerValue] == DMVenueStateVerified)
        {
            [weakSelf performSegueWithIdentifier:@"restaurantNewsInfoSegue" sender:item];
        }
        else {
            weakSelf.selectedNewsItem = newsItem;
            [weakSelf performSegueWithIdentifier:@"newsDetailSegue" sender:nil];
        }
    };
    [[cell isReadView] setHidden:newsItem.isRead];
    [[cell feedTitleLabel] setText:newsItem.title];
    [[cell feedStoryLabel] setText:newsItem.news_description];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d MMM ''yy"];
    [[cell feedDateLabel] setText:[dateFormat stringFromDate:newsItem.created_at]];
    DMVenue *venue = (DMVenue *) [newsItem venue];
    if (!self.isVenue) {
        [[cell feedVenueNameLabel] setText:venue.name];
    }
    
    [[cell cellImageView] setImage:nil];
    [[cell cellImageView] setBackgroundColor:[UIColor newsGrayColor]];
    [cell.feedTitleLabel setTextColor:[UIColor newsColor]];
    
    if(newsItem.venue == nil) {
        UIImage *systemNews = [UIImage imageNamed:@"ic_launcher"];
        [[cell cellImageView] setImage:systemNews];
        [cell.offerIcon setHidden:YES];
    } else {
        UIImage *placeHolderImage = [UIImage imageNamed:@""];
        
        if ([newsItem.update_type isEqualToNumber:@(DMNewsFeedNews)]) {
            placeHolderImage = [UIImage imageNamed:@"news_default"];
            [cell.offerIcon setHidden:YES];
        } else if ([newsItem.update_type isEqualToNumber:@(DMNewsFeedOffers)] || [newsItem.update_type isEqualToNumber:@(DMNewsFeedRewards)]) {
            [cell.feedTitleLabel setTextColor:[UIColor offersColor]];
            placeHolderImage = [UIImage imageNamed:@"offer_default"];
            [cell.offerIcon setHidden:NO];
        } else if ([newsItem.update_type isEqualToNumber:@(DMNewsFeedProdigal)]) {
            placeHolderImage = [UIImage imageNamed:@"ic_launcher"];
            [cell.offerIcon setHidden:YES];
        }
        [[cell cellImageView] setImage:placeHolderImage];
        
        if (newsItem.thumb.length != 0) {
            NSURL *url = [NSURL URLWithString:[[self newsRequest] buildMediaURL:newsItem.thumb]];
            [[cell cellImageView] setImageWithURL:url placeholderImage:placeHolderImage];
        }
        
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self newsModelController] currentDataSource] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - Button presses

- (void)didSelectTabItem:(DMNewsFeedState)item {
    [self setCurrentNewsType:item];
    [self.tableView reloadData];
    [self updateZeroMessageStatus];
}

- (IBAction)sortButtonPressed:(id)sender {
    UINavigationController *vc = (UINavigationController*)DMViewControllersProvider.instance.sortNewsVC;
    
    if (vc.viewControllers.count > 0) {
        DMSortVenueFeedViewController *filterVC = vc.viewControllers[0];
        filterVC.delegate = self;
        filterVC.filterItems = self.filterItems;
    }
    
    [vc setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)setCurrentNewsType:(NSInteger)currentNewsType {
    _currentNewsType = currentNewsType;
    [[self newsModelController] setNewsFeedState:(DMNewsFeedState) _currentNewsType];
}

- (void)updateFavouriteFilterIconState {
    [[[self navigationItem] rightBarButtonItem] setImage:[_newsModelController showFavourites] ? [UIImage imageNamed:@"favourite_active"] : [UIImage imageNamed:@"favourite_inactive"]];
}

- (IBAction)favouriteButtonPressed:(id)sender {
    [_newsModelController setShowFavourites:![_newsModelController showFavourites]];
    
    [self updateFavouriteFilterIconState];
    
    [[self tableView] reloadData];
    
    [self updateZeroMessageStatus];
}

- (IBAction)notifyMe:(id)sender {
    if(![[self userRequest] isUserLoggedIn]) {
        [self performSegueWithIdentifier:@"startSegue" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"newsNotifySegue" sender:nil];
    }
}

#pragma mark - DMSortNewsfeedViewControllerDelegte

- (void)sortVenueFeedViewController:(DMSortVenueFeedViewController *)sortNewsfeedViewController didSelectSortItem:(DMSortNewsfeedViewControllerSortItemType)itemType {
    
    [[self newsModelController] sortNewsFeedWithSortType:itemType];
    self.currentSortType = itemType;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.tableView reloadData];
    
}

- (void)closeButtonPressedOnSortViewController:(DMSortVenueFeedViewController *)sortNewsfeedViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)titleForZeroStateMessage {
    switch (self.currentNewsType) {
        case DMNewsFeedNews:
            return @"There are no news items right now";
            break;
        case DMNewsFeedOffers:
            return @"There aren't any offers right now";
            break;
        default:
            return @"There are no news items or offers right now";
            break;
    }
}

- (NSString *)descriptionForZeroStateMessage {
    switch (self.currentNewsType) {
        case DMNewsFeedNews:
            return @"No news at the moment but there's bound to be some soon. We can let you know when there is.";
            break;
        case DMNewsFeedOffers:
            return @"No offers at the moment but there are bound to be some soon.  We can let you know when that happens.";
            break;
        default:
            return @"Nothing to report right now but we can notify you when there is";
            break;
    }
}

- (void)showZeroMessageStatus:(BOOL)show {
    [[self emptyTableLabel] setHidden:!show];
    [[self emptyTableDescriptionView] setHidden:!show];
    [[self emptyTableLabel] setText:[self titleForZeroStateMessage]];
    [[self emptyTableDescriptionLabel] setText:[self descriptionForZeroStateMessage]];
    
    [[self tableView] setHidden:show];
}

- (void)updateZeroMessageStatus {
    [self showZeroMessageStatus:[[[self newsModelController] currentDataSource] count] == 0];
}


- (void)selectedFilterItems:(NSArray *)filterItems {
    [self.serializer saveFilterStateWithItems:filterItems];
    self.filterItems = filterItems;
    _newsModelController.filters = filterItems;
    [[self newsModelController] refreshCurrentSource];
    [self.tableView reloadData];
    if([[self newsModelController] currentDataSource].count == 0) {
        
        [[self emptyTableLabel] setHidden:YES];
        [[self emptyTableDescriptionView] setHidden:NO];
        [[self emptyTableDescriptionLabel] setText:@"Nothing to report now but we can notify you when there is"];
        
        [[self tableView] setHidden:YES];
    }
}

@end
