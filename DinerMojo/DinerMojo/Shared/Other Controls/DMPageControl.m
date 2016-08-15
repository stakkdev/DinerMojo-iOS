//
//  DMPageControl.m
//  DinerMojo
//
//  Created by Robert Sammons on 08/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMPageControl.h"

@implementation DMPageControl

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    self.activeImage = [UIImage imageNamed:@"ActivePageControl"];
    self.inactiveImage = [UIImage imageNamed:@"InactivePageControl"];
    
    return self;
}

-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView * dot = [self imageViewForSubview:  [self.subviews objectAtIndex: i]];
        if (i == self.currentPage) dot.image = self.activeImage;
        else dot.image = self.inactiveImage;
    }
}
- (UIImageView *) imageViewForSubview: (UIView *) view
{
    UIImageView * dot = nil;
    if ([view isKindOfClass: [UIView class]])
    {
        for (UIView* subview in view.subviews)
        {
            if ([subview isKindOfClass:[UIImageView class]])
            {
                dot = (UIImageView *)subview;
                break;
            }
        }
        if (dot == nil)
        {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height)];
            [view addSubview:dot];
        }
    }
    else
    {
        dot = (UIImageView *) view;
    }
    
    return dot;
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}
@end
