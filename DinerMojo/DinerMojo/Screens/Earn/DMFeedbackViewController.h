//
//  DMFeedbackViewController.h
//  DinerMojo
//
//  Created by Robert Sammons on 24/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMFeedbackViewController : DMTabBarViewController <UITextViewDelegate, DMOperationCompletePopUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;
@property (weak, nonatomic) IBOutlet UITextView *feedbackPlaceholderTextView;

@property (weak, nonatomic) IBOutlet UIButton *ratingOneButton;
@property (weak, nonatomic) IBOutlet UIButton *ratingTwoButton;
@property (weak, nonatomic) IBOutlet UIButton *ratingThreeButton;
@property (weak, nonatomic) IBOutlet UIButton *ratingFourButton;
@property (weak, nonatomic) IBOutlet UIButton *ratingFiveButton;

@property (weak, nonatomic) IBOutlet UILabel *feedbackDescriptionLabel;

@property BOOL didSend;
@property NSNumber *selectedVenueID;
@property NSNumber *selectedRating;
- (IBAction)ratingOnePressed:(id)sender;
- (IBAction)ratingTwoPressed:(id)sender;
- (IBAction)ratingThreePressed:(id)sender;
- (IBAction)ratingFourPressed:(id)sender;
- (IBAction)ratingFivePressed:(id)sender;
- (IBAction)submitFeedback:(id)sender;

@end
