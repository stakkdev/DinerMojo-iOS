//
//  DMRedeemCouponViewController.m
//  DinerMojo
//
//  Created by Robert Sammons on 17/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMRedeemCouponViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Shimmer/FBShimmeringView.h>
#import "DMVenueImage.h"
#import "DMDineNavigationController.h"
#import "DMEarnReviewViewController.h"
#import <SDWebImage/SDWebImage.h>


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
    self.randomCodeLabel.text = [self getRandomCode];

    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(animate) userInfo:nil repeats:YES];
    [self decorateInterface];
    
    
}

- (NSString *)getRandomCode {
    return [NSString stringWithFormat:@"%d%d%d%d", arc4random_uniform(9),arc4random_uniform(9),arc4random_uniform(9),arc4random_uniform(9)];
}

- (void)decorateInterface
{
    [self.venueNameLabel setText:self.selectedVenue.name];
    [self.venueCuisineAreaLabel setText:[NSString stringWithFormat:@"%@ | %@", [[[self.selectedVenue categories] anyObject] name], self.selectedVenue.town]];
    self.currentUser = [[self userRequest] currentUser];
    [self.userPointsLabel setAdjustsFontSizeToFitWidth:YES];
    [self.userPointsLabel setMinimumScaleFactor:0];
    [self.userPointsLabel setText:[NSString stringWithFormat:@"%@", self.currentUser.annual_points_balance]];
    DMVenueImage *venueImage = (DMVenueImage *) [self.selectedVenue primaryImage];
    
    [self.venueImageView sd_setImageWithURL:[NSURL URLWithString:[venueImage fullURL]]
                 placeholderImage:nil];
    
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
        if (input) {
            [session addInput:input];
            
            [session startRunning];
        }
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
    [self.dateLabel setText:[NSString stringWithFormat:@"Valid: %@ at %@",
                             [self.dateFormatTodaysDate stringFromDate:self.todaysDate],
                             [self.dateFormatTimeDate stringFromDate:[NSDate date]]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowEarnRedeem"]) {
        DMDineNavigationController *nav = segue.destinationViewController;
        [nav setDineNavigationDelegate:self];
        DMEarnReviewViewController *earnViewController = nav.viewControllers.firstObject;
        earnViewController.selectedVenueID = self.selectedVenue.modelID;
        earnViewController.selectedRedeemID = self.selectedRedeemID;
        earnViewController.hasRedeemed = YES;
    }
}

- (IBAction)done:(id)sender {
    [[self selectedVenue] setLast_redeem:[[NSDate alloc] init]];
    [[self selectedVenue] setLast_redeem_name:self.selectedOfferItem.title];
    //self.selectedOfferItem.title
    //reset brightness
    [[UIScreen mainScreen] setBrightness: brightness];
    [self presentAfterTransactionPopUp];
}

- (IBAction)share:(id)sender {
    [[self selectedVenue] setLast_redeem:[[NSDate alloc] init]];
    [[self selectedVenue] setLast_redeem_name:self.selectedOfferItem.title];
    //reset brightness
    [[UIScreen mainScreen] setBrightness: brightness];
    
    FacebookShareManager *fbManager = [[FacebookShareManager alloc] init];
    [fbManager shareWithPresentingVC:self url:@"http://google.pl"];
}

- (void)presentAfterTransactionPopUp {
    [AfterTransactionPopUpManager downloadPopUpModelForVenue:self.selectedVenue.modelIDValue completion:^(PopUpModel *model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!model) {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                return;
            }
            DMOperationCompletePopUpViewController* popUpVc = [AfterTransactionPopUpManager createPopUpWithModel:model forDelegate:self];
            [popUpVc setModalPresentationStyle:UIModalPresentationOverFullScreen];
            [self presentViewController:popUpVc animated:YES completion:nil];
        });
    }];
}

- (void)actionButtonPressedFromOperationCompletePopupViewController:(DMOperationCompletePopUpViewController *)operationCompletePopupViewController {
    [operationCompletePopupViewController dismissViewControllerAnimated:YES completion:nil];
    [(DMDineNavigationController *)[self navigationController] dineComplete];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionButtonPressedFromOperationCompletePopupViewController:(DMAfterTransactionPopUpViewController *)operationCompletePopupViewController ofType:(NSString *)type {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    if ([type isEqualToString:@"Booking"] || [type isEqualToString:@"Redeeming points"] || [type isEqualToString:@"Earn"]) {
        DMRestaurantInfoViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DMRestaurantInfo"];
        DMVenue *venue = [DMVenue MR_findFirstByAttribute:@"modelID" withValue:operationCompletePopupViewController.venueId];
        [vc setSelectedVenue:venue];
        [(DMDineNavigationController *)[self navigationController] dineCompleteWithVc:vc];
    } else if ([type isEqualToString:@"Referral"]) {
        DMReferAFriendViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DMReferAFriendViewController"];
        DMUser *user = [self.userRequest currentUser];
        int16_t points = user.referred_pointsValue;
        vc.referredPoints = [NSString stringWithFormat:@"%hd", points];
        [(DMDineNavigationController *)[self navigationController] dineCompleteWithVc:vc];
    }
}

- (void)readyToDismissCompletedDineNavigationController:(DMDineNavigationController *)dineNavigationController
{
   [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)readyToDismissCancelledDineNavigationController:(DMDineNavigationController *)dineNavigationController
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion: nil];
}

- (void)readyToDissmisOperationCompletePopupViewController:(DMOperationCompletePopUpViewController *)operationCompletePopupViewController
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
    
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer { }

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    [self presentAfterTransactionPopUp];
    DMVenueRequest *request = [[DMVenueRequest alloc] init];
    [request shareReceivePoints:^(NSError *error, id results) { }];
}
    
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error { }
  
@end
   
