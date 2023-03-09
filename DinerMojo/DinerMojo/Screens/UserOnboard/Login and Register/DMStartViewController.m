//
//  DMStartViewController.m
//  DinerMojo
//
//  Created by Carl Sanders on 01/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMStartViewController.h"
#import "DMReferralViewController.h"
#import "UIImage+Extensions.h"
#import "DMMappingHelper.h"
#import <GBVersionTracking/GBVersionTracking.h>
#import "DinerMojo-Swift.h"
#import <Crashlytics/Answers.h>
#import <CoreServices/CoreServices.h>

static const NSInteger kReferrelCodeMaxLength = 8;

typedef NS_ENUM(NSInteger, DMStartViewControllerReferralCodeUIState) {
    DMStartViewControllerReferralCodeUIStateDownloading = 0,
    DMStartViewControllerReferralCodeUIStateCodeAvailable = 1,
    DMStartViewControllerReferralCodeUIStateCodeNotAvailable = 2,
    DMStartViewControllerReferralCodeUIStateCodeConflicted = 3
};
@class EmailVerifyViewController;
@class SetupPasswordViewController;

@interface DMStartViewController ()
{
    CGFloat _initialRegisterViewYCoordinate;
    CGFloat _initialRegisterSubviewCenterX;
    
    CGFloat _initialLoginViewYCoordinate;
    CGFloat _initialLoginSubviewCenterX;
    
    DMStartViewControllerState _startViewControllerState;
    
    BOOL _shouldCheckForReferralCode;
}

@property (strong, nonatomic) DMBlurredView *blurredView;
@property (nonatomic) DMStartViewControllerReferralCodeUIState referralCodeUIState;
@property (strong, nonatomic) NSMutableDictionary *currentFacebookData;

- (IBAction)textChanged:(UITextField *)textField;

@end

@implementation DMStartViewController

#pragma mark -  Internal Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    _initialRegisterViewYCoordinate = _registerViewBottom.constant;
    _initialRegisterSubviewCenterX = _registerSubviewCenterX.constant;
    
    _initialLoginViewYCoordinate = _loginViewBottom.constant;
    _initialLoginSubviewCenterX = _looginSubviewCenterX.constant;
    
    _startViewControllerState = DMStartViewControllerStateNormal;
    
    _shouldCheckForReferralCode = YES;
    
    [self setReferralCodeUIState:DMStartViewControllerReferralCodeUIStateCodeNotAvailable];
    
    [[self loginPasswordTextField] setDelegate:self];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    
    if (![bundleIdentifier  isEqual: @"com.dinermojo.dinermojo"]) {
        [self.buildLabel setText:[NSString stringWithFormat:@"Build %@ (%@)", version, build]];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_blurredView == nil)
    {
        [self buildBlurredView];
    }
    
    [self.loginEmailTextField setText: [[NSUserDefaults standardUserDefaults]stringForKey:@"lastEmail"]];
    [self updatePasswordCheckUI];
}

- (void)completeFormWithFacebookDetails:(NSDictionary *)facebookDetails
{
    [self setCurrentFacebookData:[NSMutableDictionary dictionaryWithDictionary:facebookDetails]];
    
    if ([facebookDetails objectForKey:@"email"] != nil)
    {
        [[self emailTextField] setText:[facebookDetails objectForKey:@"email"]];
    }
    
    if ([facebookDetails objectForKey:@"first_name"] != nil)
    {
        [[self firstNameTextField] setText:[facebookDetails objectForKey:@"first_name"]];
    }
    
    if ([facebookDetails objectForKey:@"last_name"] != nil)
    {
        [[self lastNameTextField] setText:[facebookDetails objectForKey:@"last_name"]];
    }
    
    [[self passwordTextField] setEnabled:NO];
    [[self repeatPasswordTextField] setEnabled:NO];
    [self.passwordTextField setPlaceholder:@"password (not required)"];
    [self.repeatPasswordTextField setPlaceholder:@"repeat password (not required)"];
    
    NSString *pictureURL = [[[facebookDetails objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
    
    NSURL *url = [NSURL URLWithString:pictureURL];
    [[self profilePicture] setImageWithURL:url];
}


- (void)clearTempFacebookSession
{
    if ([[DMFacebookService sharedInstance] isFacebookSessionOpen] == YES)
    {
        [[self emailTextField] setText:@""];
        [[self firstNameTextField] setText:@""];
        [[self lastNameTextField] setText:@""];
        [[self passwordTextField] setEnabled:YES];
        [[self repeatPasswordTextField] setEnabled:YES];
        [[self profilePicture] setImage:nil];
        
        [self setCurrentFacebookData:nil];
        [[DMFacebookService sharedInstance] logOut];
    }
    
}

- (void)buildBlurredView
{
    _blurredView = [[DMBlurredView alloc] initWithFrame:[[self view] frame]];
    
    [_blurredView setBlurRadius:5.0f];
    
    [_blurredView setSaturationDelta:1.0f];
    
    [_blurredView setViewToBlur:[self imageContainerView]];
    
    [_blurredView setDelegate:self];
    
    [[self view] insertSubview:_blurredView aboveSubview:[self imageContainerView]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)animateView:(UIView *)view constraintChangesWithInterval:(NSTimeInterval)interval damping:(CGFloat)damping
{
    [UIView animateWithDuration:interval delay:0.0f usingSpringWithDamping:damping initialSpringVelocity:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
        [view layoutIfNeeded];
    } completion:nil];
}

- (void)showBlurredViewWithInterval:(NSTimeInterval)interval
{
    [_blurredView animateBlurInWithInterval:interval completion:nil];
}

- (void)dismissBlurredViewWithInterval:(NSTimeInterval)interval
{
    [_blurredView animateBlurOutWithInterval:interval completion:nil];
}

- (BOOL)isPasswordCheck
{
    return ((![[[self passwordTextField] text] isEqualToString:@""] && [[[self passwordTextField] text] isEqualToString:[[self repeatPasswordTextField] text]]) || ([[self passwordTextField] isEnabled] == NO && [[self repeatPasswordTextField] isEnabled] == NO));
}

- (BOOL)isPasswordPolicy
{
    return (self.passwordTextField.text.length < 6);
}

- (void)updatePasswordCheckUI
{
    BOOL passwordCheck = ([self isPasswordCheck] && ![self isPasswordPolicy]);
    [[self passwordCheck1] setHidden:!passwordCheck];
    [[self passwordCheck2] setHidden:!passwordCheck];
}

- (NSString *)validationStringForRegistrationForm
{
    if (![DMUser validateEmailWithString:[[self emailTextField] text]])
    {
        return @"Please enter a valid email address.";
    }
    else if ([self isPasswordCheck] == NO)
    {
        return @"Please ensure both passwords match.";
    }
    
    else if ([[[self firstNameTextField] text] isEqualToString:@""])
    {
        return @"Please enter your first name.";
    }
    else if ([[[self lastNameTextField] text] isEqualToString:@""])
    {
        return @"Please enter your last name.";
    }
    
    else if (self.passwordTextField.isEnabled == YES)
    {
        if ([self isPasswordPolicy] == YES)
            
        {
            return @"Your password needs to be at least 6 characters long.";
        }
        
    }
    
    return @"";
}

- (void)toggleRegisterSubviews
{
    CGFloat targetConstant;
    
    if (_startViewControllerState == DMStartViewControllerStateRegistration)
    {
        targetConstant = [[self view] bounds].size.width;
        _startViewControllerState = DMStartViewControllerStateReferral;
        if (_shouldCheckForReferralCode == YES)
        {
            [self downloadReferralCode];
        }
    }
    else
    {
        targetConstant = _initialRegisterSubviewCenterX;
        _startViewControllerState = DMStartViewControllerStateRegistration;
    }
    
    [_registerSubviewCenterX setConstant:targetConstant];
    
    [self animateView:[self view] constraintChangesWithInterval:0.35f damping:0.75f];
}

- (void)toggleLoginSubviews
{
    
    CGFloat targetConstant;
    
    if (_startViewControllerState == DMStartViewControllerStateLogin)
    {
        targetConstant = [[self view] bounds].size.width;
        _startViewControllerState = DMStartViewControllerStatePasswordReset;
    }
    else
    {
        targetConstant = _initialLoginSubviewCenterX;
        _startViewControllerState = DMStartViewControllerStateLogin;
    }
    
    [_looginSubviewCenterX setConstant:targetConstant];
    
    [self animateView:[self view] constraintChangesWithInterval:0.35f damping:0.75f];
}

- (void)setReferralCodeUIState:(DMStartViewControllerReferralCodeUIState)referralCodeUIState
{
    _referralCodeUIState = referralCodeUIState;
    
    NSMutableAttributedString *attributedNoReferral = [[NSMutableAttributedString alloc] initWithString:self.referralCodeNoCodeLabel.text];
    [attributedNoReferral addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:@"OpenSans" size:16]
                                 range:NSMakeRange(0, 27)];
    [[self referralCodeNoCodeLabel] setAttributedText:attributedNoReferral];
    
    switch (_referralCodeUIState) {
        case DMStartViewControllerReferralCodeUIStateDownloading:
            [[self referralCodeCheck] setHidden:YES];
            [[self referralActivityIndicator] startAnimating];
            [[self referralCodeTextField] setEnabled:NO];
            [[self referralCodePromptLabel] setTextColor:[UIColor darkGrayColor]];
            [[self referralCodePromptLabel] setText:@"Checking to see if you have been invited to DinerMojo..."];
            [[self referralCodeNoCodeLabel] setHidden:NO];
            
            break;
        case DMStartViewControllerReferralCodeUIStateCodeAvailable:
            [[self referralCodeCheck] setHidden:NO];
            [[self referralCodeCheck] setImage:[UIImage imageNamed:@"small_check"]];
            [self referralCodeCheck].image = [[self referralCodeCheck].image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [[self referralCodeCheck] setTintColor:[UIColor brandColor]];
            [[self referralActivityIndicator] stopAnimating];
            [[self referralCodeTextField] setEnabled:YES];
            [[self referralCodePromptLabel] setText:@"We have your referral code ready in the text box below."];
            [[self referralCodePromptLabel] setTextColor:[UIColor darkGrayColor]];
            [[self referralCodeNoCodeLabel] setHidden:YES];
            break;
        case DMStartViewControllerReferralCodeUIStateCodeConflicted:
            [[self referralActivityIndicator] stopAnimating];
            [[self referralCodeTextField] setEnabled:YES];
            [[self referralCodePromptLabel] setTextColor:[UIColor redColor]];
            [self.referralCodePromptLabel setText:@"This code has been used"];
            [[self referralCodeNoCodeLabel] setHidden:NO];
            
            
            break;
        default:
            [[self referralCodeCheck] setHidden:YES];
            [[self referralActivityIndicator] stopAnimating];
            [[self referralCodeTextField] setEnabled:YES];
            [[self referralCodePromptLabel] setTextColor:[UIColor darkGrayColor]];
            [[self referralCodePromptLabel] setText:@"Got a referral code? \n Great! Enter it below and get bonus points for you and your friend."];
            [[self referralCodeNoCodeLabel] setHidden:NO];
            
            NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:self.referralCodePromptLabel.text];
            [attributed addAttribute:NSFontAttributeName
                               value:[UIFont fontWithName:@"OpenSans" size:16]
                               range:NSMakeRange(0, 20)];
            [[self referralCodePromptLabel] setAttributedText:attributed];
            
            
            
            break;
    }
}

- (void)downloadReferralCode
{
    if ([self referralCodeUIState] == DMStartViewControllerReferralCodeUIStateCodeAvailable)
    {
        return;
    }
    
    [self setReferralCodeUIState:DMStartViewControllerReferralCodeUIStateDownloading];
    
    [[self userRequest] downloadReferralCodeForEmailAddress:[[self emailTextField] text] withCompletionBlock:^(NSError *error, id results) {
        if (error == nil)
        {
            [[self referralCodeTextField] setText:[results objectForKey:@"code"]];
            [self setReferralCodeUIState:DMStartViewControllerReferralCodeUIStateCodeAvailable];
        }
        else
        {
            [self setReferralCodeUIState:DMStartViewControllerReferralCodeUIStateCodeNotAvailable];
        }
        _shouldCheckForReferralCode = NO;
    }];
}

- (void)checkCode
{
    [self setReferralCodeUIState:DMStartViewControllerReferralCodeUIStateDownloading];
    
    [[self userRequest] validateCode:[[self referralCodeTextField] text] withCompletionBlock:^(NSError *error, id results) {
        if (error == nil)
        {
            [self setReferralCodeUIState:DMStartViewControllerReferralCodeUIStateCodeAvailable];
            [self.referralCodePromptLabel setTextColor:[UIColor darkGrayColor]];
            
        }
        else
        {
            //Conflict
            if (error.code == DMErrorCode409)
            {
                [self setReferralCodeUIState:DMStartViewControllerReferralCodeUIStateCodeConflicted];
            }
            
            else
            {
                [self setReferralCodeUIState:DMStartViewControllerReferralCodeUIStateCodeNotAvailable];
                
            }
            [[self referralCodeCheck] setImage:[UIImage imageNamed:@"small_cross"]];
            [[self referralCodeCheck] setHidden:NO];
            
            
        }
        _shouldCheckForReferralCode = NO;
    }];
}

- (void)loginToFacebook
    {
    [Answers logLoginWithMethod:@"Facebook" success:@YES customAttributes:@{}];
    __weak typeof(self) weakSelf = self;
    
    [[self userRequest] loginFaceboookWithSuccess:^(id result) {
        [self goToVenues:NO];
    } error:^(NSError *error, id additionalInfo) {
        // User does not exist, Attempt Registration, otherwise log out of Facebook
        if ([error code] == DMErrorCode404)
        {
            [self completeFormWithFacebookDetails:additionalInfo];
            [self registerPressed:nil];
        }
        else
        {
            [[weakSelf userRequest] logout];
            
            NSString *errorMessage = ([error code] == DMErrorCode300) ? @"There is no email address associated with this Facebook Account. DinerMojo requires an email address to register / sign in." : @"There was a problem logging in. Please try again later.";
            
            [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusError title:@"Oops!" description:errorMessage style:UIBlurEffectStyleExtraLight actionButtonTitle:nil];
        }
    } missingPermissions:^(NSSet *missingPermissions) {
        NSLog(@"missingPermissions = %@", missingPermissions);
    } cancel:^{
        // TODO: Cancel any loading indicators
    } fromViewController:self];
}

- (NSDictionary *)facebookDataParsedForServer
{
    NSNumber *latitude = [NSNumber numberWithFloat:[[DMLocationServices sharedInstance] currentLocation].coordinate.latitude];
    NSNumber *longitude = [NSNumber numberWithFloat:[[DMLocationServices sharedInstance] currentLocation].coordinate.longitude];
    NSString *locationName = [[DMLocationServices sharedInstance] locationName];
    
    if(![[DMLocationServices sharedInstance] isLocationEnabled]) {
        latitude = [NSNumber numberWithInt:0];
        longitude = [NSNumber numberWithInt:0];
    }
    if (latitude == nil) {
        latitude = [NSNumber numberWithInt:0];
    }
    if (longitude == nil) {
        longitude = [NSNumber numberWithInt:0];
    }
    if (locationName == nil) {
        locationName = @"";
    }
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    NSDictionary *data = [self currentFacebookData];
    
//    NSString *formattedDate = [DMFacebookService dinerMojoFormattedDate:[data objectForKey:@"birthday"]];
    
    [dictionary setObject:[data objectForKey:@"id"] forKey:@"facebook_id"];
    [dictionary setObject:[[FBSDKAccessToken currentAccessToken] tokenString] forKey:@"facebook_token"];
    [dictionary setObject:[data objectForKey:@"first_name"] forKey:@"first_name"];
    [dictionary setObject:[data objectForKey:@"last_name"] forKey:@"last_name"];
    [dictionary setObject:[data objectForKey:@"email"] forKey:@"email_address"];
    [dictionary setObject:@([[data objectForKey:@"gender"] integerValue]) forKey:@"gender"];
    
    if(![[DMLocationServices sharedInstance] isLocationEnabled]) {
        [dictionary setObject:latitude forKey:@"latitude"];
        [dictionary setObject:longitude forKey:@"longitude"];
    }
    [dictionary setObject:locationName forKey:@"location_name"];

//    [dictionary setObject:formattedDate forKey:@"date_of_birth"];
    
    [dictionary setObject:[[self referralCodeTextField] text] forKey:@"referral_code"];
    
    if ([[self profilePicture] image] != nil)
    {
        [dictionary setObject:[[self profilePicture] image] forKey:@"profile_picture"];
    }
    
    return (NSDictionary *)dictionary;
}

- (void)signUpWithFacebook
{
    [Answers logSignUpWithMethod:@"Facebook" success:@YES customAttributes:@{}];
    [[self userRequest] signUpWithFacebook:[self facebookDataParsedForServer] WithCompletionBlock:^(NSError *error, id results) {
        if (error)
        {
            NSString *errorMessage = ([error code] == DMErrorCode409) ? @"The email account used with this Facebook account is already registered with DinerMojo." : @"There was a problem with registration. Please try again.";
            [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusError title:@"Oops!" description:errorMessage style:UIBlurEffectStyleExtraLight actionButtonTitle:nil];
        }
        else
        {
            self.referralUser = results;
            [self performSegueWithIdentifier:@"referralSegue" sender:nil];
            
        }
    }];
}

- (void)loginWithEmail
{
    [Answers logLoginWithMethod:@"Email" success:@YES customAttributes:@{}];
    if (self.loginEmailTextField.text.length != 0 && self.loginPasswordTextField.text.length != 0)
    {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGFloat halfButtonHeight = self.closeLoginButton.bounds.size.height / 2;
        CGFloat buttonWidth = self.closeLoginButton.bounds.size.width;
        indicator.center = CGPointMake(buttonWidth - halfButtonHeight , halfButtonHeight);
        [self.closeLoginButton addSubview:indicator];
        [indicator startAnimating];
        [self.closeLoginButton setImage:nil forState:UIControlStateNormal];
        [self.closeLoginButton setEnabled:NO];
        [self.loginButton setEnabled:NO];
        
        [[self userRequest] loginWithEmail:[[self loginEmailTextField] text] password:[[self loginPasswordTextField] text] WithCompletionBlock:^(NSError *error, id results) {
            if (error)
            {
                NSString *errorMessage = ([error code] == DMErrorCode401) ? @"Please ensure you have entered the correct username and password." : @"There was a problem signing in. Please try again later.";
                [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusError title:@"Oops!" description:errorMessage style:UIBlurEffectStyleExtraLight actionButtonTitle:nil];
                [self.closeLoginButton setEnabled:YES];
                [self.closeLoginButton setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
                [self.loginButton setEnabled:YES];
            }
            else {
                [self goToVenues:NO];
            }
            [indicator stopAnimating];
            [indicator removeFromSuperview];
        }];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Please enter both fields" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [alertController setModalPresentationStyle:UIModalPresentationOverFullScreen];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)signupWithEmail
{
    [Answers logSignUpWithMethod:@"Email" success:@YES customAttributes:@{}];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGFloat halfButtonHeight = self.closeRegisterButton.bounds.size.height / 2;
    CGFloat buttonWidth = self.closeRegisterButton.bounds.size.width;
    indicator.center = CGPointMake(buttonWidth - halfButtonHeight , halfButtonHeight);
    [self.closeRegisterButton addSubview:indicator];
    [indicator startAnimating];
    [self.closeRegisterButton setImage:nil forState:UIControlStateNormal];
    [self.closeRegisterButton setEnabled:NO];
    [self.registerButton setEnabled:NO];
            
    NSNumber *latitude = [NSNumber numberWithFloat:[[DMLocationServices sharedInstance] currentLocation].coordinate.latitude];
    NSNumber *longitude = [NSNumber numberWithFloat:[[DMLocationServices sharedInstance] currentLocation].coordinate.longitude];
    if(![[DMLocationServices sharedInstance] isLocationEnabled]) {
        latitude = [NSNumber numberWithInt:0];
        longitude = [NSNumber numberWithInt:0];
    }
    NSString *locationName = [[DMLocationServices sharedInstance] locationName];
    
    if (latitude == nil) {
        latitude = [NSNumber numberWithInt:0];
    }
    if (longitude == nil) {
        longitude = [NSNumber numberWithInt:0];
    }
    if (locationName == nil) {
        locationName = @"";
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(![[DMLocationServices sharedInstance] isLocationEnabled]) {
        params = [NSMutableDictionary dictionaryWithDictionary:@{ @"email_address" : [[self emailTextField] text], @"password" : [[self passwordTextField] text], @"first_name" : [[self firstNameTextField] text], @"last_name" : [[self lastNameTextField] text], @"location_name" : locationName}];
    } else {
        params = [NSMutableDictionary dictionaryWithDictionary:@{ @"email_address" : [[self emailTextField] text], @"password" : [[self passwordTextField] text], @"first_name" : [[self firstNameTextField] text], @"last_name" : [[self lastNameTextField] text], @"latitude" : latitude, @"longitude" : longitude, @"location_name" : locationName}];
    }
    [params setObject:[[self referralCodeTextField] text] forKey:@"referral_code"];
    
    if ([[self profilePicture] image] != nil)
    {
        [params setObject:[[self profilePicture] image] forKey:@"profile_picture"];
    }
    
    [[self userRequest] signUpWithEmailData:params WithCompletionBlock:^(NSError *error, id results) {
        if (error)
        {
            NSString *errorMessage = ([error code] == DMErrorCode409) ? @"This email address already has a DinerMojo account." : @"There was a problem logging in. Please try again later.";
            
            [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusError title:@"Oops!" description:errorMessage style:UIBlurEffectStyleExtraLight actionButtonTitle:nil];
            
            [self.closeRegisterButton setEnabled:YES];
            [self.closeRegisterButton setImage:[UIImage imageNamed:@"back_arrow_grey"] forState:UIControlStateNormal];
            [self.registerButton setEnabled:YES];
            
        }
        else
        {
            self.referralUser = results;
            [self performSegueWithIdentifier:@"referralSegue" sender:nil];
        }
        
        [indicator stopAnimating];
        [indicator removeFromSuperview];
    }];
}

- (void)closeLoginWithView {
    
    [_loginViewBottom setConstant:_initialLoginViewYCoordinate];
    
    [self animateView:[self view] constraintChangesWithInterval:0.25f damping:1.0f];
    
    [self dismissBlurredViewWithInterval:0.25f];
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    //_startViewControllerState = DMStartViewControllerStateNormal;
}

#pragma mark - Button Presses

- (IBAction)skipPressed:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DMViewController *destinationViewController = [storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
    destinationViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self setRootViewController:destinationViewController animated:YES];
    [[self userRequest] skipUser];
}

- (IBAction)logInPressed:(id)sender
{
    [_loginViewBottom setConstant:-10.0];
    
    [self animateView:[self view] constraintChangesWithInterval:0.35f damping:0.75f];
    
    [self showBlurredViewWithInterval:0.35f];
    
    _startViewControllerState = DMStartViewControllerStateLogin;
}

- (IBAction)closeLoginPressed:(id)sender
{
    [_loginViewBottom setConstant:_initialLoginViewYCoordinate];
    
    [self animateView:[self view] constraintChangesWithInterval:0.25f damping:1.0f];
    
    [self dismissBlurredViewWithInterval:0.25f];
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    _startViewControllerState = DMStartViewControllerStateNormal;
}

- (IBAction)forgotPasswordPressed:(id)sender
{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    [self toggleLoginSubviews];
}

- (IBAction)signInPressed:(id)sender
{
    [self loginWithEmail];
}

- (IBAction)confirmPasswordPressed:(id)sender
{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    CGFloat halfButtonHeight = self.confirmPasswordButton.bounds.size.height / 2;
    CGFloat buttonWidth = self.confirmPasswordButton.bounds.size.width;
    indicator.center = CGPointMake(buttonWidth - halfButtonHeight , halfButtonHeight);
    [self.confirmPasswordButton addSubview:indicator];
    [indicator startAnimating];
    [self.confirmPasswordButton setEnabled:NO];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [[self userRequest] resetPasswordWithEmailAddress:self.forgotPasswordEmailTextField.text withCompletionBlock:^(NSError *error, id results) {
        
        NSLog(@"Response of api is: %@", results);
        NSLog(@"Error of api is: %ld", (long)error.code);
        
        if (error)
        {
            NSString *errorMessage;
            
            if (error.code == DMErrorCode409)
            {
                errorMessage = @"You have already requested a password reset, please check your email";
            } else if (error.code == DMFBFErrorCode403) {
                [self facebookLoginNaviagtion:self.forgotPasswordEmailTextField.text];
                [self toggleLoginSubviews];
            } else {
                errorMessage = @"An account with this email does not exist.";
            }
             if (error.code != DMFBFErrorCode403) {
                [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusError title:@"Oops!" description:errorMessage style:UIBlurEffectStyleExtraLight actionButtonTitle:nil];
            }
        }
        else
        {
            [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusSuccess title:@"Done" description:[NSString stringWithFormat:@"An email has been sent to %@", self.forgotPasswordEmailTextField.text] style:UIBlurEffectStyleExtraLight actionButtonTitle:nil];
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [indicator stopAnimating];
        [indicator removeFromSuperview];
        [self.confirmPasswordButton setEnabled:YES];
    }];
}

- (IBAction)forgotPasswordBackPressed:(id)sender
{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    [self toggleLoginSubviews];
}

- (IBAction)facebookLoginPressed:(id)sender
{
    [self facebookLoginNaviagtion: @""];
}

-(void)facebookLoginNaviagtion:(NSString *)fbUserEmail {
    // Close Login View
    [self closeLoginWithView];
    _startViewControllerState = DMStartViewControllerStateNormal;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FBSignup" bundle:nil];
    EmailVerifyViewController *emailVerify = (EmailVerifyViewController *)[storyboard instantiateViewControllerWithIdentifier:@"EmailVerifyViewController"];
    emailVerify.emailText = fbUserEmail;
    emailVerify.viewDismiss = ^(void){
        [self dismissBlurredViewWithInterval:0.25f];
    };
    emailVerify.setPassword = ^(NSInteger userId, NSString *emailId) {
        [self dismissBlurredViewWithInterval:0.25f];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FBSignup" bundle:nil];
        SetupPasswordViewController *setupPassword = (SetupPasswordViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SetupPasswordViewController"];
        setupPassword.userId = userId;
        setupPassword.emailId = emailId;
        setupPassword.viewDismiss = ^(void){
            [self dismissBlurredViewWithInterval:0.25f];
        };
        setupPassword.successSetupPassword = ^(void){
            [self dismissBlurredViewWithInterval:0.25f];
            [self goToVenues:NO];
        };
        [setupPassword setModalPresentationStyle:UIModalPresentationOverFullScreen];
        [self presentViewController:setupPassword animated:true completion: nil];
        [self showBlurredViewWithInterval:0.35f];
    };
    
    [emailVerify setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self presentViewController:emailVerify animated:true completion: nil];
    [self showBlurredViewWithInterval:0.35f];
    //[self loginToFacebook];
}

- (void)processSelectedImage:(UIImage *)image
{
    if ([image size].width == 0.0 || [image size].height == 0.0)
    {
        [self presentImagePickerErrorTitle:@"Oops" description:@"There was a problem picking an image."];
        return;
    }
    
    CGFloat width;
    CGFloat height;
    CGFloat aspectRatio = [image size].width / [image size].height;
    
    if ([image size].height > [image size].width)
    {
        width = 320.0f;
        height = width / aspectRatio;
    }
    else
    {
        height = 320.0f;
        width = height * aspectRatio;
    }
    
    UIImage *resizedImage = [image resize:CGSizeMake(width, height)];
    [[self profilePicture] setImage:resizedImage];
}

//Image Picker Circle overlay view
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController.viewControllers count] == 3 && ([[[[navigationController.viewControllers objectAtIndex:2] class] description] isEqualToString:@"PUUIImageViewController"] || [[[[navigationController.viewControllers objectAtIndex:2] class] description] isEqualToString:@"PLUIImageViewController"]))
        [self addCircleOverlayToImagePicker:viewController];
}

-(void)addCircleOverlayToImagePicker:(UIViewController*)viewController
{
    UIColor *circleColor = [UIColor clearColor];
    UIColor *maskColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    UIView *plCropOverlayCropView; //The default crop overlay view, we wan't to hide it and show our circular one
    UIView *plCropOverlayBottomBar; //On iPhone this is the bar with "cancel" and "choose" buttons, on Ipad it's an Image View with a label saying "Scale and move"
    
    //Subviews hirearchy is different in iPad/iPhone:
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        plCropOverlayCropView = [viewController.view.subviews objectAtIndex:1];
        plCropOverlayBottomBar = [[[[viewController.view subviews] objectAtIndex:1] subviews] objectAtIndex:1];
        
        //Protect against iOS changes...
        if (! [[[plCropOverlayCropView class] description] isEqualToString:@"PLCropOverlay"]){
            NSLog(@"Warning - Image Picker with circle overlay: PLCropOverlay not found");
            return;
        }
        if (! [[[plCropOverlayBottomBar class] description] isEqualToString:@"UIImageView"]){
            NSLog(@"Warning - Image Picker with circle overlay: BottomBar not found");
            return;
        }
    }
    else{
        plCropOverlayCropView = [[[viewController.view.subviews objectAtIndex:1] subviews] firstObject];
        plCropOverlayBottomBar = [[[[viewController.view subviews] objectAtIndex:1] subviews] objectAtIndex:1];
        
        //Protect against iOS changes...
        if (! [[[plCropOverlayCropView class] description] isEqualToString:@"PLCropOverlayCropView"]){
            NSLog(@"Image Picker with circle overlay: PLCropOverlayCropView not found");
            return;
        }
        if (! [[[plCropOverlayBottomBar class] description] isEqualToString:@"PLCropOverlayBottomBar"]){
            NSLog(@"Image Picker with circle overlay: PLCropOverlayBottomBar not found");
            return;
        }
    }
    
    //It seems that everything is ok, we found the CropOverlayCropView and the CropOverlayBottomBar
    
    plCropOverlayCropView.hidden = YES; //Hide default CropView
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    //Center the circleLayer frame:
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.0f, screenHeight/2 - screenWidth/2, screenWidth, screenWidth)];
    circlePath.usesEvenOddFillRule = YES;
    circleLayer.path = [circlePath CGPath];
    circleLayer.fillColor = circleColor.CGColor;
    //Mask layer frame: it begins on y=0 and ends on y = plCropOverlayBottomBar.origin.y
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, screenWidth, screenHeight- plCropOverlayBottomBar.frame.size.height) cornerRadius:0];
    [maskPath appendPath:circlePath];
    maskPath.usesEvenOddFillRule = YES;
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskPath.CGPath;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    maskLayer.fillColor = maskColor.CGColor;
    [viewController.view.layer addSublayer:maskLayer];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        //On iPhone add an hint label on top saying "scale and move" or whatever you want
        UILabel *cropLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, screenWidth, 50)];
        [cropLabel setText:@"Scale and move"]; //You should localize it
        [cropLabel setTextAlignment:NSTextAlignmentCenter];
        [cropLabel setTextColor:[UIColor whiteColor]];
        [viewController.view addSubview:cropLabel];
    }
    else{ //On iPad re-add the overlayBottomBar with the label "scale and move" because we set its parent to hidden (it's a subview of PLCropOverlay)
        [viewController.view addSubview:plCropOverlayBottomBar];
    }
}


- (void)presentImagePickerErrorTitle:(NSString *)title description:(NSString *)desctiption
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:desctiption preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:ok];
    
    [alertController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)areImagesAvailableForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    for (NSString *type in [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        if ([type isEqualToString:(NSString *)kUTTypeImage])
        {
            return YES;
        }
    }
    
    return NO;
}

- (void)setCustomControlsForCamera:(UIImagePickerController *)imagePickerController
{
    if ([imagePickerController sourceType] == UIImagePickerControllerSourceTypeCamera)
    {
        // Custom controls here
        //        imagePickerController.showsCameraControls = NO;
    }
}

- (BOOL)didLaunchImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] == YES && [self areImagesAvailableForSourceType:sourceType] == YES)
    {
        UIImagePickerController *imagePickerController = [UIImagePickerController new];
        
        if (imagePickerController.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
        {
            imagePickerController.allowsEditing = YES;
        }
        
        [imagePickerController setSourceType:sourceType];
        
        [self setCustomControlsForCamera:imagePickerController];
        
        [imagePickerController setDelegate:self];
        
        [imagePickerController setMediaTypes:@[(NSString *)kUTTypeImage]];
        
        [imagePickerController setModalPresentationStyle:UIModalPresentationOverFullScreen];
        [self presentViewController:imagePickerController animated:YES
                         completion:nil];
        
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)launchCameraRoll
{
    if ([self didLaunchImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] == NO)
    {
        [self presentImagePickerErrorTitle:@"Oops" description:@"There was a problem picking an image."];
    }
}

- (void)launchCamera
{
    if ([self didLaunchImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera] == NO)
    {
        [self presentImagePickerErrorTitle:@"Oops" description:@"There was a problem launching the camera."];
    }
}

- (IBAction)pictureChooserPressed:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Picture Chooser" message:@"Please select a picture from your library or take a picture." preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraRoll = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self launchCameraRoll];
    }];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self launchCamera];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cameraRoll];
    [alertController addAction:camera];
    [alertController addAction:cancel];
    
    [alertController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)continueRegistrationPressed:(id)sender
{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    NSString *formValidationString = [self validationStringForRegistrationForm];
    
    if ([formValidationString isEqualToString:@""])
    {
        [self toggleRegisterSubviews];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:formValidationString preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:ok];
        
        [alertController setModalPresentationStyle:UIModalPresentationOverFullScreen];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)registerPressed:(id)sender
{
    [_registerViewBottom setConstant:-10.0];
    
    [self animateView:[self view] constraintChangesWithInterval:0.35f damping:0.75f];
    
    [self showBlurredViewWithInterval:0.35f];
    
    _startViewControllerState = DMStartViewControllerStateRegistration;
}

- (IBAction)closeRegisterPressed:(id)sender
{
    [_registerViewBottom setConstant:_initialRegisterViewYCoordinate];
    
    [self animateView:[self view] constraintChangesWithInterval:0.25f damping:1.0f];
    
    [self dismissBlurredViewWithInterval:0.25f];
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    _startViewControllerState = DMStartViewControllerStateNormal;
    
    [self clearTempFacebookSession];
}

- (IBAction)referralBackPressed:(id)sender
{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    [self toggleRegisterSubviews];
}

- (IBAction)registerWithCodePressed:(id)sender
{
    if ([[DMFacebookService sharedInstance] isFacebookSessionOpen] == YES)
    {
        [[self currentFacebookData] setObject:[[self emailTextField] text] forKey:@"email"];
        [[self currentFacebookData] setObject:[[self firstNameTextField] text] forKey:@"first_name"];
        [[self currentFacebookData] setObject:[[self lastNameTextField] text] forKey:@"last_name"];
        [[self currentFacebookData] setObject:[[self profilePicture] image] forKey:@"profile_picture"];
        
        
        
        if (![[[self referralCodeTextField] text] isEqual:@""])
        {
            [[self currentFacebookData] setObject:[[self referralCodeTextField] text] forKey:@"referral_code"];
        }
        
        [self signUpWithFacebook];
    }
    else
    {
        [self signupWithEmail];
    }
}

- (IBAction)termsPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://dinermojo.com/terms"] options:@{} completionHandler:^(BOOL success) {
        NSLog(@"Opened Url: %i", success);
    }];

}

- (IBAction)privacyPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://dinermojo.com/privacy"] options:@{} completionHandler:^(BOOL success) {
        NSLog(@"Opened Url: %i", success);
    }];
}

#pragma mark - Blurred View Delegate

- (void)tapFromBlurredView:(DMBlurredView *)blurredView
{
    switch (_startViewControllerState) {
        case DMStartViewControllerStateRegistration:
            [self closeRegisterPressed:nil];
            break;
        case DMStartViewControllerStateLogin:
            [self closeLoginPressed:nil];
            break;
        default:
            break;
    }
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"referralSegue"])
    {
        DMReferralViewController *vc = [segue destinationViewController];
        vc.referralUser = self.referralUser;
    }
    
    
}

#pragma mark UIImagePickerControllerDelegate, UINavigationControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self processSelectedImage:[info objectForKey:@"UIImagePickerControllerEditedImage"]];
    }];
}

#pragma mark - Text Changed

- (IBAction)passwordTextChanged:(id)sender
{
    [self updatePasswordCheckUI];
}

- (IBAction)textChanged:(UITextField *)textField
{
    if (textField == [self emailTextField])
    {
        _shouldCheckForReferralCode = YES;
    }
    else if (textField == [self referralCodeTextField])
    {
        if ([[textField text] length] == kReferrelCodeMaxLength)
        {
            [self checkCode];
        }
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == [self referralCodeTextField])
    {
        NSInteger newStringLength = ([[textField text] length] + 1);
        if ((newStringLength > kReferrelCodeMaxLength) && ![string isEqualToString:@""])
        {
            return NO;
        }
        else if (newStringLength == kReferrelCodeMaxLength)
        {
            return YES;
        }
        else
        {
            [self setReferralCodeUIState:DMStartViewControllerReferralCodeUIStateCodeNotAvailable];
            return YES;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == [self loginPasswordTextField])
    {
        [textField resignFirstResponder];
        
        [self loginWithEmail];
        
        return YES;
    }
    
    else if (textField == [self loginEmailTextField])
    {
        [[self loginPasswordTextField] becomeFirstResponder];
        return YES;
    }
    else if (textField == [self emailTextField])
    {
        
        [[self passwordTextField] becomeFirstResponder];
        
        return YES;
    }
    
    else if (textField == [self passwordTextField])
    {
        [[self repeatPasswordTextField] becomeFirstResponder];
        
        return YES;
    }
    
    else if (textField == [self repeatPasswordTextField])
    {
        [[self firstNameTextField] becomeFirstResponder];
        
        return YES;
    }
    
    else if (textField == [self firstNameTextField])
    {
        [[self lastNameTextField] becomeFirstResponder];
        
        return YES;
    }
    
    else if (textField == [self lastNameTextField])
    {
        [textField resignFirstResponder];
        [self continueRegistrationPressed:nil];
        return YES;
    }
    return NO;
}

#pragma mark DMOperationCompletePopUpViewControllerDelegate

- (void)readyToDissmisOperationCompletePopupViewController:(DMOperationCompletePopUpViewController *)operationCompletePopupViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([[operationCompletePopupViewController popUpDescription] isEqualToString:[NSString stringWithFormat:@"An email has been sent to %@", self.forgotPasswordEmailTextField.text]])
        {
            [self toggleLoginSubviews];
        }
    }];
}

#pragma mark FacebookEmailVerifyDelegate

- (void)viewDismissed {
    [self dismissBlurredViewWithInterval:0.25f];
}

-(void)setPasswordWithUserId:(NSInteger)userId {
    [self dismissBlurredViewWithInterval:0.25f];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FBSignup" bundle:nil];
    SetupPasswordViewController *setupPassword = (SetupPasswordViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SetupPasswordViewController"];
    setupPassword.viewDismiss = ^(void){
        NSLog(@"Completion is called to intimate action is performed.");
    };

    [setupPassword setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self presentViewController:setupPassword animated:true completion: nil];
    [self showBlurredViewWithInterval:0.35f];
}

@end
