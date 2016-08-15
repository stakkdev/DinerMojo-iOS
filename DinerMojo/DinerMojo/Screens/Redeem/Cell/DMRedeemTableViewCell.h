//
//  RedeemTableViewCell.h
//  DinerMojo
//
//  Created by Robert Sammons on 18/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMRedeemTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *offerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *offerImageView;
@property (weak, nonatomic) IBOutlet DMView *offerBackgroundView;

@end
