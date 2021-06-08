//
//  DMProfileInfoViewController.m
//  DinerMojo
//
//  Created by Robert Sammons on 11/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMProfileInfoViewController.h"

@interface DMProfileInfoViewController ()

@end

@implementation DMProfileInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *dismissGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.view addGestureRecognizer:dismissGesture];
    
    [self.mojoView.layer setCornerRadius: 15.0f];
    [self.platinumView setBackgroundColor:[UIColor platinumMainColor]];
    [self.goldView setBackgroundColor:[UIColor goldMainColor]];
    [self.silverView setBackgroundColor:[UIColor silverMainColor]];
    [self.blueView setBackgroundColor:[UIColor blueMainColor]];

}

- (IBAction)handleGesture:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
