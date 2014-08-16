//
//  WebViewController.m
//  MailClient
//
//  Created by Petr Pavlik on 04/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController () <WKNavigationDelegate>

@property(nonatomic, strong) WKWebView* webView;

@end

@implementation WebViewController

- (void)dealloc {
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _webView.navigationDelegate = self;
    _webView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:_webView];
    
    UIBarButtonItem* shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-upload"] style:UIBarButtonItemStylePlain target:self action:@selector(bookmarksSelected)];
    
    UIBarButtonItem* refreshButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(reloadSelected)];
    
    self.navigationItem.rightBarButtonItems = @[shareButton, refreshButton];
    
    self.title = @"Loading...";
    
    if (self.url) {
        NSURLRequest* request = [NSURLRequest requestWithURL:self.url];
        [self.webView loadRequest:request];
    }
}

#pragma mark -

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    self.navigationController.interactivePopGestureRecognizer.enabled = !webView.canGoBack;
    
    self.title = @"Loading...";
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    self.title = webView.title;
}

#pragma mark -

- (void)reloadSelected {
    
    [self.webView reload];
}

- (void)bookmarksSelected {
    
    UIActivityViewController* activityController = [[UIActivityViewController alloc] initWithActivityItems:@[_webView.URL] applicationActivities:nil];
    
    [self presentViewController:activityController animated:YES completion:nil];
}

#pragma mark -

+ (void)presentWithURL:(NSURL*)url fromViewController:(UIViewController*)controller {
    
    
}

@end
