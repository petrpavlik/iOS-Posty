//
//  SettingsTableViewController.m
//  MailClient
//
//  Created by Petr Pavlik on 06/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "SettingsTableViewController.h"
#import <Inbox.h>
#import "TitleValueTableViewCell.h"
#import "SignatureViewController.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Settings";
    
    [self.tableView registerClass:[TitleValueTableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    UIButton* signOutButton = [UIButton buttonWithType:UIButtonTypeSystem];
    signOutButton.frame = CGRectMake(0, 0, 320, 44);
    [signOutButton setTitle:@"Sign Out" forState:UIControlStateNormal];
    
    [signOutButton addTarget:self action:@selector(signOutRequested) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = signOutButton;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = @"Signature";
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* htmlSignature = [userDefaults stringForKey:MailSignatureKey];
    
    NSAttributedString* signarute = [[NSAttributedString alloc] initWithData:[htmlSignature dataUsingEncoding:NSUTF8StringEncoding]
                                                                     options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                               NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                          documentAttributes:nil error:nil];
    
    NSString* plaintextSignature = [signarute.string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    cell.detailTextLabel.text = plaintextSignature;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SignatureViewController* controller = [SignatureViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -

- (void)signOutRequested {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Do you wish to sign out?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Sign Out" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[INAPIManager shared] unauthenticate];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
