//
//  DMProfileViewController.h
//  DinerMojo
//
//  Created by Carl Sanders on 06/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMTabBarViewController.h"


@interface DMProfileViewController : DMTabBarViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *statusBarView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *profileIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *noProfileLabel;

//Profile View
@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet DMView *profilePictureView;
@property (weak, nonatomic) IBOutlet DMImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileInitialsLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberStatusLabel;
@property (weak, nonatomic) IBOutlet DMButton *pointsButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UILabel *earnMonthsLabel;

@property (weak, nonatomic) IBOutlet UILabel *myMojoLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsToEarnLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsProgressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointsProgressLabelConstraint;

@property (weak, nonatomic) IBOutlet UIButton *savingMonthButton;
@property (weak, nonatomic) IBOutlet UIButton *savingYearButton;
@property (weak, nonatomic) IBOutlet UIButton *savingTotalButton;

@property (weak, nonatomic) IBOutlet DMButton *inviteButton;
@property (weak, nonatomic) IBOutlet UILabel *inviteLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *friendsView;

@property (weak, nonatomic) IBOutlet UILabel *referralPointsLabel;

@property (weak, nonatomic) IBOutlet DMButton *smallCirclePointsButton;
@property (weak, nonatomic) IBOutlet DMButton *largeCirclePointsButton;

@property(strong, nonatomic) UITabBar *toolBar;


@property UIRefreshControl *refreshControl;


- (IBAction)settingsButtonPressed:(id)sender;

@end
