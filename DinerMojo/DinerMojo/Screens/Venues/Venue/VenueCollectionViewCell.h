//
//  VenueCollectionViewCell.h
//  DinerMojo
//
//  Created by James Shaw on 05/02/2021.
//  Copyright © 2021 hedgehog lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMRestaurantCell.h"

@interface VenueCollectionViewCell: UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UILabel *restaurantCategory;
@property (weak, nonatomic) IBOutlet UILabel *restaurantPrice;
@property (weak, nonatomic) IBOutlet UILabel *restaurantDistance;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImageView;
@property (weak, nonatomic) IBOutlet UIButton *earnButton;
@property (weak, nonatomic) IBOutlet UIButton *redeemButton;
@property (weak, nonatomic) IBOutlet UILabel *restaurantType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellWidth;
@property (nonatomic, weak) id <DMRestaurantCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath* index;
@property (nonatomic) int state;

- (void)setEarnVisibility:(BOOL)visibility;
- (void)setRedeemVisibility:(BOOL)visibility;


@end
