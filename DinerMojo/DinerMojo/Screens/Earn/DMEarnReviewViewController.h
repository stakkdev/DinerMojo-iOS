//
//  DMEarnReviewViewController.h
//  DinerMojo
//
//  Created by Robert Sammons on 24/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMViewController.h"
#import "DMDineNavigationController.h"
#import "DMTransaction.h"
#import "DMRedeemTransaction.h"


@interface DMEarnReviewViewController : DMViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, DMOperationCompletePopUpViewControllerDelegate, DMDineNavigationControllerControllerDelegate>

- (IBAction)retakePhoto:(id)sender;
- (IBAction)saveReceipt:(id)sender;


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImage *image;

@property NSNumber *selectedVenueID;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIButton *retakeButton;

@property (weak, nonatomic) IBOutlet UIView *greenView;
@property (weak, nonatomic) IBOutlet UIView *blackView;

@property BOOL hasRedeemed;
@property NSNumber *selectedRedeemID;
@property DMRedeemTransaction *redeemTransaction;

@property UIImagePickerController *imagePickerController;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@end
