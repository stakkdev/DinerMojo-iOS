//
//  DMImageView.h
//  DinerMojo
//
//  Created by Robert Sammons on 04/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

IB_DESIGNABLE

@interface DMImageView : UIImageView

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable UIColor* borderColor;

@end
