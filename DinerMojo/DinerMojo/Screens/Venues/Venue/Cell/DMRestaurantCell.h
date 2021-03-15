//
//  DMMapViewCell.h
//  DinerMojo
//
//  Created by Carl Sanders on 02/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

@protocol DMRestaurantCellDelegate <NSObject>
@optional
- (void)didSelectEarn:(NSIndexPath*)index;
- (void)didSelectRedeem:(NSIndexPath*)index;
- (void)didSelectFavourite:(BOOL)favourite atIndex:(NSIndexPath*)index;

@end


@interface DMRestaurantCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UILabel *restaurantCategory;
@property (weak, nonatomic) IBOutlet UILabel *restaurantPrice;
@property (weak, nonatomic) IBOutlet UILabel *restaurantDistance;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImageView;
@property (weak, nonatomic) IBOutlet UIView *whiteLineView;
@property (weak, nonatomic) IBOutlet UIButton *earnButton;
@property (weak, nonatomic) IBOutlet UIButton *redeemButton;
@property (weak, nonatomic) IBOutlet UILabel *restaurantType;
@property (nonatomic, weak) id <DMRestaurantCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath* index;
@property (nonatomic) int state;
@property (weak, nonatomic) IBOutlet UIImageView *favouriteHeartImage;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;
@property BOOL isFavourite;

- (void)setEarnVisibility:(BOOL)visibility;
- (void)setRedeemVisibility:(BOOL)visibility;
- (void)setIsFavourite:(BOOL)favourite;

@end
