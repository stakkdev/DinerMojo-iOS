//
//  DMPasswordSettingsViewController.h
//  DinerMojo
//
//  Created by Carl Sanders on 12/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMTabBarViewController.h"

@interface DMPasswordSettingsViewController : DMTabBarViewController <DMOperationCompletePopUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *currentPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *typedNewPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *retypedNewPasswordTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

- (IBAction)savePassword:(id)sender;

@end
