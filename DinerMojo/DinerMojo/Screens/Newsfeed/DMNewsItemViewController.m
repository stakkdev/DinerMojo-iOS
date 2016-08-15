//
//  DMNewsItemViewController.m
//  DinerMojo
//
//  Created by Carl Sanders on 12/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMNewsItemViewController.h"
#import "DMRestaurantInfoViewController.h"
#import "DMNewsRequest.h"
#import "DMOfferItem.h"
#import "DMDineViewController.h"

@interface DMNewsItemViewController ()

@end

@implementation DMNewsItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self decorateInterface];
    self.automaticallyAdjustsScrollViewInsets = NO;

    
}

-(void)viewDidLayoutSubviews
{
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.newsTermsLabel.frame.origin.y + self.newsTermsLabel.frame.size.height + 10);

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

- (void)buildRedeemOfferButton
{
    if ([[self userRequest] isUserLoggedIn] == YES)
    {
        NSInteger pointsRequired = [[(DMOfferItem *)[self selectedItem] points_required] integerValue];
        if ([[[[self userRequest] currentUser] annual_points_balance] integerValue] >= pointsRequired)
        {
            NSString *buttonTitle = (pointsRequired == 1) ? [NSString stringWithFormat:@"Redeem with %li point", (long)pointsRequired] : [NSString stringWithFormat:@"Redeem with %li points", (long)pointsRequired];
            [self.redeemButton setBackgroundColor:[UIColor offersColor]];
            [self.redeemButton setTitle:buttonTitle forState:UIControlStateNormal];
        }
        else
        {
            [self.redeemButtonHeightConstraint setConstant:0.0];
        }
    }
    else
    {
        [self.redeemButtonHeightConstraint setConstant:0.0];
    }
    
}

- (void)decorateInterface
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d MMM ''yy"];
    UIImage *placeHolderImage;
    UIColor *imageBGColour;
    if ([self.selectedItem.update_type isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        [self.newsTitleLabel setTextColor:[UIColor brandColor]];
        [self.restaurantButton setBackgroundColor:[UIColor brandColor]];
        [self.newsDateLabel setText:[dateFormat stringFromDate:self.selectedItem.created_at]];
        [self.newsTermsLabel setText:@""];
        [self.redeemButtonHeightConstraint setConstant:0.0];
        placeHolderImage = [UIImage imageNamed:@"large_news_default"];
        imageBGColour = [UIColor newsColor];
    }
    if ([self.selectedItem.update_type isEqualToNumber:[NSNumber numberWithInt:2]])
    {
        [self.newsTitleLabel setTextColor:[UIColor offersColor]];
        [self.restaurantButton setBackgroundColor:[UIColor offersColor]];
        [self buildRedeemOfferButton];
        NSString *newsDate = [dateFormat stringFromDate:[(DMOfferItem *)[self selectedItem] expiry_date]];
        if (newsDate.length == 0)
        {
            [self.newsDateLabel setText:@"No Expiration Date"];

        }
        else
        {
            [self.newsDateLabel setText:[NSString stringWithFormat:@"Expires: %@", [dateFormat stringFromDate:[(DMOfferItem *)[self selectedItem] expiry_date]]]];

        }
        [self.newsTermsLabel setText:[(DMOfferItem *)[self selectedItem] terms_conditions]];
        placeHolderImage = [UIImage imageNamed:@"large_offer_default"];
        imageBGColour = [UIColor offersColor];
    }
    
    self.newsImageView.contentMode = UIViewContentModeCenter;
    [self.newsImageView setImage:placeHolderImage];
    [self.newsImageView setBackgroundColor:imageBGColour];
    
    if (self.selectedItem.image.length != 0)
    {
        DMNewsRequest *request = [DMNewsRequest new];
        
        NSURL *url = [NSURL URLWithString:[request buildMediaURL:self.selectedItem.image]];
        [self.newsImageView setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:placeHolderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            self.newsImageView.image = image;
            self.newsImageView.contentMode = UIViewContentModeScaleAspectFill;
            [self.newsImageView setBackgroundColor:[UIColor newsGrayColor]];
        } failure:nil];
    }
    
    [self.newsTitleLabel setText:self.selectedItem.title];
    [self.newsLabel setText:self.selectedItem.news_description];
    
    
    [self.navigationItem setTitle:[self.selectedItem.venue name]];
    
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, 0, self.view.frame.size.width, 70);
    layer.colors = [NSArray arrayWithObjects:
                    (id)[[[UIColor blackColor] colorWithAlphaComponent:0.9f] CGColor],
                    (id)[[[UIColor blackColor] colorWithAlphaComponent:0.6f] CGColor],
                    (id)[[[UIColor blackColor] colorWithAlphaComponent:0.2f] CGColor],
                    (id)[[UIColor clearColor] CGColor],
                    nil];
    [self.view.layer insertSublayer:layer above:self.view.layer];
    self.view.layer.masksToBounds = NO;

}

#pragma mark - UIScrollView



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.scrollView.contentOffset.y > 0 && self.scrollView.contentOffset.y < 69)
    {
        DMNewsRequest *request = [DMNewsRequest new];
        NSURL *url = [NSURL URLWithString:[request buildMediaURL:self.selectedItem.image]];
        [self.newsImageView setImageWithURL:url];
        
        
        UIImage *image = self.newsImageView.image;
        UIImage *newImage;
        if (self.scrollView.contentOffset.y < 69)
        {
            newImage = [image applyBlurWithRadius:(self.scrollView.contentOffset.y /10) tintColor:nil saturationDeltaFactor:1 maskImage:nil];
            
        }
        
        else
        {
            newImage = [image applyBlurWithRadius:(68/10) tintColor:nil saturationDeltaFactor:1 maskImage:nil];
            
        }
        
        [self.newsImageView setImage:newImage];
    }
    
    else if (self.scrollView.contentOffset.y == 0)
    {
        DMNewsRequest *request = [DMNewsRequest new];
        NSURL *url = [NSURL URLWithString:[request buildMediaURL:self.selectedItem.image]];
        [self.newsImageView setImageWithURL:url];
       
        
    }
}

- (UIImage *)blurredSnapshot:(CGFloat)blurAmount
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0f);
    
    [self.view drawViewHierarchyInRect:self.view.frame afterScreenUpdates:NO];
    
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIImage *blurredSnapshotImage = [snapshotImage applyBlurWithRadius:blurAmount tintColor:nil saturationDeltaFactor:0.8 maskImage:nil];
    
    UIGraphicsEndImageContext();
    
    return blurredSnapshotImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)share:(id)sender {
    
    UIImage *image = self.newsImageView.image;
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/app/id1017632373"];
    NSString *text = @"DinerMojo lets me know about fantastic offers and gives me loyalty rewards from places like this ";
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[text, image, url] applicationActivities:nil];
    
    [self.navigationController presentViewController:activityViewController animated:YES completion:^{}];

}

- (IBAction)viewRestaurant:(id)sender
{
    DMVenue *item = (DMVenue *) self.selectedItem.venue;
    [self performSegueWithIdentifier:@"showRestaurantInfoNewsSegue" sender:item];
}

- (void)gotoRedeemOffer
{
    [[self tabBarController] setSelectedIndex:2];
    UINavigationController *navigationController = [[[self tabBarController] viewControllers] objectAtIndex:2];
    DMDineViewController *viewController = (DMDineViewController *)[[navigationController viewControllers] objectAtIndex:0];
    [viewController setInitialOffer:(DMOfferItem *)[self selectedItem]];
}

- (IBAction)redeemOffer:(id)sender
{
    if ([[[[self userRequest] currentUser] is_email_verified] boolValue] == YES)
    {
        [self gotoRedeemOffer];
    }
    else
    {
        [self presentEmailVerificationCheckViewControllerWithCompletionBlock:^(NSError *error, id results) {
            [self dismissViewControllerAnimated:YES completion:^{
                if ([[[[self userRequest] currentUser] is_email_verified] boolValue] == YES)
                {
                    [self gotoRedeemOffer];
                }
                else
                {
                    [self presentUnverifiedEmailViewControllerWithStyle:UIBlurEffectStyleExtraLight];
                }
            }];
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showRestaurantInfoNewsSegue"])
    {
        [(DMRestaurantInfoViewController *)[segue destinationViewController] setSelectedVenue:sender];
    }
}


@end
