//
//  DMUIView.h
//  DinerMojo
//
//  Created by Robert Sammons on 18/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

IB_DESIGNABLE

@interface DMView : UIView

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable UIColor* borderColor;

@end
