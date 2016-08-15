//
//  DMOperationCompletePopUpViewController.m
//  DinerMojo
//
//  Created by hedgehog lab on 14/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMOperationCompletePopUpViewController.h"

@implementation DMOperationCompletePopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self updateStatusImage];
    
    [self updateTitle];
    
    [self updateDescription];
    
    [self updateActionButtonTitle];
    
    [self buildBlurEffect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    }
    else
    {
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
    }
}

- (IBAction)actionButtonPressed:(DMButton *)sender
{
    if ([[self delegate] respondsToSelector:@selector(actionButtonPressedFromOperationCompletePopupViewController:)])
    {
        [[self delegate] actionButtonPressedFromOperationCompletePopupViewController:self];
    }
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
