//
//  DMShadowImageView.m
//  DinerMojo
//
//  Created by Carl Sanders on 10/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMShadowImageView.h"

@interface DMShadowImageView ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation DMShadowImageView


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.gradientLayer = [CAGradientLayer layer];
        [self.layer insertSublayer:self.gradientLayer above:self.layer];
    }
    return self;
}

-(void)layoutSubviews;
{
    [super layoutSubviews];
    
    self.gradientLayer.colors = [NSArray arrayWithObjects:
                    (id)[[[UIColor blackColor] colorWithAlphaComponent:0.0f] CGColor],
                    (id)[[[UIColor blackColor] colorWithAlphaComponent:0.6f] CGColor],
                    (id)[[[UIColor blackColor] colorWithAlphaComponent:0.8f] CGColor], nil];
    
    self.gradientLayer.frame = CGRectMake(0,
                                          CGRectGetMaxY(self.frame)-80,
                                          self.frame.size.width + 20,
                                          80);
}

@end
