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

@interface DMFeedbackViewController ()

@end

@implementation DMFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DMVenue *selectedVenue = [DMVenue MR_findFirstByAttribute:@"modelID" withValue:self.selectedVenueID];
    [self.feedbackDescriptionLabel setText:[NSString stringWithFormat:@"Let %@ know what you think", selectedVenue.name]];
    self.selectedRating = [NSNumber numberWithInt:0];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ratingOnePressed:(id)sender {
    self.selectedRating = [NSNumber numberWithInt:1];
    [self.ratingOneButton setImage:[UIImage imageNamed:@"StarFilled"] forState:UIControlStateNormal];
    [self.ratingTwoButton setImage:[UIImage imageNamed:@"StarUnfilled"] forState:UIControlStateNormal];
    [self.ratingThreeButton setImage:[UIImage imageNamed:@"StarUnfilled"] forState:UIControlStateNormal];
    [self.ratingFourButton setImage:[UIImage imageNamed:@"StarUnfilled"] forState:UIControlStateNormal];
    [self.ratingFiveButton setImage:[UIImage imageNamed:@"StarUnfilled"] forState:UIControlStateNormal];
}

- (IBAction)ratingTwoPressed:(id)sender {
    self.selectedRating = [NSNumber numberWithInt:2];
    [self.ratingOneButton setImage:[UIImage imageNamed:@"StarFilled"] forState:UIControlStateNormal];
    [self.ratingTwoButton setImage:[UIImage imageNamed:@"StarFilled"] forState:UIControlStateNormal];
    [self.ratingThreeButton setImage:[UIImage imageNamed:@"StarUnfilled"] forState:UIControlStateNormal];
    [self.ratingFourButton setImage:[UIImage imageNamed:@"StarUnfilled"] forState:UIControlStateNormal];
    [self.ratingFiveButton setImage:[UIImage imageNamed:@"StarUnfilled"] forState:UIControlStateNormal];
}

- (IBAction)ratingThreePressed:(id)sender {
    self.selectedRating = [NSNumber numberWithInt:3];
    [self.ratingOneButton setImage:[UIImage imageNamed:@"StarFilled"] forState:UIControlStateNormal];
    [self.ratingTwoButton setImage:[UIImage imageNamed:@"StarFilled"] forState:UIControlStateNormal];
    [self.ratingThreeButton setImage:[UIImage imageNamed:@"StarFilled"] forState:UIControlStateNormal];
    [self.ratingFourButton setImage:[UIImage imageNamed:@"StarUnfilled"] forState:UIControlStateNormal];
    [self.ratingFiveButton setImage:[UIImage imageNamed:@"StarUnfilled"] forState:UIControlStateNormal];
}

- (IBAction)ratingFourPressed:(id)sender {
    self.selectedRating = [NSNumber numberWithInt:4];
    [self.ratingOneButton setImage:[UIImage imageNamed:@"StarFilled"] forState:UIControlStateNormal];
    [self.ratingTwoButton setImage:[UIImage imageNamed:@"StarFilled"] forState:UIControlStateNormal];
    [self.ratingThreeButton setImage:[UIImage imageNamed:@"StarFilled"] forState:UIControlStateNormal];
    [self.ratingFourButton setImage:[UIImage imageNamed:@"StarFilled"] forState:UIControlStateNormal];
    [self.ratingFiveButton setImage:[UIImage imageNamed:@"StarUnfilled"] forState:UIControlStateNormal];
}

- (IBAction)ratingFivePressed:(id)sender {
    self.selectedRating = [NSNumber numberWithInt:5];
    [self.ratingOneButton setImage:[UIImage imageNamed:@"StarFilled"] forState:UIControlStateNormal];
    [self.ratingTwoButton setImage:[UIImage imageNamed:@"StarFilled"] forState:UIControlStateNormal];
    [self.ratingThreeButton setImage:[UIImage imageNamed:@"StarFilled"] forState:UIControlStateNormal];
    [self.ratingFourButton setImage:[UIImage imageNamed:@"StarFilled"] forState:UIControlStateNormal];
    [self.ratingFiveButton setImage:[UIImage imageNamed:@"StarFilled"] forState:UIControlStateNormal];
}

- (IBAction)submitFeedback:(id)sender {
    
    if ([self.selectedRating isEqualToNumber:[NSNumber numberWithInt:0]])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Select a rating" message:@"To submit feedback we require a rating." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
    }
    
    else
        
    {
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

-(void)readyToDissmisOperationCompletePopupViewController:(DMOperationCompletePopUpViewController *)operationCompletePopupViewController
{
    if (operationCompletePopupViewController.status == DMOperationCompletePopUpViewControllerStatusSuccess)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            [(DMDineNavigationController *)[self navigationController] dineComplete];
        }];
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
    [(DMDineNavigationController *)[self navigationController] dineComplete];
}

@end
