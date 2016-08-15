//
//  DMViewController.h
//  DinerMojo
//
//  Created by Carl Sanders on 01/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DMOperationCompletePopUpViewController.h"
#import "DMUserRequest.h"

@interface DMViewController : UIViewController <DMOperationCompletePopUpViewControllerDelegate>

@property (strong, nonatomic) DMUserRequest *userRequest;

- (void)setRootViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (void)presentOperationCompleteViewControllerWithStatus:(DMOperationCompletePopUpViewControllerStatus)status title:(NSString *)title description:(NSString *)description style:(UIBlurEffectStyle)style actionButtonTitle:(NSString *)actionButtonTitle;

- (void)presentEmailVerificationCheckViewControllerWithCompletionBlock:(RequestCompletion)completionBlock;
- (void)presentUnverifiedEmailViewControllerWithStyle:(UIBlurEffectStyle)style;


- (void)goToLandingPage;
- (void)goToVenues;

@end
