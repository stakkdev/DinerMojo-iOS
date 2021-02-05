//
//  DMRestaurantInfoImageCarouselViewController.m
//  DinerMojo
//
//  Created by Carl Sanders on 11/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMRestaurantInfoImageCarouselViewController.h"
#import "DMVenueImage.h"



@interface DMRestaurantInfoImageCarouselViewController ()

@end

@implementation DMRestaurantInfoImageCarouselViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView.delegate = self;
    if (@available(iOS 13.0, *)) {
        self.scrollView.automaticallyAdjustsScrollIndicatorInsets = NO;
    }

    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, self.scrollView.frame.size.height - 70, self.view.frame.size.width, 70);
    /*layer.colors = [NSArray arrayWithObjects:
                    (id)[[UIColor clearColor] CGColor],
                    (id)[[[UIColor blackColor] colorWithAlphaComponent:0.4f] CGColor],
                    (id)[[[UIColor blackColor] colorWithAlphaComponent:0.6f] CGColor],
                    (id)[[[UIColor blackColor] colorWithAlphaComponent:0.9f] CGColor],
                    nil];*/
    [self.view.layer insertSublayer:layer below:self.view.layer];
    self.view.layer.masksToBounds = NO;
    [self.view bringSubviewToFront:self.pageControl];
    
    [self.activityIndicator startAnimating];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self updateImagesInScrollView];
    [self getCurrentPageIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateImagesInScrollView
{
    NSArray *venueImages = [self.venueInfo sortedImagesArray];

    NSInteger count = 0;
    for (DMVenueImage *venueImage in venueImages)
    {
        CGFloat xOrigin = count * self.scrollView.frame.size.width;
        NSString *url = [venueImage fullThumbURL];
        if(url == NULL) {
            url = [venueImage fullURL];
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin,0,self.scrollView.frame.size.width,self.scrollView.frame.size.height)];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setClipsToBounds:YES];
        [imageView setImageWithURL:[NSURL URLWithString:url]];
        [[self scrollView] addSubview:imageView];
        count ++;
    }
    
    self.scrollView.contentSize = CGSizeMake(venueImages.count * self.view.frame.size.width, self.view.frame.size.height);
    [self.pageControl setNumberOfPages:venueImages.count];
}

         
         

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   [self getCurrentPageIndex];
}

- (NSInteger)getCurrentPageIndex
{
    [self.pageControl setCurrentPage:self.scrollView.contentOffset.x / self.scrollView.frame.size.width];
    return self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
