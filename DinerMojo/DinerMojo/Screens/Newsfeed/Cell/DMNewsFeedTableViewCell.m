//
//  DMNewsFeEDTableViewCell.m
//  DinerMojo
//
//  Created by Robert Sammons on 04/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMNewsFeedTableViewCell.h"

@implementation DMNewsFeedTableViewCell

- (void)setupActions {
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(clickToShowNews:)];
    [self addGestureRecognizer:singleFingerTap];

    [self.feedVenueNameLabel setEnabled:YES];
    [self.feedVenueNameLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *venueTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(clickVenue:)];
    [self.feedVenueNameLabel addGestureRecognizer:venueTap];
}

- (void)clickToShowNews:(UITapGestureRecognizer *)recognizer
{
    if(self.tapOnNewsCell) {
        self.tapOnNewsCell();
    }
}

- (void)clickVenue:(UITapGestureRecognizer *)recognizer
{
    if(self.tapOnVenueIcon) {
        self.tapOnVenueIcon();
    }
}


@end
