//
//  DMMapViewCell.m
//  DinerMojo
//
//  Created by Carl Sanders on 02/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMRestaurantCell.h"

@implementation DMRestaurantCell


- (void)awakeFromNib {
    
    // Initialization code
    [super awakeFromNib];
    
    
    [self setSelectionStyle:UITableViewCellSelectionStyleGray];
    [[self selectedBackgroundView] setBackgroundColor:[UIColor redColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    [[self selectedBackgroundView] setHidden:YES];
    [[self whiteLineView] setBackgroundColor:[UIColor whiteColor]];
}
//
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    [[self selectedBackgroundView] setHidden:YES];
    [[self whiteLineView] setBackgroundColor:[UIColor whiteColor]];

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

- (IBAction)favoriteButtonPressed:(id)sender {
    if(self.delegate != nil) {
        [self.delegate didSelectFavourite:![self isFavourite] atIndex:self.index];
    }
    [self setIsFavourite:![self isFavourite]];
}

- (void)setRedeemVisibility:(BOOL)visibility {
    if(visibility) {
        [self.earnButton setImage:[UIImage imageNamed:@"redeem_icon_enabled"] forState:UIControlStateNormal];
    }
    else {
        [self.earnButton setImage:[UIImage imageNamed:@"redeem_icon_disabled"] forState:UIControlStateNormal];
    }
}

- (void)setEarnVisibility:(BOOL)visibility {
    if(visibility) {
        [self.redeemButton setImage:[UIImage imageNamed:@"earn_icon_enabled"] forState:UIControlStateNormal];
    }
    else {
        [self.redeemButton setImage:[UIImage imageNamed:@"earn_icon_disabled"] forState:UIControlStateNormal];
    }
}

- (void)setToFavourite:(BOOL)favourite {
    _isFavourite = favourite;
    if(favourite) {
        [self.favouriteHeartImage setImage:[UIImage imageNamed:@"heartRed"]];
    }
    else {
        [self.favouriteHeartImage setImage:[UIImage imageNamed:@"heartWhite"]];
    }
}

//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
//{
//    [super setHighlighted:highlighted animated:animated];
//    if (highlighted) {
//        self.backgroundColor =[UIColor whiteColor];
//    }



// Indent the cell from the right, however causes animation issues.

//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    self.contentView.frame = CGRectMake(0,
//                                        self.contentView.frame.origin.y,
//                                        self.contentView.frame.size.width,
//                                        self.contentView.frame.size.height);
//    
//    if ((self.editing
//        && ((_state & UITableViewCellStateShowingEditControlMask)
//            && !(_state & UITableViewCellStateShowingDeleteConfirmationMask))) ||
//        ((_state & UITableViewCellStateShowingEditControlMask)
//         && (_state & UITableViewCellStateShowingDeleteConfirmationMask)))
//    {
//        float indentPoints = self.indentationLevel = 47;
//        
//        self.contentView.frame = CGRectMake(indentPoints,
//                                            self.contentView.frame.origin.y,
//                                            self.contentView.frame.size.width,
//                                            self.contentView.frame.size.height);
//
//    }
//}
//
//- (void)willTransitionToState:(UITableViewCellStateMask)aState
//{
//    [super willTransitionToState:aState];
//    self.state = aState;
//}



@end
