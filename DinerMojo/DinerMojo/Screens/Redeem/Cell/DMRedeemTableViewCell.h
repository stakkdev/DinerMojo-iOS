//
//  RedeemTableViewCell.h
//  DinerMojo
//
//  Created by Robert Sammons on 18/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DMRedeemTableViewCellDelegate <NSObject>
@optional
- (void)infoClicked:(NSString *)info;
@end

@interface DMRedeemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeImgView;
@property (weak, nonatomic) IBOutlet UILabel *expiryDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cakeImgView;
@property (weak, nonatomic) IBOutlet UIView *infoHolder;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIView *imgHolderView;
@property (weak, nonatomic) IBOutlet UIView *cakeHolderView;
@property (weak, nonatomic) IBOutlet UIView *timeHolderView;
@property (weak, nonatomic) IBOutlet UIView *timeHolderColorView;

/*
@property (weak, nonatomic) IBOutlet UILabel *offerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *offerImageView;
@property (weak, nonatomic) IBOutlet DMView *offerBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (nonatomic) NSString *infoString;

*/
@property (nonatomic, weak) id <DMRedeemTableViewCellDelegate> delegate;
@end
