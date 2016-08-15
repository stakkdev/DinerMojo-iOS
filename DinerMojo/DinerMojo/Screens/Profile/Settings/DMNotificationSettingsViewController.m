//
//  DMNotificationSettingsViewController.m
//  DinerMojo
//
//  Created by Carl Sanders on 12/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMNotificationSettingsViewController.h"
#import "DMUser.h"


@interface DMNotificationSettingsViewController ()

@property NSInteger notificationFilter;
@property NSInteger notificationFrequency;


@end

@implementation DMNotificationSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.request = [DMUserRequest new];
    [self updateState];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateState
{
    [self deactivateFilters];
    self.notificationFilter = [[self.request currentUser].notification_filter integerValue];
    self.notificationFrequency = [[self.request currentUser].notification_frequency integerValue];
    switch ([[self.request currentUser].notification_filter integerValue])
    {
        case DMUserNotificationFilterAll:
            [self activeState:[self allUpdatesImage] withLabel:[self allUpdatesLabel]];
            break;
        case DMUserNotificationFilterNews:
            [self activeState:[self newsUpdatesImage] withLabel:[self newsUpdatesLabel]];
            break;
        case DMUserNotificationFilterOffers:
            [self activeState:[self offersImage] withLabel:[self offersUpdatesLabel]];
            break;
        default:
            break;
    }
    
    switch ([[self.request currentUser].notification_frequency integerValue])
    {
        case DMUserNotificationFrequencyImmediate:
            [self activeState:[self immediateImage] withLabel:[self immediateLabel]];
            break;
        case DMUserNotificationFrequencyDaily:
            [self activeState:[self dailyImage] withLabel:[self dailyLabel]];
            break;
        case DMUserNotificationFrequencyWeekly:
            [self activeState:[self weeklyImage] withLabel:[self weeklyLabel]];
            break;
        case DMUserNotificationFrequencyNever:
            [self activeState:[self neverImage] withLabel:[self neverLabel]];
            break;
        default:
            break;
    }
    
    
}
- (IBAction)buttonPressed:(UIButton *)sender {

    
    //Update filter
    if ([sender isEqual:[self allUpdatesImage]]) {
        [self deactivateFilters];
        self.notificationFilter = DMUserNotificationFilterAll;
        [self activeState:[self allUpdatesImage] withLabel:[self allUpdatesLabel]];
    }
    
    else if ([sender isEqual:[self newsUpdatesImage]]) {
        [self deactivateFilters];
        self.notificationFilter = DMUserNotificationFilterNews;
        [self activeState:[self newsUpdatesImage] withLabel:[self newsUpdatesLabel]];
        
    }
    
    else if ([sender isEqual:[self offersImage]]) {
        [self deactivateFilters];
        self.notificationFilter = DMUserNotificationFilterOffers;
        [self activeState:[self offersImage] withLabel:[self offersUpdatesLabel]];
        
    }
    
    //Update frequency
    
    if([sender isEqual:[self immediateImage]]) {
        [self deactivateFrequency];
        self.notificationFrequency = DMUserNotificationFrequencyImmediate;
        [self activeState:[self immediateImage] withLabel:[self immediateLabel]];
        
    }
    
    else if([sender isEqual:[self dailyImage]]) {
        [self deactivateFrequency];
        self.notificationFrequency = DMUserNotificationFrequencyDaily;
        [self activeState:[self dailyImage] withLabel:[self dailyLabel]];
        
    }
    
    else if([sender isEqual:[self weeklyImage]]) {
        [self deactivateFrequency];
        self.notificationFrequency = DMUserNotificationFrequencyWeekly;
        [self activeState:[self weeklyImage] withLabel:[self weeklyLabel]];
        
    }
    
    else if([sender isEqual:[self neverImage]]) {
        [self deactivateFrequency];
        self.notificationFrequency = DMUserNotificationFrequencyNever;
        [self activeState:[self neverImage] withLabel:[self neverLabel]];
    }
    
    
}

- (IBAction)saveNotification:(id)sender {
    
    NSDictionary *params = @{ @"filter": [NSNumber numberWithInteger:self.notificationFilter], @"frequency": [NSNumber numberWithInteger:self.notificationFrequency]};
    [[self userRequest] uploadUserProfileWith:params profileImage:nil completionBlock:^(NSError *error, id results) {
    
        if (error)
        {
            [self updateState];
            [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusError title:@"Oops" description:@"Something went wrong, please try again later"  style:UIBlurEffectStyleExtraLight actionButtonTitle:nil];
            
        }
        
        else {
            [[self.request currentUser] setNotification_filter:[NSNumber numberWithInteger:self.notificationFilter]];
            [[self.request currentUser] setNotification_frequency:[NSNumber numberWithInteger:self.notificationFrequency]];
            [self.request saveInContext:[self.request objectContext]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];

}

-(void)deactivateFilters;
{
    for (UILabel *label in [self labels]) {
        [label setTextColor:[UIColor grayColor]];
    }
    
    for (UIButton *button in [self buttons]) {
        [button setImage:[UIImage imageNamed:@"UnselectedCheckMark22"] forState:UIControlStateNormal];
    }
}

-(void)deactivateFrequency;
{
    for (UILabel *label in [self frequencyLabels]) {
        [label setTextColor:[UIColor grayColor]];
    }
    
    for (UIButton *button in [self frequencyButtons]) {
        [button setImage:[UIImage imageNamed:@"UnselectedCheckMark22"] forState:UIControlStateNormal];
    }
}

- (void)activeState:(UIButton *)button withLabel:(UILabel *)label;
{
    [button setImage:[UIImage imageNamed:@"SelectedCheckMark22"] forState:UIControlStateNormal];
    [label setTextColor:[UIColor brandColor]];
}

@end
