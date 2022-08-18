//
//  DMOperationCompletePopUpViewController.m
//  DinerMojo
//
//  Created by hedgehog lab on 14/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMOperationCompletePopUpViewController.h"
#import "DMPopUpRequest.h"

@implementation DMOperationCompletePopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self updateStatusImage];
    
    [self updateTitle];
    
    if(self.popUpDescriptionAttributed == NULL) {
        [self updateDescription];
    } else {
        [self updateDescriptionAttributed];
    }
    
    [self updateActionButtonTitle];
    
    [self buildBlurEffect];
    self.titleLabel.textColor = self.titleColor;
    
    [self.dontShowAgainButton setHidden:self.shoulHideDontShowAgainButton];
}

#pragma mark - internal methods

- (UIColor *)fontColour
{
    switch (_effectStyle) {
        case UIBlurEffectStyleDark:
            return [UIColor whiteColor];
            break;
        default:
            return [UIColor blackColor];
            break;
    }
}

- (void)buildBlurEffect
{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:_effectStyle];
    UIVisualEffectView *effectBGView = [[UIVisualEffectView alloc] initWithEffect:effect];
    [effectBGView setFrame:[[self view] bounds]];
    [[self view] insertSubview:effectBGView belowSubview:[self statusImageView]];
}

- (void)updateStatusImage
{
    if ([self statusImageView] == nil)
    {
        return;
    }
    
    if (_status == DMOperationCompletePopUpViewControllerStatusSuccess)
    {
        [[self statusImageView] setImage:[UIImage imageNamed:@"success_tick"]];
    } else if (_status == DMOperationCompletePopUpViewControllerNoInternetSuccess) {
        [[self statusImageView] setImage:[UIImage imageNamed:@"success_tick"]];
    }
    else {
        [[self statusImageView] setImage:[UIImage imageNamed:@"fail_cross"]];
    }
}

- (void)updateTitle
{
    if ([self titleLabel] == nil)
    {
        return;
    }
    
    [[self titleLabel] setText:_popUpTitle];
    [[self titleLabel] setTextColor:[self fontColour]];
}

- (void)updateDescription
{
    if ([self descriptionLabel] == nil)
    {
        return;
    }
    
    [[self descriptionLabel] setText:_popUpDescription];
    [[self descriptionLabel] setTextColor:[self fontColour]];
}

- (void)updateDescriptionAttributed
{
    if ([self descriptionLabel] == nil)
    {
        return;
    }
    
    [[self descriptionLabel] setAttributedText:_popUpDescriptionAttributed];
    [[self descriptionLabel] setTextColor:[self fontColour]];
}

- (void)updateActionButtonTitle
{
    if ([self actionButtonTitle] == nil)
    {
        [[self actionButton] setHidden:YES];
        return;
    }
    
    [[self actionButton] setTitle:_actionButtonTitle forState:UIControlStateNormal];
    [[self actionButton] setHidden:NO];
}

#pragma mark - setter methods

- (void)setStatus:(DMOperationCompletePopUpViewControllerStatus)status
{
    _status = status;
    
    [self updateStatusImage];
}

-(void)setColor:(UIColor *)color {
    self.titleColor = color;
}

- (void)setPopUpTitle:(NSString *)popUpTitle
{
    _popUpTitle = popUpTitle;
    
    [self updateTitle];
}

- (void)setPopUpDescription:(NSString *)popUpDescription
{
    _popUpDescription = popUpDescription;
    
    [self updateDescription];
}
- (void)setPopUpDescriptionAttributed:(NSMutableAttributedString *)popUpDescription
{
    _popUpDescriptionAttributed = popUpDescription;
    
    [self updateDescriptionAttributed];
}

- (void)setActionButtonTitle:(NSString *)actionButtonTitle
{
    _actionButtonTitle = actionButtonTitle;
    
    [self updateActionButtonTitle];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self delegate] != nil)
    {
        if ([[self delegate] respondsToSelector:@selector(readyToDissmisOperationCompletePopupViewController:)])
        {
            if ([[self activityIndicatorView] isAnimating] == NO)
            {
                [[self delegate] readyToDissmisOperationCompletePopupViewController:self];
            }
        }
    } else {
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

- (IBAction)actionButtonPressed:(DMButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(actionButtonPressedFromOperationCompletePopupViewController:ofType:)]) {
        [self.delegate actionButtonPressedFromOperationCompletePopupViewController:(DMAfterTransactionPopUpViewController *)self ofType:self.type];
    }
    else if ([[self delegate] respondsToSelector:@selector(actionButtonPressedFromOperationCompletePopupViewController:)])
    {
        [[self delegate] actionButtonPressedFromOperationCompletePopupViewController:self];
    } else {
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

- (IBAction)dontShowAgainButtonPressed:(id)sender {
    //NSLog(@"%@", [NSString stringWithFormat:@"tap tap %@", self.type]);
    int type;
    if ([self.type isEqualToString:@"Booking"]) {
        type = DMAfterTransactionPopUpBookingType;
    } else if ([self.type isEqualToString:@"Referral"]) {
        type = DMAfterTransactionPopUpReferralType;
    } else if ([self.type isEqualToString:@"Redeeming points"]) {
        type = DMAfterTransactionPopUpRedeemingType;
    } else if ([self.type isEqualToString:@"Earn"]) {
        type = DMAfterTransactionPopUpEarnType;
    } else {
        return;
    }
    DMPopUpRequest *request = [[DMPopUpRequest alloc] init];
    [request sendDontShowAgainWithType:type andCompletionBlock:^(NSError *error, id results) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        if ([self delegate] != nil)
        {
            if ([[self delegate] respondsToSelector:@selector(readyToDissmisOperationCompletePopupViewController:)])
            {
                if ([[self activityIndicatorView] isAnimating] == NO)
                {
                    [[self delegate] readyToDissmisOperationCompletePopupViewController:self];
                }
            }
        } else {
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
}

- (void)setActionButtonLoadingState:(BOOL)loadingState
{
    if (loadingState)
    {
        [[self activityIndicatorView] startAnimating];
        [[[self actionButton] titleLabel] setHidden:YES];
        [[self actionButton] setTitle:@"" forState:UIControlStateNormal];
    }
    else
    {
        [[self activityIndicatorView] stopAnimating];
        [[[self actionButton] titleLabel] setHidden:NO];
        [[self actionButton] setTitle:_actionButtonTitle forState:UIControlStateNormal];
    }
}

@end
