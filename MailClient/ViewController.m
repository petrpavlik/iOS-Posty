//
//  ViewController.m
//  MailClient
//
//  Created by Petr Pavlik on 19/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "ViewController.h"
#import "ThreadsTableViewController.h"
#import "NavigationController.h"

@interface ViewController ()

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Go" forState:UIControlStateNormal];
    button.frame = CGRectMake(20, 20, 100, 44);
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonTapped {
    
    ThreadsTableViewController* controller = [[ThreadsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController* navController = [[NavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navController animated:YES completion:nil];
}

@end
