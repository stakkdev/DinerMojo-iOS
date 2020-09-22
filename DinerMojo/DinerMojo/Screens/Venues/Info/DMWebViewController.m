//
//  DMWebViewController.m
//  DinerMojo
//
//  Created by Carl Sanders on 10/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMWebViewController.h"


@interface DMWebViewController ()

@end

@implementation DMWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.webURL;
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[self webURL]]];
    [[self restaurantWebView] loadRequest:urlRequest];
    [self.restaurantWebView setNavigationDelegate:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    __weak DMWebViewController *weakSelf = self;
    [self.restaurantWebView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if ([result isKindOfClass: [NSString class]]) {
            weakSelf.navigationItem.title = (NSString *)result;
        }
    }];
}

- (IBAction)closeDMWebView:(id)sender {
    [self.delegate didDismissViewController];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
@end
