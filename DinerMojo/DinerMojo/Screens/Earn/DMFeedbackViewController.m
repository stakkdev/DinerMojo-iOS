//
//  DMFeedbackViewController.m
//  DinerMojo
//
//  Created by Robert Sammons on 24/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMFeedbackViewController.h"
#import "DMOperationCompletePopUpViewController.h"
#import "DMDineNavigationController.h"
#import "DMAfterTransactionPopUpViewController.h"
#import "DinerMojo-Swift.h"
#import "DMRestaurantInfoViewController.h"
#import "DMReferAFriendViewController.h"

@interface DMFeedbackViewController ()

@property (nonatomic) BOOL didDisplayAfterTransactionPopup;

@end

@implementation DMFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _didDisplayAfterTransactionPopup = NO;
    _didSend = YES;
    DMVenue *selectedVenue = [DMVenue MR_findFirstByAttribute:@"modelID" withValue:self.selectedVenueID];
    [self.feedbackDescriptionLabel setText:[NSString stringWithFormat:@"Let %@ know what you think", selectedVenue.name]];
//    [self.feedbackDescriptionLabel setFont:[UIFont italicSystemFontOfSize:22.0]];
//    [self.feedbackDescriptionLabel setNumberOfLines:2];
    self.selectedRating = [NSNumber numberWithInt:0];
}

- (IBAction)ratingOnePressed:(id)sender {
    [self setRatingImages:[NSNumber numberWithInt:1]];
}

- (IBAction)ratingTwoPressed:(id)sender {
    [self setRatingImages:[NSNumber numberWithInt:2]];
}

- (IBAction)ratingThreePressed:(id)sender {
    [self setRatingImages:[NSNumber numberWithInt:3]];
}

- (IBAction)ratingFourPressed:(id)sender {
    [self setRatingImages:[NSNumber numberWithInt:4]];
}

- (IBAction)ratingFivePressed:(id)sender {
    [self setRatingImages:[NSNumber numberWithInt:5]];
}

- (void)setRatingImages:(NSNumber *)number {
    self.selectedRating = number;
    int index = 1;
    NSArray *buttons = @[self.ratingOneButton, self.ratingTwoButton, self.ratingThreeButton, self.ratingFourButton, self.ratingFiveButton];
    for (UIButton *button in buttons) {
        NSString *imageTitle = (index <= [number intValue] ? @"StarFilled" : @"StarUnfilled");
        [button setImage:[UIImage imageNamed:imageTitle] forState:UIControlStateNormal];
        index++;
    }
}

- (IBAction)submitFeedback:(id)sender {
    if ([self.selectedRating isEqualToNumber:[NSNumber numberWithInt:0]])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Select a rating" message:@"To submit feedback we require a rating." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:ok];
        
        [alertController setModalPresentationStyle:UIModalPresentationOverFullScreen];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        if(_didSend) {
            _didSend = NO;
            DMUserRequest *userRequest = [DMUserRequest new];
            [userRequest postFeedbackWithText:self.feedbackTextView.text rating:self.selectedRating venueID:self.selectedVenueID withCompletionBlock:^(NSError *error, id results) {
                if (error)
                {
                    [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusError title:@"Oops" description:@"Something went wrong, please try again later"  style:UIBlurEffectStyleExtraLight actionButtonTitle:nil];
                }
                else
                {
                    [self presentOperationCompleteViewControllerWithStatus:DMOperationCompletePopUpViewControllerStatusSuccess title:@"Thank you" description:@"Feedback successfully sent"  style:UIBlurEffectStyleExtraLight actionButtonTitle:nil];
                }
            }];
            
        }
    }
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [[self feedbackPlaceholderTextView] setHidden:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.feedbackTextView.text isEqualToString:@""])
    {
        [[self feedbackPlaceholderTextView] setHidden:NO];
    }
}

- (IBAction)skipFeedback:(id)sender {
    [self presentAfterTransactionPopUp];
}

- (void)presentAfterTransactionPopUp {
    [AfterTransactionPopUpManager downloadPopUpModelForVenue:[self.selectedVenueID integerValue] completion:^(PopUpModel *model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!model) {
                [(DMDineNavigationController *)[self navigationController] dineComplete];
                return;
            }
            DMOperationCompletePopUpViewController* popUpVc = [AfterTransactionPopUpManager createPopUpWithModel:model forDelegate:self];
            [popUpVc setModalPresentationStyle:UIModalPresentationOverFullScreen];
            [self presentViewController:popUpVc animated:YES completion:nil];
        });
    }];
}

# pragma mark: DMOperationCompletePopUpViewControllerDelegate delegate

-(void)readyToDissmisOperationCompletePopupViewController:(DMOperationCompletePopUpViewController *)operationCompletePopupViewController
{
    if (self.didDisplayAfterTransactionPopup) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        self.didDisplayAfterTransactionPopup = YES;
        if (operationCompletePopupViewController.status == DMOperationCompletePopUpViewControllerStatusSuccess)
        {
            [operationCompletePopupViewController dismissViewControllerAnimated:YES completion:nil];
            [self presentAfterTransactionPopUp];
        }
    }
    
}

-(void)actionButtonPressedFromOperationCompletePopupViewController:(DMOperationCompletePopUpViewController *)operationCompletePopupViewController {
    [(DMDineNavigationController *)[self navigationController] dineComplete];
}

- (void)actionButtonPressedFromOperationCompletePopupViewController:(DMAfterTransactionPopUpViewController *)operationCompletePopupViewController ofType:(NSString *)type {
    [operationCompletePopupViewController dismissViewControllerAnimated:YES completion:nil];
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

@end
