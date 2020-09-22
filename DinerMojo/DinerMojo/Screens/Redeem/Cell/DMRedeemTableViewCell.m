//
//  RedeemTableViewCell.m
//  DinerMojo
//
//  Created by Robert Sammons on 18/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMRedeemTableViewCell.h"

@implementation DMRedeemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _infoHolder.layer.masksToBounds = YES;
    _infoHolder.layer.cornerRadius = 5;
    
    _mainImageView.layer.masksToBounds = YES;
    _mainImageView.layer.cornerRadius = 60;
    
    _cakeImgView.layer.masksToBounds = YES;
    _cakeImgView.layer.cornerRadius = 20;
    
    _timeImgView.layer.masksToBounds = YES;
    _timeImgView.layer.cornerRadius = 11;

    [_imgHolderView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [_imgHolderView.layer setShadowRadius:2.0f];
    [_imgHolderView.layer setShadowOffset:CGSizeMake(0, 2)];
    [_imgHolderView.layer setShadowOpacity:0.8f];
    
    [_cakeHolderView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [_cakeHolderView.layer setShadowRadius:1.0f];
    [_cakeHolderView.layer setShadowOffset:CGSizeMake(-2, 0)];
    [_cakeHolderView.layer setShadowOpacity:0.3f];
    _cakeHolderView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_cakeHolderView.bounds cornerRadius:20].CGPath;
}


- (IBAction)infoAction:(id)sender {
    if([self.delegate respondsToSelector:@selector(infoClicked:)]) {
     //   [self.delegate infoClicked:_infoString];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
