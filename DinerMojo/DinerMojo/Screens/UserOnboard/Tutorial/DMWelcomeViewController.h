//
//  DMWelcomeViewController.h
//  DinerMojo
//
//  Created by Carl Sanders on 01/05/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMViewController.h"
#import "DMPageControl.h"

typedef NS_ENUM(NSInteger, DMWelcomeViewControllerPresentationStyle) {
    DMWelcomeViewControllerPresentationStyleFromStartup = 0,
    DMWelcomeViewControllerPresentationStyleFromPopup = 1,
};

@class DMWelcomeViewController;

@protocol DMWelcomeViewControllerDelegate <NSObject>

@optional

- (void)closeButtonPressedWelcomeViewController:(DMWelcomeViewController *)welcomeViewController;

@end

@interface DMWelcomeViewController : DMViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *greenView;
@property (weak, nonatomic) IBOutlet DMButton *skipButton;
@property (weak, nonatomic) IBOutlet DMButton *getStartedButton;
@property (weak, nonatomic) IBOutlet DMPageControl *pageControl;
@property DMWelcomeViewControllerPresentationStyle welcomeViewControllerPresentationStyle;
@property (weak, nonatomic) id<DMWelcomeViewControllerDelegate> delegate;


- (IBAction)skipPressed:(id)sender;
- (IBAction)getStarted:(UIButton *)sender;


@end
