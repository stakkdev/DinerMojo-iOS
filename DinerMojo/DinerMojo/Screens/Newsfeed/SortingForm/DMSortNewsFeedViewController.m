//
//  DMSortVenueFeedViewController.m
//  DinerMojo
//
//  Created by Carl Sanders on 29/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMSortNewsFeedViewController.h"
#import "DinerMojo-Swift.h"
#import <PureLayout/PureLayout.h>


@interface DMSortNewsFeedViewController ()
@property(nonatomic, strong) DMSortNewsOptionsProvider *sortOptionProvider;
@property(weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic, strong) TUGroupedTableManager *tableViewManager;
@property(nonatomic, strong) DMSortSelectionManager <TUSortSelectionManagerProtocol> *selectionManager;

@end

@implementation DMSortNewsFeedViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
    [self.view layoutIfNeeded];
}

- (void)setup {
    self.selectionManager = [[DMSortSelectionManager alloc] init];
    self.sortOptionProvider = [[DMSortNewsOptionsProvider alloc] init];
    self.sortOptionProvider.filterItems = self.filterItems;
    
    self.tableViewManager = [[TUGroupedTableManager alloc] initWithTableView:self.tableview reuseIDs:self.sortOptionProvider.reuseIDs];
    self.tableViewManager.headersReuseIDs = @[@"TUHeaderOptionGroupView"];
    self.tableViewManager.data = self.sortOptionProvider.preload;
    
    self.tableViewManager.selectionManager = self.selectionManager;
    
    self.title = NSLocalizedString(@"sort.page.title", nil);
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

@end
