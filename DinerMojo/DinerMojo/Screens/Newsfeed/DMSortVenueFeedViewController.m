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

@interface DMSortVenueFeedViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) DMSortOptionsProvider *sortOptionProvider;
@property(weak, nonatomic) IBOutlet UITableView *generalOptionsTableView;
@property(weak, nonatomic) IBOutlet UITableView *restaurantCategoriesTableView;
@property(weak, nonatomic) IBOutlet UITableView *lifestyleCategoriesTableView;
@property(nonatomic, strong) TUGroupedTableManager *tableViewManager;
@property(nonatomic, strong) DMSortSelectionManager <TUSortSelectionManagerProtocol> *selectionManager;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationInfoSectionHeight;
@property (weak, nonatomic) IBOutlet UIView *locationInfoSection;
@property (strong, nonatomic) DMLocationInfoItemCell *infoItemView;
extern int locationInfoSectionOpenHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *generalOptionsTableHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *restaurantsTableViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lifestyleTableViewHeightConstrint;
@property (strong, nonatomic) IBOutlet UIButton *restaurantsCategoryButton;
@property (strong, nonatomic) IBOutlet UIButton *lifestyleCategoryButton;
@property (strong, nonatomic) IBOutlet UILabel *restaurantsLabel;
@property (strong, nonatomic) IBOutlet UILabel *lifestyleLabel;

@end

@implementation DMSortVenueFeedViewController

int locationInfoSectionOpenHeight = 151;
int restaurantTableViewTag = 1;
int lifestyleTableViewTag = 2;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self.view layoutIfNeeded];
}

- (void)viewDidLayoutSubviews {
    self.restaurantsTableViewHeightConstraint.constant = self.restaurantCategoriesTableView.contentSize.height;
    self.lifestyleTableViewHeightConstrint.constant = self.lifestyleCategoriesTableView.contentSize.height;
    self.generalOptionsTableHeightConstraint.constant = self.generalOptionsTableView.contentSize.height;
}

- (void)setup {
    self.selectionManager = [[DMSortSelectionManager alloc] init];
    self.sortOptionProvider = [[DMSortOptionsProvider alloc] init];
    self.sortOptionProvider.filterItems = self.filterItems;
    
    _restaurantCategories = [self.mapModelController restaurantCategories];
    _lifestyleCategories = [self.mapModelController lifestyleCategories];
    
    _selectedLifestyleCategories = [self.mapModelController getSelectedCategoriesForLifestyle];
    _selectedRestaurantCategories = [self.mapModelController getSelectedCategoriesForRestaurants];
    
    [self checkAllInTypeSelectedForRestaurants:YES];
    [self checkAllInTypeSelectedForRestaurants:NO];
    
    self.tableViewManager = [[TUGroupedTableManager alloc] initWithTableView:self.generalOptionsTableView reuseIDs:self.sortOptionProvider.reuseIDs];
    self.tableViewManager.headersReuseIDs = @[@"TUHeaderOptionGroupView"];
    self.tableViewManager.data = self.sortOptionProvider.preload;
    
    self.generalOptionsTableHeightConstraint.constant = self.generalOptionsTableView.contentSize.height;
    
    self.tableViewManager.selectionManager = self.selectionManager;
    [[self generalOptionsTableView] setRowHeight:41];
    
    self.title = NSLocalizedString(@"sort.page.title", nil);
    
    [self refreshLocationInfoSection];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshLocationInfoSection)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    // categories tables
    [self lifestyleCategoriesTableView].delegate = self;
    [self restaurantCategoriesTableView].delegate = self;
    
    [self lifestyleCategoriesTableView].dataSource = self;
    [self restaurantCategoriesTableView].dataSource = self;
    
    [self lifestyleCategoriesTableView].tag = lifestyleTableViewTag;
    [self restaurantCategoriesTableView].tag = restaurantTableViewTag;
    
    [[self lifestyleCategoriesTableView] registerNib: [UINib nibWithNibName:@"SimpleRadioTableViewCell" bundle:nil] forCellReuseIdentifier:@"SimpleRadioTableViewCell"];
    [[self restaurantCategoriesTableView] registerNib: [UINib nibWithNibName:@"SimpleRadioTableViewCell" bundle:nil] forCellReuseIdentifier:@"SimpleRadioTableViewCell"];
    
    
    [[self lifestyleCategoriesTableView] setRowHeight:41];
    [[self restaurantCategoriesTableView] setRowHeight:41];
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
    } else {
        self.locationInfoSectionHeight.constant = locationInfoSectionOpenHeight;
        [self setupMessageView];
    }
    [self.view updateConstraints];
    [self.generalOptionsTableView reloadData];
}


//- (void)informDelegateOfSelection:(DMSortNewsfeedViewControllerSortItemType)sortItemType {
//    if ([self delegate] != nil) {
//        if ([[self delegate] respondsToSelector:@selector(sortVenueFeedViewController:didSelectSortItem:)]) {
//            [[self delegate] sortVenueFeedViewController:self didSelectSortItem:sortItemType];
//        }
//    }
//}

- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)doneAction:(id)sender {
    NSArray *data = [self.tableViewManager getFilterData];
    NSMutableArray *completeData = [[NSMutableArray alloc]initWithArray:data];
    
    for (DMVenueCategory *category in _selectedRestaurantCategories) {
        FilterItem *item = [[FilterItem alloc] initWithGroupName:GroupsNameRestaurantsFilter itemId:category.modelID.integerValue value:0];
        [completeData addObject:item];
    }
    
    for (DMVenueCategory *category in _selectedLifestyleCategories) {
        FilterItem *item = [[FilterItem alloc] initWithGroupName:GroupsNameRestaurantsFilter itemId:category.modelID.integerValue value:0];
        [completeData addObject:item];
    }
    
    if ([self delegate] != nil) {
        if ([[self delegate] respondsToSelector:@selector(selectedFilterItems:)]) {
            [[self delegate] selectedFilterItems:completeData];
        }
    }
    
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - Categories toggle

- (IBAction)restaurantsButtonPressed:(id)sender {
    [self toggleTypeIsRestaurants:YES];
}
- (IBAction)lifestyleButtonPressed:(id)sender {
    [self toggleTypeIsRestaurants:NO];
}


- (void)toggleTypeIsRestaurants:(BOOL)isRestaurants {
    BOOL allSelected  = isRestaurants ? _allRestaurantsSelected : _allLifestyleSelected;
    NSArray *selectedCategories  = isRestaurants ? _selectedRestaurantCategories : _selectedLifestyleCategories;
    NSArray *allCategories  = isRestaurants ? _restaurantCategories : _lifestyleCategories;
    if (allSelected) {
        if (isRestaurants) {
            _selectedRestaurantCategories = [[NSMutableArray alloc] init];
        } else {
            _selectedLifestyleCategories = [[NSMutableArray alloc] init];
        }
    } else {
        for (DMVenueCategory *category in allCategories) {
            [self toggleCategory:category isRestaurants:isRestaurants to:YES];
        }
    }
    [self updateAllSelectedButtonTo:!allSelected isRestaurants:isRestaurants];
    if (isRestaurants) {
        [self.restaurantCategoriesTableView reloadData];
    } else {
        [self.lifestyleCategoriesTableView reloadData];
    }
}

-(void)toggleCategory:(DMVenueCategory *)category isRestaurants:(BOOL)isRestaurants to:(BOOL)enable {
    if (enable) {
        [self selectCategory:category isRestaurants:isRestaurants];
    } else {
        [self deselectCategory:category isRestaurants:isRestaurants];
    }
}

-(void)deselectCategory:(DMVenueCategory *)category isRestaurants:(BOOL)isRestaurants {
    NSArray *selectedCategories  = isRestaurants ? _selectedRestaurantCategories : _selectedLifestyleCategories;
    if ([selectedCategories containsObject:category]) {
        NSInteger index = [selectedCategories indexOfObject:category];
        if (isRestaurants) {
            [_selectedRestaurantCategories removeObjectAtIndex:index];
        } else {
            [_selectedLifestyleCategories removeObjectAtIndex:index];
        }
    }
}

-(void)selectCategory:(DMVenueCategory *)category isRestaurants:(BOOL)isRestaurants {
    NSArray *selectedCategories  = isRestaurants ? _selectedRestaurantCategories : _selectedLifestyleCategories;
    if (![selectedCategories containsObject:category]) {
        if (isRestaurants) {
            [_selectedRestaurantCategories addObject:category];
        } else {
            [_selectedLifestyleCategories addObject:category];
        }
    }
}

- (void)checkAllInTypeSelectedForRestaurants:(BOOL)isRestaurants {
    NSArray *allArr = isRestaurants ? _restaurantCategories : _lifestyleCategories;
    NSArray *selectedArr = isRestaurants ? _selectedRestaurantCategories : _selectedLifestyleCategories;
    BOOL currentAllSelected = isRestaurants ? _allRestaurantsSelected : _allLifestyleSelected;
    if (selectedArr.count == allArr.count && !currentAllSelected) {
        [self updateAllSelectedButtonTo:YES isRestaurants:isRestaurants];
    } else if (currentAllSelected) {
        [self updateAllSelectedButtonTo:NO isRestaurants:isRestaurants];
    }
}

- (void)updateAllSelectedButtonTo:(BOOL)allSelected isRestaurants:(BOOL)isRestaurants {
    
    UIImage *selectedImage = [UIImage imageNamed:@"SelectedCheckMark22"];
    UIImage *unselectedImage = [UIImage imageNamed:@"UnselectedCheckMark22"];
    
    if (isRestaurants) {
        [self.restaurantsCategoryButton setImage:allSelected ? selectedImage : unselectedImage forState:UIControlStateNormal];
        [_restaurantsLabel setHighlighted:allSelected];
        _allRestaurantsSelected = allSelected;
        if (allSelected) {
            self.restaurantsCategoryButton.imageView.image = [self.restaurantsCategoryButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [self.restaurantsCategoryButton setTintColor:[UIColor brandColor]];
        }
        
    } else {
        [self.lifestyleCategoryButton setImage:allSelected ? selectedImage : unselectedImage forState:UIControlStateNormal];
        [_lifestyleLabel setHighlighted:allSelected];
        _allLifestyleSelected = allSelected;
        if (allSelected) {
            self.lifestyleCategoryButton.imageView.image = [self.lifestyleCategoryButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [self.lifestyleCategoryButton setTintColor:[UIColor brandColor]];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Categories Table View Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isRestaurants = tableView.tag == restaurantTableViewTag;
    NSArray *selectedArr = isRestaurants ? _selectedRestaurantCategories : _selectedLifestyleCategories;
    NSArray *allArr = isRestaurants ? _restaurantCategories : _lifestyleCategories;
    DMVenueCategory *category = [allArr objectAtIndex:indexPath.row];
    BOOL isSelected = [selectedArr containsObject:category];
    [self toggleCategory:category isRestaurants:isRestaurants to:!isSelected];
    [self checkAllInTypeSelectedForRestaurants:isRestaurants];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == restaurantTableViewTag) {
        return _restaurantCategories.count;
    } else if (tableView.tag == lifestyleTableViewTag) {
        return _lifestyleCategories.count;
        return 0;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *categoryName = @"";
    BOOL enabled = NO;
    if (tableView.tag == restaurantTableViewTag) {
        DMVenueCategory *category = [_restaurantCategories objectAtIndex:indexPath.row];
        categoryName = category.name;
        enabled = [_selectedRestaurantCategories containsObject:category];
    } else if (tableView.tag == lifestyleTableViewTag) {
        DMVenueCategory *category = [_lifestyleCategories objectAtIndex:indexPath.row];
        categoryName = category.name;
        categoryName = [categoryName stringByReplacingOccurrencesOfString:@"L-" withString:@""];
        enabled = [_selectedLifestyleCategories containsObject:category];
    }
    SimpleRadioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"SimpleRadioTableViewCell"];
    [cell setupWith:categoryName and:enabled];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 41;
}


@end
