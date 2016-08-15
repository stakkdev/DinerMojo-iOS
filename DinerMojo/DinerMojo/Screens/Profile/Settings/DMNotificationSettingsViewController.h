//
//  DMNotificationSettingsViewController.h
//  DinerMojo
//
//  Created by Carl Sanders on 12/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMTabBarViewController.h"

@interface DMNotificationSettingsViewController : DMTabBarViewController

@property (weak, nonatomic) IBOutlet UIButton *allUpdatesImage;
@property (weak, nonatomic) IBOutlet UIButton *newsUpdatesImage;
@property (weak, nonatomic) IBOutlet UIButton *offersImage;
@property (weak,
           nonatomic) IBOutlet UIButton *neverImage;
@property (weak, nonatomic) IBOutlet UIButton *dailyImage;
@property (weak, nonatomic) IBOutlet UIButton *weeklyImage;
@property (weak, nonatomic) IBOutlet UIButton *immediateImage;

@property (weak, nonatomic) IBOutlet UILabel *allUpdatesLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsUpdatesLabel;
@property (weak, nonatomic) IBOutlet UILabel *offersUpdatesLabel;
@property (weak, nonatomic) IBOutlet UILabel *neverLabel;
@property (weak, nonatomic) IBOutlet UILabel *weeklyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dailyLabel;
@property (weak, nonatomic) IBOutlet UILabel *immediateLabel;

@property (strong, nonatomic) DMUserRequest* request;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *frequencyButtons;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *frequencyLabels;


- (IBAction)buttonPressed:(id)sender;
- (IBAction)saveNotification:(id)sender;

@end
