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
    
    UIImage *oldImage = self.imageView.image;
    UIImage *newimage;
    newimage = [oldImage applyBlurWithRadius:5.0f tintColor:nil saturationDeltaFactor:1.0f maskImage:nil];
    [self.imageView setImage:newimage];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 4, self.scrollView.frame.size.height);
    if (@available(iOS 13.0, *)) {
        self.scrollView.automaticallyAdjustsScrollIndicatorInsets = NO;
    }
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
    [self performSelector:@selector(updateImagesInScrollView) withObject:self afterDelay:0.5];
}


-(void)updateImagesInScrollView
{
    for (int i = 0; i < 4; i++)
    {
        CGFloat xOrigin = i * self.scrollView.frame.size.width;
        
        UILabel *tutorialTitle = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, 43, 200, 50)];
        [tutorialTitle setFont:[UIFont tutorialTitleFont]];
        [tutorialTitle setTextColor:[UIColor whiteColor]];
        [tutorialTitle setTextAlignment:NSTextAlignmentCenter];
        [tutorialTitle setNumberOfLines:0];
        [tutorialTitle setLineBreakMode:NSLineBreakByWordWrapping];
        [tutorialTitle setCenter:CGPointMake(xOrigin + self.view.center.x, 63)];
        
        UILabel *tutorialDescription = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, 20, 290, 140)];
        [tutorialDescription setFont:[UIFont tutorialDescriptionFont]];
        [tutorialDescription setNumberOfLines:0];
        [tutorialDescription setTextColor:[UIColor darkGrayColor]];
        [tutorialDescription setTextAlignment:NSTextAlignmentCenter];
        [tutorialDescription setCenter:CGPointMake(xOrigin + self.view.center.x, self.greenView.frame.origin.y + 67)];
        
        
        UIImageView *imageView;
        
        CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;

        imageView = [[UIImageView alloc] init];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setClipsToBounds:YES];
        [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        UIView *greenView2 = [[UIView alloc] initWithFrame:CGRectMake(xOrigin, self.greenView.frame.origin.y, self.greenView.frame.size.width, self.greenView.frame.size.height)];
        greenView2.backgroundColor = [UIColor groupTableViewBackgroundColor];
  
        switch (i) {
            case 0: {
                [tutorialTitle setText:@"Choose Dining or Lifestyle"];
                [tutorialDescription setText:@"Use the “Venues” tab to discover great places to dine or get rewards near you."];
                [imageView setImage:[UIImage imageNamed:@"TutorialPhone1"]];
                break;
            }
            case 1: {
                [tutorialTitle setText:@"Earn Points"];
                
                NSString *earnPoints = [[NSString alloc] initWithFormat:@"Earn points everywhere that has this symbol "];
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                textAttachment.image = [UIImage imageNamed:@"earn_icon_enabled"];
                textAttachment.bounds = CGRectMake(0, 0, 20, 20);
                
                NSMutableAttributedString *earnPoints3 = [NSMutableAttributedString attributedStringWithAttachment:textAttachment];
                NSMutableAttributedString *earnPoints4 = [[NSMutableAttributedString alloc] initWithString:@" (£1 = 1 point). Simply use the Earn button, take a picture of your receipt and we'll take care of the rest."];
                NSMutableAttributedString *all = [[NSMutableAttributedString alloc] initWithString:earnPoints];
                [all appendAttributedString:earnPoints3];
                [all appendAttributedString:earnPoints4];
                [tutorialDescription setAttributedText:all];
                [imageView setImage:[UIImage imageNamed:@"TutorialPhone2"]];
                
                break;
            }
            case 2: {
                [tutorialTitle setText:@"Redeem Points"];
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                textAttachment.image = [UIImage imageNamed:@"redeem_icon_enabled"];
                textAttachment.bounds = CGRectMake(0, 0, 20, 20);
                
                NSMutableAttributedString *reedemPoints = [NSMutableAttributedString attributedStringWithAttachment:textAttachment];
                NSMutableAttributedString *reedem = [[NSMutableAttributedString alloc] initWithString:@"Use your points to get great rewards from any participating venues that have this symbol "];
                [reedem appendAttributedString:reedemPoints];
                [tutorialDescription setAttributedText:reedem];
                [imageView setImage:[UIImage imageNamed:@"TutorialPhone3"]];

                break;
            }
            case 3: {
                [tutorialTitle setText:@"Invite Friends & Family"];
                [tutorialDescription setText:@"Invite friends to join and you'll earn 100 points when they join plus 10% of any points they earn for a whole year."];
                [imageView setImage:[UIImage imageNamed:@"TutorialPhone5"]];
                break;
            }
            default:
                break;
        }
        
        [[self scrollView] addSubview:imageView];
        [[self scrollView] addSubview:tutorialTitle];
        [[self scrollView] addSubview:greenView2];
        [[self scrollView] addSubview:tutorialDescription];
        
        [NSLayoutConstraint activateConstraints: @[
                 [imageView.widthAnchor constraintEqualToConstant:screenWidth * 0.8],
                 [imageView.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor constant:i * screenWidth],
                 [imageView.bottomAnchor constraintEqualToAnchor:tutorialDescription.topAnchor constant:-16.0],
                 [imageView.topAnchor constraintEqualToAnchor:tutorialTitle.bottomAnchor constant:16.0],
             ]
        ];
    }
    
}


- (NSInteger)getCurrentPageIndex
{
    return self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
}

- (void)updatePageControl
{
    [self.pageControl setCurrentPage:[self getCurrentPageIndex]];
    
    if ([self getCurrentPageIndex] == 3)
    {
        [self.getStartedButton setAlpha:1];
        [self.getStartedButton setEnabled:YES];
        [self.skipButton setAlpha:0];
        [self.pageControl setAlpha:0];
    }
    else {
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
    destinationViewController.modalPresentationStyle = UIModalPresentationFullScreen;
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
