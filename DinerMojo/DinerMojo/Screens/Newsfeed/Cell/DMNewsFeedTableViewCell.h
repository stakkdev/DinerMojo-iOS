//
//  DMNewsFeEDTableViewCell.h
//  DinerMojo
//
//  Created by Robert Sammons on 04/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMNewsFeedTableViewCell : UITableViewCell

//@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *feedTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedStoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedVenueNameLabel;

@end
