//
//  DMNotificationSettingsViewController.m
//  DinerMojo
//
//  Created by Carl Sanders on 12/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMNotificationSettingsViewController.h"
#import "DinerMojo-Swift.h"
#import "SubscriptionsObject.h"
#import "DMNotificationVenueListViewController.h"
#import <PKHUD/PKHUD-Swift.h>
#import <PureLayout/PureLayout.h>
#import <Crashlytics/Answers.h>

@interface DMNotificationSettingsViewController ()

@property NSInteger notificationFilter;
@property NSInteger notificationFrequency;

@property(nonatomic, strong) TUGroupedTableManager *tableManager;
@property(nonatomic, strong) DMNotificationsSettingsProvider *provider;
@property(nonatomic, strong) DMNotificationSelectionManager *seletionManager;
@property(nonatomic, strong) NSArray *ids;
@property(nonatomic, strong) NSArray *notificationLifestyles;
@property(nonatomic, strong) NSArray *notificationDinings;
@property(nonatomic, strong) SubscriptionsObject *subObject;
@property(nonatomic, strong) NSDictionary *setupDict;
@property(nonatomic, strong) LocationNotification *locationData;

@property BOOL changed_ids;
@property BOOL didEndDownloads;
@end

@implementation DMNotificationSettingsViewController 

@synthesize locationData;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_arrow_grey"] style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = back;
    [PKHUD sharedHUDObjc].contentViewObjc = [[PKHUDProgressView alloc] initWithTitle:@"" sub:@""];
    [self.tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
    [[PKHUD sharedHUDObjc] showOnView:self.view];
    __weak typeof(self) weakSelf = self;
    
//    [[self userRequest] downloadUserProfileWithCompletionBlock:^(NSError *error, id results) {
//        if (error) {
//            [weakSelf showErrorMessage];
//            [self didEndDownloading];
//        } else {
//            [weakSelf downloadSubscriptions];
//        }
//    }];
    
    [[self userRequest] downloadUserProfileResponseWithCompletionBlock:^(NSError *error, id results, id response) {
        if (error) {
            [weakSelf showErrorMessage];
            [self didEndDownloading];
        } else {
            BOOL isFavNoti = YES;
            if (![response[@"is_favourite_venues_notification"]  isKindOfClass:[NSNull class]]) {
                if ([response[@"is_favourite_venues_notification"] boolValue] == NO) {
                    isFavNoti = NO;
                } else {
                    isFavNoti = YES;
                }
//                isFavNoti = response[@"is_favourite_venues_notification"];
            }
            NSNumber * lati = 0;
            if (![response[@"latitude"] isKindOfClass:[NSNull class]]) {
                lati = response[@"latitude"];
            }
            NSNumber * longi = 0;
            if (![response[@"longitude"]  isKindOfClass:[NSNull class]]) {
                longi = response[@"longitude"];
            }
            
            NSString * locName = @"";
            if (![response[@"location_name"]  isKindOfClass:[NSNull class]]) {
                locName = response[@"location_name"];
            }
            self.locationData = [[LocationNotification alloc] initWithLocationName:locName latitude:lati longitude:longi isFavouriteVenuesNotification:isFavNoti];
            [weakSelf downloadSubscriptions];
        }
    }];
    
    DMVenueRequest *venueRequest = [DMVenueRequest new];
    [venueRequest GET:@"venues" withParams:nil withCompletionBlock:^(NSError *error, id results) {
        if (!error) {
            NSMutableArray *all_ids = [[NSMutableArray alloc] init];
            for(NSDictionary* dict in results) {
                [all_ids addObject:dict[@"id"]];
            }
            
            DMUserRequest *userRequest = [DMUserRequest new];
            [userRequest downloadSubscriptionsWithCompletionBlock:^(NSError *error, id results) {
                SelectedNotificationsParser *parser = [[SelectedNotificationsParser alloc] initWithSubscriptionsObject:results ids:all_ids];
                NSDictionary *dic = [parser create];
                self.notificationDinings = dic[@"dinings"];
                self.notificationLifestyles = dic[@"lifestyles"];
                self.subObject = results;
                [self didEndDownloading];
            }];
            
        }
        [self didEndDownloading];
    }];
}

- (void)back:(UIBarButtonItem *)sender {
    NSArray *data = [self.tableManager getFilterData];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:[FilterItem convertPayloadToDicrionaryWithPayload:data]];
    dic[@"token"] = [DMRequest currentUserToken];
    
    if(dic[@"frequency"]) {
        if(self.notificationFrequency != [dic[@"frequency"] integerValue]) {
            self.changed_ids = YES;
        }
    }
    if(dic[@"all_venues_sub"]) {
        if([self.setupDict[@"all_venues_sub"] integerValue] != [dic[@"all_venues_sub"] integerValue]) {
            self.changed_ids = YES;
        }
    }
    if(dic[@"my_favs_sub"]) {
        if([self.setupDict[@"my_favs_sub"] integerValue] != [dic[@"my_favs_sub"] integerValue]) {
            self.changed_ids = YES;
        }
    }
    
    if(self.changed_ids == YES) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save your changes?"
                                                        message:@"Would you like to save your changes?"
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes", nil];
        
        [alert show];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didEndDownloading {
    if(self.didEndDownloads) {
        [[PKHUD sharedHUDObjc] hideWithAnimated:TRUE];
    }
    self.didEndDownloads = YES;
}
- (void)downloadSubscriptions {
    __weak typeof(self) weakSelf = self;
    
    [[self userRequest] downloadSubscriptionsWithCompletionBlock:^(NSError *error, id results) {
        if (error) {
            [weakSelf showErrorMessage];
        } else {
            [weakSelf setup:results];
        }
        [self didEndDownloading];
    }];
}

- (void)showErrorMessage {
    [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusError title:@"Oops" description:@"Something went wrong, please try again later" style:UIBlurEffectStyleExtraLight actionButtonTitle:nil];
}

- (void)setup:(SubscriptionsObject*)object {
    self.request = [DMUserRequest new];
    DMUser *currentUser = [[self userRequest] currentUser];
    self.provider = [[DMNotificationsSettingsProvider alloc] initWithFrequency:currentUser.notification_frequencyValue settings:object locationNotification:self.locationData];//[[DMNotificationsSettingsProvider alloc] initWithFrequency:currentUser.notification_frequencyValue settings:object];
    self.provider.ids = self.ids;
    self.seletionManager = [[DMNotificationSelectionManager alloc] init];
    self.tableManager = [[TUGroupedTableManager alloc] initWithTableView:self.tableView reuseIDs:self.provider.reuseIDs];
    self.tableManager.delegateLocation = self;
    self.tableManager.parent = self;
    self.tableManager.headersReuseIDs = @[@"TUHeaderOptionGroupView"];
    self.tableManager.selectionManager = self.seletionManager;
    self.tableManager.data = self.provider.preload;
    self.tableManager.notificationData = self.locationData;
    
    NSArray *data = [self.tableManager getFilterData];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:[FilterItem convertPayloadToDicrionaryWithPayload:data]];
    self.setupDict = dic;
    dic[@"token"] = [DMRequest currentUserToken];
    
    if(dic[@"frequency"]) {
        self.notificationFrequency = [dic[@"frequency"] integerValue];
    }
}

- (IBAction)saveNotification:(id)sender {
    [[PKHUD sharedHUDObjc] showOnView:self.view];
    
    [Answers logContentViewWithName:@"Save notification settings" contentType:@"" contentId:@"" customAttributes:@{}];
    
    self.changed_ids = NO;
    if (self.ids != NULL) {
        DMUserRequest *userRequest = [DMUserRequest new];
        [userRequest uploadSubscriptions:self.ids];
    }
    
    NSArray *data = [self.tableManager getFilterData];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:[FilterItem convertPayloadToDicrionaryWithPayload:data]];
    dic[@"token"] = [DMRequest currentUserToken];
    
    if(dic[@"frequency"]) {
        self.notificationFrequency = [dic[@"frequency"] integerValue];
    }
    
    __weak typeof(self) weakSelf = self;

    [[self userRequest] postSubscriptionsData:dic withCompletionBlock:^(id results, NSError *error) {
        if (error) {
            [weakSelf showErrorMessage];
        } else {
            [weakSelf saveFrequency];
        }
        [self didEndDownloading];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier  isEqual: @"showNotificationsVenues"]) {
        DMNotificationVenueListViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        vc.notificationLifestyles = self.notificationLifestyles;
        vc.notificationDinings = self.notificationDinings;
        vc.subObject = self.subObject;
    }
}

- (void)saveFrequency {
    __weak typeof(self) weakSelf = self;
    NSLog(@"locationData--%@, %@, %@, %d", locationData.latitude, locationData.longitude, locationData.locationName, locationData.isFavouriteVenuesNotification);
    BOOL isFavVenue = locationData.isFavouriteVenuesNotification;
    NSDictionary *params = @{@"frequency": @(self.notificationFrequency), @"latitude": locationData.latitude, @"longitude": locationData.longitude, @"location_name": locationData.locationName, @"is_favourite_venues_notification": @(isFavVenue)};
    [[self userRequest] uploadUserProfileWith:params profileImage:nil completionBlock:^(NSError *error, id results) {
        if (error) {
            [weakSelf showErrorMessage];
        } else {
            [[weakSelf.request currentUser] setNotification_frequency:@(weakSelf.notificationFrequency)];
            [weakSelf.request saveInContext:[weakSelf.request objectContext]];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

-(void)saveVenuesWithDinings:(NSArray *)dinings lifestyles:(NSArray *)lifestyles name:(NSString *)name changed:(BOOL)changed {
    NSArray *selectedIds = [SelectedNotificationsParser getSelectedWithDinings:dinings lifestyles:lifestyles];
    self.ids = selectedIds;
    self.provider.name = name;
    self.provider.ids = self.ids;
    self.changed_ids = !([SelectedNotificationsParser getSelectedWithDinings:dinings lifestyles:lifestyles] == [SelectedNotificationsParser getSelectedWithDinings:self.notificationDinings lifestyles:self.notificationLifestyles]);
    self.notificationLifestyles = lifestyles;
    self.notificationDinings = dinings;
    if(self.provider.ids != NULL) {
        self.tableManager.data = self.provider.preload;
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"Notifications";
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if(buttonIndex == 1) {
        [self saveNotification:self];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationItem.title = @"";
}

-(void)locationUpdated {
    NSLog(@"locationData--%@", self.tableManager.notificationData.latitude);
    NSLog(@"locationData--%@", self.tableManager.notificationData.longitude);
    NSLog(@"locationData--%@", self.tableManager.notificationData.locationName);
    NSLog(@"locationData--%d", self.tableManager.notificationData.isFavouriteVenuesNotification);
    self.locationData = self.tableManager.notificationData;
}


@end
