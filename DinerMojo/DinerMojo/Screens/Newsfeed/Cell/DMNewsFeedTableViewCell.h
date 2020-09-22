//
//  DMNewsFeEDTableViewCell.h
//  DinerMojo
//
//  Created by Robert Sammons on 04/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TapOnNewsCell)();
typedef void (^TapOnVenueIcon)();

@interface DMNewsFeedTableViewCell : UITableViewCell

//@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *feedTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedStoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedVenueNameLabel;
@property (weak, nonatomic) IBOutlet UIView *isReadView;
@property (weak, nonatomic) IBOutlet UIImageView *offerIcon;

@property (copy, nonatomic) TapOnNewsCell tapOnNewsCell;
@property (copy, nonatomic) TapOnVenueIcon tapOnVenueIcon;

- (void)setupActions;

@end
