//
//  DMOperationCompletePopUpViewController.h
//  DinerMojo
//
//  Created by hedgehog lab on 14/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMButton.h"

@class DMOperationCompletePopUpViewController;

@protocol DMOperationCompletePopUpViewControllerDelegate <NSObject>

@optional

- (void)readyToDissmisOperationCompletePopupViewController:(DMOperationCompletePopUpViewController *)operationCompletePopupViewController;
- (void)actionButtonPressedFromOperationCompletePopupViewController:(DMOperationCompletePopUpViewController *)operationCompletePopupViewController;

@end

typedef NS_ENUM(NSInteger, DMOperationCompletePopUpViewControllerStatus) {
    DMOperationCompletePopUpViewControllerStatusSuccess = 0,
    DMOperationCompletePopUpViewControllerStatusError = 1,
};

@interface DMOperationCompletePopUpViewController : UIViewController

@property (nonatomic) DMOperationCompletePopUpViewControllerStatus status;
@property (nonatomic, strong) NSString *popUpTitle;
@property (nonatomic, strong) NSString *popUpDescription;
@property UIBlurEffectStyle effectStyle;
@property (nonatomic, weak) IBOutlet UIImageView *statusImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet DMButton *actionButton;
@property (nonatomic, weak) IBOutlet NSString *actionButtonTitle;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, weak) IBOutlet UILabel *tapToDismissLabel;
@property (nonatomic, weak) id <DMOperationCompletePopUpViewControllerDelegate> delegate;

- (IBAction)actionButtonPressed:(DMButton *)sender;

- (void)setActionButtonLoadingState:(BOOL)loadingState;

@end
