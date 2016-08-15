//
//  UIImage+Extensions.h
//  Tastars
//
//  Created by Sam Miller on 07/10/2014.
//  Copyright (c) 2014 hedghehog lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Extensions)

- (UIImage *)imageWithTintedWithColor:(UIColor *)color;
- (UIImage *)resize:(CGSize)size;
- (UIImage *)scaledImageForScale:(CGFloat)scale;

@end
