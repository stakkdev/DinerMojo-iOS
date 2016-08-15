//
//  DMUIView.m
//  DinerMojo
//
//  Created by Robert Sammons on 18/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMView.h"

@implementation DMView

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

- (void)setBorderColor:(UIColor*)borderColor
{
    [[self layer] setBorderColor:borderColor.CGColor];
}

@end
