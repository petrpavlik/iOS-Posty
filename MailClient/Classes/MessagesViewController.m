//
//  MessagesViewController.m
//  MailClient
//
//  Created by Petr Pavlik on 17/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "MessagesViewController.h"
#import <Inbox.h>
#import "MessageViewController.h"
#import "WebViewController.h"
#import "ComposeMessageViewController.h"
#import "NavigationController.h"
#import "MessagesTableViewController.h"


@interface MessagesViewController () <MessagesTableViewControllerDelegate>

@property(nonatomic, strong) INMessageProvider* messageProvider;
@property(nonatomic, strong) MessagesTableViewController* tableViewController;
@property(nonatomic, strong) UIActivityIndicatorView* activityIndicator;

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-menu"] style:UIBarButtonItemStylePlain target:self action:@selector(moreSelected)],
                                                [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-trash"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteSelected)],
                                                [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-star"] style:UIBarButtonItemStylePlain target:self action:@selector(starSelected)],
                                                [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-reply-all"] style:UIBarButtonItemStylePlain target:self action:@selector(replyAllSelected)]];
    
    
    _messageProvider = [[INMessageProvider alloc] initForMessagesInThread:_thread.ID andNamespaceID:_namespaceId];
    _messageProvider.itemSortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    _tableViewController = [[MessagesTableViewController alloc] initWithStyle:UITableViewStylePlain];
    _tableViewController.messageProvider = _messageProvider;
    _tableViewController.delegate = self;
    
    _messageProvider.delegate = _tableViewController;
    
    [self addChildViewController:_tableViewController];
    
    CGRect frame = self.view.bounds;
    frame.origin.y += frame.size.height;
    
    _tableViewController.view.frame = frame;
    _tableViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tableViewController.view];
    
    [_tableViewController didMoveToParentViewController:self];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_activityIndicator startAnimating];
    _activityIndicator.hidesWhenStopped = NO;
    _activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_activityIndicator];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_activityIndicator]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_activityIndicator)]];
    
    [self.thread markAsRead];
    
    [_messageProvider refresh];
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
    
    [self.thread archive];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)replyAllSelected {
    
    INMessage * message = [[self.messageProvider items] objectAtIndex: 0];
    
    ComposeMessageViewController* controller = [[ComposeMessageViewController alloc] init];
    controller.messageToReplyTo = message;
    
    NavigationController* navigationController = [[NavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark -

- (void)messagesTableViewControllerDidCompleteDataFetch:(MessagesTableViewController *)controller {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _activityIndicator.alpha = 0;
        _tableViewController.view.frame = self.view.bounds;
    } completion:^(BOOL finished) {
        _activityIndicator.hidden = YES;
        _activityIndicator.alpha = 1;
    }];
}

- (void)messagesTableViewController:(MessagesTableViewController *)controller dataFetchDidFailWithError:(NSError *)error {
    
    [[[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}


@end
