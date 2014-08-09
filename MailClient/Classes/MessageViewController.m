//
//  MailViewController.m
//  MailClient
//
//  Created by Petr Pavlik on 20/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "MessageViewController.h"
#import <WebKit/WebKit.h>
#import <Inbox.h>
#import "MessageHeaderView.h"
#import "ComposeMessageViewController.h"
#import "NavigationController.h"
#import "DateFormatter.h"
#import "WebViewController.h"

#import "MessageHeaderView+InboxKit.h"
#import "UIWebView+InboxKit.h"

@interface MessageViewController () <TTTAttributedLabelDelegate, UIWebViewDelegate>

@property(nonatomic, strong) UIWebView* webView;
@property(nonatomic, strong) MessageHeaderView* headerView;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-menu"] style:UIBarButtonItemStylePlain target:self action:@selector(moreSelected)],
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-trash"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteSelected)],
                                                [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-star"] style:UIBarButtonItemStylePlain target:self action:@selector(starSelected)],
                                                [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-reply-all"] style:UIBarButtonItemStylePlain target:self action:@selector(replyAllSelected)]];
    
    NSParameterAssert(_message);
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    _webView.scrollView.contentInset = UIEdgeInsetsMake(106, 0, 0, 0);
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    
    MessageHeaderView* headerView = [MessageHeaderView new];
    headerView.frame = CGRectMake(0, 0, 320, 88);
    [_webView addSubview:headerView];
    _headerView = headerView;
    _headerView.fromLabel.delegate = self;
    
    if (_message) {
        [self displayMessage:_message];
    }
    else {
        
        NSParameterAssert(_messageId.length);
        
        INNamespace * namespace = [[[INAPIManager shared] namespaces] firstObject];
        _message = [INMessage instanceWithID:_messageId inNamespaceID:namespace.namespaceID];
        [_message reload:^(BOOL success, NSError *error) {
           
            if (success) {
                [self displayMessage:_message];
            }
            else {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Could not fetch a message" message:error.description preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
    
}

#pragma mark -

- (void)moreSelected {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Reply to Lucy" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Forward Message" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Flag Message" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Mark as Unread" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    
    SkinProvider* skin = [SkinProvider sharedInstance];
    
    alert.view.tintColor = skin.tintColor;
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)deleteSelected {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)replyAllSelected {
    
    NSParameterAssert(_message); //TODO: make sure it's also loaded
    
    ComposeMessageViewController* controller = [[ComposeMessageViewController alloc] init];
    controller.messageToReplyTo = _message;
    
    NavigationController* navigationController = [[NavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)starSelected {
    
    [self.message.thread star];
}

#pragma mark -

- (void)displayMessage:(INMessage*)message {
    
    [self.headerView setupWithMessage:message];
    
    [self.webView setupWithMessage:message];
}

#pragma mark -

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    NSString* email = [url.description stringByReplacingOccurrencesOfString:@"mailto:" withString:@""];
    
    NSLog(@"%@", email);
    
    NSParameterAssert(_message); //TODO: make sure it's also loaded
    
    ComposeMessageViewController* controller = [[ComposeMessageViewController alloc] init];
    
    NavigationController* navigationController = [[NavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark -

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ((navigationType == UIWebViewNavigationTypeOther) || (navigationType == UIWebViewNavigationTypeReload)) {
        return YES;
    }
    
    WebViewController* controller = [[WebViewController alloc] init];
    controller.url = request.URL;
    
    [self.navigationController  pushViewController:controller animated:YES];
    
    return NO;
}

@end
