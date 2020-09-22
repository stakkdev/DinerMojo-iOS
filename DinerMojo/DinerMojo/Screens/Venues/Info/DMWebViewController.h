//
//  DMWebViewController.h
//  DinerMojo
//
//  Created by Carl Sanders on 10/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DMWebViewControllerDelegate
- (void)didDismissViewController;
@end

@interface DMWebViewController : UIViewController <WKNavigationDelegate>


@property (weak, nonatomic) IBOutlet WKWebView *restaurantWebView;
@property (nonatomic, strong) NSString *webURL;
@property (nonatomic, weak) id <DMWebViewControllerDelegate> delegate;
    
- (IBAction)closeDMWebView:(id)sender;

@end
