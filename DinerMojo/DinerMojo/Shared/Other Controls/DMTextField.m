//
//  DMTextField.m
//  DinerMojo
//
//  Created by hedgehog lab on 03/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMTextField.h"

@implementation DMTextField

- (void)setLeftIndent:(CGFloat)leftIndent
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, leftIndent, self.bounds.size.height)];
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

@end
