//
//  DMOperationCompletePopUpViewController.h
//  DinerMojo
//
//  Created by hedgehog lab on 14/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMButton.h"

@class DMOperationCompletePopUpViewController;
@class DMAfterTransactionPopUpViewController;

@protocol DMOperationCompletePopUpViewControllerDelegate <NSObject>

@optional

- (void)readyToDissmisOperationCompletePopupViewController:(DMOperationCompletePopUpViewController *)operationCompletePopupViewController;
- (void)actionButtonPressedFromOperationCompletePopupViewController:(DMOperationCompletePopUpViewController *)operationCompletePopupViewController;
- (void)actionButtonPressedFromOperationCompletePopupViewController:(DMAfterTransactionPopUpViewController *)operationCompletePopupViewController ofType:(NSString *)type;

@end

typedef NS_ENUM(NSInteger, DMOperationCompletePopUpViewControllerStatus) {
    DMOperationCompletePopUpViewControllerStatusSuccess = 0,
    DMOperationCompletePopUpViewControllerStatusError = 1,
};

@interface DMOperationCompletePopUpViewController : UIViewController

@property (nonatomic) DMOperationCompletePopUpViewControllerStatus status;
@property (nonatomic, strong) NSString *popUpTitle;
@property (nonatomic, strong) NSString *popUpDescription;
@property (nonatomic, strong) NSAttributedString *popUpDescriptionAttributed;
@property UIBlurEffectStyle effectStyle;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, weak) IBOutlet UIImageView *statusImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet DMButton *actionButton;
@property (nonatomic, weak) IBOutlet NSString *actionButtonTitle;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, weak) IBOutlet UILabel *tapToDismissLabel;
@property (weak, nonatomic) IBOutlet UIButton *dontShowAgainButton;
@property BOOL shoulHideDontShowAgainButton;
@property (nonatomic, weak) id <DMOperationCompletePopUpViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *type;
@property (nonatomic, strong) NSNumber *venueId;

- (IBAction)actionButtonPressed:(DMButton *)sender;
- (IBAction)dontShowAgainButtonPressed:(id)sender;

- (void)setActionButtonLoadingState:(BOOL)loadingState;
- (void)setColor:(UIColor *)color;

@end
