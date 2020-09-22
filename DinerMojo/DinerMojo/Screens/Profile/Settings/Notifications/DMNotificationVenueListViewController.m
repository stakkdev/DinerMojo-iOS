//
//  DMNotificationVenueListViewController.m
//  DinerMojo
//
//  Created by Mike Mikina on 5/2/17.
//  Copyright © 2017 hedgehog lab. All rights reserved.
//

#import "DMNotificationVenueListViewController.h"
#import "DinerMojo-Swift.h"
#import <PKHUD/PKHUD-Swift.h>

@interface DMNotificationVenueListViewController () <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *allButtonContainer;
@property (strong, nonatomic) DMRadioViewOption *allSectionHandler;
@property (strong, nonatomic) UIButton *selectAllButton;

@property(nonatomic, strong) TUGroupedTableManager *tableManager;
@property(nonatomic, strong) DMNotificationsVenueProvider *provider;
@property(nonatomic, strong) DMNotificationSelectionManager *seletionManager;
@end

@implementation DMNotificationVenueListViewController

    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [self setup];
}

- (void)setup {
    self.provider = [[DMNotificationsVenueProvider alloc] initWithSettings:self.subObject selectedNotificationsDining:self.notificationDinings selectedNotificationsLifestyle:self.notificationLifestyles];
    self.tableManager = [[TUGroupedTableManager alloc] initWithTableView:self.tableview reuseIDs:[self.provider reuseIDs]];
    self.tableManager.parent = self;
    self.tableManager.headersReuseIDs = @[@"DMNotificationVenueHeaderView"];
    self.tableManager.data = [self.provider preload];
    
    if([[SelectedNotificationsParser getSelectedWithDinings:self.notificationDinings lifestyles:self.notificationLifestyles] count] == ([self.notificationDinings count] + [self.notificationLifestyles count])) {
        [self.selectAllButton setSelected:YES];
    }
}

- (void)setupView {
    self.allSectionHandler = [DMRadioViewOption instanceFromNib];
    self.selectAllButton = [self.allSectionHandler setupViewWithParent:self.allButtonContainer title:NSLocalizedString(@"notifications.all", nil)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.delegate = self;
    [self.allButtonContainer addGestureRecognizer:tap];
}

- (IBAction)saveAction:(id)sender {
    NSString *name = NULL;
    for(DMOptionGroupItem *groupItem in self.tableManager.data) {
        for(DMVenuesNotificationItem *item in [groupItem groupData]) {
            for(int i = 0; i<self.notificationDinings.count; i++) {
                if(((SelectedNotificationsDining *)self.notificationDinings[i]).id == item.venue.primitiveModelID) {
                    ((SelectedNotificationsDining *)self.notificationDinings[i]).selected = item.isSelected;
                }
            }
            for(int i = 0; i<self.notificationLifestyles.count; i++) {
                if(((SelectedNotificationsLifestyle *)self.notificationLifestyles[i]).id == item.venue.primitiveModelID) {
                    ((SelectedNotificationsLifestyle *)self.notificationLifestyles[i]).selected = item.isSelected;
                }
            }
            
            if(item.isSelected) {
                if(name == NULL) {
                    name = item.venue.name;
                }
            }
        }
    }
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [self.delegate saveVenuesWithDinings:self.notificationDinings lifestyles:self.notificationLifestyles name:name changed:YES];
    }];
    [self.navigationController popViewControllerAnimated:YES];
    [CATransaction commit];
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    BOOL isSelected = self.selectAllButton.isSelected == true;
    [self.allSectionHandler setSelectedWithSelected: !isSelected];
    for(NSArray<TUGroupedTableViewData> *data in self.tableManager.data) {
        for(DMVenuesNotificationItem *item in data.groupData) {
            item.isSelected = !isSelected;
        }
    }
    self.tableManager.data = self.tableManager.data;
}
    
    

@end
