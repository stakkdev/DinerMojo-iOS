//
//  DMReferAFriendViewController.m
//  DinerMojo
//
//  Created by Carl Sanders on 12/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMReferAFriendViewController.h"
#import <Crashlytics/Answers.h>

@interface DMReferAFriendViewController ()

@end

@implementation DMReferAFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);

    DMUser *currentUser = [[self userRequest] currentUser];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:[currentUser profilePictureFullURL]]];
    [self.profileInitialsLabel setText:[currentUser initials]];
    
    if ([self.referredPoints isEqualToString:@"0"])
    {
        [self.referredPointsDescriptionLabel setText:@"You'll start earning points as soon as your friend earns at a DinerMojo venue"];
    }
    else
    {
        NSString *pointsString = [NSString stringWithFormat:([self.referredPoints integerValue] == 1) ? @"Well done! So far, you've earned %ld point from referring friends." : @"Well done! So far, you've earned %ld points from referring friends.", (long)[self.referredPoints integerValue]];
        
        [self.referredPointsDescriptionLabel setText:pointsString];
    }
    
    [self.referredPointsLabel setText:self.referredPoints];


    UIColor *mojoColor;
    
    switch (currentUser.mojoLevel)
    {
        case DMUserMojoLevelBlue:
            mojoColor = [UIColor blueMainColor];
            break;
        case DMUserMojoLevelSilver:
            mojoColor = [UIColor silverSubColor];
            break;
        case DMUserMojoLevelGold:
            mojoColor = [UIColor goldMainColor];
            break;
        case DMUserMojoLevelPlatinum:
            mojoColor = [UIColor platinumMainColor];
            break;
    }
    
    [self.friendsIconView setBackgroundColor:mojoColor];
    [self.pointsView setBackgroundColor:mojoColor];
    [self.profileView setBorderColor:mojoColor];
}


-(void)viewDidLayoutSubviews
{
    self.scollView.contentSize = CGSizeMake(self.view.frame.size.width, 600);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Set navigation bar transparent
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[self activityIndicator] stopAnimating];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

- (void)presentInvalidEmailMessage
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Please enter a valid email address" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    
    [alertController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)sendInvite:(id)sender {
    
    if ([DMUser validateEmailWithString:self.emailTextField.text])
    {
        [Answers logContentViewWithName:@"Sent invite to friend" contentType:@"Sent invite to friend" contentId:@"" customAttributes:@{}];
        [[self activityIndicator] startAnimating];
        [[self sendInviteButton] setHidden:YES];
        
        [[self userRequest] referUserWithEmailAddress:self.emailTextField.text withCompletionBlock:^(NSError *error, id results) {
            if (error)
            {
                NSString *errorMessage;
                if ([error code] == DMErrorCode409)
                {
                    errorMessage = @"An invitation has already been sent to this email address.";
                }
                else if ([error code] == DMErrorCode400)
                {
                    errorMessage = @"Looks like your friend is already a member.";
                }
                else
                {
                    errorMessage = @"There was a problem sending the invite. Please try again later.";
                }
                
                [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusError title:@"Oops" description:errorMessage style:UIBlurEffectStyleExtraLight actionButtonTitle:nil];
            }
            else
            {
                [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusSuccess title:@"Done" description:[NSString stringWithFormat:@"An email has been sent to %@ inviting them to join DinerMojo!", self.emailTextField.text]  style:UIBlurEffectStyleExtraLight actionButtonTitle:nil];
            }
        }];
    }
    else
    {
        [self presentInvalidEmailMessage];
    }
}

#pragma mark DMOperationCompletePopUpViewControllerDelegate

- (void)readyToDissmisOperationCompletePopupViewController:(DMOperationCompletePopUpViewController *)operationCompletePopupViewController
{
    [super readyToDissmisOperationCompletePopupViewController:operationCompletePopupViewController];
    [[self activityIndicator] stopAnimating];
    [[self sendInviteButton] setHidden:NO];
    [[self emailTextField] setText:@""];
}


@end
