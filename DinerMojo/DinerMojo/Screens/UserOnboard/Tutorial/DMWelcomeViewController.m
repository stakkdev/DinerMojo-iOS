//
//  DMWelcomeViewController.m
//  DinerMojo
//
//  Created by Carl Sanders on 01/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMWelcomeViewController.h"


@interface DMWelcomeViewController ()


@end

@implementation DMWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *oldImage = self.imageView.image;
    UIImage *newimage;
    newimage = [oldImage applyBlurWithRadius:5.0f tintColor:nil saturationDeltaFactor:1.0f maskImage:nil];
    [self.imageView setImage:newimage];
    self.greenView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.pageControl setActiveImage:[UIImage imageNamed:@"ActivePageControlDarkGray"]];
    [self.pageControl setInactiveImage:[UIImage imageNamed:@"InactivePageControlDarkGray"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self welcomeViewControllerPresentationStyle] == DMWelcomeViewControllerPresentationStyleFromPopup)
    {
        [[self skipButton] setTitle:@"Close" forState:UIControlStateNormal];
        [[self getStartedButton] setTitle:@"Close" forState:UIControlStateNormal];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 5, self.scrollView.frame.size.height);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
    [self updateImagesInScrollView];
}


-(void)updateImagesInScrollView
{
    for (int i = 0; i < 5; i++)
    {
        CGFloat xOrigin = i * self.scrollView.frame.size.width;
        
        UILabel *tutorialTitle = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, 43, 200, 20)];
        [tutorialTitle setFont:[UIFont tutorialTitleFont]];
        [tutorialTitle setTextColor:[UIColor whiteColor]];
        [tutorialTitle setTextAlignment:NSTextAlignmentCenter];
        [tutorialTitle setCenter:CGPointMake(xOrigin + self.view.center.x, 43)];
        
        UILabel *tutorialDescription = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, 31, 290, 100)];
        [tutorialDescription setFont:[UIFont tutorialDescriptionFont]];
        [tutorialDescription setNumberOfLines:0];
        [tutorialDescription setTextColor:[UIColor darkGrayColor]];
        [tutorialDescription setTextAlignment:NSTextAlignmentCenter];
        [tutorialDescription setCenter:CGPointMake(xOrigin + self.view.center.x, self.greenView.frame.origin.y + 67)];
        
        
        UIImageView *imageView;
        
        
        if (IS_IPHONE_6 || IS_IPHONE_6_PLUS)
        {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, tutorialTitle.frame.origin.y + 25, 216, 360)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [imageView setCenter:CGPointMake(xOrigin + self.view.center.x, self.greenView.frame.origin.y - 210)];
        }
        
        else if (IS_IPHONE_4)
        {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, tutorialTitle.frame.origin.y + 10, 140, 200)];
            [imageView setCenter:CGPointMake(xOrigin + self.view.center.x, self.greenView.frame.origin.y - 120)];


        }
        
        else
        {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, tutorialTitle.frame.origin.y + 25, 155, 280)];
            [imageView setCenter:CGPointMake(xOrigin + self.view.center.x, self.greenView.frame.origin.y - 160)];

        }
        
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setClipsToBounds:YES];
        
        UIView *greenView2 = [[UIView alloc] initWithFrame:CGRectMake(xOrigin, self.greenView.frame.origin.y, self.greenView.frame.size.width, self.greenView.frame.size.height)];
        greenView2.backgroundColor = [UIColor groupTableViewBackgroundColor];
  
        switch (i) {
            case 0:
                [tutorialTitle setText:@"Find Restaurants"];
                [tutorialDescription setText:@"Use the “venues” tab to discover DinerMojo participating restaurants near you."];
                [imageView setImage:[UIImage imageNamed:@"TutorialPhone1"]];


                break;
            case 1:
                [tutorialTitle setText:@"Earn Points"];
                [tutorialDescription setText:@"Eat at restaurants to earn points (£1 = 1 point). Simply take a picture of your receipt and we'll take care of the rest."];
                [imageView setImage:[UIImage imageNamed:@"TutorialPhone2"]];


                break;
            case 2:
                [tutorialTitle setText:@"Redeem Points"];
                [tutorialDescription setText:@"Once you’ve earned enough points, you can get money off your bill next time you eat at a DinerMojo venue by redeeming points."];
                [imageView setImage:[UIImage imageNamed:@"TutorialPhone3"]];


                break;
            case 3:
                [tutorialTitle setText:@"Favourite Restaurants"];
                [tutorialDescription setText:@"Mark restaurants as favourites and automatically get notified about news and great offers from them."];
                [imageView setImage:[UIImage imageNamed:@"TutorialPhone4"]];

                break;
            case 4:
                [tutorialTitle setText:@"Invite Friends & Family"];
                [tutorialDescription setText:@"From your profile, invite friends to join DinerMojo and get 10% of the points from the first 12 months."];
                [imageView setImage:[UIImage imageNamed:@"TutorialPhone5"]];
                break;
            default:
                break;
        }
        
        [[self scrollView] addSubview:imageView];
        [[self scrollView] addSubview:tutorialTitle];
        [[self scrollView] addSubview:greenView2];
        [[self scrollView] addSubview:tutorialDescription];
   
   
    }
    
}


- (NSInteger)getCurrentPageIndex
{
    return self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
}

- (void)updatePageControl
{
    [self.pageControl setCurrentPage:[self getCurrentPageIndex]];
    
    if ([self getCurrentPageIndex] == 4)
    {
        [self.getStartedButton setAlpha:1];
        [self.getStartedButton setEnabled:YES];
        [self.skipButton setAlpha:0];
        [self.pageControl setAlpha:0];

    }
    
    else
    {
        [self.getStartedButton setAlpha:0];
        [self.getStartedButton setEnabled:NO];
        [self.skipButton setAlpha:1];
        [self.pageControl setAlpha:1];

    }
    
}

- (void)progress
{
    if ([self welcomeViewControllerPresentationStyle] == DMWelcomeViewControllerPresentationStyleFromStartup)
    {
        [self setRootController];
    }
    else
    {
        if ([self delegate] != nil)
        {
            if ([[self delegate] respondsToSelector:@selector(closeButtonPressedWelcomeViewController:)])
            {
                [[self delegate] closeButtonPressedWelcomeViewController:self];
            }
        }
    }
}

- (void)setRootController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DMViewController *destinationViewController = [storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
    
    [self setRootViewController:destinationViewController animated:YES];
}

- (IBAction)skipPressed:(id)sender
{
    [self progress];
}

- (IBAction)getStarted:(UIButton *)sender
{
    [self progress];
    
}

#pragma mark - UIScrollView

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updatePageControl];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updatePageControl];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

@end
