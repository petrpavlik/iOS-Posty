//
//  LoginViewController.m
//  MailClient
//
//  Created by Petr Pavlik on 06/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "ThreadsTableViewController.h"
#import "NavigationController.h"

@import CloudKit;

@interface LoginViewController ()

@property(nonatomic, strong) UILabel* infoLabel;
@property(nonatomic, strong) UIActivityIndicatorView* activityIndicator;
@property(nonatomic, strong) UIButton* retryButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (![PFUser currentUser]) {
        [self performLogin];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([PFUser currentUser]) {
        [self displayThreadsAnimated:NO];
    }
}

- (void)loadView {
    [super loadView];
    
    UIView* wrapperView = [UIView new];
    wrapperView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:wrapperView];
    
    _infoLabel = [[UILabel alloc] init];
    _infoLabel.text = @"blah";
    _infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    _infoLabel.numberOfLines = 0;
    _infoLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [wrapperView addSubview:_infoLabel];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [_activityIndicator startAnimating];
    [wrapperView addSubview:_activityIndicator];
    
    _retryButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _retryButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_retryButton addTarget:self action:@selector(retrySelected) forControlEvents:UIControlEventTouchUpInside];
    [_retryButton setTitle:@"Retry" forState:UIControlStateNormal];
    [wrapperView addSubview:_retryButton];
    
    NSDictionary* bindings = NSDictionaryOfVariableBindings(_infoLabel, _activityIndicator, _retryButton, wrapperView);
    
    [wrapperView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_infoLabel]|" options:0 metrics:nil views:bindings]];
    [wrapperView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_retryButton(>=44)]" options:0 metrics:nil views:bindings]];
    [wrapperView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_infoLabel]-[_retryButton(>=44)]|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:bindings]];
    
    [wrapperView addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_retryButton attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [wrapperView addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_retryButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[wrapperView]-|" options:0 metrics:nil views:bindings]];
    //[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[wrapperView(>=10)]-|" options:0 metrics:nil views:bindings]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:wrapperView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

#pragma mark -

- (void)performLogin {
    
    NSLog(@"%@", [PFUser currentUser]);
    
    self.infoLabel.text = @"Loading your account";
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    self.retryButton.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    [[CKContainer defaultContainer] fetchUserRecordIDWithCompletionHandler:^(CKRecordID *recordID, NSError *error) {
        
        if (error) {
            
            weakSelf.infoLabel.text = error.localizedDescription;
            weakSelf.activityIndicator.hidden = YES;
            weakSelf.retryButton.hidden = NO;
        }
        else {
            
            NSLog(@"%@ %@", recordID.recordName, recordID.zoneID);
            
            [PFUser logInWithUsernameInBackground:recordID.recordName password:@"test" block:^(PFUser *user, NSError *error) {
                
                if (error) {
                    
                    if (error.code == 101) { //invalid credentials
                        
                        PFUser *user = [PFUser user];
                        user.username = recordID.recordName;
                        user.password = @"test";
                        
                        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            
                            if (error) {
                                
                                weakSelf.infoLabel.text = error.localizedDescription;
                                weakSelf.activityIndicator.hidden = YES;
                                weakSelf.retryButton.hidden = NO;
                                
                            } else {
                                
                                [weakSelf displayThreadsAnimated:YES];
                            }
                        }];
                    }
                    else {
                        
                        weakSelf.infoLabel.text = error.localizedDescription;
                        weakSelf.activityIndicator.hidden = YES;
                        weakSelf.retryButton.hidden = NO;
                    }
                }
                else {
                    
                    [weakSelf displayThreadsAnimated:YES];
                }
            }];
        }
    }];
}

#pragma mark -

- (void)retrySelected {
    
    [self performLogin];
}

#pragma mark -

- (void)displayThreadsAnimated:(BOOL)animated {
    
    ThreadsTableViewController* controller = [[ThreadsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController* navController = [[NavigationController alloc] initWithRootViewController:controller];
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:navController animated:animated completion:nil];

}

@end
