//
//  RedeemPointsToNextLevelCell.h
//  DinerMojo
//
//  Created by Jaroslav Chaninovicz on 16/02/2018.
//  Copyright © 2018 hedgehog lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedeemPointsToNextLevelCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UIView *pointsHolderView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end
