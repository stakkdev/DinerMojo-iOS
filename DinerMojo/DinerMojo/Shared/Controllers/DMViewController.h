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

- (void)presentOperationCompleteViewControllerWithStatus:(DMOperationCompletePopUpViewControllerStatus)status title:(NSString *)title description:(NSString *)description style:(UIBlurEffectStyle)style actionButtonTitle:(NSString *)actionButtonTitle color:(UIColor *)color;


- (void)presentOperationCompleteViewControllerWithStatusAttributed:(DMOperationCompletePopUpViewControllerStatus)status title:(NSString *)title description:(NSMutableAttributedString *)description style:(UIBlurEffectStyle)style actionButtonTitle:(NSString *)actionButtonTitle;

- (void)presentOperationCompleteViewControllerWithStatusAttributed:(DMOperationCompletePopUpViewControllerStatus)status title:(NSString *)title description:(NSMutableAttributedString *)description style:(UIBlurEffectStyle)style actionButtonTitle:(NSString *)actionButtonTitle color:(UIColor *)color;

- (void)presentEmailVerificationCheckViewControllerWithCompletionBlock:(RequestCompletion)completionBlock;
- (void)presentUnverifiedEmailViewControllerWithStyle:(UIBlurEffectStyle)style;


- (void)goToLandingPage;
- (void)goToVenues:(BOOL *)initial;

@end
