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
#import "DMSortNewsfeedViewController.h"
#import "AppDelegate.h"

@interface DMNewsFeedViewController ()

@end

@implementation DMNewsFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self decorateInterface];
    _newsRequest = [DMNewsRequest new];
    _newsModelController = [DMNewsItemModelController new];
    
    if (self.isVenue)
    {
        [self newsButtonPressed:nil];
    }
    else
    {
        [self allButtonPressed:nil];
    }
    
    [self updateFavouriteFilterIconState];
    self.currentSortType = DMSortNewsfeedViewControllerSortItemTypeMostRecent;

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.activityIndicator startAnimating];

    self.pushNewsID = [[(AppDelegate *)[[UIApplication sharedApplication] delegate] notificationPayload] objectForKey:@"news_id"];
    
    if (self.isVenue)
    {
        [self.navigationItem setRightBarButtonItem:nil];
        [self.navigationItem setLeftBarButtonItem:nil];
        [self.navigationItem setTitle:self.selectedVenue.name];
        [self downloadVenueNews];
    }
    
    else
    {
        [self downloadNews];
    }
}

- (void)downloadVenueNews
{
    [self showZeroMessageStatus:NO];
    [self.emptyTableLabel setHidden:NO];
    [self.emptyTableLabel setText:@"Fetching news..."];
    
    [[self newsRequest] downloadVenueNewsWithCompletionBlock:^(NSError *error, id results) {
        if (error == nil)
        {
            [[self newsModelController] setAllItems:results];
        }
        
        else
        {
            [self.emptyTableLabel setHidden:NO];
            [self.emptyTableDescriptionView setHidden:NO];
            [self.emptyTableLabel setText:@"Can't fetch news. Check your connection"];
        }
        
        [self.activityIndicator stopAnimating];
        
        [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
        
    } withNewsType:[NSNumber numberWithInt:DMNewsFeedAll] withVenue:self.selectedVenue.modelID];
    
    
    [[self newsRequest] downloadVenueNewsWithCompletionBlock:^(NSError *error, id results) {
        if (error == nil)
        {
            [[self newsModelController] setNewsItems:results];
            [[self newsModelController] refreshCurrentSource];
            [UIView transitionWithView:self.tableView duration:0.35f options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void)
             {
                 [self.tableView reloadData];
             }completion: nil];
            
            if (self.newsModelController.newsItems.count == 0)
            {
                [self.tableView setHidden:YES];
            }
            [self updateZeroMessageStatus];
        }
        
    
    } withNewsType:[NSNumber numberWithInt:DMNewsFeedNews] withVenue:self.selectedVenue.modelID];
    
    
    [[self newsRequest] downloadVenueNewsWithCompletionBlock:^(NSError *error, id results) {
        if (error == nil)
        {
            [[self newsModelController] setOffersItems:results];
        }
        
    
    } withNewsType:[NSNumber numberWithInt:DMNewsFeedOffers] withVenue:self.selectedVenue.modelID];
}


- (void)downloadNews
{
    [self showZeroMessageStatus:NO];
    [self.emptyTableLabel setHidden:NO];
    [self.emptyTableLabel setText:@"Fetching news..."];
    
    
    [[self newsRequest] downloadNewsWithCompletionBlock:^(NSError *error, id results) {
        if (error == nil)
        {
            [[self newsModelController] setAllItems:results];
            [[self newsModelController] refreshCurrentSource];
            [[self newsModelController] sortNewsFeedWithSortType:self.currentSortType];
            [UIView transitionWithView:self.tableView duration:0.35f options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void)
             {
                 [self.tableView reloadData];
             } completion: nil];
            
            if (self.newsModelController.allItems.count == 0)
            {
                [self.tableView setHidden:YES];
                [self.emptyTableLabel setHidden:NO];
                [self.emptyTableDescriptionView setHidden:NO];
                [self.emptyTableLabel setText:@"There is no news at this time."];
            }
            
            [self updateZeroMessageStatus];
            
            if (self.pushNewsID)
            {
                self.selectedNewsItem = [DMUpdateItem MR_findFirstByAttribute:@"modelID" withValue:self.pushNewsID];
                self.pushNewsID = nil;
                AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
                appDelegate.notificationPayload = nil;
                
                [self performSegueWithIdentifier:@"newsDetailSegue" sender:nil];
            }
            

        }
        else
        {
            [self.emptyTableLabel setHidden:NO];
            [self.emptyTableDescriptionView setHidden:NO];
            [self.emptyTableLabel setText:@"Can't fetch news. Check your connection"];
            
            if (self.pushNewsID)
            {
                self.pushNewsID = nil;
                AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
                appDelegate.notificationPayload = nil;
            }


        }
        
        [self.activityIndicator stopAnimating];
        
        [self.tableView setSeparatorColor:[UIColor lightGrayColor]];

        
    } withNewsType:[NSNumber numberWithInt:DMNewsFeedAll]];
    
    [[self newsRequest] downloadNewsWithCompletionBlock:^(NSError *error, id results) {
        if (error == nil)
        {
            [[self newsModelController] setNewsItems:results];
            [[self newsModelController] sortNewsFeedWithSortType:self.currentSortType];

        }
        

    } withNewsType:[NSNumber numberWithInt:DMNewsFeedNews]];
    
    [[self newsRequest] downloadNewsWithCompletionBlock:^(NSError *error, id results) {
        if (error == nil)
        {
            [[self newsModelController] setOffersItems:results];
            [[self newsModelController] sortNewsFeedWithSortType:self.currentSortType];

        }
        
        
    } withNewsType:[NSNumber numberWithInt:DMNewsFeedOffers]];
}

- (void)decorateInterface
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"newsDetailSegue"])
    {
        DMNewsItemViewController *vc = segue.destinationViewController;
        vc.selectedItem = (DMNewsItem *) self.selectedNewsItem;
    }
}

#pragma mark - UITableView Delegates


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    self.selectedNewsItem = [[[self newsModelController] currentDataSource] objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"newsDetailSegue" sender:nil];
    cell.selected = NO;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DMNewsFeedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"DMNewsFeedTableViewCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    }
    
    DMNewsItem *newsItem = [[[self newsModelController] currentDataSource] objectAtIndex:indexPath.row];
    
    [[cell feedTitleLabel] setText:newsItem.title];
    [[cell feedStoryLabel] setText:newsItem.news_description];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d MMM ''yy"];
    [[cell feedDateLabel] setText:[dateFormat stringFromDate:newsItem.created_at]];
    DMVenue *venue = (DMVenue *) [newsItem venue];
    if (!self.isVenue)
    {
        [[cell feedVenueNameLabel] setText:venue.name];

    }
    
    [[cell cellImageView] setImage:nil];
    [[cell cellImageView] setBackgroundColor:[UIColor newsGrayColor]];
    
    UIImage *placeHolderImage;
    
    if ([newsItem.update_type isEqualToNumber:[NSNumber numberWithInt:DMNewsFeedNews]])
    {
        [cell.feedTitleLabel setTextColor:[UIColor newsColor]];
        placeHolderImage = [UIImage imageNamed:@"news_default"];
    }
    
    if ([newsItem.update_type isEqualToNumber:[NSNumber numberWithInt:DMNewsFeedOffers]])
        
    {
        [cell.feedTitleLabel setTextColor:[UIColor offersColor]];
        placeHolderImage = [UIImage imageNamed:@"offer_default"];
        
    }
    
    if (newsItem.thumb.length != 0)
    {
        NSURL *url = [NSURL URLWithString:[[self newsRequest] buildMediaURL:newsItem.thumb]];
        [[cell cellImageView] setImageWithURL:url placeholderImage:placeHolderImage];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self newsModelController] currentDataSource] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - Button presses

- (IBAction)allButtonPressed:(id)sender {
    
    [self.newsButton setBackgroundColor:[UIColor newsGrayColor]];
    [self.offersButton setBackgroundColor:[UIColor newsGrayColor]];
    [self.allButton setBackgroundColor:[UIColor newsColor]];
    [self setCurrentNewsType:DMNewsFeedAll];
    [self.tableView reloadData];
    [self updateZeroMessageStatus];
}

- (IBAction)newsButtonPressed:(id)sender
{
    [self.newsButton setBackgroundColor:[UIColor newsColor]];
    [self.offersButton setBackgroundColor:[UIColor newsGrayColor]];
    [self.allButton setBackgroundColor:[UIColor newsGrayColor]];
    [self setCurrentNewsType:DMNewsFeedNews];
    [self.tableView reloadData];
    [self updateZeroMessageStatus];
}

- (IBAction)offersButtonPressed:(id)sender
{
    [self.newsButton setBackgroundColor:[UIColor newsGrayColor]];
    [self.offersButton setBackgroundColor:[UIColor offersColor]];
    [self.allButton setBackgroundColor:[UIColor newsGrayColor]];
    [self setCurrentNewsType:DMNewsFeedOffers];
    [self.tableView reloadData];
    [self updateZeroMessageStatus];
}

- (IBAction)sortButtonPressed:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DMSortNewsfeedViewController *sortNewsFeedView = (DMSortNewsfeedViewController *) [storyboard instantiateViewControllerWithIdentifier:@"sortNewsFeedView"];
    [sortNewsFeedView setDelegate:self];
    [sortNewsFeedView setSelectedType:self.currentSortType];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:sortNewsFeedView];
    [navController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [navController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                                                      
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)setCurrentNewsType:(NSInteger)currentNewsType
{
    _currentNewsType = currentNewsType;
    [[self newsModelController] setNewsFeedState:_currentNewsType];
}

- (void)updateFavouriteFilterIconState
{
    [[[self navigationItem] rightBarButtonItem] setImage:([_newsModelController showFavourites] == YES) ? [UIImage imageNamed:@"favourite_active"] : [UIImage imageNamed:@"favourite_inactive"]];
}

- (IBAction)favouriteButtonPressed:(id)sender
{
    [_newsModelController setShowFavourites:![_newsModelController showFavourites]];
    
    [self updateFavouriteFilterIconState];
    
    [[self tableView] reloadData];
    
    [self updateZeroMessageStatus];
}

#pragma mark - DMSortNewsfeedViewControllerDelegte

- (void)sortNewsfeedViewController:(DMSortNewsfeedViewController *)sortNewsfeedViewController didSelectSortItem:(DMSortNewsfeedViewControllerSortItemType)itemType
{
    
    [[self newsModelController] sortNewsFeedWithSortType:itemType];
    self.currentSortType = itemType;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.tableView reloadData];

}

- (void)closeButtonPressedOnSortViewController:(DMSortNewsfeedViewController *)sortNewsfeedViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)titleForZeroStateMessage
{
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

- (NSString *)descriptionForZeroStateMessage
{
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

- (void)showZeroMessageStatus:(BOOL)show
{
    [[self emptyTableLabel] setHidden:!show];
    [[self emptyTableDescriptionView] setHidden:!show];
    [[self emptyTableLabel] setText:[self titleForZeroStateMessage]];
    [[self emptyTableDescriptionLabel] setText:[self descriptionForZeroStateMessage]];
    
    [[self tableView] setHidden:show];
}

- (void)updateZeroMessageStatus
{
    [self showZeroMessageStatus:[[[self newsModelController] currentDataSource] count] == 0];
}

- (IBAction)notifyMeButtonPressed:(id)sender;
{
    if ([[self userRequest] isUserLoggedIn] == YES)
    {
        [self performSegueWithIdentifier:@"newsNotifySegue" sender:nil];
    }
    else
    {
        [self presentAlertForLoginInstructions:@"You need to log in or sign up to access this feature."];
    }
}

@end
