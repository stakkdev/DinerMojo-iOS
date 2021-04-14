//
//  VenueCollectionViewCell.m
//  DinerMojo
//
//  Created by James Shaw on 05/02/2021.
//  Copyright © 2021 hedgehog lab. All rights reserved.
//

#import "VenueCollectionViewCell.h"

@implementation VenueCollectionViewCell

- (void)awakeFromNib {
    
    // Initialization code
    [super awakeFromNib];
    [[self selectedBackgroundView] setBackgroundColor:[UIColor redColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [[self selectedBackgroundView] setHidden:YES];
}
//
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [[self selectedBackgroundView] setHidden:YES];
}

- (IBAction)earnAction:(id)sender {
    
    if(self.delegate != nil) {
        [self.delegate didSelectEarn:self.index];
    }
}

- (IBAction)redeemAction:(id)sender {
    if(self.delegate != nil) {
        [self.delegate didSelectRedeem:self.index];
    }
}
- (IBAction)favouriteButtonAction:(id)sender {
    if(self.delegate != nil) {
        [self.delegate didSelectFavourite:!self.isFavourite atIndex:self.index];
    }
}

- (void)setRedeemVisibility:(BOOL)visibility {
    if(visibility) {
        [self.earnButton setImage:[UIImage imageNamed:@"redeem_icon_enabled"] forState:UIControlStateNormal];
    }
    else {
        [self.earnButton setImage:[UIImage imageNamed:@"redeem_icon_disabled"] forState:UIControlStateNormal];
    }
}

- (void)setToFavourite:(BOOL)favourite {
    [self setIsFavourite:favourite];
    if(favourite) {
        [self.heartImage setImage:[UIImage imageNamed:@"heartRed"]];
    }
    else {
        [self.heartImage setImage:[UIImage imageNamed:@"heartWhite"]];
    }
}

- (void)setShowFavoriteButton:(BOOL)show {
    [self.heartImage setHidden:!show];
    [self.favouriteButton setHidden:!show];
}

- (void)setEarnVisibility:(BOOL)visibility {
    if(visibility) {
        [self.redeemButton setImage:[UIImage imageNamed:@"earn_icon_enabled"] forState:UIControlStateNormal];
    }
    else {
        [self.redeemButton setImage:[UIImage imageNamed:@"earn_icon_disabled"] forState:UIControlStateNormal];
    }
}

@end
