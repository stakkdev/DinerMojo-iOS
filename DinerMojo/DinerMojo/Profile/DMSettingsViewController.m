//
//  DMSettingsViewController.m
//  DinerMojo
//
//  Created by Carl Sanders on 12/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMSettingsViewController.h"

@interface DMSettingsViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *editProfileImageView;

@end

@implementation DMSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[[self view] setNeedsLayout];
    //[[self view] layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [[self view] layoutIfNeeded];
    [[[self editProfileImageView]layer]setCornerRadius:CGRectGetHeight([[self editProfileImageView]bounds])/2];
    [[[self editProfileImageView]layer]setMasksToBounds:YES];
    
    
}

//-(void)viewDidLayoutSubviews;
//{
//    [super viewDidLayoutSubviews];
//    
//    [[[self editProfileImageView]layer]setCornerRadius:CGRectGetHeight([[self editProfileImageView]bounds])/2];
//    [[[self editProfileImageView]layer]setMasksToBounds:YES];
//}
//
//-(void)viewWillLayoutSubviews
//{
//    [super viewWillLayoutSubviews];
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setImage:(UIImage *)image
{
    [[[self editProfileImageView]layer]setCornerRadius:CGRectGetWidth([[self editProfileImageView]frame])/2];
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
