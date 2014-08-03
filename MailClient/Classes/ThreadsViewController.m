//
//  ThreadsViewController.m
//  MailClient
//
//  Created by Petr Pavlik on 02/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "ThreadsViewController.h"
#import "ThreadsTableViewController.h"
#import "ComposeMessageViewController.h"
#import "TagsTableViewController.h"
#import "NavigationController.h"
#import <Inbox.h>

@interface ThreadsViewController ()

@property(nonatomic, strong) ThreadsTableViewController* threadsTableViewController;
@property(nonatomic, strong) INThreadProvider* threadProvider;

@end

@implementation ThreadsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Inbox";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeEmailSelected)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tags" style:UIBarButtonItemStylePlain target:self action:@selector(testSelected)];
}

#pragma mark -

- (void)composeEmailSelected {
    
    ComposeMessageViewController* controller = [[ComposeMessageViewController alloc] init];
    NavigationController* navigationController = [[NavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)testSelected {
    
    TagsTableViewController* controller = [[TagsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    controller.delegate = self;
    
    NavigationController* navigationController = [[NavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}


@end
