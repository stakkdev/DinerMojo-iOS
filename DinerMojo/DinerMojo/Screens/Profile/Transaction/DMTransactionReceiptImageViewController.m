//
//  DMTransacationReceiptimageViewController.m
//  DinerMojo
//
//  Created by Robert Sammons on 22/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMTransactionReceiptImageViewController.h"

@interface DMTransactionReceiptImageViewController ()

@end

@implementation DMTransactionReceiptImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.imageView setImage:self.image];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeImage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
