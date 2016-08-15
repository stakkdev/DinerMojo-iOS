//
//  DMLandingViewController.m
//  DinerMojo
//
//  Created by Carl Sanders on 01/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMLandingViewController.h"
#import "DMStartViewController.h"

@interface DMLandingViewController ()

@end

@implementation DMLandingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self determineAppStart];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)determineAppStart
{
    if ([[self userRequest] isUserLoggedIn] == YES || [[self userRequest] hasUserSkipped] == YES)
    {
        [self goToVenues];
    }
    
    else
    {
        [self goToLandingPage];
    }
}

@end
