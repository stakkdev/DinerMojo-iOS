//
//  DMEarnReviewViewController.m
//  DinerMojo
//
//  Created by Robert Sammons on 24/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMEarnReviewViewController.h"
#import "UIImage+Extensions.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "DMDineNavigationController.h"
#import "DMFeedbackViewController.h"
#import <Crashlytics/Answers.h>
#import "DinerMojo-Swift.h"

@interface DMEarnReviewViewController ()

@property UIImage *editedImage;
@property CGSize size;
@property CGRect rect;

@end

@implementation DMEarnReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self launchCamera];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UIImagePickerControllerDelegate, UINavigationControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.greenView setHidden:YES];
    [self.blackView setHidden:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
        

        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        self.editedImage = [originalImage scaledImageForScale:0.25];
        [self.imageView setImage:[self imageWithBorderFromImage:self.editedImage]];
        [self.imageView setHidden:NO];

        //CGSize imageSize = [self imageSizeAfterAspectFit:self.imageView];
      
        
//        self.imageView.transform = CGAffineTransformMakeRotation(0.0204532925);

        //TODO FIX SHADOW VIEW ON 6 PLUS
        
//        UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2) - (imageSize.width / 2), self.imageView.frame.origin.y, imageSize.width, imageSize.height)];
//        [shadowView setBackgroundColor:[UIColor colorWithRed:0.294f green:0.675f blue:0.580f alpha:1.00f]];
//        [self.view insertSubview:shadowView belowSubview:self.imageView];
//        shadowView.transform = CGAffineTransformMakeRotation(-0.0144532925);

    }];
}

- (UIImage*)imageWithBorderFromImage:(UIImage*)source;
{
    const CGFloat margin = 10.0f;
    self.size = CGSizeMake([source size].width + 2*margin, [source size].height + 2*margin);
    UIGraphicsBeginImageContext(self.size);
    
    [[UIColor whiteColor] setFill];
    [[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.size.width, self.size.height)] fill];
    
    self.rect = CGRectMake(margin, margin, self.size.width-2*margin, self.size.height-2*margin);
    [source drawInRect:self.rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *testImg =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return testImg;
}

-(CGSize)imageSizeAfterAspectFit:(UIImageView*)imgview{
    
    
    float newwidth;
    float newheight;
    
    UIImage *image=imgview.image;
    
    if (image.size.height>=image.size.width){
        newheight=imgview.frame.size.height;
        newwidth=(image.size.width/image.size.height)*newheight;
        
        if(newwidth>imgview.frame.size.width){
            float diff=imgview.frame.size.width-newwidth;
            newheight=newheight+diff/newheight*newheight;
            newwidth=imgview.frame.size.width;
        }
        
    }
    else{
        newwidth=imgview.frame.size.width;
        newheight=(image.size.height/image.size.width)*newwidth;
        
        if(newheight>imgview.frame.size.height){
            float diff=imgview.frame.size.height-newheight;
            newwidth=newwidth+diff/newwidth*newwidth;
            newheight=imgview.frame.size.height;
        }
    }
    
    //NSLog(@"image after aspect fit: width=%f height=%f",newwidth,newheight);
    
    
    //adapt UIImageView size to image size
    //imgview.frame=CGRectMake(imgview.frame.origin.x+(imgview.frame.size.width-newwidth)/2,imgview.frame.origin.y+(imgview.frame.size.height-newheight)/2,newwidth,newheight);
    
    return CGSizeMake(newwidth, newheight);
    
}

- (void)takePicture
{
    [self.imagePickerController takePicture];
}

- (void)dismissCamera
{
    [self dismissViewControllerAnimated:YES completion:^{

        [(DMDineNavigationController *)[self navigationController] cancelPressed];
        
    }];
}

- (void)setCustomControlsForCamera:(UIImagePickerController *)imagePickerController
{
    if ([imagePickerController sourceType] == UIImagePickerControllerSourceTypeCamera)
    {
        
    
        UILabel *photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x - 140, self.view.frame.size.height - 147, 280, 50)];
        
        NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:@"Take a photo of the"];
        [attributed addAttribute:NSFontAttributeName
                      value:[UIFont fontWithName:@"OpenSans" size:16]
                      range:NSMakeRange(0, [attributed length])];
        [attributed addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributed length])];
        NSMutableAttributedString *attributed3 = [[NSMutableAttributedString alloc] initWithString:@" whole receipt…"];
        NSDictionary *attrDict = @{
                                   NSFontAttributeName : [UIFont fontWithName:@"OpenSans" size:16.0],
                                   NSForegroundColorAttributeName : [UIColor yellowColor]
                                   };
        [attributed3 setAttributes:attrDict range:NSMakeRange(0, [attributed3 length])];
        
        NSMutableAttributedString *attributed2 = [[NSMutableAttributedString alloc] initWithString:@"Make sure it's clear!"];
        [attributed2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:14] range:NSMakeRange(0, 21)];
        [attributed2 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributed2 length])];
        
        [attributed appendAttributedString:attributed3];
        [attributed appendAttributedString:attributed2];

        [photoLabel setAttributedText:attributed];
        [photoLabel setTextAlignment:NSTextAlignmentCenter];
        [photoLabel setNumberOfLines:0];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton = [[UIButton alloc] initWithFrame:CGRectMake(22, self.view.frame.size.height - 64, 30, 30)];
        [closeButton addTarget:self action:@selector(dismissCamera) forControlEvents:UIControlEventTouchUpInside];
        UIImage *cross = [[UIImage imageNamed:@"cross"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [closeButton setImage:cross forState:UIControlStateNormal];
        [closeButton setTintColor:[UIColor whiteColor]];
        
        UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x - 29, self.view.frame.size.height - 77, 58, 58)];
        [cameraButton addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
        UIImage *camera = [[UIImage imageNamed:@"camera"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [cameraButton setImage:camera forState:UIControlStateNormal];
        [cameraButton setTintColor:[UIColor whiteColor]];
        
        UIImageView *crossHair1ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 35, 35)];
        [crossHair1ImageView setImage:[UIImage imageNamed:@"camera_crosshair"]];
        
        UIImageView *crossHair2ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, 15, 35, 35)];
        [crossHair2ImageView setImage:[UIImage imageNamed:@"camera_crosshair"]];
        crossHair2ImageView.transform = CGAffineTransformMakeRotation(M_PI_2);

        UIImageView *crossHair3ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.view.frame.size.height - 240, 35, 35)];
        [crossHair3ImageView setImage:[UIImage imageNamed:@"camera_crosshair"]];
        crossHair3ImageView.transform = CGAffineTransformMakeRotation(M_PI * 1.5);
        
        UIImageView *crossHair4ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, self.view.frame.size.height - 240, 35, 35)];
        [crossHair4ImageView setImage:[UIImage imageNamed:@"camera_crosshair"]];
        crossHair4ImageView.transform = CGAffineTransformMakeRotation(M_PI);
        
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 190, self.view.frame.size.width, 190)];
        [backgroundView setBackgroundColor:[UIColor navColor]];
        UIView *overlayView = [[UIView alloc] initWithFrame:self.view.frame];
        [overlayView addSubview:crossHair1ImageView];
        [overlayView addSubview:crossHair2ImageView];
        [overlayView addSubview:crossHair3ImageView];
        [overlayView addSubview:crossHair4ImageView];
        [overlayView addSubview:backgroundView];
        [overlayView addSubview:closeButton];
        [overlayView addSubview:cameraButton];
        [overlayView addSubview:photoLabel];
        
        
        self.imagePickerController.cameraOverlayView = overlayView;

    }
}

- (BOOL)didLaunchImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] == YES && [self areImagesAvailableForSourceType:sourceType] == YES)
    {
        self.imagePickerController = [UIImagePickerController new];
        
        [self.imagePickerController setSourceType:sourceType];
        [self.imagePickerController setShowsCameraControls:NO];
        [self.imagePickerController setDelegate:self];
        
        [self.imagePickerController setMediaTypes:@[(NSString *)kUTTypeImage]];
        self.imagePickerController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.imagePickerController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        [self setCustomControlsForCamera:self.imagePickerController];

        [self.imagePickerController setModalPresentationStyle:UIModalPresentationOverFullScreen];
        [self presentViewController:self.imagePickerController animated:YES completion:nil];


        return YES;
    }
    else
    {
        return NO;
    }
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

- (void)launchCamera
{
    [self.greenView setHidden:NO];
    [self.blackView setHidden:NO];
    
    [self checkCamera];
}




- (void)checkCamera
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (status) {
            
        case AVAuthorizationStatusAuthorized:
            
            if ([self didLaunchImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera] == NO)
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            break;
            
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:
            
            [self showAlertCameraPrivacy];
            
            break;
            
        case AVAuthorizationStatusNotDetermined:
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(granted)
                    {
                        if ([self didLaunchImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera] == NO)
                        {
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
                    }
                    
                    else
                    {
                        [self showAlertCameraPrivacy];
                    } 
                });
            }];
            break;
    }
    
}

- (void)showAlertCameraPrivacy
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Camera Privacy" message:@"To use this feature we require your camera for verification. We do not store or use the image in any other way." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *privacy = [UIAlertAction actionWithTitle:@"Privacy Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            NSLog(@"Opened Url: %i", success);
        }];

    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Not Now" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
    [alertController addAction:privacy];
    [alertController addAction:cancel];
    
    [alertController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}


- (void)presentImagePickerErrorTitle:(NSString *)title description:(NSString *)desctiption
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:desctiption preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [alertController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)retakePhoto:(id)sender
{
    [self.imageView setHidden:YES];
    [self launchCamera];
}

- (IBAction)saveReceipt:(id)sender
{
    //activity indicator and disable
    
    if(self.redeemTransaction.venue != NULL) {
        [Answers logContentViewWithName:@"Earn transaction" contentType:[NSString stringWithFormat:@"Earn transaction - %@", self.redeemTransaction.venue.name] contentId:@"" customAttributes:@{}];
    }
    
    [[self activityIndicatorView] startAnimating];
    [[self continueButton] setHidden:YES];
    [[self retakeButton] setHidden:YES];
    
    if (self.selectedRedeemID == nil)
    {
        self.selectedRedeemID = [NSNumber numberWithInt:0];
        
    }
    
    [[self userRequest] postEarnTransactionWithBillImage:self.editedImage venueID:self.selectedVenueID transactionID:self.selectedRedeemID withCompletionBlock:^(NSError *error, id results)
    {
        if (error)
        {
            [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusError title:@"Oops" description:@"Something went wrong, please try again later"  style:UIBlurEffectStyleExtraLight actionButtonTitle:nil];
        }
        
        else
        {
            [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusSuccess title:@"Done" description:@"We'll verify your receipt and add the points to your account. You will see your submission and points appear on your Timeline."  style:UIBlurEffectStyleExtraLight actionButtonTitle:nil];
        
        }
        
        [[self activityIndicatorView] stopAnimating];
        [[self continueButton] setHidden:NO]; 
        [[self retakeButton] setHidden:NO];
    }];
}

-(void)readyToDissmisOperationCompletePopupViewController:(DMOperationCompletePopUpViewController *)operationCompletePopupViewController
{
    if (operationCompletePopupViewController.status == DMOperationCompletePopUpViewControllerStatusSuccess)
    {
            [self dismissViewControllerAnimated:YES completion:^{
                [self performSegueWithIdentifier:@"ShowFeedback" sender:nil];
            }];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowFeedback"])
    {
        DMFeedbackViewController *vc = segue.destinationViewController;
        vc.selectedVenueID = self.selectedVenueID;
        
    }
}
@end
