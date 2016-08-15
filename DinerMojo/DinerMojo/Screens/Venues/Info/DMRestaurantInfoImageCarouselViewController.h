//
//  DMRestaurantInfoImageCarouselViewController.h
//  DinerMojo
//
//  Created by Carl Sanders on 11/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMPageControl.h"

@interface DMRestaurantInfoImageCarouselViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) DMVenue *venueInfo;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet DMPageControl *pageControl;


@end
