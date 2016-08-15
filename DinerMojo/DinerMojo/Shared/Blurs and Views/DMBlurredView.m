//
//  DMBlurredView.m
//  DinerMojo
//
//  Created by hedgehog lab on 11/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMBlurredView.h"

@implementation DMBlurredView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self setAlpha:0.0];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)animateBlurInWithInterval:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:duration animations:^{
        [self setAlpha:1.0];
    } completion:completion];
}

- (void)animateBlurOutWithInterval:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:duration animations:^{
        [self setAlpha:0.0];
    } completion:completion];
}

- (void)viewTapped:(id)sender
{
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(tapFromBlurredView:)])
    {
        [[self delegate] tapFromBlurredView:self];
    }
}

@end
