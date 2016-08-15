//
//  DMTransactionTableViewCell.h
//  DinerMojo
//
//  Created by Robert Sammons on 12/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMTransactionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *restaurantTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *cuisineLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
