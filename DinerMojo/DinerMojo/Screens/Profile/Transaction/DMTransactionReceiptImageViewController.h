//
//  DMTransacationReceiptimageViewController.h
//  DinerMojo
//
//  Created by Robert Sammons on 22/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMTransactionReceiptImageViewController : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImage *image;
- (IBAction)closeImage:(id)sender;

@end
