//
//  DMPasswordSettingsViewController.m
//  DinerMojo
//
//  Created by Carl Sanders on 12/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMPasswordSettingsViewController.h"

@interface DMPasswordSettingsViewController ()

@end

@implementation DMPasswordSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.typedNewPasswordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    self.retypedNewPasswordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    self.currentPasswordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reconfirmPasswordAlertWithMessage:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reconfirm password" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)savePassword:(id)sender {
    
    if (![self.typedNewPasswordTextField.text isEqualToString:self.retypedNewPasswordTextField.text])
    {
        
        [self reconfirmPasswordAlertWithMessage:@"Your passwords do not match"];
        
    }
    
    else if (self.typedNewPasswordTextField.text.length < 6)
    {
        [self reconfirmPasswordAlertWithMessage:@"Your password needs to be atleast 6 characters long."];
    }
    
    else
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

        [self.saveButton setEnabled:NO];
        [[self userRequest] loginWithEmail:[self userRequest].currentUser.email_address password:self.currentPasswordTextField.text WithCompletionBlock:^(NSError *error, id results) {
            if (error)
            {
                [self reconfirmPasswordAlertWithMessage:@"Your current password is incorrect"];

                [self.saveButton setEnabled:YES];

            }
            
            else
            {
                NSDictionary *params = @{ @"password": self.retypedNewPasswordTextField.text};
                [[self userRequest] uploadUserProfileWith:params profileImage:nil completionBlock:^(NSError *error, id results) {
                    
                    if (error)
                    {
                        [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusError title:@"Oops" description:@"Something went wrong, please try again later"  style:UIBlurEffectStyleExtraLight actionButtonTitle:nil];

                    }
                    
                    else {
                        
                        [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusSuccess title:@"Done" description:@"Your password has been changed"  style:UIBlurEffectStyleExtraLight actionButtonTitle:nil];
                    }
                    [self.saveButton setEnabled:YES];
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];


                }];
                

            }
        }];
    }
}

-(void)readyToDissmisOperationCompletePopupViewController:(DMOperationCompletePopUpViewController *)operationCompletePopupViewController
{
    if (operationCompletePopupViewController.status == DMOperationCompletePopUpViewControllerStatusSuccess)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
