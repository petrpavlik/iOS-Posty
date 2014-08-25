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
@property(nonatomic, strong) UIView* loadingIndicator;

@end

@implementation WebViewController

- (void)dealloc {
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress" context:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SkinProvider* skin = [SkinProvider sharedInstance];
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _webView.navigationDelegate = self;
    _webView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:_webView];
    
    _loadingIndicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 2)];
    _loadingIndicator.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _loadingIndicator.backgroundColor = skin.tintColor;
    [self.view addSubview:_loadingIndicator];
    
    UIBarButtonItem* shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-upload"] style:UIBarButtonItemStylePlain target:self action:@selector(bookmarksSelected)];
    
    UIBarButtonItem* refreshButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(reloadSelected)];
    
    self.navigationItem.rightBarButtonItems = @[shareButton, refreshButton];
    
    self.title = @"Loading...";
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:(NSKeyValueObservingOptionNew) context:nil];
    
    if (self.url) {
        NSURLRequest* request = [NSURLRequest requestWithURL:self.url];
        [self.webView loadRequest:request];
    }
}

#pragma mark -

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.loadingIndicator.frame = CGRectMake(0, 0, self.view.bounds.size.width*0.05, 2);
    }];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = !webView.canGoBack;
    
    self.title = @"Loading...";
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    self.title = webView.title;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    self.loadingIndicator.frame = CGRectMake(0, 0, 0, 2);
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

#pragma mark -

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (self.webView.estimatedProgress == 1.0) {
        self.loadingIndicator.frame = CGRectMake(0, 0, 0, 2);
    }
    else if (self.webView.estimatedProgress > 0.05) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.loadingIndicator.frame = CGRectMake(0, 0, self.view.bounds.size.width*self.webView.estimatedProgress, 2);
        }];
    }
}

@end
