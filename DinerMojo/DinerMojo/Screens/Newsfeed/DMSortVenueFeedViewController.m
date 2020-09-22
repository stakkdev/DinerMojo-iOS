//
//  DMSortVenueFeedViewController.m
//  DinerMojo
//
//  Created by Carl Sanders on 29/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMSortVenueFeedViewController.h"
#import "DinerMojo-Swift.h"
#import "DMVenueCategory.h"
#import <PureLayout/PureLayout.h>
#import "DMLocationServices.h"

@interface DMSortVenueFeedViewController ()
@property(nonatomic, strong) DMSortOptionsProvider *sortOptionProvider;
@property(weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic, strong) TUGroupedTableManager *tableViewManager;
@property(nonatomic, strong) DMSortSelectionManager <TUSortSelectionManagerProtocol> *selectionManager;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationInfoSectionHeight;
@property (weak, nonatomic) IBOutlet UIView *locationInfoSection;
@property (strong, nonatomic) DMLocationInfoItemCell *infoItemView;
extern int locationInfoSectionOpenHeight;

@end

@implementation DMSortVenueFeedViewController

int locationInfoSectionOpenHeight = 151;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
    [self.view layoutIfNeeded];
}

- (void)setup {
    self.selectionManager = [[DMSortSelectionManager alloc] init];
    self.sortOptionProvider = [[DMSortOptionsProvider alloc] init];
    self.sortOptionProvider.filterItems = self.filterItems;
    

    
    self.sortOptionProvider.restaurantItems = [self fetchCategories];;

    self.tableViewManager = [[TUGroupedTableManager alloc] initWithTableView:self.tableview reuseIDs:self.sortOptionProvider.reuseIDs];
    self.tableViewManager.headersReuseIDs = @[@"TUHeaderOptionGroupView"];
    self.tableViewManager.data = self.sortOptionProvider.preload;
    
    self.tableViewManager.selectionManager = self.selectionManager;
    
    self.title = NSLocalizedString(@"sort.page.title", nil);
    
    [self refreshLocationInfoSection];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshLocationInfoSection)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (NSArray *)fetchCategories {
    NSArray *fetchedObjects;
    fetchedObjects = [self.mapModelController venuesForFilter];
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    
    for (DMVenue *venue in fetchedObjects) {
        for (DMVenueCategory *cat in [venue.categories allObjects]) {
            [categories addObject:cat];
            NSLog(@"venue name: %@ - %@", venue.name, cat.name);
        }
    }
    NSArray *fetchedCategories = [[NSSet setWithArray:categories] allObjects];
    
    return fetchedCategories;
}

- (void)setupMessageView {
    DMLocationInfoItemCell *view = [[[NSBundle mainBundle] loadNibNamed:@"DMLocationInfoItemCell" owner:self options:nil] firstObject];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.locationInfoSection addSubview:view];
    self.infoItemView = view;
    [self.infoItemView autoPinEdgesToSuperviewEdges];
}

- (void)refreshLocationInfoSection {
    if([[DMLocationServices sharedInstance] isLocationEnabled]) {
        [self.infoItemView removeFromSuperview];
        self.locationInfoSectionHeight.constant = 0;
    }
    else {
        self.locationInfoSectionHeight.constant = locationInfoSectionOpenHeight;
        [self setupMessageView];
    }
    [self.view updateConstraints];
    
    [self.tableview reloadData];
}

- (void)informDelegateOfSelection:(DMSortNewsfeedViewControllerSortItemType)sortItemType {
    if ([self delegate] != nil) {
        if ([[self delegate] respondsToSelector:@selector(sortVenueFeedViewController:didSelectSortItem:)]) {
            [[self delegate] sortVenueFeedViewController:self didSelectSortItem:sortItemType];
        }
    }
}

- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)doneAction:(id)sender {
    NSArray *data = [self.tableViewManager getFilterData];

    if ([self delegate] != nil) {
        if ([[self delegate] respondsToSelector:@selector(selectedFilterItems:)]) {
            [[self delegate] selectedFilterItems:data];
        }
    }

    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
