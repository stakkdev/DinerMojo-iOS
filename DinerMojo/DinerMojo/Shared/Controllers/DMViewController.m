//
//  DMViewController.m
//  DinerMojo
//
//  Created by Carl Sanders on 01/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMViewController.h"
#import "DinerMojo-Swift.h"
#import <GBVersionTracking/GBVersionTracking.h>
#import "DMMapViewController.h"
@interface DMViewController ()

@end

@implementation DMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (@available(iOS 13.0, *)) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    
    _userRequest = [DMUserRequest new];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setRootViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
//    if (animated == YES)
//    {
//        [UIView transitionFromView:appDelegate.window.rootViewController.view
//                            toView:viewController.view
//                          duration:0.35f
//                           options:UIViewAnimationOptionTransitionCrossDissolve
//                        completion:^(BOOL finished){
//                            [[appDelegate window] setRootViewController:viewController];
//                        }];
//    }
//    else
//    {
        [[appDelegate window] setRootViewController:viewController];
    //}
}

- (void)presentOperationCompleteViewControllerWithStatus:(DMOperationCompletePopUpViewControllerStatus)status title:(NSString *)title description:(NSString *)description style:(UIBlurEffectStyle)style actionButtonTitle:(NSString *)actionButtonTitle
{
    [self presentOperationCompleteViewControllerWithStatus:status title:title description:description style:style actionButtonTitle:actionButtonTitle color:[UIColor colorWithRed:(85/255.f) green:(85/255.f) blue:(85/255.f) alpha:1]];
}

- (void)presentOperationCompleteViewControllerWithStatus:(DMOperationCompletePopUpViewControllerStatus)status title:(NSString *)title description:(NSString *)description style:(UIBlurEffectStyle)style actionButtonTitle:(NSString *)actionButtonTitle color:(UIColor *)color {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DMOperationCompletePopUpViewController *operationCompletePopUpViewController = [storyboard instantiateViewControllerWithIdentifier:@"operationComplete"];
    [operationCompletePopUpViewController setDelegate:self];
    [operationCompletePopUpViewController setColor:color];
    [operationCompletePopUpViewController setStatus:status];
    [operationCompletePopUpViewController setPopUpTitle:title];
    [operationCompletePopUpViewController setPopUpDescription:description];
    [operationCompletePopUpViewController setActionButtonTitle:actionButtonTitle];
    [operationCompletePopUpViewController setEffectStyle:style];
    [operationCompletePopUpViewController setShoulHideDontShowAgainButton:YES];
    [operationCompletePopUpViewController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [self presentViewController:operationCompletePopUpViewController animated:YES completion:nil];
}


- (void)presentOperationCompleteViewControllerWithStatusAttributed:(DMOperationCompletePopUpViewControllerStatus)status title:(NSString *)title description:(NSMutableAttributedString *)description style:(UIBlurEffectStyle)style actionButtonTitle:(NSString *)actionButtonTitle
{
    [self presentOperationCompleteViewControllerWithStatusAttributed:status title:title description:description style:style actionButtonTitle:actionButtonTitle color:[UIColor colorWithRed:(85/255.f) green:(85/255.f) blue:(85/255.f) alpha:1]];
}

- (void)presentOperationCompleteViewControllerWithStatusAttributed:(DMOperationCompletePopUpViewControllerStatus)status title:(NSString *)title description:(NSMutableAttributedString *)description style:(UIBlurEffectStyle)style actionButtonTitle:(NSString *)actionButtonTitle color:(UIColor *)color
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DMOperationCompletePopUpViewController *operationCompletePopUpViewController = [storyboard instantiateViewControllerWithIdentifier:@"operationComplete"];
    [operationCompletePopUpViewController setDelegate:self];
    [operationCompletePopUpViewController setColor:color];
    [operationCompletePopUpViewController setStatus:status];
    [operationCompletePopUpViewController setPopUpTitle:title];
    [operationCompletePopUpViewController setPopUpDescriptionAttributed:description];
    [operationCompletePopUpViewController setActionButtonTitle:actionButtonTitle];
    [operationCompletePopUpViewController setEffectStyle:style];
    [operationCompletePopUpViewController setShoulHideDontShowAgainButton:YES];
    [operationCompletePopUpViewController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [self presentViewController:operationCompletePopUpViewController animated:YES completion:nil];
}


- (void)presentEmailVerificationCheckViewControllerWithCompletionBlock:(RequestCompletion)completionBlock;
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DMOperationCompletePopUpViewController *operationCompletePopUpViewController = [storyboard instantiateViewControllerWithIdentifier:@"operationComplete"];
    [operationCompletePopUpViewController setEffectStyle:UIBlurEffectStyleDark];
    [operationCompletePopUpViewController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [operationCompletePopUpViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [[operationCompletePopUpViewController actionButton] setBackgroundColor:[UIColor clearColor]];
    [operationCompletePopUpViewController setShoulHideDontShowAgainButton:YES];
    
    [self presentViewController:operationCompletePopUpViewController animated:YES completion:^{
        DMUserRequest *userRequest = [DMUserRequest new];
        [userRequest downloadUserProfileWithCompletionBlock:^(NSError *error, id results) {
            completionBlock(error, results);
        }];
    }];
    
    [[operationCompletePopUpViewController tapToDismissLabel] setHidden:YES];
    [[operationCompletePopUpViewController statusImageView] setHidden:YES];
    [operationCompletePopUpViewController setActionButtonLoadingState:YES];
}

- (void)presentUnverifiedEmailViewControllerWithStyle:(UIBlurEffectStyle)style
{
    [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusError title:@"Please verify your email address" description:[NSString stringWithFormat:@"We sent an email with the subject “Account verification” to your %@ email address. Please click on the link within that email to verify the email address above", [[[self userRequest] currentUser] email_address]] style:style actionButtonTitle:@"Send email again"];
}

#pragma mark DMOperationCompletePopUpViewControllerDelegate

- (void)readyToDissmisOperationCompletePopupViewController:(DMOperationCompletePopUpViewController *)operationCompletePopupViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)actionButtonPressedFromOperationCompletePopupViewController:(DMOperationCompletePopUpViewController *)operationCompletePopupViewController
{
    if ([[operationCompletePopupViewController actionButtonTitle] isEqualToString:@"Send email again"])
    {
        [operationCompletePopupViewController setActionButtonLoadingState:YES];
        [self requestEmailVerificationFromOperationCompletePopupViewController:operationCompletePopupViewController];
    } 
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)requestEmailVerificationFromOperationCompletePopupViewController:(DMOperationCompletePopUpViewController *)operationCompletePopupViewController
{
    [[self userRequest] requestEmailVerificationEmailWithCompletionBlock:^(NSError *error, id results) {
        
        [operationCompletePopupViewController setActionButtonLoadingState:NO];
        
        if (error)
        {
            NSString *errorMessage;
            
            if ([error code] == DMErrorCode400) {
                errorMessage = @"It looks like you have already verified your email address";
                [[[self userRequest] currentUser] setIs_email_verified:@YES];
                [[self userRequest] saveInContext:[[self userRequest] objectContext]];
            } else
            {
                errorMessage = @"There was a problem requesting your email, please try again later";
            }
            
            [self dismissViewControllerAnimated:YES completion:^{
                [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusError title:@"Oops" description:errorMessage  style:UIBlurEffectStyleExtraLight actionButtonTitle:nil];
            }];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:^{
                [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusSuccess title:@"Email sent" description:@"A verification email has been sent to you. Please check your Inbox and Junk box in a few minutes"  style:UIBlurEffectStyleExtraLight actionButtonTitle:nil];
            }];
        }
    }];
}

#pragma mark - Navigation

- (void)goToLandingPage
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *destinationViewController = [storyboard instantiateViewControllerWithIdentifier:@"landingNavigationController"];
    [self setRootViewController:destinationViewController animated:NO];
}

- (void)goToVenues:(BOOL *)initial
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DMViewController *destinationViewController = [storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
    if(![NSUserDefaults.standardUserDefaults boolForKey:@"showedOverlay"]) {
        if([GBVersionTracking isFirstLaunchForVersion]) {
            [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"showedOverlay"];
            DMMapViewController *vc = destinationViewController.childViewControllers.firstObject.childViewControllers.firstObject;
            if(vc != NULL) {
                vc.showOverlay = YES;
            }
        }
    }
    if (initial) {
        [self setRootViewController:destinationViewController animated:YES];
    } else {
        [self setRootViewController:destinationViewController animated:NO];
    }

}

@end
