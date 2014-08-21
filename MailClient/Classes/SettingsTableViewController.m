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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editSelected)];
    
    [self.tableView registerClass:[TitleValueTableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    SkinProvider* skin = [SkinProvider sharedInstance];
    self.tableView.backgroundColor = skin.cellBackgroundColor;
    self.tableView.separatorColor = skin.cellSeparatorColor;
    
    UIButton* signOutButton = [UIButton buttonWithType:UIButtonTypeSystem];
    signOutButton.tintColor = [UIColor redColor];
    signOutButton.frame = CGRectMake(0, 0, 320, 44);
    [signOutButton setTitle:@"Sign Out" forState:UIControlStateNormal];
    
    [signOutButton addTarget:self action:@selector(signOutRequested) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = signOutButton;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==0) {
        return 1;
    }
    else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    SkinProvider* skin = [SkinProvider sharedInstance];
    
    cell.textLabel.textColor = skin.headerTextColor;
    cell.detailTextLabel.textColor = skin.textColor;
    
    if (indexPath.section == 0) {
        
        // Configure the cell...
        cell.textLabel.text = [INAPIManager shared].namespaceEmailAddresses[0];
        
        cell.detailTextLabel.text = nil;
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;

    }
    else {
        
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

    }
    
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section==0) {
        return @"Inboxes";
    }
    else {
        return @"Settings";
    }
    
    return nil;
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

#pragma mark -

- (void)editSelected {
    
}

@end
