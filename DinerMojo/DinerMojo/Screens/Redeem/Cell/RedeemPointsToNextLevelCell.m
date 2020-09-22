//
//  RedeemPointsToNextLevelCell.m
//  DinerMojo
//
//  Created by Jaroslav Chaninovicz on 16/02/2018.
//  Copyright © 2018 hedgehog lab. All rights reserved.
//

#import "RedeemPointsToNextLevelCell.h"

@implementation RedeemPointsToNextLevelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _pointsHolderView.clipsToBounds = YES;
    _pointsHolderView.layer.cornerRadius = 5;
}

@end
