//
//  DMReferralViewController.m
//  DinerMojo
//
//  Created by Carl Sanders on 01/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMReferralViewController.h"
#import "DMWelcomeViewController.h"

@interface DMReferralViewController ()

@end

@implementation DMReferralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *oldImage = self.imageView.image;
    UIImage *newimage;
    newimage = [oldImage applyBlurWithRadius:5.0f tintColor:nil saturationDeltaFactor:1.0f maskImage:nil];
    [self.imageView setImage:newimage];
    DMUser *user = [[self userRequest] currentUser];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:[user profilePictureFullURL]]];
    [self.profileInitialsLabel setText:[user initials]];
    [self.welcomeLabel setText:[NSString stringWithFormat:@"Welcome %@", user.first_name]];
    
    
    if (self.referralUser)
    {
        [self.welcomeDescriptionLabel setText:[NSString stringWithFormat:@"Thanks for using the referral code to sign up. When you dine at your first restaurant you’ll earn points for both yourself and %@. Isn’t that great? You've also just earned 100 points for joining the club!\n\nHow about we take you for a quick tour before you get started?", self.referralUser.first_name]];
    } else
    {
        [self.welcomeDescriptionLabel setText:@"Thanks for signing up to DinerMojo. You just earned 20 points for joining the club!\n\nHow about we take you for a quick tour before you get started?"];

    }
    
    if (IS_IPHONE_4 == YES)
    {
        UIFont *currentFont = self.welcomeDescriptionLabel.font;
        [self.welcomeDescriptionLabel setFont:[UIFont fontWithName:currentFont.fontName size:12]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takeATourButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:@"welcomeSegue" sender:nil];

}

- (IBAction)getStarted:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DMViewController *destinationViewController = [storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
    destinationViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self setRootViewController:destinationViewController animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"welcomeSegue"])
    {
        DMWelcomeViewController *vc = [segue destinationViewController];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        //vc.referralUser = self.referralUser;
    }
    
    
}
@end
