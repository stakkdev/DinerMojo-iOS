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
#import "DMRedeemViewController.h"
//#import <Crashlytics/Answers.h>
#import <PureLayout/PureLayout.h>
#import "DinerMojo-Swift.h"

@interface DMNewsItemViewController ()
@property (weak, nonatomic) IBOutlet DMButton *viewRestaurantButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewRestaurantHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewReferFriendHeight;


@end

@implementation DMNewsItemViewController

#pragma mark - View Life Cycel Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self decorateInterface];
    [self setupNewsLabel];
    if (@available(iOS 13.0, *)) {
        //self.scrollView.automaticallyAdjustsScrollIndicatorInsets = NO;
    }
}
- (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGSize size = CGSizeZero;
    if (text) {
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font } context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    return size;
}

-(void)viewDidLayoutSubviews
{
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    
    //NSLog(@"contentRect is %f", contentRect.size.height);

    
//    if ([(DMOfferItem *)[self selectedItem] terms_conditions])
//
//    CGSize rewardTextSize = [self findHeightForText:self.newsTermsLabel.text havingWidth:[[UIScreen mainScreen] bounds].size.width andFont:self.newsTermsLabel.font];
//
//    NSLog(@"tersm text height is %f", rewardTextSize.height);
//
//    CGSize sizeContnet = CGSizeMake(contentRect.size.width, contentRect.size.height + rewardTextSize.height + 200.0);
//
//    NSLog(@"Updared text height is %f", sizeContnet.height);

    self.scrollView.contentSize = contentRect.size;
    //CGSizeMake(self.view.frame.size.width, self.newsTermsLabel.frame.origin.y + self.newsTermsLabel.frame.size.height + 10);*/
    //self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.newsTermsLabel.frame.origin.y + self.newsTermsLabel.frame.size.height + self.newsDateLabel.frame.size.height + 10);
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

- (void)setupNewsLabel {
    NSString *text = self.newsTextView.text;
    NSDataDetector *detector = [[NSDataDetector alloc]
                                initWithTypes: NSTextCheckingTypeLink
                                error: nil];
    NSArray<NSTextCheckingResult *> *matches = [detector matchesInString: text
                                         options: NSMatchingReportCompletion
                                           range: NSMakeRange(0, text.length)];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    for (int i = 0; i < matches.count; ++i) {
        NSURL *url = [[NSURL alloc] initWithString: [text substringWithRange:matches[i].range]];
        [attributedText addAttributes:@{
                                        NSLinkAttributeName: url,
                                        }
                                range:matches[i].range];
        [attributedText addAttributes:@{
                                        NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:14.0]
                                        }
                                range: NSMakeRange(0, text.length)];
        
    }
    
    if(self.selectedItem.additional_payload != nil) {
        NSString *textHighlight = @"\n\nWant to get even more points?\n\nJust go to the profile tab and refer a friend.  You will get 100 points when they register and so will they. Even better, you will get 10% of their earned points for a year.\n\nHelp us help our independents!\n\nThanks.";

        NSMutableAttributedString *attributedString2 =
        [[NSMutableAttributedString alloc] initWithString:textHighlight attributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans" size:14.0] }];
        [attributedString2 addAttributes:@{
            NSForegroundColorAttributeName: [UIColor navColor]
                                        }
                                range: NSMakeRange(0, textHighlight.length)];
        [attributedText appendAttributedString:attributedString2];
    }
    self.newsTextView.attributedText = attributedText;
    self.newsTextView.userInteractionEnabled = YES;
    self.newsTextView.tintColor = [UIColor brandColor];
    self.newsTextView.dataDetectorTypes = NSTextCheckingTypeLink;
    self.newsTextView.editable = NO;
    [self.newsTextView sizeToFit];
    self.newsTextView.scrollEnabled = false;
}

- (void)buildRedeemOfferButton
{
    if ([[self userRequest] isUserLoggedIn] == YES)
    {
        NSInteger pointsRequired = [[(DMOfferItem *)[self selectedItem] points_required] integerValue];
        if ([[[[self userRequest] currentUser] annual_points_balance] integerValue] >= pointsRequired)
        {
            NSString *buttonTitle;
            if (pointsRequired == 0) {
                buttonTitle = @"It's free for DinerMojo members!";
            } else {
                buttonTitle = (pointsRequired == 1) ? [NSString stringWithFormat:@"Redeem with %li point", (long)pointsRequired] : [NSString stringWithFormat:@"Redeem with %li points", (long)pointsRequired];
            }
            [self.redeemButton setBackgroundColor:[UIColor offersColor]];
            [self.redeemButton setTitle:buttonTitle forState:UIControlStateNormal];
        }
        else {
            [self.redeemButtonHeightConstraint setConstant:0.0];
        }
    }
    else {
        [self.redeemButtonHeightConstraint setConstant:0.0];
    }
}

- (void)decorateInterface
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d MMM ''yy"];
    UIImage *placeHolderImage;
    UIColor *imageBGColour;
    UIViewContentMode imgContentMode = UIViewContentModeCenter;
    
    BOOL isProdigal = [self.selectedItem.update_type isEqualToNumber:[NSNumber numberWithInt:5]];
    
    if ([self.selectedItem.update_type isEqualToNumber:[NSNumber numberWithInt:1]] || isProdigal)
    {
        if(isProdigal) {
            [self.restaurantButton setTitle:@"Check rewards!" forState:UIControlStateNormal];
        }
        
        [self.newsTitleLabel setTextColor:[UIColor brandColor]];
        [self.restaurantButton setBackgroundColor:[UIColor brandColor]];
        [self.newsDateLabel setText:[dateFormat stringFromDate:self.selectedItem.created_at]];
        [self.newsTermsLabel setText:@""];
        [self.redeemButtonHeightConstraint setConstant:0.0];
        placeHolderImage = [UIImage imageNamed:@"news_empty_image_state"];
        imageBGColour = [UIColor newsColor];
        imgContentMode = UIViewContentModeScaleAspectFill;
    }
    if ([self.selectedItem.update_type isEqualToNumber:[NSNumber numberWithInt:2]] || [self.selectedItem.update_type isEqualToNumber:[NSNumber numberWithInt:3]])
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
    
    self.newsImageView.contentMode = imgContentMode;
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
    
    // Append New Text
    [self.newsTitleLabel setText:self.selectedItem.title];
    [self.newsTextView setText:self.selectedItem.news_description];
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


    if(self.selectedItem.venue == nil) {
        [self.restaurantButton setHidden:YES];
        self.viewRestaurantHeight.constant = 0;
    }
    //NSLog(@"self. additional payload is:", self.selectedItem.additional_payload);
    if(self.selectedItem.additional_payload == nil) {
        [self.referFriendButton setHidden:YES];
        self.viewReferFriendHeight.constant = 0;
    }
    
    self.navigationController.navigationBar.backItem.title = @" ";
    self.navigationController.navigationBar.topItem.title = @" ";
    
    // Refer Friend Buttton
    [self.referFriendButton setBackgroundColor:[UIColor colorWithRed:238.0f/255.0f
                                                               green:154.0f/255.0f
                                                                blue:37.0f/255.0f
                                                               alpha:1.0f]];
    
    UIImage *backArrow = [UIImage imageNamed:@"back_arrow_grey"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backArrow style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)goBack {
    if (self.isFromNewsPush) {
        self.isFromNewsPush = FALSE;
        [self openLikeUnlikeNotificationOpen];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
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
    
    else if (self.scrollView.contentOffset.y <= 0)
    {
        DMNewsRequest *request = [DMNewsRequest new];
        if(self.selectedItem.image.length != 0) {
            NSURL *url = [NSURL URLWithString:[request buildMediaURL:self.selectedItem.image]];
            [self.newsImageView setImageWithURL:url];
        } else {
            [self.newsImageView setImage:[UIImage imageNamed:@"news_empty_image_state"]];
        }
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
    NSString *name = @"";
    if(self.selectedItem.venue == NULL) {
        name = @"system";
    } else {
        name = self.selectedItem.title;
    }
    //[Answers logShareWithMethod:[NSString stringWithFormat:@"Share newsfeed"] contentName:[NSString stringWithFormat:@"Share newsfeed - %@", name] contentType:@"" contentId:@"" customAttributes:@{}];
    [FIRAnalytics logEventWithName:@"Share newsfeed"
                        parameters:@{
                                     kFIRParameterItemName:[NSString stringWithFormat:@"Share newsfeed %@ ",name]
                                     }];
    [[FIRCrashlytics crashlytics] logWithFormat:@"Share newsfeed - %@",name];
    UIImage *image = self.newsImageView.image;
    NSString *text = @"With the DinerMojo app, you can enjoy fantastic members-only rewards and experiences at some of the very best independent restaurants and lifestyle venues.\nhttp://bit.ly/DownloadFromTheAppStore\nhttp://bit.ly/DownloadFromGooglePlay";
    
    DMActivityViewController *activityViewController = [[DMActivityViewController alloc] initWithActivityItems:@[text, image] applicationActivities:nil];
    
    [activityViewController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self.navigationController presentViewController:activityViewController animated:YES completion:^{}];

}

- (IBAction)viewRestaurant:(id)sender
{
    BOOL isProdigal = [self.selectedItem.update_type isEqualToNumber:[NSNumber numberWithInt:5]];
    
    if(isProdigal) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:NULL];
        DMRedeemViewController *vc = [sb instantiateViewControllerWithIdentifier:@"RedeemViewController"];
        vc.selectedVenue = self.selectedItem.venue;
        vc.shouldCloseOnButtonTap = YES;
        DMDineNavigationController *nav = [[DMDineNavigationController alloc] initWithRootViewController:vc];
        [nav setNavigationBarHidden:YES];
        [nav setDineNavigationDelegate:self];
        [nav setModalPresentationStyle:UIModalPresentationOverFullScreen];
        [self.navigationController presentViewController:nav animated:YES completion:NULL];
    } else if(self.selectedItem.venue != nil) {
        DMVenue *item = (DMVenue *) self.selectedItem.venue;
        [self performSegueWithIdentifier:@"showRestaurantInfoNewsSegue" sender:item];
    }
}

- (void)gotoRedeemOffer
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:NULL];
    DMRedeemViewController *vc = [sb instantiateViewControllerWithIdentifier:@"RedeemViewController"];
    vc.selectedVenue = self.selectedItem.primitiveVenue;
    vc.shouldCloseOnButtonTap = YES;
    [vc setStandardRedeem:NO];
    vc.selectedOfferItem = (DMOfferItem *)[self selectedItem];
    DMDineNavigationController *nav = [[DMDineNavigationController alloc] initWithRootViewController:vc];
    [nav setNavigationBarHidden:YES];
    [nav setDineNavigationDelegate:self];
    [nav setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self.navigationController presentViewController:nav animated:YES completion:NULL];

}

- (IBAction)referFrienButtonTaped:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

    DMReferAFriendViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DMReferAFriendViewController"];
    DMUser *user = [self.userRequest currentUser];
    int16_t points = user.referred_pointsValue;
    vc.referredPoints = [NSString stringWithFormat:@"%hd", points];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)openLikeUnlikeNotificationOpen {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FBSignup" bundle:nil];
    EarnNotificationTapVC *emailVerify = (EarnNotificationTapVC *)[storyboard instantiateViewControllerWithIdentifier:@"EarnNotificationTapVC"];
    emailVerify.emailText = @"";
    emailVerify.newsID = self.selectedItem.modelID;
    emailVerify.viewDismiss = ^(void){
        NSLog(@"Earn notification tap");
        [self.navigationController popToRootViewControllerAnimated:NO];
    };
    [emailVerify setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self presentViewController:emailVerify animated:true completion: nil];
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

- (void)readyToDismissCompletedDineNavigationController:(DMDineNavigationController *)dineNavigationController {
    if (self.isFromNewsPush) {
        self.isFromNewsPush = FALSE;
        [self openLikeUnlikeNotificationOpen];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)readyToDismissCompletedDineNavigationController:(DMDineNavigationController *)dineNavigationController with:(UIViewController *)vc {
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)readyToDismissCancelledDineNavigationController:(DMDineNavigationController *)dineNavigationController {
    if (self.isFromNewsPush) {
        self.isFromNewsPush = FALSE;
        [self openLikeUnlikeNotificationOpen];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
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
