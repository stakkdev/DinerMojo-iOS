//
//  DMEditProfileViewController.m
//  DinerMojo
//
//  Created by Robert Sammons on 16/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMEditProfileViewController.h"
#import "UIImage+Extensions.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface DMEditProfileViewController ()
@property BOOL didChangePhoto;
@end

@implementation DMEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.didChangePhoto = NO;
    self.datePicker.dateDelegate = self;
    self.datePicker.dateFormatTemplate = @"dMM";
    
    self.datePicker.layer.borderWidth = 1.0;
    self.datePicker.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.view bringSubviewToFront:self.closeDatePicker];
    
    
    self.firstNameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    self.surnameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    self.postcodeTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    
    DMUser *currentUser = [[self userRequest] currentUser];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:[currentUser profilePictureFullURL]]];
    [self.profileInitialsLabel setText:[currentUser initials]];
    
    [self.firstNameTextField setText:[currentUser first_name]];
    [self.surnameTextField setText:[currentUser last_name]];
    
    [self.emailTextField setText:[currentUser email_address]];
    
    
    if (currentUser.date_of_birth != nil)
    {
        [self datePicker:self.datePicker didSelectDate:[currentUser date_of_birth]];
        self.selectedDate = [currentUser date_of_birth];
       
    }
   
    
    [self.postcodeTextField setText:[currentUser post_code]];
    
    UIColor *mojoColor;
    
    switch (currentUser.mojoLevel)
    {
        case DMUserMojoLevelBlue:
            mojoColor = [UIColor blueSubColor];
            break;
        case DMUserMojoLevelSilver:
            mojoColor = [UIColor silverSubColor];
            break;
        case DMUserMojoLevelGold:
            mojoColor = [UIColor goldSubColor];
            break;
        case DMUserMojoLevelPlatinum:
            mojoColor = [UIColor platinumSubColor];
            break;
    }
    
    [self.profilePictureView setBorderColor:mojoColor];
    
    UIImage *backArrow = [UIImage imageNamed:@"back_arrow_grey"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backArrow style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)goBack {
    DMUser *currentUser = [[self userRequest] currentUser];
    
    if([self.firstNameTextField.text isEqualToString:[currentUser first_name]] && [self.profileInitialsLabel.text isEqualToString:[currentUser initials]] && [self.surnameTextField.text isEqualToString:[currentUser last_name]] && [self.emailTextField.text isEqualToString:[currentUser email_address]] && self.selectedDate == [currentUser date_of_birth] && ([self.postcodeTextField.text isEqualToString:[currentUser post_code]] || ([self.postcodeTextField.text isEqualToString:@""] && currentUser.post_code == nil)) && !self.didChangePhoto) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save your changes?" message:@"Would you like to save your changes?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if(buttonIndex == 1) {
        [self saveAccount:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)datePicker:(PMEDatePicker *)datePicker didSelectDate:(NSDate *)date
{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d MMM"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];

    NSString *dateString = [dateFormat stringFromDate:date];
    if (dateString != nil) {
        [self.dateButton setTitle:[NSString stringWithFormat:@"  %@", dateString] forState:UIControlStateNormal];
        self.selectedDate = date;
    }
}

- (IBAction)revealDatePicker:(id)sender {
    
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.8
                        options:0 animations:^{
                            
                            if (self.datePickerBottomConstraint.constant == -1)
                            {
                                self.datePickerBottomConstraint.constant = -162;
                            }
                            
                            else
                            {
                                self.datePickerBottomConstraint.constant = -1;
                                
                            }
                            
                            [self.view layoutIfNeeded];
                        }
                     completion:^(BOOL finished) {
                         //Completion Block
                         
                     }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.8
                        options:0 animations:^{
                            
                            self.datePickerBottomConstraint.constant = -162;
                            
                            
                            [self.view layoutIfNeeded];
                        }
                     completion:^(BOOL finished) {
                         //Completion Block
                     }];
   
}

- (IBAction)deleteAccount:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Delete my account" message:@"You will lose all points, your user profile and will need to create a new account to use DinerMojo." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"This will permanently delete your account and points." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [self deleteUserAccount];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        
        [alertController addAction:ok];
        [alertController addAction:cancel];
        
        [alertController setModalPresentationStyle:UIModalPresentationOverFullScreen];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alertController addAction:ok];
    [alertController addAction:cancel];
    
    [alertController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)deleteUserAccount
{
    [self.view.window setUserInteractionEnabled:NO];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator setColor:[UIColor blackColor]];
    [indicator setFrame:self.view.frame];
    [indicator setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.7]];
    [indicator startAnimating];
    [self.view addSubview:indicator];

    
    [[self userRequest] deleteUserWithCompletionBlock:^(NSError *error, id results) {
        
        if (error)
        {
            [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusError title:@"Oops" description:@"We can't delete your account at this time, please try again later"  style:UIBlurEffectStyleExtraLight actionButtonTitle:nil];
            [self.view.window setUserInteractionEnabled:YES];
        }
        
        else
        {
            [self.view.window setUserInteractionEnabled:YES];
            [self logOut];
        }

        [self.view.window setUserInteractionEnabled:YES];
        [indicator stopAnimating];
        [indicator removeFromSuperview];
    }];
}

- (void)logOut
{
    [[self userRequest] logout];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *destinationViewController = [storyboard instantiateViewControllerWithIdentifier:@"landingNavigationController"];
    
    [self setRootViewController:destinationViewController animated:YES];
}

- (IBAction)saveAccount:(id)sender {
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if ([self validateForm] == NO)
    {
        [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusError title:@"Oops!" description:@"Please make sure you've provided a first name, last name and valid email address." style:UIBlurEffectStyleExtraLight actionButtonTitle:nil];
        
        return;
    }
    
    NSMutableDictionary *params = [@{ @"first_name": self.firstNameTextField.text, @"last_name": self.surnameTextField.text,  @"post_code": self.postcodeTextField.text, @"email": self.emailTextField.text} mutableCopy];
    if (self.selectedDate != nil)
    {
        
        NSDateFormatter *dateFormatterSaving = [[NSDateFormatter alloc] init];
        [dateFormatterSaving setDateFormat:@"yyyy-MM-dd"];

        
        NSString *date_of_birth = [dateFormatterSaving stringFromDate:self.selectedDate];
        params[@"date_of_birth"] = date_of_birth;
    }

    [[self userRequest] uploadUserProfileWith:params profileImage:self.selectedImage completionBlock:^(NSError *error, id results) {
        
        if (error)
        {
            NSString *errorDescription;
            if ([error code] == DMErrorCode409)
            {
                errorDescription = @"The email you have entered is already in use. Try something different.";
            }
            else
            {
                errorDescription = @"Something went wrong, please try again later";
            }
            [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusError title:@"Oops" description:errorDescription  style:UIBlurEffectStyleExtraLight actionButtonTitle:nil];
            [[self saveButton] setEnabled:YES];

        }
        
        else
        {
            [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusSuccess title:@"Done" description:@"Your account has been updated"  style:UIBlurEffectStyleExtraLight actionButtonTitle:nil];
            [[self userRequest] downloadUserProfileWithCompletionBlock:^(NSError *error, id results){
                
            }];
            [[self saveButton] setEnabled:NO];

            
        }

        
    }];

}

- (IBAction)dismissDatePicker:(id)sender {
    
    [self profileImageView];
    
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.8
                        options:0 animations:^{
                            
                            self.datePickerBottomConstraint.constant = -162;
                            [self.view layoutIfNeeded];
                        }
                     completion:^(BOOL finished) {
                         //Completion Block
                     }];
}

- (BOOL)validateForm;
{
    return (self.firstNameTextField.text.length > 0 && self.surnameTextField.text.length > 0 && [DMUser validateEmailWithString:self.emailTextField.text]);
}

- (void)processSelectedImage:(UIImage *)image
{
    if ([image size].width == 0.0 || [image size].height == 0.0)
    {
        [self presentImagePickerErrorTitle:@"Profile Picture Error" description:@"There was a problem picking an image."];
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
    [self.profileImageView setImage:resizedImage];
    self.selectedImage = resizedImage;
    [[self saveButton] setEnabled:YES];

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
    
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];

    switch (status) {
        case ALAuthorizationStatusAuthorized:
            
            if ([self didLaunchImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] == NO)
            {
                [self presentImagePickerErrorTitle:@"Profile Picture Error" description:@"There was a problem picking an image."];
            }
            
            break;
        case ALAuthorizationStatusDenied:
            [self presentAlertForPrivacy];
            break;
        case ALAuthorizationStatusNotDetermined:
            
            if ([self didLaunchImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] == NO)
            {
                [self presentImagePickerErrorTitle:@"Profile Picture Error" description:@"There was a problem picking an image."];
            }
            
            break;
        case ALAuthorizationStatusRestricted:
            [self presentAlertForPrivacy];
            break;
            
        default:
            break;
    }
    
    
    
    

}

- (void)presentAlertForPrivacy
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Picture Library" message:@"To use this feature we require your Photos for verification. We do not store or use the image in any other way." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *privacy = [UIAlertAction actionWithTitle:@"Privacy Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                NSLog(@"Opened Url: %i", success);
            }];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Not Now" style:UIAlertActionStyleDestructive handler:nil];
        
        
        [alertController addAction:privacy];
        [alertController addAction:cancel];
        
        [alertController setModalPresentationStyle:UIModalPresentationOverFullScreen];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
   
}
- (void)launchCamera
{
    if ([self didLaunchImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera] == NO)
    {
        [self presentImagePickerErrorTitle:@"Profile Picture Error" description:@"There was a problem launching the camera."];
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

#pragma mark UIImagePickerControllerDelegate, UINavigationControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.didChangePhoto = YES;
    [self dismissViewControllerAnimated:YES completion:^{
        [self processSelectedImage:[info objectForKey:@"UIImagePickerControllerEditedImage"]];
    }];
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
