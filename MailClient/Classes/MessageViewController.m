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

@interface MessageViewController ()

@property(nonatomic, strong) UIWebView* webView;
@property(nonatomic, strong) MessageHeaderView* headerView;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreSelected)],
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-delete"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteSelected)],
                                                [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-reply-all"] style:UIBarButtonItemStylePlain target:self action:@selector(replyAllSelected)]];
    
    NSParameterAssert(_message);
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    _webView.scrollView.contentInset = UIEdgeInsetsMake(88, 0, 0, 0);
    [self.view addSubview:_webView];
    
    
    MessageHeaderView* headerView = [MessageHeaderView new];
    headerView.frame = CGRectMake(0, 0, 320, 88);
    [_webView addSubview:headerView];
    _headerView = headerView;
    
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
    
}

- (void)replyAllSelected {
    
    NSParameterAssert(_message); //TODO: make sure it's also loaded
    
    ComposeMessageViewController* controller = [[ComposeMessageViewController alloc] init];
    controller.messageToReplyTo = _message;
    
    NavigationController* navigationController = [[NavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark -

- (void)displayMessage:(INMessage*)message {
    
    if (_message.subject.length) {
        _headerView.subjectLabel.text = _message.subject;
    }
    else {
        _headerView.subjectLabel.text = @"No subject";
    }
    
    NSString* from = @"From: ";
    for (NSDictionary* fromDictionary in _message.from) {
        
        if ([fromDictionary[@"name"] length]) {
            from = [from stringByAppendingString:fromDictionary[@"name"]];
        }
        else {
            from = [from stringByAppendingString:fromDictionary[@"email"]];
        }
    }
    _headerView.fromLabel.text = from;
    
    NSString* to = @"To: ";
    for (NSDictionary* toDictionary in _message.to) {
        
        if ([toDictionary[@"name"] length]) {
            to = [to stringByAppendingString:toDictionary[@"name"]];
        }
        else {
            to = [to stringByAppendingString:toDictionary[@"email"]];
        }
    }
    _headerView.toLabel.text = to;
    
    
    if ([_message.body containsString:@"<head"]) {
        
        [_webView loadHTMLString:_message.body baseURL:nil];
    }
    else {
        
        NSString* templatePath = [[NSBundle mainBundle] pathForResource:@"SimpleMailTemplate" ofType:@"html"];
        NSString* content = [[NSString alloc] initWithData:[[NSFileManager defaultManager] contentsAtPath:templatePath] encoding:NSUTF8StringEncoding];
        
        content = [content stringByReplacingOccurrencesOfString:@"%@" withString:_message.body];
        
        [_webView loadHTMLString:content baseURL:nil];
    }
}

@end
