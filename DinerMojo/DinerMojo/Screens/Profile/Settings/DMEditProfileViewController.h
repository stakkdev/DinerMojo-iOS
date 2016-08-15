//
//  DMEditProfileViewController.h
//  DinerMojo
//
//  Created by Robert Sammons on 16/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "PMEDatePicker.h"

@interface DMEditProfileViewController : DMTabBarViewController <PMEDatePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet PMEDatePicker *datePicker;

- (IBAction)revealDatePicker:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *surnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *postcodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UIButton *dateDownArrowButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileInitialsLabel;
@property (weak, nonatomic) IBOutlet DMView *profilePictureView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *closeDatePicker;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePickerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePickerBottomConstraint;

@property UIImage *selectedImage;
@property NSDate *selectedDate;
- (IBAction)pictureChooserPressed:(id)sender;

- (IBAction)deleteAccount:(id)sender;
- (IBAction)saveAccount:(id)sender;

- (IBAction)editingChanged:(UITextField *)sender;
- (IBAction)dismissDatePicker:(id)sender;

@end
