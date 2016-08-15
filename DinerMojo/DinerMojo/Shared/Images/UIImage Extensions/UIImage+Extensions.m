//
//  UIImage+Extensions.m
//  Tastars
//
//  Created by Sam Miller on 07/10/2014.
//  Copyright (c) 2014 hedghehog lab. All rights reserved.
//

#import "UIImage+Extensions.h"

@implementation UIImage (Extensions)

- (UIImage *)imageWithTintedWithColor:(UIColor *)color
{
    // Construct new image
    UIImage *image;
    UIGraphicsBeginImageContextWithOptions([self size], NO, 0.0);
    CGRect rect = CGRectZero;
    rect.size = [self size];
    
    // Apply tint
    [self drawInRect:rect];
    [color set];
    UIRectFillUsingBlendMode(rect, kCGBlendModeNormal);
    
    // Restore Alpha Channel
    [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    
    // Return the image
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)resize:(CGSize)size
{
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

- (UIImage *)scaledImageForScale:(CGFloat)scale
{
    CGSize adjustedSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
    return [self resize:adjustedSize];
}

@end
