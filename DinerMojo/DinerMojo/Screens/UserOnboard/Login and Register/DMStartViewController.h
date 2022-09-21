//
//  DMStartViewController.h
//  DinerMojo
//
//  Created by Carl Sanders on 01/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMViewController.h"
#import "DMBlurredView.h"
#import "DMTextField.h"
#import "DinerMojo-Swift.h"

typedef NS_ENUM(NSInteger, DMStartViewControllerState) {
    DMStartViewControllerStateNormal = 0,
    DMStartViewControllerStateRegistration = 1,
    DMStartViewControllerStateReferral = 2,
    DMStartViewControllerStateLogin = 3,
    DMStartViewControllerStatePasswordReset = 4
};

@interface DMStartViewController : DMViewController <DMBlurredViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *buildLabel;

@property (weak, nonatomic) IBOutlet UIView *imageContainerView;
@property (weak, nonatomic) IBOutlet DMButton *skipButton;
@property (weak, nonatomic) IBOutlet DMButton *facebookButton;

@property (weak, nonatomic) IBOutlet DMButton *profilePictureButton;
@property (weak, nonatomic) IBOutlet DMImageView *profilePicture;
@property (weak, nonatomic) IBOutlet DMTextField *emailTextField;
@property (weak, nonatomic) IBOutlet DMTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet DMTextField *repeatPasswordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *passwordCheck1;
@property (weak, nonatomic) IBOutlet UIImageView *passwordCheck2;
@property (weak, nonatomic) IBOutlet DMTextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet DMTextField *lastNameTextField;

@property (weak, nonatomic) IBOutlet UILabel *referralCodePromptLabel;
@property (weak, nonatomic) IBOutlet UILabel *referralCodeNoCodeLabel;
@property (weak, nonatomic) IBOutlet DMTextField *referralCodeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *referralCodeCheck;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *referralActivityIndicator;

@property (weak, nonatomic) IBOutlet UILabel *resetPasswordLabel;
@property (weak, nonatomic) IBOutlet DMButton *confirmPasswordButton;


@property (weak, nonatomic) IBOutlet DMTextField *loginEmailTextField;
@property (weak, nonatomic) IBOutlet DMTextField *loginPasswordTextField;

@property (weak, nonatomic) IBOutlet DMButton *closeLoginButton;
@property (weak, nonatomic) IBOutlet DMButton *closeRegisterButton;
@property (weak, nonatomic) IBOutlet DMButton *registerButton;
@property (weak, nonatomic) IBOutlet DMButton *loginButton;

@property DMUser *referralUser;

- (IBAction)closeRegisterPressed:(id)sender;

@property (weak, nonatomic) IBOutlet DMTextField *forgotPasswordEmailTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerSubviewCenterX;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *looginSubviewCenterX;

@end
