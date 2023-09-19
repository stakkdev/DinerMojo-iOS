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
@property BOOL selectedQuestion1;
@property BOOL selectedQuestion2;
@property BOOL selectedQuestion3;
- (IBAction)ratingOnePressed:(id)sender;
- (IBAction)ratingTwoPressed:(id)sender;
- (IBAction)ratingThreePressed:(id)sender;
- (IBAction)ratingFourPressed:(id)sender;
- (IBAction)ratingFivePressed:(id)sender;
- (IBAction)submitFeedback:(id)sender;
- (IBAction)question1Action:(id)sender;
- (IBAction)question2Action:(id)sender;
- (IBAction)question3Action:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *question1ViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *question1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *question2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *question3ImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;

@end
