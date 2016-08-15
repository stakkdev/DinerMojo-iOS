//
//  DMWebViewController.h
//  DinerMojo
//
//  Created by Carl Sanders on 10/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMWebViewController : UIViewController <UIWebViewDelegate>


@property (weak, nonatomic) IBOutlet UIWebView *restaurantWebView;
@property (nonatomic, strong) NSString *webURL;

- (IBAction)closeDMWebView:(id)sender;

@end
