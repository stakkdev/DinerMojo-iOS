//
//  DMDineVenueTableViewCell.h
//  DinerMojo
//
//  Created by Robert Sammons on 23/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMDineVenueTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *venueImageView;
@property (weak, nonatomic) IBOutlet UIButton *tickButton;
@property (weak, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueBudgetLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueCuisineLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueMilesLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueAreaLabel;

@end
