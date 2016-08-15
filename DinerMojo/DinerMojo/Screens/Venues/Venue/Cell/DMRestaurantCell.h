//
//  DMMapViewCell.h
//  DinerMojo
//
//  Created by Carl Sanders on 02/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

@interface DMRestaurantCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UILabel *restaurantCategory;
@property (weak, nonatomic) IBOutlet UILabel *restaurantPrice;
@property (weak, nonatomic) IBOutlet UILabel *restaurantDistance;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImageView;
@property (weak, nonatomic) IBOutlet UIView *whiteLineView;


@property (nonatomic) int state;

@end
