//
//  AppleNewsDetailedController.m
//  RSS Reader
//
//  Created by Evgeniy Raylyan on 7/21/15.
//  Copyright (c) 2015 Evgeniy Raylyan. All rights reserved.
//

#import "AppleNewsDetailedController.h"
#import "AppleNewsItem.h"

@interface AppleNewsDetailedController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AppleNewsDetailedController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:self.item.link];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.webView.delegate = self;
    [self.webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *html = [webView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
    NSLog(@"%@", html);
}

@end
