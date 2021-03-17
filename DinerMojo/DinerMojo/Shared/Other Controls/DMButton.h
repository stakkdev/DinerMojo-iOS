//
//  DMView.h
//  DinerMojo
//
//  Created by Carl Sanders on 19/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

IB_DESIGNABLE

@interface DMButton : UIButton

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

@property (nonatomic, assign) IBInspectable CGFloat borderWidth;

@property (nonatomic, strong) IBInspectable UIColor *normalBorderColor;

@property (nonatomic, strong) IBInspectable UIColor *highlightBorderColor;

@property (nonatomic, assign) IBInspectable UIColor *backgroundColorForHighlightState;

- (void)toggleInnerShadow:(BOOL)on;

- (void)setBottomBorderHighlightColor:(UIColor *)highlightColor;
@end
