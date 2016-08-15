//
//  DMRedeemCouponViewController.m
//  DinerMojo
//
//  Created by Robert Sammons on 17/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMRedeemCouponViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FBShimmeringView.h"
#import "DMVenueImage.h"
#import "DMDineNavigationController.h"
#import "DMEarnReviewViewController.h"


@interface DMRedeemCouponViewController ()
{
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
    CGFloat brightness;
}

@end

@implementation DMRedeemCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.todaysDate = [NSDate date];
    
    self.dateFormatTodaysDate = [[NSDateFormatter alloc] init];
    [self.dateFormatTodaysDate setDateFormat:@"d MMM ''yy"];
    
    self.dateFormatTimeDate = [[NSDateFormatter alloc] init];
    [self.dateFormatTimeDate setDateFormat:@"HH:mm:ss"];
    
    [self.dateLabel setText:[NSString stringWithFormat:@"Valid: %@ at %@", [self.dateFormatTodaysDate stringFromDate:self.todaysDate], [self.dateFormatTimeDate stringFromDate:[NSDate date]]]];
    
    
    self.viewForShimmer.shimmering = YES;
    self.viewForShimmer.shimmeringBeginFadeDuration = 0.1;
    self.viewForShimmer.shimmeringOpacity = 1;
    self.viewForShimmer.alpha = 0.6;
    [self.viewToShimmer setBackgroundColor:[UIColor brandColor]];
    self.viewForShimmer.contentView = self.viewToShimmer;

    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(animate) userInfo:nil repeats:YES];
    [self decorateInterface];
    
    
}

- (void)decorateInterface
{
    [self.venueNameLabel setText:self.selectedVenue.name];
    [self.venueCuisineAreaLabel setText:[NSString stringWithFormat:@"%@ | %@", [[[self.selectedVenue categories] anyObject] name], self.selectedVenue.town]];
    self.currentUser = [[self userRequest] currentUser];
    [self.userPointsLabel setText:[NSString stringWithFormat:@"%@", self.currentUser.annual_points_balance]];
    DMVenueImage *venueImage = (DMVenueImage *) [self.selectedVenue primaryImage];
    
    NSURL *url = [NSURL URLWithString:[venueImage fullURL]];
    [self.venueImageView setImageWithURL:url];
    
    [self.offerDescriptionLabel setText:self.selectedOfferItem.title];
    
}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    captureVideoPreviewLayer.frame = self.pictureImageView.frame;

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    brightness = [UIScreen mainScreen].brightness;
    [[UIScreen mainScreen] setBrightness: 1.0];

    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        AVCaptureSession *session = [[AVCaptureSession alloc] init];
        session.sessionPreset = AVCaptureSessionPresetMedium;
        
        captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
        [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        captureVideoPreviewLayer.frame = self.pictureImageView.frame;

        captureVideoPreviewLayer.cornerRadius = self.pictureImageView.layer.cornerRadius;
        [self.view.layer addSublayer:captureVideoPreviewLayer];
        
        AVCaptureDevice *device = [self frontCamera];
        
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (!input) {
        }
        [session addInput:input];
        
        [session startRunning];
        
    }

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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (AVCaptureDevice *)frontCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    return nil;
}

- (void)animate
{
    [self.dateLabel setText:[NSString stringWithFormat:@"Valid: %@ at %@", [self.dateFormatTodaysDate stringFromDate:self.todaysDate], [self.dateFormatTimeDate stringFromDate:[NSDate date]]]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowEarnRedeem"]) {
        
        DMEarnReviewViewController *earnViewController = segue.destinationViewController;
        earnViewController.selectedVenueID = self.selectedVenue.modelID;
        earnViewController.selectedRedeemID = self.selectedRedeemID;
        earnViewController.hasRedeemed = YES;
    }
}

- (IBAction)done:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"You can earn points immediately or at a later point." preferredStyle:UIAlertControllerStyleActionSheet];
    
//    alertController.view.tintColor = [UIColor brandColor];

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Close Voucher" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        //reset brightness
        [[UIScreen mainScreen] setBrightness: brightness];
        
        [(DMDineNavigationController *)[self navigationController] dineComplete];
        
        
        
    }];
    
    UIAlertAction *earn = [UIAlertAction actionWithTitle:@"Earn Points" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        //reset brightness
        [[UIScreen mainScreen] setBrightness: brightness];
        
        [self performSegueWithIdentifier:@"ShowEarnRedeem" sender:nil];
        
    }];
    

    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alertController addAction:ok];
    [alertController addAction:earn];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
