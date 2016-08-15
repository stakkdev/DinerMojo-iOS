//
//  DMReferAFriendViewController.h
//  DinerMojo
//
//  Created by Carl Sanders on 12/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMTabBarViewController.h"


@interface DMReferAFriendViewController : DMTabBarViewController

@property (weak, nonatomic) IBOutlet UILabel *profileInitialsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scollView;
@property (weak, nonatomic) IBOutlet DMButton *sendInviteButton;
@property (weak, nonatomic) IBOutlet UILabel *referredPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *referredPointsDescriptionLabel;
@property (weak, nonatomic) NSString *referredPoints;
@property (weak, nonatomic) IBOutlet DMButton *friendsIconView;
@property (weak, nonatomic) IBOutlet DMButton *pointsView;
@property (weak, nonatomic) IBOutlet DMView *profileView;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)sendInvite:(id)sender;

@end
