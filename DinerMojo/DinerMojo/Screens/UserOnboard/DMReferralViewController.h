//
//  DMReferralViewController.h
//  DinerMojo
//
//  Created by Carl Sanders on 01/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMViewController.h"

@interface DMReferralViewController : DMViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *welcomeDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileInitialsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property DMUser *referralUser;


- (IBAction)getStarted:(id)sender;

@end
