//
//  DMTabBarController.m
//  DinerMojo
//
//  Created by Robert Sammons on 23/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMTabBarController.h"

@interface DMTabBarController ()

@end

@implementation DMTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
     
    if (@available(iOS 15.0, *))
    {
        UITabBarAppearance *tabBarAppearence = [[UITabBarAppearance alloc] init];
        [tabBarAppearence configureWithOpaqueBackground];
        tabBarAppearence.backgroundColor = [UIColor whiteColor];
        self.tabBar.standardAppearance = tabBarAppearence;
        self.tabBar.scrollEdgeAppearance = tabBarAppearence;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
