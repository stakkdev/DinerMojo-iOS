//
//  DMView.m
//  DinerMojo
//
//  Created by Carl Sanders on 19/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMButton.h"
#import "UIView+InnerShadow.h"

@interface DMButton ()

@property (strong, nonatomic) UIColor *originalBackgroundColor;
@end

@implementation DMButton

- (void)toggleInnerShadow:(BOOL)on {
    if(on) {
        [self addInnerShadowWithRadius:6.0f andAlpha:0.1f];
    } else {
        [self removeInnerShadow];
    }
}

- (CGFloat)cornerRadius
{
    return [self layer].cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    [[self layer] setCornerRadius:cornerRadius];
    [[self layer] setMasksToBounds:(cornerRadius > 0)];
}

- (CGFloat)borderWidth
{
    return [self layer].borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    [[self layer] setBorderWidth:borderWidth];
}

- (void)setBottomBorderHighlightColor:(UIColor*)highlightColor
{
    CGFloat width = [self layer].frame.size.width;
    CGFloat height = [self layer].frame.size.height;
    CGRect frame = CGRectMake(0, height - 5, width, 5);
    UIView *bottomBorder = [[UIView alloc] initWithFrame:frame];
    bottomBorder.backgroundColor = highlightColor;
    [self addSubview:bottomBorder];
}

- (void)setNormalBorderColor:(UIColor *)normalBorderColor
{
    _normalBorderColor = normalBorderColor;
    
    if (![self isHighlighted])
    {
        [[self layer] setBorderColor:_normalBorderColor.CGColor];
    }
}

- (void)setHighlightBorderColor:(UIColor *)highlightBorderColor
{
    _highlightBorderColor = highlightBorderColor;
    
    if ([self isHighlighted])
    {
        [[self layer] setBorderColor:_highlightBorderColor.CGColor];
    }
}

- (void)setBackgroundColorForHighlightState:(UIColor *)backgroundColorForHighlightState
{
    _backgroundColorForHighlightState = backgroundColorForHighlightState;
    
    _originalBackgroundColor = [self backgroundColor];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if ([self backgroundColorForHighlightState] != nil)
    {
        if (highlighted)
        {
            [self setBackgroundColor:_backgroundColorForHighlightState];
            [[self layer] setBorderColor:_highlightBorderColor.CGColor];
        }
        else
        {
            [self setBackgroundColor:_originalBackgroundColor];
            [[self layer] setBorderColor:_normalBorderColor.CGColor];
        }
    }
}

@end
